package com.infernal.infernal_wheel

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Receives data from the Wear OS watch via the Wear Data Layer API.
 * Persists detections to watch_detections.json and notifies Flutter via MethodChannel.
 */
class WearDataReceiver : WearableListenerService() {

    companion object {
        private const val TAG = "WearDataReceiver"
        private const val DETECTIONS_FILE = "watch_detections.json"
        private const val DRINK_DETECTIONS_FILE = "watch_drink_detections.json"
        private const val SUMMARY_FILE = "watch_daily_summary.json"
        private const val CHANNEL_NAME = "com.infernal.wheel/wear_sync"

        fun getDetectionsFile(context: Context): File =
            File(context.filesDir, DETECTIONS_FILE)

        fun getDrinkDetectionsFile(context: Context): File =
            File(context.filesDir, DRINK_DETECTIONS_FILE)

        fun getSummaryFile(context: Context): File =
            File(context.filesDir, SUMMARY_FILE)
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        Log.d(TAG, "onDataChanged: ${dataEvents.count} events")

        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue

            val dataItem = event.dataItem
            val path = dataItem.uri.path ?: continue

            when {
                path.startsWith("/smoke_detections/") -> handleDetection(dataItem, "smoke")
                path.startsWith("/drink_detections/") -> handleDetection(dataItem, "drink")
                path == "/daily_summary" -> handleDailySummary(dataItem)
                else -> Log.d(TAG, "Unknown path: $path")
            }
        }

        notifyFlutter()
    }

    private fun handleDetection(dataItem: com.google.android.gms.wearable.DataItem, type: String) {
        try {
            val dataMap = DataMapItem.fromDataItem(dataItem).dataMap

            val detection = JSONObject().apply {
                put("timestamp", dataMap.getLong("timestamp", 0L))
                put("confidence", dataMap.getDouble("confidence"))
                put("gpsCluster", dataMap.getString("gpsCluster", ""))
                put("hrBaseline", dataMap.getInt("hrBaseline", 0))
                put("hrCurrent", dataMap.getInt("hrCurrent", 0))
                put("hrDelta", dataMap.getInt("hrDelta", 0))
                put("type", type)
                put("receivedAt", System.currentTimeMillis())
            }

            // Append to correct file based on type
            val file = if (type == "drink") getDrinkDetectionsFile(this) else getDetectionsFile(this)
            val detections = if (file.exists()) {
                JSONArray(file.readText())
            } else {
                JSONArray()
            }
            detections.put(detection)
            file.writeText(detections.toString())

            Log.d(TAG, "Stored detection: confidence=${detection.getDouble("confidence")}")
        } catch (e: Exception) {
            Log.e(TAG, "Error handling detection", e)
        }
    }

    private fun handleDailySummary(dataItem: com.google.android.gms.wearable.DataItem) {
        try {
            val dataMap = DataMapItem.fromDataItem(dataItem).dataMap

            val summary = JSONObject().apply {
                put("date", dataMap.getString("date", ""))
                put("cigaretteCount", dataMap.getInt("cigarette_count", 0))
                put("drinkCount", dataMap.getInt("drink_count", 0))
                put("totalDetections", dataMap.getInt("total_detections", 0))
                put("receivedAt", System.currentTimeMillis())
            }

            // Overwrite summary file (always latest)
            val file = getSummaryFile(this)
            file.writeText(summary.toString())

            Log.d(TAG, "Stored daily summary: count=${summary.getInt("cigaretteCount")}")
        } catch (e: Exception) {
            Log.e(TAG, "Error handling daily summary", e)
        }
    }

    private fun notifyFlutter() {
        try {
            // Best-effort notification — Flutter may not be running
            val engine = FlutterEngineHolder.engine
            if (engine != null) {
                val channel = MethodChannel(
                    engine.dartExecutor.binaryMessenger,
                    CHANNEL_NAME
                )
                engine.dartExecutor.binaryMessenger.let {
                    channel.invokeMethod("onWatchDataChanged", null)
                }
                Log.d(TAG, "Notified Flutter of new watch data")
            } else {
                Log.d(TAG, "Flutter engine not available, skipping notification")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Could not notify Flutter", e)
        }
    }
}

/**
 * Simple holder to share the FlutterEngine reference between
 * MainActivity and WearDataReceiver.
 */
object FlutterEngineHolder {
    var engine: FlutterEngine? = null
}
