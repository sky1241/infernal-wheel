package com.infernal.smokingdetector

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

/**
 * Main Activity for Wear OS Smoking Detection App
 *
 * Features:
 * - Load TFLite model
 * - Request sensor permissions
 * - Start/stop sensor data collection
 * - Run inference and display results
 */
class MainActivity : AppCompatActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val PERMISSION_REQUEST_CODE = 100
    }

    private lateinit var detector: SmokingDetector
    private lateinit var sensorCollector: SensorDataCollector
    private lateinit var featureExtractor: FeatureExtractor
    private lateinit var database: DatabaseManager
    private lateinit var boostManager: BoostSamplingManager
    private lateinit var prefs: SharedPreferences

    private lateinit var statusText: TextView
    private lateinit var startButton: Button
    private lateinit var monitorButton: Button
    private lateinit var detectButton: Button
    private lateinit var testButton: Button
    private lateinit var wristButton: Button
    private lateinit var handButton: Button

    private var isCollecting = false
    private var isMonitoring = false
    private var isLeftWrist = false
    private var smokingHand = "auto" // "auto", "left", "right"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize UI
        statusText = findViewById(R.id.statusText)
        startButton = findViewById(R.id.startButton)
        monitorButton = findViewById(R.id.monitorButton)
        detectButton = findViewById(R.id.detectButton)
        testButton = findViewById(R.id.testButton)

        // Initialize preferences
        prefs = getSharedPreferences("smoking_detector_prefs", Context.MODE_PRIVATE)
        isLeftWrist = prefs.getBoolean("is_left_wrist", false)
        smokingHand = prefs.getString("smoking_hand", "auto") ?: "auto"

        // Initialize detector, sensor collector, feature extractor, database, and boost manager
        detector = SmokingDetector(this)
        sensorCollector = SensorDataCollector(this)
        featureExtractor = FeatureExtractor()
        database = DatabaseManager(this)
        boostManager = BoostSamplingManager(this)

        // Setup boost mode listener
        boostManager.setOnModeChangedListener { mode ->
            if (isCollecting) {
                sensorCollector.restart(boostManager.getCurrentRate())
                updateStatus("Sampling mode: $mode")
            }
        }

        // Load TFLite model
        if (detector.loadModel()) {
            val totalCount = database.getTotalCount()
            val last7Days = database.getCountLastNDays(7)
            val avgPerDay = database.getAvgCigarettesPerDay()
            updateStatus("Model loaded ✓\n\n📊 Stats:\nTotal: $totalCount\nLast 7d: $last7Days\nAvg/day: ${"%.1f".format(avgPerDay)}")
        } else {
            updateStatus("Model load failed ✗")
        }

        // Check permissions
        if (!hasPermissions()) {
            requestPermissions()
        }

        // Button listeners
        startButton.setOnClickListener {
            toggleDataCollection()
        }

        monitorButton.setOnClickListener {
            toggleMonitoring()
        }

        detectButton.setOnClickListener {
            runRealInference()
        }

        testButton.setOnClickListener {
            runTestInference()
        }

        // Wrist toggle button
        wristButton = findViewById(R.id.wristButton)
        updateWristButtonText()
        wristButton.setOnClickListener {
            isLeftWrist = !isLeftWrist
            prefs.edit().putBoolean("is_left_wrist", isLeftWrist).apply()
            updateWristButtonText()
            Log.d(TAG, "Wrist set to: ${if (isLeftWrist) "LEFT" else "RIGHT"}")
        }

        // Smoking hand toggle button
        handButton = findViewById(R.id.handButton)
        updateHandButtonText()
        handButton.setOnClickListener {
            smokingHand = when (smokingHand) {
                "auto" -> "left"
                "left" -> "right"
                else -> "auto"
            }
            prefs.edit().putString("smoking_hand", smokingHand).apply()
            updateHandButtonText()
            Log.d(TAG, "Smoking hand set to: $smokingHand")
        }
    }

    private fun updateWristButtonText() {
        wristButton.text = if (isLeftWrist) "Poignet: G" else "Poignet: D"
    }

    private fun updateHandButtonText() {
        handButton.text = when (smokingHand) {
            "left" -> "Fume: G"
            "right" -> "Fume: D"
            else -> "Fume: Auto"
        }
    }

    private fun getDetectionThreshold(): Float {
        if (smokingHand == "auto") return 0.7f
        val watchHand = if (isLeftWrist) "left" else "right"
        return if (smokingHand == watchHand) 0.7f else 0.5f
    }

    /**
     * Toggle sensor data collection
     */
    private fun toggleDataCollection() {
        if (!hasPermissions()) {
            requestPermissions()
            return
        }

        isCollecting = if (isCollecting) {
            sensorCollector.stop()
            startButton.text = "Start"
            updateStatus("Stopped")
            false
        } else {
            val started = sensorCollector.start()
            if (started) {
                startButton.text = "Stop"
                updateStatus("Collecting...")
                true
            } else {
                updateStatus("Failed to start sensors")
                false
            }
        }
    }

    /**
     * Toggle continuous monitoring (foreground service)
     */
    private fun toggleMonitoring() {
        if (!hasPermissions()) {
            requestPermissions()
            return
        }

        isMonitoring = if (isMonitoring) {
            DetectionService.stop(this)
            monitorButton.text = "Start Monitor"
            updateStatus("Monitoring stopped")
            false
        } else {
            DetectionService.start(this)
            monitorButton.text = "Stop Monitor"
            updateStatus("Monitoring active ✓")
            true
        }
    }

    /**
     * Run test inference with dummy data
     */
    private fun runTestInference() {
        Log.d(TAG, "Running test inference with dummy data")

        // Create dummy 30 features (zeros)
        val dummyFeatures = FloatArray(30) { 0f }

        // Run inference
        val probabilities = detector.predict(dummyFeatures)
        val predictedClass = detector.predictClassName(dummyFeatures)

        // Display results
        val result = buildString {
            append("Prediction: $predictedClass\n\n")
            append("Probabilities:\n")
            append("Cigarette: ${(probabilities[0] * 100).toInt()}%\n")
            append("Eating: ${(probabilities[1] * 100).toInt()}%\n")
            append("Drinking: ${(probabilities[2] * 100).toInt()}%\n")
            append("Other: ${(probabilities[3] * 100).toInt()}%")
        }

        updateStatus(result)
        Log.d(TAG, "Test inference: $predictedClass, probabilities=${probabilities.contentToString()}")
    }

    /**
     * Run real inference with sensor data + feature extraction
     */
    private fun runRealInference() {
        if (!isCollecting) {
            updateStatus("Start sensors first!")
            return
        }

        // Trigger boost mode (user-initiated detection)
        boostManager.triggerBoost("manual_detection")

        Log.d(TAG, "Running real inference with sensor data")
        updateStatus("Extracting features...")

        try {
            // Get recent sensor data (1000 samples = 20 seconds @ 50Hz)
            // Mirror axes if watch is on left wrist
            val sensorData = sensorCollector.getRecentData(
                numSamples = 1000,
                mirrorForLeftWrist = isLeftWrist
            )

            // Extract 30 features
            val features = featureExtractor.extractAllFeatures(
                accel = sensorData.accelerometer,
                gyro = sensorData.gyroscope,
                timestamps = sensorData.timestamps,
                hrBaseline = 70f,  // TODO: Get from Health Services API
                hrCurrent = 70f,   // TODO: Get from Health Services API
                gpsCluster = 3,    // TODO: Get from GPS clustering
                proximitySmoking = 0.1f  // TODO: Get from geofencing
            )

            Log.d(TAG, "Features extracted: ${features.contentToString()}")

            // Run inference (use dynamic threshold based on wrist/hand config)
            val probabilities = detector.predict(features)
            val predictedClass = SmokingDetector.CLASS_NAMES[
                probabilities.indices.maxByOrNull { probabilities[it] } ?: SmokingDetector.CLASS_OTHER
            ]
            val threshold = getDetectionThreshold()
            val isCigarette = probabilities[SmokingDetector.CLASS_CIGARETTE] > threshold

            // Display results
            val result = buildString {
                append("🔍 DETECTION RESULT\n\n")
                append("Prediction: $predictedClass\n")
                if (isCigarette) {
                    append("⚠️ CIGARETTE DETECTED!\n\n")
                } else {
                    append("✓ No cigarette\n\n")
                }
                append("Probabilities:\n")
                append("🚬 Cigarette: ${(probabilities[0] * 100).toInt()}%\n")
                append("🍽 Eating: ${(probabilities[1] * 100).toInt()}%\n")
                append("🍷 Drinking: ${(probabilities[2] * 100).toInt()}%\n")
                append("👌 Other: ${(probabilities[3] * 100).toInt()}%")
            }

            updateStatus(result)
            Log.d(TAG, "Real inference: $predictedClass, cigarette=$isCigarette (threshold=$threshold), probabilities=${probabilities.contentToString()}")

        } catch (e: Exception) {
            Log.e(TAG, "Inference failed", e)
            updateStatus("Error: ${e.message}")
        }
    }

    /**
     * Update status text
     */
    private fun updateStatus(message: String) {
        runOnUiThread {
            statusText.text = message
        }
    }

    /**
     * Check if all required permissions are granted
     */
    private fun hasPermissions(): Boolean {
        val permissions = arrayOf(
            Manifest.permission.BODY_SENSORS,
            Manifest.permission.ACTIVITY_RECOGNITION,
            Manifest.permission.ACCESS_FINE_LOCATION
        )

        return permissions.all {
            ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED
        }
    }

    /**
     * Request required permissions
     */
    private fun requestPermissions() {
        val permissions = arrayOf(
            Manifest.permission.BODY_SENSORS,
            Manifest.permission.ACTIVITY_RECOGNITION,
            Manifest.permission.ACCESS_FINE_LOCATION
        )

        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == PERMISSION_REQUEST_CODE) {
            val allGranted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }

            if (allGranted) {
                updateStatus("Permissions granted ✓")
            } else {
                updateStatus("Permissions denied ✗")
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorCollector.stop()
        boostManager.stop()
        detector.close()
    }
}
