package com.infernal.smokingdetector

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.tasks.await
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Wear Data Layer API Sync Manager (Watch → Phone)
 *
 * Syncs cigarette detections from the watch to the phone via Bluetooth.
 * Uses DataClient (store-and-forward) so data arrives even if phone is
 * temporarily disconnected.
 *
 * Data paths:
 * - /smoke_detections/{timestamp} — individual detection events
 * - /daily_summary                — rolling daily summary
 *
 * Strategy:
 * - Each detection is synced immediately after insertion
 * - A periodic batch sync catches anything that failed
 * - Daily summary is updated after each detection
 */
class WearSyncManager(private val context: Context) {

    companion object {
        private const val TAG = "WearSyncManager"
        private const val PREFS_NAME = "wear_sync_prefs"
        private const val KEY_LAST_SYNC_TIMESTAMP = "last_sync_timestamp"

        // Data Layer paths
        private const val PATH_DETECTION = "/smoke_detections"
        private const val PATH_DAILY_SUMMARY = "/daily_summary"

        // DataMap keys for detection items
        private const val KEY_TIMESTAMP = "timestamp"
        private const val KEY_CONFIDENCE = "confidence"
        private const val KEY_GPS_CLUSTER = "gps_cluster"
        private const val KEY_HR_BASELINE = "hr_baseline"
        private const val KEY_HR_CURRENT = "hr_current"
        private const val KEY_HR_DELTA = "hr_delta"
        private const val KEY_WRIST_LOCATION = "wrist_location"
        private const val KEY_SMOKING_HAND = "smoking_hand"

        // DataMap keys for daily summary
        private const val KEY_DATE = "date"
        private const val KEY_CIGARETTE_COUNT = "cigarette_count"
        private const val KEY_TOTAL_DETECTIONS = "total_detections"
        private const val KEY_LAST_DETECTION_TIME = "last_detection_time"
    }

    private val dataClient = Wearable.getDataClient(context)
    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    /**
     * Sync a single detection to the phone immediately.
     *
     * Called right after database insertion in DetectionService.
     * Uses the detection timestamp as the unique path segment so each
     * detection produces exactly one DataItem.
     */
    suspend fun syncDetection(detection: DatabaseManager.Detection) {
        try {
            val path = "$PATH_DETECTION/${detection.timestamp}"
            val request = PutDataMapRequest.create(path).apply {
                dataMap.putLong(KEY_TIMESTAMP, detection.timestamp)
                dataMap.putFloat(KEY_CONFIDENCE, detection.confidence)
                dataMap.putInt(KEY_GPS_CLUSTER, detection.gpsCluster)
                dataMap.putFloat(KEY_HR_BASELINE, detection.hrBaseline)
                dataMap.putFloat(KEY_HR_CURRENT, detection.hrCurrent)
                dataMap.putFloat(KEY_HR_DELTA, detection.hrDelta)
                dataMap.putString(KEY_WRIST_LOCATION, detection.wristLocation)
                dataMap.putString(KEY_SMOKING_HAND, detection.smokingHand)
            }.asPutDataRequest().setUrgent()

            dataClient.putDataItem(request).await()
            updateLastSyncTimestamp(detection.timestamp)
            Log.d(TAG, "Detection synced: timestamp=${detection.timestamp}, confidence=${detection.confidence}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to sync detection: timestamp=${detection.timestamp}", e)
            // Detection stays 'pending' in DB — batch sync will retry
        }
    }

    /**
     * Batch-sync all unsynced detections.
     *
     * Called periodically (every 30 min) to catch any detections that
     * failed to sync immediately (e.g. phone was out of range).
     */
    suspend fun syncBatch(database: DatabaseManager) {
        try {
            val unsynced = database.getUnsyncedDetections()
            if (unsynced.isEmpty()) {
                Log.d(TAG, "Batch sync: nothing to sync")
                return
            }

            Log.d(TAG, "Batch sync: ${unsynced.size} detections to sync")

            var syncedCount = 0
            for (detection in unsynced) {
                try {
                    val path = "$PATH_DETECTION/${detection.timestamp}"
                    val request = PutDataMapRequest.create(path).apply {
                        dataMap.putLong(KEY_TIMESTAMP, detection.timestamp)
                        dataMap.putFloat(KEY_CONFIDENCE, detection.confidence)
                        dataMap.putInt(KEY_GPS_CLUSTER, detection.gpsCluster)
                        dataMap.putFloat(KEY_HR_BASELINE, detection.hrBaseline)
                        dataMap.putFloat(KEY_HR_CURRENT, detection.hrCurrent)
                        dataMap.putFloat(KEY_HR_DELTA, detection.hrDelta)
                        dataMap.putString(KEY_WRIST_LOCATION, detection.wristLocation)
                        dataMap.putString(KEY_SMOKING_HAND, detection.smokingHand)
                    }.asPutDataRequest().setUrgent()

                    dataClient.putDataItem(request).await()
                    database.markAsSynced(detection.timestamp)
                    syncedCount++
                } catch (e: Exception) {
                    Log.e(TAG, "Batch sync failed for timestamp=${detection.timestamp}", e)
                    // Continue with next detection
                }
            }

            if (syncedCount > 0) {
                updateLastSyncTimestamp(System.currentTimeMillis())
            }
            Log.d(TAG, "Batch sync complete: $syncedCount/${unsynced.size} synced")
        } catch (e: Exception) {
            Log.e(TAG, "Batch sync failed", e)
        }
    }

    /**
     * Sync daily summary to phone.
     *
     * Puts a single DataItem at /daily_summary with today's stats.
     * The phone app reads this to show the daily count on the dashboard
     * without needing to aggregate individual detections.
     */
    suspend fun syncDailySummary(database: DatabaseManager) {
        try {
            val todayKey = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
            val cigaretteCount = database.getCountLastNDays(1)
            val totalDetections = database.getTotalCount()
            val lastDetectionTime = database.getLastDetectionTime()

            val request = PutDataMapRequest.create(PATH_DAILY_SUMMARY).apply {
                dataMap.putString(KEY_DATE, todayKey)
                dataMap.putInt(KEY_CIGARETTE_COUNT, cigaretteCount)
                dataMap.putInt(KEY_TOTAL_DETECTIONS, totalDetections)
                dataMap.putLong(KEY_LAST_DETECTION_TIME, lastDetectionTime)
                // Force update even if values haven't changed (timestamp makes it unique)
                dataMap.putLong("updated_at", System.currentTimeMillis())
            }.asPutDataRequest().setUrgent()

            dataClient.putDataItem(request).await()
            Log.d(TAG, "Daily summary synced: date=$todayKey, count=$cigaretteCount, total=$totalDetections")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to sync daily summary", e)
        }
    }

    /**
     * Get the timestamp of the last successful sync
     */
    fun getLastSyncTimestamp(): Long {
        return prefs.getLong(KEY_LAST_SYNC_TIMESTAMP, 0L)
    }

    private fun updateLastSyncTimestamp(timestamp: Long) {
        prefs.edit().putLong(KEY_LAST_SYNC_TIMESTAMP, timestamp).apply()
    }
}
