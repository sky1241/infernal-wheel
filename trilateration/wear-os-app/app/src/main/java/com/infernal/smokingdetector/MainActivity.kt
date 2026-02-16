package com.infernal.smokingdetector

import android.Manifest
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

    private lateinit var statusText: TextView
    private lateinit var startButton: Button
    private lateinit var testButton: Button

    private var isCollecting = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // Initialize UI
        statusText = findViewById(R.id.statusText)
        startButton = findViewById(R.id.startButton)
        testButton = findViewById(R.id.testButton)

        // Initialize detector and sensor collector
        detector = SmokingDetector(this)
        sensorCollector = SensorDataCollector(this)

        // Load TFLite model
        if (detector.loadModel()) {
            updateStatus("Model loaded ✓")
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

        testButton.setOnClickListener {
            runTestInference()
        }
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
        detector.close()
    }
}
