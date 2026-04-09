# PLAN DE GUERRE — Détection automatique de cigarettes sans tuer la batterie

> Objectif : détecter les clopes automatiquement, 0 bouton, +2-3% batterie max/jour
> Sweet spot : se greffer sur les capteurs que Samsung Health utilise déjà

---

## L'INSIGHT CLÉ

Samsung Health Sensor SDK a un mode **ACCELEROMETER_CONTINUOUS** qui :
- Tourne à **25Hz** (pas 50Hz comme notre code actuel)
- Collecte sur le **processeur applicatif sans réveiller le CPU**
- Envoie les données en **batch** (pas en temps réel)
- Est conçu pour tourner **toute la journée**
- Consommation batterie : **quasi nulle** (c'est le même mécanisme que Samsung Health utilise pour le podomètre)

**C'est EXACTEMENT ce qu'il nous faut.** Samsung a résolu le problème de batterie pour nous. On se greffe dessus.

Sources :
- [Samsung Health Sensor SDK](https://developer.samsung.com/health/sensor/overview.html)
- [Accelerometer Data Specs](https://developer.samsung.com/health/sensor/guide/data-specifications.html)
- [Understanding Accelerometer Data](https://developer.samsung.com/sdp/blog/en/2025/04/10/understanding-and-converting-galaxy-watch-accelerometer-data)

---

## COMPARAISON DES APPROCHES

| Approche | Hz | Batterie/jour | Durée batterie | Compatible |
|----------|---:|---------------|----------------|------------|
| **Notre code actuel** (SensorManager 50Hz) | 50 | -25% | ~6h | Toute montre |
| **Samsung Health Sensor SDK** (ACCELEROMETER_CONTINUOUS) | 25 | -2-3% | ~40h+ | Galaxy Watch uniquement |
| **Samsung Privileged Health SDK** (batched 25Hz) | 25 | -1-2% | ~44h+ | Galaxy Watch + approbation Samsung |
| **CLAID Framework** (ETH Zurich) | 25 | -3-5% | ~36h+ | Galaxy Watch |
| **Wear OS Health Services** (PassiveMonitoring) | Variable | -1% | ~45h+ | Toute montre Wear OS |
| **StopWatch** (recherche, 100Hz) | 100 | -50% | ~20h | Android watch |

Source : [CLAID ETH Zurich](https://claid.ethz.ch/framework_components/Packages/data_collection/GalaxyWatchCollector/), [StopWatch paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC6042639/)

---

## LE PLAN EN 3 PHASES

### PHASE 1 — Hard-code (Jour 1-3 du client)
**Coût batterie : 0%**

Le client installe l'app, utilise les boutons manuels pendant 24-72h.

Ce qui se passe en coulisse :
- Chaque +1 enregistre : timestamp, heure, jour de la semaine
- Le pattern learning construit le profil : "7h30 = clope matin", "13h = après manger"
- On collecte ~20-60 timestamps = ground truth parfait
- Boost mode pendant chaque clope = 28 fenêtres de training data par clope
- Après 3 jours : ~60-180 fenêtres de training personnel

**Aucun capteur supplémentaire. La montre dure normalement.**

### PHASE 2 — Greffe Samsung Health SDK (Jour 4+)
**Coût batterie : +2-3% max**

On active `ACCELEROMETER_CONTINUOUS` via le Samsung Health Sensor SDK :
- 25Hz continu, batché par le SDK (pas par nous)
- Le SDK gère le CPU, le buffering, la batterie
- On reçoit les données par batch toutes les X secondes
- On run notre CNN uniquement pendant les **plages horaires identifiées en Phase 1**

Flow :
```
Samsung Health SDK (25Hz continu, batché)
  ↓ batch toutes les ~12 secondes (300 samples)
  ↓
Notre code (filtre temporel)
  ├─ Heure actuelle dans une plage smoking connue ?
  │   ├─ OUI → Run CNN sur le batch → Détection ?
  │   │         ├─ OUI → +1 clope, notif, sync tel
  │   │         └─ NON → ignore
  │   └─ NON → ignore le batch (0 calcul)
  └─ Toutes les 5 min : check pattern (10ms de CPU)
```

**Sweet spot : on lit les données 25Hz mais on ne calcule que ~10% du temps (pendant les plages smoking).**

### PHASE 3 — Fine-tune + expansion (Jour 7+)
**Coût batterie : toujours +2-3%**

- Les détections auto de Phase 2 génèrent de nouvelles données de training
- Le modèle se fine-tune sur les patterns perso du client
- Les plages horaires s'élargissent progressivement
- Après 2 semaines : le modèle couvre ~80% des clopes automatiquement
- Les 20% restants : le client appuie manuellement

Objectif final : **80% détection auto + 20% manuel = 100% couverture**

---

## TECHNIQUE : Samsung Health Sensor SDK

### Ce qu'on utilise :
```kotlin
// Initialisation
val healthTrackingService = HealthTrackingService(callback, context)
healthTrackingService.connectService()

// Tracker continu (25Hz, batché, ultra low power)
val tracker = healthTrackingService.getHealthTracker(
    HealthTrackerType.ACCELEROMETER_CONTINUOUS
)

// Listener
tracker.setEventListener { dataPoint ->
    // dataPoint contient : x, y, z à 25Hz
    // Arrives en batch (~300 samples = 12 secondes)
    processAccelBatch(dataPoint)
}
```

### Format des données :
- 25Hz = 25 samples/seconde
- Batch de 12 secondes = 300 samples
- Chaque sample : AccX, AccY, AccZ (float, m/s²)
- Résolution : ±4g (Galaxy Watch 4+) ou ±8g (Galaxy Watch 6+)

### Contraintes :
- **Galaxy Watch uniquement** (pas Pixel Watch, pas Apple Watch)
- Nécessite Samsung Health Sensor SDK (gratuit, pas de review Samsung)
- Le Privileged SDK nécessite une approbation Samsung (plus de données, moins de batterie)
- L'app doit avoir un **foreground service** avec notification

### Compatibilité :
| Montre | SDK disponible | Hz | Notes |
|--------|---------------|---:|-------|
| Galaxy Watch 4 (2021) | Oui | 25 | Première avec Wear OS |
| Galaxy Watch 5 (2022) | Oui | 25 | |
| Galaxy Watch 6 (2023) | Oui | 25 | ±8g range |
| Galaxy Watch 7 (2025) | Oui | 25 | Exynos W1000 |
| Galaxy Watch 8 (2025) | Oui | 25 | |
| Galaxy Watch Ultra | Oui | 25 | 590mAh batterie |
| Galaxy Watch FE | Oui | 25 | Budget |
| **Pixel Watch** | **NON** | — | Pas de Samsung SDK |
| **Apple Watch** | **NON** | — | Autre écosystème |

Source : [Samsung Compatible Devices](https://developer.samsung.com/sdp/blog/en/2022/05/25/check-which-sensor-you-can-use-in-galaxy-watch-running-wear-os-powered-by-samsung)

---

## ADAPTATION DU CNN

Notre CNN v5 est entraîné sur des données à **50Hz**. Le Samsung SDK donne du **25Hz**.

Options :
1. **Downsample le training data de 50Hz à 25Hz** → ré-entraîner le CNN
2. **Upsample le 25Hz à 50Hz** par interpolation → garder le CNN actuel
3. **Nouveau CNN pour 25Hz** — fenêtre de 4.5s = 112 samples (au lieu de 225)

**Option 1 est la meilleure** — ré-entraîner sur 25Hz avec fenêtre 112 samples. Le papier SED utilise du 50Hz mais les features pertinentes (geste main-bouche) sont à <5Hz, donc 25Hz est largement suffisant (Nyquist = 12.5Hz > 5Hz).

---

## MESURES ET CONTRE-MESURES

| Risque | Mesure | Impact |
|--------|--------|--------|
| Batterie > 5%/jour | Filtrage temporel (only pendant plages smoking) | -80% calcul |
| Faux positifs (manger, boire) | CNN 4 classes + debounce 2 min | <30% faux positifs |
| Samsung refuse le Privileged SDK | Utiliser le Health Sensor SDK standard (gratuit) | Légèrement plus de batterie |
| Pas de gyroscope dans le SDK | Le SDK a ACCELEROMETER_CONTINUOUS mais pas GYRO continu | Ré-entraîner CNN sur 3 canaux (AccXYZ) au lieu de 6 |
| Client ne hard-code pas 24h | Gamification : "Log tes 10 premières clopes pour débloquer la détection auto" | Motivation |
| Montre non-Samsung | Fallback sur Android SensorManager avec mode basse conso (1/60s) | Plus de batterie mais fonctionne |

---

## CHIFFRES CLÉS

| Métrique | Valeur | Source |
|----------|--------|--------|
| Batterie Samsung SDK accel continu | ~2-3%/jour | Samsung docs + CLAID |
| Batterie SensorManager 50Hz | ~25%/jour (6h) | Notre test |
| Détection F1 (50Hz, labo) | 0.747 | Notre CNN v5 |
| Détection F1 (recherche StopWatch) | 0.86 precision, 0.71 recall | PMC6042639 |
| Résolution accel SDK | 25Hz | Samsung docs |
| Batch size SDK | 300 samples (12s) | Samsung docs |
| Plage smoking moyenne | 10 clopes × 5-7 min = 50-70 min/jour | Biomécanique |
| % du temps en calcul actif | ~5% (50 min / 1440 min) | Notre filtre temporel |

---

## PROCHAINES ÉTAPES (en ordre)

1. **Intégrer Samsung Health Sensor SDK** dans le projet watch
   - Ajouter la dépendance
   - Implémenter le tracker ACCELEROMETER_CONTINUOUS
   - Tester la réception des batch en background

2. **Ré-entraîner le CNN pour 25Hz**
   - Downsample SED dataset de 50Hz → 25Hz
   - Fenêtre 112 samples × 3 canaux (AccXYZ seulement, pas de gyro)
   - Valider F1 maintenu > 0.7

3. **Implémenter le filtre temporel**
   - Phase 1 : pattern learning (déjà codé)
   - Phase 2 : activer CNN uniquement pendant les plages identifiées
   - Phase 3 : fine-tune avec les détections auto

4. **Gamification du hard-code**
   - Écran "Log tes 10 premières clopes"
   - Barre de progression "Détection auto dans X clopes"
   - Déblocage auto après 24h de données

5. **Fallback non-Samsung**
   - Wear OS Health Services PassiveMonitoringClient
   - Android SensorManager avec duty cycling (5s on / 55s off)
   - Moins précis mais fonctionne partout

---

## RÉSUMÉ EXÉCUTIF

**On ne crée pas un nouveau capteur. On se greffe sur Samsung Health qui tourne déjà.**

- Phase 1 : bouton manuel → ground truth → 0% batterie
- Phase 2 : Samsung SDK 25Hz → CNN pendant plages smoking → +2% batterie
- Phase 3 : fine-tune perso → 80% auto → le client oublie qu'il a l'app

**Pourquoi personne l'a fait :**
- Tout le monde utilise SensorManager à 50-100Hz → tue la batterie en 6h
- Personne se greffe sur le Samsung Health SDK qui tourne déjà gratis
- Personne combine pattern learning + détection ciblée temporellement

**Notre avantage :**
- 0% batterie en Phase 1 (les autres commencent direct à -25%)
- 2% batterie en Phase 2 (les autres sont à -25%)
- Détection personnalisée (les autres ont un modèle générique)
- Le client garde ses données (les autres envoient tout au cloud)
