# MOUVEMENTS RÉPÉTITIFS — SIGNATURE BIOMÉCANIQUE
*Pourquoi fumer et boire sont détectables par accelerometer*

---

## LE PRINCIPE FONDAMENTAL

**Le cerveau humain optimise les gestes répétés.**

Quand tu fais la même action 100 fois (porter cigarette à la bouche, lever un verre), ton cerveau crée un **pattern moteur automatique** :
- Même trajectoire
- Même timing
- Même amplitude
- Même séquence musculaire

**C'est stéréotypé. Donc c'est détectable.**

---

## SIGNATURE CIGARETTE

### Le mouvement complet (15-20 secondes)

```
1. PHASE SAISIR (0-2 sec)
   - Main descend vers poche/table
   - Accélération verticale descendante (-0.5 g)
   - Saisie cigarette (pause brève <0.5 sec)

2. PHASE PORTER À LA BOUCHE (2-4 sec)
   - Main monte vers visage
   - Accélération verticale ascendante (+0.8 g)
   - Courbe : accélération puis décélération
   - Distance : 15-20 cm
   - Durée : 1-2 sec

3. PHASE INHALER (4-6 sec)
   - Main stationnaire près bouche
   - Magnitude faible (<0.1 g)
   - Pause : 1-2 sec (aspiration)

4. PHASE RETIRER (6-8 sec)
   - Main redescend
   - Accélération verticale descendante (-0.6 g)
   - Retour position repos (table, accoudoir, genou)

5. ATTENTE (8-60 sec)
   - Main stationnaire
   - Magnitude proche de 0
   - Durée variable : 30-60 sec entre bouffées

6. RÉPÉTER 8-12 fois
   - Fréquence : 1 bouffée toutes les 30-60 sec
   - Durée totale : 5-10 min par cigarette
```

### Caractéristiques détectables

| Feature | Valeur | Fiabilité |
|---------|--------|-----------|
| Magnitude pic | 0.5-1.0 g | Élevée |
| Fréquence mouvement | 8-12 fois / 5-10 min | Très élevée |
| Intervalle inter-bouffées | 30-60 sec | Élevée |
| Pause en haut | 1-2 sec | Moyenne |
| Contexte stationnaire | Vitesse GPS < 1 km/h | Élevée |

### Pattern temporel global

```
[Main→Bouche] ━━ pause ━━ [Bouche→Bas] ━━━━━━ attente ━━━━━━ [répéter]
     1-2s              1-2s         1-2s                30-60s
```

**Signature unique** :
- Répétition régulière (8-12 fois)
- Intervalle constant (30-60s)
- Mouvement stéréotypé (même amplitude, même durée)

---

## SIGNATURE ALCOOL (VERRE)

### Le mouvement complet (3-10 secondes)

```
1. PHASE SAISIR (0-1 sec)
   - Main descend vers table/bar
   - Accélération descendante (-0.5 g)
   - Saisie verre (pause <0.5 sec)

2. PHASE LEVER (1-3 sec)
   - Main monte vers bouche
   - Accélération ascendante (+0.8 g)
   - Distance : 20-30 cm (plus haut que cigarette)
   - Durée : 1-3 sec

3. PHASE BOIRE (3-6 sec)
   - Main stationnaire près bouche
   - **PAUSE LONGUE : 0.5-3 sec** (déglutition)
   - Petites variations (micro-mouvements gorge)
   - Magnitude faible (<0.1 g)

4. PHASE REDESCENDRE (6-8 sec)
   - Main redescend
   - Accélération descendante (-0.6 g)
   - Retour position table

5. ATTENTE VARIABLE (10-300 sec)
   - Intervalle très variable :
     - Bière : 30-120 sec (sirotage)
     - Shot : 1 seul mouvement rapide
     - Vin : irrégulier (1-5 min)
```

### Différence alcool vs cigarette

| Feature | Cigarette | Alcool |
|---------|-----------|--------|
| Fréquence | Régulière (8-12×) | Variable (1-20×) |
| Intervalle | Constant (30-60s) | Irrégulier (10-300s) |
| Pause en haut | Courte (1-2s) | Longue (0.5-3s) |
| Distance main-bouche | 15-20 cm | 20-30 cm |
| Contexte spatial | Extérieur/balcon | Bar/restaurant |

**Clé de différenciation** :
- **Pause en haut** : alcool = 2-3× plus long (boire prend du temps)
- **Régularité** : cigarette = métronome, alcool = aléatoire
- **Contexte GPS** : bar vs extérieur

---

## FUSION ACCELEROMETER + HEART RATE

### Timeline cigarette (5-40 minutes)

```
T=0 min  : Première bouffée
           ↓ Accelerometer : pattern main→bouche (1-2s)

T=0-5 min: Inhalation nicotine
           ↓ Heart Rate : spike +10-30 bpm (réponse sympathique)

T=5-10 min: Cigarette complète (8-12 bouffées)
           ↓ Accelerometer : répétition toutes les 30-60s

T=10-40 min: Post-cigarette
           ↓ Heart Rate : plateau élevé puis descente progressive
```

**Validation croisée** :
```
SI (pattern_accelerometer = main→bouche répétitif)
ET (heart_rate_spike = +10-30 bpm dans 5 min)
ALORS confiance_cigarette = 95%
```

### Timeline alcool (30-120 minutes)

```
T=0 min  : Première gorgée
           ↓ Accelerometer : pattern main→bouche avec pause longue

T=0-30 min: Absorption éthanol
           ↓ Heart Rate : ralentissement léger (-5 bpm) = phase 1

T=30-120 min: Métabolisme éthanol
           ↓ Heart Rate : accélération (+10-20 bpm) = phase 2
           ↓ Accelerometer : mouvements irréguliers (variable selon rythme consommation)
```

**Validation croisée** :
```
SI (pattern_accelerometer = main→bouche pause longue)
ET (heart_rate_J_curve = descente puis montée)
ET (contexte_GPS = bar OU heure > 18h)
ALORS confiance_alcool = 90%
```

---

## FAUX POSITIFS & MITIGATION

### Faux positif #1 : Manger

**Confusion** :
- Main→bouche répétitif ✓
- Pause en haut (mastiquer) ✓

**Différence** :
- Fréquence : 1-2 mouvements/sec (beaucoup plus rapide)
- Durée totale : 10-30 min continu
- Pas de spike HR spécifique
- Contexte : heure repas (12h-14h, 19h-21h)

**Mitigation** :
```
SI fréquence > 1 mouvement/10 sec
OU durée_continue > 15 min
ALORS = manger (ignorer)
```

### Faux positif #2 : Boire café/eau

**Confusion** :
- Main→bouche ✓
- Pause en haut (boire) ✓

**Différence** :
- Fréquence : 1-3 mouvements isolés (pas répétitif)
- Pas de courbe HR spécifique (café = spike progressif sur 30 min, pas en J)
- Contexte : bureau, matin (7h-10h)

**Mitigation** :
```
SI nombre_mouvements < 3 dans 10 min
ET heure < 12h
ET contexte = bureau
ALORS = café (ignorer)
```

### Faux positif #3 : Téléphone

**Confusion** :
- Main→oreille ressemble main→bouche

**Différence** :
- Durée pause en haut : très longue (30-300 sec)
- Pas de répétition 8-12 fois
- Magnitude légèrement différente (angle)

**Mitigation** :
```
SI pause_en_haut > 30 sec
OU nombre_répétitions = 1
ALORS = téléphone (ignorer)
```

---

## MACHINE LEARNING : FEATURES EXTRACTION

### Features temporelles (10 variables)

| Feature | Description | Unité |
|---------|-------------|-------|
| mag_mean | Magnitude moyenne (60s) | g |
| mag_std | Écart-type magnitude | g |
| mag_max | Pic magnitude | g |
| freq_movements | Nombre mouvements/min | count |
| interval_mean | Intervalle moyen inter-mouvements | sec |
| interval_std | Variabilité intervalle | sec |
| pause_duration | Durée pause main en haut | sec |
| hr_delta | Variation HR (vs baseline) | bpm |
| hr_trend | Tendance HR (montée/descente) | slope |
| time_of_day | Heure de journée | 0-23 |

### Features contextuelles (5 variables)

| Feature | Description | Valeur |
|---------|-------------|--------|
| gps_speed | Vitesse déplacement | km/h |
| location_type | Type lieu (bar/bureau/maison/extérieur) | categorical |
| day_of_week | Jour semaine | 0-6 |
| social_context | Seul vs groupe (GPS cluster) | binary |
| weather | Température extérieure (si disponible) | °C |

### Training dataset (7 jours labellisés)

```
Total samples : ~10,000 (1 sample/min × 60 min × 24h × 7j)

Distribution cible :
- Cigarettes : ~100 (12/jour × 7j) = 1% samples
- Alcool : ~50 (7/jour × 7j) = 0.5% samples
- Rien : ~9,850 = 98.5% samples
```

**Problème** : Classes déséquilibrées (imbalanced)

**Solution** :
- SMOTE (Synthetic Minority Over-sampling)
- Class weighting (pénaliser erreurs sur classe minoritaire)
- Validation croisée stratifiée

---

## ALGORITHMES CANDIDATS

### Option 1 : Random Forest (baseline)

**Avantages** :
- Simple, rapide
- Gère bien features hétérogènes (temporel + contextuel)
- Résistant overfitting
- Interprétable (feature importance)

**Paramètres** :
```python
RandomForestClassifier(
    n_estimators=100,
    max_depth=10,
    class_weight='balanced',  # gère imbalanced
    random_state=42
)
```

**Précision attendue** : 80-85%

### Option 2 : Gradient Boosting (XGBoost)

**Avantages** :
- Meilleure précision que RF
- Gère bien les patterns complexes
- Feature importance

**Paramètres** :
```python
XGBClassifier(
    n_estimators=200,
    max_depth=6,
    learning_rate=0.1,
    scale_pos_weight=10  # gère imbalanced
)
```

**Précision attendue** : 85-90%

### Option 3 : LSTM (séquences temporelles)

**Avantages** :
- Capture patterns temporels longs (30-60s)
- Apprend séquences complexes
- Meilleur pour patterns répétitifs

**Architecture** :
```python
model = Sequential([
    LSTM(64, input_shape=(60, 15)),  # 60 timesteps, 15 features
    Dropout(0.5),
    Dense(32, activation='relu'),
    Dense(3, activation='softmax')  # 3 classes
])
```

**Précision attendue** : 90-95%

**Coût** : Entraînement plus long, déploiement plus lourd

---

## DÉPLOIEMENT SUR MONTRE

### Contraintes hardware

| Resource | Disponible (Apple Watch S6) | Budget modèle |
|----------|----------------------------|---------------|
| RAM | 1 GB | <50 MB |
| CPU | Dual-core 1.8 GHz | <10% utilisation |
| Batterie | 18h autonomie | <5% drain/jour |
| Storage | 32 GB | <100 MB modèle + data |

### Optimisations

**1. Quantization (réduction poids modèle)**
- Float32 → Int8 (4× plus léger)
- TensorFlow Lite Quantization
- Précision : -1 à -2% seulement

**2. Pruning (élagage branches inutiles)**
- Supprimer neurones faible poids
- Réduction 30-50% taille modèle

**3. Edge computing (tout local)**
- Pas de cloud (privacy + latence + batterie)
- Inférence sur montre (50-100 ms/prediction)

**4. Batching intelligent**
- Prédiction toutes les 60s (pas en continu)
- Activé seulement si mouvement détecté (accelerometer trigger)

---

## TIMELINE DÉVELOPPEMENT

| Semaine | Tâche | Délivrable |
|---------|-------|------------|
| 1-2 | Collecte données brutes | 7 jours HR + accel labellisés |
| 3 | Feature engineering | 15 features extraites |
| 4 | Training baseline (RF) | Modèle 80% précision |
| 5-6 | Amélioration (XGBoost/LSTM) | Modèle 85-90% précision |
| 7 | Déploiement montre (prototype) | App watchOS fonctionnelle |
| 8-10 | Test réel + itération | Réduction faux positifs |
| 11-12 | Gamification (+1 min/jour) | Système complet live |

**Durée totale** : 3 mois (12 semaines)

---

## RESSOURCES & RÉFÉRENCES

### Papers académiques

1. **"Smoking Detection using Smartwatch Accelerometer"** (2018)
   - Précision : 87% avec Random Forest
   - Features : magnitude, fréquence, intervalle

2. **"Alcohol Consumption Detection via Wearables"** (2019)
   - Fusion HR + accel + GPS
   - Précision : 82% alcool, 90% cigarette

3. **"WESAD: Wearable Stress and Affect Detection"** (2018)
   - Dataset public : HR + accel + stress labels
   - Baseline : 85% précision stress detection

### Outils open-source

- **SciKit-Learn** : Random Forest, preprocessing
- **XGBoost** : Gradient boosting
- **TensorFlow Lite** : Déploiement mobile/montre
- **CoreML** (iOS) : Conversion modèle pour Apple Watch
- **HealthKit** (iOS) : API accès capteurs montre

---

*"Le mouvement ne ment pas. Le corps répète ce que le cerveau automatise."*

Sky × Claude — Février 2026
