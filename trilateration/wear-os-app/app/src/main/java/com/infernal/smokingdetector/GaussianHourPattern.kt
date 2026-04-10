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

    // Raw (unnormalized) density at a given minute.
    private fun rawDensity(minuteOfDay: Int): Float {
        val t = minuteOfDay.toFloat()
        val twoSigmaSq = 2f * sigmaMinutes * sigmaMinutes
        var sum = 0f
        for ((hour, count) in hourCounts) {
            // Use the mid-point of each hour as the Gaussian center (e.g. 9h → 9*60+30)
            val mu = hour * 60f + 30f
            val delta = t - mu
            // Also consider the wrap-around (e.g. 23h vs 1h): take the closest distance
            val wrapDelta = when {
                delta > 720f -> delta - 1440f
                delta < -720f -> delta + 1440f
                else -> delta
            }
            sum += count * exp(-(wrapDelta * wrapDelta) / twoSigmaSq)
        }
        return sum
    }

    // Peak density across all 24 hours (midnight to 23h59), used for normalization.
    private fun computePeakDensity(): Float {
        var peak = 0f
        for (m in 0 until 1440 step 5) {  // sample every 5 minutes
            val d = rawDensityUnnormalized(m)
            if (d > peak) peak = d
        }
        return peak
    }

    // Same as rawDensity but without calling this.rawDensity to avoid
    // infinite recursion during peak computation.
    private fun rawDensityUnnormalized(minuteOfDay: Int): Float {
        val t = minuteOfDay.toFloat()
        val twoSigmaSq = 2f * sigmaMinutes * sigmaMinutes
        var sum = 0f
        for ((hour, count) in hourCounts) {
            val mu = hour * 60f + 30f
            val delta = t - mu
            val wrapDelta = when {
                delta > 720f -> delta - 1440f
                delta < -720f -> delta + 1440f
                else -> delta
            }
            sum += count * exp(-(wrapDelta * wrapDelta) / twoSigmaSq)
        }
        return sum
    }
}
