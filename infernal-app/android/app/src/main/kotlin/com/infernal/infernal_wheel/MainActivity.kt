package com.infernal.infernal_wheel

import android.os.Bundle
import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.Wearable
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterFragmentActivity(), MessageClient.OnMessageReceivedListener {

    companion object {
        private const val TAG = "MainActivity"
        // Cap training windows on phone disk — FIFO eviction beyond this.
        // ~1 KB per file, so 1000 files ≈ 1 MB. Plenty for fine-tuning.
        private const val MAX_TRAINING_FILES = 1000
    }

    private val CHANNEL = "com.infernal.wheel/wear_sync"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Register as MessageClient listener directly (bypass manifest issues)
        Wearable.getMessageClient(this).addListener(this)
        Log.d(TAG, "MessageClient listener registered")
    }

    override fun onDestroy() {
        Wearable.getMessageClient(this).removeListener(this)
        FlutterEngineHolder.engine = null
        super.onDestroy()
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        val path = messageEvent.path
        val data = String(messageEvent.data)
        Log.d(TAG, "Watch message received: path=$path, size=${data.length}")

        // Training windows go to a separate handler — they're labelled raw
        // sensor windows used for per-user CNN fine-tuning. They are NOT
        // detection events, so they don't update counters or notify Flutter.
        if (path == "/training_window") {
            handleTrainingWindow(data)
            return
        }

        // Synchronize the entire detection write path. Multiple watch
        // messages can arrive in quick succession (e.g. backlog flush after
        // BT reconnect) and the read-modify-write of watch_detections.json
        // is racy without a lock.
        synchronized(detectionsLock) {
            try {
                val json = JSONObject(data)
                val type = json.optString("type", "cigarette")

                // Store detection
                val detection = JSONObject().apply {
                    put("timestamp", json.optLong("timestamp", System.currentTimeMillis()))
                    put("confidence", json.optDouble("confidence", 1.0))
                    put("type", type)
                    put("drinkType", json.optString("drinkType", ""))
                    put("gpsCluster", json.optInt("gpsCluster", -1))
                    put("hrBaseline", json.optDouble("hrBaseline", 0.0))
                    put("hrCurrent", json.optDouble("hrCurrent", 0.0))
                    put("hrDelta", json.optDouble("hrDelta", 0.0))
                    put("receivedAt", System.currentTimeMillis())
                }

                // Write to app_flutter dir so Dart can read it
                val flutterDir = java.io.File(filesDir.parentFile, "app_flutter")
                flutterDir.mkdirs()
                val file = if (type == "drink") {
                    java.io.File(flutterDir, "watch_drink_detections.json")
                } else {
                    java.io.File(flutterDir, "watch_detections.json")
                }

                // Read the existing array. If the file is corrupt, DO NOT
                // silently overwrite — that would erase the entire history
                // (potentially weeks of data) on a transient parse failure.
                // Instead, log the failure and skip this update; the next
                // successful read will preserve whatever's still there.
                val detections = if (file.exists()) {
                    try {
                        JSONArray(file.readText())
                    } catch (e: Exception) {
                        Log.e(TAG, "watch_detections.json is corrupt — skipping update to avoid data loss", e)
                        return@synchronized
                    }
                } else {
                    JSONArray()
                }
                detections.put(detection)
                writeJsonAtomic(file, detections.toString())

                // Update daily summary
                updateDailySummary(type)

                // Notify Flutter
                val engine = FlutterEngineHolder.engine
                if (engine != null) {
                    val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                    runOnUiThread {
                        channel.invokeMethod("onWatchDataChanged", null)
                    }
                }

                Log.d(TAG, "Watch $type stored + Flutter notified")
            } catch (e: Exception) {
                Log.e(TAG, "Error processing watch message", e)
            }
        }
    }

    /**
     * Lock object protecting all read-modify-write operations on the
     * watch_detections.json / watch_drink_detections.json files. The Wear OS
     * MessageClient callback can deliver messages on multiple threads in
     * rapid succession (especially during a buffer flush after a reconnect),
     * and without a lock the JSON file content races and we lose detections.
     */
    private val detectionsLock = Any()

    /**
     * Write `text` to `target` atomically: write to a sibling .tmp file then
     * rename. The rename is atomic on POSIX so the destination either has
     * the new content or the old one — never a half-written truncated file.
     * If the rename fails (e.g. on FAT32) we fall back to direct write.
     */
    private fun writeJsonAtomic(target: java.io.File, text: String) {
        val tmp = java.io.File(target.parentFile, "${target.name}.tmp")
        try {
            tmp.writeText(text)
            if (!tmp.renameTo(target)) {
                target.writeText(text)
                tmp.delete()
            }
        } catch (e: Exception) {
            Log.e(TAG, "writeJsonAtomic failed for ${target.name}", e)
            tmp.delete()
        }
    }

    /**
     * Receive a labelled 25Hz training window from the watch and persist it
     * to disk for later CNN fine-tuning.
     *
     * Storage layout:
     *   app_flutter/training_windows/
     *     2026-04-10T19-03-58_auto_detected_conf66.json
     *     2026-04-10T19-15-22_manual_only_conf100.json
     *     ...
     *
     * Each file contains:
     *   {
     *     "label": "auto_detected",
     *     "confidence": 0.66,
     *     "timestamp": 1775841838000,
     *     "sampleCount": 200,
     *     "sampleRate": 25,
     *     "compressed": "<base64 GorillaCompressor output>"
     *   }
     *
     * Disk cap is enforced at MAX_TRAINING_FILES — when exceeded, the oldest
     * files are deleted (FIFO). The watch should never see this — it just
     * keeps shipping windows and trusts the phone to manage storage.
     */
    private fun handleTrainingWindow(data: String) {
        synchronized(trainingLock) {
            try {
                val json = JSONObject(data)
                val label = json.optString("label", "unknown")
                val confidence = json.optDouble("confidence", 0.0)
                val timestamp = json.optLong("timestamp", System.currentTimeMillis())
                val sampleCount = json.optInt("sampleCount", 0)

                val flutterDir = java.io.File(filesDir.parentFile, "app_flutter")
                val trainingDir = java.io.File(flutterDir, "training_windows")
                trainingDir.mkdirs()

                // Cap storage — keep at most MAX_TRAINING_FILES files (FIFO).
                // Sort by FILENAME (which embeds the ISO timestamp and is
                // therefore monotonically increasing) instead of lastModified
                // — multiple files created in the same second have the same
                // mtime and would sort non-deterministically.
                val existing = trainingDir.listFiles { f -> f.isFile && f.name.endsWith(".json") }
                    ?.sortedBy { it.name }
                    ?: emptyList()
                if (existing.size >= MAX_TRAINING_FILES) {
                    val toDelete = existing.size - MAX_TRAINING_FILES + 1
                    for (i in 0 until toDelete) {
                        existing[i].delete()
                    }
                    Log.d(TAG, "[TRAINING] Pruned $toDelete oldest training file(s)")
                }

                // Build a unique, sortable filename. Two windows captured in
                // the same second would collide on `${isoTs}_${label}_conf${pct}`
                // — append the millisecond fraction to disambiguate.
                val isoTs = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH-mm-ss-SSS", java.util.Locale.US)
                    .format(java.util.Date(timestamp))
                val confPct = (confidence * 100).toInt()
                val filename = "${isoTs}_${label}_conf${confPct}.json"
                val file = java.io.File(trainingDir, filename)

                // Add a receivedAt field so we know when the phone got it
                json.put("receivedAt", System.currentTimeMillis())
                writeJsonAtomic(file, json.toString())

                Log.d(TAG, "[TRAINING] Saved window: $filename samples=$sampleCount")
            } catch (e: Exception) {
                Log.e(TAG, "[TRAINING] Failed to save training window", e)
            }
        }
    }

    /** Lock for the training_windows directory write path. */
    private val trainingLock = Any()

    private fun updateDailySummary(type: String) {
        // Caller (onMessageReceived) already holds detectionsLock when this
        // is invoked, so the read-modify-write below is safe against the
        // detection write path. Adding another nested synchronized would
        // be redundant.
        val flutterDir2 = java.io.File(filesDir.parentFile, "app_flutter")
        flutterDir2.mkdirs()
        val file = java.io.File(flutterDir2, "watch_daily_summary.json")
        val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
            .format(java.util.Date())

        // Read with corruption detection — if the summary is corrupt we
        // start a fresh one rather than crash. Counters are recoverable
        // by re-reading watch_detections.json on demand.
        val summary = if (file.exists()) {
            try {
                JSONObject(file.readText())
            } catch (e: Exception) {
                Log.w(TAG, "watch_daily_summary.json is corrupt — resetting", e)
                JSONObject()
            }
        } else {
            JSONObject()
        }

        if (summary.optString("date") != today) {
            summary.put("date", today)
            summary.put("cigaretteCount", 0)
            summary.put("drinkCount", 0)
            summary.put("totalDetections", 0)
        }

        if (type == "drink") {
            summary.put("drinkCount", summary.optInt("drinkCount", 0) + 1)
        } else {
            summary.put("cigaretteCount", summary.optInt("cigaretteCount", 0) + 1)
        }
        summary.put("totalDetections", summary.optInt("totalDetections", 0) + 1)
        summary.put("receivedAt", System.currentTimeMillis())
        writeJsonAtomic(file, summary.toString())
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FlutterEngineHolder.engine = flutterEngine

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getLatestSync" -> result.success(getLatestSync())
                    "getDailySummary" -> result.success(getDailySummary())
                    "getDetectionHistory" -> result.success(getDetectionHistory())
                    "getDrinkHistory" -> result.success(getDrinkHistory())
                    else -> result.notImplemented()
                }
            }
    }


    /**
     * Returns the most recent detection and summary as a combined map.
     */
    private fun getLatestSync(): Map<String, Any?> {
        val summary = readSummary()
        val detections = readDetections()

        val latestDetection = if (detections.length() > 0) {
            jsonObjectToMap(detections.getJSONObject(detections.length() - 1))
        } else {
            null
        }

        return mapOf(
            "summary" to summary?.let { jsonObjectToMap(it) },
            "latestDetection" to latestDetection,
            "totalDetections" to detections.length()
        )
    }

    /**
     * Returns today's daily summary from the watch.
     */
    private fun getDailySummary(): Map<String, Any?> {
        val summary = readSummary()
        return if (summary != null) {
            jsonObjectToMap(summary)
        } else {
            mapOf(
                "date" to "",
                "cigaretteCount" to 0,
                "drinkCount" to 0,
                "totalDetections" to 0,
                "receivedAt" to 0L
            )
        }
    }

    /**
     * Returns all synced detections as a list of maps.
     */
    private fun getDetectionHistory(): List<Map<String, Any?>> {
        val detections = readDetections()
        val result = mutableListOf<Map<String, Any?>>()
        for (i in 0 until detections.length()) {
            result.add(jsonObjectToMap(detections.getJSONObject(i)))
        }
        return result
    }

    private fun getDrinkHistory(): List<Map<String, Any?>> {
        val detections = readDrinkDetections()
        val result = mutableListOf<Map<String, Any?>>()
        for (i in 0 until detections.length()) {
            result.add(jsonObjectToMap(detections.getJSONObject(i)))
        }
        return result
    }

    private fun readDrinkDetections(): JSONArray {
        val file = WatchMessageReceiver.getDrinkDetectionsFile(this)
        return if (file.exists()) {
            try {
                JSONArray(file.readText())
            } catch (e: Exception) {
                JSONArray()
            }
        } else {
            JSONArray()
        }
    }

    private fun readDetections(): JSONArray {
        val file = WatchMessageReceiver.getDetectionsFile(this)
        return if (file.exists()) {
            try {
                JSONArray(file.readText())
            } catch (e: Exception) {
                JSONArray()
            }
        } else {
            JSONArray()
        }
    }

    private fun readSummary(): JSONObject? {
        val flutterDir2 = java.io.File(filesDir.parentFile, "app_flutter")
        flutterDir2.mkdirs()
        val file = java.io.File(flutterDir2, "watch_daily_summary.json")
        return if (file.exists()) {
            try {
                JSONObject(file.readText())
            } catch (e: Exception) {
                null
            }
        } else {
            null
        }
    }

    private fun jsonObjectToMap(obj: JSONObject): Map<String, Any?> {
        val map = mutableMapOf<String, Any?>()
        for (key in obj.keys()) {
            map[key] = obj.opt(key)
        }
        return map
    }
}
