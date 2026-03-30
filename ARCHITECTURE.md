# InfernalWheel — Architecture Document

> **Last updated**: 2026-03-30 — Post-audit, pre-mobile migration
> **Status**: Beta → Production migration in progress

---

## 1. Project Overview

InfernalWheel is a **cigarette/addiction tracking and smoking cessation app** with:
- A **mobile app** (Flutter/Dart) targeting Google Play Store
- A **Wear OS watch companion** (Kotlin) with ML-based cigarette detection
- A **desktop dashboard** (PowerShell + HTML/CSS/JS) — legacy, being migrated into the mobile app
- **ML training pipeline** (Python) for smoking gesture detection

**Core principle**: All data stays local on the user's device, encrypted AES-256.

---

## 2. Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    MOBILE APP (Flutter)                  │
│                                                         │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │ WebView  │──│ shelf server │──│ Dashboard HTML/JS  │ │
│  │          │  │ localhost:0  │  │ (from assets/)     │ │
│  └──────────┘  └──────┬───────┘  └───────────────────┘ │
│                       │                                  │
│  ┌────────────────────┴────────────────────────────┐    │
│  │              REST API (shelf_router)             │    │
│  │  /api/state  /api/notes  /api/drinks  /api/cmd  │    │
│  └────────────────────┬────────────────────────────┘    │
│                       │                                  │
│  ┌────────────────────┴────────────────────────────┐    │
│  │              BUSINESS LOGIC (Dart)               │    │
│  │  TimerEngine │ AddictionTracker │ HealthService  │    │
│  └────────────────────┬────────────────────────────┘    │
│                       │                                  │
│  ┌────────────────────┴────────────────────────────┐    │
│  │           ENCRYPTED STORAGE (AES-256)            │    │
│  │  PIN-derived key │ JSON/CSV │ Android Keystore   │    │
│  └─────────────────────────────────────────────────┘    │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │          ANDROID SERVICES                        │    │
│  │  Foreground Service (timer) │ Notifications      │    │
│  │  Wear Data Layer (watch sync)                    │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
         │ Wear Data Layer API (Bluetooth)
         ▼
┌─────────────────────────────────────────────────────────┐
│                  WEAR OS APP (Kotlin)                    │
│                                                         │
│  ┌───────────┐  ┌──────────────┐  ┌─────────────────┐  │
│  │ Compose   │  │ Detection    │  │ Sensor Data     │  │
│  │ M3 UI     │  │ Service      │  │ Collector       │  │
│  └───────────┘  └──────┬───────┘  └────────┬────────┘  │
│                        │                    │           │
│  ┌─────────────────────┴────────────────────┘           │
│  │          ML INFERENCE PIPELINE                       │
│  │  SensorData → FeatureExtractor → SmokingDetector     │
│  │  (50Hz)       (30 features)      (TFLite int8)       │
│  └──────────────────────┬──────────────────────         │
│                         │                               │
│  ┌──────────────────────┴────────────────────┐          │
│  │  SQLite DB │ GPS Clustering │ Health API   │          │
│  └───────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│              ML TRAINING PIPELINE (Python)               │
│  train_baseline.py → feature_extraction.py →             │
│  convert_to_tflite.py → smoking_detector.tflite          │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│            LEGACY DASHBOARD (PowerShell) ⚠️              │
│  InfernalDashboard.ps1 → HTTP server → HTML/CSS/JS      │
│  InfernalWheel.ps1 → Timer engine                        │
│  STATUS: Being migrated into Flutter app                 │
└─────────────────────────────────────────────────────────┘
```

---

## 3. Directory Structure

```
infernal-wheel/
│
├── infernal-app/                 # Flutter mobile app (PRIMARY)
│   ├── lib/
│   │   ├── core/                 # InfernalDay, Logger, Result<T>
│   │   ├── models/               # Addiction, DayEntry, SleepData, UserSettings
│   │   ├── services/             # StorageService, HealthService, AddictionTracker
│   │   ├── theme/                # AppTheme, Colors, Spacing
│   │   ├── views/                # HomeScreen, JournalScreen, SettingsScreen
│   │   │   └── components/       # AddictionCard, SleepCard
│   │   ├── widgets/              # SafeWidgets
│   │   ├── l10n/generated/       # Localization (AR, DE, EN, ES, FR, PT, ZH)
│   │   ├── debug/                # Debug tools
│   │   └── main.dart             # Entry point
│   ├── test/                     # Tests (TODO: expand)
│   ├── assets/                   # Icons, images
│   └── pubspec.yaml              # Dependencies
│
├── trilateration/                # Wear OS + ML research
│   ├── wear-os-app/              # Kotlin Wear OS app
│   │   └── app/src/main/java/.../
│   │       ├── MainActivity.kt           # Compose UI entry
│   │       ├── DetectionService.kt       # Foreground service
│   │       ├── SensorDataCollector.kt    # Accelerometer/gyro 50Hz
│   │       ├── FeatureExtractor.kt       # 30-feature signal processing
│   │       ├── SmokingDetector.kt        # TFLite inference (<50ms)
│   │       ├── HealthServicesManager.kt  # Heart rate
│   │       ├── GPSClusteringManager.kt   # DBSCAN location clustering
│   │       ├── BoostSamplingManager.kt   # Battery-optimized sampling
│   │       ├── DatabaseManager.kt        # SQLite local storage
│   │       └── ui/                       # Compose screens + theme
│   ├── models/                   # TFLite models (smoking_detector.tflite)
│   ├── *.py                      # Python ML training scripts
│   ├── apple-watch-app/          # SwiftUI (incomplete)
│   ├── garmin-app/               # Garmin (incomplete)
│   └── docs/                     # ML documentation
│
├── hellwell/                     # LEGACY — PowerShell desktop dashboard
│   ├── InfernalDashboard.ps1     # HTTP server (3,530 lines)
│   ├── InfernalWheel.ps1         # Timer engine (267 lines)
│   ├── InfernalIO.psm1           # Atomic file I/O module
│   ├── engine/
│   │   └── Engine.Functions.ps1  # Timer logic (370 lines)
│   └── dashboard/
│       ├── Dashboard.Page.ps1    # HTML generator (5,322 lines)
│       └── Dashboard.Functions.ps1 # Helper functions (1,687 lines)
│
├── ux_resources/                 # UX reference library (44,309 lines)
│   ├── WEB.md                    # Web UX bible (15,669 lines)
│   ├── MOBILE.md                 # Mobile UX bible (15,508 lines)
│   ├── WEARABLE.md               # Wearable UX bible (13,132 lines)
│   ├── DESIGN_TREE.md            # Decision tree (510 entries)
│   └── prompts/                  # Claude AI prompts
│
├── data/                         # Historical data (CSV/JSON)
├── docs/                         # Project documentation
├── logs/                         # Runtime logs
├── notes/                        # Project notes
├── forge.py                      # Debug utility (2,252 lines)
├── ARCHITECTURE.md               # THIS FILE
└── .gitignore
```

---

## 4. Key Concepts

### InfernalDay
A custom calendar system where the **day starts at 4:00 AM** (not midnight). This matches the user's sleep patterns — going to bed at 2 AM is still "today", not "tomorrow".

```
InfernalDay "2026-03-30" = 2026-03-30 04:00:00 → 2026-03-31 03:59:59
```

### Segments
The timer engine tracks time in **segments**: work, sleep, break (clope, manger, douche, etc.). Each segment has:
- `Name` — segment type
- `StartedAt` / `EndsAt` — timestamps
- `IsWork` / `IsSleep` — flags for time accounting
- `RequireOk` — whether user must acknowledge when timer expires
- `Paused` / `PausedRemainSec` — pause state

### Commands
User actions are sent as text commands: `start`, `work`, `ok`, `dodo`, `clope`, `pause`, `resume`, `extend N`, `jpp` (overtime).

### ML Detection Pipeline (Watch)
```
Sensors (50Hz) → Buffer (2s window) → FeatureExtractor (30 features)
→ SmokingDetector (TFLite, <50ms) → [cigarette | eating | drinking | other]
→ BoostSampling (adaptive rate) → Phone sync (Wear Data Layer)
```

---

## 5. Data Flow

### Mobile App (Target Architecture)
```
User taps button in WebView
  → JS fetch('/api/cmd', {cmd: 'clope'})
  → shelf_router receives POST
  → TimerEngine.processCommand('clope')
  → State updated in memory
  → Encrypted write to local storage (AES-256)
  → Response JSON → JS updates UI
  → Android notification if timer expires
```

### Watch → Phone Sync
```
Watch detects cigarette (ML)
  → DatabaseManager stores event
  → Wear Data Layer sends to phone
  → Phone app receives event
  → Updates local storage + dashboard
```

---

## 6. Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Mobile app | Flutter (Dart) | SDK >=3.0.0 |
| Mobile UI | WebView + HTML/CSS/JS | webview_flutter ^4.13 |
| Local server | shelf + shelf_router | ^1.4.2 |
| State mgmt | Provider | ^6.1.1 |
| Local storage | Hive + encrypted files | ^2.2.3 |
| Encryption | AES-256-GCM | dart:crypto + pointycastle |
| Key storage | Android Keystore | Native |
| Watch app | Kotlin + Compose M3 Wear | Kotlin 1.9.22 |
| ML inference | TensorFlow Lite | 2.14.0 |
| ML training | Python + scikit-learn | 3.x |
| Legacy dashboard | PowerShell + HTML | 7.x |
| Localization | intl (7 languages) | ^0.18.1 |

---

## 7. Security Model

### Encryption (Target)
- **Key derivation**: User PIN (4-6 digits) + random salt → PBKDF2 → AES-256 key
- **Key storage**: Android Keystore (hardware-backed, non-extractable)
- **Data at rest**: All JSON/CSV files encrypted with AES-256-GCM
- **Backup**: Encrypted export file, requires PIN to restore on new device
- **Zero server**: No cloud, no accounts, no tracking

### Current State
- No encryption (plaintext JSON/CSV files)
- No authentication
- Local-only storage (good)

---

## 8. Known Issues & Technical Debt

### Fixed (2026-03-30 deep audit)
- 56 bugs fixed across Flutter (21), Wear OS (21), PowerShell (14)
- Duplicate InfernalDay class → merged into single source
- Wear OS sensor buffer race condition → fixed (was causing 0 detections)
- Feature normalization added to ML pipeline
- Path traversal vulnerability in notes API → patched
- .gitignore added for Wear OS build artifacts

### Remaining
| Issue | Location | Impact |
|-------|----------|--------|
| health_service.dart mostly TODO stubs | `lib/services/` | Health data integration incomplete |
| 151 MB build artifacts in git history | `wear-os-app/app/build/` | Bloated repo (gitignored now, history not cleaned) |
| 23 TODO/FIXME in Flutter code | `lib/` | Incomplete features |

### MEDIUM
| Issue | Location | Impact |
|-------|----------|--------|
| No requirements.txt (Python) | `trilateration/` | ML scripts not reproducible |
| No DB schema docs (Wear OS) | `wear-os-app/` | Unmaintainable |
| Unused platforms (Windows, Web) | `infernal-app/` | Dead code |

---

## 9. API Contract (Target — shelf server)

### GET Endpoints
| Endpoint | Response | Description |
|----------|----------|-------------|
| `GET /` | HTML | Dashboard page |
| `GET /api/state` | JSON | Current timer state + daily totals |
| `GET /api/settings` | JSON | User settings + actions list |
| `GET /api/note?d=YYYY-MM-DD` | JSON | Note for specific day |
| `GET /api/notes/all` | JSON | All notes |
| `GET /api/consumption/all` | JSON | All drinks + smokes by day |
| `GET /api/quicknote` | JSON | Quick note content |
| `GET /api/actionnote` | JSON | Action note content |
| `GET /api/drinks/weeks` | JSON | Weekly alcohol totals |
| `GET /api/monthly-summary?m=YYYY-MM` | JSON | Monthly aggregates |

### POST Endpoints
| Endpoint | Body | Description |
|----------|------|-------------|
| `POST /api/cmd` | `{cmd: "work"}` | Send command to timer engine |
| `POST /api/goal` | `{hours: 500}` | Set work goal |
| `POST /api/drinks/add` | `{type, n, day?}` | Log drink |
| `POST /api/drinks/adjust` | `{type, total}` | Adjust drink total |
| `POST /api/note` | `{day, content}` | Save daily note |
| `POST /api/quicknote` | `{content}` | Save quick note |
| `POST /api/actionnote` | `{content}` | Save action note |
| `POST /api/settings/custom-actions` | `{actions[]}` | Update custom actions |
| `POST /api/settings/remove-action` | `{key}` | Remove action |
| `POST /api/settings/alcohol-volumes` | `{beer, wine, strong}` | Update drink volumes |

---

## 10. Build & Run

### Flutter App
```bash
cd infernal-app
flutter pub get
flutter run                    # Debug on connected device
flutter build apk --release    # Release APK
```

### Wear OS App
```bash
cd trilateration/wear-os-app
./gradlew assembleDebug        # Debug build
./gradlew assembleRelease      # Release build
```

### Legacy Dashboard (PC only)
```powershell
cd hellwell
.\Start-InfernalWheel.ps1      # Starts timer + dashboard on localhost:8011
```

### ML Training
```bash
cd trilateration
pip install -r requirements.txt  # TODO: create this file
python train_baseline.py
python convert_to_tflite.py
```

---

## 11. Migration Roadmap

**Summary**: The PowerShell dashboard (hellwell/) is being migrated into the Flutter app. The HTML/CSS/JS frontend is reused as-is, served locally via shelf on the phone. The PowerShell backend is replaced by Dart. All data is encrypted AES-256 with a user PIN.

```
BEFORE:  PC → PowerShell server → Browser → localhost:8011
AFTER:   Phone → Dart shelf server → WebView → localhost:auto
```

### Progress (2026-03-30)

| Bloc | Description | Status |
|------|-------------|--------|
| 0 | Extract HTML, make frontend full client-side | DONE |
| 1 | Dart shelf server (port auto, CORS, no-cache) | DONE |
| 2 | Serve HTML from Flutter assets | DONE |
| 3 | WebView + AppLauncher lifecycle | DONE |
| 4 | PIN + AES-256-GCM encrypted storage (PBKDF2 600k) | DONE |
| 5 | Timer engine (segments, day rollover 4h, commands) | DONE |
| 6 | Android foreground service + persistent notification | DONE |
| 7 | GET API endpoints (state, settings, notes, consumption) | DONE |
| 8 | POST API endpoints (cmd, drinks, notes, settings) | DONE |
| 9 | Notifications (timer expired, WAIT_OK) | TODO |
| 10 | Encrypted backup/restore (device migration) | TODO |
| 11 | Onboarding (PIN + tracker selection) | TODO |
| 12 | Play Store prep (privacy policy, signing, etc.) | TODO |
| 13 | End-to-end integration test | TODO |

### Key files
- `lib/server/local_server.dart` — shelf HTTP server, 20 API routes
- `lib/server/data_store.dart` — local file storage (JSON, CSV, TXT)
- `lib/engine/timer_engine.dart` — timer engine (port of InfernalWheel.ps1)
- `lib/engine/foreground_service.dart` — Android foreground service wrapper
- `lib/security/crypto_service.dart` — AES-256-GCM + PBKDF2 + Keystore
- `lib/views/pin_screen.dart` — PIN entry (setup + unlock)
- `lib/views/dashboard_webview.dart` — WebView widget
- `lib/main.dart` — AppLauncher (PIN → server → WebView lifecycle)
- `assets/web/index.html` — 5281-line static dashboard (224KB)
