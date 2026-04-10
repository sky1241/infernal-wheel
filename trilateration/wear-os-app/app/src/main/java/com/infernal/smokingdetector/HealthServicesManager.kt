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

        // HR post-smoking signature: nicotine causes vasoconstriction and HR
        // rises by 5-15 bpm within 2 minutes of the first puff. We keep a
        // short rolling window of timestamped HR readings so a detection
        // event can query "has HR risen by >= X bpm in the last Y seconds?"
        private const val HR_HISTORY_WINDOW_MS = 5 * 60 * 1000L  // 5 min
    }

    /** A single HR reading with its capture timestamp. */
    private data class HrSample(val timestampMs: Long, val bpm: Float)

    private var currentHR = DEFAULT_BASELINE_HR
    private var baselineHR = DEFAULT_BASELINE_HR
    // BUG 9 FIX: Thread-safe list for HR history (accessed from coroutine + main thread)
    private val hrHistory: MutableList<Float> = Collections.synchronizedList(mutableListOf())
    // Separate timestamped buffer used by the smoking-detection HR signal.
    // Pruned to HR_HISTORY_WINDOW_MS on every push.
    private val hrTimeline: MutableList<HrSample> = Collections.synchronizedList(mutableListOf())
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
        val nowMs = System.currentTimeMillis()

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

        // Maintain the short timestamped timeline used by smoking detection.
        synchronized(hrTimeline) {
            hrTimeline.add(HrSample(nowMs, hr))
            val cutoff = nowMs - HR_HISTORY_WINDOW_MS
            hrTimeline.removeAll { it.timestampMs < cutoff }
        }

        Log.d(TAG, "HR update: current=$hr, baseline=$baselineHR, delta=${hr - baselineHR}")
    }

    /**
     * Compute the HR delta between the current reading and the average
     * HR from `lookbackStartMs` to `lookbackEndMs` ago.
     *
     * Used to detect the post-smoking HR spike: if HR has risen by 5+ bpm
     * in the last 2 minutes compared to the preceding 3 minutes, that's
     * a strong corroborating signal for a real cigarette.
     *
     * Returns 0f if there isn't enough history to compute a meaningful delta.
     *
     * @param lookbackStartMs  how far back the baseline window starts (ms ago)
     * @param lookbackEndMs    where the baseline window ends (ms ago)
     */
    fun getHRRiseOverLast(
        lookbackStartMs: Long = 3 * 60 * 1000L,  // baseline: 3-5 min ago
        lookbackEndMs: Long = 2 * 60 * 1000L,    // "now" window: last 2 min
    ): Float {
        val nowMs = System.currentTimeMillis()
        synchronized(hrTimeline) {
            if (hrTimeline.size < 2) return 0f

            val baselineWindowStart = nowMs - lookbackStartMs
            val baselineWindowEnd = nowMs - lookbackEndMs
            val recentWindowStart = nowMs - lookbackEndMs

            val baselineSamples = hrTimeline.filter {
                it.timestampMs in baselineWindowStart..baselineWindowEnd
            }
            val recentSamples = hrTimeline.filter {
                it.timestampMs >= recentWindowStart
            }

            if (baselineSamples.isEmpty() || recentSamples.isEmpty()) return 0f

            val baselineAvg = baselineSamples.map { it.bpm }.average().toFloat()
            val recentAvg = recentSamples.map { it.bpm }.average().toFloat()
            return recentAvg - baselineAvg
        }
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

}
