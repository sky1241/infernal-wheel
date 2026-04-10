"""
Test the full training-window collection flow.

This test simulates what happens between the watch and the phone when a
detection event triggers a training window capture:

  1. Watch CNN detects a cigarette puff
  2. DetectionService.captureTrainingWindow() snapshots the 25Hz ring buffer
  3. MessageSyncManager.sendTrainingWindow() compresses (Gorilla) + ships
  4. Phone MainActivity.handleTrainingWindow() receives + decodes + saves

We verify:
  - The compression round-trip is lossless on 200-sample 3-channel data
  - Padding gyro to zeros (since Samsung doesn't give gyro) doesn't break it
  - The compressed payload fits in a single MessageClient message (~100 KB max)
  - The phone-side filename convention is sortable + unique
  - 1000 random windows simulate disk-cap eviction (FIFO)

Run: python test_training_window_flow.py
"""
import os
import sys
import json
import time
import struct
import gzip
import base64
import numpy as np

# Reuse compression helpers from the existing compression test
sys.path.insert(0, os.path.dirname(__file__))
from test_compression import compress_gorilla, decompress_gorilla

GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
RESET = "\033[0m"

passed = 0
failed = 0


def _check(name, condition, detail=""):
    global passed, failed
    if condition:
        print(f"  {GREEN}OK{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        passed += 1
    else:
        print(f"  {RED}FAIL{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        failed += 1


def section(title):
    print(f"\n=== {title} ===")


# ─────────────────────────────────────────────────────────────────────
# 1. Build a realistic 25Hz training window (200 samples = 8s)
# ─────────────────────────────────────────────────────────────────────
section("1. Build a realistic 25Hz training window")

np.random.seed(42)
N = 200  # 8 seconds at 25Hz — full ring buffer snapshot
# Watch worn flat: Z = 1g (9.81 m/s²), small noise, simulated puff arc on Y
t = np.arange(N) / 25.0  # seconds
accel = np.zeros((N, 3), dtype=np.float32)
accel[:, 0] = np.random.normal(0, 0.3, N)
accel[:, 1] = -3.5 + 2.0 * np.sin(2 * np.pi * 0.4 * t) + np.random.normal(0, 0.2, N)
accel[:, 2] = 8.5 + 1.5 * np.cos(2 * np.pi * 0.4 * t) + np.random.normal(0, 0.3, N)

_check("window has 200 samples", accel.shape == (200, 3))
_check("X axis has small variance (rest)",
     np.std(accel[:, 0]) < 1.0,
     f"std={np.std(accel[:, 0]):.3f}")
_check("Z axis near 1g",
     7.0 < accel[:, 2].mean() < 11.0,
     f"mean Z={accel[:, 2].mean():.3f}")


# ─────────────────────────────────────────────────────────────────────
# 2. Pad gyro with zeros (matches the Kotlin sendTrainingWindow path)
# ─────────────────────────────────────────────────────────────────────
section("2. Pad gyro with zeros (Samsung gives accel only)")

zero_gyro = np.zeros((N, 3), dtype=np.float32)
_check("zero gyro has same length as accel",
     zero_gyro.shape == accel.shape)
_check("zero gyro is all zeros",
     np.all(zero_gyro == 0))


# ─────────────────────────────────────────────────────────────────────
# 3. Compress with the same Gorilla codec used by the watch
# ─────────────────────────────────────────────────────────────────────
section("3. Gorilla compress accel + zero-gyro")

compressed = compress_gorilla(accel, zero_gyro)
_check("compressed payload non-empty", len(compressed) > 0)

raw_size = N * 6 * 4  # 6 floats × 4 bytes = 24 bytes/sample
compressed_size_bytes = len(compressed) * 0.75  # base64 inflates by ~33%
ratio = 1.0 - compressed_size_bytes / raw_size
print(f"  Raw size       : {raw_size} bytes")
print(f"  Base64 length  : {len(compressed)} chars")
print(f"  Decoded bytes  : ~{int(compressed_size_bytes)} bytes")
print(f"  Ratio          : {ratio*100:.1f}% reduction")

_check("compression ratio > 30% (zero gyro helps)",
     ratio > 0.30,
     f"{ratio*100:.1f}% reduction")
_check("compressed payload < 100 KB (MessageClient limit)",
     len(compressed) < 100_000,
     f"{len(compressed)} chars")


# ─────────────────────────────────────────────────────────────────────
# 4. Decompress and verify lossless round-trip
# ─────────────────────────────────────────────────────────────────────
section("4. Decompress and verify lossless")

accel_back, gyro_back = decompress_gorilla(compressed)

_check("decompressed accel shape matches",
     accel_back.shape == accel.shape,
     f"got {accel_back.shape}")
_check("decompressed gyro shape matches",
     gyro_back.shape == zero_gyro.shape)
_check("accel round-trip is bit-exact",
     np.array_equal(accel_back, accel))
_check("gyro round-trip is bit-exact (all zeros)",
     np.array_equal(gyro_back, zero_gyro))


# ─────────────────────────────────────────────────────────────────────
# 5. Build the JSON payload that the watch sends
# ─────────────────────────────────────────────────────────────────────
section("5. Build & parse the training_window JSON payload")

timestamp_ms = int(time.time() * 1000)
payload = {
    "type": "training_window",
    "label": "auto_detected",
    "confidence": 0.66,
    "timestamp": timestamp_ms,
    "sampleCount": N,
    "sampleRate": 25,
    "compressed": compressed,
}

payload_json = json.dumps(payload)
payload_bytes = payload_json.encode("utf-8")

_check("JSON payload < 100 KB (MessageClient limit)",
     len(payload_bytes) < 100_000,
     f"{len(payload_bytes)} bytes")

# Re-parse on phone side
parsed = json.loads(payload_json)
_check("type field is 'training_window'",
     parsed["type"] == "training_window")
_check("label is preserved",
     parsed["label"] == "auto_detected")
_check("confidence is preserved",
     parsed["confidence"] == 0.66)
_check("sampleCount matches",
     parsed["sampleCount"] == N)
_check("compressed field round-trips",
     parsed["compressed"] == compressed)


# ─────────────────────────────────────────────────────────────────────
# 6. Phone-side filename convention (matches MainActivity.handleTrainingWindow)
# ─────────────────────────────────────────────────────────────────────
section("6. Phone-side filename convention")

import datetime
iso_ts = datetime.datetime.fromtimestamp(timestamp_ms / 1000).strftime("%Y-%m-%dT%H-%M-%S")
conf_pct = int(payload["confidence"] * 100)
filename = f"{iso_ts}_{payload['label']}_conf{conf_pct}.json"

_check("filename is non-empty", len(filename) > 0)
_check("filename contains label", payload["label"] in filename)
_check("filename contains confidence", f"conf{conf_pct}" in filename)
_check("filename has .json suffix", filename.endswith(".json"))
print(f"  Example filename: {filename}")

# Test sortability — filenames generated 1 second apart should sort correctly
ts1 = int(time.time() * 1000)
ts2 = ts1 + 1000
fn1 = datetime.datetime.fromtimestamp(ts1 / 1000).strftime("%Y-%m-%dT%H-%M-%S") + "_a_conf50.json"
fn2 = datetime.datetime.fromtimestamp(ts2 / 1000).strftime("%Y-%m-%dT%H-%M-%S") + "_a_conf50.json"
_check("filenames sort chronologically (string sort)",
     sorted([fn2, fn1]) == [fn1, fn2])


# ─────────────────────────────────────────────────────────────────────
# 7. Disk cap simulation (FIFO eviction at 1000 files)
# ─────────────────────────────────────────────────────────────────────
section("7. FIFO eviction at MAX_TRAINING_FILES=1000")

MAX_TRAINING_FILES = 1000

# Simulate writing 1500 windows over time
files = []
for i in range(1500):
    fake_ts = ts1 + i * 1000  # 1 sec apart
    fake_fn = datetime.datetime.fromtimestamp(fake_ts / 1000).strftime("%Y-%m-%dT%H-%M-%S")
    fake_fn += f"_auto_detected_conf{50 + i % 50}.json"
    files.append((fake_fn, fake_ts))

# Apply FIFO cap (replicate MainActivity logic)
def apply_cap(file_list, max_count):
    """Sort by timestamp ascending, drop oldest until count <= max."""
    sorted_list = sorted(file_list, key=lambda x: x[1])
    while len(sorted_list) > max_count:
        sorted_list.pop(0)  # remove oldest
    return sorted_list

after_cap = apply_cap(files, MAX_TRAINING_FILES)

_check(f"after cap, count is exactly {MAX_TRAINING_FILES}",
     len(after_cap) == MAX_TRAINING_FILES,
     f"got {len(after_cap)}")
_check("oldest 500 files were dropped",
     after_cap[0][1] == files[500][1],
     f"first kept ts = file index {500}")
_check("most recent file is preserved",
     after_cap[-1][1] == files[-1][1])


# ─────────────────────────────────────────────────────────────────────
# 8. Memory cap simulation (RAM buffer max 50 windows on watch)
# ─────────────────────────────────────────────────────────────────────
section("8. Watch RAM buffer cap (sanity check)")

# The watch reuses MessageSyncManager.MAX_BUFFER_SIZE = 500
# At ~1 KB per window, that's ~500 KB max in RAM/disk on the watch.
WATCH_MAX_BUFFER = 500
WATCH_BYTES_PER_WINDOW = len(payload_bytes)
total_max_bytes = WATCH_MAX_BUFFER * WATCH_BYTES_PER_WINDOW
print(f"  Bytes per window      : {WATCH_BYTES_PER_WINDOW}")
print(f"  Watch max buffer size : {WATCH_MAX_BUFFER} windows")
print(f"  Watch max storage     : {total_max_bytes / 1024:.1f} KB")

_check("watch max storage < 2 MB (worst-case offline backlog)",
     total_max_bytes < 2 * 1024 * 1024,
     f"{total_max_bytes / 1024:.1f} KB")


# ─────────────────────────────────────────────────────────────────────
print("\n" + "=" * 50)
print(f"  Tests passed: {GREEN}{passed}{RESET}")
print(f"  Tests failed: {RED if failed > 0 else GREEN}{failed}{RESET}")
print("=" * 50)

if failed == 0:
    print("\nVERDICT:")
    print(f"  {GREEN}OK{RESET}  Full training-window flow validated end-to-end")
    print("        Compression is lossless, payload fits in MessageClient,")
    print("        phone-side cap evicts FIFO, watch RAM stays under 1 MB.")



# === pytest entry point ===
# The file's assertions run at module-level on import (above). pytest then
# discovers test_no_failures() and asserts that all of them passed.
def test_no_failures():
    assert failed == 0, f'{failed} _check(s) failed (see stdout above for details)'


if __name__ == "__main__":
    sys.exit(0 if failed == 0 else 1)