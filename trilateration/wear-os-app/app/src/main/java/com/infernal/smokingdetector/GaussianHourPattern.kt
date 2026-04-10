package com.infernal.smokingdetector

import kotlin.math.exp

/**
 * Soft temporal pattern of a user's smoking hours.
 *
 * The old implementation simply asked "is the current hour in the top 30% of
 * counts?" (`DatabaseManager.isHighSmokingHour`). That is a hard binary
 * threshold and fails in two common cases:
 *
 *   1. The user only has a few recorded cigarettes → the top 30% of hours
 *      is basically "any hour where there is at least one sample", which
 *      makes the filter almost always return true and lose its value.
 *   2. The user smokes around 9h00 but today decides to smoke at 9h50.
 *      8h50 is 10 min inside the 9h hour bucket, 9h50 is 50 min INSIDE the
 *      same bucket — but 10h00 is a different bucket entirely even though
 *      it's physically closer (10 min away) than 9h00 (50 min away).
 *      A pure hour-bucket model creates cliffs at each hour boundary.
 *
 * GaussianHourPattern instead models each hour as a **Gaussian mass** whose
 * amplitude is the observed count and whose standard deviation is a soft
 * "spread" (default 30 minutes). We then sum the masses at the current
 * minute-of-day coordinate to get a continuous "smoking likelihood" score
 * in [0, 1].
 *
 * Scoring rule
 * ------------
 * For each hour h with count c, add a Gaussian kernel:
 *     density(t) = c × exp(-(t - h*60)^2 / (2 × sigma^2))
 * Sum over all 24 hours, normalize by the peak of the pattern.
 *
 * Usage
 * -----
 *     val pattern = GaussianHourPattern.fromHourCounts(dbCounts)
 *     val score = pattern.score(nowMinuteOfDay)  // 0.0..1.0
 *     if (score > 0.5) → this is a likely smoking time
 */
class GaussianHourPattern(
    private val hourCounts: Map<Int, Float>,
    private val sigmaMinutes: Float = DEFAULT_SIGMA_MINUTES,
) {
    companion object {
        // 30 minutes is the sweet spot: tight enough that 9h and 12h don't
        // bleed into each other, loose enough that 8h55 and 9h05 count the
        // same as 9h00. Overrideable for unit testing.
        const val DEFAULT_SIGMA_MINUTES: Float = 30f

        // A pattern with fewer than this many total samples is considered
        // "not learned yet" — .score() always returns 0 and the caller
        // should use the bootstrap logic instead.
        const val MIN_SAMPLES_FOR_PATTERN: Int = 5

        /** Convenience factory from a DB hour → count map. */
        fun fromHourCounts(
            hourCounts: Map<Int, Float>,
            sigmaMinutes: Float = DEFAULT_SIGMA_MINUTES,
        ): GaussianHourPattern = GaussianHourPattern(hourCounts, sigmaMinutes)
    }

    private val totalSamples: Float = hourCounts.values.sum()
    private val peakDensity: Float = computePeakDensity()
    private val learned: Boolean = totalSamples >= MIN_SAMPLES_FOR_PATTERN

    /**
     * Return a score in [0..1] describing how likely it is that the user
     * typically smokes around the given minute-of-day.
     *
     * Returns 0 if the pattern hasn't been learned yet (fewer than
     * MIN_SAMPLES_FOR_PATTERN total observations).
     */
    fun score(minuteOfDay: Int): Float {
        if (!learned || peakDensity <= 0f) return 0f
        val density = rawDensity(minuteOfDay)
        return (density / peakDensity).coerceIn(0f, 1f)
    }

    /**
     * True if the given minute is in a "high" smoking region (score > 0.5).
     * Used as a drop-in replacement for the old binary `isHighSmokingHour()`.
     */
    fun isHighSmokingMinute(minuteOfDay: Int): Boolean = score(minuteOfDay) > 0.5f

    /** Is the pattern considered learned / actionable? */
    fun isLearned(): Boolean = learned

    /** Total number of observations used to build the pattern. */
    fun totalSamples(): Float = totalSamples

    /**
     * Sum of Gaussian kernels at the given minute-of-day.
     *
     * Each (hour, count) bucket contributes a Gaussian centered on the hour's
     * mid-point (h*60 + 30) with standard deviation `sigmaMinutes` and
     * amplitude `count`. Wrap-around is handled by taking the shorter of
     * the two distances around the 1440-minute clock.
     *
     * This is the SINGLE source of truth for density. Both score() and
     * computePeakDensity() use it. score() divides by peakDensity for the
     * normalized form; computePeakDensity() uses the raw form to find the
     * normalization constant in the first place.
     */
    private fun rawDensity(minuteOfDay: Int): Float {
        val t = minuteOfDay.toFloat()
        val twoSigmaSq = 2f * sigmaMinutes * sigmaMinutes
        var sum = 0f
        for ((hour, count) in hourCounts) {
            // Use the mid-point of each hour as the Gaussian center (e.g. 9h → 9*60+30)
            val mu = hour * 60f + 30f
            val delta = t - mu
            // Take the shorter distance around the 1440-minute clock so a
            // smoker who fires at 23h30 also gets credit for 00h00 reads.
            val wrapDelta = when {
                delta > 720f -> delta - 1440f
                delta < -720f -> delta + 1440f
                else -> delta
            }
            sum += count * exp(-(wrapDelta * wrapDelta) / twoSigmaSq)
        }
        return sum
    }

    /**
     * Peak raw density across all 24 hours, used to normalize score() into
     * [0, 1]. Sampled every 5 minutes which gives ~288 evaluations — fine
     * for a one-shot constructor cost (called once per Detection inference,
     * cached afterwards).
     *
     * Cannot call score() here because score() depends on peakDensity, which
     * we are currently computing. Calls rawDensity() directly instead.
     */
    private fun computePeakDensity(): Float {
        var peak = 0f
        for (m in 0 until 1440 step 5) {
            val d = rawDensity(m)
            if (d > peak) peak = d
        }
        return peak
    }
}
