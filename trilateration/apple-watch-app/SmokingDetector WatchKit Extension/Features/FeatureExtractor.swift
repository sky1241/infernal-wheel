//
//  FeatureExtractor.swift
//  SmokingDetector WatchKit Extension
//
//  Extracts 30 biomechanical features from sensor data for cigarette detection.
//  Implements time-domain, frequency-domain, and contextual feature extraction.
//

import Foundation
import Accelerate

/**
 * Feature Extractor for Smoking Detection
 *
 * Extracts 30 features from sensor data:
 * 1. Time-domain (5): RMS, peak_accel, duration, interval_mean, interval_std
 * 2. Angular (4): angular_velocity, wrist_rotation, orientation_stability, rotation_smoothness
 * 3. Jerk (3): jerk_magnitude, jerk_smoothness, jerk_consistency
 * 4. Frequency (5): dominant_freq, spectral_energy, spectral_entropy, autocorr_peak, periodicity
 * 5. Trajectory (4): path_curvature, elevation_angle, elevation_consistency, total_distance
 * 6. Regularity (3): regularity_score, periodicity_coef, temporal_clustering
 * 7. Contextual (6): hr_baseline, hr_delta, gps_cluster, time_of_day, day_of_week, proximity_smoking
 *
 * Usage:
 * ```swift
 * let extractor = FeatureExtractor()
 * let features = extractor.extractAllFeatures(
 *     accel: sensorData.accelerometer,
 *     gyro: sensorData.gyroscope,
 *     timestamps: sensorData.timestamps,
 *     hrBaseline: 70.0,
 *     hrCurrent: 85.0,
 *     gpsCluster: 0
 * )
 * ```
 */
class FeatureExtractor {

    // MARK: - Main Extraction

    /**
     * Extract all 30 features from sensor data
     *
     * Parameters:
     * - accel: Accelerometer data [N, 3] (m/s²)
     * - gyro: Gyroscope data [N, 3] (rad/s)
     * - timestamps: Timestamps [N] (seconds)
     * - hrBaseline: Baseline heart rate (bpm)
     * - hrCurrent: Current heart rate (bpm)
     * - gpsCluster: GPS cluster code (0=home, 1=work, 2=bar, 3=other)
     * - proximitySmoking: Proximity to smoking locations (0.0-1.0)
     *
     * Returns: [30] Double array of features
     */
    func extractAllFeatures(
        accel: [[Double]],
        gyro: [[Double]],
        timestamps: [TimeInterval],
        hrBaseline: Double,
        hrCurrent: Double,
        gpsCluster: Int,
        proximitySmoking: Double = 0.1
    ) -> [Double] {
        var features = [Double]()

        // 1. Time-domain features (5)
        features.append(contentsOf: extractTimeDomainFeatures(accel: accel, timestamps: timestamps))

        // 2. Angular features (4)
        features.append(contentsOf: extractAngularFeatures(gyro: gyro))

        // 3. Jerk features (3)
        features.append(contentsOf: extractJerkFeatures(accel: accel, timestamps: timestamps))

        // 4. Frequency features (5)
        features.append(contentsOf: extractFrequencyFeatures(accel: accel, timestamps: timestamps))

        // 5. Trajectory features (4)
        features.append(contentsOf: extractTrajectoryFeatures(accel: accel))

        // 6. Regularity features (3)
        features.append(contentsOf: extractRegularityFeatures(accel: accel, timestamps: timestamps))

        // 7. Contextual features (6)
        features.append(contentsOf: extractContextualFeatures(
            hrBaseline: hrBaseline,
            hrCurrent: hrCurrent,
            gpsCluster: gpsCluster,
            proximitySmoking: proximitySmoking
        ))

        return features
    }

    // MARK: - 1. Time-Domain Features

    private func extractTimeDomainFeatures(accel: [[Double]], timestamps: [TimeInterval]) -> [Double] {
        let magnitudes = accel.map { sqrt($0[0]*$0[0] + $0[1]*$0[1] + $0[2]*$0[2]) }

        // RMS
        let rms = sqrt(magnitudes.map { $0 * $0 }.reduce(0, +) / Double(magnitudes.count))

        // Peak acceleration
        let peakAccel = magnitudes.max() ?? 0.0

        // Duration
        let duration = timestamps.last! - timestamps.first!

        // Interval mean & std (time between peaks)
        let peaks = detectPeaks(signal: magnitudes, threshold: rms * 1.5)
        let intervals = zip(peaks.dropFirst(), peaks).map { $1 - $0 }
        let intervalMean = intervals.isEmpty ? 0.0 : intervals.reduce(0, +) / Double(intervals.count)
        let intervalStd = intervals.isEmpty ? 0.0 : sqrt(intervals.map { pow($0 - intervalMean, 2) }.reduce(0, +) / Double(intervals.count))

        return [rms, peakAccel, duration, intervalMean, intervalStd]
    }

    // MARK: - 2. Angular Features

    private func extractAngularFeatures(gyro: [[Double]]) -> [Double] {
        let angularVelocities = gyro.map { sqrt($0[0]*$0[0] + $0[1]*$0[1] + $0[2]*$0[2]) }

        // Angular velocity (mean)
        let angularVelocity = angularVelocities.reduce(0, +) / Double(angularVelocities.count)

        // Wrist rotation (total rotation angle)
        let wristRotation = angularVelocities.reduce(0, +) * 0.02 // dt = 0.02s @ 50Hz

        // Orientation stability (std of angular velocity)
        let orientationStability = sqrt(angularVelocities.map { pow($0 - angularVelocity, 2) }.reduce(0, +) / Double(angularVelocities.count))

        // Rotation smoothness (jerk of angular velocity)
        let rotationSmoothness = calculateSmoothness(signal: angularVelocities)

        return [angularVelocity, wristRotation, orientationStability, rotationSmoothness]
    }

    // MARK: - 3. Jerk Features

    private func extractJerkFeatures(accel: [[Double]], timestamps: [TimeInterval]) -> [Double] {
        let magnitudes = accel.map { sqrt($0[0]*$0[0] + $0[1]*$0[1] + $0[2]*$0[2]) }

        // Calculate jerk (derivative of acceleration)
        var jerk = [Double]()
        for i in 1..<magnitudes.count {
            let dt = timestamps[i] - timestamps[i-1]
            jerk.append((magnitudes[i] - magnitudes[i-1]) / dt)
        }

        // Jerk magnitude (mean)
        let jerkMagnitude = jerk.map { abs($0) }.reduce(0, +) / Double(jerk.count)

        // Jerk smoothness (std)
        let jerkMean = jerk.reduce(0, +) / Double(jerk.count)
        let jerkSmoothness = sqrt(jerk.map { pow($0 - jerkMean, 2) }.reduce(0, +) / Double(jerk.count))

        // Jerk consistency (autocorrelation at lag 1)
        let jerkConsistency = calculateAutocorrelation(signal: jerk, lag: 1)

        return [jerkMagnitude, jerkSmoothness, jerkConsistency]
    }

    // MARK: - 4. Frequency Features

    private func extractFrequencyFeatures(accel: [[Double]], timestamps: [TimeInterval]) -> [Double] {
        let magnitudes = accel.map { sqrt($0[0]*$0[0] + $0[1]*$0[1] + $0[2]*$0[2]) }

        // Dominant frequency (via FFT approximation)
        let dominantFreq = estimateDominantFrequency(signal: magnitudes, samplingRate: 50.0)

        // Spectral energy (variance)
        let mean = magnitudes.reduce(0, +) / Double(magnitudes.count)
        let spectralEnergy = magnitudes.map { pow($0 - mean, 2) }.reduce(0, +) / Double(magnitudes.count)

        // Spectral entropy (Shannon entropy)
        let spectralEntropy = calculateEntropy(signal: magnitudes)

        // Autocorrelation peak
        let autocorrPeak = calculateAutocorrelationPeak(signal: magnitudes, maxLag: 50)

        // Periodicity (autocorrelation variance)
        let periodicity = calculatePeriodicity(signal: magnitudes)

        return [dominantFreq, spectralEnergy, spectralEntropy, autocorrPeak, periodicity]
    }

    // MARK: - 5. Trajectory Features

    private func extractTrajectoryFeatures(accel: [[Double]]) -> [Double] {
        // Calculate cumulative displacement (integrate acceleration twice)
        var velocity = [[Double]]()
        var position = [[Double]]()
        let dt = 0.02 // 50Hz

        for i in 0..<accel.count {
            if i == 0 {
                velocity.append([0.0, 0.0, 0.0])
                position.append([0.0, 0.0, 0.0])
            } else {
                let vx = velocity[i-1][0] + accel[i][0] * dt
                let vy = velocity[i-1][1] + accel[i][1] * dt
                let vz = velocity[i-1][2] + accel[i][2] * dt
                velocity.append([vx, vy, vz])

                let px = position[i-1][0] + vx * dt
                let py = position[i-1][1] + vy * dt
                let pz = position[i-1][2] + vz * dt
                position.append([px, py, pz])
            }
        }

        // Path curvature (mean curvature)
        let pathCurvature = calculatePathCurvature(positions: position)

        // Elevation angle (mean angle from horizontal)
        let elevationAngle = calculateElevationAngle(velocities: velocity)

        // Elevation consistency (std of elevation angles)
        let elevationConsistency = calculateElevationConsistency(velocities: velocity)

        // Total distance traveled
        let totalDistance = calculateTotalDistance(positions: position)

        return [pathCurvature, elevationAngle, elevationConsistency, totalDistance]
    }

    // MARK: - 6. Regularity Features

    private func extractRegularityFeatures(accel: [[Double]], timestamps: [TimeInterval]) -> [Double] {
        let magnitudes = accel.map { sqrt($0[0]*$0[0] + $0[1]*$0[1] + $0[2]*$0[2]) }

        // Regularity score (inverse of coefficient of variation)
        let mean = magnitudes.reduce(0, +) / Double(magnitudes.count)
        let std = sqrt(magnitudes.map { pow($0 - mean, 2) }.reduce(0, +) / Double(magnitudes.count))
        let regularityScore = mean / (std + 1e-6)

        // Periodicity coefficient (autocorrelation at lag 25 = 0.5s @ 50Hz)
        let periodicityCoef = calculateAutocorrelation(signal: magnitudes, lag: 25)

        // Temporal clustering (count of high-activity bursts)
        let temporalClustering = Double(detectPeaks(signal: magnitudes, threshold: mean + std).count)

        return [regularityScore, periodicityCoef, temporalClustering]
    }

    // MARK: - 7. Contextual Features

    private func extractContextualFeatures(
        hrBaseline: Double,
        hrCurrent: Double,
        gpsCluster: Int,
        proximitySmoking: Double
    ) -> [Double] {
        let hrDelta = hrCurrent - hrBaseline

        // Time of day (0-23 hours as fraction 0-1)
        let hour = Calendar.current.component(.hour, from: Date())
        let timeOfDay = Double(hour) / 24.0

        // Day of week (0=Sunday, 6=Saturday as fraction 0-1)
        let dayOfWeek = Double(Calendar.current.component(.weekday, from: Date()) - 1) / 7.0

        return [hrBaseline, hrDelta, Double(gpsCluster), timeOfDay, dayOfWeek, proximitySmoking]
    }

    // MARK: - Helper Functions

    private func detectPeaks(signal: [Double], threshold: Double) -> [Int] {
        var peaks = [Int]()
        for i in 1..<(signal.count - 1) {
            if signal[i] > threshold && signal[i] > signal[i-1] && signal[i] > signal[i+1] {
                peaks.append(i)
            }
        }
        return peaks
    }

    private func calculateSmoothness(signal: [Double]) -> Double {
        guard signal.count > 1 else { return 0.0 }
        var diff = [Double]()
        for i in 1..<signal.count {
            diff.append(abs(signal[i] - signal[i-1]))
        }
        return diff.reduce(0, +) / Double(diff.count)
    }

    private func calculateAutocorrelation(signal: [Double], lag: Int) -> Double {
        guard signal.count > lag else { return 0.0 }
        let mean = signal.reduce(0, +) / Double(signal.count)
        var numerator = 0.0
        var denominator = 0.0
        for i in 0..<(signal.count - lag) {
            numerator += (signal[i] - mean) * (signal[i + lag] - mean)
            denominator += (signal[i] - mean) * (signal[i] - mean)
        }
        return denominator > 0 ? numerator / denominator : 0.0
    }

    private func estimateDominantFrequency(signal: [Double], samplingRate: Double) -> Double {
        // Simplified: count zero-crossings
        let mean = signal.reduce(0, +) / Double(signal.count)
        var crossings = 0
        for i in 1..<signal.count {
            if (signal[i] - mean) * (signal[i-1] - mean) < 0 {
                crossings += 1
            }
        }
        return Double(crossings) / 2.0 * samplingRate / Double(signal.count)
    }

    private func calculateEntropy(signal: [Double]) -> Double {
        // Shannon entropy
        let bins = 10
        let minVal = signal.min() ?? 0.0
        let maxVal = signal.max() ?? 1.0
        let range = maxVal - minVal
        var histogram = Array(repeating: 0, count: bins)

        for value in signal {
            let bin = min(Int((value - minVal) / range * Double(bins)), bins - 1)
            histogram[bin] += 1
        }

        var entropy = 0.0
        for count in histogram {
            if count > 0 {
                let p = Double(count) / Double(signal.count)
                entropy -= p * log2(p)
            }
        }
        return entropy
    }

    private func calculateAutocorrelationPeak(signal: [Double], maxLag: Int) -> Double {
        var maxCorr = 0.0
        for lag in 1...maxLag {
            let corr = calculateAutocorrelation(signal: signal, lag: lag)
            if corr > maxCorr {
                maxCorr = corr
            }
        }
        return maxCorr
    }

    private func calculatePeriodicity(signal: [Double]) -> Double {
        // Variance of autocorrelation values
        var acorrs = [Double]()
        for lag in 1...50 {
            acorrs.append(calculateAutocorrelation(signal: signal, lag: lag))
        }
        let mean = acorrs.reduce(0, +) / Double(acorrs.count)
        return sqrt(acorrs.map { pow($0 - mean, 2) }.reduce(0, +) / Double(acorrs.count))
    }

    private func calculatePathCurvature(positions: [[Double]]) -> Double {
        guard positions.count > 2 else { return 0.0 }
        var curvatures = [Double]()
        for i in 1..<(positions.count - 1) {
            let v1 = [positions[i][0] - positions[i-1][0], positions[i][1] - positions[i-1][1], positions[i][2] - positions[i-1][2]]
            let v2 = [positions[i+1][0] - positions[i][0], positions[i+1][1] - positions[i][1], positions[i+1][2] - positions[i][2]]
            let angle = acos(dotProduct(v1, v2) / (magnitude(v1) * magnitude(v2) + 1e-6))
            curvatures.append(angle)
        }
        return curvatures.reduce(0, +) / Double(curvatures.count)
    }

    private func calculateElevationAngle(velocities: [[Double]]) -> Double {
        var angles = [Double]()
        for v in velocities {
            let horizontalMag = sqrt(v[0]*v[0] + v[1]*v[1])
            let angle = atan2(v[2], horizontalMag)
            angles.append(angle)
        }
        return angles.reduce(0, +) / Double(angles.count)
    }

    private func calculateElevationConsistency(velocities: [[Double]]) -> Double {
        var angles = [Double]()
        for v in velocities {
            let horizontalMag = sqrt(v[0]*v[0] + v[1]*v[1])
            let angle = atan2(v[2], horizontalMag)
            angles.append(angle)
        }
        let mean = angles.reduce(0, +) / Double(angles.count)
        return sqrt(angles.map { pow($0 - mean, 2) }.reduce(0, +) / Double(angles.count))
    }

    private func calculateTotalDistance(positions: [[Double]]) -> Double {
        var distance = 0.0
        for i in 1..<positions.count {
            let dx = positions[i][0] - positions[i-1][0]
            let dy = positions[i][1] - positions[i-1][1]
            let dz = positions[i][2] - positions[i-1][2]
            distance += sqrt(dx*dx + dy*dy + dz*dz)
        }
        return distance
    }

    private func dotProduct(_ v1: [Double], _ v2: [Double]) -> Double {
        return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2]
    }

    private func magnitude(_ v: [Double]) -> Double {
        return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
    }
}
