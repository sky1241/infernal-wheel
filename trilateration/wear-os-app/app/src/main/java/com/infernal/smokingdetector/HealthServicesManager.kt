package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import kotlinx.coroutines.*
import java.util.Collections

/**
 * Health Services Manager for Real-Time Heart Rate
 *
 * STUB IMPLEMENTATION - Real Health Services API requires device testing
 *
 * Features (when implemented):
 * - Real-time HR monitoring (passive mode for battery efficiency)
 * - Baseline HR calculation (7-day rolling average)
 * - HR delta detection (current - baseline)
 * - Low power consumption (~1-2% battery/day)
 *
 * Strategy:
 * - Passive monitoring: HR updates when available (not continuous polling)
 * - Baseline calculation: Store last 7 days of resting HR
 * - Delta: Current HR - Baseline (useful for cigarette detection: +7-15 bpm)
 *
 * TODO: Integrate real androidx.health.services.client when testing on device
 */
class HealthServicesManager(private val context: Context) {

    companion object {
        private const val TAG = "HealthServicesManager"
        private const val DEFAULT_BASELINE_HR = 70f
        private const val BASELINE_WINDOW_DAYS = 7
    }

    private var currentHR = DEFAULT_BASELINE_HR
    private var baselineHR = DEFAULT_BASELINE_HR
    // BUG 9 FIX: Thread-safe list for HR history (accessed from coroutine + main thread)
    private val hrHistory: MutableList<Float> = Collections.synchronizedList(mutableListOf())
    private var monitoringJob: Job? = null
    // BUG 8 FIX: Store the CoroutineScope as a field so we can cancel it in stop()
    private var monitoringScope: CoroutineScope? = null

    /**
     * Start passive heart rate monitoring
     * STUB: Returns mock data for compilation
     */
    suspend fun start(): Boolean {
        return withContext(Dispatchers.IO) {
            try {
                // STUB: Simulate HR monitoring with random variations
                // BUG 8 FIX: Store scope so we can cancel it properly in stop()
                val scope = CoroutineScope(Dispatchers.Default + SupervisorJob())
                monitoringScope = scope
                monitoringJob = scope.launch {
                    while (isActive) {
                        // Simulate HR update every 10 seconds
                        val mockHR = 70f + (Math.random() * 10).toFloat()
                        onHeartRateUpdate(mockHR)
                        delay(10000)
                    }
                }

                Log.d(TAG, "Heart rate monitoring started (STUB mode)")
                true
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start heart rate monitoring", e)
                false
            }
        }
    }

    /**
     * Stop heart rate monitoring
     */
    fun stop() {
        try {
            // BUG 8 FIX: Cancel the entire scope, not just the job
            monitoringJob?.cancel()
            monitoringScope?.cancel()
            monitoringScope = null
            Log.d(TAG, "Heart rate monitoring stopped")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to stop heart rate monitoring", e)
        }
    }

    /**
     * Handle heart rate update
     */
    private fun onHeartRateUpdate(hr: Float) {
        currentHR = hr

        // BUG 9 FIX: Synchronize compound operations on the synchronized list
        synchronized(hrHistory) {
            hrHistory.add(hr)

            // Keep last 7 days of HR data (assuming ~100 samples/day)
            if (hrHistory.size > BASELINE_WINDOW_DAYS * 100) {
                hrHistory.removeAt(0)
            }

            // Update baseline (average of lowest 20% of HR values - resting HR)
            if (hrHistory.size > 10) {
                val sorted = hrHistory.sorted()
                val restingCount = (sorted.size * 0.2).toInt().coerceAtLeast(5)
                baselineHR = sorted.take(restingCount).average().toFloat()
            }
        }

        Log.d(TAG, "HR update: current=$hr, baseline=$baselineHR, delta=${hr - baselineHR}")
    }

    /**
     * Get current heart rate
     */
    fun getCurrentHR(): Float {
        return currentHR
    }

    /**
     * Get baseline heart rate (resting)
     */
    fun getBaselineHR(): Float {
        return baselineHR
    }

    /**
     * Get heart rate delta (current - baseline)
     * Useful for cigarette detection: +7-15 bpm spike
     */
    fun getHRDelta(): Float {
        return currentHR - baselineHR
    }
}
