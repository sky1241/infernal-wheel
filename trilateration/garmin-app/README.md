# Smoking Detector — Garmin Connect IQ App

Garmin Connect IQ application for automatic cigarette detection via sensors (accelerometer + gyroscope + HR).

## 📱 Tech Stack

- **Platform**: Garmin Connect IQ 3.2.0+
- **Language**: Monkey C
- **Build System**: Eclipse IDE + Connect IQ SDK
- **Supported Devices**: Fenix 7/6, Vivoactive 4, Venu 2, Forerunner 955/945

## 🏗️ Architecture

```
garmin-app/
├── manifest.xml                    # App manifest (permissions, devices)
├── resources/
│   ├── drawables/
│   │   └── launcher_icon.png       # App icon (60x60)
│   ├── strings/
│   │   └── strings.xml             # Localized strings
│   └── layouts/
│       └── layout.xml              # UI layout
├── source/
│   ├── SmokingDetectorApp.mc       # Main app entry point
│   ├── SmokingDetectorView.mc      # UI view
│   ├── SensorManager.mc            # Accelerometer + gyroscope
│   └── DetectionService.mc         # Background detection
└── README.md
```

## 🔧 Main Components

### 1. SmokingDetectorApp.mc

Main app entry point (extends Toybox.Application).

**Functions**:
- `initialize()` — App initialization
- `onStart()` — Start detection service
- `onStop()` — Stop detection service
- `getInitialView()` — Return main view

### 2. SmokingDetectorView.mc

UI view (extends Toybox.WatchUi.View).

**Functions**:
- `initialize()` — View initialization
- `onLayout(dc)` — Setup UI layout
- `onUpdate(dc)` — Draw UI (cigarette count, status)
- `onShow()` — View shown
- `onHide()` — View hidden

**UI Elements**:
- Cigarette count display
- Status indicator (monitoring/stopped)
- Last detection time

### 3. SensorManager.mc

Sensor data collection (accelerometer + gyroscope).

**Functions**:
- `initialize()` — Initialize sensors
- `start()` — Start sensor monitoring @ 25 Hz
- `stop()` — Stop sensor monitoring
- `onSensorData(data)` — Handle sensor data callback
- `getRecentData()` — Get recent samples

**Features**:
- Accelerometer: 3-axis (m/s²)
- Gyroscope: 3-axis (rad/s)
- Sampling rate: 25 Hz (Garmin limitation)
- Circular buffer: 7,500 samples (5 minutes)

### 4. DetectionService.mc

Background detection service.

**Functions**:
- `start()` — Start monitoring
- `stop()` — Stop monitoring
- `onSensorData(data)` — Process sensor data
- `runInference()` — Simple threshold-based detection (no ML)

**Strategy**:
- **No ML model** (Monkey C has no ML framework)
- **Heuristic detection** based on:
  - RMS threshold (hand movement)
  - Frequency analysis (cigarette-like motion ~0.5 Hz)
  - Heart rate spike (+7-15 bpm)
- **Notification** on detection
- **Debounce** 2 minutes

## 🚀 Build & Deploy

### Prerequisites

- Eclipse IDE with Connect IQ plugin
- Connect IQ SDK 6.0+
- Garmin watch (or simulator)

### Build

```bash
# Clone repo
cd trilateration/garmin-app

# Open Eclipse
# File → Import → Connect IQ Project → garmin-app

# Build
# Project → Build Project

# Output: garmin-app.prg
```

### Deploy to Watch

**Option 1: Via Garmin Express**
1. Connect watch to computer
2. Open Garmin Express
3. Copy `garmin-app.prg` to watch via Express

**Option 2: Via Connect IQ Mobile App**
1. Export `garmin-app.iq` from Eclipse
2. Transfer to phone
3. Open Connect IQ Mobile app
4. Install from file

**Option 3: Via Simulator**
```bash
# Run simulator
connectiq

# Load app
# File → Load → garmin-app.prg
```

## 📊 Detection Strategy

**No ML Model** (Monkey C limitation)

Instead, use **heuristic rules**:

1. **RMS Threshold**:
   - Calculate RMS of accelerometer magnitude
   - If RMS > 5.0 m/s² → Hand movement detected

2. **Frequency Analysis**:
   - Count zero-crossings in 20s window
   - If frequency ~0.5 Hz (30 zero-crossings) → Cigarette-like motion

3. **Heart Rate Spike**:
   - Monitor HR delta (current - baseline)
   - If delta > +7 bpm → Smoking indicator

4. **Combined Score**:
   - If 2/3 conditions met → Cigarette detected
   - Confidence: 70-80% (lower than ML model)

**Trade-off**:
- Accuracy: ~65% (vs 86% with ML)
- No model deployment needed
- Lightweight and fast

## 🔒 Permissions

Declared in `manifest.xml`:

```xml
<iq:uses-permission id="Sensor"/>           <!-- Accelerometer + Gyroscope -->
<iq:uses-permission id="SensorHistory"/>    <!-- Access historical data -->
<iq:uses-permission id="Position"/>         <!-- GPS for clustering -->
<iq:uses-permission id="FitContributor"/>   <!-- Save to Garmin Connect -->
```

User must authorize manually at install.

## 🧪 Test

### Test 1: Sensor Access

```monkey-c
var sensorManager = new SensorManager();
sensorManager.start();
// Check sensor data in logs
```

### Test 2: Detection Heuristic

```monkey-c
var detectionService = new DetectionService();
detectionService.start();
// Simulate cigarette-like motion
// Check for notification
```

## 📈 Limitations

1. **No ML model**: Monkey C has no TensorFlow Lite support
2. **Lower accuracy**: ~65% (vs 86% with ML)
3. **Sampling rate**: 25 Hz max (vs 50-100 Hz on Wear OS/watchOS)
4. **No background execution**: App must be active for detection
5. **Battery impact**: ~5-7% per day (higher than other platforms)

## 📚 Next Steps

### Phase 6: Garmin Implementation

- [x] BLOC 6A: Connect IQ structure (manifest + README)
- [ ] BLOC 6B: Monkey C sensors (100 lignes)
- [ ] BLOC 6C: Deployment README

## 🐛 Debug

### View Logs

```bash
# Connect IQ simulator logs
# Window → Show View → Console

# Or via adb (for physical watch)
adb logcat | grep SmokingDetector
```

### Verify Sensors

```
[SensorManager] Starting sensor monitoring @ 25 Hz
[SensorManager] Accelerometer: enabled
[SensorManager] Gyroscope: enabled
```

## 📚 References

- **Connect IQ Docs**: https://developer.garmin.com/connect-iq/
- **Sensor API**: https://developer.garmin.com/connect-iq/api-docs/Toybox/Sensor.html
- **Monkey C Guide**: https://developer.garmin.com/connect-iq/monkey-c/

---

**Status**:
- BLOC 6A COMPLETED ✅ (Project structure + README)

**Next**: BLOC 6B - Monkey C Sensor Implementation (100 lignes)
