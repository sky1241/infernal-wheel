# CoreML Model

## Conversion Required

The `smoking_detector.mlmodel` file needs to be generated from the TensorFlow Lite model.

### Convert TFLite → CoreML

```bash
# Install coremltools
pip install coremltools

# Convert
python3 convert_tflite_to_coreml.py
```

### Conversion Script

```python
import coremltools as ct
import tensorflow as tf
import numpy as np

# Load TFLite model
tflite_model_path = "../../wear-os-app/app/src/main/assets/smoking_detector.tflite"
interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
interpreter.allocate_tensors()

# Get input/output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print(f"Input shape: {input_details[0]['shape']}")
print(f"Output shape: {output_details[0]['shape']}")

# Convert via ONNX or direct CoreML conversion
# NOTE: TFLite → CoreML conversion may require intermediate ONNX format

# Create CoreML model spec
import coremltools.proto.FeatureTypes_pb2 as ft

# Define input
input_features = [
    ("features", ft.ArrayFeatureType.Double, [30])
]

# Define output
output_features = [
    ("probabilities", ft.ArrayFeatureType.Double, [4])
]

# Build CoreML model
# (Detailed conversion depends on model architecture)

# Save
coreml_model.save("smoking_detector.mlmodel")
```

### Alternative: Manual Export from Training

If you have access to the original training code:

```python
# Train your model
model = create_model()
model.fit(X_train, y_train)

# Export to CoreML
import coremltools as ct
coreml_model = ct.convert(
    model,
    inputs=[ct.TensorType(name="features", shape=(1, 30))],
    outputs=[ct.TensorType(name="probabilities", shape=(1, 4))],
    minimum_deployment_target=ct.target.watchOS9
)

# Save
coreml_model.save("smoking_detector.mlmodel")
```

### Add to Xcode

1. Drag `smoking_detector.mlmodel` into Xcode project
2. Target: SmokingDetector WatchKit Extension
3. Xcode will auto-compile to `smoking_detector.mlmodelc`

### Verify

```swift
let detector = SmokingDetector()
let loaded = detector.loadModel()
print("Model loaded: \(loaded)")
```

---

**Note**: For now, the TFLite model in `wear-os-app/` is the source of truth. CoreML conversion is needed for Apple Watch deployment.
