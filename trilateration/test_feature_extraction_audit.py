"""
Regression tests for feature_extraction.py audit pass.

Found by audit driven by `forge.py --carmack` (feature_extraction.py was
flagged with Coupling=1.00, the highest blast radius in the project — any
bug in it propagates to every model that consumes its features).

Bugs covered:
  BUG+006: dt was hardcoded to 0.02 (50Hz) in extract_angular_features.
           Now parameterized via fs (default 50 for backward compat).
  BUG+007: extract_trajectory_features crashed with IndexError when given
           a single-sample input (np.diff returns empty, dt[-1] failed).
           Now early-returns zero features for degenerate inputs.
  BUG+008: extract_trajectory_features double-integrates raw accel which
           accumulates drift very fast. NOT fixed (conceptual flaw needs
           a sensor fusion rewrite) — the docstring now warns the caller.

These tests verify the fixes for #006 and #007 and ensure that the
trajectory function doesn't crash on edge inputs.
"""
import os
import sys
import numpy as np
import pytest

sys.path.insert(0, os.path.dirname(__file__))

from feature_extraction import (
    extract_time_domain_features,
    extract_angular_features,
    extract_jerk_features,
    extract_trajectory_features,
    extract_frequency_features,
)


# ============================================================================
# BUG+006 — extract_angular_features now takes an fs parameter
# ============================================================================

def test_angular_features_default_50hz():
    """Default fs=50 keeps backward compat."""
    gyro = np.array([[0.1, 0.2, 0.3]] * 100, dtype=np.float32)
    feats = extract_angular_features(gyro)
    assert 'angular_velocity' in feats
    assert 'wrist_rotation' in feats
    assert 'orientation_stability' in feats
    assert 'rotation_smoothness' in feats


def test_angular_features_25hz_doubles_dt():
    """At 25Hz, dt=0.04 vs 50Hz dt=0.02. The cumulative wrist_rotation
    integral should double for the same input gyro signal."""
    gyro = np.array([[0.1, 0.0, 0.0]] * 100, dtype=np.float32)
    feats_50 = extract_angular_features(gyro, fs=50.0)
    feats_25 = extract_angular_features(gyro, fs=25.0)
    # wrist_rotation = sum(|gyro|) * dt → at 25Hz dt is 2x → result is 2x
    ratio = feats_25['wrist_rotation'] / feats_50['wrist_rotation']
    assert abs(ratio - 2.0) < 0.01, f"expected ratio ~2.0, got {ratio}"


def test_angular_features_empty_input():
    """Empty gyro → all zeros, no crash."""
    gyro = np.zeros((0, 3), dtype=np.float32)
    feats = extract_angular_features(gyro)
    assert feats['angular_velocity'] == 0.0
    assert feats['wrist_rotation'] == 0.0
    assert feats['orientation_stability'] == 0.0
    assert feats['rotation_smoothness'] == 0.0


def test_angular_features_single_sample_input():
    """Single sample → no jerk possible, should return 0 not crash."""
    gyro = np.array([[0.1, 0.2, 0.3]], dtype=np.float32)
    feats = extract_angular_features(gyro)
    assert feats['rotation_smoothness'] == 0.0  # was a NaN/crash before fix


# ============================================================================
# BUG+007 — extract_trajectory_features doesn't crash on degenerate input
# ============================================================================

def test_trajectory_features_empty_input():
    """Empty arrays → all zero features, no IndexError."""
    accel = np.zeros((0, 3), dtype=np.float32)
    ts = np.array([], dtype=np.float64)
    feats = extract_trajectory_features(accel, ts)
    assert feats['path_curvature'] == 0.0
    assert feats['elevation_angle'] == 0.0
    assert feats['elevation_consistency'] == 0.0
    assert feats['total_distance'] == 0.0


def test_trajectory_features_single_sample_no_crash():
    """1 sample → np.diff(ts) is empty, dt[-1] would crash before BUG+007 fix."""
    accel = np.array([[0.1, 0.2, 9.8]], dtype=np.float32)
    ts = np.array([0.0])
    feats = extract_trajectory_features(accel, ts)
    # Must return without crashing — values default to 0
    assert feats['path_curvature'] == 0.0
    assert feats['total_distance'] == 0.0


def test_trajectory_features_two_samples_no_crash():
    """2 samples → np.diff returns 1-element array, dt[-1] is valid."""
    accel = np.array([[0.1, 0.2, 9.8], [0.2, 0.3, 9.9]], dtype=np.float32)
    ts = np.array([0.0, 0.02])
    # Should not crash. We don't assert on exact values because the
    # double-integration produces drift-dominated nonsense (BUG+008).
    feats = extract_trajectory_features(accel, ts)
    assert all(k in feats for k in
               ['path_curvature', 'elevation_angle', 'elevation_consistency', 'total_distance'])


def test_trajectory_features_realistic_window():
    """A realistic 225-sample 4.5s window should produce all 4 features."""
    np.random.seed(42)
    accel = np.random.randn(225, 3).astype(np.float32)
    accel[:, 2] += 9.81  # add gravity
    ts = np.linspace(0, 4.5, 225)
    feats = extract_trajectory_features(accel, ts)
    assert feats['elevation_angle'] > 0  # sanity: gravity is non-zero
    assert all(np.isfinite(v) for v in feats.values())


# ============================================================================
# General smoke tests on the other extractors
# ============================================================================

def test_time_domain_features_smoke():
    accel = np.array([1.0, 2.0, 1.5, 3.0, 2.5, 1.0, 2.0])
    ts = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6])
    feats = extract_time_domain_features(accel, ts)
    assert feats['rms'] > 0
    assert feats['peak_accel'] == 3.0
    assert feats['duration'] == pytest.approx(0.6, abs=1e-9)


def test_jerk_features_smoke():
    accel = np.array([1.0, 2.0, 1.5, 3.0, 2.5])
    feats = extract_jerk_features(accel, dt=0.02)
    assert feats['jerk_magnitude'] > 0


def test_jerk_features_25hz_dt():
    """Pass dt=0.04 explicitly for 25Hz signal (BUG+006 doc note)."""
    accel = np.array([1.0, 2.0, 1.5, 3.0, 2.5])
    feats = extract_jerk_features(accel, dt=0.04)
    assert feats['jerk_magnitude'] > 0


def test_frequency_features_smoke():
    np.random.seed(0)
    accel = np.sin(np.linspace(0, 4 * np.pi, 200)).astype(np.float32)
    feats = extract_frequency_features(accel, fs=50.0)
    assert feats['dominant_freq'] > 0
    assert feats['spectral_energy'] > 0


def test_frequency_features_too_short_returns_zeros():
    """Signal shorter than 4 samples → all zero features."""
    accel = np.array([1.0, 2.0, 1.5])
    feats = extract_frequency_features(accel)
    assert feats['dominant_freq'] == 0.0
    assert feats['spectral_energy'] == 0.0
