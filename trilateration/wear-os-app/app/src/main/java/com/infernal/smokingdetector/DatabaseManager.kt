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
        private const val DATABASE_VERSION = 6

        // Table: cigarette_detections
        private const val TABLE_DETECTIONS = "cigarette_detections"
        // Table: drink_detections
        private const val TABLE_DRINK_DETECTIONS = "drink_detections"
        // Table: training_samples (raw windows for personal fine-tuning)
        private const val TABLE_TRAINING = "training_samples"
        // Table: smoking_patterns (24h time patterns)
        private const val TABLE_PATTERNS = "smoking_patterns"
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

        private const val COL_SYNC_STATUS = "sync_status" // 'pending' or 'synced'
        private const val COL_HR_RISE = "hr_rise"           // HR delta measured 2 min post-detection
        private const val COL_HR_CONFIRMED = "hr_confirmed" // 1 if hr_rise >= threshold, else 0

        // Auto-cleanup: keep last 90 days
        private const val RETENTION_DAYS = 90

        // Throttle the cleanup pass — running it on every insert means a
        // full table scan + DELETE on every cigarette, which is wasteful.
        // Once per hour is plenty (RETENTION_DAYS=90 means there's no rush).
        private const val CLEANUP_INTERVAL_MS = 60 * 60 * 1000L
    }

    // Last time cleanupOldRecords actually ran. We keep one global timestamp
    // because the table is single-writer (only the DetectionService) and the
    // throttling decision is independent of the table being cleaned.
    @Volatile private var lastCleanupMs: Long = 0L

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
                $COL_SMOKING_HAND TEXT DEFAULT 'auto',
                $COL_SYNC_STATUS TEXT DEFAULT 'pending',
                $COL_HR_RISE REAL DEFAULT 0,
                $COL_HR_CONFIRMED INTEGER DEFAULT 0
            )
        """.trimIndent()

        db.execSQL(createTable)

        // Create drink_detections table (same schema)
        val createDrinkTable = """
            CREATE TABLE $TABLE_DRINK_DETECTIONS (
                $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COL_TIMESTAMP INTEGER NOT NULL,
                $COL_CONFIDENCE REAL NOT NULL,
                $COL_GPS_CLUSTER INTEGER,
                $COL_HR_BASELINE REAL,
                $COL_HR_CURRENT REAL,
                $COL_HR_DELTA REAL,
                $COL_FEATURES TEXT,
                $COL_WRIST_LOCATION TEXT DEFAULT 'right',
                $COL_SMOKING_HAND TEXT DEFAULT 'auto',
                $COL_SYNC_STATUS TEXT DEFAULT 'pending'
            )
        """.trimIndent()
        db.execSQL(createDrinkTable)

        // Index on timestamp for fast queries
        db.execSQL("CREATE INDEX idx_timestamp ON $TABLE_DETECTIONS($COL_TIMESTAMP)")
        db.execSQL("CREATE INDEX idx_drink_timestamp ON $TABLE_DRINK_DETECTIONS($COL_TIMESTAMP)")

        // Training samples for personal fine-tuning
        db.execSQL("""
            CREATE TABLE $TABLE_TRAINING (
                $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                $COL_TIMESTAMP INTEGER NOT NULL,
                label TEXT NOT NULL,
                raw_data TEXT NOT NULL,
                inference_result TEXT,
                boost_measurement INTEGER DEFAULT 0
            )
        """.trimIndent())
        db.execSQL("CREATE INDEX idx_training_ts ON $TABLE_TRAINING($COL_TIMESTAMP)")

        // 24h smoking patterns
        db.execSQL("""
            CREATE TABLE $TABLE_PATTERNS (
                $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                hour INTEGER NOT NULL,
                day_of_week INTEGER NOT NULL,
                count INTEGER DEFAULT 0,
                last_updated INTEGER NOT NULL
            )
        """.trimIndent())

        Log.d(TAG, "Database created: $DATABASE_NAME")
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_WRIST_LOCATION TEXT DEFAULT 'right'")
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_SMOKING_HAND TEXT DEFAULT 'auto'")
            Log.d(TAG, "Database migrated: added wrist_location + smoking_hand columns")
        }
        if (oldVersion < 3) {
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_SYNC_STATUS TEXT DEFAULT 'pending'")
            Log.d(TAG, "Database migrated: added sync_status column")
        }
        if (oldVersion < 4) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS $TABLE_DRINK_DETECTIONS (
                    $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    $COL_TIMESTAMP INTEGER NOT NULL,
                    $COL_CONFIDENCE REAL NOT NULL,
                    $COL_GPS_CLUSTER INTEGER,
                    $COL_HR_BASELINE REAL,
                    $COL_HR_CURRENT REAL,
                    $COL_HR_DELTA REAL,
                    $COL_FEATURES TEXT,
                    $COL_WRIST_LOCATION TEXT DEFAULT 'right',
                    $COL_SMOKING_HAND TEXT DEFAULT 'auto',
                    $COL_SYNC_STATUS TEXT DEFAULT 'pending'
                )
            """.trimIndent())
            db.execSQL("CREATE INDEX IF NOT EXISTS idx_drink_timestamp ON $TABLE_DRINK_DETECTIONS($COL_TIMESTAMP)")
            Log.d(TAG, "Database migrated: added drink_detections table")
        }
        if (oldVersion < 5) {
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS $TABLE_TRAINING (
                    $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    $COL_TIMESTAMP INTEGER NOT NULL,
                    label TEXT NOT NULL,
                    raw_data TEXT NOT NULL,
                    inference_result TEXT,
                    boost_measurement INTEGER DEFAULT 0
                )
            """.trimIndent())
            db.execSQL("CREATE INDEX IF NOT EXISTS idx_training_ts ON $TABLE_TRAINING($COL_TIMESTAMP)")
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS $TABLE_PATTERNS (
                    $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    hour INTEGER NOT NULL,
                    day_of_week INTEGER NOT NULL,
                    count INTEGER DEFAULT 0,
                    last_updated INTEGER NOT NULL
                )
            """.trimIndent())
            Log.d(TAG, "Database migrated: added training_samples + smoking_patterns")
        }
        if (oldVersion < 6) {
            // HR confirmation columns for the 2-minute post-detection HR recheck
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_HR_RISE REAL DEFAULT 0")
            db.execSQL("ALTER TABLE $TABLE_DETECTIONS ADD COLUMN $COL_HR_CONFIRMED INTEGER DEFAULT 0")
            Log.d(TAG, "Database migrated: added hr_rise + hr_confirmed columns")
        }
        Log.d(TAG, "Database upgraded: $oldVersion -> $newVersion")
    }

    /**
     * Update a detection with the HR recheck result, called 2 minutes after
     * detection by DetectionService.scheduleHrConfirmation.
     */
    fun updateDetectionHrConfirmation(detectionId: Long, hrRise: Float, confirmed: Boolean) {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_HR_RISE, hrRise)
            put(COL_HR_CONFIRMED, if (confirmed) 1 else 0)
        }
        val rows = db.update(TABLE_DETECTIONS, values, "$COL_ID = ?", arrayOf(detectionId.toString()))
        Log.d(TAG, "HR confirmation updated for detection $detectionId: rise=$hrRise bpm confirmed=$confirmed ($rows rows)")
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
     * Get total cigarettes detected (all time). Used by MainActivity header.
     */
    fun getTotalCount(): Int {
        val db = readableDatabase
        return db.rawQuery("SELECT COUNT(*) FROM $TABLE_DETECTIONS", null).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    /**
     * Get cigarettes detected in last N days.
     * Used by MainActivity + DetectionService.startMonitoring (counter init).
     */
    fun getCountLastNDays(days: Int): Int {
        val db = readableDatabase
        val cutoffTime = System.currentTimeMillis() - (days * 24 * 60 * 60 * 1000L)
        return db.rawQuery(
            "SELECT COUNT(*) FROM $TABLE_DETECTIONS WHERE $COL_TIMESTAMP > ?",
            arrayOf(cutoffTime.toString())
        ).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    /**
     * Get average cigarettes per day (last 30 days). Used by MainActivity header.
     */
    fun getAvgCigarettesPerDay(): Float {
        val count = getCountLastNDays(30)
        return count / 30f
    }

    /**
     * Cleanup records older than RETENTION_DAYS.
     *
     * Throttled to once per CLEANUP_INTERVAL_MS — calling this on every
     * insert (the original behavior) meant a full DELETE scan on every
     * cigarette, which is pure waste because RETENTION_DAYS=90 doesn't
     * change minute-to-minute.
     */
    private fun cleanupOldRecords() {
        val now = System.currentTimeMillis()
        if (now - lastCleanupMs < CLEANUP_INTERVAL_MS) return
        lastCleanupMs = now

        val db = writableDatabase
        val cutoffTime = now - (RETENTION_DAYS * 24L * 60L * 60L * 1000L)

        val deleted = db.delete(
            TABLE_DETECTIONS,
            "$COL_TIMESTAMP < ?",
            arrayOf(cutoffTime.toString())
        )

        if (deleted > 0) {
            Log.d(TAG, "Cleaned up $deleted old records (>$RETENTION_DAYS days)")
        }
    }

    // ===== DRINK DETECTION METHODS =====

    fun insertDrinkDetection(
        confidence: Float, gpsCluster: Int, hrBaseline: Float, hrCurrent: Float,
        features: FloatArray, wristLocation: String = "right", smokingHand: String = "auto"
    ): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_TIMESTAMP, System.currentTimeMillis())
            put(COL_CONFIDENCE, confidence)
            put(COL_GPS_CLUSTER, gpsCluster)
            put(COL_HR_BASELINE, hrBaseline)
            put(COL_HR_CURRENT, hrCurrent)
            put(COL_HR_DELTA, hrCurrent - hrBaseline)
            put(COL_FEATURES, features.joinToString(","))
            put(COL_WRIST_LOCATION, wristLocation)
            put(COL_SMOKING_HAND, smokingHand)
        }
        val id = db.insert(TABLE_DRINK_DETECTIONS, null, values)
        Log.d(TAG, "Drink detection inserted: id=$id")
        cleanupOldDrinkRecords()
        return id
    }

    fun getDrinkCountLastNDays(days: Int): Int {
        val db = readableDatabase
        val cutoffTime = System.currentTimeMillis() - (days * 24 * 60 * 60 * 1000L)
        return db.rawQuery(
            "SELECT COUNT(*) FROM $TABLE_DRINK_DETECTIONS WHERE $COL_TIMESTAMP > ?",
            arrayOf(cutoffTime.toString())
        ).use { cursor ->
            if (cursor.moveToFirst()) cursor.getInt(0) else 0
        }
    }

    // Separate cleanup-throttle for the drink table — independent from
    // the cigarette cleanup so each table cleans on its own schedule.
    @Volatile private var lastDrinkCleanupMs: Long = 0L

    private fun cleanupOldDrinkRecords() {
        val now = System.currentTimeMillis()
        if (now - lastDrinkCleanupMs < CLEANUP_INTERVAL_MS) return
        lastDrinkCleanupMs = now

        val db = writableDatabase
        val cutoffTime = now - (RETENTION_DAYS * 24L * 60L * 60L * 1000L)
        db.delete(TABLE_DRINK_DETECTIONS, "$COL_TIMESTAMP < ?", arrayOf(cutoffTime.toString()))
    }

    // ===== TRAINING SAMPLES =====

    /**
     * Save a raw sensor window for personal fine-tuning.
     * Called during boost mode after each inference.
     * rawData: 6-channel signal as comma-separated string (225 x 6 = 1350 values)
     * label: "cigarette", "drink", "other", "unknown"
     * inferenceResult: model output probabilities
     */
    fun insertTrainingSample(
        label: String,
        rawData: String,
        inferenceResult: String = "",
        boostMeasurement: Int = 0
    ): Long {
        val db = writableDatabase
        val values = ContentValues().apply {
            put(COL_TIMESTAMP, System.currentTimeMillis())
            put("label", label)
            put("raw_data", rawData)
            put("inference_result", inferenceResult)
            put("boost_measurement", boostMeasurement)
        }
        val id = db.insert(TABLE_TRAINING, null, values)
        Log.d(TAG, "Training sample saved: id=$id, label=$label, measurement=$boostMeasurement")
        return id
    }

    // ===== SMOKING PATTERNS (24h) =====

    /**
     * Record a smoking event for pattern learning.
     * Increments the count for the current hour + day_of_week.
     *
     * Wrapped in a transaction so the SELECT-then-UPDATE-or-INSERT sequence
     * is atomic. Without the transaction, two concurrent calls could both
     * read count=N, both update count=N+1 instead of N+2 (lost update). The
     * watch is single-writer in practice but a transaction is essentially
     * free and removes the assumption.
     */
    fun recordSmokingPattern() {
        val db = writableDatabase
        val timestamp = System.currentTimeMillis()
        // Reuse a single Calendar instance per call — getInstance() allocates.
        val cal = java.util.Calendar.getInstance()
        val hour = cal.get(java.util.Calendar.HOUR_OF_DAY)
        val dow = cal.get(java.util.Calendar.DAY_OF_WEEK) // 1=Sun, 7=Sat

        db.beginTransaction()
        try {
            val existing = db.rawQuery(
                "SELECT $COL_ID, count FROM $TABLE_PATTERNS WHERE hour = ? AND day_of_week = ?",
                arrayOf(hour.toString(), dow.toString())
            ).use { cursor ->
                if (cursor.moveToFirst()) Pair(cursor.getInt(0), cursor.getInt(1)) else null
            }

            if (existing != null) {
                val values = ContentValues().apply {
                    put("count", existing.second + 1)
                    put("last_updated", timestamp)
                }
                db.update(TABLE_PATTERNS, values, "$COL_ID = ?", arrayOf(existing.first.toString()))
            } else {
                val values = ContentValues().apply {
                    put("hour", hour)
                    put("day_of_week", dow)
                    put("count", 1)
                    put("last_updated", timestamp)
                }
                db.insert(TABLE_PATTERNS, null, values)
            }
            db.setTransactionSuccessful()
        } finally {
            db.endTransaction()
        }
        Log.d(TAG, "Pattern recorded: hour=$hour, dow=$dow")
    }

    /**
     * Get all patterns as hour→count map.
     * Used for threshold adjustment: high-count hours get lower threshold.
     */
    fun getAllPatterns(): Map<Int, Float> {
        val db = readableDatabase
        val patterns = mutableMapOf<Int, Float>()
        db.rawQuery(
            "SELECT hour, AVG(count) as avg_count FROM $TABLE_PATTERNS GROUP BY hour",
            null
        ).use { cursor ->
            while (cursor.moveToNext()) {
                patterns[cursor.getInt(0)] = cursor.getFloat(1)
            }
        }
        return patterns
    }

    /**
     * Check if current hour is a high-smoking hour (top 30%).
     *
     * LEGACY binary implementation. The new code path in DetectionService
     * uses the GaussianHourPattern returned by getGaussianPattern() which
     * gives a smooth continuous score instead of a hard cliff at each hour
     * boundary. Kept here for backward compat with older call sites that
     * still need a simple boolean.
     */
    fun isHighSmokingHour(): Boolean {
        val pattern = getGaussianPattern()
        if (!pattern.isLearned()) return false
        val cal = java.util.Calendar.getInstance()
        val minuteOfDay = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 +
            cal.get(java.util.Calendar.MINUTE)
        return pattern.isHighSmokingMinute(minuteOfDay)
    }

    /**
     * Build a GaussianHourPattern from the recorded smoking_patterns table.
     * Each hour contributes a Gaussian kernel centered on that hour, whose
     * amplitude is the observed count. The pattern smooths the raw counts
     * so that nearby minutes (e.g. 8h55 vs 9h05) score similarly instead
     * of hitting a cliff at the hour boundary.
     *
     * See GaussianHourPattern.kt for the scoring rationale.
     */
    fun getGaussianPattern(): GaussianHourPattern {
        return GaussianHourPattern.fromHourCounts(getAllPatterns())
    }

}
