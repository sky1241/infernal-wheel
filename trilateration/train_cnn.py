"""
Train CNN 1D on raw accel+gyro signals (SED + SED-FL datasets).

The SED paper achieves F1=0.863 with CNN on 4.5s windows.
This script aims to match that using raw 6-channel IMU data.

Usage:
    python train_cnn.py

Output: smoking_detector_v4.tflite
"""

import pickle
import numpy as np
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import tensorflow as tf
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import f1_score, precision_score, recall_score

# ── Config ──
WINDOW_SEC = 4.5
SAMPLE_RATE = 50
WINDOW_SAMPLES = int(WINDOW_SEC * SAMPLE_RATE)  # 225
STEP_SAMPLES = WINDOW_SAMPLES // 2  # 50% overlap = 112
CHANNELS = 6  # AccX, AccY, AccZ, GyrX, GyrY, GyrZ
LABEL_THRESHOLD = 0.3  # >30% puff in window = positive
EPOCHS = 30
BATCH_SIZE = 128
N_FOLDS = 5

DATA_DIR = os.path.join(os.path.dirname(__file__), "datasets", "sed")


def load_windows():
    """Load raw 6-channel windows from SED + SED-FL."""
    X_all, y_all = [], []

    for pkl_name in ["SED.pkl", "SED-FL.pkl"]:
        path = os.path.join(DATA_DIR, pkl_name)
        if not os.path.exists(path):
            print(f"  Skipping {pkl_name} (not found)")
            continue

        print(f"  Loading {pkl_name}...")
        with open(path, 'rb') as f:
            dataset = pickle.load(f)

        count = 0
        for subj in dataset:
            for session in dataset[subj]:
                # Stack 6 channels: [N, 6]
                signals = np.column_stack([
                    session["AccX"], session["AccY"], session["AccZ"],
                    session["GyrX"], session["GyrY"], session["GyrZ"],
                ])
                gt = np.array(session["GT"])

                # Sliding window
                for start in range(0, len(signals) - WINDOW_SAMPLES, STEP_SAMPLES):
                    end = start + WINDOW_SAMPLES
                    window = signals[start:end]  # [225, 6]
                    label = 1 if np.mean(gt[start:end]) > LABEL_THRESHOLD else 0

                    # Skip NaN/Inf
                    if np.any(np.isnan(window)) or np.any(np.isinf(window)):
                        continue

                    X_all.append(window)
                    y_all.append(label)
                    count += 1

        print(f"    -> {count} windows from {pkl_name}")

    X = np.array(X_all, dtype=np.float32)
    y = np.array(y_all, dtype=np.int32)
    print(f"  Total: {len(X)} windows, {np.sum(y)} positive ({100*np.mean(y):.1f}%)")
    return X, y


def normalize_signals(X_train, X_test):
    """Per-channel z-score normalization."""
    # Compute mean/std per channel across all samples and timesteps
    mean = np.mean(X_train, axis=(0, 1))  # [6]
    std = np.std(X_train, axis=(0, 1)) + 1e-10  # [6]
    return (X_train - mean) / std, (X_test - mean) / std, mean, std


def build_cnn():
    """Build a compact CNN 1D for TFLite deployment."""
    model = tf.keras.Sequential([
        # Input: [batch, 225, 6]
        tf.keras.layers.Input(shape=(WINDOW_SAMPLES, CHANNELS)),

        # High-pass filter via 1D conv (captures gesture dynamics)
        tf.keras.layers.Conv1D(32, kernel_size=7, strides=2, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dropout(0.2),

        # Deeper features
        tf.keras.layers.Conv1D(64, kernel_size=5, strides=2, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dropout(0.2),

        # Temporal patterns
        tf.keras.layers.Conv1D(64, kernel_size=3, strides=2, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),

        # Aggregate
        tf.keras.layers.GlobalAveragePooling1D(),

        # Classifier
        tf.keras.layers.Dense(32, activation='relu'),
        tf.keras.layers.Dropout(0.3),
        tf.keras.layers.Dense(4, activation='softmax'),  # cigarette, eating, drinking, other
    ])
    return model


def train_and_evaluate():
    """5-fold CV + final model export."""
    print("\n" + "=" * 60)
    print("  CNN 1D Training — Raw IMU Signals")
    print("=" * 60)

    # Load data
    print("\nLoading data...")
    X, y = load_windows()

    # 4-class labels: smoking=0, other=3 (binary for now, mapped to 4-class for output)
    # For training we use binary cross-entropy effectively
    y_cat = np.zeros((len(y), 4), dtype=np.float32)
    for i in range(len(y)):
        if y[i] == 1:
            y_cat[i] = [0.90, 0.03, 0.03, 0.04]  # smoking
        else:
            y_cat[i] = [0.05, 0.15, 0.10, 0.70]  # other

    # Class weight
    n_pos = np.sum(y)
    n_neg = len(y) - n_pos
    class_weight = {0: 1.0, 1: n_neg / n_pos}
    # For categorical, use sample weights
    sample_weights = np.where(y == 1, n_neg / n_pos, 1.0)

    # 5-fold CV
    print(f"\n{N_FOLDS}-fold Cross-Validation:")
    skf = StratifiedKFold(n_splits=N_FOLDS, shuffle=True, random_state=42)
    results = []

    for fold, (train_idx, test_idx) in enumerate(skf.split(X, y)):
        X_train, X_test = X[train_idx], X[test_idx]
        y_train_cat, y_test_cat = y_cat[train_idx], y_cat[test_idx]
        y_test_bin = y[test_idx]
        sw_train = sample_weights[train_idx]

        # Normalize
        X_train_n, X_test_n, _, _ = normalize_signals(X_train, X_test)

        # Build & train
        model = build_cnn()
        model.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
            loss='categorical_crossentropy',
            metrics=['accuracy'],
        )

        model.fit(
            X_train_n, y_train_cat,
            sample_weight=sw_train,
            epochs=EPOCHS,
            batch_size=BATCH_SIZE,
            validation_split=0.1,
            verbose=0,
        )

        # Predict
        preds_proba = model.predict(X_test_n, verbose=0)
        preds_bin = (preds_proba[:, 0] > 0.5).astype(int)  # class 0 = cigarette

        f1 = f1_score(y_test_bin, preds_bin, zero_division=0)
        prec = precision_score(y_test_bin, preds_bin, zero_division=0)
        rec = recall_score(y_test_bin, preds_bin, zero_division=0)
        results.append((f1, prec, rec))
        print(f"  Fold {fold+1}: F1={f1:.3f}  P={prec:.3f}  R={rec:.3f}")

    # Summary
    f1s = [r[0] for r in results]
    precs = [r[1] for r in results]
    recs = [r[2] for r in results]
    print(f"\n  Mean: F1={np.mean(f1s):.3f}±{np.std(f1s):.3f}  P={np.mean(precs):.3f}  R={np.mean(recs):.3f}")

    # Train final model on ALL data
    print("\nTraining final model on all data...")
    mean = np.mean(X, axis=(0, 1))
    std = np.std(X, axis=(0, 1)) + 1e-10
    X_n = (X - mean) / std

    final_model = build_cnn()
    final_model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss='categorical_crossentropy',
    )
    final_model.fit(
        X_n, y_cat,
        sample_weight=sample_weights,
        epochs=EPOCHS,
        batch_size=BATCH_SIZE,
        validation_split=0.05,
        verbose=1,
    )

    # Save normalization
    np.savez(
        os.path.join(os.path.dirname(__file__), "normalization_params_v4.npz"),
        mean=mean, std=std,
        window_samples=WINDOW_SAMPLES,
        channels=CHANNELS,
    )

    # Export TFLite
    print("\nExporting TFLite...")
    converter = tf.lite.TFLiteConverter.from_keras_model(final_model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]

    def representative_dataset():
        indices = np.random.choice(len(X_n), 500, replace=False)
        for i in indices:
            yield [X_n[i:i + 1]]

    converter.representative_dataset = representative_dataset
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
    converter.inference_input_type = tf.int8
    converter.inference_output_type = tf.float32

    tflite_model = converter.convert()

    output_path = os.path.join(os.path.dirname(__file__), "smoking_detector_v4.tflite")
    with open(output_path, 'wb') as f:
        f.write(tflite_model)

    print(f"\nModel v4 (CNN 1D): {len(tflite_model)} bytes")
    print(f"CV F1: {np.mean(f1s):.3f} ± {np.std(f1s):.3f}")
    print(f"Saved: {output_path}")
    print("\nDONE!")


if __name__ == "__main__":
    train_and_evaluate()
