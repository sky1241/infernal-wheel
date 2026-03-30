package com.infernal.smokingdetector

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log

/**
 * Database Manager for Cigarette Detection History
 *
 * Stores all cigarette detections with:
 * - Timestamp
 * - Confidence (probability)
 * - Location (GPS cluster)
 * - Heart rate (baseline + current)
 * - Features (30 biomechanical features for debugging)
 *
 * Used for:
 * - Statistics (cigarettes/day, trends)
 * - Gamification (streak counter, total count)
 * - Debugging (feature analysis, false positives)
 * - Sync with server (future)
 *
 * Database:
 * - SQLite local storage (~1 KB per detection)
 * - Auto-cleanup: keep last 90 days only
 * - Estimated size: ~90 KB for 90 days @ 10 cigarettes/day
 */
class DatabaseManager(context: Context) : SQLiteOpenHelper(
    context,
    DATABASE_NAME,
    null,
    DATABASE_VERSION
) {

    companion object {
        private const val TAG = "DatabaseManager"
        private const val DATABASE_NAME = "smoking_detector.db"
        private const val DATABASE_VERSION = 2

        // Table: cigarette_detections
        private const val TABLE_DETECTIONS = "cigarette_detections"
        private const val COL_ID = "id"
        private const val COL_TIMESTAMP = "timestamp"
        private const val COL_CONFIDENCE = "confidence"
        private const val COL_GPS_CLUSTER = "gps_cluster"
        private const val COL_HR_BASELINE = "hr_baseline"
        private const val COL_HR_CURRENT = "hr_current"
        private const val COL_HR_DELTA = "hr_delta"
        private const val COL_FEATURES = "features" // JSON string of 30 features
        private const val COL_WRIST_LOCATION = "wrist_location" // "left" or "right"
        private const val COL_SMOKING_HAND = "smoking_hand" // "left", "right", or "auto"

        // Auto-cleanup: keep last 90 days
        private const val RETENTION_DAYS = 90
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createTable = """
            CREATE TABLE $TABLE_DETECTIONS (
                $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COL_TIMESTAMP INTEGER NOT NULL,
                $COL_CONFIDENCE REAL NOT NULL,
                $COL_GPS_CLUSTER INTEGER,
                $COL_HR_BASELINE REAL,
                $COL_HR_CURRENT REAL,
                $COL_HR_DELTA REAL,
                $COL_FEATURES TEXT,
                $COL_WRIST_LOCATION TEXT DEFAULT 'right',
                $COL_SMOKING_HAND TEXT DEFAULT 'auto'
            )
        """.trimIndent()

        db.execSQL(createTable)

        // Index on timestamp for fast queries
        db.execSQL("CREATE INDEX idx_timestamp ON $TABLE_DETECTIONS($COL_TIMESTAMP)")

        Log.d(TAG, "Database created: $DATABASE_NAME")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_WRIST_LOCATION TEXT DEFAULT 'right'")
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_SMOKING_HAND TEXT DEFAULT 'auto'")
            Log.d(TAG, "Database migrated: added wrist_location + smoking_hand columns")
        }
        Log.d(TAG, "Database upgraded: $oldVersion → $newVersion")
    }

    /**
     * Insert cigarette detection
     */
    fun insertDetection(
        confidence: Float,
        gpsCluster: Int,
        hrBaseline: Float,
        hrCurrent: Float,
        features: FloatArray,
        wristLocation: String = "right",
        smokingHand: String = "auto"
    ): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_TIMESTAMP, System.currentTimeMillis())
            put(COL_CONFIDENCE, confidence)
            put(COL_GPS_CLUSTER, gpsCluster)
            put(COL_HR_BASELINE, hrBaseline)
            put(COL_HR_CURRENT, hrCurrent)
            put(COL_HR_DELTA, hrCurrent - hrBaseline)
            put(COL_FEATURES, features.joinToString(",")) // JSON-like string
            put(COL_WRIST_LOCATION, wristLocation)
            put(COL_SMOKING_HAND, smokingHand)
        }

        val id = db.insert(TABLE_DETECTIONS, null, values)
        Log.d(TAG, "Detection inserted: id=$id, confidence=$confidence, gpsCluster=$gpsCluster")

        // Auto-cleanup old records
        cleanupOldRecords()

        return id
    }

    /**
     * Get total cigarettes detected (all time)
     */
    fun getTotalCount(): Int {
        val db = readableDatabase
        // BUG 17 FIX: Use cursor.use {} to avoid leaks
        return db.rawQuery("SELECT COUNT(*) FROM $TABLE_DETECTIONS", null).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    /**
     * Get cigarettes detected in last N days
     */
    fun getCountLastNDays(days: Int): Int {
        val db = readableDatabase
        val cutoffTime = System.currentTimeMillis() - (days * 24 * 60 * 60 * 1000L)

        // BUG 17 FIX: Use cursor.use {} to avoid leaks
        return db.rawQuery(
            "SELECT COUNT(*) FROM $TABLE_DETECTIONS WHERE $COL_TIMESTAMP > ?",
            arrayOf(cutoffTime.toString())
        ).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    /**
     * Get average cigarettes per day (last 30 days)
     */
    fun getAvgCigarettesPerDay(): Float {
        val count = getCountLastNDays(30)
        return count / 30f
    }

    /**
     * Get detections by GPS cluster (home/work/bar/other)
     */
    fun getCountByCluster(cluster: Int): Int {
        val db = readableDatabase
        // BUG 17 FIX: Use cursor.use {} to avoid leaks
        return db.rawQuery(
            "SELECT COUNT(*) FROM $TABLE_DETECTIONS WHERE $COL_GPS_CLUSTER = ?",
            arrayOf(cluster.toString())
        ).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    /**
     * Get last detection timestamp
     */
    fun getLastDetectionTime(): Long {
        val db = readableDatabase
        // BUG 17 FIX: Use cursor.use {} to avoid leaks
        return db.rawQuery(
            "SELECT $COL_TIMESTAMP FROM $TABLE_DETECTIONS ORDER BY $COL_TIMESTAMP DESC LIMIT 1",
            null
        ).use { cursor ->
            if (cursor.moveToFirst()) cursor.getLong(0) else 0L
        }
    }

    /**
     * Get streak (consecutive days with ≤ N cigarettes)
     * For gamification: "3 days with ≤2 cigarettes/day"
     */
    fun getStreak(maxCigarettesPerDay: Int = 2): Int {
        // Simplified: count days with ≤ maxCigarettesPerDay
        // TODO: Implement proper consecutive days logic
        return 0 // Placeholder
    }

    /**
     * Cleanup records older than RETENTION_DAYS
     */
    private fun cleanupOldRecords() {
        val db = writableDatabase
        val cutoffTime = System.currentTimeMillis() - (RETENTION_DAYS * 24 * 60 * 60 * 1000L)

        val deleted = db.delete(
            TABLE_DETECTIONS,
            "$COL_TIMESTAMP < ?",
            arrayOf(cutoffTime.toString())
        )

        if (deleted > 0) {
            Log.d(TAG, "Cleaned up $deleted old records (>$RETENTION_DAYS days)")
        }
    }

    /**
     * Export data for sync/backup (CSV format)
     */
    fun exportToCSV(): String {
        val db = readableDatabase
        // BUG 17 FIX: Use cursor.use {} to avoid leaks
        return db.rawQuery("SELECT * FROM $TABLE_DETECTIONS", null).use { cursor ->
            val csv = StringBuilder()
            csv.append("timestamp,confidence,gps_cluster,hr_baseline,hr_current,hr_delta,wrist_location,smoking_hand\n")

            while (cursor.moveToNext()) {
                val timestamp = cursor.getLong(cursor.getColumnIndexOrThrow(COL_TIMESTAMP))
                val confidence = cursor.getFloat(cursor.getColumnIndexOrThrow(COL_CONFIDENCE))
                val gpsCluster = cursor.getInt(cursor.getColumnIndexOrThrow(COL_GPS_CLUSTER))
                val hrBaseline = cursor.getFloat(cursor.getColumnIndexOrThrow(COL_HR_BASELINE))
                val hrCurrent = cursor.getFloat(cursor.getColumnIndexOrThrow(COL_HR_CURRENT))
                val hrDelta = cursor.getFloat(cursor.getColumnIndexOrThrow(COL_HR_DELTA))

                val wrist = cursor.getString(cursor.getColumnIndexOrThrow(COL_WRIST_LOCATION)) ?: "right"
                val hand = cursor.getString(cursor.getColumnIndexOrThrow(COL_SMOKING_HAND)) ?: "auto"
                csv.append("$timestamp,$confidence,$gpsCluster,$hrBaseline,$hrCurrent,$hrDelta,$wrist,$hand\n")
            }

            csv.toString()
        }
    }

    /**
     * Clear all data (for testing/reset)
     */
    fun clearAll() {
        val db = writableDatabase
        db.delete(TABLE_DETECTIONS, null, null)
        Log.d(TAG, "All detections cleared")
    }
}
