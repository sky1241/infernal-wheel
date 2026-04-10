"""
Train CNN 1D on raw ACCELEROMETER signals at 25Hz (3 channels).

This is the v6 model designed for Samsung Health Sensor SDK ACCELEROMETER_CONTINUOUS,
which provides 25Hz batched accel data without gyroscope (gyro continu doesn't exist
in low-power batched mode on Galaxy Watch).

Key differences from train_cnn.py (v5):
  - Sample rate: 50Hz -> 25Hz (downsampled by 2x)
  - Window samples: 225 -> 112 (4.5s @ 25Hz)
  - Channels: 6 (Acc+Gyro) -> 3 (Acc only)
  - Input shape: [1, 225, 6] -> [1, 112, 3]

Usage:
    python train_cnn_25hz.py

Output:
    smoking_detector_v6_25hz.tflite     (TFLite model, float32 input)
    normalization_params_v6_25hz.npz    (per-channel mean/std)
"""

import pickle
import numpy as np
import os
import sys
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

import tensorflow as tf
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import f1_score, precision_score, recall_score

# === Config ===
WINDOW_SEC = 4.5
SOURCE_RATE = 50           # SED dataset is at 50Hz
TARGET_RATE = 25           # Samsung Health SDK delivers 25Hz
DOWNSAMPLE_FACTOR = SOURCE_RATE // TARGET_RATE  # 2
WINDOW_SAMPLES = int(WINDOW_SEC * TARGET_RATE)  # 112
STEP_SAMPLES = WINDOW_SAMPLES // 2              # 56 (50% overlap)
CHANNELS = 3                # Acc only (X, Y, Z) — no gyro
LABEL_THRESHOLD = 0.3       # >30% puff in window = positive
EPOCHS = 15           # 15 epochs is enough on this dataset
BATCH_SIZE = 256      # Larger batch = faster epochs on CPU
N_FOLDS = 3           # 3-fold CV is enough for sanity check

DATA_DIR = os.path.join(os.path.dirname(__file__), "datasets", "sed")
OUTPUT_TFLITE = os.path.join(os.path.dirname(__file__), "smoking_detector_v6_25hz.tflite")
OUTPUT_NORM = os.path.join(os.path.dirname(__file__), "normalization_params_v6_25hz.npz")


def downsample(signal, factor):
    """Decimate signal by integer factor.

    Uses simple subsampling (every nth sample) to MATCH what the Samsung Health
    Sensor SDK actually delivers. Samsung's 25Hz mode does NOT pre-average
    samples — it just reports every 2nd reading from the underlying 50Hz sensor.

    Averaging here would smooth high-frequency components and create training
    data that doesn't match what the watch will see at runtime, hurting F1.
    """
    return signal[::factor]


def load_windows():
    """Load 3-channel ACC windows from SED + SED-FL, downsampled to 25Hz."""
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
                # Downsample each accel channel from 50Hz to 25Hz
                acc_x = downsample(np.asarray(session["AccX"], dtype=np.float32), DOWNSAMPLE_FACTOR)
                acc_y = downsample(np.asarray(session["AccY"], dtype=np.float32), DOWNSAMPLE_FACTOR)
                acc_z = downsample(np.asarray(session["AccZ"], dtype=np.float32), DOWNSAMPLE_FACTOR)
                # GT downsampled by simple subsampling to stay aligned with signal
                gt = np.asarray(session["GT"], dtype=np.int32)
                gt_ds = gt[::DOWNSAMPLE_FACTOR]
                # Trim to matching length
                n_min = min(len(acc_x), len(gt_ds))
                acc_x = acc_x[:n_min]
                acc_y = acc_y[:n_min]
                acc_z = acc_z[:n_min]
                gt_ds = gt_ds[:n_min]

                # Stack 3 channels: [N, 3]
                signals = np.column_stack([acc_x, acc_y, acc_z])

                # Sliding window
                for start in range(0, len(signals) - WINDOW_SAMPLES, STEP_SAMPLES):
                    end = start + WINDOW_SAMPLES
                    window = signals[start:end]  # [112, 3]
                    label = 1 if np.mean(gt_ds[start:end]) > LABEL_THRESHOLD else 0

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
    print(f"  Input shape: {X.shape}  (expected [N, {WINDOW_SAMPLES}, {CHANNELS}])")
    return X, y


def normalize_signals(X_train, X_test):
    """Per-channel z-score normalization."""
    mean = np.mean(X_train, axis=(0, 1))            # [3]
    std = np.std(X_train, axis=(0, 1)) + 1e-10      # [3]
    return (X_train - mean) / std, (X_test - mean) / std, mean, std


def build_cnn():
    """
    Build a CNN 1D for TFLite deployment, adapted for 25Hz / 3 channels.

    Architecture is BEEFIER than the first attempt because we lost the gyro
    channels (going from 6 to 3 channels) and we have less temporal resolution
    (50Hz -> 25Hz). To compensate we widen the conv layers and add a 4th block.
    """
    model = tf.keras.Sequential([
        # Input: [batch, 112, 3]
        tf.keras.layers.Input(shape=(WINDOW_SAMPLES, CHANNELS)),

        # Conv block 1 — wide kernel to capture slow gesture dynamics
        tf.keras.layers.Conv1D(48, kernel_size=7, strides=1, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.Dropout(0.2),

        # Conv block 2
        tf.keras.layers.Conv1D(96, kernel_size=5, strides=1, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.Dropout(0.2),

        # Conv block 3
        tf.keras.layers.Conv1D(128, kernel_size=3, strides=1, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.Dropout(0.2),

        # Conv block 4
        tf.keras.layers.Conv1D(128, kernel_size=3, strides=1, activation='relu', padding='same'),
        tf.keras.layers.BatchNormalization(),

        # Aggregate
        tf.keras.layers.GlobalAveragePooling1D(),

        # Classifier head
        tf.keras.layers.Dense(64, activation='relu'),
        tf.keras.layers.Dropout(0.3),
        tf.keras.layers.Dense(4, activation='softmax'),  # cigarette, eating, drinking, other
    ])
    return model


def train_and_evaluate():
    print("\n" + "=" * 60)
    print("  CNN 1D Training v6 — 25Hz / 3 channels (Acc only)")
    print("=" * 60)
    print(f"  Window: {WINDOW_SEC}s = {WINDOW_SAMPLES} samples @ {TARGET_RATE}Hz")
    print(f"  Channels: {CHANNELS} (AccX, AccY, AccZ)")
    print(f"  Step: {STEP_SAMPLES} samples (50% overlap)")

    # Load data
    print("\n[1/4] Loading and downsampling data...")
    X, y = load_windows()
    if len(X) == 0:
        print("ERROR: no data loaded. Check that SED.pkl is in datasets/sed/")
        sys.exit(1)

    # 4-class soft labels (binary effective)
    y_cat = np.zeros((len(y), 4), dtype=np.float32)
    for i in range(len(y)):
        if y[i] == 1:
            y_cat[i] = [0.90, 0.03, 0.03, 0.04]  # smoking
        else:
            y_cat[i] = [0.05, 0.15, 0.10, 0.70]  # other

    # Class weighting — sqrt of full inverse ratio to avoid precision collapse.
    # Full inverse (n_neg/n_pos ~ 12x) makes the model over-predict positives,
    # crashing precision. sqrt gives ~3.5x which keeps recall up without
    # destroying precision.
    n_pos = np.sum(y)
    n_neg = len(y) - n_pos
    pos_weight = float(np.sqrt(n_neg / max(n_pos, 1)))
    print(f"  Pos weight (sqrt): {pos_weight:.2f}")
    sample_weights = np.where(y == 1, pos_weight, 1.0)

    # 5-fold CV
    print(f"\n[2/4] {N_FOLDS}-fold Cross-Validation:")
    skf = StratifiedKFold(n_splits=N_FOLDS, shuffle=True, random_state=42)
    results = []

    for fold, (train_idx, test_idx) in enumerate(skf.split(X, y)):
        X_train, X_test = X[train_idx], X[test_idx]
        y_train_cat = y_cat[train_idx]
        y_test_bin = y[test_idx]
        sw_train = sample_weights[train_idx]

        X_train_n, X_test_n, _, _ = normalize_signals(X_train, X_test)

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

        preds_proba = model.predict(X_test_n, verbose=0)
        preds_bin = (preds_proba[:, 0] > 0.5).astype(int)

        f1 = f1_score(y_test_bin, preds_bin, zero_division=0)
        prec = precision_score(y_test_bin, preds_bin, zero_division=0)
        rec = recall_score(y_test_bin, preds_bin, zero_division=0)
        results.append((f1, prec, rec))
        print(f"  Fold {fold+1}: F1={f1:.3f}  P={prec:.3f}  R={rec:.3f}")

    f1s = [r[0] for r in results]
    precs = [r[1] for r in results]
    recs = [r[2] for r in results]
    mean_f1 = float(np.mean(f1s))
    print(f"\n  Mean: F1={mean_f1:.3f}+-{np.std(f1s):.3f}  P={np.mean(precs):.3f}  R={np.mean(recs):.3f}")

    # Final model on all data
    print("\n[3/4] Training final model on all data...")
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
        OUTPUT_NORM,
        mean=mean.astype(np.float32),
        std=std.astype(np.float32),
        window_samples=WINDOW_SAMPLES,
        channels=CHANNELS,
        sample_rate=TARGET_RATE,
        cv_f1=mean_f1,
    )
    print(f"  Saved normalization params: {OUTPUT_NORM}")
    print(f"  mean = {mean}")
    print(f"  std  = {std}")

    # Export TFLite (FLOAT32 input — easier to debug, no quantization crash)
    print("\n[4/4] Exporting TFLite (float32)...")
    converter = tf.lite.TFLiteConverter.from_keras_model(final_model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    # NO int8 quantization — float32 input/output (avoids the v5 crash bug)

    tflite_model = converter.convert()

    with open(OUTPUT_TFLITE, 'wb') as f:
        f.write(tflite_model)

    print(f"\n=== DONE ===")
    print(f"Model v6 (25Hz / 3 channels): {len(tflite_model)} bytes")
    print(f"CV F1: {mean_f1:.3f} +- {np.std(f1s):.3f}")
    print(f"Saved: {OUTPUT_TFLITE}")
    print(f"Norm:  {OUTPUT_NORM}")

    if mean_f1 < 0.60:
        print(f"\n!!! WARNING: F1 ({mean_f1:.3f}) is below 0.60 — fall back to 50Hz model !!!")
        sys.exit(2)
    elif mean_f1 < 0.70:
        print(f"\n!!! NOTE: F1 ({mean_f1:.3f}) is below 0.70 — acceptable but not great !!!")


if __name__ == "__main__":
    train_and_evaluate()
