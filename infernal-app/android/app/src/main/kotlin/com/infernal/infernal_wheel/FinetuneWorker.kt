package com.infernal.infernal_wheel

import android.content.Context
import android.util.Log
import androidx.work.*
import java.io.File
import java.util.concurrent.TimeUnit

/**
 * WorkManager worker that runs the on-device fine-tuning in the background.
 *
 * Conditions:
 * - Battery >= 30% (not draining during training)
 * - Not low battery mode
 * - At least 10 positive training windows collected
 * - Last fine-tune was > 24h ago
 */
class FinetuneWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    companion object {
        private const val TAG = "FinetuneWorker"
        private const val WORK_NAME = "on_device_finetune"
        private const val LAST_FINETUNE_FILE = "last_finetune.txt"

        /**
         * Schedule the fine-tuning work. Call this once at app startup —
         * WorkManager handles deduplication via ExistingPeriodicWorkPolicy.
         */
        fun schedule(context: Context) {
            val constraints = Constraints.Builder()
                .setRequiresBatteryNotLow(true)
                .build()

            // Run once per day, with flex window of 6 hours
            val work = PeriodicWorkRequestBuilder<FinetuneWorker>(
                24, TimeUnit.HOURS,
                6, TimeUnit.HOURS,
            )
                .setConstraints(constraints)
                .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 1, TimeUnit.HOURS)
                .build()

            WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,  // Don't replace if already scheduled
                work,
            )
            Log.i(TAG, "Fine-tune work scheduled (every 24h, battery OK)")
        }
    }

    override fun doWork(): Result {
        Log.i(TAG, "Fine-tune worker started")

        // Check cooldown (24h since last run)
        val lastFinetuneFile = File(applicationContext.filesDir, LAST_FINETUNE_FILE)
        if (lastFinetuneFile.exists()) {
            val lastMs = lastFinetuneFile.readText().trim().toLongOrNull() ?: 0
            val hoursSince = (System.currentTimeMillis() - lastMs) / 3600_000
            if (hoursSince < 24) {
                Log.i(TAG, "Skipping — last fine-tune was ${hoursSince}h ago (need 24h)")
                return Result.success()
            }
        }

        // Run fine-tuning
        val trainer = OnDeviceTrainer(applicationContext)
        val baseModelPath = getBaseModelPath()
        if (baseModelPath == null) {
            Log.w(TAG, "Base model not found — skipping")
            return Result.success()
        }

        val result = trainer.finetune(baseModelPath)
        Log.i(TAG, "Fine-tune result: ${result.message}")

        if (result.success) {
            // Record timestamp
            lastFinetuneFile.writeText(System.currentTimeMillis().toString())

            // Push threshold config to watch via MessageClient
            try {
                pushConfigToWatch(result)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to push config to watch", e)
                // Not a fatal error — the config is saved locally
            }
        }

        return Result.success()
    }

    private fun getBaseModelPath(): String? {
        // The base model is bundled in the watch APK, but for phone-side
        // we need a copy. Check if we have the v6 tflite locally.
        val flutterDir = File(applicationContext.filesDir.parentFile, "app_flutter")
        val modelFile = File(flutterDir, "smoking_detector.tflite")
        if (modelFile.exists()) return modelFile.absolutePath

        // Try assets
        try {
            val assetStream = applicationContext.assets.open("smoking_detector.tflite")
            val bytes = assetStream.readBytes()
            assetStream.close()
            modelFile.parentFile?.mkdirs()
            modelFile.writeBytes(bytes)
            return modelFile.absolutePath
        } catch (e: Exception) {
            Log.w(TAG, "No base model in assets: ${e.message}")
        }

        return null
    }

    private fun pushConfigToWatch(result: OnDeviceTrainer.TrainResult) {
        // Send the personalized threshold to the watch via MessageClient
        val payload = org.json.JSONObject().apply {
            put("type", "threshold_update")
            put("threshold", result.finalLoss)  // Will be used by DetectionService
            put("accuracy", 1f - result.finalLoss)
            put("timestamp", System.currentTimeMillis())
        }

        val nodeClient = com.google.android.gms.wearable.Wearable.getNodeClient(applicationContext)
        val messageClient = com.google.android.gms.wearable.Wearable.getMessageClient(applicationContext)

        nodeClient.connectedNodes.addOnSuccessListener { nodes ->
            for (node in nodes) {
                messageClient.sendMessage(
                    node.id,
                    "/threshold_update",
                    payload.toString().toByteArray()
                ).addOnSuccessListener {
                    Log.i(TAG, "Threshold pushed to watch: ${node.displayName}")
                }.addOnFailureListener { e ->
                    Log.w(TAG, "Failed to push to ${node.displayName}", e)
                }
            }
        }
    }
}
