# -1+ Architecture Document

> **Last updated**: 2026-04-07
> **Status**: Production — watch sync working, ML trained on real data

---

## 1. Project Overview

**-1+** is a cigarette/alcohol tracking and addiction cessation app with:
- **Mobile app** (Flutter/Dart) — WebView + local shelf server
- **Wear OS watch companion** (Kotlin) — ML detection + manual buttons
- **ML pipeline** (Python/TFLite) — CNN 1D trained on real smoking data
- **Desktop dashboard** (PowerShell) — legacy, migrated into mobile app

**Core principle**: 100% local. No servers. No accounts. Data encrypted AES-256-GCM.

---

## 2. Architecture

```
WATCH (Wear OS)                        PHONE (Flutter)
┌──────────────────────┐               ┌──────────────────────┐
│  UI (Compose M3)     │               │  WebView             │
│  🚬 +1  🍺🍷🥃      │  Bluetooth    │  ┌──────────────────┐ │
│                      │  MessageClient│  │ shelf server:8011 │ │
│  DetectionService    │──────────────>│  │  20 API endpoints │ │
│  (:detection process)│               │  └──────────────────┘ │
│  - CNN inference     │               │                       │
│  - Boost mode        │               │  Dashboard HTML/CSS/JS│
│  - Pattern learning  │               │  (5200 lines)         │
│  - Training samples  │               │                       │
│                      │               │  AES-256-GCM storage  │
│  MessageSyncManager  │               │  Android Keystore     │
│  - Send or buffer    │               ├───────────────────────┤
│  - Auto-flush on     │               │  WatchMessageReceiver │
│    reconnect         │               │  MainActivity listener│
└──────────────────────┘               └───────────────────────┘
```

---

## 3. Watch Detection Pipeline

```
User presses +1 🚬
  │
  ├─ Immediate: counter +1, sync to phone, record pattern
  │
  ├─ 15 seconds DELAY (user lights cigarette)
  │
  ├─ BOOST MODE: 7 minutes, inference every 15 seconds
  │   ├─ 28 measurements total
  │   ├─ Each: 4.5s window @ 50Hz → 30 features → TFLite CNN
  │   ├─ Raw windows saved as training data
  │   └─ PARTIAL_WAKE_LOCK keeps CPU alive
  │
  └─ Return to NORMAL mode (inference every 30s)
```

### ML Model Versions

| Model | Method | F1 | Precision | Recall | Size | Status |
|-------|--------|---:|----------:|-------:|-----:|--------|
| v1 | RF synthetic | 0.12 | — | — | 23KB | Replaced |
| v2 | GBM+features (SED) | 0.42 | 0.52 | 0.35 | 20KB | **Deployed** |
| v3 | GBM+features (SED+FL) | 0.33 | 0.20 | 0.85 | 23KB | High-recall |
| v4 | CNN raw (SED+FL) | 0.39 | 0.26 | 0.81 | 41KB | Experimental |
| v5 | CNN raw (SED only) | 0.75 | 0.63 | 0.92 | 39KB | Next deploy |

Training data: SED dataset (Zenodo, 11 subjects, 276 puffs, 50Hz wrist IMU).

### 24h Pattern Learning

- Records hour + day_of_week for every cigarette/drink
- After ~3 days: identifies high-smoking hours (top 30%)
- Adaptive threshold: -0.15 during predicted smoking times
- Reduces false negatives when user is likely to smoke

---

## 4. Watch → Phone Sync

```
Watch: MessageSyncManager
  ├─ Try MessageClient.sendMessage() via Bluetooth
  ├─ If no phone connected → buffer to pending_sync.json (max 500)
  └─ PhoneConnectionListener polls every 60s → auto-flush on reconnect

Phone: MainActivity.onMessageReceived()
  ├─ Receives /detection or /drink messages
  ├─ Stores in app_flutter/watch_detections.json
  ├─ Updates app_flutter/watch_daily_summary.json
  └─ Notifies Flutter via MethodChannel
```

**Why MessageClient (not DataClient):**
DataClient requires same applicationId on both devices. Failed on Xiaomi + Samsung Watch.
MessageClient works cross-package via Bluetooth — universal solution.

---

## 5. Phone App Structure

```
infernal-app/
  lib/
    main.dart                 # Entry point, AppLauncher
    core/
      infernal_day.dart       # Day system (4am rollover)
      logger.dart             # Logging + perf measurement
      result.dart             # Result<T> type
    engine/
      timer_engine.dart       # Work/sleep/break segments
    security/
      crypto_service.dart     # AES-256-GCM + Keystore
    server/
      local_server.dart       # shelf HTTP server (20 routes)
      data_store.dart         # Local file storage (JSON/CSV)
    services/
      wear_sync_service.dart  # MethodChannel to native Kotlin
    theme/
      app_theme.dart          # Material theme
      colors.dart             # Unified palette (web+phone+watch)
      spacing.dart            # 4px spacing system
    views/
      onboarding_screen.dart  # First launch welcome
      dashboard_webview.dart  # WebView → localhost:8011
  assets/web/
    index.html                # Dashboard (5200 lines)
    notes.html                # Notes/journal page
  android/
    WatchMessageReceiver.kt   # Bluetooth message listener
    MainActivity.kt           # MessageClient + MethodChannel
```

---

## 6. Watch App Structure

```
trilateration/wear-os-app/
  app/src/main/java/.../smokingdetector/
    MainActivity.kt           # Compose UI + manual buttons
    DetectionService.kt       # Foreground service (:detection process)
    SmokingDetector.kt        # TFLite model wrapper
    SensorDataCollector.kt    # Accel + Gyro @ 50Hz
    FeatureExtractor.kt       # 30 biomechanical features
    BoostSamplingManager.kt   # 15s delay → 7min boost + wake lock
    MessageSyncManager.kt     # Bluetooth send + offline buffer
    PhoneConnectionListener.kt # Auto-flush on reconnect
    DatabaseManager.kt        # SQLite (detections, drinks, training, patterns)
    HealthServicesManager.kt  # HR monitoring (stub)
    GPSClusteringManager.kt   # DBSCAN location clusters
  app/src/main/assets/
    smoking_detector.tflite   # Deployed ML model (v2, 20KB)
```

---

## 7. Key Design Decisions

| Decision | Why |
|----------|-----|
| WebView + shelf (not native Flutter UI) | Reuse existing 5200-line dashboard HTML |
| MessageClient (not DataClient) | Works cross-package on any phone brand |
| Separate :detection process | Survives Activity kill by Samsung power manager |
| PARTIAL_WAKE_LOCK during boost | Prevents CPU sleep during 7-min scan |
| AES-256-GCM auto (no PIN) | Zero friction, Keystore protects key |
| Fixed port 8011 | Predictable for watch HTTP fallback |
| Battery whitelist | Samsung Wear OS kills everything otherwise |
| startForeground in onCreate | Must be within 5s on separate process |

---

## 8. Unified Color Palette

Source of truth: web dashboard CSS variables.

| Color | Hex | Usage |
|-------|-----|-------|
| Background | #0E1319 | Phone/web base |
| Surface | #121820 | Elevated panels |
| Border | #24303C | Dividers |
| Text | #E7EDF3 | Primary text |
| Muted | #A7B3BF | Secondary text |
| Accent | #35D99A | Brand green |
| Danger | #FF7A7A | Errors, cigarette |
| Warning | #F7BF54 | Warnings, beer |
| Blue | #6BBCFF | Links |
| Watch bg | #000000 | OLED black |

---

## 9. ML Training Pipeline

```
datasets/sed/SED.pkl           # 11 subjects, 276 puffs, 50Hz (Zenodo)
datasets/sed/SED-FL.pkl        # 7 subjects, 78h free-living (Zenodo)
train_real_data.py             # GBM on 30 features → TFLite
train_cnn.py                   # CNN 1D on raw signals → TFLite
smoking_detector_v2.tflite     # Production model (GBM, F1=0.42)
smoking_detector_v5.tflite     # Best model (CNN, F1=0.75)
normalization_params_*.npz     # Feature normalization
DATASETS.md                    # 13 datasets inventory
```

---

## 10. API Endpoints (shelf server)

| Method | Path | Description |
|--------|------|-------------|
| GET | /api/state | Live state (timer, counters, watch data) |
| GET | /api/settings | User settings |
| GET | /api/consumption/all | Historical data |
| GET | /api/drinks/weeks | Weekly alcohol table |
| GET | /api/monthly-summary | Monthly stats |
| GET | /api/note?d=DATE | Note for a day |
| GET | /api/notes/all | All notes |
| GET | /api/quicknote | Quick note |
| GET | /api/actionnote | Action note |
| GET | /api/watch/summary | Watch sync summary |
| POST | /api/cmd | Send command (start/work/sleep) |
| POST | /api/drinks/add | Log drink |
| POST | /api/drinks/adjust | Adjust drink count |
| POST | /api/note | Save note |
| POST | /api/quicknote | Save quick note |
| POST | /api/actionnote | Save action note |
| POST | /api/goal | Set work goal |
| POST | /api/settings/* | Update settings |
| POST | /api/watch/sync | Watch HTTP sync (fallback) |
