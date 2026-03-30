package com.infernal.smokingdetector

import android.util.Log
import kotlin.math.*

/**
 * Feature Extraction for Smoking Detection
 *
 * Extracts 30 biomechanical features from accelerometer + gyroscope data.
 *
 * Feature categories:
 * 1. Time-domain (5): RMS, peak_accel, duration, interval_mean, interval_std
 * 2. Angular (4): angular_velocity, wrist_rotation, orientation_stability, rotation_smoothness
 * 3. Jerk (3): jerk_magnitude, jerk_smoothness, jerk_consistency
 * 4. Frequency (5): dominant_freq, spectral_energy, spectral_entropy, autocorr_peak, periodicity
 * 5. Trajectory (4): path_curvature, elevation_angle, elevation_consistency, total_distance
 * 6. Regularity (3): regularity_score, periodicity_coef, temporal_clustering
 * 7. Contextual (6): hr_baseline, hr_delta, gps_cluster, time_of_day, day_of_week, proximity_smoking
 *
 * Total: 30 features
 */
class FeatureExtractor {

    companion object {
        private const val TAG = "FeatureExtractor"
        private const val SAMPLING_RATE = 50.0 // Hz
    }

    /**
     * Extract all 30 features from sensor data
     *
     * @param accel Accelerometer data [N, 3] (X, Y, Z in m/s²)
     * @param gyro Gyroscope data [N, 3] (X, Y, Z in rad/s)
     * @param timestamps Timestamps [N] in nanoseconds
     * @param hrBaseline Baseline heart rate (bpm)
     * @param hrCurrent Current heart rate (bpm)
     * @param gpsCluster GPS cluster label (0=home, 1=work, 2=bar, 3=other)
     * @param proximitySmoking Proximity to smoking area (0.0-1.0)
     * @return FloatArray of 30 features
     */
    fun extractAllFeatures(
        accel: Array<FloatArray>,
        gyro: Array<FloatArray>,
        timestamps: LongArray,
        hrBaseline: Float = 70f,
        hrCurrent: Float = 70f,
        gpsCluster: Int = 3,
        proximitySmoking: Float = 0.1f
    ): FloatArray {
        Log.d(TAG, "Extracting 30 features from ${accel.size} samples")

        val features = FloatArray(30)
        var idx = 0

        // 1. Time-domain features (5)
        val timeDomain = extractTimeDomainFeatures(accel, timestamps)
        timeDomain.copyInto(features, idx)
        idx += timeDomain.size

        // 2. Angular features (4)
        val angular = extractAngularFeatures(gyro)
        angular.copyInto(features, idx)
        idx += angular.size

        // 3. Jerk features (3)
        val jerk = extractJerkFeatures(accel, timestamps)
        jerk.copyInto(features, idx)
        idx += jerk.size

        // 4. Frequency features (5)
        val frequency = extractFrequencyFeatures(accel)
        frequency.copyInto(features, idx)
        idx += frequency.size

        // 5. Trajectory features (4)
        val trajectory = extractTrajectoryFeatures(accel, gyro)
        trajectory.copyInto(features, idx)
        idx += trajectory.size

        // 6. Regularity features (3)
        val regularity = extractRegularityFeatures(accel, timestamps)
        regularity.copyInto(features, idx)
        idx += regularity.size

        // 7. Contextual features (6)
        val contextual = extractContextualFeatures(
            hrBaseline, hrCurrent, gpsCluster, proximitySmoking
        )
        contextual.copyInto(features, idx)

        // BUG 12 FIX: Normalize features to [0,1] using known min/max ranges
        normalizeFeatures(features)

        Log.d(TAG, "Feature extraction complete: 30 features (normalized)")
        return features
    }

    /**
     * Normalize features to [0,1] using known min/max ranges.
     * Feature order:
     *  0-4: Time-domain (rms, peakAccel, duration, intervalMean, intervalStd)
     *  5-8: Angular (angularVelocity, wristRotation, orientationStability, rotationSmoothness)
     *  9-11: Jerk (jerkMagnitude, jerkSmoothness, jerkConsistency)
     *  12-16: Frequency (dominantFreq, spectralEnergy, spectralEntropy, autocorrPeak, periodicity)
     *  17-20: Trajectory (pathCurvature, elevationAngle, elevationConsistency, totalDistance)
     *  21-23: Regularity (regularityScore, periodicityCoef, temporalClustering)
     *  24-29: Contextual (hrBaseline, hrDelta, gpsCluster, timeOfDay, dayOfWeek, proximitySmoking)
     */
    private fun normalizeFeatures(features: FloatArray) {
        // [min, max] for each of the 30 features
        val ranges = arrayOf(
            floatArrayOf(0f, 50f),     // 0: rms (m/s²)
            floatArrayOf(0f, 50f),     // 1: peakAccel (m/s²)
            floatArrayOf(0f, 30f),     // 2: duration (seconds)
            floatArrayOf(0f, 10f),     // 3: intervalMean (seconds)
            floatArrayOf(0f, 5f),      // 4: intervalStd (seconds)
            floatArrayOf(0f, 10f),     // 5: angularVelocity (rad/s)
            floatArrayOf(0f, 3600f),   // 6: wristRotation (degrees)
            floatArrayOf(0f, 100f),    // 7: orientationStability
            floatArrayOf(0f, 10f),     // 8: rotationSmoothness
            floatArrayOf(0f, 500f),    // 9: jerkMagnitude (m/s³)
            floatArrayOf(0f, 10f),     // 10: jerkSmoothness
            floatArrayOf(-1f, 1f),     // 11: jerkConsistency
            floatArrayOf(0f, 25f),     // 12: dominantFreq (Hz)
            floatArrayOf(0f, 2500f),   // 13: spectralEnergy
            floatArrayOf(0f, 3f),      // 14: spectralEntropy
            floatArrayOf(0f, 1f),      // 15: autocorrPeak
            floatArrayOf(0f, 50f),     // 16: periodicity
            floatArrayOf(0f, 3.14f),   // 17: pathCurvature (rad)
            floatArrayOf(-90f, 90f),   // 18: elevationAngle (degrees)
            floatArrayOf(0f, 100f),    // 19: elevationConsistency
            floatArrayOf(0f, 1000f),   // 20: totalDistance
            floatArrayOf(-1f, 1f),     // 21: regularityScore
            floatArrayOf(0f, 100f),    // 22: periodicityCoef
            floatArrayOf(-1f, 1f),     // 23: temporalClustering
            floatArrayOf(40f, 200f),   // 24: hrBaseline (bpm)
            floatArrayOf(-30f, 60f),   // 25: hrDelta (bpm)
            floatArrayOf(0f, 5f),      // 26: gpsCluster
            floatArrayOf(0f, 24f),     // 27: timeOfDay (hour)
            floatArrayOf(0f, 6f),      // 28: dayOfWeek
            floatArrayOf(0f, 1f),      // 29: proximitySmoking
        )

        for (i in features.indices) {
            val min = ranges[i][0]
            val max = ranges[i][1]
            val range = max - min
            if (range < 1e-10f) continue
            features[i] = ((features[i] - min) / range).coerceIn(0f, 1f)
        }
    }

    // ========================================================================
    // 1. TIME-DOMAIN FEATURES (5)
    // ========================================================================

    private fun extractTimeDomainFeatures(
        accel: Array<FloatArray>,
        timestamps: LongArray
    ): FloatArray {
        // Calculate magnitude for each sample
        val magnitudes = FloatArray(accel.size) { i ->
            sqrt(accel[i][0].pow(2) + accel[i][1].pow(2) + accel[i][2].pow(2))
        }

        // RMS (Root Mean Square)
        val rms = sqrt(magnitudes.map { it.pow(2) }.average()).toFloat()

        // Peak acceleration
        val peakAccel = magnitudes.maxOrNull() ?: 0f

        // Duration (seconds)
        val duration = if (timestamps.size > 1) {
            (timestamps.last() - timestamps.first()) / 1e9f
        } else {
            0f
        }

        // Interval mean/std (time between peaks)
        val peaks = findPeaks(magnitudes, threshold = 0.3f)
        val intervals = if (peaks.size > 1) {
            FloatArray(peaks.size - 1) { i ->
                (timestamps[peaks[i + 1]] - timestamps[peaks[i]]) / 1e9f
            }
        } else {
            floatArrayOf(0f)
        }

        val intervalMean = intervals.average().toFloat()
        val intervalStd = intervals.std()

        return floatArrayOf(rms, peakAccel, duration, intervalMean, intervalStd)
    }

    // ========================================================================
    // 2. ANGULAR FEATURES (4)
    // ========================================================================

    private fun extractAngularFeatures(gyro: Array<FloatArray>): FloatArray {
        // Angular velocity magnitude (rad/s)
        val angularVelocities = FloatArray(gyro.size) { i ->
            sqrt(gyro[i][0].pow(2) + gyro[i][1].pow(2) + gyro[i][2].pow(2))
        }
        val angularVelocity = angularVelocities.average().toFloat()

        // Wrist rotation (degrees) - cumulative rotation
        val wristRotation = angularVelocities.sum() * (1.0f / SAMPLING_RATE.toFloat()) * (180f / PI.toFloat())

        // Orientation stability (inverse of std)
        val orientationStability = 1.0f / (angularVelocities.std() + 1e-6f)

        // Rotation smoothness (inverse of jerk)
        val angularJerk = FloatArray(gyro.size - 1) { i ->
            abs(angularVelocities[i + 1] - angularVelocities[i]) * SAMPLING_RATE.toFloat()
        }
        val rotationSmoothness = 1.0f / (angularJerk.average().toFloat() + 1e-6f)

        return floatArrayOf(angularVelocity, wristRotation, orientationStability, rotationSmoothness)
    }

    // ========================================================================
    // 3. JERK FEATURES (3)
    // ========================================================================

    private fun extractJerkFeatures(
        accel: Array<FloatArray>,
        timestamps: LongArray
    ): FloatArray {
        // Jerk = derivative of acceleration
        val magnitudes = FloatArray(accel.size) { i ->
            sqrt(accel[i][0].pow(2) + accel[i][1].pow(2) + accel[i][2].pow(2))
        }

        val jerk = FloatArray(accel.size - 1) { i ->
            val dt = (timestamps[i + 1] - timestamps[i]) / 1e9f
            if (dt > 0) abs(magnitudes[i + 1] - magnitudes[i]) / dt else 0f
        }

        val jerkMagnitude = jerk.average().toFloat()
        val jerkSmoothness = 1.0f / (jerk.std() + 1e-6f)
        val jerkConsistency = 1.0f - (jerk.std() / (jerk.average().toFloat() + 1e-6f))

        return floatArrayOf(jerkMagnitude, jerkSmoothness, jerkConsistency)
    }

    // ========================================================================
    // 4. FREQUENCY FEATURES (5)
    // ========================================================================

    private fun extractFrequencyFeatures(accel: Array<FloatArray>): FloatArray {
        // Calculate magnitude
        val magnitudes = FloatArray(accel.size) { i ->
            sqrt(accel[i][0].pow(2) + accel[i][1].pow(2) + accel[i][2].pow(2))
        }

        // Simple FFT approximation (autocorrelation-based periodicity detection)
        val autocorr = autocorrelation(magnitudes, maxLag = min(100, magnitudes.size / 2))

        // Dominant frequency (Hz) - first peak in autocorrelation
        val dominantFreq = if (autocorr.size > 1) {
            val firstPeak = autocorr.drop(1).indexOfMax() + 1
            if (firstPeak > 0) SAMPLING_RATE / firstPeak else 0.0
        } else {
            0.0
        }.toFloat()

        // Spectral energy (variance)
        val spectralEnergy = magnitudes.map { it.pow(2) }.average().toFloat()

        // Spectral entropy (simplified - using magnitude distribution)
        val spectralEntropy = entropy(magnitudes)

        // Autocorrelation peak
        val autocorrPeak = autocorr.maxOrNull() ?: 0f

        // Periodicity (ratio of first peak to mean)
        val periodicity = if (autocorr.isNotEmpty()) {
            autocorrPeak / (autocorr.average().toFloat() + 1e-6f)
        } else {
            0f
        }

        return floatArrayOf(dominantFreq, spectralEnergy, spectralEntropy, autocorrPeak, periodicity)
    }

    // ========================================================================
    // 5. TRAJECTORY FEATURES (4)
    // ========================================================================

    private fun extractTrajectoryFeatures(
        accel: Array<FloatArray>,
        gyro: Array<FloatArray>
    ): FloatArray {
        // Path curvature (change in direction)
        val directions = FloatArray(accel.size) { i ->
            atan2(accel[i][1], accel[i][0])
        }
        val curvatureChanges = FloatArray(directions.size - 1) { i ->
            abs(directions[i + 1] - directions[i])
        }
        val pathCurvature = curvatureChanges.average().toFloat()

        // Elevation angle (vertical component)
        val elevationAngles = FloatArray(accel.size) { i ->
            val horizontal = sqrt(accel[i][0].pow(2) + accel[i][1].pow(2))
            atan2(accel[i][2], horizontal) * (180f / PI.toFloat())
        }
        val elevationAngle = elevationAngles.average().toFloat()
        val elevationConsistency = 1.0f / (elevationAngles.std() + 1e-6f)

        // Total distance (integrated acceleration - simplified)
        val totalDistance = accel.sumOf { sample ->
            sqrt(sample[0].pow(2) + sample[1].pow(2) + sample[2].pow(2)).toDouble()
        }.toFloat() / SAMPLING_RATE.toFloat()

        return floatArrayOf(pathCurvature, elevationAngle, elevationConsistency, totalDistance)
    }

    // ========================================================================
    // 6. REGULARITY FEATURES (3)
    // ========================================================================

    private fun extractRegularityFeatures(
        accel: Array<FloatArray>,
        timestamps: LongArray
    ): FloatArray {
        val magnitudes = FloatArray(accel.size) { i ->
            sqrt(accel[i][0].pow(2) + accel[i][1].pow(2) + accel[i][2].pow(2))
        }

        // Regularity score (autocorrelation at expected interval ~45s for cigarette)
        val expectedInterval = (45 * SAMPLING_RATE).toInt() // 45 seconds
        val autocorr = autocorrelation(magnitudes, maxLag = min(expectedInterval + 50, magnitudes.size / 2))
        val regularityScore = if (expectedInterval < autocorr.size) {
            autocorr[expectedInterval]
        } else {
            autocorr.lastOrNull() ?: 0f
        }

        // Periodicity coefficient (variance of intervals between peaks)
        val peaks = findPeaks(magnitudes, threshold = 0.3f)
        val intervals = if (peaks.size > 1) {
            FloatArray(peaks.size - 1) { i -> (peaks[i + 1] - peaks[i]).toFloat() }
        } else {
            floatArrayOf(0f)
        }
        val periodicityCoef = 1.0f / (intervals.std() + 1e-6f)

        // Temporal clustering (how clustered are the peaks)
        val temporalClustering = if (peaks.size > 2) {
            val meanInterval = intervals.average().toFloat()
            1.0f - (intervals.map { abs(it - meanInterval) }.average().toFloat() / (meanInterval + 1e-6f))
        } else {
            0f
        }

        return floatArrayOf(regularityScore, periodicityCoef, temporalClustering)
    }

    // ========================================================================
    // 7. CONTEXTUAL FEATURES (6)
    // ========================================================================

    private fun extractContextualFeatures(
        hrBaseline: Float,
        hrCurrent: Float,
        gpsCluster: Int,
        proximitySmoking: Float
    ): FloatArray {
        val hrDelta = hrCurrent - hrBaseline

        // Time of day (hour, 0-23)
        val calendar = java.util.Calendar.getInstance()
        val timeOfDay = calendar.get(java.util.Calendar.HOUR_OF_DAY).toFloat()

        // Day of week (0=Sunday, 6=Saturday)
        val dayOfWeek = calendar.get(java.util.Calendar.DAY_OF_WEEK).toFloat() - 1

        return floatArrayOf(
            hrBaseline,
            hrDelta,
            gpsCluster.toFloat(),
            timeOfDay,
            dayOfWeek,
            proximitySmoking
        )
    }

    // ========================================================================
    // HELPER FUNCTIONS
    // ========================================================================

    /**
     * Find peaks in signal above threshold
     */
    private fun findPeaks(signal: FloatArray, threshold: Float): List<Int> {
        val peaks = mutableListOf<Int>()
        for (i in 1 until signal.size - 1) {
            if (signal[i] > threshold &&
                signal[i] > signal[i - 1] &&
                signal[i] > signal[i + 1]
            ) {
                peaks.add(i)
            }
        }
        return peaks
    }

    /**
     * Autocorrelation of signal
     */
    private fun autocorrelation(signal: FloatArray, maxLag: Int): FloatArray {
        val result = FloatArray(maxLag)
        val mean = signal.average().toFloat()
        val variance = signal.map { (it - mean).pow(2) }.average().toFloat()

        // BUG 3 FIX: Guard against division by zero when variance is near-zero
        if (variance < 1e-10f) return FloatArray(maxLag) { if (it == 0) 1f else 0f }

        for (lag in 0 until maxLag) {
            var sum = 0.0
            for (i in 0 until signal.size - lag) {
                sum += (signal[i] - mean) * (signal[i + lag] - mean)
            }
            result[lag] = (sum / ((signal.size - lag) * variance)).toFloat()
        }
        return result
    }

    /**
     * Shannon entropy
     */
    private fun entropy(signal: FloatArray): Float {
        // Bin values into histogram
        val bins = 10
        val min = signal.minOrNull() ?: 0f
        val max = signal.maxOrNull() ?: 1f

        // BUG 4 FIX: Guard against division by zero when all values are identical
        if (max - min < 1e-10f) return 0f

        val binWidth = (max - min) / bins

        val histogram = IntArray(bins)
        for (value in signal) {
            val binIndex = min(((value - min) / binWidth).toInt(), bins - 1)
            histogram[binIndex]++
        }

        // Calculate entropy
        var entropy = 0.0
        for (count in histogram) {
            if (count > 0) {
                val p = count.toDouble() / signal.size
                entropy -= p * ln(p)
            }
        }
        return entropy.toFloat()
    }

    /**
     * Standard deviation of FloatArray
     */
    private fun FloatArray.std(): Float {
        val mean = this.average().toFloat()
        val variance = this.map { (it - mean).pow(2) }.average()
        return sqrt(variance).toFloat()
    }

    /**
     * Index of maximum value
     */
    private fun List<Float>.indexOfMax(): Int {
        // BUG 5 FIX: Guard against empty list
        if (isEmpty()) return 0
        var maxIndex = 0
        var maxValue = this[0]
        for (i in 1 until this.size) {
            if (this[i] > maxValue) {
                maxValue = this[i]
                maxIndex = i
            }
        }
        return maxIndex
    }
}
