package com.infernal.smokingdetector

import android.content.Context
import android.hardware.SensorManager
import android.util.Log
import kotlinx.coroutines.*

/**
 * Boost Sampling Manager for Adaptive Sampling Strategy
 *
 * Switches between normal and high-frequency sampling to balance
 * battery life and detection accuracy.
 *
 * Strategy:
 * - Normal mode: 50 Hz continuous (baseline monitoring)
 * - Boost mode: 100 Hz for 5 minutes (after trigger events)
 * - Triggers: User action (button press) or cigarette detection
 *
 * Battery Impact:
 * - Normal: ~2-3% battery/day @ 50Hz
 * - Boost: ~5-6% battery/day @ 100Hz
 * - Average: ~2.5% battery/day (boost only 10% of time)
 *
 * Use Cases:
 * - User smokes → Boost for 5min (detect consecutive cigarettes)
 * - User manually triggers detection → Boost for 5min (high precision)
 * - Idle for 5min → Return to normal mode
 */
class BoostSamplingManager(private val context: Context) {

    companion object {
        private const val TAG = "BoostSamplingManager"

        // Sampling rates (microseconds between samples)
        const val RATE_NORMAL = SensorManager.SENSOR_DELAY_GAME // ~50 Hz (20ms)
        const val RATE_BOOST = SensorManager.SENSOR_DELAY_FASTEST // ~100 Hz (10ms)

        // Boost duration
        private const val BOOST_DURATION_MS = 5 * 60 * 1000L // 5 minutes
    }

    private var currentMode: SamplingMode = SamplingMode.NORMAL
    private var boostEndTime = 0L
    private var boostJob: Job? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    private var onModeChanged: ((SamplingMode) -> Unit)? = null

    enum class SamplingMode {
        NORMAL,  // 50 Hz
        BOOST    // 100 Hz
    }

    /**
     * Set callback for mode changes
     */
    fun setOnModeChangedListener(listener: (SamplingMode) -> Unit) {
        onModeChanged = listener
    }

    /**
     * Get current sampling mode
     */
    fun getCurrentMode(): SamplingMode {
        return currentMode
    }

    /**
     * Get current sampling rate (for SensorManager.registerListener)
     */
    fun getCurrentRate(): Int {
        return when (currentMode) {
            SamplingMode.NORMAL -> RATE_NORMAL
            SamplingMode.BOOST -> RATE_BOOST
        }
    }

    /**
     * Trigger boost mode for 5 minutes
     * Can be called from:
     * - User button press (manual detection)
     * - Cigarette detection event
     */
    fun triggerBoost(reason: String) {
        val now = System.currentTimeMillis()

        // If already in boost mode, extend the duration
        if (currentMode == SamplingMode.BOOST) {
            boostEndTime = now + BOOST_DURATION_MS
            Log.d(TAG, "Boost extended: reason=$reason, duration=${BOOST_DURATION_MS / 1000}s")
            return
        }

        // Switch to boost mode
        currentMode = SamplingMode.BOOST
        boostEndTime = now + BOOST_DURATION_MS

        Log.d(TAG, "Boost activated: reason=$reason, duration=${BOOST_DURATION_MS / 1000}s")

        // Notify listener (to restart sensors with new rate)
        onModeChanged?.invoke(SamplingMode.BOOST)

        // Schedule return to normal mode
        boostJob?.cancel()
        boostJob = coroutineScope.launch {
            delay(BOOST_DURATION_MS)
            returnToNormal()
        }
    }

    /**
     * Return to normal sampling mode
     */
    private fun returnToNormal() {
        if (currentMode == SamplingMode.NORMAL) {
            return
        }

        currentMode = SamplingMode.NORMAL
        boostEndTime = 0L

        Log.d(TAG, "Returned to normal mode (50Hz)")

        // Notify listener (to restart sensors with new rate)
        onModeChanged?.invoke(SamplingMode.NORMAL)
    }

    /**
     * Manually return to normal mode (cancel boost)
     */
    fun cancelBoost() {
        boostJob?.cancel()
        returnToNormal()
    }

    /**
     * Get remaining boost time (ms)
     */
    fun getRemainingBoostTime(): Long {
        if (currentMode != SamplingMode.BOOST) {
            return 0L
        }
        val remaining = boostEndTime - System.currentTimeMillis()
        return remaining.coerceAtLeast(0L)
    }

    /**
     * Cleanup
     */
    fun stop() {
        boostJob?.cancel()
        coroutineScope.cancel()
        Log.d(TAG, "BoostSamplingManager stopped")
    }
}
