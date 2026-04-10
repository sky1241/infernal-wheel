package com.infernal.smokingdetector

import android.util.Base64
import java.io.ByteArrayOutputStream
import java.util.zip.GZIPOutputStream

/**
 * Time-series compression for IMU sensor data (watch → phone direction).
 *
 * Uses GZIP compression on XOR-delta-encoded float values.
 * Inspired by Gorilla (Facebook) time-series compression:
 * - XOR between consecutive values → many leading zeros
 * - GZIP catches the patterns → 85-95% compression
 *
 * For 225 samples x 6 channels = 1350 floats:
 * - Raw: 5400 bytes (1350 x 4)
 * - Delta + GZIP: ~300-800 bytes (85-95% reduction)
 * - Base64: ~400-1100 chars (safe for JSON/SQLite storage)
 *
 * Usage:
 *   val compressed = GorillaCompressor.compress(accel, gyro)  // → Base64 string
 *
 * Decompression happens on the Python side (finetune_cnn_v7.py,
 * test_compression.py) using the native `gzip` + `base64` modules.
 * The Kotlin object does not provide a decompress() — no watch-side caller
 * needs it, and keeping a symmetric but unused helper would just be dead
 * weight on the wearable.
 */
object GorillaCompressor {

    /**
     * Compress accel [N][3] + gyro [N][3] → Base64 string
     */
    fun compress(accel: Array<FloatArray>, gyro: Array<FloatArray>): String {
        val n = minOf(accel.size, gyro.size)
        if (n == 0) return ""

        // Flatten to interleaved: [AccX,AccY,AccZ,GyrX,GyrY,GyrZ] per sample
        val values = FloatArray(n * 6)
        for (i in 0 until n) {
            values[i * 6 + 0] = accel[i][0]
            values[i * 6 + 1] = accel[i][1]
            values[i * 6 + 2] = accel[i][2]
            values[i * 6 + 3] = gyro[i][0]
            values[i * 6 + 4] = gyro[i][1]
            values[i * 6 + 5] = gyro[i][2]
        }

        // Delta encoding: store first value, then differences
        // XOR on float bits captures small changes efficiently
        val deltaBytes = ByteArrayOutputStream(values.size * 4)

        // Write header: sample count (2 bytes) + channel count (1 byte)
        deltaBytes.write(n shr 8)
        deltaBytes.write(n and 0xFF)
        deltaBytes.write(6)

        // Write first sample raw (6 floats = 24 bytes)
        for (c in 0 until 6) {
            val bits = java.lang.Float.floatToIntBits(values[c])
            deltaBytes.write(bits shr 24)
            deltaBytes.write((bits shr 16) and 0xFF)
            deltaBytes.write((bits shr 8) and 0xFF)
            deltaBytes.write(bits and 0xFF)
        }

        // Write deltas (XOR with previous value)
        for (i in 6 until values.size) {
            val curr = java.lang.Float.floatToIntBits(values[i])
            val prev = java.lang.Float.floatToIntBits(values[i - 6]) // Same channel, previous sample
            val xor = curr xor prev
            deltaBytes.write(xor shr 24)
            deltaBytes.write((xor shr 16) and 0xFF)
            deltaBytes.write((xor shr 8) and 0xFF)
            deltaBytes.write(xor and 0xFF)
        }

        // GZIP compress the delta bytes
        val gzipOut = ByteArrayOutputStream()
        GZIPOutputStream(gzipOut).use { gz ->
            gz.write(deltaBytes.toByteArray())
        }

        // Base64 encode for storage
        return Base64.encodeToString(gzipOut.toByteArray(), Base64.NO_WRAP)
    }
}
