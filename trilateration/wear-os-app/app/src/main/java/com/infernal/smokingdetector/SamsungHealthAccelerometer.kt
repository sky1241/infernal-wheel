package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import com.samsung.android.service.health.tracking.ConnectionListener
import com.samsung.android.service.health.tracking.HealthTracker
import com.samsung.android.service.health.tracking.HealthTrackerException
import com.samsung.android.service.health.tracking.HealthTrackingService
import com.samsung.android.service.health.tracking.data.DataPoint
import com.samsung.android.service.health.tracking.data.HealthTrackerType
import com.samsung.android.service.health.tracking.data.ValueKey

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
 * AAR location
 * ------------
 * Drop samsung-health-sensor-api-*.aar into trilateration/wear-os-app/app/libs/
 * The build.gradle.kts picks it up automatically via fileTree.
 *
 * References:
 * - https://developer.samsung.com/health/sensor/overview.html
 * - API verified against samsung-health-sensor-api-1.4.1.aar via javap
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
         *                       = 0.002395 * raw_value (approximately)
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

    private var healthTrackingService: HealthTrackingService? = null
    private var accelTracker: HealthTracker? = null

    // Diagnostic counters — visible via Log.i, used to PROVE the SDK delivers
    // data on a real watch (not just compiles).
    private var batchCount: Long = 0
    private var totalSamplesReceived: Long = 0
    private var firstBatchTimeMs: Long = 0L

    // ─────────────────────────────────────────────────────────────────────
    // Public API — used by DetectionService
    // ─────────────────────────────────────────────────────────────────────

    /**
     * Returns true if the Samsung Health Sensor SDK is present at runtime.
     * Detection is done by reflection so the rest of the project gracefully
     * degrades on devices that don't have the underlying Samsung Health
     * service installed (e.g. non-Galaxy watches, emulators, dev builds).
     */
    fun isSdkAvailable(): Boolean {
        return try {
            Class.forName("com.samsung.android.service.health.tracking.HealthTrackingService")
            true
        } catch (e: ClassNotFoundException) {
            Log.w(TAG, "Samsung Health Sensor SDK class not present at runtime")
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

        val connectionListener = object : ConnectionListener {
            override fun onConnectionSuccess() {
                Log.d(TAG, "Samsung tracking service connected")
                isConnected = true
                try {
                    val tracker = healthTrackingService!!.getHealthTracker(
                        HealthTrackerType.ACCELEROMETER_CONTINUOUS
                    )
                    tracker.setEventListener(object : HealthTracker.TrackerEventListener {
                        override fun onDataReceived(dataPoints: MutableList<DataPoint>) {
                            handleBatch(dataPoints)
                        }
                        override fun onFlushCompleted() {
                            Log.d(TAG, "Flush completed")
                        }
                        override fun onError(error: HealthTracker.TrackerError) {
                            Log.e(TAG, "Tracker error: $error")
                        }
                    })
                    accelTracker = tracker
                    isAvailable = true
                    Log.d(TAG, "ACCELEROMETER_CONTINUOUS tracker active @ ${SAMPLE_RATE_HZ}Hz")
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to start accelerometer tracker", e)
                    isAvailable = false
                }
            }

            override fun onConnectionEnded() {
                Log.d(TAG, "Samsung tracking service ended")
                isConnected = false
                isAvailable = false
            }

            override fun onConnectionFailed(e: HealthTrackerException) {
                Log.e(TAG, "Samsung tracking service connection failed: code=${e.errorCode}", e)
                isConnected = false
                isAvailable = false
            }
        }

        try {
            healthTrackingService = HealthTrackingService(connectionListener, context.applicationContext)
            healthTrackingService!!.connectService()
            Log.d(TAG, "connectService() called, awaiting callback")
        } catch (e: Throwable) {
            Log.e(TAG, "Failed to instantiate HealthTrackingService", e)
            isConnected = false
            isAvailable = false
        }
    }

    /**
     * Stop receiving batches and release the tracking service.
     */
    fun disconnect() {
        if (!isConnected && !isAvailable) return

        try {
            accelTracker?.unsetEventListener()
        } catch (e: Exception) {
            Log.w(TAG, "unsetEventListener failed", e)
        }
        accelTracker = null

        try {
            healthTrackingService?.disconnectService()
        } catch (e: Exception) {
            Log.w(TAG, "disconnectService failed", e)
        }
        healthTrackingService = null

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
     */
    private fun handleBatch(dataPoints: List<DataPoint>) {
        val n = dataPoints.size
        if (n == 0) return

        val samples = Array(n) { i ->
            val dp = dataPoints[i]
            val rawX = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_X)
            val rawY = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Y)
            val rawZ = dp.getValue(ValueKey.AccelerometerSet.ACCELEROMETER_Z)
            floatArrayOf(
                rawIntToMs2(rawX),
                rawIntToMs2(rawY),
                rawIntToMs2(rawZ),
            )
        }
        val firstTs = dataPoints[0].timestamp

        // Diagnostics — proves the SDK is delivering real data
        batchCount++
        totalSamplesReceived += n
        if (firstBatchTimeMs == 0L) {
            firstBatchTimeMs = System.currentTimeMillis()
            // FIRST batch — print at INFO so it's visible in default logcat filter
            Log.i(TAG, "[FIRST BATCH] Samsung SDK delivered $n samples — pipeline is LIVE")
            // Print sample 0 values for human inspection
            val s0 = samples[0]
            Log.i(TAG, "[FIRST BATCH] sample[0] = (${s0[0]}, ${s0[1]}, ${s0[2]}) m/s²")
        }
        // Periodic stats every 25 batches (~5 minutes at default cadence)
        if (batchCount % 25 == 0L) {
            val elapsedMs = System.currentTimeMillis() - firstBatchTimeMs
            val ratePerSec = if (elapsedMs > 0) totalSamplesReceived * 1000.0 / elapsedMs else 0.0
            Log.i(TAG, "[STATS] batches=$batchCount samples=$totalSamplesReceived rate=${"%.1f".format(ratePerSec)}Hz over ${elapsedMs / 1000}s")
        }

        listener?.onBatch(samples, firstTs)
    }

    /** Diagnostics getter — used by tests / DetectionService for proof of life. */
    fun getBatchCount(): Long = batchCount
    fun getTotalSamplesReceived(): Long = totalSamplesReceived
}
