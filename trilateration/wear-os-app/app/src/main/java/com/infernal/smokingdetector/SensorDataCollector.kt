package com.infernal.smokingdetector

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager as AndroidSensorManager
import android.util.Log
import kotlin.math.sqrt

/**
 * Sensor Data Collector for Accelerometer + Gyroscope
 *
 * Collects raw sensor data and stores in circular buffers.
 * Sampling rate: 50 Hz (configurable)
 *
 * Features collected:
 * - Accelerometer (3-axis): X, Y, Z (m/s²)
 * - Gyroscope (3-axis): X, Y, Z (rad/s)
 * - Timestamps (ns)
 */
class SensorDataCollector(context: Context) : SensorEventListener {

    companion object {
        private const val TAG = "SensorDataCollector"
        private const val BUFFER_SIZE = 15_000 // 5 minutes @ 50Hz
    }

    private val sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as AndroidSensorManager
    // getDefaultSensor returns null if the device has no such sensor.
    // Real Galaxy Watches always have both, but emulators and some
    // generic Wear OS devices may be missing the gyro. Treat as nullable
    // and handle gracefully in start().
    private val accelerometer: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    private val gyroscope: Sensor? = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)

    private var currentSamplingRate = AndroidSensorManager.SENSOR_DELAY_GAME // Default: 50 Hz

    // Circular buffers for sensor data. The arrays themselves don't need
    // @Volatile (the references are immutable), but the index that protects
    // visibility into them DOES — see the @Volatile fields below.
    private val accelX = FloatArray(BUFFER_SIZE)
    private val accelY = FloatArray(BUFFER_SIZE)
    private val accelZ = FloatArray(BUFFER_SIZE)
    private val gyroX = FloatArray(BUFFER_SIZE)
    private val gyroY = FloatArray(BUFFER_SIZE)
    private val gyroZ = FloatArray(BUFFER_SIZE)
    private val timestamps = LongArray(BUFFER_SIZE)

    // bufferIndex and samplesCollected are written from the SensorManager
    // callback thread and read from the inference thread. @Volatile ensures
    // the inference thread sees fresh values from the producer.
    @Volatile private var bufferIndex = 0
    @Volatile private var samplesCollected = 0

    /**
     * Start collecting sensor data
     */
    fun start(samplingRate: Int = AndroidSensorManager.SENSOR_DELAY_GAME): Boolean {
        currentSamplingRate = samplingRate
        Log.d(TAG, "Starting sensor data collection with rate: $samplingRate")

        if (accelerometer == null) {
            Log.e(TAG, "Device has no accelerometer — cannot start collection")
            return false
        }
        if (gyroscope == null) {
            // Gyro is required for the legacy v5 6-channel CNN. The new v6
            // 25Hz model only needs accel. We log a warning but don't refuse —
            // the inference path will skip the gyro channels if necessary.
            Log.w(TAG, "Device has no gyroscope — gyro channels will be zero")
        }

        val accelRegistered = sensorManager.registerListener(
            this,
            accelerometer,
            samplingRate
        )

        val gyroRegistered = if (gyroscope != null) {
            sensorManager.registerListener(this, gyroscope, samplingRate)
        } else {
            false
        }

        if (!accelRegistered) {
            Log.e(TAG, "Failed to register accelerometer")
            return false
        }

        Log.d(TAG, "Sensors registered: Accelerometer=$accelRegistered, Gyroscope=$gyroRegistered")
        return true
    }

    /**
     * Restart sensors with new sampling rate (for boost mode)
     */
    fun restart(samplingRate: Int): Boolean {
        Log.d(TAG, "Restarting sensors with new rate: $samplingRate")
        stop()
        return start(samplingRate)
    }

    /**
     * Stop collecting sensor data
     */
    fun stop() {
        sensorManager.unregisterListener(this)
        Log.d(TAG, "Sensor data collection stopped. Total samples: $samplesCollected")
    }

    override fun onSensorChanged(event: SensorEvent) {
        when (event.sensor.type) {
            Sensor.TYPE_ACCELEROMETER -> {
                // Only accelerometer advances the index and writes timestamp
                accelX[bufferIndex] = event.values[0]
                accelY[bufferIndex] = event.values[1]
                accelZ[bufferIndex] = event.values[2]
                timestamps[bufferIndex] = event.timestamp

                // Advance buffer (circular) — only on accelerometer events
                bufferIndex = (bufferIndex + 1) % BUFFER_SIZE
                samplesCollected++
            }
            Sensor.TYPE_GYROSCOPE -> {
                // Gyroscope writes to CURRENT index without advancing
                // This ensures accel[i] and gyro[i] are from nearly the same moment
                val idx = bufferIndex
                gyroX[idx] = event.values[0]
                gyroY[idx] = event.values[1]
                gyroZ[idx] = event.values[2]
            }
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        Log.d(TAG, "Sensor accuracy changed: ${sensor?.name}, accuracy=$accuracy")
    }

    /**
     * Get recent sensor data (last N samples)
     *
     * @param numSamples Number of samples to retrieve
     * @param mirrorForLeftWrist If true, mirror accel X-axis and gyro Y-axis
     *        to normalize left-wrist data as if worn on right wrist.
     *        This ensures consistent feature extraction regardless of wrist.
     */
    fun getRecentData(numSamples: Int = 1000, mirrorForLeftWrist: Boolean = false): SensorData? {
        require(numSamples <= BUFFER_SIZE) { "numSamples exceeds buffer size" }

        // BUG 2 FIX: Return null if not enough data collected (minimum 50 = 1s at 50Hz)
        val MIN_SAMPLES = 50
        if (samplesCollected < MIN_SAMPLES) {
            Log.d(TAG, "Not enough data yet: $samplesCollected < $MIN_SAMPLES")
            return null
        }

        // Only return the valid portion if we haven't filled the requested amount yet
        val actualSamples = minOf(numSamples, samplesCollected)

        val startIndex = if (samplesCollected < actualSamples) {
            0
        } else {
            (bufferIndex - actualSamples + BUFFER_SIZE) % BUFFER_SIZE
        }

        val xSign = if (mirrorForLeftWrist) -1f else 1f
        val yGyroSign = if (mirrorForLeftWrist) -1f else 1f

        val accel = Array(actualSamples) { i ->
            val idx = (startIndex + i) % BUFFER_SIZE
            floatArrayOf(accelX[idx] * xSign, accelY[idx], accelZ[idx])
        }

        val gyro = Array(actualSamples) { i ->
            val idx = (startIndex + i) % BUFFER_SIZE
            floatArrayOf(gyroX[idx], gyroY[idx] * yGyroSign, gyroZ[idx])
        }

        val ts = LongArray(actualSamples) { i ->
            val idx = (startIndex + i) % BUFFER_SIZE
            timestamps[idx]
        }

        if (mirrorForLeftWrist) {
            Log.d(TAG, "Sensor data mirrored for left wrist (accel.X * -1, gyro.Y * -1)")
        }

        return SensorData(accel, gyro, ts)
    }

    /**
     * Calculate RMS magnitude of accelerometer
     */
    fun calculateAccelMagnitude(data: Array<FloatArray>): Float {
        var sumSq = 0.0
        for (sample in data) {
            val mag = sqrt(sample[0] * sample[0] + sample[1] * sample[1] + sample[2] * sample[2])
            sumSq += mag * mag
        }
        return sqrt(sumSq / data.size).toFloat()
    }

    /**
     * Data class for sensor readings
     */
    data class SensorData(
        val accelerometer: Array<FloatArray>, // [N, 3] (X, Y, Z)
        val gyroscope: Array<FloatArray>,     // [N, 3] (X, Y, Z)
        val timestamps: LongArray             // [N] (nanoseconds)
    ) {
        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (javaClass != other?.javaClass) return false

            other as SensorData

            if (!accelerometer.contentDeepEquals(other.accelerometer)) return false
            if (!gyroscope.contentDeepEquals(other.gyroscope)) return false
            if (!timestamps.contentEquals(other.timestamps)) return false

            return true
        }

        override fun hashCode(): Int {
            var result = accelerometer.contentDeepHashCode()
            result = 31 * result + gyroscope.contentDeepHashCode()
            result = 31 * result + timestamps.contentHashCode()
            return result
        }
    }
}
