"""
Regression tests for train_real_data.py BUG+043/044/045.

  BUG+043: periodicity_coef silently duplicated path_curvature. The feature
           vector had path_curvature twice and no real periodicity_coef,
           poisoning every GBM trained by this script.

  BUG+044: dominant_freq off-by-one. np.argmax(fft_vals[1:]) returns an
           index into the SLICE starting at bin 1, but the code used it
           to index the original freqs array → reported frequency was
           always one bin below the real peak.

  BUG+045: int8 TFLite quantization caused the "v5 crash bug" on Wear OS
           Android 16. Already fixed in train_cnn_25hz.py; train_real_data.py
           was the last holdout.

These tests combine:
  1. Numerical tests that exercise extract_features on synthetic signals
     with known dominant frequency, verifying the argmax+1 fix.
  2. Assertions that the feature vector has all 30 distinct features
     (no accidental duplication).
  3. Static-grep for the int8 quantization removal.
"""
import os
import sys

import numpy as np
import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO_ROOT, "trilateration"))

from train_real_data import extract_features  # noqa: E402


# ============================================================================
# Helper: build a synthetic 4.5s window of accel+gyro at 50Hz with a
# specified dominant frequency. 225 samples, ~0.22Hz bin resolution.
# ============================================================================

def synthetic_window(dominant_hz: float, duration_sec: float = 4.5,
                     fs: float = 50.0, seed: int = 0):
    np.random.seed(seed)
    n = int(duration_sec * fs)
    t = np.arange(n) / fs
    # Pure cosine in all three accel channels at the target frequency.
    # Z axis gets the biggest amplitude so the magnitude is dominated by it.
    signal = np.cos(2 * np.pi * dominant_hz * t)
    accel = np.column_stack([
        0.1 * signal + 0.01 * np.random.randn(n),
        0.1 * signal + 0.01 * np.random.randn(n),
        5.0 + signal + 0.01 * np.random.randn(n),  # DC + signal dominates magnitude
    ]).astype(np.float32)
    gyro = 0.01 * np.random.randn(n, 3).astype(np.float32)
    timestamps = t.astype(np.float64)
    return accel, gyro, timestamps


# ============================================================================
# BUG+044 — dominant_freq off-by-one
# ============================================================================

def test_dominant_freq_matches_synthetic_1hz():
    """1Hz dominant signal should produce dominant_freq ≈ 1.0Hz.
    Before the fix, the reported value was ~0.78Hz (one bin low)."""
    accel, gyro, ts = synthetic_window(dominant_hz=1.0)
    feats = extract_features(accel, gyro, ts)
    # Feature index 12 is dominant_freq (0-4 time, 5-8 angular, 9-11 jerk, 12 freq[0])
    dominant_freq = feats[12]
    # 225 samples / 50Hz = 4.5s; bin width = 1/4.5 ≈ 0.222Hz
    # True peak at 1Hz should land in bin 4 (index 4 → freqs[4] = 0.889Hz)
    # or bin 5 (index 5 → freqs[5] = 1.111Hz) depending on FFT leakage.
    assert 0.85 < dominant_freq < 1.15, (
        f"BUG+044 regression: dominant_freq={dominant_freq:.3f} for 1Hz signal"
    )


def test_dominant_freq_matches_synthetic_2hz():
    """2Hz dominant signal → dominant_freq ≈ 2.0Hz."""
    accel, gyro, ts = synthetic_window(dominant_hz=2.0)
    feats = extract_features(accel, gyro, ts)
    dominant_freq = feats[12]
    assert 1.85 < dominant_freq < 2.15, (
        f"BUG+044 regression: dominant_freq={dominant_freq:.3f} for 2Hz signal"
    )


def test_dominant_freq_is_not_zero_on_nonzero_signal():
    """Basic sanity: a pure sinusoidal signal must NOT report 0Hz."""
    accel, gyro, ts = synthetic_window(dominant_hz=3.0)
    feats = extract_features(accel, gyro, ts)
    assert feats[12] > 0, "dominant_freq is 0 for a 3Hz signal"


# ============================================================================
# BUG+043 — periodicity_coef must not duplicate path_curvature
# ============================================================================

def test_feature_vector_has_30_features():
    """Sanity: the extract_features contract returns exactly 30 features."""
    accel, gyro, ts = synthetic_window(dominant_hz=1.0)
    feats = extract_features(accel, gyro, ts)
    assert len(feats) == 30, f"Expected 30 features, got {len(feats)}"


def test_periodicity_coef_is_not_path_curvature_duplicate():
    """BUG+043: periodicity_coef was silently set to features[17] which
    is path_curvature. After the fix it should be set to features[15]
    which is autocorr_peak. Verify they're DIFFERENT in the output vector."""
    accel, gyro, ts = synthetic_window(dominant_hz=1.0)
    feats = extract_features(accel, gyro, ts)

    # Index 17 is path_curvature (start of trajectory block)
    path_curvature = feats[17]
    # Index 22 is periodicity_coef (3rd regularity feature)
    periodicity_coef = feats[22]
    # Index 15 is autocorr_peak
    autocorr_peak = feats[15]

    # After fix: periodicity_coef == autocorr_peak, NOT path_curvature.
    # They might coincidentally be equal on degenerate input, so use a
    # STRONGER assert: for our synthetic 1Hz signal, path_curvature is
    # near zero (smooth sinusoid) but autocorr_peak is near 1.0.
    assert abs(periodicity_coef - autocorr_peak) < 1e-6, (
        f"BUG+043 regression: periodicity_coef ({periodicity_coef}) should "
        f"equal autocorr_peak ({autocorr_peak}), not path_curvature ({path_curvature})"
    )


def test_periodicity_coef_differs_from_path_curvature_for_periodic_signal():
    """For a pure 1Hz signal the autocorrelation peak is near 1 (highly
    periodic) while path curvature is small (smooth trajectory). These
    values should be well-separated, proving the fields map to different
    computations."""
    accel, gyro, ts = synthetic_window(dominant_hz=1.0)
    feats = extract_features(accel, gyro, ts)
    path_curvature = feats[17]
    periodicity_coef = feats[22]
    # They must not be accidentally equal (within 1e-3).
    diff = abs(periodicity_coef - path_curvature)
    assert diff > 1e-3, (
        f"BUG+043 regression: periodicity_coef={periodicity_coef:.4f} "
        f"and path_curvature={path_curvature:.4f} are equal (< 1e-3 apart). "
        f"This is the old bug where features[17] aliased path_curvature "
        f"into the periodicity_coef slot."
    )


# ============================================================================
# BUG+045 — int8 quantization must be removed
# ============================================================================

@pytest.fixture(scope="module")
def train_real_data_source():
    path = os.path.join(REPO_ROOT, "trilateration", "train_real_data.py")
    with open(path, encoding="utf-8") as f:
        return f.read()


def test_no_int8_quantization(train_real_data_source):
    """TFLITE_BUILTINS_INT8 must not appear anymore."""
    assert "TFLITE_BUILTINS_INT8" not in train_real_data_source, (
        "BUG+045 regression: int8 quantization path reappeared in train_real_data.py"
    )


def test_no_int8_inference_input(train_real_data_source):
    assert "inference_input_type = tf.int8" not in train_real_data_source, (
        "BUG+045 regression: int8 inference_input_type reappeared"
    )


def test_representative_dataset_removed(train_real_data_source):
    """The representative_dataset function was only needed for int8
    calibration — the float32 path doesn't need it."""
    # Should no longer be defined inside train_final_and_export
    idx = train_real_data_source.find("def train_final_and_export")
    assert idx >= 0
    body = train_real_data_source[idx:idx + 3000]
    assert "representative_dataset" not in body, (
        "BUG+045 regression: representative_dataset fixture still present "
        "(was only needed for int8 path)"
    )


def test_bug_043_044_045_markers_present(train_real_data_source):
    for bug in ["BUG+043", "BUG+044", "BUG+045"]:
        assert bug in train_real_data_source, f"{bug} marker missing"
