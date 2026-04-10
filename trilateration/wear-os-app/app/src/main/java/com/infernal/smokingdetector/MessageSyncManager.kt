package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * MessageClient Sync Manager — watch → phone via Bluetooth
 *
 * Strategy:
 * 1. On detection: try to send via MessageClient immediately
 * 2. If phone unreachable: buffer to local JSON file
 * 3. On reconnect (NodeClient listener): flush buffer automatically
 * 4. Watch keeps minimal data (just today's counter in memory + buffer)
 *
 * MessageClient advantages over DataClient:
 * - Works cross-package (no applicationId matching needed)
 * - Bluetooth direct (no WiFi needed)
 * - Fire-and-forget (no storage on Wear Data Layer)
 * - Works via cloud relay if BT disconnected but internet available
 */
class MessageSyncManager(private val context: Context) {

    companion object {
        private const val TAG = "MessageSyncManager"
        private const val BUFFER_FILE = "pending_sync.json"
        private const val MSG_PATH_DETECTION = "/detection"
        private const val MSG_PATH_DRINK = "/drink"
        private const val MSG_PATH_TRAINING_WINDOW = "/training_window"
        private const val MAX_BUFFER_SIZE = 500 // Max buffered events before oldest are dropped
    }

    private val messageClient: MessageClient = Wearable.getMessageClient(context)
    private val nodeClient: NodeClient = Wearable.getNodeClient(context)
    private val bufferFile = File(context.filesDir, BUFFER_FILE)

    // Single mutex protecting all buffer file I/O. Without it, concurrent
    // bufferEvent + flushBuffer could lose events: thread A reads (10 events),
    // thread B reads (10 events) + adds (11) + writes (11), thread A writes
    // back its outdated 10 → the 11th event is lost.
    private val bufferMutex = Mutex()

    /**
     * Send a cigarette detection to the phone.
     * If phone is unreachable, buffers locally for later.
     */
    suspend fun sendCigarette(
        timestamp: Long = System.currentTimeMillis(),
        confidence: Float = 1.0f,
        gpsCluster: Int = -1,
        hrBaseline: Float = 0f,
        hrCurrent: Float = 0f
    ) {
        val payload = JSONObject().apply {
            put("type", "cigarette")
            put("timestamp", timestamp)
            put("confidence", confidence)
            put("gpsCluster", gpsCluster)
            put("hrBaseline", hrBaseline)
            put("hrCurrent", hrCurrent)
            put("hrDelta", hrCurrent - hrBaseline)
        }
        sendOrBuffer(MSG_PATH_DETECTION, payload)
    }

    /**
     * Send a drink detection to the phone.
     * drinkType: "beer", "wine", "strong"
     */
    suspend fun sendDrink(
        drinkType: String,
        timestamp: Long = System.currentTimeMillis(),
        confidence: Float = 1.0f,
        gpsCluster: Int = -1,
        hrBaseline: Float = 0f,
        hrCurrent: Float = 0f
    ) {
        val payload = JSONObject().apply {
            put("type", "drink")
            put("drinkType", drinkType)
            put("timestamp", timestamp)
            put("confidence", confidence)
            put("gpsCluster", gpsCluster)
            put("hrBaseline", hrBaseline)
            put("hrCurrent", hrCurrent)
            put("hrDelta", hrCurrent - hrBaseline)
        }
        sendOrBuffer(MSG_PATH_DRINK, payload)
    }

    /**
     * Send a 25Hz training window snapshot to the phone.
     *
     * The window is the most recent ~8 seconds of accelerometer data captured
     * around a detection event (auto or manual). The phone persists it as
     * ground-truth labelled data for future per-user CNN fine-tuning.
     *
     * The watch never persists training data long-term — if the phone is
     * unreachable, the window is buffered (capped) and flushed on reconnect.
     *
     * @param accel       [N][3] accelerometer in m/s² (typically N=200, ~8s @ 25Hz)
     * @param label       Source: "auto_detected", "manual_only", "auto_confirmed_by_manual"
     * @param confidence  CNN cigarette probability at the moment of detection
     * @param timestamp   Unix ms of the detection event
     */
    suspend fun sendTrainingWindow(
        accel: Array<FloatArray>,
        label: String,
        confidence: Float,
        timestamp: Long = System.currentTimeMillis()
    ) {
        if (accel.isEmpty()) {
            Log.w(TAG, "sendTrainingWindow called with empty accel — skipping")
            return
        }

        // GorillaCompressor needs accel + gyro (6 channels). We don't have gyro
        // from Samsung's ACCELEROMETER_CONTINUOUS, so pad with zeros — they
        // compress to almost nothing thanks to the delta+gzip pipeline.
        val zeroGyro = Array(accel.size) { FloatArray(3) }
        val compressed = GorillaCompressor.compress(accel, zeroGyro)

        val payload = JSONObject().apply {
            put("type", "training_window")
            put("label", label)
            put("confidence", confidence)
            put("timestamp", timestamp)
            put("sampleCount", accel.size)
            put("sampleRate", 25)
            put("compressed", compressed)
        }

        Log.d(TAG, "sendTrainingWindow: label=$label samples=${accel.size} compressed=${compressed.length} chars")
        sendOrBuffer(MSG_PATH_TRAINING_WINDOW, payload)
    }

    /**
     * Try to send message to phone. If no connected node, buffer locally.
     */
    private suspend fun sendOrBuffer(path: String, payload: JSONObject) = withContext(Dispatchers.IO) {
        try {
            val nodes = nodeClient.connectedNodes.await()
            if (nodes.isEmpty()) {
                Log.d(TAG, "No connected phone — buffering event")
                bufferEvent(path, payload)
                return@withContext
            }

            // Send to all connected nodes (usually just 1 phone)
            var sent = false
            for (node in nodes) {
                try {
                    messageClient.sendMessage(
                        node.id,
                        path,
                        payload.toString().toByteArray()
                    ).await()
                    sent = true
                    Log.d(TAG, "Sent to ${node.displayName}: $path -> ${payload.optString("type")}")
                } catch (e: Exception) {
                    Log.w(TAG, "Failed to send to ${node.displayName}", e)
                }
            }

            if (!sent) {
                Log.d(TAG, "All sends failed — buffering event")
                bufferEvent(path, payload)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Send error — buffering event", e)
            bufferEvent(path, payload)
        }
    }

    /**
     * Flush all buffered events to the phone.
     * Called when phone reconnects (from NodeClient listener or manually).
     *
     * Hold the bufferMutex for the ENTIRE flush so concurrent bufferEvent
     * calls cannot interleave with our read-modify-write of the buffer file.
     * The lock is sub-second on the happy path (one read + send + delete),
     * up to ~50s on the worst case (500 buffered events × 100ms each).
     * That's acceptable because new events still get queued by Kotlin's
     * Mutex and processed once the flush completes.
     */
    suspend fun flushBuffer() = withContext(Dispatchers.IO) {
        bufferMutex.withLock {
            val buffer = readBuffer()
            if (buffer.length() == 0) {
                Log.d(TAG, "Buffer empty, nothing to flush")
                return@withLock
            }

            Log.d(TAG, "Flushing ${buffer.length()} buffered events")

            try {
                val nodes = nodeClient.connectedNodes.await()
                if (nodes.isEmpty()) {
                    Log.d(TAG, "Still no phone — keeping buffer")
                    return@withLock
                }

                val node = nodes.first()
                var flushed = 0

                for (i in 0 until buffer.length()) {
                    try {
                        val event = buffer.getJSONObject(i)
                        val path = event.getString("_path")
                        event.remove("_path") // Don't send internal field

                        messageClient.sendMessage(
                            node.id,
                            path,
                            event.toString().toByteArray()
                        ).await()
                        flushed++
                    } catch (e: Exception) {
                        Log.w(TAG, "Flush failed for event $i", e)
                        // Keep remaining events in buffer
                        val remaining = JSONArray()
                        for (j in i until buffer.length()) {
                            remaining.put(buffer.getJSONObject(j))
                        }
                        writeBuffer(remaining)
                        Log.d(TAG, "Flushed $flushed, ${remaining.length()} remain")
                        return@withLock
                    }
                }

                // All flushed — clear buffer
                clearBuffer()
                Log.d(TAG, "Buffer fully flushed: $flushed events sent")
            } catch (e: Exception) {
                Log.e(TAG, "Flush failed", e)
            }
        }
    }

    /**
     * Get count of pending (unbuffered) events.
     */
    fun getPendingCount(): Int {
        return readBuffer().length()
    }

    // ── Buffer management ──

    /**
     * Buffer an event under the buffer mutex. Suspending so we can use the
     * Mutex (Kotlin's coroutine mutex doesn't have a non-suspending lock()).
     */
    private suspend fun bufferEvent(path: String, payload: JSONObject) {
        bufferMutex.withLock {
            try {
                val buffer = readBuffer()
                val event = JSONObject(payload.toString()) // Clone
                event.put("_path", path)
                buffer.put(event)

                // Cap buffer size with type-aware eviction.
                //
                // Old behavior: drop the OLDEST events FIFO. Bad because a
                // 500-event burst of training_window samples could evict
                // critical cigarette/drink detections that were waiting in
                // line for an hour.
                //
                // New behavior: drop training_window events first (they are
                // optional ground-truth, the user's count doesn't depend on
                // them). Only fall back to FIFO if there are no training
                // events to evict.
                val trimmed = if (buffer.length() > MAX_BUFFER_SIZE) {
                    trimBufferPreservingDetections(buffer)
                } else {
                    buffer
                }

                writeBuffer(trimmed)
                Log.d(TAG, "Buffered event (total: ${trimmed.length()})")
            } catch (e: Exception) {
                Log.e(TAG, "Buffer write failed", e)
            }
        }
    }

    /**
     * Drop events to bring the buffer back under MAX_BUFFER_SIZE.
     * Drops training_window events first (oldest first), then falls back
     * to FIFO over remaining events.
     *
     * Visible for unit testing.
     */
    internal fun trimBufferPreservingDetections(buffer: JSONArray): JSONArray {
        val needToDrop = buffer.length() - MAX_BUFFER_SIZE
        if (needToDrop <= 0) return buffer

        // Walk through and mark training_window events for eviction first.
        val keep = BooleanArray(buffer.length()) { true }
        var dropped = 0

        // Pass 1 — drop oldest training_window events
        var i = 0
        while (dropped < needToDrop && i < buffer.length()) {
            val event = buffer.optJSONObject(i)
            if (event != null && event.optString("type") == "training_window") {
                keep[i] = false
                dropped++
            }
            i++
        }

        // Pass 2 — if still over, drop oldest remaining events FIFO
        i = 0
        while (dropped < needToDrop && i < buffer.length()) {
            if (keep[i]) {
                keep[i] = false
                dropped++
            }
            i++
        }

        // Build the result preserving order
        val result = JSONArray()
        for (j in 0 until buffer.length()) {
            if (keep[j]) result.put(buffer.getJSONObject(j))
        }
        return result
    }

    private fun readBuffer(): JSONArray {
        return try {
            if (bufferFile.exists()) {
                val text = bufferFile.readText()
                if (text.isEmpty()) {
                    // Empty file is treated as empty buffer (e.g. truncated mid-write)
                    JSONArray()
                } else {
                    JSONArray(text)
                }
            } else {
                JSONArray()
            }
        } catch (e: Exception) {
            // File exists but is corrupt — log loudly so we know we lost data,
            // then return empty so the rest of the app keeps working.
            Log.e(TAG, "Buffer file exists but is corrupt — events lost", e)
            JSONArray()
        }
    }

    /**
     * Write the buffer atomically: write to a temp file then rename.
     * Without this, a crash mid-write could leave the buffer file truncated
     * (e.g. zero bytes), which readBuffer() would treat as "no events" — and
     * everything that was already buffered would be silently lost.
     */
    private fun writeBuffer(buffer: JSONArray) {
        val tmpFile = File(bufferFile.parentFile, "${bufferFile.name}.tmp")
        try {
            tmpFile.writeText(buffer.toString())
            // Rename is atomic on POSIX (and Android) — either the new file
            // is fully in place, or the old one is still there.
            if (!tmpFile.renameTo(bufferFile)) {
                // Fallback: rename failed (e.g. on Android FAT32 partition)
                // — write directly. Worst case we still get the old behavior.
                bufferFile.writeText(buffer.toString())
                tmpFile.delete()
            }
        } catch (e: Exception) {
            Log.e(TAG, "writeBuffer failed", e)
            tmpFile.delete()
        }
    }

    private fun clearBuffer() {
        if (bufferFile.exists()) {
            bufferFile.delete()
        }
    }
}
