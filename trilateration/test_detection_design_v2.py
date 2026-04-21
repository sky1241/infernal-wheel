"""
Regression tests for the v2 detection design:

  1. CNN léger tourne H24 sauf sommeil (plus de filtre on/off temporel)
  2. GaussianHourPattern ajuste le seuil du SequenceDetector, pas le on/off
  3. Trilatération multi-signaux (HR + GPS + pattern) confirme avant +1
  4. Sleep filter: skip [0h-6h] si pattern pas learned, ou [22h-7h] si
     score < 0.1 quand pattern learned

Static-grep tests on DetectionService.kt.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DETECTION_SERVICE = os.path.join(
    REPO_ROOT,
    "trilateration",
    "wear-os-app",
    "app",
    "src",
    "main",
    "java",
    "com",
    "infernal",
    "smokingdetector",
    "DetectionService.kt",
)


@pytest.fixture(scope="module")
def source():
    with open(DETECTION_SERVICE, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# 1. Old temporal on/off filter REMOVED
# ============================================================================

def test_no_is_high_smoking_hour_gate_in_batch_handler(source):
    """The old pattern `if (!isBootstrap && !database.isHighSmokingHour()) return`
    must be gone from onSamsung25HzBatch. The CNN must run at all hours
    (except sleep). The pattern only adjusts the SequenceDetector threshold."""
    # Find the onSamsung25HzBatch function
    idx = source.find("private fun onSamsung25HzBatch")
    assert idx >= 0
    # Find the next function boundary
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    # The old killer pattern must be gone
    assert "!database.isHighSmokingHour()" not in body, (
        "Old temporal on/off filter still present in onSamsung25HzBatch — "
        "the CNN must run H24 (except sleep), not just during learned hours"
    )


def test_no_bootstrap_batches_gate_for_temporal(source):
    """BOOTSTRAP_BATCHES was used to gate the temporal filter. With the new
    design, the bootstrap concept is no longer needed for temporal gating
    (the CNN always runs). The constant can stay for log throttling but
    must NOT appear in a temporal filter context."""
    idx = source.find("private fun onSamsung25HzBatch")
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    # isBootstrap should not be used to gate inference anymore
    assert "if (!isBootstrap &&" not in body, (
        "Bootstrap-based temporal gating still present"
    )


# ============================================================================
# 2. Sleep filter present
# ============================================================================

def test_sleep_filter_exists(source):
    """A sleep filter must exist that skips inference during night hours."""
    idx = source.find("private fun onSamsung25HzBatch")
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    # Must reference sleep or night window
    assert "sleep" in body.lower() or "night" in body.lower(), (
        "No sleep filter found in onSamsung25HzBatch"
    )


def test_sleep_filter_uses_hour_check(source):
    """Sleep filter must check the current hour (not just the pattern score)."""
    idx = source.find("private fun onSamsung25HzBatch")
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    assert "currentHour" in body or "HOUR_OF_DAY" in body, (
        "Sleep filter doesn't check the clock hour"
    )


# ============================================================================
# 3. Trilatération multi-signaux before +1
# ============================================================================

def test_trilateration_check_before_handle_cigarette(source):
    """When SequenceDetector triggers, we must cross-check with HR + GPS +
    pattern BEFORE calling handleCigaretteDetected."""
    idx = source.find("private suspend fun runInference25Hz")
    assert idx >= 0
    body = source[idx:idx + 5000]
    assert "TRILATERATION" in body, (
        "Trilatération multi-signal check missing from runInference25Hz"
    )


def test_trilateration_checks_hr_delta(source):
    """HR delta must be one of the confirming signals."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "hrDelta" in body or "getCurrentHR" in body, (
        "Trilatération doesn't check heart rate"
    )


def test_trilateration_checks_gps_cluster(source):
    """GPS cluster must be one of the confirming signals."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "gpsCluster" in body or "getCurrentCluster" in body, (
        "Trilatération doesn't check GPS cluster"
    )


def test_trilateration_checks_hour_pattern(source):
    """Hour pattern score must be one of the confirming signals."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "hourConfirms" in body or "isHighSmokingHour" in body, (
        "Trilatération doesn't check hour pattern"
    )


def test_trilateration_requires_at_least_one_confirmation(source):
    """The detection must require >= 1 corroborating signal beyond the CNN."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "confirmCount >= 1" in body, (
        "Trilatération doesn't enforce minimum confirmation count"
    )


def test_trilateration_rejects_unconfirmed(source):
    """Unconfirmed detections must NOT call handleCigaretteDetected."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "REJECTED" in body, (
        "Trilatération doesn't log/handle rejection of unconfirmed detections"
    )


def test_unconfirmed_still_captures_training_data(source):
    """Even rejected detections should capture training windows for future
    model improvement (labeled as uncertain)."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "uncertain" in body.lower(), (
        "Rejected detections don't capture training data as uncertain"
    )


# ============================================================================
# 4. SequenceDetector threshold still adapts to pattern
# ============================================================================

def test_sequence_detector_still_uses_hour_score(source):
    """The SequenceDetector.push() must still receive isHighSmokingHour
    so it can use 2 peaks instead of 3 during high-smoking hours."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 5000]
    assert "isHighSmokingHour" in body and "sequenceDetector.push" in body, (
        "SequenceDetector no longer receives isHighSmokingHour for threshold adjustment"
    )
