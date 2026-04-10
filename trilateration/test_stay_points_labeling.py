"""
Regression test for stay_points.py temporal labeling + DBSCAN min_pts default.

Found by forge.py --carmack which flagged stay_points.py with a defect score
of 0.331 + Coupling 0.33. A line-by-line audit revealed two bugs:

  1. label_time() had gaps at hour 8 and hour 18 (both fell into "other"),
     and a contradiction with the docstring which promised "Evening 19h-2h"
     while the code only routed 19-21 to "bar". Hours 22, 23, 0, 1, 2 went
     to "home" instead.

  2. DBSCAN_MIN_PTS = 2 was the testing value, hard-coded with a comment
     "use 5 for real data" — i.e. production was running the testing value.

This test verifies both fixes are in place and prevents regression.
"""
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))

import pandas as pd
import pytest

from stay_points import (
    DBSCAN_MIN_PTS,
    DBSCAN_MIN_PTS_TEST,
    temporal_labeling,
)


# ============================================================================
# Bug fix #36 — DBSCAN_MIN_PTS default is the production value
# ============================================================================

def test_dbscan_min_pts_is_production_value():
    """The default constant must be 5 (production), not 2 (test)."""
    assert DBSCAN_MIN_PTS == 5, (
        f"DBSCAN_MIN_PTS must be 5 (prod), got {DBSCAN_MIN_PTS}. "
        "Tests should pass min_pts=2 explicitly via the new DBSCAN_MIN_PTS_TEST."
    )


def test_dbscan_min_pts_test_constant_exists():
    """The testing alias must still exist for backward compat."""
    assert DBSCAN_MIN_PTS_TEST == 2


# ============================================================================
# Bug fix #35 — temporal labeling has no gaps and no contradictions
# ============================================================================

def _label_for_hour(hour: int) -> str:
    """Run a single-row DataFrame through temporal_labeling to get the label."""
    df = pd.DataFrame({
        'lat': [48.8566],
        'lon': [2.3522],
        'start_time': [pd.Timestamp(f'2026-01-15 {hour:02d}:30:00')],
        'end_time': [pd.Timestamp(f'2026-01-15 {hour:02d}:45:00')],
        'duration_min': [15.0],
        'num_points': [10],
    })
    out = temporal_labeling(df)
    return out['time_label'].iloc[0]


def test_no_hour_falls_through_to_other():
    """Every hour 0-23 must map to home / work / bar — no 'other'."""
    bad = []
    for hour in range(24):
        label = _label_for_hour(hour)
        if label == 'other':
            bad.append(hour)
    assert not bad, f"hours {bad} fell through to 'other' (should be home/work/bar)"


def test_hour_8_is_work_not_other():
    """Hour 8 used to fall into 'other' — it should now be 'work'."""
    assert _label_for_hour(8) == 'work'


def test_hour_18_is_bar_not_other():
    """Hour 18 used to fall into 'other' — it should now be 'bar'."""
    assert _label_for_hour(18) == 'bar'


def test_hour_22_is_home():
    """22h is sleep time → home."""
    assert _label_for_hour(22) == 'home'


def test_hour_3_is_home():
    """Middle of the night → home."""
    assert _label_for_hour(3) == 'home'


def test_hour_12_is_work():
    """Noon → work."""
    assert _label_for_hour(12) == 'work'


def test_hour_20_is_bar():
    """8pm → bar (early evening)."""
    assert _label_for_hour(20) == 'bar'


def test_label_distribution_covers_24_hours():
    """The 24 hours must be partitioned exactly across home/work/bar."""
    counts = {'home': 0, 'work': 0, 'bar': 0, 'other': 0}
    for hour in range(24):
        counts[_label_for_hour(hour)] += 1
    assert counts['other'] == 0, f"'other' should be unused, got {counts['other']} hours"
    assert counts['home'] + counts['work'] + counts['bar'] == 24, (
        f"24 hours must sum: home={counts['home']} work={counts['work']} bar={counts['bar']}"
    )
