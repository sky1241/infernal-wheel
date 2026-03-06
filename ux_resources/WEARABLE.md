# UX Wearable Complet - Patterns Smartwatch

> Regles UX/UI exhaustives pour applications smartwatch
> Plateformes: Wear OS (Samsung One UI Watch), watchOS, Fitbit OS, Garmin Connect IQ
> Sources: Guidelines officielles Google, Apple, Samsung + recherche UX 2024-2026

---

## A. Fondamentaux Ecran

### 1. Catalogue Ecrans par Modele

| Modele | Taille ecran | Resolution (px) | PPI | Forme | Batterie | RAM | Chipset |
|--------|-------------|-----------------|-----|-------|----------|-----|---------|
| **Galaxy Watch 4 (40mm)** | 1.19" | 396x396 | ~330 | Rond | 247 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 4 (44mm)** | 1.36" | 450x450 | ~321 | Rond | 361 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 5 (40mm)** | 1.19" | 396x396 | ~330 | Rond | 284 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 5 (44mm)** | 1.36" | 450x450 | ~321 | Rond | 410 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 5 Pro** | 1.36" | 450x450 | ~321 | Rond | 590 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 6 (40mm)** | 1.31" | 432x432 | ~327 | Rond | 300 mAh | 2 GB | Exynos W930 |
| **Galaxy Watch 6 (44mm)** | 1.47" | 480x480 | ~327 | Rond | 425 mAh | 2 GB | Exynos W930 |
| **Galaxy Watch 6 Classic** | 1.47" | 480x480 | ~327 | Rond | 425 mAh | 2 GB | Exynos W930 |
| **Galaxy Watch 7 (40mm)** | 1.31" | 432x432 | ~330 | Rond | 300 mAh | 2 GB | Exynos W1000 (3nm) |
| **Galaxy Watch 7 (44mm)** | 1.47" | 480x480 | ~327 | Rond | 425 mAh | 2 GB | Exynos W1000 (3nm) |
| **Galaxy Watch Ultra** | 1.47" | 480x480 | ~327 | Rond (coussin) | 590 mAh | 2 GB | Exynos W1000 (3nm) |
| **Galaxy Watch FE** | 1.19" | 396x396 | ~330 | Rond | 247 mAh | 1.5 GB | Exynos W920 (5nm) |
| **Galaxy Watch 8 (40mm)** | 1.31" | 432x432 | ~330 | Rond | 325 mAh | 2 GB | Exynos W1000 (3nm) |
| **Galaxy Watch 8 (44mm)** | 1.47" | 480x480 | ~327 | Rond | 435 mAh | 2 GB | Exynos W1000 (3nm) |
| **Galaxy Watch 8 Classic** | 1.34" | 480x480 | ~350 | Rond | 445 mAh | 2 GB | Exynos W1000 (3nm) |
| **Pixel Watch 1** | 1.24" | 450x450 | ~320 | Rond | 294 mAh | 2 GB | Exynos 9110 + Cortex-M33 |
| **Pixel Watch 2** | 1.20" | 450x450 | ~320 | Rond | 306 mAh | 2 GB | Snapdragon W5 |
| **Pixel Watch 3 (41mm)** | 1.27" | 408x408 | ~320 | Rond | 307 mAh | 2 GB | Snapdragon W5 |
| **Pixel Watch 3 (45mm)** | 1.40" | 456x456 | ~320 | Rond | 420 mAh | 2 GB | Snapdragon W5 |
| **Apple Watch SE (2nd)** | 1.57" | 324x394 | ~326 | Rect arrondi | ~296 mAh | 1 GB | S8 SiP |
| **Apple Watch Series 9 (41mm)** | 1.69" | 352x430 | ~326 | Rect arrondi | ~282 mAh | 1 GB | S9 SiP |
| **Apple Watch Series 9 (45mm)** | 1.90" | 396x484 | ~326 | Rect arrondi | ~308 mAh | 1 GB | S9 SiP |
| **Apple Watch Series 10 (42mm)** | 1.60" | 374x446 | ~326 | Rect arrondi | ~282 mAh | 1 GB | S10 SiP |
| **Apple Watch Series 10 (46mm)** | 1.80" | 416x496 | ~326 | Rect arrondi | ~308 mAh | 1 GB | S10 SiP |
| **Apple Watch Ultra 2** | 2.00" | 410x502 | ~326 | Rect arrondi | ~564 mAh | 1 GB | S9 SiP |
| **Fitbit Sense 2** | 1.58" | 336x336 | ~229 | Carre arrondi | ~6 jours | N/A | N/A |
| **Fitbit Versa 4** | 1.58" | 336x336 | ~229 | Carre arrondi | ~6 jours | N/A | N/A |
| **Garmin Venu 3** | 1.40" | 454x454 | ~319 | Rond | ~14 jours | N/A | N/A |
| **Garmin Venu 3S** | 1.20" | 390x390 | ~459 | Rond | ~10 jours | N/A | N/A |

**Source:** [GSMArena](https://www.gsmarena.com), [Google Store Specs](https://store.google.com), [Apple Watch Specs](https://www.apple.com/apple-watch-series-9/specs/)

### 2. Densites et Breakpoints Wear OS

| Concept | Valeur | Notes |
|---------|--------|-------|
| Plus petit ecran supporte | **192 dp** | Toujours designer pour celui-ci d'abord |
| Breakpoint petit/grand | **225 dp** | Seuil pour reveler du contenu supplementaire |
| Plus grand ecran courant | **240 dp** | Gros Galaxy Watch / Pixel Watch 45mm |
| Marges externes | **Pourcentages, pas dp fixes** | Permet scaling proportionnel sur ecran rond |
| Zone utilisable ecran rond | **~78-80%** | Un cercle inscrit dans un carre perd ~22% des coins |

**Regle cle:** Designer d'abord pour 192dp, puis adapter pour 225dp+ avec contenu supplementaire.

### 2b. Responsive Layouts & Quality Tiers

**Breakpoint principal:**

```kotlin
const val LARGE_DISPLAY_BREAKPOINT = 225  // dp

@Composable
fun isLargeDisplay() =
    LocalConfiguration.current.screenWidthDp >= LARGE_DISPLAY_BREAKPOINT
```

**3 tiers de qualite Google:**

| Tier | Objectif | Critere |
|------|----------|---------|
| **Tier 1: Ready** | Marche sur tous les ecrans | Marges en %, pas de clipping, contenu centre |
| **Tier 2: Responsive** | Plus de contenu sur grands ecrans | Layouts adaptatifs, composants redimensionnes |
| **Tier 3: Adaptive** | Experiences differenciees | Breakpoints, features uniques grands ecrans, shape morphing |

**Regles critiques:**
- Marges TOUJOURS en pourcentage (pas en dp fixe)
- Un grand ecran ne doit JAMAIS afficher MOINS qu'un petit
- Scrolling views: top/bottom/side margins = percentages
- Non-scrolling views: percentages + vertical constraints
- Designer pour 192-216dp d'abord, puis enrichir a 225dp+

**Responsive padding (Horologist):**

```kotlin
val contentPadding = rememberResponsiveColumnPadding(
    first = ColumnItemType.ListHeader,
    last = ColumnItemType.Button,
)
```

**Screenshot testing multi-tailles (Roborazzi):**

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)
class ScreenTest(override val device: WearDevice) : WearScreenshotTest() {
    override val tolerance = 0.02f
    @Test fun test() = runTest { AppScaffold { MyScreen() } }
    companion object {
        @JvmStatic @ParameterizedRobolectricTestRunner.Parameters
        fun devices() = WearDevice.entries
    }
}
// ./gradlew recordRoborazziDebug  → generer golden images
// ./gradlew verifyRoborazziDebug  → verifier contre golden
```

**Source:** [Android Developers - Screen Sizes](https://developer.android.com/training/wearables/compose/screen-size)

### 3. Zone Utile sur Ecran Rond

```
     ___________
    /   PERDUE   \     Les 4 coins d'un ecran rond
   /  +---------+ \    sont inutilisables.
  |   |         |  |
  |   | ZONE    |  |   Zone utile = cercle inscrit
  |   | UTILE   |  |   = ~78% de la surface totale
  |   |         |  |
   \  +---------+ /    Garder le contenu important
    \___________/      AU CENTRE, jamais dans les coins

  Marge de securite recommandee:
  - Wear OS: ~10.5% du diametre depuis chaque bord
  - Soit environ 20dp de marge sur ecran 192dp
  - Utiliser des marges en % pour s'adapter
```

| Zone | Distance du bord | Usage |
|------|-----------------|-------|
| Centre sur (safe zone) | >10.5% du diametre | Texte, boutons, contenu principal |
| Zone intermediaire | 5-10% du diametre | Icones, indicateurs secondaires |
| Bord extreme | <5% du diametre | PositionIndicator, ArcLine, decorations |
| Coins (ecran rond) | Hors cercle | INUTILISABLE - toujours noir |

**Glanceability (temps de comprehension):**
- Cible: l'utilisateur comprend l'ecran en **< 3 secondes** (etudes NNGroup)
- Session moyenne sur montre: **8-12 secondes** (vs 4 min sur telephone)
- Max 1 info principale + 2 secondaires par ecran
- Hierarchie: gros chiffre > icone > texte court > detail
- Nombre de boutons max: **3** par ecran (ideal: 1-2)
- Cognitive load: **1 decision max** par ecran (oui/non, +1/annuler)
- Sessions/jour montre: ~80-100 micro-sessions (vs ~50 sur telephone)
- Negative space: minimum **30-40%** de l'ecran doit etre vide/noir

**Anti-patterns ecran rond:**
- Placer du texte ou boutons dans les coins → coupe/invisible
- Utiliser des marges fixes en dp → ne scale pas entre 192dp et 240dp
- Ignorer le chin (certaines montres anciennes ont un bord plat en bas)
- Oublier que le contenu scrolle sous le TimeText en haut

---

## B. Touch Targets & Interactions

### 4. Touch Targets

| Plateforme | Minimum | Recommande | Exception | Source |
|-----------|---------|------------|-----------|--------|
| **Wear OS** | 48x48 dp | 52x52 dp | 40x40 dp (espace contraint) | [Android Developers - Accessibility](https://developer.android.com/training/wearables/accessibility) |
| **watchOS** | 44x44 pt | 44x44 pt+ | N/A - toujours 44pt minimum | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos) |
| **Fitbit** | ~48 px | N/A | N/A | Fitbit SDK |
| **Garmin** | Boutons physiques | N/A | Tactile + boutons selon modele | Garmin Developer |

**Tailles boutons Wear OS Material 3:**

| Taille | Icone | Conteneur | Touch target | Usage |
|--------|-------|-----------|-------------|-------|
| Large | 30x30 dp | 60x60 dp | 60x60 dp | Action principale, CTA |
| Default | 26x26 dp | 52x52 dp | 52x52 dp | Actions standard |
| Small | 24x24 dp | 48x48 dp | 48x48 dp | Arrangements compacts |
| Extra Small | 24x24 dp | 32x32 dp | **48x48 dp** (padding) | Inline, toujours ajouter padding |

**Source:** [Android Developers - Buttons](https://developer.android.com/design/ui/wear/guides/m2-5/components/buttons)

**Comportement responsive boutons (IME):**
- 1-2 boutons → s'etirent jusqu'aux marges laterales peu importe la taille
- 3 boutons sur ecran < 225dp → restent circulaires
- 3 boutons sur ecran >= 225dp → s'etirent aux marges

### 5. Gestures et Navigation

| Geste | Wear OS | watchOS | Samsung One UI |
|-------|---------|---------|---------------|
| Swipe droite | **Back** (dismiss) | Retour | Back (+ bezel) |
| Swipe gauche | Page suivante (si pager) | N/A | Page suivante |
| Swipe haut | Notifications | Control Center | Notifications |
| Swipe bas | Quick Settings | Notifications | Quick Settings |
| Tap long | Menu contextuel | Personnalisation | Menu contextuel |
| Double tap | N/A | Double Tap gesture (watchOS 11) | N/A |
| Bouton physique | Home / Recent apps | Digital Crown / Side button | Home + Back |

**Swipe-to-Dismiss (Wear OS):**
- SwipeDismissableNavHost gere ca automatiquement
- Edge swipe = 10% gauche de l'ecran → dismiss
- Reserver 20% du bord pour le geste systeme
- Les Activities supportent swipe-to-dismiss automatiquement
- Conflit: si le contenu est swipable horizontalement, utiliser edge swipe

**Source:** [Android Developers - Navigation](https://developer.android.com/design/ui/wear/guides/m2-5/behaviors-and-patterns/navigation)

### 6. Rotary Input (Bezel / Crown)

| Appareil | Type | Fonctionnement |
|----------|------|---------------|
| Galaxy Watch 4/5/6/7 | Bezel tactile digital | Glisser le doigt sur le bord de l'ecran |
| Galaxy Watch 4/6/8 Classic | Bezel physique rotatif | Tourner mecaniquement |
| Pixel Watch | RSB (Rotary Side Button) | Tourner la couronne laterale |
| Apple Watch | Digital Crown | Tourner la couronne avec detents haptiques |
| Garmin | Boutons physiques | Haut/Bas via boutons |

**Guidelines rotary input Wear OS:**
- Supporté par defaut dans ScalingLazyColumn
- Important pour accessibilite (alternative au scroll tactile)
- Feedback haptique a chaque cran recommande (`HapticFeedbackType.RotaryScroll`)
- Utiliser pour: scroll, ajuster valeurs (volume, timer), navigation listes
- API: `RotaryInputEvent` via `onGenericMotionEvent` ou Compose `rotaryScrollable()`
- Fast rotation → fling/inertial scroll

**Samsung bezel physique (Classic):**
- ~24 positions de detent par rotation complete
- Exposed via standard `RotaryInputEvent` Wear OS

**Apple Watch Digital Crown:**
- Single press = Home, Double press = derniere app, Long press = Siri
- Scroll speed variable (non-lineaire, accelere avec rotation rapide)
- API: `WKCrownSequencer` / `digitalCrownRotation` en SwiftUI

**Garmin - navigation boutons:**
- UP/DOWN = scroll widgets/menu
- SELECT/START = confirmer
- BACK/LAP = retour / action secondaire
- LIGHT (long press) = menu power

### 6b. Rotary Input Implementation (Compose)

**Built-in:** `TransformingLazyColumn`, `ScalingLazyColumn`, `Picker` supportent le rotary par defaut dans AppScaffold/ScreenScaffold.

**Scroll indicator integre:**

```kotlin
val listState = rememberTransformingLazyColumnState()
ScreenScaffold(
    scrollState = listState,
    scrollIndicator = { ScrollIndicator(state = listState) }
) { /* content */ }
```

**Custom rotary (ex: controle volume):**

```kotlin
val focusRequester = remember { FocusRequester() }

TransformingLazyColumn(
    modifier = Modifier
        .fillMaxSize()
        .onRotaryScrollEvent {
            viewModel.onVolumeChange(it.verticalScrollPixels)
            true  // true = event consomme
        }
        .focusRequester(focusRequester)
        .focusable(),
) { /* items */ }

LaunchedEffect(Unit) { focusRequester.requestFocus() }
```

**Snap fling (items qui s'accrochent):**

```kotlin
ScalingLazyColumn(
    state = state,
    flingBehavior = ScalingLazyColumnDefaults.snapFlingBehavior(state = state)
) { /* items */ }
```

**Regles:**
- `onRotaryScrollEvent` retourne `Boolean` (true = consomme, false = propage)
- `focusRequester` + `.focusable()` OBLIGATOIRES pour recevoir les events
- Toujours fournir un feedback visuel (ScrollIndicator ou changement de valeur)
- Utiliser `focusTarget` au lieu de `focusable` pour meilleures performances (M3)

**Source:** [Android Developers - Rotary Input](https://developer.android.com/training/wearables/compose/rotary-input)

### 7. Wrist Gestures

| Geste | Effet | Plateforme | Timing |
|-------|-------|-----------|--------|
| Lever le poignet (raise to wake) | Allume l'ecran | Toutes | 200-400ms |
| Baisser le poignet (lower to sleep) | Eteint l'ecran | Toutes | ~3-5s |
| Flick poignet vers le haut | Scroll vers le bas | Wear OS (opt-in) | - |
| Flick poignet vers le bas | Scroll vers le haut | Wear OS (opt-in) | - |
| Secouer (shake) | Undo | watchOS | - |
| Double tap (pouce+index) | Action principale | watchOS 10+ (Series 9/Ultra 2) | 2 taps en ~500ms. watchOS 11: scroll listes + `.handGestureShortcut(.primaryAction)` |
| Couvrir l'ecran (paume) | Couper le son | watchOS | ~3s |
| Incliner (tilt) | Parallax / scroll | Wear OS (experimental) | - |
| Long press bouton | Action systeme | Wear OS (~500ms) | 500ms |

**Timings raise-to-wake:**
- Wear OS: ~300-400ms de detection a ecran allume
- watchOS: ~200-300ms (configurable dans Settings)

**Note:** Les wrist gestures sont opt-in sur Wear OS et peu utilises en pratique. Ne pas en dependre comme navigation principale.

### 7b. Voice Input

| Aspect | Detail |
|--------|--------|
| Quand offrir la voix | Saisie texte, recherche, reponses rapides, mains occupees |
| Quand NE PAS offrir | Environnement bruyant, contexte prive, valeur precise |
| Google Assistant (Wear OS) | "Hey Google", traitement on-device partiel (Wear OS 3+) |
| Siri (watchOS) | Raise-to-speak (sans wake word si active), long press Crown |
| Latence on-device | ~200-500ms |
| Latence cloud | ~1-3s selon connexion |
| Saisie texte | Voix = input par defaut, clavier = fallback |
| Bruit | Micro au poignet = sensible au vent/bruit ambiant → fallback tactile |

**watchOS screen widths en points (pour design):**

| Taille montre | Largeur ecran (pt) | Padding liste (px) |
|--------------|-------------------|--------------------|
| 38mm / 40mm | 136 pt / 162 pt | ~15 px chaque cote |
| 41mm / 42mm | 162 pt / 176 pt | ~15 px chaque cote |
| 44mm / 45mm | 176 pt | ~15 px chaque cote |
| 49mm Ultra 2 | 187 pt | ~18 px chaque cote |

**watchOS tailles minimales controles:**

| Type | 42mm | 38mm |
|------|------|------|
| Controle circulaire | 80x80 px min | 75x75 px min |
| Bouton rectangulaire | Hauteur 53 px min | Hauteur 50 px min |
| Touch target | 44x44 pt | 44x44 pt |

**watchOS layout margins:**
- Utiliser `systemMinimumLayoutMargins` pour respecter les marges systeme
- Utiliser `safeAreaInsets` pour la zone de contenu
- Typography: bold + alignement gauche (watchOS 11+, meilleure lisibilite)

### 7c. Text Input sur Montre

**Principe fondamental:** La montre n'est PAS faite pour taper du texte. Eviter autant que possible.

> "Help people complete tasks on the watch within seconds to avoid ergonomic discomfort or arm fatigue."
> — [Principles of Wear OS development](https://developer.android.com/training/wearables/principles)

**Hierarchie des methodes d'input (du meilleur au pire):**

| Rang | Methode | Quand utiliser | Latence | Plateforme |
|------|---------|----------------|---------|------------|
| 1 | **Pre-defined choices** | Choix parmi options fixes (humeur, raison) | Instantane | Wear OS + watchOS |
| 2 | **Voice dictation** | Texte libre, mains libres, environnement calme | ~1-3s | Wear OS + watchOS |
| 3 | **Canned responses / Smart Reply** | Reponses rapides a messages, notifications | Instantane | Wear OS + watchOS |
| 4 | **Emoji** | Reactions, sentiments, feedback rapide | ~2 taps | Wear OS + watchOS |
| 5 | **Handwriting (Scribble)** | Texte court, pas de voix possible, bruyant | ~1s/lettre | Wear OS + watchOS |
| 6 | **Clavier on-screen** | Dernier recours, texte tres court | Lent | Wear OS (Gboard/Samsung) + watchOS (Series 7+) |

**Quand NE PAS demander de texte sur montre:**

| Situation | Alternative |
|-----------|-------------|
| Mot de passe | OAuth / token sharing depuis telephone |
| Texte > 2-3 mots | Rediriger vers telephone via `RemoteActivityHelper` |
| Formulaire multi-champs | Companion app sur telephone |
| Donnees structurees (email, URL) | Companion app |
| Validation complexe (regex, format) | Companion app |

#### 7c-1. RemoteInput API (Wear OS)

L'API principale pour le texte sur Wear OS. Ecran systeme avec: dictee, emoji, canned responses, smart reply, et IME.

**Dependance Gradle:**

```kotlin
implementation("androidx.wear:wear-input:1.2.0-alpha02")
implementation("androidx.core:core-ktx:1.13.1")
```

**RemoteInput pour notifications (reply action):**

```kotlin
private const val KEY_TEXT_REPLY = "key_text_reply"

val remoteInput = RemoteInput.Builder(KEY_TEXT_REPLY)
    .setLabel("Reponse rapide")
    .setChoices(arrayOf("OK", "En route", "Plus tard", "Appelle-moi"))
    .build()

val replyAction = NotificationCompat.Action.Builder(
    R.drawable.ic_reply, "Repondre", replyPendingIntent
)
    .addRemoteInput(remoteInput)
    .setAllowGeneratedResponses(true)  // Active Smart Reply ML
    .build()

// MessagingStyle recommande (donne plus de contexte au Smart Reply)
val notification = NotificationCompat.Builder(context, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_message)
    .setStyle(
        NotificationCompat.MessagingStyle(person)
            .addMessage("Salut, tu fumes?", timestamp, sender)
    )
    .addAction(replyAction)
    .build()
```

**Recuperer la reponse (BroadcastReceiver):**

```kotlin
class ReplyReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val results = RemoteInput.getResultsFromIntent(intent)
        val replyText = results?.getCharSequence(KEY_TEXT_REPLY)
        if (replyText != null) processReply(replyText.toString())
    }
}
```

**setChoices() — Canned Responses (i18n):**

```kotlin
// res/values/strings.xml → <string-array name="smoking_reasons">
val choices = context.resources.getStringArray(R.array.smoking_reasons)
val remoteInput = RemoteInput.Builder("reason_key")
    .setLabel("Pourquoi cette cigarette?")
    .setChoices(choices)
    .setAllowFreeFormInput(true)  // true = choix + texte libre
    .build()
```

#### 7c-2. RemoteInput Standalone dans l'App (Compose)

**Important:** Compose for Wear OS n'a PAS de `TextField`. Utiliser `RemoteInputIntentHelper`.

```kotlin
@Composable
fun TextInputScreen() {
    var userInput by remember { mutableStateOf("") }

    val inputLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val results = RemoteInput.getResultsFromIntent(
                result.data ?: return@rememberLauncherForActivityResult
            )
            userInput = results?.getCharSequence("input_key")?.toString() ?: ""
        }
    }

    val remoteInputs = listOf(
        RemoteInput.Builder("input_key")
            .setLabel("Note rapide")
            .setChoices(arrayOf("Stress", "Social", "Habitude", "Ennui"))
            .setAllowFreeFormInput(true)
            .build()
    )

    val intent = RemoteInputIntentHelper.createActionRemoteInputIntent()
    RemoteInputIntentHelper.putRemoteInputsExtra(intent, remoteInputs)
    RemoteInputIntentHelper.putTitleExtra(intent, "Raison de la cigarette")

    Chip(
        onClick = { inputLauncher.launch(intent) },
        label = { Text("Ajouter une note") },
        secondaryLabel = {
            Text(userInput.ifEmpty { "Appuyer pour saisir" },
                maxLines = 1, overflow = TextOverflow.Ellipsis)
        },
        icon = { Icon(Icons.Default.Edit, contentDescription = "Saisir") }
    )
}
```

#### 7c-3. Voice Dictation (Compose)

```kotlin
@Composable
fun VoiceInputScreen() {
    var spokenText by remember { mutableStateOf("") }

    val voiceLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ) { result ->
        result.data?.let { data ->
            val results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
            spokenText = results?.firstOrNull() ?: ""
        }
    }

    val voiceIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
        putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        putExtra(RecognizerIntent.EXTRA_PROMPT, "Pourquoi cette cigarette?")
    }

    Chip(
        onClick = { voiceLauncher.launch(voiceIntent) },
        label = { Text("Dicter une note") },
        secondaryLabel = { Text(spokenText.ifEmpty { "Appuyer pour parler" }) }
    )
}
```

**Limitations voix:** Micro au poignet sensible au vent/bruit. Cloud = 1-3s latence, on-device = 200-500ms (Wear OS 3+).

#### 7c-4. On-Screen Keyboard (IME)

| Clavier | Marque | Features |
|---------|--------|----------|
| **Gboard** | Google (Pixel Watch) | QWERTY, glide typing, dictee, emoji, handwriting |
| **Samsung Keyboard** | Samsung (Galaxy Watch) | QWERTY, T9, handwriting, dictee, emoji |

**Handwriting:** Disponible via Gboard/Samsung Keyboard. Character par character, plus lent que voix mais fonctionne en environnement bruyant. Pas d'API separee.

#### 7c-5. watchOS Text Input

| Methode | Disponibilite | Description |
|---------|---------------|-------------|
| **Dictation** | Tous modeles | Parler pour transcrire. Ponctuation vocale supportee |
| **Scribble** | Tous modeles | Ecrire lettres avec doigt. Crown = suggestions |
| **On-screen keyboard** | Series 7+ / Ultra (PAS SE, PAS Series 6) | QWERTY + QuickPath (glide) |
| **Emoji** | Tous modeles | Via bouton emoji depuis n'importe quelle methode |

**TextField (watchOS 7+) — champ inline:**

```swift
TextField("Note rapide", text: $noteText)
    .textInputAutocapitalization(.sentences)
    .submitLabel(.done)
    .onSubmit { saveNote(noteText) }
```

**TextFieldLink (watchOS 9+) — ecran dedie, meilleur UX:**

```swift
TextFieldLink(
    prompt: "Pourquoi cette cigarette?",
    label: { Label("Raison", systemImage: "pencil") }
) { newText in noteText = newText }
```

**Quick replies (pattern recommande):**

```swift
List {
    ForEach(quickReplies, id: \.self) { reply in
        Button(reply) { submitReason(reply) }
    }
    TextFieldLink("Autre...") { customText in
        submitReason(customText)
    }
}
```

**TextField vs TextFieldLink:**

| Aspect | TextField | TextFieldLink |
|--------|-----------|---------------|
| Disponibilite | watchOS 7+ | watchOS 9+ |
| Apparence | Champ inline | Bouton → ecran dedie |
| Texte initial | Supporte (`$binding`) | Ne supporte PAS de texte initial |
| UX recommande | Formulaires simples | Saisie ponctuelle (prefere) |

#### 7c-6. Accessibilite Text Input

| Aspect | Detail |
|--------|--------|
| Voice en premier | Toujours offrir la dictee comme option principale |
| Choix pre-definis | Reduisent besoin saisie manuelle |
| Feedback haptique | Confirmer chaque action de saisie |
| TalkBack + clavier | Mode full-screen IME mieux supporte |
| watchOS VoiceOver | Supporte avec TextField et TextFieldLink |
| Clavier Bluetooth watchOS | Pairable pour saisie accessible |

#### 7c-7. Decision Tree — Quel Input Choisir

```
Besoin de saisie texte sur montre?
├── NON → Ne pas demander. Utiliser boutons/sliders.
└── OUI → Peut-on offrir des choix pre-definis?
    ├── OUI → setChoices() (Wear OS) / List de Button (watchOS)
    └── NON → Texte libre necessaire?
        ├── Court (1-5 mots) → Voice dictation + IME fallback
        │   ├── Wear OS: RemoteInputIntentHelper
        │   └── watchOS: TextFieldLink (watchOS 9+)
        └── Long (phrase+) → Rediriger vers telephone
            ├── Wear OS: RemoteActivityHelper
            └── watchOS: WCSession transferUserInfo

Max recommande: ~50 caracteres. Single-line ONLY.
```

**Pour Infernal Wheel specifiquement:**
- Raison de la cigarette: **boutons pre-definis** (Stress, Social, Habitude, Ennui, Pause, Autre)
- Note libre optionnelle: **voice dictation** (max 1 phrase) OU rediriger vers telephone
- Humeur: **emoji ou slider** (pas de texte)

**Sources:** [Voice input](https://developer.android.com/training/wearables/user-input/voice), [Wear IME](https://developer.android.com/training/wearables/user-input/wear-ime), [RemoteInputIntentHelper](https://developer.android.com/reference/androidx/wear/input/RemoteInputIntentHelper), [TextFieldLink](https://developer.apple.com/documentation/swiftui/textfieldlink)

---

## C. Composants UI

### 8. Composants Wear OS Compose (Material 3)

| Composant | Role | Dimensions | Details |
|-----------|------|-----------|---------|
| **ScalingLazyColumn** | Liste scrollable avec scaling | Spacing 4dp, padding ~28dp top/bottom | Items centre=100%, bords=~70%. Snap-and-fling. Rotary input par defaut. AutoCentering active. En M3: remplace par `TransformingLazyColumn` |
| **Chip** | Element de liste interactif | **52dp** hauteur, pleine largeur | Icone 24dp, label + secondaryLabel, styles: primary/secondary/outlined/child/gradient |
| **CompactChip** | Version compacte | **32dp** hauteur, touch 48dp | Icone 20dp, visuellement petit mais touch target maintenu |
| **Button** | Action circulaire | Large 60dp, Default 52dp, Small 48dp, XS 32dp | Icones 30/26/24/20dp. Circulaire. Styles: primary/secondary/icon/outlined |
| **OutlinedButton** | Emphasis moyenne | Suit tailles Button | Fond transparent, contour primary 60% opacite |
| **ToggleButton** | Bascule on/off | Suit tailles Button | 2 etats visuels distincts |
| **Card** | Conteneur d'information | Min **52dp** hauteur, radius **24dp** | Padding 12dp. Types: Card, AppCard (app+time+title+body), TitleCard (title+body) |
| **TimeText** | Heure en haut d'ecran | ~12sp, ~2dp du bord | TOUJOURS present. Courbe sur ecran rond, lineaire sur carre. Prepend/append custom content |
| **PositionIndicator** | Barre de scroll laterale | ~4dp epaisseur | Cote droit, arc courbe. Fade-out apres ~1.5s sans scroll |
| **Picker** | Selection de valeur | ~48dp par slot, 3-5 items visibles | Scroll rotatif, haptic. TimePicker, DatePicker (compound) |
| **Dialog / Alert** | Confirmation / alerte | Plein ecran | Alert: titre + message + max 2 boutons (empiles vertical). ScrollLazyColumn interne |
| **Confirmation** | Feedback bref | Plein ecran | Icone + texte optionnel, auto-dismiss **4000ms** par defaut |
| **ProgressIndicator** | Progression circulaire | Stroke 4dp, start 270deg (12h) | Track = surface variant, indicator = primary. Indeterminate: rotation ~1.5s |
| **Stepper** | +/- avec valeur | Chaque bouton ~1/3 ecran | Boutons haut(+)/bas(-) avec valeur centrale. Icones 24dp |
| **SwipeToDismissBox** | Container dismissable | Edge zone 20%, completion >50% | Swipe droite = fermer. Fond: ecran precedent visible pendant swipe. Alpha fade |
| **Vignette** | Assombrissement bords | ~40dp profondeur | Modes: Top, Bottom, TopAndBottom. Gradient noir semi-transparent |

**Horologist library (supplements officiels Google):**
- `rememberResponsiveColumnPadding()` → **26.5%** padding horizontal automatique pour ecrans ronds
- Enhanced date/time pickers, media controls, volume screen
- Rotary input ameliore avec haptic feedback
- ScalingLazyColumn avec snap-and-fling (pour navigation precise)

### 8b. Migration Material 2.5 → Material 3 (Wear OS 6+)

**Dependances M3:**
```gradle
implementation("androidx.wear.compose:compose-material3:1.6.0-beta01")
implementation("androidx.wear.compose:compose-foundation:1.6.0-beta01")
```

**Renommages majeurs M2.5 → M3:**

| M2.5 | M3 | Notes |
|------|-----|-------|
| `Chip` | `Button`, `OutlinedButton`, `FilledTonalButton`, `ChildButton` | Split en variantes |
| `CompactChip` | `CompactButton` | Renomme |
| `Button` (circulaire) | `IconButton` ou `TextButton` | Split en specialises |
| `ToggleChip` | `CheckboxButton`, `RadioButton`, `SwitchButton` | Par type de toggle |
| `SplitToggleChip` | `SplitCheckboxButton`, `SplitRadioButton`, `SplitSwitchButton` | Idem |
| `ToggleButton` | `IconToggleButton` ou `TextToggleButton` | Split |
| `InlineSlider` | `Slider` | Renomme |
| `PositionIndicator` | `ScrollIndicator` | API simplifiee |
| `Scaffold` | `AppScaffold` + `ScreenScaffold` | Split en 2 composants |
| `Alert` | `AlertDialog` | Renomme |
| `Confirmation` | `ConfirmationDialog` | Renomme |
| `Vignette` | SUPPRIME | Plus dans M3 |
| `ScalingLazyColumn` | `TransformingLazyColumn` | Morphing animations |

**Nouveaux composants M3 (sans equivalent M2.5):**

| Composant | Role |
|-----------|------|
| **EdgeButton** | Bouton epousant le bord bas de l'ecran rond, 4 tailles |
| **AnimatedText** | Texte anime avec flex fonts |
| **ButtonGroup** | Groupe de boutons organises |
| **SegmentedCircularProgressIndicator** | Progress segmente |
| **HorizontalPagerScaffold** | Scaffold avec paging horizontal |
| **VerticalPagerScaffold** | Scaffold avec paging vertical |
| **OpenOnPhoneDialog** | Dialog "Ouvrir sur le telephone" |
| **DatePicker** | Selecteur de date |
| **LevelIndicator** | Indicateur de niveau/range |
| **ListSubHeader** | Sous-titre de section dans liste |

**Systeme de couleurs M3:**
- M2.5: 13 couleurs → M3: **28 couleurs** (primary, secondary, tertiary, surface variants)
- **Dynamic Color** (Wear OS 6): theme auto genere depuis les couleurs du watch face
- `dynamicColorScheme(LocalContext.current)` → palette auto

**Shape morphing M3:**
- Boutons animent leur forme lors d'interactions
- `IconButtonDefaults.animatedShape()`, `TextButtonDefaults.animatedShape()`
- Feedback visuel micro-animation sans coder custom

**Typographie M3 etendue:**
- Ajout: `bodyExtraSmall`, `numeralExtraLarge`, `numeralExtraSmall`
- **Flex Fonts**: poids, largeur, rondeur configurables dynamiquement
- `AnimatedText` utilise flex fonts pour transitions fluides

### 8c. TransformingLazyColumn (M3)

Remplace `ScalingLazyColumn` pour les listes avec effets de morphing.

```kotlin
val columnState = rememberTransformingLazyColumnState()
val contentPadding = rememberResponsiveColumnPadding(
    first = ColumnItemType.ListHeader,
    last = ColumnItemType.Button,
)
val transformationSpec = rememberTransformationSpec()

ScreenScaffold(scrollState = columnState, contentPadding = contentPadding) { cp ->
    TransformingLazyColumn(state = columnState, contentPadding = cp) {
        item {
            ListHeader(
                modifier = Modifier.fillMaxWidth()
                    .transformedHeight(this, transformationSpec),
                transformation = SurfaceTransformation(transformationSpec)
            ) { Text("Header") }
        }
        // items...
    }
}
```

**TransformingLazyColumn vs ScalingLazyColumn (Horologist):**

| Feature | TransformingLazyColumn | ScalingLazyColumn |
|---------|----------------------|-------------------|
| Scaling/Morphing | Oui (transformation riche) | Basique (scale + alpha) |
| Snap-and-Fling | Non | Oui (RotaryMode.Snap) |
| Rotary input | Supporte | Supporte (snap mode) |
| Cas d'usage | Listes standard M3 | Navigation precise item par item |
| Librairie | wear.compose.foundation | Horologist |

### 8d. EdgeButton (M3 - Nouveau)

Bouton epousant le bord inferieur de l'ecran rond. Maximise l'espace du facteur de forme circulaire.

| Taille | Usage |
|--------|-------|
| Extra Small | Actions secondaires compactes |
| Small | Actions standard |
| Medium | Actions importantes |
| Large | CTA principal (recommande pour notre bouton "+1") |

- Place dans `ScreenScaffold(edgeButton = { EdgeButton(...) })`
- Parametre `edgeButtonSpacing` pour l'espace entre le bouton et la liste
- Ideal pour l'action principale sur chaque ecran

**Architecture ecran M3 (Wear OS 6):**
```
AppScaffold {
  ScreenScaffold(
    scrollState = columnState,
    edgeButton = { EdgeButton(onClick = {}, ...) }
  ) { contentPadding ->
    TransformingLazyColumn(state = columnState, contentPadding = contentPadding) {
      item { ListHeader(...) }
      item { Button("Action 1", ...) }  // Ex-Chip en M3
      item { Button("Action 2", ...) }
    }
  }
}
```

**Source:** [Android Developers - Compose for Wear OS](https://developer.android.com/training/wearables/compose)

### 8e-bis. M3 Expressive (Wear OS 6+)

**Shape Morphing:** Les shapes reagissent aux interactions. Les boutons changent de forme dynamiquement (press, check).

| Composant | Comportement |
|-----------|-------------|
| `IconButton` | Shape morph on press (variante expressive) |
| `TextButton` | Shape morph on press |
| `IconToggleButton` | Shape morph on check/uncheck |
| `TextToggleButton` | Shape morph on check/uncheck |
| `ButtonGroup` | Groupe de boutons en ligne, shape-morph quand un est touche |

**ButtonGroup (nouveau):**
- Boutons en ligne qui shape-morphent quand l'un est presse
- 2 strategies de distribution:
  - **Evenly distributed** — symetrie
  - **Strategic arrangement** — hierarchie visuelle, emphase, guidage

**Edge-Hugging Containers:**
- Conteneurs qui epousent la forme ronde de l'ecran
- Maximisent l'espace utilisable sur le canvas circulaire
- Pattern iconique du design Wear OS

**Variable Fonts (Roboto Flex):**
- 3 axes dynamiques: weight, width, weight+width
- Nouveaux type roles specifiques Wear:
  - **Arc Text** — pour titres en arc sur le bord
  - **Numerals** — grands chiffres styles (compteurs, timers)
  - **Proactive content** — texte avec espace pour contenu live

**Motion Scheme:**
- Nouveau `MotionScheme` dans le theme M3
- Springs expressives pour animations
- Shape transitions et morphing fluide
- Variable font axes animes pour feedback interactif

**Corner Radius:**
- Formes flexibles avec rounding/sharpening
- Variete entre conteneurs pour distinction visuelle
- Etablit des relations visuelles entre formes

**Source:** [Android Developers - M3 Expressive](https://developer.android.com/design/ui/wear/guides/get-started/design-language)

### 8f. Dialogs, Pickers & Confirmations (Wear OS)

**AlertDialog (M3):**
- Responsive par defaut (s'adapte aux tailles d'ecran)
- Scrollable automatiquement si contenu depasse
- Variantes: ok/cancel buttons OU EdgeButton

```kotlin
AlertDialog(
    show = showDialog,
    onDismissRequest = { showDialog = false },
    title = { Text("Confirmer ?") },
    text = { Text("Supprimer cette entree ?") },
    confirmButton = {
        Button(onClick = { onConfirm(); showDialog = false }) {
            Text("Oui")
        }
    },
    dismissButton = {
        Button(onClick = { showDialog = false }) {
            Text("Non")
        }
    }
)
```

**ConfirmationDialog (M3):**
- Affiche message + animation avec timeout auto
- 3 types: success, failure, open-on-phone
- Auto-dismiss apres animation (typiquement ~4s)

**ConfirmationActivity (Views legacy):**

```kotlin
val intent = Intent(this, ConfirmationActivity::class.java).apply {
    putExtra(ConfirmationActivity.EXTRA_ANIMATION_TYPE, ConfirmationActivity.SUCCESS_ANIMATION)
    putExtra(ConfirmationActivity.EXTRA_MESSAGE, "Cigarette enregistree")
}
startActivity(intent)
// Types: SUCCESS_ANIMATION, FAILURE_ANIMATION, OPEN_ON_PHONE_ANIMATION
```

**TimePicker:**
- Layouts: 24h (avec/sans secondes), 12h avec AM/PM
- `initialSelection` pour composant selectionne au demarrage
- Type `MinutesSeconds` pour timer
- Animation heading: fade-out + fade-in en Spring

**DatePicker:**
- Ordre configurable: day-month-year, month-day-year, year-month-day
- Min/max dates optionnels
- Meme animation Spring que TimePicker

**Source:** [Android Developers - Dialogs](https://developer.android.com/design/ui/wear/guides/m2-5/components/dialogs)

### 8g-bis. Picker, Stepper & Settings

**Picker (selection de valeur):**

```kotlin
val pickerState = rememberPickerState(initialNumberOfOptions = 24)
Picker(
    state = pickerState,
    modifier = Modifier.size(100.dp, 100.dp),
) { index -> Text("$index") }
```

**PickerGroup (multi-colonnes, ex: heures:minutes):**

```kotlin
PickerGroup(
    pickerColumns = arrayOf(hoursPicker, minutesPicker),
    pickerGroupState = rememberPickerGroupState(),
    separator = { Text(":") }
)
```

**Responsive breakpoints Picker:**

| Layout | < 225dp | >= 225dp |
|--------|---------|----------|
| 2 colonnes spacing | 4dp | 6dp |
| 3 colonnes spacing | 2dp | 6dp |
| Gradient haut/bas | 33% de la hauteur colonne | 33% |

**Stepper (selection de range, plein ecran):**

```kotlin
Stepper(
    value = count.toFloat(),
    onValueChange = { count = it.toInt() },
    steps = 19,  // 0 a 20
    valueRange = 0f..20f,
    decreaseIcon = { Icon(Icons.Default.Remove, "Moins") },
    increaseIcon = { Icon(Icons.Default.Add, "Plus") },
) { Text("$count") }
// Long-press sur +/- = repetition rapide
// En M3: Slider disponible comme alternative compacte (peut etre segmente)
```

**Settings screen patterns (ToggleChip / M3 equivalents):**

| M2.5 | M3 | Usage |
|------|-----|-------|
| `ToggleChip` (Switch) | `SwitchButton` | On/off settings |
| `ToggleChip` (Checkbox) | `CheckboxButton` | Multi-select |
| `ToggleChip` (Radio) | `RadioButton` | Single-select |
| `SplitToggleChip` | `SplitSwitchButton` | 2 zones: nav + toggle |

**SplitToggleChip:** 2 zones tappables independantes — une pour naviguer/agir, une pour le toggle. Couleurs differentes pour distinguer les zones.

**Specs:**
- Icone: 24x24 dp
- Container hauteur: 52dp (responsive)
- Long-press sur +/-: repetition rapide pour ajustement

**Source:** [Android Developers - Pickers](https://developer.android.com/training/wearables/compose/pickers), [Steppers](https://developer.android.com/design/ui/wear/guides/m2-5/components/steppers)

### 8e. Principes Google Officiels pour Wear OS

**5 principes fondamentaux** ([source](https://developer.android.com/training/wearables/principles)):

1. **Design for critical tasks** — 1-2 taches max, pas de port du mobile sur le poignet
2. **Optimize for the wrist** — Taches en secondes, pas de fatigue du bras
3. **Glanceable surfaces** — Complications + Tiles = surfaces prioritaires
4. **Always relevant** — Contenu adapte au contexte (heure, lieu, activite)
5. **Works offline** — Fonctionne sans connexion (sport, transport)

**Best practices layout** ([source](https://developer.android.com/design/ui/wear/guides/surfaces/apps/best-practices)):
- Layout **vertical uniquement** — jamais mixer scroll vertical + horizontal
- Action principale **en haut** de l'ecran, pas en bas d'une longue page
- Scrollbar visible **uniquement** sur les ecrans scrollables
- TimeText (heure) visible partout **sauf** sur dialogues/pickers temporaires
- Labels texte + icones pour tous les points d'entree (jamais icones seules)
- Labels de section pour les dialogues longs avec contenu mixte
- Composants **full-width** (pas de largeur fixe qui ne scale pas)
- Marges en **pourcentages** (pas en dp fixes)

**Surface priority par type d'info:**

| Surface | Priorite | Contenu |
|---------|----------|---------|
| Complication | P1 | Info instantanee (compteur, timer) |
| Notification | P1 | Alertes temps-reel (detection cigarette) |
| Tile | P1-P2 | Resume + action rapide |
| App | P1-P3 | Interface complete + settings |

**Principes fitness/health** ([source](https://developer.android.com/training/wearables/principles)):
- Permission `ACTIVITY_RECOGNITION` requise (API 29+)
- App montre = data gathering, analyse detaillee → telephone
- Ecran resume post-workout sur montre
- `OngoingActivity` API pour activites longues (workout, monitoring)
- **Touch Lock** : desactiver le tactile pendant workout/monitoring actif
- Haptic pour confirmer: start, stop, auto-pause, auto-lap
- **JAMAIS** de wake lock → utiliser Health Services API (CPU dort entre lectures)
- Sensor batching **toujours** quand possible
- Flush sensors quand l'ecran s'active
- Changer la longueur de batch quand l'ecran s'eteint
- Desenregistrer les listeners quand plus necessaires

**Media/audio:**
- Speaker montre = alarmes/rappels, **PAS** pour musique (→ ecouteurs BT)
- Supporter ecouteurs Bluetooth directement depuis la montre
- Si pas d'ecouteurs connectes → ouvrir Settings Bluetooth
- Indiquer clairement la source audio (montre vs telephone)
- Telecharger contenu offline en priorite (pas streaming sauf LTE)
- **WorkManager** pour telechargements differres (sur chargeur + WiFi)

### 8g. Checklist Qualite Google Play (Wear OS)

| ID | Regle | Valeur |
|----|-------|--------|
| WO-V1 | Font scaling utilisateur | Respecter, pas de chevauchement/coupure |
| WO-V2 | Touch targets | **48x48 dp** minimum |
| WO-V3 | Back navigation | Swipe-to-close quasi partout (sauf workout, maps) |
| WO-V4 | Ongoing activity | Indicateur watch face + recent apps + tile |
| WO-V5 | Preserve app state | Restaurer si resume en minutes |
| WO-V8 | Scroll bar | Afficher sur vues scrollables |
| WO-V13 | Background | **Noir** (#000000) apps et tiles |
| WO-V14 | Font min | **12sp** essentiel, **10sp** non-essentiel |
| WO-V15 | Splash screen | Icone **48x48 dp** sur fond noir |
| WO-V16 | Watch shapes | Contenu >= 192dp cercle, pas coupe |
| WO-P1 | Target API | **Android 14 (API 34)** min (aout 2025) |
| WO-P6 | Auth | **JAMAIS** username/password sur montre (utiliser `CredentialManager` ou `RemoteAuthClient`) |
| WO-P7 | AOD pixels | **Max 15%** (verifie toutes les ~10 min) |
| WO-P8 | Memory WFF | **10 MB** ambient, **100 MB** interactif |
| WO-P10 | Complication slots | Max **8** par watch face |
| WO-G5 | Screenshots Play | **1:1 aspect ratio**, pas de device frame |
| WO-G7 | Package | Meme package name + signing key que companion |

**Tests requis Google Play:**
- Emulateur: **small round 1.2" (192dp)** + **large round 1.39" (227dp)**
- Wear OS 3.0 ou superieur
- Firebase Test Lab: Pixel Watch devices

**Source:** [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality)

### 9. Navigation Patterns

| Pattern | Usage | Profondeur max |
|---------|-------|---------------|
| **Lineaire** (horizontal paging) | 2-5 ecrans peers | 1 niveau |
| **Hub and spoke** | Ecran central + sous-ecrans | 2 niveaux |
| **Hierarchique** | Drill-down dans listes | 2-3 niveaux MAX |
| **Notification-first** | L'app = notifications | 0 (pas d'UI principale) |

**Regles de navigation Wear OS:**
- **Max 2-3 niveaux** de profondeur - l'utilisateur se perd au-dela
- Chaque ecran doit etre compris en **< 3 secondes**
- Back = swipe droite, TOUJOURS fonctionnel
- Pas de hamburger menu sur montre
- Pas de bottom navigation bar
- Pas de tabs horizontaux complexes

**Max items visibles par ecran:**
- Wear OS (ecran rond): 5-7 items au centre
- watchOS: 3-5 items selon taille montre
- Max items avant fatigue: ~15-20 (utiliser des sections)

**Anti-patterns navigation:**
- Navigation profonde (> 3 niveaux)
- Menus hamburger / drawer
- Bottom bar avec 5+ items
- Forcer l'utilisateur a chercher une fonctionnalite
- Listes de plus de 20 items sans sections

### 9b. Navigation Compose Implementation

**Dependance:** `androidx.wear.compose:compose-navigation:1.5.6+` (PAS `androidx.navigation:navigation-compose`)

**Pattern complet AppScaffold + SwipeDismissableNavHost:**

```kotlin
AppScaffold {
    val navController = rememberSwipeDismissableNavController()
    SwipeDismissableNavHost(
        navController = navController,
        startDestination = "home"
    ) {
        composable("home") {
            HomeScreen(
                onDetailClick = { id -> navController.navigate("detail/$id") }
            )
        }
        composable("detail/{id}") {
            DetailScreen(id = it.arguments?.getString("id")!!)
        }
    }
}

@Composable
fun DetailScreen(id: String) {
    val scrollState = rememberTransformingLazyColumnState()
    val padding = rememberResponsiveColumnPadding(first = ColumnItemType.BodyText)
    ScreenScaffold(scrollState = scrollState, contentPadding = padding) { cp ->
        TransformingLazyColumn(state = scrollState, contentPadding = cp) {
            // content
        }
    }
}
```

**Differences vs Navigation mobile:**

| Aspect | Mobile | Wear OS |
|--------|--------|---------|
| NavController | `rememberNavController()` | `rememberSwipeDismissableNavController()` |
| NavHost | `NavHost` | `SwipeDismissableNavHost` |
| Container top | Aucun | `AppScaffold` (OBLIGATOIRE) |
| Container ecran | Aucun | `ScreenScaffold` |
| Back | Bouton retour | Swipe droite (automatique) |
| TimeText | Manuel | Automatique via ScreenScaffold |

**Wear OS 6+:** Animations de transition mises a jour automatiquement (API 36+).

**Source:** [Android Developers - Navigation Compose](https://developer.android.com/training/wearables/compose/navigation)

### 9c. HorizontalPager & Page Indicators

**HorizontalPagerScaffold (M3):**

```kotlin
AppScaffold {
    val pagerState = rememberPagerState(pageCount = { 3 })
    HorizontalPagerScaffold(pagerState = pagerState) {
        HorizontalPager(state = pagerState) { page ->
            when (page) {
                0 -> CounterScreen()
                1 -> StatsScreen()
                2 -> SettingsScreen()
            }
        }
    }
}
```

**HorizontalPageIndicator:**
- Max **6 dots** affichees (peu importe le nombre de pages)
- Sur ecran rond: indicateur courbe automatiquement
- Position: centre-end par defaut
- TimeText et indicateur apparaissent/disparaissent selon le paging

**Regles:**
- Pages lazy-loaded (composees a la demande)
- Pages non requises sont supprimees automatiquement
- `HorizontalPagerScaffold` gere TimeText + PageIndicator coordonnes
- Aussi disponible: `VerticalPagerScaffold` pour scroll vertical entre pages

**Source:** [Android Developers - Page Indicators](https://developer.android.com/training/wearables/compose/pagination)

### 9d. Deep Linking (Wear OS)

```kotlin
// Dans le NavGraph
@Serializable data class Detail(val id: String)

composable<Detail>(
    deepLinks = listOf(
        navDeepLink<Detail>(basePath = "https://myapp.com/detail")
    )
) { backStackEntry ->
    DetailScreen(id = backStackEntry.toRoute<Detail>().id)
}
```

**PendingIntent depuis deep link (pour notifications/Ongoing Activity):**

```kotlin
val deepLinkIntent = Intent(
    Intent.ACTION_VIEW,
    "https://myapp.com/detail/$id".toUri(),
    context,
    MainActivity::class.java
)
val pendingIntent = TaskStackBuilder.create(context).run {
    addNextIntentWithParentStack(deepLinkIntent)
    getPendingIntent(0,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
}
```

**Regles:**
- Deep links pas exposes aux apps externes par defaut
- Ajouter `<intent-filter>` dans le manifest pour exposition externe
- Utiliser `androidx.wear.compose:compose-navigation` (PAS la version mobile)

### 9e. State Restoration (Wear OS)

**Process death plus frequent** sur montre (memoire limitee) — sauvegarder l'etat est critique.

| Evenement | UI (Composable) | Business (ViewModel) |
|-----------|-----------------|---------------------|
| Config change (rotation) | `rememberSaveable` | Automatique |
| Process death systeme | `rememberSaveable` | `SavedStateHandle` |

```kotlin
// UI layer — survit au process death
@Composable
fun CounterScreen() {
    var count by rememberSaveable { mutableStateOf(0) }
    // ...
}

// ViewModel layer — survit au process death
class TrackingViewModel(
    private val savedStateHandle: SavedStateHandle
) : ViewModel() {
    var cigaretteCount by savedStateHandle.saveable {
        mutableStateOf(0)
    }
        private set

    // StateFlow alternative
    val filterState: StateFlow<FilterType> =
        savedStateHandle.getStateFlow("filter", FilterType.TODAY)
}
```

**Regles:**
- `SavedStateHandle` ne sauvegarde que quand l'Activity est **stopped**
- Force stop / reboot efface le saved state
- Tester avec `StateRestorationTester` API
- Sur montre: **toujours** utiliser `rememberSaveable` au lieu de `remember` pour l'etat important

### 9f. Disconnection UI

| Placement | Cas d'usage |
|-----------|-------------|
| **Haut de l'ecran** | Fonctionnalite partielle indisponible (griser les features) |
| **Bas de la liste** | Plus de contenu chargeable tant que deconnecte |

**Lifecycle-aware Data Layer observer:**

```kotlin
class WearDataLayerObserver(
    private val dataClient: DataClient,
    private val onDataReceived: (DataEventBuffer) -> Unit
) : DefaultLifecycleObserver, DataClient.OnDataChangedListener {

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        onDataReceived(dataEvents)
    }
    override fun onResume(owner: LifecycleOwner) {
        dataClient.addListener(this)
    }
    override fun onPause(owner: LifecycleOwner) {
        dataClient.removeListener(this)
    }
}
```

**Source:** [Disconnection indicators](https://developer.android.com/design/ui/wear/guides/m2-5/behaviors-and-patterns/disconnect)

### 10. Tiles (Wear OS)

| Aspect | Valeur |
|--------|--------|
| Acces | Swipe gauche depuis watch face |
| Scrollable | **NON** - tout le contenu doit tenir sur 1 ecran |
| Technologie | ProtoLayout (pas Compose), rendu par le systeme |
| Breakpoint | 225dp pour reveler contenu supplementaire |
| Interactivite | Tap → ouvre l'app, boutons d'action rapide |
| Mise a jour min | **~15 minutes** (`setFreshnessIntervalMillis`) |
| Contenu | Donnees glancables, 1-2 actions max |
| Navigation | Swipe horizontal entre tiles |
| Touch target | 48dp minimum dans les tiles |
| Texte max | ~3 lignes recommande |

**Layouts tiles officiels:**

| Layout | Usage |
|--------|-------|
| PrimaryLayout | Header + chip/contenu principal + label optionnel |
| EdgeContentLayout | Progress circulaire au bord + contenu centre |
| MultiSlotLayout | Plusieurs sections de contenu |
| MultiButtonLayout | Grille de boutons (1-5 boutons) |

**Layouts tiles pour notre app:**
- **Single metric** : 1 gros chiffre + label + icone (ex: "5 cigarettes") → PrimaryLayout
- **Multi-slot** : 2-3 metriques empilees (clopes + alcool + sport) → MultiSlotLayout
- **Action** : Gros bouton d'action rapide ("+1 cigarette") → PrimaryLayout + Chip
- **Progress ring** : Objectif quotidien → EdgeContentLayout

**Tiles responsive:**
- Utiliser des marges en pourcentage
- Space titre/contenu: 6dp (4dp sur petit ecran <225dp)
- Typographie systeme pour coherence
- Pas d'animation dans les tiles
- Background data: utiliser WorkManager, cacher en local

**Tiles Wear OS 6 (M3 Expressive):**
- Nouveau framework ProtoLayout Material 3: `protolayout-material3` (Kotlin only)
- Layout 3 slots: title slot + main content slot + bottom slot
- Support jusqu'a **3 colonnes** dans le contenu principal
- Lottie animations supportees dans les tiles
- Gradients supplementaires et nouveaux styles arc lines
- Police systeme alignee automatiquement (Wear OS 6+)
- Dynamic color: theme auto aligne sur le watch face

**Tile interactions (implementation):**

| Action | API | Usage |
|--------|-----|-------|
| Ouvrir l'app | `launchAction(ComponentName, extras)` | Tap → ouvre une Activity avec Intent extras |
| Refresh/update tile | `loadAction()` | Trigger `onTileRequest()` pour mettre a jour le contenu |
| Compteur +1 | `loadAction(dynamicDataMapOf(...))` | Passe des donnees via stateMap, incremente en onTileRequest |
| Deep link | `loadAction()` + `lastClickableId` | Identifier le bouton tape, ouvrir l'ecran cible |

**Pattern "+1 cigarette" dans tile:**
```kotlin
// Dans la tile: bouton qui envoie une action
textButton(
    labelContent = { text("+1".layoutString) },
    onClick = clickable(
        id = "increment",
        action = loadAction(
            dynamicDataMapOf(intAppDataKey("count") mapTo currentCount + 1)
        )
    )
)

// Dans onTileRequest: lire l'etat mis a jour
val count = requestParams.currentState.stateMap[intAppDataKey("count")] ?: 0
```

**Eviter le flicker:** mettre a jour seulement le contenu qui change, pas toute la structure du layout.

**TileService M3 implementation:**

```kotlin
class SmokingTileService : TileService() {
    override fun onTileRequest(requestParams: RequestBuilders.TileRequest) =
        Futures.immediateFuture(
            Tile.Builder()
                .setResourcesVersion("1")
                .setTileTimeline(
                    Timeline.fromLayoutElement(
                        materialScope(this, requestParams.deviceConfiguration) {
                            primaryLayout(
                                titleSlot = { text("Aujourd'hui".layoutString) },
                                mainSlot = {
                                    text("5 cigarettes".layoutString,
                                        typography = BODY_LARGE)
                                },
                                bottomSlot = {
                                    textEdgeButton(
                                        labelContent = { text("+1".layoutString) },
                                        onClick = clickable(/*...*/)
                                    )
                                }
                            )
                        }
                    )
                ).build()
        )
}
```

**Manifest tile:**
```xml
<service android:name=".SmokingTileService"
    android:label="@string/tile_label"
    android:exported="true"
    android:permission="com.google.android.wearable.permission.BIND_TILE_PROVIDER">
    <intent-filter>
        <action android:name="androidx.wear.tiles.action.BIND_TILE_PROVIDER" />
    </intent-filter>
    <meta-data android:name="androidx.wear.tiles.PREVIEW"
        android:resource="@drawable/tile_preview" />
</service>
```

**Composants M3 tiles disponibles:**
- Buttons: `textButton()`, `iconButton()`, `compactButton()`, `textEdgeButton()`, `iconEdgeButton()`
- Cards: `titleCard()`, `appCard()`, `textDataCard()`, `iconDataCard()`
- Progress: `circularProgressIndicator()`, `segmentedCircularProgressIndicator()`
- Layout: `buttonGroup()`, `primaryLayout()`

**Dependencies tiles:**
```kotlin
implementation("androidx.wear.tiles:tiles:1.5.0")
implementation("androidx.wear.protolayout:protolayout:1.3.0")
implementation("androidx.wear.protolayout:protolayout-material3:1.3.0")
implementation("androidx.wear.protolayout:protolayout-expression:1.3.0")
```

**Source:** [Get started with tiles](https://developer.android.com/training/wearables/tiles/get_started?version=3)

**Source:** [Tile Interactions](https://developer.android.com/training/wearables/tiles/interactions)

### 10b. Smart Stack (watchOS 11)

| Aspect | Detail |
|--------|--------|
| Acces | Tourner Digital Crown depuis watch face |
| Live Activities | Apparaissent automatiquement depuis l'app iOS |
| Persistance | Smart Stack reste visible quand le poignet est baisse (watchOS 11) |
| Custom view | Vue personnalisee pour Apple Watch (optionnelle, sinon Dynamic Island compact) |
| Double Tap | `.handGestureShortcut(.primaryAction)` sur bouton/toggle dans widget |
| Widgets | WidgetKit, memes widgets que complications mais en plus grand |

**Relevant Widgets (watchOS 11+):**
- Les widgets apparaissent automatiquement dans le Smart Stack quand pertinents
- API `RelevantContext`: `Date`, `Location`, `Sleep`, `Fitness`
- Exemple: widget cigarettes apparait aux heures habituelles de tabagisme
- Widgets interactifs: tap pour action directe (ex: +1 cigarette)

**watchOS 26:**
- Relevant widgets: plusieurs instances en meme temps
- Controls disponibles sur watchOS
- Live Activities etendues

**Pour notre app (watchOS):**
- Widget Smart Stack: timer "depuis derniere cigarette" + compteur jour
- Live Activity: pendant une session de monitoring active
- Double Tap action: "+1 cigarette" (action primaire)
- RelevantContext: heures habituelles de tabagisme de l'utilisateur

### 11. Complications

**Types Wear OS:**

| Type | Contenu | Usage |
|------|---------|-------|
| **SHORT_TEXT** | Texte court (max 7 chars) + icone + titre optionnels | Compteur ("5"), label court |
| **LONG_TEXT** | Texte long + icone | Description, prochain RDV |
| **RANGED_VALUE** | Valeur dans un range (min/max/current) + texte | Pourcentage, progression |
| **GOAL_PROGRESS** | Valeur actuelle + cible | Objectif quotidien |
| **WEIGHTED_ELEMENTS** | Segments ponderes dans un anneau | Repartition categories |
| **MONOCHROMATIC_IMAGE** | Icone tintable monochromatique | Status on/off |
| **SMALL_IMAGE** | Image non-tintable | Photo, logo couleur |
| **PHOTO_IMAGE** | Image plein couleur grande | Background |
| **NO_DATA** | Placeholder vide | Etat sans donnees |

**Tailles de slots Wear OS:**

| Slot | Dimensions typiques |
|------|-------------------|
| CIRCLE_SMALL | ~40x40 dp |
| RECTANGLE_SMALL | ~72x40 dp |
| CIRCLE_LARGE | ~72x72 dp |
| RECTANGLE_LARGE | ~160x48 dp |

**Types watchOS (WidgetKit):**

| Famille | Description | Taille |
|---------|-------------|--------|
| accessoryCircular | Petit circulaire | ~50x50 pt |
| accessoryRectangular | Rectangulaire | ~150x50 pt |
| accessoryInline | Ligne de texte | ~150x16 pt |
| accessoryCorner | Gauge + texte en arc | Le long du bezel |

**Frequences de mise a jour:**

| Plateforme | Methode | Frequence |
|-----------|---------|-----------|
| Wear OS | `ComplicationDataSourceService` | ~5-10 min (actif), min 300s (manifest) |
| watchOS | WidgetKit TimelineProvider | ~4 push updates/heure |
| watchOS | Background app refresh | 4-6 fois/heure |

**Regles complications:**
- ContentDescription obligatoire pour accessibilite
- Pas de mot "complication" dans la description
- Max 7 caracteres pour SHORT_TEXT
- Update frequency limitee pour batterie
- MONOCHROMATIC_IMAGE doit etre tintable
- Max 8 slots par watch face (typique)
- **watchOS: PAS de watch faces tierces** - seulement des complications via WidgetKit

**Source:** [Android Developers - Complications](https://developer.android.com/training/wearables/complications)

### 11b. Implementation Complications (Wear OS)

**Data source service:**

```kotlin
class SmokingComplicationService : SuspendingComplicationDataSourceService() {

    override fun getPreviewData(type: ComplicationType): ComplicationData {
        return when (type) {
            ComplicationType.SHORT_TEXT -> ShortTextComplicationData.Builder(
                text = PlainComplicationText.Builder("5").build(),
                contentDescription = PlainComplicationText.Builder("5 cigarettes today").build()
            ).setTitle(PlainComplicationText.Builder("cig").build())
             .build()
            ComplicationType.RANGED_VALUE -> RangedValueComplicationData.Builder(
                value = 5f, min = 0f, max = 20f,
                contentDescription = PlainComplicationText.Builder("5 of 20 goal").build()
            ).setText(PlainComplicationText.Builder("5/20").build())
             .build()
            else -> throw IllegalArgumentException("Unsupported: $type")
        }
    }

    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData {
        val count = repository.getTodayCount() // suspend call
        return when (request.complicationType) {
            ComplicationType.SHORT_TEXT -> ShortTextComplicationData.Builder(
                text = PlainComplicationText.Builder("$count").build(),
                contentDescription = PlainComplicationText.Builder("$count cigarettes").build()
            ).setTapAction(openAppPendingIntent(this))
             .build()
            // ... autres types
            else -> throw IllegalArgumentException("Unsupported")
        }
    }
}
```

**Manifest:**

```xml
<service
    android:name=".SmokingComplicationService"
    android:permission="com.google.android.wearable.permission.BIND_COMPLICATION_PROVIDER"
    android:exported="true">
    <intent-filter>
        <action android:name="android.support.wearable.complications.ACTION_COMPLICATION_UPDATE_REQUEST" />
    </intent-filter>
    <meta-data
        android:name="android.support.wearable.complications.SUPPORTED_TYPES"
        android:value="SHORT_TEXT,RANGED_VALUE,GOAL_PROGRESS" />
    <meta-data
        android:name="android.support.wearable.complications.UPDATE_PERIOD_SECONDS"
        android:value="600" />
</service>
```

**Push updates (event-driven, meilleur que polling):**

```kotlin
// Apres chaque cigarette enregistree:
val requester = ComplicationDataSourceUpdateRequester.create(
    context, ComponentName(context, SmokingComplicationService::class.java)
)
requester.requestUpdateAll()  // Update toutes les complications actives
// Budget: minimum 300s entre updates (manifest), push illimite mais raisonnable
```

**TimeDifferenceComplicationText (timer sans updates constantes):**

```kotlin
// "Derniere cigarette il y a X min" - auto-updates par le systeme
val timeSinceLast = TimeDifferenceComplicationText.Builder(
    TimeDifferenceStyle.SHORT_DUAL_UNIT,
    CountUpTimeReference(lastCigaretteInstant)  // Instant de la derniere cigarette
).setMinimumTimeUnit(TimeUnit.MINUTES)
 .build()

ShortTextComplicationData.Builder(
    text = timeSinceLast,
    contentDescription = PlainComplicationText.Builder("Time since last cigarette").build()
).build()
// Le systeme met a jour l'affichage automatiquement, pas besoin de reveiller le service
```

**Dynamic values (Wear OS 4+, sans reveiller le provider):**

```kotlin
// Valeur dynamique mise a jour par le systeme a partir du DataStore
val dynamicCount = DynamicComplicationText(
    dynamicValue = PlatformHealthSources.dailySteps(),  // ou custom DynamicDataValue
    fallbackValue = PlainComplicationText.Builder("--").build()
)
```

**Regles implementation:**
- `UPDATE_PERIOD_SECONDS` minimum 300s (5 min), 0 = desactive le polling (push only)
- `getPreviewData()` OBLIGATOIRE - affiche dans le picker de complications
- `onComplicationRequest()` doit etre rapide (< 20s) sinon timeout
- `setTapAction()` avec PendingIntent pour ouvrir l'app au tap
- Supporter au minimum 2-3 types differents (SHORT_TEXT + RANGED_VALUE recommande)
- Pour timer: utiliser `TimeDifferenceComplicationText` au lieu de updates frequentes

**Source:** [Android Developers - Complication Data Sources](https://developer.android.com/training/wearables/complications/data-source)

---

## D. Typographie

### 12. Type Scale Wear OS Material 3

| Role | Tokens | Scaling | Usage |
|------|--------|---------|-------|
| **Display** | DisplayLarge, Medium, Small | NON (>=20sp, pas de scaling) | Hero metrics, gros chiffres |
| **Title** | TitleLarge, Medium, Small | OUI (suit preferences user) | Titres ecrans |
| **Label** | LabelLarge, Medium, Small | Medium+Small seulement | Labels boutons, chips |
| **Body** | BodyLarge, Medium, Small | OUI | Texte courant |
| **Numeral** | NumeralExtraLarge, Large, etc. | NON (>=20sp) | Chiffres, compteurs, heure |
| **Arc** | ArcLarge, Medium, Small | OUI | Texte courbe (TimeText, labels peripheriques) |

**Regles typographie montre:**
- Scaling interdit au-dessus de 20sp (espace insuffisant)
- Tabular spacing par defaut pour les Numerals
- Numerals = max 2-3 caracteres (pas de localisation)
- Arc = texte court uniquement, en haut ou bas de l'ecran
- Variable fonts utilises pour optimiser lisibilite a petite taille
- Tester avec font scaling active dans les parametres

**Anti-patterns typographie:**
- Texte trop petit (<12sp) → illisible au poignet
- Paragraphes longs → l'utilisateur ne lit pas sur une montre
- Pas de troncature (ellipsis) sur texte debordant
- Ignorer le font scaling utilisateur

**Source:** [Android Developers - Typography](https://developer.android.com/design/ui/wear/guides/styles/typography)

### 13. Typographie watchOS

| Taille montre | Dynamic Type range |
|--------------|-------------------|
| 38mm / 40mm | 14-19pt pour body text |
| 42mm / 44mm / 45mm | 15-20pt pour body text |
| 49mm Ultra | Espace supplementaire pour plus de texte |

**Regles watchOS:**
- Minimum 44pt pour touch targets
- Texte doit etre lisible a distance bras tendu (~30-40cm)
- SF Compact (police systeme) optimise pour petits ecrans
- Dynamic Type supporte mais range limite

---

## E. Ambient Mode / Always-On Display (AOD)

### 14. Ambient Mode Wear OS

| Contrainte | Valeur | Raison |
|-----------|--------|--------|
| Pixels illumines max | **15%** de la surface | Economie batterie OLED |
| Surface noire minimum | **85%** | Prevenir burn-in |
| Frequence update | **1x / minute** max (onUpdateAmbient) | Economie CPU/batterie |
| Animations | **INTERDITES** | Batterie + burn-in |
| Couleurs | Limites (blanc, gris, couleur accent) | Visibilite + economie |
| Interaction | **NON interactive** (sauf cas speciaux) | Activation accidentelle |

**Que montrer en ambient:**
- Heure (toujours)
- 1-2 donnees critiques (ex: compteur cigarettes, timer en cours)
- Outlines pour icones/boutons (pas de fills solides)
- Fond NOIR pur (#000000)

**Burn-in prevention:**
- Si `burnInProtectionRequired == true` : decaler periodiquement les elements
- Eviter les blocs blancs/colores statiques
- Utiliser des outlines au lieu de fills
- Pas de branding ou images de fond

**Impact batterie AOD:**

| Mode | Drain relatif |
|------|--------------|
| AOD off (ecran off) | Baseline |
| AOD correct (>=85% noir) | +5-15% drain/jour |
| AOD mal implemente (<85% noir) | +20-40% drain/jour |
| Tilt-to-wake seulement | +2-5% drain/jour |

**Wear OS 6+ (API 36+):** "Global AOD" - l'app reste visible et tourne en mode dimmed (plus de screenshot floute). Controle ambient complet par l'app. +10% autonomie batterie vs Wear OS 5.

**Low-bit ambient:** Certains appareils limitent a 1-bit (noir/blanc seulement). Verifier `deviceHasLowBitAmbient`. Desactiver l'anti-aliasing.

**Anti-patterns ambient:**
- Plus de 15% de pixels allumes
- Animations ou transitions
- Contenu interactif (sauf Wear OS 6+)
- Donnees qui changent plus d'1x/minute
- Branding ou decoration
- Meme contenu que le mode interactif (trop charge)
- Polices grasses/epaisses (burn-in) → utiliser outlines fines

**Source:** [Android Developers - Always-on](https://developer.android.com/training/wearables/always-on)

### 14b. Ambient Mode Implementation (Compose)

**3 etats possibles:**

| Wear OS | targetSDK | Callback | Resultat |
|---------|-----------|----------|----------|
| ≤ 5 | Any | Non | AOD Lite (screenshot floue + heure) |
| 6+ | 36+ | Non | Global AOD (app dimmed, 1x/min) |
| Any | Any | Oui | Ambiactive (app gere son propre AOD) |

**2 timeouts d'inactivite:**
1. Interactive → Ambient (premier timeout)
2. Ambient → Retour au watch face (deuxieme timeout, sauf Ongoing Activity)

**AmbientLifecycleObserver:**

```kotlin
val ambientCallback = object : AmbientLifecycleObserver.AmbientLifecycleCallback {
    override fun onEnterAmbient(ambientDetails: AmbientLifecycleObserver.AmbientDetails) {
        // ambientDetails.deviceHasLowBitAmbient → desactiver anti-aliasing
        // ambientDetails.burnInProtectionRequired → shifter le contenu
    }
    override fun onExitAmbient() { /* restaurer le plein UI */ }
    override fun onUpdateAmbient() { /* 1x/minute max */ }
}

// Dans Activity.onCreate():
lifecycle.addObserver(AmbientLifecycleObserver(this, ambientCallback))
```

**AmbientAware (Horologist, pour Compose):**

```kotlin
AmbientAware { ambientState ->
    if (ambientState.isAmbient) {
        AmbientContent()  // UI low-power
    } else {
        InteractiveContent()  // UI complet
    }
}
```

**Regles ambient:**
- **85%+ ecran noir** pour economiser la batterie
- Icones/boutons en outline, pas en remplissage solide
- Remplacer donnees live (chrono, HR) par `--` statique
- Burn-in protection: shifter le contenu periodiquement si `burnInProtectionRequired`
- Low-bit ambient: desactiver anti-aliasing si `deviceHasLowBitAmbient`
- `TimeText` est automatiquement ambient-aware (update 1x/min, pas besoin de code)

**Debugging:**

```bash
adb shell input keyevent KEYCODE_SLEEP   # entrer en ambient
adb shell input keyevent KEYCODE_WAKEUP  # sortir de ambient
```

**Source:** [Android Developers - Always-on](https://developer.android.com/training/wearables/always-on)

### 15. Modes silencieux et contextes

| Mode | Ecran | Son | Haptique | Notifications |
|------|-------|-----|----------|--------------|
| Normal | On | On | On | Toutes |
| Silencieux | On | Off | On | Toutes (silencieuses) |
| Do Not Disturb | On | Off | Off | Filtrees |
| Theatre/Cinema | Off | Off | Off | Aucune |
| Bedtime | Dimmed | Off | Filtrees | Filtrees |
| Water Lock | On (non-tactile) | Off | Off | Visuelles seulement |

**Impact sur l'app:**
- Detecter le mode actif via `NotificationManager.getCurrentInterruptionFilter()`
- Adapter le feedback: si haptique off → renforcer le feedback visuel
- Ne JAMAIS bypass le mode DND sauf alarme critique
- En Water Lock: pas de tactile → boutons physiques uniquement

---

## F. Sante & Addiction Tracking

### 16. Patterns de Tracking sur Montre

| Pattern | Description | Quand utiliser |
|---------|-------------|---------------|
| **Auto-detection + confirmation** | ML detecte l'action → notification → user confirme/ignore | Detection cigarette, alcool |
| **Compteur manuel** | Gros bouton "+1" tap rapide | Tracking simple, fiable |
| **Timer** | Chronometre automatique | Duree d'activite |
| **Streak/series** | Visualisation jours consecutifs | Motivation, retention |
| **Progress ring** | Arc circulaire autour de l'ecran | Objectif quotidien |

**UX compteur addiction (notre use case):**
```
Ecran principal montre:
+------------------+
|     10:35        |  ← TimeText (toujours)
|                  |
|       5          |  ← Gros chiffre (compteur jour)
|   cigarettes     |  ← Label
|                  |
|     [+1]         |  ← Bouton principal (60dp, bien visible)
|                  |
| Derniere: 14:23  |  ← Info secondaire
+------------------+
```

**Regles UX tracking addiction:**
- **Auto-start monitoring** au lancement (pas de bouton "Start" confus)
- Compteur visible en **< 1 seconde** (glance)
- Bouton "+1" = action la plus grosse et visible
- Feedback haptique a chaque detection/ajout
- Notification quand detection auto → "Cigarette detectee? [Oui] [Non]"
- Complication sur watch face = compteur du jour (GOAL_PROGRESS ou SHORT_TEXT)
- Tile = resume quotidien + bouton rapide
- Undo bref apres increment (toast 3-5s avec annuler)
- Voice input: "Hey Google, log 2 bieres" pour batch

**Visualisation streak/habitude sur ecran rond:**

| Pattern | Description |
|---------|-------------|
| Ring completion | Anneau journalier qui se remplit. Multi-anneaux fins pour multi-habitudes |
| Calendar arc | Jours de la semaine/mois en arc autour de l'ecran. Cercles pleins = complete |
| Flame counter | Gros chiffre + icone flamme. "Serie de 7 jours" + 7 points |
| Progress dots | 7 points en bas (Lun-Dim), remplis = complete. Jour actuel surbrille |

**Alcool - patterns specifiques:**
- Unites standard (pas ml/oz) comme metrique principale
- Estimation BAC avec niveaux d'alerte couleur
- Total hebdo avec ligne limite recommandee (14 unites/semaine)
- Timer "temps depuis dernier verre"

### 16b. Analyse Apps Addiction Existantes (Montre)

| App | Ce qui marche | Ce qui est nul |
|-----|--------------|---------------|
| **SmokeFree** (Sean Allen) | Timer prominent, milestones clairs, widget iOS | Pas de Wear OS standalone, compteur pas assez visible |
| **QuitNow!** | Stats detaillees (argent, temps, sante) | Surcharge d'info sur montre, UX desktop portee |
| **I Am Sober** | Motivation quotes, communaute, pledges | Pas de detection auto, timer seulement |
| **Nomo** | Multi-addictions, timer par addiction | UI datee, pas de quick-log 1 tap |
| **EasyQuit** | Achievement system, body recovery timeline | Pas de companion montre |
| **Quit Tracker** | Visualisation argent economise | UI minimaliste mais trop basique montre |
| **Smoke Free** (app distincte) | Gamification poussee, missions | Trop de contenu pour montre |
| **HabitBull** | Tracking multi-habitudes, streaks | Generique, pas specialise addiction |

**Lecons pour notre app:**
- Timer "depuis derniere" = feature #1 (I Am Sober, SmokeFree le prouvent)
- Quick-log 1 tap = aucune app ne le fait bien sur montre → notre avantage
- Detection auto ML = ZERO app existante → differentiation totale
- Gamification legere (streaks, milestones) = retention prouvee
- Trop d'info = echec sur montre (QuitNow erreur classique)
- Argent economise = motivant mais secondaire (complication ou telephone)

### 16c. Gamification sur Montre

| Element | Implementation montre | Telephone |
|---------|----------------------|-----------|
| **Streaks** | Icone flamme + compteur jours, toujours visible | Historique complet |
| **Badges** | Notification + haptique quand debloque | Galerie complete |
| **Milestones** | 1j, 3j, 7j, 14j, 30j, 90j, 1an → celebration | Detail + partage |
| **Daily challenge** | Tile: "Objectif: max 8 cig" | Personnalisation |
| **Argent economise** | Complication SHORT_TEXT: "12.50 CHF" | Graphique detaille |

**Celebrations sur montre:**
- Haptique pattern special (QUICK_RISE + THUD + TICK x3) = "confetti haptique"
- Animation courte (< 2s): icone animee (check, flamme, etoile)
- PAS de confetti visuel (trop charge sur petit ecran)
- Frequence: max 1-2 celebrations/jour (fatigue sinon)
- Son optionnel (petit "ding" satisfaisant si pas en silencieux)

**Craving log rapide:**
```
Ecran craving (2 taps total):
Tap 1: Bouton "Envie" sur ecran principal
Tap 2: Intensite 1-5 (5 gros boutons en arc)
→ Log + haptique confirmation
→ Message encourageant ("Vous avez resiste!")
```

### 17. Health Connect Integration

| API | Usage | Limitation |
|-----|-------|-----------|
| Health Connect | Hub central lecture/ecriture sante | Pas de type "cigarette" natif |
| Samsung Health SDK | Donnees Samsung specifiques | Acces restreint |
| Health Services | Capteurs optimises batterie | Wear OS uniquement |
| ExerciseClient | Tracking activite physique | Types d'exercice predefinis |
| MeasureClient | Mesures temps reel (HR, SpO2) | Court terme, consomme batterie |

**Cigarettes dans Health Connect:**
- PAS de type natif "cigarette" ou "smoking" dans Health Connect
- Options: utiliser NutritionRecord (detourne), ou stocker en local + sync custom
- Recommandation: base SQLite locale + sync via Data Layer API vers telephone

**Source:** [Samsung Developer - Health Connect](https://developer.samsung.com/health/blog/en/accessing-samsung-health-data-through-health-connect)

---

## G. Performance & Batterie

### 18. Contraintes Hardware

| Contrainte | Valeur typique | Impact design |
|-----------|---------------|--------------|
| RAM totale | 1.5 - 2 GB | Apps limitees en memoire |
| RAM dispo app | ~300-800 MB (systeme prend 800MB-1.2GB) | Pas de gros assets |
| App heap default | 128-192 MB (256 MB avec largeHeap) | Target < 50 MB pour bon citoyen |
| Stockage | 16-32 GB | Models TFLite OK |
| CPU | Dual-core A55 1.4GHz → Penta-core A78+A55 3nm | Inference ML possible |
| GPU | Mali-G68 (recent) | Animations simples |
| Cold start target | < 2-3s (ideal < 1s avec baseline profiles) | Splash minimaliste |
| Baseline profiles | 20-40% amelioration startup | Toujours activer en release |
| Frame rate interactif | 60 fps cible | Standard pour scroll/animations |
| Frame rate workout | 30 fps acceptable | Trade-off batterie |
| Frame rate ambient | 0 fps (statique) | 1 update/min max |
| Taille APK recommandee | < 10 MB (optimal), < 30 MB (ok) | Max 150 MB (store limit) |
| Luminosite max | 2000 nits (recent) | Lisible en plein soleil |

**SoC par generation:**

| SoC | Process | CPU | GPU | NPU | Montres |
|-----|---------|-----|-----|-----|---------|
| Exynos W920 | 5nm | 2x A55 1.18GHz | Mali-G68 | Non | Galaxy Watch 4 |
| Exynos W930 | 5nm | 2x A55 1.4GHz | Mali-G68 MP2 | Non | Galaxy Watch 5/6 |
| Exynos W1000 | 3nm | 1x A78 + 4x A55 | Mali-G68 | Oui (Samsung NPU) | Galaxy Watch 7/Ultra |
| Snapdragon W5+ | 4nm | 4x A53 1.7GHz | Adreno 702 | Hexagon (limite) | Pixel Watch 2 |
| Apple S9 | 4nm | 4-core (2P+2E) | 4-core GPU | Neural Engine 4-core | Watch S9/Ultra 2 |

### 19. Optimisation Batterie

| Technique | Gain | Comment |
|-----------|------|---------|
| Sensor batching | Significatif | `maxReportLatencyUs > 30s` pour regrouper les lectures |
| Health Services API | Major | Utiliser au lieu de SensorManager direct |
| Minimiser listener time | Moyen | Desenregistrer les listeners ASAP |
| WorkManager periodic | Moyen | Taches non-urgentes, battery-aware |
| Foreground service | Necessaire | Pour monitoring continu (notre use case) |
| Doze mode respect | Critique | Ne pas empecher le sleep systeme |
| DataItem non-urgent | Moyen | Sync differee jusqu'a 30min si pas urgent |
| DataItem urgent | Faible gain | Sync immediate, consomme plus |

**Sensors et batterie:**

| Sensor | Conso (mA) | Recommandation |
|--------|-----------|----------------|
| Accelerometre | 0.2-0.5 | OK en continu avec batching (hardware pedometer) |
| Gyroscope | 3-6 | Activer seulement quand necessaire |
| Heart Rate (PPG) | 1-5 | Health Services, pas SensorManager. Continu: ~5mA, periodic: ~0.5mA |
| GPS | 25-50 | JAMAIS en continu sauf workout actif |
| Barometre | 0.01-0.1 | Negligeable, OK en continu |
| SpO2 | 3-8 | Spot measurements seulement (LEDs) |
| ECG | 5-10 | On-demand, lectures de 30s |
| BIA (body comp) | 5-15 | On-demand, <30s |
| Temperature peau | 0.1-0.5 | Periodic sampling, sleep tracking |
| Magnetometre | 0.5-1 | Faible, navigation |

**Budget batterie apps tierces:**

| Scenario | Budget | Notes |
|----------|--------|-------|
| App idle en background | < 1% batterie/heure | Quasi-zero quand non utilise |
| Monitoring passif sante | 2-5% batterie/jour | Avec PassiveMonitoringClient |
| Exercise tracking actif | 5-15% batterie/heure | GPS + HR continu + ecran |
| Complications updates | < 0.5% batterie/jour | Si refresh >= 2 heures |
| Total apps tierces | < 10-15% batterie/jour | Toutes apps non-systeme combinees |
| Min interval wake-ups | Toutes les 1-2 min | Pas plus frequent |

**Transports et consommation:**

| Transport | Conso (mA) | Debit | Utilisation |
|-----------|-----------|-------|-------------|
| Bluetooth LE | 5-10 | 0.2-2 Mbps | Sync standard (prefere) |
| Bluetooth Classic | 20-40 | 2-3 Mbps | Gros transferts |
| WiFi | 80-150 | 20-150 Mbps | Fallback, gros transferts |
| LTE (cellular) | 200+ | 5-50 Mbps | Standalone, tres couteux |

**Background restrictions (Wear OS 5+):**
- Apps en background NE PEUVENT PAS lancer d'alarmes/jobs sauf si sur chargeur
- Monitoring continu → **foreground service obligatoire** avec `startForegroundService()`
- Notification ongoing requise pour foreground service
- Exception: watch faces et complications actives selectionnees par l'utilisateur

**Foreground service types (Android 14+ obligatoire):**

| Type | Usage | Permission |
|------|-------|-----------|
| `health` | Monitoring capteurs sante | `FOREGROUND_SERVICE_HEALTH` |
| `connectedDevice` | Sync Data Layer | `FOREGROUND_SERVICE_CONNECTED_DEVICE` |
| `location` | GPS tracking | `FOREGROUND_SERVICE_LOCATION` + `ACCESS_FINE_LOCATION` |
| `dataSync` | Upload/download data | `FOREGROUND_SERVICE_DATA_SYNC` |

**Pour notre app:** `foregroundServiceType="health"` dans le manifest.

**Doze mode et Wear OS:**
- Montre entre en Doze quand ecran off + immobile + non-chargee
- Doze bloque: reseau, jobs, syncs, alarmes standard
- `setAndAllowWhileIdle()` fonctionne mais max **1 alarme / 9 minutes / app**
- Foreground service avec type `health` = **exempt de Doze** (capteurs restent actifs)
- WorkManager expedited: `setExpedited()` = moins impacte par Doze

**App Standby Buckets Wear OS:**

| Bucket | Jobs | Alarmes | Reseau |
|--------|------|---------|--------|
| Active | Pas de limite | Pas de limite | Pas de limite |
| Working set | Differe 2h | Differe 6min | Pas de limite |
| Frequent | Differe 8h | Differe 30min | Pas de limite |
| Rare | Differe 24h | Differe 2h+ | Restreint |
| Restricted | 1/jour max | 1/jour max | Restreint |

**Recommendation:** Notre app avec foreground service actif = bucket Active. Si l'utilisateur ne l'utilise pas pendant jours → degrade vers Rare → notifications de rappel limitees.

### 19b. Health Services API (implementation)

**3 clients — quand utiliser quoi:**

| Client | Usage | Duree | Batterie | Notre app |
|--------|-------|-------|----------|-----------|
| **PassiveMonitoringClient** | Background long-terme, updates peu frequents | Heures/jours | Faible | Detection de base (steps, HR periodic) |
| **ExerciseClient** | Workout actif, metriques rapides | Minutes/heures | Moyen-fort | PAS notre use case (pas un workout) |
| **MeasureClient** | Spot measurement, UI active | Secondes | Fort | HR spot quand l'app est ouverte |

**PassiveMonitoringClient (notre use case principal):**
```kotlin
// Enregistrer un listener background
val config = PassiveListenerConfig.builder()
    .setDataTypes(setOf(DataType.HEART_RATE_BPM, DataType.STEPS_DAILY))
    .build()

passiveMonitoringClient.setPassiveListenerServiceAsync(
    MyPassiveListenerService::class.java,
    config
)
```
- Donnees livrees en **batch** quand le service se reveille
- Ou via **callback** a un rythme legerement plus rapide (app en memoire seulement)
- Passive Goals: notifier quand seuil atteint (ex: 10000 pas)

**MeasureClient (spot measurement):**
```kotlin
// Mesure HR ponctuelle quand l'ecran est actif
measureClient.registerMeasureCallback(DataType.HEART_RATE_BPM, callback)
// TOUJOURS desenregistrer quand l'ecran s'eteint
measureClient.unregisterMeasureCallback(DataType.HEART_RATE_BPM, callback)
```

**ExerciseClient (tracking workout):**
- Definit les data types disponibles par type d'exercice
- Donnees 1Hz (1 sample/seconde) pendant exercice actif
- Modes delivery: streaming (ecran on) ou batch (ecran off)
- Goals et debounced goals supportes

**Capabilities check (obligatoire avant usage):**
```kotlin
val capabilities = healthServicesClient
    .passiveMonitoringClient
    .capabilities
    .await()

val supportsHR = DataType.HEART_RATE_BPM in capabilities.supportedDataTypesPassiveMonitoring
```

**Permissions Health Services (Wear OS 6+ / API 36):**

| Permission legacy (API 33-35) | Permission nouvelle (API 36+) |
|-------------------------------|-------------------------------|
| `BODY_SENSORS` | `android.permission.health.READ_HEART_RATE` |
| `BODY_SENSORS_BACKGROUND` | `READ_HEALTH_DATA_IN_BACKGROUND` |
| `ACTIVITY_RECOGNITION` | `android.permission.health.READ_STEPS` |

**Source:** [Health Services API](https://developer.android.com/health-and-fitness/health-services)

### 19c. Performance Compose (optimisation startup)

**Baseline Profiles:**
- Pre-compilent les classes/methodes critiques au demarrage
- Gain: **20-40% reduction cold start** (mesure reelle)
- Compose 1.8+ inclut des profile rules auto-merged
- Verifier: `adb shell dumpsys package dexopt | grep -A 1 $PACKAGE_NAME` → target `status=speed-profile`

**R8 obligatoire en release:**
- Shrink + obfuscate + optimize
- Toujours utiliser `proguard-android-optimize.txt`
- Startup Profile + R8 = code critique dans le primary DEX file

**Tests performance:**
- **TOUJOURS en release** (debug = overhead enorme, pas de baseline profiles)
- **Sur device physique** (emulateur = pas representatif)
- Macrobenchmark + JankStats + System Trace
- Valider les animations M3 Expressive (flex fonts, shape morphing) sur device reel

**Checklist performance Compose Wear:**
1. Compose >= 1.8+ (gains significatifs stabilite + perf)
2. Baseline profiles avec key workflows
3. R8 active avec resource shrinking
4. Valider: `adb shell dumpsys package dexopt | grep -A 1 $PACKAGE` → `speed-profile`
5. Startup profiles (optionnel, augmente taille APK)
6. Macrobenchmarks sur device physique
7. JankStats pour tracker les jank frames
8. System Trace pour diagnostiquer latence animations
9. Tester sur devices representatifs du user base cible
10. `adb shell cmd package bg-dexopt-job` pour forcer l'optimisation apres install (~40s)

**Source:** [Compose Performance Wear OS](https://developer.android.com/training/wearables/compose/performance), [Power](https://developer.android.com/training/wearables/apps/power)

### 20. TensorFlow Lite sur Montre

| Aspect | Valeur/Recommandation |
|--------|----------------------|
| Taille modele recommandee | < 5 MB (idealement < 1 MB) |
| Quantization | INT8 recommande (10x reduction taille, 3.5x plus rapide) |
| Inference time cible | < 100ms par prediction |
| Memoire pour inference | < 50 MB |
| Delegation GPU | Supportee sur Mali-G68 |
| NNAPI | Supporte sur Exynos W1000 |

**Pipeline capteur → inference (notre app):**
```
Accelerometre (50Hz) → Buffer 3s → Extract features (30 valeurs)
Gyroscope (50Hz)   →            → TFLite inference (< 100ms)
                                → Resultat: [idle, smoking, drinking, other]
                                → Si smoking > seuil → notification
```

**Inference performance par taille modele:**

| Taille modele | Inference CPU | Notes |
|--------------|--------------|-------|
| < 1 MB | 5-20 ms | Single thread sur Cortex-A55 |
| 1-5 MB | 20-100 ms | Acceptable pour usage interactif |
| 5-20 MB | 100-500 ms | Limit pratique, warm-up 100-500ms |
| > 20 MB | OOM risk | RAM insuffisante (1-2 GB total) |

**Patterns ML battery-efficient:**

| Pattern | Impact batterie | Quand utiliser |
|---------|----------------|---------------|
| Inference continue (25-50Hz) | 5-15%/heure | Detection chute, securite temps reel |
| Sampling periodique (5-15 min) | 1-3%/heure | Health tracking, detection habitude |
| Event-triggered | Minimal (~2-4%/h actif) | Detect mouvement significatif → classifier |
| Duty cycling (10s on / 50s off) | Moyen | Compromis latence/batterie |
| Batch inference | Faible | Traiter donnees accumulees periodiquement |

**Pour detection cigarette (notre app):**
- Recommande: **Event-triggered** avec significant motion detector → activer accelerometre 25Hz pendant fenetre 10s → classifier → retour idle
- Impact batterie estime: ~2-4% par heure en periodes actives
- Tradeoff precision: ~85-92% detection avec periodique vs ~95%+ continu
- Utiliser `SENSOR_DELAY_NORMAL` (200ms/5Hz) sauf si taux plus eleve necessaire
- INT8 utilise ~30-50% moins d'energie que FP32

**Optimisations ML sur montre:**
- Batching sensor data (ne pas inferer a chaque sample)
- `maxReportLatencyUs` jusqu'a 60s pour batching en background
- Quantization INT8 du modele
- Modele petit (< 1 MB) avec features pre-calculees
- Desenregistrer sensors pendant ambient/AOD
- 1-2 threads max pour inference (plus = plus de conso)

---

## H. Sync & Communication

### 21. Wear Data Layer API

| Client | Usage | Connectivite | Persistance | Taille max |
|--------|-------|-------------|-------------|-----------|
| **DataClient** | Sync donnees bidirectionnelle | Non (buffered) | Oui, synced a reconnexion | 100 KB/DataItem (+ Assets illimites) |
| **MessageClient** | RPC, commandes one-shot | Oui (connecte) | Non (fire-and-forget) | < 100 KB |
| **ChannelClient** | Transfer gros fichiers | Oui | Non (streaming) | Illimite (streaming) |

**DataClient - Sync donnees:**
- DataItems = unites de donnees diffusees et synchronisees sur tous les appareils
- Stockage persistant: si deconnecte, bufferise et sync a la reconnexion
- `setUrgent()` pour sync immediate (sinon delai jusqu'a 30min)
- Assets pour donnees binaires (cache auto, economise bande passante BT)

**MessageClient - Commandes:**
- Fire-and-forget, pas de garantie de livraison
- Ideal pour: "ouvre l'app telephone", "sync maintenant", commandes ponctuelles

**Limitation majeure:**
- Data Layer API fonctionne UNIQUEMENT avec Android phone
- Si montre pairee avec iPhone → Data Layer API ne fonctionne PAS
- Alternative: cloud sync via WiFi (REST API / Firebase)

**Architecture sync recommandee (notre app):**
```
[Montre] SQLite local
    ↓ DataClient (urgent)
[Telephone] Room DB
    ↓ Retrofit / Firebase
[Cloud] Firestore / API
    ↓
[Dashboard Web]
```

**WearableListenerService (background sync):**

```kotlin
class SmokeDataListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.type == DataEvent.TYPE_CHANGED) {
                val path = event.dataItem.uri.path
                if (path == "/smoke-event") {
                    // Traiter l'event cigarette recu du telephone
                    val dataMap = DataMapItem.fromDataItem(event.dataItem).dataMap
                    val timestamp = dataMap.getLong("timestamp")
                    // Sauvegarder en base locale...
                }
            }
        }
    }
}
```

```xml
<!-- Manifest -->
<service android:name=".SmokeDataListenerService"
    android:exported="true">
    <intent-filter>
        <action android:name="com.google.android.gms.wearable.DATA_CHANGED" />
        <data android:scheme="wear" android:host="*"
            android:path="/smoke-event" />
    </intent-filter>
</service>
```

**Source:** [Android Developers - Data Layer](https://developer.android.com/training/wearables/data/overview), [Handle Data Layer events](https://developer.android.com/training/wearables/data/events)

### 21b. watchOS Watch Connectivity

| API | Usage | Persistance | Timing |
|-----|-------|-------------|--------|
| `sendMessage(_:replyHandler:)` | Messages temps reel | Non (fire-and-forget) | Immediat si reachable |
| `updateApplicationContext(_:)` | Etat courant (last-value-wins) | Oui (dernier etat) | Prochain wake |
| `transferUserInfo(_:)` | Events importants (queue FIFO) | Oui (queued, reliable) | Background, fiable |
| `transferFile(_:metadata:)` | Gros fichiers | Oui (queued) | Background |
| `transferCurrentComplicationUserInfo(_:)` | Donnees complication | Oui | Budget limite/jour |

**Quand utiliser quoi (watchOS):**
- `sendMessage` → commandes live ("ouvre l'app telephone")
- `updateApplicationContext` → settings, etat courant (ecrase le precedent)
- `transferUserInfo` → **chaque event cigarette** (fiable, queue, garanti)
- `transferFile` → export donnees, modele ML mis a jour

**Conflict resolution (cross-platform):**
- Regle simple: **derniere ecriture gagne** (timestamp UTC)
- Compteur: utiliser des operations CRDT (increment-only counter)
- Settings: telephone = source de verite, montre = lecture seule
- En cas de conflit: telephone gagne toujours

**Schema versioning:**
- Inclure `schemaVersion: Int` dans chaque message/DataItem
- Montre v1 + telephone v2: telephone doit comprendre les deux formats
- Migration: telephone met a jour en premier, montre suit via Play Store auto-update
- Fallback: ignorer les champs inconnus (pas crash)

### 21c. Testing Montre

| Type de test | Outil | Notes |
|-------------|-------|-------|
| UI layout | Emulateur Wear OS (Android Studio) | Tester rond + carre, 192dp + 225dp |
| Ambient mode | `adb shell am broadcast -a com.google.android.wearable.action.AMBIENT_UPDATE` | Trigger manuel |
| Battery drain | `adb shell dumpsys batterystats` + Battery Historian | Mesurer drain reel |
| Haptique | Device reel UNIQUEMENT | Emulateur ne vibre pas |
| Performance | Android Studio Profiler (CPU, Memory) | Via WiFi debug |
| TalkBack | Device reel | Tester navigation complete screen reader |
| Tiles | Tile preview dans Android Studio | + test sur device |
| Complications | Complication preview + watch face testeur | Sur device |
| Field testing | Porter la montre 1 journee complete | Notes sur les problemes reels |
| Monkey test | `adb shell monkey -p com.pkg -v 10000` | Stress test random |
| UI Espresso | `androidx.test.espresso` + Wear OS rules | Tests automatises |

**Emulateur vs Device reel:**

| Feature | Emulateur | Device reel |
|---------|-----------|-------------|
| Layout/UI | OK | OK |
| Sensors | Simules (limites) | Reels |
| Haptique | NON | OUI |
| Battery drain | NON mesurable | OUI |
| Bezel/crown | Simule (scroll souris) | Reel |
| Performance | Plus rapide que device | Reference |
| Ambient mode | Simulable via ADB | Automatique |

**ADB WiFi debugging:**
```bash
# Activer le debug WiFi sur la montre
# Settings > Developer Options > ADB Debugging > Debug over WiFi
adb connect <watch-ip>:5555
```

### 21d. Testing Compose for Wear OS

**UI Testing avec ComposeTestRule:**

```kotlin
@get:Rule
val composeTestRule = createComposeRule()

@Test
fun counterDisplaysCorrectly() {
    composeTestRule.setContent {
        CigaretteCounterScreen(count = 5)
    }
    composeTestRule.onNodeWithText("5").assertIsDisplayed()
    composeTestRule.onNodeWithContentDescription("Ajouter une cigarette")
        .performClick()
}

@Test
fun swipeToDismissWorks() {
    composeTestRule.setContent {
        SwipeDismissableNavHost(/*...*/) { /*...*/ }
    }
    // Simuler swipe-to-dismiss
    composeTestRule.onRoot().performTouchInput {
        swipeRight(startX = 0f, endX = centerX)
    }
}
```

**Screenshot Testing (Roborazzi pour Wear OS):**

```kotlin
@RunWith(ParameterizedRobolectricTestRunner::class)
class WearScreenshotTest(
    private val deviceConfig: DeviceConfig
) {
    @get:Rule
    val composeTestRule = createComposeRule()

    companion object {
        @JvmStatic
        @ParameterizedRobolectricTestRunner.Parameters
        fun devices() = listOf(
            DeviceConfig(screenWidth = 192, screenHeight = 192, isRound = true),  // Small round
            DeviceConfig(screenWidth = 225, screenHeight = 225, isRound = true),  // Large round
            DeviceConfig(screenWidth = 280, screenHeight = 280, isRound = true),  // XL round
        )
    }

    @Test
    fun mainScreen_snapshot() {
        composeTestRule.setContent {
            MainWearScreen(count = 3)
        }
        composeTestRule.onRoot().captureRoboImage("main_${deviceConfig.screenWidth}.png")
    }
}
// ./gradlew recordRoborazziDebug  → generer golden images
// ./gradlew verifyRoborazziDebug  → comparer contre golden
```

**Macrobenchmark pour Wear OS:**

```kotlin
@LargeTest
@RunWith(AndroidJUnit4::class)
class StartupBenchmark {
    @get:Rule
    val benchmarkRule = MacrobenchmarkRule()

    @Test
    fun startupCold() = benchmarkRule.measureRepeated(
        packageName = "com.infernal.wear",
        metrics = listOf(StartupTimingMetric()),
        iterations = 5,
        startupMode = StartupMode.COLD,
        compilationMode = CompilationMode.DEFAULT
    ) {
        pressHome()
        startActivityAndWait()
    }
}
```

**Tile Testing:**

```kotlin
// Preview dans Android Studio (pas de test automatise officiel)
// Utiliser TilePreviewHelper pour visualiser
@Preview(device = WearDevices.SMALL_ROUND)
@Composable
fun TilePreview() {
    // Render du contenu tile en Compose pour preview
    TileLayoutPreview(myTileLayout())
}
```

### 21e. Dependencies & BOM (2025-2026)

**Compose for Wear OS BOM (centralise les versions):**

```kotlin
// build.gradle.kts (module :wear)
dependencies {
    // BOM — gere les versions de toutes les libs Wear Compose
    val composeBom = platform("androidx.compose:compose-bom:2025.03.00")
    implementation(composeBom)

    // Wear Compose (versions gerees par BOM)
    implementation("androidx.wear.compose:compose-material3")
    implementation("androidx.wear.compose:compose-foundation")
    implementation("androidx.wear.compose:compose-navigation")

    // Horologist (supplements Google)
    implementation("com.google.android.horologist:horologist-compose-layout:0.6.20")
    implementation("com.google.android.horologist:horologist-compose-material:0.6.20")
    implementation("com.google.android.horologist:horologist-tiles:0.6.20")

    // Tiles & ProtoLayout
    implementation("androidx.wear.tiles:tiles:1.5.0")
    implementation("androidx.wear.tiles:tiles-material3:1.5.0")
    implementation("androidx.wear.protolayout:protolayout:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-material3:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-expression:1.3.0")

    // Health Services
    implementation("androidx.health:health-services-client:1.1.0-alpha05")

    // Health Connect (telephone)
    implementation("androidx.health.connect:connect-client:1.1.0-alpha10")

    // Data Layer
    implementation("com.google.android.gms:play-services-wearable:19.0.0")

    // Wear ongoing activity
    implementation("androidx.wear:wear-ongoing:1.1.0")

    // Complications data source
    implementation("androidx.wear.watchface:watchface-complications-data-source-ktx:1.2.1")

    // Testing
    testImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-test-manifest")
}
```

**SDK Requirements (2025-2026):**

| Parametre | Valeur | Notes |
|-----------|--------|-------|
| `compileSdk` | **35** (Android 15) | Minimum pour M3 Wear complet |
| `targetSdk` | **34** (Android 14) | Requis Play Store depuis aout 2024 |
| `minSdk` | **30** (Wear OS 3) | Minimum pour Compose for Wear OS |
| Kotlin | **1.9.22+** | Pour Compose compiler 1.5+ |
| AGP | **8.3+** | Android Gradle Plugin |
| Compose compiler | **1.5.10+** | Via BOM |

**Versions emulateurs Android Studio:**

| Config emulateur | API | Taille ecran | Forme |
|-----------------|-----|-------------|-------|
| Wear OS Small Round | 33-35 | 192x192 dp | Rond |
| Wear OS Large Round | 33-35 | 225x225 dp | Rond |
| Wear OS Square | 33 | 280x280 dp | Carre |
| Galaxy Watch 4 | 30 | 396x396 px | Rond |
| Pixel Watch | 33 | 384x384 px | Rond |
| Pixel Watch 2 | 34 | 384x384 px | Rond |

**Gradle wrapper (recommande):**
```properties
# gradle-wrapper.properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.6-bin.zip
```

---

## I. Accessibilite

### 22. Accessibilite Wear OS

| Aspect | Regle | Valeur |
|--------|-------|--------|
| Touch target minimum | Standard / Exception | 48dp / 40dp |
| Hauteur liste minimum | Pour TalkBack | >= 32dp par item |
| Contraste texte | WCAG AA | >= 4.5:1 |
| Contraste UI | Elements non-texte | >= 3:1 |
| Focus visible | Outline | 2px solid + offset |
| Font scaling | Supporte | Via Settings > Accessibility |
| TalkBack | Screen reader | Pas de "in list"/"out of list" sur montre |
| Rotary input | Alternative au tactile | Pour dexterite reduite |
| Content descriptions | Obligatoire | Sur tous les elements interactifs |

**TalkBack sur montre - specificites:**
- PAS d'annonces "in list" / "out of list" (ecran trop petit = 1 liste par UI)
- TalkBack skip les items < 32dp de hauteur
- TalkBack skip les items trop pres du haut/bas de l'ecran
- Ajouter padding top/bottom sur premier/dernier item
- Listes horizontales: ces regles ne s'appliquent PAS

**ContentDescription bonnes pratiques:**
- Decrire ce qui est affiche, rien de plus
- PAS de "complication", "tile", "bouton" dans la description
- Ex: pour date "13 decembre" → description = "13 decembre" (pas "Date: 13 decembre")
- Sur complications: `SmallImageComplicationData.Builder.contentDescription(...)`

**Compose accessibility modifiers:**

```kotlin
// Content description sur Image/Icon
Icon(
    imageVector = Icons.Default.Add,
    contentDescription = "Ajouter une cigarette"  // OBLIGATOIRE si interactif, null si decoratif
)

// Custom traversal order (si l'ordre par defaut ne convient pas)
Box(Modifier.semantics { isTraversalGroup = true }) {
    Text("Compteur", Modifier.semantics { traversalIndex = 0f })
    Button(onClick = { }, Modifier.semantics { traversalIndex = 1f }) {
        Text("+1")
    }
}

// Merge semantics (regrouper pour TalkBack)
Row(Modifier.semantics(mergeDescendants = true) { }) {
    Icon(Icons.Default.Info, contentDescription = null)
    Text("5 cigarettes aujourd'hui")
    // TalkBack lit: "5 cigarettes aujourd'hui" (pas icone separement)
}
```

**PickerGroup (built-in accessibility):**
- `PickerGroup` utilise un coordinateur de focus pour assigner le focus au bon `Picker`
- Utiliser les composants built-in quand possible → meilleure accessibilite automatique

**Source:** [Android Developers - Accessibility](https://developer.android.com/training/wearables/accessibility)

### 22b. Motor Accessibility

| Feature | Plateforme | Description |
|---------|-----------|-------------|
| **AssistiveTouch** | watchOS | Naviguer par gestes main: clench, double clench, pinch, double pinch |
| **Voice Control** | Toutes | Naviguer et interagir entierement par la voix |
| **Switch Control** | watchOS | Utiliser un accessoire Bluetooth externe pour naviguer |
| **Reduce Motion** | Toutes | Desactiver animations → respecter ce setting |
| **Touch Accommodations** | watchOS | Hold duration augmentee, ignore repeat taps |
| **Rotary input** | Wear OS | Alternative au tactile pour scroll (bezel/crown) |

**Regles motor accessibility:**
- Touch targets agrandis >= 52dp pour utilisateurs avec tremblements
- TOUJOURS supporter le rotary input comme alternative au scroll tactile
- `Modifier.semantics { Role.Button }` pour TalkBack actions
- Pas de gestes complexes (double tap, long press) comme SEUL moyen d'acceder a une feature
- Toujours avoir un fallback tactile simple pour chaque interaction avancee

### 22c. Cognitive Accessibility

| Regle | Implementation |
|-------|---------------|
| Langage simple | Phrases courtes, mots courants, pas de jargon |
| Icones + texte | Jamais icones seules pour actions importantes |
| Navigation consistante | Meme pattern dans toute l'app |
| Error recovery | Undo toujours disponible, pas de punition |
| Etat clair | L'utilisateur sait toujours ou il est et ce qu'il peut faire |
| Choix limites | Max 3-4 options par ecran |

### 22d. Motion & Animation Tokens (Material 3)

**Duration tokens (official M3):**

| Token | Valeur | Usage |
|-------|--------|-------|
| `short1` | 50ms | Micro-feedback (ripple) |
| `short2` | 100ms | Fade, color change |
| `short3` | 150ms | Small element enter/exit |
| `short4` | 200ms | Button press feedback |
| `medium1` | 250ms | Card expand/collapse |
| `medium2` | 300ms | Screen transitions simples |
| `medium3` | 350ms | Dialog enter |
| `medium4` | 400ms | Complex transitions |
| `long1` | 450ms | Full-screen transitions |
| `long2` | 500ms | Sheet expand |
| `long3` | 550ms | Complex multi-element |
| `long4` | 600ms | Large surface morph |
| `extra-long1` | 700ms | Splash → content |
| `extra-long2` | 800ms | Complex orchestration |
| `extra-long3` | 900ms | Major layout change |
| `extra-long4` | 1000ms | Dramatic reveal |

**Sur montre:** Privilegier short1-4 et medium1-2 (sessions 8-12s, pas de temps pour long).

**Easing tokens (cubic-bezier):**

| Token | Valeur | Usage |
|-------|--------|-------|
| `standard` | `(0.2, 0, 0, 1)` | Mouvement general (enter + exit) |
| `standard.accelerate` | `(0.3, 0, 1, 1)` | Element quitte l'ecran |
| `standard.decelerate` | `(0, 0, 0, 1)` | Element arrive a l'ecran |
| `emphasized.accelerate` | `(0.3, 0, 0.8, 0.15)` | Sortie avec emphase |
| `emphasized.decelerate` | `(0.05, 0.7, 0.1, 1)` | Entree avec emphase (spring-like) |
| `legacy` | `(0.4, 0, 0.2, 1)` | Ancien standard M2 (compat) |
| `linear` | `(0, 0, 1, 1)` | Progress bars, color fade |

**Regles animation sur montre:**
- Eviter animations > 400ms (medium4) sauf transition ecran majeure
- Pas de boucles longues — pause entre boucles >= duree animation
- Animations shape morphing M3: automatiques via MotionScheme, pas besoin de custom
- Privilegier `emphasized.decelerate` pour entrees (plus vif, plus reactif)
- `standard` pour la majorite des animations generales
- Tester avec System Trace pour valider la latence

**Source:** [Material Design 3 - Motion Tokens](https://github.com/material-foundation/material-tokens/blob/json/json/motion.json)

### 22e. Compose Animation APIs

**AnimationSpec types:**

```kotlin
// tween — duration-based, uses easing curve
val spec = tween<Float>(
    durationMillis = 300,
    delayMillis = 0,
    easing = FastOutSlowInEasing   // = M2 standard
)

// spring — physics-based (preferred for natural feel)
val spec = spring<Float>(
    dampingRatio = Spring.DampingRatioMediumBouncy,  // 0.5
    stiffness = Spring.StiffnessMedium               // 1500f
)

// keyframes — multi-step timeline
val spec = keyframes<Float> {
    durationMillis = 300
    0f at 0 using LinearEasing
    0.5f at 150 using FastOutSlowInEasing
    1f at 300
}

// snap — immediate, no animation (state switch)
val spec = snap<Float>(delayMillis = 0)

// repeatable — loop with finite count
val spec = repeatable<Float>(
    iterations = 3,
    animation = tween(200),
    repeatMode = RepeatMode.Reverse
)
```

**Sur montre:** Privilegier `spring` pour les gestes (plus naturel), `tween` avec short/medium tokens pour les transitions UI. Eviter `repeatable` avec iterations > 3.

### 22f. MotionScheme (M3 Expressive)

`MotionScheme` dans `MaterialTheme` fournit 2 specs preconfigures:

| Spec | Peut depasser les bornes (overshoot) | Usage |
|------|--------------------------------------|-------|
| `defaultSpatialSpec()` | Oui (spring) | Position, taille, forme (shape morphing) |
| `defaultEffectsSpec()` | Non (strict) | Couleur, opacite, alpha |

```kotlin
// Utilisation dans un composable
val motionScheme = MaterialTheme.motionScheme

// Spatial — pour deplacement/redimensionnement (peut overshoot)
val positionSpec = motionScheme.defaultSpatialSpec<IntOffset>()

// Effects — pour couleur/opacite (pas d'overshoot)
val alphaSpec = motionScheme.defaultEffectsSpec<Float>()
```

**Regle:** Ne JAMAIS utiliser `defaultSpatialSpec` pour des couleurs/alpha (l'overshoot produirait des valeurs invalides). Utiliser `defaultEffectsSpec` pour tout ce qui a des bornes strictes.

### 22g. Tile Animations (ProtoLayout)

**Contraintes tiles:**
- **Max 4 elements animes simultanement** dans une tile
- Enter/exit transitions supportees: `fadeIn`, `fadeOut`, `slideIn`, `slideOut`
- Pas de spring — uniquement duration-based
- Les tiles ont un framerate reduit par rapport a Compose

```kotlin
// ProtoLayout tile animation
setEnterTransition(
    EnterTransition.Builder()
        .setFadeIn(FadeInTransition.Builder().build())
        .setSlideIn(SlideInTransition.Builder()
            .setDirection(SlideDirection.SLIDE_DIRECTION_BOTTOM_TO_TOP)
            .build())
        .build()
)
```

### 22h. Shared Element Transitions

**Compose (Wear OS):**
```kotlin
// sharedElement — element identique entre 2 ecrans (icon, image)
Modifier.sharedElement(
    rememberSharedContentState(key = "item_$id"),
    animatedVisibilityScope = this
)

// sharedBounds — conteneur qui change de taille/position
Modifier.sharedBounds(
    rememberSharedContentState(key = "container_$id"),
    animatedVisibilityScope = this
)
```

**watchOS (SwiftUI):**
```swift
.matchedGeometryEffect(id: "item_\(id)", in: namespace)
```

### 22i. Regles Critiques Animation Montre

| Regle | Detail |
|-------|--------|
| **Durees 30% plus courtes** | Une animation de 300ms mobile = ~200ms sur montre |
| **Target 30 FPS** | Suffisant pour la montre, economise la batterie |
| **Pas d'animation au lancement** | L'utilisateur veut l'info immediatement |
| **Max 1 animation a la fois** | Eviter les orchestrations complexes |
| **Privilegier spring** | Plus naturel que tween pour les gestes |

**Comparaison cross-platform:**

| Aspect | Wear OS (Compose) | watchOS (SwiftUI) |
|--------|-------------------|-------------------|
| Physics | `spring()` | `.smooth(duration: 0.5)` |
| Bounce | `DampingRatioMediumBouncy` | `.snappy(duration: 0.5, extraBounce: 0.1)` |
| High bounce | `DampingRatioHighBouncy` | `.bouncy(duration: 0.5, extraBounce: 0.2)` |
| Duration-based | `tween(300ms)` | `.easeInOut(duration: 0.3)` |
| Shared element | `sharedElement()` / `sharedBounds()` | `matchedGeometryEffect` |
| Tile/Widget | ProtoLayout (max 4 animes) | WidgetKit (limited) |

**Sources:** [Compose Animation docs](https://developer.android.com/develop/ui/compose/animation), [SwiftUI Animation](https://developer.apple.com/documentation/swiftui/animation)

---

## J. Haptics & Feedback

### 23. Feedback Haptique

**VibrationEffect Wear OS (predefined):**

| Constant | Int | Description | Usage |
|----------|-----|-------------|-------|
| EFFECT_CLICK | 0 | Clic court et net | Confirmation tap |
| EFFECT_DOUBLE_CLICK | 1 | Deux clics rapides | Erreur / attention |
| EFFECT_TICK | 2 | Tick leger | Scroll, navigation |
| EFFECT_HEAVY_CLICK | 5 | Clic fort et prononce | Action importante |
| EFFECT_TEXTURE_TICK | 21 | Tick texture (API 31+) | Feedback subtil |

**Composition Primitives (API 30+):**

| Primitive | Int | Description |
|-----------|-----|-------------|
| PRIMITIVE_CLICK | 1 | Clic net |
| PRIMITIVE_THUD | 3 | Impact lourd basse-freq |
| PRIMITIVE_SPIN | 4 | Sensation rotation |
| PRIMITIVE_QUICK_RISE | 5 | Montee rapide intensite |
| PRIMITIVE_SLOW_RISE | 6 | Montee progressive |
| PRIMITIVE_QUICK_FALL | 7 | Descente rapide |
| PRIMITIVE_TICK | 8 | Tick leger |
| PRIMITIVE_LOW_TICK | 9 | Tick subtil basse-freq |

**Parametres vibration custom:**

| Parametre | Min | Max | Recommande | Unite |
|-----------|-----|-----|-----------|-------|
| Duree pulse | 1 | 10000 | 50-300 | ms |
| Amplitude | 1 | 255 | 80-200 | int |
| Gap entre pulses | 0 | 10000 | 50-500 | ms |
| Duree totale pattern | - | - | < 2000 | ms |
| Composition scale | 0.0 | 1.0 | 0.3-0.8 | float |
| Composition delay | 0 | 10000 | 50-300 | ms |

**watchOS WKHapticType:**

| Case | Int | Usage |
|------|-----|-------|
| .notification | 0 | Alerte arrivee |
| .directionUp | 1 | Scroll / valeur augmente |
| .directionDown | 2 | Scroll / valeur diminue |
| .success | 3 | Action reussie |
| .failure | 4 | Erreur / rejet |
| .retry | 5 | Retry dispo |
| .start | 6 | Debut timer/workout |
| .stop | 7 | Fin timer/workout |
| .click | 8 | Selection element UI |

**Pattern detection cigarette (notre app):**
```
// "Alert + Awareness" pattern - ~650ms, intensite descendante
PRIMITIVE_QUICK_RISE (scale 0.8) →
  delay 100ms →
PRIMITIVE_THUD (scale 0.6) →
  delay 200ms →
PRIMITIVE_TICK (scale 0.4) →
  delay 150ms →
PRIMITIVE_TICK (scale 0.4)

// Alternative createWaveform:
timings:    [0, 150, 80, 200, 80, 150]
amplitudes: [0, 180, 0,  120, 0,  100]
repeat:     -1
```
Intensite descendante = attire l'attention sans agacer. Distinct des notifications standard.

**Quand utiliser haptic vs son vs visuel:**

| Contexte | Recommandation |
|----------|---------------|
| Public | Haptique seulement |
| Prive/maison | Son acceptable |
| Alerte urgente (sante) | Haptique + son optionnel (respecter DND) |
| Timer/alarme | Son + haptique |
| Confirmation | Haptique seulement |
| Navigation | Haptique (en conduisant) |
| Appel entrant | Son + haptique |

**Principes haptic design Google** ([source](https://developer.android.com/develop/ui/views/haptics/haptics-principles)):
- **Consistance** : meme effet haptic = meme type d'interaction partout
- **Integration** : co-designer visuel + audio + haptique ensemble (congruent)
- **Moderation** : less is more — trop de vibrations = agacant + engourdissement
- **Semantique** : chaque pattern = une signification universelle dans l'app

**Regles:**
- Haptique = feedback principal sur montre (pas le son)
- Son = reserve aux alarmes/timers critiques
- Toujours coupler haptique + visuel (DND peut couper haptique)
- Respecter les modes silencieux/DND/theatre
- Verifier `NotificationManager.getCurrentInterruptionFilter()`
- ZEN_MODE: 0=off, 1=important only, 2=no interruptions, 3=alarms only

---

## K. Notifications

### 24. Notifications sur Montre

| Aspect | Regle |
|--------|-------|
| Style recommande | BigTextStyle (expandable) |
| Actions | Via WearableExtender (pas NotificationBuilder direct) |
| Max actions | **3** actions max (empilees vertical) |
| Label action max | ~**12-14 caracteres** pour lisibilite |
| Reply | Inline actions, reponses predefinies, voice input |
| Texte collapsed | **< 40 caracteres** pour vue primaire |
| Temps de lecture moyen | ~**5 secondes** par notification |
| Ongoing | Pour foreground service (mini-dashboard permanent) |

**Importance levels:**

| Niveau | Constante | Comportement montre |
|--------|-----------|-------------------|
| HIGH (4) | IMPORTANCE_HIGH | Heads-up, haptique + son |
| DEFAULT (3) | IMPORTANCE_DEFAULT | Stream, haptique seulement |
| LOW (2) | IMPORTANCE_LOW | Stream, pas d'interruption |
| MIN (1) | IMPORTANCE_MIN | Stream, invisible quasi |
| NONE (0) | IMPORTANCE_NONE | Cache |

**Bridged vs Local:**

| Aspect | Bridged (du telephone) | Local (sur montre) |
|--------|----------------------|-------------------|
| Source | App telephone | App montre |
| Latence | ~1-3s (relai BT) | Immediate |
| Actions | Ouvre app telephone | Ouvre app montre |
| Dismiss sync | Via `setDismissalId()` | Via `setDismissalId()` |
| Recommande quand | Pas d'app standalone | App standalone installee |

**Source:** [Android Developers](https://developer.android.com/training/wearables/notifications)

**Notification-first pattern (notre app):**
```
Detection cigarette →
  Notification heads-up:
  "Cigarette detectee a 14:23"
  [Confirmer] [Faux positif]

  Si confirme → compteur +1 + haptique succes
  Si faux positif → ignore + ameliore le modele
  Si ignore (timeout 5min) → compte comme confirmee
```

**Ongoing notification (monitoring):**
```
Notification permanente (foreground service):
  "Monitoring actif - 5 cigarettes aujourd'hui"
  [+1 Manuelle] [Pause]
```

**Anti-patterns notifications montre:**
- Trop de notifications → l'utilisateur les desactive
- Actions non claires (icones sans labels)
- Forcer l'ouverture de l'app pour repondre
- Notifications identiques telephone + montre (bridging non filtre)

---

## K-bis. App Lifecycle & State Management

### 24b. Cycle de Vie App sur Montre

| Phase | Timing | Comportement |
|-------|--------|-------------|
| **Cold start** | 2-5s (cible < 2s) | Premier lancement, tout initialise. Baseline profiles = -20-40% |
| **Warm start** | < 500ms | App en background, resume rapide |
| **Hot start** | < 200ms | App en memoire, juste onResume |
| **Kill par systeme** | Apres ~5-15 min en background | LowMemoryKiller tue les apps non-foreground |
| **Foreground service** | Indefini | Seul moyen de garantir la survie en background |

**Memory Management:**
- `LowMemoryKiller` priorite: Foreground > Visible > Service > Background > Empty
- Apps montre tuees plus agressivement que sur telephone (RAM limitee)
- Heap par defaut: 128-192 MB, largeHeap: 256 MB
- Target < 50 MB en pratique pour etre un bon citoyen
- `onTrimMemory(TRIM_MEMORY_RUNNING_LOW)` → liberer caches
- `onSaveInstanceState` → sauvegarder compteur + timer obligatoirement

**Resume et Continuite:**

| Scenario | Comportement attendu |
|----------|---------------------|
| Retour apres < 5min | Meme ecran, meme etat |
| Retour apres 5-30min | Ecran principal, donnees fraiches |
| Retour apres > 30min | Ecran principal, refresh complet |
| Apres kill systeme | Restaurer via SavedInstanceState + DB locale |
| Raise-to-wake | Montre = watch face. Derniere app si < 2min (configurable) |
| Timer en cours | TOUJOURS recalculer au resume (SystemClock.elapsedRealtime) |

**RecentApps timeout Wear OS:** ~3-5 minutes par defaut avant de disparaitre des recents.

**Transition interactif → ambient → interactif:**
- Pas de flash blanc (fond #000000 = smooth)
- Ambient: simplifier l'UI (outlines, moins d'elements)
- Resume: restaurer l'UI complete sans animation de transition lourde
- Timing: ~300ms pour transition complete

### 24c. Wrist Detection et On-Body State

| Etat | Detection | Impact |
|------|-----------|--------|
| Au poignet | Capteur capacitif, latence 1-3s | Tous capteurs actifs, ecran unlock |
| Retire du poignet | Perte contact | Lock screen + PIN, capteurs HR off |
| Remis au poignet | Contact detecte | Demande PIN, resume capteurs |
| Sur le chargeur | Detecte via BatteryManager | Nightstand mode, sync complete |

**Impact tracking:**
- Arreter capteurs HR/SpO2 si montre retiree (donnees invalides)
- Accelerometre sur table = bruit non pertinent → ignorer
- Logger le gap dans les donnees (timestamps debut/fin retrait)
- Resume automatique du monitoring a la remise au poignet
- API: `SensorManager.getDefaultSensor(Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT)`

### 24d. Charging UX et Battery States

**Nightstand mode (sur chargeur):**
- Ecran always-on acceptable (pas de souci batterie)
- Afficher horloge + prochain alarme
- Tracking: PAUSE la detection (pas au poignet)
- Sync complete: profiter du WiFi + charge pour gros transferts
- Mise a jour modele ML si disponible

**Battery states UX:**

| Niveau | Seuil | Action app |
|--------|-------|-----------|
| Normal | > 30% | Toutes features actives |
| Low | 15-30% | Reduire sampling capteurs (50Hz → 10Hz) |
| Critical | 5-15% | Desactiver ML, garder compteur manuel |
| Ultra low | < 5% | Notification "batterie faible", mode minimal |

**Charge rapide par modele:**

| Modele | 0-100% | 30 min = |
|--------|--------|----------|
| Galaxy Watch 7 | ~90 min | ~50% |
| Pixel Watch 3 | ~75 min | ~55% |
| Apple Watch S10 | ~75 min | ~80% (fast charge) |

**System Battery Saver Mode (Wear OS):**

```kotlin
// Detecter le mode economie d'energie systeme
val powerManager = getSystemService(PowerManager::class.java)
val isBatterySaver = powerManager.isPowerSaveMode

// Ecouter les changements
val filter = IntentFilter(PowerManager.ACTION_POWER_SAVE_MODE_CHANGED)
registerReceiver(object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val saving = powerManager.isPowerSaveMode
        if (saving) disableNonEssentialFeatures()
        else restoreNormalOperation()
    }
}, filter)
```

**Comportement systeme en Battery Saver (Wear OS 5+):**

| Impact | Detail |
|--------|--------|
| Network | Connexions differees, pas de sync en arriere-plan |
| Location | GPS desactive sauf foreground actif |
| Jobs | WorkManager/JobScheduler differes jusqu'a charge |
| Vibration | Reduite ou desactivee |
| AOD | Peut etre desactive automatiquement |
| App standby | Buckets plus restrictifs |

**Bonnes pratiques Battery Saver:**
- Detecter `isPowerSaveMode` et reduire proactivement (capteurs, animations, sync)
- NE JAMAIS demander a l'utilisateur de desactiver Battery Saver
- Garder la fonctionnalite core (compteur cigarettes) meme en mode eco
- Desactiver: ML inference, animations non-essentielles, sync frequente
- Garder: compteur manuel, haptique confirmation, affichage basique

**watchOS Low Power Mode (watchOS 9+):**
- `ProcessInfo.processInfo.isLowPowerModeEnabled`
- Observe via `NSProcessInfoPowerStateDidChange`
- Reduit: background app refresh, heart rate, WiFi, Always-On Display
- Complications: updates moins frequentes (1x/heure max)
- App doit reduire animations et network calls

**Eviter "battery drain notification":**
- Optimiser sampling (batching, event-triggered)
- Budget total < 10-15% batterie/jour pour toutes apps tierces
- Foreground notification: formuler positivement ("Monitoring actif") pas negativement

### 24e. Ongoing Activity API

**But:** Garder l'app visible sur watch face + Recents pendant une session longue (workout, tracking).

**Dependances:**

```gradle
implementation "androidx.wear:wear-ongoing:1.1.0"
implementation "androidx.core:core:1.17.0"
```

**Implementation:**

```kotlin
val pendingIntent = PendingIntent.getActivity(this, 0,
    Intent(this, MainActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
    },
    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
)

val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_smoking)
    .setContentTitle("Monitoring actif")
    .setCategory(NotificationCompat.CATEGORY_WORKOUT)
    .setOngoing(true)

val ongoingActivity = OngoingActivity.Builder(applicationContext, NOTIFICATION_ID, notificationBuilder)
    .setAnimatedIcon(R.drawable.ic_animated_smoke)  // noir/blanc, fond transparent
    .setStaticIcon(R.drawable.ic_smoke_static)      // pour ambient
    .setTouchIntent(pendingIntent)                  // tap → retour dans l'app
    .setStatus(
        Status.Builder()
            .addTemplate("#count# cigarettes")
            .addPart("count", Status.TextPart("5"))
            .build()
    )
    .build()

ongoingActivity.apply(applicationContext)
startForeground(NOTIFICATION_ID, notificationBuilder.build())
```

**Surfaces affichees:**

| Surface | Mode actif | Mode ambient |
|---------|-----------|-------------|
| Watch face | Icone animee (tappable) | Icone statique |
| Recents launcher | Item + status dynamique | Item |

**Categories de priorite:**
`CATEGORY_CALL` > `CATEGORY_NAVIGATION` > `CATEGORY_TRANSPORT` > `CATEGORY_ALARM` > `CATEGORY_WORKOUT` > `CATEGORY_STOPWATCH`

**Regles:**
- Icone statique OBLIGATOIRE (sinon `IllegalArgumentException`)
- Touch intent OBLIGATOIRE
- Icones noir/blanc avec fond transparent
- Updates: quelques fois par minute raisonnable
- Stop: simplement `notificationManager.cancel(NOTIFICATION_ID)`

**Source:** [Android Developers - Ongoing Activity](https://developer.android.com/training/wearables/notifications/ongoing-activity)

### 24f. Splash Screen (Wear OS)

**Dependance:** `androidx.core:core-splashscreen:1.2.0+`

**Theme (`res/values/styles.xml`):**

```xml
<style name="Theme.App.Starting" parent="Theme.SplashScreen">
    <item name="windowSplashScreenBackground">@android:color/black</item>
    <item name="windowSplashScreenAnimatedIcon">@drawable/splash_icon</item>
    <item name="postSplashScreenTheme">@style/Theme.App</item>
</style>
<!-- Icone non-ronde: parent="Theme.SplashScreen.IconBackground" -->
```

**Drawable (`res/drawable/splash_icon.xml`):**

```xml
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:width="48dp" android:height="48dp"
          android:drawable="@mipmap/ic_launcher" android:gravity="center" />
</layer-list>
<!-- Icone non-ronde: 36dp au lieu de 48dp -->
```

**Manifest:**

```xml
<activity android:name=".MainActivity"
    android:theme="@style/Theme.App.Starting"
    android:exported="true">
```

**Activity:**

```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    installSplashScreen()  // AVANT super.onCreate()
    super.onCreate(savedInstanceState)
    setContent { WearApp() }
}
```

**Source:** [Android Developers - Splash Screen](https://developer.android.com/training/wearables/apps/splash-screen)

---

## L. Onboarding & Permissions

### 25. First-Run Experience

| Etape | Pattern | Duree max |
|-------|---------|-----------|
| 1. Installation | Via telephone ou Play Store montre | Automatique |
| 2. Pairing | Data Layer handshake | Automatique si meme compte |
| 3. Permissions | BODY_SENSORS d'abord, BACKGROUND ensuite | 2 ecrans max |
| 4. Configuration | Poignet (G/D) + main fumeur | 1 ecran |
| 5. Premier usage | Demarrage auto monitoring | Immediat |

**Permissions - ordre et timing:**
1. **BODY_SENSORS** → demander au premier lancement (critique pour l'app)
2. **ACTIVITY_RECOGNITION** → demander au premier lancement
3. **BODY_SENSORS_BACKGROUND** → demander APRES avoir accorde BODY_SENSORS
4. **NE JAMAIS** demander BODY_SENSORS et BODY_SENSORS_BACKGROUND en meme temps → le systeme ignore les deux

**Wear OS 6+ (API 36):** BODY_SENSORS migre vers `android.permissions.health.*`

**Permission refusee - comportement:**
- Ne PAS bloquer l'utilisateur
- Proposer un mode degrade (compteur manuel sans detection auto)
- Feedback visuel actionnable ("Activer les capteurs dans Parametres")
- Guide vers la page Settings si necessaire

**Source:** [Android Developers - Permissions](https://developer.android.com/training/wearables/apps/permissions)

### 26. Progressive Disclosure

| Niveau | Ce qui est montre | Ce qui est cache |
|--------|-------------------|-----------------|
| Glance (tile/complication) | Compteur du jour | Historique, stats |
| Ecran principal | Compteur + bouton +1 | Parametres, graphs |
| Detail (scroll/tap) | Historique jour, derniere detection | Parametres avances |
| Settings | Config complete | Debug, export |

**Regle:** L'utilisateur ne devrait JAMAIS avoir besoin de plus de 2 taps pour accomplir l'action principale.

### 26b. Permissions sur Wear OS

**Permissions cles pour notre app:**

| Permission | API level | Usage |
|-----------|-----------|-------|
| `BODY_SENSORS` | ≤ 35 | Capteurs biometriques (HR, etc.) |
| `android.permission.health.READ_HEART_RATE` | 36+ | Remplace BODY_SENSORS |
| `ACTIVITY_RECOGNITION` | 29+ | Detection activite physique |
| `POST_NOTIFICATIONS` | 33+ | Notifications |
| `FOREGROUND_SERVICE_HEALTH` | 34+ | Service foreground sante |

**Compose permission state:**

```kotlin
val permissionState = rememberPermissionState(
    permission = Manifest.permission.BODY_SENSORS,
    onPermissionResult = { granted ->
        if (granted) startMonitoring()
    }
)

if (permissionState.status.isGranted) {
    MonitoringScreen()
} else {
    PermissionRequestScreen(
        onRequest = { permissionState.launchPermissionRequest() }
    )
}
```

**4 scenarios de permissions:**
1. **Watch demande permission watch** — Dialog systeme standard
2. **Watch demande permission phone** — Renvoyer l'utilisateur au telephone
3. **Phone demande permission watch** — Renvoyer l'utilisateur a la montre
4. **Phone demande plusieurs d'un coup** (Android 12+) — `CompanionDeviceManager`

**Patterns UX pour permissions:**
- **Ask in context** — Demander quand le besoin est evident (tap "detecter" → permission capteurs)
- **Educate in context** — Expliquer AVANT si pas evident, utiliser `shouldShowRequestPermissionRationale()`
- Icone cadenas pour features desactivees par permission refusee
- Ne JAMAIS bloquer l'app entiere pour une permission refusee

**Denial flow:**
1. Premier refus → peut re-demander
2. Deuxieme refus → option "Don't show again"
3. Apres "Don't show again" → Settings uniquement

**Watch faces:** NE PAS demander de permissions directement, utiliser les complications.

**Source:** [Android Developers - Permissions](https://developer.android.com/training/wearables/apps/permissions)

---

## M. Internationalization (i18n)

### 27. Texte sur Ecran Minuscule

| Langue | Expansion vs anglais | Impact |
|--------|---------------------|--------|
| Allemand | +30-40% | Troncature frequente |
| Francais | +15-25% | Troncature possible |
| Chinois/Japonais | -30-50% (caracteres) | Plus compact |
| Arabe/Hebreu | RTL layout requis | Mirror horizontal |

**Strategies de troncature:**
- Ellipsis (...) par defaut sur tout texte debordant
- Abbreviations predefinies par langue (ex: "cigarettes" → "cig." → "5")
- Privilegier icones + chiffres over texte
- Tester avec la langue la plus longue (allemand)
- Complications: max 7 caracteres pour SHORT_TEXT

**RTL sur ecran rond:**
- Layout se mirror horizontalement
- PositionIndicator passe a gauche
- Swipe directions restent les memes (UX systeme)
- TimeText reste en haut centre

**Date/heure sur complications:**
- Format court toujours (12h vs 24h selon locale)
- Abreviations mois ("Jan" vs "janv." vs "1月")
- Respecter les separateurs locaux (. vs / vs -)

---

## N. Distribution & Store

### 28. Google Play pour Wear OS

| Requirement | Valeur |
|------------|--------|
| API target minimum | Android 13 (API 33) ou 14 (API 34) depuis aout 2024 |
| Manifest requis | `<uses-feature android:name="android.hardware.type.watch" />` |
| Standalone flag | `android:value="true"` dans meta-data |
| Screenshots | Screenshots specifiques Wear OS dans la listing |
| App quality | Doit passer le checklist Wear OS |
| Standalone pour promo | Requis pour apparaitre dans le store on-watch |

**Standalone vs Non-standalone:**

| Type | Description | Store on-watch |
|------|-------------|---------------|
| Standalone | Fonctionne sans telephone | Oui (promu) |
| Non-standalone | Necessite telephone | Non promu |
| Hybrid | Fonctionne seul, enrichi avec telephone | Oui (recommande) |

**Source:** [Android Developers - Distribute](https://developer.android.com/distribute/best-practices/launch/distribute-wear)

---

## O. Design System Montre

### 29. Couleurs OLED

| Usage | Couleur | Hex |
|-------|---------|-----|
| Fond principal | Noir pur | #000000 |
| Surface elevation 0 | Quasi-noir | #121212 |
| Surface elevation 1 | Gris tres fonce | #1E1E1E |
| Surface elevation 4 | Gris fonce | #272727 |
| Surface elevation 8 | Gris moyen-fonce | #2E2E2E |
| Texte primaire | Blanc | #FFFFFF ou #E0E0E0 |
| Texte secondaire | Gris clair | #9E9E9E |
| Accent primaire | Selon brand | Saturation reduite vs mobile |
| Succes | Vert | #4CAF50 |
| Erreur | Rouge | #F44336 |
| Warning | Orange | #FF9800 |

**Regles couleurs OLED:**
- Fond TOUJOURS #000000 (pixels eteints = 0 conso)
- Eviter les grandes surfaces blanches (conso + burn-in)
- Couleurs desaturees vs mobile (ecran petit = plus intense percu)
- Ambient mode: blanc/gris seulement (pas de couleurs)
- Contraste 4.5:1 minimum pour texte, 3:1 pour UI
- Toutes les paires de couleurs M3 garantissent **minimum 3:1 contraste**

### 29c. Systeme de Couleurs M3 Expressive (28 tokens)

**3 couches d'accent + 2 couches neutres:**

| Groupe | Roles | Usage |
|--------|-------|-------|
| **Primary** | primary, onPrimary, primaryDim, primaryContainer, onPrimaryContainer | Actions principales (EdgeButton, CTA, etats actifs) |
| **Secondary** | secondary, onSecondary, secondaryDim, secondaryContainer, onSecondaryContainer | Actions secondaires, zones denses |
| **Tertiary** | tertiary, onTertiary, tertiaryDim, tertiaryContainer, onTertiaryContainer | Accents contrastants, badges, objectif atteint |
| **Error** | error, onError, errorDim, errorContainer, onErrorContainer | Supprimer, fermer, alertes urgence (rouge teinte) |
| **Surface** | surfaceContainerLow, surfaceContainer, surfaceContainerHigh, onSurface, onSurfaceVariant | Fonds, conteneurs, texte |

**Modificateurs de tokens:**
- **On-** = texte/icones SUR la couleur parente (ex: onPrimary = texte sur fond primary)
- **-Dim** = version attenuee, pas d'attention immediate
- **-Container** = fill pour elements foreground (boutons, cards), PAS pour texte
- **-Variant** = alternative moins marquee

**Dynamic Color (Wear OS 6+):**
```kotlin
val dynamicColors = dynamicColorScheme(LocalContext.current)
MaterialTheme(colorScheme = dynamicColors ?: myBrandColors) { ... }
```
- Palette auto generee depuis les couleurs du watch face Pixel
- Fallback sur les couleurs brand si non supporte
- Coherence visuelle: app s'integre naturellement au cadran choisi

**Source:** [Color Roles and Tokens](https://developer.android.com/design/ui/wear/guides/styles/color/roles-tokens)

### 29b. Couleurs - Daltonisme et Gradients

**Daltonisme (8% des hommes):**
- NE JAMAIS encoder l'info UNIQUEMENT par la couleur
- Toujours doubler: couleur + icone OU couleur + forme OU couleur + texte
- Rouge/vert: utiliser rouge + triangle warning vs vert + checkmark
- Simuler avec Android Studio (Color Blind simulator) ou Figma plugin
- Modes specifiques: Deuteranopia (vert), Protanopia (rouge), Tritanopia (bleu)

**Gradients sur montre:**
- Utilisation limitee: boutons gradient acceptes (Compose for Wear OS Chip gradient)
- Backgrounds: NON (fond toujours #000000)
- Progress arcs: gradient acceptable (ex: bleu→vert progression)
- Ambient mode: PAS de gradients (trop de pixels allumes)

**Nombre de couleurs max dans une app montre:**
- 1 couleur primaire (brand/accent)
- 1 couleur secondaire (optionnelle)
- Gris pour texte secondaire
- Vert/rouge/orange pour statuts semantiques
- Total: **4-5 couleurs max** (plus = confusion sur petit ecran)

### 30. Icones

| Type | Taille | Format |
|------|--------|--------|
| Launcher icon (montre) | 48x48 dp (circular) | Adaptive icon, fond circulaire |
| Complication icon | Monochromatique, tintable | SVG/VectorDrawable |
| Action notification | 24x24 dp | Monochromatique |
| Bouton icon | 24-30 dp selon taille bouton | Material Icons |

### 30b. Design Tokens Wearable

**Spacing scale montre (plus petite que mobile):**

| Token | Valeur | Usage |
|-------|--------|-------|
| space-xxs | 2dp | Intra-component gaps |
| space-xs | 4dp | Entre elements lies (icone-label) |
| space-sm | 6dp | Entre items de liste |
| space-md | 8dp | Sections mineures |
| space-lg | 12dp | Card padding |
| space-xl | 16dp | Section separators |
| space-xxl | 24dp | Top/bottom content padding |

**Comparaison mobile vs montre:**
- Mobile spacing base: 8dp → Montre: 4dp
- Mobile padding: 16dp → Montre: 8-12dp
- Mobile section gap: 24dp → Montre: 12-16dp

**Border radius:**
- Boutons: circulaires (50% radius)
- Cards: 24dp (suit la courbure de l'ecran)
- Chips: 16dp (coins arrondis)
- Dialogs: full-screen (pas de radius)

**Elevation sur OLED noir:**
- Pas de shadows (invisibles sur noir)
- Utiliser couleurs de surface (#1E1E1E, #272727) pour hierarchie
- Plus clair = plus eleve (inverse du mode light)

**SwiftUI watchOS - composants cles:**
- `NavigationStack` → navigation hierarchique
- `List` → liste native avec swipe actions
- `TabView` → pages swipables (style PageTabViewStyle)
- `Gauge` → jauge semi-circulaire (objectif/progress)
- `ProgressView` → progress circulaire ou lineaire
- `.digitalCrownRotation` → binding au Digital Crown
- `TimelineView` → updates periodiques (complications)
- `ContainerBackground` → fond custom derriere le contenu

### 30c. Outils de Prototypage & Design

> **Section detaillee : voir AA. Outils de Prototypage & Design (sections 44-47)**
> Contient: Figma kits officiels avec liens, @WearPreviewDevices, emulateurs, Layout Inspector,
> Direct Surface Launch, ProtoPie (seul player Wear OS natif), Samsung Watch Face Studio,
> accessibility testing checklist, workflow design-to-dev 9 etapes, rond vs carre strategy.

---

## P. Curved UI & System Overlay

### 31. Texte Courbe et ArcLine

| Element | Usage | Limite |
|---------|-------|--------|
| CurvedText | Texte suivant la courbure de l'ecran | Wear OS uniquement, court seulement |
| ArcLine | Progress bar / indicateur courbe | Bord de l'ecran |
| TimeText | Heure courbee en haut | Toujours present, s'efface au scroll |
| PositionIndicator | Barre scroll laterale | Cote droit (ou gauche RTL) |

**Quand utiliser du texte courbe vs droit:**
- Courbe: status en haut/bas, labels peripheriques, progress
- Droit: contenu principal, boutons, listes
- Regle: texte courbe = COURT (max ~15-20 caracteres)
- Readability chute rapidement avec la longueur

### 32. System UI et Safe Zones

| Element systeme | Position | Impact |
|----------------|----------|--------|
| TimeText | Haut centre | Contenu passe dessous au scroll |
| PositionIndicator | Droite | Ne pas placer de contenu dessous |
| System gestures | Bords | Reserver 20% gauche pour back swipe |
| Quick settings | Swipe bas | Pas de conflit avec contenu haut |
| Notifications | Swipe haut | Pas de conflit avec contenu bas |
| StatusBar | Minimal | Moins envahissant que sur telephone |

---

## Q. Contextes d'Utilisation

### 33. Contextes Physiques

| Contexte | Contrainte | Adaptation |
|----------|-----------|------------|
| **En mouvement** | Ecran dur a lire, 1 main libre | Gros elements, peu d'info, haptique fort |
| **Pluie / doigts mouilles** | Tactile imprecis | Touch targets XL, Water Lock mode |
| **Gants** | Tactile ne marche PAS | Boutons physiques, bezel, voix |
| **Plein soleil** | Contraste reduit | 2000 nits, couleurs vives, eviter gris subtils |
| **Nuit / cinema** | Luminosite trop forte | AOD, mode theatre, luminosite min |
| **Nage** | Pas de tactile | Water Lock, boutons physiques uniquement |
| **Conduite** | Attention requise | ZERO interaction complexe, 1 tap max |
| **Au lit / reveil** | Ecran face au visage | Luminosite basse, alarme haptique |
| **Reunion** | Discretion requise | Haptique subtil, pas de son, glance rapide |

### 34. Contexte et Detection Auto

| Contexte detecte | Source | Action app |
|-----------------|--------|-----------|
| Activite physique | ACTIVITY_RECOGNITION | Pause detection cigarette |
| Sommeil | Samsung Health / Health Services | Mode nuit, pas de notifications |
| Chargeur connecte | BatteryManager | Sync complete, mise a jour modele |
| Deconnecte du telephone | Data Layer | Mode offline, stockage local |
| Premier reveil | Premiere interaction matin | Reset compteur jour si configure |

---

## R. Data Visualization sur Montre

### 35. Visualisation sur Ecran Minuscule

| Type | Quand | Comment |
|------|-------|---------|
| **Chiffre seul** | Metrique principale | Gros, centre, 1 valeur |
| **Progress ring** | Objectif avec cible | Arc autour de l'ecran (ArcLine) |
| **Mini bar chart** | Tendance 7 jours | Max 7 barres, hauteur relative |
| **Sparkline** | Tendance continue | Ligne simple, pas d'axes |
| **Dot indicator** | Compteur discret | Points colores (ex: clopes du jour) |
| **Heat map ring** | Repartition horaire | Segments colores autour du cercle |

**Anti-patterns data viz montre:**
- Graphiques complexes (line chart avec axes, legends)
- Tableaux de donnees
- Camemberts avec plus de 3 segments
- Texte explicatif long
- Interaction pour reveler des donnees (hover impossible)

**Regles data viz montre:**
- Pas d'axes visibles (pas de place)
- Pas de legendes separees (integrer dans le chart)
- Max 7 data points visibles (7 barres, 7 segments)
- Animation entry: ~300ms ease-out
- Tap sur chart → "Voir details sur telephone" (deep link)
- Couleur = information semantique (vert=bon, rouge=mauvais)

**Comparaison Aujourd'hui vs Historique:**

| Format | Exemple | Quand |
|--------|---------|-------|
| Fleche + pourcentage | "↑ 25%" ou "↓ 12%" | Tendance vs hier/moyenne |
| Delta absolu | "+3 vs hier" | Compteur, difference exacte |
| Progress ring | Anneau rempli a 75% | Objectif quotidien |
| Sparkline | Mini-courbe 7 jours | Tendance hebdo |
| Couleur seule | Vert/orange/rouge | Statut rapide (glanceable) |

**Regle d'or:** 1 metrique par ecran, contexte minimal, drill-down vers telephone pour details.

---

## S. Securite & Privacy

### 36. Donnees sur Montre

| Aspect | Recommandation |
|--------|---------------|
| EncryptedSharedPreferences | OUI disponible (AES-256 GCM + SIV), ~2-5ms par read/write |
| EncryptedFile | Disponible (AndroidX Security) |
| Room + SQLCipher | Disponible (encryption DB complete) |
| Android Keystore | Disponible (cles hardware-backed) |
| Donnees sensibles | Minimiser ce qui reste sur la montre |
| Auth | Wrist detection auto (capteur capacitif, latence 1-3s) |
| PIN | 4-10 digits, requis apres retrait du poignet |
| Biometrique | NON disponible (pas de hardware sur montres actuelles) |
| Credential Manager | Wear OS 4+ (passkeys, passwords) |
| OAuth | Via `RemoteAuthClient` (auth assistee par telephone) |
| HTTPS | Obligatoire (TLS 1.3) pour toute communication cloud |
| Health data GDPR | Consentement explicite Art.9, droit a l'effacement, DPIA requis |
| Health data HIPAA | Encryption at rest + in transit, audit logs, BAA requis |
| Export | JSON/CSV depuis l'app telephone, pas depuis la montre |

**Data minimization:**
- Collecter uniquement les permissions necessaires
- Traiter on-device (ML local plutot que cloud)
- Agreger avant de transmettre (resumes quotidiens, pas donnees brutes)
- Auto-suppression (raw data supprimee apres 7 jours)
- Pas d'identifiants persistants (IDs rotatifs)

**Permissions Wear OS 6+ migration:**
- `BODY_SENSORS` → `android.permissions.health.*` (granulaire)
- Plus fin: HR, temperature, SpO2 separement
- Background access: demande separee obligatoire
- Chaque permission dangereuse doit etre accordee sur la montre separement (pas de sync depuis telephone)

**Privacy UX:**
- Onboarding: expliquer clairement quelles donnees sont collectees et pourquoi
- Settings: section "Vos donnees" accessible (liste permissions + toggle)
- Delete my data: bouton clair, confirmation, irreversible, accessible depuis telephone
- No-cloud option: tout garder 100% local = argument de vente pour donnees addiction
- Anonymisation: si sync cloud, hasher les identifiants
- Export: JSON/CSV depuis telephone, avec chiffrement optionnel

### 36b. Authentication sur Montre

**Methode recommandee:** Credential Manager (`credentials:1.5.0`)

**Methodes supportees (priorite):**
1. **Passkeys** — industrie standard, phishing-resistant, screen lock device
2. **Sign In with Google** — federated identity
3. **Data Layer token sharing** — phone envoie token → watch recoit
4. **OAuth PKCE** — redirection via RemoteAuthClient
5. **OAuth DAG (Device Authorization Grant)** — code affiche sur montre, confirme sur telephone

**Code Credential Manager:**

```kotlin
try {
    val response = credentialManager.getCredential(activity, createGetCredentialRequest())
    authenticate(response.credential)
} catch (_: GetCredentialCancellationException) {
    navigateToSecondaryAuthentication()
} catch (_: NoCredentialException) {
    showGuestMode()  // JAMAIS bloquer l'app
}
```

**Token sharing (phone → watch via Data Layer):**

```kotlin
// Mobile envoie le token
val putDataReq = PutDataMapRequest.create("/auth").run {
    dataMap.putString("token", authToken)
    asPutDataRequest()
}
Wearable.getDataClient(context).putDataItem(putDataReq)

// Watch ecoute
class AuthDataListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.dataItem.uri.path?.startsWith("/auth") == true) {
                val token = DataMapItem.fromDataItem(event.dataItem)
                    .dataMap.getString("token")
                handleSignIn(token)
            }
        }
    }
}
```

**Regles auth montre:**
- JAMAIS de username/password sur montre (Google Play quality WO-V4)
- Passkeys NE PEUVENT PAS etre creees sur Wear OS (seulement utilisees)
- Fournir le max de fonctionnalites SANS auth (guest mode)
- Fallback obligatoire: Credential Manager ne marche pas avec iOS-paired watches
- Implementer `AmbientLifecycleObserver` pendant les flows OAuth (empeche le timeout)
- Wrist detection: verifier si le verrouillage automatique est actif avant d'afficher des donnees sensibles

**Source:** [Android Developers - Auth Wear](https://developer.android.com/training/wearables/apps/auth-wear)

---

## T. Samsung One UI Watch Specificites

### 37. Differences One UI Watch vs Stock Wear OS

| Aspect | Stock Wear OS | Samsung One UI Watch |
|--------|--------------|---------------------|
| Design apps systeme | Material 3 | One UI style |
| Bezel | RSB/crown | Digital ou physique rotatif |
| Health SDK | Health Services | Samsung Health SDK (superset) |
| Store | Play Store | Play Store + Galaxy Store |
| Tiles | Standard | Tiles custom Samsung |
| Watch faces | WFF standard | + Samsung Watch Face Studio |
| Quick Panel | Google design | Samsung redesign |
| Notifications | Standard | Samsung grouping |

**Samsung Galaxy Watch bezel par generation:**

| Generation | Modele standard | Modele Classic |
|-----------|----------------|---------------|
| Watch 4 | Bezel tactile digital | Bezel physique rotatif |
| Watch 5 | Bezel tactile digital | N/A (pas de Classic) |
| Watch 6 | Bezel tactile digital | Bezel physique rotatif |
| Watch 7 | Bezel tactile digital | N/A |
| Watch 8 | Bezel tactile digital | Bezel physique rotatif (ameliore) |
| Watch Ultra | Bouton Quick Action | N/A |

**One UI 8 Watch (2025 - Galaxy Watch 8):**
- Premier smartwatch avec **Google Gemini** integre
- Tourne sur **Wear OS 6** out of the box
- Tiles redesignees: optimisees pour petits ecrans, info plus lisible d'un coup d'oeil
- **Nouvelles features sante:**
  - Bedtime Guidance (optimisation sommeil)
  - Vascular Load (stress vasculaire pendant sommeil)
  - Running Coach (strategies d'entrainement personnalisees)
  - Antioxidant Index (niveau carotenoides)
- Stockage: 32 GB (standard), **64 GB (Classic)**
- Autonomie: ~40h sans AOD, ~30h avec AOD

**Samsung BioActive sensor (Galaxy Watch 4+):**

| Capteur | Disponibilite | Acces tiers |
|---------|--------------|-------------|
| HR (PPG) | Tous modeles | Health Services API (libre) |
| ECG | GW4+ | Privileged SDK (demande Samsung) |
| BIA (body composition) | GW4+ | Privileged SDK (demande Samsung) |
| SpO2 | GW4+ | Health Services API (libre) |
| Temperature peau | GW5+ | Health Services API (Wear OS 4+) |
| Blood Pressure | GW4+ (marches limites) | Privileged SDK (tres restreint) |

**Sampling rates Samsung:**
- HR: 1Hz (continu), 0.1Hz (periodic), on-demand (single)
- Accelerometre: 25Hz, 50Hz, 100Hz, 200Hz (configurable)
- Gyroscope: 25Hz, 50Hz, 100Hz, 200Hz
- Pour notre app: accelerometre 25-50Hz suffit pour detection geste cigarette

**Samsung Health integration:**
- Samsung Health peut lire Health Connect
- Privileged SDK: acces restreint (formulaire demande Samsung Developer)
- Custom data dans Samsung Health: limite (pas de type "cigarette")
- Tile dans Samsung Health dashboard: pas possible pour apps tierces
- One UI Watch 6: integration plus profonde Health Connect, nouvelles APIs sante

---

## U. Standalone vs Companion

### 38. Architecture App

| Architecture | Avantages | Inconvenients |
|-------------|-----------|--------------|
| **Standalone** | Fonctionne sans telephone, promu dans store | Plus complexe, sync a gerer |
| **Companion** | Logique sur telephone, montre = affichage | Dependance telephone, pas promu |
| **Hybrid** (recommande) | Le meilleur des deux | Plus de code a maintenir |

**Architecture recommandee (notre app):**
```
MONTRE (standalone capable):
- Detection ML locale (TFLite)
- Compteur manuel
- SQLite local
- Foreground service monitoring
- Fonctionne SANS telephone

TELEPHONE (companion enrichi):
- Dashboard complet
- Historique graphs
- Parametres avances
- Sync cloud
- Data Layer sync avec montre

CLOUD (optionnel):
- Backup
- Dashboard web
- Multi-device
```

**Manifest pour hybrid standalone:**
```xml
<meta-data
    android:name="com.google.android.wearable.standalone"
    android:value="true" />

<uses-feature
    android:name="android.hardware.type.watch" />
```

### 38b. Detection Companion App & Mode Offline

**Capability system (wear.xml):**

```xml
<!-- Mobile app: res/values/wear.xml -->
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_infernal_phone_app</item>
    </string-array>
</resources>

<!-- Watch app: res/values/wear.xml -->
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_infernal_wear_app</item>
    </string-array>
</resources>
```

**Detection du telephone depuis la montre:**

```kotlin
// Type de telephone
val phoneType = PhoneTypeHelper.getPhoneDeviceType(context)
// DEVICE_TYPE_ANDROID, DEVICE_TYPE_IOS, DEVICE_TYPE_UNKNOWN, DEVICE_TYPE_ERROR

// App companion installee ?
val capabilityInfo = capabilityClient
    .getCapability("verify_remote_infernal_phone_app", CapabilityClient.FILTER_REACHABLE)
    .await()
val phoneAppInstalled = capabilityInfo.nodes.isNotEmpty()

// Si pas installee → ouvrir Play Store sur telephone
if (!phoneAppInstalled && phoneType == DEVICE_TYPE_ANDROID) {
    RemoteActivityHelper(context).startRemoteActivity(
        Intent(Intent.ACTION_VIEW)
            .setData(Uri.parse("market://details?id=com.infernal.smokingdetector"))
    )
}
```

**Offline-first regles:**
- L'app montre DOIT fonctionner sans telephone (standalone=true)
- Stocker toutes les donnees localement (Room/DataStore)
- Sync opportuniste quand telephone est reachable
- Bluetooth LE: max ~4 KB/s → minimiser les donnees envoyees
- Afficher clairement si connecte ou non (icone status)
- Jamais de crash si telephone absent

**Source:** [Android Developers - Standalone Apps](https://developer.android.com/training/wearables/apps/standalone-apps)

### 38c. Multi-Device Continuity (Watch ↔ Phone)

> **Section detaillee : voir AC. Multi-Device Continuity & Handoff Patterns (sections 50-54)**
> Contient: RemoteActivityHelper, ConfirmationActivity, Ongoing Activity API, CapabilityClient,
> MessageClient (100KB limit), Android 17 Handoff, watchOS NSUserActivity/WCSession (5 methodes),
> cross-device UX patterns (14 taches categoriees), error handling (5 types), reconnection delays,
> NNGroup 5 omnichannel components, decision tree, 14-point implementation checklist.

**Resume rapide — Patterns de continuation:**

| Scenario | Initie sur | Continue sur | Methode |
|----------|-----------|-------------|---------|
| Voir stats detaillees | Montre | Telephone | RemoteActivityHelper + deep link |
| Ajouter note longue | Montre | Telephone | RemoteActivityHelper + intent data |
| Configurer parametres | Telephone | Montre | DataItem sync |
| Partager progres | Montre | Telephone | RemoteActivityHelper → share sheet |
| Debug/logs | Montre | Telephone | MessageClient one-shot (100KB max) |

**Regles UX cross-device cles:**
- Confirmer toujours (ConfirmationActivity.OPEN_ON_PHONE_ANIMATION)
- Fallback gracieux si telephone absent
- Sauvegarder localement AVANT le handoff
- Deep link requis pour restaurer le contexte
- Timeout handoff: 5s max, spinner si >1s

---

## V. Patterns de Chargement

### 39. Loading sur Montre

| Duree | Feedback | Implementation |
|-------|----------|---------------|
| < 100ms | Aucun | Instantane |
| 100ms - 1s | Spinner subtil | CircularProgressIndicator indeterminate |
| 1-3s | Skeleton screen | Formes imitant le contenu final |
| > 3s | Progress bar | Avec % si possible + option Cancel |

**Specificites montre:**
- Skeleton shimmer: cycle 1.5-2s (identique mobile)
- Pas de splash screen long (cold start < 2s)
- Optimistic UI pour like/save/toggle
- Si echec: rollback + toast d'erreur
- JAMAIS de spinner plein ecran

### 40. Error States

| Type erreur | Affichage montre | Action |
|-------------|-----------------|--------|
| Pas de connexion | Icone offline + mode degrade | Auto-retry en background |
| Sensor indisponible | "Capteurs non disponibles" | Compteur manuel fallback |
| Permission refusee | "Autoriser les capteurs" | Lien Settings |
| ML inference fail | Silencieux | Retry prochain cycle |
| Sync fail | Badge de sync pending | Retry a reconnexion |
| Storage full | "Memoire pleine" | Purger vieilles donnees |

**Regle:** Sur montre, les erreurs doivent etre DISCRETES sauf si elles bloquent l'action principale.

---

## W. Audio sur Montre

### 41. Audio et Son

| Aspect | Valeur |
|--------|--------|
| Speaker | Present sur Galaxy Watch (toutes generations), Apple Watch |
| Qualite | Limitee (frequences, volume, distorsion) |
| Usage principal | Appels, alarmes, navigation vocale |
| Volume public | Garder bas, privilegier haptique |

**Arbre de decision feedback:**
```
FEEDBACK NECESSAIRE?
       |
  +----+----+
  |         |
Confirmation  Alarme/Timer
  |              |
HAPTIQUE      SON + HAPTIQUE
(pas de son)  (obligatoire meme
              en silencieux?)
```

**Modes et impact:**
- Mode silencieux: haptique seulement
- DND: rien (sauf alarmes)
- Theatre: rien du tout
- Bedtime: filtre

---

## X. Watch Faces

### 42. Custom Watch Faces

| Aspect | Regle |
|--------|-------|
| Format | Watch Face Format (WFF) v4 pour Wear OS 6 |
| Complications | Exposer 2-4 slots minimum |
| Ambient mode | Obligatoire, < 15% pixels allumes |
| Burn-in | Shift pixels si requis |
| Battery | Minimiser updates, pas d'animation en ambient |
| Interaction | Tap sur complication → ouvre l'app |

**WFF v4 nouveautes (Wear OS 6):**
- Photo watch faces: collections de photos utilisateur
- Transitions animees ambient ↔ interactif
- Watch Face Push API: distribution via marketplace tiers
- **Deadline migration:** Toutes les watch faces legacy doivent migrer vers WFF avant le **14 janvier 2026** (plus de publication AndroidX/WSL legacy sur Play Store)

**Watch Face pour notre app:**
- Complication RANGED_VALUE: progression objectif quotidien
- Complication SHORT_TEXT: compteur du jour ("5 cig")
- Complication ICON: status monitoring (on/off)
- Tap → ouvre l'ecran compteur

---

## Y. Anti-Patterns Universels

### 43. Ce qu'il ne faut JAMAIS faire sur montre

| Anti-pattern | Pourquoi | Alternative |
|-------------|----------|-------------|
| Port du telephone sur le poignet | L'utilisateur a 1-3 secondes d'attention | Glanceable, 1 info principale |
| Navigation profonde (>3 niveaux) | L'utilisateur se perd | Hub-and-spoke, max 2 niveaux |
| Texte long / paragraphes | Personne ne lit sur une montre | Chiffres, icones, mots-cles |
| Formulaires complexes | Saisie penible sur montre | Config sur telephone, sync |
| Clavier texte libre | Lent et frustrant | Voix, reponses predefinies, boutons |
| Spinner plein ecran | Bloquant | Skeleton ou indicateur inline |
| 6 boutons sur 1 ecran | Confusion, touch targets trop petits | 1-2 actions principales |
| Son comme feedback principal | Genere en public | Haptique + visuel |
| Ignorer ambient mode | Batterie drainee, burn-in | Implementer ambient obligatoirement |
| Sync temps reel continue | Batterie drainee | Batched sync, DataItems non-urgents |
| Meme UI que le telephone | L'ecran est 10x plus petit | Redesigner pour le poignet |
| Ignorer le bezel/crown | Input naturel gaspille | Supporter rotary input |
| Animations lourdes | -30% batterie possible | Animations simples, reduire fps en workout (30fps) |
| Username/password sur montre | Interdit (Google Play WO-P6) | CredentialManager / RemoteAuthClient |
| Marges fixes en dp | Ne scale pas | Marges en pourcentages |
| Icones sans labels | Inaccessible | Toujours icone + label texte |
| Scroll horizontal + vertical | Desorientant | Vertical uniquement |
| Wake lock continu | Battery killer | Health Services API (CPU dort entre lectures) |
| Ignorer font scaling | Texte coupe, Play Store rejet | Respecter le setting systeme |

### 43b. Benchmarks Industrie & Recherche UX

| Metrique | Valeur | Source |
|----------|--------|--------|
| Session moyenne montre | **8-12 secondes** | NNGroup / etudes smartwatch |
| Sessions/jour montre | **~80-100** micro-sessions | Etudes comportementales |
| Retention app sante J30 | **~7%** des utilisateurs | Industry research 2024 |
| Interactions utiles montre | **6 types** identifies | NNGroup |
| Max taps pendant workout | **3 taps** avant friction | UX research 2024 |
| Temps attention montre | **1-3 secondes** par glance | Google Wear OS principles |
| Apps Wear OS installees | **3-8** en moyenne | Google Play data |
| Perte battery par animations | Jusqu'a **-30%** | Appventurez research 2024 |
| Precision tap sur montre | ~85-90% pour 48dp | Etudes touch target wearable |
| Precision tap avec gants | ~50-60% pour 48dp | Community empirical |

**Facteurs cles retention apps addiction montre:**
- Quick-log 1 tap = engagement quotidien (#1 facteur)
- Streaks >= 7 jours = +3.6x retention
- Notifications non-culpabilisantes = -40% desinstallation vs culpabilisantes
- Detection auto = "wow factor" mais faux positifs > 20% = desinstallation rapide
- Gamification legere (pas excessive) = engagement sans fatigue

### 43c. Recherche UX NNGroup - 6 Types d'Interactions Montre

**Source:** NNGroup diary study, 11 participants, 200+ interactions documentees.

| Type | Description | Frequence |
|------|-------------|-----------|
| **1. Receiving** | Recevoir notifications (updates, rappels, feedback, suggestions) | Tres frequent |
| **2. Referencing** | Consulter info disponible (heure, meteo, compteur) | Frequent |
| **3. Recording** | Capturer des donnees (workout, eau, sommeil, cigarettes) | Frequent |
| **4. Controlling** | Controler d'autres appareils (musique, maison, alarme) | Plus positif |
| **5. Communicating** | Appels, messages, reponses rapides | Important |
| **6. Guiding** | Direction en temps reel (navigation, exercice guide, respiration) | Situel |

**Interactions PAS adaptees a la montre:**
- **Consuming** (video, articles) — ecran trop petit
- **Creating** (ecrire, dessiner) — input trop difficile
- **Browsing** (shopping, exploration) — pas de comportement oriente but
- **Searching** (requetes complexes) — input + affichage insuffisants

**Principes UX cles (NNGroup):**

| Principe | Explication |
|----------|-------------|
| **Glanceable** | Lisible en 2-3 secondes max |
| **Informative** | Assez de detail pour eviter de sortir le telephone |
| **Personalized** | Contenu generique/promo = agacement immediat |
| **Timely** | Delivre au bon moment = valeur percue x10 |
| **Accessible** | Hierarchie plate, pas de profondeur |
| **Easy initiation** | 2-3 gestes max pour demarrer un recording |
| **Contextually prompted** | Detection auto d'activite = delight |
| **Accurate (perceived)** | Inexactitude = perte de confiance immediate |

**Statistiques comportementales:**
- 1 Americain sur 5 possede une smartwatch (Pew Research 2020)
- **80%+ des interactions** = apps natives (messages, activite, timers)
- Adoption apps tierces sur montre = minimale
- Users voient la montre comme un **filtre de contenu** — tolerent MOINS l'irrelevant que sur telephone
- Checker la montre est **socialement plus acceptable** que sortir le telephone
- "Device inertia": les gens completent des taches sur l'appareil le moins optimal pour eviter de changer

**Pour notre app (smoking tracker):**
- Type "Recording" = notre cas principal (quick input +1 cigarette)
- Type "Referencing" = compteur du jour visible en complication
- Type "Receiving" = rappels/encouragements (NON culpabilisants)
- Type "Controlling" = demarrer/arreter le monitoring
- Easy initiation CRITIQUE: tile/complication → 1 tap

**Source:** [NNGroup - Smartwatch Interactions](https://www.nngroup.com/articles/smartwatch-interactions/)

### 43d. Quand Construire une App Montre (NNGroup)

**Construire SI:**
- Fournit de la valeur impossible/inconvenante sur telephone
- Supporte des micro-interactions deja tentees sur mobile
- Exploite des donnees uniques (capteurs, biometrie, mouvement)
- Acces rapide dans des situations ou le telephone est indisponible

**NE PAS construire SI:**
- Replique simplement une fonctionnalite telephone basique
- Relation temporaire avec l'utilisateur (app hotel, service ponctuel)
- Interactions complexes (lecture longue, ecriture, video)
- L'utilisateur a probablement son telephone a portee de main

**Design reco:**
- Prioriser les notifications efficaces AVANT de faire une app standalone
- Eviter les resumes multi-ecrans (>3 ecrans de scroll = personne ne lit)
- Decouverte/recherche UX AVANT le dev pour valider la valeur

**Source:** [NNGroup - Should You Build a Smartwatch App?](https://www.nngroup.com/articles/smartwatch-app/)

### 43e. Power Conservation Hierarchy

**Impact batterie par source (ordre decroissant):**

| Source | Impact | Mitigation |
|--------|--------|-----------|
| Network (LTE/Wi-Fi) | Tres eleve | Differer jusqu'au chargement |
| Ecran on / mode interactif | Eleve | Utiliser ambient mode |
| GPS | Eleve | Seulement sur demande utilisateur |
| CPU intensif | Eleve | Batching, idle max |
| Heart rate sensor | Moyen | Health Services (batched) |
| Bluetooth | Moyen | Sessions courtes |
| Wakelocks | Moyen | WorkManager a la place |

**Regles batterie:**
- Ne JAMAIS copier l'app mobile telle quelle → deleguer le travail lourd au telephone
- Differer downloads jusqu'a **charging + Wi-Fi** (WorkManager avec constraints)
- Prefetch quand en charge ce que l'utilisateur voudra probablement
- Interactions courtes (secondes, pas minutes)
- Animations: eviter boucles longues, pause entre boucles >= duree animation
- Data Layer: envoyer des changements d'etat, PAS des updates continues

**WorkManager sur montre:**

```kotlin
WorkManager.getInstance(context).enqueueUniquePeriodicWork(
    "data_sync", ExistingPeriodicWorkPolicy.KEEP,
    PeriodicWorkRequestBuilder<SyncWorker>(2, TimeUnit.HOURS)
        .setConstraints(Constraints.Builder()
            .setRequiresCharging(true)
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()
        ).build()
)
```

**Monitoring capteurs:**

```bash
adb shell dumpsys sensorservice          # registrations capteurs
adb shell dumpsys batterystats           # stats batterie
adb shell dumpsys activity service WearableService  # Data Layer usage
```

**Verification:**
- ExerciseClient: app ne se reveille PAS plus d'1x toutes les 1-2 min
- Tiles/complications: disable auto-refresh OU >= 2h d'intervalle
- Partager une seule database entre app, tiles, et complications
- Apres swipe-dismiss ou ecran off: verifier que les capteurs se desenregistrent

**Source:** [Android Developers - Power](https://developer.android.com/training/wearables/apps/power)

### 43f. Touch Lock & Fitness UX

**Touch lock:** Desactiver le tactile pendant une activite (workout, tracking actif).
- Empeche les touches accidentelles pendant le mouvement
- Utilisateur doit appuyer un bouton physique pour debloquer
- Recommande pour toute app de tracking continu

**Haptics pour confirmer les actions fitness:**
- Start monitoring → vibration confirmation
- Stop monitoring → vibration distincte
- Auto-detection cigarette → vibration + notification
- Milestone (objectif quotidien atteint) → vibration de celebration

**Complement phone vs duplicate:**
- Montre = collecte de donnees + resume minimal
- Analyse detaillee post-session → app telephone
- Ne faire que les taches critiques au poignet

**Source:** [Android Developers - Principles](https://developer.android.com/training/wearables/principles)

### 43g. Fitts's Law sur Ecran Rond

**Etude Ashbrook 2008** (round touchscreen wristwatch):
- Fitts' law model fit: **R^2 = 0.959** (N=90 points) → tres forte validite predictive
- 3 types de mouvement testes: tap, through, rim

**Implications design:**
- **Pie/radial menus** sont inherement superieurs sur ecrans ronds (distances egales du centre, targets plus grandes)
- **Edge targets** toujours plus rapides que targets 1px du bord (bezel = boundary physique)
- Placer les actions principales au centre ou sur les bords, PAS dans les coins (inaccessibles sur rond)
- Round screen = **22% moins d'espace UI** qu'ecran carre → chaque pixel compte

**Source:** [Ashbrook - Round Touchscreen Wristwatch Interaction](https://www.researchgate.net/publication/221270967)

### 43h. Habit Formation & BCTs (Behavior Change Techniques)

**BCTs les plus efficaces pour wearables (meta-analyse PMC, 20 systemes):**

| BCT | Prevalence | Efficacite |
|-----|-----------|-----------|
| **Feedback sur comportement** | 17/20 systemes | Bonne evidence |
| **Self-monitoring** | 16/20 systemes | Bonne evidence |
| **Goal setting** | 13/13 monitors | Mixte (6 positif, 6 null) |
| **Prompts/cues** | >50% | Bonne evidence |
| **Social support/comparaison** | >50% | Mixte |
| **Rewards (badges virtuels)** | >50% | Mixte |

**Regle critique:** Interventions avec **5+ BCTs** sont plus efficaces que celles avec moins (benefice cumulatif).

**Pour notre app smoking cessation:**
- **Self-monitoring** = compteur cigarettes (OBLIGATOIRE, c'est notre coeur)
- **Feedback** = stats quotidiennes, tendances, argent economise
- **Goal setting** = objectif quotidien de reduction
- **Prompts/cues** = rappels aux heures habituelles (RelevantContext watchOS)
- **Rewards** = badges pour streaks, milestones
- **JITAIs (Just-In-Time Adaptive Interventions)** = detecter les moments de craving via capteurs

**Donnees smoking cessation specifiques:**
- Interventions personnalisees = **significativement meilleures** que soins standard
- Adherence = facteur d'echec principal → UX simple = critique
- Combine app + pharmacotherapie > app seule
- Middle-aged adults beneficient le plus de programmes court/moyen terme

**Source:** [PMC - BCTs in Wearables](https://pmc.ncbi.nlm.nih.gov/articles/PMC11054424/), [PMC - Smoking Cessation Apps](https://pmc.ncbi.nlm.nih.gov/articles/PMC10160935/)

### 43i. Notification Triage (Watch vs Phone)

**Formule NNGroup pour notifications montre efficaces:**
1. **Personnellement pertinentes** (pas generiques/promo)
2. **Timing appropriate** (bon moment)
3. **Non-repetitives** (pas de spam)
4. **Suffisamment informatives** (comprendre sans sortir le telephone)

**Pourquoi la montre pour les notifications:**
- Notifications arrivent **silencieusement** (haptique)
- Plus **socialement acceptable** que sortir le telephone
- Montre = **sur le corps** → users auraient **rate l'info** avec telephone seul
- La montre est un **filtre** — les users presument que les notifs seront pertinentes

**Notification fatigue = plainte #1 en usability testing**
- Haute frequence → messages ignores instantanement
- 12 motivations uniques d'interaction avec notifications (3 timings: avant/pendant/apres tache)
- Users voient les notifs comme outils pour **ameliorer la performance** de leur tache, pas juste des distractions

**Pour notre app:**
- Detection cigarette → notification haptique discrete, pas intrusive
- Resume quotidien → 1x/jour le soir, pas plus
- Encouragement → seulement quand milestone atteint (positif, jamais culpabilisant)
- Craving alert (futur) → JITAI notification quand capteurs detectent un pattern

**Source:** [NNGroup - Smartwatch Notification Formula](https://www.nngroup.com/videos/smartwatch-notification-formula/)

### 43j. Cognitive Load sur Petit Ecran

**Principes:**
- Ecran montre = **moins de la moitie** d'un smartphone
- Distiller le contenu au **strict minimum** necessaire
- Interfaces encombrees → confusion, frustration, charge cognitive accrue
- **Grid view** (moins d'items visibles) = satisfaction plus elevee
- **Liste longue** = meilleur temps de completion (speed vs satisfaction trade-off)
- Categorisation hierarchique = resultats satisfaisants en temps, efficacite, satisfaction

**Regles pratiques:**
- Eliminer le visual clutter: moins d'icones, boutons, texte
- Si boutons necessaires: **peu et gros**
- Information comprehensible **d'un coup d'oeil**
- 1 seul objectif clair par ecran
- Tester les designs en **mouvement et distraction** (marche, exercice)

**40% des sessions telephone** durent < 15 secondes → sessions montre sont egalement breves

**Source:** [NNGroup - Glanceable Typography](https://www.nngroup.com/articles/glanceable-fonts/), [Usability Geek](https://usabilitygeek.com/7-user-interface-guidelines-for-designing-watch-apps/)

### 43k. Marche Global & Statistiques (2026)

| Metrique | Valeur |
|----------|--------|
| Utilisateurs smartwatch monde | 562.86 millions (+23.7% vs 2024) |
| Americains avec wearable | ~1 sur 3 |
| Users tracking sante/fitness | 83% |
| Activite la plus trackee | Pas quotidiens (59%) |
| ~90% population | Montre au poignet gauche (non-dominant) |

**Source:** [DemandSage](https://www.demandsage.com/smartwatch-statistics/), [Market.us](https://scoop.market.us/smart-wearables-statistics/)

---

## Z. Valeurs Cles (Memo Rapide)

### Fondamentaux

| Quoi | Valeur |
|------|--------|
| Touch target Wear OS | 48x48 dp (min 40dp) |
| Touch target watchOS | 44x44 pt |
| Spacing base | 4dp |
| Contraste texte | >= 4.5:1 |
| Contraste UI | >= 3:1 |
| Ecran min Wear OS | 192 dp |
| Breakpoint | 225 dp |
| Profondeur nav max | 2-3 niveaux |

### Timings

| Quoi | Valeur |
|------|--------|
| Instant (no feedback) | < 100ms |
| Spinner | 100ms - 1s |
| Skeleton | 1s - 3s |
| Progress bar | > 3s |
| Cold start target | < 2s |
| Inference ML target | < 100ms |
| Sensor batch delay | > 30s |
| DataItem non-urgent delay | Jusqu'a 30min |
| Ambient update | 1x/minute max |
| Glance time user | 1-3 secondes |

### Batterie

| Quoi | Valeur |
|------|--------|
| Batterie typique | 250-590 mAh |
| Ambient pixels max | 15% de la surface |
| TFLite model max | < 5 MB (ideal < 1 MB) |
| Foreground service | Obligatoire pour monitoring continu |
| Background jobs | Bloques sauf sur chargeur (Wear OS 5+) |

### Notifications

| Quoi | Valeur |
|------|--------|
| Style | BigTextStyle (expandable) |
| Actions max | 2-3 |
| SHORT_TEXT max chars | 7 |
| Ongoing | Obligatoire pour foreground service |

### Migration M3

| Quoi | Valeur |
|------|--------|
| Lib M3 | `compose-material3:1.6.0-beta01` |
| Couleurs M2.5 → M3 | 13 → 28 parametres |
| Chip → | Button / OutlinedButton / ChildButton |
| PositionIndicator → | ScrollIndicator |
| Scaffold → | AppScaffold + ScreenScaffold |
| ScalingLazyColumn → | TransformingLazyColumn |
| Vignette | SUPPRIME en M3 |
| Nouveau: EdgeButton | Bouton epousant le bord bas (4 tailles) |
| Dynamic Color | Auto depuis watch face (Wear OS 6) |
| WFF deadline | 14 janvier 2026 (plus de legacy) |

### Composants

| Quoi | Valeur |
|------|--------|
| Chip hauteur | 52dp |
| CompactChip hauteur | 32dp |
| Card min hauteur | 52dp |
| Card corner radius | 24dp |
| Bouton Large | 60dp (icone 30dp) |
| Bouton Default | 52dp (icone 26dp) |
| Bouton Small | 48dp (icone 24dp) |
| Bouton XS | 32dp (icone 20dp, touch 48dp) |
| ScalingLazyColumn spacing | 4dp |
| ScalingLazyColumn padding | ~28dp top/bottom |
| PositionIndicator epaisseur | ~4dp |
| PositionIndicator fade | ~1.5s apres scroll |
| Vignette depth | ~40dp |
| TimeText font | ~12sp |
| Confirmation auto-dismiss | 4000ms |
| Swipe dismiss edge | 20% ecran |
| Swipe dismiss completion | >50% largeur |
| Horologist padding | 26.5% horizontal |

### Design

| Quoi | Valeur |
|------|--------|
| Fond OLED | #000000 (toujours) |
| Surface 1dp | #1E1E1E |
| Surface 4dp | #272727 |
| Icone launcher | 48x48 dp circulaire |
| Font scaling max | Pas au-dessus de 20sp |
| Max items visible | 5-7 (Wear OS), 3-5 (watchOS) |
| Max items avant fatigue | ~15-20 |
| Max pages/tabs | 5-7 |

### Complications & Tiles

| Quoi | Valeur |
|------|--------|
| Tile update min | ~15 minutes |
| Complication update min | 300s (5min) Wear OS |
| Complication push budget | ~4/heure (watchOS) |
| SHORT_TEXT max | 7 caracteres |
| Max slots par watch face | ~8 |
| Tiles scrollable | NON |

### Timings Gestures

| Quoi | Valeur |
|------|--------|
| Raise-to-wake Wear OS | ~300-400ms |
| Raise-to-wake watchOS | ~200-300ms |
| Lower-to-sleep | ~3-5s |
| Long press | ~500ms |
| Double tap watchOS | 2 taps en ~500ms |
| Voice latency on-device | ~200-500ms |
| Voice latency cloud | ~1-3s |

### Lifecycle

| Quoi | Valeur |
|------|--------|
| Cold start target | < 2s (baseline profiles = -20-40%) |
| Warm start | < 500ms |
| Hot start | < 200ms |
| RecentApps timeout | ~3-5 min |
| Resume same screen | < 5 min d'absence |
| Kill par systeme | ~5-15 min background |
| Ambient transition | ~300ms |

### Spacing (Design Tokens)

| Quoi | Valeur |
|------|--------|
| Base | 4dp (montre) vs 8dp (mobile) |
| Card padding | 12dp |
| Content padding | 8-12dp |
| Section gap | 12-16dp |
| Top/bottom padding | 24dp |
| Negative space min | 30-40% ecran |

### Glanceability

| Quoi | Valeur |
|------|--------|
| Temps comprehension | < 3 secondes |
| Session moyenne montre | 8-12 secondes |
| Sessions/jour | ~80-100 micro-sessions |
| Max boutons/ecran | 3 (ideal 1-2) |
| Max decisions/ecran | 1 |
| Max couleurs dans l'app | 4-5 |

### Motion & Animation

| Quoi | Valeur |
|------|--------|
| Duree recommandee montre | short1-4 (50-200ms), medium1-2 (250-300ms) |
| Max animation montre | 400ms sauf transition majeure |
| **Regle duree montre** | **30% plus court que mobile** |
| **Target FPS montre** | **30 FPS** (suffisant, economise batterie) |
| Standard easing | cubic-bezier(0.2, 0, 0, 1) |
| Emphasized decelerate | cubic-bezier(0.05, 0.7, 0.1, 1) |
| Legacy (M2 compat) | cubic-bezier(0.4, 0, 0.2, 1) |
| Shape morphing | Auto via MotionScheme (M3 Expressive) |
| Pause entre boucles | >= duree animation |
| `defaultSpatialSpec` | Peut overshoot (position, taille, forme) |
| `defaultEffectsSpec` | Strict (couleur, alpha, opacite) |
| Tile animations max | 4 elements simultanes |
| Shared element Wear | `sharedElement()` / `sharedBounds()` |
| Shared element watchOS | `matchedGeometryEffect` |
| Spring Wear OS | `spring(dampingRatio, stiffness)` |
| Spring watchOS | `.smooth` / `.snappy` / `.bouncy` |

### Standalone & Offline

| Quoi | Valeur |
|------|--------|
| Standalone manifest | `com.google.android.wearable.standalone` = true |
| Bluetooth LE bandwidth | ~4 KB/s max |
| CapabilityClient | Detection app companion |
| PhoneTypeHelper | ANDROID / IOS / UNKNOWN |
| RemoteActivityHelper | Ouvrir Play Store sur telephone |
| Offline-first | OBLIGATOIRE (jamais crash si pas de phone) |

### Google Play Quality (memo)

| Quoi | Valeur |
|------|--------|
| Font min essentiel | 12sp |
| Font min non-essentiel | 10sp |
| Target API min | Android 14 (API 34) |
| Auth sur montre | JAMAIS username/password |
| AOD max pixels | 15% |
| WFF assets ambient | 10 MB max |
| WFF assets interactif | 100 MB max |
| Splash icon | 48x48 dp sur noir |
| Background | #000000 obligatoire |
| Screenshots Play | 1:1 aspect ratio |
| Test emulateur | 192dp + 227dp round |
| WFF deadline legacy | 14 janvier 2026 |

### Retention & Engagement

| Quoi | Valeur |
|------|--------|
| Retention J30 health app | ~7% |
| Session moyenne montre | 8-12 secondes |
| Sessions/jour | ~80-100 |
| Streak seuil retention | 7 jours (+3.6x) |
| Max taps workout | 3 avant friction |
| Faux positifs ML seuil | < 20% pour retention |

### Navigation Compose

| Quoi | Valeur |
|------|--------|
| NavHost Wear | `SwipeDismissableNavHost` (PAS NavHost) |
| NavController Wear | `rememberSwipeDismissableNavController()` |
| Container top | `AppScaffold` (OBLIGATOIRE) |
| Container ecran | `ScreenScaffold` |
| Navigation lib | `wear-compose:compose-navigation:1.5.6+` |
| Pager max dots | 6 (HorizontalPageIndicator) |
| Pager scaffold | `HorizontalPagerScaffold` / `VerticalPagerScaffold` |
| Deep links | `navDeepLink<Route>(basePath = ...)` dans `composable()` |
| State UI | `rememberSaveable` (survit process death) |
| State ViewModel | `SavedStateHandle.saveable {}` ou `.getStateFlow()` |
| Process death | Plus frequent sur montre (memoire limitee) |
| Disconnect top | Fonctionnalite partielle indisponible |
| Disconnect bottom | Plus de contenu chargeable |

### Ongoing Activity & Splash

| Quoi | Valeur |
|------|--------|
| Ongoing Activity lib | `wear-ongoing:1.1.0` |
| Ongoing icon type | Noir/blanc, fond transparent |
| Ongoing categories | CALL > NAVIGATION > TRANSPORT > ALARM > WORKOUT |
| Splash lib | `core-splashscreen:1.2.0+` |
| Splash icon round | 48dp |
| Splash icon non-round | 36dp (avec background) |
| `installSplashScreen()` | AVANT `super.onCreate()` |

### Ambient Mode

| Quoi | Valeur |
|------|--------|
| Ecran noir min ambient | 85% |
| Update ambient | 1x/minute max |
| Burn-in protection | Shifter contenu si `burnInProtectionRequired` |
| Low-bit ambient | Desactiver anti-aliasing si flag |
| TimeText ambient | Auto-aware, pas besoin de code |
| Horologist ambient | `AmbientAware` composable |

### Permissions

| Quoi | Valeur |
|------|--------|
| BODY_SENSORS | API ≤ 35 |
| READ_HEART_RATE | API 36+ (remplace BODY_SENSORS) |
| ACTIVITY_RECOGNITION | API 29+ |
| Max denials avant "don't show" | 2 |
| Watch faces | JAMAIS demander de permissions directement |

### NNGroup UX Research

| Quoi | Valeur |
|------|--------|
| 6 types interactions | Receiving, Referencing, Recording, Controlling, Communicating, Guiding |
| Glance time | 2-3 secondes |
| 80%+ interactions | Apps natives (pas tierces) |
| Tolerance irrelevant | Plus basse que telephone |
| Device inertia | Watch > Phone > Desktop (les gens evitent de changer) |
| Easy initiation | 2-3 gestes max |

### M3 Expressive

| Quoi | Valeur |
|------|--------|
| Shape morphing | Boutons changent de forme au press/check |
| ButtonGroup | Ligne de boutons shape-morphing |
| Variable fonts | Roboto Flex (weight, width, weight+width) |
| MotionScheme | Springs expressives dans le theme |
| Arc Text | Nouveau type role pour titres en arc |
| Numerals | Nouveau type role pour grands chiffres |
| Edge-hugging | Conteneurs epousant la forme ronde |

### Quality Tiers

| Quoi | Valeur |
|------|--------|
| Tier 1: Ready | Marges %, pas de clipping |
| Tier 2: Responsive | Plus de contenu sur grands ecrans |
| Tier 3: Adaptive | Breakpoints, features differenciees |
| Regle absolue | Grand ecran JAMAIS moins d'info que petit |

### UX Research

| Quoi | Valeur |
|------|--------|
| Fitts' Law round watch R^2 | 0.959 (Ashbrook 2008) |
| Round vs square espace | 22% moins sur rond |
| Pie/radial menus sur rond | Superieurs aux menus lineaires |
| BCTs minimum efficacite | 5+ techniques |
| Notification fatigue | Plainte #1 en usability testing |
| Phone microsessions <15s | 40% de toutes les sessions |
| Smartwatch users monde | 562.86M (2026) |
| Users tracking sante | 83% |
| Poignet gauche | ~90% (non-dominant) |

### Text Input

| Quoi | Valeur |
|------|--------|
| Input method prioritaire | Pre-defined choices > Voice > Handwriting > Keyboard |
| Max texte libre sur montre | 1-2 mots, au-dela → telephone |
| RemoteInput (Wear OS) | Supporte voix + clavier + choix pre-definis |
| TextFieldLink (watchOS 9+) | Ecran de saisie dedie |
| Dictation latence (on-device) | 200-500ms |
| Dictation latence (cloud) | 1-3s |

### Multi-Device (details: section AC, 50-54)

| Quoi | Valeur |
|------|--------|
| RemoteActivityHelper | Ouvrir app telephone depuis montre |
| ConfirmationActivity | 3 types: SUCCESS, FAILURE, OPEN_ON_PHONE |
| Handoff latence | 1-3s acceptable, timeout 5s max |
| Android 17 Handoff API | setHandoffEnabled() + onHandoffActivityRequested() |
| watchOS Handoff | NSUserActivity + isEligibleForHandoff |
| Deep link requis | Obligatoire pour restaurer contexte apres handoff |
| CapabilityClient | wear.xml + FILTER_REACHABLE / FILTER_ALL |
| MessageClient max | 100 KB, pas de persistance, pas de retry |
| WCSession sendMessage | Immediat si isReachable, sinon fallback transferUserInfo |
| WCSession transferUserInfo | Queue FIFO, livraison garantie |
| WCSession updateApplicationContext | Dernier gagne (ecrase) |
| Reconnexion apres Doze | Jusqu'a 4 minutes |
| Ongoing Activity lib | `wear-ongoing:1.1.0` |
| Ongoing update frequence | Quelques MAJ/minute max |
| Notification dismissal sync | `setDismissalId()` |
| Regle NNGroup handoff | > 10s ou > 3 taps -> envisager phone |
| PhoneTypeHelper | ANDROID / IOS / UNKNOWN / ERROR |
| Horologist | google.github.io/horologist (helpers recommandes) |

### Testing & BOM

| Quoi | Valeur |
|------|--------|
| compileSdk | 35 (Android 15) |
| targetSdk | 34 (Android 14, requis Play Store) |
| minSdk | 30 (Wear OS 3, requis Compose) |
| Emulateurs | Small (192dp), Large (225dp), XL (280dp) |
| Screenshot test | Roborazzi (./gradlew recordRoborazziDebug) |
| Benchmark | Macrobenchmark avec StartupTimingMetric |
| Horologist | 0.6.x (supplements Google) |
| Compose BOM | 2025.03.00 |

### Battery Saver

| Quoi | Valeur |
|------|--------|
| Detection | PowerManager.isPowerSaveMode |
| Broadcast | ACTION_POWER_SAVE_MODE_CHANGED |
| Impact network | Sync background bloquee |
| Impact GPS | Desactive sauf foreground |
| Impact AOD | Peut etre desactive auto |
| watchOS Low Power | ProcessInfo.isLowPowerModeEnabled |
| Regle app | Garder compteur, desactiver ML/animations |

---

## AA. Outils de Prototypage & Design

### 44. Figma pour Wearables

#### a) Kits de Design Officiels Google (Wear OS)

Google fournit deux kits Figma officiels pour Wear OS, tous deux supportant **Material 3 Expressive** :

| Kit | Contenu | Lien Figma Community |
|-----|---------|---------------------|
| **M3 Wear OS Apps Design Kit** | Composants, styles, variables, layouts pour apps | [figma.com/community/file/1506418396052412186](https://www.figma.com/community/file/1506418396052412186) |
| **M3 Wear OS Tiles Design Kit** | Composants, styles, variables, layouts pour tiles | [figma.com/community/file/1507852095734722321](https://www.figma.com/community/file/1507852095734722321) |

**Composants inclus dans le kit Apps :**
- Buttons (Button, OutlinedButton, ChildButton, EdgeButton, ButtonGroup)
- Cards, Lists (TransformingLazyColumn items)
- Dialogs, Confirmations, Pickers
- Navigation (SwipeDismiss, HorizontalPager, PageIndicator)
- ScrollIndicator, TimeText, ProgressIndicator
- Couleurs dynamiques M3 (28 parametres)
- Typographie M3 (ArcLine, Numerals)

**Page officielle :** [developer.android.com/design/ui/wear/guides/get-started/design-kits](https://developer.android.com/design/ui/wear/guides/get-started/design-kits)

#### b) Templates Apple Watch (Figma)

| Ressource | Description | Lien |
|-----------|-------------|------|
| **watchOS 26 (officiel Apple)** | Kit UI complet, bezels, templates, guides typographiques | [figma.com/community/file/1540060090060216489](https://www.figma.com/community/file/1540060090060216489) |
| **watchOS 11** | Version precedente, encore utile pour retrocompat | [figma.com/community/file/1483534709614446054](https://www.figma.com/community/file/1483534709614446054) |
| **Apple Design Resources** | Source officielle (Figma + Sketch) | [developer.apple.com/design/resources](https://developer.apple.com/design/resources/) |

**Tip :** Le kit watchOS officiel Apple inclut les bezels de toutes tailles (41mm, 45mm, 42mm, 46mm, 49mm Ultra), les complications, et les templates de notifications.

#### c) Contraintes Ecran Rond dans Figma

Figma ne supporte pas nativement les frames circulaires. Workarounds :

| Technique | Comment |
|-----------|---------|
| **Frame carre + Clip Content** | Creer un frame carre (ex: 450x450), activer "Clip content", ajouter un masque circulaire par-dessus |
| **Corner Radius max** | Frame 450x450 avec corner radius = 225 (= 50%) simule un ecran rond |
| **Plugin "Device Frames"** | Ajoute des frames avec masque rond integre |
| **Overlay bezel** | Placer l'image du bezel par-dessus le frame avec blend mode darken |
| **Composant masque reutilisable** | Creer un composant "Watch Frame" avec masque circulaire, reutilisable dans tous les ecrans |

**Regle critique :** Toujours designer dans un frame carre avec masque rond. Ne PAS designer dans un frame rectangulaire puis "imaginer" le clipping — les coins caches contiennent souvent du contenu essentiel.

**Safe area ecran rond :**
- Contenu textuel : rester dans le cercle inscrit (70.7% de la surface)
- Marges horizontales : 5.2% minimum (Horologist = 26.5% padding horizontal pour texte)
- Elements interactifs : jamais dans les 10% exterieurs du rayon

#### d) Composants Material 3 pour Wear OS dans Figma

Le kit M3 Wear OS Apps utilise les **Variables Figma** pour :
- Color tokens (28 roles : primary, onPrimary, secondary, tertiary, surface, etc.)
- Typography tokens (Display, Title, Label, Body + ArcLine, Numerals)
- Shape tokens (Full, Large, Medium, Small + morphing states)
- Spacing tokens (base 4dp)

**Workflow recommande :** Dupliquer le kit Community > activer les variables locales > overrider les couleurs pour votre brand > designer vos ecrans.

### 45. Outils Android Studio

#### a) Wear OS Preview (@Preview)

Compose pour Wear OS fournit des annotations de preview specifiques dans `androidx.wear.compose.ui.tooling.preview` :

| Annotation | Effet |
|------------|-------|
| `@WearPreviewDevices` | Genere des previews pour toutes les tailles d'ecran Wear OS |
| `@WearPreviewFontScales` | Genere des previews pour differentes tailles de police |
| `@WearPreviewSmallRound` | Preview sur petit ecran rond (192dp) |
| `@WearPreviewLargeRound` | Preview sur grand ecran rond (227dp) |
| `@WearPreviewSquare` | Preview sur ecran carre |
| `@Preview(device = WearDevices.SMALL_ROUND)` | Preview specifique petit rond |
| `@Preview(device = WearDevices.LARGE_ROUND)` | Preview specifique grand rond |

```kotlin
// Exemple: preview multi-device
@WearPreviewDevices
@WearPreviewFontScales
@Composable
fun MyScreenPreview() {
    MyWearTheme {
        MyScreen()
    }
}
```

**Dependance requise :**
```kotlin
implementation("androidx.wear.compose:compose-ui-tooling-preview:1.5.0+")
debugImplementation("androidx.compose.ui:ui-tooling")
```

#### b) Emulateurs Wear OS (configurations disponibles)

| Profil Emulateur | Taille | Forme | API | Notes |
|-----------------|--------|-------|-----|-------|
| **Wear OS Small Round** | 192dp | Rond | 33-36 | Taille minimum a tester |
| **Wear OS Large Round** | 227dp | Rond | 33-36 | Taille standard Galaxy Watch / Pixel Watch |
| **Wear OS Square** | 180dp | Carre | 30-33 | Legacy (Wear OS 2.x) |
| **Wear OS 6 (API 36)** | Variable | Rond | 36 | Android 16 "Baklava", M3 Expressive |

**Configuration :**
1. SDK Manager > installer system image Wear OS (x86_64 ou arm64-v8a, 64-bit uniquement API 33+)
2. Device Manager > Create Device > categorie "Wear OS"
3. Selectionner profil materiel + system image

**Fonctionnalites speciales de l'emulateur Wear :**
- Panneau **Health Services** (icone coeur) : simuler rythme cardiaque, pas, calories, exercice
- **Capteurs** : accelerometre, gyroscope, temperature ambiante, champ magnetique, proximite, lumiere, pression, humidite
- **Boutons physiques** : Button 1, Button 2 via barre d'outils
- **Palming** : icone paume pour simuler le geste de couverture de l'ecran
- **Rotary input** : accessible via menu overflow (**...**) de la barre d'outils
- **Pairing** avec emulateur telephone via Device Manager

**Limitations connues (API 36) :**
- `DashedArcLine` : rendu incorrect sur emulateur
- `CircularProgressIndicator` : rendu incorrect sur emulateur
- Performance batterie non representative — toujours valider sur device reel

#### c) Layout Inspector sur Montre

Le Layout Inspector fonctionne sur les appareils Wear OS (physiques et emulateurs) :

| Etape | Action |
|-------|--------|
| 1 | Lancer l'app sur le device/emulateur |
| 2 | Android Studio > Running Devices > Toggle Layout Inspector |
| 3 | Inspecter la hierarchie de vues, proprietes, contraintes |
| 4 | Utiliser la vue 3D pour identifier les couches superposees |

**Cas d'usage montre :**
- Verifier que le contenu ne depasse pas le masque rond
- Valider les marges sur ecrans de differentes tailles
- Inspecter les paddings du `ScreenScaffold` et `AppScaffold`
- Debugger les problemes de `TransformingLazyColumn` (scaling, alpha)

#### d) Direct Surface Launch (Tiles & Complications)

Pour debugger les Tiles et Complications sans naviguer dans le systeme :

| Surface | Methode |
|---------|---------|
| **Tile** | Clic droit sur `TileService` > Run (ou icone gutter) > se lance directement |
| **Complication** | Run configuration > selectionner ComplicationDataSourceService |
| **Watch Face** | Run configuration > lance directement sur le cadran |

```
// Run configuration pour Tile
Type: Wear OS Tile
Module: app
Tile: com.example.MyTileService
```

**Avantage :** Evite de swiper vers la tile dans le carrousel — gain de temps enorme en iterations de design.

### 46. Autres Outils

#### a) Samsung Galaxy Watch - Ressources Design

| Ressource | Usage | Lien |
|-----------|-------|------|
| **Watch Face Studio** | Design de cadrans sans code (drag & drop) | [developer.samsung.com/watch-face-studio](https://developer.samsung.com/watch-face-studio/user-guide/create.html) |
| **One UI Watch Design Guidelines** | Principes UX circulaire, bezel rotatif, touch bezel | [developer.samsung.com/galaxy-watch-design](https://developer.samsung.com/galaxy-watch-design/principle.html) |
| **Design Resources (Tizen legacy)** | Templates, composants, icones | [developer.samsung.com/one-ui-watch-tizen/resource](https://developer.samsung.com/one-ui-watch-tizen/resource.html) |

**Watch Face Studio** supporte :
- Preview sur differentes tailles d'ecran Samsung
- Animation conditionnelle (heure, pas, batterie, meteo)
- Barres de progression circulaires et lineaires
- Export direct au format WFF (Watch Face Format)
- Test sur device connecte en temps reel

#### b) Outils de Prototypage Ecran Rond

| Outil | Support rond | Points forts | Limites |
|-------|-------------|--------------|---------|
| **ProtoPie** | Natif (masque rond + player Wear OS) | Prototype hi-fi sans code, test sur vrai device Wear OS, interactions connectees multi-device | Payant ($13+/mois) |
| **Figma Prototyping** | Via masque (workaround) | Integre au workflow design, transitions basiques | Pas de test sur device reel, interactions limitees |
| **Principle** | Via masque | Animations avancees, timeline | Mac only, pas de partage device |
| **Framer** | Via masque | Code-based, React components | Pas de player montre |
| **Android Studio Preview** | Natif | Compose interactif, Live Edit | Pas d'animation de transition |

**Recommandation :** ProtoPie est le seul outil avec un **Player Wear OS natif** permettant de tester les prototypes directement sur une montre physique.

**ProtoPie Player for Wear OS :**
- Installer ProtoPie Player depuis le Play Store sur la montre
- Envoyer le prototype via ProtoPie Connect
- Tester les interactions tactiles, rotary, et gestures sur l'ecran rond reel
- Supporter les interactions connectees montre-telephone (ex: notification sur montre declenchant une action sur le prototype telephone)

**Source :** [protopie.io/solutions/smartwatch](https://www.protopie.io/solutions/smartwatch), [protopie.io/learn/docs/player/player-for-wear-os](https://www.protopie.io/learn/docs/player/player-for-wear-os)

#### c) Outils de Test d'Accessibilite

| Outil | Plateforme | Usage |
|-------|-----------|-------|
| **TalkBack** | Wear OS | Screen reader integre, tester navigation sequentielle |
| **VoiceOver** | watchOS | Screen reader Apple, gestes specifiques montre |
| **Accessibility Scanner** | Android (emulateur) | Analyse automatique des problemes (contraste, touch targets, labels) |
| **Font Size Override** | Wear OS + watchOS | Tester avec taille police maximale |
| **Switch Access** | Wear OS | Navigation via boutons externes |
| **@WearPreviewFontScales** | Android Studio | Voir le rendu a toutes les echelles de police |

**Checklist accessibilite a tester :**
1. TalkBack : chaque element interactif a un `contentDescription`
2. Touch targets : minimum 48dp (voir Section B)
3. Contraste : ratio 4.5:1 pour texte, 3:1 pour elements graphiques
4. Font scaling : l'UI ne casse pas a 200% de taille de police
5. Navigation sequentielle : ordre logique de focus
6. Haptics : feedback vibratoire pour les actions sans retour visuel (ecran loin des yeux)

### 47. Workflow Design-to-Dev

#### a) Workflow Recommande

```
DESIGN                          DEV                            TEST
  |                               |                              |
  1. Kit Figma M3 Wear OS        |                              |
  |                               |                              |
  2. Ecrans dans frame rond       |                              |
     (450x450 + masque)           |                              |
  |                               |                              |
  3. Prototype ProtoPie           |                              |
     (test sur vraie montre)      |                              |
  |                               |                              |
  4. Handoff Figma               5. Implementation Compose       |
     (inspect mode, tokens)          @WearPreviewDevices          |
  |                               |                              |
  |                              6. Emulateur                    |
  |                                 (Small Round + Large Round)  |
  |                               |                              |
  |                              7. Layout Inspector             |
  |                                 (verifier marges, clipping)  |
  |                               |                              |
  |                              8. Device reel                  |
  |                                 (batterie, lisibilite        |
  |                                  soleil, mouvement)          |
  |                               |                              |
  |                               |                            9. Accessibility
  |                               |                               (TalkBack, font
  |                               |                                scaling, contraste)
```

**Regles du workflow :**
- Toujours commencer par le plus petit ecran (192dp rond)
- Designer d'abord pour rond, adapter ensuite pour carre si necessaire
- Valider le prototype sur montre reelle AVANT le dev (evite les iterations couteuses)
- Utiliser les memes tokens couleur/typo entre Figma et Compose (variables Figma = M3 tokens)

#### b) Gestion Rond vs Carre en Design

| Aspect | Rond | Carre | Strategy |
|--------|------|-------|----------|
| **Surface utile** | 78.5% du carre englobant | 100% | Designer pour rond = compatible carre |
| **Texte** | Marges 26.5% horizontales | Marges 5-8% | Utiliser `ResponsiveBoxInsetConstraints` |
| **Listes** | Items centraux plus larges (scaling) | Largeur uniforme | `TransformingLazyColumn` gere automatiquement |
| **Boutons** | Centrer, eviter les bords | Aligner sur grille | `EdgeButton` epouse le bord rond |
| **Navigation** | Swipe back naturel | Idem | `SwipeDismissableNavHost` |

**Regle d'or :** Depuis Wear OS 4+, 99%+ des appareils sont ronds. Designer uniquement pour rond sauf besoin legacy explicite.

#### c) Test Device Reel vs Emulateur

| Critere | Emulateur | Device Reel |
|---------|-----------|-------------|
| **Iteration rapide** | Excellent (hot reload, Live Edit) | Lent (deploiement + navigation) |
| **Layout / UI** | Fiable (sauf DashedArcLine API 36) | Reference absolue |
| **Performance** | Non representative | Seule source fiable |
| **Batterie** | Impossible a mesurer | Critique a valider |
| **Lisibilite soleil** | Impossible | Test en exterieur obligatoire |
| **Haptics** | Non supporte | Seul moyen de valider |
| **Capteurs** | Simules (panneau Health Services) | Donnees reelles |
| **Rotary input** | Simule (menu overflow) | Bezel physique ou couronne |
| **Mouvement** | Impossible | Tester en marchant, en courant |
| **Burn-in OLED** | Non applicable | Verifier shift ambient |
| **Glove mode** | Impossible | Tester avec gants |
| **Cout** | Gratuit | $200-400+ par device |

**Strategie recommandee :**
1. **Dev quotidien :** Emulateur Small Round (192dp) + Large Round (227dp) + `@WearPreviewDevices`
2. **Validation UI :** Layout Inspector sur emulateur
3. **Validation UX :** Prototype ProtoPie sur montre reelle (avant dev)
4. **Validation finale :** Device reel pour performance, batterie, lisibilite, haptics
5. **Accessibilite :** TalkBack sur device reel (emulateur acceptable en fallback)
6. **Minimum devices reels :** 1 Pixel Watch + 1 Galaxy Watch (couvrent 90%+ du marche Wear OS)

**Sources :** [Android Developers - Wear OS Design Kits](https://developer.android.com/design/ui/wear/guides/get-started/design-kits), [Android Developers - Emulator](https://developer.android.com/training/wearables/get-started/emulator), [Android Developers - Debugging](https://developer.android.com/training/wearables/get-started/debugging), [Android Developers - Compose Previews](https://developer.android.com/develop/ui/compose/tooling/previews), [Android Developers - Accessibility](https://developer.android.com/training/wearables/accessibility), [ProtoPie Smartwatch](https://www.protopie.io/solutions/smartwatch), [Apple Design Resources](https://developer.apple.com/design/resources/), [Samsung Developer](https://developer.samsung.com/galaxy-watch-design/principle.html)

---

## AC. Multi-Device Continuity & Handoff Patterns

> Patterns officiels pour la continuite entre montre et telephone.
> Sources: [Android Developers](https://developer.android.com/training/wearables), [Apple Developer](https://developer.apple.com/documentation/watchconnectivity), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/)

### 50. Wear OS -> Android Phone Handoff

#### 50a. RemoteActivityHelper (ouvrir l'app phone depuis la montre)

**Package:** `androidx.wear.remote.interactions`

**Dependance Gradle:**
```gradle
implementation "androidx.wear:wear-remote-interactions:1.1.0"
```

**Principe:** Permet de lancer une Activity sur le telephone companion depuis la montre. Supporte les intents avec `ACTION_VIEW`, un URI de donnees, et la categorie `CATEGORY_BROWSABLE`.

**Code Kotlin - Ouvrir l'app phone:**
```kotlin
import androidx.wear.remote.interactions.RemoteActivityHelper
import android.content.Intent
import android.net.Uri
import kotlinx.coroutines.guava.await

// Ouvrir une page specifique sur le phone
suspend fun openOnPhone(context: Context) {
    val remoteActivityHelper = RemoteActivityHelper(context)

    val intent = Intent(Intent.ACTION_VIEW).apply {
        data = Uri.parse("https://example.com/details/123")
        addCategory(Intent.CATEGORY_BROWSABLE)
    }

    try {
        remoteActivityHelper.startRemoteActivity(intent).await()
        // Afficher confirmation "Ouvert sur le telephone"
        showOpenOnPhoneAnimation(context)
    } catch (e: Exception) {
        // Phone non connecte ou app non installee
        showFailureAnimation(context)
    }
}

// Ouvrir le Play Store pour installer l'app companion
suspend fun promptInstallPhoneApp(context: Context) {
    val remoteActivityHelper = RemoteActivityHelper(context)
    val marketIntent = Intent(Intent.ACTION_VIEW).apply {
        data = Uri.parse("market://details?id=com.example.myapp")
        addCategory(Intent.CATEGORY_BROWSABLE)
    }
    remoteActivityHelper.startRemoteActivity(marketIntent).await()
}
```

**Contraintes:**
- Intent doit avoir `ACTION_VIEW` + `CATEGORY_BROWSABLE`
- Donnees via `Intent.setData(Uri)` uniquement
- Retourne `TARGET_NODE_NOT_CONNECTED` si le phone est deconnecte
- Pas de retry automatique

**Source:** [RemoteActivityHelper API](https://developer.android.com/reference/androidx/wear/remote/interactions/RemoteActivityHelper)

#### 50b. ConfirmationActivity (feedback visuel apres handoff)

**Trois types d'animation:**

| Constante | Usage |
|-----------|-------|
| `SUCCESS_ANIMATION` | Action completee sur la montre |
| `FAILURE_ANIMATION` | Action echouee |
| `OPEN_ON_PHONE_ANIMATION` | Contenu redirige vers le telephone |

**Manifest:**
```xml
<activity android:name="androidx.wear.activity.ConfirmationActivity" />
```

**Code Kotlin:**
```kotlin
fun showOpenOnPhoneAnimation(context: Context) {
    val intent = Intent(context, ConfirmationActivity::class.java).apply {
        putExtra(
            ConfirmationActivity.EXTRA_ANIMATION_TYPE,
            ConfirmationActivity.OPEN_ON_PHONE_ANIMATION
        )
        putExtra(
            ConfirmationActivity.EXTRA_MESSAGE,
            context.getString(R.string.opening_on_phone)
        )
    }
    context.startActivity(intent)
}
```

**Comportement:** Affiche l'animation plein ecran, puis `finish()` automatique -> retour a l'Activity precedente.

**Source:** [Show confirmations on Wear](https://developer.android.com/training/wearables/views/confirm)

#### 50c. Ongoing Activity (continuite sur les surfaces Wear OS)

**Dependances:**
```gradle
dependencies {
    implementation "androidx.wear:wear-ongoing:1.1.0"
    implementation "androidx.core:core:1.17.0"
}
```

**Principe:** Expose une activite longue (workout, navigation, media) sur le watch face (icone tappable) et dans les Recents du launcher. L'utilisateur peut revenir a l'app en un tap.

**Code Kotlin complet:**
```kotlin
// 1. Creer la notification ongoing
val pendingIntent = PendingIntent.getActivity(
    this, 0,
    Intent(this, TrackingActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
    },
    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
)

val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
    .setContentTitle("Suivi cigarette")
    .setContentText("Detection en cours")
    .setSmallIcon(R.drawable.ic_smoking)
    .setCategory(NotificationCompat.CATEGORY_WORKOUT)
    .setContentIntent(pendingIntent)
    .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
    .setOngoing(true)

// 2. Creer l'OngoingActivity avec status dynamique
val startTime = SystemClock.elapsedRealtime()
val status = Status.Builder()
    .addTemplate("#type# #time#")
    .addPart("type", Status.TextPart("Suivi"))
    .addPart("time", Status.StopwatchPart(startTime))
    .build()

val ongoingActivity = OngoingActivity.Builder(
    applicationContext, NOTIFICATION_ID, notificationBuilder
)
    .setAnimatedIcon(R.drawable.ic_smoking_animated)
    .setStaticIcon(R.drawable.ic_smoking_static)
    .setTouchIntent(pendingIntent)
    .setStatus(status)
    .build()

// 3. Appliquer et poster
ongoingActivity.apply(applicationContext)
startForeground(NOTIFICATION_ID, notificationBuilder.build())
```

**Mise a jour du status:**
```kotlin
// Quelques MAJ par minute max (systeme ignore si trop frequent)
OngoingActivity.recoverOngoingActivity(context)
    ?.update(context, newStatus)
```

**Arret:** `notificationManager.cancel(NOTIFICATION_ID)`

**Categories supportees:**

| Categorie | Usage |
|-----------|-------|
| `CATEGORY_WORKOUT` | Exercice, suivi sante |
| `CATEGORY_NAVIGATION` | Navigation GPS |
| `CATEGORY_TRANSPORT` | Lecture media |
| `CATEGORY_STOPWATCH` | Chronometre |
| `CATEGORY_CALL` | Appels voix/video |
| `CATEGORY_LOCATION_SHARING` | Partage de position |
| `CATEGORY_ALARM` | Alarmes/minuteries |

**Source:** [Ongoing Activity API](https://developer.android.com/training/wearables/notifications/ongoing-activity)

#### 50d. Deep Link Watch Notification -> Phone App

**Pattern bridged notification (automatique):**
Les notifications creees sur le phone sont automatiquement bridgees vers la montre. Elles incluent automatiquement un bouton pour ouvrir l'app sur le phone.

**Pattern local notification (manuel):**
```kotlin
// Action specifique montre qui ouvre le phone
val openOnPhoneAction = NotificationCompat.Action.Builder(
    R.drawable.ic_phone,
    "Voir sur le telephone",
    phoneOpenPendingIntent
).build()

val wearableExtender = NotificationCompat.WearableExtender()
    .addAction(openOnPhoneAction)   // Action visible UNIQUEMENT sur la montre
    .setDismissalId("tracking_123") // Sync dismissal cross-device

val notification = NotificationCompat.Builder(context, channelId)
    .setContentTitle("5 cigarettes aujourd'hui")
    .setContentText("Voir les details sur le telephone")
    .extend(wearableExtender)
    .build()
```

**Sync de dismissal:** `setDismissalId()` synchronise la suppression de la notification entre montre et phone.

**Eviter les doublons:** Utiliser les Bridging APIs quand l'app est installee sur les deux appareils. Critique sur Wear OS 5+.

**Source:** [Notifications on Wear OS](https://developer.android.com/training/wearables/notifications)

#### 50e. CapabilityClient (verifier disponibilite app phone)

**Principe:** Detecter si l'app companion est installee sur le phone, et quelles fonctionnalites elle supporte.

**Configuration statique - wear.xml:**

*Dans l'app mobile (res/values/wear.xml):*
```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_infernal_wheel_phone</item>
    </string-array>
</resources>
```

*Dans l'app Wear OS (res/values/wear.xml):*
```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_infernal_wheel_wear</item>
    </string-array>
</resources>
```

**Code Kotlin - Detecter l'app phone:**
```kotlin
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.Wearable

suspend fun checkPhoneAppInstalled(context: Context): Boolean {
    val capabilityClient = Wearable.getCapabilityClient(context)
    val capabilityInfo = capabilityClient.getCapability(
        "verify_remote_infernal_wheel_phone",
        CapabilityClient.FILTER_REACHABLE
    ).await()
    return capabilityInfo.nodes.isNotEmpty()
}

// Detecter le type d'appareil companion
val phoneType = PhoneTypeHelper.getPhoneDeviceType(context)
// DEVICE_TYPE_ANDROID, DEVICE_TYPE_IOS, DEVICE_TYPE_UNKNOWN, DEVICE_TYPE_ERROR
```

**Configuration dynamique a runtime:**
```kotlin
// Ajouter une capability dynamiquement
capabilityClient.addLocalCapability("feature_cigarette_detection").await()

// Retirer une capability
capabilityClient.removeLocalCapability("feature_cigarette_detection").await()
```

**Filtre FILTER_ALL vs FILTER_REACHABLE:**
- `FILTER_REACHABLE`: Noeuds actuellement connectes (Bluetooth/WiFi)
- `FILTER_ALL`: Tous les noeuds connus (meme offline)

**Reconnexion:** Les appareils peuvent mettre jusqu'a 4 minutes pour se reconnecter apres Doze, retrait du poignet, ou inactivite.

**Source:** [Discover devices on network](https://developer.android.com/training/wearables/data/discover-devices), [Standalone apps](https://developer.android.com/training/wearables/apps/standalone-apps)

#### 50f. Phone Confirmation Pattern (montre initie, phone confirme)

**Flow complet en Compose:**
```kotlin
@Composable
fun HandoffToPhoneButton(
    context: Context,
    onSuccess: () -> Unit,
    onError: (String) -> Unit
) {
    var isLoading by remember { mutableStateOf(false) }
    var phoneAvailable by remember { mutableStateOf<Boolean?>(null) }

    // Verifier la disponibilite du phone au lancement
    LaunchedEffect(Unit) {
        phoneAvailable = checkPhoneAppInstalled(context)
    }

    val coroutineScope = rememberCoroutineScope()

    Button(
        onClick = {
            coroutineScope.launch {
                isLoading = true
                try {
                    if (phoneAvailable == true) {
                        // Envoyer les donnees au phone
                        sendMessageToPhone(context, "/open/details", dataPayload)
                        // Afficher confirmation
                        showOpenOnPhoneAnimation(context)
                        onSuccess()
                    } else {
                        // Proposer installation
                        promptInstallPhoneApp(context)
                    }
                } catch (e: Exception) {
                    onError("Telephone non disponible")
                } finally {
                    isLoading = false
                }
            }
        },
        enabled = !isLoading
    ) {
        if (isLoading) {
            CircularProgressIndicator(modifier = Modifier.size(16.dp))
        } else {
            Icon(Icons.Default.PhoneAndroid, contentDescription = null)
            Spacer(Modifier.width(4.dp))
            Text("Voir sur telephone")
        }
    }
}
```

#### 50g. MessageClient (communication watch <-> phone)

**Caracteristiques:**

| Propriete | Valeur |
|-----------|--------|
| Persistance | Aucune (fire-and-forget) |
| Taille max fiable | 100 KB |
| Retry automatique | Non |
| Mode offline | Non supporte |
| Methodes | `sendMessage()` (one-way), `sendRequest()` (request-response) |

**Code Kotlin:**
```kotlin
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.MessageClient

// Envoyer un message au phone
suspend fun sendMessageToPhone(context: Context, path: String, data: ByteArray) {
    val nodeClient = Wearable.getNodeClient(context)
    val nodes = nodeClient.connectedNodes.await()

    val phoneNode = nodes.firstOrNull { it.isNearby }
        ?: throw Exception("Phone not connected")

    Wearable.getMessageClient(context)
        .sendMessage(phoneNode.id, path, data)
        .await()
}

// Recevoir des messages (dans WearableListenerService)
class PhoneListenerService : WearableListenerService() {
    override fun onMessageReceived(messageEvent: MessageEvent) {
        when (messageEvent.path) {
            "/cigarette/logged" -> {
                // Phone a confirme l'enregistrement
                val count = messageEvent.data.toString(Charsets.UTF_8).toInt()
                updateWatchUI(count)
            }
            "/sync/request" -> {
                // Phone demande une synchro
                sendCurrentData()
            }
        }
    }
}
```

**Manifest pour le service:**
```xml
<service
    android:name=".PhoneListenerService"
    android:exported="true">
    <intent-filter>
        <action android:name="com.google.android.gms.wearable.MESSAGE_RECEIVED" />
        <data android:scheme="wear" android:host="*" android:pathPrefix="/cigarette" />
        <data android:scheme="wear" android:host="*" android:pathPrefix="/sync" />
    </intent-filter>
</service>
```

**Source:** [Data Layer messages](https://developer.android.com/training/wearables/data/messages)

#### 50h. Android 17 Handoff (nouveau, 2026)

**Nouveau:** Android 17 introduit un systeme de Handoff natif similaire a Apple Handoff.

**API:**
- `setHandoffEnabled(true)` sur l'Activity pour activer le handoff
- `onHandoffActivityRequested()` callback pour fournir les donnees de restauration
- Retourne un `HandoffActivityData` avec l'etat a transferer
- Surfaces d'entree: launcher et taskbar sur l'appareil recepteur
- Supporte phone -> tablette -> Chromebook -> Android TV
- Fallback: app-to-web Handoff si l'app n'est pas installee sur l'appareil cible

**Source:** [Android 17 Handoff (9to5Google)](https://9to5google.com/2026/02/13/android-17-handoff/)

---

### 51. watchOS -> iPhone Handoff

#### 51a. Handoff API (NSUserActivity)

**Principe:** Permet a l'utilisateur de commencer une tache sur la montre et la continuer sur l'iPhone. L'activite apparait sur l'ecran de verrouillage de l'iPhone (icone en bas).

**Code Swift - Cote Watch:**
```swift
import Foundation

class TrackingController: WKInterfaceController {

    override func willActivate() {
        super.willActivate()

        // Creer l'activite utilisateur
        let activity = NSUserActivity(activityType: "com.infernalwheel.viewDetails")
        activity.title = "Voir les details du suivi"
        activity.isEligibleForHandoff = true
        activity.userInfo = [
            "cigaretteCount": 5,
            "date": Date().timeIntervalSince1970
        ]

        // Rendre l'activite courante
        update(activity)
    }
}
```

**Code Swift - Cote iPhone (AppDelegate):**
```swift
func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
    if userActivity.activityType == "com.infernalwheel.viewDetails" {
        let count = userActivity.userInfo?["cigaretteCount"] as? Int ?? 0
        // Naviguer vers l'ecran de details
        navigateToDetails(cigaretteCount: count)
        return true
    }
    return false
}
```

**Info.plist (les deux apps):**
```xml
<key>NSUserActivityTypes</key>
<array>
    <string>com.infernalwheel.viewDetails</string>
    <string>com.infernalwheel.viewStats</string>
</array>
```

**Limitations:**
- L'icone de handoff apparait en bas de l'ecran de verrouillage iPhone -> l'utilisateur doit swiper vers le haut
- Pas toutes les apps supportent le handoff
- Cout d'interaction eleve selon NNGroup ("utterly bizarre interaction design")

**Source:** [Continuing User Activities with Handoff](https://developer.apple.com/documentation/Foundation/continuing-user-activities-with-handoff)

#### 51b. WCSession (Watch Connectivity)

**5 methodes de transfert:**

| Methode | Persistance | Timing | Taille | Usage |
|---------|-------------|--------|--------|-------|
| `sendMessage(_:)` | Non | Immediat (si reachable) | Petit | RPC temps reel |
| `transferUserInfo(_:)` | Oui (queue FIFO) | Background | Petit-moyen | Donnees incrementales |
| `updateApplicationContext(_:)` | Oui (dernier gagne) | Background | Petit | Etat global sync |
| `transferFile(_:metadata:)` | Oui (queue) | Background | Fichiers | Fichiers volumineux |
| `transferCurrentComplicationUserInfo(_:)` | Oui (prioritaire) | Immediat | Petit | MAJ complications |

**Code Swift - Setup et communication:**
```swift
import WatchConnectivity

class ConnectivityManager: NSObject, WCSessionDelegate {

    static let shared = ConnectivityManager()

    func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // Envoi temps reel (phone doit etre reachable)
    func sendCigaretteLogged(count: Int) {
        guard WCSession.default.isReachable else {
            // Fallback: transferUserInfo pour livraison garantie
            WCSession.default.transferUserInfo(["count": count, "timestamp": Date()])
            return
        }
        WCSession.default.sendMessage(
            ["action": "cigaretteLogged", "count": count],
            replyHandler: { reply in
                // Phone a confirme
            },
            errorHandler: { error in
                // Fallback vers transferUserInfo
                WCSession.default.transferUserInfo(["count": count])
            }
        )
    }

    // Sync etat global (dernier etat ecrase le precedent)
    func syncState(totalToday: Int, goal: Int) {
        try? WCSession.default.updateApplicationContext([
            "totalToday": totalToday,
            "goal": goal
        ])
    }

    // MARK: - Delegate

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let action = message["action"] as? String {
            switch action {
            case "updateGoal":
                let newGoal = message["goal"] as? Int ?? 0
                updateLocalGoal(newGoal)
            default: break
            }
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        // Traiter les donnees en queue (garanties)
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith state: WCSessionActivationState,
        error: Error?
    ) {
        // Gerer l'activation
    }
}
```

**Regles critiques:**
- `sendMessage` echoue silencieusement si `isReachable == false`
- `transferUserInfo` est queue FIFO -> livraison garantie meme si phone eteint
- `updateApplicationContext` ecrase la valeur precedente -> uniquement pour etat courant
- `transferCurrentComplicationUserInfo` a un budget limite (~50/jour en background)
- Le simulateur watchOS ne supporte PAS `transferFile`, `transferUserInfo`, `transferCurrentComplicationUserInfo` -> tester sur appareil physique

**Source:** [WCSession](https://developer.apple.com/documentation/watchconnectivity/wcsession)

#### 51c. Arbre de decision: quelle methode WCSession utiliser

```
Donnees a envoyer?
       |
   +---+---+
   |       |
Temps reel  Peut attendre
   |            |
isReachable? transferUserInfo()
   |         (queue FIFO, garanti)
 +---+
 |   |
Oui  Non
 |    |
sendMessage()  updateApplicationContext()
(immediat)     (dernier etat, ecrase)
```

---

### 52. UX Patterns Cross-Device

#### 52a. Quand rediriger vers le phone vs gerer sur la montre

**Garder sur la montre:**

| Tache | Raison |
|-------|--------|
| Controles single-tap | Pas de friction |
| Lecture de notifications | Glanceable |
| Suivi workout/tracking | Capteurs sur le poignet |
| Navigation (prochain virage) | Mains libres |
| Controles media (play/pause) | Telecommande naturelle |
| Minuteries/chronometre | Acces rapide |
| Enregistrement d'evenement (cigarette) | Un bouton suffit |

**Rediriger vers le phone:**

| Tache | Raison |
|-------|--------|
| Saisie de texte longue | Clavier impossible sur montre |
| Analyse detaillee post-workout | Graphiques complexes, ecran trop petit |
| Navigation de playlists | Trop de scrolling |
| Configuration/parametres avances | Trop de champs |
| Historique detaille | Tableaux, listes longues |
| Photos/videos | Resolution insuffisante |
| Recherche | Input difficile |
| Gestion d'erreurs complexes | Trop d'info a afficher |

**Regle NNGroup:** "A watch is not a smaller phone." Si l'interaction depasse 10-15 secondes ou requiert plus de 2-3 taps, envisager le handoff.

**Source:** [6 Types of Smartwatch Interactions (NNGroup)](https://www.nngroup.com/articles/smartwatch-interactions/), [Principles of Wear OS development](https://developer.android.com/training/wearables/principles)

#### 52b. Loading/Waiting States pendant le handoff

**Pattern recommande:**

```
1. Utilisateur tape "Voir sur telephone"
     |
2. Afficher CircularProgressIndicator (1-3s max)
     |
3a. Succes -> ConfirmationActivity(OPEN_ON_PHONE_ANIMATION)
    Message: "Ouvert sur le telephone"
    Auto-dismiss apres 2s
     |
3b. Echec -> ConfirmationActivity(FAILURE_ANIMATION)
    Message: "Telephone non disponible"
    + Action "Reessayer"
```

**Code Compose pour le loading:**
```kotlin
@Composable
fun HandoffLoadingState() {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            CircularProgressIndicator(
                modifier = Modifier.size(24.dp),
                strokeWidth = 3.dp
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "Ouverture sur le telephone...",
                style = MaterialTheme.typography.body2,
                textAlign = TextAlign.Center
            )
        }
    }
}
```

**Timeout:** Ne pas depasser 5 secondes d'attente. Au-dela, afficher l'erreur.

#### 52c. Error Handling quand le phone est inatteignable

**Hierarchie d'erreurs:**

| Erreur | Message utilisateur | Action |
|--------|-------------------|--------|
| Phone non connecte Bluetooth | "Telephone non connecte" | "Parametres Bluetooth" |
| App phone non installee | "Installez l'app sur le telephone" | Ouvrir Play Store |
| Phone en mode avion | "Telephone non disponible" | "Reessayer" |
| Timeout (>5s) | "Connexion lente" | "Reessayer" ou "Annuler" |
| Phone eteint/batterie vide | "Telephone non disponible" | Proposer action locale si possible |

**Principe NNGroup:** Ne JAMAIS dire "Allez sur l'iPhone et ouvrez l'app." Utiliser le handoff automatique pour eviter a l'utilisateur de chercher l'app manuellement. "Apps should hand over situations like these to the phone app, instead of having people launch the app by themselves."

**Code Kotlin - Gestion d'erreur robuste:**
```kotlin
sealed class HandoffResult {
    object Success : HandoffResult()
    data class PhoneNotConnected(val canRetry: Boolean) : HandoffResult()
    object AppNotInstalled : HandoffResult()
    object Timeout : HandoffResult()
}

suspend fun performHandoff(context: Context): HandoffResult {
    // 1. Verifier que l'app phone existe
    val hasPhoneApp = checkPhoneAppInstalled(context)
    if (!hasPhoneApp) return HandoffResult.AppNotInstalled

    // 2. Verifier la connectivite
    val nodeClient = Wearable.getNodeClient(context)
    val nodes = nodeClient.connectedNodes.await()
    if (nodes.isEmpty()) return HandoffResult.PhoneNotConnected(canRetry = true)

    // 3. Tenter le handoff avec timeout
    return try {
        withTimeout(5000L) {
            val remoteHelper = RemoteActivityHelper(context)
            val intent = Intent(Intent.ACTION_VIEW).apply {
                data = Uri.parse("infernalwheel://details")
                addCategory(Intent.CATEGORY_BROWSABLE)
            }
            remoteHelper.startRemoteActivity(intent).await()
            HandoffResult.Success
        }
    } catch (e: TimeoutCancellationException) {
        HandoffResult.Timeout
    } catch (e: Exception) {
        HandoffResult.PhoneNotConnected(canRetry = true)
    }
}
```

**Source:** [Apple Watch UX Appraisal (NNGroup)](https://www.nngroup.com/articles/smartwatch/)

#### 52d. Reconnexion et delais

| Scenario | Delai typique | Action |
|----------|--------------|--------|
| Bluetooth actif, proximite | < 1s | Immediat |
| Sortie de Doze (phone) | Jusqu'a 4 min | Attendre ou prevenir |
| Montre retiree du poignet | Jusqu'a 4 min | Re-detection au porter |
| Interaction simultanee (2 appareils) | Accelere | Reconnexion plus rapide |

**Source:** [Discover devices on network](https://developer.android.com/training/wearables/data/discover-devices)

#### 52e. Principes NNGroup pour le cross-device

**5 composantes d'une UX omnichannel reussie:**

1. **Coherence** - Experiences consistantes entre montre et phone (memes couleurs, terminologie, structure mentale)
2. **Optimisation contextuelle** - Adapter l'experience a chaque appareil (montre = glanceable, phone = detail)
3. **Continuite transparente** - L'utilisateur reprend ou il en etait sans friction. "If you can pick up where you left off, the user experience will be seamless."
4. **Proactivite** - Anticiper les transitions (ex: Google Maps "Envoyer au telephone")
5. **Collaboration** - Utiliser les 2 appareils en meme temps (telecommande media)

**Solutions techniques pour la continuite:**

| Methode | Implementation |
|---------|---------------|
| Authentification | Sign-in gate (activites de valeur) |
| Envoi de liens | Email/SMS de reprise, QR codes, passcodes |
| Handoff natif | RemoteActivityHelper (Android), NSUserActivity (Apple) |
| Deep linking | URI schemes pour restaurer le contexte exact |
| Persistence | Wishlists, save-for-later, donnees locales |

**Anti-patterns a eviter:**

| Anti-pattern | Pourquoi c'est mauvais | Solution |
|-------------|----------------------|----------|
| "Ouvrez l'app sur le telephone" sans handoff | Force l'utilisateur a chercher l'app | Utiliser RemoteActivityHelper |
| Contenu tronque sans moyen de voir la suite | Frustration, information incomplete | Handoff vers phone avec deep link |
| Sync manuelle requise | Friction inutile (ex: Delta Airlines) | Sync automatique en background |
| Meme UX exacte montre/phone | Montre pas adaptee au contenu detaille | Adapter au contexte de chaque appareil |
| Pas de feedback apres handoff | Utilisateur ne sait pas si ca a marche | ConfirmationActivity obligatoire |
| Barcode/scan qui echoue sans fallback | Blocage total | Proposer saisie manuelle ou code |

**Source:** [Seamlessness in Omnichannel UX (NNGroup)](https://www.nngroup.com/articles/seamless-cross-channel/), [Smartwatch Interactions (NNGroup)](https://www.nngroup.com/articles/smartwatch-interactions/), [Apple Watch UX (NNGroup)](https://www.nngroup.com/articles/smartwatch/)

#### 52f. Decision Tree - Handoff vs Local

```
Action demandee par l'utilisateur
              |
     +--------+--------+
     |                  |
  < 10s              > 10s
  < 3 taps           ou texte/detail
     |                  |
  MONTRE             PHONE?
  (local)               |
                   +----+----+
                   |         |
              Phone       Phone non
            connecte      connecte
                   |         |
              HANDOFF    Possible
            avec feedback  localement?
                   |       |      |
              Confirma-   Oui    Non
              tion        |      |
              Animation  LOCAL  Erreur +
                         (degrade) "Connectez
                                    votre tel."
```

---

### 53. Standalone Configuration & Horologist

**Manifest Wear OS:**
```xml
<manifest>
    <application>
        <!-- Declarer comme app Wear OS -->
        <uses-feature android:name="android.hardware.type.watch" />

        <!-- Standalone: true si l'app fonctionne sans phone -->
        <meta-data
            android:name="com.google.android.wearable.standalone"
            android:value="true" />
    </application>
</manifest>
```

**Regle Google:** Meme les apps non-standalone peuvent etre installees avant l'app phone companion. Toujours prevoir le cas ou le phone n'a pas l'app et proposer l'installation.

**Horologist (librairie Google recommandee):**
Le projet [Horologist](https://google.github.io/horologist/) fournit des helpers pour:
- Monitoring connexion phone <-> montre
- Implementation CapabilityClient simplifiee
- Detection type d'appareil companion (PhoneTypeHelper)
- Datalayer helpers avec samples

**Source:** [Standalone apps](https://developer.android.com/training/wearables/apps/standalone-apps), [Horologist](https://google.github.io/horologist/)

---

### 54. Checklist Implementateur Cross-Device

| # | Item | API/Pattern |
|---|------|------------|
| 1 | Declarer capabilities dans wear.xml (phone + watch) | CapabilityClient |
| 2 | Verifier app phone installee au lancement | `checkPhoneAppInstalled()` |
| 3 | Proposer installation si absente | `RemoteActivityHelper` -> Play Store |
| 4 | Feedback visuel apres chaque handoff | `ConfirmationActivity` |
| 5 | Timeout 5s max sur les operations cross-device | `withTimeout()` |
| 6 | Fallback local si phone indisponible | Mode degrade |
| 7 | Sync dismissal des notifications | `setDismissalId()` |
| 8 | Eviter doublons notifications | Bridging APIs |
| 9 | Ongoing Activity pour taches longues | `OngoingActivity.Builder` |
| 10 | MessageClient pour RPC, DataClient pour sync etat | Data Layer API |
| 11 | Tester reconnexion apres Doze (4 min delai) | Scenario de test |
| 12 | Gerer `DEVICE_TYPE_IOS` differemment | `PhoneTypeHelper` |
| 13 | Deep link requis pour restaurer contexte | URI scheme custom |
| 14 | Ne jamais dire "ouvrez l'app manuellement" | Handoff auto |

---

*Bible UX Wearable - Mise a jour mars 2026*
*Sources: [Android Developers](https://developer.android.com/wear), [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Samsung Developer](https://developer.samsung.com/one-ui-watch), [GSMArena](https://www.gsmarena.com), [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality), [Color Roles M3](https://developer.android.com/design/ui/wear/guides/styles/color/roles-tokens), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/), [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11054424/), [Ongoing Activity API](https://developer.android.com/training/wearables/notifications/ongoing-activity), [RemoteActivityHelper](https://developer.android.com/reference/androidx/wear/remote/interactions/RemoteActivityHelper), [WCSession](https://developer.apple.com/documentation/watchconnectivity/wcsession), [NNGroup Omnichannel](https://www.nngroup.com/articles/seamless-cross-channel/), [NNGroup Apple Watch](https://www.nngroup.com/articles/smartwatch/)*

## AD. Workout & Exercise Tracking UI

> Patterns UI pour le suivi d'exercice en temps reel sur montre connectee.
> Sources: [Health Services API](https://developer.android.com/health-and-fitness/guides), [Apple HealthKit Workouts](https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings), [Wear OS Exercise](https://developer.android.com/training/wearables/health-services/exercise)

### 55. Real-Time Metrics Layout

**Principe:** L'ecran d'exercice actif doit afficher 2-4 metriques simultanement selon le sport. Au-dela de 4, paginer verticalement.

**Layout recommande par sport:**

| Sport | Champ 1 (haut) | Champ 2 (centre) | Champ 3 (bas) | Champ 4 (optionnel) |
|-------|----------------|-------------------|----------------|----------------------|
| **Course** | Temps ecoule | Rythme (min/km) | Distance | FC (zone couleur) |
| **Velo** | Temps | Vitesse (km/h) | Distance | FC |
| **Natation** | Temps | Longueurs | Distance | SWOLF |
| **HIIT** | Timer interval | Repetitions | FC | Calories |
| **Marche** | Temps | Pas | Distance | FC |
| **Musculation** | Set / Rep | Temps repos | FC | Exercice nom |
| **Yoga** | Temps total | FC | Calories | - |

**Tailles de police recommandees:**

| Element | Taille | Poids |
|---------|--------|-------|
| Metrique principale (temps/distance) | 32-40 sp | Bold |
| Metrique secondaire | 20-24 sp | Medium |
| Label (ex: "PACE") | 12-14 sp | Regular, 70% opacite |
| Unite (km, bpm) | 12-14 sp | Regular |

### 55b. HR Zone Color Coding

**5 zones standard (pourcentage de FC max):**

| Zone | Nom | % FC Max | Couleur Wear OS (M3) | Couleur watchOS | Hex |
|------|-----|----------|----------------------|-----------------|-----|
| 1 | Echauffement | 50-60% | `colorTertiaryDim` | `.blue` | #64B5F6 |
| 2 | Brulage graisse | 60-70% | `colorPrimary` | `.green` | #81C784 |
| 3 | Cardio | 70-80% | `colorSecondary` | `.yellow` | #FFD54F |
| 4 | Seuil | 80-90% | `colorError` dim | `.orange` | #FFB74D |
| 5 | VO2 Max | 90-100% | `colorError` | `.red` | #E57373 |

**Code Compose for Wear OS - Zone display:**
```kotlin
@Composable
fun HrZoneIndicator(currentBpm: Int, maxHr: Int) {
    val percentage = (currentBpm.toFloat() / maxHr * 100).toInt()
    val zone = when {
        percentage < 60 -> HrZone(1, "WARM UP", Color(0xFF64B5F6))
        percentage < 70 -> HrZone(2, "FAT BURN", Color(0xFF81C784))
        percentage < 80 -> HrZone(3, "CARDIO", Color(0xFFFFD54F))
        percentage < 90 -> HrZone(4, "THRESHOLD", Color(0xFFFFB74D))
        else            -> HrZone(5, "VO2 MAX", Color(0xFFE57373))
    }
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(4.dp)
            .background(zone.color, RoundedCornerShape(2.dp))
    )
    Text(
        text = "${zone.name} Z${zone.number}",
        color = zone.color,
        fontSize = 12.sp,
        modifier = Modifier.padding(top = 2.dp)
    )
}
```

**SwiftUI watchOS:**
```swift
struct HRZoneBar: View {
    let currentBPM: Int
    let maxHR: Int

    var zoneColor: Color {
        let pct = Double(currentBPM) / Double(maxHR)
        switch pct {
        case ..<0.6:  return .blue
        case ..<0.7:  return .green
        case ..<0.8:  return .yellow
        case ..<0.9:  return .orange
        default:      return .red
        }
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(zoneColor)
            .frame(height: 4)
    }
}
```

### 55c. Auto-Pause & GPS Lock

**Auto-pause UX:**
- Detecter arret (vitesse < 1 km/h pendant 3-5s pour course)
- Afficher etat "PAUSED" clairement (texte large + fond dim)
- Reprise auto quand mouvement reprend
- Haptic feedback a la pause (1 vibration courte) et reprise (2 vibrations courtes)
- Timer fige visuellement (opacite reduite ou clignotement lent 1Hz)

**GPS lock indicator:**

| Etat | Icone | Couleur | Comportement |
|------|-------|---------|-------------|
| Recherche GPS | Satellite animé pulse | Gris 50% | "Acquisition GPS..." |
| GPS fixe faible (>10m) | Satellite statique | Jaune | Tracking actif |
| GPS fixe bon (<10m) | Satellite plein | Vert | Tracking optimal |
| GPS perdu | Satellite barre | Rouge | "Signal GPS perdu" |

**ExerciseClient binding (Wear OS Health Services):**
```kotlin
val exerciseClient = HealthServices.getClient(context).exerciseClient

// Verifier capacites
val capabilities = exerciseClient.getCapabilitiesAsync().await()
val runCaps = capabilities.getExerciseTypeCapabilities(ExerciseType.RUNNING)

// Configurer exercice
val config = ExerciseConfig.builder(ExerciseType.RUNNING)
    .setDataTypes(setOf(
        DataType.HEART_RATE_BPM,
        DataType.DISTANCE_TOTAL,
        DataType.SPEED,
        DataType.LOCATION
    ))
    .setIsAutoPauseAndResumeEnabled(true)
    .setIsGpsEnabled(true)
    .build()

exerciseClient.startExerciseAsync(config).await()
```

### 55d. Lap/Split & Segment Display

**Lap screen layout:**
- Swipe horizontal (ou bouton physique) pour marquer un tour
- Haptic confirmation: double tap court (50ms + 50ms)
- Afficher pendant 2s en overlay: "LAP 3 — 4:32"
- Liste des laps accessible par swipe vertical depuis l'ecran principal

**Natation segments:**
- Auto-detection retournement (accelerometre)
- Affichage: longueur actuelle / total, style detecte (crawl/brasse/dos/papillon)
- Repos entre series: timer automatique

### 55e. Lock Screen During Workout

**Wear OS:** Water Lock desactive le tactile ; bouton physique seul controle
**watchOS:** Water Lock via `WKInterfaceDevice.current().enableWaterLock()`

**Regle:** Toujours proposer le verrouillage pour les sports aquatiques et les sports a contact (eviter les touches accidentelles).

### 55f. Post-Workout Summary

**Contenu minimum:**
| Metrique | Format |
|----------|--------|
| Duree totale | HH:MM:SS |
| Distance | X.XX km |
| Rythme moyen | M:SS /km |
| FC moyenne / max | XXX / XXX bpm |
| Calories | XXX kcal |
| Carte (si GPS) | Trace miniature |
| Zones FC | Bar chart horizontal |

**Interaction:** Scroll vertical pour toutes les metriques. Bouton "Save" en bas. Bouton "Discard" avec confirmation.

### 55g. Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| API | Health Services ExerciseClient | HKWorkoutSession + HKLiveWorkoutBuilder |
| Auto-pause | `setIsAutoPauseAndResumeEnabled(true)` | `HKWorkoutSession.pause()` auto via motion |
| GPS | `setIsGpsEnabled(true)` | Automatique si `HKWorkoutActivityType` le requiert |
| Background | Ongoing Activity obligatoire | Session active = background garanti |
| Lock screen | Water lock manual | Water Lock + Crown to unlock |
| Zones FC | A implementer manuellement | Zones natives dans `HKWorkoutBuilder` |
| Multi-sport | `ExerciseType` enum (50+ types) | `HKWorkoutActivityType` (80+ types) |

### Checklist Workout UI

- ✅ Afficher max 4 metriques par page, paginer au-dela
- ✅ Couleur HR zone visible en permanence (barre ou fond)
- ✅ Auto-pause avec feedback haptic distinct pause/reprise
- ✅ GPS lock indicator avant de demarrer le tracking
- ✅ Ongoing Activity (Wear OS) pour garder le foreground
- ✅ Lock screen proposé pour sports aquatiques
- ✅ Post-workout summary scrollable avec option save/discard
- ❌ Ne pas afficher plus de 5 metriques sur un seul ecran
- ❌ Ne pas utiliser de petites polices (<12sp) pour les metriques actives
- ❌ Ne pas masquer le timer principal — toujours visible

**Anti-patterns:**
1. **Dashboard surcharge** — 6+ metriques dans un seul ecran, illisible en mouvement
2. **Pas de GPS feedback** — L'utilisateur demarre la course sans savoir si le GPS est acquis
3. **Pause silencieuse** — Auto-pause sans haptic = confusion, l'utilisateur ne sait pas si le tracking continue

**Source:** [Health Services on Wear OS](https://developer.android.com/training/wearables/health-services), [Apple Workout API](https://developer.apple.com/documentation/healthkit/hkworkoutsession), [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality)

---

## AE. Heart Rate & Health Data Display

> Patterns d'affichage des donnees de sante (FC, SpO2, stress, temperature, ECG).
> Sources: [Health Services API](https://developer.android.com/training/wearables/health-services), [Apple HealthKit](https://developer.apple.com/documentation/healthkit), [Samsung Health Sensor SDK](https://developer.samsung.com/health/sensor-sdk)

### 56. Continuous HR Graph (Sparkline)

**Contraintes ecran rond:**
- Largeur graphe: 70-80% du diametre ecran
- Hauteur graphe: 40-50 dp max
- Points de donnee affiches: 20-30 (dernieres 5-10 minutes)
- Epaisseur ligne: 2-3 dp
- Pas d'axes visibles (trop petit) — utiliser couleur de zone comme reference

**Code Compose sparkline:**
```kotlin
@Composable
fun HrSparkline(
    readings: List<Int>, // derniers 30 BPM
    modifier: Modifier = Modifier
) {
    val zoneColor = hrZoneColor(readings.lastOrNull() ?: 0)
    Canvas(modifier = modifier.height(40.dp).fillMaxWidth(0.75f)) {
        if (readings.size < 2) return@Canvas
        val min = (readings.min() - 10).coerceAtLeast(40)
        val max = (readings.max() + 10).coerceAtMost(220)
        val path = Path()
        readings.forEachIndexed { i, bpm ->
            val x = i * size.width / (readings.size - 1)
            val y = size.height - ((bpm - min).toFloat() / (max - min) * size.height)
            if (i == 0) path.moveTo(x, y) else path.lineTo(x, y)
        }
        drawPath(path, color = zoneColor, style = Stroke(width = 2.dp.toPx()))
    }
}
```

**SwiftUI watchOS sparkline:**
```swift
struct HRSparkline: View {
    let readings: [Int]

    var body: some View {
        Chart(Array(readings.enumerated()), id: \.offset) { index, bpm in
            LineMark(
                x: .value("Time", index),
                y: .value("BPM", bpm)
            )
            .foregroundStyle(zoneColor(for: bpm))
            .lineStyle(StrokeStyle(lineWidth: 2))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 40)
        .padding(.horizontal)
    }
}
```

### 56b. HR Zone Visualization Table

| Zone | Plage BPM (age 30, max ~190) | Couleur | Utilite |
|------|------------------------------|---------|---------|
| 1 — Rest/Light | 95-114 bpm (50-60%) | #64B5F6 Bleu | Recuperation active |
| 2 — Fat Burn | 114-133 bpm (60-70%) | #81C784 Vert | Endurance de base |
| 3 — Cardio | 133-152 bpm (70-80%) | #FFD54F Jaune | Amelioration aerobique |
| 4 — Hard | 152-171 bpm (80-90%) | #FFB74D Orange | Seuil lactique |
| 5 — Peak | 171-190 bpm (90-100%) | #E57373 Rouge | Sprint / VO2max |

**Formule FC max:** 220 - age (Tanaka: 208 - 0.7 × age pour plus de precision)

### 56c. Resting HR Trend

**Affichage:**
- Graphique 7 jours / 30 jours (toggle via tap ou swipe horizontal)
- Valeur actuelle en grand (32sp bold), tendance en petit (14sp, "↓ 3 bpm vs semaine derniere")
- Ligne de reference: moyenne 30 jours en pointille (1dp, 40% opacite)

**Seuils d'alerte (adulte):**

| Condition | Seuil | Action UX |
|-----------|-------|-----------|
| FC repos normale | 60-100 bpm | Affichage standard |
| Bradycardie potentielle | < 40 bpm (10 min) | Notification + vibration |
| Tachycardie repos | > 120 bpm (10 min au repos) | Notification urgente |
| FC irreguliere | Variation > 20% sans activite | Notification douce |

### 56d. Abnormal HR Alert UX

**Flow d'alerte FC elevee:**
1. Detection: FC > seuil pendant duree configuree
2. Haptic: 3 taps longs (600ms each, 200ms gap)
3. Ecran: fond rouge dim (#E57373 a 20%), icone coeur, "Frequence cardiaque elevee: 142 bpm"
4. Actions: "OK" (dismiss) + "Details" (historique)
5. Log dans historique sante

**Regle critique:** Ne JAMAIS utiliser le mot "danger" ou "urgence" pour une alerte FC elevee non confirmee. Formuler: "Votre frequence cardiaque semble elevee pour votre niveau d'activite actuel."

### 56e. SpO2 & Blood Oxygen

**Ecran de mesure "Keep Still":**
- Fond sombre, icone poumon/O2
- Texte: "Restez immobile. Mesure en cours..." (16sp)
- Barre de progression circulaire (15-30 secondes)
- Bras doit rester plat, montre bien positionnee

**Affichage resultat:**
| SpO2 | Couleur | Label |
|------|---------|-------|
| 95-100% | Vert | Normal |
| 90-94% | Jaune | Bas — consulter si persistant |
| < 90% | Rouge | Tres bas — avis medical |

### 56f. ECG Recording Flow

**Apple Watch (Series 4+):**
1. Ouvrir app ECG → "Posez le doigt sur la Digital Crown"
2. Timer 30 secondes, trace ECG en temps reel
3. Resultat: "Rythme sinusal" / "Fibrillation auriculaire" / "Non concluant"
4. Option: exporter PDF vers Health

**Galaxy Watch (Watch 4+, Samsung Health Monitor):**
1. Ouvrir Samsung Health Monitor → "Posez le doigt sur le capteur arriere"
2. Timer 30 secondes
3. Resultat similaire
4. Restrictions geographiques (approuve par pays)

### 56g. Real-Time vs Historical Toggle

**Pattern recommande:**
- Ecran principal: valeur temps reel (gros chiffre, mise a jour chaque seconde)
- Swipe vertical bas: graphe historique (dernieres 24h / 7j / 30j)
- Ne PAS melanger temps reel et historique sur le meme ecran (confusion)

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| HR continu | `HeartRateAccuracy` via Health Services | `HKQuantityType.heartRate` via workout/background |
| SpO2 | `DataType.SPO2` (Health Services) | `HKQuantityType.oxygenSaturation` |
| ECG | Samsung Health Monitor SDK (restreint) | `HKElectrocardiogram` (natif) |
| Temperature | `SKIN_TEMPERATURE` (Wear OS 5+) | `HKQuantityType.appleSleepingWristTemperature` |
| Alerte FC | A implementer manuellement | Alertes HR native dans Settings |
| Autorisation | `BODY_SENSORS` permission | HealthKit authorization dialog |

### Checklist Health Data Display

- ✅ Sparkline adaptee ecran rond (70-80% largeur, 40dp hauteur)
- ✅ Couleur de zone HR toujours contextuelle
- ✅ Seuils d'alerte configurables par l'utilisateur
- ✅ Ecran "restez immobile" pour SpO2 avec progression
- ✅ Separer temps reel et historique (ecrans distincts)
- ✅ Formulation non-alarmiste pour les alertes
- ❌ Ne pas diagnostiquer — toujours "consulter un professionnel"
- ❌ Ne pas afficher ECG sans disclaimer reglementaire
- ❌ Ne pas vibrer en continu pour alerte FC (3 taps puis stop)

**Anti-patterns:**
1. **Diagnostic medical implicite** — Afficher "Vous avez de la fibrillation" sans disclaimer
2. **Graphe illisible** — Axes, legende, grille sur 1.3" → bruit visuel total
3. **Alerte fatigue** — Vibrer toutes les 5 minutes pour FC elevee pendant l'exercice

**Source:** [Health Services Wear OS](https://developer.android.com/training/wearables/health-services), [Apple HealthKit](https://developer.apple.com/documentation/healthkit), [Samsung Health Monitor](https://developer.samsung.com/health/monitor-sdk)

---

## AF. Sleep Tracking UI

> Patterns d'affichage et interaction pour le suivi du sommeil sur montre connectee.
> Sources: [Apple Sleep Tracking](https://developer.apple.com/documentation/healthkit/hkcategoryvaluesleepanalysis), [Google Sleep API](https://developer.android.com/training/wearables/health-services/passive), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/)

### 57. Sleep Stage Visualization

**Couleurs par stade de sommeil:**

| Stade | Couleur | Hex | Position (axe Y, haut = leger) |
|-------|---------|-----|-------------------------------|
| Eveille | Rouge clair | #EF9A9A | 4 (haut) |
| REM | Bleu clair | #90CAF9 | 3 |
| Sommeil leger | Indigo moyen | #7986CB | 2 |
| Sommeil profond | Indigo fonce | #3949AB | 1 (bas) |

**Hypnogramme sur ecran rond:**
- Largeur: 80% du diametre
- Hauteur: 50-60 dp
- Axe X = temps (22h → 7h), sans labels (trop petit)
- Axe Y = stade (4 niveaux), barres empilees ou stepped line
- Couleur de fond: noir pur (#000000) pour AMOLED

**Code Compose hypnogram simplifie:**
```kotlin
@Composable
fun SleepHypnogram(
    stages: List<SleepStage>, // (startTime, endTime, stage)
    modifier: Modifier = Modifier
) {
    val colors = mapOf(
        Stage.AWAKE to Color(0xFFEF9A9A),
        Stage.REM to Color(0xFF90CAF9),
        Stage.LIGHT to Color(0xFF7986CB),
        Stage.DEEP to Color(0xFF3949AB)
    )
    Canvas(modifier = modifier.height(50.dp).fillMaxWidth(0.8f)) {
        val totalDuration = stages.sumOf { it.durationMs }
        var xOffset = 0f
        stages.forEach { stage ->
            val width = (stage.durationMs.toFloat() / totalDuration) * size.width
            val yTop = when (stage.type) {
                Stage.AWAKE -> 0f
                Stage.REM   -> size.height * 0.25f
                Stage.LIGHT -> size.height * 0.50f
                Stage.DEEP  -> size.height * 0.75f
            }
            drawRect(
                color = colors[stage.type]!!,
                topLeft = Offset(xOffset, yTop),
                size = Size(width, size.height - yTop)
            )
            xOffset += width
        }
    }
}
```

**SwiftUI watchOS:**
```swift
struct SleepHypnogram: View {
    let stages: [SleepStage]

    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(stages) { stage in
                    Rectangle()
                        .fill(stage.color)
                        .frame(width: geo.size.width * stage.proportion)
                        .frame(height: geo.size.height, alignment: .bottom)
                        .frame(height: stage.heightFraction * geo.size.height)
                }
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
    }
}
```

### 57b. Sleep Score Display

**Layout recommande:**
- Score en grand au centre: 72-96 dp, bold (ex: "85")
- Label sous le score: "Sleep Score" (14sp)
- Arc circulaire autour du score (gauge 0-100):
  - 0-50: Rouge
  - 51-70: Orange
  - 71-85: Vert clair
  - 86-100: Vert
- Sous-metriques en scroll: duree, efficacite, regularity

### 57c. Night Mode (DND automatique)

**Comportement recommande (11pm - 7am par defaut):**

| Propriete | Valeur |
|-----------|--------|
| Luminosite ecran | ≤ 10% ou niveau 1 |
| Always-On Display | Desactive ou minimal (heure seule) |
| Haptics | Desactivees (sauf alarme) |
| Notifications | Silencieuses, pas d'ecran allume |
| Couleur dominante | Rouge fonce / gris sombre |
| Raise-to-wake | Desactive |
| Touch-to-wake | Desactive (bouton physique uniquement) |

**Wear OS:**
```kotlin
// Activer Bedtime mode via DND
val notificationManager = getSystemService(NotificationManager::class.java)
notificationManager.setInterruptionFilter(
    NotificationManager.INTERRUPTION_FILTER_NONE // ou ALARMS only
)
```

**watchOS:** Sleep Focus automatique via `HKCategoryValueSleepAnalysis` detection.

### 57d. Bedtime Reminder & Morning Summary

**Bedtime reminder:**
- 30 minutes avant heure cible (configurable)
- Notification douce: 1 haptic tap, ecran: "Bientot l'heure de dormir"
- Action: "Activer mode nuit" (one-tap)

**Morning summary notification:**
- Affichee au premier raise-to-wake apres reveil detecte
- Contenu: score, duree, stades (mini hypnogramme), "Vous avez dormi 7h23"
- Action: "Details" → ecran complet ou handoff phone

### 57e. Snoring Detection Display

- Indicateur: microphone actif pendant la nuit (icone discrete)
- Resultat matin: "Ronflements detectes: 23 min (3 episodes)"
- Audio snippets disponibles sur le telephone (pas sur la montre)
- Disclaimer: "A titre informatif uniquement, ne constitue pas un diagnostic"

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Detection sommeil | Health Services PassiveMonitoringClient | Automatique (Sleep Focus + capteurs) |
| Stades | `SleepStageType` (AWAKE, LIGHT, DEEP, REM) | `HKCategoryValueSleepAnalysis` (inBed, asleepCore, asleepDeep, asleepREM, awake) |
| Mode nuit | DND / Bedtime mode (Android) | Sleep Focus (watchOS 9+) |
| Ronflement | Non natif (apps tierces) | Non natif montre (iPhone nearby) |
| Score sommeil | Implementation app | Non natif (apps tierces comme AutoSleep) |
| Reveil intelligent | Via alarme app | Natif watchOS 9+ (vibration phase legere) |

### Checklist Sleep UI

- ✅ Hypnogramme simplifie avec 4 couleurs distinctes
- ✅ Score en grand avec arc gauge
- ✅ Mode nuit automatique (dim, no haptics, no raise-to-wake)
- ✅ Notification matinale avec resume compact
- ✅ Couleurs AMOLED-friendly (fond noir, couleurs saturees)
- ❌ Ne pas afficher de graphes detailles — renvoyer au telephone
- ❌ Ne pas vibrer pendant le sommeil (sauf alarme)
- ❌ Ne pas utiliser de blanc/bleu vif la nuit (lumiere bleue)

**Anti-patterns:**
1. **Ecran lumineux nocturne** — Summary qui allume l'ecran a pleine luminosite a 3h du matin
2. **Hypnogramme surcharge** — Axes, labels, legende sur 1.3" rond → illisible
3. **Vibration intempestive** — Notifier "vous etes eveille depuis 10 min" pendant la nuit

**Source:** [Apple Sleep](https://developer.apple.com/documentation/healthkit/hkcategoryvaluesleepanalysis), [Wear OS Passive Data](https://developer.android.com/training/wearables/health-services/passive), [Sleep Foundation](https://www.sleepfoundation.org/stages-of-sleep)

---

## AG. Maps & Turn-by-Turn Navigation

> Affichage cartographique et navigation guidee sur ecran de montre.
> Sources: [Google Maps Wear OS](https://developer.android.com/training/wearables/apps/maps), [Apple MapKit watchOS](https://developer.apple.com/documentation/mapkit), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/)

### 58. Map Rendering Constraints

**Limites materielles:**

| Contrainte | Valeur | Implication |
|------------|--------|-------------|
| RAM disponible pour carte | 50-100 MB max | Tuiles vectorielles obligatoires (pas raster) |
| Taille cache offline | 50-200 MB recommande | Limiter a zone de 20x20 km |
| Refresh rate carte | 1-5 FPS suffisant | Pas de 60fps scroll, trop couteux |
| Tactile sur carte | Imprecis (gros doigts) | Pan = mouvement bras, zoom = bezel/crown |
| Ecran rond | Coins caches | Centrer POI, eviter info dans les coins |

**Wear OS (Google Maps SDK):**
```kotlin
// MapView dans Compose for Wear OS
implementation "com.google.android.gms:play-services-maps:19.0.0"

@Composable
fun WearMapScreen(location: LatLng) {
    AndroidView(factory = { context ->
        MapView(context).apply {
            onCreate(null)
            getMapAsync { map ->
                map.uiSettings.isZoomControlsEnabled = false // bezel zoom
                map.moveCamera(CameraUpdateFactory.newLatLngZoom(location, 16f))
                map.setMapStyle(MapStyleOptions.loadRawResourceStyle(context, R.raw.dark_map))
            }
        }
    })
}
```

**Regle:** Toujours utiliser un style de carte sombre (mode nuit) pour economiser la batterie AMOLED et reduire la distraction au poignet.

### 58b. Turn-by-Turn Layout

**Disposition ecran:**
```
┌─────────────────┐
│    ↗ 250m       │  ← Distance prochaine instruction (20sp bold)
│                 │
│    ┏━━━━━━┓     │
│    ┃  ⬆️➡️ ┃     │  ← Grande fleche directionnelle (80x80 dp)
│    ┗━━━━━━┛     │
│                 │
│  Rue de Rivoli  │  ← Nom de rue (16sp, max 20 chars, ellipsis)
│    ⏱ 12 min     │  ← ETA (14sp, 60% opacite)
└─────────────────┘
```

**Tailles recommandees:**

| Element | Taille | Priorite |
|---------|--------|----------|
| Fleche directionnelle | 64-80 dp | 1 (toujours visible) |
| Distance prochaine manoeuvre | 20-24 sp bold | 2 |
| Nom de rue | 14-16 sp | 3 (tronquer si necessaire) |
| ETA / distance restante | 12-14 sp, dim | 4 |

### 58c. Haptic Directions

**Pattern haptic par direction (Google Maps Wear OS):**

| Direction | Pattern haptic | Description |
|-----------|---------------|-------------|
| Tourner a gauche | 2 taps courts cote gauche | `CLICK` × 2, 100ms gap |
| Tourner a droite | 3 taps courts cote droit | `CLICK` × 3, 100ms gap |
| Tout droit (rappel) | 1 tap long | `HEAVY_CLICK` × 1 |
| Demi-tour | Vibration continue 500ms | Pattern continu |
| Destination atteinte | 3 taps longs | `HEAVY_CLICK` × 3, 200ms gap |
| Deviation de route | 2 vibrations longues | 300ms on, 200ms off, 300ms on |

**Code Wear OS haptic:**
```kotlin
fun vibrateDirection(context: Context, direction: Direction) {
    val vibrator = context.getSystemService(Vibrator::class.java)
    val pattern = when (direction) {
        Direction.LEFT -> longArrayOf(0, 50, 100, 50) // 2 taps
        Direction.RIGHT -> longArrayOf(0, 50, 100, 50, 100, 50) // 3 taps
        Direction.STRAIGHT -> longArrayOf(0, 200) // 1 long
        Direction.U_TURN -> longArrayOf(0, 500) // continuous
        Direction.ARRIVED -> longArrayOf(0, 200, 200, 200, 200, 200) // 3 long
        Direction.OFF_ROUTE -> longArrayOf(0, 300, 200, 300) // 2 long
    }
    vibrator.vibrate(VibrationEffect.createWaveform(pattern, -1))
}
```

**watchOS:**
```swift
func hapticForDirection(_ direction: Direction) {
    let device = WKInterfaceDevice.current()
    switch direction {
    case .left:
        device.play(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            device.play(.click)
        }
    case .right:
        device.play(.directionUp) // built-in directional
    case .arrived:
        device.play(.success)
    default:
        device.play(.notification)
    }
}
```

### 58d. Low-Power Navigation

**Strategie ecran eteint entre les instructions:**
1. Ecran off apres 5s sans interaction
2. A 200m de la prochaine manoeuvre: reveil ecran + haptic
3. Afficher instruction en mode ambient (blanc sur noir, 1 bit)
4. Apres passage du virage: ecran off a nouveau

**Economie batterie:** ~40% de battery saved vs ecran allume en continu pendant 1h de navigation

### 58e. Breadcrumb Trail (Randonnee)

**Pattern:**
- Trace du parcours effectue en pointilles sur fond de carte sombre
- Position actuelle: point bleu pulsant (8dp, animation 1Hz)
- Waypoints: cercles 6dp avec label court (3-4 chars)
- Distance restante + denivele en bas d'ecran
- Boussole: petite fleche nord (12dp) en haut a droite

### 58f. Route Deviation Alert

| Etat | Seuil | UX |
|------|-------|----|
| On route | < 30m de la route | Normal |
| Deviation legere | 30-100m | Haptic douce, "Recalcul..." |
| Hors route | > 100m pendant 30s | Haptic forte, nouveau calcul auto |

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| SDK carte | Google Maps SDK for Wear | MapKit (limite, pas de navigation native) |
| Navigation native | Google Maps app | Apple Maps app |
| Carte offline | Telechargement via phone | Cartes offline automatiques (watchOS 10+) |
| Haptic directions | Via API Vibrator | `WKInterfaceDevice.play()` |
| Ambient mode nav | Supporté (instructions low-bit) | Always-On (watchOS 8+) |
| Boussole | `SensorManager.TYPE_ROTATION_VECTOR` | `CLHeading` + `CMMotionManager` |

### Checklist Navigation

- ✅ Fleche directionnelle large (64-80 dp minimum)
- ✅ Haptic distinct par type de virage
- ✅ Mode sombre carte obligatoire (AMOLED)
- ✅ Ecran eteint entre instructions (economie batterie)
- ✅ Nom de rue tronque proprement (ellipsis a 20 chars)
- ✅ Alerte deviation avec recalcul automatique
- ❌ Ne pas afficher de carte zoomable interactive (imprecis au doigt)
- ❌ Ne pas garder l'ecran allume en continu pendant la navigation
- ❌ Ne pas utiliser de couleurs pastel sur fond clair (illisible en exterieur)

**Anti-patterns:**
1. **Carte interactive complexe** — Pinch-to-zoom sur 1.3" = frustration
2. **Navigation silencieuse** — Pas de haptic, l'utilisateur doit regarder la montre a chaque intersection
3. **Instructions trop detaillees** — "Dans 247 metres, prenez la deuxieme sortie du rond-point direction..." → tronquer

**Source:** [Google Maps Wear OS](https://developer.android.com/training/wearables/apps/maps), [Apple MapKit](https://developer.apple.com/documentation/mapkit), [Google Maps haptic research](https://blog.google/products/maps/)

---

## AH. Cellular vs Bluetooth-Only UX

> Gestion des etats de connectivite et degradation gracieuse des fonctionnalites.
> Sources: [Wear OS Network](https://developer.android.com/training/wearables/data/network-access), [Apple Watch Cellular](https://support.apple.com/guide/watch/use-your-apple-watch-with-a-cellular-network-apd30a498e26/watchos)

### 59. Connection State Indicators

**5 etats de connectivite:**

| Etat | Icone | Couleur | Barre status | Fonctionnalites |
|------|-------|---------|-------------|-----------------|
| BT connecte au phone | 📱 (mini) | Vert | Aucune icone (etat normal) | 100% des features |
| BT deconnecte + LTE | 📶 (signal) | Vert | Icone LTE verte | 80% (pas de sync rapide) |
| WiFi seulement | 📶 WiFi | Jaune | Icone WiFi | 70% (latence accrue) |
| BT deconnecte, pas de reseau | ✈️ barré | Rouge | Icone nuage barre | Mode offline |
| Mode avion | ✈️ | Gris | Icone avion | Capteurs locaux uniquement |

**Regle critique:** Ne PAS afficher d'icone quand la connectivite est normale (BT au phone). N'afficher une icone que pour les etats degrades.

### 59b. Feature Degradation Matrix

| Feature | BT+Phone | LTE seul | WiFi seul | Offline |
|---------|----------|----------|-----------|---------|
| Notifications | ✅ Temps reel | ✅ Temps reel | ✅ Temps reel | ❌ |
| Appels | ✅ Via phone | ✅ Direct | ❌ | ❌ |
| Messages (envoi) | ✅ | ✅ | ✅ | ❌ (queue) |
| Musique streaming | ✅ Via phone | ✅ Direct (data!) | ✅ | ❌ |
| Musique offline | ✅ | ✅ | ✅ | ✅ |
| GPS / Navigation | ✅ | ✅ | ⚠️ Pas de carte | ⚠️ GPS brut |
| Health tracking | ✅ | ✅ | ✅ | ✅ (sync later) |
| Paiement NFC | ✅ | ✅ | ✅ | ✅ (tokenise) |
| Assistant vocal | ✅ | ✅ | ✅ | ❌ |
| Apps tierces sync | ✅ | ⚠️ Certaines | ⚠️ Certaines | ❌ |

### 59c. LTE Power Impact

| Mode | Consommation | Impact batterie |
|------|-------------|-----------------|
| BT connecte (idle) | ~5-10 mW | Reference |
| LTE idle (connecte, pas de data) | ~50-80 mW | ~5x BT |
| LTE actif (streaming) | 200-400 mW | ~30-40x BT |
| WiFi idle | ~20-40 mW | ~3x BT |
| WiFi actif | ~100-200 mW | ~15x BT |

**Implication UX:** Avertir l'utilisateur avant le streaming LTE: "Le streaming sur LTE reduit significativement l'autonomie. Telecharger pour ecouter hors ligne?"

### 59d. Data Usage Awareness

**Pattern UI:**
- Afficher icone "LTE" quand actif (rappel visuel)
- Dashboard data: "Usage LTE aujourd'hui: 45 MB"
- Alerte a 80% du forfait montre (si connu)
- Option: "Limiter aux donnees essentielles en LTE" (pas de sync photos, pas de streaming)

### 59e. Streaming vs Offline Decision Tree

```
Phone nearby? ──YES──► Stream via phone (BT)
       │
       NO
       │
  WiFi available? ──YES──► Stream via WiFi
       │
       NO
       │
  LTE active? ──YES──► Contenu offline disponible? ──YES──► Jouer offline
       │                        │
       │                        NO ──► "Streamer via LTE?"
       │                                (warning batterie/data)
       NO
       │
  ► Mode offline uniquement
```

### 59f. eSIM & Standalone Considerations

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| eSIM setup | Via Galaxy Wearable / Pixel Watch app | Via Watch app iPhone |
| Numero partage | Meme numero que phone (NumberSync) | Meme numero que iPhone |
| Activation | Operateur-dependant | Operateur-dependant |
| Standalone sans eSIM | WiFi si connu, sinon offline | WiFi si connu, sinon offline |
| Emergency call sans eSIM | ✅ Supporté (regulation) | ✅ Supporté (regulation) |

### 59g. Emergency Calling

**Regle absolue:** Les appels d'urgence (112/911/999) doivent TOUJOURS fonctionner, meme sans eSIM activee, sans forfait, sans phone. C'est une obligation reglementaire.

**UX:** Le bouton SOS ne doit jamais etre grise ou desactive pour raison de connectivite.

### Checklist Connectivity

- ✅ Pas d'icone en etat normal (BT connecte)
- ✅ Degradation gracieuse avec fallback offline
- ✅ Warning avant streaming LTE (batterie + data)
- ✅ Queue les operations quand offline, sync au retour
- ✅ Emergency call toujours accessible
- ✅ Afficher clairement l'etat de connexion dans settings
- ❌ Ne pas bloquer l'app entiere si offline
- ❌ Ne pas streamer automatiquement en LTE sans consentement
- ❌ Ne pas cacher l'etat LTE (l'utilisateur doit savoir qu'il consomme de la data)

**Anti-patterns:**
1. **App morte offline** — "Connexion requise" au lieu de mode degrade
2. **Streaming LTE silencieux** — Vide la batterie en 2h sans que l'utilisateur comprenne
3. **Icone de connexion permanente** — Pollution visuelle quand tout va bien

**Source:** [Wear OS Network Access](https://developer.android.com/training/wearables/data/network-access), [Apple Watch Cellular](https://support.apple.com/guide/watch/), [3GPP Emergency Calling](https://www.3gpp.org/)

---

## AI. Music & Media Control

> Layout et interactions pour le controle multimedia sur montre connectee.
> Sources: [Media Controls Wear OS](https://developer.android.com/training/wearables/views/media-controls), [Apple Now Playing](https://developer.apple.com/design/human-interface-guidelines/now-playing)

### 60. Now Playing Layout

**Disposition recommandee ecran rond:**
```
┌──────────────────┐
│   🎵 Artist      │  ← Artiste (14sp, 60% opacite, ellipsis)
│                  │
│  ┌────────────┐  │
│  │  Album Art │  │  ← Pochette album (80-100 dp, centre)
│  └────────────┘  │
│                  │
│   Song Title     │  ← Titre (16sp bold, max ~20 chars)
│                  │
│  ⏮  ▶️/⏸  ⏭    │  ← Controles (tap targets 48dp min)
│                  │
│  ━━━━━●━━━━━━━  │  ← Barre progression (swipeable)
│                  │
│  🔊 Volume      │  ← Crown/bezel = volume
└──────────────────┘
```

**Tailles des elements:**

| Element | Taille | Interaction |
|---------|--------|-------------|
| Pochette album | 80-100 dp carre | Tap = toggle play/pause |
| Boutons prev/next | 32 dp icone, 48 dp tap target | Tap |
| Bouton play/pause | 40 dp icone, 52 dp tap target | Tap |
| Barre de progression | 4 dp hauteur, pleine largeur -16dp | Drag horizontal |
| Volume | Pas de slider visible | Crown (watchOS) / Bezel (Galaxy) |

### 60b. Volume Control

**Crown (watchOS):** Rotation Digital Crown = volume. Chaque cran = 1 unite (~6.25% sur 16 niveaux). Feedback haptic a chaque cran.

**Bezel (Galaxy Watch):** Rotation bezel = volume. Smooth, pas de crans.

**Wear OS sans bezel:** Boutons +/- ou side button avec RSB (Rotary Side Button).

**Indicateur volume:** Arc en haut de l'ecran apparait pendant 2s lors d'un changement, puis disparait.

### 60c. Offline Music Sync

**UX de telechargement:**
1. Selection sur le telephone: playlists/albums a synchroniser
2. Sync automatique quand montre en charge + WiFi
3. Sur la montre: icone ☁️↓ pendant sync, ✓ quand pret
4. Indicateur stockage: "2.1 GB / 4.0 GB utilise"

**Limites stockage typiques:**

| Montre | Stockage total | Disponible musique (estime) |
|--------|---------------|---------------------------|
| Galaxy Watch 7 | 16 GB | ~5-8 GB |
| Pixel Watch 3 | 32 GB | ~12-16 GB |
| Apple Watch S10 | 64 GB | ~30-40 GB |

### 60d. Bluetooth Audio Output

**Picker ecouteurs:**
- Liste des appareils BT appaires: nom + icone type (earbuds/headphones/speaker)
- Appareil actif en surbrillance verte
- Tap pour basculer la sortie audio
- "Haut-parleur montre" toujours en dernier (qualite mediocre)

### 60e. Streaming vs Local Toggle

**Pattern:**
- Icone: nuage (streaming) vs appareil (local)
- Toggle accessible depuis Now Playing (icone en haut a droite)
- Si LTE: warning "Streaming via donnees mobiles"
- Si offline: automatiquement local, toggle grise

### 60f. Background Playback Indicator

**Wear OS:** Ongoing Activity avec icone ♫ dans le watch face
**watchOS:** Now Playing complication auto-update, icone ♫ dans status bar

**Code Wear OS Ongoing Activity:**
```kotlin
val ongoingActivity = OngoingActivity.Builder(context, NOTIFICATION_ID, notification)
    .setStaticIcon(Icon.createWithResource(context, R.drawable.ic_music))
    .setTouchIntent(openAppPendingIntent)
    .setStatus(
        OngoingActivityStatus.Builder()
            .addPart("song", OngoingActivityStatus.TextPart("Now Playing: Song Title"))
            .build()
    )
    .build()
ongoingActivity.apply(context)
```

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Media control | `MediaBrowserServiceCompat` | `WKNowPlayingInfoCenter` |
| Volume hardware | RSB / bezel | Digital Crown |
| Streaming apps | YouTube Music, Spotify | Apple Music, Spotify |
| Offline sync | App-specifique | Apple Music auto-sync |
| BT audio switch | Parametres → BT | Now Playing → AirPlay icon |
| Background | Ongoing Activity | Background audio session |

### Checklist Media

- ✅ Pochette album visible et centree
- ✅ Volume via hardware (crown/bezel), pas de slider tactile
- ✅ Titre tronque avec ellipsis (max ~20 chars)
- ✅ Ongoing Activity / Now Playing complication
- ✅ Indicateur offline vs streaming clair
- ✅ Picker BT audio accessible sans quitter le player
- ❌ Ne pas forcer le streaming en LTE sans confirmation
- ❌ Ne pas afficher la barre de progression en mode ambient
- ❌ Ne pas cacher les controles derriere un geste (play/pause toujours visible)

**Anti-patterns:**
1. **Volume par slider tactile** — Imprecis, couvre la pochette, utiliser le hardware
2. **Pas d'indicateur offline** — L'utilisateur ne sait pas si la musique est telechargee ou streamee
3. **Pochette manquante** — Ecran gris avec juste du texte = experience degradee

**Source:** [Wear OS Media](https://developer.android.com/training/wearables/views/media-controls), [Apple Now Playing HIG](https://developer.apple.com/design/human-interface-guidelines/now-playing), [Spotify Wear OS](https://developer.spotify.com/)

---

## AJ. Phone Calls on Watch

> Gestion des appels telephoniques sur montre (reception, emission, en cours).
> Sources: [Wear OS Calling](https://developer.android.com/training/wearables), [Apple Watch Calls](https://support.apple.com/guide/watch/make-and-receive-phone-calls-apd90498a498/watchos)

### 61. Incoming Call Screen

**Layout:**
```
┌──────────────────┐
│                  │
│   📞 Incoming    │  ← Label (14sp)
│                  │
│   John Doe       │  ← Nom contact (20sp bold)
│   +33 6 12 34..  │  ← Numero (14sp, 60% opacite)
│                  │
│  🟢    🔇    🔴  │  ← Accept / Silence / Reject
│ Accept Mute Decline│
│                  │
│  💬 Reply        │  ← Quick reply message
└──────────────────┘
```

**Boutons:**

| Action | Icone | Couleur | Taille tap target | Geste alternatif |
|--------|-------|---------|-------------------|-----------------|
| Accepter | Telephone vert | #4CAF50 | 52 dp | - |
| Refuser | Telephone rouge | #F44336 | 52 dp | - |
| Silence | Cloche barree | Gris | 40 dp | Poser paume sur ecran |
| Repondre SMS | Bulle message | Bleu | 36 dp | - |

**Haptic incoming call:** Vibration continue pattern (200ms on, 200ms off) tant que l'appel sonne.

### 61b. In-Call Screen

**Layout pendant l'appel:**
```
┌──────────────────┐
│   John Doe       │  ← Nom (16sp bold)
│   00:42          │  ← Duree (24sp, mise a jour chaque seconde)
│                  │
│  🎤   🔊   ⌨️   │  ← Mute / Speaker / Keypad
│                  │
│  🔴 End Call     │  ← Bouton fin (large, 52dp height)
└──────────────────┘
```

**Actions disponibles:**

| Action | Icone | Etat toggle |
|--------|-------|-------------|
| Mute micro | 🎤 / 🎤❌ | On/Off, couleur change |
| Haut-parleur | 🔊 / 🔊❌ | On/Off |
| Clavier DTMF | ⌨️ | Ouvre ecran numerique |
| Raccrocher | 🔴 | Action definitive |

### 61c. Call Quality Limits

| Aspect | Haut-parleur montre | Ecouteurs BT |
|--------|-------------------|--------------|
| Qualite audio | Mediocre (micro loin bouche) | Bonne |
| Environnement bruyant | Tres mauvais | Acceptable |
| Distance bras etendu | ~30 cm du micro | N/A |
| Usage recommande | < 2 min, calme | Appels longs |
| Privacite | Nulle (haut-parleur) | Bonne |

**UX recommandee:** Si l'appel dure > 30s et pas d'ecouteurs BT, suggerer discretement "Transférer sur le telephone?" en bas d'ecran.

### 61d. Call Routing

**Priorite de routage:**
1. Ecouteurs BT connectes → audio vers ecouteurs
2. Haut-parleur montre (si pas d'ecouteurs)
3. Transfert vers phone (sur action utilisateur)

**Wear OS:**
```kotlin
// Verifier ecouteurs connectes
val audioManager = getSystemService(AudioManager::class.java)
val isHeadsetConnected = audioManager.isBluetoothA2dpOn
```

### 61e. DND During Workout

**Regle:** Pendant un exercice, les appels doivent passer en mode silencieux par defaut. Exception: contacts favoris ou urgences (2 appels du meme numero en 3 minutes).

**UX:** Notification tactile douce (1 tap) + nom affiché en banner 3s en haut d'ecran, sans interrompre l'ecran d'exercice.

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Appels via BT | ✅ Via phone | ✅ Via iPhone |
| Appels LTE natifs | ✅ (eSIM) | ✅ (eSIM) |
| Transfert vers phone | Manuel | Automatique (pick up iPhone = transfert) |
| Silence par geste | Paume sur ecran (certains modeles) | Paume sur ecran |
| DTMF keypad | ✅ | ✅ |
| FaceTime audio | ❌ | ✅ |
| Wi-Fi calling | ✅ (si operateur) | ✅ |

### Checklist Appels

- ✅ Boutons accept/reject larges (52dp) et colores (vert/rouge)
- ✅ Silence par paume sur ecran
- ✅ Timer d'appel visible en permanence
- ✅ Suggestion transfert phone si appel long
- ✅ DND pendant workout (sauf favoris/urgences)
- ❌ Ne pas forcer le haut-parleur sans alternative
- ❌ Ne pas bloquer l'ecran d'exercice pour un appel non-urgent
- ❌ Ne pas garder l'ecran allume pendant tout l'appel (ambient apres 5s)

**Anti-patterns:**
1. **Boutons minuscules incoming call** — Rater l'appel parce que le bouton accept fait 32dp
2. **Pas de transfert phone** — Forcer une conversation de 10 min sur le haut-parleur du poignet
3. **Exercice interrompu** — L'ecran de workout disparait pour afficher l'appel, l'utilisateur perd ses metriques

**Source:** [Wear OS Calling](https://developer.android.com/training/wearables), [Apple Watch Calls](https://support.apple.com/guide/watch/)

---

## AK. Notification Grouping & Stacking

> Gestion du groupement et de l'empilement des notifications sur montre.
> Sources: [Wear OS Notifications](https://developer.android.com/training/wearables/notifications), [watchOS Notifications](https://developer.apple.com/documentation/watchos-apps/designing-your-apps-notifications), [Material Design Notifications](https://developer.android.com/design/ui/wear/guides/surfaces/notifications)

### 62. Group Notification Layout

**Principe:** Quand une app envoie 3+ notifications, les grouper sous un summary. L'utilisateur voit d'abord le resume, tap pour expander.

**Layout collapsed (summary):**
```
┌──────────────────┐
│ 📧 Gmail         │
│ 3 new emails     │  ← Summary text
│ J. Doe, A. Smith │  ← Apercu expediteurs
└──────────────────┘
```

**Layout expanded:**
```
┌──────────────────┐
│ 📧 John Doe      │  ← Notification individuelle 1
│ Meeting tomorrow  │
├──────────────────┤
│ 📧 Alice Smith   │  ← Notification individuelle 2
│ Project update    │
├──────────────────┤
│ 📧 Bob Wilson    │  ← Notification individuelle 3
│ Quick question    │
└──────────────────┘
```

### 62b. Wear OS Grouping API

```kotlin
// Notification summary (parent)
val summaryNotif = NotificationCompat.Builder(context, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_email)
    .setContentTitle("3 new emails")
    .setContentText("J. Doe, A. Smith, B. Wilson")
    .setGroup(GROUP_KEY_EMAILS)
    .setGroupSummary(true) // <-- REQUIS pour le parent
    .setStyle(NotificationCompat.InboxStyle()
        .addLine("John Doe: Meeting tomorrow")
        .addLine("Alice Smith: Project update")
        .addLine("Bob Wilson: Quick question")
        .setSummaryText("3 new emails")
    )
    .build()

// Notifications enfants
val childNotif = NotificationCompat.Builder(context, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_email)
    .setContentTitle("John Doe")
    .setContentText("Meeting tomorrow at 2pm")
    .setGroup(GROUP_KEY_EMAILS) // <-- Meme group key
    .build()

notificationManager.notify(SUMMARY_ID, summaryNotif)
notificationManager.notify(CHILD_ID_1, childNotif)
```

### 62c. watchOS Automatic Stacking

**watchOS gere le groupement automatiquement:**
- Meme app → stack automatique apres 3+ notifications
- `threadIdentifier` pour sous-groupes (ex: conversations separees)
- Pas de `setGroupSummary()` — le systeme cree le summary

```swift
let content = UNMutableNotificationContent()
content.title = "John Doe"
content.body = "Meeting tomorrow at 2pm"
content.threadIdentifier = "email-inbox" // sous-groupe
content.summaryArgument = "John Doe"
content.summaryArgumentCount = 1
```

### 62d. Notification Limits & Truncation

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Notifications visibles dans flux | ~20 max (puis "older notifications") | ~20 max |
| Texte collapsed (body) | ~40-50 chars avant ellipsis | ~40 chars |
| Texte expanded | ~200 chars | ~200 chars |
| Actions max par notification | 3 | 4 (dont dismiss) |
| Groupes max visibles | Pas de limite stricte | Pas de limite |
| Enfants par groupe avant truncation | ~8-10 puis "X more" | ~5-8 |

### 62e. Notification Channels (Multi-Feature Apps)

**Pattern pour app multi-feature (ex: app sante):**

| Channel | Importance | Comportement montre |
|---------|-----------|-------------------|
| `health_alerts` | HIGH | Vibration + ecran allume |
| `daily_summary` | DEFAULT | Vibration douce |
| `social` | LOW | Silencieux, dans le flux |
| `marketing` | MIN | Ne pas bridger du tout |

```kotlin
val healthChannel = NotificationChannel(
    "health_alerts",
    "Health Alerts",
    NotificationManager.IMPORTANCE_HIGH
).apply {
    enableVibration(true)
    vibrationPattern = longArrayOf(0, 300, 200, 300)
}
```

### 62f. Bridging & Cross-Device Dismiss

**Bridging filter (Wear OS):**
```xml
<!-- wear.xml - Exclure certaines notifications du bridging phone→watch -->
<wearableApp>
    <bridging enabled="true">
        <excludedTags>
            <string>marketing</string>
            <string>low_priority</string>
        </excludedTags>
    </bridging>
</wearableApp>
```

**Cross-device dismiss sync:**
```kotlin
// Synchroniser le dismiss entre phone et watch
val notification = NotificationCompat.Builder(context, CHANNEL_ID)
    .setDismissalId("email_123") // <-- Meme ID sur phone et watch
    .setContentTitle("New email")
    .build()
```

**Regle:** Quand l'utilisateur dismiss sur la montre, la notification doit disparaitre du phone (et vice versa). Sans `setDismissalId()`, les dismissals ne sont PAS synchronises.

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Groupement | Manuel (`setGroup()` + `setGroupSummary()`) | Automatique + `threadIdentifier` |
| Bridging control | `BridgingManager` / wear.xml | Mirroring automatique, filtre via UNNotificationCategory |
| Dismiss sync | `setDismissalId()` | Automatique |
| Actions inline | `RemoteInput` pour reponse | `UNTextInputNotificationAction` |
| Max actions | 3 | 4 |
| Rich media | `BigPictureStyle` / `BigTextStyle` | Attachments (`UNNotificationAttachment`) |

### Checklist Notifications

- ✅ Grouper les notifications (3+) avec summary parent
- ✅ `setDismissalId()` pour sync dismiss cross-device
- ✅ Channels avec importances differenciees
- ✅ Filtrer le bridging (exclure marketing/low priority)
- ✅ Max 3 actions par notification
- ✅ `threadIdentifier` (watchOS) pour sous-groupes logiques
- ❌ Ne pas envoyer chaque notification individuellement sans groupement
- ❌ Ne pas bridger les notifications deja gerees par l'app watch native
- ❌ Ne pas mettre plus de 3 actions (surcharge cognitive)

**Anti-patterns:**
1. **Flood de notifications** — 10 emails = 10 vibrations separees au lieu d'un groupe
2. **Dismiss desynchronise** — Dismisser sur la montre, retrouver la meme notification sur le phone
3. **Tout en HIGH** — Chaque notification allume l'ecran et vibre fortement

**Source:** [Wear OS Notifications](https://developer.android.com/training/wearables/notifications), [watchOS Notifications](https://developer.apple.com/documentation/watchos-apps/designing-your-apps-notifications), [Bridging API](https://developer.android.com/training/wearables/notifications/bridger)

---

## AL. Payment on Watch (Apple Pay / Google Wallet)

> Patterns UX pour le paiement sans contact depuis la montre.
> Sources: [Google Wallet Wear OS](https://developer.android.com/wear/tiles/api-overview), [Apple Pay Watch](https://developer.apple.com/apple-pay/), [Samsung Pay](https://developer.samsung.com/pay)

### 63. Activation du Paiement

**Double-press side button:**

| Plateforme | Geste d'activation | Bouton |
|------------|-------------------|--------|
| watchOS (Apple Pay) | Double-click bouton lateral | Side button |
| Wear OS (Google Wallet) | Double-click bouton superieur | Programmable button |
| Galaxy Watch (Samsung Pay) | Long press Back ou raccourci | Back button |

**Flow paiement:**
1. Double-press → ecran portefeuille apparait instantanement (<300ms)
2. Carte par defaut affichee (preview: derniers 4 chiffres + logo)
3. Swipe horizontal pour changer de carte
4. "Approchez du terminal" + animation NFC
5. Contact terminal → haptic + checkmark (200ms)
6. Ecran resultat: ✓ "Paye" + montant + commercant (3s puis auto-dismiss)

### 63b. Card Selection UI

**Layout:**
```
┌──────────────────┐
│  ← Swipe →       │
│                  │
│  ┌────────────┐  │
│  │ 💳 VISA    │  │  ← Carte active (grande, centre)
│  │ •••• 4242  │  │
│  │ Default ✓  │  │
│  └────────────┘  │
│                  │
│  ● ○ ○ ○        │  ← Indicateur page (dots)
│                  │
│  Ready to Pay    │  ← Status
└──────────────────┘
```

**Swipe horizontal** entre les cartes. Max 8-10 cartes visibles (au-dela, scroll).

### 63c. Authentication & Wrist Detection

| Methode | Plateforme | Quand |
|---------|-----------|-------|
| Wrist detection (implicite) | watchOS + Wear OS | Montre au poignet = authentifie |
| PIN au demarrage | Toutes | Quand la montre est mise au poignet |
| Re-auth apres retrait | Toutes | Montre retiree → PIN requis au retour |
| Pas de biometrie pendant paiement | Toutes | Trop lent, wrist detection suffit |

**Regle:** La detection au poignet EST l'authentification. Pas de PIN/biometrie supplementaire par transaction.

### 63d. Transit Cards (Transport)

**Specificite:** Les cartes de transport (Navigo, Suica, PASMO) fonctionnent en "Express Transit" — pas de double-press, pas d'authentification. Simplement approcher la montre du lecteur.

**UX:** Pas d'ecran affiché, transaction silencieuse. Notification post-transaction optionnelle.

### 63e. Success / Failure Feedback

| Resultat | Haptic | Visuel | Duree affichage |
|----------|--------|--------|----------------|
| Succes | 2 taps courts `SUCCESS` | ✓ vert + montant | 3s auto-dismiss |
| Echec | 3 taps longs `FAILURE` | ✗ rouge + "Reessayer" | Reste jusqu'a dismiss |
| Carte non reconnue | 1 tap long | ⚠️ "Carte non supportee" | 5s |
| Terminal timeout | Vibration continue 500ms | "Reapprocher du terminal" | Reste actif |

### Platform Comparison

| Aspect | Apple Pay (watchOS) | Google Wallet (Wear OS) | Samsung Pay |
|--------|-------------------|------------------------|-------------|
| Activation | Double-click side | Double-click top button | Long press back |
| Auth | Wrist detection | Wrist detection + PIN setup | Wrist detection |
| Transit express | ✅ | ✅ (certains pays) | ✅ (certains pays) |
| Cartes max | Pas de limite stricte | 12 cartes | 12 cartes |
| NFC offline | ✅ (tokenise) | ✅ (tokenise) | ✅ (MST + NFC) |

### Checklist Paiement

- ✅ Double-press → carte visible en < 300ms
- ✅ Swipe horizontal pour changer de carte
- ✅ Haptic + visuel distinct succes/echec
- ✅ Auto-dismiss apres 3s sur succes
- ✅ Transit express sans authentification
- ✅ Wrist detection comme authentification implicite
- ❌ Ne pas demander de PIN par transaction
- ❌ Ne pas afficher le numero complet de la carte
- ❌ Ne pas bloquer le paiement si offline (tokenisation locale)

**Anti-patterns:**
1. **Auth supplementaire** — Demander un PIN pour chaque paiement en plus du wrist lock
2. **Lenteur d'activation** — Plus de 500ms entre le double-press et l'ecran portefeuille
3. **Pas de feedback echec** — Le terminal refuse, la montre ne dit rien

**Source:** [Apple Pay](https://developer.apple.com/apple-pay/), [Google Wallet](https://developers.google.com/wallet), [Samsung Pay SDK](https://developer.samsung.com/pay)

---

## AM. Messaging on Watch

> Patterns d'affichage et de saisie de messages sur montre connectee.
> Sources: [Wear OS Messaging](https://developer.android.com/training/wearables/notifications), [watchOS Messaging](https://developer.apple.com/design/human-interface-guidelines/messaging), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/)

### 64. Conversation List Layout

**Disposition:**
- Liste verticale scrollable (ScalingLazyColumn / List)
- Chaque item: avatar (32dp rond) + nom (16sp bold) + preview (14sp, 1 ligne) + timestamp
- Conversations non lues: nom en bold + point indicateur bleu (8dp)
- Max ~15-20 conversations visibles avant "Load more"

**Item layout:**
```
┌──────────────────────┐
│ 🟦👤 John Doe   14:32│  ← Avatar + Nom + Heure
│    Hey, are you f... │  ← Preview message (14sp, 60% opacite)
├──────────────────────┤
│ 👤 Alice         13:15│
│    Thanks for the... │
└──────────────────────┘
```

### 64b. Message Bubble on Small Screen

**Contraintes:**
- Largeur bulle: max 85% de la largeur ecran
- Bulles envoyees: alignees droite, couleur primaire (#BB86FC ou app color)
- Bulles recues: alignees gauche, couleur surface (gris fonce)
- Police: 14-16 sp
- Max ~50-60 chars visibles sans scroll dans une bulle
- Messages longs: tronques avec "..." + tap pour expand

### 64c. Input Method Picker

**Methodes disponibles:**

| Methode | Icone | Wear OS | watchOS | Vitesse |
|---------|-------|---------|---------|---------|
| Voix (STT) | 🎤 | ✅ Google STT | ✅ Siri STT | Rapide |
| Clavier QWERTY | ⌨️ | ✅ Gboard mini | ✅ watchOS 9+ | Lent |
| Scribble/Handwriting | ✍️ | ✅ | ✅ | Moyen |
| Emoji | 😀 | ✅ | ✅ | Rapide |
| Smart Reply | 💬 | ✅ ML suggestions | ✅ | Tres rapide |
| Dessin/GIF | 🎨 | ⚠️ Limite | ✅ (Digital Touch) | Lent |

**Smart Reply ML:**
- 3 suggestions max affichees sous le message recu
- Suggestions contextuelles ("Oui", "Non", "Je suis en route")
- Tap = envoi immediat sans confirmation
- Wear OS: `RemoteInput` + ML on-device
- watchOS: suggestions natives dans Notification

### 64d. Smart Reply Code

**Wear OS (RemoteInput):**
```kotlin
val remoteInput = RemoteInput.Builder(KEY_QUICK_REPLY)
    .setLabel("Reply")
    .setChoices(arrayOf("Yes", "No", "On my way", "Call me"))
    .build()

val replyAction = NotificationCompat.Action.Builder(
    R.drawable.ic_reply, "Reply", replyPendingIntent
)
    .addRemoteInput(remoteInput)
    .build()
```

**watchOS:**
```swift
let replyAction = UNTextInputNotificationAction(
    identifier: "REPLY_ACTION",
    title: "Reply",
    options: [],
    textInputButtonTitle: "Send",
    textInputPlaceholder: "Type a message"
)
```

### 64e. Constraints on Rich Content

| Contenu | Supporte | Limitation |
|---------|----------|-----------|
| Texte | ✅ | Max ~200 chars avant scroll |
| Emoji | ✅ | Rendu natif |
| Image/Photo | ⚠️ | Thumbnail 100x100dp max, tap pour agrandir |
| GIF | ⚠️ | Premiere frame statique ou animation courte |
| Sticker | ⚠️ | Reduit a 64x64dp |
| Fichier/PDF | ❌ | "Ouvrir sur le telephone" |
| Lien | ⚠️ | Texte seulement, pas de preview |

### 64f. Read Receipts & Typing Indicator

**Read receipts:** Coches (✓✓ bleu) sous le message, meme pattern que phone mais plus petit (10sp).

**Typing indicator:** "..." anime en bas de conversation, 3 points qui pulsent. Disparait apres 10s timeout.

### Platform Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| App Messages native | Google Messages | iMessage |
| Clavier | Gboard (swipe, tap, voice) | QWERTY natif (watchOS 9+) |
| Smart Reply | ML on-device | Suggestions natives |
| Scribble | ✅ | ✅ |
| GIF envoi | Via Gboard | Via #images |
| Group chat | ✅ | ✅ (iMessage groups) |

### Checklist Messaging

- ✅ Smart Reply en premiere option (le plus rapide)
- ✅ Voix en deuxieme option
- ✅ Bulles couleur differenciee envoi/reception
- ✅ Preview conversation tronquee a 1 ligne
- ✅ Input method picker accessible en 1 tap
- ❌ Ne pas forcer le clavier par defaut (voix/smart reply d'abord)
- ❌ Ne pas afficher les GIF en taille pleine (trop lourd)
- ❌ Ne pas exiger de scroll pour trouver le champ de saisie

**Anti-patterns:**
1. **Clavier par defaut** — Forcer QWERTY sur 1.3" au lieu de proposer la voix
2. **Conversation entiere** — Charger 100 messages au lieu des 10 derniers
3. **Pas de smart reply** — Obliger l'utilisateur a taper chaque reponse

**Source:** [Wear OS Input](https://developer.android.com/training/wearables/user-input), [watchOS Text Input](https://developer.apple.com/design/human-interface-guidelines/text-fields), [NNGroup Watch Input](https://www.nngroup.com/articles/smartwatch-interactions/)

---

## AN. Fall Detection & Emergency SOS

> Patterns UX pour la detection de chute, crash, et activation SOS.
> Sources: [Apple Fall Detection](https://support.apple.com/en-us/108896), [Google Pixel Watch Safety](https://support.google.com/googlepixelwatch/answer/7633578), [Samsung Galaxy Watch Emergency](https://www.samsung.com/us/support/answer/ANS00082540/)

### 65. Fall Detection Flow

**Sequence UX apres detection de chute:**

| Etape | Temps | UX |
|-------|-------|----|
| 1. Detection | T+0 | Haptic forte (vibration continue 1s) + ecran allume |
| 2. Alerte | T+0s | "Chute detectee. Vous allez bien?" + timer 30s |
| 3. Countdown | T+0 → T+30s | Cercle progressif 30s, decroissant, rouge |
| 4a. Reponse OK | T+X (user tap) | "Je vais bien" → dismiss, log l'evenement |
| 4b. Pas de reponse | T+30s | Appel automatique urgences + notification contacts |
| 5. Appel urgences | T+30s | Sirene sonore 5s avant appel (alerte entourage) |
| 6. Partage position | T+30s | GPS envoye aux contacts d'urgence + services |

**Layout ecran fall detection:**
```
┌──────────────────┐
│                  │
│  ⚠️ Fall         │
│  Detected        │  ← Titre (20sp bold, couleur alerte)
│                  │
│    ⏱️ 23s        │  ← Timer countdown (40sp bold, rouge)
│                  │
│  [I'm OK]        │  ← Bouton large vert (52dp height)
│                  │
│  [Emergency SOS] │  ← Bouton rouge (appel immediat)
│                  │
│  Calling in 23s  │  ← Info (14sp)
└──────────────────┘
```

### 65b. Crash Detection (Car Accident)

**Specifique Apple Watch Ultra/S8+ et Pixel Watch 2+:**
- Accelerometre haute frequence (jusqu'a 256g)
- Detection impact severe → meme flow que fall avec timer 10s (plus court)
- Appel automatique au 112/911 si pas de reponse
- GPS haute precision envoye aux secours

### 65c. SOS Activation (Manual)

| Plateforme | Geste | Delai |
|-----------|-------|-------|
| watchOS | Long press side button (3s) | Slider "Emergency SOS" |
| Wear OS (Pixel Watch) | 5 pressions rapides bouton | Countdown 5s |
| Galaxy Watch | Long press Home + Back | Countdown 5s |

**Regle UX critique:** Le geste SOS ne doit JAMAIS etre accidentellement declenchable en usage normal. D'ou le long press ou multi-press.

### 65d. Emergency Contact Notification

**Contenu du message automatique:**
```
"[Nom] a declenche un appel d'urgence depuis sa montre.
Position: [GPS coords + adresse si disponible]
Heure: [timestamp]
Appel aux services d'urgence en cours."
```

- Envoye par SMS (fonctionne sans data)
- Mis a jour avec nouvelle position toutes les 10 minutes pendant 1h
- Contacts configures dans Health app (iPhone) ou Safety app (Pixel)

### 65e. Medical ID Display

**Accessible depuis le cadran (swipe ou long press power):**
- Nom, age, groupe sanguin
- Allergies, medicaments
- Conditions medicales
- Contacts d'urgence
- Pas de deverrouillage requis (information vitale)

### Platform Comparison

| Aspect | watchOS | Wear OS (Pixel) | Galaxy Watch |
|--------|---------|-----------------|-------------|
| Fall detection | Series 4+ | Pixel Watch 2+ | Watch 4+ |
| Crash detection | Series 8+/Ultra | Pixel Watch 2+ | ❌ |
| SOS geste | Long press side (3s) | 5x press | Long press Home+Back |
| Timer avant appel | 30s (fall), 10s (crash) | 30s | 30s |
| Medical ID | ✅ (Health app) | ✅ (Safety app) | ✅ (Samsung Health) |
| Sirene sonore | ✅ (Ultra) | ❌ | ❌ |
| Partage position | ✅ Auto | ✅ Auto | ✅ Auto |

### Checklist Emergency

- ✅ Timer visible et large (40sp min) avec countdown
- ✅ Bouton "I'm OK" accessible d'un seul tap (52dp)
- ✅ Appel automatique si pas de reponse (30s)
- ✅ GPS partage aux contacts d'urgence
- ✅ Medical ID accessible sans deverrouillage
- ✅ SOS fonctionne meme sans eSIM (appel urgences obligation legale)
- ❌ Ne jamais rendre le SOS plus difficile a activer que le geste standard
- ❌ Ne pas demander de confirmation supplementaire apres le timer
- ❌ Ne pas desactiver SOS pendant le mode avion

**Anti-patterns:**
1. **Timer trop court** — 10s pour une chute normale (faux positifs, appels inutiles au 112)
2. **Bouton cancel trop petit** — Utilisateur conscient mais ne trouve pas comment annuler
3. **Pas de feedback pre-appel** — L'appel part sans que l'utilisateur realise

**Source:** [Apple Fall Detection](https://support.apple.com/en-us/108896), [Pixel Watch Emergency](https://support.google.com/googlepixelwatch/answer/7633578), [Samsung Emergency SOS](https://www.samsung.com/us/support/answer/ANS00082540/)

---

## AO. watchOS 10+ Architectural Changes

> Changements architecturaux majeurs introduits dans watchOS 10 et implications UX.
> Sources: [Apple watchOS 10 Release Notes](https://developer.apple.com/documentation/watchos-release-notes/watchos-10-release-notes), [Apple HIG watchOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [WWDC23 Sessions](https://developer.apple.com/wwdc23/)

### 66. NavigationStack (remplacement de NavigationLink)

**Avant (watchOS 9 et avant):**
```swift
// DEPRECATED - NavigationLink avec destination directe
NavigationLink(destination: DetailView()) {
    Text("Go to Detail")
}
```

**Apres (watchOS 10+):**
```swift
// RECOMMANDE - NavigationStack avec path
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        ItemRow(item: item)
                    }
                }
            }
            .navigationDestination(for: Item.self) { item in
                DetailView(item: item)
            }
        }
    }
}
```

**Avantages:** Navigation programmatique, deep linking, state restoration, back stack gere automatiquement.

### 66b. TabView Vertical Pagination

**watchOS 10:** `TabView` utilise la pagination verticale (Digital Crown scroll) au lieu de swipe horizontal.

```swift
struct MainView: View {
    var body: some View {
        TabView {
            SummaryView()
                .containerBackground(.blue.gradient, for: .tabView)
            DetailView()
                .containerBackground(.green.gradient, for: .tabView)
            SettingsView()
                .containerBackground(.orange.gradient, for: .tabView)
        }
        .tabViewStyle(.verticalPage) // watchOS 10+
    }
}
```

**Implication:** Le swipe vertical entre pages est desormais le pattern principal de navigation de contenu. Le swipe horizontal est reserve a la navigation back.

### 66c. Full-Screen Background (.containerBackground)

**Nouveau pattern watchOS 10:** Chaque vue peut avoir un fond plein ecran colore.

```swift
.containerBackground(for: .tabView) {
    LinearGradient(
        colors: [.blue, .purple],
        startPoint: .top,
        endPoint: .bottom
    )
}
```

**Regles:**
- Fond couvre tout l'ecran (bords a bords, sous la barre de navigation)
- Utiliser des gradients subtils (pas d'images lourdes)
- Le contenu doit rester lisible sur le fond (contraste 4.5:1 minimum)

### 66d. Smart Stack (Scroll Up)

**watchOS 10:** Scroll vers le haut depuis le cadran → Smart Stack (widgets empiles).

**Implications pour les developpeurs:**
- Widgets utilisant `WidgetKit` (meme API que iPhone)
- Taille unique: plein ecran de la montre
- Contenu contextuel (heure, lieu, activite)
- `TimelineProvider` pour mise a jour periodique (15-60 min)
- `relevance` score pour priorite dans le stack

### 66e. Toolbar & Force Touch Removal

| Version | Interaction | Remplacement |
|---------|-------------|-------------|
| watchOS 6 et avant | Force Touch → menu contextuel | - |
| watchOS 7+ | Force Touch supprime | `.toolbar` items |
| watchOS 10+ | `.toolbar` dans NavigationStack | `.toolbar { ToolbarItem(placement:) }` |

```swift
.toolbar {
    ToolbarItem(placement: .topBarLeading) {
        Button(action: { /* settings */ }) {
            Image(systemName: "gear")
        }
    }
    ToolbarItem(placement: .topBarTrailing) {
        Button(action: { /* add */ }) {
            Image(systemName: "plus")
        }
    }
}
```

### 66f. Digital Crown as Primary Nav

**watchOS 10 hierarchy:**
1. Digital Crown = scroll vertical principal (navigation entre pages, listes)
2. Swipe horizontal gauche = back
3. Tap = selection
4. Side button = app switcher / Apple Pay
5. Crown press = home / Siri

### 66g. .navigationBarBackButtonHidden()

**Usage:** Cacher le bouton back par defaut quand la navigation custom est geree.

```swift
DetailView()
    .navigationBarBackButtonHidden(true)
    .toolbar {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
    }
```

**Attention:** Ne cacher le back button que si une action explicite (Cancel/Done) est fournie. L'utilisateur doit toujours pouvoir quitter.

### Checklist watchOS 10+

- ✅ Migrer `NavigationLink(destination:)` vers `NavigationStack` + `navigationDestination`
- ✅ Utiliser `.tabViewStyle(.verticalPage)` pour pagination
- ✅ Ajouter `.containerBackground()` pour fond plein ecran
- ✅ Supporter Smart Stack widgets si pertinent
- ✅ Remplacer Force Touch par toolbar items
- ✅ Digital Crown comme navigation verticale principale
- ❌ Ne pas utiliser swipe horizontal pour paginer (reserve au back)
- ❌ Ne pas cacher le back button sans alternative explicite
- ❌ Ne pas ignorer les changements de TabView (breaking change)

**Source:** [watchOS 10 Release Notes](https://developer.apple.com/documentation/watchos-release-notes/watchos-10-release-notes), [WWDC23 Design for watchOS 10](https://developer.apple.com/videos/play/wwdc2023/10138/), [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos)

---

## AP. Wear OS 4/5 Material 3 Migration

> Differences entre Wear OS 4 (API 33) et Wear OS 5 (API 34+), migration Material 2 vers Material 3.
> Sources: [Wear OS Release Notes](https://developer.android.com/wear/versions), [Compose for Wear OS M3](https://developer.android.com/training/wearables/compose), [Material 3 Wear](https://developer.android.com/design/ui/wear)

### 67. Wear OS 4 vs 5 Key Changes

| Aspect | Wear OS 4 (API 33) | Wear OS 5 (API 34+) |
|--------|--------------------|--------------------|
| Chipset minimum | Snapdragon W5/Exynos W920 | Idem |
| Watch Face Format | WFF 1.0 | WFF 2.0 (plus de complications, animations) |
| Permission model | Runtime permissions | Stricter background restrictions |
| Health Services | 1.0 stable | 1.1+ (new data types: skin temp) |
| Tiles API | Tiles 1.2 | Tiles 1.4 (layout amélioré) |
| Background limits | 30 min max foreground service sans notification | Stricter: 10 min, doit utiliser Ongoing Activity |
| Ambient mode | Always-On via `AmbientModeSupport` | Deprecated → use `AmbientLifecycleObserver` |

### 67b. M2 → M3 Component Mapping

| Material 2 (Wear Compose) | Material 3 (Wear Compose) | Notes |
|---------------------------|--------------------------|-------|
| `androidx.wear.compose.material.Button` | `androidx.wear.compose.material3.Button` | API quasi identique |
| `Chip` | `Button` (filled) / `OutlinedButton` | Renomme |
| `AppCard` / `TitleCard` | `Card` variants | Simplifie |
| `ToggleChip` | `ToggleButton` | Renomme |
| `ScalingLazyColumn` | `TransformingLazyColumn` | Nouveau! Animations integrées |
| `TimeText` | `TimeText` (M3 version) | Edge-aware |
| `SwipeToDismissBox` | `SwipeToDismissBox` (M3) | Meme pattern |
| `PositionIndicator` | `ScrollIndicator` | Renomme |
| `Picker` | `Picker` (M3) | Style mis a jour |
| `Dialog` | `AlertDialog` / `ConfirmationDialog` | Separes |
| `MaterialTheme` | `MaterialTheme` (M3) | Nouveau color scheme |

### 67c. TransformingLazyColumn (Remplacement de ScalingLazyColumn)

```kotlin
// Material 3 - TransformingLazyColumn
import androidx.wear.compose.material3.lazy.TransformingLazyColumn
import androidx.wear.compose.material3.lazy.rememberTransformingLazyColumnState

@Composable
fun M3List() {
    val state = rememberTransformingLazyColumnState()
    TransformingLazyColumn(
        state = state,
        modifier = Modifier.fillMaxSize()
    ) {
        items(20) { index ->
            Button(
                onClick = { /* action */ },
                label = { Text("Item $index") },
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}
```

**Avantages vs ScalingLazyColumn:** Animations de morphing integrees (les items se transforment en entrant/sortant du viewport), meilleure performance de scroll.

### 67d. Color Scheme M3

```kotlin
// Material 3 Wear OS color theme
val WearColorScheme = ColorScheme(
    primary = Color(0xFFD0BCFF),       // Violet clair
    onPrimary = Color(0xFF381E72),
    primaryContainer = Color(0xFF4F378B),
    secondary = Color(0xFFCCC2DC),
    onSecondary = Color(0xFF332D41),
    surface = Color(0xFF1C1B1F),       // Presque noir
    onSurface = Color(0xFFE6E1E5),
    error = Color(0xFFF2B8B5),
    onError = Color(0xFF601410),
    background = Color(0xFF000000)     // Noir pur AMOLED
)
```

### 67e. Permission Changes (Wear OS 5)

| Permission | Wear OS 4 | Wear OS 5 |
|-----------|-----------|-----------|
| `BODY_SENSORS` | Runtime | Runtime + foreground-only par defaut |
| `ACTIVITY_RECOGNITION` | Runtime | Runtime |
| `ACCESS_FINE_LOCATION` | Runtime | Runtime + background location stricter |
| `POST_NOTIFICATIONS` | Runtime (API 33+) | Runtime |
| Foreground service type | Requis | Requis + type declaration obligatoire |

```xml
<!-- Wear OS 5: Declarer le type de foreground service -->
<service
    android:name=".ExerciseService"
    android:foregroundServiceType="health|location"
    android:exported="false" />
```

### 67f. Watch Face Format (WFF) 2.0

**Nouveautes WFF 2.0 (Wear OS 5):**
- Animations Lottie dans les complications
- Plus de slots de complication (jusqu'a 8)
- Support des themes dynamiques (couleur de la montre)
- Interactivite: tap sur complications avec data binding

### Checklist Migration M3

- ✅ Remplacer imports `material` par `material3`
- ✅ Migrer `ScalingLazyColumn` → `TransformingLazyColumn`
- ✅ Migrer `Chip` → `Button` / `OutlinedButton`
- ✅ Migrer `ToggleChip` → `ToggleButton`
- ✅ Mettre a jour `ColorScheme` vers les tokens M3
- ✅ Declarer `foregroundServiceType` pour tous les services
- ✅ Utiliser `AmbientLifecycleObserver` au lieu de `AmbientModeSupport`
- ❌ Ne pas mixer M2 et M3 dans la meme app (conflits de theme)
- ❌ Ne pas ignorer les restrictions background Wear OS 5
- ❌ Ne pas utiliser `ScalingLazyColumn` dans un nouveau projet

**Source:** [Wear OS 5 Changes](https://developer.android.com/wear/versions), [Compose Material 3 Wear](https://developer.android.com/training/wearables/compose), [WFF 2.0](https://developer.android.com/training/wearables/watch-faces/format)

---

## AQ. Circular vs Rectangular Screen

> Differences de layout entre les ecrans ronds (Wear OS) et rectangulaires arrondis (watchOS).
> Sources: [Wear OS Layout](https://developer.android.com/training/wearables/compose/layouts), [Apple HIG Layout](https://developer.apple.com/design/human-interface-guidelines/layout), [Samsung One UI Watch](https://developer.samsung.com/one-ui-watch)

### 68. Usable Area Comparison

| Forme | Usable area vs total | Probleme principal |
|-------|---------------------|--------------------|
| Rond (Wear OS) | ~78% (cercle inscrit dans carre) | Coins perdus (~22%) |
| Rect arrondi (watchOS) | ~92% (petits coins arrondis) | Plus de contenu, mais plus etroit |
| Carre arrondi (Fitbit) | ~88% | Compromis |

**Zone safe pour rond (ecran 450x450 px):**
- Cercle inscrit: 318x318 px de contenu sans clipping
- Avec marges 5.2%: zone utile ~280x280 px au centre
- Texte long: max ~18-20 caracteres avant troncature

### 68b. Content Reflow Rules

| Element | Ecran rond | Ecran rectangulaire |
|---------|-----------|-------------------|
| Titre centre | ✅ (naturel) | ✅ |
| Texte multi-lignes | ⚠️ Lignes courtes au bord, longues au centre | ✅ Largeur constante |
| Liste | Items plus courts en haut/bas (ScalingLazyColumn) | Items largeur constante |
| Boutons pleine largeur | Arrondir les bords pour suivre le cercle | Rectangle pleine largeur |
| Image plein ecran | Crop circulaire ou vignette | Plein ecran rectangle |
| Barre de progression | Arc circulaire (CircularProgressIndicator) | Lineaire en bas |

### 68c. Layout Comparison Side-by-Side

**Ecran rond (Wear OS):**
```
       ╭──────────╮
      ╱            ╲
    ╱   12:45 PM     ╲      ← TimeText en arc
   │                   │
   │    Main Content   │    ← Centre: contenu principal
   │                   │
    ╲   [Button]     ╱      ← Bouton adapt au cercle
      ╲            ╱
       ╰──────────╯
```

**Ecran rectangulaire (watchOS):**
```
┌──────────────────┐
│ 12:45 PM         │    ← TimeText lineaire haut-gauche
│                  │
│  Main Content    │    ← Contenu avec marges 16px
│                  │
│  [Button]        │    ← Bouton pleine largeur
│                  │
└──────────────────┘
```

### 68d. List Item Differences

**Rond:** `ScalingLazyColumn` / `TransformingLazyColumn` — les items sont reduits et decales pres des bords (haut/bas). Padding dynamique selon la position Y.

**Rectangulaire:** `List` standard — tous les items ont la meme largeur et taille. Pas de scaling.

```kotlin
// Wear OS rond - marges automatiques
TransformingLazyColumn(
    contentPadding = PaddingValues(
        top = 40.dp,    // espace pour TimeText + bord rond
        bottom = 40.dp, // espace bord rond bas
        start = 10.dp,
        end = 10.dp
    )
)
```

```swift
// watchOS rectangulaire - marges standard
List {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}
.listStyle(.carousel) // ou .plain
```

### 68e. Complication Slot Positioning

| Position | Rond | Rectangulaire |
|----------|------|--------------|
| Top | Centre-haut du cercle | Haut-centre |
| Bottom | Centre-bas du cercle | Bas-centre |
| Left/Right | Flancs du cercle (souvent petit) | Cotes (plus d'espace) |
| Center | Centre (grand) | Centre (grand) |
| Corners | ❌ Zone perdue | ✅ 4 coins utilisables |
| Max slots (watch face) | 4-6 typique, 8 max | 4-8 selon design |

### 68f. Asset Preparation

| Approche | Avantage | Inconvenient |
|----------|----------|------------|
| Asset unique + masque circulaire | Un seul fichier | Perte de contenu dans les coins |
| Assets par forme (round/rect) | Optimise pour chaque ecran | Double travail de design |
| Assets vectoriels (SVG/VectorDrawable) | Scale parfait, un fichier | Pas pour les photos |

**Regle:** Pour les icones et illustrations, utiliser des assets vectoriels. Pour les photos et pochettes album, utiliser un asset carre et laisser le systeme cropper (circulaire ou rectangulaire).

### Checklist Screen Shape

- ✅ Tester sur ecran rond ET rectangulaire
- ✅ Marges en pourcentage (pas dp fixes) pour les ecrans ronds
- ✅ `ScalingLazyColumn` / `TransformingLazyColumn` pour les listes rondes
- ✅ Contenu centre sur ecran rond (pas aligne a gauche)
- ✅ Assets vectoriels quand possible
- ❌ Ne pas placer de contenu critique dans les coins (ecran rond)
- ❌ Ne pas supposer une largeur constante pour le texte (rond = variable)
- ❌ Ne pas utiliser le meme layout pixel-perfect pour les deux formes

**Anti-patterns:**
1. **Layout rectangulaire force sur rond** — Texte coupe dans les coins, boutons caches
2. **Ignorer le scaling** — Listes sans scaling = items hauts coupes en haut/bas rond
3. **Assets raster non-adaptees** — Photo carree avec coins noirs sur ecran rond

**Source:** [Wear OS Screens](https://developer.android.com/training/wearables/compose/layouts), [Apple HIG Layout](https://developer.apple.com/design/human-interface-guidelines/layout)

---

## AR. Animation Constraints on Watch

> Limites d'animation sur montre connectee (performance, batterie, accessibilite).
> Sources: [Wear OS Performance](https://developer.android.com/training/wearables/performance), [Apple HIG Motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Lottie](https://airbnb.io/lottie/)

### 69. Performance Budget

| Contrainte | Valeur | Notes |
|------------|--------|-------|
| Frame rate interactif | 60 FPS (16.6ms/frame) | Objectif, rarement atteint sur Wear OS |
| Frame rate realiste | 30 FPS (33.3ms/frame) | Acceptable pour la plupart des animations |
| Frame rate low-power | 10-15 FPS | Mode ambiant / economie batterie |
| Animations simultanees max | 2-3 | Au-dela: jank (frames dropped) |
| GPU RAM | 128-256 MB partagee | Animations lourdes = OOM risk |
| CPU budget animation | ~5-8ms par frame | Le reste pour layout + logic |

### 69b. Duration Guidelines

| Type d'animation | Duree recommandee | Max absolu |
|-----------------|-------------------|-----------|
| Micro-interaction (tap feedback) | 100-150ms | 200ms |
| Transition entre ecrans | 200-300ms | 500ms |
| Loading spinner | Continu, mais low-FPS (15fps) | - |
| Success checkmark | 300-400ms | 600ms |
| Page transition | 250-350ms | 500ms |
| Morphing (FAB → screen) | 300-500ms | 500ms |
| Ambient mode transition | 150ms | 200ms |

**Easing recommande:**
- Entree: `FastOutSlowInInterpolator` / `.easeOut`
- Sortie: `FastOutLinearInInterpolator` / `.easeIn`
- Standard: `FastOutSlowInInterpolator` (Material)

### 69c. Lottie on Watch

**Contraintes Lottie pour Tiles:**

| Propriete | Limite |
|-----------|--------|
| Taille fichier JSON | < 50 KB |
| Dimensions | ≤ 200x200 dp |
| Frames | ≤ 60 frames |
| Layers | ≤ 5 layers |
| Effets (blur, shadow) | ❌ Non supportes |
| Expressions | ❌ Non supportees |
| Format | JSON (pas dotLottie) |

**Wear OS Tiles Lottie:**
```kotlin
// Dans le layout de Tile
Image.Builder()
    .setResourceId("anim_success")
    .setWidth(dp(48f))
    .setHeight(dp(48f))
    .build()

// Dans le ResourcesProvider
override fun onTileResourcesRequest(request: ResourcesRequest) =
    Resources.Builder()
        .addIdToImageMapping("anim_success",
            ImageResource.Builder()
                .setAndroidAnimatedImageResourceByResId(R.raw.success_anim)
                .build()
        )
        .build()
```

### 69d. Ambient Mode — No Animation (Hard Rule)

**Regle absolue:** En mode ambient (always-on display), ZERO animation. Raisons:
1. Burn-in OLED (pixels statiques alternent, mais animation = pixels constants)
2. Batterie: 1 FPS max en ambient
3. Guidelines Google/Apple: ecran ambient = statique

**Contenu ambient:**
- Heure (mise a jour 1x/min)
- Donnees statiques (pas de barre de progression animee)
- Couleurs: blanc/gris sur noir, pas de couleurs vives
- Anti burn-in: deplacer le contenu de 1-2px periodiquement

### 69e. Reduce Motion Detection

**Wear OS:**
```kotlin
val isReduceMotionEnabled = Settings.Global.getFloat(
    contentResolver,
    Settings.Global.ANIMATOR_DURATION_SCALE,
    1f
) == 0f

// Si reduce motion: remplacer animations par des transitions instantanees
```

**watchOS:**
```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var body: some View {
    if reduceMotion {
        content.transition(.opacity) // fade simple
    } else {
        content.transition(.slide.combined(with: .opacity))
    }
}
```

**Regle:** Toujours respecter `Reduce Motion`. Remplacer les animations par des fades simples (150ms opacity) ou des transitions instantanees.

### 69f. Animation Comparison

| Aspect | Wear OS | watchOS |
|--------|---------|---------|
| Framework | Compose animations / Lottie | SwiftUI animations / Core Animation |
| Lottie support | Tiles (limite) + Compose (full) | Lottie-iOS (full) |
| Ambient mode | Aucune animation | Aucune animation |
| Reduce Motion | `ANIMATOR_DURATION_SCALE` | `accessibilityReduceMotion` |
| Transition par defaut | 300ms ease-in-out | 350ms spring |
| Max simultanées | 2-3 recommande | 3-4 (hardware plus puissant) |

### Checklist Animations

- ✅ Micro-interactions: 100-150ms
- ✅ Transitions: 200-300ms max
- ✅ Max 2-3 animations simultanees
- ✅ Lottie < 50KB, ≤ 5 layers pour Tiles
- ✅ Zero animation en ambient mode
- ✅ Respecter Reduce Motion
- ✅ Tester sur device reel (emulateur masque les jank)
- ❌ Ne pas depasser 500ms pour une transition
- ❌ Ne pas utiliser de blur/shadow dans les animations watch
- ❌ Ne pas animer en ambient (burn-in + batterie)

**Anti-patterns:**
1. **Animation 60fps constante** — Vide la batterie, chauffe le poignet
2. **Lottie 500KB** — Crash memoire sur les montres d'entree de gamme
3. **Animation en ambient** — Burn-in OLED garanti en quelques semaines

**Source:** [Wear OS Performance](https://developer.android.com/training/wearables/performance), [Apple HIG Motion](https://developer.apple.com/design/human-interface-guidelines/motion), [Lottie for Android](https://airbnb.io/lottie/#/android)

---

## AS. Charging & Dock Mode

> Comportement UX quand la montre est en charge ou en mode dock/nightstand.
> Sources: [Apple Nightstand Mode](https://support.apple.com/guide/watch/charge-apple-watch-apdab4c27498/watchos), [Wear OS Charging](https://developer.android.com/training/wearables)

### 70. Charging Screen Layout

**Informations affichees pendant la charge:**

| Element | Taille | Position |
|---------|--------|----------|
| Pourcentage batterie | 40-48 sp bold | Centre |
| Heure actuelle | 20-24 sp | Haut |
| Temps restant ("Full in ~45 min") | 14 sp, 60% opacite | Sous le pourcentage |
| Animation charge | Arc circulaire vert progressif | Autour du pourcentage |
| Prochaine alarme | 14 sp | Bas |

**Layout:**
```
┌──────────────────┐
│     10:45 PM     │  ← Heure
│                  │
│    ╭───────╮     │
│    │  73%  │     │  ← Pourcentage dans arc
│    ╰───────╯     │
│  Full in ~45 min │  ← ETA
│                  │
│  ⏰ Alarm 7:00   │  ← Prochaine alarme
└──────────────────┘
```

### 70b. Nightstand / Dock Mode

**Apple Watch Nightstand Mode:**
- Montre posee sur le cote sur le chargeur
- Affiche: heure en grand, date, prochaine alarme
- Ecran dim (luminosite niveau 1)
- Tap ou Crown press = afficher l'heure brievement (5s)
- Alarme: boutons Snooze (tap ecran) et Stop (side button ou crown)

**Wear OS Dock/Bedside Mode:**
- Moins standardise (depend du fabricant)
- Samsung: Goodnight mode (DND + ecran eteint)
- Pixel Watch: affiche heure + charge en mode always-on dim

### 70c. Charging Brightness & Color

| Aspect | Valeur |
|--------|--------|
| Luminosite ecran charge (nuit) | ≤ 10% / niveau 1 |
| Couleur dominante | Gris fonce / rouge sombre (pas de bleu) |
| AMOLED | Max 10% des pixels allumes |
| Mise a jour ecran | 1x/min (heure) ou 1x/5min (batterie %) |
| Timeout ecran | 10s apres interaction, puis dim/off |

### 70d. Charging Animation

**Pattern arc circulaire:**
- Arc vert (#4CAF50) progressif de 0° a 360° selon le % batterie
- Animation lente: l'arc "pulse" legerement (opacite 80-100%, 2s cycle)
- A 100%: arc complet + checkmark vert + "Fully Charged"
- Pas d'animation complexe (Lottie inutile, simple arc suffit)

### 70e. "Ready to Use" at 80%

**Pattern recommande:**
- A 80%: notification haptic (si portee) ou ecran "Ready to go — 80%"
- Raison: la charge 80-100% est lente (trickle charge), et 80% suffit pour une journee
- Apple le fait deja avec "Optimized Battery Charging" (plafonne a 80% la nuit)

### Platform Comparison

| Aspect | watchOS | Wear OS |
|--------|---------|---------|
| Nightstand mode | ✅ Natif (orientation paysage) | ⚠️ Depend du fabricant |
| Ecran pendant charge | Heure + % + alarme | Heure + % (variable) |
| Snooze alarme dock | Tap ecran | ❌ Pas standardise |
| Charge optimisee (80%) | ✅ Natif | ✅ (Pixel Watch, Samsung) |
| Photo frame mode | ❌ | ❌ (pas de standard montre) |

### Checklist Charge & Dock

- ✅ Afficher % batterie en grand, lisible
- ✅ ETA de charge complete
- ✅ Luminosite minimale (nuit = dim)
- ✅ Prochaine alarme visible
- ✅ Animation charge subtile (arc progressif, pas de Lottie lourd)
- ❌ Ne pas afficher l'ecran a pleine luminosite pendant la charge de nuit
- ❌ Ne pas jouer des sons/haptics pendant la charge (sauf alarme)
- ❌ Ne pas animer a plus de 1 FPS en mode dock

**Anti-patterns:**
1. **Ecran brillant la nuit** — Montre sur la table de nuit qui illumine la chambre
2. **Pas d'ETA** — "73%" sans savoir quand ca sera pret
3. **Animation gourmande pendant charge** — Ralentit la charge et chauffe l'appareil

**Source:** [Apple Nightstand](https://support.apple.com/guide/watch/), [Wear OS Power](https://developer.android.com/training/wearables/performance)

---

## AT. Water Lock Mode

> Activation, desactivation et UX du mode aquatique (protection ecran tactile).
> Sources: [Apple Water Lock](https://support.apple.com/guide/watch/water-lock-apd4e3a8e9d0/watchos), [Samsung Water Lock](https://www.samsung.com/us/support/troubleshooting/TSG01203568/)

### 71. Activation / Deactivation Flow

**Activation:**

| Plateforme | Methode | Automatique? |
|------------|---------|-------------|
| watchOS | Control Center → icone goutte d'eau | Auto pendant nage (Workout) |
| Wear OS (Samsung) | Quick settings → Water Lock | Auto pendant nage (Samsung Health) |
| Wear OS (Pixel) | Quick settings → Water Lock | Auto pendant nage |

**Desactivation:**

| Plateforme | Methode | Feedback |
|------------|---------|----------|
| watchOS | Tourner la Digital Crown (multi-tours) | Haptic + son d'ejection d'eau (speaker) |
| Wear OS (Samsung) | Long press Home button (2s) | Haptic confirmation |
| Wear OS (Pixel) | Long press crown | Haptic confirmation |

### 71b. Water Ejection (Apple Watch)

**Fonctionnement unique Apple Watch:**
- Le speaker emet un son a frequence specifique (~165 Hz) qui expulse l'eau par vibration
- L'utilisateur voit une animation d'onde sonore
- Dure ~3 secondes
- Patent Apple, non disponible sur Wear OS

**Code watchOS (activation programmatique):**
```swift
import WatchKit

WKInterfaceDevice.current().enableWaterLock()
// L'ecran tactile est desactive
// L'utilisateur doit tourner la Digital Crown pour deverrouiller
```

### 71c. Touchscreen Disabled Indicator

**Ecran pendant Water Lock:**
```
┌──────────────────┐
│                  │
│     💧           │  ← Icone goutte d'eau (grande, centre)
│                  │
│  Water Lock On   │  ← Label (16sp)
│                  │
│  Turn Crown to   │  ← Instructions (14sp)
│    unlock        │
│                  │
└──────────────────┘
```

**Regle:** L'ecran affiche clairement que le tactile est desactive et comment le reactiver. Les taps sur l'ecran ne font RIEN (pas meme allumer l'ecran).

### 71d. Physical Button-Only Control Model

**Pendant Water Lock, seuls les boutons physiques fonctionnent:**

| Action | Bouton |
|--------|--------|
| Voir l'heure | Raise-to-wake (si active) ou press Crown |
| Mettre en pause (workout) | Side button (watchOS) / Home button (Wear OS) |
| Arreter le workout | ❌ Pas possible en Water Lock — deverrouiller d'abord |
| Prendre un lap | Side button double-press (watchOS pendant workout) |
| SOS | Long press side button fonctionne TOUJOURS |

### 71e. Auto Water Lock During Swim

**Comportement:**
- Demarrer un workout "Natation" → Water Lock active automatiquement
- Pause entre les sets: Water Lock reste actif
- Fin du workout: Water Lock desactive automatiquement + ejection eau (Apple)
- Samsung / Pixel: prompt "Desactiver Water Lock?"

### Platform Comparison

| Aspect | watchOS | Wear OS (Samsung) | Wear OS (Pixel) |
|--------|---------|-------------------|-----------------|
| Activation | Control Center / auto swim | Quick settings / auto | Quick settings / auto |
| Desactivation | Crown rotation | Long press Home | Long press crown |
| Ejection eau (speaker) | ✅ Son + vibration | ❌ | ❌ |
| SOS pendant Water Lock | ✅ Toujours | ✅ Toujours | ✅ Toujours |
| Resistance eau | WR50 (50m) | IP68 / 5ATM | 5ATM |
| Bezel pendant lock | N/A (pas de bezel) | ❌ Desactive | N/A |

### Checklist Water Lock

- ✅ Icone goutte d'eau claire sur l'ecran
- ✅ Instructions de devrouillage visibles
- ✅ Auto-activation pendant les workouts aquatiques
- ✅ Boutons physiques restent fonctionnels (sauf tactile/bezel)
- ✅ SOS toujours accessible meme en Water Lock
- ❌ Ne pas permettre des interactions tactiles accidentelles sous l'eau
- ❌ Ne pas bloquer le SOS pendant Water Lock
- ❌ Ne pas oublier le feedback de desactivation (haptic obligatoire)

**Anti-patterns:**
1. **Water Lock sans feedback** — L'utilisateur ne sait pas si c'est actif ou pas
2. **Pas d'auto-lock nage** — L'utilisateur oublie d'activer et les touches d'eau changent les metriques
3. **Deverrouillage accidentel** — Geste trop simple = deverrouille dans l'eau

**Source:** [Apple Water Lock](https://support.apple.com/guide/watch/), [Samsung Water Lock](https://www.samsung.com/us/support/), [Water Resistance Ratings](https://www.iso.org/standard/83421.html)

---

## AU. Smart Home Control on Watch

> Patterns UX pour le controle domotique depuis la montre connectee.
> Sources: [Google Home Wear OS](https://developers.home.google.com/), [Apple HomeKit Watch](https://developer.apple.com/documentation/homekit), [Samsung SmartThings](https://developer.samsung.com/smartthings)

### 72. Device List Layout

**Organisation recommandee:**

| Approche | Quand l'utiliser |
|----------|-----------------|
| Par piece (Room) | > 10 appareils, maison structuree |
| Par categorie (Lights, Locks, Thermostat) | < 10 appareils ou categorie unique |
| Favoris en premier | Toujours (max 4-6 favoris en haut) |

**Layout liste:**
```
┌──────────────────┐
│  🏠 Home         │  ← Titre
├──────────────────┤
│  ★ Quick Actions │  ← Section favoris
│  💡 Living Room  │  On  ← Toggle inline
│  🔒 Front Door  │  Locked ← Status
├──────────────────┤
│  📍 Living Room  │  ← Par piece
│  💡 Lamp 1       │  Off
│  💡 Lamp 2       │  On
│  📍 Bedroom      │
│  💡 Bedside      │  Off
└──────────────────┘
```

### 72b. Toggle Patterns

| Appareil | Interaction | Feedback | Latence attendue |
|----------|-------------|----------|-----------------|
| Lumiere on/off | Tap toggle | Haptic + icone change | 1-2s (cloud) |
| Lumiere intensite | Crown/bezel rotation | Pourcentage en temps reel | 200-500ms (local) |
| Serrure lock/unlock | Tap + confirmation | "Etes-vous sur?" dialog | 2-3s (cloud) |
| Thermostat temp | Crown/bezel rotation | Temperature affichee | 1-3s |
| Volet roulant | Tap up/stop/down | Animation position | 1-5s |
| Camera | Tap → live preview (si supporte) | Preview stream | 3-5s |

**Regle securite:** Les actions irreversibles ou de securite (deverrouiller porte, ouvrir garage) doivent TOUJOURS demander confirmation.

### 72c. Scene Activation (One-Tap Presets)

**Exemples de scenes:**
- "Bonne nuit" → eteindre toutes les lumieres, verrouiller portes, thermostat 18°C
- "Je pars" → tout eteindre, alarme on
- "Film" → lumieres salon a 20%, TV on

**Layout scene:**
- Bouton large (pleine largeur, 52dp height)
- Icone + nom de la scene
- Tap → execution immediate + haptic confirmation
- Pas de confirmation (la scene est reversible)

### 72d. Status Indicators

| Etat | Icone | Couleur |
|------|-------|---------|
| On / Allume | Icone plein | Jaune (#FFD54F) pour lumieres, Vert pour autres |
## AV. Camera Remote Control

> Patterns UX pour le controle de camera a distance depuis la montre.
> Sources: [Apple Camera Remote](https://support.apple.com/guide/watch/take-photos-with-camera-remote-apd3a84e6e6d/watchos), [Wear OS Camera](https://developer.android.com/training/wearables)

### 73. Viewfinder Preview

**Contraintes du flux video:**

| Aspect | Valeur |
|--------|--------|
| Resolution preview | 160x160 dp (rond) / 180x140 dp (rect) |
| Frame rate stream | 10-15 FPS (suffisant pour cadrage) |
| Latence BT | 100-300ms (acceptable) |
| Latence WiFi | 50-150ms |
| Qualite JPEG stream | 30-50% (economie bande passante) |

**Layout:**
```
┌──────────────────┐
│  ┌──────────┐    │
│  │ Preview  │    │  ← Flux camera (centre, 70% largeur)
│  │  Stream  │    │
│  └──────────┘    │
│                  │
│     ⏱ 3s        │  ← Timer (optionnel, 14sp)
│                  │
│    ( 📷 )       │  ← Bouton shutter (64dp, centre-bas)
│                  │
│  🔄  💡         │  ← Front/back + Flash (petits, 32dp)
└──────────────────┘
```

### 73b. Shutter Button

| Aspect | Specification |
|--------|--------------|
| Taille | 64 dp diametre (tap target) |
| Position | Centre-bas de l'ecran |
| Icone | Cercle blanc avec bordure (pattern camera universel) |
| Feedback tap | Haptic `CLICK` + flash blanc 100ms sur preview |
| Feedback photo prise | Haptic `SUCCESS` + thumbnail 2s |
| Etat desactive | Gris 50%, pendant processing |

### 73c. Timer Countdown

**Options:** Off / 3s / 10s

**UX countdown:**
1. Tap shutter avec timer active
2. Ecran: gros chiffre centre (48sp bold), decompte 3...2...1
3. Haptic chaque seconde (`CLICK`)
4. Flash ecran blanc a 0 + photo prise
5. Preview thumbnail 2s

### 73d. Controls Secondaires

| Controle | Icone | Position | Tap target |
|----------|-------|----------|-----------|
| Front/Back camera | 🔄 | Bas-gauche | 40dp |
| Flash on/off/auto | ⚡ | Bas-droite | 40dp |
| Timer | ⏱ | Haut-droite | 36dp |
| Dernieres photos | Thumbnail | Haut-gauche | 36dp |

### 73e. Video Recording

**Indicateur enregistrement:**
- Point rouge (●) clignotant (1Hz) en haut a gauche (8dp)
- Timer d'enregistrement: "00:42" (16sp, rouge)
- Bouton stop: carre rouge (52dp) remplace le shutter

### 73f. Photo Review

- Apres la prise: thumbnail apparait en bas-gauche (32dp rond)
- Tap thumbnail → plein ecran (zoom non recommande sur montre)
- Swipe pour voir les dernieres photos (max 5-10 en cache)
- "Voir tout sur le telephone" en fin de liste

### Platform Comparison

| Aspect | watchOS | Wear OS |
|--------|---------|---------|
| App native | Camera Remote (native) | Pas d'app native universelle |
| Preview stream | ✅ WiFi/BT | App tierce necessaire |
| Shutter | ✅ + timer 3s/10s | Via app tierce |
| Front/back toggle | ✅ | Via app tierce |
| Flash control | ✅ | Via app tierce |
| Video | ❌ (photo only, native) | Via app tierce |
| Live Photo | ✅ | ❌ |

### Checklist Camera Remote

- ✅ Bouton shutter large et centre (64dp)
- ✅ Preview basse resolution suffisante (10-15 FPS)
- ✅ Haptic + flash visuel a la prise de photo
- ✅ Timer countdown avec decompte haptic
- ✅ Thumbnail review accessible rapidement
- ❌ Ne pas streamer en haute resolution (batterie + bande passante)
- ❌ Ne pas proposer d'edition photo sur la montre
- ❌ Ne pas encombrer l'ecran avec trop de controles

**Anti-patterns:**
1. **Preview HD** — Stream 1080p sur une montre 1.3" = batterie morte en 15 min
2. **Shutter minuscule** — Bouton 32dp pour la fonction principale
3. **Pas de feedback** — Photo prise sans haptic ni flash, incertitude

**Source:** [Apple Camera Remote](https://support.apple.com/guide/watch/), [Wear OS Data Layer](https://developer.android.com/training/wearables/data/data-layer)

---

## AW. Data Density Limits (Consolidated Reference)

> Reference consolidee des limites de contenu par composant sur ecran de montre.
> Sources: [Wear OS Complications](https://developer.android.com/training/wearables/watch-faces/complications), [Apple ClockKit](https://developer.apple.com/documentation/clockkit), [Wear OS Tiles](https://developer.android.com/training/wearables/tiles), [Material Design Wear](https://developer.android.com/design/ui/wear)

### 74. Text Length Limits per Component

| Composant | Max caracteres | Notes |
|-----------|---------------|-------|
| **Complication SHORT_TEXT** | 7 | Chiffres/acronymes ("12:45", "85bpm", "Mon") |
| **Complication LONG_TEXT** | ~20-25 | Phrase courte ("Meeting at 3pm") |
| **Complication RANGED_VALUE** | Label: 7, value text: 5 | Arc + texte court |
| **Tile primary text** | ~20-25 | 1 ligne, 16sp |
| **Tile secondary text** | ~30-35 | 1-2 lignes, 14sp |
| **Notification title (collapsed)** | ~25-30 | Avant ellipsis dans le flux |
| **Notification body (collapsed)** | ~40-50 | Preview 1-2 lignes |
| **Notification body (expanded)** | ~200 | Scroll vertical |
| **List item primary label** | ~18-22 (rond), ~25-30 (rect) | 1 ligne, 16sp |
| **List item secondary label** | ~25-30 (rond), ~35-40 (rect) | 1 ligne, 14sp, dim |
| **Button label** | ~12-15 | 1 ligne, 14sp |
| **Chip label** | ~15-18 | 1 ligne, 14sp |
| **Dialog title** | ~20 | 1-2 lignes, 18sp |
| **Dialog body** | ~80-100 | Scrollable |
| **TimeText** | ~10-12 | "12:45 PM" ou custom status |

### 74b. Component Count Limits

| Element | Maximum recommande | Hard limit |
|---------|-------------------|-----------|
| **Actions par ecran** | 3 | 5 (surcharge cognitive au-dela de 3) |
| **Boutons par ecran** | 3 | 4 |
| **Items de liste visibles** | 5-7 (sans scroll) | ~15-20 total (scroll) |
| **Complications par watch face** | 4-6 (design typique) | 8 (max WFF) |
| **Tiles installees** | 5-7 (recommande) | ~10 (systeme) |
| **Quick settings toggles** | 6-8 visibles | ~12-15 (scroll) |
| **Notification actions** | 2-3 | 3 (Wear OS) / 4 (watchOS) |
| **Smart Reply suggestions** | 3 | 5 |
| **Pages dans pager horizontal** | 3-5 | ~8 (au-dela, inaccessible) |
| **Tab items (vertical, watchOS)** | 3-5 | ~10 |
| **Menu items** | 5-7 | ~10 |

### 74c. Visual Density Limits

| Metrique | Minimum recommande | Raison |
|----------|-------------------|--------|
| **Font size minimum** | 12 sp | Lisibilite a distance bras (25-35cm) |
| **Tap target minimum** | 48 dp (Google) / 44pt (Apple) | Precision doigt |
| **Spacing entre elements** | 8 dp minimum | Eviter les taps accidentels |
| **Icone minimum** | 24 dp (inline) / 32 dp (action) | Reconnaissance |
| **Contraste texte/fond** | 4.5:1 (AA) | Accessibilite WCAG |
| **Contraste grand texte** | 3:1 (AA) | Texte >= 18sp |
| **Lignes de texte max par ecran** | 5-7 (sans scroll) | Lisibilite |
| **Metriques de donnee par ecran** | 3-4 | Workout / sante |

### 74d. Image & Media Limits

| Type | Taille max recommandee | Format |
|------|----------------------|--------|
| Complication icon | 24x24 dp (tinted) | VectorDrawable / SF Symbol |
| Complication image (full) | Taille slot | PNG/WebP |
| Tile image | 200x200 dp max | WebP (compression) |
| Notification large icon | 64x64 dp | PNG |
| Notification big picture | 320x320 dp max | JPEG/WebP |
| Album art (Now Playing) | 80-100 dp | JPEG (quality 70%) |
| App icon | 48x48 dp (launcher) | Adaptive icon |
| Lottie animation (Tile) | < 50 KB, 200x200 dp | JSON |

### 74e. Temporal Limits

| Element | Duree/Frequence | Notes |
|---------|-----------------|-------|
| Notification on-screen | 8-10s puis queue | Ne pas depasser |
| Toast / confirmation | 2-3s auto-dismiss | `ConfirmationActivity` |
| Loading timeout | 5s max puis fallback | Ne pas faire attendre plus |
| Complication refresh | 15 min minimum (watchOS), ~10 min (Wear OS) | Limitation systeme |
| Tile refresh | 15-60 min | `TimelineProvider` / `TileService` |
| Animation max duration | 500ms transition | Voir section AR |
| Haptic notification | < 1s | 1-3 taps, pas de continu |
| Ambient screen update | 1x/min | Limitation systeme |

### 74f. Platform-Specific Hard Limits Summary

| Limite | Wear OS | watchOS |
|--------|---------|---------|
| Max Tiles | ~10 | N/A (widgets dans Smart Stack) |
| Max complications | 8 per face (WFF) | 8 per face |
| Max notification actions | 3 | 4 |
| Complication refresh | ~10 min | 15 min (budget) |
| Background runtime | 10 min (Wear OS 5) | 4-15 min (background tasks) |
| App storage | 100-500 MB (pratique) | 50-500 MB (pratique) |
| Tile layout depth | 10 niveaux max | N/A |

### 74g. Quick Reference Decision Table

| "Combien de X ?" | Reponse | Justification |
|-------------------|---------|---------------|
| Chars sur 1 ligne ? | 18-22 (rond), 25-30 (rect) | Largeur utile ecran |
| Boutons par ecran ? | 2-3 | Loi de Hick (temps de choix) |
| Items de liste ? | Max 15-20 | Au-dela, l'utilisateur abandonne |
| Metriques de workout ? | 3-4 par page | Lisibilite en mouvement |
| Couleurs distinctes ? | 5-6 max | Discrimination couleur poignet |
| Niveaux de navigation ? | 2-3 max | Retour fastidieux au-dela |
| Mots dans un label ? | 2-3 | Lecture rapide (glance) |
| Secondes d'interaction ? | < 10s idealement | Session montre = 5-10s median |

### Checklist Data Density

- ✅ SHORT_TEXT complication: max 7 chars
- ✅ Tap targets: 48dp minimum (44pt Apple)
- ✅ Font: jamais en dessous de 12sp
- ✅ Max 3 actions par ecran
- ✅ Max 4 metriques de donnee par ecran
- ✅ Tronquer texte avec ellipsis (pas de wrap multilignes pour les labels)
- ✅ Interaction totale < 10s par session
- ❌ Ne pas afficher un paragraphe de texte (renvoyer au phone)
- ❌ Ne pas depasser 3 niveaux de navigation
- ❌ Ne pas mettre 6+ boutons sur un ecran

**Anti-patterns:**
1. **Port du phone** — Copier l'UI mobile sur la montre (trop de contenu, trop petit)
2. **Texte long non tronque** — Le texte deborde ou wrap sur 4 lignes
3. **Dashboard de donnees** — 8 metriques, 3 graphes, 2 boutons sur 1.3"

**Source:** [Wear OS Complications Data](https://developer.android.com/training/wearables/watch-faces/complications), [Apple ClockKit](https://developer.apple.com/documentation/clockkit), [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality), [NNGroup Smartwatch](https://www.nngroup.com/articles/smartwatch-interactions/)

---

*Bible UX Wearable - Mise a jour mars 2026*
*Sources: [Android Developers](https://developer.android.com/wear), [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Samsung Developer](https://developer.samsung.com/one-ui-watch), [GSMArena](https://www.gsmarena.com), [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality), [Color Roles M3](https://developer.android.com/design/ui/wear/guides/styles/color/roles-tokens), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/), [Health Services API](https://developer.android.com/training/wearables/health-services), [Apple HealthKit](https://developer.apple.com/documentation/healthkit), [Matter Protocol](https://csa-iot.org/all-solutions/matter/)*
## AX. Medication Reminder UI

Medication reminders are a high-value wearable use case — the watch is always on the wrist at dosing time, and glanceability matters more than information density.

### Dose Scheduling Notification

```
┌──────────────────────┐
│      💊 10:00 AM     │
│                      │
│    Metformin 500mg   │
│                      │
│  [Take]  [Skip]     │
│       [Snooze]      │
└──────────────────────┘
```

Notification displays medication name, dose, and scheduled time. Three action buttons are the maximum for watch notifications — `Take` confirms adherence, `Skip` logs a missed dose with optional reason, `Snooze` reschedules +15 min (configurable, max 3 snoozes to prevent indefinite deferral). Use the `NotificationCompat.Action` (Wear OS) or `UNNotificationAction` (watchOS) APIs. Set category to alarm/reminder priority so it surfaces even in Do Not Disturb.

### Multi-Medication List

On screens 1.2–1.9 inches, display at most 3–4 medications per screen using a vertical scrolling list. Each row shows:

```
┌──────────────────────┐
│ ● Metformin  500mg   │  ← colored dot = category
│   10:00 AM  ✓ taken  │
├──────────────────────┤
│ ○ Lisinopril 10mg   │
│   10:00 AM  pending  │
├──────────────────────┤
│ ● Aspirin    81mg    │
│   12:00 PM  upcoming │
└──────────────────────┘
```

Group medications by time slot. Use color-coded dots (category), bold name, and a status badge (taken/pending/upcoming). Tapping a row opens the confirmation flow for that specific dose.

### Confirmation Flow

1. User taps `Take` → haptic confirmation (single strong tap) → brief "Taken ✓" overlay (1.5 s auto-dismiss).
2. User taps `Skip` → half-screen prompt "Reason?" with 3 canned responses (Forgot, Side effects, Doctor advised) + free-text via voice. Logged for adherence report.
3. Snooze → brief toast "+15 min" → notification reschedules silently.

### Adherence Tracking Visualization (Streak Calendar)

Display a 7-day strip on the watch (current week), full month view on phone:

```
┌──────────────────────┐
│   This Week           │
│ M  T  W  T  F  S  S │
│ ●  ●  ●  ◐  ○  ·  · │
│                      │
│ ● all taken  ◐ partial│
│ ○ missed     · future │
│ Streak: 3 days 🔥    │
└──────────────────────┘
```

Keep the visualization binary at the day level on-watch. Detailed per-dose breakdown lives on the phone companion.

### Platform APIs

- **Android (Health Connect):** `MedicationRecord` via `androidx.health.connect.client` — write adherence events with timestamp, dose, and medication reference.
- **watchOS (HealthKit):** As of watchOS 10+, no first-party medication API on-watch; sync adherence data to iPhone via `WCSession` and write to `HKClinicalRecord` or use custom `HKCategorySample` types. Apple Health medication tracking (iOS 16+) is read-only from third-party apps.

### Caregiver Notification Pattern

When a dose is missed (skip or no response within snooze window), optionally notify a designated caregiver via the phone companion app. Never send caregiver alerts directly from the watch — route through the phone to respect connectivity constraints and allow the phone app to batch/throttle notifications (max 1 alert per missed time-slot, not per medication).

---

## AY. Theater Mode UX

Theater mode (also called Cinema mode or Silent mode) suppresses all screen wake and sound output, intended for environments where any light or noise from the watch is disruptive.

### Behavior When Active

- **Raise-to-wake:** Disabled. Screen stays off on wrist raise.
- **Always-on display (AOD):** Disabled. Screen is fully off.
- **Notifications:** Delivered silently — no haptic, no sound, no screen wake. They queue in the notification shade for later review.
- **Touch:** Screen responds to deliberate touch (tap or button press) but remains off otherwise.
- **Alarms:** Platform-dependent. Wear OS silences alarms; watchOS still fires alarms with haptic only (user-configurable).

### Entry and Exit

- **Wear OS:** Swipe down to Quick Settings → tap the theater mode icon (mask/screen icon). Also available via `Settings > Display > Theater mode`. Exit by pressing the hardware button (crown or side button).
- **watchOS:** Swipe up to Control Center → tap the theater masks icon. Exit by tapping the screen then turning the Digital Crown, or by pressing the side button.

Provide a subtle visual indicator on the watch face when theater mode is active (small icon in status bar or complication slot) so the user remembers the mode is on.

### App Awareness

Apps should detect theater mode and suppress any custom wake or vibration logic:

- **Wear OS:** Check `NotificationManager.getCurrentInterruptionFilter()` — returns `INTERRUPTION_FILTER_NONE` or `INTERRUPTION_FILTER_ALARMS` during theater mode. Register a `NotificationManager.OnInterruptionFilterChangedListener` to react dynamically.
- **watchOS:** There is no public API to directly query theater mode. Use `WKApplicationDelegate.applicationWillResignActive()` as a proxy — theater mode triggers a resign-active event. Avoid scheduling `WKHapticType` feedback when the app is inactive.

Apps must NOT attempt to override theater mode by forcing screen wake (e.g., `FLAG_KEEP_SCREEN_ON`). Respect the user's explicit choice. If your app has a critical alert use case (e.g., medical alarm), use the platform's critical alert channel which operates independently of theater mode.

---

## AZ. Watch-to-Watch Communication

Direct communication between two smartwatches is heavily constrained by platform architecture. Both Wear OS and watchOS treat the watch as a peripheral to a phone, not as a peer-to-peer device.

### Platform Capabilities

| Capability | watchOS | Wear OS |
|---|---|---|
| Direct watch-to-watch API | No public API | No API |
| Walkie-Talkie | Apple-only, system app, not extensible by 3rd parties | N/A |
| Shared workouts | `HKWorkoutSession` with mirroring (watchOS 10+, same user only) | No equivalent |
| Relay via phone | `WCSession` → phone → internet → other phone → other watch | `MessageClient`/`DataClient` → phone → cloud → other phone → other watch |
| Relay via cloud | Watch → phone → server → push notification → other watch | Same |
| Bluetooth direct | No API for watch-to-watch BT | No API for watch-to-watch BT |
| Wi-Fi direct / NFC | Not available watch-to-watch | Not available watch-to-watch |

### Architectural Reality

All watch-to-watch communication must be relayed. The path is always:

`Watch A → Phone A → Cloud/Server → Phone B → Watch B`

Latency is typically 1–5 seconds end-to-end. This rules out real-time multiplayer gaming but works for messaging, status sharing, location pings, and async interactions.

### Family Setup (Managed Watches)

- **Apple Family Setup:** Child's Apple Watch paired to parent's iPhone. The child has no iPhone. Communication happens via Messages and FaceTime audio (system-level, not extensible).
- **Wear OS Family Setup (limited):** Some OEMs (Samsung) support child watch pairing to parent phone via Family Link. Third-party apps have limited access.

In both cases, the "watch-to-watch" communication between parent and child is mediated entirely by the parent's phone and cloud services.

### Design Guidance for Developers

1. **Do not attempt direct watch-to-watch protocols.** There is no supported API on any platform.
2. **Design for async.** Assume 2–5 s latency minimum. Show "sending..." states.
3. **Use push notifications** as the delivery mechanism to the remote watch. Keep payloads small (<4 KB).
4. **Degrade gracefully** when the relay phone is unreachable (e.g., phone is off). Queue messages and deliver when connectivity resumes.

---

## BA. Explicit N/A: Multi-Window and PiP on Watch

**Multi-window, picture-in-picture (PiP), split-screen, and floating window modes are not supported on any wearable platform — Wear OS, watchOS, or Samsung Tizen/One UI Watch.**

This is not an oversight; it is a deliberate platform constraint:

- **Screen size:** Watch displays range from 1.2" to 1.9" (368–466 px width). Splitting this area yields regions too small for any meaningful interaction or readability.
- **Interaction model:** Wearable sessions average under 10 seconds. The cognitive overhead of managing multiple windows exceeds the entire session duration.
- **Hardware constraints:** Wearable SoCs (e.g., Snapdragon W5, Apple S9) have limited GPU/memory budgets optimized for single full-screen rendering. Compositing multiple surfaces would degrade frame rate and battery life.
- **Platform enforcement:** Both `WindowManager` on Wear OS and `WKInterfaceController` on watchOS enforce single-activity, full-screen presentation. There is no API to request PiP or split modes.

**One app, one screen, always full-screen.** If your use case requires showing two data sources simultaneously (e.g., map + heart rate), composite them into a single unified layout within your app rather than attempting multi-window patterns. Use complications on the watch face for at-a-glance secondary data.

Do not spend engineering time exploring workarounds. This limitation is architectural and will not change for the foreseeable hardware generation.

---

## BB. Voice Interaction on Watch (Extended)

Voice is the highest-bandwidth input method on wearables — faster than tiny keyboards, more expressive than taps, and usable eyes-free during physical activity.

### Voice Dictation

**Wear OS — RemoteInput:**
```kotlin
// Launch system dictation for text input
val remoteInput = RemoteInput.Builder("reply_text")
    .setLabel("Speak your message")
    .setAllowFreeFormInput(true)
    .build()

val intent = RemoteActivityHelper.buildRemoteInputIntent(
    context, arrayOf(remoteInput)
)
startActivityForResult(intent, REQUEST_DICTATION)

// In onActivityResult:
val results = RemoteInput.getResultsFromIntent(data)
val spokenText = results?.getCharSequence("reply_text")
```

**watchOS — Dictation via TextField or presentTextInputController:**
```swift
// watchOS 9+ SwiftUI — system dictation is automatic with TextField
TextField("Message", text: $messageText)

// watchOS <9 or custom trigger
presentTextInputController(
    withSuggestions: ["On my way", "Running late", "Call me"],
    allowedInputMode: .allowEmoji
) { results in
    guard let results, let text = results.first as? String else { return }
    self.handleDictatedText(text)
}
```

### Voice Assistant Integration

- **Wear OS (Google Assistant):** Register custom App Actions via `shortcuts.xml` to handle domain-specific voice commands. Example: "Hey Google, log a cigarette in [AppName]" triggers an intent routed to your app.
- **watchOS (Siri):** Donate `INIntent` subclasses or use App Intents (iOS 16+ / watchOS 9+) for Siri Shortcuts. Example: `LogCigaretteIntent` registered as a Siri Shortcut, invocable by "Hey Siri, log a cigarette."

### Voice-First Design Principles

1. **Design for no-look interaction.** During running, cycling, or driving, the user cannot glance at the screen. Voice commands must work without visual confirmation — use haptic confirmation (double tap = success, long buzz = error).
2. **Keep utterances short.** Dictation accuracy drops significantly after 8–10 words. Design prompts that expect 1–4 word responses.
3. **Offer canned responses as fallback.** When dictation fails (noisy environment, accent issues, offline), present 3–5 pre-written quick replies. Let users customize these in the phone companion app.
4. **Confirm destructive actions.** Voice-triggered deletes or sends require a second confirmation step (tap or second voice "yes").

### Dictation Accuracy Tips

- Activate the microphone only after a clear trigger (button press or wake word) to avoid capturing ambient noise.
- Use on-device speech recognition when available (Wear OS on-device model, watchOS on-device dictation in watchOS 10+) to reduce latency and work offline.
- For domain-specific vocabulary (medication names, exercise types), post-process dictation results with a local dictionary/fuzzy matcher rather than expecting perfect transcription.

### Voice Feedback Pattern

After a voice command is processed:
1. **Haptic:** Immediate — single tap for acknowledged, double for success, long for error.
2. **Visual:** Brief — checkmark or X icon, 1.5 s, auto-dismiss. Do not require the user to look at the screen.
3. **Audio:** Optional — a subtle chime only if the user is not in silent/theater mode. Check `AudioManager.getRingerMode()` (Wear OS) or respect `WKInterfaceDevice` silent state before playing audio feedback.

### When Voice Fails — Fallback Hierarchy

1. **Canned responses:** Pre-populated list (e.g., "Yes", "No", "On my way", "5 minutes").
2. **Emoji picker:** Grid of 12–16 most-used emoji, one tap to send.
3. **Tiny keyboard:** T9-style or QWERTY (Wear OS Gboard, watchOS Scribble/QuickPath). Last resort — slow and error-prone on small screens.
4. **Defer to phone:** "Open on phone" button hands the interaction to the companion app where full text input is available.

---

## BC. Ultra-Wideband (UWB) Features

> Precision spatial awareness on wearables: directional finding, car/home unlock, and ranging sessions.
> Sources: [Apple Nearby Interaction](https://developer.apple.com/documentation/nearbyinteraction), [Android UWB](https://developer.android.com/develop/connectivity/uwb), [FiRa Consortium](https://www.firaconsortium.org/), [IEEE 802.15.4z](https://standards.ieee.org/standard/802_15_4z-2020.html)

### Overview

Ultra-Wideband (UWB) uses time-of-flight radio pulses (6.5 GHz / 8 GHz bands) to measure distance with ~10 cm accuracy and angular direction within ~3 degrees azimuth. On wearables, UWB enables precision finding (locating items), car key / home unlock, and peer-to-peer spatial awareness — all without GPS power costs.

**Hardware support (as of 2025):**

| Device | UWB Chip | Range | Angular Accuracy |
|--------|----------|-------|------------------|
| Apple Watch Ultra 2 | Apple U2 | up to 50 m (line-of-sight) | +/- 3 deg azimuth |
| Apple Watch Series 9/10 | Apple U2 | up to 50 m | +/- 3 deg azimuth |
| Samsung Galaxy Watch Ultra | Samsung UWB | up to 30 m | +/- 5 deg azimuth |
| Pixel Watch 3 | No UWB | N/A | N/A |

### Ranging Sessions

**watchOS — Nearby Interaction:**
```swift
import NearbyInteraction

class RangingManager: NSObject, NISessionDelegate {
    private var session: NISession?

    func startRanging(with token: NIDiscoveryToken) {
        session = NISession()
        session?.delegate = self

        let config = NINearbyPeerConfiguration(peerToken: token)
        session?.run(config)
    }

    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
        guard let object = nearbyObjects.first else { return }
        // distance in meters (Float?), direction as simd_float3
        let distance = object.distance  // e.g., 2.34 m
        let direction = object.direction // unit vector (x, y, z)
        updateUI(distance: distance, direction: direction)
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
        // Session ended — re-run if needed
    }
}
```

**Android — UWB Ranging:**
```kotlin
import androidx.core.uwb.RangingParameters
import androidx.core.uwb.UwbManager

// AndroidX UWB API (requires UWB-capable device)
val uwbManager = UwbManager.createInstance(context)
val controllerSession = uwbManager.controllerSessionScope()

val rangingParameters = RangingParameters(
    uwbConfigType = RangingParameters.CONFIG_UNICAST_DS_TWR,  // Double-sided two-way ranging
    sessionId = sessionId,
    subSessionId = 0,
    sessionKeyInfo = sessionKey,
    complexChannel = controllerSession.uwbComplexChannel,
    peerDevices = listOf(peerDevice),
    updateRateType = RangingParameters.RANGING_UPDATE_RATE_AUTOMATIC
)

controllerSession.prepareSession(rangingParameters)
    .collect { rangingResult ->
        when (rangingResult) {
            is RangingResult.RangingResultPosition -> {
                val distance = rangingResult.position.distance?.value  // meters
                val azimuth = rangingResult.position.azimuth?.value    // degrees
                val elevation = rangingResult.position.elevation?.value
            }
            is RangingResult.RangingResultPeerDisconnected -> { /* handle */ }
        }
    }
```

### Directional Guidance UI

When guiding the user toward a UWB target (finding a lost item, walking to a car), the watch UI must be optimized for glanceability:

| Element | Specification |
|---------|---------------|
| Direction arrow | Minimum 48x48 dp, rotates smoothly (60 fps), points toward target relative to wrist orientation |
| Distance readout | Large numerals (24 sp+), update rate 4 Hz, round to 0.1 m when < 5 m, round to 1 m when > 5 m |
| Proximity zones | Far (> 10 m): blue, Medium (2-10 m): yellow, Close (< 2 m): green with haptic pulse |
| Haptic feedback | Pulse frequency increases as distance decreases: > 5 m = 1 Hz, 2-5 m = 2 Hz, < 2 m = 4 Hz, < 0.5 m = continuous |
| Out-of-range indicator | Show "Searching..." with subtle animation when no UWB signal detected for > 2 s |

**Critical UX rule:** Always combine UWB with Bluetooth RSSI as fallback. UWB requires line-of-sight; BLE works through walls. Show "approximate" label when falling back to BLE ranging.

### Car Key / Home Unlock

**Apple Car Key (watchOS):**
- Uses NFC tap for legacy + UWB for passive unlock (approach and open)
- UWB enables hands-free: unlock when watch is within 1.5 m, lock when > 4 m
- Wallet integration: car key appears as a pass in Apple Wallet on watch
- Express Mode: no authentication required for unlock (configurable)

**Samsung SmartThings + UWB:**
- Digital home key via SmartThings on Galaxy Watch
- UWB ranging triggers unlock when < 1 m from compatible door lock
- Requires Samsung UWB-enabled watch + SmartThings-compatible lock

### Privacy Considerations

1. **Location inference:** UWB ranging data can triangulate a user's position within a building. Never store raw ranging data beyond the active session.
2. **Accessory tracking protection:** Apple's Find My network and Google's Find My Device network both implement anti-stalking measures (unknown tracker alerts after 8-24 hours of co-travel).
3. **Session tokens:** UWB discovery tokens are ephemeral. Rotate session keys every ranging session. Never persist `NIDiscoveryToken` or UWB session keys to disk.
4. **User consent:** Always request explicit permission before initiating ranging. On watchOS, `NISession` requires the app to be in the foreground. On Android, UWB requires `UWB_RANGING` permission (normal permission, auto-granted).
5. **FiRa MAC address randomization:** FiRa 2.0 mandates MAC address randomization per session to prevent tracking.

### Checklist

- ✅ Verify `NISession.deviceCapabilities.supportsDirectionMeasurement` before showing directional UI
- ✅ Check `packageManager.hasSystemFeature("android.hardware.uwb")` on Android
- ✅ Combine UWB + BLE for continuous ranging (UWB for precision, BLE for fallback)
- ✅ Haptic pulse rate scales inversely with distance
- ✅ Direction arrow accounts for wrist rotation via device motion sensors
- ✅ Rotate UWB session keys per session
- ✅ Gracefully degrade when UWB is unavailable (show BLE-only approximate distance)
- ❌ Do not persist raw ranging data beyond active session
- ❌ Do not initiate ranging without user action or clear automated trigger (e.g., approaching car)
- ❌ Do not show precise direction if angular accuracy > 15 degrees (show distance only)

### Anti-patterns

1. **UWB-only design** — Many devices lack UWB. Always provide BLE fallback or the feature is unusable on Pixel Watch, older Galaxy Watch models, and Apple Watch SE.
2. **Continuous background ranging** — UWB ranging consumes 50-80 mW. Running it continuously drains ~15% battery/hour. Use geofence or BLE proximity to trigger UWB sessions only when needed.
3. **Arrow jitter** — Raw UWB direction updates can jitter +/- 10 degrees. Apply a low-pass filter (exponential moving average, alpha = 0.3) to smooth the arrow rotation.
4. **No out-of-range state** — When the target moves behind a wall, UWB signal drops instantly. Without a clear "signal lost" state, users stare at a frozen arrow.

**Sources:** [Apple Nearby Interaction](https://developer.apple.com/documentation/nearbyinteraction), [AndroidX UWB](https://developer.android.com/develop/connectivity/uwb), [FiRa Consortium Technical Specs](https://www.firaconsortium.org/), [Apple Car Key](https://developer.apple.com/car-keys/)

---

## BD. watchOS Background Execution

> Budget-limited background execution on watchOS: app refresh, transfers, workout sessions, and complication updates.
> Sources: [Apple Background Execution](https://developer.apple.com/documentation/watchkit/background_execution), [WWDC 2022 - Efficiency Awaits](https://developer.apple.com/videos/play/wwdc2022/10003/), [WWDC 2023 - Background Tasks](https://developer.apple.com/videos/play/wwdc2023/10101/)

### Overview

watchOS aggressively suspends apps to preserve battery. Unlike iOS, watchOS apps get minimal background time. Apple allocates a strict CPU time budget (~4 minutes total per day for background refresh, variable by usage patterns). Understanding each background mode and its limits is essential.

### Background Modes

| Mode | Budget | Duration per Wake | Use Case |
|------|--------|-------------------|----------|
| Background App Refresh | ~4 min CPU/day, ~4 wakes/hour max | ~15 s wall-clock per wake | Fetching new data, updating state |
| URLSession Background Transfer | No CPU budget (system-managed) | Runs while app is suspended | Large downloads/uploads (sync data) |
| Workout Session | Unlimited while active | Continuous | Active exercise tracking |
| Bluetooth Background | Limited to active BLE connections | Connection events only | Peripheral communication |
| Complication Timeline Update | ~50 updates/day (getTimeline) | ~15 s per update | Complication data refresh |
| Background Audio | Continuous while playing | Until playback stops | Music / podcast playback |
| Smart Alarm / Sleep Tracking | System-managed | Until alarm fires | Sleep monitoring |

### Background App Refresh

```swift
import WatchKit

// Schedule background refresh (watchOS 9+)
func scheduleRefresh() {
    let preferredDate = Date().addingTimeInterval(15 * 60) // 15 min from now
    WKApplication.shared().scheduleBackgroundRefresh(
        withPreferredDate: preferredDate,
        userInfo: nil
    ) { error in
        if let error {
            print("Schedule failed: \(error.localizedDescription)")
        }
    }
}

// Handle in ExtensionDelegate or @main App
func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    for task in backgroundTasks {
        switch task {
        case let refreshTask as WKApplicationRefreshBackgroundTask:
            // You have ~15 seconds wall-clock time
            fetchLatestData { newData in
                self.updateComplicationTimeline()
                self.scheduleRefresh() // Re-schedule next refresh
                refreshTask.setTaskCompletedWithSnapshot(true)
            }
        case let urlTask as WKURLSessionRefreshBackgroundTask:
            // Background URLSession completed
            let session = URLSession(
                configuration: .background(withIdentifier: urlTask.sessionIdentifier),
                delegate: self, delegateQueue: nil
            )
            // session delegate receives data
            urlTask.setTaskCompletedWithSnapshot(false)
        case let snapshotTask as WKSnapshotRefreshBackgroundTask:
            snapshotTask.setTaskCompleted(
                restoredDefaultState: true,
                estimatedSnapshotExpiration: Date.distantFuture,
                userInfo: nil
            )
        default:
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}
```

### URLSession Background Transfers

```swift
// For syncing health data to server while app is suspended
func startBackgroundUpload(data: Data) {
    let config = URLSessionConfiguration.background(
        withIdentifier: "com.app.healthSync"
    )
    config.isDiscretionary = false          // Send ASAP, not at system's discretion
    config.sessionSendsLaunchEvents = true  // Wake app on completion

    let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)

    // Write data to temp file (required for background uploads)
    let tempURL = FileManager.default.temporaryDirectory
        .appendingPathComponent("sync_\(UUID().uuidString).json")
    try? data.write(to: tempURL)

    var request = URLRequest(url: serverURL)
    request.httpMethod = "POST"

    let uploadTask = session.uploadTask(with: request, fromFile: tempURL)
    uploadTask.resume()
}
```

**Key constraint:** Background transfers on watchOS require the data to be written to a file first. In-memory `Data` uploads are not supported in background sessions.

### Workout Session Background Mode

```swift
import HealthKit

// Workout sessions keep the app alive in background
let workoutConfig = HKWorkoutConfiguration()
workoutConfig.activityType = .running
workoutConfig.locationType = .outdoor

let session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfig)
let builder = session.associatedWorkoutBuilder()

session.startActivity(with: Date())
builder.beginCollection(withStart: Date()) { success, error in
    // Collecting data — app stays alive in background
    // Heart rate, distance, calories update via builder
}

// IMPORTANT: Start a Live Activity or Ongoing Activity
// to signal to the system this is a long-running session
```

**Budget:** Unlimited CPU while the workout session is active. The app remains in memory and receives sensor updates. This is the only mode that gives true continuous background execution on watchOS.

### Complication Timeline Budget

- **~50 timeline reloads per day** via `CLKComplicationServer.sharedInstance().reloadTimeline(for:)`
- Each reload triggers `getTimeline(for:)` which should complete in < 15 s
- Push complication updates via APNs: use `complication` push type, limited to ~50/day
- WidgetKit complications (watchOS 9+): system controls refresh, typically 4-8 times/hour based on relevance

```swift
// Push complication update via APNs payload
{
    "aps": {
        "content-available": 1
    },
    // No alert — silent push triggers background refresh
}
```

### Budget Optimization Strategies

1. **Batch network calls.** Combine multiple API requests into one background refresh wake. Each wake costs the same budget whether you make 1 or 5 requests.
2. **Use URLSession background transfers for large payloads.** They do not count against CPU budget.
3. **Prioritize complications.** If the user has your complication on their watch face, the system allocates more background refresh budget to your app.
4. **Avoid scheduling too frequently.** Requesting refresh every 5 minutes will exhaust your ~4 daily wakes/hour quickly. 15-minute intervals are a practical minimum.
5. **Leverage workout sessions for health apps.** If your app tracks activity, a workout session gives unlimited background time.

### Checklist

- ✅ Always re-schedule the next background refresh inside the current refresh handler
- ✅ Call `setTaskCompletedWithSnapshot()` within 15 s or the system terminates the task
- ✅ Use `isDiscretionary = false` for time-sensitive background transfers
- ✅ Write upload data to a file (not in-memory Data) for background URLSession
- ✅ Test background behavior on a real device — Simulator does not accurately simulate budgets
- ✅ Use `ProcessInfo.processInfo.performExpiringActivity` for short critical tasks
- ❌ Do not assume background refresh will fire at the exact scheduled time (system delays up to 15 min)
- ❌ Do not rely on background refresh for time-critical alerts — use push notifications instead
- ❌ Do not start a workout session solely to get background time (App Store Review rejection risk)

### Anti-patterns

1. **Polling in background** — Scheduling refresh every 2 minutes exhausts daily budget in < 2 hours. The system will throttle or stop waking your app entirely.
2. **Ignoring budget signals** — If `scheduleBackgroundRefresh` returns an error, the system has denied the request. Back off exponentially.
3. **Heavy computation in refresh** — Running ML inference or complex calculations during the 15 s background window risks termination and wastes budget. Pre-compute on phone, sync results.
4. **Not testing on device** — Background execution timing on Simulator is unreliable. Always validate on hardware with Instruments > Energy Log.

**Sources:** [Apple Background Execution](https://developer.apple.com/documentation/watchkit/background_execution), [WWDC 2022 Session 10003](https://developer.apple.com/videos/play/wwdc2022/10003/), [Apple URLSession Background](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1407496-background)

---

## BE. watchOS WidgetKit Complications

> Migrating from ClockKit to WidgetKit complications: timeline entries, widget families, and refresh strategies.
> Sources: [Apple WidgetKit for watchOS](https://developer.apple.com/documentation/widgetkit/making-a-configurable-widget), [WWDC 2022 - Complications and Widgets](https://developer.apple.com/videos/play/wwdc2022/10050/), [WWDC 2023 - Widgets on watchOS](https://developer.apple.com/videos/play/wwdc2023/10029/)

### Overview

Starting with watchOS 9, Apple introduced WidgetKit as the replacement for ClockKit complications. ClockKit was deprecated in watchOS 9 and removed in watchOS 11. WidgetKit complications use SwiftUI views, share the same architecture as iOS/iPadOS widgets, and support timeline-based updates with relevance scoring.

### Migration from ClockKit

| ClockKit Concept | WidgetKit Equivalent |
|------------------|---------------------|
| `CLKComplicationDataSource` | `TimelineProvider` (or `AppIntentTimelineProvider`) |
| `CLKComplicationTemplate` | SwiftUI `View` in widget body |
| `CLKComplicationFamily` | `WidgetFamily` (.accessoryCircular, .accessoryRectangular, etc.) |
| `CLKComplicationTimelineEntry` | `TimelineEntry` |
| `getTimeline(for:)` | `timeline(for:in:)` |
| `reloadTimeline(for:)` | `WidgetCenter.shared.reloadTimelines(ofKind:)` |
| `CLKComplicationServer.sharedInstance()` | `WidgetCenter.shared` |

### Widget Families for watchOS

| Family | Size | Use Case | Example |
|--------|------|----------|---------|
| `.accessoryCircular` | ~50x50 pt (fits circular slot) | Single metric, icon + number | Step count ring, heart rate |
| `.accessoryRectangular` | ~160x70 pt (wide slot) | Multi-line text, small chart | Next event + time, health summary |
| `.accessoryInline` | Single line of text (above watch face) | Short label + value | "Steps: 8,234" or "72 bpm" |
| `.accessoryCorner` | Corner curved text + gauge | Gauge with label | Battery %, UV index gauge |

### Implementation

```swift
import WidgetKit
import SwiftUI

// 1. Define the Timeline Entry
struct CigaretteEntry: TimelineEntry {
    let date: Date
    let count: Int
    let dailyLimit: Int
    let relevance: TimelineEntryRelevance?
}

// 2. Create the Timeline Provider
struct CigaretteProvider: TimelineProvider {
    func placeholder(in context: Context) -> CigaretteEntry {
        CigaretteEntry(date: .now, count: 0, dailyLimit: 10, relevance: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (CigaretteEntry) -> Void) {
        let entry = CigaretteEntry(date: .now, count: currentCount(), dailyLimit: 10, relevance: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CigaretteEntry>) -> Void) {
        let currentDate = Date()
        let count = currentCount()

        // Create entries for the next 4 hours (one per hour)
        var entries: [CigaretteEntry] = []
        for hourOffset in 0..<4 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = CigaretteEntry(
                date: entryDate,
                count: count,
                dailyLimit: 10,
                relevance: TimelineEntryRelevance(score: Float(count) / 10.0) // Higher relevance when more cigarettes
            )
            entries.append(entry)
        }

        // Reload after 1 hour or when app signals a change
        let timeline = Timeline(entries: entries, policy: .after(
            Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        ))
        completion(timeline)
    }
}

// 3. Define the Widget Views
struct CircularComplicationView: View {
    let entry: CigaretteEntry

    var body: some View {
        Gauge(value: Double(entry.count), in: 0...Double(entry.dailyLimit)) {
            Text("CIG")
        } currentValueLabel: {
            Text("\(entry.count)")
                .font(.system(.title3, design: .rounded, weight: .bold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(entry.count > entry.dailyLimit ? .red : .green)
    }
}

struct RectangularComplicationView: View {
    let entry: CigaretteEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Cigarettes Today")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("\(entry.count) / \(entry.dailyLimit)")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(entry.count > entry.dailyLimit ? .red : .primary)
            ProgressView(value: Double(entry.count), total: Double(entry.dailyLimit))
                .tint(entry.count > entry.dailyLimit ? .red : .green)
        }
    }
}

// 4. Register the Widget
@main
struct CigaretteWidget: Widget {
    let kind = "CigaretteTracker"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CigaretteProvider()) { entry in
            switch entry.widgetFamily {
            case .accessoryCircular:
                CircularComplicationView(entry: entry)
            case .accessoryRectangular:
                RectangularComplicationView(entry: entry)
            case .accessoryInline:
                Text("Cigs: \(entry.count)/\(entry.dailyLimit)")
            default:
                CircularComplicationView(entry: entry)
            }
        }
        .configurationDisplayName("Cigarette Tracker")
        .description("Track daily cigarette count")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline,
            .accessoryCorner
        ])
    }
}
```

### Relevance Scoring

Relevance determines which complication the Smart Stack surfaces on top:

```swift
// Score from 0.0 (low) to 1.0 (high)
TimelineEntryRelevance(score: 0.8, duration: 3600) // High relevance for 1 hour

// Examples of good relevance strategies:
// - Workout app: score = 1.0 during active workout, 0.2 otherwise
// - Cigarette tracker: score increases with count (0.1 at 0 cigs, 0.9 at limit)
// - Calendar: score = 1.0 when next event is within 15 minutes
// - Weather: score = 0.8 during active precipitation
```

**System behavior:** The Smart Stack (watchOS 10+) uses relevance scores to auto-surface the most relevant widget when the user raises their wrist. A well-tuned relevance score significantly increases complication visibility.

### Refresh Strategies

| Strategy | Method | Budget Impact |
|----------|--------|---------------|
| Timeline-based | Return future entries in `getTimeline` | Zero — pre-computed |
| Push-triggered | APNs `complication` push -> `WidgetCenter.shared.reloadTimelines(ofKind:)` | ~50 pushes/day |
| App-triggered | Call `reloadTimelines(ofKind:)` from foreground app | Unlimited from foreground |
| Background refresh | `WKApplication.scheduleBackgroundRefresh` -> reload in handler | Counts against background budget |

**Best practice:** Return 4-8 hours of future timeline entries in `getTimeline`. This minimizes the number of reload calls needed. Use push notifications only for unpredictable events (e.g., user logged a cigarette from the phone app).

### Checklist

- ✅ Support all four accessory families (circular, rectangular, inline, corner) for maximum watch face compatibility
- ✅ Provide meaningful placeholder and snapshot (shown during widget gallery browsing)
- ✅ Set `TimelineEntryRelevance` score appropriately for Smart Stack ranking
- ✅ Return multiple future timeline entries to reduce reload frequency
- ✅ Use `WidgetCenter.shared.reloadTimelines(ofKind:)` when app state changes in foreground
- ✅ Test with `#Preview` macro and on-device for accurate rendering
- ❌ Do not call `reloadTimelines` more than 50 times/day from background
- ❌ Do not use images larger than 1024x1024 px in complication views
- ❌ Do not include interactive controls in watchOS complications (not supported until watchOS 10 Smart Stack widgets)

### Anti-patterns

1. **Stale data** — Returning a single timeline entry with `.never` reload policy. The complication shows outdated data for hours. Always provide future entries or use `.after(date)`.
2. **Over-reloading** — Calling `reloadTimelines` on every minor state change. Batch updates; reload at most once per significant user action.
3. **Ignoring circular constraints** — Designing for `.accessoryRectangular` only. Circular is the most common complication slot on most watch faces. Always support it.
4. **Text overflow in inline** — `.accessoryInline` has ~20-25 characters max. Longer text is silently truncated. Keep labels under 20 characters.

**Sources:** [Apple WidgetKit](https://developer.apple.com/documentation/widgetkit), [WWDC 2022 Session 10050](https://developer.apple.com/videos/play/wwdc2022/10050/), [WWDC 2023 Session 10029](https://developer.apple.com/videos/play/wwdc2023/10029/), [Apple Widget Design Guidelines](https://developer.apple.com/design/human-interface-guidelines/widgets)

---

## BF. watchOS 11 HealthKit APIs

> HealthKit on watchOS: workout builder, cycling/swimming sensors, custom workout types, authorization flow, and background delivery.
> Sources: [Apple HealthKit](https://developer.apple.com/documentation/healthkit), [WWDC 2024 - What's New in HealthKit](https://developer.apple.com/videos/play/wwdc2024/10109/), [Apple Workout API](https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings)

### Overview

HealthKit on watchOS provides direct access to health and fitness sensors. watchOS 11 (2024) expanded the API with new workout types, improved cycling metrics, swimming stroke classification, and refined authorization flows. The watch is the primary HealthKit data source for real-time biometrics; the phone acts as the long-term data store and sync hub.

### Workout Builder API

```swift
import HealthKit

class WorkoutManager: NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?

    func startWorkout(type: HKWorkoutActivityType) async throws {
        let config = HKWorkoutConfiguration()
        config.activityType = type
        config.locationType = .outdoor

        // For swimming
        if type == .swimming {
            config.swimmingLocationType = .openWater // or .pool
            config.lapLength = HKQuantity(unit: .meter(), doubleValue: 50) // Pool length
        }

        session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        builder = session?.associatedWorkoutBuilder()

        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: config
        )

        let start = Date()
        session?.startActivity(with: start)
        try await builder?.beginCollection(at: start)
    }

    // Real-time data updates
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                        didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            let statistics = workoutBuilder.statistics(for: quantityType)

            switch quantityType {
            case HKQuantityType(.heartRate):
                let bpm = statistics?.mostRecentQuantity()?.doubleValue(for: .count().unitDivided(by: .minute()))
                // Update UI: bpm
            case HKQuantityType(.activeEnergyBurned):
                let kcal = statistics?.sumQuantity()?.doubleValue(for: .kilocalorie())
                // Update UI: kcal
            case HKQuantityType(.distanceWalkingRunning):
                let km = statistics?.sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo))
                // Update UI: km
            case HKQuantityType(.cyclingPower):
                let watts = statistics?.mostRecentQuantity()?.doubleValue(for: .watt())
                // watchOS 10+ cycling power from paired sensor
            case HKQuantityType(.cyclingSpeed):
                let mps = statistics?.mostRecentQuantity()?.doubleValue(for: .meter().unitDivided(by: .second()))
                // watchOS 10+ cycling speed
            default: break
            }
        }
    }

    func endWorkout() async throws {
        session?.end()
        try await builder?.endCollection(at: Date())
        let workout = try await builder?.finishWorkout()
        // workout is saved to HealthKit
    }
}
```

### Cycling Power & Speed (watchOS 10+)

New in watchOS 10 / 11:
- **`HKQuantityType(.cyclingPower)`** — watts, from Bluetooth cycling power meter
- **`HKQuantityType(.cyclingSpeed)`** — m/s, from speed sensor or GPS-derived
- **`HKQuantityType(.cyclingCadence)`** — rpm, from cadence sensor
- **Functional Threshold Power (FTP):** stored as `HKQuantityType(.cyclingFunctionalThresholdPower)`, user can set manually or Apple Watch estimates after outdoor rides
- **Power zones:** Derived from FTP (zone 1: < 55% FTP, zone 2: 56-75%, zone 3: 76-90%, zone 4: 91-105%, zone 5: 106-120%, zone 6: > 120%)

### Swimming Stroke Detection

```swift
// Swimming stroke types detected automatically
// HKSwimmingStrokeStyle: .freestyle, .backstroke, .breaststroke, .butterfly, .mixed

// Access stroke data from workout events
func workoutSession(_ workoutSession: HKWorkoutSession,
                    didGenerate event: HKWorkoutEvent) {
    if event.type == .lap {
        // Auto-detected lap (pool mode) or manual lap (open water)
    }
    if let metadata = event.metadata,
       let strokeStyle = metadata[HKMetadataKeySwimmingStrokeStyle] as? Int {
        let stroke = HKSwimmingStrokeStyle(rawValue: strokeStyle)
        // Update UI with detected stroke type
    }
}

// SWOLF score = strokes per lap + lap time in seconds
// Automatically calculated by Apple Watch for pool swimming
// Access via HKQuantityType(.swimmingStrokeCount) per lap
```

### Custom Workout Types

watchOS 11 expanded `HKWorkoutActivityType` to include:
- `.underwaterDiving` (watchOS 9+ on Ultra)
- `.swimBikeRun` (triathlon, watchOS 9+ multi-sport)
- `.cardioDance`
- `.socialDance`
- `.pickleball`
- `.cooldown`

For unsupported activities, use `.other` with custom metadata:

```swift
let config = HKWorkoutConfiguration()
config.activityType = .other

// Add custom activity name via metadata when saving
builder?.addMetadata(
    [HKMetadataKeyWorkoutBrandName: "Cigarette Craving Walk"],
    completion: { _, _ in }
)
```

### Health Data Authorization Flow

```swift
// Request authorization — must happen BEFORE any read/write
func requestAuthorization() async throws {
    let typesToShare: Set<HKSampleType> = [
        HKQuantityType.workoutType(),
        HKQuantityType(.heartRate),
        HKQuantityType(.activeEnergyBurned)
    ]

    let typesToRead: Set<HKObjectType> = [
        HKQuantityType(.heartRate),
        HKQuantityType(.stepCount),
        HKQuantityType(.oxygenSaturation),
        HKObjectType.activitySummaryType()
    ]

    try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
    // System shows permission sheet — user grants/denies per type
}
```

**Authorization UX rules:**
- Request permission only when the user first attempts a feature that needs it (not at app launch)
- The system shows authorization status as `.notDetermined`, `.sharingDenied`, or `.sharingAuthorized`. For **read** access, the status is always `.notDetermined` for privacy (you cannot tell if the user denied read access)
- If denied, guide the user to Settings > Health > [Your App] with a deep link, do not repeatedly prompt

### Background Delivery

```swift
// Receive HealthKit updates while app is in background
func enableBackgroundDelivery() {
    let heartRateType = HKQuantityType(.heartRate)

    healthStore.enableBackgroundDelivery(
        for: heartRateType,
        frequency: .immediate  // .immediate, .hourly, .daily
    ) { success, error in
        // When new heart rate samples arrive, system wakes app briefly
    }
}

// Set up an HKObserverQuery to handle background wakes
let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
    // Fetch new samples here
    // MUST call completionHandler when done
    self.fetchNewHeartRateSamples()
    completionHandler()
}
healthStore.execute(query)
```

**Budget:** `.immediate` background delivery wakes the app for each new sample but is throttled by the system. Realistically expect wakes every 5-15 minutes for heart rate. For less critical data, use `.hourly` or `.daily`.

### Checklist

- ✅ Request only the HealthKit data types your app actually uses (data minimization)
- ✅ Handle `.sharingDenied` gracefully — show clear messaging about why the feature needs access
- ✅ Use `HKLiveWorkoutBuilder` for real-time workout data (not manual `HKQuantitySample` saves)
- ✅ Set `config.lapLength` for pool swimming to enable accurate lap counting
- ✅ Enable background delivery only for data types that drive core app functionality
- ✅ Call the background delivery completion handler promptly (system terminates after ~15 s)
- ❌ Do not request authorization for all HealthKit types "just in case" — App Store Review rejects this
- ❌ Do not check `authorizationStatus(for:)` for read types — it always returns `.notDetermined` for privacy
- ❌ Do not save workout data without a corresponding `HKWorkoutSession` — data will lack proper attribution

### Anti-patterns

1. **Authorization at launch** — Prompting for HealthKit access on first launch before the user understands why. Authorization request should be triggered by a user action (e.g., tapping "Start Workout").
2. **Ignoring multi-sport** — For apps supporting triathlons, not using `HKWorkoutSession.beginNewActivity()` for transitions. Each sport segment should be its own activity within the session.
3. **Manual sample creation during workouts** — Creating `HKQuantitySample` objects manually instead of using the `HKLiveWorkoutBuilder` data source. The builder handles timestamps, session association, and de-duplication automatically.
4. **Excessive background delivery** — Enabling `.immediate` delivery for 10+ data types. Each type consumes background budget. Limit to 1-2 critical types.

**Sources:** [Apple HealthKit](https://developer.apple.com/documentation/healthkit), [WWDC 2024 Session 10109](https://developer.apple.com/videos/play/wwdc2024/10109/), [Apple Workout Sessions](https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings)

---

## BG. Wear OS 5 Power Efficiency

> Power budgets, passive monitoring costs, WorkManager constraints, and optimization techniques for Wear OS 5.
> Sources: [Wear OS Power](https://developer.android.com/training/wearables/performance), [Google I/O 2024 Wear OS](https://io.google/2024/), [Watch Face Format](https://developer.android.com/training/wearables/wff), [Baseline Profiles](https://developer.android.com/topic/performance/baselineprofiles)

### Overview

Wear OS 5 (based on Android 14) introduced stricter power management: tighter Doze restrictions, per-app battery budgets enforced by the system, and the declarative Watch Face Format (WFF) which replaces custom `CanvasWatchFaceService` implementations with power-efficient XML/JSON definitions. The overarching goal is 24-hour battery life on a single charge for typical use.

### Watch Face Format Power Budget

WFF watch faces are rendered by the system compositor rather than app code, dramatically reducing power:

| Approach | Avg Power Draw | CPU Wake Frequency |
|----------|---------------|-------------------|
| Custom `CanvasWatchFaceService` (Wear OS 3/4) | 15-40 mW active, 5-15 mW ambient | Every frame (1-10 Hz) |
| Watch Face Format (WFF) declarative | 5-12 mW active, 1-3 mW ambient | System-managed, ~1 Hz ambient |
| WFF with complications | 8-18 mW active | System-managed + complication refresh |

```xml
<!-- Watch Face Format example (XML declarative) -->
<WatchFace width="450" height="450">
    <Scene>
        <!-- Analog hands rendered by system — no app code -->
        <AnalogClock centerX="225" centerY="225">
            <HourHand resource="@drawable/hour_hand" width="20" height="120" />
            <MinuteHand resource="@drawable/minute_hand" width="14" height="160" />
            <SecondHand resource="@drawable/second_hand" width="4" height="170" />
        </AnalogClock>

        <!-- Complication slot -->
        <ComplicationSlot
            slotId="top"
            supportedTypes="SHORT_TEXT,RANGED_VALUE,ICON"
            x="225" y="100" width="80" height="40" />
    </Scene>

    <!-- Ambient mode: hide second hand, reduce update rate -->
    <AmbientScene>
        <AnalogClock centerX="225" centerY="225">
            <HourHand resource="@drawable/hour_hand_ambient" width="20" height="120" />
            <MinuteHand resource="@drawable/minute_hand_ambient" width="14" height="160" />
            <!-- No SecondHand in ambient — saves ~3 mW -->
        </AnalogClock>
    </AmbientScene>
</WatchFace>
```

**Key rules:**
- No second hand in ambient mode (saves 2-5 mW by reducing update rate to 1/minute)
- Maximum 8 complication slots per watch face
- Animations limited to 15 fps in active mode, 0 fps in ambient
- Use vector drawables over bitmaps (50-80% smaller, scale without aliasing)

### Health Services Passive Monitoring Costs

| Data Type | Passive Monitoring Cost | Update Interval | Notes |
|-----------|------------------------|-----------------|-------|
| Heart rate (continuous) | ~8-12 mW | Every 1-5 s | Green LED PPG sensor |
| Heart rate (periodic) | ~2-4 mW | Every 10-15 min | Default passive mode |
| Steps | ~0.5-1 mW | Batched per minute | Accelerometer always-on |
| Daily distance | ~0.5-1 mW | Derived from steps | No additional sensor cost |
| SpO2 (on-demand) | ~15-20 mW | Per measurement (~30 s) | Red + IR LEDs |
| Skin temperature | ~0.5 mW | Every 1-5 min | Passive thermistor |
| Elevation / floors | ~1-2 mW | Per floor change | Barometer |
| GPS (continuous) | ~80-120 mW | 1 Hz | Major battery drain |
| GPS (batched) | ~30-50 mW | Every 5-10 s | Reduced fix rate |

```kotlin
// Passive monitoring registration (Wear OS Health Services)
val passiveMonitoringClient = PassiveMonitoringClient(context)

val passiveConfig = PassiveListenerConfig.builder()
    .setDataTypes(setOf(
        DataType.HEART_RATE_BPM,  // ~2-4 mW periodic
        DataType.STEPS_DAILY,     // ~0.5 mW
        DataType.CALORIES_DAILY   // Derived, negligible
    ))
    .setHealthEventTypes(setOf(
        HealthEvent.Type.FALL_DETECTED
    ))
    .build()

passiveMonitoringClient.setPassiveListenerServiceAsync(
    MyPassiveListenerService::class.java,
    passiveConfig
)
```

### WorkManager on Wear OS

WorkManager is the recommended API for deferrable background work on Wear OS. However, Wear OS imposes stricter constraints than phone Android:

```kotlin
// Wear OS WorkManager — constraints matter more on watch
val syncWorkRequest = OneTimeWorkRequestBuilder<SyncWorker>()
    .setConstraints(
        Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)  // WiFi or BT-tethered
            .setRequiresBatteryNotLow(true)  // Skip if < 15% battery
            .setRequiresCharging(false)      // Don't require charging (watch charges rarely)
            .build()
    )
    .setBackoffCriteria(
        BackoffPolicy.EXPONENTIAL,
        Duration.ofMinutes(10)  // Minimum 10 min on Wear OS (vs 30 s on phone)
    )
    .addTag("health_sync")
    .build()

WorkManager.getInstance(context).enqueueUniqueWork(
    "health_sync",
    ExistingWorkPolicy.REPLACE,
    syncWorkRequest
)
```

**Wear OS WorkManager constraints:**
- Minimum backoff interval: 10 minutes (phone: 30 seconds)
- Expedited work: available but system may defer during Doze
- Periodic work minimum interval: 15 minutes (same as phone)
- System kills workers exceeding 10 minutes execution time
- Network constraint: prefer `CONNECTED` over `UNMETERED` (watch rarely has unmetered WiFi)

### Battery Historian Analysis

```bash
# Capture bug report from watch via ADB
adb -s <watch-serial> bugreport > watch_bugreport.zip

# Upload to Battery Historian (https://bathist.ef.lc/ or run locally)
# Key metrics to analyze:
# - Wakelock duration per app (target: < 60 s cumulative per hour)
# - JobScheduler/WorkManager execution count (target: < 10 per hour)
# - Sensor usage duration (target: GPS < 5 min/hour for non-workout)
# - Network transfer volume (target: < 500 KB per sync)
# - CPU running time (target: < 2 min per hour in background)
```

**Power budget rule of thumb:** An app should consume < 5% battery per hour in the background. At 300 mAh battery capacity, that is 15 mAh/hour or ~45 mW average draw. Subtract system baseline (~20-25 mW) and you have ~20 mW budget for your app's background activity.

### Baseline Profiles for Wear OS

Baseline Profiles pre-compile critical code paths using AOT compilation, reducing cold-start jank and CPU usage (which saves power):

```kotlin
// benchmark/src/main/java/BaselineProfileGenerator.kt
@RunWith(AndroidJUnit4::class)
class BaselineProfileGenerator {
    @get:Rule
    val rule = BaselineProfileRule()

    @Test
    fun generateBaselineProfile() = rule.collect(
        packageName = "com.example.wearapp"
    ) {
        // Navigate through critical user journeys
        pressHome()
        startActivityAndWait()

        // Tile rendering path
        device.findObject(By.text("Start")).click()
        device.waitForIdle()

        // Complication rendering path
        // ... navigate key screens
    }
}
```

**Impact on Wear OS:**
- Cold start: 20-40% faster (from ~1.5 s to ~0.9 s on Pixel Watch 3)
- Scroll jank: 30-50% fewer dropped frames
- Power: ~10-15% less CPU time for common operations (fewer JIT compilations at runtime)

### Tile Refresh Limits

| Tile State | Max Refresh Rate | Recommended |
|------------|-----------------|-------------|
| On-screen (user viewing) | Platform-limited ~1/min | Update only on data change |
| Off-screen (in tile carousel) | ~4 per hour | Every 15-30 min |
| Fresh install / first add | Immediate | Provide instant snapshot |

```kotlin
// Tile refresh request (from app)
TileService.getUpdater(context)
    .requestUpdate(MyTileService::class.java)
// System may defer this request. Do not call more than once per data change event.
```

### Checklist

- ✅ Migrate custom watch faces to Watch Face Format (WFF) for 50-70% power reduction
- ✅ Remove second hand from ambient mode watch faces
- ✅ Use passive monitoring (not active/continuous) for background health tracking
- ✅ Set `setRequiresBatteryNotLow(true)` on non-critical WorkManager tasks
- ✅ Generate and ship Baseline Profiles with your Wear OS app
- ✅ Profile with Battery Historian before each release
- ✅ Limit tile refresh to data-change events, not periodic polling
- ❌ Do not use continuous GPS outside of active workout sessions
- ❌ Do not hold wakelocks longer than 5 seconds for any single operation
- ❌ Do not schedule WorkManager periodic tasks more frequently than every 15 minutes
- ❌ Do not use `AlarmManager.setExactAndAllowWhileIdle()` for recurring work — use WorkManager

### Anti-patterns

1. **Continuous heart rate for non-workout apps** — Drawing 8-12 mW permanently for a cigarette tracker that only needs periodic data. Use 10-minute passive intervals instead.
2. **GPS polling for step counting** — GPS is unnecessary for step tracking. The accelerometer provides step data at 1% of the power cost.
3. **Custom watch face with Canvas** — Still using `CanvasWatchFaceService` on Wear OS 5. WFF is mandatory for new submissions on Google Play as of 2024.
4. **Ignoring Doze** — Assuming your app can always access network. After 30 minutes of inactivity, Doze blocks network access. Use WorkManager with network constraints.

**Sources:** [Wear OS Performance](https://developer.android.com/training/wearables/performance), [Watch Face Format](https://developer.android.com/training/wearables/wff), [Health Services API](https://developer.android.com/health-and-fitness/guides), [Baseline Profiles](https://developer.android.com/topic/performance/baselineprofiles/overview)

---

## BH. App Store Privacy Labels for Health Data

> Required privacy disclosures for health/fitness wearable apps on Apple App Store and Google Play.
> Sources: [Apple App Store Review Guidelines 5.1.3](https://developer.apple.com/app-store/review/guidelines/#data-collection-and-storage), [Google Play Health Policy](https://support.google.com/googleplay/android-developer/answer/10787469), [HHS HIPAA Guidance](https://www.hhs.gov/hipaa/for-professionals/index.html)

### Overview

Wearable health apps collect uniquely sensitive data: heart rate, workout patterns, menstrual cycles, blood oxygen, sleep, medication schedules, and smoking habits. Both Apple and Google require explicit privacy disclosures at submission. Misrepresenting data collection leads to rejection or removal. Health data is also subject to additional regulatory requirements (HIPAA in the US, GDPR in the EU) depending on context.

### Apple Privacy Nutrition Labels

When submitting a watchOS/iOS app that uses HealthKit, you must declare each data type in App Store Connect under "App Privacy":

| Privacy Category | HealthKit Examples | Disclosure Required |
|-----------------|-------------------|-------------------|
| **Health & Fitness** | Heart rate, workouts, step count, sleep, menstrual cycle, blood glucose, ECG | Always if reading or writing |
| **Body** | Height, weight, body fat %, BMI | If accessed via HealthKit |
| **Identifiers** | HealthKit user ID (implied via device) | If linking to account |
| **Usage Data** | App interaction (workout start/stop times) | If collected |
| **Diagnostics** | Crash logs containing health context | If sent to server |

**Mandatory disclosures for HealthKit apps:**
1. **Data Used to Track You:** Declare if health data is linked to advertising identifiers (generally prohibited — HealthKit data cannot be used for advertising per Apple guidelines).
2. **Data Linked to You:** Declare if health data is associated with user identity (account, email). Most health apps must declare this.
3. **Data Not Linked to You:** Declare if health data is collected but not associated with identity (rare for health apps).
4. **Data Not Collected:** Only if you truly never read/write HealthKit data.

**Apple App Store Review Guidelines 5.1.3 (Health & HealthKit):**
- HealthKit data may not be stored in iCloud (must use direct server-to-device sync)
- HealthKit data may not be sold to advertising platforms, data brokers, or information resellers
- HealthKit data may not be used for purposes other than health/fitness functionality
- Apps must have a privacy policy accessible from within the app
- Must clearly disclose all health data shared with third parties

### Google Play Health Data Policy

Google Play requires a **Permissions Declaration Form** for apps accessing health-related permissions:

| Permission / API | Declaration Requirement |
|-----------------|----------------------|
| `BODY_SENSORS` (heart rate) | Must justify in declaration form |
| `ACTIVITY_RECOGNITION` (steps, activity type) | Must justify in declaration form |
| Health Connect API access | Must complete Health Connect permissions declaration |
| `ACCESS_FINE_LOCATION` (GPS for workouts) | Must justify if used during exercise |
| Background sensor access | Additional justification required |

**Google Play Data Safety section requirements:**
- Declare all health data types collected (activity, heart rate, sleep, etc.)
- Declare whether data is encrypted in transit (required: yes)
- Declare whether data can be deleted by user (required for health: yes)
- Declare third-party sharing (analytics, cloud storage)
- Declare data retention period

**Health Connect (Android 14+):**
- Apps must declare `READ_HEALTH_DATA_IN_BACKGROUND` for background access
- Rate limits: 1000 read requests per 15 minutes per app
- Data retention: Health Connect retains data for 30 days by default; longer storage requires user consent
- Apps must implement data deletion when user requests it via Health Connect settings

### HIPAA Considerations for Consumer Apps

**Key distinction:** Most consumer wearable apps are NOT covered by HIPAA. HIPAA applies only to:
1. **Covered Entities:** Hospitals, clinics, health plans, healthcare clearinghouses
2. **Business Associates:** Companies that handle PHI on behalf of covered entities

A standalone smoking cessation app that collects heart rate data is typically NOT a HIPAA-covered entity. However:

| Scenario | HIPAA Applicable? |
|----------|------------------|
| Standalone consumer app (user tracks own health) | No |
| App prescribed by doctor as part of treatment | Possibly (if data flows to covered entity) |
| App that shares data with insurance company | Yes (business associate) |
| App integrated with EHR (Epic, Cerner) | Yes (business associate) |
| App storing data on behalf of a hospital | Yes (business associate) |

**Even if not HIPAA-covered, best practices apply:**
- Encrypt health data at rest (AES-256) and in transit (TLS 1.3)
- Implement user data deletion (both platforms require this)
- Minimize data collection to what the app actually needs
- Document data retention periods
- Conduct annual security assessment

### Data Minimization Principles

1. **Collect only what you use.** If your cigarette tracker needs heart rate to detect smoking patterns, do not also request blood glucose, menstrual cycle, or sleep data.
2. **Process locally when possible.** Run ML inference on-device rather than sending raw sensor data to a server.
3. **Aggregate before syncing.** Send daily summaries (e.g., "12 cigarettes today, avg HR 78 bpm during smoking") rather than raw per-second heart rate streams.
4. **Delete raw data after processing.** If you collect 24 hours of accelerometer data to detect smoking gestures, delete the raw data after extracting events.
5. **Respect opt-out.** If a user revokes HealthKit or Health Connect access, delete previously collected health data within 30 days.

### Checklist

- ✅ Complete Apple App Privacy nutrition labels for every HealthKit data type accessed
- ✅ Complete Google Play Data Safety section and Permissions Declaration Form
- ✅ Include a privacy policy accessible from within the app (required by both platforms)
- ✅ Encrypt health data at rest (AES-256) and in transit (TLS 1.2+)
- ✅ Implement user data deletion endpoint and in-app "Delete My Data" button
- ✅ Request only HealthKit/Health Connect types your app actively uses
- ✅ Never use health data for advertising or sell it to third parties
- ✅ Store HealthKit data on-device or on your own server — not in iCloud
- ❌ Do not access HealthKit data types you did not declare in App Store Connect
- ❌ Do not share health data with analytics SDKs (Firebase, Mixpanel) without explicit disclosure
- ❌ Do not retain raw health data indefinitely — define and enforce a retention period

### Anti-patterns

1. **Blanket HealthKit authorization** — Requesting 30+ HealthKit types when the app only uses 3. Apple reviewers check your authorization request against declared privacy labels. Mismatch = rejection.
2. **Silent third-party sharing** — Sending heart rate data to an analytics backend without declaring it in privacy labels. Both Apple and Google enforce this; violations lead to app removal.
3. **No deletion mechanism** — Collecting years of health data with no way for users to delete it. GDPR Article 17 (right to erasure) and both platform policies require deletion capability.
4. **iCloud for HealthKit** — Storing HealthKit-sourced data in CloudKit or iCloud Drive. Apple explicitly prohibits this (App Store Review Guideline 5.1.3).

**Sources:** [Apple App Store Review Guidelines 5.1.3](https://developer.apple.com/app-store/review/guidelines/#data-collection-and-storage), [Apple App Privacy](https://developer.apple.com/app-store/app-privacy-details/), [Google Play Health Policy](https://support.google.com/googleplay/android-developer/answer/10787469), [HHS HIPAA](https://www.hhs.gov/hipaa/for-professionals/index.html), [Health Connect](https://developer.android.com/health-and-fitness/guides/health-connect)

---

## BI. CoreML / TFLite on Wearable

> On-device ML inference on watches: model constraints, health pattern detection, battery impact, and implementation.
> Sources: [Apple CoreML](https://developer.apple.com/documentation/coreml), [TensorFlow Lite Micro](https://www.tensorflow.org/lite/microcontrollers), [Google On-Device ML](https://developers.google.com/ml-kit)

### Overview

Running ML models on-watch enables real-time health insights (anomaly detection, activity classification, sleep staging) without network latency or privacy concerns of server-side processing. However, watch hardware imposes severe constraints: limited RAM (1-2 GB shared with OS), no GPU on most watches (Apple Neural Engine is the exception), and every milliwatt of inference cost comes from a ~300 mAh battery.

### Hardware Constraints

| Device | ML Accelerator | Available RAM for App | CPU | Max Recommended Model Size |
|--------|---------------|----------------------|-----|---------------------------|
| Apple Watch S9/10/Ultra 2 | Neural Engine (4-core) | ~200-300 MB | S9/S10 SiP (2-core) | < 50 MB |
| Apple Watch SE (2nd) | None (CPU only) | ~150 MB | S8 SiP (2-core) | < 20 MB |
| Pixel Watch 3 | None (CPU only) | ~400 MB | Snapdragon W5 (4-core) | < 30 MB |
| Galaxy Watch 7 | None (CPU only) | ~500 MB | Exynos W1000 (5-core) | < 30 MB |
| Garmin Venu 3 | None | Very limited | Custom RISC | Not practical (< 1 MB) |

### Model Size and Performance Guidelines

| Metric | Target | Critical Limit |
|--------|--------|----------------|
| Model file size | < 25 MB (ideal), < 50 MB (max) | > 50 MB causes OOM on older watches |
| Inference latency | < 50 ms per prediction | > 200 ms creates noticeable UI lag |
| RAM during inference | < 100 MB peak | > 200 MB triggers system kill |
| Battery per inference | < 0.5 mJ | Continuous inference at > 2 mJ/call drains 5%+ per hour |
| Inference frequency | 1-4 Hz for real-time, batch for non-critical | > 10 Hz unnecessary for most health signals |

### CoreML on watchOS

```swift
import CoreML

// Load model (compiled .mlmodelc in app bundle)
class SmokingDetector {
    private let model: SmokingGestureClassifier  // Generated from .mlmodel

    init() throws {
        let config = MLModelConfiguration()
        config.computeUnits = .all  // Use Neural Engine if available
        // .cpuOnly for consistent but slower inference
        // .cpuAndNeuralEngine for best performance on S9+

        model = try SmokingGestureClassifier(configuration: config)
    }

    func classify(accelerometerWindow: MLMultiArray) -> (label: String, confidence: Double)? {
        // Input: 3-axis accelerometer data, 50 samples at 25 Hz (2-second window)
        // MLMultiArray shape: [1, 50, 3] (batch, time, axes)
        guard let prediction = try? model.prediction(input:
            SmokingGestureClassifierInput(sensorData: accelerometerWindow)
        ) else { return nil }

        return (prediction.label, prediction.labelProbability[prediction.label] ?? 0)
    }

    // Batch inference for power efficiency
    func classifyBatch(windows: [MLMultiArray]) -> [String] {
        // Process multiple windows at once — amortizes model load cost
        // CoreML batch prediction (watchOS 9+)
        let inputs = windows.map {
            SmokingGestureClassifierInput(sensorData: $0)
        }
        guard let predictions = try? model.predictions(inputs: inputs) else { return [] }
        return predictions.map { $0.label }
    }
}
```

**CoreML model optimization for watch:**
- Use `coremltools` to quantize: `ct.models.neural_network.quantization_utils.quantize_weights(model, nbits=16)` reduces size ~50%
- INT8 quantization: further 50% reduction with < 2% accuracy loss for activity classification
- Use `MLModelConfiguration.computeUnits = .all` to leverage Neural Engine on S9/S10 (8-15x faster than CPU)
- Compile models with `coremlc` for target deployment (watchOS specific optimizations)

### TFLite on Wear OS

```kotlin
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.FileUtil

class SmokingDetector(context: Context) {
    private val interpreter: Interpreter

    init {
        // Load .tflite model from assets
        val modelBuffer = FileUtil.loadMappedFile(context, "smoking_classifier.tflite")

        val options = Interpreter.Options().apply {
            setNumThreads(2)          // Use 2 of 4 CPU cores
            setUseNNAPI(false)        // NNAPI not reliable on Wear OS — use CPU
            // setUseXNNPack(true)    // XNNPACK delegate for optimized CPU inference
        }

        interpreter = Interpreter(modelBuffer, options)
    }

    fun classify(sensorWindow: FloatArray): Pair<String, Float> {
        // Input: [1, 50, 3] — 2-second window of 3-axis accel at 25 Hz
        val input = arrayOf(sensorWindow.toTypedArray()
            .toList().chunked(3).map { it.toFloatArray() }.toTypedArray())
        val output = Array(1) { FloatArray(3) }  // 3 classes: idle, smoking, other_gesture

        interpreter.run(input, output)

        val labels = listOf("idle", "smoking", "other_gesture")
        val maxIdx = output[0].indices.maxByOrNull { output[0][it] } ?: 0
        return Pair(labels[maxIdx], output[0][maxIdx])
    }

    fun close() {
        interpreter.close()  // Release native memory
    }
}
```

**TFLite optimization for Wear OS:**
- Use `TFLiteConverter` with `optimizations=[tf.lite.Optimize.DEFAULT]` for dynamic range quantization
- Full INT8 quantization with representative dataset reduces model to ~25% original size
- XNNPACK delegate improves CPU inference 2-4x on ARM cores
- Avoid NNAPI delegate on Wear OS — inconsistent hardware support across watch chipsets

### Health-Specific ML Use Cases

| Use Case | Input | Model Type | Size (quantized) | Inference Rate | Accuracy Target |
|----------|-------|-----------|-------------------|----------------|-----------------|
| Activity classification | Accelerometer 25 Hz | CNN or LSTM | 2-5 MB | 1 Hz (1-s window) | > 90% |
| Smoking gesture detection | Accel + gyro 50 Hz | 1D-CNN | 3-8 MB | 0.5 Hz (2-s window) | > 85% |
| Heart rate anomaly (tachycardia) | HR time series | Threshold + LSTM | 1-3 MB | 0.1 Hz (10-s window) | > 95% sensitivity |
| Sleep staging (wake/light/deep/REM) | Accel + HR | Random Forest or CNN | 5-15 MB | 1/30 Hz (30-s epochs) | > 80% (Cohen's kappa > 0.6) |
| Fall detection | Accel + gyro 100 Hz | 1D-CNN | 2-4 MB | 10 Hz (continuous) | > 95% sensitivity, < 1% false positive |

### Battery Impact of Inference

| Inference Pattern | Estimated Battery Cost | Notes |
|-------------------|----------------------|-------|
| Continuous 1 Hz inference (2 MB model, CPU) | ~3-5% per hour | Acceptable for active workout tracking |
| Periodic inference every 30 s | ~0.5-1% per hour | Good for background smoking detection |
| On-demand inference (user-triggered) | Negligible | Best for non-continuous features |
| Continuous + sensor collection | ~5-8% per hour | Accel + gyro + inference combined |

**Power optimization strategy for smoking detection:**
1. **Stage 1 — Accelerometer gate:** Collect accel at 25 Hz (always-on, ~1 mW). Run lightweight threshold check: if wrist is raised to mouth height, proceed to stage 2.
2. **Stage 2 — Feature extraction:** Collect 2-second window of accel + gyro. Extract features (mean, std, FFT peaks). Cost: ~2 mW for 2 seconds.
3. **Stage 3 — ML inference:** Run classifier on extracted features. Cost: ~5 mW for ~30 ms.
4. **Result:** Instead of continuous ML inference (~30 mW), the staged approach averages ~2-4 mW.

### Checklist

- ✅ Quantize models to INT8 or FP16 before deploying to watch (50-75% size reduction)
- ✅ Target < 25 MB model size for broad device compatibility
- ✅ Use staged inference (cheap gate -> expensive model) to reduce average power
- ✅ Set `computeUnits = .all` on CoreML to leverage Neural Engine when available
- ✅ Use `setNumThreads(2)` on TFLite to avoid starving the UI thread
- ✅ Release model resources (`interpreter.close()`) when not in use
- ✅ Test inference latency on lowest-spec target device (Apple Watch SE, older Galaxy Watch)
- ❌ Do not load models larger than 50 MB — OOM risk on 1 GB RAM devices
- ❌ Do not use NNAPI delegate on Wear OS — inconsistent and often slower than CPU
- ❌ Do not run inference at > 4 Hz for health signals (diminishing returns, excessive power)
- ❌ Do not keep the model loaded in memory when the app is in background (system may kill)

### Anti-patterns

1. **Server-side inference for real-time features** — Sending raw accelerometer data to a cloud API for smoking detection. Network latency (200-2000 ms) makes it useless for real-time, and it drains battery via radio usage. On-device inference at 30 ms is superior.
2. **Unquantized FP32 models** — Deploying the training-time model directly. FP32 models are 2-4x larger and 2x slower than quantized equivalents with negligible accuracy difference for health classification tasks.
3. **Continuous inference without gating** — Running the full ML pipeline 24/7 regardless of context. If the user is sleeping, the smoking detector should be paused. Use activity state or time-of-day to gate inference.
4. **Single monolithic model** — One large model for all tasks (activity + smoking + sleep). Separate specialized models are smaller, faster, and can be loaded/unloaded independently.

**Sources:** [Apple CoreML](https://developer.apple.com/documentation/coreml), [CoreML Tools Quantization](https://coremltools.readme.io/docs/quantization), [TensorFlow Lite](https://www.tensorflow.org/lite), [TFLite Optimization](https://www.tensorflow.org/lite/performance/model_optimization)

---

## BJ. Garmin Connect IQ Development

> Building apps for Garmin watches: Monkey C language, app types, memory limits, display constraints, and sensor access.
> Sources: [Garmin Connect IQ Developer Guide](https://developer.garmin.com/connect-iq/overview/), [Garmin API Docs](https://developer.garmin.com/connect-iq/api-docs/), [Connect IQ Store](https://apps.garmin.com/)

### Overview

Garmin watches run Connect IQ, a proprietary platform using the Monkey C programming language. Unlike Wear OS or watchOS, Garmin devices are optimized for extreme battery life (5-14 days smartwatch mode, weeks in GPS mode) at the cost of limited processing power, RAM, and display capabilities. Connect IQ apps must operate within a strict 64 KB memory budget (128 KB on newer devices like Venu 3).

### App Types

| Type | Purpose | Memory Limit | Lifecycle | Example |
|------|---------|-------------|-----------|---------|
| **Watch Face** | Custom time display | 64-128 KB | Always running (1 Hz update) | Analog face with health stats |
| **Widget** | Glanceable info card | 64-128 KB | Runs when user scrolls to it | Daily step summary |
| **Data Field** | Custom metric in activity screen | 32-64 KB | Active during workout recording | Smoking counter as activity field |
| **Device App** | Full interactive application | 64-128 KB | Launched from app menu | Cigarette logger with history |

### Monkey C Language Basics

```javascript
// Monkey C — syntax similar to Java/JavaScript
using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Lang;

class CigaretteApp extends Application.AppBase {
    var cigaretteCount = 0;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        // Load saved count from storage
        var stored = Application.Storage.getValue("count");
        if (stored != null) {
            cigaretteCount = stored;
        }
    }

    function onStop(state) {
        // Persist count
        Application.Storage.setValue("count", cigaretteCount);
    }

    function getInitialView() {
        return [new CigaretteView(), new CigaretteDelegate()];
    }
}

class CigaretteView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        // dc = DeviceContext (drawing canvas)
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var app = Application.getApp();
        var count = app.cigaretteCount;

        // Center text on circular display
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        dc.drawText(cx, cy - 30, Graphics.FONT_LARGE, count.toString(),
            Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(cx, cy + 20, Graphics.FONT_SMALL, "cigarettes",
            Graphics.TEXT_JUSTIFY_CENTER);
    }
}

class CigaretteDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onSelect() {
        // Physical button press or tap — increment counter
        var app = Application.getApp();
        app.cigaretteCount++;
        Application.Storage.setValue("count", app.cigaretteCount);

        // Haptic feedback
        if (Attention has :vibrate) {
            Attention.vibrate([new Attention.VibeProfile(50, 100)]);
        }

        WatchUi.requestUpdate();  // Trigger onUpdate redraw
        return true;
    }
}
```

### Memory Management (64 KB Limit)

The 64 KB limit applies to **runtime heap** — all objects, arrays, strings, and bitmaps your code allocates. This is extremely tight.

**Memory budget breakdown for a typical app:**
| Component | Estimated Cost | Notes |
|-----------|---------------|-------|
| Monkey C runtime overhead | ~8-12 KB | VM, stack, system objects |
| App class + delegates | ~2-4 KB | Per-class overhead |
| Bitmap (full screen 218x218) | ~20-48 KB | 1 bitmap can exhaust memory |
| String array (20 items) | ~1-2 KB | Each string ~50-100 bytes |
| Sensor data buffer (100 samples) | ~2-4 KB | Float arrays |
| Remaining for logic | ~10-30 KB | Very constrained |

**Strategies:**
- Never load full-screen bitmaps. Use vector drawing (`dc.drawLine`, `dc.drawCircle`, `dc.fillRectangle`) instead.
- Release resources in `onHide()`, reallocate in `onShow()`.
- Use `System.getSystemStats().freeMemory` to monitor available memory at runtime.
- Limit history arrays to 20-50 entries. Offload to `Application.Storage` (persisted, not counted in heap).
- Avoid string concatenation in loops (creates garbage, fragments heap).

### Display Constraints

| Device Series | Resolution | Shape | Color Depth | Touchscreen |
|---------------|-----------|-------|-------------|-------------|
| Venu 3 / 3S | 454x454 / 390x390 | Round | 16-bit (65K colors) | Yes |
| Venu 2 / Sq 2 | 416x416 / 320x360 | Round / Square | 16-bit | Yes |
| Forerunner 965 | 454x454 | Round | 16-bit | Yes |
| Forerunner 265 | 416x416 | Round | 16-bit | Yes |
| Forerunner 55 | 208x208 | Round | MIP (64 colors) | No |
| Fenix 7 / Epix 2 | 260x260 / 416x416 | Round | MIP / AMOLED | Varies |
| Instinct 2 | 176x176 | Round (notched) | Monochrome | No |

**MIP (Memory-in-Pixel) displays:**
- Only 64 colors (8 per channel, 2-bit per RGB)
- Always-on, near-zero power (no backlight needed in daylight)
- Design for high contrast (black + 1-2 accent colors)
- No anti-aliasing — use 1 px lines, avoid gradients

**AMOLED displays (Venu, Epix):**
- Full 16-bit color (65,536 colors)
- OLED burn-in risk: shift pixels 1-2 px periodically on watch faces
- Dark backgrounds save power (OLED pixels off = zero power)

### Sensor Access

```javascript
using Toybox.Sensor;
using Toybox.SensorHistory;

// Real-time sensor access
class SensorManager {
    function enableSensors() {
        // Register for sensor events
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_ONBOARD_ACCELEROMETER]);
        Sensor.enableSensorEvents(method(:onSensor));
    }

    function onSensor(info) {
        if (info.heartRate != null) {
            var hr = info.heartRate;  // BPM (integer)
        }
        if (info has :accel && info.accel != null) {
            // 3-axis accelerometer: [x, y, z] in milli-g
            var x = info.accel[0];
            var y = info.accel[1];
            var z = info.accel[2];
        }
    }

    // Historical sensor data (SensorHistory)
    function getLast24HoursHeartRate() {
        var iter = SensorHistory.getHeartRateHistory({
            :period => 86400  // 24 hours in seconds
        });
        var sample = iter.next();
        while (sample != null) {
            var hr = sample.data;      // BPM or null
            var time = sample.when;    // Moment timestamp
            sample = iter.next();
        }
    }
}
```

**Available sensors by device tier:**

| Sensor | Venu 3 | Forerunner 265 | Forerunner 55 | Instinct 2 |
|--------|--------|---------------|--------------|------------|
| Heart rate (PPG) | Yes | Yes | Yes | Yes |
| SpO2 | Yes | Yes | No | Yes |
| Accelerometer | Yes | Yes | Yes | Yes |
| Gyroscope | Yes | Yes | No | No |
| Barometer | Yes | Yes | No | Yes |
| Compass | Yes | Yes | No | Yes |
| GPS | Yes | Yes | Yes | Yes |
| Temperature | Yes | Yes | No | No |
| ECG | No | No | No | No |

### Connect IQ Store Submission

- **Review time:** 5-10 business days (longer than Apple/Google)
- **Size limit:** 512 KB for app bundle (code + resources)
- **Device compatibility:** Must declare supported devices in `manifest.xml`
- **Permissions:** Declare in manifest: `<iq:permissions><uses-permission id="Sensor" /><uses-permission id="Storage" /></iq:permissions>`
- **Minimum SDK version:** Connect IQ 4.0+ recommended for modern devices

### Checklist

- ✅ Monitor `System.getSystemStats().freeMemory` during development — crash if < 2 KB free
- ✅ Use vector drawing instead of bitmap images wherever possible
- ✅ Support both MIP (64-color) and AMOLED (65K-color) displays via resource overrides
- ✅ Test on real hardware — Garmin Simulator does not accurately reflect memory pressure
- ✅ Release sensor listeners in `onHide()` to avoid background power drain
- ✅ Use `Application.Storage` for data persistence (survives app restart, not counted in heap)
- ✅ Keep app bundle under 256 KB for fast install over Bluetooth
- ❌ Do not allocate full-screen bitmaps (20-48 KB each — nearly the entire heap)
- ❌ Do not use string concatenation in loops (use `StringUtil.format()` or pre-allocated buffers)
- ❌ Do not assume touchscreen — many Garmin devices are button-only (5-button layout)
- ❌ Do not target fewer than 10 device models (limits discoverability in Connect IQ Store)

### Anti-patterns

1. **Port from Wear OS without redesign** — A Wear OS app uses 200 MB RAM and touch gestures. Direct port to Connect IQ is impossible. Redesign for 64 KB and physical buttons.
2. **Full-screen background images** — A 218x218 16-bit bitmap uses ~93 KB uncompressed. Exceeds entire memory budget. Use solid colors and drawn shapes.
3. **Continuous sensor polling** — Enabling accelerometer at 25 Hz permanently halves battery life on Garmin. Use it only during active tracking, disable in `onHide()`.
4. **Ignoring MIP displays** — Designing only for AMOLED (gradients, rich colors). On a Fenix 7 with MIP display, the UI is unreadable. Always provide a high-contrast MIP resource set.

**Sources:** [Garmin Connect IQ Developer Guide](https://developer.garmin.com/connect-iq/overview/), [Garmin API Reference](https://developer.garmin.com/connect-iq/api-docs/), [Monkey C Language Reference](https://developer.garmin.com/connect-iq/reference-guides/monkey-c-reference/), [Connect IQ Store](https://apps.garmin.com/)

---

## BK. Fitbit OS / Fitbit SDK (Legacy + Transition)

> Legacy Fitbit SDK architecture, the transition to Wear OS via Pixel Watch, and migration guidance.
> Sources: [Fitbit Developer Docs (archived)](https://dev.fitbit.com/), [Google Fitbit Transition](https://blog.google/products/fitbit/), [Pixel Watch Developer Guide](https://developer.android.com/training/wearables)

### Overview

Fitbit OS was a proprietary platform running on Fitbit Sense, Versa, and Ionic series watches. Following Google's acquisition of Fitbit (January 2021), the platform has been sunsetted in favor of Wear OS. The Pixel Watch (2022+) runs Wear OS with Fitbit health integration. Fitbit SDK ceased accepting new app submissions in 2024, though existing apps continue to function on legacy hardware.

### Fitbit SDK Architecture (Legacy)

**Three-tier architecture:**

| Component | Language | Runtime | Role |
|-----------|---------|---------|------|
| **Device App** | JavaScript (ES6) | JerryScript VM on watch | UI rendering, sensor access, local logic |
| **Companion App** | JavaScript (ES6) | Runs on paired phone | Internet access, heavy computation, phone APIs |
| **Settings** | JSX (React-like) | Runs in Fitbit mobile app | Configuration UI for the watch app |

```javascript
// Device app (runs on watch) — clock face example
import clock from "clock";
import { HeartRateSensor } from "heart-rate";
import document from "document";

// Update every second
clock.granularity = "seconds";

const hrm = new HeartRateSensor({ frequency: 1 }); // 1 Hz
hrm.addEventListener("reading", () => {
    const hrLabel = document.getElementById("hr-value");
    hrLabel.text = `${hrm.heartRate} bpm`;
});
hrm.start();

clock.addEventListener("tick", (evt) => {
    const now = evt.date;
    const hours = now.getHours();
    const mins = ("0" + now.getMinutes()).slice(-2);
    document.getElementById("time").text = `${hours}:${mins}`;
});
```

```javascript
// Companion app (runs on phone) — fetch data from server
import { settingsStorage } from "settings";
import { peerSocket } from "messaging";

// Receive message from watch
peerSocket.addEventListener("message", (evt) => {
    if (evt.data.type === "cigarette_logged") {
        // Send to server
        fetch("https://api.example.com/log", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                count: evt.data.count,
                timestamp: evt.data.timestamp
            })
        });
    }
});
```

```jsx
// Settings page (JSX, rendered in Fitbit mobile app)
function settingsComponent(props) {
    return (
        <Page>
            <Section title="Daily Limit">
                <Slider
                    label="Max cigarettes per day"
                    settingsKey="dailyLimit"
                    min="1"
                    max="40"
                />
            </Section>
            <Section title="Notifications">
                <Toggle
                    settingsKey="enableReminders"
                    label="Hourly reminders"
                />
            </Section>
        </Page>
    );
}
registerSettingsPage(settingsComponent);
```

### Fitbit SDK Constraints

| Constraint | Value | Notes |
|-----------|-------|-------|
| Device app memory | ~64 KB JS heap | Similar to Garmin |
| Display resolution | 336x336 (Sense 2, Versa 4) | Square with rounded corners |
| Touch support | Yes (swipe + tap) | No physical buttons except side button |
| Sensor access | HR, accelerometer, gyro, SpO2, skin temp | Via Sensor API |
| Communication | Peer messaging (watch <-> phone) | No direct internet from watch |
| File transfer | Via File Transfer API | Max 5 MB per transfer |
| App size limit | 10 MB (resources + code) | Clock faces: 2 MB |
| Battery impact | Apps budgeted ~5% per day background | System enforces limits |

### Migration: Fitbit OS to Wear OS (Pixel Watch)

**Key differences for migrating developers:**

| Aspect | Fitbit OS | Wear OS (Pixel Watch) |
|--------|-----------|----------------------|
| Language | JavaScript | Kotlin/Java (or Compose) |
| UI Framework | SVG-based (document model) | Jetpack Compose for Wear OS |
| Health Data | Fitbit Web API / device sensors | Health Services API + Health Connect |
| Complications | Clock face only | WidgetKit-style Tiles + Complications |
| Background | Companion app on phone | WorkManager, Health Services passive |
| Distribution | Fitbit App Gallery | Google Play Store |
| Settings | JSX settings page | Phone companion app or on-watch Preferences |

**Migration checklist:**
1. **Rewrite UI in Compose for Wear OS.** No automated migration exists from SVG/JS to Compose.
2. **Replace Fitbit Web API with Health Connect.** Fitbit Web API remains available for historical data, but new data on Pixel Watch flows through Health Connect.
3. **Replace peer messaging with Data Layer API.** The `peerSocket` pattern maps to `MessageClient` / `DataClient` on Wear OS.
4. **Replace clock face with Watch Face Format (WFF).** Custom watch faces must use WFF on Wear OS 5+.
5. **Port settings to companion phone app or on-watch PreferenceScreen.**

### Fitbit Web API (Still Active)

The Fitbit Web API remains operational for accessing user health data from server-side applications:

```bash
# OAuth 2.0 flow to access Fitbit data
# Scopes: activity, heartrate, sleep, weight, nutrition, oxygen_saturation

# Get daily activity summary
GET https://api.fitbit.com/1/user/-/activities/date/2026-03-06.json
Authorization: Bearer <access_token>

# Get heart rate time series (1-day, 1-min intervals)
GET https://api.fitbit.com/1/user/-/activities/heart/date/2026-03-06/1d/1min.json
Authorization: Bearer <access_token>

# Get sleep log
GET https://api.fitbit.com/1.2/user/-/sleep/date/2026-03-06.json
Authorization: Bearer <access_token>
```

**Rate limits:** 150 API requests per hour per user. Use webhooks (Subscription API) instead of polling for real-time updates.

### Checklist

- ✅ For new projects, target Wear OS (not Fitbit OS) — Fitbit SDK is sunset
- ✅ Use Fitbit Web API for server-side access to legacy Fitbit user data
- ✅ If migrating from Fitbit OS, plan a full rewrite (no automated migration tools)
- ✅ Register for Fitbit Web API Subscription webhooks instead of polling
- ✅ Support Health Connect on Pixel Watch for accessing Fitbit health data natively
- ❌ Do not submit new apps to Fitbit App Gallery (no longer accepting submissions as of 2024)
- ❌ Do not assume Fitbit Web API data and Health Connect data are identical (different processing pipelines, slight metric differences)
- ❌ Do not rely on Fitbit companion app architecture on Wear OS (Wear OS apps can access internet directly)

### Anti-patterns

1. **Building new features on Fitbit SDK** — The platform is frozen. Invest in Wear OS for future-proof development.
2. **Direct API migration without UX redesign** — Fitbit's SVG-based UI and Wear OS Compose have fundamentally different interaction patterns. A 1:1 port produces a poor experience.
3. **Ignoring Health Connect** — On Pixel Watch, health data flows through Health Connect. Accessing only the Fitbit Web API misses real-time data available on-device.
4. **Polling Fitbit Web API** — Making 150 requests/hour to check for new data. Use the Subscription API for push-based updates.

**Sources:** [Fitbit Developer Docs](https://dev.fitbit.com/), [Fitbit Web API Reference](https://dev.fitbit.com/build/reference/web-api/), [Google Fitbit Acquisition Blog](https://blog.google/products/fitbit/), [Health Connect](https://developer.android.com/health-and-fitness/guides/health-connect)

---

## BL. ECG Waveform Rendering

> Displaying real-time ECG data on a watch screen: paper speed standards, gain, grid overlay, regulatory considerations.
> Sources: [Apple ECG](https://developer.apple.com/documentation/healthkit/hkelectrocardiogram), [AHA ECG Standards](https://www.ahajournals.org/doi/10.1161/CIRCULATIONAHA.106.180200), [FDA De Novo DEN180044](https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN180044.pdf)

### Overview

ECG (electrocardiogram) recording is available on Apple Watch Series 4+ and Samsung Galaxy Watch 4+. Rendering a medical-grade ECG waveform on a 1.5-2 inch screen requires careful adherence to AHA/ACC display standards while adapting for the tiny viewport. The Apple ECG app received FDA De Novo clearance (Class II) for single-lead ECG with atrial fibrillation detection.

### ECG Display Standards

Medical ECG paper uses a standardized grid:

| Parameter | Standard Value | Watch Adaptation |
|-----------|---------------|-----------------|
| Paper speed | 25 mm/s (standard), 50 mm/s (detail) | 25 mm/s mapped to screen pixels |
| Gain | 10 mm/mV (standard) | 10 mm/mV or auto-scale to fit screen height |
| Grid major divisions | 5 mm (= 0.2 s horizontally, 0.5 mV vertically) | Render as subtle lines or dots |
| Grid minor divisions | 1 mm (= 0.04 s horizontally, 0.1 mV vertically) | Omit on watch (too dense for small screen) |
| Waveform line width | 0.5-1 mm on paper | 2-3 px on watch (retina equivalent) |
| Background color | White (paper) or black (monitor) | Black preferred on OLED (saves power, reduces burn-in) |
| Waveform color | Black (paper) or green (monitor) | Green (#00FF00) on black — high contrast, medical convention |

**Mapping to watch pixels (Apple Watch 45mm, 396x484 px, ~326 PPI):**
- 1 mm on paper = ~12.8 px at 326 PPI
- 25 mm/s paper speed = 320 px/s on screen
- At 320 px/s, a 396 px-wide screen shows ~1.24 seconds of ECG
- 10 mm/mV gain = 128 px/mV
- Typical QRS complex height (1-2 mV) = 128-256 px (fits comfortably in screen height)

### Real-Time ECG Rendering

**watchOS — Reading ECG from HealthKit (post-recording):**
```swift
import HealthKit

func readECG() async throws {
    let ecgType = HKObjectType.electrocardiogramType()
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    let query = HKSampleQuery(sampleType: ecgType, predicate: nil,
                               limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, _ in
        guard let ecg = samples?.first as? HKElectrocardiogram else { return }

        // ECG metadata
        let classification = ecg.classification  // .sinusRhythm, .atrialFibrillation, .inconclusive
        let averageHR = ecg.averageHeartRate     // HKQuantity (bpm)
        let samplingFrequency = ecg.samplingFrequency  // HKQuantity (Hz), typically 512 Hz
        let numberOfVoltageMeasurements = ecg.numberOfVoltageMeasurements  // ~15,360 for 30s

        // Read voltage measurements
        var voltages: [Double] = []
        let voltageQuery = HKElectrocardiogramQuery(ecg) { query, result in
            switch result {
            case .measurement(let measurement):
                if let voltage = measurement.quantity(for: .appleWatchSimilarToLeadI) {
                    voltages.append(voltage.doubleValue(for: .voltUnit(with: .micro)))
                    // Voltage in microvolts (typically -500 to +1500 uV)
                }
            case .done:
                // All measurements received — render waveform
                DispatchQueue.main.async {
                    self.renderECGWaveform(voltages: voltages, sampleRate: 512)
                }
            case .error(let error):
                print("ECG query error: \(error)")
            @unknown default: break
            }
        }
        self.healthStore.execute(voltageQuery)
    }
    healthStore.execute(query)
}
```

**SwiftUI ECG Waveform View:**
```swift
struct ECGWaveformView: View {
    let voltages: [Double]  // in microvolts
    let sampleRate: Double  // 512 Hz
    let paperSpeed: Double = 25.0  // mm/s
    let gain: Double = 10.0  // mm/mV

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let ppi: Double = 326  // Apple Watch PPI
            let mmPerPx = 25.4 / ppi  // ~0.078 mm/px

            // Pixels per second = paperSpeed / mmPerPx
            let pxPerSecond = paperSpeed / mmPerPx  // ~320 px/s
            // Pixels per mV = gain / mmPerPx
            let pxPerMV = gain / mmPerPx  // ~128 px/mV

            // How many samples fit on screen
            let visibleDuration = Double(width) / pxPerSecond  // ~1.24 s
            let visibleSamples = Int(visibleDuration * sampleRate)  // ~635 samples

            ZStack {
                // Grid (major divisions only)
                ECGGridView(width: width, height: height, mmPerPx: mmPerPx)

                // Waveform
                Path { path in
                    let startIdx = max(0, voltages.count - visibleSamples)
                    let centerY = height / 2

                    for i in startIdx..<voltages.count {
                        let x = Double(i - startIdx) / Double(visibleSamples) * Double(width)
                        let voltageMV = voltages[i] / 1000.0  // uV to mV
                        let y = centerY - (voltageMV * pxPerMV)

                        if i == startIdx {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.green, lineWidth: 2)
            }
        }
    }
}

struct ECGGridView: View {
    let width: Double
    let height: Double
    let mmPerPx: Double

    var body: some View {
        Canvas { context, size in
            let majorSpacing = 5.0 / mmPerPx  // 5mm grid = ~64 px

            // Vertical lines (time markers, 0.2s each)
            var x: Double = 0
            while x < width {
                context.stroke(
                    Path { p in p.move(to: CGPoint(x: x, y: 0)); p.addLine(to: CGPoint(x: x, y: height)) },
                    with: .color(.gray.opacity(0.3)),
                    lineWidth: 0.5
                )
                x += majorSpacing
            }

            // Horizontal lines (voltage markers, 0.5mV each)
            var y: Double = 0
            while y < height {
                context.stroke(
                    Path { p in p.move(to: CGPoint(x: 0, y: y)); p.addLine(to: CGPoint(x: width, y: y)) },
                    with: .color(.gray.opacity(0.3)),
                    lineWidth: 0.5
                )
                y += majorSpacing
            }
        }
    }
}
```

### P-QRS-T Labeling

On a watch-sized screen, full waveform annotation is impractical. Best practices:

- **Do not label individual P, QRS, T waves on the live waveform** — too small, too dense
- **Show classification result as text above waveform:** "Sinus Rhythm" or "Atrial Fibrillation"
- **Show average heart rate** prominently (large font, top of screen)
- **Use color coding for classification:** Green = sinus rhythm, Red = AFib detected, Yellow = inconclusive
- **Detailed annotation (P-QRS-T markers) should be on the phone app** where the screen is large enough

### Data Export

```swift
// Export ECG as PDF (medical standard format)
func exportECGAsPDF(voltages: [Double], metadata: ECGMetadata) -> Data {
    let pageSize = CGRect(x: 0, y: 0, width: 612, height: 792) // Letter size
    let renderer = UIGraphicsPDFRenderer(bounds: pageSize)

    return renderer.pdfData { context in
        context.beginPage()
        // Draw standard ECG grid (25mm/s, 10mm/mV)
        // Draw waveform
        // Add metadata: date, time, HR, classification, device info
        // Add calibration pulse (1mV, 200ms) at start
    }
}

// Export as CSV for research use
func exportAsCSV(voltages: [Double], sampleRate: Double) -> String {
    var csv = "timestamp_ms,voltage_uv\n"
    for (i, v) in voltages.enumerated() {
        let timeMs = Double(i) / sampleRate * 1000.0
        csv += "\(String(format: "%.1f", timeMs)),\(String(format: "%.1f", v))\n"
    }
    return csv
}
```

### Regulatory Framework

| Aspect | Apple Watch ECG | Samsung Galaxy Watch ECG |
|--------|----------------|------------------------|
| Regulatory clearance | FDA De Novo (Class II) DEN180044 | FDA 510(k) K222575 |
| Intended use | Rhythm classification (AFib vs Sinus) | Rhythm classification (AFib vs Sinus) |
| Not intended for | Diagnosis of heart attacks, other arrhythmias | Same |
| Lead type | Single-lead (similar to Lead I) | Single-lead (Lead I equivalent) |
| Recording duration | 30 seconds | 30 seconds |
| Sample rate | 512 Hz | 500 Hz |
| Age restriction | 22+ years (Apple), no restriction on Samsung | 22+ years |
| Contraindications | Pacemakers, implanted defibrillators | Same |

**Key regulatory UX requirements:**
- Must display disclaimer: "This is not a medical diagnosis"
- Must indicate when results are inconclusive (poor signal, too much motion)
- Must recommend contacting a healthcare provider for abnormal results
- Must not use alarming language (avoid "heart attack" or "danger")
- PDF export must include calibration pulse and standard formatting for physician review

### Checklist

- ✅ Use 25 mm/s paper speed and 10 mm/mV gain as defaults (AHA standard)
- ✅ Green waveform on black background for OLED watch displays
- ✅ Show classification result prominently (Sinus Rhythm / AFib / Inconclusive)
- ✅ Display average heart rate during recording
- ✅ Include calibration pulse (1 mV, 200 ms) in exported PDF
- ✅ Provide PDF and/or CSV export for sharing with healthcare provider
- ✅ Show disclaimer text per regulatory requirements
- ✅ Waveform line width: 2-3 px (visible on small screen without obscuring detail)
- ❌ Do not label individual P-QRS-T waves on the watch screen (too small)
- ❌ Do not render minor grid divisions on watch (1 mm grid is < 13 px — visual noise)
- ❌ Do not use red for the waveform color (red is reserved for alarm states in medical displays)
- ❌ Do not allow ECG recording during physical activity (motion artifacts invalidate results)

### Anti-patterns

1. **Rendering without calibration reference** — Without the 1 mV / 200 ms calibration pulse, a physician cannot assess gain accuracy. Always include it in exports.
2. **Auto-scaling gain** — Dynamically adjusting the Y-axis to fit the waveform makes it impossible to visually compare recordings. Use fixed 10 mm/mV gain; offer 5 mm/mV and 20 mm/mV as options.
3. **Continuous ECG streaming** — Apple Watch records 30-second ECG snapshots, not continuous ECG. Designing UI for "live ECG monitoring" sets incorrect user expectations and may violate regulatory clearance scope.
4. **Diagnostic language** — Using words like "diagnosis," "heart attack detected," or "seek emergency care immediately" in the app. The device is cleared for rhythm classification only, not diagnosis.

**Sources:** [Apple HKElectrocardiogram](https://developer.apple.com/documentation/healthkit/hkelectrocardiogram), [AHA ECG Standards (Circulation 2007)](https://www.ahajournals.org/doi/10.1161/CIRCULATIONAHA.106.180200), [FDA De Novo DEN180044](https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN180044.pdf), [Samsung ECG FDA 510(k)](https://www.accessdata.fda.gov/cdrh_docs/pdf22/K222575.pdf)

---

## BM. Continuous Glucose Monitor (CGM) Integration

> Displaying CGM data on wearables: glucose values, trend arrows, time-in-range, urgent alerts, and platform integration.
> Sources: [Apple HealthKit Glucose](https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/bloodglucose), [Dexcom Developer API](https://developer.dexcom.com/), [FDA CGM Guidance](https://www.fda.gov/medical-devices/in-vitro-diagnostics/glucose-monitoring-devices)

### Overview

Continuous Glucose Monitors (CGMs) like Dexcom G7 and Abbott FreeStyle Libre 3 provide real-time glucose readings every 1-5 minutes. Wearable integration allows users (primarily Type 1/Type 2 diabetes patients) to glance at glucose levels, trends, and alerts without pulling out a phone. This is a safety-critical feature — missed hypoglycemia alerts can be life-threatening.

### Glucose Display Standards

| Element | Value | Unit Options |
|---------|-------|-------------|
| Glucose range (normal) | 70-180 mg/dL (3.9-10.0 mmol/L) | mg/dL (US), mmol/L (international) |
| Hypoglycemia (low) | < 70 mg/dL (< 3.9 mmol/L) | Yellow alert |
| Urgent low | < 55 mg/dL (< 3.1 mmol/L) | Red alert + haptic + sound |
| Hyperglycemia (high) | > 250 mg/dL (> 13.9 mmol/L) | Orange alert |
| Target range | 70-180 mg/dL (customizable) | Green zone |

### Watch UI Layout for CGM

```
┌─────────────────────┐
│     12:45 PM        │
│                     │
│    ↗ 142           │   ← Trend arrow + current value (largest element)
│     mg/dL           │
│                     │
│  ▁▂▃▅▆▇▆▅▃▂▃▅▆    │   ← Mini sparkline (last 3 hours)
│  ─ ─ ─ ─ ─ ─ ─ ─  │   ← Target range line (180 mg/dL)
│                     │
│  Time in range: 78% │   ← Daily TIR percentage
│  Last reading: 2m   │   ← Data freshness indicator
└─────────────────────┘
```

**Design specifications:**

| Element | Size | Priority |
|---------|------|----------|
| Current glucose value | 40-48 sp (largest text on screen) | 1 (must be readable at arm's length) |
| Trend arrow | 24x24 dp minimum, adjacent to value | 1 (equal to value) |
| Unit label (mg/dL or mmol/L) | 14 sp | 2 |
| Sparkline graph | Full width, 40-60 dp height | 2 |
| Time-in-range % | 16 sp | 3 |
| Data freshness ("2 min ago") | 12 sp | 3 (critical for safety — stale data warning) |

### Trend Arrows

CGM trend arrows indicate the rate of glucose change:

| Arrow | Symbol | Rate of Change | Meaning |
|-------|--------|---------------|---------|
| Rising rapidly | ↑↑ | > +3 mg/dL/min | Glucose increasing fast |
| Rising | ↑ | +2 to +3 mg/dL/min | Glucose increasing |
| Rising slightly | ↗ | +1 to +2 mg/dL/min | Glucose increasing slowly |
| Steady | → | -1 to +1 mg/dL/min | Glucose stable |
| Falling slightly | ↘ | -1 to -2 mg/dL/min | Glucose decreasing slowly |
| Falling | ↓ | -2 to -3 mg/dL/min | Glucose decreasing |
| Falling rapidly | ↓↓ | < -3 mg/dL/min | Glucose decreasing fast |

**Arrow rendering rules:**
- Arrow size: 24x24 dp minimum, 32x32 dp preferred
- Color matches glucose zone (green in range, yellow low, red urgent low, orange high)
- Double arrows (↑↑, ↓↓) should be visually distinct — use bolder stroke or larger size
- Animate arrow briefly (0.3 s pulse) when value changes to draw attention

### Time-in-Range Visualization

Time-in-Range (TIR) is the percentage of the day spent within the target glucose range (70-180 mg/dL). It is the primary metric endorsed by the International Consensus on TIR (2019).

**Targets (per International Consensus):**

| Metric | Target (Type 1/2) | Good | Needs Improvement |
|--------|-------------------|------|-------------------|
| Time in Range (70-180) | > 70% | 50-70% | < 50% |
| Time Below Range (< 70) | < 4% | 4-10% | > 10% |
| Time Below Range (< 54) | < 1% | 1-3% | > 3% |
| Time Above Range (> 180) | < 25% | 25-40% | > 40% |
| Time Above Range (> 250) | < 5% | 5-10% | > 10% |

**Watch complication for TIR:**
```swift
// Circular complication showing TIR as a ring gauge
struct TIRComplicationView: View {
    let timeInRange: Double  // 0.0 to 1.0

    var body: some View {
        Gauge(value: timeInRange) {
            Text("TIR")
                .font(.system(.caption2, design: .rounded))
        } currentValueLabel: {
            Text("\(Int(timeInRange * 100))%")
                .font(.system(.body, design: .rounded, weight: .bold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(tirColor)
    }

    var tirColor: Color {
        switch timeInRange {
        case 0.7...: return .green
        case 0.5..<0.7: return .yellow
        default: return .red
        }
    }
}
```

### Urgent Low Alert UX

Urgent low glucose (< 55 mg/dL / < 3.1 mmol/L) is a medical emergency. The watch alert must be impossible to miss:

1. **Haptic:** Continuous strong vibration pattern — repeated long buzzes (500 ms on, 200 ms off) until acknowledged
2. **Visual:** Full-screen red overlay with large white text: "URGENT LOW" + value. Override always-on display dimming.
3. **Audio:** Alarm sound at maximum volume (bypass Do Not Disturb and silent mode if platform allows)
4. **Persistence:** Alert must remain on screen until user explicitly acknowledges (tap "Dismiss" or "I'm OK")
5. **Repeat:** If not acknowledged within 5 minutes, re-alert. If not acknowledged within 15 minutes, escalate (notify emergency contacts if configured)
6. **Data freshness:** If CGM data is > 10 minutes old, show "NO DATA" warning instead of stale value (stale low reading may no longer be accurate)

### HealthKit Glucose Integration (watchOS)

```swift
// Read glucose samples from HealthKit
let glucoseType = HKQuantityType(.bloodGlucose)

let query = HKSampleQuery(
    sampleType: glucoseType,
    predicate: HKQuery.predicateForSamples(
        withStart: Date().addingTimeInterval(-3 * 3600), // Last 3 hours
        end: Date()
    ),
    limit: HKObjectQueryNoLimit,
    sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
) { _, samples, _ in
    guard let glucoseSamples = samples as? [HKQuantitySample] else { return }

    for sample in glucoseSamples {
        let mgdl = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .milli).unitDivided(by: .liter()))
        // Convert: mg/dL to mmol/L = mgdl / 18.0
        let timestamp = sample.startDate
        let source = sample.sourceRevision.source.name // "Dexcom G7", "LibreLink", etc.
    }
}
healthStore.execute(query)

// Background delivery for new glucose readings
healthStore.enableBackgroundDelivery(for: glucoseType, frequency: .immediate) { success, error in
    // App wakes when new glucose sample arrives
}
```

### Dexcom API Integration (Server-Side)

```bash
# Dexcom Share API (for companion phone app)
# OAuth 2.0 + API calls

# Get estimated glucose values (EGVs) for last 3 hours
GET https://api.dexcom.com/v3/users/self/egvs
    ?startDate=2026-03-06T09:00:00&endDate=2026-03-06T12:00:00
Authorization: Bearer <access_token>

# Response:
{
    "egvs": [
        {
            "systemTime": "2026-03-06T11:45:00",
            "displayTime": "2026-03-06T11:45:00",
            "value": 142,          // mg/dL
            "unit": "mg/dL",
            "trendRate": 1.5,      // mg/dL/min
            "trend": "slightlyRising"  // Trend arrow name
        }
    ]
}
```

### Checklist

- ✅ Display current glucose value as the largest element (40-48 sp)
- ✅ Always show trend arrow adjacent to value (never hidden or secondary)
- ✅ Show data freshness ("2 min ago") — critical for safety
- ✅ Support both mg/dL and mmol/L with user preference toggle
- ✅ Urgent low alerts must bypass Do Not Disturb / silent mode
- ✅ Alert persistence: require explicit user acknowledgment for urgent lows
- ✅ Show "NO DATA" or "SIGNAL LOST" when CGM data is > 10 minutes old
- ✅ Use color coding: green (in range), yellow (low), red (urgent low), orange (high)
- ✅ Include sparkline showing 3-hour trend at a glance
- ❌ Do not show glucose value without the trend arrow (value alone is insufficient for decision-making)
- ❌ Do not use small text (< 32 sp) for the glucose value — must be readable with a quick glance
- ❌ Do not suppress urgent low alerts in any watch mode (theater, sleep, workout)
- ❌ Do not display interpolated/predicted values as actual readings without clear labeling

### Anti-patterns

1. **Delayed alerts** — Batching glucose notifications to reduce frequency. A 15-minute delay on an urgent low alert can cause loss of consciousness. Deliver immediately.
2. **Value without context** — Showing "142" without unit, trend arrow, or time-in-range. The number alone is meaningless without rate-of-change context.
3. **Fixed mg/dL only** — Not supporting mmol/L. Most countries outside the US use mmol/L. Always provide a unit preference.
4. **Alarm fatigue** — Alerting at every glucose value outside range. Reserve strong alerts for urgent thresholds only. Use subtle notifications for mild highs/lows.

**Sources:** [Apple HealthKit Blood Glucose](https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier/bloodglucose), [Dexcom Developer API](https://developer.dexcom.com/), [International Consensus on TIR (Diabetes Care, 2019)](https://diabetesjournals.org/care/article/42/8/1593/36367/), [FDA CGM Guidance](https://www.fda.gov/medical-devices/in-vitro-diagnostics/glucose-monitoring-devices)

---

## BN. AFib / Irregular Rhythm Notification

> PPG-based atrial fibrillation detection on consumer watches: algorithm overview, notification UX, regulatory framework, and clinical validation.
> Sources: [Apple Irregular Rhythm Notification](https://developer.apple.com/documentation/healthkit/hkcategoryvalueafibrillationburden), [FDA De Novo DEN180042](https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN180042.pdf), [Stanford Apple Heart Study (NEJM 2019)](https://www.nejm.org/doi/full/10.1056/NEJMoa1901183), [Samsung BioActive Sensor](https://semiconductor.samsung.com/us/processor/bio-sensor/)

### Overview

Consumer smartwatches can detect irregular heart rhythms suggestive of atrial fibrillation (AFib) using photoplethysmography (PPG) — the same green LED sensor used for heart rate monitoring. This is a passive background feature that periodically checks rhythm regularity and alerts the user if an irregular pattern is detected. It is NOT a diagnosis — it is a notification that prompts the user to consult a healthcare provider.

### Detection Algorithm Overview

**Apple Irregular Rhythm Notification:**
1. PPG sensor activates intermittently in background (every ~1-2 hours when the user is still)
2. Collects ~15 seconds of pulse waveform data
3. Tachogram analysis: measures pulse-to-pulse intervals (R-R interval equivalent)
4. Applies a neural network classifier trained on ECG-labeled data
5. If 5 of 6 consecutive tachogram checks over ~48 hours show irregularity, notification fires
6. Single isolated irregular reading does NOT trigger notification (reduces false positives)

**Samsung Galaxy Watch (BioActive Sensor):**
1. Uses PPG + electrical heart rate sensor (ECG electrodes)
2. Background irregular rhythm monitoring via PPG
3. On-demand ECG recording (user touches side button) for confirmation
4. Samsung Health app processes and classifies rhythm

**Key performance metrics (from clinical studies):**

| Metric | Apple Watch (Stanford Study) | Samsung (published data) |
|--------|------------------------------|-------------------------|
| Positive predictive value (PPV) | 84% (ECG-confirmed AFib after notification) | ~87% |
| Sensitivity | Not reported (passive monitoring, no ground truth for non-notified) | ~95% (controlled study) |
| Notification rate | 0.52% of participants received notification | N/A |
| False positive triggers | ~16% of notifications (not AFib on follow-up) | ~13% |

### Notification UX

**What the notification MUST communicate:**

1. **What was detected:** "Irregular rhythm detected" (never "Atrial Fibrillation detected" — the watch cannot diagnose)
2. **What it means:** "Your heart rhythm showed signs of irregularity that may be consistent with atrial fibrillation"
3. **What to do:** "Please consult your healthcare provider. This is not a diagnosis."
4. **Supporting data:** Date/time of detection, number of irregular checks, option to record an ECG (if device supports it)
5. **What NOT to do:** "Do not call emergency services based solely on this notification" (unless symptoms like chest pain, dizziness are present)

**Apple's notification flow:**
```
[Background Detection]
        ↓
[5 of 6 checks irregular over ~48h]
        ↓
[Notification on Watch]
"Irregular Rhythm — Your heart rhythm appears irregular.
 This may indicate atrial fibrillation."
        ↓
[Tap to view details]
        ↓
[Detail Screen]
- History of irregular readings (dates/times)
- "Record an ECG" button (Series 4+)
- "Learn More" link
- "Talk to Your Doctor" guidance
        ↓
[Optional: Record 30-second ECG]
        ↓
[ECG Result: Sinus Rhythm / AFib / Inconclusive]
        ↓
[PDF export for doctor visit]
```

**Watch notification design:**

| Element | Specification |
|---------|---------------|
| Notification icon | Heart with irregular rhythm symbol |
| Title | "Irregular Rhythm" (16 sp, bold) |
| Body | 2-3 lines of plain language explanation (14 sp) |
| Actions | "View Details" (primary), "Dismiss" (secondary) |
| Haptic | Gentle double-tap (NOT alarm pattern — avoid panic) |
| Sound | Default notification sound (NOT siren or alarm) |
| Persistence | Remains in notification center until read |
| Repeat | Does not re-notify for 48 hours after acknowledgment |

### Clinical Validation: Sensitivity and Specificity

**Critical distinction — what the watch CAN and CANNOT detect:**

| Condition | Watch Detection | Notes |
|-----------|----------------|-------|
| Atrial Fibrillation (AFib) | Yes (with limitations) | PPG detects irregular R-R intervals |
| Atrial Flutter | Partial (sometimes classified as irregular) | Less reliably detected than AFib |
| Premature Ventricular Contractions (PVCs) | May trigger false positive | PVCs can appear as irregularity |
| Heart Attack (MI) | No | Requires 12-lead ECG with ST segment analysis |
| Heart Block | No | Requires ECG, not detectable via PPG |
| Supraventricular Tachycardia (SVT) | Sometimes (as fast HR) | Detected as tachycardia, not specifically SVT |
| Ventricular Fibrillation | No (medical emergency) | Patient likely unconscious — watch detection irrelevant |

### Regulatory Framework

| Regulatory Path | Apple Watch | Samsung Galaxy Watch |
|----------------|-------------|---------------------|
| Irregular Rhythm Notification | FDA De Novo DEN180042 (Class II) | FDA 510(k) |
| ECG App | FDA De Novo DEN180044 (Class II) | FDA 510(k) K222575 |
| Classification | OTC (over-the-counter), no prescription | OTC |
| Intended population | Adults 22+ (Apple), Adults (Samsung) | Adults |
| Excluded populations | Known AFib, pacemaker users, < 22 years | Known AFib, pacemaker users |
| Labeling requirement | "Not intended to replace traditional diagnosis" | Same |

**Regulatory UX requirements:**
- The app must NOT use the word "diagnose" or "diagnosis"
- Must include "This feature does not detect heart attacks" in onboarding
- Must state excluded populations (pacemakers, known AFib, under 22)
- Must recommend physician follow-up, never self-treatment
- Must allow user to disable notifications (opt-out)
- Must store notification history for physician review (exportable)

### Implementation Considerations for Third-Party Apps

Third-party apps cannot directly access the raw irregular rhythm notification algorithm on either platform. However, they can:

**watchOS:**
```swift
// Read AFib history from HealthKit (watchOS 9+ / iOS 16+)
let afiburdenType = HKCategoryType(.atrialFibrillationBurden)

let query = HKSampleQuery(sampleType: afiburdenType, predicate: nil,
                           limit: 10, sortDescriptors: nil) { _, samples, _ in
    for sample in (samples as? [HKCategorySample]) ?? [] {
        // .atrialFibrillationBurden: percentage of time in AFib over a period
        // Values: HKCategoryValueAppleWalkingSteadinessEvent or custom
        let startDate = sample.startDate
        let endDate = sample.endDate
    }
}

// Read ECG recordings
let ecgType = HKObjectType.electrocardiogramType()
// Query and check ecg.classification == .atrialFibrillation
```

**Wear OS:**
- Health Connect does not expose raw AFib notification data
- Apps can read heart rate variability (HRV) data: `HEART_RATE_VARIABILITY_RMSSD`
- Custom PPG-based rhythm analysis requires IRB approval and regulatory clearance for medical claims

### Checklist

- ✅ Use plain language: "irregular rhythm" not "atrial fibrillation detected"
- ✅ Always include "This is not a diagnosis" disclaimer
- ✅ Recommend physician consultation — never suggest self-treatment
- ✅ Allow users to disable irregular rhythm notifications (opt-out required)
- ✅ Store notification history with timestamps for physician review
- ✅ Provide ECG recording option after notification (if hardware supports)
- ✅ Export results as PDF for clinical use
- ✅ Use gentle notification pattern (double-tap haptic), NOT alarm
- ✅ Exclude known AFib patients and pacemaker users in onboarding
- ❌ Do not say "You have atrial fibrillation" — say "irregular rhythm that may be consistent with AFib"
- ❌ Do not trigger emergency calls automatically based on irregular rhythm detection
- ❌ Do not re-notify within 48 hours of a previous notification (alarm fatigue)
- ❌ Do not claim detection of heart attacks, heart blocks, or other non-AFib conditions

### Anti-patterns

1. **Alarm-style notification** — Using siren sound and red flashing screen for irregular rhythm notification. This causes panic. The detection is probabilistic (~84% PPV), and many users will be false positives. Use calm, informative notification design.
2. **No physician guidance** — Showing "Irregular Rhythm" without clear next steps. Users need actionable guidance: "Schedule an appointment with your doctor and show them this report."
3. **Claiming diagnostic capability** — Marketing or UI copy that says "detects atrial fibrillation." The device detects irregular rhythm *suggestive* of AFib. The distinction matters legally and medically.
4. **Continuous monitoring hype** — Implying the watch monitors every heartbeat. In reality, PPG checks occur intermittently (~every 1-2 hours). AFib episodes between checks can be missed entirely.

**Sources:** [Stanford Apple Heart Study (NEJM 2019)](https://www.nejm.org/doi/full/10.1056/NEJMoa1901183), [FDA De Novo DEN180042](https://www.accessdata.fda.gov/cdrh_docs/reviews/DEN180042.pdf), [Apple Irregular Rhythm](https://www.apple.com/healthcare/docs/site/Apple_Watch_Irregular_Rhythm_Notification_Feature.pdf), [Samsung BioActive Sensor](https://semiconductor.samsung.com/us/processor/bio-sensor/)

---

## BO. Academic Validation Studies

> Published clinical research validating wearable health sensors: heart rate, rhythm, SpO2, blood pressure, COVID detection, and the consumer vs clinical-grade distinction.
> Sources: [Stanford Apple Heart Study (NEJM 2019)](https://www.nejm.org/doi/full/10.1056/NEJMoa1901183), [DETECT Study (Nature Medicine 2022)](https://www.nature.com/articles/s41591-022-01988-1), [Fitbit COVID Study (Nature Medicine 2021)](https://www.nature.com/articles/s41591-020-1123-x), [Samsung BP Validation (Hypertension 2021)]

### Overview

Consumer wearable health data is increasingly used in research and clinical decision-making, but accuracy varies significantly by sensor type, device model, and measurement conditions. Understanding published validation studies helps developers set appropriate expectations in UI copy, choose reliable data sources, and avoid overpromising sensor accuracy.

### Stanford Apple Heart Study (2019)

**Publication:** Perez et al., "Large-Scale Assessment of a Smartwatch to Identify Atrial Fibrillation," NEJM 2019; 381:1909-1917.

| Metric | Value |
|--------|-------|
| Participants enrolled | 419,297 |
| Notification rate (irregular rhythm) | 0.52% (2,161 participants) |
| Positive predictive value (PPV) | 84% (of notified participants who received ECG patch) |
| Simultaneous AFib on ECG patch + Apple Watch | 71% concordance |
| Study duration | 8 months |
| Device | Apple Watch Series 1-3 |
| Age of notified participants (median) | 57 years |

**Key findings for developers:**
- 0.52% notification rate means the vast majority of users will never see an irregular rhythm notification. Design for this — do not make AFib detection a prominent marketing feature for general populations.
- 84% PPV means ~16% of notifications are false positives. UI must manage user anxiety appropriately.
- Young users (< 40) had higher false positive rates due to ectopic beats (PVCs) being misclassified.

### DETECT Study — Scripps Research (2022)

**Publication:** Quer et al., "Wearable Sensor Data and Self-Reported Symptoms for COVID-19 Detection," Nature Medicine 2022; 28:1745-1752.

| Metric | Value |
|--------|-------|
| Participants | 39,701 |
| Devices used | Fitbit, Apple Watch, Garmin |
| Key biomarkers | Elevated resting heart rate, reduced HRV, sleep disruption |
| Detection accuracy (AUC) | 0.80 for COVID-19 vs other respiratory infections |
| Earliest detection | Up to 2 days before symptom onset |
| Sensor data used | Heart rate, HRV, sleep, steps, SpO2 |

**Key findings for developers:**
- Resting heart rate elevation of 1-3 bpm and HRV depression are subtle but detectable signals.
- Individual baseline comparison (personal normal vs current) is more informative than population norms.
- SpO2 dips during sleep correlated with respiratory illness severity.

### Fitbit Influenza/COVID Prediction (2020)

**Publication:** Radin et al., "Harnessing Wearable Device Data to Improve State-Level Real-Time Estimation of Influenza-Like Illness in the USA: a Population-Based Study," Lancet Digital Health 2020; 2:e85-e93.

And: Mishra et al., "Pre-symptomatic Detection of COVID-19 from Smartwatch Data," Nature Biomedical Engineering 2020.

| Metric | Value |
|--------|-------|
| Participants (Fitbit study) | 47,249 |
| Resting HR elevation during illness | +1.5 to +3 bpm above personal baseline |
| Sleep increase during illness | +0.5 to +1.5 hours/night |
| Step decrease during illness | -20% to -40% below baseline |
| Prediction accuracy | AUC 0.78-0.82 for illness detection |

### Samsung Galaxy Watch Blood Pressure Validation

**Publication:** Shin et al., "Validation of Samsung Galaxy Watch Active2 Blood Pressure Monitoring," Hypertension 2021.

| Metric | Value |
|--------|-------|
| Method | Pulse Transit Time (PTT) via PPG + ECG |
| Calibration required | Yes — against cuff measurement every 28 days |
| Mean difference (systolic) | +/- 3.3 mmHg (vs cuff reference) |
| Mean difference (diastolic) | +/- 3.1 mmHg (vs cuff reference) |
| Standard deviation | 8.4 mmHg systolic, 6.8 mmHg diastolic |
| ISO 81060-2 compliance | Met (within +/- 5 mmHg mean, +/- 8 mmHg SD) |
| Regulatory status | Cleared in South Korea (MFDS), not FDA-cleared for US market |
| Limitation | Accuracy degrades without regular recalibration; not validated for hypertensive crisis (> 180/120) |

### Wrist-Based SpO2 Accuracy

| Device | Accuracy vs Pulse Oximeter (finger) | Conditions | Source |
|--------|-------------------------------------|------------|--------|
| Apple Watch Series 6-10 | +/- 2% (90-100% range) | Stationary, good skin contact | Apple specs + Hafen et al. |
| Fitbit Sense 2 / Charge 5 | +/- 3% (90-100% range) | Stationary, overnight | Fitbit validation data |
| Garmin Venu 2/3 | +/- 3-4% (estimated) | Stationary | Garmin specs (no published validation) |
| Samsung Galaxy Watch 5/6/7 | +/- 2-3% | Stationary, post-calibration | Samsung Health specs |

**Critical UX caveat:** Wrist SpO2 is NOT clinically validated for:
- Detecting hypoxemia (SpO2 < 90%) — sensor accuracy degrades below 90%
- Dark skin tones (melanin absorbs green/red light, increasing error by 2-4%)
- During motion (artifact makes readings unreliable)
- Cold environments (vasoconstriction reduces perfusion at wrist)

### Clinical-Grade vs Consumer-Grade Distinction

| Feature | Clinical-Grade | Consumer-Grade (Watch) |
|---------|---------------|----------------------|
| ECG leads | 12-lead standard | Single-lead (Lead I equivalent) |
| ECG diagnosis capability | Full arrhythmia + ST analysis | AFib/Sinus only |
| SpO2 accuracy | +/- 1% (FDA-cleared finger probe) | +/- 2-4% (wrist PPG) |
| Blood pressure | Cuff-based (gold standard) | PTT-based (requires calibration, Samsung only) |
| Heart rate accuracy | Chest strap ECG-derived | PPG-derived (+/- 2-5 bpm at rest, +/- 10 bpm during exercise) |
| Regulatory standard | FDA Class II (510(k) or De Novo) | FDA De Novo or no clearance |
| Intended use | Clinical diagnosis | Wellness / screening |

**UX implication:** Always include language like "For informational purposes only. Not a medical device." unless the feature has specific FDA clearance (Apple ECG and Irregular Rhythm Notification do have clearance).

### Checklist

- ✅ Reference published validation data in user-facing accuracy disclaimers
- ✅ Distinguish between "screening" (watches) and "diagnosis" (clinical)
- ✅ Show accuracy ranges in settings/about: "Heart rate: +/- 2-5 bpm at rest"
- ✅ Use personal baseline comparison (more reliable than absolute thresholds)
- ✅ Account for skin tone and motion in accuracy disclaimers
- ✅ Recommend clinical follow-up for any abnormal findings
- ❌ Do not claim "medical grade" accuracy for consumer wearable data
- ❌ Do not use SpO2 readings below 90% for clinical decision-making
- ❌ Do not present blood pressure measurements without recent calibration status
- ❌ Do not hide accuracy limitations in fine print — surface them contextually

### Anti-patterns

1. **Precision theater** — Displaying heart rate as "78.3 bpm" implies false precision. The sensor is accurate to +/- 2-5 bpm. Display as "78 bpm" (integer).
2. **Ignoring population bias** — Studies like Stanford Apple Heart Study were conducted predominantly on lighter-skinned participants. PPG accuracy on darker skin tones is 2-4% lower. Acknowledge this limitation.
3. **Extrapolating beyond studied conditions** — Citing the Stanford study (resting adults) to justify heart rate accuracy during intense exercise. Most validation studies were conducted at rest.
4. **Omitting calibration state** — Samsung BP readings without recent calibration (< 28 days) are unreliable. The UI must show calibration date and warn when recalibration is due.

**Sources:** [Stanford Apple Heart Study (NEJM 2019)](https://www.nejm.org/doi/full/10.1056/NEJMoa1901183), [DETECT Study (Nature Medicine 2022)](https://www.nature.com/articles/s41591-022-01988-1), [Fitbit COVID (Lancet Digital Health 2020)](https://www.thelancet.com/journals/landig/article/PIIS2589-7500(19)30222-5/fulltext), [Samsung BP Validation (Hypertension 2021)](https://www.ahajournals.org/doi/10.1161/HYPERTENSIONAHA.121.17554)

---

## BP. watchOS SwiftUI App Architecture

> Modern watchOS app structure: @main lifecycle, NavigationStack, TabView, sheets, always-on display, and environment values.
> Sources: [Apple watchOS SwiftUI](https://developer.apple.com/documentation/watchos-apps/building-a-watchos-app), [WWDC 2022 - SwiftUI on watchOS](https://developer.apple.com/videos/play/wwdc2022/10133/), [WWDC 2023 - watchOS 10 Design](https://developer.apple.com/videos/play/wwdc2023/10138/)

### Overview

watchOS apps use the SwiftUI App lifecycle (@main) introduced in watchOS 7. As of watchOS 10, the recommended architecture uses NavigationStack for drill-down, vertical TabView for top-level paging, sheet presentations for modal flows, and environment-driven always-on display adaptations. WKInterfaceController (WatchKit storyboard-based) is fully deprecated.

### App Lifecycle

```swift
import SwiftUI

@main
struct CigaretteTrackerApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        // Setup: HealthKit authorization, notification registration
    }

    func applicationDidBecomeActive() {
        // Refresh data when app comes to foreground
    }

    func applicationWillResignActive() {
        // Save state before going to background
    }

    // Handle background tasks
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            // See section BD for detailed background task handling
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}
```

### NavigationStack (watchOS 10+)

```swift
struct ContentView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section("Today") {
                    NavigationLink(value: Route.counter) {
                        CounterRow(count: todayCount)
                    }
                    NavigationLink(value: Route.history) {
                        Label("History", systemImage: "calendar")
                    }
                }
                Section("Health") {
                    NavigationLink(value: Route.heartRate) {
                        Label("Heart Rate", systemImage: "heart.fill")
                    }
                }
            }
            .navigationTitle("Tracker")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .counter: CounterView()
                case .history: HistoryView()
                case .heartRate: HeartRateView()
                }
            }
        }
    }
}

enum Route: Hashable {
    case counter
    case history
    case heartRate
}
```

**Key NavigationStack rules on watchOS:**
- Back navigation: system swipe-from-left-edge gesture (automatic, do not override)
- Maximum recommended depth: 3 levels (more causes user disorientation on tiny screen)
- Use `navigationTitle` for each view — it appears in the top bar and aids orientation
- Deep linking: populate `NavigationPath` programmatically for push notification deep links

### TabView with Vertical Pagination (watchOS 10+)

```swift
struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Page 1: Summary
            SummaryView()
                .tag(0)
                .containerBackground(.blue.gradient, for: .tabView)

            // Page 2: Counter (primary interaction)
            CounterView()
                .tag(1)
                .containerBackground(.orange.gradient, for: .tabView)

            // Page 3: Trends
            TrendsView()
                .tag(2)
                .containerBackground(.green.gradient, for: .tabView)
        }
        .tabViewStyle(.verticalPage)  // Digital Crown scrolls between pages
        .onAppear {
            selectedTab = 1  // Start on counter page
        }
    }
}
```

**Vertical paging rules:**
- Digital Crown scrolls between pages (not swipe — swipe is for back navigation)
- Maximum 5-7 pages (more causes "where am I?" confusion)
- Each page should be a complete, self-contained screen (no scrolling within a page if possible)
- Use `.containerBackground` for visual page differentiation
- Page indicators appear on the right edge (system-managed)

### Sheet Presentations

```swift
struct CounterView: View {
    @State private var showingLog = false
    @State private var showingSettings = false

    var body: some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 64, weight: .bold, design: .rounded))

            Button("Log Cigarette") {
                logCigarette()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

            Button("Details") {
                showingLog = true
            }
        }
        .sheet(isPresented: $showingLog) {
            // Modal sheet slides up from bottom
            TodayLogView()
                .presentationDetents([.medium, .large]) // watchOS 10+
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingSettings = true }) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}
```

**Sheet rules on watchOS:**
- Sheets cover the full screen (no half-sheet on watches < watchOS 10)
- watchOS 10+ supports `.presentationDetents` but screen size limits usefulness
- Dismiss via swipe-down gesture or explicit "Done" button
- Use sheets for: settings, detail views, confirmation flows
- Do not nest sheets (sheet within a sheet — confusing navigation)

### Always-On Display State

```swift
struct CounterView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced

    var body: some View {
        VStack {
            if isLuminanceReduced {
                // Always-On Display (AOD) mode: simplified, power-efficient
                Text("\(count)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))  // Dimmed
                // No buttons, no animations, no bright colors
                // Update at most 1/minute
            } else {
                // Active mode: full UI
                Text("\(count)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(.orange)

                Button("Log Cigarette") {
                    logCigarette()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isLuminanceReduced)
    }
}
```

**Always-On Display rules:**
- `isLuminanceReduced == true` when wrist is lowered (AOD mode)
- Reduce brightness: use 60% opacity for white text, remove bright accent colors
- Remove interactive elements (buttons, sliders) — user cannot interact in AOD
- Remove animations — no timers, no spinning indicators
- Update content at most once per minute (system enforces this)
- Remove sensitive information (health data, personal details) in AOD for privacy
- Use `TimelineView(.everyMinute)` for time-based updates in AOD

### Environment Values for watchOS

```swift
struct AdaptiveView: View {
    @Environment(\.isLuminanceReduced) var isAOD          // Always-on display
    @Environment(\.scenePhase) var scenePhase              // .active, .inactive, .background
    @Environment(\.horizontalSizeClass) var sizeClass      // .compact on all watches
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.colorScheme) var colorScheme             // Always .dark on watchOS

    var body: some View {
        // Adapt based on environment
        VStack {
            // ...
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                startSensorUpdates()
            case .inactive, .background:
                pauseSensorUpdates()
            @unknown default: break
            }
        }
    }
}
```

### Recommended App Structure

```
CigaretteTrackerWatch/
├── CigaretteTrackerApp.swift          // @main entry point
├── AppDelegate.swift                   // WKApplicationDelegate
├── Models/
│   ├── CigaretteLog.swift             // Data model
│   └── HealthDataManager.swift        // HealthKit interface
├── Views/
│   ├── MainTabView.swift              // TabView (vertical pages)
│   ├── SummaryView.swift              // Page 1: daily summary
│   ├── CounterView.swift              // Page 2: log button
│   ├── TrendsView.swift               // Page 3: weekly chart
│   ├── HistoryView.swift              // Navigation destination
│   └── SettingsView.swift             // Sheet presentation
├── Complications/
│   └── CigaretteWidget.swift          // WidgetKit complication
├── Notifications/
│   └── NotificationController.swift   // Custom notification UI
└── Resources/
    └── Assets.xcassets
```

### Checklist

- ✅ Use `@main` App lifecycle (not WKInterfaceController)
- ✅ Use NavigationStack for drill-down navigation (watchOS 10+)
- ✅ Use TabView with `.verticalPage` for top-level content switching
- ✅ Handle `isLuminanceReduced` for always-on display state
- ✅ Limit navigation depth to 3 levels maximum
- ✅ Limit TabView to 5-7 pages maximum
- ✅ Use `.containerBackground` for per-page background colors
- ✅ Handle `scenePhase` for resource management (start/stop sensors)
- ✅ Remove interactive elements and sensitive data in AOD mode
- ❌ Do not use storyboards or WKInterfaceController (deprecated since watchOS 7)
- ❌ Do not nest sheets (sheet presenting another sheet)
- ❌ Do not use horizontal swipe for navigation (reserved for back gesture)
- ❌ Do not animate in AOD mode (system will terminate power-hungry AOD renders)

### Anti-patterns

1. **UIKit on watchOS** — Attempting to use UIKit components or UIViewRepresentable on watchOS. watchOS is SwiftUI-only (no UIKit equivalent). All UI must be SwiftUI native.
2. **Deep navigation hierarchies** — 5+ levels deep NavigationStack. On a watch, users lose context after 3 levels. Flatten the hierarchy; use sheets for side-quests.
3. **Ignoring always-on display** — Not implementing `isLuminanceReduced` handling. The app shows bright, interactive UI when the wrist is down, draining battery and revealing private health data.
4. **Tab overflow** — 10+ pages in a TabView. Without visible tab labels (watches have no tab bar), users cannot navigate or remember page positions. Keep it under 7.

**Sources:** [Apple watchOS App Lifecycle](https://developer.apple.com/documentation/watchos-apps/building-a-watchos-app), [WWDC 2022 Session 10133](https://developer.apple.com/videos/play/wwdc2022/10133/), [WWDC 2023 Session 10138](https://developer.apple.com/videos/play/wwdc2023/10138/), [Apple SwiftUI Environment](https://developer.apple.com/documentation/swiftui/environmentvalues)

---

## BQ. Health Data Confidence & Quality Indicators

> Sensor confidence levels, motion artifact rejection, skin contact detection, and communicating data uncertainty to users.
> Sources: [Apple HealthKit Metadata](https://developer.apple.com/documentation/healthkit/hkmetadatakey), [Wear OS Health Services Data Accuracy](https://developer.android.com/health-and-fitness/guides/health-services/active-data#accuracy), [ISO 80601-2-61 (Pulse Oximetry)](https://www.iso.org/standard/73339.html)

### Overview

Wearable sensors produce data of variable quality. A heart rate reading taken while the user is running has more motion artifact than one taken at rest. A SpO2 reading with poor skin contact is unreliable. Users and developers must understand data confidence to make appropriate decisions. Showing a "98% SpO2" reading with no quality indicator when the actual confidence is low can lead to dangerous complacency.

### Sensor Confidence Levels

**Wear OS Health Services — Data Accuracy Enum:**

```kotlin
import androidx.health.services.client.data.DataPointAccuracy
import androidx.health.services.client.data.HeartRateAccuracy

// Heart rate data point includes accuracy
fun onHeartRateData(dataPoint: DataPoint<Double>) {
    val bpm = dataPoint.value
    val accuracy = dataPoint.accuracy as? HeartRateAccuracy

    when (accuracy?.sensorStatus) {
        HeartRateAccuracy.SensorStatus.ACCURACY_HIGH -> {
            // Good skin contact, low motion, reliable reading
            showHeartRate(bpm, confident = true)
        }
        HeartRateAccuracy.SensorStatus.ACCURACY_MEDIUM -> {
            // Moderate confidence — motion or intermittent contact
            showHeartRate(bpm, confident = true)  // Still usable
        }
        HeartRateAccuracy.SensorStatus.ACCURACY_LOW -> {
            // Poor contact or high motion — show with warning
            showHeartRate(bpm, confident = false)
        }
        HeartRateAccuracy.SensorStatus.NO_CONTACT -> {
            // Watch not on wrist or no skin contact
            showNoContact()
        }
        HeartRateAccuracy.SensorStatus.UNRELIABLE -> {
            // Data should not be used
            hideHeartRate()
        }
        else -> {}
    }
}
```

**Apple HealthKit — Metadata Keys for Quality:**

```swift
// HealthKit samples include metadata about quality
func processHeartRateSample(_ sample: HKQuantitySample) {
    let bpm = sample.quantity.doubleValue(for: .count().unitDivided(by: .minute()))

    // Motion context
    if let motionContext = sample.metadata?[HKMetadataKeyHeartRateMotionContext] as? Int {
        switch HKHeartRateMotionContext(rawValue: motionContext) {
        case .sedentary:
            // High confidence — user stationary
            break
        case .active:
            // Moderate confidence — motion artifact possible
            break
        default: break
        }
    }

    // Device placement
    if let sensorLocation = sample.metadata?[HKMetadataKeyHeartRateSensorLocation] as? Int {
        // .wrist = 2 (typical for watch)
        // .chest = 1 (more accurate, from chest strap)
    }

    // SpO2 specific metadata
    // Apple does not expose raw confidence, but provides:
    // - HKMetadataKeyAppleDeviceCalibrated (Bool)
    // - Sample is only saved if Apple deems quality sufficient
}
```

### Motion Artifact Rejection

Motion is the primary source of PPG sensor error:

| Motion State | Heart Rate Error | SpO2 Error | Recommended Action |
|-------------|-----------------|------------|-------------------|
| Stationary (sitting/standing) | +/- 2 bpm | +/- 2% | Show value confidently |
| Walking | +/- 5 bpm | +/- 3-4% | Show value, no warning |
| Running | +/- 5-10 bpm | +/- 5-8% | Show value with "during exercise" label |
| Vigorous arm movement | +/- 10-20 bpm | Unreliable | Show "---" or "Move less for reading" |
| Wrist flexion (typing) | +/- 3-5 bpm | +/- 3% | Show value, no warning |

**Accelerometer-based motion rejection:**
```kotlin
// Check accelerometer magnitude to assess motion level
fun assessMotionLevel(accelMagnitude: Float): MotionLevel {
    // accelMagnitude = sqrt(x^2 + y^2 + z^2) in m/s^2
    // 9.8 = gravity (stationary), higher = movement
    val deviation = abs(accelMagnitude - 9.81f)

    return when {
        deviation < 0.5f -> MotionLevel.STATIONARY    // High confidence
        deviation < 2.0f -> MotionLevel.LIGHT_MOTION   // Medium confidence
        deviation < 5.0f -> MotionLevel.MODERATE_MOTION // Low confidence
        else -> MotionLevel.HIGH_MOTION                 // Unreliable — suppress reading
    }
}
```

### Skin Contact Detection

Both platforms detect whether the watch is being worn:

**Wear OS:**
```kotlin
// Wrist detection via Health Services
val passiveConfig = PassiveListenerConfig.builder()
    .setShouldUserActivityInfoBeRequested(true)
    .build()

// UserActivityInfo includes:
// - userActivityState: USER_ACTIVITY_EXERCISE, USER_ACTIVITY_PASSIVE, USER_ACTIVITY_UNKNOWN
// Wear OS does not expose raw "on-wrist" boolean to third-party apps directly
// Heart rate readings stop when watch detects no wrist contact
```

**watchOS:**
```swift
// watchOS detects wrist state via:
// 1. WKApplication.shared().isWristDetectionEnabled (Bool, read-only)
// 2. Heart rate samples stop when watch is off-wrist
// 3. No direct "isOnWrist" API for third-party apps

// Indirect detection: check if heart rate data is flowing
// If no HR sample for > 5 minutes, assume off-wrist
```

### Data Quality Tiers

Define a quality framework for your app:

| Tier | Conditions | UI Treatment | Data Storage |
|------|-----------|-------------|-------------|
| **Gold** | Stationary, good skin contact, sensor reports HIGH accuracy | Show value normally, full-size font | Store with full confidence |
| **Silver** | Light motion, sensor reports MEDIUM accuracy | Show value normally | Store with confidence flag |
| **Bronze** | Moderate motion, sensor reports LOW accuracy | Show value with "~" prefix or lighter opacity | Store with low-confidence flag |
| **Rejected** | High motion, NO_CONTACT, or UNRELIABLE | Show "---" or "Hold still" | Do not store |

### Showing Uncertainty to Users

**DO:**
- Use visual dimming (70% opacity) for low-confidence values
- Prefix with "~" for approximate: "~82 bpm"
- Show "measuring..." animation when waiting for stable reading
- Display data age: "2 min ago" helps users assess relevance
- Show quality explanation on tap: "This reading was taken during movement and may be less accurate"

**DO NOT:**
- Show error bars or +/- ranges (confusing for non-technical users)
- Use red/yellow/green traffic light for data quality (users confuse with health status)
- Hide low-confidence data entirely (users lose trust if values disappear unpredictably)
- Show precise decimal values for low-confidence data (false precision)

### "Measurement May Be Inaccurate" Patterns

```swift
struct HeartRateView: View {
    let bpm: Int
    let confidence: DataConfidence

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                if confidence == .low {
                    Text("~")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                Text("\(bpm)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(confidence == .low ? .secondary : .primary)
                Text("bpm")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if confidence == .low {
                Text("Hold still for accurate reading")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
            }

            if confidence == .noContact {
                VStack {
                    Image(systemName: "applewatch.side.right")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("Wear watch snugly for heart rate")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

enum DataConfidence {
    case high, medium, low, noContact
}
```

### Checklist

- ✅ Check `HeartRateAccuracy.sensorStatus` on every Wear OS heart rate data point
- ✅ Check `HKMetadataKeyHeartRateMotionContext` on watchOS heart rate samples
- ✅ Suppress or dim values when sensor reports LOW or UNRELIABLE
- ✅ Show "Hold still" message when motion artifact is detected
- ✅ Show data freshness ("2 min ago") for all health values
- ✅ Use visual dimming (opacity) for uncertain values — not color coding
- ✅ Store confidence metadata alongside health values for later analysis
- ✅ Show "Wear watch snugly" when no skin contact detected
- ❌ Do not display health values with no quality assessment
- ❌ Do not use decimal precision for uncertain readings ("82.3 bpm" at low confidence)
- ❌ Do not hide readings silently — always show why data is missing
- ❌ Do not use green/yellow/red for data quality (conflicts with health status colors)

### Anti-patterns

1. **Always showing a number** — Displaying "72 bpm" even when the sensor reports NO_CONTACT. The number is noise, not signal. Show "---" or "Wear watch" instead.
2. **False precision** — Showing "SpO2: 97.4%" when sensor accuracy is +/- 2-3%. Round to integers and add "~" for low confidence.
3. **Quality indicator overload** — Showing confidence bars, signal strength icons, and accuracy percentages simultaneously. Users want a simple answer: "Is this number trustworthy?" One visual cue (dimming or "~") suffices.
4. **Treating all readings equally in analytics** — Computing daily average heart rate from all samples regardless of confidence. Exclude UNRELIABLE and NO_CONTACT readings; weight by confidence tier.

**Sources:** [Apple HealthKit Metadata Keys](https://developer.apple.com/documentation/healthkit/hkmetadatakey), [Wear OS Health Services Accuracy](https://developer.android.com/health-and-fitness/guides/health-services/active-data#accuracy), [Apple Heart Rate Monitoring](https://support.apple.com/en-us/102341), [ISO 80601-2-61](https://www.iso.org/standard/73339.html)

---

## BR. Menstrual Cycle Tracking UX

> Cycle tracking on wearables: symptom logging, prediction visualization, privacy sensitivity, and inclusive design.
> Sources: [Apple Cycle Tracking](https://developer.apple.com/documentation/healthkit/hkcategorytype/init(categorytypeidentifier:)/menstrualflow), [Samsung Health Cycle Tracking](https://www.samsung.com/us/support/answer/ANS00084043/), [WHO Menstrual Health](https://www.who.int/news-room/fact-sheets/detail/menstruation), [Inclusive Design Research (Microsoft)](https://inclusive.microsoft.design/)

### Overview

Menstrual cycle tracking is a core health feature on Apple Watch and Samsung Galaxy Watch. On a wearable, the UX must balance comprehensive logging with minimal interaction time. The data is deeply personal — cycle tracking apps face heightened privacy scrutiny, especially post-Dobbs (US), where menstrual data could theoretically be subpoenaed. Inclusive language matters: not all people who menstruate identify as women.

### Platform Features

| Feature | Apple (Cycle Tracking) | Samsung Health |
|---------|----------------------|----------------|
| Period logging | Start/end dates, flow level (light/medium/heavy) | Start/end dates, flow level |
| Symptom logging | 15+ symptoms (cramps, headache, mood, etc.) | 10+ symptoms |
| Prediction | Period and fertile window prediction | Period prediction |
| Wrist temperature | Retrospective ovulation estimation (Series 8+) | Skin temperature (Galaxy Watch 5+) |
| Notifications | Period due, fertile window | Period due |
| On-device processing | All data processed on-device (Apple) | Server-processed (Samsung) |
| Data storage | On-device + encrypted iCloud (opt-in) | Samsung Health cloud |
| FDA/regulatory | No clinical claims (wellness only) | No clinical claims |

### Watch UI for Cycle Logging

The watch UI must enable quick logging (< 10 seconds) for the most common actions:

```
┌──────────────────────┐
│    Cycle Tracking     │
│                       │
│  Today: Day 14        │
│  ● ● ● ● ○ ○ ○      │   ← Cycle phase dots (past = filled, future = empty)
│                       │
│  ┌─────────────────┐  │
│  │  Log Period      │  │   ← Primary action button
│  └─────────────────┘  │
│  ┌─────────────────┐  │
│  │  Log Symptoms    │  │   ← Secondary action
│  └─────────────────┘  │
│                       │
│  Next period: ~5 days │
└──────────────────────┘
```

**Period flow logging (quick select):**
```swift
struct FlowLogView: View {
    @State private var selectedFlow: FlowLevel?

    var body: some View {
        VStack(spacing: 12) {
            Text("Period Flow")
                .font(.headline)

            ForEach(FlowLevel.allCases, id: \.self) { level in
                Button(action: { logFlow(level) }) {
                    HStack {
                        Circle()
                            .fill(level.color)
                            .frame(width: 12, height: 12)
                        Text(level.label)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

enum FlowLevel: String, CaseIterable {
    case spotting, light, medium, heavy

    var label: String {
        switch self {
        case .spotting: return "Spotting"
        case .light: return "Light"
        case .medium: return "Medium"
        case .heavy: return "Heavy"
        }
    }

    var color: Color {
        switch self {
        case .spotting: return .pink.opacity(0.4)
        case .light: return .pink.opacity(0.6)
        case .medium: return .pink.opacity(0.8)
        case .heavy: return .pink
        }
    }
}
```

### Symptom Logging UI

On a watch, logging 15+ symptoms one by one is too slow. Group them:

| Category | Symptoms | Watch Interaction |
|----------|----------|-------------------|
| **Physical** | Cramps, headache, bloating, breast tenderness, fatigue | Scrollable list with toggle |
| **Mood** | Happy, sad, anxious, irritable, sensitive | Emoji-style quick select (5 faces) |
| **Energy** | High, normal, low, exhausted | 4-point scale |
| **Other** | Acne, cravings, insomnia, nausea | Secondary list (optional) |

**Design rule:** Show top 5-6 most recently used symptoms first. The user's personal pattern matters more than a comprehensive list. Offer "More symptoms..." at the bottom for the full list.

```swift
struct SymptomLogView: View {
    @State private var selectedSymptoms: Set<Symptom> = []
    let recentSymptoms: [Symptom]  // Ordered by frequency of past logging

    var body: some View {
        List {
            Section("Recent") {
                ForEach(recentSymptoms.prefix(6)) { symptom in
                    Button(action: { toggleSymptom(symptom) }) {
                        HStack {
                            Text(symptom.emoji)
                            Text(symptom.name)
                            Spacer()
                            if selectedSymptoms.contains(symptom) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                }
            }
            Section {
                NavigationLink("More Symptoms...") {
                    AllSymptomsView(selected: $selectedSymptoms)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveSymptoms() }
            }
        }
    }
}
```

### Prediction Visualization

| Element | Specification |
|---------|---------------|
| Predicted period start | Date range (e.g., "Mar 12-15") — never a single exact date |
| Predicted fertile window | Date range, shown only if user opts in |
| Cycle day counter | "Day 14 of ~28" — use "~" to indicate prediction uncertainty |
| Calendar view | Color-coded: red/pink = period, blue = predicted period, green = fertile (if opted in) |
| Accuracy disclaimer | "Predictions are estimates based on past cycles" — always visible |

**Complication:**
```swift
// Circular complication showing cycle day
struct CycleComplication: View {
    let cycleDay: Int
    let cycleLength: Int

    var body: some View {
        Gauge(value: Double(cycleDay), in: 1...Double(cycleLength)) {
            Text("Day")
        } currentValueLabel: {
            Text("\(cycleDay)")
                .font(.system(.title3, design: .rounded, weight: .bold))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.pink)
    }
}
```

### Fertility Window (Optional)

Fertility window display is a sensitive feature:

1. **Opt-in only.** Never show fertility data by default. Require explicit user choice.
2. **Not a contraceptive.** Display disclaimer: "This is not a method of birth control and should not be used to prevent pregnancy."
3. **Not a fertility treatment.** Display disclaimer: "This feature does not diagnose fertility conditions."
4. **Wrist temperature correlation (Apple Watch Series 8+):** Retrospective ovulation estimation based on biphasic temperature shift (~0.2-0.5 degrees C rise after ovulation). Shown as "Estimated ovulation occurred around [date]" — always retrospective, never predictive in real-time.

### Privacy Sensitivity

**Threat model for cycle data:**
- Law enforcement subpoena of menstrual data (post-Dobbs US context)
- Employer access via corporate wellness programs
- Insurance company data access
- Domestic partner surveillance

**Privacy design rules:**

| Rule | Implementation |
|------|---------------|
| On-device processing | All prediction algorithms run locally, never server-side |
| End-to-end encryption | If syncing to cloud, use E2E encryption (Apple does this for Health data with Advanced Data Protection) |
| No third-party sharing | Never send cycle data to analytics SDKs or advertising partners |
| Quick-hide gesture | Allow user to dismiss cycle tracking screen with a single gesture if someone is looking over their shoulder |
| Biometric lock | Require Face ID / passcode to view cycle data (Apple: protected behind Health app lock) |
| Data deletion | One-tap "Delete All Cycle Data" option |
| Minimal notification content | Notification says "Health reminder" not "Period due tomorrow" (visible on lock screen) |
| No export without auth | Require authentication before exporting cycle data as PDF/CSV |

```swift
// Notification with privacy-preserving content
let content = UNMutableNotificationContent()
content.title = "Health Reminder"  // NOT "Period due tomorrow"
content.body = "Check your cycle tracking for today's update"
content.sound = .default
// The specific health detail is only visible inside the app
```

### Inclusive Language

| Instead of | Use |
|-----------|-----|
| "Women's health" | "Cycle health" or "Menstrual health" |
| "She/her" in UI copy | "You/your" (second person) |
| "Female cycle" | "Menstrual cycle" |
| "Mother/maternal" | "Parent/parental" (where applicable) |
| Pink-only color scheme | Offer color theme options (not everyone associates pink with menstruation) |
| Gendered icons (dress, female symbol) | Neutral icons (calendar, drop, thermometer) |

**Note:** Apple Cycle Tracking and Samsung Health both use gender-neutral UI in recent versions. Follow this pattern.

### HealthKit Integration

```swift
// Write menstrual flow sample
func logPeriod(flow: HKCategoryValueMenstrualFlow, date: Date) {
    let type = HKCategoryType(.menstrualFlow)
    let sample = HKCategorySample(
        type: type,
        value: flow.rawValue,  // .unspecified, .light, .medium, .heavy, .none
        start: date,
        end: date,
        metadata: [HKMetadataKeyMenstrualCycleStart: true]  // Mark as cycle start
    )
    healthStore.save(sample) { success, error in }
}

// Write symptom
func logSymptom(_ symptom: HKCategoryTypeIdentifier, date: Date) {
    // Available symptom types:
    // .abdominalCramps, .acne, .bloating, .breastTenderness,
    // .fatigue, .headache, .moodChanges, .nausea, etc.
    let type = HKCategoryType(symptom)
    let sample = HKCategorySample(
        type: type,
        value: HKCategoryValue.notApplicable.rawValue,
        start: date,
        end: date
    )
    healthStore.save(sample) { success, error in }
}

// Read cycle data for prediction
func getCycleHistory(months: Int) async throws -> [HKCategorySample] {
    let type = HKCategoryType(.menstrualFlow)
    let startDate = Calendar.current.date(byAdding: .month, value: -months, to: Date())!
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date())

    return try await withCheckedThrowingContinuation { continuation in
        let query = HKSampleQuery(sampleType: type, predicate: predicate,
                                   limit: HKObjectQueryNoLimit,
                                   sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)])
        { _, samples, error in
            if let error { continuation.resume(throwing: error); return }
            continuation.resume(returning: (samples as? [HKCategorySample]) ?? [])
        }
        healthStore.execute(query)
    }
}
```

### Checklist

- ✅ Logging flow level in < 10 seconds (3 taps: open -> select flow -> confirm)
- ✅ Show most recently logged symptoms first (personalized order)
- ✅ Display predictions as date ranges, never exact dates
- ✅ Fertility window is opt-in only with clear disclaimers
- ✅ Notifications use generic titles ("Health Reminder") not explicit content
- ✅ All cycle data processed on-device
- ✅ Provide one-tap "Delete All Cycle Data" option
- ✅ Use inclusive, gender-neutral language throughout
- ✅ Offer color theme options (not pink-only)
- ✅ Require authentication to view or export cycle data
- ❌ Do not show fertility window by default
- ❌ Do not use gendered icons or pronouns
- ❌ Do not sync cycle data to third-party servers
- ❌ Do not display specific cycle information in notifications or complications visible on lock screen

### Anti-patterns

1. **Prediction overconfidence** — Showing "Your period starts March 12" as a definitive date. Cycles vary by 1-7 days naturally. Always show a range and use "estimated" or "~".
2. **Pink-everything design** — Using exclusively pink color scheme for cycle tracking. This is exclusionary and gender-normative. Offer neutral color options.
3. **Public complications** — Showing "Period Day 3" on the always-visible watch face complication. This reveals deeply personal health information to anyone who glances at the watch. Use abstract visualizations (progress ring, day number without label).
4. **No opt-out for fertility** — Showing fertility window predictions to all users by default. Many users track periods for health monitoring, not fertility planning. This feature must be explicitly enabled.

**Sources:** [Apple Cycle Tracking](https://support.apple.com/en-us/108918), [Apple HealthKit Menstrual](https://developer.apple.com/documentation/healthkit/hkcategorytypeidentifier), [Samsung Cycle Tracking](https://www.samsung.com/us/support/answer/ANS00084043/), [WHO Menstrual Health](https://www.who.int/news-room/fact-sheets/detail/menstruation), [Microsoft Inclusive Design](https://inclusive.microsoft.design/)

---

## BS. Productivity App Patterns on Watch

> Timers, reminders, lists, voice memos, calendar glance, and minimal interaction principles for productivity apps on wearables.
> Sources: [Apple HIG - Productivity on watchOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Wear OS Tiles Best Practices](https://developer.android.com/training/wearables/tiles), [NNGroup Smartwatch Interactions](https://www.nngroup.com/articles/smartwatch-interactions/)

### Overview

Productivity apps on watches must respect the "3-second rule": any interaction should complete within 3 seconds, or it belongs on the phone. The watch excels at: glancing at information (calendar, task count), capturing input quickly (voice memos, single-tap completion), and providing timed nudges (reminders, timers). It fails at: composing long text, managing complex lists, or multi-step workflows.

### Timer Patterns

Timers are the most natural watch productivity feature — the watch is literally strapped to the wrist, always visible for countdown checking.

```swift
// watchOS Timer with haptic alerts
struct PomodoroTimerView: View {
    @State private var timeRemaining: TimeInterval = 25 * 60  // 25 minutes
    @State private var isRunning = false
    @State private var timerPhase: TimerPhase = .work

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            // Phase label
            Text(timerPhase.label)
                .font(.caption)
                .foregroundStyle(timerPhase.color)

            // Countdown display
            Text(timeString)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()  // Prevents layout shift as digits change

            // Progress ring
            CircularProgressView(progress: progress)
                .frame(width: 120, height: 120)

            // Controls
            HStack(spacing: 20) {
                Button(action: reset) {
                    Image(systemName: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)

                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(timerPhase.color)
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                // Haptic at milestones
                if timeRemaining == 60 { WKInterfaceDevice.current().play(.notification) }
                if timeRemaining == 10 { WKInterfaceDevice.current().play(.start) }
            } else {
                timerComplete()
            }
        }
    }

    func timerComplete() {
        isRunning = false
        WKInterfaceDevice.current().play(.success) // Strong haptic

        // Switch phase
        timerPhase = timerPhase == .work ? .break_ : .work
        timeRemaining = timerPhase == .work ? 25 * 60 : 5 * 60
    }
}

enum TimerPhase {
    case work, break_
    var label: String { self == .work ? "Focus" : "Break" }
    var color: Color { self == .work ? .orange : .green }
}
```

**Timer UX rules:**

| Rule | Value | Rationale |
|------|-------|-----------|
| Minimum font size for countdown | 40 sp | Must be readable at arm's length mid-activity |
| Use `.monospacedDigit()` | Always | Prevents layout shift when "1:09" becomes "1:10" |
| Haptic at completion | Strong/success pattern | User may not be looking at watch |
| Haptic at milestones | 1 minute remaining, 10 seconds remaining | Builds anticipation without constant checking |
| Always-on display | Show countdown (update 1/min in AOD) | Timer is useless if it disappears when wrist drops |
| Complication | Show remaining time as countdown text | Glanceable from watch face without opening app |

### Reminders & Task Completion

The watch is ideal for completing tasks (single-tap checkoff), not creating them:

```swift
// Minimal task list — optimized for one-tap completion
struct TaskListView: View {
    @State var tasks: [TaskItem]

    var body: some View {
        List {
            ForEach($tasks) { $task in
                Button(action: {
                    withAnimation {
                        task.isCompleted.toggle()
                        if task.isCompleted {
                            WKInterfaceDevice.current().play(.click)
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(task.isCompleted ? .green : .secondary)
                            .font(.title3)
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundStyle(task.isCompleted ? .secondary : .primary)
                            .lineLimit(2)
                    }
                }
            }
        }
        .navigationTitle("Tasks")
    }
}
```

**Task list UX rules:**
- Maximum 10-15 items visible in list (scroll beyond this loses context)
- Single-tap to complete (no swipe-to-complete — too error-prone on small screen)
- Completed tasks: strikethrough + dim, move to bottom after 2 seconds
- Do not allow task creation on watch (use voice only if absolutely necessary; prefer phone companion)
- Sync completion state to phone immediately via Data Layer API / WatchConnectivity
- Show overdue tasks with red accent

### Grocery / Shopping Lists

```swift
struct GroceryListView: View {
    @State var items: [GroceryItem]

    var body: some View {
        List {
            // Unchecked items first, grouped by aisle/category
            Section("To Get") {
                ForEach(items.filter { !$0.checked }) { item in
                    GroceryRow(item: item) {
                        checkItem(item)
                    }
                }
            }

            // Checked items collapsed
            if items.contains(where: { $0.checked }) {
                Section("Got It (\(items.filter(\.checked).count))") {
                    ForEach(items.filter { $0.checked }) { item in
                        GroceryRow(item: item, checked: true) {
                            uncheckItem(item)
                        }
                    }
                }
            }
        }
    }
}

struct GroceryRow: View {
    let item: GroceryItem
    var checked: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(checked ? .green : .primary)
                VStack(alignment: .leading) {
                    Text(item.name)
                        .strikethrough(checked)
                    if let quantity = item.quantity {
                        Text(quantity)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
```

**Grocery list rules:**
- Sort unchecked items by store aisle/category for shopping flow
- Show quantity next to item name ("Milk x2", "Eggs (dozen)")
- Single-tap to check off
- Haptic confirmation on check
- Allow adding items via voice only ("Hey Siri, add bananas to my grocery list")
- Sync instantly to phone / shared list

### Voice Memos

```swift
import AVFoundation

struct VoiceMemoView: View {
    @StateObject private var recorder = WatchRecorder()

    var body: some View {
        VStack {
            // Recording indicator
            if recorder.isRecording {
                Circle()
                    .fill(.red)
                    .frame(width: 12, height: 12)
                    .opacity(recorder.isRecording ? 1 : 0)  // Pulse animation

                Text(recorder.durationString)
                    .font(.system(.title2, design: .rounded))
                    .monospacedDigit()
            }

            // Record / Stop button
            Button(action: {
                if recorder.isRecording {
                    recorder.stop()
                } else {
                    recorder.start()
                }
            }) {
                Image(systemName: recorder.isRecording ? "stop.fill" : "mic.fill")
                    .font(.title)
                    .frame(width: 64, height: 64)
            }
            .buttonStyle(.borderedProminent)
            .tint(recorder.isRecording ? .red : .blue)
        }
    }
}

class WatchRecorder: ObservableObject {
    @Published var isRecording = false
    @Published var duration: TimeInterval = 0
    private var audioRecorder: AVAudioRecorder?

    var durationString: String {
        let mins = Int(duration) / 60
        let secs = Int(duration) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    func start() {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("memo_\(Date().timeIntervalSince1970).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,       // Mono (watch has one mic)
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
            AVEncoderBitRateKey: 64000       // 64 kbps — good quality, small file
        ]

        audioRecorder = try? AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.record()
        isRecording = true
        WKInterfaceDevice.current().play(.start)
    }

    func stop() {
        audioRecorder?.stop()
        isRecording = false
        WKInterfaceDevice.current().play(.success)
        // Transfer recording to phone via WCSession or save locally
    }
}
```

**Voice memo rules:**
- One-tap to start recording (no settings, no file naming)
- Haptic at start and stop
- Show recording duration prominently (monospaced digits)
- Maximum recording length: 5-10 minutes (watch storage is limited, ~32 GB shared with OS)
- Auto-transfer to phone via WatchConnectivity when connected
- Auto-name with timestamp ("Memo Mar 6, 11:45 AM")

### Calendar Glance

The calendar on a watch should answer one question: "What's next?"

```swift
struct CalendarGlanceView: View {
    let nextEvent: CalendarEvent?
    let upcomingEvents: [CalendarEvent]  // Next 3-5 events

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let event = nextEvent {
                // Next event — hero treatment
                VStack(alignment: .leading, spacing: 4) {
                    Text("NEXT")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(event.title)
                        .font(.headline)
                        .lineLimit(2)
                    HStack {
                        Text(event.timeString)
                            .font(.subheadline)
                        if let location = event.location {
                            Text("- \(location)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    Text(event.relativeTime)  // "in 23 min"
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
                .padding(.bottom, 4)

                Divider()

                // Upcoming events — compact list
                ForEach(upcomingEvents.prefix(3)) { event in
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(event.calendarColor)
                            .frame(width: 4, height: 24)
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.caption)
                                .lineLimit(1)
                            Text(event.timeString)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } else {
                // No upcoming events
                VStack {
                    Image(systemName: "calendar")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    Text("No upcoming events")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
```

**Calendar glance rules:**
- Show next event as the hero element (largest text, most prominent)
- Show relative time ("in 23 min") not absolute ("11:45 AM") for the next event — relative is faster to process mentally
- Show absolute time for later events
- Maximum 3-4 upcoming events (more requires scrolling, defeats "glance" purpose)
- Color-code by calendar source (work = blue, personal = green, etc.)
- Complication: show next event title + "in X min" — nothing else needed

### Pomodoro Timer Specifics

| Parameter | Recommended Value | Source |
|-----------|------------------|--------|
| Work interval | 25 min (default), configurable 15-50 min | Cirillo Pomodoro Technique |
| Short break | 5 min | Standard |
| Long break | 15-30 min (after 4 work intervals) | Standard |
| Auto-start next phase | Optional (off by default — user should consciously start) | UX best practice |
| Haptic pattern (work complete) | Success + notification (strong double pulse) | Distinguishable from casual notifications |
| Haptic pattern (break complete) | Start pattern (gentle rising pulse) | Distinct from work-complete |

### Complications for Quick Actions

```swift
// Wear OS Tile for quick task actions
@OptIn(ProtoLayoutExperimental::class)
class ProductivityTile : TileService() {
    override fun onTileRequest(requestParams: RequestBuilders.TileRequest) =
        Futures.immediateFuture(
            Tile.Builder()
                .setResourcesVersion("1")
                .setTileTimeline(Timeline.fromLayoutElement(
                    Column.Builder()
                        .addContent(
                            Text.Builder()
                                .setText("3 tasks remaining")
                                .setTypography(Typography.TYPOGRAPHY_CAPTION1)
                                .build()
                        )
                        .addContent(
                            // Quick-complete button for top task
                            Chip.Builder()
                                .setPrimaryLabelContent("Buy groceries")
                                .setIconContent("check_icon")
                                .setOnClick(
                                    ActionBuilders.LoadAction.Builder()
                                        .setRequestState(/* complete task ID */)
                                        .build()
                                )
                                .build()
                        )
                        .build()
                ))
                .build()
        )
}
```

### Minimal Interaction Principle

The guiding principle for all watch productivity apps:

| Interaction Type | Maximum Taps | Maximum Duration | Example |
|-----------------|-------------|-----------------|---------|
| Check off a task | 1 tap | < 1 s | Tap checkbox |
| Start/stop timer | 1 tap | < 1 s | Tap play/pause |
| Log a voice memo | 2 taps | < 2 s (+ recording time) | Tap record, tap stop |
| Glance at calendar | 0 taps (raise wrist) | < 3 s | Complication or tile |
| Add item via voice | 2 taps + voice | < 5 s | Tap add, speak, tap confirm |
| Create a new task (text) | N/A | N/A | Do this on the phone, not the watch |

### Checklist

- ✅ Timer countdown visible in always-on display mode
- ✅ Use `.monospacedDigit()` for all countdown displays
- ✅ Haptic feedback at timer milestones (1 min remaining, 10 s, completion)
- ✅ Single-tap task completion with immediate haptic confirmation
- ✅ Calendar glance shows relative time for next event ("in 23 min")
- ✅ Voice memo starts recording with one tap (no configuration)
- ✅ Maximum 10-15 items in any scrollable list
- ✅ Sync all changes to phone immediately
- ✅ Provide complication showing task count or next event
- ✅ Voice input for adding items (never tiny keyboard)
- ❌ Do not build text composition on watch (task creation, note editing)
- ❌ Do not require multi-step workflows for common actions
- ❌ Do not show more than 4 upcoming calendar events
- ❌ Do not auto-start Pomodoro phases without user confirmation
- ❌ Do not omit haptics on timer completion (user may not be looking)

### Anti-patterns

1. **Full task manager on watch** — Replicating Todoist's full interface on a 1.5" screen: projects, labels, priorities, due dates, subtasks. The watch should show a flat list of today's tasks with one-tap completion. Everything else stays on the phone.
2. **Keyboard-based input** — Requiring users to type task names on the watch keyboard. This takes 30-60 seconds for a simple item. Use voice input or sync from phone exclusively.
3. **Timer without haptics** — A Pomodoro timer that only shows a visual countdown. If the user is working (not looking at their wrist), they miss the completion entirely. Haptics are mandatory for timer apps.
4. **Calendar detail view** — Showing full event details (attendees, notes, location map, video call link) on the watch. Show title, time, and location only. Everything else is "Open on iPhone."
5. **No complication** — A productivity app without a complication is invisible. Users check their watch face 80+ times per day — the complication is the primary entry point.

**Sources:** [Apple HIG watchOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Wear OS Tiles](https://developer.android.com/training/wearables/tiles), [NNGroup Smartwatch](https://www.nngroup.com/articles/smartwatch-interactions/), [Cirillo Pomodoro Technique](https://francescocirillo.com/products/the-pomodoro-technique)

---

---

## BT. Data Sync Indicator UI

> Visual patterns for showing data synchronisation status between watch and phone.
> Users must always know whether their data is current, syncing, or stale.
> Sources: [Wear OS Data Layer](https://developer.android.com/training/wearables/data/data-layer), [WatchConnectivity](https://developer.apple.com/documentation/watchconnectivity), [Material 3 Progress Indicators](https://m3.material.io/components/progress-indicators)

### Syncing State (Active Transfer)

Display a small circular progress indicator while data is actively transferring over Bluetooth or WiFi.

**Wear OS implementation:**
- Use `CircularProgressIndicator` composable from Wear Compose
- Size: 16dp diameter, `strokeWidth = 2.dp`
- Color: `MaterialTheme.colorScheme.primary`
- Placement: top-right corner of the screen, overlaid on content, or inline next to a "Last synced" label
- Animation: indeterminate spin (no progress value), `alpha = 0.8f` to keep it subtle
- Do not block user interaction while syncing — the indicator is informational only

```kotlin
CircularProgressIndicator(
    modifier = Modifier.size(16.dp).alpha(0.8f),
    strokeWidth = 2.dp,
    color = MaterialTheme.colorScheme.primary
)
```

**watchOS implementation:**
- Use `ProgressView()` with `.scaleEffect(0.6)` to shrink to appropriate watch size
- Place in `.toolbar` trailing position or inline in a list row
- SwiftUI automatically handles the indeterminate spin animation

```swift
ProgressView()
    .scaleEffect(0.6)
    .frame(width: 16, height: 16)
```

**Duration:** Show only during active transfer. If sync completes in under 300ms, skip the indicator entirely to avoid flash. Use a 300ms delay before showing the spinner (debounce).

### Synced State (Success)

After a successful sync, briefly show a confirmation before returning to neutral.

**Wear OS implementation:**
- Show `Icon(Icons.Rounded.Check, tint = MaterialTheme.colorScheme.primary)` at 16dp
- Use `AnimatedVisibility` with `fadeIn(animationSpec = tween(300))` + `fadeOut(animationSpec = tween(2000))`
- Auto-dismiss after 2 seconds — no user action required
- Optional: display "Last synced: just now" as secondary text below the icon

```kotlin
AnimatedVisibility(
    visible = showSyncSuccess,
    exit = fadeOut(animationSpec = tween(2000))
) {
    Icon(
        Icons.Rounded.Check,
        contentDescription = "Synced",
        modifier = Modifier.size(16.dp),
        tint = MaterialTheme.colorScheme.primary
    )
}
```

**watchOS implementation:**
- Show `Image(systemName: "checkmark.circle.fill").foregroundColor(.green)` at 16pt
- Animate out with `.opacity(showCheck ? 1 : 0).animation(.easeOut(duration: 2))` after 2 seconds
- Haptic: `WKInterfaceDevice.current().play(.success)` on sync completion (optional, only if user-initiated)

### Failed State (Error)

Persistent error indicator that remains visible until the user acknowledges or retries.

**Wear OS implementation:**
- Show `Icon(Icons.Rounded.Warning, tint = MaterialTheme.colorScheme.error)` at 16dp
- Do NOT auto-dismiss — persist until retry succeeds or user taps
- Tap action on the icon: trigger manual retry via `DataClient.putDataItem()` or `MessageClient.sendMessage()`
- If 3+ consecutive failures: show a `BottomSheet` or `AlertDialog` with message "Sync failed. Check phone connection." and a Retry button
- Include a "Dismiss" option so users are not permanently blocked by the warning

```kotlin
Icon(
    Icons.Rounded.Warning,
    contentDescription = "Sync failed",
    modifier = Modifier.size(16.dp).clickable { retrySyncAction() },
    tint = MaterialTheme.colorScheme.error
)
```

**watchOS implementation:**
- Show `Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)` at 16pt
- Tap triggers retry via `WCSession.default.transferUserInfo()` or `sendMessage()`
- On repeated failures: present `.sheet` with explanation and retry button
- Haptic: `WKInterfaceDevice.current().play(.failure)` on error

### Last-Sync Timestamp

Always show when data was last successfully synced. Users need confidence their data is current.

**Formatting rules:**
- Use relative time, never absolute: "Just now", "2 min ago", "1h ago", "Yesterday"
- Update the displayed relative time every 60 seconds (use a timer or `TimelineView`)
- Thresholds: <60s → "Just now", 1-59 min → "X min ago", 1-23h → "Xh ago", 24h+ → "Yesterday" or date

**Placement:**
- Primary: settings screen, under a "Sync" or "Data" section heading
- Secondary: long-press context menu on main data display
- Optional: inline below the sync status icon as a caption-size label

**Wear OS:** Use `DateUtils.getRelativeTimeSpanString()` for locale-aware formatting.

**watchOS:** Use `RelativeDateTimeFormatter()` for automatic relative string generation.

### Manual Sync Trigger

Always provide a way for users to force a sync, even if automatic sync is working.

**Wear OS:**
- Pull-to-refresh on main scrollable content using `SwipeDismissableNavHost` with `ScalingLazyColumn` and pull-down refresh pattern
- Alternative: explicit "Sync now" button in Settings screen
- Debounce: ignore manual sync requests if last sync was <10 seconds ago

**watchOS:**
- Use `.refreshable { await syncNow() }` modifier on `List` or `ScrollView`
- Alternative: "Sync Now" button in Settings
- Show the syncing indicator immediately on pull-to-refresh to confirm the gesture was recognized

### Offline Badge

When the watch has no connection to the phone for more than 30 seconds, show a persistent but subtle offline indicator.

- Icon: cloud with diagonal line through it (cloud-off), 12dp/12pt
- Placement: top bar, leading or trailing position, alongside other status indicators
- Color: `colorOnSurfaceVariant` (muted, not alarming — offline is normal for watches)
- Wear OS: `Icon(painterResource(R.drawable.ic_cloud_off), modifier = Modifier.size(12.dp))`
- watchOS: `Image(systemName: "icloud.slash").font(.system(size: 12))`
- Remove immediately when connection is re-established (no fade delay)
- Do NOT show a toast or alert for offline state — it is too common on watches to warrant interruption

### Checklist

- ✅ Syncing spinner appears only during active transfer, debounced 300ms
- ✅ Success checkmark auto-dismisses after 2 seconds
- ✅ Error indicator persists until retry or dismiss
- ✅ Relative timestamps updated every 60 seconds
- ✅ Manual sync available via pull-to-refresh or settings button
- ✅ Offline badge shown after 30s disconnection, removed immediately on reconnect
- ✅ Haptic feedback on user-initiated sync completion (success or failure)
- ❌ Do not show absolute timestamps (users cannot quickly parse "14:32:07")
- ❌ Do not block UI during sync — all sync is asynchronous
- ❌ Do not show sync errors as full-screen alerts (use inline indicators)
- ❌ Do not auto-retry more than 3 times without user consent

**Sources:** [Wear OS Data Layer API](https://developer.android.com/training/wearables/data/data-layer), [WatchConnectivity](https://developer.apple.com/documentation/watchconnectivity), [Material 3 Progress Indicators](https://m3.material.io/components/progress-indicators), [NNGroup Status Visibility](https://www.nngroup.com/articles/ten-usability-heuristics/)

---

## BU. Complication-to-Instant-Action Pattern

> Tap a complication on the watch face, execute a background action, show confirmation, return to watch face.
> Total interaction time: under 3 seconds. No app launch, no navigation, no screen transition.
> Sources: [Wear OS Complications](https://developer.android.com/training/wearables/complications), [ClockKit](https://developer.apple.com/documentation/clockkit), [WidgetKit AppIntent](https://developer.apple.com/documentation/widgetkit)

### Use Cases

This pattern is ideal for:
- **One-tap cigarette logging** — tap complication, event is logged, count increments on watch face
- **Quick water intake** — tap to add one glass, complication updates total
- **Start/stop timer** — tap to toggle, complication shows running/paused state
- **Quick mood check-in** — tap to log current mood with predefined value

The key requirement: the action must be **unambiguous** — one tap always means one specific thing. If the action needs parameters or confirmation, use a different pattern (launch app).

### Architecture Flow

```
1. User taps complication on watch face
2. System delivers tap intent to ComplicationDataSource
3. BroadcastReceiver executes background action (log event, write data)
4. ConfirmationActivity shows success overlay (2s auto-dismiss)
5. User returns to watch face — complication shows updated data
```

Total elapsed time: 1.5–3 seconds. Zero navigation. Zero scrolling.

### Wear OS Implementation

**Step 1 — Complication tap target:**
- In your `ComplicationDataSource.onComplicationRequest()`, set the tap action to a `PendingIntent` targeting a `BroadcastReceiver`, NOT an Activity
- Using a BroadcastReceiver avoids launching any visible UI until you explicitly show confirmation

```kotlin
val tapIntent = PendingIntent.getBroadcast(
    context,
    COMPLICATION_REQUEST_CODE,
    Intent(context, LogCigaretteReceiver::class.java),
    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
)
```

**Step 2 — BroadcastReceiver handles action:**
- `LogCigaretteReceiver.onReceive()`: write event to local database, queue sync to phone
- Then launch `ConfirmationActivity` with `SUCCESS_ANIMATION`

```kotlin
class LogCigaretteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Execute action
        CigaretteRepository.logEvent(timestamp = System.currentTimeMillis())

        // Show confirmation overlay
        val confirmIntent = Intent(context, ConfirmationActivity::class.java).apply {
            putExtra(ConfirmationActivity.EXTRA_ANIMATION_TYPE, ConfirmationActivity.SUCCESS_ANIMATION)
            putExtra(ConfirmationActivity.EXTRA_MESSAGE, "Logged")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(confirmIntent)

        // Force complication update
        ProviderUpdateRequester(context, ComponentName(context, CigaretteComplication::class.java))
            .requestUpdateAll()
    }
}
```

**Step 3 — ConfirmationActivity:**
- Built-in Wear OS component: shows animated checkmark (success) or X (failure)
- Auto-dismisses after ~2000ms, returns user to watch face
- No user interaction needed — it is purely visual confirmation

**Step 4 — Complication update:**
- `ProviderUpdateRequester.requestUpdateAll()` forces the system to re-query your `ComplicationDataSource`
- Your data source returns the updated count/value
- The complication on the watch face reflects the new data immediately

**Horologist alternative:**
- Use `ConfirmationOverlay` composable from Horologist library for a Compose-based confirmation
- Shows icon + message text, auto-hides after specified duration

### watchOS Implementation

**Step 1 — Complication tap target:**
- Set `widgetURL` or use deep link in your `CLKComplicationDataSource` timeline entries
- With WidgetKit (watchOS 9+): use `AppIntent` framework for direct action execution

**Step 2 — AppIntent handles action:**

```swift
struct LogCigaretteIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Cigarette"

    func perform() async throws -> some IntentResult & ProvidesDialog {
        CigaretteStore.shared.logEvent(date: .now)
        return .result(dialog: "Logged ✓")
    }
}
```

**Step 3 — Widget/Complication update:**
- Call `WidgetCenter.shared.reloadTimelines(ofKind: "CigaretteComplication")` inside the intent
- The complication re-renders with updated data from the shared data store
- For `CLKComplicationServer`: call `reloadTimeline(for:)` on active complications

**Step 4 — Haptic confirmation:**
- Always fire haptic on action completion — the user may not be looking at the screen
- `WKInterfaceDevice.current().play(.success)` for successful action
- `WKInterfaceDevice.current().play(.failure)` if action fails

### Haptic Feedback (Both Platforms)

Haptic confirmation is **mandatory** for complication-to-action, not optional. The user taps a tiny target on the watch face — they need physical confirmation that it registered.

**Wear OS:**
```kotlin
val vibrator = context.getSystemService(Vibrator::class.java)
vibrator.vibrate(VibrationEffect.createOneShot(50, 180))
```
- Duration: 50ms (short, crisp)
- Amplitude: 180 (firm but not jarring, scale 1-255)

**watchOS:**
- Success: `WKHapticType.success` (double tap feeling)
- Failure: `WKHapticType.failure` (three quick taps)
- Retry prompt: `WKHapticType.retry` (single firm tap)

### Error Handling

When the background action fails (database error, storage full, etc.):

**Wear OS:**
- Launch `ConfirmationActivity` with `FAILURE_ANIMATION` instead of `SUCCESS_ANIMATION`
- Add a "Retry?" button by launching a minimal activity after the failure animation
- Log the failure for debugging; do not silently swallow errors

**watchOS:**
- Return `.result(dialog: "Failed")` from the AppIntent
- Fire `.failure` haptic
- If the intent supports it, provide a "Retry" action in the dialog

### Offline Queueing

The phone may be unreachable when the user taps the complication. The action must still succeed locally.

**Strategy:**
1. Always write the action to local storage first (Room DB on Wear OS, Core Data/SwiftData on watchOS)
2. Queue a sync task for when the phone becomes reachable
3. Show the success confirmation to the user (the local action succeeded)
4. Display a small "pending sync" badge on the complication (e.g., tiny dot or cloud icon)
5. When the phone reconnects, flush the queue and remove the pending badge
6. If the queue grows beyond 50 items, warn the user to check phone connection

**Wear OS pending badge:**
- Use `SmallImage` type complication with an overlay dot
- Or use `ShortText` with a trailing "•" character when items are pending

**watchOS pending badge:**
- Add a small indicator in the complication's `CLKComplicationTemplate` or WidgetKit view
- Use SF Symbol `arrow.triangle.2.circlepath` (sync pending) as a small overlay

### Performance Requirements

| Metric | Target | Rationale |
|--------|--------|-----------|
| Tap-to-haptic latency | < 200ms | User must feel response instantly |
| Action execution | < 500ms | Database write + queue sync |
| Confirmation display | 1.5–2s | Long enough to read, short enough to not annoy |
| Complication update | < 1s after action | User sees new count immediately |
| Total interaction | < 3s | Faster than pulling out phone |

### Checklist

- ✅ Tap targets a BroadcastReceiver (Wear OS) or AppIntent (watchOS), not a full Activity
- ✅ Haptic fires within 200ms of tap
- ✅ ConfirmationActivity/dialog auto-dismisses in 2 seconds
- ✅ Complication data updates immediately after action
- ✅ Action writes to local storage first, syncs to phone second
- ✅ Offline queue with pending badge on complication
- ✅ Failure shows error animation + retry option
- ❌ Do not launch the full app for single-action operations
- ❌ Do not require network connectivity for the action to succeed locally
- ❌ Do not skip haptic feedback (user may not be looking at screen)
- ❌ Do not show confirmation for longer than 3 seconds (blocks watch face)

**Sources:** [Wear OS Complications Data Source](https://developer.android.com/training/wearables/complications/data-source), [ConfirmationActivity](https://developer.android.com/reference/androidx/wear/activity/ConfirmationActivity), [ClockKit](https://developer.apple.com/documentation/clockkit), [WidgetKit AppIntent](https://developer.apple.com/documentation/widgetkit/adding-interactivity-to-widgets-and-live-activities), [Horologist ConfirmationOverlay](https://google.github.io/horologist/)

---

## BV. Watch App Icon Specifications

> Detailed icon specifications for watch app launchers, complications, and app stores.
> A watch app icon is viewed at approximately 48dp on a 1.2–1.9" screen — clarity and simplicity are paramount.
> Sources: [Wear OS Icon Guidelines](https://developer.android.com/training/wearables/design/app-icons), [Apple HIG App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons), [Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)

### Wear OS Launcher Icon

**Dimensions and format:**
- Master size: 300×300px (xxxhdpi), system scales down to 48dp for display
- Provide all density buckets: mdpi (48×48), hdpi (72×72), xhdpi (96×96), xxhdpi (144×144), xxxhdpi (192×192 or 300×300)
- Format: WebP (preferred) or PNG
- File location: `res/mipmap-xxxhdpi/ic_launcher.webp` and `ic_launcher_round.webp`

**Shape and masking:**
- The system applies a **circular mask** automatically on Wear OS
- Design your icon as a full-bleed square; the system will crop to circle
- Safe zone: keep all meaningful content within the **center 75%** (225×225px area at 300px master)
- Content outside the safe zone will be clipped by the circular mask — use it only for background color/pattern

**Adaptive icon layers:**
- Provide two layers: foreground (symbol/logo) and background (solid color or gradient)
- Foreground layer: PNG with transparency, centered symbol
- Background layer: opaque color or simple gradient
- The system applies subtle parallax motion between layers on tilt — design for it
- Declare in `AndroidManifest.xml` via `<adaptive-icon>` or in `ic_launcher.xml` resource

**Design guidelines:**
- Symbol: centered, occupying maximum **60% of total area** (180×180px at 300px master)
- Use high contrast between symbol and background — test on OLED black watch face
- Background: use brand primary color or simple gradient; **avoid pure black** (#000000) as it blends with the OLED display and makes the icon invisible on dark watch faces
- Minimum recommended background luminance: #1A1A1A or brighter
- No text in the icon — at 48dp displayed size, text is illegible
- No photographs or screenshots — they become muddy noise at small sizes
- Line weight: minimum 2dp strokes at displayed size (approximately 12px at 300px master)

**Testing your icon:**
- View at actual 48dp size on a real watch or emulator
- Place on a dark watch face AND a light watch face — both must work
- Compare visual weight against system icons (Settings gear, Play Store icon)
- Walk 3 steps back from the watch on your wrist — can you still identify the icon?

### watchOS App Icon

**Dimensions and full size set:**
- Master design: **1024×1024px** (used for App Store listing)
- Device sizes required (all @2x):
  - 38mm: 80×80px
  - 40mm: 88×88px (172×172px @2x)
  - 41mm: 92×92px (181×181px @2x)
  - 42mm: 80×80px
  - 44mm: 100×100px (196×196px @2x)
  - 45mm: 102×102px (204×204px @2x)
  - 49mm Ultra: 108×108px (215×215px @2x)
- Notification icon sizes: 24×24px, 27.5×27.5px, 29×29px, 33×33px (@2x variants)
- Companion Settings icon: 58×58px (@2x), 87×87px (@3x)

**Shape and masking:**
- The system applies a **squircle** (continuous corner radius / superellipse) mask automatically
- Design as a full-bleed square — the OS handles the corner rounding
- Safe zone: keep all meaningful content within the **center 80%** (820×820px area at 1024px master)
- Corners get rounded aggressively — never place important content near edges

**Design guidelines:**
- Background: **MUST be opaque** — transparency is not allowed (unlike iOS app icons, watchOS requires a solid background since watchOS 6)
- Symbol: simple, recognizable silhouette, centered, occupying maximum **65% of total area**
- Color: use brand primary color, but consider **increasing saturation by 5-10%** compared to the phone icon — small icons benefit from slightly more vivid colors
- No text, no photographs, no screenshots — same rules as Wear OS
- Ensure the icon is identifiable at 40px physical display size
- Stroke weight: minimum 2pt at the smallest display size

**Dark and tinted mode (watchOS 10+):**
- watchOS 10 introduced automatic icon tinting for certain watch face styles
- Provide an alternate dark-mode icon variant in your asset catalog
- The system may desaturate or tint your icon — test with multiple watch face color themes
- Recommended: provide a monochrome "template" version alongside the full-color icon

**Asset catalog setup:**
- Create `AppIcon` set in `Assets.xcassets` with watchOS target
- Xcode will show slots for each required size
- Use a single 1024×1024 master and let Xcode auto-generate sizes, OR provide hand-optimized versions for each size (recommended for complex icons)

**Testing your icon:**
- Preview in Xcode's asset catalog at all sizes simultaneously
- Test on physical device with both light and dark watch faces
- Test alongside native Apple apps — your icon should feel native in weight and style
- Check the App Store listing on an iPhone — the 1024px version must also look good at phone-screen sizes

### Complication Icons (Separate from App Icon)

Complication icons appear on the watch face itself, alongside time and other data. They have different requirements from the app launcher icon.

**Wear OS complication icon:**
- Size: 24dp (approximately 72px at xxxhdpi)
- Style: single-color silhouette — the system tints it to match the watch face theme
- Weight: match Material Icon weight (outlined, 2dp stroke)
- Format: vector drawable (XML) preferred, PNG acceptable
- Keep it simple: the icon is displayed at approximately 7mm physical size
- No background shape — the icon floats on the watch face
- File: `res/drawable/ic_complication.xml`

**watchOS complication icon:**
- Style: SF Symbol aesthetic — consistent stroke weight, geometric precision
- Rendering mode: template (single color, tinted by the system based on watch face)
- Provide as PDF or SVG in the asset catalog with "Render As: Template Image"
- Sizes: match the complication family (graphic circular, graphic corner, etc.)
- Must be legible in both light and dark tint colors — test with white and black tinting

### General Icon Design Tips

**The "3-step test":**
1. Display the icon on a real watch, on your wrist
2. Walk 3 steps away from a mirror
3. If you can identify the icon at that distance, it passes — if not, simplify further

**Visual consistency:**
- Compare your icon against platform system icons (Settings, Workout, Timer)
- Match the visual weight: if system icons use 2dp strokes, yours should too
- Use the platform's icon grid template for alignment:
  - Wear OS: [Adaptive Icon Grid](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)
  - watchOS: Apple's icon grid in the HIG resources

**Color for small sizes:**
- Darker colors lose detail on OLED — keep primary background above #2A2A2A
- Highly saturated colors pop better at small sizes than muted tones
- Test with protanopia and deuteranopia filters — icon must be distinguishable by shape, not just color

**Common mistakes to avoid:**
- Putting the company name or app name as text in the icon
- Using a photo or screenshot as the icon background
- Designing at 1024px without checking how it looks at 48dp
- Using pure black background on Wear OS (invisible on OLED watch faces)
- Ignoring the safe zone and losing content to circular/squircle masking
- Making the symbol too detailed — features smaller than 2dp disappear at displayed size

### Icon Specifications Quick Reference

| Property | Wear OS | watchOS |
|----------|---------|---------|
| Master size | 300×300px (xxxhdpi) | 1024×1024px |
| Display size | 48dp | ~40-54pt (varies by model) |
| Shape mask | Circle (automatic) | Squircle (automatic) |
| Safe zone | Center 75% | Center 80% |
| Max symbol area | 60% | 65% |
| Background | Opaque, avoid #000000 | Opaque required, no transparency |
| Text allowed | No | No |
| Format | WebP/PNG, adaptive icon XML | PNG in asset catalog |
| Complication icon | 24dp, single-color vector | SF Symbol style, template render |
| Dark mode variant | N/A (system handles) | Yes (watchOS 10+) |

### Checklist

- ✅ Master icon designed at platform-specified master resolution
- ✅ All meaningful content within safe zone (75% Wear OS, 80% watchOS)
- ✅ Symbol is recognizable at 48dp / 40pt actual display size
- ✅ Background is not pure black (#000000) on Wear OS
- ✅ Background is fully opaque on watchOS (no transparency)
- ✅ No text, no photographs, no screenshots in the icon
- ✅ Adaptive icon layers provided for Wear OS (foreground + background)
- ✅ All required sizes provided in watchOS asset catalog
- ✅ Complication icon is single-color, template-rendered, separate from app icon
- ✅ Tested on real device at arm's length with both light and dark watch faces
- ✅ Dark/tinted mode variant provided for watchOS 10+
- ❌ Do not use gradients with more than 2 stops (becomes mud at small size)
- ❌ Do not exceed 65% symbol area (icon feels cramped)
- ❌ Do not hand-pick icon sizes — use the platform's density system

**Sources:** [Wear OS App Icon Guidelines](https://developer.android.com/training/wearables/design/app-icons), [Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive), [Apple HIG App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons), [Apple watchOS Icon Sizes](https://developer.apple.com/design/human-interface-guidelines/app-icons#watchOS-app-icon-sizes), [SF Symbols](https://developer.apple.com/sf-symbols/)

---

## BW. watchOS 12 & Apple Intelligence on Watch

> Dernieres evolutions watchOS de WWDC 2025, Apple Intelligence sur poignet, Sleep Apnea, et fonctionnalites Ultra.
> Sources: [Apple WWDC 2025](https://developer.apple.com/wwdc25/), [watchOS 12 Release Notes](https://developer.apple.com/documentation/watchos-release-notes/watchos-12-release-notes), [Apple Watch Ultra 2 User Guide](https://support.apple.com/guide/apple-watch-ultra-2/), [Apple Health Technologies](https://developer.apple.com/health-fitness/)

---

### 1. watchOS 12 Visual Changes

Le design **Liquid Glass** introduit a WWDC 2025 s'applique a la montre:

- **Navigation bar** : materiau translucide avec flou gaussien, s'adapte au contenu derriere
- **Boutons systeme** : rendu verre avec reflets dynamiques selon l'angle du poignet
- **Animations spring-based** : transitions utilisant des ressorts physiques (stiffness ~300, damping ~20), remplacant les eases cubiques
- **Coins arrondis uniformes** : `continuous` corner style applique globalement, rayon proportionnel a la taille de l'element
- **Elevation et profondeur** : ombres subtiles sous les cartes et boutons, renforce la hierarchie visuelle

**Smart Stack revamped:**
- Cartes en verre translucide avec bordure lumineuse subtile
- Transitions plus fluides entre widgets (cross-dissolve avec spring animation)
- Regroupement intelligent : widgets lies affiches en cluster (ex: Meteo + UV + Vent)
- Long-press sur un widget → menu contextuel inline (plus besoin d'ouvrir l'app)

**Cadrans et complications interactives:**
- Nouveaux cadrans exploitant Liquid Glass (reflets reagissent au mouvement du poignet)
- Tap direct sur une complication → action instantanee sans ouvrir l'app
  - Exemple : tap sur complication "Eau" → ajoute 250ml, haptic confirmation
- Complications animees : mini-graphiques en temps reel (sparkline, gauge circulaire)
- Live Activities etendues : apps tierces peuvent afficher des donnees live sur le cadran
  - Transport en commun, minuteurs cuisine, score sportif, suivi livraison
  - Limite : 1 Live Activity visible a la fois sur le cadran, rotation automatique si multiples

**Impact developpeur:**
- Tester les vues custom avec le nouveau materiau : `Material.ultraThinMaterial` sur watchOS 12
- Les anciens `NavigationStack` / `List` adoptent automatiquement le style Liquid Glass
- Attention: texte sur fond verre necessite contraste eleve → utiliser `.foregroundStyle(.primary)` ou blanc pur

---

### 2. watchOS 12 Developer APIs

**NavigationSplitView ameliore:**
- Support elargi pour les plus grands ecrans Apple Watch (Ultra 49mm, Series 10 46mm)
- Sidebar + Detail view sur grands ecrans, collapse automatique sur petits ecrans
- `NavigationSplitView { sidebar } detail: { detail }` fonctionne nativement sur watchOS 12

**WidgetKit etendu:**
- Nouvelles familles de complications : `accessoryRectangularLarge` (2x la hauteur du rectangular standard)
- Contenu plus riche : images, graphiques, texte multi-ligne dans les complications
- Rechargement intelligent : le systeme apprend quand l'utilisateur consulte chaque widget
- `AppIntentTimelineProvider` : les widgets peuvent declencher des App Intents directement

**Gestes et raccourcis:**
- `.handGestureShortcut(.primaryAction)` etendu : nouveaux types de gestes
  - Double-pinch : action secondaire configurable
  - Clench (poing ferme) : action tertiaire
  - Chaque app peut enregistrer jusqu'a 3 gestes distincts
- `DigitalCrownRotation` ameliore : retour haptique granulaire par cran

**Background App Refresh:**
- Planification intelligente basee sur les habitudes utilisateur
- Si l'utilisateur consulte l'app chaque jour a 8h, le refresh se declenche a 7h55
- Budget plus genereux pour les apps health/fitness : jusqu'a 4 refreshs/heure (vs 1 standard)
- Nouveau `BGHealthMonitoringTaskRequest` pour monitoring continu en arriere-plan

**Nouvelles donnees sante:**
- Body temperature trends : acces aux tendances (pas seulement valeur brute)
- Hydration estimation : basee sur activite + transpiration + conditions meteo
- `HKQuantityType(.dietaryWater)` ameliore avec estimation passive
- Readiness score : score composite basé sur HRV + sommeil + charge entrainement

**CustomWorkoutComposition API:**
- Construire des segments d'entrainement programmatiquement
- `WorkoutComposition { WarmupStep(duration: .minutes(5)); IntervalStep(work: .minutes(4), rest: .minutes(1), repeats: 6); CooldownStep(duration: .minutes(5)) }`
- Synchronisation avec Apple Fitness+ pour entrainements guides
- Export vers le format `.workout` partageable entre utilisateurs

---

### 3. Apple Intelligence on Watch

**Resumes de notifications:**
- Meme moteur que sur iPhone, adapte au poignet
- Groupement intelligent : toutes les notifications d'une conversation → 1 resume
- Format : 2 lignes max, style telegraphique ("Jean: diner 20h ce soir? Marie: OK pour moi")
- Le resume preserve le sentiment (urgence, ton positif/negatif)
- Tap sur le resume → deploie toutes les notifications individuelles

**Smart Replies:**
- Suggestions de reponse contextuelles alimentees par ML on-device
- 3 suggestions max, adaptees au contexte de la conversation
- Support du ton : detecte si la conversation est formelle/informelle
- Fonctionne sans iPhone a proximite (modele on-device sur S9+)
- Personnalisation : apprend le style de reponse de l'utilisateur au fil du temps

**Siri ameliore:**
- Temps de reponse reduit : ~1s pour requetes on-device (vs ~2s watchOS 11)
- Conscience du contenu a l'ecran : "Que dit cette notification?" → Siri lit le contenu
- Enchainement de requetes sans re-invoquer : conversation multi-tour
- Limites persistantes : pas d'Image Playground, pas de Writing Tools (ecran trop petit)
- Pas de generation d'image ou d'edition de texte longue sur la montre

**Health Insights IA:**
- Resumes de tendances sante generes par IA dans l'app Vitals
- Format narratif : "Votre frequence cardiaque au repos a baisse de 5% cette semaine, coherent avec votre augmentation d'activite"
- Alertes proactives : detection d'anomalies dans les patterns (ex: HRV inhabituellement basse)
- Donnees restent 100% on-device, aucun envoi cloud pour les insights sante

**Impact developpeur:**
- App Intents fonctionnent avec Siri sur la montre → exposer les actions de l'app
- `@AssistantIntent` pour rendre les actions discoverables par Siri
- Les actions IA lourdes sont offloadees sur l'iPhone appaire → la montre doit etre a proximite
- Prevoir un fallback si l'iPhone n'est pas disponible (mode avion, batterie morte)

---

### 4. Sleep Apnea Detection (watchOS 11+)

**Contexte reglementaire:**
- FDA-authorized De Novo (septembre 2024), premier dispositif grand public pour le depistage
- Disponible sur Apple Watch Series 9+, Ultra 2+ (accelerometre haute precision requis)
- Classification : outil de depistage, pas de diagnostic (oriente vers consultation medicale)

**Fonctionnement technique:**
- Accelerometre detecte les perturbations respiratoires pendant le sommeil
- Mesure les mouvements subtils du poignet lies aux micro-eveils respiratoires
- Metrique : "Breathing Disturbances" affichee comme Elevated / Not Elevated
- Necessite 10 nuits de donnees sur une periode de 30 jours pour l'evaluation initiale
- Algorithme ML entraine sur des donnees polysomnographiques cliniques

**Flow UX:**
1. Activation : Reglages > Sommeil > "Perturbations respiratoires" → Activer
2. Collecte silencieuse pendant 10 nuits (pas de feedback intermediaire)
3. Notification Health : "Vos resultats de perturbations respiratoires sont prets"
4. Tap → Health app → graphique de tendance sur 30 jours
5. Statut binaire avec code couleur : vert (Not Elevated), jaune (Elevated)
6. Si Elevated : bouton "Partager avec votre medecin" → genere un PDF medical
7. Le PDF inclut : graphique 30 jours, nombre de nuits analysees, methodologie

**Acces developpeur:**
- HealthKit : `HKQuantityType.quantityType(forIdentifier: .appleBreathingDisturbances)`
- Donnee hautement sensible → autorisation HealthKit explicite requise
- Pas d'acces aux donnees brutes d'accelerometre nocturne (uniquement le resultat agrege)
- Affichage recommande : statut binaire (pas un chiffre), couleur codee, tendance temporelle

---

### 5. Apple Watch Ultra Features UX

**Jauge de profondeur:**
- Activation automatique quand submerge >1m, desactivation en surface
- Affichage : profondeur actuelle (centre, grande police), max profondeur (haut-gauche), temperature eau (haut-droite), duree (bas)
- Arriere-plan : degrade bleu qui s'intensifie avec la profondeur
- Limite : plongee recreative uniquement (max 40m, certifie EN 13319)
- API : `CMWaterSubmersionManager` pour evenements d'immersion
- Pas d'API de profondeur directe pour apps tierces (donnees proprietary)

**Precision Finding (Ultra 2):**
- UWB + guidance visuelle/haptique pour localiser iPhone ou AirTag
- UI : fleche plein ecran pointant vers l'appareil, distance en metres
- Animation pulsante, intensite haptique augmente a l'approche
- Fonctionne a l'interieur grace au UWB (pas seulement GPS)

**Action Button:**
- Pression simple : configurable (Workout, Chronometre, Waypoint, Retour, Plongee, Lampe, Raccourci)
- Pression longue (3s) : Sirene (86dB, son d'urgence)
- Developpeur : mapper l'Action Button vers un App Intent → action custom dans l'app
- Design UX : action immediate, aucun ecran de confirmation (vitesse > securite pour sports/outdoor)
- Feedback : haptique fort + retour visuel instantane pour confirmer l'action

**Mode Nuit:**
- Teinte rouge sur toute l'UI, preserve l'adaptation a l'obscurite
- Activation automatique en faible luminosite, ou toggle via Centre de Controle
- Developpeur : surveiller `.preferredColorScheme` et adapter les vues custom
- Tester les vues avec teinte rouge : verifier que le contraste reste lisible

---

### Checklist watchOS 12

- ✅ Tester toutes les vues avec le materiau Liquid Glass (contraste texte)
- ✅ Adopter les animations spring-based pour les transitions custom
- ✅ Mettre a jour les complications pour les nouvelles familles WidgetKit
- ✅ Exposer les actions cles via App Intents pour Siri
- ✅ Prevoir un fallback si l'iPhone n'est pas a proximite pour les fonctions IA
- ✅ Tester les gestes etendus (double-pinch, clench) si pertinent
- ✅ Valider le flow Sleep Apnea si l'app touche au sommeil/sante
- ✅ Adapter les vues pour le mode Nuit si l'app cible les utilisateurs Ultra
- ❌ Ne pas afficher les donnees de perturbations respiratoires comme un nombre brut
- ❌ Ne pas supposer que Apple Intelligence est disponible (Series 8 et avant : non)
- ❌ Ne pas bloquer l'UX si le reseau est indisponible pour les fonctions IA

**Sources:** [Apple WWDC 2025](https://developer.apple.com/wwdc25/), [watchOS 12 Release Notes](https://developer.apple.com/documentation/watchos-release-notes/watchos-12-release-notes), [Apple Watch Ultra 2 User Guide](https://support.apple.com/guide/apple-watch-ultra-2/), [Sleep Apnea Detection](https://support.apple.com/en-us/108091), [HealthKit Breathing Disturbances](https://developer.apple.com/documentation/healthkit), [Apple Intelligence](https://developer.apple.com/apple-intelligence/)

---

## BX. Wearable AI Assistants & Voice 2025

> Capacites des assistants IA sur montres connectees en 2025 : Gemini sur Wear OS, Siri ameliore, bonnes pratiques voix.
> Sources: [Google I/O 2025](https://io.google/2025/), [Apple WWDC 2025](https://developer.apple.com/wwdc25/), [Samsung Galaxy Watch Documentation](https://developer.samsung.com/one-ui-watch)

---

### 1. Gemini on Wear OS (2025)

**Deploiement:**
- Samsung Galaxy Watch 7+ (One UI Watch 6+) : Google Gemini comme assistant par defaut
- Pixel Watch 3+ : Gemini Nano on-device pour taches legeres
- Remplacement progressif de Google Assistant classique sur les montres compatibles

**Activation:**
- Pression longue du bouton home → overlay Gemini
- "Hey Google" wake word (toujours actif, faible consommation via DSP dedie)
- Geste raise-to-speak : lever le poignet + parler sans wake word

**Capacites cloud (via phone relay):**
- Requetes conversationnelles : meteo, directions, rappels, minuteurs
- Actions contextuelles : "Commence un entrainement" → ouvre l'app Workout avec activite detectee
- Controle maison connectee : "Eteins la lumiere du salon" → integration Google Home native
- Interaction notifications : "Reponds a Jean" → dictee vocale ou smart reply
- Multi-modal : peut lire et resumer le contenu des notifications groupees
- Recherche web : resultats resumes affiches sur la montre (pas de page web complete)

**UI pattern vocal:**
- Overlay plein ecran avec fond sombre semi-transparent
- Resultats partiels affiches en temps reel (streaming text)
- Indicateur d'ecoute : icone micro animee (ondes pulsantes)
- Si la reponse est longue : carte scrollable avec resume en haut
- Boutons d'action rapide sous la reponse ("Ouvrir sur le telephone", "En savoir plus")
- Timeout : 3s de silence → arret de l'ecoute, affichage de ce qui a ete compris

**Gemini Nano on-device (Pixel Watch 3+):**
- Modele 2B parametres, execute localement sur le NPU de la montre
- Smart reply generation : suggestions de reponse sans cloud
- Summarisation de notifications : resume en 1 phrase
- Enhancement de la reconnaissance d'activite : inference locale plus rapide
- Limitation : pas de capacite conversationnelle complete, pas de recherche web
- Avantage : fonctionne sans telephone, sans WiFi, sans LTE
- Latence : ~200ms pour smart reply, ~500ms pour summarisation

**Integration developpeur:**
- Pas d'API Gemini directe sur la montre (utiliser l'API cloud via phone relay)
- App Actions : exposer les fonctionnalites de l'app via `<capability>` dans AndroidManifest
  ```xml
  <capability android:name="actions.intent.START_EXERCISE">
    <intent android:action="android.intent.action.VIEW"
            android:targetPackage="com.example.app">
      <parameter android:name="exercise.name" android:key="exerciseType"/>
    </intent>
  </capability>
  ```
- Voice shortcuts : enregistrer des patterns vocaux pour acces rapide a l'app
- `RemoteActionCompat` → declencher Gemini cote telephone pour requetes complexes
- BII (Built-in Intents) : catalogue d'intents standardises pour actions courantes

---

### 2. Siri on watchOS (2025 Improvements)

**Traitement on-device:**
- La plupart des requetes gerees sans iPhone pour Series 9+ (Neural Engine)
- Requetes on-device : minuteurs, alarmes, rappels, controle musique, HomeKit basique
- Requetes necessitant cloud : recherche web, requetes complexes, traduction
- Temps de reponse on-device : ~1s (vs ~2-3s avec relay iPhone)

**Integration Apple Intelligence:**
- Siri peut lire et agir sur le contenu affiche a l'ecran
- "Qu'est-ce que dit cette notification?" → Siri extrait et resume le contenu
- Contexte personnel : Siri accede aux informations des apps compatibles via App Intents
- Conversation multi-tour : enchainer des requetes sans re-invoquer "Hey Siri"
- Suggestion proactive : Siri propose des actions basees sur l'heure, le lieu, la routine

**App Intents pour developpeurs:**
```swift
struct LogCigaretteIntent: AppIntent {
    static var title: LocalizedStringResource = "Log a Cigarette"
    static var description = IntentDescription("Records a cigarette event")

    func perform() async throws -> some IntentResult {
        CigaretteTracker.shared.log()
        return .result(dialog: "Logged. Stay strong!")
    }
}
```
- `@AssistantIntent` : rend l'intent discoverable par Siri sans configuration manuelle
- `SiriTipView` sur la montre : enseigner les commandes vocales avec des tips in-app
  - Placement recommande : en bas de l'ecran principal, disparait apres 3 utilisations
- Parametres dynamiques : Siri peut demander des precisions ("Combien de cigarettes?")
- Resultat enrichi : retourner un `IntentResult` avec dialogue + snippet visuel

**Smart Stack & suggestions:**
- Siri suggere les widgets pertinents selon le contexte temporel/spatial
- Matin : widget sommeil + meteo + calendrier
- Arrivee au bureau : widget transport + reunions
- Fin de journee : widget activite + rappels
- L'ordre du Smart Stack s'adapte automatiquement, l'utilisateur peut epingler des widgets

**Type to Siri (watchOS 11+):**
- Disponible via clavier scribble ou mini-clavier QWERTY
- Utile dans les environnements bruyants ou les situations ou parler est inapproprie
- Activer : Reglages > Siri > "Ecrire a Siri"
- Le champ texte apparait a la place de l'interface vocale

---

### 3. Voice Input Best Practices 2025

**Sensibilite au wake word:**
- Ajuster pour les environnements bruyants (salle de sport, exterieur, transports)
- Les deux plateformes utilisent le beamforming + reduction de bruit ML
- Faux positifs plus rares avec les modeles 2025 (taux < 0.5% en environnement normal)
- Conseil : proposer un mode "bouton uniquement" pour desactiver le wake word

**Confirmation des actions vocales:**
- Toujours confirmer avec haptique + feedback visuel bref (1.5s max)
- Pattern : ecran de succes avec icone checkmark + texte court → auto-dismiss
- Pour actions destructives : ajouter une etape de confirmation vocale ("Etes-vous sur?")
- Pour actions reversibles : confirmer + montrer "Annuler" pendant 3s

**Gestion des erreurs:**
- Si mal compris : afficher ce qui a ete entendu + bouton "Reessayer"
- Ne jamais executer une action ambigue sans confirmation
- Proposer des alternatives : "Vouliez-vous dire X ou Y?"
- Apres 2 echecs consecutifs : suggerer la saisie manuelle ("Essayez d'ecrire")

**Fallback hors-ligne:**
- Mettre en file les commandes vocales quand offline
- Executer a la reconnexion avec notification de confirmation
- Actions locales (minuteur, alarme) : executer immediatement sans reseau
- Actions cloud (envoi message, recherche) : informer "Sera envoye des que connecte"

**Multi-langue:**
- Support du code-switching (l'utilisateur change de langue en pleine phrase)
- Detecter automatiquement la langue sans forcer une selection manuelle
- Les modeles 2025 gerent le melange francais-anglais courant ("Set un timer de 5 minutes")
- Limites : les langues avec peu de donnees d'entrainement ont un taux d'erreur plus eleve

**Indicateurs de confidentialite:**
- watchOS : point vert dans la barre de statut quand le micro est actif
- Wear OS : icone micro dans le panneau de notifications rapides
- Obligation legale : informer visuellement l'utilisateur que l'ecoute est active
- Les donnees vocales sur-device ne sont jamais transmises au cloud (on-device models)

**Timeout et duree d'ecoute:**
- 3 secondes de silence → arreter l'ecoute (ne pas attendre plus longtemps)
- Feedback visuel du countdown : onde sonore qui diminue progressivement
- Si l'utilisateur parle tres lentement : etendre a 5s avec indicateur "J'ecoute encore..."
- Maximum absolu : 30s d'ecoute continue, puis couper avec "Message trop long pour la montre"

**Annulation de bruit:**
- Beamforming + ML noise reduction sur les deux plateformes
- Wear OS (Pixel Watch 3) : 3 microphones, suppression active du bruit ambiant
- watchOS (Series 9+) : dual microphones avec algorithme de separation de sources
- En environnement tres bruyant (>85dB) : afficher "Environnement bruyant, rapprochez-vous"

---

### 4. Comparison Table: Gemini vs Siri on Watch

| Feature | Gemini (Wear OS) | Siri (watchOS) |
|---------|-----------------|-----------------|
| On-device model | Nano 2B (Pixel Watch 3+) | Neural Engine (S9+ chip) |
| Cloud fallback | Oui (phone relay) | Oui (iPhone relay) |
| Smart home | Google Home natif | HomeKit natif |
| App actions | App Actions / `<capability>` | App Intents / `@AssistantIntent` |
| Langues supportees | 40+ | 21 |
| Wake word | "Hey Google" | "Hey Siri" / Raise to speak |
| Response speed (on-device) | ~1.2s | ~1.0s |
| Response speed (cloud) | ~2.5s | ~2.0s |
| Smart reply | Gemini Nano | Apple Intelligence |
| Notification summary | Gemini Nano | Apple Intelligence |
| Multi-turn conversation | Oui (cloud) | Oui (watchOS 12) |
| Screen context awareness | Non | Oui (Apple Intelligence) |
| Type-to-assistant | Oui (clavier Wear OS) | Oui (watchOS 11+) |
| Offline capability | Partielle (Nano) | Partielle (Neural Engine) |

---

### 5. Integration Patterns for Smoking Cessation App

**Gemini / Wear OS:**
```xml
<capability android:name="actions.intent.CREATE_THING">
  <intent android:action="android.intent.action.VIEW"
          android:targetPackage="com.infernalwheel.app">
    <parameter android:name="thing.name" android:key="eventType"/>
  </intent>
</capability>
```
- "Hey Google, log a cigarette on Infernal Wheel" → declenche l'intent
- Smart reply contextuelle quand la notification de rappel arrive

**Siri / watchOS:**
```swift
struct QuickLogIntent: AppIntent {
    static var title: LocalizedStringResource = "Quick Log"
    @Parameter(title: "Count") var count: Int?

    func perform() async throws -> some IntentResult {
        let qty = count ?? 1
        CigaretteTracker.shared.log(count: qty)
        return .result(dialog: "Logged \(qty). You've had \(CigaretteTracker.shared.todayCount) today.")
    }
}
```
- "Hey Siri, quick log 2" → enregistre 2 cigarettes, feedback avec total du jour
- SiriTipView sur l'ecran principal : "Dites 'Quick Log' pour enregistrer"

**Bonnes pratiques communes:**
- Le feedback vocal doit etre encourageant, jamais culpabilisant
- Inclure le total du jour dans la reponse pour conscience situationnelle
- Proposer un raccourci vocal pour la fonction la plus frequente (log)
- Ne pas exposer les statistiques detaillees par voix (trop long → orienter vers l'ecran)

---

### Checklist AI Assistants & Voice

- ✅ App Actions / App Intents declares pour les fonctions principales
- ✅ Feedback vocal bref et encourageant (<2s de dialogue)
- ✅ Confirmation haptique apres chaque action vocale
- ✅ Fallback offline : actions locales executees, actions cloud en file d'attente
- ✅ Gestion d'erreur : afficher ce qui a ete compris + option reessayer
- ✅ SiriTipView / voice shortcut tips integres dans l'app
- ✅ Indicateur de confidentialite visible quand le micro est actif
- ✅ Timeout de 3s de silence, feedback visuel du countdown
- ✅ Teste en environnement bruyant (>70dB) avec des commandes courantes
- ✅ Multi-langue : au minimum la langue du systeme + anglais
- ❌ Ne pas executer d'action destructive sans confirmation vocale explicite
- ❌ Ne pas envoyer de donnees vocales au cloud si un modele on-device suffit
- ❌ Ne pas forcer l'assistant vocal : toujours offrir une alternative tactile
- ❌ Ne pas depasser 30s d'ecoute continue sur la montre

**Sources:** [Google I/O 2025](https://io.google/2025/), [Apple WWDC 2025](https://developer.apple.com/wwdc25/), [Samsung Galaxy Watch AI Features](https://developer.samsung.com/one-ui-watch), [Gemini Nano on-device](https://ai.google.dev/edge), [Apple App Intents](https://developer.apple.com/documentation/appintents), [App Actions](https://developer.android.com/guide/app-actions), [NNGroup Voice UX](https://www.nngroup.com/articles/voice-first/)

---

*Bible UX Wearable - Sections BC-BX added March 2026*
*Sources include: Apple Developer Documentation, Android Developer Documentation, Garmin Connect IQ SDK, FDA regulatory guidance, NEJM, Nature Medicine, AHA standards, FiRa Consortium, NNGroup, WHO guidance, Google AI, Apple Intelligence*