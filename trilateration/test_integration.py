#!/usr/bin/env python3
"""
Integration Test: Bloc 1 (GPS) + Bloc 2 (Features)

Test pipeline:
1. Generate GPS trajectory (Bloc 1)
2. Detect stay points + clustering
3. Generate accelerometer gesture at specific location
4. Extract features with GPS context from Bloc 1
5. Verify contextual features match GPS cluster

This validates that Bloc 1 and Bloc 2 connect correctly.
"""

import numpy as np
import pandas as pd
from datetime import datetime, timedelta
import sys

# Import Bloc 1
from stay_points import process_trajectory

# Import Bloc 2
from feature_extraction import extract_all_features, features_to_dataframe


def main():
    print("=" * 80)
    print("INTEGRATION TEST: BLOC 1 (GPS) + BLOC 2 (FEATURES)")
    print("=" * 80)
    print()

    # ========================================================================
    # STEP 1: Generate GPS trajectory (Bloc 1)
    # ========================================================================

    print("[STEP 1] Generate GPS trajectory (home -> bar -> home)...")

    np.random.seed(42)

    # Locations
    home_lat, home_lon = 48.8566, 2.3522  # Paris
    bar_lat, bar_lon = 48.8800, 2.3600    # Bar (nearby)

    trajectory_data = []
    base_time = datetime(2024, 2, 15, 18, 0, 0)  # 6 PM

    # At home (18h-19h, 60 min)
    for i in range(12):
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=i*5),
            'lat': home_lat + np.random.normal(0, 0.0001),
            'lon': home_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    # Go to bar (19h-19h30, moving)
    for i in range(6):
        t = i / 6
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=60 + i*5),
            'lat': home_lat + t * (bar_lat - home_lat) + np.random.normal(0, 0.0002),
            'lon': home_lon + t * (bar_lon - bar_lon) + np.random.normal(0, 0.0002),
            'accuracy': np.random.uniform(10, 20)
        })

    # At bar (19h30-22h30, 180 min) - SMOKING HAPPENS HERE
    for i in range(36):
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=90 + i*5),
            'lat': bar_lat + np.random.normal(0, 0.0001),
            'lon': bar_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    # Go home (22h30-23h, moving)
    for i in range(6):
        t = i / 6
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=270 + i*5),
            'lat': bar_lat + t * (home_lat - bar_lat) + np.random.normal(0, 0.0002),
            'lon': bar_lon + t * (home_lon - bar_lon) + np.random.normal(0, 0.0002),
            'accuracy': np.random.uniform(10, 20)
        })

    # At home night (23h-24h, 60 min)
    for i in range(12):
        trajectory_data.append({
            'timestamp': base_time + timedelta(minutes=300 + i*5),
            'lat': home_lat + np.random.normal(0, 0.0001),
            'lon': home_lon + np.random.normal(0, 0.0001),
            'accuracy': np.random.uniform(5, 15)
        })

    trajectory_df = pd.DataFrame(trajectory_data)

    print(f"[OK] Generated {len(trajectory_df)} GPS points")
    print()

    # ========================================================================
    # STEP 2: Process GPS with Bloc 1 (stay points + clustering)
    # ========================================================================

    print("[STEP 2] Process GPS trajectory with Bloc 1...")
    print()

    stay_points_result = process_trajectory(trajectory_df)

    print()

    if len(stay_points_result) == 0:
        print("[ERROR] No stay points detected!")
        sys.exit(1)

    # Find bar cluster
    bar_cluster = stay_points_result[
        (stay_points_result['start_time'].dt.hour >= 19) &
        (stay_points_result['start_time'].dt.hour < 23)
    ]

    if len(bar_cluster) == 0:
        print("[ERROR] No bar cluster found!")
        sys.exit(1)

    bar_label = bar_cluster.iloc[0]['label']
    print(f"[OK] Found bar cluster: label='{bar_label}'")
    print()

    # ========================================================================
    # STEP 3: Generate cigarette gesture at bar (20h30)
    # ========================================================================

    print("[STEP 3] Generate cigarette gesture at bar (20:30)...")

    fs = 50.0  # 50Hz
    duration = 300  # 5 min
    n_samples = int(fs * duration)
    timestamps = np.linspace(0, duration, n_samples)

    # Cigarette pattern
    puff_times = [30, 75, 120, 165, 210, 255]

    accel_3d = np.zeros((n_samples, 3))
    gyro_3d = np.zeros((n_samples, 3))

    for puff_time in puff_times:
        puff_start = int(puff_time * fs)
        puff_end = int((puff_time + 2.0) * fs)

        if puff_end < n_samples:
            # Accel
            accel_3d[puff_start:puff_end, 0] = 0.5 * np.sin(2 * np.pi * 2 * np.linspace(0, 2.0, puff_end - puff_start))
            accel_3d[puff_start:puff_end, 1] = 0.3 * np.sin(2 * np.pi * 2 * np.linspace(0, 2.0, puff_end - puff_start) + np.pi/4)
            accel_3d[puff_start:puff_end, 2] = 0.8 * np.sin(2 * np.pi * 2 * np.linspace(0, 2.0, puff_end - puff_start) + np.pi/2)

            # Gyro
            gyro_3d[puff_start:puff_end, 0] = 90 * np.sin(2 * np.pi * 1 * np.linspace(0, 2.0, puff_end - puff_start))
            gyro_3d[puff_start:puff_end, 1] = 60 * np.sin(2 * np.pi * 1 * np.linspace(0, 2.0, puff_end - puff_start) + np.pi/3)

    accel_3d += np.random.normal(0, 0.05, accel_3d.shape)
    gyro_3d += np.random.normal(0, 5, gyro_3d.shape)

    print(f"[OK] Generated gesture: {n_samples} samples, {len(puff_times)} puffs")
    print()

    # ========================================================================
    # STEP 4: Extract features with GPS context from Bloc 1
    # ========================================================================

    print("[STEP 4] Extract features with GPS context from Bloc 1...")

    gesture_timestamp = datetime(2024, 2, 15, 20, 30, 0)  # 8:30 PM at bar

    features = extract_all_features(
        accel_3d=accel_3d,
        gyro_3d=gyro_3d,
        timestamps=timestamps,
        hr_baseline=70.0,
        hr_current=82.0,
        gps_cluster=bar_label,  # ← FROM BLOC 1!
        event_timestamp=gesture_timestamp,
        proximity_smoking=0.9
    )

    print(f"[OK] Extracted {len(features)} features")
    print()

    # ========================================================================
    # STEP 5: Verify integration
    # ========================================================================

    print("=" * 80)
    print("INTEGRATION VERIFICATION")
    print("=" * 80)
    print()

    print("[CHECK] GPS Context Integration:")
    print(f"   GPS cluster from Bloc 1:  '{bar_label}'")
    print(f"   GPS cluster in features:  {features['gps_cluster']}")
    print(f"   Time of day (hour):       {features['time_of_day']:.1f}h")
    print(f"   Day of week:              {features['day_of_week']} (Thursday)")
    print()

    print("[CHECK] Biomechanical Features:")
    print(f"   Regularity score:         {features['regularity_score']:.3f}")
    print(f"   Angular velocity:         {features['angular_velocity']:.1f} deg/s")
    print(f"   HR delta:                 +{features['hr_delta']:.0f} bpm")
    print()

    # Verify GPS cluster matches
    cluster_map = {'home': 0, 'work': 1, 'bar': 2, 'other': 3, 'noise': 3}
    expected_cluster_value = cluster_map.get(bar_label, 3)

    if features['gps_cluster'] == expected_cluster_value:
        print("[OK] GPS context integration SUCCESS!")
        print(f"     Bloc 1 label '{bar_label}' correctly mapped to numeric {expected_cluster_value}")
    else:
        print("[ERROR] GPS context integration FAILED!")
        print(f"     Expected {expected_cluster_value}, got {features['gps_cluster']}")
        sys.exit(1)

    print()

    # Export to DataFrame
    df = features_to_dataframe(features)
    print("[OK] Features exported to DataFrame:")
    print(f"     Shape: {df.shape}")
    print(f"     Columns: {list(df.columns[:5])}... (showing first 5)")
    print()

    print("=" * 80)
    print("[SUCCESS] INTEGRATION TEST PASSED!")
    print("=" * 80)
    print()
    print("Bloc 1 (GPS stay points) + Bloc 2 (Feature extraction) connect correctly.")
    print("GPS context (cluster label) flows from Bloc 1 to Bloc 2 features.")


if __name__ == "__main__":
    main()
