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
        // BUG+050 fix: was 50f, which combined with STAY_POINT_RADIUS_M=50m
        // meant Android only delivered location callbacks AFTER the user had
        // already moved beyond the stay radius. The `distance < 50m` branch
        // in onLocationChanged could therefore essentially never fire, and
        // stay-point detection was dead code. Dropped to 5m so the listener
        // fires on micro-movements inside a stay (walking around the kitchen,
        // reaching for a phone, etc.) and the duration check can accumulate
        // time at the same location.
        private const val GPS_MIN_DISTANCE_M = 5f

        // Cluster labels
        const val CLUSTER_HOME = 0
        const val CLUSTER_WORK = 1
        const val CLUSTER_BAR = 2
        const val CLUSTER_OTHER = 3
    }

    private val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager

    // Synchronized list to protect against race between LocationListener
    // callbacks (writer) and the inference thread (reader via getCurrentCluster).
    // BUG+012: was a bare mutableListOf, ConcurrentModificationException possible
    // when minByOrNull iterated while a new stay point was being added.
    private val stayPoints = java.util.Collections.synchronizedList(mutableListOf<StayPoint>())
    @Volatile private var currentLocation: Location? = null
    @Volatile private var currentStayStart: Long? = null

    @Volatile private var currentCluster = CLUSTER_OTHER

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
     * Update current cluster based on location.
     *
     * BUG+009 fix: this used to set currentCluster = sp.cluster (the raw
     * DBSCAN cluster id, e.g. 0/1/2/3 in arrival order). The caller in
     * DetectionService writes that int into the gps_cluster DB column
     * expecting CLUSTER_HOME=0/CLUSTER_WORK=1/CLUSTER_BAR=2/CLUSTER_OTHER=3
     * — completely different semantics. Now we map sp.clusterName to the
     * proper constant before assigning.
     *
     * BUG+012 fix: snapshot the synchronized list to a local copy before
     * iterating with minByOrNull — Collections.synchronizedList only
     * synchronizes individual ops, not iteration.
     */
    private fun updateCurrentCluster(location: Location) {
        // Snapshot under the list's intrinsic lock to avoid CME during
        // iteration of minByOrNull.
        val snapshot = synchronized(stayPoints) { stayPoints.toList() }

        if (snapshot.isEmpty()) {
            currentCluster = CLUSTER_OTHER
            return
        }

        // Find nearest stay point cluster
        val nearest = snapshot.minByOrNull { sp ->
            haversineDistance(location.latitude, location.longitude, sp.lat, sp.lon)
        }

        nearest?.let { sp ->
            val distance = haversineDistance(location.latitude, location.longitude, sp.lat, sp.lon)
            if (distance < DBSCAN_EPS_M) {
                currentCluster = clusterNameToId(sp.clusterName)
                Log.d(TAG, "Current cluster: $currentCluster (${sp.clusterName}, distance=${distance.toInt()}m)")
            } else {
                currentCluster = CLUSTER_OTHER
            }
        }
    }

    /** Map a semantic cluster name to its public int constant. */
    private fun clusterNameToId(name: String): Int = when (name) {
        "home" -> CLUSTER_HOME
        "work" -> CLUSTER_WORK
        "bar" -> CLUSTER_BAR
        else -> CLUSTER_OTHER
    }

    /**
     * DBSCAN clustering on stay points.
     *
     * BUG+011 fix: the previous version skipped points whose cluster was
     * already != -1, so once a point was classified it could never be
     * re-evaluated even if more data arrived that should merge it into
     * a different cluster. Now we RESET every point to -1 at the start
     * of each run and re-classify from scratch — for a small list of
     * stay points (typically < 200) this is cheap and always correct.
     *
     * BUG+010 fix: the time-of-day labeling had hour gaps (8.5 and 17.5
     * fell into "other") and overlaps (22.5 matched both home and bar
     * branches, with home winning by ordering). Now uses an exhaustive
     * partition that maps every avgHour ∈ [0, 24) to exactly one bucket.
     *
     * BUG+012 fix: take a snapshot of the synchronized list before
     * iterating to avoid ConcurrentModificationException.
     */
    private fun clusterStayPoints() {
        val snapshot = synchronized(stayPoints) {
            // Reset before re-clustering — see BUG+011 fix above.
            stayPoints.forEach { it.cluster = -1; it.clusterName = "other" }
            stayPoints.toList()
        }

        var clusterLabel = 0
        for (point in snapshot) {
            if (point.cluster != -1) continue // Already classified by an earlier core point in this run

            val neighbors = snapshot.filter { other ->
                haversineDistance(point.lat, point.lon, other.lat, other.lon) < DBSCAN_EPS_M
            }

            if (neighbors.size >= DBSCAN_MIN_PTS) {
                // Core point — create a new cluster and label every neighbor
                val avgHour = neighbors.map { it.hour }.average()
                val name = labelByHour(avgHour)
                neighbors.forEach {
                    it.cluster = clusterLabel
                    it.clusterName = name
                }
                Log.d(TAG, "Cluster $clusterLabel: $name (${neighbors.size} points, avgHour=$avgHour)")
                clusterLabel++
            } else {
                point.cluster = -1
                point.clusterName = "other"
            }
        }
    }

    /**
     * Map an average-hour value to a semantic location label.
     *
     * Partition (every hour belongs to exactly one bucket, no gaps, no overlaps):
     *   home : 22.0 <= h or h < 8.0     (10h, sleep + early morning)
     *   work : 8.0 <= h < 18.0          (10h, working day)
     *   bar  : 18.0 <= h < 22.0         (4h, early evening)
     *
     * The avgHour input is a Double (mean of integer hours), so values
     * like 8.5 and 17.5 are valid and must land in a deterministic bucket.
     */
    private fun labelByHour(avgHour: Double): String = when {
        avgHour >= 22.0 || avgHour < 8.0 -> "home"
        avgHour < 18.0 -> "work"   // covers 8.0..17.999
        else -> "bar"              // covers 18.0..21.999
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
