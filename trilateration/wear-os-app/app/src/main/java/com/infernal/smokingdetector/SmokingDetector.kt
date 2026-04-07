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
 * Supports TWO model formats:
 * - v2 (features): Input [1, 30] → 30 extracted features
 * - v5 (CNN raw):  Input [1, 225, 6] → raw accel+gyro signals
 *
 * Auto-detects format from model input shape at load time.
 *
 * Output: [1, 4] float32 (cigarette, eating, drinking, other)
 */
class SmokingDetector(private val context: Context) {

    companion object {
        private const val TAG = "SmokingDetector"
        private const val MODEL_FILE = "smoking_detector.tflite"

        const val CLASS_CIGARETTE = 0
        const val CLASS_EATING = 1
        const val CLASS_DRINKING = 2
        const val CLASS_OTHER = 3

        val CLASS_NAMES = arrayOf("cigarette", "eating", "drinking", "other")

        // Raw signal model params
        const val WINDOW_SAMPLES = 225  // 4.5s @ 50Hz
        const val CHANNELS = 6          // AccX,Y,Z + GyrX,Y,Z
    }

    private var interpreter: Interpreter? = null
    private var isRawSignalModel = false  // true if v5 CNN, false if v2 features

    // Normalization params for raw signal model
    private var normMean: FloatArray? = null
    private var normStd: FloatArray? = null

    fun loadModel(): Boolean {
        return try {
            Log.d(TAG, "Loading TFLite model: $MODEL_FILE")

            val model = loadModelFile(MODEL_FILE)
            val options = Interpreter.Options().apply { numThreads = 1 }

            interpreter = try {
                val nnapiOptions = Interpreter.Options().apply {
                    numThreads = 1
                    useNNAPI = true
                }
                Interpreter(model, nnapiOptions)
            } catch (e: Exception) {
                Log.w(TAG, "NNAPI not available, falling back to CPU", e)
                Interpreter(model, options)
            }

            // Auto-detect model format from input shape
            val inputShape = interpreter?.getInputTensor(0)?.shape()
            isRawSignalModel = inputShape != null && inputShape.size == 3 && inputShape[1] == WINDOW_SAMPLES

            Log.d(TAG, "Model loaded: ${if (isRawSignalModel) "CNN raw [1,225,6]" else "features [1,30]"}")
            Log.d(TAG, "Input shape: ${inputShape?.contentToString()}")
            Log.d(TAG, "Output shape: ${interpreter?.getOutputTensor(0)?.shape()?.contentToString()}")

            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model", e)
            false
        }
    }

    /**
     * Set normalization params for raw signal model.
     * mean/std are per-channel [6] arrays from training.
     */
    fun setNormalization(mean: FloatArray, std: FloatArray) {
        normMean = mean
        normStd = std
    }

    fun isRawSignalModel(): Boolean = isRawSignalModel

    /**
     * Run inference on 30 extracted features (v2 model)
     */
    fun predict(features: FloatArray): FloatArray {
        if (isRawSignalModel) {
            Log.w(TAG, "Raw signal model loaded but predict(features) called — returning uniform")
            return FloatArray(4) { 0.25f }
        }
        require(features.size == 30) { "Expected 30 features, got ${features.size}" }

        val inputArray = Array(1) { features }
        val outputArray = Array(1) { FloatArray(4) }

        return try {
            val startTime = System.currentTimeMillis()
            interpreter?.run(inputArray, outputArray)
            val inferenceTime = System.currentTimeMillis() - startTime
            Log.d(TAG, "Inference (features): ${inferenceTime}ms → ${outputArray[0].contentToString()}")
            outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "Inference failed", e)
            FloatArray(4) { 0.25f }
        }
    }

    /**
     * Run inference on raw 6-channel signals (v5 CNN model)
     *
     * @param accel [N][3] accelerometer data (X,Y,Z)
     * @param gyro [N][3] gyroscope data (X,Y,Z)
     * @return Probabilities for each class
     */
    fun predictRaw(accel: Array<FloatArray>, gyro: Array<FloatArray>): FloatArray {
        if (!isRawSignalModel) {
            Log.w(TAG, "Feature model loaded but predictRaw() called — returning uniform")
            return FloatArray(4) { 0.25f }
        }

        val n = minOf(accel.size, gyro.size, WINDOW_SAMPLES)
        if (n < WINDOW_SAMPLES) {
            Log.w(TAG, "Not enough samples for raw inference: $n < $WINDOW_SAMPLES")
            return FloatArray(4) { 0.25f }
        }

        // Build [1, 225, 6] input tensor
        val input = Array(1) { Array(WINDOW_SAMPLES) { FloatArray(CHANNELS) } }
        for (i in 0 until WINDOW_SAMPLES) {
            val idx = n - WINDOW_SAMPLES + i  // Take last 225 samples
            input[0][i][0] = accel[idx][0]  // AccX
            input[0][i][1] = accel[idx][1]  // AccY
            input[0][i][2] = accel[idx][2]  // AccZ
            input[0][i][3] = gyro[idx][0]   // GyrX
            input[0][i][4] = gyro[idx][1]   // GyrY
            input[0][i][5] = gyro[idx][2]   // GyrZ
        }

        // Normalize per channel
        if (normMean != null && normStd != null) {
            for (i in 0 until WINDOW_SAMPLES) {
                for (c in 0 until CHANNELS) {
                    input[0][i][c] = (input[0][i][c] - normMean!![c]) / normStd!![c]
                }
            }
        }

        val outputArray = Array(1) { FloatArray(4) }

        return try {
            val startTime = System.currentTimeMillis()
            interpreter?.run(input, outputArray)
            val inferenceTime = System.currentTimeMillis() - startTime
            Log.d(TAG, "Inference (raw CNN): ${inferenceTime}ms → ${outputArray[0].contentToString()}")
            outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "Raw inference failed", e)
            FloatArray(4) { 0.25f }
        }
    }

    private fun loadModelFile(filename: String): MappedByteBuffer {
        val fileDescriptor = context.assets.openFd(filename)
        val inputStream = FileInputStream(fileDescriptor.fileDescriptor)
        val fileChannel = inputStream.channel
        return fileChannel.map(
            FileChannel.MapMode.READ_ONLY,
            fileDescriptor.startOffset,
            fileDescriptor.declaredLength
        )
    }

    fun close() {
        interpreter?.close()
        interpreter = null
        Log.d(TAG, "Model closed")
    }
}
