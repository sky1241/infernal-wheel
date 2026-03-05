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

| Taille montre | Largeur ecran (pt) |
|--------------|-------------------|
| 41mm | 162 pt |
| 45mm | 176 pt |
| 49mm Ultra | 187 pt |

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

**Source:** [Android Developers - Tiles](https://developer.android.com/training/wearables/tiles)

### 10b. Smart Stack (watchOS 11)

| Aspect | Detail |
|--------|--------|
| Acces | Tourner Digital Crown depuis watch face |
| Live Activities | Apparaissent automatiquement depuis l'app iOS |
| Persistance | Smart Stack reste visible quand le poignet est baisse (watchOS 11) |
| Custom view | Vue personnalisee pour Apple Watch (optionnelle, sinon Dynamic Island compact) |
| Double Tap | `.handGestureShortcut(.primaryAction)` sur bouton/toggle dans widget |
| Widgets | WidgetKit, memes widgets que complications mais en plus grand |

**Pour notre app (watchOS):**
- Widget Smart Stack: timer "depuis derniere cigarette" + compteur jour
- Live Activity: pendant une session de monitoring active
- Double Tap action: "+1 cigarette" (action primaire)

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
- Exception: health monitoring = cas d'usage valide

**Source:** [Android Developers - Power](https://developer.android.com/training/wearables/apps/power)

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

**Source:** [Android Developers - Data Layer](https://developer.android.com/training/wearables/data/overview)

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

**Eviter "battery drain notification":**
- Optimiser sampling (batching, event-triggered)
- Budget total < 10-15% batterie/jour pour toutes apps tierces
- Foreground notification: formuler positivement ("Monitoring actif") pas negativement

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

---

*Bible UX Wearable - Mise a jour mars 2026*
*Sources: [Android Developers](https://developer.android.com/wear), [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos), [Samsung Developer](https://developer.samsung.com/one-ui-watch-tizen), [GSMArena](https://www.gsmarena.com)*
