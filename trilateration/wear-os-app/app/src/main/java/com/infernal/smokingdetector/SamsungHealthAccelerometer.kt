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
 *   2. Download the "Health Sensor SDK" AAR
 *   3. Drop it into trilateration/wear-os-app/app/libs/samsung-health-sensor-sdk.aar
 *   4. Uncomment the implementation block at the bottom of this file
 *   5. Sync gradle
 *
 * Until the AAR is added, this class compiles as a STUB that logs warnings
 * and never delivers data. Phase 1 (50Hz boost) still works without it.
 *
 * Reference: https://developer.samsung.com/health/sensor/overview.html
 */
class SamsungHealthAccelerometer(private val context: Context) {

    companion object {
        private const val TAG = "SamsungHealthAccel"
        const val SAMPLE_RATE_HZ = 25
        const val EXPECTED_BATCH_SIZE = 300  // ~12s @ 25Hz
    }

    /**
     * Callback receiving batches of accel samples from the Samsung SDK.
     *
     * @param samples Array of 3-float arrays [AccX, AccY, AccZ] in m/s^2
     * @param timestampNs Nanosecond timestamp of the FIRST sample in the batch
     */
    fun interface BatchListener {
        fun onBatch(samples: Array<FloatArray>, timestampNs: Long)
    }

    private var listener: BatchListener? = null
    private var isConnected: Boolean = false
    private var isAvailable: Boolean = false

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
            Log.w(TAG, "Samsung Health Sensor SDK not present — drop the AAR in app/libs/ to enable")
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

        // ── REAL IMPLEMENTATION (uncomment after adding AAR) ──
        //
        // import com.samsung.android.service.health.tracking.HealthTrackerType
        // import com.samsung.android.service.health.tracking.HealthTrackingService
        // import com.samsung.android.service.health.tracking.ConnectionListener
        // import com.samsung.android.service.health.tracking.data.DataPoint
        // import com.samsung.android.service.health.tracking.data.ValueKey
        //
        // val connectionListener = object : ConnectionListener {
        //     override fun onConnectionSuccess() {
        //         isConnected = true
        //         val tracker = healthTrackingService!!.getHealthTracker(
        //             HealthTrackerType.ACCELEROMETER_CONTINUOUS
        //         )
        //         tracker.setEventListener { dataPoints: List<DataPoint> ->
        //             handleBatch(dataPoints)
        //         }
        //     }
        //     override fun onConnectionEnded() { isConnected = false }
        //     override fun onConnectionFailed(e: HealthTrackerException) {
        //         Log.e(TAG, "Samsung tracking service connection failed", e)
        //         isConnected = false
        //     }
        // }
        // healthTrackingService = HealthTrackingService(connectionListener, context)
        // healthTrackingService!!.connectService()

        Log.w(TAG, "Samsung SDK stub connect() — real implementation pending AAR install")
        isAvailable = false
    }

    /**
     * Stop receiving batches and release the tracking service.
     */
    fun disconnect() {
        if (!isConnected) return

        // ── REAL IMPLEMENTATION (uncomment after adding AAR) ──
        //
        // healthTrackingService?.disconnectService()
        // healthTrackingService = null

        isConnected = false
        isAvailable = false
        Log.d(TAG, "Disconnected")
    }

    fun isActive(): Boolean = isConnected && isAvailable

    // ─────────────────────────────────────────────────────────────────────
    // Internal — convert Samsung DataPoint format to our (Float, Float, Float)
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Called from the Samsung SDK event listener with a batch of DataPoints.
     * Each DataPoint contains x, y, z values via ValueKey.AccelerometerSet.
     *
     * NOTE: this method is not currently called — it's the target shape for
     * when the AAR is wired in. See REAL IMPLEMENTATION block above.
     */
    @Suppress("unused")
    private fun handleBatchMock(dataPoints: List<Any>) {
        val n = dataPoints.size
        if (n == 0) return

        // ── REAL IMPLEMENTATION (uncomment after adding AAR) ──
        //
        // val samples = Array(n) { i ->
        //     val dp = dataPoints[i] as DataPoint
        //     floatArrayOf(
        //         dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_X).toFloat(),
        //         dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Y).toFloat(),
        //         dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Z).toFloat(),
        //     )
        // }
        // val firstTs = (dataPoints[0] as DataPoint).timestamp
        // listener?.onBatch(samples, firstTs)

        Log.d(TAG, "Mock handleBatch called with $n points")
    }
}
