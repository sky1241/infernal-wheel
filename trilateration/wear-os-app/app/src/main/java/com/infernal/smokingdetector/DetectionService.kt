package com.infernal.smokingdetector

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import kotlinx.coroutines.*

/**
 * Foreground Service for Continuous Smoking Detection
 *
 * Runs in background with persistent notification.
 * Monitors sensors continuously and runs inference periodically.
 *
 * Features:
 * - Continuous sensor monitoring @ 50Hz
 * - Periodic inference every 30 seconds
 * - Cigarette detection with notification
 * - Low power consumption (boost sampling strategy)
 *
 * Lifecycle:
 * - START: User clicks "Start Monitoring"
 * - RUNNING: Continuous detection
 * - STOP: User clicks "Stop Monitoring" or system kills service
 */
class DetectionService : Service() {

    companion object {
        private const val TAG = "DetectionService"
        private const val NOTIFICATION_CHANNEL_ID = "smoking_detection_channel"
        private const val NOTIFICATION_ID = 1001
        private const val INFERENCE_INTERVAL_MS = 30_000L // 30 seconds
        private const val SYNC_INTERVAL_MS = 30 * 60 * 1000L // 30 minutes

        // Detection thresholds
        private const val THRESHOLD_DIRECT = 0.7f   // Watch on smoking hand → strong signal
        private const val THRESHOLD_INDIRECT = 0.5f  // Watch on opposite hand → weaker signal

        // Service actions
        const val ACTION_START = "com.infernal.smokingdetector.START"
        const val ACTION_STOP = "com.infernal.smokingdetector.STOP"
        const val ACTION_BOOST = "com.infernal.smokingdetector.BOOST"

        /**
         * Trigger boost mode from outside (e.g., manual +1 button)
         */
        fun triggerBoost(context: Context, reason: String) {
            if (!isRunning) return
            val intent = Intent(context, DetectionService::class.java).apply {
                action = ACTION_BOOST
                putExtra("reason", reason)
            }
            context.startService(intent)
        }

        // BUG 18 FIX: Static flag for service running state (replaces deprecated ActivityManager query)
        @Volatile
        var isRunning = false

        /**
         * Start detection service
         */
        fun start(context: Context) {
            val intent = Intent(context, DetectionService::class.java).apply {
                action = ACTION_START
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        /**
         * Stop detection service
         */
        fun stop(context: Context) {
            val intent = Intent(context, DetectionService::class.java).apply {
                action = ACTION_STOP
            }
            context.startService(intent)
        }
    }

    private lateinit var detector: SmokingDetector
    private lateinit var sensorCollector: SensorDataCollector
    private lateinit var featureExtractor: FeatureExtractor
    private lateinit var gpsManager: GPSClusteringManager
    private lateinit var healthServices: HealthServicesManager
    private lateinit var database: DatabaseManager
    private lateinit var boostManager: BoostSamplingManager
    private lateinit var messageSync: MessageSyncManager
    private lateinit var phoneListener: PhoneConnectionListener
    private lateinit var notificationManager: NotificationManager

    private var serviceScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private var inferenceJob: Job? = null
    private var syncJob: Job? = null

    private lateinit var prefs: SharedPreferences
    private var isLeftWrist = false
    private var smokingHand = "auto"
    private var cigarettesDetected = 0
    private var drinksDetected = 0
    private var lastDetectionTime = 0L
    private var lastDrinkDetectionTime = 0L
    private val DRINK_THRESHOLD = 0.6f
    // BUG 10 FIX: Guard against double-start
    private var isMonitoring = false

    private val prefListener = SharedPreferences.OnSharedPreferenceChangeListener { _, key ->
        when (key) {
            "is_left_wrist" -> {
                isLeftWrist = prefs.getBoolean("is_left_wrist", false)
                Log.d(TAG, "Pref updated: wrist=${if (isLeftWrist) "left" else "right"}")
            }
            "smoking_hand" -> {
                smokingHand = prefs.getString("smoking_hand", "auto") ?: "auto"
                Log.d(TAG, "Pref updated: smoking_hand=$smokingHand")
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        isRunning = true // BUG 18 FIX
        Log.d(TAG, "Service created")

        // CRITICAL: call startForeground IMMEDIATELY (must be within 5s on separate process)
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannel()
        val earlyNotification = createNotification(
            title = "Detection starting...",
            text = "Initializing sensors",
            ongoing = true
        )
        startForeground(NOTIFICATION_ID, earlyNotification)
        Log.d(TAG, "Early foreground started")

        // Initialize components (can take time, but foreground is already set)
        detector = SmokingDetector(this)
        sensorCollector = SensorDataCollector(this)
        featureExtractor = FeatureExtractor()
        gpsManager = GPSClusteringManager(this)
        healthServices = HealthServicesManager(this)
        database = DatabaseManager(this)
        boostManager = BoostSamplingManager(this)
        messageSync = MessageSyncManager(this)
        phoneListener = PhoneConnectionListener(this, messageSync)

        // Read wrist/hand preferences + listen for runtime changes
        prefs = getSharedPreferences("smoking_detector_prefs", Context.MODE_PRIVATE)
        isLeftWrist = prefs.getBoolean("is_left_wrist", false)
        smokingHand = prefs.getString("smoking_hand", "auto") ?: "auto"
        prefs.registerOnSharedPreferenceChangeListener(prefListener)
        Log.d(TAG, "Wrist: ${if (isLeftWrist) "left" else "right"}, Smoking hand: $smokingHand")

        // Setup boost mode listener (restart sensors with new rate)
        boostManager.setOnModeChangedListener { mode ->
            val newRate = boostManager.getCurrentRate()
            sensorCollector.restart(newRate)
            Log.d(TAG, "Sampling mode changed: $mode (rate=$newRate)")
        }

        // Boost inference listener: run inference when boost triggers it
        boostManager.setOnBoostInferenceListener {
            serviceScope.launch {
                runInference(isBoostMeasurement = true)
            }
        }

        // Load TFLite model
        if (!detector.loadModel()) {
            Log.e(TAG, "Failed to load TFLite model")
            stopSelf()
            return
        }

    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // BUG 11 FIX: Handle null intent (system restart with START_STICKY)
        when (intent?.action) {
            ACTION_START -> {
                Log.d(TAG, "Starting detection service")
                startForegroundService()
                startMonitoring()
            }
            ACTION_STOP -> {
                Log.d(TAG, "Stopping detection service")
                stopMonitoring()
                stopSelf()
            }
            ACTION_BOOST -> {
                val reason = intent?.getStringExtra("reason") ?: "manual"
                Log.d(TAG, "Boost triggered: $reason")
                boostManager.triggerBoost(reason)
            }
            null -> {
                // System restarted the service — ensure foreground notification is shown
                Log.d(TAG, "Service restarted by system (null intent), resuming")
                startForegroundService()
                startMonitoring()
            }
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false // BUG 18 FIX
        Log.d(TAG, "Service destroyed")
        prefs.unregisterOnSharedPreferenceChangeListener(prefListener)
        stopMonitoring()
        detector.close()
        serviceScope.cancel()
    }

    /**
     * Start foreground service with persistent notification
     */
    private fun startForegroundService() {
        // Already called startForeground in onCreate (for 5s deadline)
        // Just update the notification text
        val notification = createNotification(
            title = "Detection active",
            text = "Monitoring sensors...",
            ongoing = true
        )
        notificationManager.notify(NOTIFICATION_ID, notification)
        Log.d(TAG, "Foreground notification updated")
    }

    /**
     * Start continuous monitoring
     */
    private fun startMonitoring() {
        // BUG 10 FIX: Guard against double-start
        if (isMonitoring) return
        isMonitoring = true

        // BUG 21 FIX: Initialize counters from database so they don't reset on service restart
        cigarettesDetected = database.getCountLastNDays(1)
        drinksDetected = database.getDrinkCountLastNDays(1)

        // Start sensor collection with current boost mode rate
        val started = sensorCollector.start(boostManager.getCurrentRate())
        if (!started) {
            Log.e(TAG, "Failed to start sensor collection")
            stopSelf()
            return
        }

        Log.d(TAG, "Sensor collection started (mode=${boostManager.getCurrentMode()})")

        // Start GPS clustering
        gpsManager.start()
        Log.d(TAG, "GPS clustering started")

        // Start Health Services (HR monitoring)
        serviceScope.launch {
            healthServices.start()
            Log.d(TAG, "Health Services started")
        }

        // Start periodic inference
        inferenceJob = serviceScope.launch {
            while (isActive) {
                delay(INFERENCE_INTERVAL_MS)
                runInference()
            }
        }

        Log.d(TAG, "Periodic inference started (every ${INFERENCE_INTERVAL_MS / 1000}s)")

        // Start periodic batch sync (every 30 minutes)
        syncJob = serviceScope.launch {
            while (isActive) {
                delay(SYNC_INTERVAL_MS)
                try {
                    messageSync.flushBuffer()
                } catch (e: Exception) {
                    Log.e(TAG, "Periodic sync failed", e)
                }
            }
        }
        Log.d(TAG, "Periodic sync started (every ${SYNC_INTERVAL_MS / 60000} min)")

        // Start phone connection listener (auto-flush buffer on reconnect)
        phoneListener.start(serviceScope)
        Log.d(TAG, "Phone connection listener started")
    }

    /**
     * Stop monitoring
     */
    private fun stopMonitoring() {
        isMonitoring = false // BUG 10 FIX
        inferenceJob?.cancel()
        syncJob?.cancel()
        phoneListener.stop()
        sensorCollector.stop()
        gpsManager.stop()
        healthServices.stop()
        boostManager.stop()
        Log.d(TAG, "Monitoring stopped")
    }

    /**
     * Run inference on recent sensor data
     */
    private suspend fun runInference(isBoostMeasurement: Boolean = false) {
        withContext(Dispatchers.Default) {
            try {
                Log.d(TAG, "Running inference...")

                // Get recent sensor data (1000 samples = 20s @ 50Hz)
                // Mirror axes if watch is on left wrist for consistent feature extraction
                val sensorData = sensorCollector.getRecentData(
                    numSamples = 1000,
                    mirrorForLeftWrist = isLeftWrist
                )

                // BUG 2 FIX: Skip inference if not enough sensor data yet
                if (sensorData == null) {
                    Log.d(TAG, "Not enough sensor data yet, skipping inference")
                    return@withContext
                }

                // Extract 30 features
                val features = featureExtractor.extractAllFeatures(
                    accel = sensorData.accelerometer,
                    gyro = sensorData.gyroscope,
                    timestamps = sensorData.timestamps,
                    hrBaseline = healthServices.getBaselineHR(), // Resting HR (7-day average)
                    hrCurrent = healthServices.getCurrentHR(),   // Current HR (real-time)
                    gpsCluster = gpsManager.getCurrentCluster(), // GPS clustering (home/work/bar/other)
                    proximitySmoking = 0.1f  // TODO: Get from geofencing
                )

                // Run TFLite inference with adaptive threshold
                var threshold = getDetectionThreshold()
                // Pattern-based threshold: lower during high-smoking hours
                if (database.isHighSmokingHour()) {
                    threshold = (threshold - 0.15f).coerceAtLeast(0.4f)
                    Log.d(TAG, "High-smoking hour: threshold lowered to $threshold")
                }
                val probabilities = detector.predict(features)
                val isCigarette = probabilities[SmokingDetector.CLASS_CIGARETTE] > threshold
                val isDrinking = probabilities[SmokingDetector.CLASS_DRINKING] > DRINK_THRESHOLD

                // Save raw window as training sample during boost mode
                if (isBoostMeasurement) {
                    val rawStr = sensorData.accelerometer.zip(sensorData.gyroscope)
                        .joinToString(",") { (a, g) -> "${a[0]},${a[1]},${a[2]},${g[0]},${g[1]},${g[2]}" }
                    val resultStr = probabilities.contentToString()
                    val label = if (boostManager.isInBoostMode()) "cigarette" else "unknown"
                    database.insertTrainingSample(
                        label = label,
                        rawData = rawStr,
                        inferenceResult = resultStr,
                        boostMeasurement = boostManager.getBoostMeasurementCount()
                    )
                }

                Log.d(TAG, "Inference: cig=$isCigarette drink=$isDrinking (threshold=$threshold), probs=${probabilities.contentToString()}")

                // Update notification
                updateNotification(
                    isCigarette = isCigarette,
                    isDrinking = isDrinking,
                    probabilities = probabilities
                )

                // Handle cigarette detection
                if (isCigarette) {
                    handleCigaretteDetected(
                        confidence = probabilities[0],
                        features = features
                    )
                }

                // Handle drink detection
                if (isDrinking) {
                    handleDrinkDetected(
                        confidence = probabilities[SmokingDetector.CLASS_DRINKING],
                        features = features
                    )
                }

            } catch (e: Exception) {
                Log.e(TAG, "Inference failed", e)
            }
        }
    }

    /**
     * Handle cigarette detection
     */
    private fun handleCigaretteDetected(confidence: Float, features: FloatArray) {
        val currentTime = System.currentTimeMillis()

        // Debounce: Ignore if detected within last 2 minutes
        if (currentTime - lastDetectionTime < 120_000) {
            Log.d(TAG, "Cigarette detected but debounced (too recent)")
            return
        }

        lastDetectionTime = currentTime
        cigarettesDetected++

        Log.d(TAG, "🚬 CIGARETTE DETECTED! Count: $cigarettesDetected, Confidence: ${(confidence * 100).toInt()}%")

        // Save to database
        val id = database.insertDetection(
            confidence = confidence,
            gpsCluster = gpsManager.getCurrentCluster(),
            hrBaseline = healthServices.getBaselineHR(),
            hrCurrent = healthServices.getCurrentHR(),
            features = features,
            wristLocation = if (isLeftWrist) "left" else "right",
            smokingHand = smokingHand
        )
        Log.d(TAG, "Detection saved to database: id=$id")

        // Record pattern for 24h learning
        database.recordSmokingPattern()

        // Sync to phone via Bluetooth MessageClient
        serviceScope.launch {
            try {
                messageSync.sendCigarette(
                    timestamp = currentTime,
                    confidence = confidence,
                    gpsCluster = gpsManager.getCurrentCluster(),
                    hrBaseline = healthServices.getBaselineHR(),
                    hrCurrent = healthServices.getCurrentHR()
                )
            } catch (e: Exception) {
                Log.e(TAG, "Sync failed, buffered for later", e)
            }
        }

        // Send notification
        sendCigaretteNotification(confidence)

        // Trigger boost sampling (5 minutes @ 100Hz)
        boostManager.triggerBoost("cigarette_detected")

        // TODO: Trigger +1 min gamification delay
    }

    /**
     * Handle drink detection
     */
    private fun handleDrinkDetected(confidence: Float, features: FloatArray) {
        val currentTime = System.currentTimeMillis()

        // Debounce: Ignore if detected within last 2 minutes
        if (currentTime - lastDrinkDetectionTime < 120_000) {
            Log.d(TAG, "Drink detected but debounced (too recent)")
            return
        }

        lastDrinkDetectionTime = currentTime
        drinksDetected++

        Log.d(TAG, "🍺 DRINK DETECTED! Count: $drinksDetected, Confidence: ${(confidence * 100).toInt()}%")

        // Save to database
        val id = database.insertDrinkDetection(
            confidence = confidence,
            gpsCluster = gpsManager.getCurrentCluster(),
            hrBaseline = healthServices.getBaselineHR(),
            hrCurrent = healthServices.getCurrentHR(),
            features = features,
            wristLocation = if (isLeftWrist) "left" else "right",
            smokingHand = smokingHand
        )
        Log.d(TAG, "Drink detection saved to database: id=$id")
        database.recordSmokingPattern() // Also track drink patterns

        // Sync to phone via Bluetooth MessageClient
        serviceScope.launch {
            try {
                messageSync.sendDrink(
                    drinkType = "auto",
                    timestamp = currentTime,
                    confidence = confidence,
                    gpsCluster = gpsManager.getCurrentCluster(),
                    hrBaseline = healthServices.getBaselineHR(),
                    hrCurrent = healthServices.getCurrentHR()
                )
            } catch (e: Exception) {
                Log.e(TAG, "Drink sync failed, buffered for later", e)
            }
        }

        // Send notification
        sendDrinkNotification(confidence)

        // Trigger boost sampling
        boostManager.triggerBoost("drink_detected")
    }

    /**
     * Get detection threshold based on smoking hand vs watch hand.
     *
     * Logic:
     * - "auto" → assume smoking hand = watch hand (most common case:
     *   right-handed → watch left, smokes left; left-handed → watch right, smokes right)
     *   → direct signal → high threshold (0.7)
     * - Smoking hand == watch hand → direct signal → high threshold (0.7)
     * - Smoking hand != watch hand → indirect signal → lower threshold (0.5)
     */
    private fun getDetectionThreshold(): Float {
        if (smokingHand == "auto") {
            return THRESHOLD_DIRECT
        }

        val watchHand = if (isLeftWrist) "left" else "right"
        return if (smokingHand == watchHand) THRESHOLD_DIRECT else THRESHOLD_INDIRECT
    }

    /**
     * Update ongoing notification with detection status
     */
    private fun updateNotification(isCigarette: Boolean, isDrinking: Boolean = false, probabilities: FloatArray) {
        val text = when {
            isCigarette -> "🚬 Détecté! (${(probabilities[0] * 100).toInt()}%)"
            isDrinking -> "🍺 Détecté! (${(probabilities[2] * 100).toInt()}%)"
            else -> "✓ 🚬 $cigarettesDetected | 🍺 $drinksDetected"
        }

        val notification = createNotification(
            title = "Smoking Detection Active",
            text = text,
            ongoing = true
        )

        notificationManager.notify(NOTIFICATION_ID, notification)
    }

    /**
     * Send cigarette detection alert notification
     */
    private fun sendCigaretteNotification(confidence: Float) {
        val notification = createNotification(
            title = "🚬 Cigarette Detected!",
            text = "Confidence: ${(confidence * 100).toInt()}% | Total: $cigarettesDetected",
            ongoing = false,
            priority = NotificationCompat.PRIORITY_HIGH
        )

        notificationManager.notify(NOTIFICATION_ID + 1, notification)
    }

    /**
     * Send drink detection alert notification
     */
    private fun sendDrinkNotification(confidence: Float) {
        val notification = createNotification(
            title = "🍺 Boisson détectée!",
            text = "Confiance: ${(confidence * 100).toInt()}% | Total: $drinksDetected",
            ongoing = false,
            priority = NotificationCompat.PRIORITY_HIGH
        )

        notificationManager.notify(NOTIFICATION_ID + 2, notification)
    }

    /**
     * Create notification
     */
    private fun createNotification(
        title: String,
        text: String,
        ongoing: Boolean,
        priority: Int = NotificationCompat.PRIORITY_LOW
    ): Notification {
        // Intent to open MainActivity
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Stop action
        val stopIntent = Intent(this, DetectionService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this,
            1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(android.R.drawable.ic_menu_info_details)
            .setContentIntent(pendingIntent)
            .setOngoing(ongoing)
            .setPriority(priority)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .apply {
                if (ongoing) {
                    addAction(
                        android.R.drawable.ic_menu_close_clear_cancel,
                        "Stop",
                        stopPendingIntent
                    )
                }
            }
            .build()
    }

    /**
     * Create notification channel (Android 8.0+)
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "Smoking Detection",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Continuous smoking detection monitoring"
                setShowBadge(false)
            }

            notificationManager.createNotificationChannel(channel)
            Log.d(TAG, "Notification channel created")
        }
    }
}
