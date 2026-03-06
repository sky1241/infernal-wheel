package com.infernal.smokingdetector

import android.Manifest
import android.app.ActivityManager
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
import androidx.wear.remote.interactions.RemoteActivityHelper
import com.infernal.smokingdetector.ui.InfernalWearTheme
import com.infernal.smokingdetector.ui.MainScreen
import com.infernal.smokingdetector.ui.SettingsScreen
import kotlinx.coroutines.*

/**
 * Main Activity for Wear OS Smoking Detection App
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
        private const val PHONE_APP_URL = "https://infernal-wheel.web.app"
    }

    private lateinit var database: DatabaseManager
    private lateinit var prefs: SharedPreferences
    private lateinit var remoteActivityHelper: RemoteActivityHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        database = DatabaseManager(this)
        prefs = getSharedPreferences("smoking_detector_prefs", Context.MODE_PRIVATE)
        remoteActivityHelper = RemoteActivityHelper(this, Dispatchers.IO.asExecutor())

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
        var currentScreen by remember { mutableStateOf("main") }
        var isMonitoring by remember { mutableStateOf(isServiceRunning()) }
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

        // Refresh counters and service state when returning to main screen
        LaunchedEffect(currentScreen) {
            if (currentScreen == "main") {
                todayCount = database.getCountLastNDays(1)
                totalCount = database.getTotalCount()
                avgPerDay = database.getAvgCigarettesPerDay()
                isMonitoring = isServiceRunning()
            }
        }

        // Periodic refresh while on main screen (service may detect cigarettes in background)
        LaunchedEffect(currentScreen) {
            if (currentScreen == "main") {
                while (true) {
                    delay(10_000)
                    todayCount = database.getCountLastNDays(1)
                    totalCount = database.getTotalCount()
                    avgPerDay = database.getAvgCigarettesPerDay()
                    isMonitoring = isServiceRunning()
                }
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
                    if (isMonitoring) {
                        DetectionService.stop(this@MainActivity)
                        isMonitoring = false
                    } else {
                        DetectionService.start(this@MainActivity)
                        isMonitoring = true
                    }
                    Log.d(TAG, "Monitoring: $isMonitoring")
                },
                onOpenSettings = {
                    currentScreen = "settings"
                },
                onOpenOnPhone = {
                    openOnPhone()
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

    /**
     * Check if DetectionService is currently running
     */
    private fun isServiceRunning(): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        @Suppress("DEPRECATION")
        for (service in manager.getRunningServices(Integer.MAX_VALUE)) {
            if (DetectionService::class.java.name == service.service.className) {
                return true
            }
        }
        return false
    }

    /**
     * Open companion website on phone via Bluetooth (RemoteIntent)
     */
    private fun openOnPhone() {
        try {
            val intent = android.content.Intent(android.content.Intent.ACTION_VIEW)
                .addCategory(android.content.Intent.CATEGORY_BROWSABLE)
                .setData(android.net.Uri.parse(PHONE_APP_URL))

            remoteActivityHelper.startRemoteActivity(intent)
            Log.d(TAG, "Opening on phone: $PHONE_APP_URL")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open on phone", e)
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
}
