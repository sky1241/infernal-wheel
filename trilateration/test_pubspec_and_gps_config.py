"""
Regression tests for BUG+049 (pubspec intl pin) and BUG+050 (GPS stay-point
dead code).

BUG+049: pubspec.yaml used 'intl: any' which allowed unbounded version
         resolution. Now pinned to ^0.19.0 so future pub upgrades stay
         within the current major.

BUG+050: GPSClusteringManager registered requestLocationUpdates with
         GPS_MIN_DISTANCE_M = 50f, meaning Android only delivered
         callbacks AFTER the user had moved beyond the 50m stay radius.
         `distance < STAY_POINT_RADIUS_M` was therefore unreachable in
         practice, making the entire stay-point detection pipeline dead
         code. Now GPS_MIN_DISTANCE_M = 5f so callbacks fire on micro-
         movements inside a stay.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PUBSPEC = os.path.join(REPO_ROOT, "infernal-app", "pubspec.yaml")
GPS_MANAGER = os.path.join(
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
    "GPSClusteringManager.kt",
)


@pytest.fixture(scope="module")
def pubspec_source():
    with open(PUBSPEC, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def gps_source():
    with open(GPS_MANAGER, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+049 — pubspec intl version pin
# ============================================================================

def test_intl_is_not_any(pubspec_source):
    """The bad pattern 'intl: any' must not reappear."""
    # Match only at the start of a line (not inside a comment).
    bad = re.search(r"^\s*intl:\s*any\s*$", pubspec_source, re.MULTILINE)
    assert bad is None, (
        "BUG+049 regression: 'intl: any' reappeared in pubspec.yaml"
    )


def test_intl_uses_caret_range(pubspec_source):
    """intl must use ^X.Y.Z format like the other dependencies."""
    assert re.search(
        r"^\s*intl:\s*\^\d+\.\d+\.\d+",
        pubspec_source,
        re.MULTILINE,
    ), "BUG+049 regression: intl no longer pinned to a caret range"


def test_bug_049_marker_present(pubspec_source):
    assert "BUG+049" in pubspec_source


def test_all_dependencies_either_sdk_or_pinned(pubspec_source):
    """Defense-in-depth: no other dependency should be 'any'."""
    # Find dependencies block
    idx = pubspec_source.find("dependencies:")
    end_idx = pubspec_source.find("dev_dependencies:")
    assert idx >= 0 and end_idx > idx
    block = pubspec_source[idx:end_idx]
    bad = re.findall(r"^\s+(\w+):\s*any\s*$", block, re.MULTILINE)
    assert not bad, f"BUG+049 regression: other 'any' dependencies found: {bad}"


# ============================================================================
# BUG+050 — GPS_MIN_DISTANCE_M must be < STAY_POINT_RADIUS_M
# ============================================================================

def test_gps_min_distance_is_small_enough_for_stay_detection(gps_source):
    """The min-distance filter must be MUCH smaller than STAY_POINT_RADIUS_M,
    otherwise the location listener never fires inside a stay."""
    gps_min_match = re.search(
        r"GPS_MIN_DISTANCE_M\s*=\s*(\d+(?:\.\d+)?)f",
        gps_source,
    )
    stay_radius_match = re.search(
        r"STAY_POINT_RADIUS_M\s*=\s*(\d+(?:\.\d+)?)",
        gps_source,
    )
    assert gps_min_match, "GPS_MIN_DISTANCE_M constant removed"
    assert stay_radius_match, "STAY_POINT_RADIUS_M constant removed"

    gps_min = float(gps_min_match.group(1))
    stay_radius = float(stay_radius_match.group(1))

    # The min-distance filter MUST be less than the stay radius — ideally
    # < 1/5 of it so micro-movements inside the stay still produce callbacks.
    assert gps_min < stay_radius / 5, (
        f"BUG+050 regression: GPS_MIN_DISTANCE_M={gps_min}m is not small "
        f"enough relative to STAY_POINT_RADIUS_M={stay_radius}m. "
        f"Need gps_min < stay_radius/5 so the LocationManager fires inside "
        f"the stay radius."
    )


def test_gps_min_distance_not_50(gps_source):
    """Specific check: the old value 50f must not reappear."""
    bad = re.search(r"GPS_MIN_DISTANCE_M\s*=\s*50\.?0?f", gps_source)
    assert bad is None, (
        "BUG+050 regression: GPS_MIN_DISTANCE_M = 50f restored, which makes "
        "the stay-point detection unreachable"
    )


def test_bug_050_marker_present(gps_source):
    assert "BUG+050" in gps_source


# ============================================================================
# Logic proof: simulate the old broken behavior vs the fixed behavior
# ============================================================================

def _simulate_stay_detection(min_distance_filter, stay_radius,
                             actual_displacements):
    """Port of the Kotlin logic. Returns True if a stay was detected.

    actual_displacements is a list of distances between consecutive real
    GPS positions (what the user actually does). The LocationManager
    filter only delivers callbacks when the cumulative displacement
    since the last callback exceeds min_distance_filter.
    """
    delivered_callbacks = []
    cum = 0.0
    for d in actual_displacements:
        cum += d
        if cum >= min_distance_filter:
            delivered_callbacks.append(cum)
            cum = 0.0

    # Stay detection: if any two consecutive delivered callbacks are
    # < stay_radius apart (and implicitly occurring over time), the stay
    # branch would fire. With the old config this is effectively never.
    stay_seen = False
    prev = None
    for d in delivered_callbacks:
        if prev is not None and d < stay_radius:
            stay_seen = True
            break
        prev = d
    return stay_seen


def test_old_config_never_detects_stay_for_micro_movements():
    """User moves 3m, 4m, 5m, 2m (all within a 50m stay). With the OLD
    50m filter, Android delivers ZERO callbacks (no cumulative movement
    > 50m). Stay detection cannot fire — this is what BUG+050 described."""
    displacements = [3, 4, 5, 2, 3, 4]  # cumul 21m, never exceeds 50
    assert not _simulate_stay_detection(50.0, 50.0, displacements)


def test_new_config_fires_on_micro_movements():
    """With the 5m filter, the same micro-movements produce multiple
    callbacks, each < 50m apart, so stay detection CAN fire."""
    displacements = [3, 4, 5, 2, 3, 4]
    # The stay_radius check alone would need to see 2 consecutive callbacks
    # < 50m apart, which is now possible since callbacks deliver.
    # We at least get callbacks from this micro-movement pattern.
    delivered = []
    cum = 0.0
    for d in displacements:
        cum += d
        if cum >= 5.0:
            delivered.append(cum)
            cum = 0.0
    assert len(delivered) >= 2, (
        f"BUG+050 fix proof: 5m filter should deliver multiple callbacks "
        f"for micro-movements summing to {sum(displacements)}m; got {len(delivered)}"
    )
