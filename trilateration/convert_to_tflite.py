#!/usr/bin/env python3
"""
Convert Random Forest Model to TensorFlow Lite

Takes the trained Random Forest model (.pkl) and converts it to TFLite format
for deployment on Wear OS (Android smartwatch).

Pipeline:
1. Load Random Forest (.pkl)
2. Convert to TensorFlow model
3. Quantize (int8 for smaller size + faster inference)
4. Export to TFLite (.tflite)

Output:
- smoking_detector.tflite (quantized, ~128 KB)
- smoking_detector_float32.tflite (full precision, ~1 MB)

References:
- [docs/DEPLOYMENT_HARDWARE.md]
"""

import os
import numpy as np
import pickle
import tensorflow as tf
from sklearn.ensemble import RandomForestClassifier
import warnings
warnings.filterwarnings('ignore')


# ============================================================================
# LOAD TRAINED MODEL
# ============================================================================

def load_model(model_path: str = 'models/random_forest_baseline.pkl') -> RandomForestClassifier:
    """Load trained Random Forest model from disk.

    BUG+015 fix: explicit existence check before opening — pickle.load on a
    missing file raised an opaque FileNotFoundError mid-pipeline.
    BUG+013 note: pickle is RCE-equivalent — anything in the .pkl runs at
    load time. We trust models/random_forest_baseline.pkl because it's
    produced by our own train_baseline.py and lives inside the repo. Do NOT
    point this loader at untrusted .pkl files.
    """
    print(f"[INFO] Loading trained model from {model_path}...")

    if not os.path.isfile(model_path):
        raise FileNotFoundError(
            f"Model file not found: {model_path}\n"
            f"Run `python train_baseline.py` first to generate the .pkl."
        )

    with open(model_path, 'rb') as f:
        model = pickle.load(f)  # noqa: S301 — trusted internal artifact, see docstring

    if not isinstance(model, RandomForestClassifier):
        raise TypeError(
            f"Expected RandomForestClassifier, got {type(model).__name__}. "
            f"The .pkl may be corrupted or from an incompatible script."
        )

    print(f"[OK] Model loaded")
    print(f"     Type: {type(model).__name__}")
    print(f"     Trees: {model.n_estimators}")
    print(f"     Features: {model.n_features_in_}")

    return model


# ============================================================================
# CONVERT SKLEARN → TENSORFLOW
# ============================================================================

def sklearn_rf_to_tensorflow(rf_model: RandomForestClassifier, input_shape: tuple = (30,)):
    """
    Convert sklearn Random Forest to TensorFlow model.

    Strategy: Create a TensorFlow model that mimics the Random Forest behavior.
    Each tree becomes a set of operations.

    Note: This is simplified - in production, use tf-decision-forests or similar.
    For this prototype, we'll create a neural network approximation.
    """
    print()
    print("[INFO] Converting sklearn Random Forest to TensorFlow...")
    print("       Strategy: Create neural network approximation of RF")
    print()

    # Create a simple neural network that approximates the Random Forest
    # (In production, use tf-decision-forests for exact conversion)

    model = tf.keras.Sequential([
        tf.keras.layers.Input(shape=input_shape),
        tf.keras.layers.Dense(128, activation='relu', name='dense1'),
        tf.keras.layers.Dropout(0.3),
        tf.keras.layers.Dense(64, activation='relu', name='dense2'),
        tf.keras.layers.Dropout(0.3),
        tf.keras.layers.Dense(32, activation='relu', name='dense3'),
        tf.keras.layers.Dense(4, activation='softmax', name='output')  # 4 classes
    ])

    print("[INFO] TensorFlow model created")
    print(f"       Input shape: {input_shape}")
    print(f"       Output classes: 4 (cigarette, eating, drinking, other)")

    return model


# ============================================================================
# TRAIN TENSORFLOW MODEL (KNOWLEDGE DISTILLATION)
# ============================================================================

def distill_knowledge(rf_model, tf_model, X_real: np.ndarray):
    """
    Train TensorFlow model to mimic Random Forest predictions on REAL data.

    BUG+014 fix: the previous implementation used `np.random.randn(1000, 30)`
    as the distillation set. Sklearn RF.predict_proba on pure Gaussian noise
    returns near-uniform distributions for almost every sample, so the
    student NN learned to predict ~uniform softmax everywhere. This is the
    root cause of the v3/v4 broken TFLite models. Distillation REQUIRES the
    student to see realistic inputs from the same distribution the teacher
    was trained on — otherwise it learns the prior, not the function.

    Args:
        rf_model: Trained sklearn Random Forest (teacher)
        tf_model: TensorFlow model to train (student)
        X_real:   Real feature matrix [N, 30] — same features used to train
                  the teacher. Pass np.load('features_train.npy') or rerun
                  feature_extraction on your raw dataset.

    Raises:
        ValueError: if X_real is None, empty, or has wrong feature dim.
    """
    print()
    print("[INFO] Knowledge distillation: Training TF model to mimic RF...")

    if X_real is None or len(X_real) == 0:
        raise ValueError(
            "X_real is required for distillation. Random/synthetic data "
            "produces broken models — see BUG+014. Pass the same feature "
            "matrix used to train the RF teacher."
        )
    expected_features = rf_model.n_features_in_
    if X_real.shape[1] != expected_features:
        raise ValueError(
            f"X_real has {X_real.shape[1]} features but teacher expects "
            f"{expected_features}. Mismatched feature pipelines."
        )

    X_real = X_real.astype(np.float32)
    print(f"       Distilling on {len(X_real)} REAL samples ({expected_features} features)")

    # Get predictions from Random Forest (teacher)
    y_rf_proba = rf_model.predict_proba(X_real)

    # Compile TensorFlow model
    tf_model.compile(
        optimizer='adam',
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )

    print("[INFO] Training TensorFlow model...")

    # Train TF model to match RF predictions
    history = tf_model.fit(
        X_real,
        y_rf_proba,
        epochs=50,
        batch_size=32,
        verbose=0,
        validation_split=0.2
    )

    final_accuracy = history.history['accuracy'][-1]
    print(f"[OK] Training completed")
    print(f"     Final accuracy: {final_accuracy:.3f}")

    return tf_model


# ============================================================================
# CONVERT TO TFLITE
# ============================================================================

def convert_to_tflite(tf_model, output_path: str = 'models/smoking_detector.tflite', quantize: bool = True):
    """
    Convert TensorFlow model to TFLite format.

    Args:
        tf_model: TensorFlow/Keras model
        output_path: Output path for .tflite file
        quantize: If True, apply int8 quantization (smaller size, faster)
    """
    print()
    print("[INFO] Converting to TensorFlow Lite...")

    # Create TFLite converter
    converter = tf.lite.TFLiteConverter.from_keras_model(tf_model)

    if quantize:
        print("       Applying int8 quantization...")

        # Post-training quantization
        converter.optimizations = [tf.lite.Optimize.DEFAULT]

        # Representative dataset for quantization
        def representative_dataset():
            for _ in range(100):
                data = np.random.randn(1, 30).astype(np.float32)
                yield [data]

        converter.representative_dataset = representative_dataset
        converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
        converter.inference_input_type = tf.float32
        converter.inference_output_type = tf.float32

    # Convert
    tflite_model = converter.convert()

    # Save
    with open(output_path, 'wb') as f:
        f.write(tflite_model)

    size_kb = len(tflite_model) / 1024
    print(f"[OK] TFLite model saved to {output_path}")
    print(f"     Size: {size_kb:.1f} KB")

    if quantize:
        print(f"     Quantization: int8 (4-8× smaller than float32)")

    return output_path


# ============================================================================
# TEST TFLITE MODEL
# ============================================================================

def test_tflite_model(tflite_path: str):
    """Test TFLite model inference."""
    print()
    print("[INFO] Testing TFLite model...")

    # Load TFLite model
    interpreter = tf.lite.Interpreter(model_path=tflite_path)
    interpreter.allocate_tensors()

    # Get input/output details
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    print(f"[OK] Model loaded in TFLite interpreter")
    print(f"     Input shape: {input_details[0]['shape']}")
    print(f"     Output shape: {output_details[0]['shape']}")

    # Test inference
    test_input = np.random.randn(1, 30).astype(np.float32)
    interpreter.set_tensor(input_details[0]['index'], test_input)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]['index'])

    print(f"[OK] Inference test successful")
    print(f"     Output probabilities: {output[0]}")
    print(f"     Predicted class: {np.argmax(output[0])}")

    # Measure inference time
    import time
    n_runs = 100
    start = time.time()
    for _ in range(n_runs):
        interpreter.invoke()
    end = time.time()

    avg_time_ms = (end - start) / n_runs * 1000
    print(f"[PERF] Average inference time: {avg_time_ms:.2f} ms ({n_runs} runs)")

    if avg_time_ms < 50:
        print(f"[OK] Inference time meets real-time requirement (<50ms)")
    else:
        print(f"[WARNING] Inference time exceeds target (>50ms)")


# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=" * 80)
    print("CONVERT RANDOM FOREST TO TENSORFLOW LITE")
    print("=" * 80)
    print()

    # Step 1: Load trained Random Forest
    rf_model = load_model('models/random_forest_baseline.pkl')

    # Step 2: Create TensorFlow approximation
    tf_model = sklearn_rf_to_tensorflow(rf_model, input_shape=(30,))

    # Step 3: Knowledge distillation — must use REAL features (BUG+014)
    features_path = 'models/X_train_features.npy'
    if not os.path.isfile(features_path):
        raise FileNotFoundError(
            f"Missing distillation features: {features_path}\n"
            f"Knowledge distillation requires the SAME real feature matrix\n"
            f"used to train the Random Forest teacher (see BUG+014).\n"
            f"Update train_baseline.py to save X_train via\n"
            f"  np.save('models/X_train_features.npy', X_train.values)\n"
            f"then re-run."
        )
    X_real = np.load(features_path)
    tf_model = distill_knowledge(rf_model, tf_model, X_real=X_real)

    # Step 4: Convert to TFLite (quantized)
    tflite_path = convert_to_tflite(tf_model, output_path='models/smoking_detector.tflite', quantize=True)

    # Step 5: Convert to TFLite (float32, no quantization)
    tflite_path_float = convert_to_tflite(tf_model, output_path='models/smoking_detector_float32.tflite', quantize=False)

    # Step 6: Test TFLite model
    test_tflite_model(tflite_path)

    print()
    print("=" * 80)
    print("[SUCCESS] MODEL CONVERSION COMPLETED!")
    print("=" * 80)
    print()

    print("[OUTPUT] Generated files:")
    print(f"   - {tflite_path} (quantized int8, optimized)")
    print(f"   - {tflite_path_float} (float32, full precision)")
    print()

    print("[NEXT STEPS]")
    print("   1. Copy smoking_detector.tflite to Wear OS project")
    print("   2. Integrate TFLite interpreter in Kotlin app")
    print("   3. Deploy to watch and test!")
    print()

    print("[INFO] For Wear OS integration:")
    print("   - Add TFLite dependency to build.gradle")
    print("   - Load model in Kotlin: Interpreter(File(\"smoking_detector.tflite\"))")
    print("   - Run inference: interpreter.run(inputArray, outputArray)")


if __name__ == "__main__":
    main()
