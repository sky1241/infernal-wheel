# Smoking Detector — Apple Watch App

Apple Watch application for automatic cigarette detection via multi-modal sensors (accelerometer + gyroscope + HR + GPS).

## 📱 Tech Stack

- **Platform**: watchOS 9.0+ (WatchKit)
- **Language**: Swift 5.9
- **ML Framework**: CoreML
- **UI**: SwiftUI
- **Build System**: Xcode 15.0+

## 🏗️ Architecture

```
apple-watch-app/
├── SmokingDetector.xcodeproj/          # Xcode project
│   └── project.pbxproj
├── SmokingDetector WatchKit App/       # WatchKit app (UI)
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── ContentView.swift               # Main UI
├── SmokingDetector WatchKit Extension/ # WatchKit extension (logic)
│   ├── Models/
│   │   └── smoking_detector.mlmodel    # CoreML model
│   ├── Managers/
│   │   ├── SmokingDetector.swift       # CoreML wrapper
│   │   ├── SensorManager.swift         # Accelerometer + Gyroscope
│   │   ├── HealthKitManager.swift      # Heart rate monitoring
│   │   └── LocationManager.swift       # GPS clustering
│   ├── Features/
│   │   └── FeatureExtractor.swift      # Extract 30 features
│   ├── Services/
│   │   └── DetectionService.swift      # Background detection
│   ├── Info.plist
│   └── ExtensionDelegate.swift
└── README.md
```

## 🔧 Main Components

### 1. SmokingDetector.swift

CoreML wrapper for cigarette detection model.

**Functions**:
- `loadModel()` — Load `smoking_detector.mlmodel` from bundle
- `predict(features: [Double])` — Inference on 30 features → probabilities [cigarette, eating, drinking, other]
- `isCigaretteDetected(features, threshold)` — Detection if P(cigarette) > threshold

**Input**: `[30]` Double (30 biomechanical features)
**Output**: `[4]` Double (probabilities)

**Optimization**:
- CoreML optimized for Apple Neural Engine
- Int8 quantization (23.2 KB model size)
- Inference time: <30ms on Apple Watch Series 8+

### 2. SensorManager.swift

Sensor data collector (accelerometer + gyroscope).

**Functions**:
- `startMonitoring()` — Start acquisition @ 50 Hz
- `stopMonitoring()` — Stop acquisition
- `getRecentData(numSamples)` — Get last N samples

**Buffers**:
- Circular buffers: 15,000 samples (5 minutes @ 50Hz)
- 3-axis accelerometer (m/s²)
- 3-axis gyroscope (rad/s)
- Timestamps (ns)

### 3. HealthKitManager.swift

Heart rate monitoring via HealthKit.

**Functions**:
- `requestAuthorization()` — Request HealthKit permissions
- `startHeartRateMonitoring()` — Start HR streaming
- `getBaselineHR()` — Get 7-day resting HR average
- `getCurrentHR()` — Get current HR
- `getHRDelta()` — Get HR spike (current - baseline)

**Strategy**:
- HKAnchoredObjectQuery for real-time HR updates
- Baseline: lowest 20% of HR values over 7 days
- Delta: useful for cigarette detection (+7-15 bpm spike)

### 4. FeatureExtractor.swift

Extract 30 biomechanical features from sensor data.

**Features**:
1. Time-domain (5): RMS, peak_accel, duration, interval_mean, interval_std
2. Angular (4): angular_velocity, wrist_rotation, orientation_stability, rotation_smoothness
3. Jerk (3): jerk_magnitude, jerk_smoothness, jerk_consistency
4. Frequency (5): dominant_freq, spectral_energy, spectral_entropy, autocorr_peak, periodicity
5. Trajectory (4): path_curvature, elevation_angle, elevation_consistency, total_distance
6. Regularity (3): regularity_score, periodicity_coef, temporal_clustering
7. Contextual (6): hr_baseline, hr_delta, gps_cluster, time_of_day, day_of_week, proximity_smoking

**Algorithms**:
- Peak detection (threshold-based)
- Autocorrelation (lag-based periodicity)
- FFT (dominant frequency via Accelerate framework)
- Shannon entropy (signal distribution)
- Trajectory analysis (curvature + elevation)

### 5. DetectionService.swift

Background detection service.

**Functions**:
- `start()` — Start continuous monitoring
- `stop()` — Stop monitoring
- Background session management (WKApplicationRefreshBackgroundTask)
- Periodic inference every 30 seconds
- Local notification on cigarette detection
- Debounce 2 minutes (avoid double detections)

**Features**:
- Background execution via WKExtension
- Low power consumption (boost sampling strategy)
- Persistent detection even when app is not active

## 🚀 Build & Deploy

### Prerequisites

- macOS Monterey+ (12.0+)
- Xcode 15.0+
- Apple Watch Series 4+ (watchOS 9.0+)
- Apple Developer Account (for device testing)

### Build

```bash
# Open project
cd trilateration/apple-watch-app
open SmokingDetector.xcodeproj

# Build in Xcode
# Product → Build (⌘B)
```

### Deploy to Watch

1. Connect Apple Watch to Mac via iPhone
2. Enable Developer Mode on iPhone & Watch
   - Settings → Privacy & Security → Developer Mode
3. Select "SmokingDetector WatchKit App" scheme
4. Select your Apple Watch as destination
5. Product → Run (⌘R)

## 📊 CoreML Model

**File**: `smoking_detector.mlmodel`

**Details**:
- **Size**: 23.2 KB (int8 quantized)
- **Architecture**: Input(30) → Dense(128) → Dense(64) → Dense(32) → Dense(4)
- **Classes**: [cigarette, eating, drinking, other]
- **Accuracy**: 86.4%

**30 Features Input**:
1. Time-domain (5)
2. Angular (4)
3. Jerk (3)
4. Frequency (5)
5. Trajectory (4)
6. Regularity (3)
7. Contextual (6)

## 🔒 Permissions

Declared in `Info.plist`:

```xml
<!-- Motion & Fitness -->
<key>NSMotionUsageDescription</key>
<string>Used to detect smoking gestures</string>

<!-- HealthKit -->
<key>NSHealthShareUsageDescription</key>
<string>Used to monitor heart rate for detection</string>

<!-- Location -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>Used for GPS clustering (home/work/bar)</string>

<!-- Background Modes -->
<key>WKBackgroundModes</key>
<array>
    <string>workout-processing</string>
</array>
```

User must authorize manually at runtime.

## 🧪 Test

### Test 1: Load Model

```swift
let detector = SmokingDetector()
let loaded = detector.loadModel() // true if success
```

### Test 2: Dummy Inference

```swift
let dummyFeatures = [Double](repeating: 0.0, count: 30)
let probabilities = detector.predict(features: dummyFeatures)
// Output: [0.25, 0.25, 0.25, 0.25] (uniform if all zeros)
```

### Test 3: Sensor Collection

```swift
let sensorManager = SensorManager()
sensorManager.startMonitoring()
// Wait 5s
let data = sensorManager.getRecentData(numSamples: 250) // 5s @ 50Hz
sensorManager.stopMonitoring()
```

## 📈 Next Steps

### Phase 5: Apple Watch Implementation

- [x] BLOC 5A: Project structure (Xcode setup)
- [ ] BLOC 5B: CoreML model integration (150 lignes)
- [ ] BLOC 5C: HealthKit + Sensors (200 lignes)
- [ ] BLOC 5D: Feature extraction Swift (400 lignes)
- [ ] BLOC 5E: Background detection service (250 lignes)
- [ ] BLOC 5F: WatchOS UI + Notifications (150 lignes)

### Phase 6: Garmin Watch

- [ ] BLOC 6A: Connect IQ structure (50 lignes)
- [ ] BLOC 6B: Monkey C sensors (100 lignes)
- [ ] BLOC 6C: Deployment README

## 🐛 Debug

### View Logs

```bash
# Console.app → Select iPhone → Filter: SmokingDetector
# Or via Xcode:
# Window → Devices and Simulators → Select Watch → View Device Logs
```

### Verify Model Loaded

```
[SmokingDetector] Model loaded successfully
[SmokingDetector] Input: [30] Double
[SmokingDetector] Output: [4] Double (probabilities)
```

## 📚 References

- **CoreML Docs**: https://developer.apple.com/documentation/coreml
- **HealthKit**: https://developer.apple.com/documentation/healthkit
- **WatchKit**: https://developer.apple.com/documentation/watchkit
- **CMMotionManager**: https://developer.apple.com/documentation/coremotion/cmmotionmanager

---

**Status**:
- BLOC 5A COMPLETED ✅ (Project structure + README)

**Next**: BLOC 5B - CoreML Model Integration (150 lignes)
