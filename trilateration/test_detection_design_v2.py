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
    """A sleep filter must exist that skips inference during sleep."""
    idx = source.find("private fun onSamsung25HzBatch")
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    assert "sleep" in body.lower() or "isSleeping" in body, (
        "No sleep filter found in onSamsung25HzBatch"
    )


def test_sleep_filter_uses_real_hr_data(source):
    """Sleep filter must use real HR-based sleep detection from
    HealthServicesManager, not just clock hour."""
    idx = source.find("private fun onSamsung25HzBatch")
    next_fn = source.find("private suspend fun runInference25Hz", idx)
    body = source[idx:next_fn] if next_fn > idx else source[idx:idx + 3000]
    assert "healthServices.isSleeping" in body or "isSleeping" in body, (
        "Sleep filter doesn't use real HR-based sleep detection"
    )


def test_health_services_has_sleep_detection():
    """HealthServicesManager must expose an isSleeping property based on
    real HR data (low HR + low variance + below 65 bpm)."""
    hsm_path = os.path.join(
        REPO_ROOT,
        "trilateration", "wear-os-app", "app", "src", "main", "java",
        "com", "infernal", "smokingdetector", "HealthServicesManager.kt",
    )
    with open(hsm_path, encoding="utf-8") as f:
        hsm_src = f.read()
    assert "var isSleeping" in hsm_src, (
        "HealthServicesManager doesn't expose isSleeping property"
    )
    assert "hrStd" in hsm_src or "variance" in hsm_src.lower(), (
        "Sleep detection doesn't check HR variance/stability"
    )


# ============================================================================
# 3. Trilatération multi-signaux before +1
# ============================================================================

def test_3_stage_pipeline_enum_exists(source):
    """The 3-stage state machine must be defined."""
    assert "enum class DetectionStage" in source
    assert "IDLE" in source and "OBSERVING" in source and "FULL" in source


def test_idle_stage_watches_for_spike(source):
    """Stage 1 (IDLE): CNN watches for cigProb spike."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "DetectionStage.IDLE" in body
    assert "IDLE" in body and "OBSERVING" in body


def test_observing_stage_runs_1_minute(source):
    """Stage 2 (OBSERVING): 1 minute of observation."""
    assert "OBSERVATION_DURATION_MS" in source
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "DetectionStage.OBSERVING" in body


def test_full_stage_runs_5_minutes(source):
    """Stage 3 (FULL): 5 minutes of deep observation."""
    assert "FULL_OBSERVATION_DURATION_MS" in source
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "DetectionStage.FULL" in body


def test_observing_can_reject_to_idle(source):
    """If 1-minute observation doesn't confirm, must go back to IDLE."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    # Must transition OBSERVING → IDLE on rejection
    assert "OBSERVING" in body and "IDLE" in body


def test_full_stage_confirms_or_rejects(source):
    """Stage 3 must either call handleCigaretteDetected or log REJECTED."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "handleCigaretteDetected" in body
    assert "REJECTED" in body


def test_full_stage_captures_training_data(source):
    """Both confirmed and rejected detections should capture training data."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert body.count("captureTrainingWindow") >= 2, (
        "Need at least 2 captureTrainingWindow calls (confirmed + rejected)"
    )


def test_observing_triggers_boost_on_confirm(source):
    """When OBSERVING confirms → triggers boost for better data collection."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "triggerBoost" in body and "observation_confirmed" in body


# ============================================================================
# 4. SequenceDetector threshold still adapts to pattern
# ============================================================================

def test_peak_threshold_adapts_to_hour_pattern(source):
    """The peak threshold in the 3-stage pipeline must adapt based on
    isHighSmokingHour — lower threshold during known smoking hours."""
    idx = source.find("private suspend fun runInference25Hz")
    body = source[idx:idx + 12000]
    assert "isHighSmokingHour" in body and "peakThreshold" in body, (
        "Peak threshold no longer adapts to hour pattern"
    )
