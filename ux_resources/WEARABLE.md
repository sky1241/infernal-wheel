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

**Figma — Kits officiels:**

| Kit | Source | Contenu |
|-----|--------|---------|
| **Material 3 for Wear OS** | Google (Figma Community) | Composants M3, couleurs, typo, layouts rond |
| **Apple Watch Design Kit** | Apple (Figma Community) | Composants watchOS, ecrans types, metrics |
| **Samsung Galaxy Watch** | Samsung Developers | One UI Watch composants, bezel simulation |

**Configurer Figma pour ecran rond:**
- Frame 384x384 px (Pixel Watch) ou 450x450 px (Galaxy Watch 6)
- Masque circulaire sur le frame (clip content)
- Plugin "Watch Face" ou "Circle Mask" pour preview rapide
- Grille 8dp pour alignement (4dp pour micro-spacing)
- Exporter: **2x** pour densite OLED (1.5-2x selon modele)

**Android Studio — Outils de design:**

```kotlin
// Preview Compose pour montre
@Preview(
    device = WearDevices.SMALL_ROUND,  // 192dp
    showSystemUi = true,
    showBackground = true,
    backgroundColor = 0xFF000000
)
@Composable
fun MainScreenPreview() {
    InfernalWearTheme {
        MainScreen(count = 5)
    }
}

// Preview multi-devices
@Preview(device = WearDevices.SMALL_ROUND, name = "Small")
@Preview(device = WearDevices.LARGE_ROUND, name = "Large")
@Preview(
    device = "spec:width=280dp,height=280dp,isRound=true",
    name = "XL Custom"
)
@Composable
fun ResponsivePreview() { /* ... */ }

// Preview en mode ambient
@Preview(
    device = WearDevices.SMALL_ROUND,
    uiMode = Configuration.UI_MODE_TYPE_WATCH
)
@Composable
fun AmbientPreview() { /* ... */ }
```

**Layout Inspector sur montre:**
- Connecter via WiFi ADB
- Android Studio > Tools > Layout Inspector
- Selectionner le process Wear OS
- Fonctionne pour Compose (composition tree) + View-based

**Workflow design-to-dev recommande:**

```
1. Figma (design)
   ├── Utiliser kit M3 Wear officiel
   ├── Tester sur frame rond + carre
   ├── Exporter assets @1x @1.5x @2x
   └── Design tokens → theme Compose
2. Android Studio (dev)
   ├── @Preview multi-devices
   ├── Interactive mode (click/scroll dans IDE)
   ├── Hot reload sur emulateur
   └── Layout Inspector
3. Emulateur (test rapide)
   ├── Tester rond + carre
   ├── Simuler ambient mode via ADB
   └── Screenshot testing (Roborazzi)
4. Device reel (validation finale)
   ├── Haptique
   ├── Performance reelle
   ├── Luminosite en exterieur
   └── Test au poignet (ergonomie, glanceability)
```

**Samsung Galaxy Watch Studio:**
- Outil gratuit pour creer des watch faces (pas pour apps)
- Templates pour bezel rotatif
- Exporte directement en WFF (Watch Face Format)

**Outils complementaires:**

| Outil | Usage | Prix |
|-------|-------|------|
| **ProtoPie** | Prototypage interactif, supporte ecran rond | Payant |
| **Principle** | Animation prototyping (macOS) | Payant |
| **Android Studio** | Preview + emulateur | Gratuit |
| **Accessibility Scanner** | Test a11y automatise | Gratuit (Google) |
| **Battery Historian** | Analyse consommation batterie | Gratuit (Google) |
| **Roborazzi** | Screenshot testing | Gratuit (open-source) |

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

**Principe:** L'utilisateur commence une tache sur un device, la continue sur un autre. Seamless.

**RemoteActivityHelper (Wear OS → Phone):**

```kotlin
// Ouvrir une activite sur le telephone depuis la montre
val remoteActivityHelper = RemoteActivityHelper(context)

// Ouvrir l'app telephone avec des donnees specifiques
remoteActivityHelper.startRemoteActivity(
    Intent(Intent.ACTION_VIEW).apply {
        setData(Uri.parse("infernal://stats/today"))
        addCategory(Intent.CATEGORY_BROWSABLE)
    },
    targetNodeId // optionnel, null = premier telephone trouve
).addOnSuccessListener {
    // Confirmer a l'utilisateur: "Ouvert sur le telephone"
    showConfirmation(ConfirmationActivity.OPEN_ON_PHONE_ANIMATION)
}.addOnFailureListener { e ->
    // Telephone pas connecte ou app pas installee
    showError("Telephone non disponible")
}
```

**Phone → Watch (ouvrir une activite sur la montre):**

```kotlin
// Depuis l'app telephone, ouvrir l'app montre
val remoteActivityHelper = RemoteActivityHelper(context)
remoteActivityHelper.startRemoteActivity(
    Intent("com.infernal.QUICK_LOG").apply {
        addCategory(Intent.CATEGORY_DEFAULT)
    },
    targetNodeId = wearNodeId
)
```

**Patterns de continuation recommandes:**

| Scenario | Initie sur | Continue sur | Methode |
|----------|-----------|-------------|---------|
| Voir stats detaillees | Montre | Telephone | RemoteActivityHelper + deep link |
| Ajouter note longue | Montre | Telephone | RemoteActivityHelper + intent data |
| Configurer parametres | Telephone | Montre | DataItem sync |
| Partager progres | Montre | Telephone | RemoteActivityHelper → share sheet |
| Debug/logs | Montre | Telephone | MessageClient one-shot |

**Confirmation visuelle (CRITIQUE):**

```kotlin
// Toujours confirmer l'action cross-device a l'utilisateur
// Wear OS fournit 3 animations built-in:
startActivity(Intent(context, ConfirmationActivity::class.java).apply {
    putExtra(ConfirmationActivity.EXTRA_ANIMATION_TYPE,
        ConfirmationActivity.OPEN_ON_PHONE_ANIMATION)  // icone telephone
    putExtra(ConfirmationActivity.EXTRA_MESSAGE, "Ouvert sur le telephone")
    putExtra(ConfirmationActivity.EXTRA_ANIMATION_DURATION_MILLIS, 2000)
})
```

**watchOS Handoff (NSUserActivity):**

```swift
// Sur la montre: declarer une activite en cours
let activity = NSUserActivity(activityType: "com.infernal.viewStats")
activity.title = "Voir statistiques"
activity.userInfo = ["date": Date()]
activity.isEligibleForHandoff = true
self.userActivity = activity

// Sur l'iPhone: recevoir le handoff
func application(_ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == "com.infernal.viewStats" {
        let date = userActivity.userInfo?["date"] as? Date
        navigateToStats(date: date)
        return true
    }
    return false
}
```

**Android 17+ Handoff API (nouveau, 2026):**

```kotlin
// Nouvelle API cross-device (Android 17 beta)
// setHandoffEnabled() sur une Activity
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setHandoffEnabled(true)  // Active le handoff pour cette activity
}

override fun onHandoffActivityRequested(): HandoffActivityData {
    return HandoffActivityData.Builder()
        .setDeepLink(Uri.parse("infernal://stats/${currentDate}"))
        .setExtras(bundleOf("userId" to userId))
        .build()
}
```

**Regles UX cross-device:**

| Regle | Detail |
|-------|--------|
| **Confirmer toujours** | Animation + message "Ouvert sur telephone" |
| **Fallback gracieux** | Si telephone absent → message explicite, pas de crash |
| **Pas de donnees perdues** | Sauvegarder localement AVANT le handoff |
| **Latence acceptable** | 1-3s pour le handoff, montrer un spinner si >1s |
| **Directionnel** | Montre→telephone pour complexite, telephone→montre pour rapidite |
| **Deep link requis** | L'app cible doit supporter les deep links pour restaurer le contexte |

**Source:** [RemoteActivityHelper](https://developer.android.com/reference/androidx/wear/remote/interactions/RemoteActivityHelper), [Android 17 Handoff](https://developer.android.com/about/versions/17)

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

### Multi-Device

| Quoi | Valeur |
|------|--------|
| RemoteActivityHelper | Ouvrir app telephone depuis montre |
| ConfirmationActivity | 3 types: SUCCESS, FAILURE, OPEN_ON_PHONE |
| Handoff latence | 1-3s acceptable |
| Android 17 Handoff API | setHandoffEnabled() + onHandoffActivityRequested() |
| watchOS Handoff | NSUserActivity + isEligibleForHandoff |
| Deep link requis | Obligatoire pour restaurer contexte apres handoff |

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

*Bible UX Wearable - Mise a jour mars 2026*
*Sources: [Android Developers](https://developer.android.com/wear), [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Samsung Developer](https://developer.samsung.com/one-ui-watch), [GSMArena](https://www.gsmarena.com), [Wear OS App Quality](https://developer.android.com/docs/quality-guidelines/wear-app-quality), [Color Roles M3](https://developer.android.com/design/ui/wear/guides/styles/color/roles-tokens), [NNGroup](https://www.nngroup.com/articles/smartwatch-interactions/), [PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11054424/)*
