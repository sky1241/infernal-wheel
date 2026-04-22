package com.infernal.smokingdetector

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.Node
import com.google.android.gms.wearable.Wearable
import kotlinx.coroutines.*
import kotlinx.coroutines.tasks.await

/**
 * Listens for phone connect/disconnect events.
 * When phone reconnects, auto-flushes buffered detections.
 *
 * Registered in DetectionService (runs as long as monitoring is active).
 */
class PhoneConnectionListener(
    private val context: Context,
    private val syncManager: MessageSyncManager
) : com.google.android.gms.wearable.MessageClient.OnMessageReceivedListener {

    companion object {
        private const val TAG = "PhoneConnListener"
        private const val CHECK_INTERVAL_MS = 60_000L // Check every 1 min
    }

    private var job: Job? = null
    private var wasConnected = false

    /**
     * Start polling for phone connection changes.
     * (NodeClient.addListener requires a WearableListenerService;
     * polling is simpler for our use case.)
     */
    fun start(scope: CoroutineScope) {
        // Listen for messages from phone (threshold updates, model updates)
        Wearable.getMessageClient(context).addListener(this)

        job = scope.launch {
            while (isActive) {
                try {
                    val nodes = Wearable.getNodeClient(context).connectedNodes.await()
                    val isConnected = nodes.isNotEmpty()

                    if (isConnected && !wasConnected) {
                        // Phone just reconnected — flush buffer
                        Log.d(TAG, "Phone reconnected! Flushing buffer...")
                        syncManager.flushBuffer()
                    }

                    wasConnected = isConnected

                    if (!isConnected) {
                        val pending = syncManager.getPendingCount()
                        if (pending > 0) {
                            Log.d(TAG, "Phone offline, $pending events buffered")
                        }
                    }
                } catch (e: Exception) {
                    Log.w(TAG, "Connection check failed", e)
                }

                delay(CHECK_INTERVAL_MS)
            }
        }
    }

    fun stop() {
        job?.cancel()
        job = null
        Wearable.getMessageClient(context).removeListener(this)
    }

    /**
     * Handle messages from the phone — currently: threshold updates
     * from the on-device fine-tuning pipeline.
     */
    override fun onMessageReceived(messageEvent: com.google.android.gms.wearable.MessageEvent) {
        val path = messageEvent.path
        val data = String(messageEvent.data)

        Log.i(TAG, "Message from phone: path=$path size=${data.length}")

        when (path) {
            "/threshold_update" -> {
                try {
                    val json = org.json.JSONObject(data)
                    val threshold = json.optDouble("threshold", -1.0).toFloat()
                    if (threshold > 0f && threshold < 1f) {
                        // Save to SharedPreferences so DetectionService picks it up
                        val prefs = context.getSharedPreferences(
                            "smoking_detector_prefs", android.content.Context.MODE_PRIVATE
                        )
                        prefs.edit().putFloat("personal_threshold", threshold).apply()
                        Log.i(TAG, "Personal threshold updated: $threshold")
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to parse threshold_update", e)
                }
            }
        }
    }
}
