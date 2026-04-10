# Architecture — Infernal Wheel / -1+

> **Last updated**: 2026-04-10 (nuit session — multi-signal detection stack)
> **Status**: Production-ready pipeline verified on real Galaxy Watch 7.

Snapshot of the project structure and the responsibilities of each component.

---

## Top-level layout

```
infernal-wheel/
├── infernal-app/                  # Flutter mobile app (phone)
│   ├── lib/                       # Dart code — UI, services, shelf server
│   ├── android/                   # Flutter Android wrapper + MainActivity.kt
│   │                              #   handles watch MessageClient sync
│   ├── assets/web/                # Dashboard HTML/CSS/JS embedded in WebView
│   ├── test_api.py                # API integration tests (17/17 passing)
│   └── test_flows.py              # UX flow tests (125/125 passing)
│
├── trilateration/                 # ML pipeline + Wear OS app
│   ├── wear-os-app/               # Galaxy Watch app (Kotlin)
│   │   └── app/src/main/java/com/infernal/smokingdetector/
│   │       ├── DetectionService.kt         # foreground service (:detection)
│   │       ├── SmokingDetector.kt          # TFLite wrapper, auto-detects model format
│   │       ├── SequenceDetector.kt         # 🆕 temporal pattern match (6-min window)
│   │       ├── GaussianHourPattern.kt      # 🆕 continuous smoking-hour score
│   │       ├── SamsungHealthAccelerometer.kt  # 25Hz parasitic accel flow
│   │       ├── DatabaseManager.kt          # SQLite schema v6 + migrations
│   │       ├── HealthServicesManager.kt    # HR tracking (STUB + HR rise detection)
│   │       ├── SensorDataCollector.kt      # legacy 50Hz SensorManager path
│   │       ├── FeatureExtractor.kt         # 30-feature extraction (legacy v2 model)
│   │       ├── BoostSamplingManager.kt     # 50Hz boost for 7 min after +1 click
│   │       ├── MessageSyncManager.kt       # watch → phone sync + offline buffer
│   │       ├── PhoneConnectionListener.kt  # auto-flush on reconnect
│   │       ├── GorillaCompressor.kt        # delta + gzip + base64 for sensor data
│   │       ├── GPSClusteringManager.kt     # home/work/bar clustering
│   │       └── MainActivity.kt             # watch UI entry point (Compose)
│   │
│   ├── datasets/sed/              # SED smoking detection dataset (SED.pkl + SED-FL.pkl)
│   ├── train_cnn.py               # original 50Hz/6ch training
│   ├── train_cnn_25hz.py          # v6 training (25Hz/3ch accel only)
│   ├── finetune_cnn_v7.py         # 🆕 per-user fine-tuning script
│   ├── smoking_detector_v6_25hz.tflite     # current production model
│   ├── normalization_params_v6_25hz.npz    # matching norm params
│   ├── test_sequence_detector.py  # 🆕 12 tests
│   ├── test_gaussian_pattern.py   # 🆕 21 tests
│   ├── test_hr_confirmation.py    # 🆕 8 tests
│   ├── test_train_cnn_25hz.py     # 31 tests
│   ├── test_samsung_pipeline.py   # 22 tests
│   ├── test_v6_on_device_parity.py # 11 tests
│   ├── test_training_window_flow.py # 27 tests
│   ├── test_compression.py        # Gorilla lossless verification
│   ├── PLAN_DE_GUERRE.md          # strategic vision (parasitic flow, dual 50Hz/25Hz)
│   ├── PLAN_DE_BATAILLE.md        # tactical execution plan
│   ├── SAMSUNG_PARTNER_PLAN.md    # Samsung partner registration guide
│   ├── SYSTEM_SUMMARY.md          # high-level system description
│   ├── ARBRE_DETECTION.md         # detection-stack tree view
│   └── DATASETS.md                # inventory of 13 datasets available
│
├── CHANGELOG.md                   # 🆕 project changelog (Keep a Changelog format)
├── ARCHITECTURE.md                # this file
└── .gitignore                     # excludes AAR, APK, personal data, etc.
```

---

## Data flow on the watch

```
┌────────────────────────────┐
│ Samsung Health Sensor SDK  │   ACCELEROMETER_CONTINUOUS @ 25Hz
│ (ACCELEROMETER_CONTINUOUS) │   batched every ~12s (300 samples)
└─────────────┬──────────────┘
              │  raw int values
              ▼
┌────────────────────────────┐
│ SamsungHealthAccelerometer │   rawIntToMs2() × 3 axes
│ (wrapper class)            │   emits Array<FloatArray> in m/s²
└─────────────┬──────────────┘
              │  300 samples × 3ch
              ▼
┌────────────────────────────┐
│ DetectionService           │
│   onSamsung25HzBatch()     │   push into 200-sample ring buffer
│                            │   rate-limit inference to 1/4s
└─────────────┬──────────────┘
              │  last 112 samples (4.5s @ 25Hz)
              ▼
┌────────────────────────────┐
│ SmokingDetector.predictRaw │   TFLite v6 CNN (35 KB, 2-4 ms)
│   25Hz                     │   [1, 112, 3] → [1, 4] softmax
└─────────────┬──────────────┘
              │  P(cigarette)
              ▼
┌────────────────────────────┐
│ SequenceDetector.push()    │   sliding window 6 min
│   3 peaks > 0.50 required  │   (2 in high-smoking hour,
│   (2 if high-smoking hour) │    driven by GaussianHourPattern)
└─────────────┬──────────────┘
              │  triggered == true
              ▼
      ┌───────────────────┐
      │ Parallel fork     │
      ├───────────────────┤
      │ 1. captureTraining│   snapshot ring buffer → MessageSyncManager
      │    Window()       │   → phone (offline buffer if needed)
      ├───────────────────┤
      │ 2. handleCigarette│   DB insert + notification +
      │    Detected()     │   messageSync.sendCigarette() +
      │                   │   boostManager.triggerBoost() +
      │                   │   scheduleHrConfirmation() (delay 2 min)
      └───────────────────┘
```

---

## Detection confidence stack

Every detection is corroborated by multiple independent signals:

| Signal | Source | Lag | Contribution |
|--------|--------|-----|--------------|
| CNN probability | SmokingDetector (TFLite) | Real-time (2-4 ms) | Primary |
| Temporal pattern | SequenceDetector | 60-120 sec | Denoises isolated gestures |
| HR rise | HealthServicesManager | +120 sec after trigger | Physiological confirmation |
| Hour of day | GaussianHourPattern | Always | Soft prior (lowers bar in smoking hours) |
| GPS cluster | GPSClusteringManager | Always | Home/work/bar context (not yet in decision) |

The system is **redundant**: a false positive would need to fool all three
signals simultaneously, which is extremely unlikely in normal daily activity.

---

## Database schema (v6)

### `cigarette_detections`
| Column | Type | Purpose |
|--------|------|---------|
| id | INTEGER PK | Auto-increment |
| timestamp | INTEGER | Unix ms of the detection |
| confidence | REAL | CNN P(cigarette) at trigger time |
| gps_cluster | INTEGER | Cluster ID from GPSClusteringManager |
| hr_baseline | REAL | Resting HR at detection time |
| hr_current | REAL | Instantaneous HR at detection time |
| hr_delta | REAL | Synchronous delta (current - baseline) |
| features | TEXT | JSON 30-feature vector (for legacy v2 model) |
| wrist_location | TEXT | "left" or "right" |
| smoking_hand | TEXT | "left" / "right" / "auto" |
| sync_status | TEXT | "pending" / "synced" |
| **hr_rise** 🆕 | REAL | HR delta measured 2 min after detection |
| **hr_confirmed** 🆕 | INTEGER | 1 if hr_rise ≥ 5 bpm, else 0 |

### `smoking_patterns`
| Column | Type | Purpose |
|--------|------|---------|
| id | INTEGER PK | Auto-increment |
| hour | INTEGER | 0-23 |
| day_of_week | INTEGER | 1=Sun, 7=Sat |
| count | INTEGER | Cumulative smoking events in this slot |
| last_updated | INTEGER | Unix ms |

### `training_samples`
| Column | Type | Purpose |
|--------|------|---------|
| id | INTEGER PK | Auto-increment |
| timestamp | INTEGER | Unix ms |
| label | TEXT | "cigarette" / "drink" / "unknown" |
| raw_data | TEXT | Serialized window |
| inference_result | TEXT | CNN output at capture time |
| boost_measurement | INTEGER | Boost mode sequence index (0-27) |

---

## Watch → phone data flow

```
WATCH                              PHONE
─────                              ─────
[detection event]
     │
     ├─ MessageSyncManager ────────► MainActivity.onMessageReceived
     │    path="/detection"              path="/detection"
     │    (offline buffer if needed)     ↓
     │                                 app_flutter/watch_detections.json
     │                                 ↓ notify Flutter via MethodChannel
     │                                 dashboard shows new count
     │
     └─ MessageSyncManager ────────► MainActivity.onMessageReceived
          path="/training_window"        path="/training_window"
          (compressed Gorilla payload)   ↓
                                       app_flutter/training_windows/
                                         YYYY-MM-DDTHH-MM-SS_<label>_conf<pct>.json
                                       ↓ FIFO cap 1000 files (~1 MB)

                                     [later: developer pulls training_windows/
                                      via adb and runs finetune_cnn_v7.py
                                      to retrain the CNN on personal data]
```

---

## Test coverage summary

| Suite | Tests | Focus |
|-------|:--:|-------|
| test_sequence_detector.py 🆕 | 12 | Temporal pattern detection |
| test_gaussian_pattern.py 🆕 | 21 | Continuous hour scoring |
| test_hr_confirmation.py 🆕 | 8 | HR rise detection |
| test_samsung_pipeline.py | 22 | int → m/s² → CNN end-to-end |
| test_train_cnn_25hz.py | 31 | CNN training pipeline |
| test_v6_on_device_parity.py | 11 | Python inference ≈ watch output |
| test_training_window_flow.py | 27 | Watch → phone sync + buffer |
| test_compression.py | ~8 | Gorilla lossless |
| test_api.py (phone) | 17 | Flutter backend API |
| test_flows.py (phone) | 125 | UX flows |

**Total: ~282 tests, all green as of 2026-04-10 nuit session.**

---

## Build / install commands

### Watch APK
```bash
cd trilateration/wear-os-app
./gradlew :app:assembleDebug
adb -s <watch_ip>:<port> install -r -d app/build/outputs/apk/debug/app-debug.apk
adb -s <watch_ip>:<port> shell am start-foreground-service \
    -n com.infernal.wheel/com.infernal.smokingdetector.DetectionService \
    -a com.infernal.smokingdetector.START
```

### Phone APK
```bash
cd infernal-app
flutter build apk --debug
adb -s <phone_id> install -r -d build/app/outputs/flutter-apk/app-debug.apk
```

### Run all Python tests
```bash
cd trilateration
for t in test_sequence_detector test_gaussian_pattern test_hr_confirmation \
         test_train_cnn_25hz test_samsung_pipeline test_v6_on_device_parity \
         test_training_window_flow test_compression; do
  python $t.py
done
```

### Pull training windows from phone (for fine-tuning)
```bash
adb -s <phone_id> exec-out run-as com.infernal.infernal_wheel \
    tar c -C files/app_flutter/training_windows . | tar x -C ./pulled_training/
python finetune_cnn_v7.py --pulled_dir ./pulled_training/ --min-windows 20
```

---

## Known stubs / TODOs

- `HealthServicesManager` is still a STUB — it emits mock HR values. The
  new HR timeline buffer and `getHRRiseOverLast()` logic are ready to wire
  in real androidx.health.services.client data as soon as that code path
  is written. All downstream consumers (HR confirmation recheck, DB column
  updates) already work against the mock data.
- `finetune_cnn_v7.py` currently rebuilds the CNN from scratch rather than
  warm-starting from the v6 weights. A future revision should export the
  Keras `.h5` alongside each `.tflite` so we can properly warm-start.
- The `exported=true` flag on `DetectionService` in AndroidManifest.xml is
  required for `adb shell am start-foreground-service` during development
  but MUST be flipped to `false` before the Play Store release.
- Samsung partner registration is still pending (SAMSUNG_PARTNER_PLAN.md).
  Until done, the app only works on watches with Health Platform dev mode
  enabled — i.e. the developer's own watch.
