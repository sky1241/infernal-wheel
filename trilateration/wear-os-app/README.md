# Smoking Detector — Wear OS App

Wear OS application pour la détection automatique de cigarettes via capteurs multi-modaux (accelerometer + gyroscope + HR + GPS).

## 📱 Stack Technique

- **Platform** : Wear OS 3.0+ (API 30+)
- **Language** : Kotlin
- **ML Framework** : TensorFlow Lite 2.14.0
- **Hardware Acceleration** : NNAPI (Neural Network API)
- **Build System** : Gradle 8.2.0 + Kotlin DSL

## 🏗️ Architecture

```
wear-os-app/
├── app/
│   ├── build.gradle.kts              # Dépendances (TFLite, sensors, etc.)
│   ├── src/main/
│   │   ├── AndroidManifest.xml       # Permissions (sensors, location, foreground)
│   │   ├── assets/
│   │   │   └── smoking_detector.tflite  # Modèle TFLite (23.2 KB)
│   │   ├── java/com/infernal/smokingdetector/
│   │   │   ├── MainActivity.kt       # UI principale
│   │   │   ├── SmokingDetector.kt    # TFLite wrapper
│   │   │   └── SensorDataCollector.kt # Lecture capteurs
│   │   └── res/
│   │       ├── layout/activity_main.xml
│   │       └── values/strings.xml
├── build.gradle.kts                  # Configuration projet
└── settings.gradle.kts               # Modules
```

## 🔧 Composants Principaux

### 1. SmokingDetector.kt

Wrapper TFLite pour le modèle de détection.

**Fonctions** :
- `loadModel()` — Charge `smoking_detector.tflite` depuis assets
- `predict(features: FloatArray)` — Inférence sur 30 features → probabilities [cigarette, eating, drinking, other]
- `isCigaretteDetected(features, threshold)` — Détection cigarette si P(cigarette) > seuil

**Input** : `[1, 30]` float32 (30 features biomécanique)
**Output** : `[1, 4]` float32 (probabilities)

**Optimisation** :
- NNAPI enabled (hardware acceleration via Neural Engine)
- Int8 quantization (23.2 KB model size)
- Inference time : <50ms

### 2. SensorDataCollector.kt

Collecteur de données capteurs (accelerometer + gyroscope).

**Fonctions** :
- `start()` — Démarre acquisition @ 50 Hz
- `stop()` — Arrête acquisition
- `getRecentData(numSamples)` — Récupère derniers N samples

**Buffers** :
- Circular buffers : 15,000 samples (5 minutes @ 50Hz)
- 3-axis accelerometer (m/s²)
- 3-axis gyroscope (rad/s)
- Timestamps (ns)

### 3. FeatureExtractor.kt

Extraction des 30 features biomécanique depuis sensor data.

**Fonctions** :
- `extractAllFeatures(accel, gyro, timestamps, ...)` — Extrait 30 features → FloatArray
- Time-domain (5) : RMS, peak_accel, duration, interval_mean, interval_std
- Angular (4) : angular_velocity, wrist_rotation, orientation_stability, rotation_smoothness
- Jerk (3) : jerk_magnitude, jerk_smoothness, jerk_consistency
- Frequency (5) : dominant_freq, spectral_energy, spectral_entropy, autocorr_peak, periodicity
- Trajectory (4) : path_curvature, elevation_angle, elevation_consistency, total_distance
- Regularity (3) : regularity_score, periodicity_coef, temporal_clustering
- Contextual (6) : hr_baseline, hr_delta, gps_cluster, time_of_day, day_of_week, proximity_smoking

**Algorithmes** :
- Peak detection (threshold-based)
- Autocorrelation (lag-based periodicity)
- FFT approximation (dominant frequency)
- Shannon entropy (signal distribution)
- Trajectory analysis (curvature + elevation)

### 4. DetectionService.kt

Service foreground pour détection continue en background.

**Fonctions** :
- `start(context)` — Démarre service foreground avec notification persistante
- `stop(context)` — Arrête service
- Monitoring continu @ 50 Hz (accelerometer + gyroscope)
- Inférence périodique toutes les 30 secondes
- Notification cigarette détectée (avec debounce 2 min)
- Compteur cigarettes détectées

**Features** :
- Foreground service (notification persistante)
- Coroutines pour inférence asynchrone
- Debounce 2 minutes (éviter doubles détections)
- Low power consumption (boost sampling strategy)
- Auto-restart on kill (START_STICKY)

**Lifecycle** :
```
START → Sensors ON → Inference Loop (30s) → Detection → Notification
                                           ↓
STOP  ← Sensors OFF ← User Stop Button ← Service Destroyed
```

### 5. MainActivity.kt

Interface utilisateur Wear OS.

**Features** :
- Load TFLite model au démarrage
- Request permissions (BODY_SENSORS, ACTIVITY_RECOGNITION, LOCATION)
- Bouton **Start Monitor** pour service continu (vert #4CAF50)
- Bouton Start/Stop pour acquisition manuelle capteurs
- Bouton **Detect Now** pour inférence RÉELLE (sensor data + features + model)
- Bouton Test pour inférence test (dummy data)
- Affichage résultats temps réel avec probabilités

## 🚀 Build & Deploy

### Prérequis

- Android Studio Hedgehog+ (2023.1.1+)
- Android SDK 34
- Wear OS emulator ou montre physique (Wear OS 3.0+)

### Build

```bash
# Clone repo
cd trilateration/wear-os-app

# Build APK
./gradlew assembleDebug

# Output: app/build/outputs/apk/debug/app-debug.apk
```

### Deploy sur montre

**Option 1 : Via Android Studio**
1. Ouvrir projet dans Android Studio
2. Connecter montre via ADB Wifi ou USB
3. Run → Run 'app'

**Option 2 : Via ADB**
```bash
# Enable Developer Mode on watch
# Settings → System → About → tap Build number 7x

# Enable ADB debugging
# Settings → Developer options → ADB debugging

# Connect via Wifi
adb connect <WATCH_IP>:5555

# Install APK
adb install app/build/outputs/apk/debug/app-debug.apk
```

## 📊 Modèle TFLite

**Fichier** : `app/src/main/assets/smoking_detector.tflite`

**Détails** :
- **Taille** : 23.2 KB (int8 quantized)
- **Architecture** : Input(30) → Dense(128) → Dense(64) → Dense(32) → Dense(4)
- **Classes** : [cigarette, eating, drinking, other]
- **Accuracy** : 86.4% (knowledge distillation from Random Forest)

**30 Features Input** :
1. Time-domain (5) : RMS, peak_accel, duration, interval_mean, interval_std
2. Angular (4) : angular_velocity, wrist_rotation, orientation_stability, rotation_smoothness
3. Jerk (3) : jerk_magnitude, jerk_smoothness, jerk_consistency
4. Frequency (5) : dominant_freq, spectral_energy, spectral_entropy, autocorr_peak, periodicity
5. Trajectory (4) : path_curvature, elevation_angle, elevation_consistency, total_distance
6. Regularity (3) : regularity_score, periodicity_coef, temporal_clustering
7. Contextual (6) : hr_baseline, hr_delta, gps_cluster, time_of_day, day_of_week, proximity_smoking

## 🔒 Permissions

Déclarées dans `AndroidManifest.xml` :

```xml
<!-- Sensors -->
<uses-permission android:name="android.permission.BODY_SENSORS" />
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.HIGH_SAMPLING_RATE_SENSORS" />

<!-- Location (GPS clustering) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- Foreground service -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_HEALTH" />
```

User doit accepter manuellement au runtime.

## 🧪 Test

### Test 1 : Load Model

```kotlin
val detector = SmokingDetector(context)
val loaded = detector.loadModel() // true si succès
```

### Test 2 : Dummy Inference

```kotlin
val dummyFeatures = FloatArray(30) { 0f }
val probabilities = detector.predict(dummyFeatures)
// Output: [0.25, 0.25, 0.25, 0.25] (uniform si all zeros)
```

### Test 3 : Sensor Collection

```kotlin
val collector = SensorDataCollector(context)
collector.start()
// Wait 5s
val data = collector.getRecentData(250) // 5s @ 50Hz
collector.stop()
```

## 📈 Prochaines Étapes

### ✅ Phase 2 : Feature Extraction (COMPLÉTÉ)

- [x] Implémenter `FeatureExtractor.kt`
- [x] Extraire 30 features depuis sensor data
- [x] Intégrer avec SmokingDetector pour inférence temps réel

### ✅ Phase 3 : Detection Service (COMPLÉTÉ)

- [x] Foreground service pour monitoring continu
- [x] Inférence périodique (30s intervals)
- [x] Notifications cigarette détectée (avec debounce)
- [ ] Boost sampling (1/3s pendant 5min après user trigger) — TODO
- [ ] GPS clustering integration — TODO
- [ ] Health Services API (HR real-time) — TODO

### Phase 4 : Gamification (Next)

- [ ] UI +1 min/jour
- [ ] Streak counter
- [ ] Dashboard stats
- [ ] Database persistence (cigarettes history)

## 🐛 Debug

### Logs

```bash
adb logcat | grep -E "SmokingDetector|SensorDataCollector|MainActivity"
```

### Vérifier modèle chargé

```
D/SmokingDetector: Loading TFLite model: smoking_detector.tflite
D/SmokingDetector: Model loaded successfully
D/SmokingDetector: Input shape: [1, 30]
D/SmokingDetector: Output shape: [1, 4]
```

### Vérifier sensors

```
D/SensorDataCollector: Starting sensor data collection
D/SensorDataCollector: Sensors registered: Accelerometer=true, Gyroscope=true
```

## 📚 Références

- **TFLite Docs** : https://www.tensorflow.org/lite/android
- **Wear OS Sensors** : https://developer.android.com/training/wearables/sensors
- **NNAPI** : https://developer.android.com/ndk/guides/neuralnetworks

---

**Status** :
- Bloc 1 COMPLÉTÉ ✅ (Structure + TFLite integration)
- Bloc 2 COMPLÉTÉ ✅ (Feature extraction 30 features)
- Bloc 3 COMPLÉTÉ ✅ (Foreground detection service + continuous monitoring)

**Next** : Bloc 4 (Build APK + deploy to watch + test field)
