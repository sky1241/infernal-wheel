//
//  DetectionService.swift
//  SmokingDetector WatchKit Extension
//
//  Background detection service for continuous smoking monitoring.
//  Runs inference periodically and sends notifications on cigarette detection.
//

import Foundation
import WatchKit
import UserNotifications

/**
 * Detection Service for Background Monitoring
 *
 * Features:
 * - Continuous sensor monitoring @ 50Hz
 * - Periodic inference every 30 seconds
 * - Cigarette detection with local notifications
 * - Debounce: 2 minutes between detections
 * - Background execution via WKExtension
 * - Low power: boost sampling strategy
 *
 * Usage:
 * ```swift
 * let service = DetectionService()
 * service.start()
 * // ... monitoring runs in background ...
 * service.stop()
 * ```
 */
class DetectionService {

    // MARK: - Properties

    private let detector = SmokingDetector()
    private let sensorManager = SensorManager()
    private let featureExtractor = FeatureExtractor()
    private let healthKitManager = HealthKitManager()

    // Inference
    private var inferenceTimer: Timer?
    private let inferenceInterval: TimeInterval = 30.0 // 30 seconds

    // Detection state
    private var cigarettesDetected = 0
    private var lastDetectionTime: Date?
    private let debounceInterval: TimeInterval = 120.0 // 2 minutes

    // Background task
    private var backgroundTask: WKApplicationRefreshBackgroundTask?

    // MARK: - Lifecycle

    /**
     * Start detection service
     */
    func start(completion: ((Bool) -> Void)? = nil) {
        print("[DetectionService] Starting...")

        // Load model
        guard detector.loadModel() else {
            print("[DetectionService] ERROR: Failed to load model")
            completion?(false)
            return
        }

        // Request HealthKit authorization
        healthKitManager.requestAuthorization { [weak self] authorized in
            guard let self = self else { return }

            if !authorized {
                print("[DetectionService] WARNING: HealthKit not authorized")
            }

            // Start HealthKit monitoring
            self.healthKitManager.startHeartRateMonitoring()

            // Start sensor monitoring
            guard self.sensorManager.startMonitoring(samplingRate: 50.0) else {
                print("[DetectionService] ERROR: Failed to start sensors")
                completion?(false)
                return
            }

            // Start periodic inference
            self.startPeriodicInference()

            // Schedule background refresh
            self.scheduleBackgroundRefresh()

            print("[DetectionService] ✓ Service started")
            completion?(true)
        }
    }

    /**
     * Stop detection service
     */
    func stop() {
        print("[DetectionService] Stopping...")

        // Stop inference
        inferenceTimer?.invalidate()
        inferenceTimer = nil

        // Stop sensors
        sensorManager.stopMonitoring()

        // Stop HealthKit
        healthKitManager.stopHeartRateMonitoring()

        print("[DetectionService] Service stopped")
    }

    // MARK: - Inference

    /**
     * Start periodic inference
     */
    private func startPeriodicInference() {
        inferenceTimer = Timer.scheduledTimer(
            withTimeInterval: inferenceInterval,
            repeats: true
        ) { [weak self] _ in
            self?.runInference()
        }

        print("[DetectionService] Periodic inference started (every \(inferenceInterval)s)")
    }

    /**
     * Run inference on recent sensor data
     */
    private func runInference() {
        print("[DetectionService] Running inference...")

        // Get recent sensor data (1000 samples = 20s @ 50Hz)
        guard let sensorData = sensorManager.getRecentData(numSamples: 1000) else {
            print("[DetectionService] WARNING: Not enough sensor data")
            return
        }

        // Extract features
        let features = featureExtractor.extractAllFeatures(
            accel: sensorData.accelerometer,
            gyro: sensorData.gyroscope,
            timestamps: sensorData.timestamps,
            hrBaseline: healthKitManager.getBaselineHR(),
            hrCurrent: healthKitManager.getCurrentHR(),
            gpsCluster: 0, // TODO: GPS clustering
            proximitySmoking: 0.1
        )

        // Run inference
        let probabilities = detector.predict(features: features)
        let isCigarette = detector.isCigaretteDetected(features: features, threshold: 0.7)

        print("[DetectionService] Inference complete: cigarette=\(isCigarette), probabilities=\(probabilities)")

        // Handle detection
        if isCigarette {
            handleCigaretteDetected(confidence: probabilities[0])
        }
    }

    /**
     * Handle cigarette detection
     */
    private func handleCigaretteDetected(confidence: Double) {
        let now = Date()

        // Debounce: Ignore if detected within last 2 minutes
        if let lastTime = lastDetectionTime, now.timeIntervalSince(lastTime) < debounceInterval {
            print("[DetectionService] Cigarette detected but debounced (too recent)")
            return
        }

        lastDetectionTime = now
        cigarettesDetected += 1

        print("[DetectionService] 🚬 CIGARETTE DETECTED! Count: \(cigarettesDetected), Confidence: \(Int(confidence * 100))%")

        // Send notification
        sendNotification(confidence: confidence)

        // TODO: Save to local database
        // TODO: Trigger boost sampling (50Hz → 100Hz for 5 minutes)
    }

    // MARK: - Notifications

    /**
     * Send local notification for cigarette detection
     */
    private func sendNotification(confidence: Double) {
        let content = UNMutableNotificationContent()
        content.title = "🚬 Cigarette Detected"
        content.body = "Confidence: \(Int(confidence * 100))% | Total: \(cigarettesDetected)"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Deliver immediately
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[DetectionService] Notification error: \(error.localizedDescription)")
            } else {
                print("[DetectionService] Notification sent")
            }
        }
    }

    /**
     * Request notification permissions
     */
    static func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("[DetectionService] Notification auth error: \(error.localizedDescription)")
                completion(false)
                return
            }
            print("[DetectionService] Notification auth: \(granted ? "granted" : "denied")")
            completion(granted)
        }
    }

    // MARK: - Background Execution

    /**
     * Schedule background refresh task
     *
     * Ensures the service continues running even when app is not active.
     */
    private func scheduleBackgroundRefresh() {
        let refreshDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes

        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: refreshDate,
            userInfo: nil
        ) { error in
            if let error = error {
                print("[DetectionService] Background refresh error: \(error.localizedDescription)")
            } else {
                print("[DetectionService] Background refresh scheduled for \(refreshDate)")
            }
        }
    }

    /**
     * Handle background refresh task
     *
     * Called by WKExtensionDelegate when background task fires.
     */
    func handleBackgroundTask(_ task: WKApplicationRefreshBackgroundTask) {
        print("[DetectionService] Background task fired")

        // Run inference once
        runInference()

        // Schedule next refresh
        scheduleBackgroundRefresh()

        // Complete task
        task.setTaskCompletedWithSnapshot(false)
    }

    // MARK: - Statistics

    /**
     * Get total cigarettes detected
     */
    func getTotalCount() -> Int {
        return cigarettesDetected
    }

    /**
     * Get last detection time
     */
    func getLastDetectionTime() -> Date? {
        return lastDetectionTime
    }

    /**
     * Reset counter
     */
    func resetCounter() {
        cigarettesDetected = 0
        lastDetectionTime = nil
        print("[DetectionService] Counter reset")
    }
}
