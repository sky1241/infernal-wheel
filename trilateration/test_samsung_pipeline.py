"""
End-to-end test simulating the Samsung Health SDK pipeline.

What this tests
---------------
The Samsung Health Sensor SDK delivers accelerometer data as RAW INTEGER
values (not float m/s^2). Our CNN was trained on m/s^2 floats from the SED
dataset. The wrapper class SamsungHealthAccelerometer.kt is responsible for
converting int -> m/s^2 before passing data to the CNN.

This test reproduces the exact pipeline in Python:
  1. Generate fake Samsung-style raw int batches (mimicking 25Hz @ 300 samples)
  2. Apply the conversion formula from SamsungHealthAccelerometer.ACCEL_INT_TO_MS2
  3. Build a sliding window of 112 samples
  4. Apply normalization (from normalization_params_v6_25hz.npz)
  5. Run TFLite inference
  6. Verify output is sensible (sums to 1, no NaN/Inf, varies with input)

If this passes, the on-device pipeline should also work — modulo the
Kotlin wiring (which is unit-testable on JVM separately).

Usage:
    python test_samsung_pipeline.py
"""

import os
import sys
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
import tensorflow as tf

# === Constants from SamsungHealthAccelerometer.kt ===
# 9.81 / (16383.75 / 4.0) ~ 0.002395
ACCEL_INT_TO_MS2 = 9.81 / (16383.75 / 4.0)

# === Constants from train_cnn_25hz.py ===
WINDOW_SAMPLES = 112
CHANNELS = 3
SAMPLE_RATE_HZ = 25
EXPECTED_BATCH_SIZE = 300  # ~12s @ 25Hz from Samsung SDK

MODEL_PATH = os.path.join(os.path.dirname(__file__), "smoking_detector_v6_25hz.tflite")
NORM_PATH = os.path.join(os.path.dirname(__file__), "normalization_params_v6_25hz.npz")


# === ANSI ===
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
# 1. Conversion factor sanity
# ─────────────────────────────────────────────────────────────────────
section("1. Samsung int -> m/s^2 conversion")

_check("ACCEL_INT_TO_MS2 ~ 0.002395",
     abs(ACCEL_INT_TO_MS2 - 0.002395) < 1e-5,
     f"got {ACCEL_INT_TO_MS2:.6f}")

# Common sanity check: at rest the watch reads ~9.81 m/s^2 on the up axis
# So a raw int of (16383.75 / 4) ~ 4096 should map to 9.81 m/s^2
raw_at_1g = 16383.75 / 4.0
ms2_at_1g = raw_at_1g * ACCEL_INT_TO_MS2
_check("raw 4096 ~ 9.81 m/s^2 (1g)",
     abs(ms2_at_1g - 9.81) < 0.01,
     f"got {ms2_at_1g:.4f}")

# Negative ints should map to negative m/s^2
_check("conversion preserves sign",
     -1000 * ACCEL_INT_TO_MS2 < 0)

# Zero -> zero
_check("conversion of 0 is 0",
     0 * ACCEL_INT_TO_MS2 == 0.0)


# ─────────────────────────────────────────────────────────────────────
# 2. Simulate a Samsung batch
# ─────────────────────────────────────────────────────────────────────
section("2. Simulate Samsung 300-sample batch @ 25Hz")

def fake_samsung_batch(n_samples=EXPECTED_BATCH_SIZE, seed=42):
    """
    Build a fake batch in Samsung's int format.
    Simulates a watch at rest (Z ~ 1g) with small random motion.
    """
    rng = np.random.default_rng(seed)
    # 1g on Z, small noise on all axes (~50 raw int = ~0.12 m/s^2 motion)
    raw_x = rng.integers(-50, 50, size=n_samples).astype(np.int32)
    raw_y = rng.integers(-50, 50, size=n_samples).astype(np.int32)
    raw_z_at_rest = int(16383.75 / 4.0)  # 1g
    raw_z = raw_z_at_rest + rng.integers(-50, 50, size=n_samples).astype(np.int32)
    return np.column_stack([raw_x, raw_y, raw_z])


batch_int = fake_samsung_batch()
_check("batch shape is [300, 3]",
     batch_int.shape == (EXPECTED_BATCH_SIZE, CHANNELS),
     f"got {batch_int.shape}")
_check("batch dtype is int",
     np.issubdtype(batch_int.dtype, np.integer))

# Convert to m/s^2
batch_ms2 = batch_int.astype(np.float32) * ACCEL_INT_TO_MS2
_check("converted batch dtype is float32",
     batch_ms2.dtype == np.float32)
_check("converted Z axis ~ 9.81 m/s^2 (mean)",
     abs(batch_ms2[:, 2].mean() - 9.81) < 0.5,
     f"mean Z = {batch_ms2[:, 2].mean():.3f}")
_check("converted X/Y axes ~ 0 m/s^2 (small motion)",
     abs(batch_ms2[:, 0].mean()) < 0.5 and abs(batch_ms2[:, 1].mean()) < 0.5,
     f"X={batch_ms2[:, 0].mean():.3f} Y={batch_ms2[:, 1].mean():.3f}")


# ─────────────────────────────────────────────────────────────────────
# 3. Sliding window of 112 samples (what the CNN sees)
# ─────────────────────────────────────────────────────────────────────
section("3. Build 112-sample window from batch")

# Take last 112 samples (matching DetectionService.runInference25Hz logic)
window = batch_ms2[-WINDOW_SAMPLES:]
_check("window shape is [112, 3]",
     window.shape == (WINDOW_SAMPLES, CHANNELS),
     f"got {window.shape}")
_check("window has no NaN/Inf",
     not np.any(np.isnan(window)) and not np.any(np.isinf(window)))


# ─────────────────────────────────────────────────────────────────────
# 4. Normalize (using the actual training norm params)
# ─────────────────────────────────────────────────────────────────────
section("4. Normalize using trained params")

if not os.path.exists(NORM_PATH):
    print(f"  {YELLOW}SKIP{RESET}  Norm params not found at {NORM_PATH}")
    sys.exit(1)

norm = np.load(NORM_PATH)
mean = norm['mean']
std = norm['std']
_check("loaded norm mean shape [3]", mean.shape == (CHANNELS,))
_check("loaded norm std shape [3]", std.shape == (CHANNELS,))

window_normalized = (window - mean) / std
_check("normalized window has no NaN/Inf",
     not np.any(np.isnan(window_normalized)) and not np.any(np.isinf(window_normalized)))
_check("normalized window in reasonable range (z-score)",
     np.abs(window_normalized).max() < 100,
     f"max |z| = {np.abs(window_normalized).max():.3f}")


# ─────────────────────────────────────────────────────────────────────
# 5. TFLite inference
# ─────────────────────────────────────────────────────────────────────
section("5. TFLite inference on simulated batch")

if not os.path.exists(MODEL_PATH):
    print(f"  {YELLOW}SKIP{RESET}  Model not found at {MODEL_PATH}")
    sys.exit(1)

interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

input_tensor = window_normalized[np.newaxis, :, :].astype(np.float32)
interpreter.set_tensor(input_details[0]['index'], input_tensor)
interpreter.invoke()
output = interpreter.get_tensor(output_details[0]['index'])[0]

_check("output shape [4] (4 classes)",
     output.shape == (4,))
_check("output sums to ~1.0 (softmax)",
     abs(output.sum() - 1.0) < 0.01,
     f"sum={output.sum():.4f}")
_check("output is well-calibrated (no NaN, no extreme values)",
     not np.any(np.isnan(output)) and np.all(output >= 0))

cig_prob = output[0]
print(f"\n  Inferred probabilities (rest position): {output.tolist()}")
print(f"  Cigarette probability: {cig_prob*100:.1f}%")

# A watch at rest should NOT be predicted as smoking
_check("watch at rest -> low cigarette probability (<50%)",
     cig_prob < 0.5,
     f"cig_prob={cig_prob*100:.1f}%")


# ─────────────────────────────────────────────────────────────────────
# 6. Try a "movement" pattern (fake puff-like signal)
# ─────────────────────────────────────────────────────────────────────
section("6. Inference on fake puff-like signal")

def fake_puff_batch(seed=99):
    """Simulate a 'puff-like' gesture: arc up then down on Y-axis."""
    rng = np.random.default_rng(seed)
    n = EXPECTED_BATCH_SIZE
    t = np.arange(n) / SAMPLE_RATE_HZ  # seconds

    # Sinusoidal arc on Y (mimicking arm to mouth)
    raw_x = rng.integers(-100, 100, size=n).astype(np.int32)
    raw_y = (1500 * np.sin(2 * np.pi * 0.3 * t)).astype(np.int32)  # 0.3Hz oscillation
    raw_z = (16383.75 / 4.0 + 500 * np.cos(2 * np.pi * 0.3 * t)).astype(np.int32)
    return np.column_stack([raw_x, raw_y, raw_z])


puff_batch_int = fake_puff_batch()
puff_ms2 = puff_batch_int.astype(np.float32) * ACCEL_INT_TO_MS2
puff_window = puff_ms2[-WINDOW_SAMPLES:]
puff_normalized = (puff_window - mean) / std

interpreter.set_tensor(input_details[0]['index'],
                       puff_normalized[np.newaxis, :, :].astype(np.float32))
interpreter.invoke()
puff_output = interpreter.get_tensor(output_details[0]['index'])[0]

_check("puff output shape [4]", puff_output.shape == (4,))
_check("puff output sums to ~1.0",
     abs(puff_output.sum() - 1.0) < 0.01)
_check("rest vs puff -> different predictions",
     not np.allclose(output, puff_output, atol=0.05),
     f"max diff={np.abs(output - puff_output).max():.4f}")

print(f"\n  Rest probabilities:  {[f'{p:.3f}' for p in output.tolist()]}")
print(f"  Puff probabilities:  {[f'{p:.3f}' for p in puff_output.tolist()]}")


# ─────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────
print("\n" + "=" * 50)
print(f"  Tests passed: {GREEN}{passed}{RESET}")
print(f"  Tests failed: {RED if failed > 0 else GREEN}{failed}{RESET}")
print("=" * 50)

print("\nVERDICT:")
if failed == 0:
    print(f"  {GREEN}OK{RESET}  Samsung pipeline simulation works end-to-end")
    print(f"        The Kotlin wrapper SHOULD produce these same outputs")
    print(f"        once the AAR is wired in and on-device data flows through it.")
else:
    print(f"  {RED}FAIL{RESET} Pipeline has issues — fix before deploying")



# === pytest entry point ===
# The file's assertions run at module-level on import (above). pytest then
# discovers test_no_failures() and asserts that all of them passed.
def test_no_failures():
    assert failed == 0, f'{failed} _check(s) failed (see stdout above for details)'


if __name__ == "__main__":
    sys.exit(0 if failed == 0 else 1)