//
//  HealthKitManager.swift
//  SmokingDetector WatchKit Extension
//
//  Manages heart rate monitoring via HealthKit.
//  Calculates baseline HR and detects HR spikes for cigarette detection.
//

import Foundation
import HealthKit

/**
 * HealthKit Manager for Heart Rate Monitoring
 *
 * Features:
 * - Real-time heart rate streaming
 * - Baseline HR calculation (7-day resting HR average)
 * - HR delta detection (current - baseline)
 * - Low power consumption (passive monitoring)
 *
 * Usage:
 * ```swift
 * let healthKitManager = HealthKitManager()
 * healthKitManager.requestAuthorization { authorized in
 *     if authorized {
 *         healthKitManager.startHeartRateMonitoring()
 *     }
 * }
 * let currentHR = healthKitManager.getCurrentHR()
 * let baselineHR = healthKitManager.getBaselineHR()
 * let delta = healthKitManager.getHRDelta()
 * ```
 */
class HealthKitManager {

    // MARK: - Properties

    private let healthStore = HKHealthStore()

    // Heart rate data
    private var currentHR: Double = 70.0 // Default
    private var baselineHR: Double = 70.0 // Default resting HR
    private var hrHistory = [Double]()

    // Query
    private var heartRateQuery: HKAnchoredObjectQuery?

    // Constants
    private let baselineWindowDays = 7
    private let maxHistorySize = 700 // 7 days × ~100 samples/day

    // MARK: - Authorization

    /**
     * Request HealthKit authorization
     *
     * Parameters:
     * - completion: Callback with authorization result
     */
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("[HealthKitManager] ERROR: HealthKit not available")
            completion(false)
            return
        }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { success, error in
            if let error = error {
                print("[HealthKitManager] Authorization error: \(error.localizedDescription)")
                completion(false)
                return
            }

            if success {
                print("[HealthKitManager] ✓ Authorization granted")
            } else {
                print("[HealthKitManager] Authorization denied")
            }

            completion(success)
        }
    }

    // MARK: - Heart Rate Monitoring

    /**
     * Start real-time heart rate monitoring
     *
     * Uses HKAnchoredObjectQuery for streaming updates.
     */
    func startHeartRateMonitoring() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        // Create anchored query (streams new samples)
        let query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: nil,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processSamples(samples)
        }

        // Update handler for new samples
        query.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processSamples(samples)
        }

        heartRateQuery = query
        healthStore.execute(query)

        print("[HealthKitManager] ✓ Heart rate monitoring started")
    }

    /**
     * Stop heart rate monitoring
     */
    func stopHeartRateMonitoring() {
        if let query = heartRateQuery {
            healthStore.stop(query)
            heartRateQuery = nil
            print("[HealthKitManager] Monitoring stopped")
        }
    }

    /**
     * Process new heart rate samples
     */
    private func processSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else {
            return
        }

        for sample in samples {
            let hr = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            onHeartRateUpdate(hr: hr)
        }
    }

    /**
     * Handle heart rate update
     */
    private func onHeartRateUpdate(hr: Double) {
        currentHR = hr
        hrHistory.append(hr)

        // Keep last 7 days of data (~700 samples)
        if hrHistory.count > maxHistorySize {
            hrHistory.removeFirst()
        }

        // Update baseline (average of lowest 20% of HR values = resting HR)
        if hrHistory.count > 10 {
            let sorted = hrHistory.sorted()
            let restingCount = max(Int(Double(sorted.count) * 0.2), 5)
            let restingSamples = sorted.prefix(restingCount)
            baselineHR = restingSamples.reduce(0.0, +) / Double(restingSamples.count)
        }

        print("[HealthKitManager] HR: current=\(Int(hr)), baseline=\(Int(baselineHR)), delta=\(Int(hr - baselineHR))")
    }

    // MARK: - Getters

    /**
     * Get current heart rate (bpm)
     */
    func getCurrentHR() -> Double {
        return currentHR
    }

    /**
     * Get baseline heart rate (resting HR, bpm)
     */
    func getBaselineHR() -> Double {
        return baselineHR
    }

    /**
     * Get heart rate delta (current - baseline)
     *
     * Useful for cigarette detection: +7-15 bpm spike expected
     */
    func getHRDelta() -> Double {
        return currentHR - baselineHR
    }
}
