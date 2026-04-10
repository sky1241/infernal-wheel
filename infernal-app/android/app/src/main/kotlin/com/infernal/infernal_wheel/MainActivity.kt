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

            val detections = if (file.exists()) {
                try { JSONArray(file.readText()) } catch (_: Exception) { JSONArray() }
            } else {
                JSONArray()
            }
            detections.put(detection)
            file.writeText(detections.toString())

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
        try {
            val json = JSONObject(data)
            val label = json.optString("label", "unknown")
            val confidence = json.optDouble("confidence", 0.0)
            val timestamp = json.optLong("timestamp", System.currentTimeMillis())
            val sampleCount = json.optInt("sampleCount", 0)

            val flutterDir = java.io.File(filesDir.parentFile, "app_flutter")
            val trainingDir = java.io.File(flutterDir, "training_windows")
            trainingDir.mkdirs()

            // Cap storage — keep at most MAX_TRAINING_FILES files (FIFO)
            val existing = trainingDir.listFiles { f -> f.isFile && f.name.endsWith(".json") }
                ?.sortedBy { it.lastModified() }
                ?: emptyList()
            if (existing.size >= MAX_TRAINING_FILES) {
                val toDelete = existing.size - MAX_TRAINING_FILES + 1
                for (i in 0 until toDelete) {
                    existing[i].delete()
                }
                Log.d(TAG, "[TRAINING] Pruned $toDelete oldest training file(s)")
            }

            // Build a unique, sortable filename
            val isoTs = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH-mm-ss", java.util.Locale.US)
                .format(java.util.Date(timestamp))
            val confPct = (confidence * 100).toInt()
            val filename = "${isoTs}_${label}_conf${confPct}.json"
            val file = java.io.File(trainingDir, filename)

            // Add a receivedAt field so we know when the phone got it
            json.put("receivedAt", System.currentTimeMillis())
            file.writeText(json.toString())

            Log.d(TAG, "[TRAINING] Saved window: $filename samples=$sampleCount")
        } catch (e: Exception) {
            Log.e(TAG, "[TRAINING] Failed to save training window", e)
        }
    }

    private fun updateDailySummary(type: String) {
        val flutterDir2 = java.io.File(filesDir.parentFile, "app_flutter")
        flutterDir2.mkdirs()
        val file = java.io.File(flutterDir2, "watch_daily_summary.json")
        val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
            .format(java.util.Date())

        val summary = if (file.exists()) {
            try { JSONObject(file.readText()) } catch (_: Exception) { JSONObject() }
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
        file.writeText(summary.toString())
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
