package com.infernal.smokingdetector

import android.util.Base64
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.util.zip.GZIPInputStream
import java.util.zip.GZIPOutputStream

/**
 * Time-series compression for IMU sensor data.
 *
 * Uses GZIP compression on delta-encoded float values.
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
 *   val (accel, gyro) = GorillaCompressor.decompress(compressed)
 */
object GorillaCompressor {

    private const val TAG = "GorillaCompressor"

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

    /**
     * Decompress Base64 string → accel [N][3] + gyro [N][3]
     *
     * Returns (empty, empty) on ANY error (corrupt base64, corrupt gzip,
     * truncated stream, mismatched header, invalid sample count). The caller
     * never sees an exception — corruption is treated as "no data" because
     * the alternative is a crash on the watch service.
     *
     * Hardened reads: stream.read() returns -1 at EOF; without explicit
     * checks the bit-shifts produce garbage 32-bit values that get
     * interpreted as floats, leading to NaN/Inf in the reconstructed
     * window and downstream model garbage.
     */
    fun decompress(compressed: String): Pair<Array<FloatArray>, Array<FloatArray>> {
        if (compressed.isEmpty()) return Pair(emptyArray(), emptyArray())

        return try {
            decompressInner(compressed)
        } catch (e: Exception) {
            android.util.Log.e(TAG, "decompress failed — returning empty", e)
            Pair(emptyArray(), emptyArray())
        }
    }

    private fun decompressInner(compressed: String): Pair<Array<FloatArray>, Array<FloatArray>> {
        // Base64 decode
        val gzipBytes = Base64.decode(compressed, Base64.NO_WRAP)

        // GZIP decompress
        val deltaBytes = ByteArrayInputStream(gzipBytes).use { bis ->
            GZIPInputStream(bis).use { gz -> gz.readBytes() }
        }

        val stream = ByteArrayInputStream(deltaBytes)

        // Read header (3 bytes minimum)
        if (deltaBytes.size < 3) return Pair(emptyArray(), emptyArray())
        val nHi = stream.read()
        val nLo = stream.read()
        if (nHi < 0 || nLo < 0) return Pair(emptyArray(), emptyArray())
        val n = (nHi shl 8) or nLo
        val channels = stream.read()

        if (channels != 6 || n <= 0) return Pair(emptyArray(), emptyArray())

        // Sanity bound: n is read from a 2-byte field so max 65535. At 6
        // floats × 4 bytes per sample that's ~1.5 MB on the watch heap.
        // Reject anything bigger than EXPECTED_MAX_SAMPLES to fail fast.
        if (n > MAX_SAMPLES_PER_WINDOW) return Pair(emptyArray(), emptyArray())

        // Verify the body has enough bytes for the declared sample count.
        // Format: header(3) + first sample(24 bytes) + (n-1) × 24 bytes deltas
        val expectedBodySize = 3 + n * 6 * 4
        if (deltaBytes.size != expectedBodySize) {
            android.util.Log.w(TAG, "decompress: declared n=$n needs $expectedBodySize bytes but stream has ${deltaBytes.size}")
            return Pair(emptyArray(), emptyArray())
        }

        // Read first sample (6 floats = 24 bytes)
        val values = FloatArray(n * 6)
        for (c in 0 until 6) {
            val b0 = stream.read()
            val b1 = stream.read()
            val b2 = stream.read()
            val b3 = stream.read()
            if (b0 < 0 || b1 < 0 || b2 < 0 || b3 < 0) return Pair(emptyArray(), emptyArray())
            val bits = (b0 shl 24) or (b1 shl 16) or (b2 shl 8) or b3
            values[c] = java.lang.Float.intBitsToFloat(bits)
        }

        // Read deltas and reconstruct
        for (i in 6 until values.size) {
            val b0 = stream.read()
            val b1 = stream.read()
            val b2 = stream.read()
            val b3 = stream.read()
            if (b0 < 0 || b1 < 0 || b2 < 0 || b3 < 0) return Pair(emptyArray(), emptyArray())
            val xor = (b0 shl 24) or (b1 shl 16) or (b2 shl 8) or b3
            val prevBits = java.lang.Float.floatToIntBits(values[i - 6])
            values[i] = java.lang.Float.intBitsToFloat(prevBits xor xor)
        }

        // Unflatten to accel[N][3] + gyro[N][3]
        val accel = Array(n) { i -> floatArrayOf(values[i * 6], values[i * 6 + 1], values[i * 6 + 2]) }
        val gyro = Array(n) { i -> floatArrayOf(values[i * 6 + 3], values[i * 6 + 4], values[i * 6 + 5]) }

        return Pair(accel, gyro)
    }

    // Hard cap on N (samples per window). Real callers max out around 300
    // samples (Samsung 25Hz batch) or 225 (50Hz CNN window). Anything bigger
    // is almost certainly a corrupted header that we should reject up front.
    private const val MAX_SAMPLES_PER_WINDOW: Int = 10_000

    /**
     * Estimate compression ratio for a given window.
     */
    fun compressionRatio(accel: Array<FloatArray>, gyro: Array<FloatArray>): Float {
        val rawSize = accel.size * 6 * 4f  // 6 channels x 4 bytes per float
        val compressed = compress(accel, gyro)
        val compressedSize = compressed.length * 0.75f  // Base64 overhead ~33%
        return if (rawSize > 0) 1f - (compressedSize / rawSize) else 0f
    }
}
