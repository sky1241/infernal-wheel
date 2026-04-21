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

        // 25Hz parasitic flow params (Phase 2 of war plan)
        private const val RING_BUFFER_25HZ = 200            // ~8s of signal at 25Hz
        private const val MIN_INFERENCE_INTERVAL_25HZ_MS = 4_000L  // Don't run more than once per 4s

        // 3-stage detection pipeline:
        //   Stage 1 (IDLE):     CNN léger tourne, watches for cigProb spike
        //   Stage 2 (OBSERVING): 1 minute of trilatération multi-signaux
        //                        to confirm the spike is real, not a false positive
        //   Stage 3 (FULL):     5 minutes of deep observation + data collection
        //                        → if confirmed: +1 cigarette
        //                        → if not: return to IDLE, 0 cigarette
        private const val OBSERVATION_DURATION_MS = 60_000L    // 1 minute
        private const val FULL_OBSERVATION_DURATION_MS = 5 * 60_000L // 5 minutes
        private const val OBSERVATION_CONFIRM_THRESHOLD = 3    // need 3+ high-prob windows in 1 min
        private const val FULL_CONFIRM_THRESHOLD = 5           // need 5+ high-prob windows in 5 min

        // Bootstrap window: while we don't have a learned smoking-hour profile yet,
        // let the first BOOTSTRAP_BATCHES samples through the temporal filter so the
        // CNN actually runs and we can validate the pipeline (and start collecting
        // detections that feed pattern learning). After that, the filter takes over.
        // 50 batches × ~12s/batch ≈ 10 minutes of unfiltered inference on first run.
        private const val BOOTSTRAP_BATCHES = 50

        // Number of batches we log for diagnostic purposes (avoids log spam after).
        private const val BOOTSTRAP_LOG_BATCHES = 10

        // HR confirmation — recheck 2 minutes after detection to see if HR
        // has risen by at least this delta compared to the 3-5 min baseline.
        // 5 bpm is the conservative lower bound of the documented nicotine
        // HR response (5-15 bpm typical).
        private const val HR_CONFIRMATION_DELAY_MS: Long = 2 * 60 * 1000L
        private const val HR_CONFIRMATION_DELTA_BPM: Float = 5.0f

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

    // Samsung Health Sensor SDK — parasitic 25Hz accel flow (Phase 2 of war plan)
    private lateinit var samsungAccel: SamsungHealthAccelerometer

    // Sequence detector — replaces single-threshold triggering with
    // a temporal pattern match over the last 6 minutes of inferences.
    // See SequenceDetector.kt for the rationale.
    private val sequenceDetector = SequenceDetector()

    // 3-stage detection state machine
    private enum class DetectionStage { IDLE, OBSERVING, FULL }
    @Volatile private var detectionStage = DetectionStage.IDLE
    @Volatile private var stageStartMs = 0L
    @Volatile private var stageHighProbCount = 0  // high cigProb windows in current stage
    @Volatile private var stageHrDeltaSum = 0f    // accumulated HR delta during stage

    /**
     * Ring buffer for 25Hz accel samples coming from Samsung SDK.
     * Keeps the last RING_BUFFER_25HZ samples (~8s of signal) so we can
     * always extract the most recent CNN window of 112 samples.
     */
    private val ring25HzBuffer = ArrayDeque<FloatArray>(RING_BUFFER_25HZ)
    private val ring25HzLock = Object()
    @Volatile private var lastInference25HzMs = 0L
    // Total number of batches received since service start. Drives the bootstrap
    // window (skip temporal filter until we have enough history to learn from).
    // MUST increment on every batch, independently of log spam throttling.
    private var totalBatchesReceived: Long = 0L
    // Logging is throttled to the first BOOTSTRAP_LOG_BATCHES to avoid spam.
    // Separate counter from totalBatchesReceived — see BUG FIX #1 in CHANGELOG.
    private var loggedBatchCount: Int = 0

    private var serviceScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private var inferenceJob: Job? = null
    private var syncJob: Job? = null

    private lateinit var prefs: SharedPreferences
    private var isLeftWrist = false
    private var smokingHand = "auto"
    // BUG+031 fix: counters + debounce timestamps are mutated from 3 concurrent
    // paths (periodic 50Hz inference, 25Hz Samsung callback, boost listener).
    // Atomic types give us a race-free check-then-update for the 2-min debounce
    // and a safe increment for the UI counters.
    @Volatile private var cigarettesDetected = 0
    @Volatile private var drinksDetected = 0
    private val lastDetectionTime = java.util.concurrent.atomic.AtomicLong(0L)
    private val lastDrinkDetectionTime = java.util.concurrent.atomic.AtomicLong(0L)
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
        samsungAccel = SamsungHealthAccelerometer(this)

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

        // Load TFLite model. If this fails we abort the service via stopSelf()
        // — onDestroy() will then run on a partially-initialized service, which
        // is exactly the scenario stopMonitoring()'s isInitialized guards
        // protect against. Without those guards, the failed model load would
        // crash the JVM and mask the original error.
        if (!detector.loadModel()) {
            Log.e(TAG, "Failed to load TFLite model — service will stop")
            stopSelf()
            return
        }

        // Set normalization params per model format
        when (detector.getModelFormat()) {
            SmokingDetector.ModelFormat.CNN_50HZ_6CH -> {
                // v5: 50Hz / 6 channels (Acc + Gyro)
                detector.setNormalization(
                    mean = floatArrayOf(0.5848f, -4.4789f, 4.7827f, -0.0013f, -0.0012f, -0.0017f),
                    std = floatArrayOf(5.3890f, 3.7457f, 3.6576f, 0.5993f, 0.3300f, 0.5065f)
                )
                Log.d(TAG, "Normalization set for CNN_50HZ_6CH (v5)")
            }
            SmokingDetector.ModelFormat.CNN_25HZ_3CH -> {
                // v6: 25Hz / 3 channels (Acc only)
                // From normalization_params_v6_25hz.npz (CV F1=0.410 — generic baseline,
                // designed to be fine-tuned per user via Phase 1 hard-code data)
                detector.setNormalization(
                    mean = floatArrayOf(-0.5455f, -3.4465f, 3.5015f),
                    std = floatArrayOf(4.2177f, 4.4892f, 5.9296f)
                )
                Log.d(TAG, "Normalization set for CNN_25HZ_3CH (v6)")
            }
            else -> { /* feature model — no normalization needed */ }
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
                // Inside this branch the `when (intent?.action)` already
                // proved intent is non-null (otherwise we'd be in the null
                // branch below), so the safe-call would be redundant here.
                val reason = intent.getStringExtra("reason") ?: "manual"
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
        // Defensive: every lateinit access must be guarded because onCreate()
        // can fail partway through (e.g. TFLite load fails) and trigger an
        // immediate stopSelf() → onDestroy() → these properties may not yet
        // be initialized. Crashing here would mask the real onCreate error.
        if (::prefs.isInitialized) {
            try { prefs.unregisterOnSharedPreferenceChangeListener(prefListener) } catch (e: Exception) {
                Log.w(TAG, "unregister prefListener failed", e)
            }
        }
        try { stopMonitoring() } catch (e: Exception) { Log.w(TAG, "stopMonitoring failed in onDestroy", e) }
        if (::detector.isInitialized) {
            try { detector.close() } catch (e: Exception) { Log.w(TAG, "detector.close failed", e) }
        }
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
            // Roll back the isMonitoring flag — otherwise a subsequent
            // startMonitoring() call after recovery would early-return
            // and the service would silently never resume.
            isMonitoring = false
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

        // Phase 2 of war plan: connect Samsung Health Sensor SDK 25Hz parasitic flow
        // (no-op if SDK AAR not yet installed in app/libs/)
        if (samsungAccel.isSdkAvailable()) {
            samsungAccel.connect { samples, timestampNs ->
                onSamsung25HzBatch(samples, timestampNs)
            }
            Log.d(TAG, "Samsung 25Hz parasitic flow connected")
        } else {
            Log.w(TAG, "Samsung Health Sensor SDK absent — running 50Hz boost only")
        }
    }

    /**
     * Stop monitoring. Every lateinit access must be guarded because this can
     * be called from onDestroy() during a partially-initialized teardown
     * (e.g. when TFLite fails to load and onCreate aborts midway).
     */
    private fun stopMonitoring() {
        isMonitoring = false // BUG 10 FIX
        inferenceJob?.cancel()
        syncJob?.cancel()
        if (::phoneListener.isInitialized) {
            try { phoneListener.stop() } catch (e: Exception) { Log.w(TAG, "phoneListener.stop failed", e) }
        }
        if (::sensorCollector.isInitialized) {
            try { sensorCollector.stop() } catch (e: Exception) { Log.w(TAG, "sensorCollector.stop failed", e) }
        }
        if (::gpsManager.isInitialized) {
            try { gpsManager.stop() } catch (e: Exception) { Log.w(TAG, "gpsManager.stop failed", e) }
        }
        if (::healthServices.isInitialized) {
            try { healthServices.stop() } catch (e: Exception) { Log.w(TAG, "healthServices.stop failed", e) }
        }
        if (::boostManager.isInitialized) {
            try { boostManager.stop() } catch (e: Exception) { Log.w(TAG, "boostManager.stop failed", e) }
        }
        if (::samsungAccel.isInitialized) {
            try { samsungAccel.disconnect() } catch (e: Exception) { Log.w(TAG, "samsungAccel.disconnect failed", e) }
        }
        synchronized(ring25HzLock) { ring25HzBuffer.clear() }
        sequenceDetector.reset()
        Log.d(TAG, "Monitoring stopped")
    }

    /**
     * Callback invoked by SamsungHealthAccelerometer for each batch of 25Hz samples.
     *
     * Pipeline:
     *   1. Push samples into the ring buffer
     *   2. Apply temporal filter — skip if not in a learned smoking hour
     *   3. Apply rate limiter — at most one inference per MIN_INFERENCE_INTERVAL_25HZ_MS
     *   4. Run CNN 25Hz on the most recent 112-sample window
     *   5. Handle detection (debounce + DB + sync + notification)
     */
    private fun onSamsung25HzBatch(samples: Array<FloatArray>, @Suppress("UNUSED_PARAMETER") timestampNs: Long) {
        // 1. Push into ring buffer — O(1) per sample thanks to ArrayDeque
        val newBufSize: Int
        synchronized(ring25HzLock) {
            for (s in samples) {
                if (ring25HzBuffer.size >= RING_BUFFER_25HZ) {
                    ring25HzBuffer.removeFirst()  // O(1) on ArrayDeque
                }
                ring25HzBuffer.addLast(s)
            }
            newBufSize = ring25HzBuffer.size
        }

        // Increment total batch counter — drives the bootstrap window.
        // This MUST happen on every batch, unlike the log throttle below.
        totalBatchesReceived++

        // Diagnostic log — throttled to the first BOOTSTRAP_LOG_BATCHES to avoid spam.
        if (loggedBatchCount < BOOTSTRAP_LOG_BATCHES) {
            Log.i(TAG, "[25Hz] received batch of ${samples.size} samples, ring=$newBufSize/$RING_BUFFER_25HZ total=$totalBatchesReceived")
            loggedBatchCount++
        }

        // 2. Sleep filter — skip inference when the user is asleep.
        //
        //    Design: the CNN léger runs H24 EXCEPT during sleep. The
        //    GaussianHourPattern does NOT gate on/off — it only adjusts
        //    the SequenceDetector threshold (fewer peaks required during
        //    high-smoking hours). This way the detection works at ANY
        //    hour, including unusual ones (late-night party, early morning).
        //
        //    Sleep detection uses REAL HR data from HealthServicesManager:
        //    when HR is consistently low (< baseline+3), stable (std < 3),
        //    and below 65 bpm for the last 5 minutes → user is asleep.
        //    This works regardless of clock time: a 15h nap is caught,
        //    and a 3am party keeps the CNN running.
        //
        //    Fallback when HR data is not available: use clock hour as
        //    approximation (0h-6h only).
        if (healthServices.isSleeping) {
            return
        }

        // 3. Rate limiter
        val now = System.currentTimeMillis()
        if (now - lastInference25HzMs < MIN_INFERENCE_INTERVAL_25HZ_MS) {
            return
        }
        lastInference25HzMs = now

        // 4. Run inference asynchronously
        serviceScope.launch {
            runInference25Hz()
        }
    }

    /**
     * Inference path for the 25Hz / 3-channel CNN model (v6).
     * Pulls the last 112 samples from the ring buffer and feeds them to the model.
     */
    private suspend fun runInference25Hz() = withContext(Dispatchers.Default) {
        if (detector.getModelFormat() != SmokingDetector.ModelFormat.CNN_25HZ_3CH) {
            // Wrong model loaded — silently skip
            return@withContext
        }

        // Snapshot last WINDOW_SAMPLES_25HZ samples from ring buffer
        val window: Array<FloatArray> = synchronized(ring25HzLock) {
            if (ring25HzBuffer.size < SmokingDetector.WINDOW_SAMPLES_25HZ) return@withContext
            val start = ring25HzBuffer.size - SmokingDetector.WINDOW_SAMPLES_25HZ
            Array(SmokingDetector.WINDOW_SAMPLES_25HZ) { i -> ring25HzBuffer[start + i].copyOf() }
        }

        try {
            val probs = detector.predictRaw25Hz(window)
            val cigProb = probs[SmokingDetector.CLASS_CIGARETTE]
            val nowMs = System.currentTimeMillis()

            // Hour pattern score for threshold adjustment
            val gaussianPattern = database.getGaussianPattern()
            val cal = java.util.Calendar.getInstance()
            val minuteOfDay = cal.get(java.util.Calendar.HOUR_OF_DAY) * 60 +
                cal.get(java.util.Calendar.MINUTE)
            val hourScore = gaussianPattern.score(minuteOfDay)
            val isHighSmokingHour = hourScore > 0.5f

            // Adaptive peak threshold: lower during known smoking hours
            val peakThreshold = if (isHighSmokingHour) 0.40f else 0.50f
            val isHighProb = cigProb >= peakThreshold

            // HR delta (real-time)
            val hrDelta = healthServices.getCurrentHR() - healthServices.getBaselineHR()

            // ── 3-STAGE DETECTION PIPELINE ──
            when (detectionStage) {

                DetectionStage.IDLE -> {
                    // Stage 1: CNN léger watches for a spike
                    Log.d(TAG, "25Hz [IDLE] cigProb=${"%.3f".format(cigProb)} peak=$isHighProb")
                    if (isHighProb) {
                        // Spike detected → enter 1-minute observation
                        detectionStage = DetectionStage.OBSERVING
                        stageStartMs = nowMs
                        stageHighProbCount = 1
                        stageHrDeltaSum = hrDelta
                        Log.i(TAG, "[STAGE] IDLE → OBSERVING (cigProb=${"%.3f".format(cigProb)})")
                    }
                }

                DetectionStage.OBSERVING -> {
                    // Stage 2: 1 minute of trilatération observation
                    val elapsed = nowMs - stageStartMs
                    if (isHighProb) stageHighProbCount++
                    stageHrDeltaSum += hrDelta

                    Log.d(TAG, "25Hz [OBSERVING] cigProb=${"%.3f".format(cigProb)} " +
                        "peaks=$stageHighProbCount/$OBSERVATION_CONFIRM_THRESHOLD " +
                        "elapsed=${elapsed / 1000}s/60s hrDelta=${"%.1f".format(hrDelta)}")

                    if (elapsed >= OBSERVATION_DURATION_MS) {
                        // 1 minute is up — decide
                        if (stageHighProbCount >= OBSERVATION_CONFIRM_THRESHOLD) {
                            // Enough peaks in 1 min → go to full observation
                            detectionStage = DetectionStage.FULL
                            stageStartMs = nowMs
                            // Keep the accumulated counts, continue counting
                            Log.i(TAG, "[STAGE] OBSERVING → FULL " +
                                "(peaks=$stageHighProbCount, avgHrDelta=${"%.1f".format(stageHrDeltaSum / stageHighProbCount)})")
                            // Trigger boost sampling for better data collection
                            boostManager.triggerBoost("observation_confirmed")
                        } else {
                            // Not enough peaks → false alarm, back to idle
                            Log.i(TAG, "[STAGE] OBSERVING → IDLE (only $stageHighProbCount peaks, threshold=$OBSERVATION_CONFIRM_THRESHOLD)")
                            detectionStage = DetectionStage.IDLE
                            stageHighProbCount = 0
                            stageHrDeltaSum = 0f
                        }
                    }
                }

                DetectionStage.FULL -> {
                    // Stage 3: 5 minutes of deep observation
                    val elapsed = nowMs - stageStartMs
                    if (isHighProb) stageHighProbCount++
                    stageHrDeltaSum += hrDelta

                    Log.d(TAG, "25Hz [FULL] cigProb=${"%.3f".format(cigProb)} " +
                        "peaks=$stageHighProbCount/$FULL_CONFIRM_THRESHOLD " +
                        "elapsed=${elapsed / 1000}s/300s hrDelta=${"%.1f".format(hrDelta)}")

                    if (elapsed >= FULL_OBSERVATION_DURATION_MS) {
                        // 5 minutes is up — final decision
                        val avgHrDelta = if (stageHighProbCount > 0) stageHrDeltaSum / stageHighProbCount else 0f
                        val gpsCluster = gpsManager.getCurrentCluster()
                        val gpsConfirms = gpsCluster != GPSClusteringManager.CLUSTER_OTHER
                        val hrConfirms = avgHrDelta >= 4.0f

                        Log.i(TAG, "[FULL DECISION] peaks=$stageHighProbCount " +
                            "avgHrDelta=${"%.1f".format(avgHrDelta)} hrOK=$hrConfirms " +
                            "gps=$gpsCluster gpsOK=$gpsConfirms hour=$isHighSmokingHour")

                        if (stageHighProbCount >= FULL_CONFIRM_THRESHOLD) {
                            // CONFIRMED — real cigarette
                            Log.i(TAG, "[DETECTION] CONFIRMED — +1 cigarette " +
                                "(peaks=$stageHighProbCount, avgHrDelta=${"%.1f".format(avgHrDelta)})")
                            captureTrainingWindow(
                                label = "auto_detected",
                                confidence = cigProb
                            )
                            handleCigaretteDetected(
                                confidence = cigProb,
                                features = FloatArray(30)
                            )
                        } else {
                            // Not confirmed — false positive
                            Log.i(TAG, "[DETECTION] REJECTED — not enough peaks in full observation " +
                                "(peaks=$stageHighProbCount < $FULL_CONFIRM_THRESHOLD)")
                            captureTrainingWindow(
                                label = "uncertain_no_confirm",
                                confidence = cigProb
                            )
                        }

                        // Back to idle
                        detectionStage = DetectionStage.IDLE
                        stageHighProbCount = 0
                        stageHrDeltaSum = 0f
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "25Hz inference failed", e)
        }
    }

    /**
     * Snapshot the current 25Hz ring buffer and ship it to the phone as
     * labelled training data. The watch never persists training windows
     * long-term — MessageSyncManager handles the offline buffer + flush
     * on reconnect, then cleans up.
     *
     * @param label  "auto_detected" | "manual_only" | "auto_confirmed_by_manual"
     * @param confidence  CNN cigarette probability at the moment of detection
     */
    private fun captureTrainingWindow(label: String, confidence: Float) {
        val snapshot: Array<FloatArray> = synchronized(ring25HzLock) {
            if (ring25HzBuffer.isEmpty()) return
            Array(ring25HzBuffer.size) { i -> ring25HzBuffer[i].copyOf() }
        }

        Log.i(TAG, "[TRAINING] Capturing window: label=$label conf=$confidence samples=${snapshot.size}")

        serviceScope.launch {
            try {
                messageSync.sendTrainingWindow(
                    accel = snapshot,
                    label = label,
                    confidence = confidence
                )
            } catch (e: Exception) {
                Log.e(TAG, "Training window send failed (will be buffered)", e)
            }
        }
    }

    /**
     * Run inference on recent sensor data
     */
    private suspend fun runInference(isBoostMeasurement: Boolean = false) {
        withContext(Dispatchers.Default) {
            try {
                // When the loaded model is the 25Hz one, the periodic 50Hz path is
                // a no-op — Samsung's batched flow drives runInference25Hz instead.
                // Skipping here avoids spamming "predictRaw on non-50Hz model" logs.
                if (detector.getModelFormat() == SmokingDetector.ModelFormat.CNN_25HZ_3CH) {
                    return@withContext
                }

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
                // Run inference: raw CNN (v5) or features (v2)
                val probabilities = if (detector.isRawSignalModel()) {
                    detector.predictRaw(sensorData.accelerometer, sensorData.gyroscope)
                } else {
                    detector.predict(features)
                }
                val isCigarette = probabilities[SmokingDetector.CLASS_CIGARETTE] > threshold
                val isDrinking = probabilities[SmokingDetector.CLASS_DRINKING] > DRINK_THRESHOLD

                // Save training sample during boost mode
                // Store extracted features (120 bytes) instead of raw signals (5400 bytes)
                // Raw signals are sent to phone for heavy retraining
                if (isBoostMeasurement) {
                    val featuresStr = features.joinToString(",")
                    val resultStr = probabilities.contentToString()
                    val label = if (boostManager.isInBoostMode()) "cigarette" else "unknown"
                    database.insertTrainingSample(
                        label = label,
                        rawData = featuresStr,
                        inferenceResult = resultStr,
                        boostMeasurement = boostManager.getBoostMeasurementCount()
                    )
                    Log.d(TAG, "Training sample saved (features, measurement ${boostManager.getBoostMeasurementCount()})")
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

        // BUG+031 fix: atomic check-then-set. Two inference paths arriving
        // in the same millisecond window could both read a stale
        // lastDetectionTime and BOTH pass the 120s check → double DB insert,
        // double sync, double notification. AtomicLong.compareAndSet only
        // lets ONE thread through per debounce window.
        while (true) {
            val prev = lastDetectionTime.get()
            if (currentTime - prev < 120_000) {
                Log.d(TAG, "Cigarette detected but debounced (too recent)")
                return
            }
            if (lastDetectionTime.compareAndSet(prev, currentTime)) break
            // Another thread updated it between our read and CAS — retry.
        }
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

        // Note: boost sampling is already triggered by the 3-stage pipeline
        // at OBSERVING → FULL transition (line 594). No need to re-trigger
        // here — doing so would reset the boost timer mid-collection.

        // Schedule a heart-rate confirmation recheck 2 minutes after detection.
        // Nicotine causes HR to rise 5-15 bpm within 120 seconds of the first
        // puff. If we see that rise, the detection is marked HR_CONFIRMED and
        // its trust score is boosted (used later for fine-tuning label quality).
        scheduleHrConfirmation(detectionId = id, detectionTimestamp = currentTime)

        // TODO: Trigger +1 min gamification delay
    }

    /**
     * Re-read heart rate 2 minutes after a detection and update the DB record
     * with whether HR actually rose by >= HR_CONFIRMATION_DELTA_BPM bpm.
     *
     * This is the second independent signal in the detection stack:
     *   1. CNN sequence detector (visual pattern of hand-to-mouth puffs)
     *   2. HR delta 2 min after detection (physiological response to nicotine)
     *   3. Temporal pattern gaussian (learned smoking hours)
     *
     * All three are independent — a false positive would need to coincidentally
     * trigger all three, which is extremely unlikely in normal daily activity.
     */
    private fun scheduleHrConfirmation(detectionId: Long, detectionTimestamp: Long) {
        serviceScope.launch {
            try {
                delay(HR_CONFIRMATION_DELAY_MS)

                val hrRise = healthServices.getHRRiseOverLast(
                    lookbackStartMs = 3 * 60 * 1000L,  // baseline window = 3-5 min ago
                    lookbackEndMs = 2 * 60 * 1000L     // recent window = last 2 min
                )
                val confirmed = hrRise >= HR_CONFIRMATION_DELTA_BPM
                // Sanity: log how long ago the detection was, to make sure
                // we're really 2 minutes after — useful when investigating
                // logs in case the recheck fires early due to coroutine quirks.
                val ageMs = System.currentTimeMillis() - detectionTimestamp

                Log.i(
                    TAG,
                    "[HR CONFIRM] detectionId=$detectionId age=${ageMs}ms " +
                        "hrRise=${"%.2f".format(hrRise)} bpm " +
                        "threshold=$HR_CONFIRMATION_DELTA_BPM confirmed=$confirmed"
                )

                // Update the detection record so the fine-tuner knows whether
                // to treat this as a high-confidence or low-confidence sample.
                database.updateDetectionHrConfirmation(
                    detectionId = detectionId,
                    hrRise = hrRise,
                    confirmed = confirmed
                )
            } catch (e: kotlinx.coroutines.CancellationException) {
                // Service was stopped during the 2-minute delay. This is normal
                // — don't log as error. The DB row stays at its default
                // hr_confirmed=0 which is the correct safe value.
                Log.d(TAG, "HR confirmation cancelled for detection $detectionId (service stopping)")
                throw e  // re-throw so the coroutine cleans up properly
            } catch (e: Exception) {
                Log.e(TAG, "HR confirmation recheck failed for detection $detectionId", e)
            }
        }
    }

    /**
     * Handle drink detection
     */
    private fun handleDrinkDetected(confidence: Float, features: FloatArray) {
        val currentTime = System.currentTimeMillis()

        // BUG+031 fix: same atomic CAS pattern as the cigarette path.
        while (true) {
            val prev = lastDrinkDetectionTime.get()
            if (currentTime - prev < 120_000) {
                Log.d(TAG, "Drink detected but debounced (too recent)")
                return
            }
            if (lastDrinkDetectionTime.compareAndSet(prev, currentTime)) break
        }
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
