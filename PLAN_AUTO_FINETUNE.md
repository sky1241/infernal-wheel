# Plan de bataille — Fine-tuning automatique on-device

## Objectif

Le CNN v6 (F1=0.41) est générique. Chaque utilisateur a des gestes
différents quand il fume. Le modèle doit s'adapter automatiquement
à chaque user, comme Samsung Health adapte le podomètre à la foulée.

## Architecture retenue

**TFLite on-device training** (Google LiteRT) — directement sur le
téléphone, pas besoin de serveur.

### Pourquoi TFLite et pas ONNX Runtime ?

- On utilise déjà TFLite sur la montre pour l'inference
- Le modèle v6 est déjà en format `.tflite`
- ONNX Runtime Training est plus mature pour les LLMs mais overkill
  pour un petit CNN 4-couches
- Garder le même ecosystème = moins de dépendances

## Flow complet

```
MONTRE                          TÉLÉPHONE                     MONTRE
  |                                |                            |
  | 1. User +1 clope              |                            |
  | 2. captureTrainingWindow      |                            |
  |    (8s accel @ 25Hz)          |                            |
  | -------BT MessageClient-----> |                            |
  |                                | 3. Stocke training_window |
  |                                |    dans app_flutter/       |
  |                                |    training_windows/       |
  |                                |                            |
  |                                | 4. Quand assez de données  |
  |                                |    (>= 20 windows positives|
  |                                |    + négatifs du SED)      |
  |                                |                            |
  |                                | 5. Fine-tune le CNN v6     |
  |                                |    - Freeze feature layers |
  |                                |    - Re-train classifier   |
  |                                |      head (2 dense layers) |
  |                                |    - 10-15 epochs          |
  |                                |    - ~2-5 min sur phone    |
  |                                |                            |
  |                                | 6. Export nouveau .tflite  |
  |                                |    + normalization params  |
  |                                |                            |
  |                                | -----BT MessageClient----> |
  |                                |                            | 7. Hot-swap modèle
  |                                |                            |    sans restart
  |                                |                            |    du service
```

## Étapes de développement

### Étape 1 — Préparer le modèle pour le training on-device
**Fichier**: `trilateration/prepare_trainable_model.py`

- [ ] Charger le CNN v6 Keras (pas le .tflite — il faut le .h5 source)
- [ ] Marquer les conv layers comme frozen (trainable=False)
- [ ] Garder les dense layers (classifier head) trainable
- [ ] Ajouter les 4 signatures TFLite requises:
  - `train` — forward + backward + weight update
  - `infer` — forward seulement (inference)
  - `save` — sérialiser les weights mis à jour
  - `restore` — charger des weights sauvegardés
- [ ] Convertir avec TFLiteConverter + experimental_enable_resource_variables
- [ ] Output: `smoking_detector_trainable.tflite` (~500KB-1MB)

### Étape 2 — Phone-side training service (Kotlin)
**Fichier**: `infernal-app/android/app/src/main/kotlin/.../OnDeviceTrainer.kt`

- [ ] Classe OnDeviceTrainer qui:
  - Charge le modèle trainable via TFLite Interpreter
  - Lit les training windows depuis app_flutter/training_windows/
  - Décompresse (GorillaCompressor format → float arrays)
  - Sépare en positifs (label=auto_detected, manual_only) et négatifs
  - Mélange avec des négatifs hard-codés du SED dataset (embarqués)
  - Lance le training via la signature `train` (10-15 epochs)
  - Sauvegarde le modèle fine-tuné via la signature `save`
  - Exporte en .tflite standard pour la montre

### Étape 3 — Trigger automatique du fine-tuning
**Fichier**: Intégré dans `MainActivity.kt` (phone)

- [ ] Condition de trigger:
  - >= 20 training windows positives stockées
  - Dernier fine-tune > 24h (pas plus d'1x par jour)
  - Téléphone en charge OU batterie > 50%
  - WiFi connecté (pour ne pas drainer la data mobile)
- [ ] Lancer OnDeviceTrainer dans un WorkManager (background task)
- [ ] Notification "Modèle mis à jour" quand c'est fini

### Étape 4 — Push du modèle vers la montre
**Fichier**: Extension de `MessageSyncManager` (phone → watch)

- [ ] Nouveau path MessageClient: `/model_update`
- [ ] Envoyer le .tflite fine-tuné via chunks (limite ~100KB par message)
  - Ou utiliser DataClient avec Asset pour les gros fichiers
- [ ] Côté montre: recevoir, valider (taille, magic bytes), sauvegarder
- [ ] SmokingDetector.kt: méthode `hotSwapModel(newModelPath)` qui:
  - Ferme l'ancien interpreter
  - Charge le nouveau modèle
  - Reconfigure la normalization
  - Reprend l'inference sans restart du DetectionService

### Étape 5 — Rollback et sécurité
- [ ] Garder l'ancien modèle comme backup
- [ ] Si le nouveau modèle crash au load → rollback automatique
- [ ] Si le F1 estimé du nouveau modèle est pire → ne pas déployer
- [ ] Versioning des modèles (v6 → v6.1 → v6.2 → ...)

### Étape 6 — UI feedback
- [ ] Dashboard phone: section "Modèle IA" avec:
  - Version du modèle actuel (v6 generic / v6.1 personal)
  - Nombre de training windows collectées
  - Date du dernier fine-tune
  - Estimation F1 (si on a assez de données pour un mini test)
- [ ] Watch notification quand le modèle est mis à jour

## Contraintes techniques

| Contrainte | Valeur | Source |
|---|---|---|
| RAM pour training | ~100-200 MB | TFLite blog |
| Temps de training | 2-5 min (10 epochs, ~200 samples) | Estimation |
| Taille modèle trainable | ~500KB-1MB | MobileNetV2 pattern |
| Batterie training | ~3-5% du phone | Estimation |
| Min training windows | 20 positives | Empirique (finetune_cnn_v7.py) |
| Max training frequency | 1x/jour | Battery conservation |

## Dépendances à ajouter

### Phone (build.gradle.kts)
```kotlin
// TFLite pour le training on-device
implementation("org.tensorflow:tensorflow-lite:2.17.0")
implementation("org.tensorflow:tensorflow-lite-select-tf-ops:2.17.0")
```

### Montre (déjà en place)
- TFLite 2.17.0 ✓
- MessageSyncManager ✓
- GorillaCompressor ✓

## Ordre de priorité

1. **Étape 1** (prepare_trainable_model.py) — peut se faire maintenant
2. **Étape 2** (OnDeviceTrainer.kt) — le gros du boulot
3. **Étape 4** (push model to watch) — nécessite étape 2
4. **Étape 3** (auto-trigger) — nécessite étape 2+4
5. **Étape 5** (rollback) — peut attendre la v2
6. **Étape 6** (UI) — cosmétique, en dernier

## Risques

1. **TFLite training signatures** — la doc est sparse, certaines ops
   (BatchNorm, Dropout) ne sont pas supportées en mode training. Il
   faudra peut-être simplifier l'architecture du CNN pour que le
   training compile.

2. **Qualité du fine-tune** — avec seulement 20-50 windows personnelles
   le modèle peut overfitter sur les manies du user et devenir PIRE
   sur les variations normales de ses gestes. Mitigation: garder des
   négatifs du SED dataset dans le mix.

3. **Hot-swap du modèle** — changer le modèle pendant que l'inference
   tourne nécessite une synchronisation propre. Le interpreterLock
   (BUG+032) aide mais il faut quand même gérer le cas où une
   inference est en cours pendant le swap.

4. **SELECT_TF_OPS** — ajoute ~20MB à l'APK du phone. C'est lourd
   mais c'est one-time (le user ne le voit pas).
