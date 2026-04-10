"""
Validation tests for the 25Hz CNN training pipeline (v6 model).

These tests do NOT retrain the model. They verify that:
  1. The downsampling logic is correct (50Hz -> 25Hz, no NaN/Inf)
  2. The window shape matches the expected CNN input [1, 112, 3]
  3. The trained TFLite model loads and produces valid output (sum to 1, all in [0,1])
  4. The normalization params file is well-formed
  5. The model gives DIFFERENT outputs for different inputs (sanity check)
  6. Inference time is reasonable for a wearable (<200ms on CPU)

Run after `python train_cnn_25hz.py` has finished.

Usage:
    python test_train_cnn_25hz.py
"""

import os
import sys
import time
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import tensorflow as tf

# Import constants from the training script
sys.path.insert(0, os.path.dirname(__file__))
from train_cnn_25hz import (
    WINDOW_SAMPLES, CHANNELS, TARGET_RATE,
    DOWNSAMPLE_FACTOR, downsample,
    OUTPUT_TFLITE, OUTPUT_NORM,
)


# ANSI colors
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


# === 1. Downsampling logic ===
section("1. Downsampling logic")

raw = np.linspace(0, 100, 100, dtype=np.float32)
ds = downsample(raw, DOWNSAMPLE_FACTOR)

_check("downsample factor 2 halves length (even)", len(ds) == 50, f"len={len(ds)}")
_check("downsample no NaN", not np.any(np.isnan(ds)))
_check("downsample no Inf", not np.any(np.isinf(ds)))
# Subsampling: ds[i] should equal raw[i*2] (take every 2nd sample, no averaging)
_check("downsample takes every 2nd sample (subsample, not average)",
     abs(ds[0] - raw[0]) < 1e-5 and abs(ds[1] - raw[2]) < 1e-5,
     f"ds[0]={ds[0]:.3f} expected={raw[0]:.3f}")

# Edge case: odd length — np.array[::2] of length 101 gives 51 elements (ceil)
raw_odd = np.arange(101, dtype=np.float32)
ds_odd = downsample(raw_odd, 2)
_check("downsample odd length yields ceil(N/2)", len(ds_odd) == 51, f"len={len(ds_odd)}")


# === 2. Window shape ===
section("2. Window shape")

_check("WINDOW_SAMPLES is 112", WINDOW_SAMPLES == 112, f"got {WINDOW_SAMPLES}")
_check("CHANNELS is 3", CHANNELS == 3, f"got {CHANNELS}")
_check("TARGET_RATE is 25Hz", TARGET_RATE == 25, f"got {TARGET_RATE}")
_check("4.5s window at 25Hz = 112 samples", int(4.5 * 25) == WINDOW_SAMPLES)


# === 3. TFLite model load ===
section("3. TFLite model")

if not os.path.exists(OUTPUT_TFLITE):
    print(f"  {YELLOW}SKIP{RESET}  TFLite model not found at {OUTPUT_TFLITE}")
    print(f"  {YELLOW}SKIP{RESET}  Run `python train_cnn_25hz.py` first")
else:
    interpreter = tf.lite.Interpreter(model_path=OUTPUT_TFLITE)
    interpreter.allocate_tensors()

    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    input_shape = input_details[0]['shape']
    output_shape = output_details[0]['shape']

    _check("model has 1 input", len(input_details) == 1)
    _check("model has 1 output", len(output_details) == 1)
    _check("input shape is [1, 112, 3]",
         tuple(input_shape) == (1, WINDOW_SAMPLES, CHANNELS),
         f"got {tuple(input_shape)}")
    _check("output shape is [1, 4]",
         tuple(output_shape) == (1, 4),
         f"got {tuple(output_shape)}")
    _check("input dtype is float32",
         input_details[0]['dtype'] == np.float32,
         f"got {input_details[0]['dtype']}")

    # Run inference on random data
    np.random.seed(42)
    dummy_input = np.random.randn(1, WINDOW_SAMPLES, CHANNELS).astype(np.float32)
    interpreter.set_tensor(input_details[0]['index'], dummy_input)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]['index'])

    _check("output sums to ~1.0 (softmax)",
         abs(output.sum() - 1.0) < 0.01,
         f"sum={output.sum():.4f}")
    _check("all output probs in [0, 1]",
         np.all(output >= 0) and np.all(output <= 1),
         f"min={output.min():.4f} max={output.max():.4f}")

    # Sanity: different inputs should give different outputs
    np.random.seed(123)
    other_input = np.random.randn(1, WINDOW_SAMPLES, CHANNELS).astype(np.float32) * 5
    interpreter.set_tensor(input_details[0]['index'], other_input)
    interpreter.invoke()
    other_output = interpreter.get_tensor(output_details[0]['index'])

    _check("model produces different outputs for different inputs",
         not np.allclose(output, other_output, atol=1e-3),
         f"diff={np.abs(output - other_output).max():.4f}")

    # Inference timing (CPU)
    n_iters = 50
    start = time.time()
    for _ in range(n_iters):
        interpreter.set_tensor(input_details[0]['index'], dummy_input)
        interpreter.invoke()
    elapsed_ms = (time.time() - start) * 1000 / n_iters

    _check("inference under 200ms (CPU avg)",
         elapsed_ms < 200,
         f"{elapsed_ms:.1f}ms/inference")


# === 4. Normalization params ===
section("4. Normalization params")

if not os.path.exists(OUTPUT_NORM):
    print(f"  {YELLOW}SKIP{RESET}  Norm params not found at {OUTPUT_NORM}")
else:
    norm = np.load(OUTPUT_NORM)
    _check("contains 'mean'", 'mean' in norm.files)
    _check("contains 'std'", 'std' in norm.files)
    _check("contains 'window_samples'", 'window_samples' in norm.files)
    _check("contains 'channels'", 'channels' in norm.files)
    _check("contains 'sample_rate'", 'sample_rate' in norm.files)

    if 'mean' in norm.files:
        mean = norm['mean']
        std = norm['std']
        _check("mean has 3 elements",
             mean.shape == (3,) or mean.shape == (CHANNELS,),
             f"shape={mean.shape}")
        _check("std has 3 elements",
             std.shape == (3,) or std.shape == (CHANNELS,),
             f"shape={std.shape}")
        _check("std all positive",
             np.all(std > 0),
             f"min std={std.min():.4f}")
        _check("mean values reasonable for accelerometer (m/s^2)",
             np.all(np.abs(mean) < 20),
             f"max abs mean={np.abs(mean).max():.4f}")
        _check("std values reasonable",
             np.all((std > 0.01) & (std < 50)),
             f"std range=[{std.min():.4f}, {std.max():.4f}]")

    if 'cv_f1' in norm.files:
        f1 = float(norm['cv_f1'])
        _check("CV F1 is recorded", True, f"F1={f1:.3f}")
        if f1 < 0.60:
            print(f"  {RED}WARN{RESET}  F1 ({f1:.3f}) is below 0.60 — model may be too weak")
        elif f1 < 0.70:
            print(f"  {YELLOW}NOTE{RESET}  F1 ({f1:.3f}) is acceptable but could be better")
        else:
            print(f"  {GREEN}GOOD{RESET}  F1 ({f1:.3f}) meets target")


# === 5. End-to-end smoke test (downsample -> model) ===
section("5. End-to-end pipeline smoke test")

if os.path.exists(OUTPUT_TFLITE) and os.path.exists(OUTPUT_NORM):
    # Simulate raw 50Hz signal -> downsample -> normalize -> infer
    # Use 224 samples (even) so 224/2 = 112 exactly
    np.random.seed(0)
    raw_50hz = np.random.randn(224, 3).astype(np.float32) * 5  # 4.48s @ 50Hz, 3 ch

    # Downsample each channel
    ds_signal = np.column_stack([
        downsample(raw_50hz[:, c], DOWNSAMPLE_FACTOR) for c in range(3)
    ])
    _check("downsampled 224-sample signal shape is [112, 3]",
         ds_signal.shape == (WINDOW_SAMPLES, CHANNELS),
         f"got {ds_signal.shape}")

    # Normalize
    norm = np.load(OUTPUT_NORM)
    mean = norm['mean']
    std = norm['std']
    normalized = (ds_signal - mean) / std

    # Infer
    interpreter = tf.lite.Interpreter(model_path=OUTPUT_TFLITE)
    interpreter.allocate_tensors()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    interpreter.set_tensor(input_details[0]['index'],
                           normalized[np.newaxis, :, :].astype(np.float32))
    interpreter.invoke()
    probs = interpreter.get_tensor(output_details[0]['index'])[0]

    _check("e2e pipeline produces valid 4-class output",
         probs.shape == (4,) and abs(probs.sum() - 1.0) < 0.01,
         f"probs={probs.tolist()}")


# === Summary ===
print("\n" + "=" * 50)
print(f"  Tests passed: {GREEN}{passed}{RESET}")
print(f"  Tests failed: {RED if failed > 0 else GREEN}{failed}{RESET}")
print("=" * 50)



# === pytest entry point ===
# The file's assertions run at module-level on import (above). pytest then
# discovers test_no_failures() and asserts that all of them passed.
def test_no_failures():
    assert failed == 0, f'{failed} _check(s) failed (see stdout above for details)'


if __name__ == "__main__":
    sys.exit(0 if failed == 0 else 1)