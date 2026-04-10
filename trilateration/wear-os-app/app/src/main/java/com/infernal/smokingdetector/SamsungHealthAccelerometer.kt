package com.infernal.smokingdetector

import android.content.Context
import android.util.Log

/**
 * Wrapper around Samsung Health Sensor SDK ACCELEROMETER_CONTINUOUS.
 *
 * Why this class exists
 * ---------------------
 * Samsung Galaxy Watch already runs the accelerometer continuously for the
 * built-in pedometer / activity tracking. The Samsung Health Sensor SDK lets
 * us TAP INTO that same flux without starting our own sensor — meaning the
 * physical sensor is "free" from a battery standpoint. We only pay the cost
 * of the CPU waking up ~5x/min to receive batched samples.
 *
 * Numbers
 * -------
 *   - Sample rate:  25Hz (1500 samples/min)
 *   - Batch size:   ~300 samples (~12 seconds of signal)
 *   - Channels:     3 (AccX, AccY, AccZ in m/s^2)
 *   - Battery cost: ~1-2%/day on Galaxy Watch 4+
 *
 * Setup required by the user
 * --------------------------
 * The Samsung Health Sensor SDK is NOT on Maven Central. You must:
 *   1. Register a free Samsung developer account at developer.samsung.com
 *   2. Download the "Health Sensor SDK"
 *   3. Drop the AAR into trilateration/wear-os-app/app/libs/samsung-health-sensor-api.aar
 *   4. Uncomment the imports + REAL IMPLEMENTATION blocks marked below
 *   5. Sync gradle
 *
 * Until the AAR is added, this class compiles as a STUB that logs warnings
 * and never delivers data. Phase 1 (50Hz boost mode) still works without it.
 *
 * IMPORTANT — Unit conversion
 * ---------------------------
 * Samsung returns RAW INT values for accelerometer (not m/s^2 floats).
 * The conversion formula from the Samsung docs is:
 *
 *     m/s^2 = raw_int * 9.81 / (16383.75 / 4.0)
 *           = raw_int * ACCEL_INT_TO_MS2
 *
 * The CNN was trained on m/s^2 values from the SED dataset, so we MUST
 * convert here in the wrapper, otherwise the model sees values in the wrong
 * scale and produces garbage.
 *
 * References:
 * - https://developer.samsung.com/health/sensor/overview.html
 * - https://developer.samsung.com/health/sensor/api-reference/com/samsung/android/service/health/tracking/data/ValueKey.AccelerometerSet.html
 */
class SamsungHealthAccelerometer(private val context: Context) {

    companion object {
        private const val TAG = "SamsungHealthAccel"
        const val SAMPLE_RATE_HZ = 25
        const val EXPECTED_BATCH_SIZE = 300  // ~12s @ 25Hz

        /**
         * Conversion factor from Samsung raw int to m/s^2.
         *
         * Samsung formula: m/s^2 = 9.81 / (16383.75 / 4.0) * raw_value
         *                       = 9.81 / 4095.9375 * raw_value
         *                       = 0.002395 * raw_value (approximately)
         *
         * Public so tests can validate it.
         */
        const val ACCEL_INT_TO_MS2: Float = (9.81 / (16383.75 / 4.0)).toFloat()
    }

    /**
     * Callback receiving batches of accel samples from the Samsung SDK.
     *
     * @param samples Array of 3-float arrays [AccX, AccY, AccZ] in m/s^2
     *                (already converted from Samsung's raw int format)
     * @param timestampNs Nanosecond timestamp of the FIRST sample in the batch
     */
    fun interface BatchListener {
        fun onBatch(samples: Array<FloatArray>, timestampNs: Long)
    }

    private var listener: BatchListener? = null
    private var isConnected: Boolean = false
    private var isAvailable: Boolean = false

    // ─────────────────────────────────────────────────────────────────────
    // Real Samsung SDK fields — declared as Any? so the file compiles
    // without the AAR present. They are populated only inside the REAL
    // IMPLEMENTATION blocks once the AAR is added and the imports below
    // are uncommented.
    // ─────────────────────────────────────────────────────────────────────
    //
    // import com.samsung.android.service.health.tracking.ConnectionListener
    // import com.samsung.android.service.health.tracking.HealthTracker
    // import com.samsung.android.service.health.tracking.HealthTrackerException
    // import com.samsung.android.service.health.tracking.HealthTrackingService
    // import com.samsung.android.service.health.tracking.data.DataPoint
    // import com.samsung.android.service.health.tracking.data.HealthTrackerType
    // import com.samsung.android.service.health.tracking.data.ValueKey
    //
    // private var healthTrackingService: HealthTrackingService? = null
    // private var accelTracker: HealthTracker? = null

    // ─────────────────────────────────────────────────────────────────────
    // Public API — used by DetectionService
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Returns true if the Samsung Health Sensor SDK is present at runtime.
     * Detection is done by reflection so this class compiles even when the
     * AAR is not yet added to libs/.
     */
    fun isSdkAvailable(): Boolean {
        return try {
            Class.forName("com.samsung.android.service.health.tracking.HealthTrackingService")
            true
        } catch (e: ClassNotFoundException) {
            Log.w(TAG, "Samsung Health Sensor SDK not present — drop samsung-health-sensor-api.aar in app/libs/ to enable")
            false
        }
    }

    /**
     * Connect to the Samsung Health Tracking service and start the
     * ACCELEROMETER_CONTINUOUS tracker. Idempotent.
     */
    fun connect(listener: BatchListener) {
        this.listener = listener

        if (!isSdkAvailable()) {
            isAvailable = false
            return
        }

        // ╔═══════════════════════════════════════════════════════════════╗
        // ║ REAL IMPLEMENTATION — uncomment after adding the AAR + imports ║
        // ╚═══════════════════════════════════════════════════════════════╝
        //
        // val connectionListener = object : ConnectionListener {
        //     override fun onConnectionSuccess() {
        //         Log.d(TAG, "Samsung tracking service connected")
        //         isConnected = true
        //         try {
        //             accelTracker = healthTrackingService!!.getHealthTracker(
        //                 HealthTrackerType.ACCELEROMETER_CONTINUOUS
        //             )
        //             accelTracker!!.setEventListener(object : HealthTracker.TrackerEventListener {
        //                 override fun onDataReceived(dataPoints: MutableList<DataPoint>) {
        //                     handleBatch(dataPoints)
        //                 }
        //                 override fun onFlushCompleted() {
        //                     Log.d(TAG, "Flush completed")
        //                 }
        //                 override fun onError(e: HealthTracker.TrackerError) {
        //                     Log.e(TAG, "Tracker error: $e")
        //                 }
        //             })
        //             isAvailable = true
        //             Log.d(TAG, "ACCELEROMETER_CONTINUOUS tracker active")
        //         } catch (e: Exception) {
        //             Log.e(TAG, "Failed to start accelerometer tracker", e)
        //             isAvailable = false
        //         }
        //     }
        //
        //     override fun onConnectionEnded() {
        //         Log.d(TAG, "Samsung tracking service ended")
        //         isConnected = false
        //         isAvailable = false
        //     }
        //
        //     override fun onConnectionFailed(e: HealthTrackerException) {
        //         Log.e(TAG, "Samsung tracking service connection failed: code=${e.errorCode}", e)
        //         isConnected = false
        //         isAvailable = false
        //     }
        // }
        //
        // healthTrackingService = HealthTrackingService(connectionListener, context.applicationContext)
        // healthTrackingService!!.connectService()

        Log.w(TAG, "Samsung SDK stub connect() — uncomment REAL IMPLEMENTATION block after adding AAR")
        isAvailable = false
    }

    /**
     * Stop receiving batches and release the tracking service.
     */
    fun disconnect() {
        if (!isConnected && !isAvailable) return

        // ╔═══════════════════════════════════════════════════════════════╗
        // ║ REAL IMPLEMENTATION — uncomment after adding the AAR           ║
        // ╚═══════════════════════════════════════════════════════════════╝
        //
        // try {
        //     accelTracker?.unsetEventListener()
        // } catch (e: Exception) {
        //     Log.w(TAG, "unsetEventListener failed", e)
        // }
        // accelTracker = null
        // try {
        //     healthTrackingService?.disconnectService()
        // } catch (e: Exception) {
        //     Log.w(TAG, "disconnectService failed", e)
        // }
        // healthTrackingService = null

        isConnected = false
        isAvailable = false
        Log.d(TAG, "Disconnected")
    }

    fun isActive(): Boolean = isConnected && isAvailable

    // ─────────────────────────────────────────────────────────────────────
    // Internal — convert Samsung DataPoint to (Float, Float, Float) in m/s^2
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Convert one Samsung raw integer reading to m/s^2.
     * Pure function — used inside handleBatch and exposed for unit testing.
     */
    fun rawIntToMs2(rawValue: Int): Float = rawValue * ACCEL_INT_TO_MS2

    /**
     * Called from the Samsung SDK event listener with a batch of DataPoints.
     * Converts each point's raw int x/y/z to m/s^2 and forwards as a batch
     * to the user-supplied BatchListener.
     *
     * Currently invoked from the REAL IMPLEMENTATION block in connect() once
     * the AAR is wired in.
     */
    @Suppress("unused")
    private fun handleBatch(dataPoints: MutableList<Any>) {
        val n = dataPoints.size
        if (n == 0) return

        // ╔═══════════════════════════════════════════════════════════════╗
        // ║ REAL IMPLEMENTATION — uncomment after adding the AAR           ║
        // ╚═══════════════════════════════════════════════════════════════╝
        //
        // val samples = Array(n) { i ->
        //     val dp = dataPoints[i] as DataPoint
        //     val rawX = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_X)
        //     val rawY = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Y)
        //     val rawZ = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Z)
        //     floatArrayOf(
        //         rawIntToMs2(rawX),
        //         rawIntToMs2(rawY),
        //         rawIntToMs2(rawZ),
        //     )
        // }
        // val firstTs = (dataPoints[0] as DataPoint).timestamp
        // listener?.onBatch(samples, firstTs)

        Log.d(TAG, "Stub handleBatch with $n points (uncomment REAL IMPL to forward)")
    }
}
