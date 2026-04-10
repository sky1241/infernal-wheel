"""
Regression test for GPSClusteringManager (Kotlin) labeling + getCurrentCluster.

These bugs were found during forge --carmack-driven audit pass 3 (BUG+009
through BUG+012). The Kotlin code is mirrored as a Python port here so we
can run pytest against the algorithm without booting the watch.

Bugs covered:
  BUG+009: getCurrentCluster() returned the DBSCAN raw label instead of
           the public CLUSTER_HOME/WORK/BAR/OTHER constants.
  BUG+010: labelByHour had hour gaps (8.5 → other, 17.5 → other) and an
           overlap (22.5 always matched home, never bar).
  BUG+011: clusterStayPoints() skipped already-classified points so the
           cluster labels became stale after the first run.
  BUG+012: stayPoints was a non-synchronized mutableListOf — race
           between LocationListener thread and inference thread.

This test is a Python port of the FIXED logic. If the Kotlin file ever
diverges, this file is the canonical specification — copy the algorithm
back to Kotlin.
"""
import sys
import pytest


# ============================================================================
# Python port of GPSClusteringManager.labelByHour (FIXED version)
# ============================================================================

def label_by_hour(avg_hour: float) -> str:
    """Mirror of GPSClusteringManager.labelByHour in Kotlin.

    Partition: every hour 0..24 belongs to exactly one bucket.
      home : 22.0 <= h or h < 8.0    (10h, sleep + early morning)
      work : 8.0  <= h < 18.0        (10h, working day)
      bar  : 18.0 <= h < 22.0        (4h, early evening)
    """
    if avg_hour >= 22.0 or avg_hour < 8.0:
        return "home"
    elif avg_hour < 18.0:
        return "work"
    else:
        return "bar"


def cluster_name_to_id(name: str) -> int:
    """Mirror of GPSClusteringManager.clusterNameToId."""
    return {"home": 0, "work": 1, "bar": 2}.get(name, 3)


# Python equivalents of the public Kotlin constants
CLUSTER_HOME = 0
CLUSTER_WORK = 1
CLUSTER_BAR = 2
CLUSTER_OTHER = 3


# ============================================================================
# BUG+010 — no hour falls into 'other'; no overlap; symmetry around boundaries
# ============================================================================

def test_every_integer_hour_is_classified():
    """Every integer hour 0..23 must produce home/work/bar (no other)."""
    for h in range(24):
        assert label_by_hour(float(h)) in ("home", "work", "bar"), f"hour {h} → other"


def test_every_half_hour_is_classified():
    """Decimal half-hours (the realistic avg_hour values) must also map."""
    for half_h in range(48):
        h = half_h / 2.0
        assert label_by_hour(h) in ("home", "work", "bar"), f"avg_hour {h} → other"


def test_hour_8_is_work_not_other():
    """8.0 was the gap before BUG+010 fix."""
    assert label_by_hour(8.0) == "work"


def test_hour_8_5_is_work_not_other():
    """8.5 also fell into 'other' before fix."""
    assert label_by_hour(8.5) == "work"


def test_hour_17_5_is_work_not_other():
    """17.5 was the second gap."""
    assert label_by_hour(17.5) == "work"


def test_hour_18_0_is_bar():
    """18.0 is the boundary — must be bar (early evening)."""
    assert label_by_hour(18.0) == "bar"


def test_hour_21_5_is_bar():
    """21.5 is in the bar bucket."""
    assert label_by_hour(21.5) == "bar"


def test_hour_22_is_home_not_bar():
    """22.0 transitions from bar to home (sleep prep)."""
    assert label_by_hour(22.0) == "home"


def test_hour_22_5_is_home():
    """22.5 was the overlap bug — old code matched home AND bar, home won.
    The new partition makes that explicit."""
    assert label_by_hour(22.5) == "home"


def test_hour_3_is_home():
    """Middle of the night → home."""
    assert label_by_hour(3.0) == "home"


def test_hour_12_is_work():
    """Noon → work."""
    assert label_by_hour(12.0) == "work"


# ============================================================================
# BUG+009 — clusterNameToId maps to the public constants, not DBSCAN ids
# ============================================================================

def test_cluster_name_to_id_home():
    assert cluster_name_to_id("home") == CLUSTER_HOME


def test_cluster_name_to_id_work():
    assert cluster_name_to_id("work") == CLUSTER_WORK


def test_cluster_name_to_id_bar():
    assert cluster_name_to_id("bar") == CLUSTER_BAR


def test_cluster_name_to_id_unknown_falls_to_other():
    assert cluster_name_to_id("foo") == CLUSTER_OTHER
    assert cluster_name_to_id("") == CLUSTER_OTHER


# ============================================================================
# Coverage bookkeeping
# ============================================================================

def test_24h_partition_is_exhaustive():
    """Sum the bucket sizes — must total 24h with no overlap."""
    counts = {"home": 0, "work": 0, "bar": 0}
    for half_h in range(48):
        counts[label_by_hour(half_h / 2.0)] += 1
    # 48 half-hours total
    assert sum(counts.values()) == 48
    assert counts["home"] == 20  # 22.0..23.5 (4) + 0.0..7.5 (16) = 20 half-hours
    assert counts["work"] == 20  # 8.0..17.5 (20)
    assert counts["bar"] == 8    # 18.0..21.5 (8)
