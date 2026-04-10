"""
Deep regression tests for stay_points.py — kill the mutation survivors.

After running `python forge.py --mutate trilateration/stay_points.py` we
discovered that 166 mutants were generated and only ~14% were killed by
the existing 10-test suite (test_stay_points_labeling.py covers only
label_time() and the DBSCAN_MIN_PTS constant — the rest of the file is
untested).

This file adds tests for the other 5 critical functions:

  1. haversine_distance — geodesic distance correctness
  2. wls_fusion — weighted vs unweighted, zero-input edge cases
  3. detect_stay_points — sliding window correctness
  4. cluster_stay_points — DBSCAN integration
  5. process_trajectory — full pipeline smoke test

Goal: bring stay_points.py mutation score from ~14% to >50% by killing
the survivors that test boundary conditions and arithmetic operators.
"""
import os
import sys

import math
import pandas as pd
import pytest

sys.path.insert(0, os.path.dirname(__file__))

from stay_points import (
    EARTH_RADIUS_M,
    DBSCAN_MIN_PTS,
    haversine_distance,
    wls_fusion,
    detect_stay_points,
    cluster_stay_points,
    temporal_labeling,
    process_trajectory,
)


# ============================================================================
# 1. haversine_distance
# ============================================================================

def test_haversine_zero_distance():
    """Same point → distance 0."""
    assert haversine_distance(48.8566, 2.3522, 48.8566, 2.3522) == 0.0


def test_haversine_paris_lyon():
    """Paris (48.8566, 2.3522) to Lyon (45.7640, 4.8357) ≈ 392 km."""
    d = haversine_distance(48.8566, 2.3522, 45.7640, 4.8357)
    # Reference value from a geodesic calculator (great-circle, sphere model)
    assert 390_000 < d < 395_000, f"got {d/1000:.1f} km, expected ~392 km"


def test_haversine_antipodes():
    """Two diametrically opposite points → π × R ≈ 20015 km."""
    d = haversine_distance(0.0, 0.0, 0.0, 180.0)
    expected = math.pi * EARTH_RADIUS_M
    assert abs(d - expected) < 1.0


def test_haversine_small_distance():
    """Two points 100m apart on the equator."""
    # 100m at the equator ≈ 0.0009 degrees of longitude
    d = haversine_distance(0.0, 0.0, 0.0, 100.0 / EARTH_RADIUS_M * 180.0 / math.pi)
    assert 99.5 < d < 100.5, f"got {d}m, expected ~100m"


def test_haversine_symmetric():
    """d(A, B) == d(B, A)."""
    a = (48.8566, 2.3522)
    b = (45.7640, 4.8357)
    assert abs(haversine_distance(*a, *b) - haversine_distance(*b, *a)) < 1e-6


# ============================================================================
# 2. wls_fusion
# ============================================================================

def test_wls_empty_input():
    """Empty DataFrame → (None, None)."""
    df = pd.DataFrame(columns=['lat', 'lon', 'accuracy'])
    lat, lon = wls_fusion(df)
    assert lat is None and lon is None


def test_wls_single_point():
    """Single point → that exact point, no averaging."""
    df = pd.DataFrame({'lat': [48.8566], 'lon': [2.3522], 'accuracy': [10.0]})
    lat, lon = wls_fusion(df)
    assert lat == 48.8566 and lon == 2.3522


def test_wls_uniform_weights_no_accuracy():
    """No accuracy column → uniform mean."""
    df = pd.DataFrame({'lat': [48.0, 49.0], 'lon': [2.0, 3.0]})
    lat, lon = wls_fusion(df)
    assert abs(lat - 48.5) < 1e-9
    assert abs(lon - 2.5) < 1e-9


def test_wls_weighted_favors_accurate_point():
    """Lower accuracy value = higher weight = result closer to that point."""
    # Point A has accuracy 1m (very precise), point B has accuracy 100m (loose).
    # Weight A = 1/1² = 1.0, weight B = 1/100² = 0.0001.
    # Result should be ~ entirely A.
    df = pd.DataFrame({
        'lat': [48.0, 60.0],
        'lon': [2.0, 5.0],
        'accuracy': [1.0, 100.0],
    })
    lat, lon = wls_fusion(df)
    assert abs(lat - 48.0) < 0.01
    assert abs(lon - 2.0) < 0.01


def test_wls_equal_accuracy_equals_mean():
    """Two points with equal accuracy → midpoint."""
    df = pd.DataFrame({
        'lat': [48.0, 49.0],
        'lon': [2.0, 3.0],
        'accuracy': [10.0, 10.0],
    })
    lat, lon = wls_fusion(df)
    assert abs(lat - 48.5) < 1e-9
    assert abs(lon - 2.5) < 1e-9


# ============================================================================
# 3. detect_stay_points
# ============================================================================

def _build_traj(points):
    """Helper: build a trajectory DataFrame from a list of (lat, lon, ts_iso)."""
    return pd.DataFrame({
        'lat': [p[0] for p in points],
        'lon': [p[1] for p in points],
        'timestamp': pd.to_datetime([p[2] for p in points]),
    })


def test_detect_stay_points_empty():
    """Empty trajectory → no stays."""
    traj = pd.DataFrame(columns=['lat', 'lon', 'timestamp'])
    assert detect_stay_points(traj) == []


def test_detect_stay_points_single_point():
    """Single point can't form a stay."""
    traj = _build_traj([(48.0, 2.0, '2026-01-01 09:00:00')])
    assert detect_stay_points(traj) == []


def test_detect_stay_points_short_visit_no_stay():
    """5 points within 10m but only 5 minutes → not a stay (min 10 min)."""
    pts = [(48.0, 2.0, f'2026-01-01 09:0{m}:00') for m in range(5)]
    traj = _build_traj(pts)
    stays = detect_stay_points(traj)
    assert stays == []


def test_detect_stay_points_long_visit_yields_stay():
    """5 points within 10m over 15 minutes → 1 stay."""
    pts = [(48.0, 2.0, f'2026-01-01 09:{m:02d}:00') for m in (0, 5, 10, 12, 15)]
    traj = _build_traj(pts)
    stays = detect_stay_points(traj, radius_m=50, min_time_min=10)
    assert len(stays) == 1
    assert stays[0]['duration_min'] >= 10
    assert abs(stays[0]['lat'] - 48.0) < 1e-6


def test_detect_stay_points_moving_breaks_stay():
    """Sequence: stay 15min, walk away → still 1 stay."""
    pts = [
        (48.0, 2.0, '2026-01-01 09:00:00'),
        (48.0, 2.0, '2026-01-01 09:05:00'),
        (48.0, 2.0, '2026-01-01 09:15:00'),
        # Now move 1km away (well outside 50m radius)
        (48.01, 2.01, '2026-01-01 09:20:00'),
        (48.02, 2.02, '2026-01-01 09:25:00'),
    ]
    traj = _build_traj(pts)
    stays = detect_stay_points(traj, radius_m=50, min_time_min=10)
    assert len(stays) == 1


# ============================================================================
# 4. cluster_stay_points
# ============================================================================

def test_cluster_empty_stay_points():
    """Empty input → empty DataFrame."""
    df = cluster_stay_points([])
    assert len(df) == 0


def test_cluster_two_close_stays_one_cluster():
    """Two stays within 100m → 1 cluster (with min_pts=2)."""
    stays = [
        {'lat': 48.0, 'lon': 2.0, 'start_time': pd.Timestamp('2026-01-01 09:00'),
         'end_time': pd.Timestamp('2026-01-01 09:15'), 'duration_min': 15, 'num_points': 5},
        {'lat': 48.0001, 'lon': 2.0001, 'start_time': pd.Timestamp('2026-01-02 09:00'),
         'end_time': pd.Timestamp('2026-01-02 09:15'), 'duration_min': 15, 'num_points': 5},
    ]
    df = cluster_stay_points(stays, eps_m=100, min_pts=2)
    # Both should belong to the same non-noise cluster
    assert (df['cluster'] >= 0).sum() == 2
    assert df['cluster'].nunique() == 1


def test_cluster_far_stays_are_noise():
    """Two stays far apart → both noise (cluster=-1) with min_pts=2."""
    stays = [
        {'lat': 48.0, 'lon': 2.0, 'start_time': pd.Timestamp('2026-01-01 09:00'),
         'end_time': pd.Timestamp('2026-01-01 09:15'), 'duration_min': 15, 'num_points': 5},
        {'lat': 50.0, 'lon': 5.0, 'start_time': pd.Timestamp('2026-01-02 09:00'),
         'end_time': pd.Timestamp('2026-01-02 09:15'), 'duration_min': 15, 'num_points': 5},
    ]
    df = cluster_stay_points(stays, eps_m=100, min_pts=2)
    assert (df['cluster'] == -1).sum() == 2


# ============================================================================
# 5. process_trajectory smoke test
# ============================================================================

def test_process_trajectory_pipeline():
    """End-to-end: trajectory → stays → cluster → labels.

    Generates enough stays per location (>= DBSCAN_MIN_PTS = 5) so the
    DBSCAN clustering actually produces non-noise clusters. The earlier
    version of this test used 2 stays per location which worked under
    the old (broken) DBSCAN_MIN_PTS=2 default but produces only noise
    after BUG+004 fixed the constant to the production value of 5.
    """
    pts = []
    # 6 days at home (cluster A) — each stay is 6 GPS points × 5 min apart
    # so it qualifies as a stay (>= 10 min). 6 stays > MIN_PTS=5 → cluster.
    for d in range(1, 7):
        for m in range(0, 30, 5):
            pts.append((48.0, 2.0, f'2026-01-{d:02d} 07:{m:02d}:00'))
    # 6 days at work (cluster B)
    for d in range(1, 7):
        for m in range(0, 30, 5):
            pts.append((48.10, 2.10, f'2026-01-{d:02d} 10:{m:02d}:00'))

    traj = _build_traj(pts)
    result = process_trajectory(traj)

    # Should have at least 12 stays (6 mornings + 6 work sessions)
    assert len(result) >= 12, f"got {len(result)} stays, expected >= 12"
    # Should have at least 2 distinct clusters (home + work)
    non_noise = result[result['cluster'] >= 0]
    assert non_noise['cluster'].nunique() >= 2, (
        f"got {non_noise['cluster'].nunique()} non-noise clusters, expected >= 2"
    )


# ============================================================================
# 6. Constants check
# ============================================================================

def test_dbscan_min_pts_is_5():
    """Production default per the GeoLife paper."""
    assert DBSCAN_MIN_PTS == 5


def test_earth_radius_constant():
    """Earth radius should be ~6371 km."""
    assert 6_370_000 < EARTH_RADIUS_M < 6_372_000
