package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import org.tensorflow.lite.Interpreter
import java.io.FileInputStream
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel

/**
 * TFLite Smoking Detection Model Wrapper
 *
 * Loads smoking_detector.tflite and runs inference on 30 extracted features.
 *
 * Input: [1, 30] float32 array (30 biomechanical features)
 * Output: [1, 4] float32 array (probabilities for cigarette, eating, drinking, other)
 *
 * Model details:
 * - Size: 23.2 KB (int8 quantized)
 * - Architecture: Input(30) → Dense(128) → Dense(64) → Dense(32) → Dense(4)
 * - Inference time: <50ms (NNAPI accelerated)
 */
class SmokingDetector(private val context: Context) {

    companion object {
        private const val TAG = "SmokingDetector"
        private const val MODEL_FILE = "smoking_detector.tflite"

        // Class labels
        const val CLASS_CIGARETTE = 0
        const val CLASS_EATING = 1
        const val CLASS_DRINKING = 2
        const val CLASS_OTHER = 3

        val CLASS_NAMES = arrayOf("cigarette", "eating", "drinking", "other")
    }

    private var interpreter: Interpreter? = null

    /**
     * Load TFLite model from assets
     */
    fun loadModel(): Boolean {
        return try {
            Log.d(TAG, "Loading TFLite model: $MODEL_FILE")

            val model = loadModelFile(MODEL_FILE)

            // Configure interpreter options
            val options = Interpreter.Options().apply {
                // Use NNAPI for hardware acceleration (Neural Engine)
                useNNAPI = true
                // Number of threads for CPU fallback
                numThreads = 4
            }

            interpreter = Interpreter(model, options)

            Log.d(TAG, "Model loaded successfully")
            Log.d(TAG, "Input shape: ${interpreter?.getInputTensor(0)?.shape()?.contentToString()}")
            Log.d(TAG, "Output shape: ${interpreter?.getOutputTensor(0)?.shape()?.contentToString()}")

            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model", e)
            false
        }
    }

    /**
     * Load model file from assets as MappedByteBuffer
     */
    private fun loadModelFile(filename: String): MappedByteBuffer {
        val fileDescriptor = context.assets.openFd(filename)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        val startOffset = fileDescriptor.startOffset
        val declaredLength = fileDescriptor.declaredLength
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }

    /**
     * Run inference on 30 extracted features
     *
     * @param features Float array of 30 biomechanical features
     * @return Probabilities for each class [cigarette, eating, drinking, other]
     */
    fun predict(features: FloatArray): FloatArray {
        require(features.size == 30) { "Expected 30 features, got ${features.size}" }

        val inputArray = Array(1) { features }
        val outputArray = Array(1) { FloatArray(4) }

        try {
            val startTime = System.currentTimeMillis()
            interpreter?.run(inputArray, outputArray)
            val inferenceTime = System.currentTimeMillis() - startTime

            Log.d(TAG, "Inference time: ${inferenceTime}ms")
            Log.d(TAG, "Output probabilities: ${outputArray[0].contentToString()}")

            return outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "Inference failed", e)
            return FloatArray(4) { 0.25f } // Return uniform distribution on error
        }
    }

    /**
     * Release resources
     */
    fun close() {
        interpreter?.close()
        interpreter = null
        Log.d(TAG, "Model closed")
    }
}
