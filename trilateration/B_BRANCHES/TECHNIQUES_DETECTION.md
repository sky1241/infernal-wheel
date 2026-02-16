# TECHNIQUES SMOKING DETECTION — SYSTÈMES VALIDÉS
*Analyse détaillée des algorithmes, features, et stratégies low-power*

---

## SYSTÈMES ANALYSÉS

| Système | Année | Précision | Contexte | Source |
|---------|-------|-----------|----------|--------|
| **StopWatch** | 2019 | 86% prec, 71% recall | Free-living 24h | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC6042639/) |
| **HeartIt** | 2025 | High (not specified) | Both wrists | [Springer](https://link.springer.com/article/10.1007/s11390-024-2981-3) |
| **CNN-LSTM** | 2020 | 78% F1-score | Puff detection | [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC7235127/) |
| **LOSO CV** | Various | 97-98% | Controlled | Multiple papers |
| **PACT2.0** | 2019 | 86% F1 HMG, 98% event | Lighter + IMU | Previous refs |

---

## 1. HAND-TO-MOUTH GESTURE (HMG) — CORE PATTERN

### Les 3 Phases Détectées

Tous les systèmes détectent ces 3 mouvements séquentiels :

```
1. HAND RAISING TO MOUTH
   - Trajectoire ascendante
   - Durée : ~1-2 sec
   - Accélération : +0.5 à +1.0 g (vertical axis)

2. HAND STATIONARY AT MOUTH (PUFF)
   - Main stable près bouche
   - Durée : 1-2 sec
   - Magnitude : <0.1 g (quasi-immobile)

3. HAND MOVING AWAY FROM MOUTH
   - Trajectoire descendante
   - Durée : ~1-2 sec
   - Accélération : -0.5 à -0.8 g
```

### Extraction Trajectoire 3D

**Sensors IMU** : Accelerometer 3-axis + Gyroscope + Compass (Magnetometer)

**Fusion** : Fournit trajectoire 3D décrivant mouvement main

**Raison** : Accel seul donne accélération linéaire, gyro donne rotation, compass donne orientation → fusionné = trajectoire complète

---

## 2. SIGNAL PROCESSING — PIPELINE STANDARD

### Étape 1 : Filtrage Bruit

**Butterworth 2nd Order Low-Pass Filter**

```python
from scipy.signal import butter, filtfilt

def butterworth_lowpass(data, cutoff=5.0, fs=50.0, order=2):
    """
    Filtre passe-bas Butterworth pour IMU data.

    Args:
        data: signal brut (N,) ou (N,3) pour 3-axis
        cutoff: fréquence coupure (Hz)
        fs: fréquence échantillonnage (Hz)
        order: ordre filtre

    Returns:
        data_filtered: signal filtré
    """
    nyquist = 0.5 * fs
    normal_cutoff = cutoff / nyquist
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    return filtfilt(b, a, data, axis=0)

# Usage
accel_filtered = butterworth_lowpass(accel_raw, cutoff=5.0, fs=50.0)
```

**Pourquoi 5 Hz cutoff ?**
- Mouvements main volontaires : 0.5-5 Hz
- Bruit haute fréquence (vibrations, tremblements) : >10 Hz
- Nyquist : échantillonnage 50 Hz → max détectable 25 Hz

### Étape 2 : Wavelet Filtering (optionnel)

**Utilisé par certains systèmes pour décomposition multi-échelle**

```python
import pywt

def wavelet_decompose(data, wavelet='db4', level=3):
    """
    Décompose signal en plusieurs échelles temporelles.

    Args:
        data: signal 1D
        wavelet: famille wavelet (Daubechies 4)
        level: niveaux décomposition

    Returns:
        coeffs: liste coefficients (cA3, cD3, cD2, cD1)
    """
    coeffs = pywt.wavedec(data, wavelet, level=level)
    return coeffs

# Reconstruction signal débruité
def wavelet_denoise(data, wavelet='db4', level=3, threshold=0.1):
    coeffs = pywt.wavedec(data, wavelet, level=level)
    # Seuillage coefficients détail
    coeffs_thresh = [coeffs[0]] + [pywt.threshold(c, threshold*max(c)) for c in coeffs[1:]]
    return pywt.waverec(coeffs_thresh, wavelet)
```

### Étape 3 : Détection Candidats HMG

**Méthode simple : Détection pics (peaks)**

```python
from scipy.signal import find_peaks

def detect_hmg_candidates(accel_z, height=0.3, distance=25):
    """
    Détecte candidats HMG via pics dans axe vertical.

    Args:
        accel_z: accélération axe Z (vertical)
        height: amplitude min pic (g)
        distance: distance min entre pics (samples) = 25 samples @ 50Hz = 0.5 sec

    Returns:
        peaks_idx: indices pics détectés
    """
    peaks, _ = find_peaks(accel_z, height=height, distance=distance)
    return peaks
```

**Méthode avancée : Autocorrelation (régularité)**

```python
import numpy as np

def unbiased_autocorrelation(signal, max_lag=100):
    """
    Autocorrélation non biaisée pour détecter patterns répétitifs.

    Smoking = HMG réguliers (30-60 sec) → pic autocorrélation
    Eating = HMG irréguliers → pas de pic

    Args:
        signal: série temporelle
        max_lag: lag max (samples)

    Returns:
        acorr: autocorrélation
    """
    n = len(signal)
    signal = signal - np.mean(signal)
    acorr = np.correlate(signal, signal, mode='full')
    acorr = acorr[n-1:n+max_lag]
    acorr /= (n - np.arange(max_lag+1))  # normalisation non biaisée
    return acorr
```

**Application** : Si autocorrelation montre pic à lag=1500 samples (@50Hz) = 30 sec → pattern régulier = smoking likely.

---

## 3. MACHINE LEARNING — CLASSIFICATION

### Option 1 : SVM (Support Vector Machine)

**Features extraites** (par fenêtre 3-5 sec) :

```python
def extract_hmg_features(accel_window):
    """
    Extrait features pour SVM classifier.

    Args:
        accel_window: (N, 3) accélération 3-axis

    Returns:
        features: (15,) vecteur features
    """
    features = []

    # Magnitude
    mag = np.linalg.norm(accel_window, axis=1)
    features.append(np.mean(mag))      # mean magnitude
    features.append(np.std(mag))       # std magnitude
    features.append(np.max(mag))       # max magnitude
    features.append(np.min(mag))       # min magnitude

    # Per-axis stats
    for axis in range(3):
        features.append(np.mean(accel_window[:, axis]))
        features.append(np.std(accel_window[:, axis]))

    # Frequency domain (optionnel)
    fft = np.fft.rfft(mag)
    features.append(np.argmax(np.abs(fft)))  # dominant frequency bin

    return np.array(features)
```

**Training SVM** :

```python
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline

# Pipeline standard
clf = Pipeline([
    ('scaler', StandardScaler()),  # normalisation features
    ('svm', SVC(kernel='rbf', C=1.0, gamma='auto'))
])

# Training
clf.fit(X_train, y_train)  # X_train: (n_samples, 15), y_train: (n_samples,) 0/1

# Inference
y_pred = clf.predict(X_test)
```

### Option 2 : Decision Trees

**Features motion** : Patterns spécifiques

```python
from sklearn.tree import DecisionTreeClassifier

# Features motion (exemple simplifié)
def extract_motion_features(accel_window):
    mag = np.linalg.norm(accel_window, axis=1)

    # Detect raising phase
    raising = np.sum(np.diff(mag) > 0.1)  # count rising samples

    # Detect stationary phase
    stationary = np.sum(mag < 0.15)  # count low-mag samples

    # Detect lowering phase
    lowering = np.sum(np.diff(mag) < -0.1)

    return np.array([raising, stationary, lowering])

# Decision tree
clf = DecisionTreeClassifier(max_depth=5, min_samples_split=10)
clf.fit(X_train, y_train)
```

**Avantage** : Interprétable (visualiser arbre de décision)

### Option 3 : CNN-LSTM (Deep Learning)

**Architecture** : Convolutional + Recurrent Neural Networks

**Input** : Fenêtre temporelle brute (pas besoin feature engineering manuel)

```python
import tensorflow as tf
from tensorflow.keras import layers, models

def build_cnn_lstm(input_shape=(150, 3), n_classes=2):
    """
    CNN-LSTM pour puff detection.

    Args:
        input_shape: (timesteps, n_channels) = (150 samples @ 50Hz = 3 sec, 3-axis)
        n_classes: 2 (puff / non-puff)

    Returns:
        model: CNN-LSTM compilé
    """
    model = models.Sequential([
        # CNN layers (feature extraction)
        layers.Conv1D(64, kernel_size=5, activation='relu', input_shape=input_shape),
        layers.MaxPooling1D(pool_size=2),
        layers.Conv1D(128, kernel_size=3, activation='relu'),
        layers.MaxPooling1D(pool_size=2),

        # LSTM layers (temporal patterns)
        layers.LSTM(64, return_sequences=True),
        layers.Dropout(0.5),
        layers.LSTM(32),
        layers.Dropout(0.5),

        # Dense layers
        layers.Dense(32, activation='relu'),
        layers.Dense(n_classes, activation='softmax')
    ])

    model.compile(optimizer='adam',
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    return model

# Training
model = build_cnn_lstm()
model.fit(X_train, y_train, epochs=50, batch_size=32, validation_split=0.2)
```

**Performance** : 78% F1-score (CNN-LSTM paper 2020)

**Trade-off** : Précision élevée BUT coût computationnel (difficile déploiement montre)

---

## 4. LOW-POWER STRATEGIES — BATTERIE

### Stratégie 1 : Adaptive Triggering (HeartIt)

**Principe** : Accelerometer (low-power, toujours ON) → trigger HR sensor (high-power, ON seulement si gesture détecté)

**Pipeline** :

```
1. Accelerometer ON 24/7 (consommation faible ~0.5 mA)
2. Détection geste "lighter lighting" (pattern unique cigarette)
3. SI lighter detected → activer HR sensor pour 60 sec
4. HR sensor (consommation élevée ~3-5 mA) analyse spike nicotine
5. Après 60 sec → désactiver HR
```

**Économie** : HR actif seulement 10 min/jour (12 cigarettes × 60 sec) vs 24h continu → **économie 95%**

**Code concept** :

```python
class AdaptiveTrigger:
    def __init__(self):
        self.hr_sensor_active = False
        self.hr_timer = 0

    def process_accel(self, accel_sample):
        # Toujours analyser accel (low-power)
        if self.detect_lighter_gesture(accel_sample):
            self.activate_hr_sensor(duration=60)  # activer 60 sec

    def activate_hr_sensor(self, duration):
        self.hr_sensor_active = True
        self.hr_timer = duration
        # Trigger hardware HR sensor

    def update(self, dt=1):
        if self.hr_sensor_active:
            self.hr_timer -= dt
            if self.hr_timer <= 0:
                self.hr_sensor_active = False
                # Désactiver hardware HR sensor
```

### Stratégie 2 : Duty Cycling

**Principe** : Échantillonner capteurs par bursts (pas continu)

**Exemple** :
- Accel : 1 sec ON, 4 sec OFF (cycle 20% = duty cycle 0.2)
- GPS : 1 fix toutes les 5 min (duty cycle ~0.003)

**Économie** : Proportionnelle au duty cycle

### Stratégie 3 : RF Proximity Sensors (ultra low-power)

**Technologie** : RF transmitter 125 kHz (wrist) + receiver (chest)

**Consommation** : ~0.1 mA (10× moins que accel)

**Detection** : Changement couplage RF quand main approche poitrine/visage

**Limite** : Moins précis que IMU, faux positifs élevés

### Stratégie 4 : Battery-Free (NFC + Wireless Charging)

**NFC Sensor** : VO2 (vanadium dioxide) nicotine sensor + NFC tag

**Principe** : Smartphone/watch lit NFC tag pour récupérer data, pas besoin batterie embarquée

**Wireless Charging** : Qi standard, 500 mAh Li-ion polymer battery

**Autonomie** : 2-3 jours avec adaptive triggering

---

## 5. PERFORMANCES COMPARÉES

### Métriques Standards

| Métrique | Définition | Formule |
|----------|------------|---------|
| **Precision** | Proportion détections correctes | TP / (TP + FP) |
| **Recall (Sensitivity)** | Proportion cigarettes détectées | TP / (TP + FN) |
| **F1-Score** | Moyenne harmonique prec + recall | 2 × (prec × recall) / (prec + recall) |
| **Accuracy** | Proportion totale correcte | (TP + TN) / (TP + TN + FP + FN) |

### Résultats Publiés

**StopWatch (free-living 24h)** :
- Precision : 86%
- Recall : 71%
- F1-score : 0.78
- Contexte : participants réels, vie quotidienne, 24h continu

**CNN-LSTM (puff detection)** :
- F1-score : 78%
- Contexte : détection puffs individuels (pas événement complet)

**LOSO Cross-Validation (controlled)** :
- Accuracy : 97-98%
- F1-score : 93-86% (puff count estimation)
- Contexte : environnement contrôlé, protocole strict

**Général (multiple studies)** :
- F1-score range : 0.83 - 0.94
- Contexte : varie selon étude

### Faux Positifs Typiques

| Activité | Confusion | Mitigation |
|----------|-----------|------------|
| **Eating** | HMG répétitif | Fréquence (2-3×/sec vs 1×/30-60sec), duration (20 min vs 10 min) |
| **Drinking** | HMG + pause | Pause courte (<1 sec) vs puff (1-2 sec), pas de régularité |
| **Phone** | Main → oreille | Pause très longue (30-300 sec), single gesture |
| **Scratching face** | Main → face | Pas de stationary phase, mouvement erratique |

---

## 6. ALGORITHMES AVANCÉS

### Autocorrelation pour Régularité

**Concept** : Smoking = HMG très réguliers (30-60 sec interval)

**Implémentation** :

```python
def detect_smoking_by_regularity(accel_trace, window=600, threshold=0.6):
    """
    Détecte smoking via régularité HMG (autocorrelation).

    Args:
        accel_trace: (N,) magnitude accélération
        window: fenêtre analyse (samples) = 600 @ 50Hz = 12 sec
        threshold: seuil autocorrelation pour smoking

    Returns:
        is_smoking: bool
    """
    # Sliding window
    for i in range(0, len(accel_trace) - window, window):
        segment = accel_trace[i:i+window]

        # Autocorrelation
        acorr = unbiased_autocorrelation(segment, max_lag=150)  # 3 sec lag

        # Peak detection dans acorr
        peaks, _ = find_peaks(acorr[10:], height=threshold)  # ignore lag=0

        if len(peaks) >= 2:  # au moins 2 pics = pattern répétitif
            return True

    return False
```

### Kernel Smoothing + Correction

**Problème** : Détections bruitées (faux positifs isolés)

**Solution** : Kernel-based smoothing sur séquence temporelle détections

```python
from scipy.ndimage import gaussian_filter1d

def smooth_detections(detections, sigma=2):
    """
    Lisse séquence détections binaires.

    Args:
        detections: (N,) array 0/1 (0=non-puff, 1=puff)
        sigma: largeur kernel Gaussian

    Returns:
        smoothed: (N,) float [0, 1] probabilité smoothed
    """
    smoothed = gaussian_filter1d(detections.astype(float), sigma=sigma)
    return smoothed

# Usage
detections_raw = np.array([0, 0, 1, 0, 1, 1, 0, 0, 1, 0])  # noisy
smoothed = smooth_detections(detections_raw, sigma=1.5)
detections_clean = (smoothed > 0.5).astype(int)  # threshold
```

### Lighter Record Integration

**Concept** : Combiner IMU (wrist) + lighter data (lighting events)

**Pipeline** :

```
1. Lighter détecte lighting event (timestamp)
2. IMU détecte HMG candidates (timestamps)
3. Fusion : HMG dans fenêtre ±2 min de lighting = cigarette confirmée
```

**Avantage** : Très haute précision (98% F1-score PACT2.0)

**Limite** : Besoin lighter instrumenté (pas réaliste pour déploiement grand public)

---

## 7. DÉPLOIEMENT MONTRE — CONSIDÉRATIONS PRATIQUES

### Contraintes Hardware

| Resource | Apple Watch S6 | Wear OS typical | Budget modèle |
|----------|----------------|-----------------|---------------|
| CPU | Dual-core 1.8 GHz | Quad-core 1.1 GHz | <10% utilisation |
| RAM | 1 GB | 1-2 GB | <50 MB |
| Batterie | 18h autonomie | 24h autonomie | <5% drain/jour |
| Storage | 32 GB | 8-16 GB | <100 MB modèle |

### Optimisations Déploiement

**1. Quantization** : Float32 → Int8 (TensorFlow Lite)

```python
import tensorflow as tf

# Convertir modèle en TFLite quantized
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # quantization
tflite_model = converter.convert()

# Sauvegarder
with open('model_quantized.tflite', 'wb') as f:
    f.write(tflite_model)

# Réduction taille : 4× plus léger (32-bit → 8-bit)
```

**2. Pruning** : Éliminer neurones faible poids

**3. Feature Selection** : Réduire 15 features → 8 features critiques

**4. Sampling Rate Adaptation** : 50 Hz → 25 Hz (si précision OK)

---

## RÉFÉRENCES COMPLÈTES

### Systèmes & Papers

1. **StopWatch (2019)** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC6042639/
   → 86% precision, 71% recall, free-living 24h

2. **CNN-LSTM (2020)** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC7235127/
   → 78% F1-score puff detection, deep learning

3. **HeartIt (2025)** - Springer JCST
   https://link.springer.com/article/10.1007/s11390-024-2981-3
   → Low-power adaptive triggering, both wrists

4. **Systematic Review (2019)** - MDPI Sensors
   https://www.mdpi.com/1424-8220/19/21/4678
   → Review 30+ papers, state-of-the-art

5. **IMU Smart Lighter (2019)** - MDPI Sensors
   https://www.mdpi.com/1424-8220/19/3/570
   → 98% F1-score avec lighter data fusion

---

*"Le pattern ne ment pas. Le corps répète ce que le cerveau automatise."*

**Techniques validées — Février 2026**
Sky × Claude
