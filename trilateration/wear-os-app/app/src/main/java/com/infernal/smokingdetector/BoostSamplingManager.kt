package com.infernal.smokingdetector

import android.content.Context
import android.hardware.SensorManager
import android.os.PowerManager
import android.util.Log
import kotlinx.coroutines.*

/**
 * Boost Sampling Manager — Adaptive detection after manual trigger
 *
 * Flow when user presses +1:
 * 1. DELAY phase: Wait 15 seconds (user lights cigarette)
 * 2. BOOST phase: Inference every 15 seconds for 7 minutes (28 measurements)
 *    - Each measurement = 4.5s window at 50Hz → CNN inference
 *    - Raw windows stored for personal fine-tuning
 * 3. NORMAL phase: Back to inference every 30 seconds
 *
 * This gives us ~28 high-quality labeled windows per cigarette.
 * After 1 day (~20 cigs) = ~560 personal training windows.
 */
class BoostSamplingManager(private val context: Context) {

    companion object {
        private const val TAG = "BoostSamplingManager"

        // Sampling rates
        const val RATE_NORMAL = SensorManager.SENSOR_DELAY_GAME    // ~50 Hz
        const val RATE_BOOST = SensorManager.SENSOR_DELAY_FASTEST  // ~100 Hz

        // Boost timing
        private const val DELAY_BEFORE_BOOST_MS = 15_000L      // 15s wait (light up)
        private const val BOOST_INFERENCE_INTERVAL_MS = 15_000L // 15s between measurements
        private const val BOOST_DURATION_MS = 7 * 60 * 1000L   // 7 minutes total
        private const val BOOST_MEASUREMENTS = 28               // ~7min / 15s

        // Normal timing
        const val NORMAL_INFERENCE_INTERVAL_MS = 30_000L        // 30s between measurements
    }

    // State fields are read from the main thread (getCurrentMode/getCurrentRate
    // called from DetectionService periodic loop) and written from the boost
    // coroutine. @Volatile ensures cross-thread visibility.
    @Volatile private var currentMode: SamplingMode = SamplingMode.NORMAL
    @Volatile private var boostJob: Job? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    @Volatile private var wakeLock: PowerManager.WakeLock? = null

    private var onModeChanged: ((SamplingMode) -> Unit)? = null
    private var onBoostInference: (() -> Unit)? = null
    @Volatile private var boostMeasurementCount = 0

    enum class SamplingMode {
        NORMAL,     // 50 Hz, inference every 30s
        DELAY,      // Waiting 15s for user to light up
        BOOST       // 100 Hz, inference every 15s for 7 min
    }

    fun setOnModeChangedListener(listener: (SamplingMode) -> Unit) {
        onModeChanged = listener
    }

    /**
     * Set callback for boost-mode inference triggers.
     * DetectionService will run inference when this fires.
     */
    fun setOnBoostInferenceListener(listener: () -> Unit) {
        onBoostInference = listener
    }

    fun getCurrentMode(): SamplingMode = currentMode
    fun getCurrentRate(): Int = when (currentMode) {
        SamplingMode.NORMAL -> RATE_NORMAL
        SamplingMode.BOOST -> RATE_BOOST
        SamplingMode.DELAY -> RATE_NORMAL // Keep normal during delay
    }

    fun getBoostMeasurementCount(): Int = boostMeasurementCount

    /**
     * Trigger the full boost sequence: DELAY → BOOST → NORMAL
     * Called when user presses +1 cigarette or +1 drink.
     *
     * @Synchronized so two concurrent triggers (e.g. user click + auto
     * detection arriving in the same instant) cannot interleave the
     * cancel + acquireWakeLock + launch sequence and end up with a leaked
     * wake lock or two competing boost jobs.
     */
    @Synchronized
    fun triggerBoost(reason: String) {
        // Cancel any existing boost — also releases its wake lock
        boostJob?.cancel()
        // Release the previous boost's wake lock before acquiring a new one,
        // otherwise back-to-back triggerBoost calls leak refcounted locks.
        releaseWakeLock()
        boostMeasurementCount = 0

        // Acquire wake lock to prevent CPU sleep during boost
        acquireWakeLock()

        // Phase 1: DELAY (15s)
        currentMode = SamplingMode.DELAY
        Log.d(TAG, "DELAY phase started: waiting ${DELAY_BEFORE_BOOST_MS/1000}s ($reason)")

        boostJob = coroutineScope.launch {
            // Wait for user to light up
            delay(DELAY_BEFORE_BOOST_MS)

            // Phase 2: BOOST (7 min, inference every 15s)
            currentMode = SamplingMode.BOOST
            onModeChanged?.invoke(SamplingMode.BOOST)
            Log.d(TAG, "BOOST phase started: ${BOOST_MEASUREMENTS} measurements over ${BOOST_DURATION_MS/60000}min")

            for (i in 1..BOOST_MEASUREMENTS) {
                if (!isActive) break

                boostMeasurementCount = i
                Log.d(TAG, "Boost measurement $i/$BOOST_MEASUREMENTS")

                // Trigger inference in DetectionService
                onBoostInference?.invoke()

                // Wait 15s before next measurement
                if (i < BOOST_MEASUREMENTS) {
                    delay(BOOST_INFERENCE_INTERVAL_MS)
                }
            }

            // Phase 3: Return to NORMAL
            returnToNormal()
        }
    }

    private fun returnToNormal() {
        if (currentMode == SamplingMode.NORMAL) return

        currentMode = SamplingMode.NORMAL
        boostMeasurementCount = 0
        releaseWakeLock()
        Log.d(TAG, "Returned to NORMAL mode (30s interval)")
        onModeChanged?.invoke(SamplingMode.NORMAL)
    }

    private fun acquireWakeLock() {
        val existing = wakeLock
        val lock = if (existing == null) {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            val newLock = pm.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "infernal:boost_sampling"
            )
            // Disable refcount so a stray double-acquire doesn't leave the
            // lock held forever. Single owner, single lifecycle.
            newLock.setReferenceCounted(false)
            wakeLock = newLock
            newLock
        } else {
            existing
        }
        // acquire() with a timeout is the safety net — even if someone
        // forgets to release, the lock auto-releases after this duration.
        lock.acquire(BOOST_DURATION_MS + DELAY_BEFORE_BOOST_MS + 30_000)
        Log.d(TAG, "Wake lock acquired")
    }

    private fun releaseWakeLock() {
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
                Log.d(TAG, "Wake lock released")
            }
        }
    }

    fun cancelBoost() {
        boostJob?.cancel()
        releaseWakeLock()
        returnToNormal()
    }

    fun isInBoostMode(): Boolean = currentMode == SamplingMode.BOOST
    fun isInDelayMode(): Boolean = currentMode == SamplingMode.DELAY

    fun getRemainingBoostTime(): Long {
        if (currentMode != SamplingMode.BOOST) return 0L
        val elapsed = boostMeasurementCount * BOOST_INFERENCE_INTERVAL_MS
        return (BOOST_DURATION_MS - elapsed).coerceAtLeast(0L)
    }

    fun stop() {
        boostJob?.cancel()
        releaseWakeLock()
        coroutineScope.cancel()
        Log.d(TAG, "BoostSamplingManager stopped")
    }
}
