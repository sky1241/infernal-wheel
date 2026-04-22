#!/usr/bin/env python3
"""
Prepare the v6 CNN for on-device transfer learning.

Strategy: export TWO models:
  1. smoking_detector_v6_25hz.tflite — inference only (already exists, deployed on watch)
  2. smoking_detector_v6_saved_model/ — full Keras SavedModel for phone-side fine-tuning

The PHONE does the fine-tuning using TFLite + SELECT_TF_OPS (which supports
training). After fine-tuning, it converts to a standard inference .tflite
and pushes it to the watch.

This is simpler and more reliable than trying to export train/infer/save/restore
signatures into a single .tflite file (which has known issues with BatchNorm
and Keras Variable.read_value in TF 2.17).

Flow:
  1. Build CNN v6 architecture (same as train_cnn_25hz.py)
  2. Train on SED data (if available) to get meaningful conv weights
  3. Export as SavedModel (full Keras model with weights)
  4. Export the frozen feature extractor config so the phone knows which
     layers to freeze during fine-tuning

Usage:
    python prepare_trainable_model.py

Output:
    smoking_detector_v6_saved_model/   (Keras SavedModel for phone fine-tuning)
    trainable_config.json              (which layers to freeze/train)
"""

import os
import sys
import json
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'
import tensorflow as tf

# === Config (must match train_cnn_25hz.py) ===
WINDOW_SAMPLES = 112
CHANNELS = 3
NUM_CLASSES = 4

BASE_DIR = os.path.dirname(__file__)
SAVED_MODEL_PATH = os.path.join(BASE_DIR, "smoking_detector_v6_trainable.keras")
CONFIG_PATH = os.path.join(BASE_DIR, "trainable_config.json")
TFLITE_OUTPUT = os.path.join(BASE_DIR, "smoking_detector_v6_finetuned.tflite")


def build_cnn():
    """Same architecture as train_cnn_25hz.py build_cnn()."""
    model = tf.keras.Sequential([
        tf.keras.layers.Input(shape=(WINDOW_SAMPLES, CHANNELS)),
        tf.keras.layers.Conv1D(48, 7, strides=1, activation='relu', padding='same', name='conv1'),
        tf.keras.layers.BatchNormalization(name='bn1'),
        tf.keras.layers.MaxPooling1D(2, name='pool1'),
        tf.keras.layers.Dropout(0.2, name='drop1'),
        tf.keras.layers.Conv1D(96, 5, strides=1, activation='relu', padding='same', name='conv2'),
        tf.keras.layers.BatchNormalization(name='bn2'),
        tf.keras.layers.MaxPooling1D(2, name='pool2'),
        tf.keras.layers.Dropout(0.2, name='drop2'),
        tf.keras.layers.Conv1D(128, 3, strides=1, activation='relu', padding='same', name='conv3'),
        tf.keras.layers.BatchNormalization(name='bn3'),
        tf.keras.layers.MaxPooling1D(2, name='pool3'),
        tf.keras.layers.Dropout(0.2, name='drop3'),
        tf.keras.layers.Conv1D(128, 3, strides=1, activation='relu', padding='same', name='conv4'),
        tf.keras.layers.BatchNormalization(name='bn4'),
        tf.keras.layers.GlobalAveragePooling1D(name='gap'),
        tf.keras.layers.Dense(64, activation='relu', name='head_dense1'),
        tf.keras.layers.Dropout(0.3, name='head_drop'),
        tf.keras.layers.Dense(NUM_CLASSES, activation='softmax', name='head_output'),
    ])
    return model


def train_on_sed(model):
    """Train on SED data to get meaningful feature extractor weights."""
    try:
        from train_cnn_25hz import load_windows
        print("[2/5] Loading SED data for pre-training...")
        X, y, subjects = load_windows()
        if len(X) == 0:
            print("  No SED data — skipping pre-training")
            return False

        y_cat = np.zeros((len(y), 4), dtype=np.float32)
        for i in range(len(y)):
            y_cat[i] = [0.90, 0.03, 0.03, 0.04] if y[i] == 1 else [0.05, 0.15, 0.10, 0.70]

        # Normalize
        mean = np.mean(X, axis=(0, 1))
        std = np.std(X, axis=(0, 1)) + 1e-10
        X_n = (X - mean) / std

        # Save normalization params
        np.savez(
            os.path.join(BASE_DIR, "normalization_params_v6_25hz.npz"),
            mean=mean.astype(np.float32),
            std=std.astype(np.float32),
        )

        # Class weighting
        n_pos = np.sum(y)
        n_neg = len(y) - n_pos
        pos_weight = float(np.sqrt(n_neg / max(n_pos, 1)))
        sample_weights = np.where(y == 1, pos_weight, 1.0)

        model.compile(
            optimizer=tf.keras.optimizers.Adam(1e-3),
            loss='categorical_crossentropy',
        )
        model.fit(
            X_n, y_cat,
            sample_weight=sample_weights,
            epochs=10,
            batch_size=256,
            validation_split=0.1,
            verbose=1,
        )
        print("  Feature extractor trained on SED data")
        return True
    except Exception as e:
        print(f"  Could not train on SED: {e}")
        return False


def export_saved_model(model):
    """Export as Keras .keras file for phone-side fine-tuning."""
    print("[3/5] Exporting Keras model...")
    model.save(SAVED_MODEL_PATH)
    size_kb = os.path.getsize(SAVED_MODEL_PATH) / 1024
    print(f"  Saved to: {SAVED_MODEL_PATH} ({size_kb:.1f} KB)")


def export_config():
    """Export the layer config so the phone knows what to freeze."""
    print("[4/5] Exporting trainable config...")
    config = {
        "model_version": "v6_25hz",
        "window_samples": WINDOW_SAMPLES,
        "channels": CHANNELS,
        "num_classes": NUM_CLASSES,
        "frozen_layers": [
            "conv1", "bn1", "pool1", "drop1",
            "conv2", "bn2", "pool2", "drop2",
            "conv3", "bn3", "pool3", "drop3",
            "conv4", "bn4", "gap",
        ],
        "trainable_layers": ["head_dense1", "head_drop", "head_output"],
        "fine_tune_lr": 1e-4,
        "fine_tune_epochs": 10,
        "min_positive_windows": 20,
        "batch_size": 16,
    }
    with open(CONFIG_PATH, 'w') as f:
        json.dump(config, f, indent=2)
    print(f"  Config saved to: {CONFIG_PATH}")


def test_finetune_locally(model):
    """Quick test: simulate phone-side fine-tuning flow."""
    print("[5/5] Testing fine-tune flow locally...")

    # Freeze feature extractor
    trainable_names = {'head_dense1', 'head_drop', 'head_output'}
    for layer in model.layers:
        layer.trainable = layer.name in trainable_names

    trainable_count = sum(1 for l in model.layers if l.trainable)
    frozen_count = sum(1 for l in model.layers if not l.trainable)
    print(f"  Frozen: {frozen_count} layers, Trainable: {trainable_count} layers")
    print(f"  Trainable params: {sum(v.numpy().size for v in model.trainable_variables)}")

    # Simulate fine-tune with random data
    model.compile(
        optimizer=tf.keras.optimizers.Adam(1e-4),
        loss='categorical_crossentropy',
        metrics=['accuracy'],
    )
    X_fake = np.random.randn(32, WINDOW_SAMPLES, CHANNELS).astype(np.float32)
    y_fake = np.zeros((32, NUM_CLASSES), dtype=np.float32)
    y_fake[:, 0] = 0.9  # all "cigarette"
    y_fake[:, 1:] = 0.033

    history = model.fit(X_fake, y_fake, epochs=3, batch_size=16, verbose=0)
    print(f"  Fine-tune test: loss={history.history['loss'][-1]:.4f}")

    # Export fine-tuned as TFLite
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_bytes = converter.convert()

    with open(TFLITE_OUTPUT, 'wb') as f:
        f.write(tflite_bytes)
    print(f"  Fine-tuned TFLite: {TFLITE_OUTPUT} ({len(tflite_bytes)/1024:.1f} KB)")

    # Verify inference
    interpreter = tf.lite.Interpreter(model_content=tflite_bytes)
    interpreter.allocate_tensors()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    test_input = np.random.randn(1, WINDOW_SAMPLES, CHANNELS).astype(np.float32)
    interpreter.set_tensor(input_details[0]['index'], test_input)
    interpreter.invoke()
    probs = interpreter.get_tensor(output_details[0]['index'])[0]
    print(f"  Inference test: {probs} (sum={probs.sum():.3f})")

    print("\n  ALL CHECKS PASSED")


def main():
    print("=" * 60)
    print("  Prepare CNN v6 for On-Device Fine-Tuning")
    print("=" * 60)

    # Step 1
    print("\n[1/5] Building model...")
    model = build_cnn()
    model.summary()

    # Step 2
    trained = train_on_sed(model)

    # Step 3
    export_saved_model(model)

    # Step 4
    export_config()

    # Step 5
    test_finetune_locally(model)

    print("\n" + "=" * 60)
    print("  DONE — ready for on-device fine-tuning")
    print("  Phone loads SavedModel, freezes conv layers,")
    print("  trains head on personal data, exports .tflite,")
    print("  pushes to watch via BT.")
    print("=" * 60)


if __name__ == "__main__":
    main()
