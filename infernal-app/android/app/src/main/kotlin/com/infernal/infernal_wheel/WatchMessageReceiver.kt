package com.infernal.infernal_wheel

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Receives messages from the watch via MessageClient.
 *
 * Paths:
 * - /detection → cigarette detection
 * - /drink → drink detection
 *
 * Stores in local JSON files and updates daily summary.
 * Notifies Flutter via MethodChannel if app is in foreground.
 */
class WatchMessageReceiver : WearableListenerService() {

    companion object {
        private const val TAG = "WatchMsgReceiver"
        private const val DETECTIONS_FILE = "watch_detections.json"
        private const val DRINK_DETECTIONS_FILE = "watch_drink_detections.json"
        private const val SUMMARY_FILE = "watch_daily_summary.json"
        private const val CHANNEL_NAME = "com.infernal.wheel/wear_sync"
        private const val MAX_DETECTIONS = 10000 // Cap file size

        fun getDetectionsFile(context: Context): File =
            File(context.filesDir, DETECTIONS_FILE)

        fun getDrinkDetectionsFile(context: Context): File =
            File(context.filesDir, DRINK_DETECTIONS_FILE)

        fun getSummaryFile(context: Context): File =
            File(context.filesDir, SUMMARY_FILE)
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        val path = messageEvent.path
        val data = String(messageEvent.data)

        Log.d(TAG, "Message received: path=$path, size=${data.length}")

        try {
            val json = JSONObject(data)

            when (path) {
                "/detection" -> handleDetection(json, "cigarette")
                "/drink" -> handleDetection(json, "drink")
                else -> Log.w(TAG, "Unknown message path: $path")
            }

            updateDailySummary(json)
            notifyFlutter()

        } catch (e: Exception) {
            Log.e(TAG, "Error processing message", e)
        }
    }

    private fun handleDetection(json: JSONObject, type: String) {
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

        val file = if (type == "drink") getDrinkDetectionsFile(this) else getDetectionsFile(this)

        val detections = if (file.exists()) {
            try { JSONArray(file.readText()) } catch (_: Exception) { JSONArray() }
        } else {
            JSONArray()
        }
        detections.put(detection)

        // Cap size
        val trimmed = if (detections.length() > MAX_DETECTIONS) {
            val newArr = JSONArray()
            for (i in detections.length() - MAX_DETECTIONS until detections.length()) {
                newArr.put(detections.getJSONObject(i))
            }
            newArr
        } else {
            detections
        }

        file.writeText(trimmed.toString())
        Log.d(TAG, "Stored $type detection (total: ${trimmed.length()})")
    }

    private fun updateDailySummary(json: JSONObject) {
        val file = getSummaryFile(this)
        val today = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
            .format(java.util.Date())
        val type = json.optString("type", "cigarette")

        val summary = if (file.exists()) {
            try { JSONObject(file.readText()) } catch (_: Exception) { JSONObject() }
        } else {
            JSONObject()
        }

        // Reset if new day
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
        Log.d(TAG, "Summary updated: cig=${summary.optInt("cigaretteCount")} drink=${summary.optInt("drinkCount")}")
    }

    private fun notifyFlutter() {
        try {
            val engine = FlutterEngineHolder.engine ?: return
            val channel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            channel.invokeMethod("onWatchDataChanged", null)
            Log.d(TAG, "Flutter notified")
        } catch (e: Exception) {
            Log.w(TAG, "Could not notify Flutter", e)
        }
    }
}
