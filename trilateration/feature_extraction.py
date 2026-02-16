#!/usr/bin/env python3
"""
Feature Extraction - 30 Biomechanical Features

Extracts discriminative features from accelerometer + gyroscope data
to classify cigarette vs eating vs drinking vs other gestures.

Features (30 total):
- Time-domain (5): RMS, Peak, Duration, Interval mean/std
- Angular (4): Angular velocity, Wrist rotation, Orientation stability
- Jerk (3): Jerk magnitude, Smoothness, Trajectory consistency
- Frequency (5): Dominant freq, Spectral energy, Autocorrelation
- Trajectory (4): Path curvature, Hand-to-mouth angle, Elevation, Distance
- Regularity (3): Regularity score, Periodicity, Temporal clustering
- Contextual (6): HR baseline, HR delta, GPS cluster, Time-of-day, Day-of-week, Proximity

References:
- [B_BRANCHES/BIOMECANIQUE_GESTES.md]
- [B_BRANCHES/TECHNIQUES_DETECTION.md]
"""

import numpy as np
import pandas as pd
from scipy import signal
from scipy.fft import fft, fftfreq
from scipy.stats import skew, kurtosis
from datetime import datetime, timedelta
from typing import Dict, List, Tuple, Optional
import warnings
warnings.filterwarnings('ignore')


# ============================================================================
# TIME-DOMAIN FEATURES (5)
# ============================================================================

def extract_time_domain_features(accel: np.ndarray, timestamps: np.ndarray) -> Dict[str, float]:
    """
    Extract time-domain features from accelerometer signal.

    Features:
    1. RMS (Root Mean Square)
    2. Peak acceleration
    3. Duration (seconds)
    4. Mean interval between peaks
    5. Std interval between peaks

    Args:
        accel: Acceleration magnitude array (Nx1)
        timestamps: Timestamp array (Nx1) in seconds

    Returns:
        Dict with 5 features
    """
    features = {}

    # 1. RMS
    features['rms'] = np.sqrt(np.mean(accel ** 2))

    # 2. Peak acceleration
    features['peak_accel'] = np.max(accel)

    # 3. Duration
    features['duration'] = timestamps[-1] - timestamps[0]

    # 4-5. Interval between peaks
    # Find peaks (acceleration > threshold)
    threshold = np.mean(accel) + 0.5 * np.std(accel)
    peaks, _ = signal.find_peaks(accel, height=threshold, distance=10)

    if len(peaks) > 1:
        intervals = np.diff(timestamps[peaks])
        features['interval_mean'] = np.mean(intervals)
        features['interval_std'] = np.std(intervals)
    else:
        features['interval_mean'] = 0.0
        features['interval_std'] = 0.0

    return features


# ============================================================================
# ANGULAR FEATURES (4)
# ============================================================================

def extract_angular_features(gyro: np.ndarray) -> Dict[str, float]:
    """
    Extract angular features from gyroscope signal.

    Features:
    1. Angular velocity (mean magnitude)
    2. Wrist rotation (max rotation angle)
    3. Orientation stability (std of angular velocity)
    4. Rotation smoothness (jerk of angular velocity)

    Args:
        gyro: Gyroscope 3-axis array (Nx3) [pitch, roll, yaw] in deg/s

    Returns:
        Dict with 4 features
    """
    features = {}

    # 1. Angular velocity magnitude
    angular_velocity_mag = np.linalg.norm(gyro, axis=1)
    features['angular_velocity'] = np.mean(angular_velocity_mag)

    # 2. Wrist rotation (max cumulative rotation)
    # Integrate angular velocity to get rotation angle
    dt = 0.02  # Assume 50Hz sampling → 0.02s per sample
    rotation_angles = np.cumsum(angular_velocity_mag) * dt
    features['wrist_rotation'] = np.max(rotation_angles)

    # 3. Orientation stability (lower = more stable)
    features['orientation_stability'] = np.std(angular_velocity_mag)

    # 4. Rotation smoothness (angular jerk)
    angular_jerk = np.diff(angular_velocity_mag) / dt
    features['rotation_smoothness'] = np.mean(np.abs(angular_jerk))

    return features


# ============================================================================
# JERK FEATURES (3)
# ============================================================================

def extract_jerk_features(accel: np.ndarray, dt: float = 0.02) -> Dict[str, float]:
    """
    Extract jerk features (rate of change of acceleration).

    Features:
    1. Jerk magnitude (mean)
    2. Smoothness (std of jerk - lower = smoother)
    3. Trajectory consistency (autocorrelation of jerk)

    Args:
        accel: Acceleration magnitude array (Nx1)
        dt: Sampling interval (seconds)

    Returns:
        Dict with 3 features
    """
    features = {}

    # Compute jerk
    jerk = np.diff(accel) / dt

    # 1. Jerk magnitude
    features['jerk_magnitude'] = np.mean(np.abs(jerk))

    # 2. Smoothness (cigarette = smooth, eating = jerky)
    features['jerk_smoothness'] = np.std(jerk)

    # 3. Trajectory consistency (autocorrelation)
    if len(jerk) > 1:
        autocorr = np.corrcoef(jerk[:-1], jerk[1:])[0, 1]
        features['jerk_consistency'] = autocorr if not np.isnan(autocorr) else 0.0
    else:
        features['jerk_consistency'] = 0.0

    return features


# ============================================================================
# FREQUENCY-DOMAIN FEATURES (5)
# ============================================================================

def extract_frequency_features(accel: np.ndarray, fs: float = 50.0) -> Dict[str, float]:
    """
    Extract frequency-domain features using FFT.

    Features:
    1. Dominant frequency (Hz)
    2. Spectral energy (total power)
    3. Spectral entropy (complexity)
    4. Autocorrelation peak
    5. Periodicity score

    Args:
        accel: Acceleration magnitude array (Nx1)
        fs: Sampling frequency (Hz)

    Returns:
        Dict with 5 features
    """
    features = {}

    N = len(accel)
    if N < 4:
        return {
            'dominant_freq': 0.0,
            'spectral_energy': 0.0,
            'spectral_entropy': 0.0,
            'autocorr_peak': 0.0,
            'periodicity': 0.0
        }

    # FFT
    accel_fft = fft(accel - np.mean(accel))
    freqs = fftfreq(N, 1/fs)

    # Only positive frequencies
    positive_freqs = freqs[:N//2]
    power_spectrum = np.abs(accel_fft[:N//2]) ** 2

    # 1. Dominant frequency
    dominant_idx = np.argmax(power_spectrum[1:]) + 1  # Skip DC component
    features['dominant_freq'] = positive_freqs[dominant_idx]

    # 2. Spectral energy
    features['spectral_energy'] = np.sum(power_spectrum)

    # 3. Spectral entropy
    power_norm = power_spectrum / (np.sum(power_spectrum) + 1e-10)
    features['spectral_entropy'] = -np.sum(power_norm * np.log2(power_norm + 1e-10))

    # 4. Autocorrelation peak (regularity indicator)
    autocorr = np.correlate(accel - np.mean(accel), accel - np.mean(accel), mode='full')
    autocorr = autocorr[len(autocorr)//2:]  # Keep only positive lags
    autocorr = autocorr / autocorr[0]  # Normalize

    # Find first peak after lag 10 (avoid trivial peak at lag 0)
    if len(autocorr) > 20:
        peaks, _ = signal.find_peaks(autocorr[10:], height=0.3)
        if len(peaks) > 0:
            features['autocorr_peak'] = autocorr[10 + peaks[0]]
        else:
            features['autocorr_peak'] = 0.0
    else:
        features['autocorr_peak'] = 0.0

    # 5. Periodicity score (cigarette = high, eating = low)
    # High autocorrelation + narrow spectral peak = periodic
    spectral_peak_ratio = power_spectrum[dominant_idx] / (np.sum(power_spectrum) + 1e-10)
    features['periodicity'] = features['autocorr_peak'] * spectral_peak_ratio

    return features


# ============================================================================
# TRAJECTORY FEATURES (4)
# ============================================================================

def extract_trajectory_features(accel_3d: np.ndarray, timestamps: np.ndarray) -> Dict[str, float]:
    """
    Extract trajectory features from 3D accelerometer.

    Features:
    1. Path curvature
    2. Hand-to-mouth angle (elevation)
    3. Elevation pattern consistency
    4. Total distance

    Args:
        accel_3d: 3-axis accelerometer (Nx3) [x, y, z]
        timestamps: Timestamp array (Nx1)

    Returns:
        Dict with 4 features
    """
    features = {}

    # Integrate acceleration to get velocity, then position (double integration)
    dt = np.diff(timestamps)
    dt = np.append(dt, dt[-1])  # Pad to match length

    velocity = np.cumsum(accel_3d * dt[:, np.newaxis], axis=0)
    position = np.cumsum(velocity * dt[:, np.newaxis], axis=0)

    # 1. Path curvature (mean change in direction)
    if len(position) > 2:
        direction_changes = []
        for i in range(1, len(position) - 1):
            v1 = position[i] - position[i-1]
            v2 = position[i+1] - position[i]
            norm1 = np.linalg.norm(v1)
            norm2 = np.linalg.norm(v2)
            if norm1 > 0 and norm2 > 0:
                cos_angle = np.dot(v1, v2) / (norm1 * norm2)
                cos_angle = np.clip(cos_angle, -1, 1)
                angle = np.arccos(cos_angle)
                direction_changes.append(angle)

        features['path_curvature'] = np.mean(direction_changes) if direction_changes else 0.0
    else:
        features['path_curvature'] = 0.0

    # 2. Hand-to-mouth angle (elevation - z component dominance)
    features['elevation_angle'] = np.mean(np.abs(accel_3d[:, 2]))  # z-axis

    # 3. Elevation pattern consistency
    features['elevation_consistency'] = 1.0 - np.std(accel_3d[:, 2]) / (np.mean(np.abs(accel_3d[:, 2])) + 1e-10)

    # 4. Total distance
    distances = np.linalg.norm(np.diff(position, axis=0), axis=1)
    features['total_distance'] = np.sum(distances)

    return features


# ============================================================================
# REGULARITY FEATURES (3)
# ============================================================================

def extract_regularity_features(accel: np.ndarray, timestamps: np.ndarray) -> Dict[str, float]:
    """
    Extract regularity features (key discriminator for cigarette).

    Features:
    1. Regularity score (autocorrelation strength)
    2. Periodicity coefficient (FFT peak strength)
    3. Temporal clustering (events clustered in time)

    Args:
        accel: Acceleration magnitude array (Nx1)
        timestamps: Timestamp array (Nx1)

    Returns:
        Dict with 3 features
    """
    features = {}

    # 1. Regularity score (autocorrelation at dominant period)
    autocorr = np.correlate(accel - np.mean(accel), accel - np.mean(accel), mode='full')
    autocorr = autocorr[len(autocorr)//2:]
    autocorr = autocorr / (autocorr[0] + 1e-10)

    # Find strongest autocorrelation peak (excluding lag 0)
    if len(autocorr) > 20:
        peaks, properties = signal.find_peaks(autocorr[10:], height=0.2, prominence=0.1)
        if len(peaks) > 0:
            features['regularity_score'] = np.max(properties['peak_heights'])
        else:
            features['regularity_score'] = 0.0
    else:
        features['regularity_score'] = 0.0

    # 2. Periodicity coefficient (from FFT)
    freq_features = extract_frequency_features(accel)
    features['periodicity_coef'] = freq_features['periodicity']

    # 3. Temporal clustering (coefficient of variation of intervals)
    # Find peaks
    threshold = np.mean(accel) + 0.5 * np.std(accel)
    peaks, _ = signal.find_peaks(accel, height=threshold, distance=10)

    if len(peaks) > 1:
        intervals = np.diff(timestamps[peaks])
        cv = np.std(intervals) / (np.mean(intervals) + 1e-10)
        features['temporal_clustering'] = 1.0 / (1.0 + cv)  # Lower CV = higher clustering
    else:
        features['temporal_clustering'] = 0.0

    return features


# ============================================================================
# CONTEXTUAL FEATURES (6)
# ============================================================================

def extract_contextual_features(
    hr_baseline: float,
    hr_current: float,
    gps_cluster: str,
    timestamp: datetime,
    proximity_to_smoking_location: float
) -> Dict[str, float]:
    """
    Extract contextual features (not from sensors, but from context).

    Features:
    1. HR baseline (resting heart rate)
    2. HR delta (current - baseline)
    3. GPS cluster (home=0, work=1, bar=2, other=3)
    4. Time of day (hour as float 0-23.99)
    5. Day of week (0=Monday, 6=Sunday)
    6. Proximity to known smoking location (0-1)

    Args:
        hr_baseline: Resting heart rate (bpm)
        hr_current: Current heart rate (bpm)
        gps_cluster: Cluster label from stay_points.py ('home', 'work', 'bar', 'other')
        timestamp: Datetime of event
        proximity_to_smoking_location: Distance to nearest smoking location (normalized 0-1)

    Returns:
        Dict with 6 features
    """
    features = {}

    # 1. HR baseline
    features['hr_baseline'] = hr_baseline

    # 2. HR delta
    features['hr_delta'] = hr_current - hr_baseline

    # 3. GPS cluster (categorical → numerical)
    cluster_map = {'home': 0, 'work': 1, 'bar': 2, 'other': 3, 'noise': 3}
    features['gps_cluster'] = cluster_map.get(gps_cluster, 3)

    # 4. Time of day (0-24)
    features['time_of_day'] = timestamp.hour + timestamp.minute / 60.0

    # 5. Day of week (0=Monday, 6=Sunday)
    features['day_of_week'] = timestamp.weekday()

    # 6. Proximity to smoking location
    features['proximity_smoking'] = proximity_to_smoking_location

    return features


# ============================================================================
# MAIN FEATURE EXTRACTION
# ============================================================================

def extract_all_features(
    accel_3d: np.ndarray,
    gyro_3d: np.ndarray,
    timestamps: np.ndarray,
    hr_baseline: float = 70.0,
    hr_current: float = 70.0,
    gps_cluster: str = 'other',
    event_timestamp: Optional[datetime] = None,
    proximity_smoking: float = 0.5
) -> Dict[str, float]:
    """
    Extract all 30 features from a gesture window.

    Args:
        accel_3d: 3-axis accelerometer (Nx3) in m/s^2
        gyro_3d: 3-axis gyroscope (Nx3) in deg/s
        timestamps: Timestamp array (Nx1) in seconds from start
        hr_baseline: Resting heart rate
        hr_current: Current heart rate
        gps_cluster: GPS cluster label ('home', 'work', 'bar', 'other')
        event_timestamp: Datetime of event
        proximity_smoking: Proximity to smoking location (0-1)

    Returns:
        Dict with 30 features
    """
    if event_timestamp is None:
        event_timestamp = datetime.now()

    # Compute acceleration magnitude
    accel_mag = np.linalg.norm(accel_3d, axis=1)

    # Extract feature groups
    features = {}

    # Time-domain (5)
    features.update(extract_time_domain_features(accel_mag, timestamps))

    # Angular (4)
    features.update(extract_angular_features(gyro_3d))

    # Jerk (3)
    features.update(extract_jerk_features(accel_mag))

    # Frequency (5)
    features.update(extract_frequency_features(accel_mag))

    # Trajectory (4)
    features.update(extract_trajectory_features(accel_3d, timestamps))

    # Regularity (3)
    features.update(extract_regularity_features(accel_mag, timestamps))

    # Contextual (6)
    features.update(extract_contextual_features(
        hr_baseline, hr_current, gps_cluster, event_timestamp, proximity_smoking
    ))

    return features


def features_to_dataframe(features: Dict[str, float]) -> pd.DataFrame:
    """Convert features dict to single-row DataFrame."""
    return pd.DataFrame([features])


# ============================================================================
# TEST / DEMO
# ============================================================================

if __name__ == "__main__":
    print("=" * 80)
    print("FEATURE EXTRACTION - 30 BIOMECHANICAL FEATURES - TEST")
    print("=" * 80)
    print()

    # Generate synthetic gesture: cigarette puff pattern
    print("[TEST] Generating synthetic cigarette gesture (8 puffs, 5 min)...")

    np.random.seed(42)
    fs = 50.0  # 50Hz sampling
    duration = 300  # 5 minutes = 300 seconds
    n_samples = int(fs * duration)
    timestamps = np.linspace(0, duration, n_samples)

    # Cigarette pattern: 8 puffs at ~45s intervals
    puff_times = [30, 75, 120, 165, 210, 255]  # 6 puffs (realistic)
    puff_duration = 2.0  # 2 seconds per puff

    # Simulate accelerometer (hand-to-mouth motion)
    accel_3d = np.zeros((n_samples, 3))
    for puff_time in puff_times:
        # Find samples in this puff window
        puff_start = int(puff_time * fs)
        puff_end = int((puff_time + puff_duration) * fs)

        if puff_end < n_samples:
            # Simulate hand movement: acceleration spike in all axes
            accel_3d[puff_start:puff_end, 0] = 0.5 * np.sin(2 * np.pi * 2 * np.linspace(0, puff_duration, puff_end - puff_start))
            accel_3d[puff_start:puff_end, 1] = 0.3 * np.sin(2 * np.pi * 2 * np.linspace(0, puff_duration, puff_end - puff_start) + np.pi/4)
            accel_3d[puff_start:puff_end, 2] = 0.8 * np.sin(2 * np.pi * 2 * np.linspace(0, puff_duration, puff_end - puff_start) + np.pi/2)

    # Add noise
    accel_3d += np.random.normal(0, 0.05, accel_3d.shape)

    # Simulate gyroscope (wrist rotation)
    gyro_3d = np.zeros((n_samples, 3))
    for puff_time in puff_times:
        puff_start = int(puff_time * fs)
        puff_end = int((puff_time + puff_duration) * fs)

        if puff_end < n_samples:
            # Rotation during puff
            gyro_3d[puff_start:puff_end, 0] = 90 * np.sin(2 * np.pi * 1 * np.linspace(0, puff_duration, puff_end - puff_start))
            gyro_3d[puff_start:puff_end, 1] = 60 * np.sin(2 * np.pi * 1 * np.linspace(0, puff_duration, puff_end - puff_start) + np.pi/3)
            gyro_3d[puff_start:puff_end, 2] = 40 * np.sin(2 * np.pi * 1 * np.linspace(0, puff_duration, puff_end - puff_start) + np.pi/6)

    # Add noise
    gyro_3d += np.random.normal(0, 5, gyro_3d.shape)

    print(f"[OK] Generated {n_samples} samples @ {fs}Hz ({duration}s)")
    print(f"     {len(puff_times)} puffs at intervals: {np.diff(puff_times).tolist()} seconds")
    print()

    # Extract features
    print("[INFO] Extracting 30 features...")

    features = extract_all_features(
        accel_3d=accel_3d,
        gyro_3d=gyro_3d,
        timestamps=timestamps,
        hr_baseline=70.0,
        hr_current=82.0,  # +12 bpm (nicotine effect)
        gps_cluster='bar',
        event_timestamp=datetime(2024, 2, 15, 20, 30, 0),  # 8:30 PM
        proximity_smoking=0.9
    )

    print(f"[OK] Extracted {len(features)} features")
    print()

    # Display features by category
    print("=" * 80)
    print("FEATURE VALUES")
    print("=" * 80)
    print()

    categories = {
        'Time-domain (5)': ['rms', 'peak_accel', 'duration', 'interval_mean', 'interval_std'],
        'Angular (4)': ['angular_velocity', 'wrist_rotation', 'orientation_stability', 'rotation_smoothness'],
        'Jerk (3)': ['jerk_magnitude', 'jerk_smoothness', 'jerk_consistency'],
        'Frequency (5)': ['dominant_freq', 'spectral_energy', 'spectral_entropy', 'autocorr_peak', 'periodicity'],
        'Trajectory (4)': ['path_curvature', 'elevation_angle', 'elevation_consistency', 'total_distance'],
        'Regularity (3)': ['regularity_score', 'periodicity_coef', 'temporal_clustering'],
        'Contextual (6)': ['hr_baseline', 'hr_delta', 'gps_cluster', 'time_of_day', 'day_of_week', 'proximity_smoking']
    }

    for category, feature_names in categories.items():
        print(f"{category}:")
        for fname in feature_names:
            if fname in features:
                print(f"   {fname:25s} = {features[fname]:10.4f}")
        print()

    # Check discriminative features
    print("=" * 80)
    print("DISCRIMINATIVE FEATURES VALIDATION")
    print("=" * 80)
    print()

    print("[CHECK] Cigarette signature features:")
    print(f"   Regularity score:    {features['regularity_score']:.3f}  (expect >0.5 for cigarette)")
    print(f"   Interval mean:       {features['interval_mean']:.1f}s   (expect ~45s for cigarette)")
    print(f"   Dominant freq:       {features['dominant_freq']:.4f}Hz (expect ~0.022Hz for cigarette)")
    print(f"   Angular velocity:    {features['angular_velocity']:.1f}°/s (expect ~90°/s for cigarette)")
    print(f"   HR delta:            +{features['hr_delta']:.0f} bpm   (expect +7-15 for nicotine)")
    print()

    # Export to DataFrame
    df = features_to_dataframe(features)
    print("[OK] Features exported to DataFrame:")
    print(f"     Shape: {df.shape}")
    print()

    print("[OK] Test completed successfully!")
    print()
    print("[NEXT] Connect with Bloc 1 (stay_points.py) for GPS context integration")
