package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.Dispatchers
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
                    Log.d(TAG, "Sent to ${node.displayName}: $path → ${payload.optString("type")}")
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
     */
    suspend fun flushBuffer() = withContext(Dispatchers.IO) {
        val buffer = readBuffer()
        if (buffer.length() == 0) {
            Log.d(TAG, "Buffer empty, nothing to flush")
            return@withContext
        }

        Log.d(TAG, "Flushing ${buffer.length()} buffered events")

        try {
            val nodes = nodeClient.connectedNodes.await()
            if (nodes.isEmpty()) {
                Log.d(TAG, "Still no phone — keeping buffer")
                return@withContext
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
                    return@withContext
                }
            }

            // All flushed — clear buffer
            clearBuffer()
            Log.d(TAG, "Buffer fully flushed: $flushed events sent")
        } catch (e: Exception) {
            Log.e(TAG, "Flush failed", e)
        }
    }

    /**
     * Get count of pending (unbuffered) events.
     */
    fun getPendingCount(): Int {
        return readBuffer().length()
    }

    // ── Buffer management ──

    private fun bufferEvent(path: String, payload: JSONObject) {
        try {
            val buffer = readBuffer()
            val event = JSONObject(payload.toString()) // Clone
            event.put("_path", path)
            buffer.put(event)

            // Cap buffer size
            val trimmed = if (buffer.length() > MAX_BUFFER_SIZE) {
                val newBuffer = JSONArray()
                for (i in buffer.length() - MAX_BUFFER_SIZE until buffer.length()) {
                    newBuffer.put(buffer.getJSONObject(i))
                }
                newBuffer
            } else {
                buffer
            }

            writeBuffer(trimmed)
            Log.d(TAG, "Buffered event (total: ${trimmed.length()})")
        } catch (e: Exception) {
            Log.e(TAG, "Buffer write failed", e)
        }
    }

    private fun readBuffer(): JSONArray {
        return try {
            if (bufferFile.exists()) {
                JSONArray(bufferFile.readText())
            } else {
                JSONArray()
            }
        } catch (e: Exception) {
            JSONArray()
        }
    }

    private fun writeBuffer(buffer: JSONArray) {
        bufferFile.writeText(buffer.toString())
    }

    private fun clearBuffer() {
        if (bufferFile.exists()) {
            bufferFile.delete()
        }
    }
}
