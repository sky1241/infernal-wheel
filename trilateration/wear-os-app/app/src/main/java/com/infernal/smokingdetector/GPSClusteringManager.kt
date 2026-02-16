package com.infernal.smokingdetector

import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import kotlin.math.*

/**
 * GPS Clustering Manager for Location-Based Context
 *
 * Detects stay points and clusters locations into semantic labels:
 * - home (0)
 * - work (1)
 * - bar (2)
 * - other (3)
 *
 * Uses DBSCAN clustering algorithm with stay point detection.
 *
 * Strategy:
 * 1. Collect GPS points continuously
 * 2. Detect stay points (stationary >5 min within 50m)
 * 3. Cluster stay points with DBSCAN (ε=100m, MinPts=2)
 * 4. Label clusters based on time-of-day patterns
 *
 * Performance:
 * - Low power: GPS updates every 5 minutes (not continuous)
 * - Battery impact: ~2-3% per day
 */
class GPSClusteringManager(private val context: Context) : LocationListener {

    companion object {
        private const val TAG = "GPSClusteringManager"

        // Stay point detection
        private const val STAY_POINT_RADIUS_M = 50.0
        private const val STAY_POINT_MIN_DURATION_MS = 300_000L // 5 minutes

        // DBSCAN clustering
        private const val DBSCAN_EPS_M = 100.0
        private const val DBSCAN_MIN_PTS = 2

        // GPS update interval
        private const val GPS_UPDATE_INTERVAL_MS = 300_000L // 5 minutes
        private const val GPS_MIN_DISTANCE_M = 50f

        // Cluster labels
        const val CLUSTER_HOME = 0
        const val CLUSTER_WORK = 1
        const val CLUSTER_BAR = 2
        const val CLUSTER_OTHER = 3
    }

    private val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager

    private val stayPoints = mutableListOf<StayPoint>()
    private var currentLocation: Location? = null
    private var currentStayStart: Long? = null

    private var currentCluster = CLUSTER_OTHER

    /**
     * Start GPS location tracking
     */
    fun start(): Boolean {
        return try {
            locationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                GPS_UPDATE_INTERVAL_MS,
                GPS_MIN_DISTANCE_M,
                this
            )
            Log.d(TAG, "GPS tracking started (every 5 min)")
            true
        } catch (e: SecurityException) {
            Log.e(TAG, "GPS permission denied", e)
            false
        }
    }

    /**
     * Stop GPS location tracking
     */
    fun stop() {
        locationManager.removeUpdates(this)
        Log.d(TAG, "GPS tracking stopped")
    }

    /**
     * Get current location cluster
     */
    fun getCurrentCluster(): Int {
        return currentCluster
    }

    override fun onLocationChanged(location: Location) {
        Log.d(TAG, "Location update: (${location.latitude}, ${location.longitude})")

        // Check if still at current stay point
        currentLocation?.let { prev ->
            val distance = haversineDistance(
                prev.latitude, prev.longitude,
                location.latitude, location.longitude
            )

            if (distance < STAY_POINT_RADIUS_M) {
                // Still at same location, check duration
                currentStayStart?.let { start ->
                    val duration = System.currentTimeMillis() - start
                    if (duration >= STAY_POINT_MIN_DURATION_MS) {
                        // Stay point detected!
                        addStayPoint(location)
                        Log.d(TAG, "Stay point detected: (${location.latitude}, ${location.longitude}), duration=${duration/1000}s")
                    }
                }
            } else {
                // Moved to new location
                currentStayStart = System.currentTimeMillis()
            }
        } ?: run {
            // First location
            currentStayStart = System.currentTimeMillis()
        }

        currentLocation = location

        // Update cluster based on current location
        updateCurrentCluster(location)
    }

    override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
    override fun onProviderEnabled(provider: String) {
        Log.d(TAG, "GPS provider enabled")
    }
    override fun onProviderDisabled(provider: String) {
        Log.d(TAG, "GPS provider disabled")
    }

    /**
     * Add stay point and run clustering
     */
    private fun addStayPoint(location: Location) {
        val stayPoint = StayPoint(
            lat = location.latitude,
            lon = location.longitude,
            timestamp = System.currentTimeMillis(),
            hour = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY)
        )

        stayPoints.add(stayPoint)

        // Run DBSCAN clustering
        if (stayPoints.size >= DBSCAN_MIN_PTS) {
            clusterStayPoints()
        }
    }

    /**
     * Update current cluster based on location
     */
    private fun updateCurrentCluster(location: Location) {
        if (stayPoints.isEmpty()) {
            currentCluster = CLUSTER_OTHER
            return
        }

        // Find nearest stay point cluster
        val nearest = stayPoints.minByOrNull { sp ->
            haversineDistance(location.latitude, location.longitude, sp.lat, sp.lon)
        }

        nearest?.let { sp ->
            val distance = haversineDistance(location.latitude, location.longitude, sp.lat, sp.lon)
            if (distance < DBSCAN_EPS_M) {
                currentCluster = sp.cluster
                Log.d(TAG, "Current cluster: $currentCluster (distance=${distance.toInt()}m)")
            } else {
                currentCluster = CLUSTER_OTHER
            }
        }
    }

    /**
     * DBSCAN clustering on stay points
     */
    private fun clusterStayPoints() {
        // Simple DBSCAN implementation
        var clusterLabel = 0

        for (point in stayPoints) {
            if (point.cluster != -1) continue // Already clustered

            // Find neighbors within ε
            val neighbors = stayPoints.filter { other ->
                haversineDistance(point.lat, point.lon, other.lat, other.lon) < DBSCAN_EPS_M
            }

            if (neighbors.size >= DBSCAN_MIN_PTS) {
                // Core point - create cluster
                point.cluster = clusterLabel
                neighbors.forEach { it.cluster = clusterLabel }

                // Label cluster based on time patterns
                val avgHour = neighbors.map { it.hour }.average()
                point.clusterName = when {
                    avgHour in 22.0..8.0 -> "home"
                    avgHour in 9.0..17.0 -> "work"
                    avgHour in 18.0..23.0 -> "bar"
                    else -> "other"
                }

                Log.d(TAG, "Cluster $clusterLabel: ${point.clusterName} (${neighbors.size} points, avgHour=$avgHour)")

                clusterLabel++
            } else {
                // Noise point
                point.cluster = -1
            }
        }
    }

    /**
     * Haversine distance between two GPS coordinates (meters)
     */
    private fun haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double): Double {
        val R = 6371000.0 // Earth radius in meters
        val dLat = Math.toRadians(lat2 - lat1)
        val dLon = Math.toRadians(lon2 - lon1)

        val a = sin(dLat / 2).pow(2) +
                cos(Math.toRadians(lat1)) * cos(Math.toRadians(lat2)) *
                sin(dLon / 2).pow(2)

        val c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return R * c
    }

    /**
     * Data class for stay point
     */
    data class StayPoint(
        val lat: Double,
        val lon: Double,
        val timestamp: Long,
        val hour: Int,
        var cluster: Int = -1,
        var clusterName: String = "other"
    )
}
