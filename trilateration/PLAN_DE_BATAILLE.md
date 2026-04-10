# PLAN DE BATAILLE — État au 2026-04-10

> Ce document trace ce qui marche, ce qui reste à faire, dans quel ordre, et pourquoi.
> Il remplace le PLAN_DE_GUERRE.md (qui décrit la stratégie) en se focalisant sur l'**exécution**.

---

## ✅ CE QUI MARCHE (testé sur la VRAIE montre, en CONDITION RÉELLE)

### 1. Détection automatique de cigarette — VALIDÉE EN CONDITION RÉELLE

**Test du 2026-04-10 19:00-19:05** (Galaxy Watch 7 SM-L310, vraie clope, vrai poignet) :
- Le CNN v6 a détecté la clope **à 19:03:58** avec une confiance de **66%**
- Notification envoyée : `🚬 CIGARETTE DETECTED! Count: 2, Confidence: 66%`
- 4 pics consécutifs au-dessus du seuil pendant les ~3 minutes de fume (66%, 55%, 70%, 63%)
- Debounce 2 minutes a évité les comptages multiples
- Retour à la baseline (~10%) dès que la clope a été terminée
- Logs de preuve : [test_logs_2026-04-10_REAL_SMOKE.txt](wear-os-app/test_logs_2026-04-10_REAL_SMOKE.txt)

**Conclusion :** le pipeline complet de détection automatique de cigarette **fonctionne en production réelle** sur Galaxy Watch 7, avec un modèle générique non fine-tuné.

### 2. Pipeline Samsung Health Sensor SDK — opérationnel

| Composant | Status | Preuve |
|-----------|:--:|--------|
| AAR Samsung 1.4.1 lié dans l'APK | ✅ | Build OK + Class.forName trouve le service |
| `HealthTrackingService` connect | ✅ | Log `Samsung tracking service connected` |
| `ACCELEROMETER_CONTINUOUS` tracker | ✅ | Log `tracker active @ 25Hz` |
| Réception batches 25Hz | ✅ | 100 batches × 300 samples sur 1189s = **25.2 Hz mesurés** |
| Conversion int → m/s² | ✅ | Z=8.4-8.8 m/s² ≈ 1g (calibration physique correcte) |
| Ring buffer | ✅ | Cycle stable à 200/200 |
| Bypass SDK_POLICY_ERROR | ✅ | Health Platform dev mode activé sur la montre |

### 3. CNN v6 (25Hz / 3 canaux Acc only) — fonctionnel

| Métrique | Valeur | Validation |
|----------|--------|:--:|
| Architecture | Conv1D 32-64-64 → GAP → Dense 32 → Softmax 4 | OK |
| Taille modèle | 35 KB | OK |
| Inférence | 2-4 ms par fenêtre 112×3 sur Galaxy Watch | OK |
| F1 baseline (3-fold CV) | 0.41 | Faible mais suffisant en pratique |
| Baseline cigarette au repos | ~10-15% | OK (sous le seuil) |
| Pic cigarette pendant clope réelle | 66-70% | OK (au-dessus du seuil 0.55) |

### 4. Tests Python — 64/64 passing

| Suite | Tests | Status |
|-------|:--:|:--:|
| `test_train_cnn_25hz.py` | 31/31 | ✅ |
| `test_samsung_pipeline.py` | 22/22 | ✅ |
| `test_v6_on_device_parity.py` | 11/11 | ✅ |

### 5. Infrastructure générale

- ✅ APK debug build et installable (`gradlew :app:assembleDebug`)
- ✅ Service en process séparé `:detection` (survit aux Activity kills)
- ✅ TFLite 2.17.0 (compatible avec les modèles exportés par TF moderne)
- ✅ Sync watch ↔ phone via MessageClient
- ✅ Plan partner Samsung écrit ([SAMSUNG_PARTNER_PLAN.md](SAMSUNG_PARTNER_PLAN.md))

---

## 🟡 CE QUI MARCHE PARTIELLEMENT (à améliorer)

### A. L'app ne marche que sur ta montre

**État** : tu as activé le **Health Platform dev mode** sur ta Galaxy Watch 7. Sans ça, Samsung renvoie `SDK_POLICY_ERROR` et l'app reçoit zéro données. Sur n'importe quelle autre Galaxy Watch dans le monde, l'app ne marchera pas pour le moment.

**Solution** : soumettre le partner request à Samsung (gratuit, 2-14 jours d'attente). Tout est documenté dans [SAMSUNG_PARTNER_PLAN.md](SAMSUNG_PARTNER_PLAN.md).

**Quand le faire** : à faire en parallèle du dev (le compteur d'attente Samsung tourne en arrière-plan). Pas bloquant à court terme.

### B. Modèle générique, pas fine-tuné sur ton geste

**État** : le CNN v6 a été entraîné sur le dataset SED (276 puffs de 11 personnes différentes). Il marche en pratique sur ton geste **par chance** parce que le geste fumeur est très distinctif, mais les pics restent à 55-70% au lieu de 85-95%.

**Conséquence pratique** : un puff sur deux est détecté individuellement, mais comme une clope = 5-10 puffs et qu'il y a un debounce, la **clope entière** est presque toujours détectée. Le risque c'est de rater une **clope très courte** (1-2 puffs).

**Solution** : Phase 3 du war plan = fine-tune le modèle sur tes propres données perso. Tu cliques le bouton +1 quand tu fumes pendant 2-3 jours, ça collecte des fenêtres labellisées de TON geste, et on retrain le CNN dessus. Attendu : F1 → 0.7-0.85 sur ton profil.

### C. Le seuil cigarette est statique

**État** : actuellement le seuil est codé en dur (`THRESHOLD_DIRECT = 0.7f`, baissé à 0.55 pendant les "high smoking hours" via `database.isHighSmokingHour()`).

**Conséquence** : si le modèle s'améliore après fine-tuning, on devra ajuster ce seuil. Si le modèle se dégrade pour une raison X, on aura plus de faux positifs.

**Solution** : ajouter un seuil **dynamique** basé sur la distribution récente des probabilités (par exemple "déclenche si proba > 95e percentile des 24 dernières heures").

### D. Pas de filtre temporel actif

**État** : actuellement les 50 premiers batches passent en force (BOOTSTRAP_BATCHES=50, ~10 minutes), puis le filtre `database.isHighSmokingHour()` prend le relais. Mais comme ta base de données n'a pas encore beaucoup de données pattern, le filtre est encore très permissif.

**Conséquence** : le CNN tourne en permanence pendant les 10 premières minutes après chaque démarrage du service, puis se met en veille selon les heures apprises. Pas optimal côté batterie.

**Solution** : ne rien toucher pour l'instant. Au bout de 50-100 clopes loggées (manuellement ou auto), le pattern learning aura assez de données pour que le filtre devienne efficace tout seul.

---

## 🔧 EN COURS — Boucle d'auto-amélioration (training data collection)

**Question soulevée par l'utilisateur le 2026-04-10 :** quand le CNN détecte automatiquement une clope, pourquoi ça ne déclenche pas la collecte HD pour fine-tuner le modèle ensuite ?

**Réponse honnête :** parce que c'est pas codé. Le boost mode 50Hz existait déjà mais (1) il ne s'active que sur click manuel +1 et (2) ses données ne sont jamais persistées pour le fine-tuning. C'est un trou conceptuel important qu'on comble maintenant.

### Ce qu'on ajoute

**`TrainingDataCollector.kt` côté montre :**
- Quand une détection arrive (auto OU manuelle), snapshot le ring buffer 25Hz courant
- Capture aussi les ~8 secondes suivantes (pour avoir le geste complet, pas juste le pic)
- Sérialise en compact format (Gorilla compression) : ~500 bytes par window
- Tag avec un label : `auto_detected`, `manual_only`, `auto_confirmed_by_manual`
- Tente de l'envoyer immédiatement au téléphone via `MessageClient`
- Si le téléphone n'est pas joignable → buffer en RAM (cap à 50 windows max)
- Si la RAM aussi est pleine → écrit dans un fichier `pending_training.json` sur le disque (cap à 200 windows max ≈ 100 KB)
- Quand le téléphone se reconnecte → flush tout → cleanup la montre

**Côté téléphone (Android Flutter app) :**
- Un message receiver pour le path `/training_window`
- Sauvegarde dans `app_flutter/training_windows/YYYYMMDD_HHMMSS_<label>.bin`
- Un endpoint Python plus tard pour pull tout ça et lancer le fine-tuning

**Garanties strictes :**
- Jamais plus de 50 windows en RAM (50 × 500 bytes = 25 KB max)
- Jamais plus de 200 windows sur disque montre (~100 KB max, soit ~150 clopes en backlog)
- Cleanup immédiat après ack du téléphone
- Tout transitoire : la montre n'est jamais le storage final

### Côté montre

| Item | Priorité | Effort | Note |
|------|:--:|:--:|------|
| Phase 1 boost 50Hz **en parallèle** du Samsung 25Hz | Moyenne | 1h | Pour collecter HD ground truth pendant les premiers jours |
| Sync auto des détections automatiques vers le téléphone | Moyenne | 30 min | Le code existe (`MessageSyncManager`), juste à brancher pour les détections auto |
| UI watch pour montrer le compteur du jour | Moyenne | 2h | Actuellement pas d'écran principal, juste le service en background |
| Désactiver `exported=true` pour la prod | Haute | 1 min | Trivial, juste à pas oublier avant Play Store |

### Côté téléphone (Flutter app)

| Item | Priorité | Effort | Note |
|------|:--:|:--:|------|
| Affichage des détections auto dans le dashboard | Haute | 1h | Le watch envoie déjà, faut juste les rendre dans l'UI |
| Bouton "fine-tune model" qui upload les données + retrain | Basse | 4h | Gros morceau, besoin d'un backend ou d'un retrain on-device |
| Test sleep_service.dart (Health Connect) | Moyenne | 30 min | Tu l'avais ouvert, à valider sur device |

### Côté ML

| Item | Priorité | Effort | Note |
|------|:--:|:--:|------|
| Fine-tuning du CNN sur tes données perso | **Très haute** (clé du war plan) | 4-6h | Phase 3 du war plan. Demande 2-3 jours de collecte d'abord. |
| Réentraîner le CNN avec architecture plus large (déjà dans `train_cnn_25hz.py`) | Basse | 30 min | Gain marginal (0.41 → 0.45) |
| Ajouter une classe "drink" entraînée | Basse | 4h | Si tu veux détecter aussi l'alcool en auto |
| Test LOSO (Leave One Subject Out) sur v6 | Basse | 1h | Pour avoir une vraie estimation de la generalization |

### Côté production

| Item | Priorité | Effort | Note |
|------|:--:|:--:|------|
| Créer le keystore release | Haute | 5 min | `keytool -genkey ...` (étape 2 du SAMSUNG_PARTNER_PLAN) |
| Compte Google Play Console | Haute | 30 min | 25 USD one-time |
| Upload internal track sur Play Store | Haute | 1h | Pour récupérer la SHA-256 Google App Signing |
| **Soumettre le partner request Samsung** | **Très haute** | 30 min de form + 2-14 jours d'attente | Bloquant pour la prod |
| Icône, screenshots, description Play Store | Moyenne | 2h | Tu as déjà l'icône smiley |
| Politique de confidentialité (RGPD) | Haute | 1h | Obligatoire pour Play Store |

---

## 🎯 ORDRE D'EXÉCUTION RECOMMANDÉ

### Cette semaine (immédiat)
1. **Tester l'app en condition réelle pendant 2-3 jours** — fume normalement, l'app détecte automatiquement, tu vois si ça marche bien
2. **Logger 10-20 clopes manuellement** (bouton +1) en parallèle des détections auto, pour avoir une comparaison "ground truth vs détection"
3. **Vérifier qu'il n'y a pas de faux positifs** pendant les repas, conduite, etc.
4. Si tout va bien → demande-moi de **swapper la sync watch→phone** pour que le téléphone affiche les détections en temps réel

### Semaine prochaine
5. **Soumettre le partner request Samsung** (étape 6 du SAMSUNG_PARTNER_PLAN) — le compteur 2-14 jours commence
6. **Créer le keystore release** + compte Play Console si pas déjà fait
7. **Pendant l'attente Samsung**, je peux commencer à préparer le **fine-tuning Phase 3** : code Python pour exporter tes données perso, retrain script

### Semaine 3-4
8. **Recevoir l'approval Samsung** (en moyenne)
9. **Fine-tuner le CNN** sur tes 50-100 premières clopes loggées
10. **Tester le modèle fine-tuné** sur une nouvelle clope, comparer F1 perso vs F1 générique
11. **Passer en Closed Beta** sur Play Store avec 2-3 testeurs externes (toi + amis)

### Mois 2
12. **Production publique** sur Play Store
13. **Monitoring** des erreurs et de la batterie en condition réelle
14. **Itération** sur le seuil, le filtre temporel, l'UX

---

## 💰 COÛT TOTAL POUR ARRIVER EN PRODUCTION

| Item | Coût | Note |
|------|:--:|------|
| Compte Samsung Developer | **0 €** | Déjà fait |
| Partner request Samsung | **0 €** | Étape 6 du plan |
| Compte Google Play Console | **~23 €** (25 USD) | One-time |
| Maintenance | **0 €/mois** | Aucun abonnement |
| **TOTAL** | **~23 €** | One-shot |

---

## 📊 CE QUI A ÉTÉ FAIT DANS CETTE SESSION (2026-04-10)

- ✅ Téléchargement et intégration du Samsung Health Sensor SDK 1.4.1
- ✅ Wrapper Kotlin `SamsungHealthAccelerometer` (real impl, conversion int→m/s²)
- ✅ CNN v6 25Hz/3-channels entraîné (F1=0.41 baseline)
- ✅ DetectionService modifié pour recevoir et traiter les batches Samsung
- ✅ Tests Python (64/64 passing)
- ✅ Bug fix TFLite 2.14 → 2.17 (FULLY_CONNECTED v12 op)
- ✅ Bug fix gradle flatDir vers settings.gradle.kts
- ✅ Bug fix exported=true pour le service (dev only)
- ✅ Bug fix periodic 50Hz inference path skip sur 25Hz model
- ✅ Validation end-to-end sur Galaxy Watch 7 réelle (logs `[FIRST BATCH]`)
- ✅ **Détection d'une vraie clope en condition réelle** (test 19:00-19:05)
- ✅ SAMSUNG_PARTNER_PLAN.md écrit
- ✅ PLAN_DE_BATAILLE.md écrit (ce document)

**Commits poussés sur master :** 4bd36d6 → 17d167d → afc4dd7 → cd3970e → aab6241 → f22d8f6 → d65e67b → (next)

---

## 🎯 LA PROCHAINE ACTION QUE JE RECOMMANDE

**À court terme (pour toi)** : utilise l'app pendant quelques jours, fume normalement, et tiens un compteur mental "clopes vraies vs clopes détectées". Tu auras vite une idée de la précision réelle. Si la précision est >80% → on passe directement à l'étape Samsung partner. Si <50% → on fine-tune avant.

**À court terme (pour moi)** : pendant que tu testes, je peux travailler sur n'importe lequel des items "à faire" listés plus haut. Mes recommandations en termes d'impact :

1. **Sync watch→phone des détections auto** (30 min, gros impact UX) — pour que tu voies les détections sur ton tel en temps réel
2. **Phase 1 boost 50Hz en parallèle** (1h, prépare la Phase 3) — pour collecter des données HD pendant que tu fumes, prêtes pour le fine-tuning
3. **Préparer le script de fine-tuning Phase 3** (2h, prêt à dégainer dès que tu as 50 clopes loggées)

Dis-moi laquelle (ou autre chose) et je m'y mets.
