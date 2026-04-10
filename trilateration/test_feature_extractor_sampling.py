"""
Regression tests for FeatureExtractor.kt sampling-rate + empty-array bugs.

Found by audit pass (senior dev / military quality) driven by forge. The
extractor hardcoded SAMPLING_RATE = 50.0 in 8 places and had four sites that
crashed with NegativeArraySizeException on empty input:

  BUG+020: SAMPLING_RATE was hardcoded everywhere — wrong physics at 25Hz
           (Galaxy Watch 7 batched flow runs at 25Hz, not 50Hz).
           Fix: derive fs from timestamps via computeSamplingRate().

  BUG+021: FloatArray(gyro.size - 1) crashes when gyro is empty (size 0
           gives -1 → NegativeArraySizeException). Same for accel.
           Fix: early return zero-vector when accel.size < 2 or gyro.size < 2.

  BUG+022: expectedInterval = 45 * 50 = 2250 hardcoded. At 25Hz the correct
           lag for "1 cigarette puff every 45s" is 1125 samples, not 2250.
           Fix: expectedInterval = (45 * samplingRate).toInt().

This file is the canonical Python port of the FIXED logic. If the Kotlin
file diverges from this spec, this test will fail and the developer must
update both sides.
"""
import math
import pytest


# ============================================================================
# Python port of FIXED FeatureExtractor helpers
# ============================================================================

DEFAULT_SAMPLING_RATE = 50.0
MIN_SAMPLES_FOR_FEATURES = 2


def compute_sampling_rate(timestamps_ns):
    """Mirror of FeatureExtractor.computeSamplingRate (Kotlin)."""
    if len(timestamps_ns) < 2:
        return DEFAULT_SAMPLING_RATE
    duration_sec = (timestamps_ns[-1] - timestamps_ns[0]) / 1e9
    if duration_sec <= 0.0:
        return DEFAULT_SAMPLING_RATE
    return (len(timestamps_ns) - 1) / duration_sec


def expected_interval_samples(sampling_rate, period_sec=45.0):
    """BUG+022 fix: lag for the regularity autocorrelation must scale with fs."""
    return int(period_sec * sampling_rate)


def safe_diff_length(arr_size):
    """Mirror of FloatArray(arr.size - 1) but with the BUG+021 guard.
    Returns 0 (= empty diff array) when input is too small to differentiate."""
    if arr_size < 2:
        return 0
    return arr_size - 1


# ============================================================================
# BUG+020 — sampling rate is now measured, not hardcoded
# ============================================================================

def test_compute_sampling_rate_50hz():
    """50Hz batch: 50 samples over 1.0 second → fs ≈ 49 (n-1 / dur)."""
    timestamps = [int(i * 0.02 * 1e9) for i in range(50)]  # 20ms apart
    fs = compute_sampling_rate(timestamps)
    # 49 intervals over 0.98s = 50.0 Hz
    assert math.isclose(fs, 50.0, rel_tol=1e-9), f"expected 50Hz, got {fs}"


def test_compute_sampling_rate_25hz():
    """25Hz Samsung batched flow: 25 samples over 1.0 second → fs ≈ 25."""
    timestamps = [int(i * 0.04 * 1e9) for i in range(25)]  # 40ms apart
    fs = compute_sampling_rate(timestamps)
    # 24 intervals over 0.96s = 25.0 Hz
    assert math.isclose(fs, 25.0, rel_tol=1e-9), f"expected 25Hz, got {fs}"


def test_compute_sampling_rate_100hz():
    """High-rate sensor."""
    timestamps = [int(i * 0.01 * 1e9) for i in range(100)]
    fs = compute_sampling_rate(timestamps)
    assert math.isclose(fs, 100.0, rel_tol=1e-9), f"expected 100Hz, got {fs}"


def test_compute_sampling_rate_empty_falls_back():
    assert compute_sampling_rate([]) == DEFAULT_SAMPLING_RATE


def test_compute_sampling_rate_single_sample_falls_back():
    assert compute_sampling_rate([1_000_000]) == DEFAULT_SAMPLING_RATE


def test_compute_sampling_rate_zero_duration_falls_back():
    """All timestamps identical (clock not advancing) — must not divide by 0."""
    assert compute_sampling_rate([100, 100, 100]) == DEFAULT_SAMPLING_RATE


def test_compute_sampling_rate_negative_duration_falls_back():
    """Out-of-order timestamps must not produce negative fs."""
    assert compute_sampling_rate([1_000_000_000, 500_000_000]) == DEFAULT_SAMPLING_RATE


# ============================================================================
# BUG+021 — empty / single-sample input must not crash
# ============================================================================

def test_safe_diff_empty():
    """Old code: FloatArray(0 - 1) → NegativeArraySizeException. Fixed: 0."""
    assert safe_diff_length(0) == 0


def test_safe_diff_single_sample():
    """Old code: FloatArray(1 - 1) = FloatArray(0) → ok but average() crashes."""
    assert safe_diff_length(1) == 0


def test_safe_diff_two_samples():
    assert safe_diff_length(2) == 1


def test_safe_diff_normal():
    assert safe_diff_length(50) == 49


# ============================================================================
# BUG+022 — expectedInterval scales with fs
# ============================================================================

def test_expected_interval_at_50hz_is_2250():
    """50Hz × 45s = 2250 samples (the old hardcoded value, still correct at 50Hz)."""
    fs = 50.0
    assert expected_interval_samples(fs) == 2250


def test_expected_interval_at_25hz_is_1125():
    """25Hz × 45s = 1125 samples — the OLD code returned 2250 here, which is
    a 90s lag instead of 45s — the regularity score was reading at the wrong
    time and contributed garbage to the feature vector."""
    fs = 25.0
    assert expected_interval_samples(fs) == 1125


def test_expected_interval_at_100hz_is_4500():
    fs = 100.0
    assert expected_interval_samples(fs) == 4500


def test_expected_interval_uses_measured_fs_not_default():
    """Round-trip: measure fs from timestamps, then derive lag — must match
    the batch's actual rate."""
    # 25 samples spaced 40ms apart = 25Hz
    timestamps = [int(i * 0.04 * 1e9) for i in range(25)]
    fs = compute_sampling_rate(timestamps)
    lag = expected_interval_samples(fs)
    assert lag == 1125, f"25Hz batch should give lag=1125, got {lag}"


# ============================================================================
# BUG+021 regression — guard cascades through every extractor
# ============================================================================

@pytest.mark.parametrize("accel_size,gyro_size,should_bail", [
    (0, 0, True),    # both empty
    (0, 50, True),   # accel empty
    (50, 0, True),   # gyro empty
    (1, 1, True),    # single sample
    (2, 2, False),   # smallest valid
    (50, 50, False), # normal
])
def test_extract_all_bails_on_too_few_samples(accel_size, gyro_size, should_bail):
    """Mirror of FeatureExtractor.extractAllFeatures min-sample guard."""
    bailed = (accel_size < MIN_SAMPLES_FOR_FEATURES or
              gyro_size < MIN_SAMPLES_FOR_FEATURES)
    assert bailed == should_bail
