# 🔬 TRILATÉRATION SMARTWATCH — DÉTECTION CIGARETTE & ALCOOL

**Système auto-détection via capteurs multi-modaux (accelerometer + gyroscope + heart rate + GPS)**

*Documentation complète : 4,600+ lignes validées scientifiquement avec 50+ références*

---

## 📐 ARCHITECTURE WINTER TREE (R/T/B/C)

```
          ☆  CIME — Interface & Gamification
         /|\
        / | \  BRANCHES — Pattern Recognition
       /  |  \
      /   |   \
─────/────|────\───── LE SOL = Sky ↔ Smartwatch
     \    |    /
      \   |   /  TRONC — Fusion Capteurs
       \  |  /
        \ | /
         \|/
    RACINES — Hardware Sensors
          |
    MYCORHIZES — Lois physiques
```

**Principe** : Croissance du bas (hardware) vers le haut (UI), comme un arbre en hiver.

---

## 📂 STRUCTURE DU PROJET

### 🌲 [ARBRE_DETECTION.md](ARBRE_DETECTION.md) ← **COMMENCER ICI**
Document maître avec vue d'ensemble complète (428 lignes)

### 🌿 R_RACINES/ — Hardware & Physique

| Fichier | Contenu | Lignes |
|---------|---------|--------|
| **[DATASETS.md](R_RACINES/DATASETS.md)** | GeoLife, WESAD, PPG-DaLiA (téléchargement + quick start) | 429 |

**Concepts clés** :
- Lois physiques : Nicotine +7-15 bpm, Alcool dose-dépendant (2+ verres)
- Hardware : PPG 1Hz, Accelerometer 50-100Hz, Gyroscope, GPS
- Datasets publics : 17k trajectoires GPS, 15 sujets HR+accel

### 🌳 T_TRONC/ — Fusion Multi-Capteurs

| Fichier | Contenu | Lignes |
|---------|---------|--------|
| **[LOCALISATION_CONTEXTUELLE.md](T_TRONC/LOCALISATION_CONTEXTUELLE.md)** | WLS fusion + DBSCAN clustering (pas true trilatération) | 571 |

**Concepts clés** :
- WLS (Weighted Least Squares) fusion de GPS
- Stay point detection (fenêtre glissante R=50m, T_min=10min)
- DBSCAN clustering pour lieux significatifs (home/work/bar)
- Labelling temporel : nuit=maison, jour=bureau, soirée=bar

### 🌲 B_BRANCHES/ — Intelligence & Machine Learning

| Fichier | Contenu | Lignes |
|---------|---------|--------|
| **[TECHNIQUES_DETECTION.md](B_BRANCHES/TECHNIQUES_DETECTION.md)** | Signal processing + ML algorithms (SVM, CNN-LSTM) | 505 |
| **[BIOMECANIQUE_GESTES.md](B_BRANCHES/BIOMECANIQUE_GESTES.md)** | 30 features quantitatives + confounding mitigation | 628 |
| **[MOUVEMENTS_REPETITIFS.md](B_BRANCHES/MOUVEMENTS_REPETITIFS.md)** | Patterns cigarette/alcool/eating (existant enrichi) | 437 |

**Concepts clés** :
- **Signal processing** : Butterworth low-pass (5Hz), wavelet, autocorrelation
- **ML algorithms** : SVM 86%/71%, Decision Trees, CNN-LSTM 78% F1
- **30 features** : Time-domain (5), Angular (4), Jerk (3), Frequency (5), Trajectory (4), Regularity (3), Contextual (6)
- **Confounding gestures** : Sense2Quit model 97.52% F1 (gère eating, drinking, phone, etc.)
- **Adaptive triggering** : Accelerometer always-on → trigger HR+ML only when gesture detected (95% battery save)

### ☆ C_CIME/ — Interface & Gamification

*(Vide pour l'instant - specs UI à venir)*

**Concepts prévus** :
- Notification discrète (vibration, pas de son)
- Système delay +1 min/jour (streak gamification)
- Dashboard : cigarettes/jour, alcool/jour, heatmap horaire, carte lieux

### 📚 docs/ — Documentation Technique

| Fichier | Contenu | Lignes |
|---------|---------|--------|
| **[DEPLOYMENT_HARDWARE.md](docs/DEPLOYMENT_HARDWARE.md)** | TFLite/CoreML, quantization, battery optimization | 658 |
| **[VALIDATION_TESTING.md](docs/VALIDATION_TESTING.md)** | LOSO, metrics, IRB ethics, field validation | 627 |

**Concepts clés** :
- **Platforms** : Apple Watch (CoreML, Neural Engine), Wear OS (TFLite, NNAPI)
- **Optimization** : Pruning 50% + Quantization int8 = 8× reduction (1024KB → 128KB, -3% accuracy)
- **Battery** : Adaptive triggering 95% save, Quantization -60% power
- **Validation target** : LOSO (gold standard) — Lab 85-92% F1 and Field 80-86% F1 are **literature benchmarks** (RisQ, ASPIRE, Sense2Quit) used as Phase 3-4 targets, not measured on this model yet. Current model validated end-to-end on Galaxy Watch 7 (April 2026, 2 real-world sessions). See [BUGS.md BUG+053](BUGS.md) on label-leakage audit invalidating prior F1 metrics.

---

## 🚀 QUICK START

### 1. Comprendre le système (5 min)
Lire [ARBRE_DETECTION.md](ARBRE_DETECTION.md) sections :
- R1 Mycorhizes (lois physiques validées)
- T2 Pattern Detection (cigarette vs alcool)
- B1 Machine Learning (modèles baseline)

### 2. Prototyper avec datasets publics (1-2 semaines)
```bash
# Télécharger GeoLife (GPS mobility)
wget https://download.microsoft.com/download/F/4/8/F4894AA5-FDBC-481E-9285-D5F8C4C4F039/Geolife%20Trajectories%201.3.zip
unzip "Geolife Trajectories 1.3.zip"

# Télécharger WESAD (HR + accel)
wget https://uni-siegen.sciebo.de/s/pYjSgfOVs6Ntahr/download -O WESAD.zip
unzip WESAD.zip

# Implémenter stay points + DBSCAN (voir T_TRONC/LOCALISATION_CONTEXTUELLE.md)
python trilateration/stay_points.py

# Extraire 30 features biomécanique (voir B_BRANCHES/BIOMECANIQUE_GESTES.md)
python trilateration/feature_extraction.py

# Train Random Forest baseline (voir B_BRANCHES/TECHNIQUES_DETECTION.md)
python trilateration/train_baseline.py
```

### 3. Collecter données propres (7 jours)
- Porter Apple Watch 24/7
- Logger manuellement : timestamp chaque cigarette/verre via app mobile
- Collecter : GPS (1/5min) + accel (50Hz) + HR (1Hz)
- Format : CSV ou SQLite

### 4. Déployer sur montre (2-4 semaines)
```bash
# Convert model → CoreML (iOS) ou TFLite (Android)
python convert_to_coreml.py --model baseline_rf.pkl --output SmokingDetector.mlmodel

# Quantization int8 (4× smaller)
python quantize_model.py --input model.h5 --output model_int8.tflite

# Test on device
# iOS: Xcode → WatchKit app → load SmokingDetector.mlmodel
# Android: Android Studio → Wear OS app → load model_int8.tflite
```

---

## 📊 MÉTRIQUES CIBLES (issues de la littérature)

> ⚠️ **Important** : les chiffres ci-dessous sont les **targets attendus** dérivés de la littérature et des benchmarks comparables (RisQ, ASPIRE, Sense2Quit). Ils ne sont **pas mesurés sur ce modèle**. La validation Phase 3-4 (Lab + Field LOSO) est planifiée mais pas exécutée. Status actuel : prototype validé end-to-end sur Galaxy Watch 7, 2 sessions réelles (avril 2026). Voir [BUGS.md BUG+053](BUGS.md) sur l'audit label-leakage qui invalide les F1 antérieurs.

| Phase | Environnement | F1-Score (target) | Méthode | Source |
|-------|---------------|-------------------|---------|--------|
| **Lab** | Contrôlé | **85-92%** *(target)* | 10-fold CV | Literature benchmark |
| **Field** | Real-world | **80-86%** *(target)* | LOSO (15-30 participants) | Literature benchmark |
| **Production** | Deployment | **80%+** *(target)* | Continuous monitoring | A/B testing planned |

### Benchmarks littérature

| Système | Précision | Recall | F1-Score | Année |
|---------|-----------|--------|----------|-------|
| **RisQ** | 81% | - | 81% | 2014 |
| **ASPIRE** | 90% | - | 90% | 2021 |
| **HeartIt** | - | - | 81-98% | 2025 |
| **Sense2Quit** | - | - | **97.52%** ✓ | 2025 |
| **StopWatch** | 86% | 71% | 78% | 2019 |

**Objectif** : Atteindre 85-90% F1 en lab, 80-85% F1 en field (LOSO)

---

## 🔑 FEATURES DISCRIMINATIVES CLÉS

| Feature | Cigarette | Eating | Drinking | Phone |
|---------|-----------|--------|----------|-------|
| **Regularity score** | **0.7** ✓ | 0.3 | 0.3 | 0.1 |
| **Interval mean** | **45s** ✓ | 0.5s | 60s | N/A |
| **Dominant freq** | **0.022 Hz** ✓ | 1.5 Hz | 0.01 Hz | 0 Hz |
| **Pause duration** | **1.5s** ✓ | 0.4s | 3s | 120s |
| **Angular velocity** | **90°/s** ✓ | 200°/s | 80°/s | 40°/s |

**Différenciation clé** : Cigarette = **régulier** (autocorrelation >0.7), Eating/Drinking = **irrégulier**

---

## 🛠️ STACK TECHNIQUE

### Langage & Frameworks
- **Prototype** : Python 3.9+ (scikit-learn, pandas, numpy, scipy)
- **Production** : Swift (iOS/watchOS), Kotlin (Android/Wear OS)

### ML & Optimization
- **Training** : scikit-learn (Random Forest), XGBoost, TensorFlow/PyTorch (LSTM)
- **Deployment** : TensorFlow Lite (LiteRT 2024), CoreML (iOS)
- **Optimization** : Pruning (50%) + Quantization (int8) = 8× smaller

### Hardware Targets
- **Apple Watch Series 6+** : CoreML, Neural Engine (20-35ms inference)
- **Wear OS (Snapdragon 4100+)** : TFLite, NNAPI (35-50ms inference)
- **Garmin/Fitbit** : APIs limitées (non recommandé pour prototypage)

### Storage & Privacy
- **Local SQLite** : Encrypted (iOS Keychain, Android Keystore)
- **GDPR compliant** : Right to erasure, data minimization, no cloud
- **Model size** : 128 KB (int8) + Event data 700 KB/year < 6 MB total

---

## 📖 RÉFÉRENCES SCIENTIFIQUES (50+ papers)

### Physiologie
- [PMC 2024] Cardiovascular Effects of Smoking → +7-15 bpm nicotine
- [Nature 2021] Alcohol dose-dependent HR → 2+ verres augmentation
- [MDPI 2023] E-cigarette effects → +4 bpm, dissipe 1h

### Signal Processing & ML
- [RisQ 2014] Smoking gestures with inertial sensors → 81% F1
- [Sense2Quit 2025] Confounding resilient model → 97.52% F1
- [HeartIt 2025] HR pattern + accelerometer → 81-98% accuracy
- [CNN-LSTM 2024] Eating detection → 90.5% F1 multi-gesture

### Deployment
- [LiteRT 2024] TensorFlow Lite renamed, multi-framework support
- [CoreML WWDC22] Battery optimization for always-on ML
- [TinyML 2025] Energy-efficient object detection → 95% battery save

### Validation
- [HAR Validation 2024] LOSO vs K-fold → -13% gap (data leakage)
- [Field Study 2017] Lab 85% F1, Field 83% F1 → <5% gap
- [IRB Ethics 2022] Wearable informed consent → data ownership clarification

**Toutes les références avec liens dans chaque fichier respectif.**

---

## 🎯 NEXT STEPS

### Phase 1 — Prototypage (En cours)
- [x] Recherche scientifique (7 blocs validés)
- [x] Documentation complète (4,600+ lignes)
- [ ] Implémentation Python baseline (feature extraction + Random Forest)
- [ ] Test sur datasets publics (GeoLife + WESAD)

### Phase 2 — Collecte Données (1-2 semaines)
- [ ] Porter Apple Watch 7 jours
- [ ] Logger cigarettes manuellement (app mobile)
- [ ] Collecter GPS + accel + HR (SQLite)
- [ ] Valider qualité données (no missing, no artifacts)

### Phase 3 — Validation Lab (2-4 semaines)
- [ ] IRB approval (N=5-10 participants)
- [ ] Protocole : 6 cigarettes + confounding gestures (3h)
- [ ] Video ground truth (manual labeling)
- [ ] F1-score ≥ 85% (target)

### Phase 4 — Field Validation (4-8 semaines)
- [ ] N=15-30 participants, 7-14 jours
- [ ] Self-report + EMA reminders
- [ ] LOSO cross-validation
- [ ] F1-score ≥ 80% (target, real-world)

### Phase 5 — Production Deployment (2-4 semaines)
- [ ] Convert model → CoreML/TFLite
- [ ] Quantization int8 (4× size reduction)
- [ ] App watchOS/Wear OS (UI + notifications)
- [ ] OTA model update mechanism
- [ ] Monitor false positive rate (<2 per day)

---

## 📞 CONTACT & CONTRIBUTION

**Auteurs** : Sky × Claude Sonnet 4.5
**Date** : Février 2026
**License** : MIT (code), CC BY 4.0 (documentation)

**Repo GitHub** : https://github.com/sky1241/infernal-wheel/tree/master/trilateration

---

*"Le mycelium détecte par croissance, pas par force brute."*

**Documentation validée scientifiquement avec 50+ références — Février 2026**
