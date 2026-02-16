# DATASETS PUBLICS — PROTOTYPAGE & VALIDATION
*Données réelles pour tester les algorithmes avant collecte propre*

---

## POURQUOI UTILISER DES DATASETS PUBLICS

**Avantages** :
- Prototyper **sans attendre** (pas besoin de collecter 7 jours de données)
- Valider algorithmes sur **données réelles** (pas synthétiques)
- Comparer avec **baselines publiés** (benchmarks académiques)
- Identifier **problèmes** avant déploiement (faux positifs, edge cases)

**Ordre d'utilisation** (recommandé par ChatGPT) :
1. **Datasets publics** : prototyper stay points + clustering (GeoLife)
2. **Collecte propre** : 7 jours GPS + accel + HR (validation use case)
3. **Déploiement montre** : production avec update incrémental

---

## 1. GeoLife — GPS Mobility ✅

### Description

**Source** : Microsoft Research Asia
**Publication** : 2007-2012
**Sujets** : 182 utilisateurs
**Data** : 17,621 trajectoires, 1.2 million km, 48,000+ heures

**Format** : Fichiers `.plt` (lat, lon, alt, timestamp)

### Applications pour notre use case

- **Stay point detection** : tester fenêtre glissante + seuils (R, T_min)
- **DBSCAN clustering** : découvrir lieux significatifs (home, work, other)
- **Labelling temporel** : valider règles (nuit = maison, jour ouvré = bureau)
- **Baseline** : comparer notre pipeline vs papiers académiques (Zheng et al.)

### Download

| Source | URL | Format |
|--------|-----|--------|
| **Microsoft Download Center** | https://www.microsoft.com/en-us/download/details.aspx?id=52367 | ZIP officiel |
| **Kaggle** | https://www.kaggle.com/datasets/arashnic/microsoft-geolife-gps-trajectory-dataset | CSV préprocessé |
| **GitHub exemples** | https://github.com/jeffmur/geoLife | Code analyse |

### Structure données

```
GeoLife/
├── Data/
│   ├── 000/
│   │   └── Trajectory/
│   │       ├── 20081023025304.plt
│   │       ├── 20081024011907.plt
│   │       └── ...
│   ├── 001/
│   └── ...
└── User Guide.pdf
```

**Format `.plt`** :
```
Latitude,Longitude,0,Altitude,Days,Date,Time
39.984702,116.318417,0,492,39744.1201851852,2008-10-23,02:53:00
39.984683,116.31845,0,492,39744.1201967593,2008-10-23,02:53:05
...
```

### Quick start Python

```python
import pandas as pd
from pathlib import Path

def load_geolife_trajectory(plt_file):
    df = pd.read_csv(plt_file, skiprows=6, header=None,
                     names=['lat', 'lon', 'zero', 'alt', 'days', 'date', 'time'])
    df['timestamp'] = pd.to_datetime(df['date'] + ' ' + df['time'])
    return df[['lat', 'lon', 'alt', 'timestamp']]

# Charger tous les trajets d'un user
user_dir = Path('GeoLife/Data/000/Trajectory')
trajectories = [load_geolife_trajectory(f) for f in user_dir.glob('*.plt')]
```

### Références

1. **Zheng et al. (WWW 2009)** - "Mining Interesting Locations and Travel Sequences from GPS Trajectories"
   https://www.microsoft.com/en-us/research/publication/mining-interesting-locations-and-travel-sequences-from-gps-trajectories/

2. **User Guide officiel** - Microsoft Research
   https://www.microsoft.com/en-us/research/publication/geolife-gps-trajectory-dataset-user-guide/

---

## 2. WESAD — Wearable Stress & Affect Detection ✅

### Description

**Publication** : ACM ICMI 2018
**Sujets** : 15 participants
**Sensors** : Wrist + chest devices
**Modalités** :
- Blood Volume Pulse (BVP/PPG)
- Electrocardiogram (ECG)
- Electrodermal Activity (EDA/GSR)
- Electromyogram (EMG)
- Respiration
- Body temperature
- **3-axis accelerometer** ← utile pour nous
- **Heart rate** ← utile pour nous

**États labellisés** : neutral, stress, amusement

### Applications pour notre use case

- **HR baseline** : mesurer HR repos (neutral state)
- **HR variability** : tester détection changements (stress vs neutral)
- **Accelerometer patterns** : mouvements quotidiens vs gestes spécifiques
- **Fusion capteurs** : valider pipeline HR + accel

⚠️ **Note** : Pas de smoking/drinking dans WESAD, mais utile pour tester **fusion HR + accel** sur données réelles.

### Download

| Source | URL | Accès |
|--------|-----|-------|
| **UCI ML Repository** | https://archive.ics.uci.edu/ml/datasets/WESAD+(Wearable+Stress+and+Affect+Detection) | Public |
| **Direct Download** | https://uni-siegen.sciebo.de/s/pYjSgfOVs6Ntahr/download | ZIP 1.8GB |
| **Kaggle** | https://www.kaggle.com/datasets/orvile/wesad-wearable-stress-affect-detection-dataset | Préprocessé |
| **GitHub repos** | https://github.com/WJMatthew/WESAD | Code exemples |

### Structure données

```
WESAD/
├── S2/
│   ├── S2.pkl          # Python pickle (pandas DataFrame)
│   ├── S2_readme.txt
│   └── S2_quest.csv    # Questionnaire
├── S3/
└── ...
```

**Format pickle** : dictionnaire avec clés `'signal'`, `'label'`, `'subject'`

### Quick start Python

```python
import pickle
import numpy as np

# Charger données sujet 2
with open('WESAD/S2/S2.pkl', 'rb') as f:
    data = pickle.load(f, encoding='latin1')

# Extraire HR et accel (wrist device)
chest = data['signal']['chest']
wrist = data['signal']['wrist']

hr = wrist['BVP']      # Blood Volume Pulse (calculer HR)
accel = wrist['ACC']   # 3-axis accelerometer
labels = data['label'] # 0=not, 1=baseline, 2=stress, 3=amusement

# Sampling rates
fs_bvp = 64 Hz
fs_acc = 32 Hz
```

### Références

3. **Schmidt et al. (ICMI 2018)** - "Introducing WESAD, a Multimodal Dataset for Wearable Stress and Affect Detection"
   https://dl.acm.org/doi/10.1145/3242969.3242985
   → Paper original avec baseline results

---

## 3. PPG-DaLiA — Heart Rate + Motion ✅

### Description

**Publication** : Sensors 2019
**Sujets** : 15 participants
**Durée** : 35+ heures totales
**Sensors** :
- Photoplethysmography (PPG) wrist
- 3-axis accelerometer wrist
- ECG chest (ground truth)

**Activités** : 8 daily life activities (sitting, walking, cycling, driving, lunch, etc.)

### Applications pour notre use case

- **HR motion compensation** : tester estimation HR pendant mouvement
- **Activity recognition** : distinguer activités (utile pour filtrer transit vs stay)
- **PPG quality** : identifier quand HR est fiable vs bruité

⚠️ **Note** : Pas de smoking, mais excellent pour **motion artifact compensation** (crucial pour HR fiable).

### Download

| Source | URL |
|--------|-----|
| **UCI ML Repository** | https://archive.ics.uci.edu/ml/datasets/PPG-DaLiA |
| **GitHub analysis** | https://github.com/IlyessAgg/PPG-DaLiA-Dataset-Analysis |

### Structure données

```
PPG_DaLiA/
├── S1_E1.pkl
├── S1_E2.pkl
├── ...
└── README.txt
```

### Quick start Python

```python
import pickle

with open('PPG_DaLiA/S1_E1.pkl', 'rb') as f:
    data = pickle.load(f)

ppg = data['PPG']           # Wrist PPG signal
accel = data['Accelerometer'] # 3-axis accel
ecg = data['ECG']           # Ground truth
activity = data['Activity'] # Activity labels
```

### Références

4. **Reiss et al. (Sensors 2019)** - "Deep PPG: Large-Scale Heart Rate Estimation with Convolutional Neural Networks"
   https://www.mdpi.com/1424-8220/19/14/3079
   → Paper + CNN baseline pour HR estimation

---

## 4. Smoking Detection — PACT2.0 ⚠️

### Description

**Source** : Recherche académique (Cole et al., multiple papers)
**Data** : 871 heures IMU, 35 fumeurs modérés-heavy
**Sensors** : 3-axis accelerometer wrist

**Contenu** :
- 463 lighting events
- 443 cigarettes
- Controlled (1.5-2h) + free-living (~24h)

### Problème : Accès non public

❌ **Pas disponible en téléchargement direct** (contrairement à GeoLife/WESAD/PPG-DaLiA)

**Options** :
1. **Contacter auteurs** : demander accès dataset (standard académique)
2. **Utiliser papers** : implémenter leurs features/méthodes sur nos données
3. **Collecter propre** : 7 jours labellisés manuellement (nécessaire de toute façon)

### Références disponibles

5. **Cole et al. (JMIR 2017)** - "Detecting Smoking Events Using Accelerometer Data Collected Via Smartwatch Technology"
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/
   → 81% accuracy, features + SVM

6. **PACT2.0 (2019)** - "Personal Automatic Cigarette Tracker 2.0"
   → 86% F1-score hand-to-mouth, 98% F1-score smoking event

---

## 5. Autres Datasets Utiles

### MDC (Nokia)

**Description** : 185 users, 2 ans, GPS + accel + Bluetooth
**Utilité** : Fusion GPS + mouvement (comme notre use case)
**Accès** : https://www.idiap.ch/dataset/mdc

### Reality Mining (MIT)

**Description** : 100 users, 9 mois, Bluetooth + cell towers + GPS
**Utilité** : Social context + location patterns
**Accès** : http://realitycommons.media.mit.edu/realitymining.html

### Cabspotting

**Description** : 500 taxis San Francisco, GPS trajectoires
**Utilité** : Tester scalabilité algorithmes (large-scale)
**Accès** : http://cabspotting.org/

---

## PLAN D'UTILISATION RECOMMANDÉ

### Phase 1 — Prototypage GPS (1-2 semaines)

**Dataset** : GeoLife

1. Télécharger GeoLife (user 000-009, ~10 users pour commencer)
2. Implémenter stay point detection (fenêtre glissante)
3. Implémenter DBSCAN clustering
4. Labelling home/work (règles temporelles)
5. **Métriques** : nombre lieux détectés, précision labelling vs ground truth

**Validation** : Comparer résultats avec Zheng et al. (WWW 2009)

### Phase 2 — Fusion HR + Accel (1-2 semaines)

**Datasets** : WESAD + PPG-DaLiA

1. Télécharger WESAD (sujet S2-S5, ~4 sujets)
2. Extraire HR + accel (wrist device)
3. Tester détection changements HR (neutral → stress)
4. **PPG-DaLiA** : tester HR estimation pendant mouvement
5. **Métriques** : précision HR, robustesse au mouvement

### Phase 3 — Collecte Propre (1 semaine)

**Objectif** : Données smoking/drinking labellisées

1. Porter smartwatch 7 jours
2. Logger manuellement : timestamp chaque cigarette/verre
3. Collecter : GPS (1/5min) + accel (50Hz) + HR (1Hz)
4. Format : CSV ou SQLite
5. **Métriques** : 50+ événements cigarette, 30+ événements alcool

### Phase 4 — Training ML (1-2 semaines)

**Datasets** : Collecte propre + (optionnel) PACT2.0 si accès

1. Feature engineering (15 features : HR, accel, GPS, time)
2. Split train/test (70/30 ou cross-validation temporelle)
3. Baseline : Random Forest, XGBoost
4. Advanced : LSTM si assez données
5. **Métriques** : précision, F1-score, faux positifs/jour

---

## SCRIPTS UTILES

### Téléchargement automatique

```bash
# GeoLife
wget https://download.microsoft.com/download/F/4/8/F4894AA5-FDBC-481E-9285-D5F8C4C4F039/Geolife%20Trajectories%201.3.zip
unzip "Geolife Trajectories 1.3.zip"

# WESAD (nécessite credentials UCI)
# Ou direct link (attention 1.8GB)
wget https://uni-siegen.sciebo.de/s/pYjSgfOVs6Ntahr/download -O WESAD.zip
unzip WESAD.zip
```

### Conversion formats

```python
# GeoLife PLT → CSV
import pandas as pd
from pathlib import Path

def convert_plt_to_csv(input_dir, output_file):
    all_data = []
    for plt_file in Path(input_dir).rglob('*.plt'):
        df = pd.read_csv(plt_file, skiprows=6, header=None,
                        names=['lat', 'lon', 'zero', 'alt', 'days', 'date', 'time'])
        df['user'] = plt_file.parent.parent.parent.name
        df['trajectory'] = plt_file.stem
        all_data.append(df)

    combined = pd.concat(all_data, ignore_index=True)
    combined.to_csv(output_file, index=False)
    print(f"Saved {len(combined)} points to {output_file}")

convert_plt_to_csv('GeoLife/Data', 'geolife_all.csv')
```

---

## RÉFÉRENCES COMPLÈTES

### GPS Mobility

1. **GeoLife Dataset** - Microsoft Research
   https://www.microsoft.com/en-us/download/details.aspx?id=52367

2. **Zheng et al. (WWW 2009)** - Mining Interesting Locations
   https://www.microsoft.com/en-us/research/publication/mining-interesting-locations-and-travel-sequences-from-gps-trajectories/

3. **Ashbrook & Starner (2003)** - Using GPS to Learn Significant Locations
   → Premier papier significant locations

### Wearable Physiological

4. **WESAD** - UCI ML Repository
   https://archive.ics.uci.edu/ml/datasets/WESAD+(Wearable+Stress+and+Affect+Detection)

5. **Schmidt et al. (ICMI 2018)** - Introducing WESAD
   https://dl.acm.org/doi/10.1145/3242969.3242985

6. **PPG-DaLiA** - UCI ML Repository
   https://archive.ics.uci.edu/ml/datasets/PPG-DaLiA

7. **Reiss et al. (Sensors 2019)** - Deep PPG
   https://www.mdpi.com/1424-8220/19/14/3079

### Smoking Detection

8. **Cole et al. (JMIR 2017)** - Smartwatch Accelerometer Detection
   https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/

9. **PACT2.0** - Personal Automatic Cigarette Tracker
   → Dataset non public, contacter auteurs

---

*"Prototyper sur données réelles avant de collecter. Valider avant de déployer."*

**Datasets validés — Février 2026**
Sky × Claude
