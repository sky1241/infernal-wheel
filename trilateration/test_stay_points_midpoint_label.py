"""
Regression test for BUG+048 — stay_points.temporal_labeling used only
start_time.hour, mislabeling overnight stays.

A user who arrives home at 21h30 and leaves at 8h00 has start_time.hour=21,
which hit the 'bar' bucket (18-21) even though the stay is clearly a
home-overnight pattern. The fix anchors the label to the MIDPOINT of each
stay's time range so the majority-duration window drives the label.
"""
import os
import sys
from datetime import datetime, timedelta

import pandas as pd
import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(REPO_ROOT, "trilateration"))

from stay_points import temporal_labeling  # noqa: E402


def _make_stays(*ranges):
    """Build a clustered_stays DataFrame with given (start, end) tuples.
    Each stay lands in cluster 0 (so the majority-vote per cluster runs)."""
    rows = []
    for start, end in ranges:
        rows.append({
            'lat': 48.85,
            'lon': 2.35,
            'start_time': start,
            'end_time': end,
            'duration_min': (end - start).total_seconds() / 60,
            'num_points': 10,
            'cluster': 0,
        })
    return pd.DataFrame(rows)


# ============================================================================
# BUG+048 — midpoint-based labeling
# ============================================================================

def test_overnight_stay_is_labeled_home_not_bar():
    """Start 21h30, end 08h00 → duration ~10.5h, midpoint ~02h45 → HOME.
    Before fix: start.hour=21 → 'bar'. After fix: midpoint.hour=2 → 'home'."""
    start = datetime(2026, 4, 14, 21, 30)
    end = datetime(2026, 4, 15, 8, 0)
    df = _make_stays((start, end))
    out = temporal_labeling(df)
    assert out.iloc[0]['time_label'] == 'home', (
        f"BUG+048 regression: overnight 21h30-08h00 labeled "
        f"{out.iloc[0]['time_label']!r}, expected 'home'"
    )


def test_short_evening_stay_is_labeled_bar():
    """Start 19h, end 20h → midpoint 19h30 → 'bar'. Pure evening social."""
    start = datetime(2026, 4, 14, 19, 0)
    end = datetime(2026, 4, 14, 20, 0)
    df = _make_stays((start, end))
    out = temporal_labeling(df)
    assert out.iloc[0]['time_label'] == 'bar'


def test_morning_work_stay_is_labeled_work():
    """Start 09h, end 17h → midpoint 13h → 'work'."""
    start = datetime(2026, 4, 14, 9, 0)
    end = datetime(2026, 4, 14, 17, 0)
    df = _make_stays((start, end))
    out = temporal_labeling(df)
    assert out.iloc[0]['time_label'] == 'work'


def test_weekend_lunch_stay_is_labeled_work():
    """Start 12h, end 14h → midpoint 13h → 'work' (8-18 bucket). Even on
    a weekend this is the 'work' bucket by clock time."""
    start = datetime(2026, 4, 18, 12, 0)  # Saturday
    end = datetime(2026, 4, 18, 14, 0)
    df = _make_stays((start, end))
    out = temporal_labeling(df)
    assert out.iloc[0]['time_label'] == 'work'


def test_bug_048_marker_present():
    path = os.path.join(REPO_ROOT, "trilateration", "stay_points.py")
    with open(path, encoding="utf-8") as f:
        source = f.read()
    assert "BUG+048" in source, "BUG+048 marker missing from stay_points.py"


def test_midpoint_computation_preserves_cluster_majority():
    """3 overnight stays (cluster 0) + 1 evening stay (cluster 0). After
    majority-vote per cluster, the cluster should label as 'home' because
    the majority are overnight."""
    # 3 overnight home stays
    stays = [
        (datetime(2026, 4, 14, 22, 0), datetime(2026, 4, 15, 7, 0)),
        (datetime(2026, 4, 15, 22, 0), datetime(2026, 4, 16, 7, 0)),
        (datetime(2026, 4, 16, 23, 0), datetime(2026, 4, 17, 6, 0)),
        # One evening stay at 19h
        (datetime(2026, 4, 17, 19, 0), datetime(2026, 4, 17, 20, 0)),
    ]
    df = _make_stays(*stays)
    out = temporal_labeling(df)
    # All should inherit cluster 0's majority label = 'home'
    assert out.iloc[0]['label'] == 'home'
    assert (out['label'] == 'home').sum() == 4, (
        "majority-vote should label all cluster-0 points as 'home'"
    )


def test_noise_point_still_labeled_noise():
    """Stay with cluster=-1 (DBSCAN noise) must keep label='noise'."""
    start = datetime(2026, 4, 14, 14, 0)
    end = datetime(2026, 4, 14, 14, 30)
    df = _make_stays((start, end))
    df.loc[0, 'cluster'] = -1
    out = temporal_labeling(df)
    assert out.iloc[0]['label'] == 'noise'


def test_empty_input_returns_empty():
    """Safety: empty DataFrame in, empty DataFrame out."""
    df = pd.DataFrame()
    out = temporal_labeling(df)
    assert len(out) == 0
