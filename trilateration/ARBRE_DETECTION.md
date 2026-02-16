# ARBRE DE DÉTECTION — TRILATÉRATION SMARTWATCH
*Auto-détection cigarettes & alcool par capteurs multi-modaux*

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

**Loi 1 : La nicotine accélère le cœur**
- Augmentation BPM : +10 à +30 bpm dans les 5 minutes
- Durée : 20-40 minutes
- Pattern : spike rapide puis plateau puis descente

**Loi 2 : L'alcool ralentit puis accélère**
- Phase 1 (0-30min) : ralentissement léger (-5 bpm)
- Phase 2 (30min-2h) : accélération (+10-20 bpm)
- Pattern : courbe en J

**Loi 3 : Le mouvement cigarette est stéréotypé**
- Main → bouche : ~15-20 cm, 1-2 sec
- Fréquence : 8-12 mouvements par cigarette
- Timing : 1 mouvement toutes les 30-60 sec

**Loi 4 : Le mouvement verre est stéréotypé**
- Main → bouche : ~20-30 cm, 1-3 sec
- Fréquence : variable (sirotage vs gorgée)
- Pattern : bras monte + pause (boire) + descend

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

**Filtre 2 : Détection pics (heart rate)**
- Identifier variations significatives (>±5 bpm)
- Fenêtre glissante : 5 minutes

**Filtre 3 : Calibration personnelle**
- BPM repos = baseline individuelle (varie 50-90)
- Correction individuelle : mesurer pendant 3-7 jours

---

## T — TRONC (0 à +2) : Fusion Multi-Capteurs

### T1 — Core Engine (0) : Fusion de données

**Fenêtre temporelle glissante : 60 secondes**
- Buffer : dernières 60 sec de données
- Update : toutes les 1 sec (temps réel)

**Synchronisation capteurs**
- Timestamp unifié (milliseconde)
- Alignement temporel (compensation latence GPS)

**Extraction features**
- Heart rate : moyenne, écart-type, variation max
- Accelerometer : magnitude, fréquence mouvements, pattern
- GPS : localisation, vitesse, changement de lieu

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

**Validation cigarette**
```
SI pattern_mouvement_cigarette = True
ET heart_rate_spike (+10-30 bpm dans 5 min) = True
ALORS confiance_cigarette = HIGH
SINON confiance_cigarette = MEDIUM (mouvement seul)
```

**Validation alcool**
```
SI pattern_mouvement_alcool = True
ET (heart_rate_J_curve OU localisation_bar) = True
ALORS confiance_alcool = HIGH
SINON confiance_alcool = MEDIUM
```

---

## B — BRANCHES (3 à 4) : Intelligence & Apprentissage

### B1 — Machine Learning (3) : Pattern Recognition Auto

**Modèle 1 : Supervised Learning (baseline)**
- Input : 10 features (HR mean, HR std, accel magnitude, freq, GPS context, heure, etc.)
- Output : 3 classes (cigarette, alcool, rien)
- Algorithme : Random Forest ou Gradient Boosting
- Training : 7 jours de données labellisées manuellement

**Modèle 2 : Unsupervised Clustering**
- Détecter patterns récurrents sans label
- K-means ou DBSCAN sur features temporelles
- Identifier anomalies (nouveaux comportements)

**Modèle 3 : Temporal Pattern (LSTM)**
- Séquences temporelles (10-60 sec)
- Prédire action suivante
- Apprendre patterns complexes (ex: cigarette après café)

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
| Batterie montre (GPS consomme) | GPS échantillonné (1 mesure/5 min), activé seulement si mouvement détecté |
| Faux positifs (manger, boire café) | Validation croisée HR + contexte spatial + pattern temporel |
| Données d'entraînement (labelling pénible) | Approche semi-supervisée : clustering auto + validation manuelle minimale |
| Variabilité individuelle (HR baseline différent) | Calibration personnelle : mesure repos 3-7 jours |
| Privacy/stockage données | Tout local sur montre (pas de cloud), agrégation anonyme uniquement |

---

## RESSOURCES TECHNIQUES

**Hardware cible**
- Apple Watch Series 6+ (PPG 1Hz, accel 100Hz, GPS)
- Garmin Fenix/Forerunner (similaire)
- Fitbit Sense (PPG + accel + GPS)

**Stack logiciel**
- Langage : Python (prototype) → Swift/Kotlin (production)
- ML : scikit-learn (baseline) → TensorFlow Lite (déploiement montre)
- Storage : SQLite local sur montre

**Datasets publics (comparaison)**
- WESAD (Wearable Stress and Affect Detection) — HR + accel stress
- PPG-DaLiA — HR estimation avec mouvement
- Smoking detection papers (chercher "accelerometer smoking detection")

---

## MÉTRIQUES DE SUCCÈS

| Phase | Métrique | Cible |
|-------|----------|-------|
| 1 | Précision cigarette | 80% |
| 1 | Faux positifs/jour | <2 |
| 2 | Précision cigarette + alcool | 85% |
| 2 | Faux positifs/jour | <1 |
| 3 | Réduction consommation (30j) | -20% |
| 3 | Streak moyen | >7 jours |

---

*"Le mycelium détecte par croissance, pas par force brute."*

Sky × Claude — Février 2026
