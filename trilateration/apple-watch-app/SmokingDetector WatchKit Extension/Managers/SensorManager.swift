//
//  SensorManager.swift
//  SmokingDetector WatchKit Extension
//
//  Manages accelerometer and gyroscope data collection.
//  Stores data in circular buffers for real-time inference.
//

import Foundation
import CoreMotion

/**
 * Sensor Manager for Accelerometer + Gyroscope
 *
 * Features:
 * - Collects 3-axis accelerometer data (m/s²)
 * - Collects 3-axis gyroscope data (rad/s)
 * - Circular buffers: 15,000 samples (5 minutes @ 50Hz)
 * - Configurable sampling rate (default: 50 Hz)
 *
 * Usage:
 * ```swift
 * let sensorManager = SensorManager()
 * sensorManager.startMonitoring()
 * // ... wait ...
 * let data = sensorManager.getRecentData(numSamples: 1000)
 * sensorManager.stopMonitoring()
 * ```
 */
class SensorManager {

    // MARK: - Properties

    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()

    // Circular buffers (5 minutes @ 50Hz = 15,000 samples)
    private let bufferSize = 15_000

    private var accelX = [Double]()
    private var accelY = [Double]()
    private var accelZ = [Double]()
    private var gyroX = [Double]()
    private var gyroY = [Double]()
    private var gyroZ = [Double]()
    private var timestamps = [TimeInterval]()

    private var bufferIndex = 0
    private var samplesCollected = 0

    // Sampling rate (Hz)
    private var samplingRate: Double = 50.0 // 50 Hz (20ms interval)

    // MARK: - Initialization

    init() {
        // Pre-allocate buffers
        accelX = Array(repeating: 0.0, count: bufferSize)
        accelY = Array(repeating: 0.0, count: bufferSize)
        accelZ = Array(repeating: 0.0, count: bufferSize)
        gyroX = Array(repeating: 0.0, count: bufferSize)
        gyroY = Array(repeating: 0.0, count: bufferSize)
        gyroZ = Array(repeating: 0.0, count: bufferSize)
        timestamps = Array(repeating: 0.0, count: bufferSize)

        // Configure operation queue
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
    }

    // MARK: - Monitoring Control

    /**
     * Start sensor monitoring
     *
     * Parameters:
     * - samplingRate: Samples per second (default: 50 Hz)
     *
     * Returns: true if sensors started successfully
     */
    func startMonitoring(samplingRate: Double = 50.0) -> Bool {
        self.samplingRate = samplingRate
        let updateInterval = 1.0 / samplingRate

        guard motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable else {
            print("[SensorManager] ERROR: Sensors not available")
            return false
        }

        // Configure accelerometer
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.startAccelerometerUpdates(to: operationQueue) { [weak self] data, error in
            guard let self = self, let data = data else {
                if let error = error {
                    print("[SensorManager] Accelerometer error: \(error.localizedDescription)")
                }
                return
            }

            self.accelX[self.bufferIndex] = data.acceleration.x
            self.accelY[self.bufferIndex] = data.acceleration.y
            self.accelZ[self.bufferIndex] = data.acceleration.z
            self.timestamps[self.bufferIndex] = Date().timeIntervalSince1970
        }

        // Configure gyroscope
        motionManager.gyroUpdateInterval = updateInterval
        motionManager.startGyroUpdates(to: operationQueue) { [weak self] data, error in
            guard let self = self, let data = data else {
                if let error = error {
                    print("[SensorManager] Gyroscope error: \(error.localizedDescription)")
                }
                return
            }

            self.gyroX[self.bufferIndex] = data.rotationRate.x
            self.gyroY[self.bufferIndex] = data.rotationRate.y
            self.gyroZ[self.bufferIndex] = data.rotationRate.z

            // Advance buffer (circular)
            self.bufferIndex = (self.bufferIndex + 1) % self.bufferSize
            self.samplesCollected += 1
        }

        print("[SensorManager] ✓ Monitoring started @ \(samplingRate) Hz")
        return true
    }

    /**
     * Stop sensor monitoring
     */
    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        print("[SensorManager] Monitoring stopped. Total samples: \(samplesCollected)")
    }

    /**
     * Restart sensors with new sampling rate
     *
     * Used for boost sampling strategy (50Hz → 100Hz)
     */
    func restart(samplingRate: Double) -> Bool {
        stopMonitoring()
        return startMonitoring(samplingRate: samplingRate)
    }

    // MARK: - Data Retrieval

    /**
     * Get recent sensor data (last N samples)
     *
     * Parameters:
     * - numSamples: Number of samples to retrieve (max: bufferSize)
     *
     * Returns: SensorData struct with accelerometer, gyroscope, and timestamps
     */
    func getRecentData(numSamples: Int) -> SensorData? {
        guard numSamples <= bufferSize else {
            print("[SensorManager] ERROR: numSamples (\(numSamples)) exceeds buffer size (\(bufferSize))")
            return nil
        }

        guard samplesCollected >= numSamples else {
            print("[SensorManager] WARNING: Not enough samples collected (\(samplesCollected) < \(numSamples))")
            return nil
        }

        let startIndex = (bufferIndex - numSamples + bufferSize) % bufferSize

        var accel = [[Double]]()
        var gyro = [[Double]]()
        var ts = [TimeInterval]()

        for i in 0..<numSamples {
            let idx = (startIndex + i) % bufferSize
            accel.append([accelX[idx], accelY[idx], accelZ[idx]])
            gyro.append([gyroX[idx], gyroY[idx], gyroZ[idx]])
            ts.append(timestamps[idx])
        }

        return SensorData(accelerometer: accel, gyroscope: gyro, timestamps: ts)
    }
}

// MARK: - Data Structures

/**
 * Sensor data container
 */
struct SensorData {
    let accelerometer: [[Double]]  // [N, 3] (X, Y, Z) in m/s²
    let gyroscope: [[Double]]      // [N, 3] (X, Y, Z) in rad/s
    let timestamps: [TimeInterval] // [N] Unix timestamps (seconds)
}
