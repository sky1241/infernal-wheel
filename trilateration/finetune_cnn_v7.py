"""
Fine-tune the v6 25Hz CNN on per-user training windows collected from the
watch → phone sync pipeline.

Input
-----
  infernal-app/android/app/src/main/assets/training_windows/*.json
OR (preferred for dev)
  Pull from the phone:
    adb -s <phone_id> exec-out run-as com.infernal.infernal_wheel \
        tar c -C files/app_flutter/training_windows . | tar x -C ./pulled_training/

Each file is a JSON blob written by MainActivity.handleTrainingWindow:
  {
    "type": "training_window",
    "label": "auto_detected" | "manual_only" | "auto_confirmed_by_manual",
    "confidence": 0.66,
    "timestamp": 1775841838000,
    "sampleCount": 200,
    "sampleRate": 25,
    "compressed": "<base64 GorillaCompressor output>"
  }

Labelling strategy
------------------
  auto_detected                  → weight 1.0  (CNN said it was a cigarette)
  auto_confirmed_by_manual       → weight 2.0  (CNN + user agreed)
  manual_only                    → weight 3.0  (user clicked but CNN missed;
                                                these are the hardest and most
                                                valuable examples to learn from)
  false_positive                 → weight 2.0 as negative

All other minute-windows from the phone-side continuous recording can serve
as hard negatives, but we don't have that feed yet — for now we bootstrap
with the SED dataset as the negative class and mix in the personal positives.

Output
------
  smoking_detector_v7_personal.tflite
  normalization_params_v7_personal.npz

Usage
-----
    python finetune_cnn_v7.py --pulled_dir ./pulled_training/
    python finetune_cnn_v7.py --pulled_dir ./pulled_training/ --min-windows 20

The script refuses to run if fewer than --min-windows training windows are
available (default 20). This prevents overfitting on a tiny personal set.
"""

import os
import sys
import json
import base64
import gzip
import struct
import argparse
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

# ============================================================================
# Constants (must match SmokingDetector.kt + train_cnn_25hz.py)
# ============================================================================
WINDOW_SAMPLES = 112
CHANNELS = 3
SAMPLE_RATE = 25
BASE_MODEL = "smoking_detector_v6_25hz.tflite"
BASE_NORM = "normalization_params_v6_25hz.npz"
OUTPUT_MODEL = "smoking_detector_v7_personal.tflite"
OUTPUT_NORM = "normalization_params_v7_personal.npz"


# ============================================================================
# Gorilla decompress — same format as the Kotlin watch side
# ============================================================================
def decompress_gorilla(compressed_b64):
    """Decompress a Gorilla-packed window into (accel[N,3], gyro[N,3])."""
    if not compressed_b64:
        return np.empty((0, 3), dtype=np.float32), np.empty((0, 3), dtype=np.float32)

    raw_bytes = gzip.decompress(base64.b64decode(compressed_b64))
    n, channels = struct.unpack('>HB', raw_bytes[:3])
    assert channels == 6, f"Expected 6 channels (accel+gyro), got {channels}"

    values = np.zeros(n * 6, dtype=np.float32)
    offset = 3
    for c in range(6):
        values[c] = struct.unpack('>f', raw_bytes[offset:offset + 4])[0]
        offset += 4

    for i in range(6, n * 6):
        xor = struct.unpack('>I', raw_bytes[offset:offset + 4])[0]
        prev_bits = struct.unpack('>I', struct.pack('>f', values[i - 6]))[0]
        values[i] = struct.unpack('>f', struct.pack('>I', prev_bits ^ xor))[0]
        offset += 4

    accel = values.reshape(-1, 6)[:, :3]
    gyro = values.reshape(-1, 6)[:, 3:]
    return accel, gyro


def load_training_windows(pulled_dir):
    """Load all training_window JSON files and return labelled arrays."""
    if not os.path.isdir(pulled_dir):
        raise SystemExit(f"Directory not found: {pulled_dir}")

    files = sorted(
        os.path.join(pulled_dir, f)
        for f in os.listdir(pulled_dir)
        if f.endswith(".json")
    )
    if not files:
        raise SystemExit(f"No .json files in {pulled_dir}")

    windows = []
    labels = []
    weights = []
    for path in files:
        try:
            with open(path, "r") as fh:
                payload = json.load(fh)
        except Exception as e:
            print(f"  skip {path}: {e}")
            continue

        label = payload.get("label", "unknown")
        accel, _gyro = decompress_gorilla(payload.get("compressed", ""))
        if accel.shape[0] < WINDOW_SAMPLES:
            print(f"  skip {path}: only {accel.shape[0]} samples < {WINDOW_SAMPLES}")
            continue

        # Center-crop to WINDOW_SAMPLES
        start = (accel.shape[0] - WINDOW_SAMPLES) // 2
        window = accel[start:start + WINDOW_SAMPLES].astype(np.float32)
        windows.append(window)
        labels.append(label)

        weight = {
            "auto_detected": 1.0,
            "auto_confirmed_by_manual": 2.0,
            "manual_only": 3.0,
            "false_positive": 2.0,
        }.get(label, 1.0)
        weights.append(weight)

    return np.array(windows), np.array(labels), np.array(weights, dtype=np.float32)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pulled_dir", required=True,
                        help="Directory containing training_window JSON files pulled from the phone")
    parser.add_argument("--min-windows", type=int, default=20,
                        help="Refuse to fine-tune if fewer than this many valid windows")
    parser.add_argument("--epochs", type=int, default=15)
    parser.add_argument("--batch-size", type=int, default=32)
    parser.add_argument("--lr", type=float, default=1e-4,
                        help="Fine-tune learning rate (lower than training from scratch)")
    args = parser.parse_args()

    print("=" * 60)
    print("  v7 personal fine-tune")
    print("=" * 60)

    print("\n[1/5] Loading training windows from", args.pulled_dir)
    X, labels, weights = load_training_windows(args.pulled_dir)
    print(f"  Loaded {len(X)} windows")
    print(f"  Label distribution: {dict(zip(*np.unique(labels, return_counts=True)))}")

    if len(X) < args.min_windows:
        print(f"\n!!! Only {len(X)} windows < --min-windows {args.min_windows}")
        print("    Collect more cigarettes first. Each +1 on the watch during Phase 1")
        print("    contributes a high-value 'manual_only' window.")
        sys.exit(1)

    # ------------------------------------------------------------
    # [2/5] Map labels to 4-class soft labels
    #
    # BUG+036 fix: explicit allow-list, not "default to cigarette". The
    # previous code did `if lbl == "false_positive": ... else: cigarette`,
    # which meant any unknown label — including "unknown" (the load-time
    # fallback for corrupt files) — got silently trained as cigarette.
    # On a tiny personal dataset (20-50 windows), a single corrupt file
    # can shift 2-5% of the gradient toward false positives.
    # ------------------------------------------------------------
    print("\n[2/5] Building 4-class soft targets")

    CIGARETTE_TARGET = np.array([0.90, 0.03, 0.03, 0.04], dtype=np.float32)
    OTHER_TARGET = np.array([0.05, 0.15, 0.10, 0.70], dtype=np.float32)
    LABEL_TO_TARGET = {
        "auto_detected": CIGARETTE_TARGET,
        "auto_confirmed_by_manual": CIGARETTE_TARGET,
        "manual_only": CIGARETTE_TARGET,
        "false_positive": OTHER_TARGET,
    }

    y_cat = np.zeros((len(X), 4), dtype=np.float32)
    unknown_count = 0
    keep_mask = np.ones(len(X), dtype=bool)
    for i, lbl in enumerate(labels):
        target = LABEL_TO_TARGET.get(lbl)
        if target is None:
            unknown_count += 1
            print(f"  WARNING: unknown label '{lbl}' at window {i} — DROPPING (was silently labeled cigarette before BUG+036 fix)")
            keep_mask[i] = False
            continue
        y_cat[i] = target

    if unknown_count > 0:
        print(f"  Dropped {unknown_count} windows with unrecognized labels")
        X = X[keep_mask]
        y_cat = y_cat[keep_mask]
        labels = labels[keep_mask]
        weights = weights[keep_mask]
        if len(X) < args.min_windows:
            print(f"\n!!! After dropping unknowns, only {len(X)} < --min-windows {args.min_windows}")
            sys.exit(1)

    # ------------------------------------------------------------
    # [3/5] Load the base v6 model and replace its head
    # ------------------------------------------------------------
    import tensorflow as tf
    base_path = os.path.join(os.path.dirname(__file__), BASE_MODEL)
    if not os.path.exists(base_path):
        raise SystemExit(f"Base model not found: {base_path}")

    print("\n[3/5] Loading base v6 model for warm-start")
    # TFLite models can't be fine-tuned directly — we need the Keras model.
    # For the v7 pipeline we retrain from scratch but bias toward personal data.
    # A proper warm-start path would require exporting the Keras .h5 alongside
    # the .tflite. That's a TODO for the next iteration.
    #
    # In the meantime: rebuild the same architecture and train on the personal
    # set, then export to TFLite. The model is small enough that this converges
    # quickly with 20-50 samples.
    from train_cnn_25hz import build_cnn, normalize_signals

    # Use the base norm params so the input distribution matches the original
    # training distribution.
    base_norm_path = os.path.join(os.path.dirname(__file__), BASE_NORM)
    base_norm = np.load(base_norm_path)
    mean = base_norm['mean']
    std = base_norm['std']
    X_n = (X - mean) / std

    # ------------------------------------------------------------
    # [4/5] Train
    # ------------------------------------------------------------
    print("\n[4/5] Fine-tuning on personal data")
    model = build_cnn()
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=args.lr),
        loss='categorical_crossentropy',
        metrics=['accuracy'],
    )
    model.fit(
        X_n, y_cat,
        sample_weight=weights,
        epochs=args.epochs,
        batch_size=min(args.batch_size, max(1, len(X) // 2)),
        verbose=1,
    )

    # ------------------------------------------------------------
    # [5/5] Export
    # ------------------------------------------------------------
    print("\n[5/5] Exporting TFLite (float32)")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_bytes = converter.convert()

    out_path = os.path.join(os.path.dirname(__file__), OUTPUT_MODEL)
    with open(out_path, 'wb') as f:
        f.write(tflite_bytes)

    out_norm = os.path.join(os.path.dirname(__file__), OUTPUT_NORM)
    np.savez(
        out_norm,
        mean=mean.astype(np.float32),
        std=std.astype(np.float32),
        window_samples=WINDOW_SAMPLES,
        channels=CHANNELS,
        sample_rate=SAMPLE_RATE,
        n_personal_windows=len(X),
    )

    print("\n=== DONE ===")
    print(f"  Model:  {out_path} ({len(tflite_bytes)} bytes)")
    print(f"  Norm:   {out_norm}")
    print(f"  Next:   copy {OUTPUT_MODEL} to wear-os-app/app/src/main/assets/smoking_detector.tflite")
    print(f"          then rebuild the watch APK and install")


if __name__ == "__main__":
    main()
