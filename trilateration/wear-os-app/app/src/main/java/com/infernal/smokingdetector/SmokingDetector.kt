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
 * Supports THREE model formats (auto-detected from input tensor shape):
 * - v2 (features): Input [1, 30]      → 30 extracted features
 * - v5 (CNN raw):  Input [1, 225, 6]  → raw accel+gyro signals @ 50Hz
 * - v6 (CNN 25Hz): Input [1, 112, 3]  → raw accel signals @ 25Hz (Samsung SDK)
 *
 * Output: [1, 4] float32 (cigarette, eating, drinking, other)
 */
class SmokingDetector(private val context: Context) {

    enum class ModelFormat {
        FEATURES_30,        // v2: [1, 30]
        CNN_50HZ_6CH,       // v5: [1, 225, 6]
        CNN_25HZ_3CH,       // v6: [1, 112, 3]
        UNKNOWN
    }

    companion object {
        private const val TAG = "SmokingDetector"
        private const val MODEL_FILE = "smoking_detector.tflite"

        const val CLASS_CIGARETTE = 0
        const val CLASS_EATING = 1
        const val CLASS_DRINKING = 2
        const val CLASS_OTHER = 3

        val CLASS_NAMES = arrayOf("cigarette", "eating", "drinking", "other")

        // v5 (50Hz) params
        const val WINDOW_SAMPLES_50HZ = 225  // 4.5s @ 50Hz
        const val CHANNELS_6 = 6             // AccX,Y,Z + GyrX,Y,Z

        // v6 (25Hz) params
        const val WINDOW_SAMPLES_25HZ = 112  // 4.5s @ 25Hz
        const val CHANNELS_3 = 3             // AccX,Y,Z only

        // Legacy aliases (kept for backward compat with older callers)
        const val WINDOW_SAMPLES = WINDOW_SAMPLES_50HZ
        const val CHANNELS = CHANNELS_6
    }

    private var interpreter: Interpreter? = null
    private var modelFormat: ModelFormat = ModelFormat.UNKNOWN

    // Normalization params for raw signal model
    private var normMean: FloatArray? = null
    private var normStd: FloatArray? = null

    // BUG+032 fix: TFLite Interpreter is NOT thread-safe. In DetectionService
    // the 50Hz path has 2 concurrent inference coroutines (periodic + boost)
    // and on 25Hz the rate limiter already serializes things, but defending
    // at the interpreter boundary costs nothing and makes this class safe
    // for any future caller. All interpreter.run() calls go through this lock.
    private val interpreterLock = Object()

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
            modelFormat = when {
                inputShape == null -> ModelFormat.UNKNOWN
                inputShape.size == 2 && inputShape[1] == 30 -> ModelFormat.FEATURES_30
                inputShape.size == 3 && inputShape[1] == WINDOW_SAMPLES_50HZ && inputShape[2] == CHANNELS_6 ->
                    ModelFormat.CNN_50HZ_6CH
                inputShape.size == 3 && inputShape[1] == WINDOW_SAMPLES_25HZ && inputShape[2] == CHANNELS_3 ->
                    ModelFormat.CNN_25HZ_3CH
                else -> ModelFormat.UNKNOWN
            }

            Log.d(TAG, "Model loaded: format=$modelFormat shape=${inputShape?.contentToString()}")
            Log.d(TAG, "Output shape: ${interpreter?.getOutputTensor(0)?.shape()?.contentToString()}")

            if (modelFormat == ModelFormat.UNKNOWN) {
                Log.e(TAG, "Unrecognized model format — predictions will return uniform 0.25")
            }

            true
        } catch (e: Exception) {
            Log.e(TAG, "Failed to load model", e)
            false
        }
    }

    /**
     * Set normalization params for raw signal model.
     * mean/std are per-channel arrays from training (size 6 for v5, size 3 for v6).
     *
     * Validates:
     *   - mean.size == std.size (must match)
     *   - no std[c] == 0 (would cause division by zero in normalization)
     *   - no NaN/Inf
     *
     * If validation fails, the params are NOT installed and a warning is logged.
     * Inference will then run on UN-normalized data, which produces garbage but
     * doesn't crash. Better than silently using broken params.
     */
    fun setNormalization(mean: FloatArray, std: FloatArray) {
        if (mean.size != std.size) {
            Log.e(TAG, "setNormalization: mean.size=${mean.size} != std.size=${std.size} — REJECTED")
            return
        }
        for (i in std.indices) {
            if (std[i] == 0f || std[i].isNaN() || std[i].isInfinite()) {
                Log.e(TAG, "setNormalization: std[$i]=${std[i]} invalid (would div-by-zero) — REJECTED")
                return
            }
            if (mean[i].isNaN() || mean[i].isInfinite()) {
                Log.e(TAG, "setNormalization: mean[$i]=${mean[i]} invalid — REJECTED")
                return
            }
        }
        normMean = mean
        normStd = std
        Log.d(TAG, "Normalization installed: ${mean.size} channels")
    }

    fun getModelFormat(): ModelFormat = modelFormat

    // Backward-compat: the old call returned true for any CNN model
    fun isRawSignalModel(): Boolean =
        modelFormat == ModelFormat.CNN_50HZ_6CH || modelFormat == ModelFormat.CNN_25HZ_3CH

    /**
     * Run inference on 30 extracted features (v2 model)
     */
    fun predict(features: FloatArray): FloatArray {
        if (modelFormat != ModelFormat.FEATURES_30) {
            Log.w(TAG, "predict(features) called on non-feature model ($modelFormat) — returning uniform")
            return FloatArray(4) { 0.25f }
        }
        require(features.size == 30) { "Expected 30 features, got ${features.size}" }

        val interp = interpreter
        if (interp == null) {
            Log.e(TAG, "predict called with null interpreter — returning uniform")
            return FloatArray(4) { 0.25f }
        }

        val inputArray = Array(1) { features }
        val outputArray = Array(1) { FloatArray(4) }

        return try {
            val startTime = System.currentTimeMillis()
            // BUG+032: serialize access — TFLite Interpreter is not thread-safe.
            synchronized(interpreterLock) {
                interp.run(inputArray, outputArray)
            }
            val inferenceTime = System.currentTimeMillis() - startTime
            Log.d(TAG, "Inference (features): ${inferenceTime}ms -> ${outputArray[0].contentToString()}")
            outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "Inference failed", e)
            FloatArray(4) { 0.25f }
        }
    }

    /**
     * Run inference on raw 6-channel signals (v5 CNN model @ 50Hz).
     *
     * @param accel [N][3] accelerometer data (X,Y,Z)
     * @param gyro  [N][3] gyroscope data (X,Y,Z)
     */
    fun predictRaw(accel: Array<FloatArray>, gyro: Array<FloatArray>): FloatArray {
        if (modelFormat != ModelFormat.CNN_50HZ_6CH) {
            Log.w(TAG, "predictRaw(acc,gyro) called on non-50Hz model ($modelFormat) — returning uniform")
            return FloatArray(4) { 0.25f }
        }

        val n = minOf(accel.size, gyro.size, WINDOW_SAMPLES_50HZ)
        if (n < WINDOW_SAMPLES_50HZ) {
            Log.w(TAG, "Not enough samples for raw inference: $n < $WINDOW_SAMPLES_50HZ")
            return FloatArray(4) { 0.25f }
        }

        // Build [1, 225, 6] input tensor
        val input = Array(1) { Array(WINDOW_SAMPLES_50HZ) { FloatArray(CHANNELS_6) } }
        for (i in 0 until WINDOW_SAMPLES_50HZ) {
            val idx = n - WINDOW_SAMPLES_50HZ + i
            input[0][i][0] = accel[idx][0]
            input[0][i][1] = accel[idx][1]
            input[0][i][2] = accel[idx][2]
            input[0][i][3] = gyro[idx][0]
            input[0][i][4] = gyro[idx][1]
            input[0][i][5] = gyro[idx][2]
        }

        // Per-channel normalization. Cache the local references so the JIT
        // doesn't re-null-check on every iteration. Validate the size matches
        // the expected channel count — a mismatch would either silently
        // skip normalization (broken predictions) or crash with
        // ArrayIndexOutOfBoundsException. Both are bad; we explicitly bail
        // and warn.
        val mean = normMean
        val std = normStd
        if (mean != null && std != null) {
            if (mean.size != CHANNELS_6 || std.size != CHANNELS_6) {
                Log.w(TAG, "predictRaw50Hz: norm size mismatch (mean=${mean.size} std=${std.size} expected=$CHANNELS_6) — running un-normalized")
            } else {
                for (i in 0 until WINDOW_SAMPLES_50HZ) {
                    for (c in 0 until CHANNELS_6) {
                        input[0][i][c] = (input[0][i][c] - mean[c]) / std[c]
                    }
                }
            }
        }

        val interp = interpreter
        if (interp == null) {
            Log.e(TAG, "predictRaw50Hz called with null interpreter — returning uniform")
            return FloatArray(4) { 0.25f }
        }
        val outputArray = Array(1) { FloatArray(4) }

        return try {
            val startTime = System.currentTimeMillis()
            // BUG+032: serialize access — TFLite Interpreter is not thread-safe.
            synchronized(interpreterLock) {
                interp.run(input, outputArray)
            }
            val inferenceTime = System.currentTimeMillis() - startTime
            Log.d(TAG, "Inference (CNN 50Hz): ${inferenceTime}ms -> ${outputArray[0].contentToString()}")
            outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "Raw inference failed", e)
            FloatArray(4) { 0.25f }
        }
    }

    /**
     * Run inference on raw 3-channel accel-only signals (v6 CNN model @ 25Hz).
     *
     * @param accel [N][3] accelerometer data (X,Y,Z) — at least 112 samples
     */
    fun predictRaw25Hz(accel: Array<FloatArray>): FloatArray {
        if (modelFormat != ModelFormat.CNN_25HZ_3CH) {
            Log.w(TAG, "predictRaw25Hz called on non-25Hz model ($modelFormat) — returning uniform")
            return FloatArray(4) { 0.25f }
        }

        val n = minOf(accel.size, WINDOW_SAMPLES_25HZ)
        if (n < WINDOW_SAMPLES_25HZ) {
            Log.w(TAG, "Not enough samples for 25Hz inference: $n < $WINDOW_SAMPLES_25HZ")
            return FloatArray(4) { 0.25f }
        }

        // Build [1, 112, 3] input tensor
        val input = Array(1) { Array(WINDOW_SAMPLES_25HZ) { FloatArray(CHANNELS_3) } }
        for (i in 0 until WINDOW_SAMPLES_25HZ) {
            val idx = accel.size - WINDOW_SAMPLES_25HZ + i
            input[0][i][0] = accel[idx][0]
            input[0][i][1] = accel[idx][1]
            input[0][i][2] = accel[idx][2]
        }

        // Per-channel normalization. Cache locals (see predictRaw 50Hz comment).
        val mean = normMean
        val std = normStd
        if (mean != null && std != null) {
            if (mean.size != CHANNELS_3 || std.size != CHANNELS_3) {
                Log.w(TAG, "predictRaw25Hz: norm size mismatch (mean=${mean.size} std=${std.size} expected=$CHANNELS_3) — running un-normalized")
            } else {
                for (i in 0 until WINDOW_SAMPLES_25HZ) {
                    for (c in 0 until CHANNELS_3) {
                        input[0][i][c] = (input[0][i][c] - mean[c]) / std[c]
                    }
                }
            }
        }

        val interp = interpreter
        if (interp == null) {
            Log.e(TAG, "predictRaw25Hz called with null interpreter — returning uniform")
            return FloatArray(4) { 0.25f }
        }
        val outputArray = Array(1) { FloatArray(4) }

        return try {
            val startTime = System.currentTimeMillis()
            // BUG+032: serialize access — TFLite Interpreter is not thread-safe.
            synchronized(interpreterLock) {
                interp.run(input, outputArray)
            }
            val inferenceTime = System.currentTimeMillis() - startTime
            Log.d(TAG, "Inference (CNN 25Hz): ${inferenceTime}ms -> ${outputArray[0].contentToString()}")
            outputArray[0]
        } catch (e: Exception) {
            Log.e(TAG, "25Hz inference failed", e)
            FloatArray(4) { 0.25f }
        }
    }

    private fun loadModelFile(filename: String): MappedByteBuffer {
        // Use .use {} on both the AssetFileDescriptor and the FileInputStream
        // so we don't leak the underlying file descriptors. The MappedByteBuffer
        // returned by FileChannel.map() survives the close because the kernel
        // keeps the mapping alive until it's garbage-collected (documented in
        // FileChannel.map() Javadoc).
        return context.assets.openFd(filename).use { afd ->
            FileInputStream(afd.fileDescriptor).use { fis ->
                fis.channel.map(
                    FileChannel.MapMode.READ_ONLY,
                    afd.startOffset,
                    afd.declaredLength
                )
            }
        }
    }

    fun close() {
        interpreter?.close()
        interpreter = null
        Log.d(TAG, "Model closed")
    }
}
