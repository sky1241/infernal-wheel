#!/usr/bin/env python3
"""
GPS Stay Points Detection + DBSCAN Clustering

Pipeline:
1. Load GPS trajectories (GeoLife format)
2. WLS fusion (Weighted Least Squares)
3. Stay points detection (sliding window R=50m, T_min=10min)
4. DBSCAN clustering (ε=100m, MinPts=5)
5. Temporal labeling (night=home, day=work, evening=bar)

References:
- [T_TRONC/LOCALISATION_CONTEXTUELLE.md]
- GeoLife dataset: https://www.microsoft.com/en-us/research/publication/geolife-gps-trajectory-dataset-user-guide/
"""

import numpy as np
import pandas as pd
from datetime import datetime, timedelta
from sklearn.cluster import DBSCAN
from typing import List, Tuple, Dict
import os


# ============================================================================
# CONSTANTS
# ============================================================================

EARTH_RADIUS_M = 6371000  # Earth radius in meters
STAY_POINT_RADIUS_M = 50  # Stay point detection radius (meters)
STAY_POINT_MIN_TIME_MIN = 10  # Stay point minimum duration (minutes)
DBSCAN_EPS_M = 100  # DBSCAN epsilon (meters)
DBSCAN_MIN_PTS = 2  # DBSCAN minimum points (use 5 for real data, 2 for testing)


# ============================================================================
# HAVERSINE DISTANCE
# ============================================================================

def haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """
    Calculate great-circle distance between two GPS points using Haversine formula.

    Args:
        lat1, lon1: First point (degrees)
        lat2, lon2: Second point (degrees)

    Returns:
        Distance in meters

    References:
        - https://en.wikipedia.org/wiki/Haversine_formula
    """
    # Convert to radians
    lat1_rad = np.radians(lat1)
    lon1_rad = np.radians(lon1)
    lat2_rad = np.radians(lat2)
    lon2_rad = np.radians(lon2)

    # Haversine formula
    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad
    a = np.sin(dlat/2)**2 + np.cos(lat1_rad) * np.cos(lat2_rad) * np.sin(dlon/2)**2
    c = 2 * np.arcsin(np.sqrt(a))

    return EARTH_RADIUS_M * c


# ============================================================================
# WLS FUSION (Weighted Least Squares)
# ============================================================================

def wls_fusion(points: pd.DataFrame) -> Tuple[float, float]:
    """
    Fuse multiple GPS points using Weighted Least Squares.

    Weight = 1 / accuracy^2 (higher weight for more accurate points)

    Args:
        points: DataFrame with columns ['lat', 'lon', 'accuracy']

    Returns:
        (fused_lat, fused_lon)

    References:
        - [T_TRONC/LOCALISATION_CONTEXTUELLE.md] Section WLS
    """
    if len(points) == 0:
        return None, None

    if len(points) == 1:
        return points.iloc[0]['lat'], points.iloc[0]['lon']

    # Calculate weights (inverse square of accuracy)
    # If no accuracy column, use uniform weights
    if 'accuracy' in points.columns:
        weights = 1.0 / (points['accuracy'].values ** 2)
        weights = weights / weights.sum()  # Normalize
    else:
        weights = np.ones(len(points)) / len(points)

    # Weighted average
    fused_lat = np.sum(points['lat'].values * weights)
    fused_lon = np.sum(points['lon'].values * weights)

    return fused_lat, fused_lon


# ============================================================================
# STAY POINTS DETECTION
# ============================================================================

def detect_stay_points(trajectory: pd.DataFrame,
                       radius_m: float = STAY_POINT_RADIUS_M,
                       min_time_min: float = STAY_POINT_MIN_TIME_MIN) -> List[Dict]:
    """
    Detect stay points using sliding window algorithm.

    Algorithm:
    1. For each point Pi, look ahead to find points within radius R
    2. If time span >= T_min, it's a stay point
    3. Fuse all points in the stay using WLS

    Args:
        trajectory: DataFrame with ['timestamp', 'lat', 'lon', 'accuracy']
        radius_m: Stay point radius (meters)
        min_time_min: Minimum stay duration (minutes)

    Returns:
        List of stay points: [{'lat', 'lon', 'start_time', 'end_time', 'duration_min'}]

    References:
        - [T_TRONC/LOCALISATION_CONTEXTUELLE.md] Stay Point Detection
    """
    if len(trajectory) < 2:
        return []

    # Ensure timestamp is datetime
    if not pd.api.types.is_datetime64_any_dtype(trajectory['timestamp']):
        trajectory['timestamp'] = pd.to_datetime(trajectory['timestamp'])

    # Sort by time
    traj = trajectory.sort_values('timestamp').reset_index(drop=True)

    stay_points = []
    i = 0

    while i < len(traj):
        j = i + 1

        # Look ahead to find points within radius
        while j < len(traj):
            dist = haversine_distance(
                traj.iloc[i]['lat'], traj.iloc[i]['lon'],
                traj.iloc[j]['lat'], traj.iloc[j]['lon']
            )

            if dist > radius_m:
                break  # Moved out of radius

            j += 1

        # Check if time span >= min_time
        if j > i + 1:
            time_span = (traj.iloc[j-1]['timestamp'] - traj.iloc[i]['timestamp']).total_seconds() / 60

            if time_span >= min_time_min:
                # This is a stay point - fuse all points using WLS
                stay_cluster = traj.iloc[i:j]
                fused_lat, fused_lon = wls_fusion(stay_cluster)

                stay_points.append({
                    'lat': fused_lat,
                    'lon': fused_lon,
                    'start_time': traj.iloc[i]['timestamp'],
                    'end_time': traj.iloc[j-1]['timestamp'],
                    'duration_min': time_span,
                    'num_points': len(stay_cluster)
                })

                i = j  # Jump to end of stay
                continue

        i += 1

    return stay_points


# ============================================================================
# DBSCAN CLUSTERING
# ============================================================================

def cluster_stay_points(stay_points: List[Dict],
                        eps_m: float = DBSCAN_EPS_M,
                        min_pts: int = DBSCAN_MIN_PTS) -> pd.DataFrame:
    """
    Cluster stay points using DBSCAN to identify significant locations.

    Args:
        stay_points: List of stay points from detect_stay_points()
        eps_m: DBSCAN epsilon (meters)
        min_pts: DBSCAN minimum points per cluster

    Returns:
        DataFrame with stay points + cluster labels

    References:
        - [T_TRONC/LOCALISATION_CONTEXTUELLE.md] DBSCAN Clustering
        - https://scikit-learn.org/stable/modules/generated/sklearn.cluster.DBSCAN.html
    """
    if len(stay_points) == 0:
        return pd.DataFrame()

    df = pd.DataFrame(stay_points)

    # Convert lat/lon to radians for DBSCAN
    coords_rad = np.radians(df[['lat', 'lon']].values)

    # DBSCAN with haversine metric
    # eps must be in radians (eps_m / EARTH_RADIUS_M)
    eps_rad = eps_m / EARTH_RADIUS_M

    dbscan = DBSCAN(eps=eps_rad, min_samples=min_pts, metric='haversine')
    df['cluster'] = dbscan.fit_predict(coords_rad)

    return df


# ============================================================================
# TEMPORAL LABELING
# ============================================================================

def temporal_labeling(clustered_stays: pd.DataFrame) -> pd.DataFrame:
    """
    Label clusters based on temporal patterns.

    Rules:
    - Night (22h-8h) → home
    - Day (9h-18h) → work
    - Evening (19h-2h) → bar/social

    Args:
        clustered_stays: DataFrame from cluster_stay_points()

    Returns:
        DataFrame with 'label' column added

    References:
        - [T_TRONC/LOCALISATION_CONTEXTUELLE.md] Temporal Labeling
    """
    if len(clustered_stays) == 0:
        return clustered_stays

    df = clustered_stays.copy()

    # Extract hour from start_time
    df['hour'] = df['start_time'].dt.hour

    # Temporal labeling
    def label_time(hour):
        if 22 <= hour or hour < 8:
            return 'home'
        elif 9 <= hour < 18:
            return 'work'
        elif 19 <= hour < 22:
            return 'bar'
        else:
            return 'other'

    df['time_label'] = df['hour'].apply(label_time)

    # For each cluster, assign most frequent time label
    if 'cluster' in df.columns:
        cluster_labels = df[df['cluster'] != -1].groupby('cluster')['time_label'].agg(
            lambda x: x.value_counts().index[0] if len(x) > 0 else 'unknown'
        ).to_dict()

        df['label'] = df['cluster'].map(cluster_labels).astype('object')  # Fix pandas warning
        df.loc[df['cluster'] == -1, 'label'] = 'noise'
    else:
        df['label'] = df['time_label']

    return df


# ============================================================================
# PIPELINE
# ============================================================================

def process_trajectory(trajectory: pd.DataFrame) -> pd.DataFrame:
    """
    Full pipeline: trajectory → stay points → clustering → labeling.

    Args:
        trajectory: DataFrame with ['timestamp', 'lat', 'lon', 'accuracy']

    Returns:
        DataFrame with clustered + labeled stay points
    """
    print(f"[INFO] Processing trajectory with {len(trajectory)} GPS points...")

    # Step 1: Detect stay points
    stay_points = detect_stay_points(trajectory)
    print(f"[OK] Detected {len(stay_points)} stay points")

    if len(stay_points) == 0:
        return pd.DataFrame()

    # Step 2: Cluster stay points
    clustered = cluster_stay_points(stay_points)
    n_clusters = len(clustered[clustered['cluster'] != -1]['cluster'].unique())
    print(f"[OK] Clustered into {n_clusters} significant locations")

    # Step 3: Temporal labeling
    labeled = temporal_labeling(clustered)
    print(f"[OK] Labeled locations:")
    for label in labeled['label'].unique():
        count = len(labeled[labeled['label'] == label])
        print(f"   - {label}: {count} stays")

    return labeled


# ============================================================================
# LOAD GEOLIFE DATA (Quick Test)
# ============================================================================

def load_geolife_plt(file_path: str) -> pd.DataFrame:
    """
    Load GeoLife .plt file format.

    Format (CSV, skip 6 header lines):
    lat,lon,0,altitude,days,date,time

    Args:
        file_path: Path to .plt file

    Returns:
        DataFrame with ['timestamp', 'lat', 'lon', 'altitude']
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File not found: {file_path}")

    # Read CSV, skip 6 header lines
    df = pd.read_csv(file_path, skiprows=6, header=None,
                     names=['lat', 'lon', 'zero', 'altitude', 'days', 'date', 'time'])

    # Combine date + time into timestamp
    df['timestamp'] = pd.to_datetime(df['date'] + ' ' + df['time'])

    # Keep only relevant columns
    df = df[['timestamp', 'lat', 'lon', 'altitude']].copy()

    # Add mock accuracy (GeoLife doesn't provide it)
    df['accuracy'] = 10.0  # Assume 10m accuracy

    return df


# ============================================================================
# TEST / DEMO
# ============================================================================

if __name__ == "__main__":
    print("=" * 80)
    print("GPS STAY POINTS + DBSCAN CLUSTERING - TEST")
    print("=" * 80)
    print()

    # Generate synthetic trajectory for testing (if no GeoLife data)
    print("[TEST] Generating synthetic trajectory...")

    # Simulate trajectory: home (morning) → work (day) → bar (evening) → home (night)
    np.random.seed(42)

    # Home location (Paris, example)
    home_lat, home_lon = 48.8566, 2.3522
    # Work location (2km away)
    work_lat, work_lon = 48.8750, 2.3700
    # Bar location (1km from work)
    bar_lat, bar_lon = 48.8800, 2.3600

    trajectory_data = []
    base_time = datetime(2024, 2, 15, 7, 0, 0)

    # Morning at home (7h-8h30, 90 min)
    for i in range(18):  # 18 points × 5 min = 90 min
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=i*5),
            'lat': home_lat + np.random.normal(0, 0.0001),
            'lon': home_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    # Commute to work (8h30-9h, moving points)
    for i in range(6):
        t = i / 6
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=90 + i*5),
            'lat': home_lat + t * (work_lat - home_lat) + np.random.normal(0, 0.0002),
            'lon': home_lon + t * (work_lon - home_lon) + np.random.normal(0, 0.0002),
            'accuracy': np.random.uniform(10, 20)
        })

    # At work (9h-18h, 540 min)
    for i in range(108):  # 108 points × 5 min = 540 min
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=120 + i*5),
            'lat': work_lat + np.random.normal(0, 0.0001),
            'lon': work_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    # Go to bar (18h-19h, moving points)
    for i in range(12):
        t = i / 12
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=660 + i*5),
            'lat': work_lat + t * (bar_lat - work_lat) + np.random.normal(0, 0.0002),
            'lon': work_lon + t * (bar_lon - work_lon) + np.random.normal(0, 0.0002),
            'accuracy': np.random.uniform(10, 20)
        })

    # At bar (19h-22h, 180 min)
    for i in range(36):  # 36 points × 5 min = 180 min
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=720 + i*5),
            'lat': bar_lat + np.random.normal(0, 0.0001),
            'lon': bar_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    # Go home (22h-22h30, moving points)
    for i in range(6):
        t = i / 6
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=900 + i*5),
            'lat': bar_lat + t * (home_lat - bar_lat) + np.random.normal(0, 0.0002),
            'lon': bar_lon + t * (home_lon - bar_lon) + np.random.normal(0, 0.0002),
            'accuracy': np.random.uniform(10, 20)
        })

    # At home night (22h30-24h, 90 min)
    for i in range(18):
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=930 + i*5),
            'lat': home_lat + np.random.normal(0, 0.0001),
            'lon': home_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    trajectory_df = pd.DataFrame(trajectory_data)

    print(f"[OK] Generated {len(trajectory_df)} GPS points")
    print(f"     Time span: {trajectory_df['timestamp'].min()} -> {trajectory_df['timestamp'].max()}")
    print()

    # Run pipeline
    result = process_trajectory(trajectory_df)

    print()
    print("=" * 80)
    print("RESULTS")
    print("=" * 80)
    print()

    if len(result) > 0:
        print(result[['lat', 'lon', 'start_time', 'end_time', 'duration_min', 'cluster', 'label']].to_string(index=False))
        print()

        # Summary by cluster
        print("[SUMMARY] CLUSTER SUMMARY:")
        for cluster_id in sorted(result[result['cluster'] != -1]['cluster'].unique()):
            cluster_data = result[result['cluster'] == cluster_id]
            label = cluster_data['label'].iloc[0]
            total_time = cluster_data['duration_min'].sum()
            n_visits = len(cluster_data)
            centroid_lat = cluster_data['lat'].mean()
            centroid_lon = cluster_data['lon'].mean()

            print(f"   Cluster {cluster_id} ({label}):")
            print(f"      - {n_visits} visits, {total_time:.1f} min total")
            print(f"      - Centroid: ({centroid_lat:.4f}, {centroid_lon:.4f})")
    else:
        print("[WARNING] No stay points detected")

    print()
    print("[OK] Test completed successfully!")
