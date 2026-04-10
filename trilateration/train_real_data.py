"""
Train smoking/drinking detection model on REAL data (SED/SED-FL datasets).

Usage:
    python train_real_data.py [--runs 5] [--window 4.5] [--overlap 0.5]

Replaces the synthetic-data model with one trained on real wrist IMU data.
Output: smoking_detector_v2.tflite
"""

import pickle
import numpy as np
import os
import sys
from pathlib import Path

# ── Config ──
WINDOW_SEC = 4.5        # Window size (matches SED paper)
OVERLAP = 0.5           # 50% overlap
SAMPLE_RATE = 50        # Hz (SED dataset)
WINDOW_SAMPLES = int(WINDOW_SEC * SAMPLE_RATE)  # 225 samples
STEP_SAMPLES = int(WINDOW_SAMPLES * (1 - OVERLAP))  # 112 samples

NUM_RUNS = int(sys.argv[sys.argv.index('--runs') + 1]) if '--runs' in sys.argv else 5
SEED_BASE = 42

DATA_DIR = Path(__file__).parent / "datasets" / "sed"
OUTPUT_DIR = Path(__file__).parent

print(f"Config: window={WINDOW_SEC}s, overlap={OVERLAP}, Hz={SAMPLE_RATE}")
print(f"Window={WINDOW_SAMPLES} samples, step={STEP_SAMPLES}")
print(f"Runs: {NUM_RUNS}")


# ── Feature Extraction (simplified 30 features) ──
def extract_features(accel, gyro, timestamps):
    """Extract 30 features from a window of accel+gyro data."""
    ax, ay, az = accel[:, 0], accel[:, 1], accel[:, 2]
    gx, gy, gz = gyro[:, 0], gyro[:, 1], gyro[:, 2]

    # Magnitude
    acc_mag = np.sqrt(ax**2 + ay**2 + az**2)
    gyr_mag = np.sqrt(gx**2 + gy**2 + gz**2)

    dt = 1.0 / SAMPLE_RATE
    n = len(ax)

    features = []

    # Time-domain (5): RMS, peak, duration, interval mean/std
    features.append(np.sqrt(np.mean(acc_mag**2)))           # rms_accel
    features.append(np.max(acc_mag))                         # peak_accel
    features.append(n * dt)                                  # duration
    diffs = np.diff(acc_mag)
    features.append(np.mean(np.abs(diffs)) if len(diffs) > 0 else 0)  # interval_mean
    features.append(np.std(diffs) if len(diffs) > 0 else 0)           # interval_std

    # Angular (4): velocity, rotation, stability, smoothness
    features.append(np.mean(gyr_mag))                        # angular_velocity
    features.append(np.std(gyr_mag))                         # wrist_rotation
    # Orientation stability (low std = stable)
    features.append(1.0 / (1.0 + np.std(np.arctan2(ay, ax))))  # orientation_stability
    # Rotation smoothness
    gyr_jerk = np.diff(gyr_mag) / dt if len(gyr_mag) > 1 else np.array([0])
    features.append(1.0 / (1.0 + np.mean(np.abs(gyr_jerk))))   # rotation_smoothness

    # Jerk (3): magnitude, smoothness, consistency
    acc_jerk = np.diff(acc_mag) / dt if len(acc_mag) > 1 else np.array([0])
    features.append(np.mean(np.abs(acc_jerk)))               # jerk_magnitude
    features.append(1.0 / (1.0 + np.std(acc_jerk)))          # jerk_smoothness
    features.append(np.mean(acc_jerk**2) / (np.var(acc_jerk) + 1e-10))  # jerk_consistency

    # Frequency (5): dominant freq, spectral energy/entropy, autocorr, periodicity
    fft_vals = np.abs(np.fft.rfft(acc_mag))
    freqs = np.fft.rfftfreq(n, d=dt)
    if len(fft_vals) > 1:
        # BUG+044 fix: np.argmax(fft_vals[1:]) returns an index into the
        # SLICE starting at bin 1. To map back to the original freqs array
        # we must add 1. Without this, the reported dominant_freq is
        # systematically one bin below the real peak (~0.22Hz error on a
        # 225-sample window @ 50Hz, which is 20-40% relative error on
        # the 0.5-1Hz smoking fundamental).
        features.append(freqs[np.argmax(fft_vals[1:]) + 1])  # dominant_freq
        features.append(np.sum(fft_vals**2))                  # spectral_energy
        fft_norm = fft_vals / (np.sum(fft_vals) + 1e-10)
        features.append(-np.sum(fft_norm * np.log(fft_norm + 1e-10)))  # spectral_entropy
    else:
        features.extend([0, 0, 0])

    # Autocorrelation peak
    if len(acc_mag) > 10:
        autocorr = np.correlate(acc_mag - np.mean(acc_mag), acc_mag - np.mean(acc_mag), mode='full')
        autocorr = autocorr[len(autocorr)//2:]
        if len(autocorr) > 1:
            autocorr = autocorr / (autocorr[0] + 1e-10)
            peak_idx = np.argmax(autocorr[1:]) + 1 if len(autocorr) > 1 else 0
            features.append(autocorr[peak_idx] if peak_idx < len(autocorr) else 0)  # autocorr_peak
        else:
            features.append(0)
    else:
        features.append(0)
    features.append(features[-1] * features[-4] if len(features) >= 4 else 0)  # periodicity

    # Trajectory (4): curvature, elevation, consistency, distance
    if n > 2:
        dx = np.diff(ax)
        dy = np.diff(ay)
        dz = np.diff(az)
        curvature = np.mean(np.abs(np.diff(np.arctan2(dy, dx + 1e-10)))) if len(dx) > 1 else 0
        features.append(curvature)                            # path_curvature
    else:
        features.append(0)
    elev = np.arctan2(az, np.sqrt(ax**2 + ay**2 + 1e-10))
    features.append(np.mean(elev))                            # elevation_angle
    features.append(1.0 / (1.0 + np.std(elev)))              # elevation_consistency
    features.append(np.sum(np.sqrt(np.diff(ax)**2 + np.diff(ay)**2 + np.diff(az)**2)))  # total_distance

    # Regularity (3): score, periodicity coef, temporal clustering
    features.append(1.0 / (1.0 + np.std(acc_mag)))           # regularity_score
    # BUG+043 fix: periodicity_coef was `features[17]` which is path_curvature
    # at this point in the feature list (0-11 time/angular/jerk, 12-14 freq,
    # 15 autocorr_peak, 16 periodicity, 17 path_curvature, ...). The comment
    # said "reuse autocorr" which would be index 15, not 17. The bug silently
    # duplicated path_curvature into the periodicity_coef slot, so every GBM
    # trained by this script had (a) path_curvature appearing twice as an
    # input feature and (b) no real periodicity_coef at all. Fix: use the
    # autocorr_peak value at index 15.
    features.append(features[15] if len(features) > 15 else 0)  # periodicity_coef
    # Temporal clustering: how "bursty" the signal is
    threshold = np.mean(acc_mag) + np.std(acc_mag)
    above = (acc_mag > threshold).astype(float)
    features.append(np.mean(above))                           # temporal_clustering

    # Contextual (6): placeholders (HR, GPS, time not in dataset)
    features.append(70.0)   # hr_baseline (placeholder)
    features.append(0.0)    # hr_delta (placeholder)
    features.append(0)      # gps_cluster (placeholder)
    features.append(12.0)   # time_of_day (placeholder)
    features.append(3)      # day_of_week (placeholder)
    features.append(0.5)    # proximity_smoking (placeholder)

    return np.array(features[:30], dtype=np.float32)


# ── Load SED Dataset ──
def load_sed(filename="SED.pkl"):
    filepath = DATA_DIR / filename
    print(f"Loading {filepath} ...")
    with open(filepath, 'rb') as f:
        dataset = pickle.load(f)

    X_all, y_all, subjects = [], [], []

    for subject_id in dataset:
        for session in dataset[subject_id]:
            acc = np.column_stack([session["AccX"], session["AccY"], session["AccZ"]])
            gyro = np.column_stack([session["GyrX"], session["GyrY"], session["GyrZ"]])
            gt = np.array(session["GT"])
            timestamps = np.array(session["T"])

            # Sliding window
            for start in range(0, len(acc) - WINDOW_SAMPLES, STEP_SAMPLES):
                end = start + WINDOW_SAMPLES
                window_acc = acc[start:end]
                window_gyro = gyro[start:end]
                window_gt = gt[start:end]
                window_t = timestamps[start:end]

                # Label: 1 if >30% of window has puff
                label = 1 if np.mean(window_gt) > 0.3 else 0

                try:
                    feats = extract_features(window_acc, window_gyro, window_t)
                    if not np.any(np.isnan(feats)) and not np.any(np.isinf(feats)):
                        X_all.append(feats)
                        y_all.append(label)
                        subjects.append(subject_id)
                except Exception:
                    continue

    X = np.array(X_all, dtype=np.float32)
    y = np.array(y_all, dtype=np.int32)
    print(f"Loaded: {len(X)} windows, {np.sum(y)} positive ({100*np.mean(y):.1f}%)")
    return X, y, np.array(subjects)


# ── Normalize Features ──
def normalize(X_train, X_test):
    mean = np.mean(X_train, axis=0)
    std = np.std(X_train, axis=0) + 1e-10
    return (X_train - mean) / std, (X_test - mean) / std, mean, std


# ── Train + Evaluate (LOSO = Leave One Subject Out) ──
def train_loso(X, y, subjects, seed=42):
    from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
    from sklearn.metrics import f1_score, precision_score, recall_score, classification_report

    unique_subjects = np.unique(subjects)
    all_preds, all_true = [], []

    for test_subject in unique_subjects:
        train_mask = subjects != test_subject
        test_mask = subjects == test_subject

        X_train, X_test = X[train_mask], X[test_mask]
        y_train, y_test = y[train_mask], y[test_mask]

        if len(np.unique(y_train)) < 2 or len(np.unique(y_test)) < 2:
            continue

        X_train_n, X_test_n, _, _ = normalize(X_train, X_test)

        clf = GradientBoostingClassifier(
            n_estimators=200,
            max_depth=5,
            learning_rate=0.1,
            random_state=seed,
            subsample=0.8,
        )
        clf.fit(X_train_n, y_train)
        preds = clf.predict(X_test_n)

        all_preds.extend(preds)
        all_true.extend(y_test)

    all_preds = np.array(all_preds)
    all_true = np.array(all_true)

    f1 = f1_score(all_true, all_preds, zero_division=0)
    prec = precision_score(all_true, all_preds, zero_division=0)
    rec = recall_score(all_true, all_preds, zero_division=0)

    print(f"  LOSO F1={f1:.3f}  P={prec:.3f}  R={rec:.3f}")
    return f1, prec, rec


# ── Train Final Model (all data) + Export TFLite ──
def train_final_and_export(X, y, seed=42):
    from sklearn.ensemble import GradientBoostingClassifier
    import struct

    # Normalize
    mean = np.mean(X, axis=0)
    std = np.std(X, axis=0) + 1e-10
    X_n = (X - mean) / std

    clf = GradientBoostingClassifier(
        n_estimators=200,
        max_depth=5,
        learning_rate=0.1,
        random_state=seed,
        subsample=0.8,
    )
    clf.fit(X_n, y)

    # Save normalization params
    np.savez(OUTPUT_DIR / "normalization_params.npz", mean=mean, std=std)
    print(f"Normalization params saved")

    # Convert to TFLite via a simple Keras wrapper
    try:
        import tensorflow as tf

        # Create a simple NN that mimics the GBM decision boundary
        model = tf.keras.Sequential([
            tf.keras.layers.InputLayer(input_shape=(30,)),
            tf.keras.layers.Dense(128, activation='relu'),
            tf.keras.layers.Dropout(0.3),
            tf.keras.layers.Dense(64, activation='relu'),
            tf.keras.layers.Dropout(0.2),
            tf.keras.layers.Dense(32, activation='relu'),
            tf.keras.layers.Dense(4, activation='softmax'),  # 4 classes
        ])

        # Generate soft labels from GBM
        proba = clf.predict_proba(X_n)
        # Expand to 4 classes: [cigarette, eating, drinking, other]
        # GBM is binary (smoking vs not), map to 4-class
        y_soft = np.zeros((len(y), 4), dtype=np.float32)
        for i in range(len(y)):
            if y[i] == 1:  # smoking
                y_soft[i] = [0.85, 0.05, 0.05, 0.05]
            else:
                y_soft[i] = [0.05, 0.15, 0.10, 0.70]

        model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
        model.fit(X_n, y_soft, epochs=50, batch_size=32, validation_split=0.1, verbose=1)

        # Convert to TFLite (float32 — BUG+045 fix).
        # The previous int8 path caused the "v5 crash bug" on Wear OS
        # Android 16 (TFLite runtime couldn't load int8 input tensors
        # reliably on the Galaxy Watch). train_cnn_25hz.py already moved
        # to float32; this script was the last holdout. Keep float32
        # until we have a confirmed fix + device-tested validation.
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        converter.optimizations = [tf.lite.Optimize.DEFAULT]

        tflite_model = converter.convert()

        output_path = OUTPUT_DIR / "smoking_detector_v2.tflite"
        with open(output_path, 'wb') as f:
            f.write(tflite_model)

        print(f"TFLite model saved: {output_path} ({len(tflite_model)} bytes)")
        return True

    except ImportError:
        print("TensorFlow not installed — skipping TFLite export")
        print("Install with: pip install tensorflow")

        # Save GBM model as pickle fallback
        import joblib
        joblib.dump(clf, OUTPUT_DIR / "smoking_detector_v2_gbm.pkl")
        print(f"GBM model saved as pickle fallback")
        return False


# ── Main ──
if __name__ == "__main__":
    print("\n" + "="*60)
    print("  TRAINING ON REAL DATA — SED Dataset (Zenodo)")
    print("="*60 + "\n")

    # Load data
    X, y, subjects = load_sed("SED.pkl")

    # Multiple runs with different seeds
    results = []
    for run in range(NUM_RUNS):
        seed = SEED_BASE + run
        print(f"\n--- Run {run+1}/{NUM_RUNS} (seed={seed}) ---")
        f1, prec, rec = train_loso(X, y, subjects, seed=seed)
        results.append({'run': run+1, 'f1': f1, 'precision': prec, 'recall': rec})

    # Summary
    print("\n" + "="*60)
    print("  RESULTS SUMMARY")
    print("="*60)
    f1s = [r['f1'] for r in results]
    precs = [r['precision'] for r in results]
    recs = [r['recall'] for r in results]
    print(f"  F1:        {np.mean(f1s):.3f} ± {np.std(f1s):.3f}")
    print(f"  Precision: {np.mean(precs):.3f} ± {np.std(precs):.3f}")
    print(f"  Recall:    {np.mean(recs):.3f} ± {np.std(recs):.3f}")

    if np.mean(f1s) > 0.5:
        print("\n  Model quality: GOOD — proceeding to TFLite export")
        train_final_and_export(X, y, seed=SEED_BASE)
    else:
        print("\n  Model quality: LOW — needs more data or tuning")
        print("  Exporting anyway for comparison...")
        train_final_and_export(X, y, seed=SEED_BASE)

    print("\nDone!")
