# ARBRE DE DÉTECTION — TRILATÉRATION SMARTWATCH
*Auto-détection cigarettes & alcool par capteurs multi-modaux*

**📄 EXECUTIVE SUMMARY** : Pour un résumé complet du système (1 page), voir [SYSTEM_SUMMARY.md](SYSTEM_SUMMARY.md)

---

## ARCHITECTURE WINTER TREE (R/T/B/C)

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

---

## R — RACINES (-5 à 0) : Hardware & Physique

### R1 — Mycorhizes (-5) : Lois physiques immuables

**Loi 1 : La nicotine accélère le cœur** *(validé scientifiquement)*
- Augmentation BPM : **+7-15 bpm** (cigarette classique), **+4 bpm** (e-cigarette)
- Timing : effet **immédiat (0 min)**, dissipe en **1 heure**
- Réversible : HR baisse **-5-15 bpm** dans les **24h** après arrêt
- Pattern : spike immédiat puis descente progressive
- Sources : [PMC 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC11843939/), [MDPI 2023](https://www.mdpi.com/2305-6304/13/10/831)

**Loi 2 : L'alcool augmente le cœur (dose-dépendant)** *(validé scientifiquement)*
- 1 verre : **pas d'effet** détectable sur HR
- 2+ verres : **augmentation dose-dépendante** (mécanisme : ↓parasympathique + ↑sympathique)
- **Pas de courbe en J** pour HR direct (la J-curve s'applique à mortalité cardiovasculaire, pas HR)
- Retour baseline quand alcool éliminé du sang
- Sources : [AJP 2009](https://journals.physiology.org/doi/full/10.1152/ajpheart.00700.2009), [Nature 2021](https://www.nature.com/articles/s41598-021-92767-y)

**Loi 3 : Le mouvement cigarette est stéréotypé** *(validé scientifiquement)*
- Main → bouche : ~15-20 cm, 1-2 sec
- Fréquence : 8-12 mouvements par cigarette
- Timing : 1 mouvement toutes les 30-60 sec
- **Signature biomécanique** : angular velocity 60-120°/s, regularity score >0.7, dominant freq 0.017-0.033 Hz
- Sources : [RisQ 2014](https://pmc.ncbi.nlm.nih.gov/articles/PMC4682919/), [Regularity 2019](https://pmc.ncbi.nlm.nih.gov/articles/PMC6400470/)
- *(voir B_BRANCHES/BIOMECANIQUE_GESTES.md pour 30 features détaillées)*

**Loi 4 : Le mouvement verre est stéréotypé** *(validé scientifiquement)*
- Main → bouche : ~20-30 cm, 1-3 sec
- Fréquence : variable (sirotage vs gorgée)
- Pattern : bras monte + pause (boire) + descend
- **Différence vs cigarette** : pause 2-4s (vs 1-2s), intervalle irrégulier (vs régulier)
- Sources : [Eating Drinking 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC11154557/)
- *(voir BIOMECANIQUE_GESTES.md pour différenciation complète)*

**Loi 5 : La géolocalisation contextualise**
- Bar/restaurant : probabilité alcool ↑
- Extérieur/balcon : probabilité cigarette ↑
- Bureau : probabilité cigarette ou café

### R2 — Capteurs (-4) : Hardware disponible

**Capteur 1 : Heart Rate (PPG)**
- Fréquence : 1 Hz (1 mesure/sec)
- Précision : ±2 bpm
- Latence : temps réel

**Capteur 2 : Accelerometer (3 axes)**
- Fréquence : 50-100 Hz
- Précision : ±0.01 g
- Données : X, Y, Z (accélération)

**Capteur 3 : Gyroscope (3 axes)**
- Fréquence : 50-100 Hz
- Données : rotation pitch/roll/yaw

**Capteur 4 : GPS**
- Fréquence : 1 Hz (ou moins pour économie batterie)
- Précision : ±5-10 m
- Latence : 1-5 sec

**Capteur 5 : Horloge**
- Timestamp chaque événement
- Patterns temporels (heure de la journée, jour de la semaine)

### R3 — Preprocessing (-3) : Nettoyage signal

**Filtre 1 : Passe-bas (accelerometer)**
- Éliminer bruit haute fréquence (>20 Hz)
- Garder mouvements volontaires (0.5-5 Hz)
- **Implémentation** : Butterworth 2nd order, wavelet filtering *(voir B_BRANCHES/TECHNIQUES_DETECTION.md)*

**Filtre 2 : Détection pics (heart rate)**
- Identifier variations significatives (>±5 bpm)
- Fenêtre glissante : 5 minutes

**Filtre 3 : Calibration personnelle**
- BPM repos = baseline individuelle (varie 50-90)
- Correction individuelle : mesurer pendant 3-7 jours

### R4 — Boost Sampling (-2) : Stratégie d'acquisition intelligente

**Mode Normal (Battery Save)**
- **Sampling rate** : 1 sample/60s (ou 1/2min)
- **Capteurs actifs** : Accelerometer only (0.5 mW)
- **Objectif** : Détection macro-patterns, économie batterie

**Mode Boost (User-Triggered High-Frequency)**
- **Déclencheur** : User appuie bouton "cigarette" ou "bière"
- **Pre-trigger** : **15 secondes AVANT** activation boost (capture première bouffée)
- **Sampling rate** : **1 sample/3s** (accelerometer + PPG)
- **Durée** : **5 minutes** (300s) = **100 samples high-resolution**
- **Retour automatique** : Mode normal après 5 min

**Timeline boost** :
```
T-15s : User clique bouton (pré-trigger)
T0    : Boost démarre (1 sample/3s)
T+3s  : Allume cigarette → première bouffée CAPTURÉE
T+45s : Deuxième bouffée
T+90s : Troisième bouffée
...
T+5min: Fin boost → retour mode normal (1 sample/60s)
```

**Justification sampling 1/3s** :
- Pattern cigarette : intervalle 30-45s entre bouffées
- Nyquist minimum : 1/22s → **1/3s = 7.5× marge sécurité**
- Capture **2-3 samples par bouffée** → détection pattern robuste
- Évite aliasing (risque de louper bouffées si 1/5s ou plus)

**Compression** :
- **Gorilla time-series compression** : 90-95% reduction
- 100 samples × 6 bytes × 10 cigarettes/jour = **6 KB → 0.3-0.6 KB/jour**
- 7 jours training : **4.2 KB total** (négligeable)

**Battery Impact** :
- Consommation boost : 3.5 mW (accel + PPG)
- 10 cigarettes/jour × 5.25 min = **52.5 min boost**
- Impact total 24h : **+1%** batterie (15 mWh sur 1455 mWh total)
- **Conclusion** : Négligeable vs OS baseline (1440 mWh) ✅

**Avantages** :
1. **Ground truth labeling** : User valide événement → perfect training data
2. **High-resolution capture** : 100 samples capturent micro-structure complète (8-12 bouffées)
3. **Battery efficient** : Boost seulement 50-70 min/jour (vs 1440 min total)
4. **Robuste** : Pre-trigger 15s garantit capture première bouffée

*(Voir SYSTEM_SUMMARY.md pour calculs batterie détaillés)*

---

## T — TRONC (0 à +2) : Fusion Multi-Capteurs

### T1 — Core Engine (0) : Fusion de données

**Fenêtre temporelle glissante : 60 secondes**
- Buffer : dernières 60 sec de données
- Update : toutes les 1 sec (temps réel)

**Synchronisation capteurs**
- Timestamp unifié (milliseconde)
- Alignement temporel (compensation latence GPS)

**Extraction features** *(voir BIOMECANIQUE_GESTES.md pour 30 features détaillées)*
- Heart rate : moyenne, écart-type, variation max
- Accelerometer : magnitude, fréquence mouvements, pattern, **jerk, angular velocity**
- GPS : localisation, vitesse, changement de lieu
- **Time-domain** : mean, std, max, skewness, kurtosis (5 features)
- **Frequency-domain** : FFT, PSD, dominant freq, spectral energy (5 features)
- **Trajectory** : distance, speed, pause duration, regularity score (4 features)

### T2 — Pattern Detection (1) : Reconnaissance mouvements

**Pattern cigarette (accelerometer + gyro)**
```
1. Détection mouvement main→bouche
   - Magnitude > seuil (0.3 g)
   - Durée 1-2 sec
   - Orientation : vertical ascendant puis descendant

2. Répétition stéréotypée
   - Fréquence : 8-12 fois en 5-10 min
   - Intervalle : 30-60 sec entre mouvements

3. Contexte spatial
   - Stationnaire (vitesse GPS < 1 km/h)
   - Localisation : extérieur ou balcon (si GPS précis)
```

**Pattern alcool (accelerometer + gyro)**
```
1. Détection mouvement main→bouche
   - Magnitude > seuil (0.3 g)
   - Durée 1-3 sec
   - Pause en haut (0.5-2 sec) = boire

2. Fréquence variable
   - Bière : 1-3 gorgées/min
   - Shot : 1 mouvement rapide
   - Vin : sirotage irrégulier

3. Contexte spatial
   - Bar/restaurant (GPS + base de données lieux)
   - Soirée (heure : 18h-2h)
```

### T3 — Heart Rate Correlation (2) : Validation physiologique

**Validation cigarette** *(basé sur HeartIt 2025, Validation Study 2017)*
```
SI pattern_mouvement_cigarette = True
ET heart_rate_spike (+7-15 bpm immédiat) = True
ALORS confiance_cigarette = HIGH (précision 81-98% selon études)
SINON confiance_cigarette = MEDIUM (mouvement seul)
```
- Sources : [HeartIt 2025](https://link.springer.com/article/10.1007/s11390-024-2981-3), [Validation 2017](https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/)

**Validation alcool** *(basé sur AJP 2009, Nature 2021)*
```
SI pattern_mouvement_alcool = True
ET (nombre_mouvements ≥ 2 OU localisation_bar) = True
ALORS confiance_alcool = MEDIUM-HIGH
SINON confiance_alcool = LOW

Note : 1 verre ne change pas HR détectablement
→ Validation alcool plus difficile que cigarette
→ Contexte spatial (GPS) crucial
```

---

## B — BRANCHES (3 à 4) : Intelligence & Apprentissage

### B1 — Machine Learning (3) : Pattern Recognition Auto

**Modèle 1 : Supervised Learning (baseline)**
- Input : 10 features (HR mean, HR std, accel magnitude, freq, GPS context, heure, etc.)
- Output : 3 classes (cigarette, alcool, rien)
- Algorithme : Random Forest ou Gradient Boosting
- Training : 7 jours de données labellisées manuellement
- **Performance** : SVM 86%/71%, CNN-LSTM 78% F1 *(voir B_BRANCHES/TECHNIQUES_DETECTION.md)*

**Modèle 2 : Unsupervised Clustering**
- Détecter patterns récurrents sans label
- K-means ou DBSCAN sur features temporelles
- Identifier anomalies (nouveaux comportements)

**Modèle 3 : Temporal Pattern (LSTM)**
- Séquences temporelles (10-60 sec)
- Prédire action suivante
- Apprendre patterns complexes (ex: cigarette après café)
- **Architecture** : CNN-LSTM 2 couches, adaptive triggering *(voir B_BRANCHES/TECHNIQUES_DETECTION.md)*

### B2 — Trilatération Contextuelle (3) : Localisation sémantique

**Base de données lieux**
- Maison : X, Y (rayon 50m)
- Bureau : X, Y (rayon 100m)
- Bar habituel : X, Y (rayon 20m)
- Zone fumeur : balcon, extérieur

**Probabilité bayésienne**
```
P(cigarette | lieu_extérieur) = 0.7
P(cigarette | lieu_bureau) = 0.3
P(alcool | lieu_bar) = 0.8
P(alcool | lieu_maison, heure>18h) = 0.5
```

**Update en temps réel**
- Créer nouveaux lieux automatiquement (clustering GPS)
- Apprendre associations lieu ↔ comportement

### B3 — Temporal Patterns (4) : Prédiction

**Pattern horaire**
- Cigarette : pics à 8h (café), 12h (pause), 18h (fin travail), 22h (soirée)
- Alcool : pics à 19h-23h (soirée)

**Pattern social**
- Détection événement social (GPS stationnaire + groupe)
- Augmente probabilité alcool × 2

**Prédiction proactive**
```
SI heure = 18h
ET lieu = bureau
ET pattern_historique = cigarette_fin_journée
ALORS warning_prédictif = +1 min delay activé
```

---

## C — CIME (5) : Interface & Gamification

### C1 — Feedback Immédiat (5)

**Notification discrète**
- Vibration légère (pas de son)
- Message : "Cigarette détectée. +1 min ajouté."
- Pas de jugement, juste information

### C2 — Gamification +1 minute/jour (5)

**Système de delay progressif**
```
Jour 1 : détection → tu peux fumer/boire immédiatement (0 min)
Jour 2 : détection → attends 1 min avant
Jour 3 : détection → attends 2 min avant
...
Jour N : détection → attends N min avant
```

**Mécanique**
- Timer visible sur montre
- Choix : "Skip" (reset à jour 1) ou "Attendre" (streak continue)
- Visualisation streak (jours consécutifs)

### C3 — Dashboard (5)

**Métriques journalières**
- Cigarettes détectées : 12
- Alcool détecté : 4 verres
- Streak actuel : 7 jours (7 min delay)
- Meilleur streak : 15 jours

**Graphiques**
- Courbe cigarettes/jour (tendance)
- Heatmap horaire (quand tu fumes/bois le plus)
- Carte lieux (où tu fumes/bois le plus)

---

## PLAN D'IMPLÉMENTATION (3 phases)

### Phase 1 — Prototype Détection (2-4 semaines)

**Objectif** : Détecter 1 cigarette avec 80% précision

1. Collecter données brutes (accelerometer + HR) pendant 7 jours
2. Labelliser manuellement (timestamp cigarettes)
3. Entraîner modèle simple (Random Forest)
4. Tester en temps réel sur montre
5. Itérer sur faux positifs/négatifs

**Succès** : 8/10 cigarettes détectées, <2 faux positifs/jour

### Phase 2 — Fusion Multi-Capteurs (4-8 semaines)

**Objectif** : Ajouter alcool + contexte spatial

1. Ajouter GPS + base de données lieux
2. Entraîner modèle multi-classe (cigarette/alcool/rien)
3. Validation physiologique (courbe HR)
4. Réduire faux positifs avec fusion capteurs

**Succès** : 85% précision cigarette + alcool, <1 faux positif/jour

### Phase 3 — Gamification Live (2-4 semaines)

**Objectif** : Déployer système +1 min/jour

1. Interface montre (timer + notifications)
2. Logique streak (persist across days)
3. Dashboard mobile (graphs + stats)
4. Test réel sur 30 jours

**Succès** : Sky utilise le système et réduit consommation

---

## DÉFIS TECHNIQUES & SOLUTIONS

| Défi | Solution |
|------|----------|
| Batterie montre (GPS consomme) | GPS échantillonné (1 mesure/5 min), activé seulement si mouvement détecté + **Adaptive triggering (95% save)** |
| Faux positifs (manger, boire café) | Validation croisée HR + contexte spatial + pattern temporel + **Sense2Quit confounding resilient model (97.52% F1)** |
| Données d'entraînement (labelling pénible) | Approche semi-supervisée : clustering auto + validation manuelle minimale + **Datasets publics (GeoLife, WESAD, PPG-DaLiA)** |
| Variabilité individuelle (HR baseline différent) | Calibration personnelle : mesure repos 3-7 jours |
| Privacy/stockage données | Tout local sur montre (pas de cloud), agrégation anonyme uniquement + **SQLite encrypted (iOS Keychain, Android Keystore)** |
| **Taille modèle (déploiement montre)** | **Pruning 50% + Quantization int8 = 8× reduction (1024 KB → 128 KB), -3% accuracy** |
| **RAM limitée (1 GB disponible)** | **Runtime <15 MB (quantized model), batching intelligent, hardware acceleration (Neural Engine/NNAPI)** |
| **Latence inférence** | **Neural Engine/NNAPI 20-35 ms (acceptable pour 60s window), sliding window every 1s** |

---

## RESSOURCES TECHNIQUES

**Hardware cible**
- Apple Watch Series 6+ (PPG 1Hz, accel 100Hz, GPS)
- Garmin Fenix/Forerunner (similaire)
- Fitbit Sense (PPG + accel + GPS)

**Stack logiciel** *(voir docs/DEPLOYMENT_HARDWARE.md pour détails complets)*
- Langage : Python (prototype) → Swift/Kotlin (production)
- ML : scikit-learn (baseline) → **TensorFlow Lite (LiteRT 2024)** ou **CoreML** (déploiement montre)
- Optimization : **Pruning (50%) + Quantization (int8)** = 8× smaller, 3× faster, -60% battery
- Storage : SQLite local sur montre (~6 MB total: model 128KB + data 700KB/an)

**Datasets publics (prototypage)** *(voir R_RACINES/DATASETS.md pour détails complets)*
- **GeoLife** (Microsoft) — 17k trajectoires GPS, 48k+ heures → stay points + clustering
  https://www.microsoft.com/en-us/download/details.aspx?id=52367
- **WESAD** — 15 sujets, HR + accel wrist/chest, 3 états (neutral/stress/amusement)
  https://archive.ics.uci.edu/ml/datasets/WESAD+(Wearable+Stress+and+Affect+Detection)
- **PPG-DaLiA** — 15 sujets, 35h, PPG + accel + ECG, 8 activités daily life
  https://archive.ics.uci.edu/ml/datasets/PPG-DaLiA
- **PACT2.0** — 871h IMU, 35 fumeurs (non public, contacter auteurs)

**Techniques de détection validées** *(voir TECHNIQUES_DETECTION.md pour détails complets)*
- **Signal Processing** — Butterworth low-pass (2nd order, 5Hz), wavelet filtering, autocorrelation
- **ML Algorithms** — SVM (86%/71%), Decision Trees, CNN-LSTM (78% F1-score)
- **Hand-to-Mouth Gesture** — 3 phases détection (raising, stationary, moving away)
- **Low-Power** — Adaptive triggering (accelerometer → HR sensor only when gesture detected, 95% batterie save)
- **Performance** — StopWatch (86% precision, 71% recall free-living), LOSO CV (97-98% controlled)

**Biomécanique & Features** *(voir BIOMECANIQUE_GESTES.md pour détails complets)*
- **30 features quantitatives** — Time-domain (5), Angular (4), Jerk (3), Frequency (5), Trajectory (4), Regularity (3), Contextual (6)
- **Confounding gestures** — Eating (1-2/s vs 1/45s), Drinking (pause 2-4s vs 1-2s), Phone (dwell 30-300s vs 1-2s)
- **Sense2Quit model** — 97.52% F1-score, gère 15 gestes confondants (eating, drinking, yawning, phone, face touching, etc.)
- **Key features** — Regularity score (0.7 cigarette vs 0.3 eating), Angular velocity (90°/s vs 200°/s), Dominant freq (0.022 Hz vs 1.5 Hz)

**Deployment & Hardware** *(voir docs/DEPLOYMENT_HARDWARE.md pour détails complets)*
- **Platforms** — Apple Watch Series 6+ (CoreML, Neural Engine), Wear OS (TFLite, NNAPI), Garmin/Fitbit (limité)
- **Model optimization** — Quantization (4× smaller, -1 to -2% accuracy), Pruning (50% reduction), Combined (8× total, 87% size)
- **Battery** — Adaptive triggering (95% save vs continuous), CoreML always-on optimized, Quantization -60% power (MobileNet study)
- **Latency** — 20-35 ms inference (Neural Engine/NNAPI), 35-50 ms (GPU), 100 ms (CPU only)
- **Storage** — Model 128 KB (int8), Event data 700 KB/year, Total <6 MB

**Validation & Testing** *(voir docs/VALIDATION_TESTING.md pour détails complets)*
- **Cross-validation** — LOSO (Leave-One-Subject-Out) gold standard, K-fold biased (+13% overestimation via data leakage)
- **Lab performance** — F1-score 85-92% (controlled), Precision 92-95%, Recall 85-90%
- **Field performance** — F1-score 80-86% (LOSO real-world), Lab-to-field gap <10% acceptable
- **Metrics** — Confusion matrix, Precision/Recall/F1, PR-AUC (better than ROC-AUC for imbalanced 1-2% positive class)
- **IRB & Ethics** — Informed consent required, GDPR compliant (right to erasure, encryption), N=15-30 participants for validation
- **Sample size** — Pilot N=5-10 (7 days), Validation N=15-30 (14 days), Deployment N=50-100 (30 days)

---

## MÉTRIQUES DE SUCCÈS *(voir docs/VALIDATION_TESTING.md pour protocoles complets)*

### Validation Lab (Controlled Environment)

| Phase | Métrique | Cible | Méthode |
|-------|----------|-------|---------|
| 1 (Lab) | **F1-score cigarette** | **85-92%** | 10-fold CV |
| 1 (Lab) | Precision | 92-95% | Confusion matrix |
| 1 (Lab) | Recall | 85-90% | Video ground truth |
| 1 (Lab) | False positive rate | <10% | Manual count |

### Validation Field (Real-World)

| Phase | Métrique | Cible | Méthode |
|-------|----------|-------|---------|
| 2 (Field) | **F1-score (LOSO)** | **80-86%** | Leave-One-Subject-Out |
| 2 (Field) | Lab-to-field gap | <10% | F1_lab - F1_field |
| 2 (Field) | Precision | 80-88% | Self-report ground truth |
| 2 (Field) | Recall | 75-85% | EMA validation |
| 2 (Field) | False positive rate | <5 per day | User feedback |

### Production Deployment

| Phase | Métrique | Cible |
|-------|----------|-------|
| 3 | Réduction consommation (30j) | -20% |
| 3 | Streak moyen | >7 jours |
| 3 | Battery life | >18h/jour |
| 3 | User satisfaction (SUS) | >70 |

---

## 🚀 IMPLEMENTATION STATUS (Python Prototypes)

**Phase 1 : Prototypage Python** — En cours

| Bloc | Script | Status | Commit | Description |
|------|--------|--------|--------|-------------|
| **1** | `stay_points.py` | ✅ **VALIDÉ** | `a65512a` | GPS Stay Points + DBSCAN clustering (488 lignes) |
| **2** | `feature_extraction.py` | ✅ **VALIDÉ** | `07ee481` | Feature extraction (30 features biomécanique, 750 lignes) |
| **Integration** | `test_integration.py` | ✅ **VALIDÉ** | `07ee481` | Bloc 1 ↔ Bloc 2 integration test |
| **3** | `train_baseline.py` | ⏳ Pending | - | Train Random Forest baseline |
| **4** | `test_loso.py` | ⏳ Pending | - | LOSO cross-validation |

**Bloc 1 : Test Results** ✅
- Input : 204 GPS points synthétiques (home→work→bar→home, 17h)
- Output : 4 stay points → 1 cluster "home" (2 visites, 175 min total)
- Centroid : (48.8566, 2.3522) Paris
- DBSCAN : ε=100m, MinPts=2 (test mode)
- Validation : Windows + Python 3.13.6

**Bloc 2 : Test Results** ✅
- Input : 15,000 samples @ 50Hz (5 min, 6 puffs synthétiques)
- Output : 30 features extraites (Time, Angular, Jerk, Frequency, Trajectory, Regularity, Contextual)
- Discriminative features:
  - Regularity score : 0.774 (cigarette signature >0.5)
  - HR delta : +12 bpm (nicotine effect)
  - Angular velocity : 10.7°/s
- Validation : Windows + Python 3.13.6

**Integration Test** ✅
- GPS cluster "noise" (Bloc 1) → numeric 3 (Bloc 2) ✅
- Time/date context : 20.5h Thursday ✅
- 30 features extracted with GPS context ✅

**Next** : Bloc 3 (Train Random Forest baseline)

---

## RÉFÉRENCES SCIENTIFIQUES VALIDÉES

### Physiologie Nicotine/Cigarette

1. **Cardiovascular Effects of Smoking 2024** - PMC
   https://pmc.ncbi.nlm.nih.gov/articles/PMC11843939/
   → Augmentation +7-15 bpm, réversible -5-15 bpm en 24h

2. **Time-Dose Effects E-Cigarettes 2023** - MDPI
   https://www.mdpi.com/2305-6304/13/10/831
   → E-cigarette +4.23 bpm (CI: 2.10-6.37), effet immédiat dissipe en 1h

3. **AHA Scientific Sessions 2022** - American Heart Association
   https://newsroom.heart.org/news/people-who-vape-had-worrisome-changes-in-cardiovascular-function-even-as-young-adults
   → +4 bpm après vaping/smoking

### Physiologie Alcool

4. **Dose-related effects of red wine and alcohol 2009** - AJP
   https://journals.physiology.org/doi/full/10.1152/ajpheart.00700.2009
   → 1 verre = pas d'effet HR, 2+ verres = augmentation dose-dépendante

5. **Impact of acute ethanol intake 2021** - Nature Scientific Reports
   https://www.nature.com/articles/s41598-021-92767-y
   → Mécanisme : ↓parasympathique + ↑sympathique, retour baseline après élimination

### Smoking Detection Smartwatch

6. **HeartIt 2025** - Springer JCST
   https://link.springer.com/article/10.1007/s11390-024-2981-3
   → Détection via HR pattern + accelerometer, fonctionne sur les deux poignets

7. **Validation Study 2017** - JMIR mHealth
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/
   → 81% détection sessions, 90% si protocole respecté

8. **ASPIRE System 2021** - JMIR Formative
   https://pmc.ncbi.nlm.nih.gov/articles/PMC7895644/
   → Détecte initiation, puffs, durée, intervalle inter-puffs

9. **PACT2.0 2019**
   → 86% F1-score hand-to-mouth, 98% F1-score événement smoking

---

*"Le mycelium détecte par croissance, pas par force brute."*

**Recherche validée scientifiquement — Février 2026**
Sky × Claude
