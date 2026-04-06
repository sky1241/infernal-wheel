# -1+ (Minus One Plus)

Habit tracker & addiction monitor — cigarettes, alcohol, sleep, work.
Mobile app (Android) + smartwatch (Wear OS) + web dashboard.

**100% local. Zero servers. Your data stays on your phone.**

## What it does

- **Cigarette tracking** — manual +1 button on watch + ML auto-detection (TFLite)
- **Alcohol tracking** — beer, wine, strong — manual buttons on watch
- **Time tracking** — work, sleep, breaks, sport with live timer
- **Daily notes** — morning/evening check-in with mood, anxiety, CBT, anger management
- **Monthly stats** — calendar heatmap, trends, records
- **Watch → Phone sync** — Bluetooth MessageClient, works offline with auto-flush

## Architecture

```
Watch (Wear OS)                     Phone (Flutter)
+------------------+                +------------------+
| +1 Clope button  |  Bluetooth     | WatchMessageRcvr |
| +1 Beer/Wine/Fort|  MessageClient | MainActivity     |
| ML Detection     | ------------> | Shelf server:8011|
| Offline buffer   |                | WebView dashboard|
| PhoneConnListener|                | AES-256 storage  |
+------------------+                +------------------+
```

## Project structure

```
infernal-app/          # Flutter mobile app (Android)
  lib/
    server/            # Shelf HTTP server + API (20 endpoints)
    engine/            # Timer engine (work/sleep/break segments)
    security/          # AES-256-GCM + Android Keystore
    views/             # Onboarding, WebView, PIN screen
  assets/web/          # Dashboard HTML (5200 lines) + Notes page
  android/             # Kotlin: WatchMessageReceiver, MainActivity

trilateration/
  wear-os-app/         # Wear OS watch app (Kotlin + Compose)
    smokingdetector/   # ML detection + sensor collection
      MainActivity.kt  # UI + manual logging + Bluetooth sync
      DetectionService  # Foreground service, 30s inference loop
      MessageSyncMgr    # Bluetooth sync + offline buffer
      SmokingDetector   # TFLite model (23KB, 4 classes)
      FeatureExtractor  # 30 biomechanical features
      DatabaseManager   # SQLite (cigarettes + drinks)

hellwell/              # Legacy PowerShell dashboard (desktop)
  InfernalDashboard    # HTTP server (port 8011)
  InfernalWheel        # Timer engine
  dashboard/           # HTML/CSS/JS generation

ux_resources/          # UX bible (~45K lines)
  WEB.md               # Web UX rules (15,669 lines)
  MOBILE.md            # Mobile UX rules (15,508 lines)
  WEARABLE.md          # Wearable UX rules (13,132 lines)
  ICONS.md             # App icon design bible (307 lines)
```

## Tech stack

| Component | Technology |
|-----------|-----------|
| Mobile app | Flutter (Dart) + WebView |
| Watch app | Kotlin + Compose for Wear OS |
| ML model | TensorFlow Lite (int8, 23KB) |
| Local server | shelf (Dart HTTP) |
| Storage | SQLite (watch) + JSON (phone) |
| Encryption | AES-256-GCM + Android Keystore |
| Sync | Wear OS MessageClient (Bluetooth) |
| Dashboard | Vanilla HTML/CSS/JS (no framework) |

## ML Detection

The watch runs a TFLite model that classifies hand gestures:

| Class | Index | Description |
|-------|-------|-------------|
| Cigarette | 0 | Smoking gesture (hand-to-mouth) |
| Eating | 1 | Eating gesture |
| Drinking | 2 | Drinking gesture |
| Other | 3 | No addiction activity |

**Features:** 30 biomechanical signals (accelerometer, gyroscope, heart rate, GPS cluster, time-of-day).
**Inference:** every 30 seconds, <50ms per run.

## Security

- AES-256-GCM encryption (key auto-generated, stored in Android Keystore)
- No server, no account, no cloud — data never leaves the device
- Android app sandboxing + full-disk encryption
- Path traversal protection on all API endpoints

## Build

```bash
# Phone app
cd infernal-app && flutter build apk --debug

# Watch app
cd trilateration/wear-os-app && ./gradlew assembleDebug

# Install
adb install infernal-app/build/app/outputs/flutter-apk/app-debug.apk
adb -s WATCH_IP:PORT install trilateration/wear-os-app/app/build/outputs/apk/debug/app-debug.apk
```

## License

Personal use.
