# LOCALISATION CONTEXTUELLE — GPS + CLUSTERING
*Pas de trilatération stricte, mais fusion/filtrage + détection de lieux*

---

## POINT CLÉ (ChatGPT + recherche)

**Avec uniquement GPS lat/lon estimés, on ne "trilatère" pas** : on fait de la **fusion/filtrage** (réduire bruit) puis du **clustering** (détecter stay points/lieux significatifs).

La "trilatération" stricte nécessite des **distances vers ancres connues** (beacons UWB, Wi-Fi RTT, GPS pseudoranges). On n'a pas ça.

---

## PIPELINE RÉEL

```
Mouvement détecté (accelerometer)
         ↓
GPS échantillonné (1/5 min)
         ↓
WLS Fusion (réduire bruit ±5-10m)
         ↓
Stay Point Detection (immobile ≥10-20 min)
         ↓
DBSCAN Clustering (découverte auto lieux)
         ↓
Labelling contextuel (maison/bureau/bar)
         ↓
Scoring probabilité (cigarette/alcool selon lieu)
```

---

## 1. FUSION GPS — WLS (Weighted Least Squares)

### Problème

GPS donne position `(lat, lon)` avec incertitude `σ` (accuracy). En urbain/indoor : `σ = 5-50m`, avec outliers.

### Solution

Fusionner N fixes GPS avec pondération par incertitude.

### Formule mathématique

Projeter lat/lon en coordonnées locales ENU (East-North-Up) autour d'un point de référence.

Pour mesures `p_i = (x_i, y_i)` avec écart-type horizontal `σ_i` :

```
p̂ = Σ(w_i * p_i) / Σ(w_i)

où w_i = 1 / σ_i²
```

Covariance (approx isotrope) :

```
Cov(p̂) ≈ (Σ 1/σ_i²)⁻¹ * I
```

### Pseudo-code Python

```python
import numpy as np

def wls_fuse(points_xy, sigmas_m):
    """
    Fusionne N fixes GPS bruitées.

    Args:
        points_xy: (N, 2) en mètres dans repère local (ENU)
        sigmas_m: (N,) incertitude horizontale (m)

    Returns:
        p: (2,) position fusionnée
        cov: (2, 2) matrice covariance
    """
    w = 1.0 / (np.square(sigmas_m) + 1e-9)  # éviter division par 0
    p = (points_xy * w[:, None]).sum(axis=0) / w.sum()
    cov = (1.0 / w.sum()) * np.eye(2)
    return p, cov
```

### Gestion outliers (indoor)

**Rejet simple** : ignorer fixes avec `σ > THRESHOLD` (ex. 30m).

**Robuste** : fonction de perte Huber (réduire poids outliers sans les éliminer).

---

## 2. FILTRE DE KALMAN (si utilisateur bouge)

### État

```
x_t = [x, y, v_x, v_y]  # position + vitesse
```

### Mesure GPS

```
z_t = [x, y]
```

### Algorithme

1. **Prédiction** : `x_t = F * x_{t-1}` (propagation mouvement)
2. **Correction** : `x_t = x_t + K * (z_t - H * x_t)` (mise à jour GPS)

**Intérêt** : lisse la trajectoire, fournit une incertitude exploitable.

**Librairie** : `pykalman` (Python), ou Core Location native (Apple).

---

## 3. STAY POINT DETECTION

### Définition

**Stay point** = endroit où l'utilisateur reste **immobile** pendant **dwell time ≥ T**.

### Algorithme (fenêtre glissante)

```python
def detect_stay_points(gps_trace, R_threshold=50, T_min=600):
    """
    Détecte les stay points.

    Args:
        gps_trace: liste de (timestamp, lat, lon, accuracy)
        R_threshold: rayon max (m) pour considérer "immobile"
        T_min: dwell time min (sec)

    Returns:
        stay_points: liste de (centroid, start_time, end_time, dwell)
    """
    stay_points = []
    i = 0

    while i < len(gps_trace):
        # Fenêtre commençant à i
        centroid = gps_trace[i]
        cluster = [gps_trace[i]]
        j = i + 1

        # Agréger points proches
        while j < len(gps_trace):
            if distance(gps_trace[j], centroid) < R_threshold:
                cluster.append(gps_trace[j])
                centroid = mean(cluster)  # recalculer centroid
                j += 1
            else:
                break

        # Vérifier dwell time
        dwell = cluster[-1].timestamp - cluster[0].timestamp
        if dwell >= T_min:
            stay_points.append({
                'centroid': centroid,
                'start': cluster[0].timestamp,
                'end': cluster[-1].timestamp,
                'dwell': dwell,
                'n_samples': len(cluster)
            })

        i = j if j > i else i + 1

    return stay_points
```

### Paramètres typiques

| Param | Valeur | Justification |
|-------|--------|---------------|
| R_threshold | 30-50m | Précision GPS urbaine |
| T_min | 10-20 min | Filtrer passages courts |
| GPS sampling | 1/5 min | Économie batterie |

---

## 4. CLUSTERING — DBSCAN

### Pourquoi DBSCAN > K-means

| Feature | DBSCAN | K-means |
|---------|--------|---------|
| Nombre clusters | Auto-détecté | Doit être spécifié |
| Gestion bruit | ✅ Outliers ignorés | ❌ Force dans cluster |
| Forme clusters | Arbitraire | Sphérique uniquement |
| Urbain/indoor | ✅ Robuste | ❌ Fragile |

### Algorithme DBSCAN

**Paramètres** :
- `eps` : rayon max entre 2 points voisins (ex. 50m)
- `min_samples` : nombre min points pour former cluster (ex. 3)

**Principe** :
1. Point = **core** si ≥ `min_samples` voisins dans rayon `eps`
2. Point = **border** si voisin d'un core mais pas core lui-même
3. Point = **noise** sinon (outlier, ignoré)

### Pseudo-code Python

```python
from sklearn.cluster import DBSCAN
import numpy as np

def cluster_stay_points(stay_points, eps=50, min_samples=3):
    """
    Cluster les stay points en lieux significatifs.

    Args:
        stay_points: liste de stay points (lat, lon)
        eps: rayon max (m) entre 2 voisins
        min_samples: min points pour cluster

    Returns:
        labels: array d'étiquettes cluster (-1 = noise)
        n_clusters: nombre de clusters trouvés
    """
    # Convertir lat/lon en coordonnées métriques (ENU local)
    coords = np.array([(sp['lat'], sp['lon']) for sp in stay_points])
    coords_xy = latlon_to_meters(coords)  # helper function

    # DBSCAN
    db = DBSCAN(eps=eps, min_samples=min_samples, metric='euclidean')
    labels = db.fit_predict(coords_xy)

    n_clusters = len(set(labels)) - (1 if -1 in labels else 0)

    return labels, n_clusters
```

### Mise à jour incrémentale (online)

**Formule** : Pour cluster avec centroid `μ` et compteur `n`, nouveau point `p` :

```
μ' = μ + 1/(n+1) * (p - μ)
n' = n + 1
```

**Pseudo-code online clustering** :

```python
for each new GPS sample (p, acc):
    if acc > ACC_MAX:
        ignore  # GPS trop bruité

    if user_is_moving(accelerometer):
        ignore or buffer as "transit"

    # Trouver cluster le plus proche
    c = nearest_cluster_by_distance(p)

    if c exists and dist(p, c.centroid) < R_JOIN:
        c.update_centroid_incremental(p)
        c.update_time_stats(timestamp)
    else:
        create_new_cluster(p)

# Périodiquement
periodically:
    merge_clusters_if_close(R_MERGE)
    label_home_work_by_time_patterns()
```

---

## 5. LABELLING CONTEXTUEL

### Règles simples basées sur patterns temporels

| Lieu | Critère |
|------|---------|
| **Maison** | Cluster le plus fréquent la nuit (21h-6h) |
| **Bureau** | Cluster fréquent jours ouvrés (9h-17h) |
| **Bar/restaurant** | Cluster fréquent soir/weekend (18h-2h) + corrélé drinking gesture |
| **Extérieur** | Pas de cluster stable, mouvement détecté |

### Algorithme labelling auto

```python
def label_clusters(clusters, stay_points):
    for cluster in clusters:
        # Récupérer tous les stay points de ce cluster
        visits = [sp for sp in stay_points if sp['cluster_id'] == cluster.id]

        # Analyser patterns temporels
        night_visits = [v for v in visits if is_night_time(v['start'])]
        work_visits = [v for v in visits if is_work_hours(v['start'])]
        evening_visits = [v for v in visits if is_evening(v['start'])]

        # Scoring
        night_score = len(night_visits) / len(visits)
        work_score = len(work_visits) / len(visits)
        evening_score = len(evening_visits) / len(visits)

        # Labelling
        if night_score > 0.6:
            cluster.label = 'home'
        elif work_score > 0.5:
            cluster.label = 'work'
        elif evening_score > 0.4:
            cluster.label = 'bar'  # à affiner avec gesture
        else:
            cluster.label = 'other'

    return clusters
```

---

## 6. SCORING PROBABILITÉ (BAYÉSIEN)

### Base de données lieux

```python
places = {
    'home': {'id': 1, 'centroid': (lat, lon), 'radius': 50, 'visits': 120},
    'work': {'id': 2, 'centroid': (lat, lon), 'radius': 100, 'visits': 80},
    'bar_habituel': {'id': 3, 'centroid': (lat, lon), 'radius': 20, 'visits': 15}
}
```

### Probabilités bayésiennes

```python
# Prior (basé sur patterns historiques)
P_cigarette = {
    'home': 0.3,
    'work': 0.4,
    'outdoor': 0.7,
    'bar': 0.2
}

P_alcohol = {
    'home': 0.3,
    'work': 0.1,
    'bar': 0.8,
    'restaurant': 0.6
}
```

### Règle de décision

```
P(cigarette | lieu_extérieur) = 0.7
P(cigarette | lieu_bureau) = 0.4
P(alcool | lieu_bar) = 0.8
P(alcool | lieu_maison, heure>18h) = 0.5
```

### Update en temps réel

```python
def update_proba(gesture_detected, current_place, time):
    # Prior
    if gesture_detected == 'cigarette':
        p_base = P_cigarette[current_place.label]
    else:
        p_base = P_alcohol[current_place.label]

    # Modulation temporelle
    if is_evening(time):
        p_base *= 1.5  # plus probable le soir

    # Corrélation avec patterns historiques
    if current_place.has_recent_gesture(gesture_detected):
        p_base *= 1.2

    return min(p_base, 1.0)  # cap à 1
```

---

## 7. IMPLÉMENTATION SMARTWATCH

### Contraintes batterie

| Stratégie | Économie |
|-----------|----------|
| GPS échantillonné (1/5 min) | 70-80% |
| GPS déclenché par mouvement (accelerometer) | 85-90% |
| Geofencing (region monitoring) | 90-95% |
| Combiné (geofencing + mouvement) | 95% |

### APIs disponibles

**Apple Watch (Core Location)** :
- `CLLocationManager.requestLocation()` : one-shot GPS
- `CLLocationManager.startMonitoringSignificantLocationChanges()` : low-power
- `CLRegion` : geofencing (max 20 régions)

**Wear OS (Android)** :
- `FusedLocationProviderClient` : fusion GPS + réseau
- `Geofence` : geofencing
- `ActivityRecognitionClient` : détection activité (marche/arrêt/véhicule)

### Pseudo-code pipeline complet

```swift
// Apple Watch (Swift)
class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var clusters: [PlaceCluster] = []

    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 50  // update si déplacement > 50m
        locationManager.allowsBackgroundLocationUpdates = true

        // Start low-power mode
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Filtrer accuracy
        guard location.horizontalAccuracy < 50 else { return }

        // Fusionner avec WLS (si plusieurs fixes récentes)
        let fusedLocation = wlsFuse(recentLocations: recentBuffer + [location])

        // Détecter stay point
        if isStayPoint(fusedLocation, dwell: 600) {
            updateClusters(fusedLocation)
        }

        // Scoring contextuel
        let currentPlace = findNearestCluster(fusedLocation)
        let probaCigarette = scoreContext(place: currentPlace, time: Date())

        // Trigger détection si probability élevée + mouvement détecté
        if probaCigarette > 0.6 && handToMouthDetected {
            activateHRSensor()
        }
    }
}
```

### Stockage local (SQLite)

```sql
CREATE TABLE places (
    id INTEGER PRIMARY KEY,
    label TEXT,  -- 'home', 'work', 'bar', 'other'
    centroid_lat REAL,
    centroid_lon REAL,
    radius REAL,
    visits INTEGER,
    first_seen TIMESTAMP,
    last_seen TIMESTAMP
);

CREATE TABLE stay_points (
    id INTEGER PRIMARY KEY,
    place_id INTEGER,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    dwell_seconds INTEGER,
    FOREIGN KEY(place_id) REFERENCES places(id)
);
```

---

## 8. DATASETS PUBLICS (PROTOTYPAGE)

### GeoLife (Microsoft Research)

**Description** : 182 utilisateurs, 17,621 trajectoires, 24M+ points GPS (2007-2012).

**URL** : https://www.microsoft.com/en-us/research/publication/geolife-gps-trajectory-dataset-user-guide/

**Format** : Fichiers `.plt` (lat, lon, alt, timestamp)

**Utilité** :
- Prototyper stay point detection
- Valider DBSCAN clustering
- Tester labelling home/work

### MDC Dataset (Nokia)

**Description** : 185 utilisateurs, 2 ans, GPS + accel + Bluetooth.

**Utilité** : Fusion GPS + mouvement (comme ton use case).

### Autres

- **Reality Mining (MIT)** : Bluetooth + cell towers + GPS
- **Cabspotting** : Taxis San Francisco (500 véhicules)

---

## 9. RÉFÉRENCES SCIENTIFIQUES

### Localisation / Lieux significatifs

1. **Ashbrook & Starner (2003)** - "Using GPS to Learn Significant Locations"
   → Premier papier sur significant locations via clustering GPS

2. **Zheng et al. (WWW 2009)** - "Mining Interesting Locations and Travel Sequences"
   → Extraction lieux/trajectoires à grande échelle (GeoLife dataset)

3. **Kato et al. (2024)** - "Stay Point Detection Impact of Log Interval"
   → Évaluation impact fréquence échantillonnage

4. **Montoliu et al. (2013)** - "Discovering Places of Interest in Everyday Life"
   → Pipeline complet stay points → lieux → labelling

### Smoking Detection Smartwatch

5. **Cole et al. (2017)** - "Detecting Smoking Events Using Accelerometer Data"
   JMIR mHealth, https://pmc.ncbi.nlm.nih.gov/articles/PMC5745355/
   → 81% précision, accelerometer seul

6. **HeartIt (2025)** - "Low-Power Smoking Detection with Smartwatch"
   Springer JCST, https://link.springer.com/article/10.1007/s11390-024-2981-3
   → Stratégie low-power : accéléro déclenche HR

7. **Sense2Quit (2025)** - "Robust to Confounding Gestures"
   → Modèle robuste faux positifs (manger, boire café)

### Énergie / Localisation adaptative

8. **"Rate-Adaptive GPS Sampling"** - Duty-cycle GPS + accéléro
   → Adaptation fréquence selon mouvement détecté

9. **"Geofencing Energy-Aware"** - Region monitoring vs continuous GPS
   → Comparaison consommation batterie

---

## 10. ORDRE D'IMPLÉMENTATION RECOMMANDÉ

### Phase 1 — Prototypage offline (2-3 semaines)

1. **Télécharger GeoLife dataset**
2. **Implémenter stay point detection** (fenêtre glissante)
3. **Implémenter DBSCAN clustering**
4. **Labelling home/work/other** (règles temporelles)
5. **Évaluation** : nombre lieux détectés, précision labelling

### Phase 2 — Fusion capteurs (2-3 semaines)

6. **Collecter propres données** : GPS + accelerometer (7 jours)
7. **WLS fusion** : réduire bruit GPS
8. **Détection mouvement** : filtrer transit vs stay
9. **Validation croisée** : GPS + gesture detection

### Phase 3 — Déploiement montre (2-4 semaines)

10. **API Core Location / Wear OS**
11. **Stockage SQLite local**
12. **Update incrémental clusters**
13. **Scoring contextuel temps réel**
14. **Test batterie** : objectif <5% drain/jour

---

*"Pas de trilatération. Juste du clustering intelligent."*

**Validation ChatGPT + recherche académique — Février 2026**
Sky × Claude
