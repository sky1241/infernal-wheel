package com.infernal.smokingdetector

import android.app.*
import android.content.Context
import android.content.Intent
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

        // Service actions
        const val ACTION_START = "com.infernal.smokingdetector.START"
        const val ACTION_STOP = "com.infernal.smokingdetector.STOP"

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
    private lateinit var notificationManager: NotificationManager

    private var serviceScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private var inferenceJob: Job? = null

    private var cigarettesDetected = 0
    private var lastDetectionTime = 0L

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service created")

        // Initialize components
        detector = SmokingDetector(this)
        sensorCollector = SensorDataCollector(this)
        featureExtractor = FeatureExtractor()
        gpsManager = GPSClusteringManager(this)
        healthServices = HealthServicesManager(this)
        database = DatabaseManager(this)
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Load TFLite model
        if (!detector.loadModel()) {
            Log.e(TAG, "Failed to load TFLite model")
            stopSelf()
            return
        }

        // Create notification channel
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
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
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        Log.d(TAG, "Service destroyed")
        stopMonitoring()
        detector.close()
        serviceScope.cancel()
    }

    /**
     * Start foreground service with persistent notification
     */
    private fun startForegroundService() {
        val notification = createNotification(
            title = "Smoking Detection Active",
            text = "Monitoring sensors...",
            ongoing = true
        )

        startForeground(NOTIFICATION_ID, notification)
        Log.d(TAG, "Foreground service started")
    }

    /**
     * Start continuous monitoring
     */
    private fun startMonitoring() {
        // Start sensor collection
        val started = sensorCollector.start()
        if (!started) {
            Log.e(TAG, "Failed to start sensor collection")
            stopSelf()
            return
        }

        Log.d(TAG, "Sensor collection started")

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
    }

    /**
     * Stop monitoring
     */
    private fun stopMonitoring() {
        inferenceJob?.cancel()
        sensorCollector.stop()
        gpsManager.stop()
        healthServices.stop()
        Log.d(TAG, "Monitoring stopped")
    }

    /**
     * Run inference on recent sensor data
     */
    private suspend fun runInference() {
        withContext(Dispatchers.Default) {
            try {
                Log.d(TAG, "Running inference...")

                // Get recent sensor data (1000 samples = 20s @ 50Hz)
                val sensorData = sensorCollector.getRecentData(numSamples = 1000)

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

                // Run TFLite inference
                val probabilities = detector.predict(features)
                val isCigarette = detector.isCigaretteDetected(features, threshold = 0.7f)

                Log.d(TAG, "Inference complete: cigarette=$isCigarette, probabilities=${probabilities.contentToString()}")

                // Update notification
                updateNotification(
                    isCigarette = isCigarette,
                    probabilities = probabilities
                )

                // Handle cigarette detection
                if (isCigarette) {
                    handleCigaretteDetected(
                        confidence = probabilities[0],
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
            features = features
        )
        Log.d(TAG, "Detection saved to database: id=$id")

        // Send notification
        sendCigaretteNotification(confidence)

        // TODO: Trigger +1 min gamification delay
    }

    /**
     * Update ongoing notification with detection status
     */
    private fun updateNotification(isCigarette: Boolean, probabilities: FloatArray) {
        val text = if (isCigarette) {
            "🚬 Cigarette detected! (${(probabilities[0] * 100).toInt()}%)"
        } else {
            "✓ No smoking | Count: $cigarettesDetected"
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
