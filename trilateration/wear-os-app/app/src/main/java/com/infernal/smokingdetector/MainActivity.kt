package com.infernal.smokingdetector

import android.Manifest
import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.*
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.infernal.smokingdetector.ui.InfernalWearTheme
import com.infernal.smokingdetector.ui.MainScreen
import com.infernal.smokingdetector.ui.SettingsScreen

/**
 * Main Activity for Wear OS Smoking Detection App
 * Refactored: Compose M3 Wear UI with proper UX hierarchy
 *
 * Design rules applied (WEARABLE.md):
 * - Single primary CTA per screen (section B)
 * - ScalingLazyColumn for round screens (section 8c)
 * - OLED black background (section E)
 * - 48dp touch targets (section B)
 * - Settings in separate screen (section 9)
 * - Horologist 26.5dp padding (section 8)
 */
class MainActivity : ComponentActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val PERMISSION_REQUEST_CODE = 100
        private const val THRESHOLD_DIRECT = 0.7f
        private const val THRESHOLD_INDIRECT = 0.5f
    }

    private lateinit var detector: SmokingDetector
    private lateinit var sensorCollector: SensorDataCollector
    private lateinit var featureExtractor: FeatureExtractor
    private lateinit var database: DatabaseManager
    private lateinit var boostManager: BoostSamplingManager
    private lateinit var prefs: SharedPreferences

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize backend
        prefs = getSharedPreferences("smoking_detector_prefs", Context.MODE_PRIVATE)
        detector = SmokingDetector(this)
        sensorCollector = SensorDataCollector(this)
        featureExtractor = FeatureExtractor()
        database = DatabaseManager(this)
        boostManager = BoostSamplingManager(this)

        // Load model
        val modelLoaded = detector.loadModel()
        Log.d(TAG, "Model loaded: $modelLoaded")

        // Check permissions
        if (!hasPermissions()) {
            requestPermissions()
        }

        setContent {
            InfernalWearTheme {
                WearApp()
            }
        }
    }

    @Composable
    private fun WearApp() {
        // State
        var currentScreen by remember { mutableStateOf("main") }
        var isMonitoring by remember { mutableStateOf(false) }
        var todayCount by remember { mutableIntStateOf(database.getCountLastNDays(1)) }
        var totalCount by remember { mutableIntStateOf(database.getTotalCount()) }
        var avgPerDay by remember { mutableFloatStateOf(database.getAvgCigarettesPerDay()) }
        var lastDetection by remember { mutableStateOf<String?>(null) }
        var isLeftWrist by remember {
            mutableStateOf(prefs.getBoolean("is_left_wrist", false))
        }
        var smokingHand by remember {
            mutableStateOf(prefs.getString("smoking_hand", "auto") ?: "auto")
        }

        // Setup boost listener
        LaunchedEffect(Unit) {
            boostManager.setOnModeChangedListener { mode ->
                Log.d(TAG, "Sampling mode changed: $mode")
            }
        }

        when (currentScreen) {
            "main" -> MainScreen(
                todayCount = todayCount,
                totalCount = totalCount,
                avgPerDay = avgPerDay,
                isMonitoring = isMonitoring,
                lastDetection = lastDetection,
                onLogCigarette = {
                    // Manual cigarette log
                    database.insertDetection(
                        confidence = 1.0f,
                        gpsCluster = -1,
                        hrBaseline = 0f,
                        hrCurrent = 0f,
                        features = FloatArray(30),
                        wristLocation = if (isLeftWrist) "left" else "right",
                        smokingHand = smokingHand
                    )
                    todayCount = database.getCountLastNDays(1)
                    totalCount = database.getTotalCount()
                    avgPerDay = database.getAvgCigarettesPerDay()
                    lastDetection = "Cigarette loguee"
                    Log.d(TAG, "Manual cigarette logged. Today: $todayCount, Total: $totalCount")
                },
                onToggleMonitor = {
                    if (!hasPermissions()) {
                        requestPermissions()
                        return@MainScreen
                    }
                    isMonitoring = if (isMonitoring) {
                        DetectionService.stop(this@MainActivity)
                        sensorCollector.stop()
                        boostManager.stop()
                        false
                    } else {
                        DetectionService.start(this@MainActivity)
                        sensorCollector.start()
                        true
                    }
                    Log.d(TAG, "Monitoring: $isMonitoring")
                },
                onOpenSettings = {
                    currentScreen = "settings"
                },
            )

            "settings" -> SettingsScreen(
                isLeftWrist = isLeftWrist,
                smokingHand = smokingHand,
                onWristToggle = {
                    isLeftWrist = !isLeftWrist
                    prefs.edit().putBoolean("is_left_wrist", isLeftWrist).apply()
                    Log.d(TAG, "Wrist: ${if (isLeftWrist) "LEFT" else "RIGHT"}")
                },
                onHandToggle = {
                    smokingHand = when (smokingHand) {
                        "auto" -> "left"
                        "left" -> "right"
                        else -> "auto"
                    }
                    prefs.edit().putString("smoking_hand", smokingHand).apply()
                    Log.d(TAG, "Smoking hand: $smokingHand")
                },
                onBack = {
                    currentScreen = "main"
                },
            )
        }
    }

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

    private fun requestPermissions() {
        val permissions = arrayOf(
            Manifest.permission.BODY_SENSORS,
            Manifest.permission.ACTIVITY_RECOGNITION,
            Manifest.permission.ACCESS_FINE_LOCATION
        )
        ActivityCompat.requestPermissions(this, permissions, PERMISSION_REQUEST_CODE)
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorCollector.stop()
        boostManager.stop()
        detector.close()
    }
}
