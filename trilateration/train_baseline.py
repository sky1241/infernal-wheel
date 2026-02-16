#!/usr/bin/env python3
"""
Train Baseline Random Forest Classifier

Train a Random Forest model to classify gestures:
- cigarette (target class)
- eating
- drinking
- other

Uses 30 features from feature_extraction.py

Target performance (from literature):
- Lab: 85-92% F1-score
- Field: 80-86% F1-score

References:
- StopWatch 2019: SVM 86% precision, 71% recall
- Sense2Quit 2025: 97.52% F1-score (confounding resilient)
- [B_BRANCHES/TECHNIQUES_DETECTION.md]
"""

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import classification_report, confusion_matrix, f1_score
import pickle
from datetime import datetime
import warnings
warnings.filterwarnings('ignore')

# Import feature extraction
from feature_extraction import extract_all_features


# ============================================================================
# GENERATE SYNTHETIC TRAINING DATA
# ============================================================================

def generate_synthetic_gesture(
    gesture_type: str,
    n_samples: int = 1000,  # Reduced for faster testing (was 15000)
    fs: float = 50.0
) -> tuple:
    """
    Generate synthetic gesture data for training.

    Args:
        gesture_type: 'cigarette', 'eating', 'drinking', 'other'
        n_samples: Number of accelerometer samples
        fs: Sampling frequency (Hz)

    Returns:
        (accel_3d, gyro_3d, timestamps, hr_baseline, hr_current, gps_cluster)
    """
    duration = n_samples / fs
    timestamps = np.linspace(0, duration, n_samples)

    accel_3d = np.zeros((n_samples, 3))
    gyro_3d = np.zeros((n_samples, 3))

    if gesture_type == 'cigarette':
        # Regular puffs every ~45s
        puff_times = np.arange(30, duration, 45)
        puff_duration = 2.0

        for puff_time in puff_times:
            puff_start = int(puff_time * fs)
            puff_end = int((puff_time + puff_duration) * fs)

            if puff_end < n_samples:
                # Hand-to-mouth motion
                t = np.linspace(0, puff_duration, puff_end - puff_start)
                accel_3d[puff_start:puff_end, 0] = 0.5 * np.sin(2 * np.pi * 2 * t)
                accel_3d[puff_start:puff_end, 1] = 0.3 * np.sin(2 * np.pi * 2 * t + np.pi/4)
                accel_3d[puff_start:puff_end, 2] = 0.8 * np.sin(2 * np.pi * 2 * t + np.pi/2)

                # Wrist rotation (~90 deg/s)
                gyro_3d[puff_start:puff_end, 0] = 90 * np.sin(2 * np.pi * 1 * t)
                gyro_3d[puff_start:puff_end, 1] = 60 * np.sin(2 * np.pi * 1 * t + np.pi/3)
                gyro_3d[puff_start:puff_end, 2] = 40 * np.sin(2 * np.pi * 1 * t + np.pi/6)

        hr_baseline = 70.0
        hr_current = 82.0  # +12 bpm (nicotine)
        gps_cluster = 'bar'

    elif gesture_type == 'eating':
        # Irregular eating motions every ~0.5s
        eating_times = np.arange(10, duration, np.random.uniform(0.3, 1.0))
        eating_duration = 0.4

        for eat_time in eating_times:
            eat_start = int(eat_time * fs)
            eat_end = int((eat_time + eating_duration) * fs)

            if eat_end < n_samples:
                # Jerky motion
                t = np.linspace(0, eating_duration, eat_end - eat_start)
                accel_3d[eat_start:eat_end, 0] = 0.7 * np.sin(2 * np.pi * 5 * t) + 0.3 * np.random.randn(len(t))
                accel_3d[eat_start:eat_end, 1] = 0.5 * np.sin(2 * np.pi * 5 * t + np.pi/3) + 0.2 * np.random.randn(len(t))
                accel_3d[eat_start:eat_end, 2] = 0.4 * np.sin(2 * np.pi * 5 * t + np.pi/2) + 0.2 * np.random.randn(len(t))

                # High angular velocity (~200 deg/s)
                gyro_3d[eat_start:eat_end, 0] = 200 * np.sin(2 * np.pi * 3 * t) + 50 * np.random.randn(len(t))
                gyro_3d[eat_start:eat_end, 1] = 150 * np.sin(2 * np.pi * 3 * t + np.pi/4) + 30 * np.random.randn(len(t))

        hr_baseline = 70.0
        hr_current = 70.0  # No change
        gps_cluster = 'home'

    elif gesture_type == 'drinking':
        # Irregular sips every ~60s
        sip_times = np.arange(20, duration, np.random.uniform(40, 80))
        sip_duration = 3.0

        for sip_time in sip_times:
            sip_start = int(sip_time * fs)
            sip_end = int((sip_time + sip_duration) * fs)

            if sip_end < n_samples:
                # Slow motion
                t = np.linspace(0, sip_duration, sip_end - sip_start)
                accel_3d[sip_start:sip_end, 0] = 0.4 * np.sin(2 * np.pi * 0.5 * t)
                accel_3d[sip_start:sip_end, 1] = 0.3 * np.sin(2 * np.pi * 0.5 * t + np.pi/5)
                accel_3d[sip_start:sip_end, 2] = 0.6 * np.sin(2 * np.pi * 0.5 * t + np.pi/3)

                # Moderate rotation (~80 deg/s)
                gyro_3d[sip_start:sip_end, 0] = 80 * np.sin(2 * np.pi * 0.5 * t)
                gyro_3d[sip_start:sip_end, 1] = 50 * np.sin(2 * np.pi * 0.5 * t + np.pi/4)

        hr_baseline = 70.0
        hr_current = 75.0  # +5 bpm (alcohol, if 2+ drinks)
        gps_cluster = 'bar'

    else:  # 'other'
        # Random motion
        accel_3d = 0.1 * np.random.randn(n_samples, 3)
        gyro_3d = 20 * np.random.randn(n_samples, 3)

        hr_baseline = 70.0
        hr_current = 70.0
        gps_cluster = 'work'

    # Add noise
    accel_3d += np.random.normal(0, 0.05, accel_3d.shape)
    gyro_3d += np.random.normal(0, 5, gyro_3d.shape)

    return accel_3d, gyro_3d, timestamps, hr_baseline, hr_current, gps_cluster


def generate_training_dataset(n_per_class: int = 50) -> pd.DataFrame:
    """
    Generate synthetic training dataset with all gesture classes.

    Args:
        n_per_class: Number of samples per class

    Returns:
        DataFrame with features + labels
    """
    print(f"[INFO] Generating synthetic training dataset ({n_per_class} samples/class)...")

    gestures = ['cigarette', 'eating', 'drinking', 'other']
    dataset = []

    for gesture in gestures:
        print(f"   Generating {n_per_class} samples of '{gesture}'...")

        for i in range(n_per_class):
            # Generate gesture
            accel_3d, gyro_3d, timestamps, hr_baseline, hr_current, gps_cluster = \
                generate_synthetic_gesture(gesture)

            # Extract features
            features = extract_all_features(
                accel_3d=accel_3d,
                gyro_3d=gyro_3d,
                timestamps=timestamps,
                hr_baseline=hr_baseline,
                hr_current=hr_current,
                gps_cluster=gps_cluster,
                event_timestamp=datetime.now(),
                proximity_smoking=0.5 if gesture == 'cigarette' else 0.1
            )

            features['label'] = gesture
            dataset.append(features)

    df = pd.DataFrame(dataset)

    print(f"[OK] Generated {len(df)} total samples")
    print(f"     Features: {len(df.columns) - 1}")
    print(f"     Class distribution:")
    for gesture in gestures:
        count = len(df[df['label'] == gesture])
        print(f"       {gesture:12s}: {count:3d} samples")

    return df


# ============================================================================
# TRAIN RANDOM FOREST
# ============================================================================

def train_random_forest(X_train, y_train, n_estimators: int = 100) -> RandomForestClassifier:
    """
    Train Random Forest classifier.

    Args:
        X_train: Training features
        y_train: Training labels
        n_estimators: Number of trees

    Returns:
        Trained RandomForestClassifier
    """
    print(f"[INFO] Training Random Forest (n_estimators={n_estimators})...")

    clf = RandomForestClassifier(
        n_estimators=n_estimators,
        max_depth=10,
        min_samples_split=5,
        min_samples_leaf=2,
        random_state=42,
        n_jobs=-1
    )

    clf.fit(X_train, y_train)

    print(f"[OK] Training completed")

    # Feature importance
    feature_names = X_train.columns
    importances = clf.feature_importances_
    indices = np.argsort(importances)[::-1]

    print(f"[INFO] Top 10 important features:")
    for i in range(min(10, len(feature_names))):
        idx = indices[i]
        print(f"   {i+1}. {feature_names[idx]:25s}: {importances[idx]:.4f}")

    return clf


# ============================================================================
# EVALUATE MODEL
# ============================================================================

def evaluate_model(clf, X_test, y_test):
    """
    Evaluate classifier on test set.

    Args:
        clf: Trained classifier
        X_test: Test features
        y_test: Test labels
    """
    print()
    print("=" * 80)
    print("MODEL EVALUATION")
    print("=" * 80)
    print()

    # Predict
    y_pred = clf.predict(X_test)

    # Classification report
    print("[REPORT] Classification Report:")
    print()
    print(classification_report(y_test, y_pred, digits=3))

    # Confusion matrix
    print("[CONFUSION] Confusion Matrix:")
    print()
    cm = confusion_matrix(y_test, y_pred, labels=['cigarette', 'eating', 'drinking', 'other'])
    print("              cigarette  eating  drinking  other")
    labels_list = ['cigarette', 'eating', 'drinking', 'other']
    for i, label in enumerate(labels_list):
        print(f"   {label:12s}", end="")
        for j in range(len(labels_list)):
            print(f"   {cm[i, j]:4d}", end="")
        print()
    print()

    # F1-score per class
    print("[F1-SCORE] Per-class F1-scores:")
    for label in ['cigarette', 'eating', 'drinking', 'other']:
        mask_true = (y_test == label)
        mask_pred = (y_pred == label)

        if mask_true.sum() > 0:
            f1 = f1_score(y_test, y_pred, labels=[label], average='macro')
            print(f"   {label:12s}: {f1:.3f}")

    # Overall F1
    f1_macro = f1_score(y_test, y_pred, average='macro')
    f1_weighted = f1_score(y_test, y_pred, average='weighted')

    print()
    print(f"[OVERALL] F1-score (macro):    {f1_macro:.3f}")
    print(f"[OVERALL] F1-score (weighted): {f1_weighted:.3f}")

    # Compare to literature
    print()
    print("[COMPARE] Literature benchmarks:")
    print("   StopWatch 2019:     F1 = 0.780 (SVM)")
    print("   Sense2Quit 2025:    F1 = 0.975 (confounding resilient)")
    print("   Lab target:         F1 = 0.850-0.920")
    print("   Field target:       F1 = 0.800-0.860")
    print()

    if f1_macro >= 0.80:
        print("[OK] Model meets field validation target (F1 >= 0.80)!")
    elif f1_macro >= 0.70:
        print("[WARNING] Model below target but acceptable for prototype")
    else:
        print("[WARNING] Model needs improvement (F1 < 0.70)")


# ============================================================================
# SAVE MODEL
# ============================================================================

def save_model(clf, filename: str = 'models/random_forest_baseline.pkl'):
    """Save trained model to disk."""
    import os
    os.makedirs(os.path.dirname(filename), exist_ok=True)

    with open(filename, 'wb') as f:
        pickle.dump(clf, f)

    print(f"[OK] Model saved to {filename}")


# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=" * 80)
    print("TRAIN BASELINE RANDOM FOREST CLASSIFIER")
    print("=" * 80)
    print()

    # Generate training dataset
    df = generate_training_dataset(n_per_class=10)  # 10 samples per class = 40 total (reduced for testing)

    # Split features and labels
    X = df.drop('label', axis=1)
    y = df['label']

    print()
    print(f"[INFO] Dataset shape: {X.shape}")
    print(f"       Features: {X.shape[1]}")
    print(f"       Samples: {X.shape[0]}")
    print()

    # Train/test split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.3, random_state=42, stratify=y
    )

    print(f"[INFO] Train/test split:")
    print(f"       Train: {len(X_train)} samples")
    print(f"       Test:  {len(X_test)} samples")
    print()

    # Train model
    clf = train_random_forest(X_train, y_train, n_estimators=100)

    # Cross-validation
    print()
    print("[INFO] Running 5-fold cross-validation...")
    cv_scores = cross_val_score(clf, X_train, y_train, cv=5, scoring='f1_macro', n_jobs=-1)
    print(f"[OK] CV F1-scores: {cv_scores}")
    print(f"     Mean: {cv_scores.mean():.3f} (+/- {cv_scores.std() * 2:.3f})")
    print()

    # Evaluate on test set
    evaluate_model(clf, X_test, y_test)

    # Save model
    save_model(clf, 'models/random_forest_baseline.pkl')

    print()
    print("=" * 80)
    print("[SUCCESS] BASELINE MODEL TRAINING COMPLETED!")
    print("=" * 80)
    print()
    print("[NEXT] Bloc 4: LOSO cross-validation with real dataset")


if __name__ == "__main__":
    main()
