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
import kotlinx.coroutines.*
import kotlinx.coroutines.SupervisorJob

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
        // BUG+039: manual +1 tap debounce window — clicks within this
        // interval of the previous are ignored to prevent accidental
        // double-taps from creating ghost DB rows + double BT syncs.
        // Raised from 300ms to 2000ms after real-world test: user reported
        // accidental multi-taps on the 1.2" watch screen inflating the
        // daily count (31 counted vs ~10 real).
        private const val MANUAL_LOG_DEBOUNCE_MS = 2000L
    }

    private lateinit var database: DatabaseManager
    private lateinit var prefs: SharedPreferences
    private lateinit var messageSync: MessageSyncManager
    private val syncScope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    // BUG+039 fix: double-tap debounce for the manual log buttons.
    // Same CAS pattern as DetectionService BUG+031 — AtomicLong + compareAndSet
    // lets only one click per MANUAL_LOG_DEBOUNCE_MS through. 300ms is the
    // Compose-recommended window for tap deduplication on small screens.
    private val lastManualLogMs = java.util.concurrent.atomic.AtomicLong(0L)

    private fun consumeManualClick(): Boolean {
        val now = System.currentTimeMillis()
        while (true) {
            val prev = lastManualLogMs.get()
            if (now - prev < MANUAL_LOG_DEBOUNCE_MS) return false
            if (lastManualLogMs.compareAndSet(prev, now)) return true
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        database = DatabaseManager(this)
        prefs = getSharedPreferences("smoking_detector_prefs", Context.MODE_PRIVATE)
        messageSync = MessageSyncManager(this)

        if (!hasPermissions()) {
            requestPermissions()
        }

        setContent {
            InfernalWearTheme {
                WearApp()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Cancel the IO coroutine scope so any in-flight sendCigarette /
        // sendDrink job is interrupted instead of leaking the activity.
        // Without this, every activity recreate (rotation, theme change,
        // process restart) accumulates an orphaned scope still holding
        // a reference to `this` → memory leak + duplicate sends.
        syncScope.cancel()
        // Close the SQLiteOpenHelper to release the underlying connection
        // pool. Multiple Activity instances with leaked DB handles
        // eventually exhaust the SQLite cursor pool and throw.
        if (::database.isInitialized) {
            try { database.close() } catch (e: Exception) {
                Log.w(TAG, "database.close failed", e)
            }
        }
    }

    @Composable
    private fun WearApp() {
        var currentScreen by remember { mutableStateOf("main") }
        var isMonitoring by remember { mutableStateOf(isServiceRunning()) }
        var todayCount by remember { mutableIntStateOf(database.getCountLastNDays(1)) }
        var todayDrinkCount by remember { mutableIntStateOf(database.getDrinkCountLastNDays(1)) }
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
                todayDrinkCount = database.getDrinkCountLastNDays(1)
                totalCount = database.getTotalCount()
                avgPerDay = database.getAvgCigarettesPerDay()
                isMonitoring = isServiceRunning()
            }
        }

        // Periodic refresh while on main screen
        LaunchedEffect(currentScreen) {
            if (currentScreen == "main") {
                while (true) {
                    delay(10_000)
                    todayCount = database.getCountLastNDays(1)
                    todayDrinkCount = database.getDrinkCountLastNDays(1)
                    totalCount = database.getTotalCount()
                    avgPerDay = database.getAvgCigarettesPerDay()
                    isMonitoring = isServiceRunning()
                }
            }
        }

        when (currentScreen) {
            "main" -> MainScreen(
                todayCount = todayCount,
                todayDrinkCount = todayDrinkCount,
                totalCount = totalCount,
                avgPerDay = avgPerDay,
                isMonitoring = isMonitoring,
                lastDetection = lastDetection,
                onLogCigarette = {
                    // BUG+039: reject double-taps within MANUAL_LOG_DEBOUNCE_MS
                    if (!consumeManualClick()) {
                        Log.d(TAG, "Cigarette tap debounced (too fast)")
                        return@MainScreen
                    }
                    // Auto-start detection on first log
                    if (!isMonitoring && hasPermissions()) {
                        DetectionService.start(this@MainActivity)
                        isMonitoring = true
                        Log.d(TAG, "Auto-started monitoring on first cigarette log")
                    }
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
                    lastDetection = "🚬 +1"
                    Log.d(TAG, "Manual cigarette logged. Today: $todayCount")
                    database.recordSmokingPattern()
                    // Trigger boost mode (15s delay → 7 min scanning)
                    DetectionService.triggerBoost(this@MainActivity, "manual_cigarette")
                    // Sync to phone via Bluetooth
                    syncScope.launch {
                        messageSync.sendCigarette()
                        Log.d(TAG, "Cigarette synced to phone")
                    }
                },
                onLogDrink = { drinkType ->
                    // BUG+039: reject double-taps within MANUAL_LOG_DEBOUNCE_MS
                    if (!consumeManualClick()) {
                        Log.d(TAG, "Drink tap debounced (too fast)")
                        return@MainScreen
                    }
                    // Auto-start detection on first log
                    if (!isMonitoring && hasPermissions()) {
                        DetectionService.start(this@MainActivity)
                        isMonitoring = true
                        Log.d(TAG, "Auto-started monitoring on first drink log")
                    }
                    database.insertDrinkDetection(
                        confidence = 1.0f,
                        gpsCluster = -1,
                        hrBaseline = 0f,
                        hrCurrent = 0f,
                        features = FloatArray(30),
                        wristLocation = if (isLeftWrist) "left" else "right",
                        smokingHand = drinkType
                    )
                    todayDrinkCount = database.getDrinkCountLastNDays(1)
                    val emoji = when(drinkType) { "beer" -> "🍺"; "wine" -> "🍷"; "strong" -> "🥃"; else -> "🍺" }
                    lastDetection = "$emoji +1"
                    Log.d(TAG, "Manual $drinkType logged. Today: $todayDrinkCount")
                    database.recordSmokingPattern()
                    DetectionService.triggerBoost(this@MainActivity, "manual_$drinkType")
                    // Sync to phone via Bluetooth
                    syncScope.launch {
                        messageSync.sendDrink(drinkType = drinkType)
                        Log.d(TAG, "$drinkType synced to phone")
                    }
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
     * BUG 18 FIX: Use static flag instead of deprecated ActivityManager.getRunningServices
     */
    private fun isServiceRunning(): Boolean {
        return DetectionService.isRunning
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
