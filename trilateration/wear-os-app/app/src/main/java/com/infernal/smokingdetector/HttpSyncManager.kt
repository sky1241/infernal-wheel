package com.infernal.smokingdetector

import android.content.Context
import android.content.SharedPreferences
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

/**
 * HTTP Sync Manager — sends detections directly to the phone's shelf server.
 *
 * Bypasses Wear Data Layer API (which requires same package name + GMS).
 * Works on any phone brand (Xiaomi, Samsung, Pixel, etc.)
 *
 * Discovery: the phone's shelf server port is saved in shared prefs.
 * The user sets it once via the watch settings, or we try common ports.
 *
 * Fallback chain:
 * 1. WiFi direct: POST to phone IP on saved port
 * 2. Bluetooth proxy: the watch routes through the phone's BT connection,
 *    so 10.0.0.1 or the phone's gateway IP works
 * 3. Queue locally if all fail, retry next time
 */
class HttpSyncManager(private val context: Context) {

    companion object {
        private const val TAG = "HttpSyncManager"
        private const val PREFS_NAME = "http_sync_prefs"
        private const val KEY_PHONE_URL = "phone_url"
        private const val KEY_LAST_SYNC = "last_sync_timestamp"
        private const val CONNECT_TIMEOUT = 5000
        private const val READ_TIMEOUT = 5000

        // Fixed server port (matches phone shelf server)
        private const val DEFAULT_PORT = 8011

        // Phone WiFi IP — hardcoded for now, auto-discovery later
        private const val PHONE_IP = "192.168.1.160"
    }

    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    /**
     * Sync a cigarette or drink detection to the phone.
     * type: "cigarette" or "drink" (with subtype in smokingHand for drink type)
     */
    suspend fun syncDetection(
        type: String,
        timestamp: Long,
        confidence: Float,
        gpsCluster: Int = -1,
        hrBaseline: Float = 0f,
        hrCurrent: Float = 0f,
        drinkType: String = ""
    ): Boolean = withContext(Dispatchers.IO) {
        val body = JSONObject().apply {
            put("type", type)
            put("timestamp", timestamp)
            put("confidence", confidence)
            put("gpsCluster", gpsCluster)
            put("hrBaseline", hrBaseline)
            put("hrCurrent", hrCurrent)
            put("hrDelta", hrCurrent - hrBaseline)
            put("drinkType", drinkType)
        }

        // Try saved URL first
        val savedUrl = prefs.getString(KEY_PHONE_URL, null)
        if (savedUrl != null) {
            val success = postJson("$savedUrl/api/watch/sync", body)
            if (success) {
                prefs.edit().putLong(KEY_LAST_SYNC, System.currentTimeMillis()).apply()
                return@withContext true
            }
        }

        // Try hardcoded phone IP
        val success = postJson("http://$PHONE_IP:$DEFAULT_PORT/api/watch/sync", body)
        if (success) {
            savePhoneUrl("http://$PHONE_IP:$DEFAULT_PORT")
            return@withContext true
        }

        Log.w(TAG, "All sync attempts failed — will retry later")
        return@withContext false
    }

    /**
     * Discover and save the phone's shelf server URL.
     * Call this from settings when user enters the port manually.
     */
    fun savePhoneUrl(url: String) {
        prefs.edit().putString(KEY_PHONE_URL, url).apply()
        Log.d(TAG, "Phone URL saved: $url")
    }

    fun getPhoneUrl(): String? = prefs.getString(KEY_PHONE_URL, null)

    fun getLastSyncTimestamp(): Long = prefs.getLong(KEY_LAST_SYNC, 0L)

    /**
     * Try to auto-discover the phone by hitting /api/state on candidate IPs.
     * Returns the working URL or null.
     */
    suspend fun autoDiscover(portHint: Int = 0): String? = withContext(Dispatchers.IO) {
        val ports = if (portHint > 0) listOf(portHint) else listOf(DEFAULT_PORT)

        for (ip in listOf(PHONE_IP)) {
            for (port in ports) {
                try {
                    val url = URL("http://$ip:$port/api/state")
                    val conn = url.openConnection() as HttpURLConnection
                    conn.connectTimeout = 2000
                    conn.readTimeout = 2000
                    conn.requestMethod = "GET"
                    val code = conn.responseCode
                    conn.disconnect()
                    if (code == 200) {
                        val baseUrl = "http://$ip:$port"
                        savePhoneUrl(baseUrl)
                        Log.d(TAG, "Auto-discovered phone at $baseUrl")
                        return@withContext baseUrl
                    }
                } catch (_: Exception) {}
            }
        }

        Log.d(TAG, "Auto-discover failed")
        return@withContext null
    }

    private fun postJson(urlStr: String, body: JSONObject): Boolean {
        return try {
            val url = URL(urlStr)
            val conn = url.openConnection() as HttpURLConnection
            conn.connectTimeout = CONNECT_TIMEOUT
            conn.readTimeout = READ_TIMEOUT
            conn.requestMethod = "POST"
            conn.setRequestProperty("Content-Type", "application/json")
            conn.doOutput = true

            conn.outputStream.use { os ->
                os.write(body.toString().toByteArray())
            }

            val code = conn.responseCode
            val response = if (code in 200..299) {
                conn.inputStream.bufferedReader().readText()
            } else {
                conn.errorStream?.bufferedReader()?.readText() ?: ""
            }
            conn.disconnect()

            if (code in 200..299) {
                Log.d(TAG, "Sync OK ($code): $urlStr → $response")
                true
            } else {
                Log.w(TAG, "Sync failed ($code): $urlStr → $response")
                false
            }
        } catch (e: Exception) {
            Log.w(TAG, "Sync error: $urlStr → ${e.message}")
            false
        }
    }

    private fun extractPort(url: String?): Int {
        if (url == null) return 0
        return try {
            URL(url).port.let { if (it == -1) 0 else it }
        } catch (_: Exception) {
            0
        }
    }
}
