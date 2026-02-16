package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.PassiveMonitoringUpdate
import androidx.health.services.client.PassiveListenerCallback
import kotlinx.coroutines.*
import kotlin.math.roundToInt

/**
 * Health Services Manager for Real-Time Heart Rate
 *
 * Uses Wear OS Health Services API to monitor heart rate continuously.
 *
 * Features:
 * - Real-time HR monitoring (passive mode for battery efficiency)
 * - Baseline HR calculation (7-day rolling average)
 * - HR delta detection (current - baseline)
 * - Low power consumption (~1-2% battery/day)
 *
 * Strategy:
 * - Passive monitoring: HR updates when available (not continuous polling)
 * - Baseline calculation: Store last 7 days of resting HR
 * - Delta: Current HR - Baseline (useful for cigarette detection: +7-15 bpm)
 */
class HealthServicesManager(private val context: Context) {

    companion object {
        private const val TAG = "HealthServicesManager"
        private const val DEFAULT_BASELINE_HR = 70f
        private const val BASELINE_WINDOW_DAYS = 7
    }

    private var healthServicesClient: HealthServicesClient? = null
    private val passiveListenerCallback = object : PassiveListenerCallback {
        override fun onRegistered() {
            Log.d(TAG, "Health Services passive monitoring registered")
        }

        override fun onRegistrationFailed(throwable: Throwable) {
            Log.e(TAG, "Health Services registration failed", throwable)
        }

        override fun onPermissionLost() {
            Log.e(TAG, "Health Services permission lost")
        }

        override fun onPassiveMonitoringUpdate(update: PassiveMonitoringUpdate) {
            update.dataPoints.forEach { dataPoint ->
                when (dataPoint.dataType) {
                    DataType.HEART_RATE_BPM -> {
                        val hr = dataPoint.value.asDouble().roundToInt()
                        onHeartRateUpdate(hr.toFloat())
                    }
                }
            }
        }
    }

    private var currentHR = DEFAULT_BASELINE_HR
    private var baselineHR = DEFAULT_BASELINE_HR
    private val hrHistory = mutableListOf<Float>()

    /**
     * Start passive heart rate monitoring
     */
    suspend fun start(): Boolean {
        return withContext(Dispatchers.IO) {
            try {
                healthServicesClient = HealthServicesClient(context)

                val passiveMonitoringClient = healthServicesClient!!.passiveMonitoringClient

                // Register for passive heart rate updates
                passiveMonitoringClient.setPassiveListenerCallback(
                    passiveListenerCallback
                )

                Log.d(TAG, "Heart rate monitoring started (passive mode)")
                true
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start heart rate monitoring", e)
                false
            }
        }
    }

    /**
     * Stop heart rate monitoring
     */
    fun stop() {
        healthServicesClient?.let {
            val passiveMonitoringClient = it.passiveMonitoringClient
            passiveMonitoringClient.clearPassiveListenerCallbackAsync()
            Log.d(TAG, "Heart rate monitoring stopped")
        }
    }

    /**
     * Handle heart rate update
     */
    private fun onHeartRateUpdate(hr: Float) {
        currentHR = hr
        hrHistory.add(hr)

        // Keep last 7 days of HR data (assuming ~100 samples/day)
        if (hrHistory.size > BASELINE_WINDOW_DAYS * 100) {
            hrHistory.removeAt(0)
        }

        // Update baseline (average of lowest 20% of HR values - resting HR)
        if (hrHistory.size > 10) {
            val sorted = hrHistory.sorted()
            val restingCount = (sorted.size * 0.2).toInt().coerceAtLeast(5)
            baselineHR = sorted.take(restingCount).average().toFloat()
        }

        Log.d(TAG, "HR update: current=$hr, baseline=$baselineHR, delta=${hr - baselineHR}")
    }

    /**
     * Get current heart rate
     */
    fun getCurrentHR(): Float {
        return currentHR
    }

    /**
     * Get baseline heart rate (resting)
     */
    fun getBaselineHR(): Float {
        return baselineHR
    }

    /**
     * Get heart rate delta (current - baseline)
     * Useful for cigarette detection: +7-15 bpm spike
     */
    fun getHRDelta(): Float {
        return currentHR - baselineHR
    }
}
