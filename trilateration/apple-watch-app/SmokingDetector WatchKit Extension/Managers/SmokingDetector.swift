//
//  SmokingDetector.swift
//  SmokingDetector WatchKit Extension
//
//  CoreML wrapper for cigarette detection model.
//  Performs on-device inference using Apple Neural Engine.
//

import Foundation
import CoreML

/**
 * Smoking Detector - CoreML Wrapper
 *
 * Loads and runs inference on the cigarette detection model.
 *
 * Model details:
 * - Input: [30] Double (biomechanical features)
 * - Output: [4] Double (probabilities: cigarette, eating, drinking, other)
 * - Size: 23.2 KB (int8 quantized)
 * - Inference time: <30ms on Apple Watch Series 8+
 *
 * Usage:
 * ```swift
 * let detector = SmokingDetector()
 * detector.loadModel()
 * let probabilities = detector.predict(features: features)
 * let isCigarette = detector.isCigaretteDetected(features: features)
 * ```
 */
class SmokingDetector {

    // MARK: - Properties

    private var model: MLModel?
    private let modelName = "smoking_detector"

    // Class labels (output order)
    private let classLabels = ["cigarette", "eating", "drinking", "other"]

    // MARK: - Initialization

    init() {
        // Model is loaded lazily via loadModel()
    }

    // MARK: - Model Loading

    /**
     * Load CoreML model from bundle
     *
     * Returns: true if model loaded successfully, false otherwise
     */
    func loadModel() -> Bool {
        do {
            // Get model URL from bundle
            guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "mlmodelc") else {
                print("[SmokingDetector] ERROR: Model file not found: \(modelName).mlmodelc")
                return false
            }

            // Load model with configuration
            let configuration = MLModelConfiguration()
            configuration.computeUnits = .all // Use Neural Engine + GPU + CPU

            model = try MLModel(contentsOf: modelURL, configuration: configuration)

            print("[SmokingDetector] ✓ Model loaded successfully")
            print("[SmokingDetector] Input: [30] Double")
            print("[SmokingDetector] Output: [4] Double (probabilities)")

            return true

        } catch {
            print("[SmokingDetector] ERROR: Failed to load model: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Inference

    /**
     * Run inference on features
     *
     * Parameters:
     * - features: [30] Double array (biomechanical features)
     *
     * Returns: [4] Double array (probabilities for cigarette, eating, drinking, other)
     */
    func predict(features: [Double]) -> [Double] {
        guard let model = model else {
            print("[SmokingDetector] ERROR: Model not loaded. Call loadModel() first.")
            return [0.25, 0.25, 0.25, 0.25] // Uniform distribution
        }

        guard features.count == 30 else {
            print("[SmokingDetector] ERROR: Invalid features size: \(features.count) (expected 30)")
            return [0.25, 0.25, 0.25, 0.25]
        }

        do {
            // Create input feature provider
            let inputArray = try MLMultiArray(shape: [1, 30], dataType: .double)
            for i in 0..<30 {
                inputArray[i] = NSNumber(value: features[i])
            }

            let inputFeatures = SmokingDetectorInput(features: inputArray)

            // Run inference
            let output = try model.prediction(from: inputFeatures)

            // Extract probabilities
            guard let outputMultiArray = output.featureValue(for: "probabilities")?.multiArrayValue else {
                print("[SmokingDetector] ERROR: Could not extract output probabilities")
                return [0.25, 0.25, 0.25, 0.25]
            }

            var probabilities = [Double]()
            for i in 0..<4 {
                probabilities.append(outputMultiArray[i].doubleValue)
            }

            return probabilities

        } catch {
            print("[SmokingDetector] ERROR: Inference failed: \(error.localizedDescription)")
            return [0.25, 0.25, 0.25, 0.25]
        }
    }

    /**
     * Check if cigarette is detected
     *
     * Parameters:
     * - features: [30] Double array
     * - threshold: Confidence threshold (default: 0.7)
     *
     * Returns: true if cigarette detected with confidence > threshold
     */
    func isCigaretteDetected(features: [Double], threshold: Double = 0.7) -> Bool {
        let probabilities = predict(features: features)
        let cigaretteProbability = probabilities[0]

        let detected = cigaretteProbability > threshold

        if detected {
            print("[SmokingDetector] 🚬 CIGARETTE DETECTED! Confidence: \(Int(cigaretteProbability * 100))%")
        }

        return detected
    }

    /**
     * Get predicted class name
     *
     * Parameters:
     * - features: [30] Double array
     *
     * Returns: Class name with highest probability
     */
    func predictClassName(features: [Double]) -> String {
        let probabilities = predict(features: features)

        guard let maxIndex = probabilities.enumerated().max(by: { $0.element < $1.element })?.offset else {
            return "unknown"
        }

        return classLabels[maxIndex]
    }
}

// MARK: - MLFeatureProvider Wrappers

/**
 * Input feature provider for CoreML model
 */
class SmokingDetectorInput: MLFeatureProvider {
    var features: MLMultiArray

    var featureNames: Set<String> {
        return ["features"]
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "features" {
            return MLFeatureValue(multiArray: features)
        }
        return nil
    }

    init(features: MLMultiArray) {
        self.features = features
    }
}
