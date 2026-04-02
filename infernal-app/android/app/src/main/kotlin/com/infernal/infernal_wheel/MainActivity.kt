package com.infernal.infernal_wheel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.infernal.wheel/wear_sync"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Share engine reference so WearDataReceiver can notify Flutter
        FlutterEngineHolder.engine = flutterEngine

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getLatestSync" -> result.success(getLatestSync())
                    "getDailySummary" -> result.success(getDailySummary())
                    "getDetectionHistory" -> result.success(getDetectionHistory())
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        FlutterEngineHolder.engine = null
        super.onDestroy()
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

    private fun readDetections(): JSONArray {
        val file = WearDataReceiver.getDetectionsFile(this)
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
        val file = WearDataReceiver.getSummaryFile(this)
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
