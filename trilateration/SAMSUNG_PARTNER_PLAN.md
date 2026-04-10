# Samsung Partner Registration — Plan d'action

## TL;DR

Pour que ton app `-1+` (com.infernal.wheel) fonctionne sur **n'importe quelle Galaxy Watch dans le monde** sans avoir à activer le dev mode manuellement, tu dois soumettre **un formulaire gratuit** à Samsung. Coût : **0 €**. Délai d'approbation : **2 à 14 jours ouvrés**. Aucun abonnement, aucun renouvellement.

Sans cette inscription : l'app marche **uniquement sur ta montre** (parce que c'est la seule où tu as activé le dev mode Health Platform).

---

## Pourquoi c'est nécessaire

Le Samsung Health Sensor SDK est verrouillé côté service système (`com.samsung.android.service.health`). Quand notre wrapper appelle `getHealthTracker(ACCELEROMETER_CONTINUOUS).setEventListener(...)`, le service Samsung vérifie 2 choses :

1. Le **package name** de l'app (`com.infernal.wheel`) est-il dans la liste des partenaires autorisés ?
2. La **signature SHA-256** du certificat de signing de l'APK installé matche-t-elle celle enregistrée chez Samsung pour ce package ?

Si **les deux ne matchent pas** → `Tracker error: SDK_POLICY_ERROR` → aucun batch n'est délivré.

Le dev mode Health Platform bypasse cette vérification, mais c'est local à la montre et c'est manuel — donc inutilisable en production.

---

## Étape 1 — Comprendre les deux signatures SHA-256

C'est le truc qui peut te perdre. **Il y a deux SHA-256 différentes possibles** selon comment tu publies ton app, et tu dois donner la BONNE à Samsung.

### Cas A — Tu publies sans Play App Signing (rare, déconseillé)

Ton APK final est signé avec **ton keystore local** (`release.jks`). Les utilisateurs reçoivent un APK signé avec ta clé. La SHA-256 que voient les montres est celle de **ton keystore**.

**Action** : donne à Samsung la SHA-256 de ton keystore local.

### Cas B — Tu publies avec Play App Signing (par défaut, recommandé)

Tu uploades ton APK signé avec un **upload key** (ton keystore local). Google **re-signe** l'APK avec sa propre **app signing key** avant de le distribuer aux utilisateurs. Les montres voient donc la SHA-256 de **Google**, pas la tienne.

**Action** : donne à Samsung la SHA-256 de la **App signing key** générée par Google, pas celle de ton upload key.

Tu trouves cette SHA-256 dans la Play Console :
> **Setup → App integrity → App signing → App signing key certificate → SHA-256 certificate fingerprint**

### Comment savoir dans quel cas tu es

Quand tu crées ton app dans la Play Console pour la première fois, Google te demande explicitement si tu veux activer Play App Signing. Par défaut depuis 2021, c'est ON et tu ne peux plus le désactiver après. **Donc tu seras presque certainement dans le cas B.**

**Conséquence pratique** : tu ne peux pas inscrire l'app chez Samsung tant que tu n'as pas créé l'app dans la Play Console et uploadé un premier APK pour générer la app signing key. Sinon tu n'as pas la SHA-256 finale.

---

## Étape 2 — Créer le keystore release local

(Ça c'est le keystore qui signe ton **upload APK**, pas l'app signing key Google. Mais tu en as quand même besoin pour upload sur Play Console.)

```bash
cd c:/Users/ludov/infernal-wheel/trilateration/wear-os-app
keytool -genkey -v \
  -keystore release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias infernalwheel
```

Réponds aux questions (nom, ville, etc.) et **note bien le password** (mot de passe du keystore + mot de passe de la clé). Tu vas en avoir besoin pour signer chaque release.

**⚠️ CRITIQUE** : sauvegarde `release.jks` à plusieurs endroits (USB, cloud privé chiffré). Si tu le perds, tu ne pourras plus jamais signer une mise à jour de l'app sur le Play Store. Google ne pardonne pas la perte du upload key.

Ajoute ensuite à `.gitignore` :
```
release.jks
keystore.properties
```

---

## Étape 3 — Configurer le signing dans build.gradle.kts

Crée `keystore.properties` (NON commité) :
```properties
storeFile=release.jks
storePassword=TON_PASSWORD_KEYSTORE
keyAlias=infernalwheel
keyPassword=TON_PASSWORD_CLE
```

Modifie `app/build.gradle.kts` pour ajouter une signing config release. Je peux te le faire automatiquement le moment venu — pas besoin de toucher tant qu'on est en dev.

---

## Étape 4 — Build une release APK

```bash
gradlew :app:assembleRelease
```

Ça produit `app/build/outputs/apk/release/app-release.apk` signé avec ton upload key.

---

## Étape 5 — Créer l'app sur Play Console

1. Va sur https://play.google.com/console
2. Crée un compte développeur Google Play (**25 USD une fois pour la vie**)
3. Crée une nouvelle app : nom `-1+`, package `com.infernal.wheel`
4. Suis le wizard : description, screenshots, catégorie, etc.
5. Va dans **Internal testing** (pas besoin de production tout de suite)
6. Upload `app-release.apk`
7. Google génère automatiquement la **App signing key** côté serveur
8. Récupère la SHA-256 de cette app signing key dans :
   **Setup → App integrity → App signing key certificate → SHA-256 certificate fingerprint**

Note ou copie cette SHA-256. Format :
```
SHA-256: 12:34:56:AB:CD:EF:...:XX  (64 hex caractères, séparés par :)
```

---

## Étape 6 — Soumettre le partner request à Samsung

1. Va sur https://developer.samsung.com/health/sensor/process.html
2. Clique sur **"Partner Request"** (lien dans le texte)
3. Crée/connecte-toi à ton compte Samsung Developer (gratuit, déjà fait)
4. Remplis le formulaire :

| Champ | Valeur à donner |
|-------|-----------------|
| Company / Individual name | Ton nom complet (ou nom de société si tu en as une) |
| Email | Le même que ton compte Samsung Developer |
| App name | `-1+` |
| Package name | `com.infernal.wheel` |
| **App signature (SHA-256)** | **La SHA-256 récupérée à l'étape 5** (Play App signing key) |
| Description of use case | "Smoking gesture detection on the wrist using accelerometer data, with all processing happening locally on the watch (no cloud). The app helps users quit smoking by tracking their daily consumption automatically." |
| SDK functions used | `ACCELEROMETER_CONTINUOUS` (et `HEART_RATE_CONTINUOUS` si tu veux ajouter la HR plus tard) |
| Distribution channel | Google Play Store |
| Target audience | Adults trying to quit smoking |
| Country / Region | France |

5. Soumets le formulaire
6. Tu reçois un email de confirmation
7. Attends 2-14 jours ouvrés

Pendant l'attente, Samsung peut t'envoyer des questions par email si quelque chose dans la description les intrigue. Réponds rapidement et professionnellement.

---

## Étape 7 — Une fois approuvé

Tu reçois un email "Your partner request has been approved". À partir de là :

1. **Aucun changement de code** nécessaire — tu n'as rien à modifier dans l'app
2. Le service Samsung sur **toutes les Galaxy Watch** acceptera désormais la combinaison `(com.infernal.wheel, ta SHA-256)`
3. Les utilisateurs qui installeront ton app depuis le Play Store n'auront PAS besoin d'activer le dev mode
4. Tu peux désactiver le dev mode Health Platform sur ta propre montre pour vérifier que ça marche en production

**Test de validation** : installer l'APK release sur une Galaxy Watch *qui n'a JAMAIS eu le dev mode activé*. Si tu vois `[FIRST BATCH]` dans logcat, c'est gagné.

---

## Risques et contre-mesures

| Risque | Probabilité | Mitigation |
|--------|:--:|------------|
| Samsung refuse le partner request | Faible | Décrire clairement l'usage légitime (anti-tabac), montrer que les données restent locales. Si refus, demander pourquoi et corriger. |
| Délai > 2 semaines | Moyen | Lancer la démarche le plus tôt possible, en parallèle du dev. Continuer à dev sur ta montre avec dev mode pendant l'attente. |
| Tu perds ton upload keystore (`release.jks`) | Catastrophe possible | **3 backups dans 3 endroits différents** (USB, disque dur externe, cloud privé chiffré comme Proton Drive). Sans ça, l'app meurt sur le Play Store. |
| Tu changes de keystore après inscription Samsung | Possible | Refaire un partner request avec la nouvelle SHA-256. C'est gratuit mais ça remet 2 semaines d'attente. |
| Samsung change leur policy SDK | Faible (rare) | Suivre les release notes du Samsung Health Sensor SDK, vérifier régulièrement sur le forum dev. |

---

## Plan temporel optimal

```
Maintenant         → Continue le dev sur ta montre (dev mode actif chez toi)
                     L'app marche, tu fais l'UX, le pattern learning, etc.

Semaine 1          → Crée le keystore release local
                     Crée le compte Play Console (25 USD)
                     Build APK release
                     Upload sur Play Console internal track
                     Récupère la SHA-256 de l'app signing key Google

Semaine 1 (suite)  → Soumets le partner request Samsung
                     ⏰ Le compteur 2-14 jours commence à tourner

Semaine 2-3        → Continue le dev, en attendant
                     Tu peux pousser des updates sur Internal Testing
                     pour tester sur ton compte sans approval Samsung
                     (parce que ta montre a le dev mode)

Semaine 3-4        → Approval Samsung reçu (en moyenne)
                     Test validation sur une montre vierge
                     Si OK : push vers Closed Beta puis Production

Mois 2+            → Production ouverte, vrais utilisateurs
                     Monitoring des erreurs SDK Samsung en cas
                     de souci avec leur backend
```

---

## Coût total

| Item | Coût | Quand |
|------|:----:|:------|
| Compte Samsung Developer | **0 €** | Déjà fait |
| Partner request Samsung Health Sensor SDK | **0 €** | Étape 6 |
| Compte Google Play Console | **~23 €** (25 USD) | Étape 5, une fois pour la vie |
| Maintien Samsung partnership | **0 €** | Aucun renouvellement |
| Maintien compte Google Play | **0 €** (après le 25 USD initial) | — |
| **TOTAL pour distribuer mondialement** | **~23 €** | One-shot |

C'est tout. Pas d'abonnement, pas de royalties, pas de revenue share avec Samsung. Google prend 15% sur les ventes Play Store si tu fais payer l'app, mais sinon zéro frais récurrent.

---

## Questions Samsung pourrait te poser (et réponses)

**Q : Where is sensor data processed?**
R : 100% on-device. The accelerometer batches are received via `ACCELEROMETER_CONTINUOUS`, processed by a local CNN model (TFLite, embedded in the APK), and detection results are stored only in the watch's local SQLite database. No data is uploaded to any server. The user's phone receives synced detection counts only via Bluetooth MessageClient, also stored locally.

**Q : What user data do you store?**
R : Only timestamps of detected smoking events, hour of day, day of week, and confidence scores. No raw sensor data is persisted long-term (only a 200-sample ring buffer for the CNN, ~8 seconds of signal).

**Q : Why do you need the continuous accelerometer?**
R : Smoking gesture detection requires recognizing the hand-to-mouth movement pattern, which is a sub-second event that cannot be detected by sampling the accelerometer manually. Continuous 25Hz batched sampling allows us to detect these gestures while preserving battery life (~2-3% per day vs ~25% with traditional SensorManager 50Hz polling).

**Q : Do you collect heart rate?**
R : Currently no. We use Wear OS Health Services for HR baseline (already user-permitted). We may request `HEART_RATE_CONTINUOUS` access from your SDK in a future version to improve detection accuracy.

**Q : What happens if Samsung Health is not installed on the watch?**
R : The app gracefully degrades — `SamsungHealthAccelerometer.isSdkAvailable()` returns false via reflection, and we fall back to a 50Hz duty-cycled SensorManager loop (less battery-efficient but functional).

---

## Liens utiles

- [Samsung Health Sensor SDK overview](https://developer.samsung.com/health/sensor/overview.html)
- [App creation process & partner request](https://developer.samsung.com/health/sensor/process.html)
- [Health Platform developer mode](https://developer.samsung.com/health/sensor/guide/developer-mode.html) — pour tester pendant l'attente
- [Google Play App Signing](https://support.google.com/googleplay/android-developer/answer/9842756) — tout sur Play App Signing
- [Android Studio: signing your app](https://developer.android.com/studio/publish/app-signing) — création du keystore release
