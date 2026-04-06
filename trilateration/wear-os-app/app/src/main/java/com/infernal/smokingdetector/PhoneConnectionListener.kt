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
) {

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
    }
}
