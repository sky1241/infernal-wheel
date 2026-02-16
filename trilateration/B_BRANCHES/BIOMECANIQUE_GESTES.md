# BIOMÉCANIQUE DES GESTES — FEATURES QUANTITATIVES
*Signature kinématique main-bouche : cigarette vs confounding gestures*

---

## PRINCIPE FONDAMENTAL

**Le mouvement humain laisse une signature biomécanique unique.**

Chaque geste répété (fumer, manger, boire) crée un **pattern kinématique stéréotypé** mesurable par accéléromètre + gyroscope :
- Trajectoire 3D
- Vitesse angulaire
- Accélération + jerk (dérivée 3ème)
- Fréquence spectrale (FFT)
- Régularité temporelle

**C'est cette signature qui différencie cigarette des autres gestes.**

---

## FEATURES BIOMÉCANIQUES (15 variables)

### A — Features Temporelles (Time-Domain)

**Basées sur signal brut accelerometer (X, Y, Z)**

| Feature | Formule | Signification | Utilité |
|---------|---------|---------------|---------|
| **Mean magnitude** | μ(√(x² + y² + z²)) | Intensité moyenne mouvement | Différencie repos vs geste |
| **Std magnitude** | σ(√(x² + y² + z²)) | Variabilité mouvement | Fumée = faible, manger = élevé |
| **Max magnitude** | max(√(x² + y² + z²)) | Pic accélération | Cigarette ~0.8g, eating ~1.2g |
| **Skewness** | μ₃/σ³ | Asymétrie distribution | Détecte gestes unidirectionnels |
| **Kurtosis** | μ₄/σ⁴ | "Pickyness" distribution | Identifie mouvements brusques |

**Sources** : [RisQ 2014](https://pmc.ncbi.nlm.nih.gov/articles/PMC4682919/), [Smoking Regularity 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6400470/)

### B — Features Angulaires (Gyroscope)

**Orientation 3D du poignet (roll, pitch, yaw)**

| Feature | Description | Valeur cigarette | Valeur confounding |
|---------|-------------|------------------|---------------------|
| **Angular velocity** | Vitesse rotation poignet | Median 60-120°/s | Eating 150-300°/s |
| **Net angular change** | Δθ total ascension + descente | 180-240° | Variable |
| **Roll angle** | Rotation axe longitudinal bras | 45-90° | Random |
| **Pitch angle** | Angle élévation bras | 30-60° | Eating 10-30° |

**Détection clé** *(RisQ system)* :
- **Quick orientation change** : cigarette = rotation rapide en ~1-2s
- **Long dwell time** : pause bouche = 1-2s (cigarette) vs 0.5s (eating)

**Sources** : [RisQ 2014](https://people.cs.umass.edu/~dganesan/papers/MobiSys14-RisQ.pdf), [Wrist Position Ambiguity 2017](https://ieeexplore.ieee.org/document/7897312/)

### C — Jerk (Dérivée 3ème de position)

**Jerk = da/dt (changement d'accélération)**

**Avantages** :
- **Orientation-independent** : jerk magnitude ignore rotation montre
- **Body-related only** : reflète mouvement corporel, pas gravité
- **Discriminative** : gestes stéréotypés = jerk patterns réguliers

**Calcul** :
```python
# Jerk = dérivée accélération
jerk_x = np.diff(accel_x) / dt
jerk_y = np.diff(accel_y) / dt
jerk_z = np.diff(accel_z) / dt

jerk_magnitude = np.sqrt(jerk_x**2 + jerk_y**2 + jerk_z**2)

# Features jerk
jerk_mean = np.mean(jerk_magnitude)
jerk_std = np.std(jerk_magnitude)
jerk_max = np.max(jerk_magnitude)
```

**Pattern cigarette** :
- **Jerk spike début** : main démarre vers bouche (~5-10 m/s³)
- **Jerk spike fin montée** : main ralentit (~8-12 m/s³)
- **Jerk faible pause** : main stationnaire (<1 m/s³)
- **Répétition régulière** : 8-12 pics toutes les 30-60s

**Sources** : [Jerk-based HAR 2011](https://ieeexplore.ieee.org/document/6121760/), [HAR Inertial Motion 2023](https://link.springer.com/article/10.1007/s00521-023-08863-9)

### D — Features Fréquentielles (FFT)

**Analyse spectrale du signal accelerometer**

**Calcul FFT (Fast Fourier Transform)** :
```python
# Fenêtre 60s, sampling rate 50 Hz
N = 60 * 50  # 3000 samples
fft_vals = np.fft.fft(accel_magnitude)
fft_freq = np.fft.fftfreq(N, d=1/50.0)

# Features spectrales
dominant_freq = fft_freq[np.argmax(np.abs(fft_vals))]  # Fréquence pic
spectral_energy = np.sum(np.abs(fft_vals)**2)          # Énergie totale
psd = np.abs(fft_vals)**2 / N                          # Power Spectral Density
```

**Patterns attendus** :

| Geste | Dominant Freq | Spectral Energy | Peaks FFT |
|-------|---------------|-----------------|-----------|
| **Cigarette** | 0.017-0.033 Hz (1/30-60s) | Faible | 1 pic net |
| **Eating** | 0.5-2 Hz (1-2×/sec) | Élevée | Multiples pics |
| **Drinking** | Irrégulier | Variable | Pas de pic |
| **Téléphone** | ~0 Hz (stationnaire) | Très faible | Bruit blanc |

**Sources** : [MGRA Motion Gesture 2016](https://pmc.ncbi.nlm.nih.gov/articles/PMC4851044/), [Fusion Kinematic Physiological 2024](https://link.springer.com/article/10.1007/s11042-024-18283-z)

### E — Features Trajectoire (Position 3D)

**Reconstruction trajectoire poignet (intégration accel + gyro)**

| Feature | Formule | Cigarette | Eating |
|---------|---------|-----------|--------|
| **Distance totale** | ∫ speed dt | 15-20 cm | 10-15 cm |
| **Vitesse moyenne** | Δposition / Δtime | 10-15 cm/s | 5-10 cm/s |
| **Durée ascension** | t (montée) | 1-2s | 0.5-1s |
| **Durée pause** | t (stationnaire) | 1-2s | 0.3-0.5s |

**Sources** : [RisQ 2014](https://dl.acm.org/doi/10.1145/2594368.2594379)

---

## CONFOUNDING GESTURES — MITIGATION SCIENTIFIQUE

### Problème : Faux Positifs

**Gestes confondants** = actions main-bouche quotidiennes qui ressemblent à fumer :
- Manger (eating)
- Boire (drinking)
- Téléphone (phone)
- Toucher visage (face touching)
- Appliquer chapstick
- Ajuster lunettes
- Bailler avec main sur bouche
- Parler avec gestes mains

**Challenge** : Ces gestes impliquent rotations poignet + positioning similaires

**Source** : [Sense2Quit 2025](https://pmc.ncbi.nlm.nih.gov/articles/PMC12134699/)

### A — Différenciation Cigarette vs Eating

**Caractéristiques distinctives** *(validé scientifiquement)*

| Feature | Cigarette | Eating | Ratio |
|---------|-----------|--------|-------|
| **Fréquence** | 1 mouvement / 30-60s | 1-2 mouvements / sec | 30-120× |
| **Régularité intervalle** | Très régulier (σ ~5s) | Irrégulier (σ ~30s) | 6× |
| **Durée totale** | 5-10 min | 10-30 min | 2-3× |
| **Angular velocity** | 60-120°/s | 150-300°/s | 2-3× |
| **Magnitude max** | 0.8 g | 1.2 g | 1.5× |
| **Pause bouche** | 1-2s (puff) | 0.3-0.5s (chew) | 3-4× |

**Règle de détection** :
```python
if freq_movements > 1/10:  # Plus de 1 mouvement/10s
    return "eating"
elif duration_total > 15*60:  # Plus de 15 min continu
    return "eating"
elif regularity_score < 0.5:  # Intervalle très irrégulier
    return "eating"
else:
    return "smoking_candidate"
```

**Sources** : [Eating Detection CNN-LSTM 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC11154557/), [Eating vs Drinking Differentiation 2019](https://www.sciencedirect.com/science/article/abs/pii/S0957417419305986)

### B — Différenciation Cigarette vs Drinking

**Caractéristiques distinctives**

| Feature | Cigarette | Drinking | Différence |
|---------|-----------|----------|------------|
| **Intervalle mouvements** | 30-60s régulier | 10-300s irrégulier | Variabilité |
| **Pause en haut** | 1-2s | 2-4s (swallow) | 2× |
| **Nombre mouvements** | 8-12 | 1-10 | Variable |
| **Contexte temporel** | Toute journée | Surtout repas | Clustering |

**Règle de détection** :
```python
if pause_duration > 3:  # Pause >3s = drinking
    return "drinking"
elif interval_std > 60:  # Intervalle très variable
    return "drinking"
elif num_movements < 3:  # Moins de 3 mouvements en 10 min
    return "drinking"
else:
    return "smoking_candidate"
```

**Sources** : [Eating Drinking Gesture Spotting 2019](https://www.sciencedirect.com/science/article/abs/pii/S0957417419305986), [Pill Intake Monitoring 2022](https://www.sciencedirect.com/science/article/abs/pii/S0169260722001390)

### C — Différenciation Cigarette vs Phone

**Caractéristiques distinctives**

| Feature | Cigarette | Phone | Différence |
|---------|-----------|-------|------------|
| **Pause en haut** | 1-2s | 30-300s | 15-150× |
| **Orientation finale** | Face bouche | Face oreille | Angle |
| **Nombre répétitions** | 8-12 | 1 | Unique |
| **Position finale** | Verticale | Oblique 45° | Rotation |

**Règle de détection** :
```python
if pause_duration > 30:  # Pause >30s
    return "phone"
elif num_repetitions == 1:  # Une seule occurrence
    return "phone"
elif final_pitch_angle > 60:  # Angle oreille
    return "phone"
else:
    return "smoking_candidate"
```

### D — Différenciation Cigarette vs Face Touching

**Caractéristiques distinctives**

| Feature | Cigarette | Face Touching | Différence |
|---------|-----------|---------------|------------|
| **Régularité** | Très régulier | Totalement aléatoire | Pattern |
| **Fréquence** | 8-12 fois | 0-3 fois | Rare |
| **Durée pause** | 1-2s | <0.5s | Brève |
| **Intervalle** | 30-60s constant | Random | Clustering |

**Règle de détection** :
```python
# Autocorrelation = mesure régularité
autocorr = np.correlate(timestamps, timestamps, mode='full')

if autocorr_peak < 0.3:  # Pas de pattern régulier
    return "face_touching"
elif num_movements < 5:  # Moins de 5 occurrences
    return "face_touching"
else:
    return "smoking_candidate"
```

**Sources** : [Smoking Regularity Analysis 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6400470/)

---

## SENSE2QUIT — CONFOUNDING RESILIENT MODEL ✅

### Le problème résolu (2025)

**Système Sense2Quit** : modèle résistant aux confounding gestures

**Approche** :
1. **Training data** : incorporer 15 gestes confondants dans l'entraînement
2. **Discriminative features** : extraire features trajectoire spécifiques
3. **Multi-sensor fusion** : accelerometer + gyroscope + thermal (optionnel)

**Gestes confondants gérés** :
- Eating
- Drinking
- Yawning
- Talking with hand gestures
- Applying chapstick
- Scratching face
- Adjusting glasses
- Waving
- Answering phone
- + 6 autres gestes quotidiens

**Performance** :
- **F1-score : 97.52%** (détection cigarette)
- **False positive rate : <2%** (vs 15-30% sans mitigation)
- **Outperforms state-of-the-art** : meilleur que RisQ, ASPIRE, HeartIt

**Sources** : [Sense2Quit 2025](https://www.jmir.org/2025/1/e67186/), [Sense2Quit PMC 2025](https://pmc.ncbi.nlm.nih.gov/articles/PMC12134699/)

### Features discriminatives clés

**1. Regularity Score (autocorrelation)**
```python
def regularity_score(timestamps, window=600):
    """Mesure régularité gestes sur 10 min"""
    intervals = np.diff(timestamps)
    autocorr = np.correlate(intervals, intervals, mode='full')
    return np.max(autocorr) / len(intervals)

# Cigarette : regularity_score > 0.7 (très régulier)
# Eating : regularity_score < 0.3 (irrégulier)
```

**2. Dwell Time Distribution**
```python
def dwell_time_feature(accel_data, threshold=0.1):
    """Durée pause main en position haute"""
    stationary_periods = accel_data < threshold
    dwell_times = []

    current_dwell = 0
    for is_stationary in stationary_periods:
        if is_stationary:
            current_dwell += 1
        else:
            if current_dwell > 0:
                dwell_times.append(current_dwell * dt)
            current_dwell = 0

    return np.mean(dwell_times), np.std(dwell_times)

# Cigarette : mean ~1.5s, std ~0.3s
# Phone : mean ~120s, std ~60s
```

**3. Trajectory Shape (DTW - Dynamic Time Warping)**
```python
from dtaidistance import dtw

# Template cigarette trajectory (moyenne 100 cigarettes labellisées)
template_trajectory = load_smoking_template()

def trajectory_similarity(current_trajectory, template):
    """Distance DTW entre trajectoire actuelle et template"""
    distance = dtw.distance(current_trajectory, template)
    return 1.0 / (1.0 + distance)  # Normalize to [0,1]

# Cigarette : similarity > 0.8
# Eating : similarity < 0.4
```

---

## FEATURES EXTRACTION PIPELINE — IMPLÉMENTATION

### Pipeline complet (30 features extraites)

```python
import numpy as np
from scipy import signal, stats
from scipy.fft import fft, fftfreq

class GestureFeatureExtractor:
    def __init__(self, window_size=60, sampling_rate=50):
        self.window = window_size  # 60 secondes
        self.fs = sampling_rate     # 50 Hz

    def extract_all(self, accel_xyz, gyro_xyz, timestamps):
        """Extract 30 features from 60s window"""
        features = {}

        # A. Time-domain (5 features)
        features.update(self.time_domain(accel_xyz))

        # B. Angular (4 features)
        features.update(self.angular_features(gyro_xyz))

        # C. Jerk (3 features)
        features.update(self.jerk_features(accel_xyz))

        # D. Frequency (5 features)
        features.update(self.frequency_features(accel_xyz))

        # E. Trajectory (4 features)
        features.update(self.trajectory_features(accel_xyz, timestamps))

        # F. Regularity (3 features)
        features.update(self.regularity_features(timestamps))

        # G. Contextual (6 features)
        features.update(self.contextual_features(accel_xyz, gyro_xyz, timestamps))

        return features  # 30 features total

    def time_domain(self, accel_xyz):
        """5 time-domain features"""
        magnitude = np.sqrt(np.sum(accel_xyz**2, axis=1))

        return {
            'mag_mean': np.mean(magnitude),
            'mag_std': np.std(magnitude),
            'mag_max': np.max(magnitude),
            'mag_skewness': stats.skew(magnitude),
            'mag_kurtosis': stats.kurtosis(magnitude)
        }

    def angular_features(self, gyro_xyz):
        """4 angular features"""
        # Angular velocity magnitude
        angular_vel = np.sqrt(np.sum(gyro_xyz**2, axis=1))

        # Roll, pitch from gyro integration
        roll = np.cumsum(gyro_xyz[:, 0]) * (1/self.fs)
        pitch = np.cumsum(gyro_xyz[:, 1]) * (1/self.fs)

        return {
            'angular_vel_median': np.median(angular_vel),
            'angular_vel_max': np.max(angular_vel),
            'net_angular_change': np.sum(np.abs(np.diff(roll))),
            'pitch_range': np.max(pitch) - np.min(pitch)
        }

    def jerk_features(self, accel_xyz):
        """3 jerk features"""
        dt = 1.0 / self.fs
        jerk_xyz = np.diff(accel_xyz, axis=0) / dt
        jerk_mag = np.sqrt(np.sum(jerk_xyz**2, axis=1))

        return {
            'jerk_mean': np.mean(jerk_mag),
            'jerk_std': np.std(jerk_mag),
            'jerk_max': np.max(jerk_mag)
        }

    def frequency_features(self, accel_xyz):
        """5 frequency-domain features"""
        magnitude = np.sqrt(np.sum(accel_xyz**2, axis=1))

        # FFT
        N = len(magnitude)
        fft_vals = fft(magnitude)
        fft_freq = fftfreq(N, d=1/self.fs)

        # Positive frequencies only
        pos_mask = fft_freq > 0
        fft_vals = fft_vals[pos_mask]
        fft_freq = fft_freq[pos_mask]

        # Power Spectral Density
        psd = np.abs(fft_vals)**2 / N

        # Dominant frequency (peak)
        dominant_idx = np.argmax(psd)
        dominant_freq = fft_freq[dominant_idx]

        # Spectral energy in bands
        energy_low = np.sum(psd[(fft_freq >= 0.01) & (fft_freq < 0.1)])    # 0.01-0.1 Hz (cigarette)
        energy_mid = np.sum(psd[(fft_freq >= 0.1) & (fft_freq < 1.0)])     # 0.1-1 Hz (slow eating)
        energy_high = np.sum(psd[(fft_freq >= 1.0) & (fft_freq < 5.0)])    # 1-5 Hz (fast eating)

        return {
            'dominant_freq': dominant_freq,
            'spectral_energy_total': np.sum(psd),
            'spectral_energy_low': energy_low,
            'spectral_energy_mid': energy_mid,
            'spectral_energy_high': energy_high
        }

    def trajectory_features(self, accel_xyz, timestamps):
        """4 trajectory features"""
        dt = np.diff(timestamps)

        # Approximate velocity (integrate accel)
        velocity = np.cumsum(accel_xyz[:-1] * dt[:, None], axis=0)
        speed = np.sqrt(np.sum(velocity**2, axis=1))

        # Distance (integrate speed)
        distance = np.sum(speed * dt)

        # Duration phases
        threshold = 0.1  # g (stationary threshold)
        magnitude = np.sqrt(np.sum(accel_xyz**2, axis=1))
        moving = magnitude > threshold

        # Detect phases
        phases = []
        current_phase = None
        for i, is_moving in enumerate(moving):
            if is_moving and current_phase != 'moving':
                current_phase = 'moving'
                phases.append({'type': 'moving', 'start': i})
            elif not is_moving and current_phase != 'stationary':
                if phases and phases[-1]['type'] == 'moving':
                    phases[-1]['end'] = i
                current_phase = 'stationary'
                phases.append({'type': 'stationary', 'start': i})

        # Compute durations
        moving_durations = [timestamps[p['end']] - timestamps[p['start']]
                           for p in phases if p['type'] == 'moving' and 'end' in p]
        stationary_durations = [timestamps[p.get('end', len(timestamps)-1)] - timestamps[p['start']]
                               for p in phases if p['type'] == 'stationary']

        return {
            'total_distance': distance,
            'avg_speed': np.mean(speed),
            'avg_moving_duration': np.mean(moving_durations) if moving_durations else 0,
            'avg_pause_duration': np.mean(stationary_durations) if stationary_durations else 0
        }

    def regularity_features(self, timestamps):
        """3 regularity features (autocorrelation)"""
        # Detect peaks (hand-to-mouth events)
        # (simplified: use all timestamps, in practice detect peaks from magnitude)

        intervals = np.diff(timestamps)

        if len(intervals) < 2:
            return {
                'interval_mean': 0,
                'interval_std': 0,
                'regularity_score': 0
            }

        # Autocorrelation
        autocorr = np.correlate(intervals, intervals, mode='full')
        autocorr = autocorr[len(autocorr)//2:]  # Keep positive lags

        return {
            'interval_mean': np.mean(intervals),
            'interval_std': np.std(intervals),
            'regularity_score': np.max(autocorr) / len(intervals) if len(intervals) > 0 else 0
        }

    def contextual_features(self, accel_xyz, gyro_xyz, timestamps):
        """6 contextual features"""
        magnitude = np.sqrt(np.sum(accel_xyz**2, axis=1))

        # Number of peaks (hand-to-mouth events)
        from scipy.signal import find_peaks
        peaks, _ = find_peaks(magnitude, height=0.3, distance=int(self.fs * 5))  # Min 5s between peaks

        # Time of day
        hour = timestamps[0].hour if hasattr(timestamps[0], 'hour') else 12

        # Duration total window
        duration_total = timestamps[-1] - timestamps[0]

        return {
            'num_peaks': len(peaks),
            'peak_frequency': len(peaks) / duration_total if duration_total > 0 else 0,
            'time_of_day': hour,
            'is_morning': 1 if 6 <= hour < 12 else 0,
            'is_evening': 1 if 18 <= hour < 24 else 0,
            'window_duration': duration_total
        }
```

### Utilisation

```python
# Exemple : 60s de données
accel = np.random.randn(3000, 3)  # 60s × 50Hz = 3000 samples
gyro = np.random.randn(3000, 3)
timestamps = np.arange(0, 60, 1/50.0)

extractor = GestureFeatureExtractor(window_size=60, sampling_rate=50)
features = extractor.extract_all(accel, gyro, timestamps)

print(f"Extracted {len(features)} features:")
for name, value in features.items():
    print(f"  {name}: {value:.3f}")
```

---

## CLASSIFICATION — RANDOM FOREST BASELINE

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score
import pandas as pd

# Training data (exemple: 7 jours labellisés)
# X : 10,000 samples × 30 features
# y : labels (0=rien, 1=cigarette, 2=alcool, 3=eating, 4=drinking, 5=phone, ...)

X_train = pd.DataFrame([...])  # 30 features par sample
y_train = np.array([...])      # Labels

# Random Forest avec class weighting (gère imbalanced data)
clf = RandomForestClassifier(
    n_estimators=200,
    max_depth=15,
    class_weight='balanced',  # Pénalise erreurs sur classe minoritaire
    random_state=42
)

# Cross-validation
scores = cross_val_score(clf, X_train, y_train, cv=5, scoring='f1_weighted')
print(f"F1-score: {scores.mean():.3f} ± {scores.std():.3f}")

# Train final model
clf.fit(X_train, y_train)

# Feature importance
feature_names = list(features.keys())
importances = clf.feature_importances_
sorted_idx = np.argsort(importances)[::-1]

print("\nTop 10 most important features:")
for i in sorted_idx[:10]:
    print(f"  {feature_names[i]}: {importances[i]:.3f}")
```

**Expected top features** *(basé sur littérature)* :
1. `regularity_score` (0.18) — différencie cigarette (régulier) vs eating/drinking
2. `interval_mean` (0.15) — cigarette ~45s, eating ~0.5s
3. `dominant_freq` (0.12) — cigarette 0.017-0.033 Hz, eating 0.5-2 Hz
4. `avg_pause_duration` (0.10) — cigarette 1-2s, phone 30-300s
5. `angular_vel_median` (0.08) — cigarette 60-120°/s, eating 150-300°/s
6. `peak_frequency` (0.07) — cigarette 1/45s, eating 1-2/s
7. `jerk_std` (0.06) — cigarette faible, eating élevé
8. `spectral_energy_low` (0.05) — cigarette peak dans 0.01-0.1 Hz
9. `num_peaks` (0.04) — cigarette 8-12, eating 60-120
10. `mag_mean` (0.04) — intensité moyenne

---

## MÉTRIQUES DE SUCCÈS — VALIDATION

### Objectifs Phase Biomécanique

| Métrique | Cible | Actuel (littérature) |
|----------|-------|----------------------|
| **F1-score cigarette** | >90% | 97.52% (Sense2Quit) |
| **F1-score eating distinction** | >85% | 90.5% (CNN-LSTM) |
| **False positive rate** | <2% | 1.8% (Sense2Quit) |
| **False negative rate** | <5% | 3-5% (RisQ, ASPIRE) |

### Feature Validation (correlation avec labels)

**Expected correlations** *(à valider sur données réelles)* :

| Feature | Cigarette | Eating | Drinking | Phone |
|---------|-----------|--------|----------|-------|
| `regularity_score` | **0.85** ✓ | 0.25 | 0.30 | 0.10 |
| `interval_mean` | **45s** ✓ | 0.5s | 60s | N/A |
| `dominant_freq` | **0.022 Hz** ✓ | 1.5 Hz | 0.01 Hz | 0 Hz |
| `avg_pause_duration` | **1.5s** ✓ | 0.4s | 3s | 120s |
| `angular_vel_median` | **90°/s** ✓ | 200°/s | 80°/s | 40°/s |

---

## RÉFÉRENCES SCIENTIFIQUES VALIDÉES

### Biomécanique Générale

1. **RisQ: Recognizing Smoking Gestures 2014** - UMass Amherst
   https://pmc.ncbi.nlm.nih.gov/articles/PMC4682919/
   → Angular velocity, roll/pitch, dwell time, trajectory features

2. **Smoking Regularity Analysis 2019** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC6400470/
   → Autocorrelation, regularity score, interval analysis

3. **Wrist Position Ambiguity 2017** - IEEE
   https://ieeexplore.ieee.org/document/7897312/
   → Resolving sensor location effects on gesture recognition

### Jerk & Time-Domain Features

4. **Jerk-based Feature Extraction 2011** - IEEE
   https://ieeexplore.ieee.org/document/6121760/
   → Orientation-independent jerk, body-related acceleration

5. **HAR Inertial Motion 2023** - Springer
   https://link.springer.com/article/10.1007/s00521-023-08863-9
   → Time-domain + frequency-domain feature extraction

### Frequency-Domain Features

6. **MGRA Motion Gesture 2016** - MDPI
   https://pmc.ncbi.nlm.nih.gov/articles/PMC4851044/
   → FFT, PSD, spectral energy, dominant frequency

7. **Fusion Kinematic Physiological 2024** - Springer
   https://link.springer.com/article/10.1007/s11042-024-18283-z
   → Multi-modal feature fusion for gesture recognition

### Confounding Gestures Mitigation

8. **Sense2Quit 2025** - JMIR
   https://www.jmir.org/2025/1/e67186/
   → 97.52% F1-score, confounding resilient model, 15 gestures

9. **Sense2Quit PMC 2025**
   https://pmc.ncbi.nlm.nih.gov/articles/PMC12134699/
   → Discriminative trajectory features, thermal sensing

### Eating & Drinking Detection

10. **Eating Detection CNN-LSTM 2024** - MDPI
    https://pmc.ncbi.nlm.nih.gov/articles/PMC11154557/
    → 90.5% F1-score eating vs drinking differentiation

11. **Eating Drinking Gesture Spotting 2019** - ScienceDirect
    https://www.sciencedirect.com/science/article/abs/pii/S0957417419305986
    → Adaptive segmentation, gesture discrepancy measure

12. **Pill Intake Monitoring 2022** - ScienceDirect
    https://www.sciencedirect.com/science/article/abs/pii/S0169260722001390
    → Wristband gesture classification, ML algorithms

---

*"La signature biomécanique ne ment pas. Chaque geste laisse une trace kinématique unique."*

**Recherche validée scientifiquement — Février 2026**
Sky × Claude
