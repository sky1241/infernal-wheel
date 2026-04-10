"""
Regression tests for feature_extraction.py BUG+024 + BUG+025.

  BUG+024: extract_all_features didn't propagate fs to its sub-extractors,
           so every fs-dependent feature was wrong by 2x on the 25Hz Samsung
           pipeline (silent fall-back to default 50Hz / dt=0.02).

  BUG+025: extract_time_domain_features / extract_jerk_features /
           extract_regularity_features had no empty-input guards and would
           crash with IndexError or silently produce NaN on len < 2 input.

This test is the canonical Python spec for the FIXED feature pipeline.
"""
import os
import sys

import numpy as np
import pytest

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from feature_extraction import (
    extract_time_domain_features,
    extract_jerk_features,
    extract_regularity_features,
    extract_frequency_features,
    extract_angular_features,
    extract_all_features,
    _infer_fs_from_timestamps,
)


# ============================================================================
# BUG+024 — sampling rate inference + propagation
# ============================================================================

def test_infer_fs_50hz():
    """50 samples spaced 0.02s apart → 50 Hz."""
    ts = np.arange(50) / 50.0
    fs = _infer_fs_from_timestamps(ts)
    assert abs(fs - 50.0) < 1e-9


def test_infer_fs_25hz():
    """Samsung Health Sensor SDK batched flow → 25 Hz."""
    ts = np.arange(25) / 25.0
    fs = _infer_fs_from_timestamps(ts)
    assert abs(fs - 25.0) < 1e-9


def test_infer_fs_100hz():
    ts = np.arange(100) / 100.0
    fs = _infer_fs_from_timestamps(ts)
    assert abs(fs - 100.0) < 1e-9


def test_infer_fs_falls_back_on_empty():
    assert _infer_fs_from_timestamps(np.array([])) == 50.0


def test_infer_fs_falls_back_on_single_sample():
    assert _infer_fs_from_timestamps(np.array([0.0])) == 50.0


def test_infer_fs_falls_back_on_zero_duration():
    """Clock not advancing — must not divide by zero."""
    assert _infer_fs_from_timestamps(np.array([5.0, 5.0, 5.0])) == 50.0


def test_infer_fs_falls_back_on_negative_duration():
    """Out-of-order timestamps must not produce negative fs."""
    assert _infer_fs_from_timestamps(np.array([1.0, 0.5])) == 50.0


def test_extract_all_features_passes_fs_to_jerk():
    """The point of BUG+024: when timestamps are 25Hz, jerk_magnitude must
    be computed with dt=0.04, not dt=0.02. We can verify this by feeding the
    SAME accel pattern at the SAME real time positions and confirming that
    the dt-aware jerk halves vs the broken-50Hz-baked-in version."""
    np.random.seed(0)
    n_samples = 50
    # Use arange/fs so the inferred fs is EXACTLY 25.0 — np.linspace(0, T, N)
    # gives (N-1)/T which is off-by-one compared to N/T.
    timestamps = np.arange(n_samples) / 25.0  # exactly 25Hz
    accel_3d = np.random.randn(n_samples, 3) * 0.5
    gyro_3d = np.random.randn(n_samples, 3) * 10

    features_inferred = extract_all_features(accel_3d, gyro_3d, timestamps)
    features_explicit_25 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=25.0)
    features_explicit_50 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=50.0)

    # Inferred fs from a 25Hz batch must equal the explicit-25 result.
    assert features_inferred['jerk_magnitude'] == features_explicit_25['jerk_magnitude']
    # And it must DIFFER from the silent-50Hz default — that was the bug.
    assert features_inferred['jerk_magnitude'] != features_explicit_50['jerk_magnitude']
    # Specifically: jerk = diff / dt → halving dt doubles jerk.
    # 25Hz dt=0.04, 50Hz dt=0.02. Same numerator, ratio should be 2.0.
    ratio = features_explicit_50['jerk_magnitude'] / features_explicit_25['jerk_magnitude']
    assert abs(ratio - 2.0) < 1e-9, f"expected 2x ratio, got {ratio}"


def test_extract_all_features_passes_fs_to_angular():
    """wrist_rotation = sum(|omega|) * dt. Halving dt halves the rotation.
    So the 25Hz inferred result must be HALF the (silent) 50Hz default."""
    n_samples = 50
    timestamps = np.linspace(0, 2.0, n_samples)  # 25Hz
    accel_3d = np.zeros((n_samples, 3))
    gyro_3d = np.ones((n_samples, 3)) * 30  # constant 30 deg/s on each axis

    f25 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=25.0)
    f50 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=50.0)

    ratio = f50['wrist_rotation'] / f25['wrist_rotation']
    assert abs(ratio - 0.5) < 1e-6, f"expected 0.5x, got {ratio}"


def test_extract_all_features_passes_fs_to_frequency():
    """dominant_freq scales linearly with fs. A signal at index k in the
    FFT corresponds to freq = k * fs / N. Doubling fs doubles dominant_freq."""
    n_samples = 200
    duration = 8.0  # 25Hz
    timestamps = np.linspace(0, duration, n_samples)
    # Pure 1Hz sine in z-axis so dominant_freq has a clear answer.
    t = timestamps
    accel_3d = np.column_stack([
        np.zeros(n_samples),
        np.zeros(n_samples),
        np.sin(2 * np.pi * 1.0 * t),
    ])
    gyro_3d = np.zeros((n_samples, 3))

    f25 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=25.0)
    f50 = extract_all_features(accel_3d, gyro_3d, timestamps, fs=50.0)

    # At fs=25 the dominant freq should be ~1Hz (the actual signal freq).
    # At fs=50 the SAME bin index k corresponds to a freq 2x higher
    # because freq = k*fs/N. This is exactly the BUG+024 symptom: a 1Hz
    # cigarette puff cadence got reported as 2Hz on the 25Hz pipeline.
    assert f25['dominant_freq'] != f50['dominant_freq']
    ratio = f50['dominant_freq'] / f25['dominant_freq']
    assert abs(ratio - 2.0) < 1e-6, f"expected 2x freq scaling, got {ratio}"


def test_extract_all_features_inferred_fs_matches_25hz_batch():
    """End-to-end: feed a Samsung-like 25Hz batch with NO explicit fs and
    confirm the result matches the explicit fs=25.0 path."""
    n_samples = 100
    timestamps = np.arange(n_samples) / 25.0  # exactly 25Hz
    np.random.seed(7)
    accel_3d = np.random.randn(n_samples, 3) * 0.4
    gyro_3d = np.random.randn(n_samples, 3) * 15

    f_inferred = extract_all_features(accel_3d, gyro_3d, timestamps)
    f_explicit = extract_all_features(accel_3d, gyro_3d, timestamps, fs=25.0)

    for key in f_inferred:
        assert f_inferred[key] == f_explicit[key], f"{key} mismatch"


# ============================================================================
# BUG+025 — empty / single-sample input must not crash, must return zeros
# ============================================================================

def test_time_domain_empty_input_returns_zeros():
    out = extract_time_domain_features(np.array([]), np.array([]))
    assert out == {
        'rms': 0.0, 'peak_accel': 0.0, 'duration': 0.0,
        'interval_mean': 0.0, 'interval_std': 0.0,
    }


def test_time_domain_single_sample_returns_zeros():
    out = extract_time_domain_features(np.array([1.0]), np.array([0.0]))
    assert out['rms'] == 0.0
    assert out['peak_accel'] == 0.0
    assert out['duration'] == 0.0


def test_jerk_empty_input_returns_zeros():
    out = extract_jerk_features(np.array([]))
    assert out == {
        'jerk_magnitude': 0.0, 'jerk_smoothness': 0.0, 'jerk_consistency': 0.0,
    }


def test_jerk_single_sample_returns_zeros():
    out = extract_jerk_features(np.array([5.0]))
    assert out['jerk_magnitude'] == 0.0
    assert out['jerk_smoothness'] == 0.0


def test_regularity_empty_input_returns_zeros():
    out = extract_regularity_features(np.array([]), np.array([]))
    assert out == {
        'regularity_score': 0.0, 'periodicity_coef': 0.0, 'temporal_clustering': 0.0,
    }


def test_regularity_single_sample_returns_zeros():
    out = extract_regularity_features(np.array([1.0]), np.array([0.0]))
    assert out['regularity_score'] == 0.0


def test_frequency_handles_none_input_gracefully():
    """Defensive guard: callers passing None used to crash at len(None)."""
    out = extract_frequency_features(None)
    assert out['dominant_freq'] == 0.0
    assert out['spectral_energy'] == 0.0


def test_extract_all_features_does_not_crash_on_minimum_input():
    """End-to-end: 2 samples is the smallest 'real' window.
    With the BUG+025 guards everything must return zeros instead of crashing."""
    timestamps = np.array([0.0, 0.04])  # 25Hz, 2 samples
    accel_3d = np.array([[0.0, 0.0, 9.81], [0.0, 0.0, 9.81]])
    gyro_3d = np.array([[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]])

    out = extract_all_features(accel_3d, gyro_3d, timestamps)
    # 30 features must all be present
    assert len(out) == 30
    # Must contain numbers, not NaN
    for key, value in out.items():
        assert not np.isnan(value), f"{key} is NaN"
