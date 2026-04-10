package com.infernal.smokingdetector

import android.util.Log

/**
 * Sequence-based cigarette detector.
 *
 * Why a sequence detector (not a single-threshold trigger)
 * --------------------------------------------------------
 * A single hand-to-mouth gesture is ambiguous: drinking coffee, eating a
 * snack, scratching your face, adjusting glasses — all produce ONE puff-like
 * probability spike in the CNN output. Setting a threshold high enough to
 * avoid those (e.g. 0.7) makes the detector miss real cigarettes whose
 * puffs typically peak around 0.55-0.70 with a generic model. Setting it
 * low (0.5) creates dozens of false positives per day.
 *
 * What DOES distinguish a cigarette from daily-life noise is the TEMPORAL
 * PATTERN: a real smoker takes 5-10 puffs spaced 30-60 seconds apart over
 * 3-5 minutes. No common activity produces 3+ high-probability spikes
 * within a sliding window of ~6 minutes. A coffee break has 1 spike.
 * A meal has maybe 2. Smoking has 5-10.
 *
 * So instead of "trigger if probability > X" we implement:
 *   "trigger if at least K windows with probability > P_peak
 *    have occurred in the last N milliseconds"
 *
 * This trades instant reactivity for robustness. The trade-off is that we
 * detect the cigarette ~60-120 seconds after it starts (when enough puffs
 * have accumulated) rather than at the first puff. In practice this is
 * fine — the goal is counting cigarettes, not stopping a puff mid-drag.
 *
 * Parameters
 * ----------
 * windowMs          : how far back we look for peaks (default 6 minutes)
 * peakThreshold     : minimum probability to count a sample as a "peak"
 * minPeaks          : how many peaks we need to trigger a detection
 * minPeaksInSmokingHour : lowered value when the user is in a learned
 *                         high-smoking time window (adaptive sensitivity)
 *
 * Thread safety
 * -------------
 * All public methods are synchronized on `this`. The detector is typically
 * called from a single coroutine, but guarding is cheap and defensive.
 */
class SequenceDetector(
    private val windowMs: Long = DEFAULT_WINDOW_MS,
    private val peakThreshold: Float = DEFAULT_PEAK_THRESHOLD,
    private val minPeaks: Int = DEFAULT_MIN_PEAKS,
    private val minPeaksInSmokingHour: Int = DEFAULT_MIN_PEAKS_IN_SMOKING_HOUR,
) {
    companion object {
        private const val TAG = "SequenceDetector"

        // 6 minutes of history — long enough to accumulate ~5-10 puffs,
        // short enough to flush out transient noise from unrelated gestures.
        const val DEFAULT_WINDOW_MS: Long = 6 * 60 * 1000L

        // 0.50 is the generic-model threshold observed in real smoking tests:
        // baseline at rest ~0.10-0.20, peaks during puffs 0.55-0.70.
        // After per-user fine-tuning this can be raised (e.g. 0.65) to keep
        // the same sensitivity with fewer false starts.
        const val DEFAULT_PEAK_THRESHOLD: Float = 0.50f

        // 3 peaks in 6 min is the minimum that reliably distinguishes a
        // cigarette from a meal or random gesture. Validated empirically
        // against the 20:18-20:22 live smoking test (4 peaks detected).
        const val DEFAULT_MIN_PEAKS: Int = 3

        // During learned smoking hours, 2 peaks is enough — we trust the
        // time context and react faster. Still safe because a random 2-peak
        // burst outside of smoking time is filtered by the standard path.
        const val DEFAULT_MIN_PEAKS_IN_SMOKING_HOUR: Int = 2

        // After a positive trigger, ignore further peaks for this long to
        // avoid double-counting the same cigarette. Matches the existing
        // handleCigaretteDetected debounce.
        private const val POST_TRIGGER_COOLDOWN_MS: Long = 2 * 60 * 1000L
    }

    /** A single inference sample stored in the sliding window. */
    data class Sample(val timestampMs: Long, val probability: Float)

    /** Outcome of a single push() call. */
    data class Result(
        val triggered: Boolean,
        val peakCount: Int,
        val minPeaksRequired: Int,
        val latestPeakProb: Float,
        val oldestSampleAgeMs: Long,
    )

    private val samples = ArrayDeque<Sample>()
    // Sentinel value — any nowMs - lastTriggerMs check will return false
    // until the first real trigger happens. Avoids a phantom cooldown at
    // startup when lastTriggerMs would otherwise be 0 and nowMs is also
    // small (e.g. in a unit test with simulated timestamps starting at 0).
    private var lastTriggerMs: Long = -1L

    /**
     * Push a new CNN inference probability and evaluate whether the
     * sequence has reached the trigger condition.
     *
     * @param probability  CNN cigarette probability (0..1)
     * @param nowMs        current timestamp in ms (parametrized for testing)
     * @param isHighSmokingHour  true if learned pattern says the user
     *                           typically smokes around this hour
     */
    @Synchronized
    fun push(probability: Float, nowMs: Long, isHighSmokingHour: Boolean): Result {
        // 1. Prune samples older than the sliding window
        while (samples.isNotEmpty() && nowMs - samples.first().timestampMs > windowMs) {
            samples.removeFirst()
        }

        // 2. Append the new sample
        samples.addLast(Sample(nowMs, probability))

        // 3. Count peaks (samples above the peak threshold) in the window
        val peakCount = samples.count { it.probability >= peakThreshold }
        val latestPeakProb = samples.lastOrNull { it.probability >= peakThreshold }?.probability ?: 0f
        val oldestAge = if (samples.isNotEmpty()) nowMs - samples.first().timestampMs else 0L

        // 4. Compute required peak count based on context
        val required = if (isHighSmokingHour) minPeaksInSmokingHour else minPeaks

        // 5. Check cooldown — a successful trigger silences further triggers
        //    for POST_TRIGGER_COOLDOWN_MS milliseconds. Before any trigger
        //    has happened (lastTriggerMs == -1) the cooldown never applies.
        val inCooldown = lastTriggerMs >= 0 &&
            (nowMs - lastTriggerMs) < POST_TRIGGER_COOLDOWN_MS

        val triggered = !inCooldown && peakCount >= required

        if (triggered) {
            lastTriggerMs = nowMs
            // Clear samples so the next cigarette starts counting from zero
            samples.clear()
            Log.i(
                TAG,
                "[SEQUENCE TRIGGER] peaks=$peakCount/$required window=${windowMs / 1000}s " +
                    "latestProb=${"%.3f".format(latestPeakProb)}"
            )
        }

        return Result(
            triggered = triggered,
            peakCount = peakCount,
            minPeaksRequired = required,
            latestPeakProb = latestPeakProb,
            oldestSampleAgeMs = oldestAge,
        )
    }

    /** Current number of samples in the sliding window (for diagnostics). */
    @Synchronized
    fun size(): Int = samples.size

    /** Number of samples currently above the peak threshold. */
    @Synchronized
    fun currentPeakCount(): Int = samples.count { it.probability >= peakThreshold }

    /** Reset everything — used on service stop or manual override. */
    @Synchronized
    fun reset() {
        samples.clear()
        lastTriggerMs = -1L
    }
}
