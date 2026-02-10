# UX Mobile Complet - Patterns Consolidés

> Consolidation des patterns UX pour applications MOBILE (iOS + Android)
> Sources: PDFs dans `ux_resources/`, Apple HIG, Material Design 3

---

## A. iOS - Apple Human Interface Guidelines

### 1. Touch Targets iOS

| Pattern | Règle | Valeur | Source |
|---------|-------|--------|--------|
| Taille minimale cibles | Tous éléments interactifs | 44×44 pt | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/accessibility#Buttons-and-controls) |
| Zone de hit | Peut dépasser les bounds visuels | ≥ 44pt hit region | Apple HIG |
| Espacement entre cibles | Éviter les erreurs de tap | ≥ 8pt recommandé | Apple HIG |
| Cibles textuelles | Liens dans le texte | Padding vertical suffisant | Apple HIG |

**Checklist:**
- [ ] Tous les boutons font au moins 44×44 pt
- [ ] Les contrôles (switches, steppers) ont une zone de hit ≥ 44pt
- [ ] Les liens textuels ont un padding vertical suffisant
- [ ] Espacement entre cibles adjacentes ≥ 8pt

---

### 2. Layout Margins iOS

| Contexte | Marge | Notes | Source |
|----------|-------|-------|--------|
| Compact width (iPhone portrait) | 16pt | Marge latérale standard | Apple HIG |
| Regular width (iPad, iPhone landscape) | 20pt | Marge latérale élargie | Apple HIG |
| ReadableContentGuide | Dynamique | Limite largeur texte lisible | Apple HIG |
| DirectionalLayoutMargins | Adaptif | Respect RTL automatique | Apple HIG |

**Code Swift:**
```swift
// Utiliser les layout margins automatiques
view.directionalLayoutMargins = NSDirectionalEdgeInsets(
    top: 0, leading: 16, bottom: 0, trailing: 16
)

// Pour le texte lisible
label.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    label.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
    label.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
])
```

---

### 3. Safe Areas iOS

| Zone | Description | Usage |
|------|-------------|-------|
| safeAreaInsets.top | Notch, Dynamic Island, status bar | Ne pas placer de contenu interactif |
| safeAreaInsets.bottom | Home indicator | Boutons au-dessus du safe area |
| safeAreaInsets.leading/trailing | Écrans edge-to-edge | Marges de contenu |
| additionalSafeAreaInsets | Ajustements custom | Tab bar custom, overlays |

**Différence Safe Areas vs Margins:**
- **Safe Areas**: Zones physiquement sûres (pas de notch, home indicator)
- **Layout Margins**: Espacement esthétique du contenu

**Checklist:**
- [ ] Contenu interactif dans les safe areas
- [ ] Background peut s'étendre hors safe areas
- [ ] Boutons d'action au-dessus du home indicator
- [ ] Test sur différents appareils (notch, Dynamic Island)

---

### 4. Typography iOS - SF Pro

| Style | Taille | Poids | Usage |
|-------|--------|-------|-------|
| Large Title | 34pt | Bold | Navigation bar (scrolled) |
| Title 1 | 28pt | Bold | Titres principaux |
| Title 2 | 22pt | Bold | Sous-sections |
| Title 3 | 20pt | Semibold | Titres de cartes |
| Headline | 17pt | Semibold | Titres de listes |
| Body | 17pt | Regular | Texte principal |
| Callout | 16pt | Regular | Texte secondaire |
| Subheadline | 15pt | Regular | Labels |
| Footnote | 13pt | Regular | Notes, timestamps |
| Caption 1 | 12pt | Regular | Légendes |
| Caption 2 | 11pt | Regular | Légendes secondaires |

**Dynamic Type:**
- Toujours utiliser les styles système pour le scaling automatique
- Tester de xSmall à AX5 (accessibilité)
- Prévoir truncation/scroll pour textes longs

**Code Swift:**
```swift
label.font = UIFont.preferredFont(forTextStyle: .body)
label.adjustsFontForContentSizeCategory = true
```

---

### 5. Tab Bar iOS

| Règle | Valeur | Justification |
|-------|--------|---------------|
| Nombre de tabs | 2-5 (max 6) | Au-delà: "More" ou navigation drawer |
| Labels | Toujours afficher | Icônes seules = ambiguës |
| Hauteur | 49pt (iPhone), 50pt (iPad) | Standard système |
| Comportement au push | Rester visible | Ne jamais cacher sur navigation push |
| Badge | Nombres ou point | Indicateur de nouveauté |

**Anti-patterns:**
- Cacher la tab bar pendant la navigation
- Plus de 5 icônes (utiliser "More" si nécessaire)
- Icônes sans labels
- Tab bar pour actions (utiliser toolbar)

**Checklist:**
- [ ] Maximum 5 tabs visibles
- [ ] Chaque tab a un label
- [ ] Tab bar reste visible pendant la navigation
- [ ] État actif clairement distinct
- [ ] Badges pour notifications/nouveautés

---

### 6. Navigation iOS

| Pattern | Usage | Comportement |
|---------|-------|--------------|
| Navigation Stack | Hiérarchie de contenu | Push/pop, back automatique |
| Swipe-back | Retour par geste | Bord gauche → droite |
| Modal (sheet) | Tâches interruptives | Dismiss par swipe down |
| Full-screen modal | Tâches immersives | Bouton close explicite requis |
| Tab Views | Vues parallèles | Max 6 tabs |

**Swipe-back navigation:**
- Ne jamais désactiver sans raison majeure
- Geste depuis le bord gauche de l'écran
- Permet un back naturel et rapide

**Checklist:**
- [ ] Back button toujours présent dans navigation stack
- [ ] Swipe-back activé (ne pas désactiver)
- [ ] Modals ont un moyen de dismiss clair
- [ ] Pas de navigation circulaire (A→B→A→B...)

---

### 7. Composants iOS - Dimensions

| Composant | Dimension | Notes |
|-----------|-----------|-------|
| Navigation Bar | 44pt (compact), 96pt (large title) | Large title au scroll initial |
| Tab Bar | 49pt (iPhone), 50pt (iPad) | Zone de hit plus grande |
| Toolbar | 44pt | Actions contextuelles |
| Search Bar | 36pt | Dans navigation bar |
| Table Row | 44pt minimum | Hauteur minimale pour touch |
| Cell standard | 44pt | Hauteur par défaut UITableViewCell |
| Button | 44×44pt minimum | Hauteur de hit region |
| Toggle/Switch | 31×51pt (visuel) | Hit region plus grande |
| Segmented Control | 32pt hauteur | Segments ≥ 44pt largeur |
| Slider | 34pt hauteur touch | Track: 4pt |

---

## B. Android - Material Design 3

### 8. Touch Targets Android

| Pattern | Règle | Valeur | Source |
|---------|-------|--------|--------|
| Taille minimale | Tous éléments interactifs | 48×48 dp | [Material Design](https://m3.material.io/foundations/accessible-design/accessibility-basics) |
| Zone de touch | Peut dépasser les bounds visuels | ≥ 48dp | Material Design |
| Espacement entre cibles | Éviter les erreurs de tap | 8dp recommandé | Material Design |
| Icône seule | Avec zone de touch élargie | Icône 24dp, touch 48dp | Material Design |

**Code Kotlin/Compose:**
```kotlin
// Modifier pour agrandir la zone de touch
Modifier
    .size(24.dp) // Taille visuelle
    .clickable { /* action */ }
    .padding(12.dp) // Zone de touch 48dp
```

**Checklist:**
- [ ] Tous les éléments interactifs font au moins 48×48 dp
- [ ] Espacement 8dp minimum entre cibles
- [ ] Icônes avec touch target élargi
- [ ] Tester avec paramètres d'accessibilité Android

---

### 9. Spacing Android (Base 8dp)

| Token | Valeur | Usage |
|-------|--------|-------|
| Spacing XS | 4dp | Micro-espacement, icône-texte |
| Spacing S | 8dp | Gap éléments liés |
| Spacing M | 16dp | Padding standard |
| Spacing L | 24dp | Séparation groupes |
| Spacing XL | 32dp | Sections |
| Spacing XXL | 48dp | Séparations majeures |

**Grid System:**
- Base: 8dp
- Colonnes: 4 (mobile), 8 (tablette), 12 (desktop)
- Gutters: 16dp (mobile), 24dp (tablette/desktop)
- Margins: 16dp (mobile), 24dp (tablette)

---

### 10. Typography Android - Roboto

| Style | Taille | Line Height | Poids | Usage |
|-------|--------|-------------|-------|-------|
| Display Large | 57sp | 64sp | Regular | Hero sections |
| Display Medium | 45sp | 52sp | Regular | Titres majeurs |
| Display Small | 36sp | 44sp | Regular | Titres importants |
| Headline Large | 32sp | 40sp | Regular | Titres de page |
| Headline Medium | 28sp | 36sp | Regular | Titres de section |
| Headline Small | 24sp | 32sp | Regular | Sous-sections |
| Title Large | 22sp | 28sp | Regular | Titres de cartes |
| Title Medium | 16sp | 24sp | Medium | Titres de listes |
| Title Small | 14sp | 20sp | Medium | Labels importants |
| Body Large | 16sp | 24sp | Regular | Texte principal |
| Body Medium | 14sp | 20sp | Regular | Texte secondaire |
| Body Small | 12sp | 16sp | Regular | Captions |
| Label Large | 14sp | 20sp | Medium | Boutons |
| Label Medium | 12sp | 16sp | Medium | Chips, tabs |
| Label Small | 11sp | 16sp | Medium | Légendes |

**Scaling (sp):**
- Utiliser `sp` pour le texte (respecte les préférences utilisateur)
- Utiliser `dp` pour les dimensions fixes

---

### 11. Navigation Bar Android (Bottom Navigation)

| Règle | Valeur | Justification |
|-------|--------|---------------|
| Nombre de destinations | 3-5 | Ni moins, ni plus |
| Labels | Toujours afficher | Obligatoire Material 3 |
| Hauteur | 80dp (avec labels) | Standard Material 3 |
| Icônes | 24dp | Outline inactive, filled active |
| Indicateur actif | Pill shape | Forme distinctive M3 |

**Anti-patterns:**
- Moins de 3 ou plus de 5 destinations
- Cacher les labels (obligatoires dans M3)
- Utiliser pour des actions (utiliser FAB/AppBar)
- Cacher pendant le scroll

**Checklist:**
- [ ] Entre 3 et 5 destinations
- [ ] Labels toujours visibles
- [ ] Indicateur actif clair (pill M3)
- [ ] Icônes outline/filled pour état
- [ ] Reste visible pendant navigation

---

### 12. Navigation Drawer Android

| Propriété | Valeur | Notes |
|-----------|--------|-------|
| Largeur | 360dp max | Ou 100% - 56dp |
| Marge droite visible | 56dp minimum | Permet de fermer en tapant |
| Header | Optionnel | Profile, branding |
| Sections | Groupées avec dividers | Max 7-8 items visibles |
| États | Inactif, actif, hover, pressed | Feedback visuel clair |

**Quand utiliser:**
- Plus de 5 destinations principales
- Navigation complexe avec sections
- Tablettes/grands écrans
- Alternative au bottom nav

---

### 13. Composants Android - Dimensions

| Composant | Dimension | Notes |
|-----------|-----------|-------|
| App Bar (Top) | 64dp | Standard, peut être plus grand |
| App Bar (Bottom) | 80dp | Avec FAB embedded |
| Bottom Navigation | 80dp | Avec labels |
| Navigation Rail | 80dp largeur | Tablettes |
| FAB (standard) | 56dp | Action primaire |
| FAB (small) | 40dp | Actions secondaires |
| FAB (large) | 96dp | Action majeure |
| Extended FAB | 56dp hauteur | Avec label |
| Button | 40dp hauteur | Filled, outlined, text |
| Icon Button | 48dp | Touch target standard |
| TextField | 56dp hauteur | Avec label |
| Chip | 32dp hauteur | Filter, input, assist |
| Card | Variable | Min padding 16dp |
| List item | 56dp (1 ligne), 72dp (2 lignes) | Minimum |
| Dialog | 280-560dp largeur | Responsive |
| Snackbar | 48dp hauteur | Avec action unique |

---

## C. Patterns Mobiles Universels

### 14. Pull-to-Refresh

| Règle | Valeur | Justification |
|-------|--------|---------------|
| Seuil de déclenchement | ~60-80dp de pull | Assez pour être intentionnel |
| Feedback immédiat | Spinner/indicateur visible | Dès le début du geste |
| État "prêt" | Indicateur change | Avant relâchement |
| Durée max | Timeout après 10-15s | Éviter spinner infini |
| Annulation | Relâcher avant seuil | Permet l'annulation |

**Implémentation:**
- iOS: `UIRefreshControl`
- Android: `SwipeRefreshLayout` / Pull-to-Refresh Compose

**Checklist:**
- [ ] Seuil clair avant déclenchement
- [ ] Feedback visuel pendant le pull
- [ ] Spinner pendant le chargement
- [ ] Timeout pour éviter l'infini
- [ ] Position scroll restaurée après refresh

---

### 15. Bottom Sheets

| Type | Usage | Comportement |
|------|-------|--------------|
| Standard | Contenu complémentaire | Coexiste avec contenu principal |
| Modal | Choix/actions requises | Scrim, bloque interaction derrière |
| Expanding | Détails progressifs | Drag pour agrandir |

**Dimensions:**
- Hauteur initiale: 25-50% écran
- Hauteur max: 90% écran (laisser voir le parent)
- Coins arrondis: 12-16dp (top)
- Handle: 4×32dp centré

**Checklist:**
- [ ] Handle visible pour drag
- [ ] Dismiss par swipe down
- [ ] Modal: scrim + tap outside = dismiss
- [ ] Ne jamais couvrir 100% de l'écran
- [ ] Contenu scrollable si nécessaire

---

### 16. FAB (Floating Action Button)

| Règle | Valeur | Justification |
|-------|--------|---------------|
| Nombre | 1 seul par écran | Action primaire unique |
| Position | Bottom-right (LTR) | Convention établie |
| Margin | 16dp des bords | Safe area respectée |
| Élévation | 6dp | Au-dessus du contenu |
| Action | Création, ajout, partage | Actions positives/constructives |

**Anti-patterns:**
- Plusieurs FAB sur un écran
- FAB pour actions destructives
- FAB qui bloque du contenu important
- Extended FAB sans label

**Variations:**
| Taille | Dimension | Usage |
|--------|-----------|-------|
| Small | 40dp | Actions secondaires |
| Standard | 56dp | Action primaire |
| Large | 96dp | Action majeure, accent fort |
| Extended | 56dp × auto | Avec texte, plus explicite |

---

### 17. Snackbar & Toast

| Propriété | Snackbar | Toast |
|-----------|----------|-------|
| Durée | 4-10s ou dismiss manuel | 2-4s auto |
| Action | 1 action max (Undo) | Aucune |
| Position | Bottom (au-dessus FAB) | Bottom ou center |
| Interruptible | Oui (swipe) | Non |
| Usage | Feedback + récupération | Info pure |

**Snackbar avec Undo:**
```
"Message archivé"  [ANNULER]
```

**Règles:**
- Maximum 1 action
- Label court (< 2 lignes)
- Au-dessus de la bottom navigation
- Ne pas bloquer le FAB

**Checklist:**
- [ ] Une seule action maximum
- [ ] Texte court et clair
- [ ] Position au-dessus de la navigation
- [ ] Durée appropriée (4-10s)
- [ ] Swipe to dismiss activé

---

### 18. Gestes Standards

| Geste | Action | Usage |
|-------|--------|-------|
| Tap | Sélection, activation | Universel |
| Double tap | Zoom, like | Contextuel |
| Long press | Menu contextuel, sélection | Actions secondaires |
| Swipe horizontal | Navigation, dismiss, actions | Listes, cartes |
| Swipe vertical | Scroll, pull-to-refresh | Contenu |
| Pinch | Zoom in/out | Images, cartes |
| Rotate | Rotation contenu | Photos, cartes (rare) |
| Edge swipe (iOS) | Back navigation | Bord gauche |

**Principes:**
- Gestes standards = attendus
- Gestes custom = découvrabilité requise
- Toujours une alternative visible (bouton)
- Ne pas surcharger (max 2-3 gestes custom)

**Checklist:**
- [ ] Gestes standards respectés
- [ ] Gestes custom avec hint initial
- [ ] Alternative visible pour chaque geste
- [ ] Pas de gestes conflictuels

---

### 19. Push Notifications

| Règle | Description |
|-------|-------------|
| Permission priming | Expliquer la valeur AVANT le prompt système |
| Catégorisation | Distinguer transactionnel / marketing / système |
| Fréquence | Batching, pas de spam |
| Deep link | Notification → écran pertinent |
| Timing | Respecter DND, fuseaux horaires |
| Opt-out | Facile et granulaire |

**Contenu:**
- Titre: court, actionnable (< 50 caractères)
- Body: contexte, valeur (< 100 caractères)
- Actions: 2 max, verbes spécifiques

**Anti-patterns:**
- Permission au lancement sans contexte
- Notifications génériques sans personnalisation
- Ignorer les préférences DND
- Pas de deep link (ouvre juste l'app)

---

### 20. États de Chargement Mobile

| État | Pattern | Durée typique |
|------|---------|---------------|
| Instantané | Aucun indicateur | < 100ms |
| Court | Spinner subtil | 100-500ms |
| Moyen | Skeleton screen | 500ms-2s |
| Long | Progress bar | > 2s |
| Très long | Progress % + estimation | > 5s |

**Skeleton screens:**
- Forme du contenu final
- Animation subtile (shimmer)
- Pas de texte placeholder lisible

**Checklist:**
- [ ] Pas de spinner pour actions < 100ms
- [ ] Skeleton pour contenu structuré
- [ ] Progress bar si durée estimable
- [ ] Timeout après 15-30s max
- [ ] Message d'erreur si échec

---

## D. Navigation Mobile - Comparatif

### 21. Tab Bar vs Bottom Navigation vs Navigation Drawer

| Critère | Tab Bar (iOS) | Bottom Nav (Android) | Nav Drawer |
|---------|---------------|---------------------|------------|
| Destinations | 2-5 | 3-5 | 5+ |
| Visibilité | Toujours visible | Toujours visible | À la demande |
| Espace | Occupe le bas | Occupe le bas | Overlay |
| Hiérarchie | Flat | Flat | Hiérarchique |
| Usage | Sections principales | Destinations top-level | Navigation complexe |

**Quand choisir:**
- **Tab Bar / Bottom Nav**: App simple, 3-5 sections équivalentes
- **Navigation Drawer**: App complexe, beaucoup de destinations, tablettes
- **Combinaison**: Drawer + Bottom Nav pour apps très riches

---

### 22. App Bars - Comparatif

| Propriété | iOS Navigation Bar | Android Top App Bar |
|-----------|-------------------|---------------------|
| Hauteur | 44pt (compact), 96pt (large) | 64dp (standard) |
| Back button | Chevron gauche | Arrow left |
| Title | Center (default) | Left (M3) |
| Actions | Droite | Droite |
| Large title | Scroll vers compact | Collapsing possible |
| Couleur | System blur | Surface ou Primary |

---

## E. Accessibilité Mobile

### 23. VoiceOver (iOS) & TalkBack (Android)

| Pattern | Implémentation iOS | Implémentation Android |
|---------|-------------------|------------------------|
| Label | accessibilityLabel | contentDescription |
| Hint | accessibilityHint | - (dans label) |
| Trait | accessibilityTraits | Sémantique Compose |
| Groupement | shouldGroupAccessibilityChildren | importantForAccessibility |
| Ordre | accessibilityElements | accessibilityTraversalAfter |
| Live region | UIAccessibility.post | android:accessibilityLiveRegion |

**Checklist:**
- [ ] Tous les éléments interactifs ont un label
- [ ] Images décoratives marquées "isAccessibilityElement = false"
- [ ] Ordre de lecture logique
- [ ] Changements dynamiques annoncés
- [ ] Test avec VoiceOver / TalkBack

---

### 24. Modes d'Accessibilité

| Mode | iOS | Android | Adaptation |
|------|-----|---------|------------|
| Taille texte | Dynamic Type | Font scale | Layout flexible |
| Contraste | Increase Contrast | High contrast | Couleurs alternatives |
| Mouvement | Reduce Motion | Remove animations | Désactiver animations |
| Transparence | Reduce Transparency | - | Fonds opaques |
| Couleurs | Smart/Classic Invert | Color inversion | Tester inversions |

**CSS/Code pour reduce motion:**
```swift
// iOS
if UIAccessibility.isReduceMotionEnabled {
    // Désactiver animations
}

// Android Compose
if (LocalDensity.current.fontScale > 1.3f) {
    // Adapter le layout
}
```

---

## F. Dimensions Récapitulatif

### 25. Touch Targets - Tableau Final

| Plateforme | Minimum | Recommandé | Source |
|------------|---------|------------|--------|
| iOS | 44×44 pt | 44×44 pt | Apple HIG |
| Android | 48×48 dp | 48×48 dp | Material Design |
| Web (WCAG) | 24×24 CSS px | 44×44 px | WCAG 2.5.8 |

### 26. Composants - Tableau Comparatif

| Composant | iOS | Android |
|-----------|-----|---------|
| Status Bar | 44-54pt (Dynamic Island) | 24dp |
| Navigation Bar / App Bar | 44pt / 96pt (large) | 64dp |
| Tab Bar / Bottom Nav | 49pt | 80dp |
| Toolbar | 44pt | 56dp |
| Search Bar | 36pt | 56dp |
| Button height | 44pt (hit region) | 40dp (48dp touch) |
| TextField | 34pt | 56dp |
| List row | 44pt min | 56-72dp |
| FAB | - (pas natif) | 56dp |
| Chip | - | 32dp |
| Card padding | 16pt | 16dp |

---

## G. Checklist Globale Mobile

### 27. Audit Rapide (10 points)

- [ ] **Touch targets**: Tous ≥ 44pt (iOS) / 48dp (Android)
- [ ] **Espacement**: 8pt/dp minimum entre cibles
- [ ] **Safe areas**: Contenu dans les zones sûres
- [ ] **Navigation**: Back/swipe-back fonctionnel
- [ ] **Tab bar**: Labels présents, max 5 items
- [ ] **Typography**: Styles système, Dynamic Type / sp
- [ ] **Feedback**: < 100ms pour les interactions
- [ ] **Loading**: Skeleton/spinner approprié
- [ ] **Accessibilité**: Labels, ordre de lecture, VoiceOver/TalkBack
- [ ] **Gestes**: Standards respectés, alternatives visibles

### 28. Tests Essentiels

| Test | Méthode |
|------|---------|
| Touch targets | Mesurer avec Accessibility Inspector / Layout Bounds |
| VoiceOver/TalkBack | Naviguer sans écran |
| Dynamic Type / Font Scale | Tester aux extrêmes |
| Orientation | Portrait ET paysage |
| Safe areas | Tester sur notch/Dynamic Island |
| Reduce Motion | Activer et vérifier |
| Dark mode | Contraste et lisibilité |
| Offline | Mode avion |

---

## H. Dark Mode

### 29. Couleurs Sémantiques

| Pattern | Règle | iOS | Android |
|---------|-------|-----|---------|
| Background | Utiliser couleurs sémantiques dynamiques | `UIColor.systemBackground`, `secondarySystemBackground`, `tertiarySystemBackground` | `MaterialTheme.colorScheme.surface`, `surfaceVariant`, `background` |
| Texte | Hiérarchie de labels | `UIColor.label`, `secondaryLabel`, `tertiaryLabel`, `quaternaryLabel` | `onSurface`, `onSurfaceVariant`, `onBackground` |
| Dividers | Couleurs translucides système | `UIColor.separator` | Tokens M3 avec alpha |
| Fills/Overlays | Couleurs adaptatives avec transparence | `UIColor.systemFill`, `secondarySystemFill`, `tertiarySystemFill` | State layers M3 |

**Contraste WCAG:**
- Texte normal: ≥ 4.5:1
- Texte large (≥18pt ou 14pt bold): ≥ 3:1
- Composants UI (bordures, icônes): ≥ 3:1

### 30. Elevation en Dark Mode

| Plateforme | Méthode | Valeurs |
|------------|---------|---------|
| iOS | Subtle shadows + materials | Éviter pure black, utiliser hiérarchie subtile |
| Android M3 | Tonal elevation + shadows | Level0=0dp, Level1=1dp, Level2=3dp, Level3=6dp, Level4=8dp, Level5=12dp |

**Code iOS (SwiftUI):**
```swift
struct ThemedCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Title")
                .foregroundStyle(Color(UIColor.label))
            Text("Secondary text")
                .foregroundStyle(Color(UIColor.secondaryLabel))
            Divider()
                .background(Color(UIColor.separator))
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
```

**Code Android (Compose):**
```kotlin
@Composable
fun ThemedCard() {
    Card(
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 3.dp)
    ) {
        Column(Modifier.padding(16.dp)) {
            Text("Title", color = MaterialTheme.colorScheme.onSurface)
            Text("Secondary", color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
    }
}
```

**Checklist Dark Mode:**
- [ ] Toutes surfaces/textes/icônes utilisent des rôles sémantiques (pas de hex hardcodé)
- [ ] Contraste vérifié: ≥4.5:1 texte, ≥3:1 texte large et composants UI
- [ ] Dividers utilisent `separator`/tokens (pas de lignes blanches pures)
- [ ] Elevation via tokens tonaux (Android) et hiérarchie subtile (iOS)
- [ ] États disabled restent lisibles (tester contraste)

**Anti-patterns:**
- Palette dark custom qui casse la sémantique système
- Backgrounds pure #000 partout
- Styles disabled avec opacité qui passe sous 3:1 de contraste
- Assets dark séparés pour toute l'UI au lieu de rôles sémantiques

---

## I. Haptics & Feedback Tactile

### 31. Types de Haptics

| Type | iOS | Android | Usage |
|------|-----|---------|-------|
| Impact | `UIImpactFeedbackGenerator` (light, medium, heavy, soft, rigid) | `HapticFeedbackConstants` | Moments physiques (snap, collision) |
| Notification | `UINotificationFeedbackGenerator` (success, warning, error) | Patterns distincts courts | Résultats d'actions |
| Selection | `UISelectionFeedbackGenerator.selectionChanged()` | Selection haptics | Changement de valeur discret (pickers) |

**Code iOS:**
```swift
final class Haptics {
    static let shared = Haptics()
    private let selection = UISelectionFeedbackGenerator()
    private let notify = UINotificationFeedbackGenerator()

    func prepare() {
        selection.prepare()
        notify.prepare()
    }

    func selectionChanged() { selection.selectionChanged() }
    func success() { notify.notificationOccurred(.success) }
    func warning() { notify.notificationOccurred(.warning) }
    func error() { notify.notificationOccurred(.error) }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred()
    }
}
```

**Code Android:**
```kotlin
fun View.hapticConfirm() {
    performHapticFeedback(HapticFeedbackConstants.CONFIRM)
}

fun View.hapticReject(context: Context) {
    performHapticFeedback(HapticFeedbackConstants.REJECT)
    // Fallback vibration si nécessaire
    val vibrator = context.getSystemService(Vibrator::class.java)
    vibrator?.vibrate(VibrationEffect.createOneShot(40L, VibrationEffect.DEFAULT_AMPLITUDE))
}
```

**Checklist Haptics:**
- [ ] Chaque haptic a une signification sémantique claire (impact vs selection vs result)
- [ ] Haptics NON utilisés pour interactions fréquentes (scroll, curseur texte)
- [ ] `prepare()` utilisé quand le timing est critique
- [ ] Toujours couplé avec un changement visuel (couleur, texte, icône, animation)
- [ ] Testé avec vibration désactivée / mode silencieux

**Anti-patterns:**
- Haptics comme "décoration"
- Multiples haptics en succession rapide
- `selectionChanged()` sur tap de bouton "Confirmer" (Apple déconseille explicitement)
- Success/warning/error pour navigation neutre

---

## J. Animations & Motion

### 32. Durées Tokenisées

| Tier | iOS | Android M3 | Usage |
|------|-----|------------|-------|
| Micro | 0.20-0.25s | Short1=50ms, Short2=100ms, Short3=150ms, Short4=200ms | Feedback micro |
| Standard | 0.30-0.35s | Medium1=250ms, Medium2=300ms, Medium3=350ms, Medium4=400ms | Transitions d'état |
| Large | 0.45-0.60s | Long1=450ms, Long2=500ms, Long3=550ms, Long4=600ms | Interruptible, grandes transitions |

**Easing M3:**
- Standard: `cubic-bezier(0.2, 0.0, 0.0, 1.0)`
- StandardDecelerate: `cubic-bezier(0, 0, 0, 1)`
- EmphasizedDecelerate: `cubic-bezier(0.05, 0.7, 0.1, 1.0)`

**Code iOS - Reduce Motion:**
```swift
struct Motion {
    static let micro: TimeInterval = 0.25
    static let standard: TimeInterval = 0.35
    static let large: TimeInterval = 0.50
}

func animateIfAllowed(_ animations: @escaping () -> Void) {
    if UIAccessibility.isReduceMotionEnabled {
        UIView.performWithoutAnimation { animations() }
    } else {
        UIView.animate(withDuration: Motion.standard, animations: animations)
    }
}
```

**Code Android (Compose):**
```kotlin
@Composable
fun AnimatedVisibilityTokenized(visible: Boolean) {
    val alpha by animateFloatAsState(
        targetValue = if (visible) 1f else 0f,
        animationSpec = tween(
            durationMillis = 300, // Medium2
            easing = CubicBezierEasing(0.2f, 0f, 0f, 1f)
        )
    )
    Box(Modifier.alpha(alpha)) { /* content */ }
}
```

**Checklist Motion:**
- [ ] App utilise une échelle de durées documentée (pas de timings arbitraires)
- [ ] Easing standardisé (pas de cubic-bezier random)
- [ ] Interactions fréquentes sans motion supplémentaire
- [ ] Reduce Motion respecté (animations non-essentielles désactivables)
- [ ] Elevation animée avec échelle dp consistante

**Anti-patterns:**
- Animations 700ms+ pour navigation basique
- Stacking multiple animations (opacity+scale+blur) sur chaque interaction
- Ignorer Reduce Motion
- Motion qui déclenche inconfort vestibulaire sans option off

---

## K. Keyboard Handling

### 33. Gestion du Clavier

| Pattern | iOS | Android |
|---------|-----|---------|
| Layout guide | `keyboardLayoutGuide` / `UIKeyboardLayoutGuide` | `WindowInsets.ime` |
| Scroll into view | UIScrollView content inset | `imePadding()` / `bringIntoView` |
| Dismiss | Tap outside / scroll / action UI | Consistent patterns |
| Hauteur | Observer keyboard frame, NE PAS hardcoder | Insets APIs, pas de "dp estimé" |

**Code iOS (SwiftUI):**
```swift
struct ChatComposer: View {
    @State private var text = ""
    var body: some View {
        VStack(spacing: 0) {
            ScrollView { /* messages */ }
            Divider()
            HStack {
                TextField("Message", text: $text)
                    .textFieldStyle(.roundedBorder)
                Button("Send") { /* send */ }
            }
            .padding(12)
            .background(Color(UIColor.secondarySystemBackground))
        }
        // iOS 15+ gère automatiquement le keyboard
    }
}
```

**Code Android (Compose):**
```kotlin
@Composable
fun ChatComposerScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.ime)
    ) {
        // Messages...
        Spacer(Modifier.weight(1f))
        // Composer...
    }
}
```

**Checklist Keyboard:**
- [ ] Pas de hauteur de clavier hardcodée - uniquement guides/insets système
- [ ] Champ focusé jamais masqué (scroll into view)
- [ ] Return key configuré selon le flux (Next/Done)
- [ ] Dismiss behavior consistant et non-surprenant

**Anti-patterns:**
- "Keyboard avoidance" avec magic numbers
- Contenu qui saute et cause du jitter
- Auto-dismiss keyboard pendant que l'utilisateur tape
- Focus piégé sans moyen de dismiss

---

## L. Forms Mobile

### 34. Autofill & Types de Clavier

| Champ | iOS textContentType | Android inputType/hint | Clavier |
|-------|---------------------|------------------------|---------|
| Email | `.emailAddress` | `KeyboardType.Email` | Email |
| Password | `.password` | `KeyboardType.Password` | Texte |
| OTP | `.oneTimeCode` | OTP hints | Number pad |
| Phone | `.telephoneNumber` | `KeyboardType.Phone` | Phone |
| Name | `.name` | Name hints | Texte |

**Code iOS (SwiftUI):**
```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var password = ""
    @State private var otp = ""

    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
            SecureField("Password", text: $password)
                .textContentType(.password)
            TextField("One-time code", text: $otp)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
        }
    }
}
```

**Code Android (Compose):**
```kotlin
@Composable
fun LoginForm() {
    var email by remember { mutableStateOf("") }
    OutlinedTextField(
        value = email,
        onValueChange = { email = it },
        label = { Text("Email") },
        keyboardOptions = KeyboardOptions(
            keyboardType = KeyboardType.Email,
            imeAction = ImeAction.Next
        )
    )
}
```

### 35. Validation & Erreurs

| Règle | Description |
|-------|-------------|
| Timing | Valider "as early as helpful, as late as necessary" - après interaction (onBlur/submit) |
| Placement | Erreurs adjacentes au champ, pas en haut de page |
| Signal | Couleur + texte (jamais couleur seule) |
| Correction | Retirer l'erreur quand corrigé |

**Labels vs Placeholders:**
| Élément | Rôle | Mobile |
|---------|------|--------|
| Label | Identifier le champ | Toujours visible (au-dessus ou floating) |
| Placeholder | Exemple/hint | <15 caractères, disparaît au focus |
| Helper Text | Format/tips | Sous le champ si nécessaire |

**Formule message d'erreur:** "What + Why + Fix"
- Exemple: "Invalid email. Please enter a valid email address."
- Ton: "We couldn't..." (pas "You failed...")
- Max: ~80 caractères

**Checklist Forms:**
- [ ] Chaque input déclare sa signification sémantique (email/password/OTP) pour autofill
- [ ] États d'erreur adjacents au champ et pas "couleur seule"
- [ ] IME/Return actions correspondent au flux (Next/Done)
- [ ] Validation pas aggressivement "rouge pendant la frappe"
- [ ] Label toujours visible, placeholder <15 chars
- [ ] Messages d'erreur: quoi + pourquoi + comment corriger

**Anti-patterns:**
- Champ rouge à chaque keystroke
- Placeholder comme seul label
- Empêcher le paste pour OTP
- Masking qui bloque sélection/curseur
- Erreurs cachées en haut de page loin du champ
- Messages d'erreur qui blâment l'utilisateur

---

## M. Biometrics & Authentication

### 36. Face ID / Touch ID / Fingerprint

| Pattern | iOS | Android |
|---------|-----|---------|
| Prompt système | `LAContext.evaluatePolicy` | `BiometricPrompt` système |
| Fallback credential | `deviceOwnerAuthentication` (biometry + passcode) | `BIOMETRIC_STRONG \| DEVICE_CREDENTIAL` |
| Stockage secrets | Keychain (`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`) | Android Keystore |
| UX rollout | Opt-in après premier login réussi | Opt-in, pas obligatoire |

**Code iOS:**
```swift
import LocalAuthentication

func authenticate(reason: String, completion: @escaping (Bool) -> Void) {
    let ctx = LAContext()
    var error: NSError?
    guard ctx.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
        completion(false)
        return
    }
    ctx.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
        DispatchQueue.main.async { completion(success) }
    }
}
```

**Code Android:**
```kotlin
val promptInfo = BiometricPrompt.PromptInfo.Builder()
    .setTitle("Sign in")
    .setSubtitle("Use biometrics or your device PIN")
    .setAllowedAuthenticators(
        BiometricManager.Authenticators.BIOMETRIC_STRONG or
        BiometricManager.Authenticators.DEVICE_CREDENTIAL
    )
    .build()

biometricPrompt.authenticate(promptInfo)
```

**Checklist Biometrics:**
- [ ] Uniquement prompts système (pas de "fake Face ID UI")
- [ ] Fallback device credential quand approprié
- [ ] Actions high-value requièrent strong auth (Android: BIOMETRIC_STRONG)
- [ ] Secrets stockés dans Keychain/Keystore, pas dans prefs

**Anti-patterns:**
- Forcer biometrics au premier lancement
- Bloquer login si biometric non enrollé
- Stocker tokens hors Keychain/Keystore
- Implémenter compteur "3 essais" au lieu de laisser le système gérer

---

## N. Permissions Strategy

### 37. Demande de Permissions

| Pattern | Règle | iOS | Android |
|---------|-------|-----|---------|
| Timing | Demander en contexte, pas au lancement | Aligner prompt avec action user | Même - request quand feature invoquée |
| Priming | Expliquer pourquoi avant prompt système | Écran custom court | "Educational UI" avant requesting |
| Rationale | Ne pas toujours montrer - utiliser signal plateforme | - | `shouldShowRequestPermissionRationale()` |
| Refus | Détecter et router vers Settings | `UIApplication.openSettingsURLString` | Guide vers Settings si "don't ask again" |

**Code iOS - Open Settings:**
```swift
func openAppSettings() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url)
}
```

**Code Android - Rationale flow:**
```kotlin
if (shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)) {
    // Show educational UI explaining why, then request
}
requestPermissions(arrayOf(Manifest.permission.CAMERA), REQ_CAMERA)
```

**Checklist Permissions:**
- [ ] Pas de prompts permission au cold start sauf si app non-fonctionnelle sans
- [ ] Chaque permission a une educational UI liée à l'intent user si risque de refus
- [ ] État de refus a un mode dégradé gracieux (read-only, saisie manuelle)
- [ ] Fallback Settings disponible quand user a bloqué les prompts

**Anti-patterns:**
- Demander plusieurs permissions d'affilée
- Demander location quand user tape "Sign up"
- Bloquer l'UI derrière un permission wall non-dismissable
- Répéter un prompt refusé sans expliquer

---

## O. Offline Mode & Sync

### 38. Détection Connectivité

| Pattern | iOS | Android |
|---------|-----|---------|
| Monitor | `NWPathMonitor` | `ConnectivityManager.registerDefaultNetworkCallback()` |
| Offline-first | Local cache/store comme source pour reads | Local data source = source of truth |
| Queue writes | Implémenter queue locale, sync later | Queued writes + WorkManager |
| HTTP cache | `URLCache` avec caching policy | HTTP cache + Room/Datastore |

**Code iOS:**
```swift
import Network

final class Connectivity {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ConnectivityMonitor")
    var onChange: ((Bool) -> Void)?

    func start() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.onChange?(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }
    func stop() { monitor.cancel() }
}
```

**Code Android:**
```kotlin
val cm = context.getSystemService(ConnectivityManager::class.java)
cm.registerDefaultNetworkCallback(object : ConnectivityManager.NetworkCallback() {
    override fun onAvailable(network: Network) { /* online */ }
    override fun onLost(network: Network) { /* offline */ }
})
```

**Checklist Offline:**
- [ ] App reste utilisable offline pour paths "read" (listes, contenu caché)
- [ ] UI indique clairement état offline/online (banner, icône, actions disabled)
- [ ] Writes: online-only (block) OU queued OU lazy-write - choisi par domaine
- [ ] Sync a backoff + retry policy - pas de boucles retry infinies
- [ ] Stratégie cache documentée (quoi caché, invalidation, TTL)

**Anti-patterns:**
- Montrer UI vide qui ressemble à "no data" quand c'est "offline"
- Écraser changements locaux après reconnexion
- Retry agressif sur 401/403
- UI qui attend le premier network call avant de montrer le cache

---

## P. Splash & Launch Screens

### 39. Launch Screen Guidelines

| Pattern | iOS | Android |
|---------|-----|---------|
| Mécanisme | Launch Storyboard (UILaunchImages deprecated) | SplashScreen API (Android 12+) |
| Purpose | Perception de vitesse + readiness | Cold/warm start, dismiss au first frame |
| Animation icon | Éviter prolongé | ≤ 1000ms recommandé, delayed start ≤ 166ms |
| Dimensions | Storyboard constraints | Branding 200×80dp, icon w/ bg 240×240dp in 160dp circle |

**Code Android:**
```kotlin
override fun onCreate(savedInstanceState: Bundle?) {
    val splashScreen = installSplashScreen()
    super.onCreate(savedInstanceState)
    setContentView(R.layout.main_activity)
}
```

**Checklist Launch:**
- [ ] Pas de "fake loading spinner" sur launch screen sauf absolument nécessaire
- [ ] Branding ne retarde pas app readiness - transition vers vraie UI rapide
- [ ] Android: icon animation ≤ 1000ms, delayed start ≤ 166ms
- [ ] iOS: storyboard launch screen, UILaunchImages deprecated supprimé

**Anti-patterns:**
- Long logo movies
- Marketing copy sur launch screen
- Bloquer first frame pendant network calls deferables
- Spinners supplémentaires sur Android 12 splash (jarring)

---

## Q. Empty States

### 40. Structure Empty States

| Élément | Description |
|---------|-------------|
| Image/Illustration | Contextuelle, pas trop grande |
| Titre | Court, explicatif |
| Message | Explique quoi et pourquoi |
| CTA | Action primaire si user peut résoudre |

**Types:**
- **First use**: Accueillant, éducatif
- **No results**: Factuel, suggestions alternatives
- **Error**: Clair, action de récupération
- **Offline**: Explicite, distingué de "no data"

**Code iOS (SwiftUI):**
```swift
struct EmptyStateView: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(Color(UIColor.secondaryLabel))
            Text(title).font(.headline)
            Text(message)
                .font(.body)
                .foregroundStyle(Color(UIColor.secondaryLabel))
                .multilineTextAlignment(.center)
            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
    }
}
```

**Templates Copy Empty States:**
| Type | Titre | Body | CTA |
|------|-------|------|-----|
| First-Use | "Welcome to [App]" | "Let's set up your first [item]." | "Get Started" |
| No-Results | "No results found" | "Try different keywords or filters." | "Clear filters" |
| Data-Absent | "No [items] yet" | "Your [items] will appear here." | "Add [item]" |
| Error/Offline | "Something went wrong" | "Check your connection and try again." | "Retry" |

**Checklist Empty States:**
- [ ] Empty states expliquent ce qui se passe et ce qui apparaîtra
- [ ] Si user peut corriger: CTA primaire; sinon: help/learn more
- [ ] Empty states offline clairement labellés (pas confondus avec "no results")
- [ ] Ton adapté au contexte (first use vs error)
- [ ] 1 CTA principal max (2 si vraiment nécessaire)

**Anti-patterns:**
- Écrans blancs
- "No data" sans explication
- CTAs qui ne font rien ou mènent à dead ends
- Humour pour états error/offline qui nécessitent clarté

---

## R. Tablets & iPad

### 41. Support Multi-Window

| Pattern | iOS | Android |
|---------|-----|---------|
| Multitasking | Split View / Slide Over, size class changes | Multi-window, adaptive layouts |
| Navigation | `NavigationSplitView` / sidebars | Navigation Rail (80dp, 3-7 destinations) |
| Pointer | Pointer interactions API | Focus states clairs |

**Code iOS (SwiftUI):**
```swift
struct RootView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Inbox", value: "inbox")
                NavigationLink("Settings", value: "settings")
            }
        } detail: {
            Text("Select an item")
        }
    }
}
```

**Code Android (Compose):**
```kotlin
@Composable
fun TabletScaffold() {
    Row {
        NavigationRail(modifier = Modifier.width(80.dp)) {
            NavigationRailItem(
                selected = true,
                onClick = { },
                icon = { Icon(Icons.Default.Home, "Home") },
                label = { Text("Home") }
            )
        }
        // Main content...
    }
}
```

**Checklist Tablets:**
- [ ] Layout s'adapte à Split View/Slide Over - pas de sidebars coupées
- [ ] Navigation large screen utilise split/sidebars (iPad) ou rails (Android)
- [ ] Navigation rail: 3-7 destinations, placement consistant, width 80dp
- [ ] Pointer support iPad: états hover/highlight clairs

**Anti-patterns:**
- UI phone simplement scaled up
- Liste single-column pour tout
- Cacher navigation derrière hamburger sur grands écrans
- Ignorer pointer/keyboard input sur iPad

---

## S. Foldables (Android)

### 42. Postures & Hinge

| Pattern | Description |
|---------|-------------|
| Postures | Flat + half-open (tabletop, book) |
| Continuity | Préserver état app lors changements posture |
| Hinge awareness | Ne pas placer contrôles critiques sous le hinge |
| Testing | Émulateur foldable + WindowManager samples |

**Code Compose (conceptuel):**
```kotlin
@Composable
fun FoldAwareScreen(windowInfoTracker: WindowInfoTracker) {
    // Observer FoldingFeature via Jetpack WindowManager
    // Switch entre one-pane vs two-pane ou tabletop layouts
}
```

**Checklist Foldables:**
- [ ] App gère changements de posture sans perdre l'état
- [ ] Layout évite la zone hinge - contenu critique pas caché
- [ ] Utilise canonical adaptive layouts (list-detail, supporting pane) quand écran s'agrandit
- [ ] Testé sur émulateur + au moins un vrai foldable si shipping à ce segment

**Anti-patterns:**
- Forcer single phone layout dans toutes les postures
- Reset navigation au unfold
- Placer FAB ou CTA primaire pile sur le hinge
- Ignorer opportunités tabletop/book où UI peut split naturellement

---

## Sources

### Apple
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [HIG Color (semantic colors)](https://developer.apple.com/design/human-interface-guidelines/color)
- [HIG Motion](https://developer.apple.com/design/human-interface-guidelines/motion)
- [HIG Launching](https://developer.apple.com/design/human-interface-guidelines/launching)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Accessibility Guidelines](https://developer.apple.com/accessibility/)
- [UIColor semantic colors](https://developer.apple.com/documentation/uikit/uicolor)
- [UIFeedbackGenerator (haptics)](https://developer.apple.com/documentation/uikit/uifeedbackgenerator)
- [LocalAuthentication](https://developer.apple.com/documentation/localauthentication)
- [Keychain](https://developer.apple.com/documentation/security/keychain_services)
- [NWPathMonitor](https://developer.apple.com/documentation/network/nwpathmonitor)
- [UIKeyboardLayoutGuide](https://developer.apple.com/documentation/uikit/uikeyboardlayoutguide)
- [NavigationSplitView](https://developer.apple.com/documentation/swiftui/navigationsplitview)
- [Pointer interactions](https://developer.apple.com/documentation/uikit/pointer-interactions)
- [iPad multitasking](https://developer.apple.com/library/archive/documentation/WindowsViews/Conceptual/AdoptingMultitaskingOniPad/)

### Google / Android
- [Material Design 3](https://m3.material.io/)
- [M3 Color roles & tokens](https://m3.material.io/styles/color/roles)
- [M3 Elevation tokens](https://m3.material.io/styles/elevation/tokens)
- [M3 Motion tokens](https://m3.material.io/styles/motion/easing-and-duration/tokens-specs)
- [M3 Text fields](https://m3.material.io/components/text-fields/overview)
- [Android Accessibility](https://developer.android.com/guide/topics/ui/accessibility)
- [Compose accessibility](https://developer.android.com/jetpack/compose/accessibility)
- [Haptic feedback](https://developer.android.com/develop/ui/views/haptics/haptic-feedback)
- [Biometric auth](https://developer.android.com/identity/sign-in/biometric-auth)
- [Keystore](https://developer.android.com/privacy-and-security/keystore)
- [Permissions requesting](https://developer.android.com/training/permissions/requesting)
- [Offline-first architecture](https://developer.android.com/topic/architecture/data-layer/offline-first)
- [ConnectivityManager](https://developer.android.com/develop/connectivity/network-ops/reading-network-state)
- [SplashScreen API](https://developer.android.com/develop/ui/views/launch/splash-screen)
- [WindowInsets (keyboard)](https://developer.android.com/develop/ui/compose/system/insets)
- [Autofill optimization](https://developer.android.com/identity/autofill/autofill-optimize)
- [Navigation Rail](https://developer.android.com/develop/ui/compose/components/navigation-rail)
- [Large screens UI](https://developer.android.com/guide/topics/large-screens/user-interface)
- [Foldables](https://developer.android.com/develop/ui/compose/layouts/adaptive/foldables)

### Standards
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- [WCAG Contrast minimum](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- [WCAG Animation from interactions](https://www.w3.org/WAI/WCAG22/Understanding/animation-from-interactions.html)
- [WAI-ARIA Mobile](https://www.w3.org/TR/mobile-accessibility-mapping/)

### Références PDFs
- `UX_Behavioral_Patterns_2024-2025_Checklist_FULL_v3.pdf` - Patterns comportementaux
- `universal_ui_rulebook_v1_audit_matrice_v3.pdf` - Règles iOS/Android
- `1. SYSTÈME D'ESPACEMENT (Spacing).pdf` - Métriques et spacing
- `Codes avant-gardistes du design UI_UX encore standards en 2026-1.pdf` - 20 patterns universels
- `Guide UX Mobile Complete 2024–2026 With Concrete iOS & Android Values.pdf` - Valeurs concrètes iOS/Android

---

*Document mis à jour le 2026-02-09*
*Complément de: WEB.md + DESIGN_TREE.md*
*Total: 46 sections, ~320 règles MOBILE*

---

## T. Ajouts 2024-2026 (Sources Premium)

### 43. iOS Spring Animation Values (Apple WWDC)

| Bounce | Effet | Usage |
|--------|-------|-------|
| ~0.15 | Subtil | Plupart des interactions quotidiennes |
| ~0.30 | Noticeable | Feedback important, confirmations |
| ~0.40+ | Caution | Peut causer motion sickness |

**SwiftUI Presets:**
```swift
// Standard subtil
.animation(.spring(bounce: 0.15))

// Snappy preset (default 0.5s)
.animation(.snappy)

// Avec extra bounce
.animation(.snappy(extraBounce: 0.1))

// Smooth (moins de rebond)
.animation(.smooth(duration: 0.35))
```

**Règle:** Commencer par bounce 0.15, augmenter uniquement si feedback important.

---

### 44. Cross-Environment Navigation (Linear Pattern)

Quand une app tourne sur Electron + Browser + Mobile:

| Principe | Description |
|----------|-------------|
| Mental model unique | Même navigation partout |
| History contract | Back fait la même chose dans tous les contextes |
| Environment-aware | Swipe-back iOS, bouton Android, Ctrl+[ Electron |

**Anti-pattern:** Back qui fait quelque chose de différent selon le contexte (browser vs app shell).

```swift
// iOS: JAMAIS désactiver swipe-back sauf raison majeure
navigationController?.interactivePopGestureRecognizer?.isEnabled = true
```

---

### 45. Onboarding Contextuel (NNG 2023)

| Type | Problème | Alternative |
|------|----------|-------------|
| Tutorials | Interrompent, oubliés vite | Contextual help |
| Coach marks en cascade | Cognitive overload | Just-in-time hints |
| Tours obligatoires | Frustration | Empty states avec CTA |

**Pattern Notion (2026):**
- Confetti attaché aux automations (milestone significatif)
- Pas confetti pour usage générique

**Règle:**
> "Teach by letting users do real work, with guardrails."

```swift
// Empty state avec single best next action
struct EmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 48))
            Text("Pas encore de documents")
                .font(.headline)
            Text("Créez votre premier document pour commencer")
                .foregroundStyle(.secondary)
            Button("Créer un document") { /* action */ }
                .buttonStyle(.borderedProminent)
        }
    }
}
```

---

### 46. Command Palette Mobile

Sur mobile, le command palette devient:

| Mobile | Desktop |
|--------|---------|
| Search bar persistent | Cmd+K anywhere |
| Quick actions dans search | Palette overlay |
| Suggestions contextuelles | Full command list |

```swift
// iOS: Spotlight-style search
struct MobileCommandBar: View {
    @State private var query = ""

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Rechercher ou taper une commande...", text: $query)
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Quick actions
            if query.isEmpty {
                QuickActionsGrid()
            } else {
                SearchResults(query: query)
            }
        }
    }
}
```

---

## U. Quick Reference Mobile

### Valeurs Critiques

| Élément | iOS | Android | Source |
|---------|-----|---------|--------|
| Touch target | 44pt | 48dp | HIG / M3 |
| Navigation bar | 44pt / 96pt (large) | 64dp | System |
| Tab bar / Bottom nav | 49pt | 80dp | System |
| FAB | - | 56dp (40/96 variants) | M3 |
| Spacing base | 4pt | 4dp (8dp grid) | Universal |
| Animation micro | 0.20-0.25s | 50-200ms | HIG / M3 |
| Animation standard | 0.30-0.35s | 250-400ms | HIG / M3 |
| Spring bounce subtle | 0.15 | - | Apple |
| Spring bounce noticeable | 0.30 | - | Apple |

### Checklist Ultime Mobile

**Touch & Gesture:**
- [ ] Toutes cibles >= 44pt (iOS) / 48dp (Android)
- [ ] Swipe-back activé (iOS)
- [ ] Edge gestures non bloqués
- [ ] Gestes custom ont alternative visible

**Navigation:**
- [ ] Tab bar / Bottom nav <= 5 items
- [ ] Labels TOUJOURS présents (pas icons seuls)
- [ ] Back préserve état (scroll, filtres)
- [ ] Deep links fonctionnels

**Feedback:**
- [ ] Haptics à usage sémantique (pas décoration)
- [ ] Spring bounce <= 0.30 pour la plupart
- [ ] Reduce motion respecté
- [ ] Toast/Snackbar au-dessus de la navigation

**Accessibilité:**
- [ ] VoiceOver / TalkBack testés
- [ ] Dynamic Type / Font scale supportés
- [ ] Safe areas respectées
- [ ] Labels accessibles sur tous éléments interactifs

**Forms:**
- [ ] Keyboard type approprié (email, tel, etc.)
- [ ] textContentType / autofill hints
- [ ] Clavier ne masque pas le champ focusé
- [ ] Validation pas rouge pendant la frappe

---

## V. Internationalisation & Localisation Mobile

### 47. Expansion de Texte

| Langue | Expansion vs Anglais | Action |
|--------|---------------------|--------|
| Allemand (DE) | +30-35% | Containers flexibles, auto-layout |
| Russe (RU) | +30-35% | Containers flexibles, auto-layout |
| Français (FR) | +20% | Containers flexibles |
| Espagnol (ES) | +20% | Containers flexibles |
| Chinois (ZH) | -30% caractères | Peut nécessiter plus de hauteur |
| Japonais (JA) | -30% caractères | Peut nécessiter plus de hauteur |

**iOS:** Utiliser Auto Layout avec contraintes flexibles
**Android:** Utiliser ConstraintLayout + wrap_content

---

### 48. Support RTL (Arabe, Hébreu)

| Aspect | iOS | Android |
|--------|-----|---------|
| Direction | `semanticContentAttribute = .forceRightToLeft` | `android:supportsRtl="true"` + `layoutDirection` |
| Auto-flip | UIKit: `DirectionalLayoutMargins` | `start/end` au lieu de `left/right` |
| Icônes | Flip avec `imageFlipped(for:)` | `autoMirrored="true"` |

**Éléments à flipper:**
- Flèches de navigation
- Progress bars
- Sliders
- Chevrons

**Éléments à NE PAS flipper:**
- Logos
- Graphs/charts
- Checkmarks
- Icônes non-directionnelles (phone, search)

**Code iOS:**
```swift
// Flip layout pour RTL
view.semanticContentAttribute = .forceRightToLeft

// Icône miroir automatique
let config = UIImage.SymbolConfiguration(paletteColors: [.label])
let image = UIImage(systemName: "arrow.right")?
    .withConfiguration(config)
    .imageFlipped(for: .rightToLeft)
```

**Code Android:**
```xml
<!-- AndroidManifest.xml -->
<application android:supportsRtl="true">

<!-- Layout - utiliser start/end -->
<TextView
    android:layout_marginStart="16dp"
    android:layout_marginEnd="16dp" />

<!-- Icône avec auto-mirror -->
<ImageView
    android:src="@drawable/ic_arrow"
    android:autoMirrored="true" />
```

---

### 49. Formats Localisés Mobile

| Donnée | iOS | Android |
|--------|-----|---------|
| Dates | `DateFormatter` avec `locale` | `DateFormat.getDateInstance(locale)` |
| Nombres | `NumberFormatter` avec `locale` | `NumberFormat.getInstance(locale)` |
| Monnaie | `NumberFormatter.Style.currency` | `NumberFormat.getCurrencyInstance(locale)` |

**Code iOS:**
```swift
let formatter = DateFormatter()
formatter.locale = Locale.current // Respecte locale système
formatter.dateStyle = .medium
formatter.timeStyle = .short
let dateString = formatter.string(from: Date())
```

**Checklist i18n Mobile:**
- [ ] Auto Layout / ConstraintLayout flexibles pour expansion texte
- [ ] RTL supporté (`supportsRtl`, `semanticContentAttribute`)
- [ ] Icônes directionnelles flippées (flèches, progress)
- [ ] Icônes non-directionnelles NON flippées (logos, charts)
- [ ] Dates/nombres formatés avec locale système
- [ ] String resources externalisées (pas de hardcode)
- [ ] Tests avec pseudo-locale pour détecter problèmes

---

## W. Gamification Mobile

### 50. Streaks & Progress (Mobile)

| Aspect | iOS | Android | Source |
|--------|-----|---------|--------|
| Widget streak | Home Screen widget | Home Screen widget | [Duolingo](https://blog.duolingo.com/widget-feature/) |
| Retention boost | 7 jours = +3.6× rétention | Idem | [UX Magazine](https://uxmag.com/articles/the-psychology-of-hot-streak-game-design-how-to-keep-players-coming-back-every-day-without-shame) |
| Notification timing | Morning optimal (8-10h) | Personnalisable via ML | Best practice |
| Streak Freeze | In-app purchase ou earned | Idem | Duolingo, Snapchat |

**Visual Patterns:**
- Flamme animée (Duolingo)
- Calendrier de contributions (GitHub)
- Anneau de progression (Apple Fitness)
- Compteur numérique + icône

**Code iOS - Widget:**
```swift
struct StreakWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "streak", provider: StreakProvider()) { entry in
            StreakWidgetView(streak: entry.streakCount)
        }
        .configurationDisplayName("Daily Streak")
        .supportedFamilies([.systemSmall])
    }
}
```

**Checklist:**
- [ ] Widget home screen pour rappel visuel
- [ ] Streak Freeze disponible (earned ou acheté)
- [ ] Grace period 24-48h pour incidents
- [ ] Animation de célébration aux milestones (7, 30, 100, 365 jours)
- [ ] Notification de rappel non-agressive

---

### 51. Points, Badges & Leaderboards Mobile

| Élément | iOS | Android | Source |
|---------|-----|---------|--------|
| Badge unlock | HIG: Haptic feedback (success) | Material: confetti animation | Platform conventions |
| Leaderboard | Game Center optionnel | Play Games optionnel | Native integration |
| Points display | Tab bar badge ou card | Bottom nav badge ou card | App-specific |

**Leaderboard Views:**
1. **Friends** (default si social) - Plus motivant
2. **Weekly** - Fresh starts réguliers
3. **Global** - Pour compétiteurs hardcore
4. **Local** - Nearby users (fitness apps)

**Best Practices:**
- Montrer position de l'utilisateur + 2 au-dessus/en-dessous
- Reset hebdo/mensuel pour égaliser les chances
- Éviter pour données sensibles (finance, santé privée)

**Checklist:**
- [ ] Haptic feedback sur badge unlock (iOS: `.success`)
- [ ] Animation de célébration (scale + particles)
- [ ] Leaderboard friends-first si données sociales
- [ ] Position utilisateur toujours visible

---

### 52. Engagement Loops Mobile

| Pattern | Mobile-specific | Source |
|---------|-----------------|--------|
| Push notifications | Trigger principal de retour | [Hooked](https://www.nirandfar.com/hooked/) |
| App badges | Unread count sur icône | iOS/Android native |
| Widgets | Glanceable progress | iOS 14+, Android 12+ |
| Daily rewards | Login bonus calendrier | Gaming pattern |

**Hook Model (Nir Eyal) adapté mobile:**
1. **Trigger**: Push notification, Widget, App badge
2. **Action**: Ouvrir app, tap simple (< 2 taps to value)
3. **Variable Reward**: Points aléatoires, surprises, social validation
4. **Investment**: Personnalisation, streak, données

**Code Android - App Badge:**
```kotlin
// Update app icon badge (launcher specific)
ShortcutBadger.applyCount(context, unreadCount)

// Or via NotificationCompat
val notification = NotificationCompat.Builder(context, channelId)
    .setNumber(badgeCount)
    .build()
```

**Checklist:**
- [ ] Push notifications avec deep linking vers action
- [ ] App badge count pour unread/pending
- [ ] Widget pour progress at-a-glance
- [ ] < 2 taps pour atteindre la valeur principale

---

## X. Settings Mobile

### 53. Architecture Settings Mobile

| Aspect | iOS | Android | Source |
|--------|-----|---------|--------|
| Pattern | List avec disclosure indicators | Preference fragments | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/settings) / [Android](https://developer.android.com/design/ui/mobile/guides/patterns/settings) |
| Grouping | Sections avec headers | Categories avec dividers | Platform standard |
| Search | iOS 15+ search bar intégré | Toolbar search | Available natively |
| Hierarchy | Max 2-3 niveaux | Max 2-3 niveaux | [Toptal](https://www.toptal.com/designers/ux/settings-ux) |

**iOS Pattern:**
```swift
struct SettingsView: View {
    var body: some View {
        List {
            Section("Account") {
                NavigationLink("Profile", destination: ProfileView())
                NavigationLink("Privacy", destination: PrivacyView())
            }
            Section("Notifications") {
                Toggle("Push Notifications", isOn: $pushEnabled)
                Toggle("Email Digest", isOn: $emailEnabled)
            }
        }
        .searchable(text: $searchText) // iOS 15+
    }
}
```

**Android Pattern:**
```kotlin
// PreferenceScreen in XML
<PreferenceScreen>
    <PreferenceCategory app:title="Account">
        <Preference app:key="profile" app:title="Profile"/>
        <SwitchPreferenceCompat app:key="notifications" app:title="Push Notifications"/>
    </PreferenceCategory>
</PreferenceScreen>
```

**Checklist:**
- [ ] Utiliser composants natifs (List iOS, PreferenceFragment Android)
- [ ] Grouping logique avec headers/categories
- [ ] Max 2-3 niveaux de profondeur
- [ ] Search si > 15 settings

---

### 54. Toggle & Switch Mobile

| Aspect | iOS | Android | Source |
|--------|-----|---------|--------|
| Visual size | 51×31pt | 52×32dp | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/toggles) / [Material](https://m3.material.io/components/switch) |
| Touch target | 44×44pt minimum | 48×48dp minimum | WCAG |
| Effet | Immédiat (pas de Save) | Immédiat | [NN/g](https://www.nngroup.com/articles/toggle-switch-guidelines/) |
| Label position | Gauche du toggle | Gauche du switch | Convention |

**Règle d'or:** Toggle/Switch = effet immédiat, pas de bouton "Save"

**Code iOS:**
```swift
Toggle("Enable Dark Mode", isOn: $isDarkMode)
    .toggleStyle(SwitchToggleStyle())
    .onChange(of: isDarkMode) { newValue in
        // Effet immédiat
        applyTheme(isDark: newValue)
    }
```

**Code Android:**
```kotlin
SwitchPreferenceCompat(context).apply {
    key = "dark_mode"
    title = "Enable Dark Mode"
    setOnPreferenceChangeListener { _, newValue ->
        applyTheme(isDark = newValue as Boolean)
        true
    }
}
```

**Checklist:**
- [ ] Touch target ≥ 44pt (iOS) / 48dp (Android)
- [ ] Label clair à gauche
- [ ] Effet immédiat (pas de bouton Save)
- [ ] État visuellement évident (ON vert, OFF gris)

---

### 55. Destructive Settings Mobile

| Pattern | iOS | Android | Source |
|---------|-----|---------|--------|
| Confirmation | Alert avec bouton destructif rouge | AlertDialog avec bouton accent | Platform standard |
| Position | Bas de la liste settings | Bas de la liste | Convention |
| Text | Rouge pour actions destructives | Couleur error (rouge) | Platform convention |

**Account Deletion (GDPR/App Store):**
- DOIT être accessible (pas caché)
- PEUT avoir friction raisonnable (confirmation, typing)
- DOIT offrir export de données avant
- Apple App Store: REQUIS depuis 2022

**Code iOS:**
```swift
Button("Delete Account", role: .destructive) {
    showDeleteConfirmation = true
}
.alert("Delete Account?", isPresented: $showDeleteConfirmation) {
    Button("Cancel", role: .cancel) { }
    Button("Delete", role: .destructive) {
        deleteAccount()
    }
} message: {
    Text("This action cannot be undone. All your data will be permanently deleted.")
}
```

**Checklist:**
- [ ] Couleur destructive (rouge)
- [ ] Confirmation avec explication claire
- [ ] Export de données proposé avant deletion
- [ ] Accessible (pas de dark patterns)

---

## Y. Search Mobile

### 56. Search Input Mobile

| Aspect | iOS | Android | Source |
|--------|-----|---------|--------|
| Height | 36pt (in nav bar) | 56dp (toolbar) | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/search-fields) / [Material](https://m3.material.io/components/search) |
| Position | Navigation bar ou pull-down | Toolbar ou expandable | Platform standard |
| Cancel button | "Cancel" text à droite | X icon | Convention |
| Keyboard | Auto-show on focus | Auto-show on focus | UX standard |

**iOS Patterns:**
1. **Navigation bar search** - Persistent, always visible
2. **Pull-down search** - Scroll down pour révéler
3. **Search tab** - Tab dédié à la recherche

**Code iOS:**
```swift
NavigationStack {
    List(filteredItems) { item in
        ItemRow(item: item)
    }
    .searchable(text: $searchText, prompt: "Search items...")
    .searchSuggestions {
        ForEach(suggestions, id: \.self) { suggestion in
            Text(suggestion).searchCompletion(suggestion)
        }
    }
}
```

**Code Android:**
```kotlin
SearchBar(
    query = searchQuery,
    onQueryChange = { searchQuery = it },
    onSearch = { performSearch(searchQuery) },
    active = isSearchActive,
    onActiveChange = { isSearchActive = it },
    placeholder = { Text("Search...") }
) {
    // Search suggestions
    suggestions.forEach { suggestion ->
        ListItem(
            headlineContent = { Text(suggestion) },
            modifier = Modifier.clickable { searchQuery = suggestion }
        )
    }
}
```

**Checklist:**
- [ ] Keyboard apparaît automatiquement au focus
- [ ] Clear button (X) quand texte présent
- [ ] Cancel/dismiss accessible
- [ ] Voice search si pertinent (microphone icon)

---

### 57. Autocomplete Mobile

| Aspect | iOS | Android | Source |
|--------|-----|---------|--------|
| Max suggestions | 6-8 items (écran limité) | 6-8 items | [Baymard](https://baymard.com/blog/autocomplete-design) |
| Recent searches | En premier, avec X pour supprimer | Idem | Standard |
| Keyboard nav | Non applicable (touch) | Non applicable | Mobile-specific |
| Debounce | 200-300ms | 200-300ms | Performance |

**Suggestion Types:**
1. **Recent searches** - Historique utilisateur
2. **Popular/Trending** - Recherches populaires
3. **Personalized** - Basées sur comportement
4. **Content preview** - Résultats inline (images, prix)

**Checklist:**
- [ ] Max 6-8 suggestions visibles
- [ ] Recent searches avec option de suppression
- [ ] Highlight du texte matché (bold)
- [ ] Tap = recherche, pas navigation directe
- [ ] Clear all history option

---

### 58. No Results Mobile

| Pattern | Description | Source |
|---------|-------------|--------|
| Message friendly | "No results for 'xyz'" | Standard |
| Illustration | Image/icon sympathique | Design polish |
| Suggestions | "Try different keywords" | UX best practice |
| Popular items | Montrer alternatives | E-commerce pattern |

**Éléments d'un bon empty search state:**
1. Message clair (pas de blâme utilisateur)
2. Illustration optionnelle
3. Suggestions concrètes
4. Alternatives (popular, related)
5. CTA pour clear/retry

**Checklist:**
- [ ] Message friendly sans blâmer
- [ ] Suggestions alternatives
- [ ] Easy clear pour réessayer
- [ ] Ne pas montrer une page vide

---

## Z. Animations Mobile

### 59. Timing iOS vs Android

| Type | iOS | Android | Source |
|------|-----|---------|--------|
| Micro | 200-250ms | 150-200ms | [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/motion) / [Material Motion](https://m3.material.io/styles/motion) |
| Standard | 300-350ms | 250-350ms | Platform guidelines |
| Complex | 400-500ms | 300-400ms | Page transitions |
| Spring default | duration: 0.5, bounce: 0.15-0.30 | N/A (use Interpolator) | Apple WWDC |

**iOS Spring Values:**
- Subtle: bounce 0.15
- Noticeable: bounce 0.30
- Playful: bounce 0.40+ (avec prudence)

**Android Easing:**
- `FastOutSlowInInterpolator` - Standard
- `LinearOutSlowInInterpolator` - Entering
- `FastOutLinearInInterpolator` - Exiting

---

### 60. Micro-interactions Mobile

| Interaction | iOS | Android | Source |
|-------------|-----|---------|--------|
| Button press | scale(0.96) + haptic | Ripple effect | Platform convention |
| Pull-to-refresh | Native UIRefreshControl | SwipeRefreshLayout | System component |
| Swipe action | Reveal avec spring | Reveal avec material motion | [Mobbin](https://mobbin.com/) |
| Like/heart | Scale pop + haptic | Scale + ripple | Social apps |

**Haptic Feedback Types (iOS):**
```swift
// Success (badge unlock, completion)
UIImpactFeedbackGenerator(style: .success).impactOccurred()

// Light (subtle tap)
UIImpactFeedbackGenerator(style: .light).impactOccurred()

// Medium (toggle, selection)
UIImpactFeedbackGenerator(style: .medium).impactOccurred()

// Heavy (important action)
UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
```

**Checklist:**
- [ ] Haptic feedback sémantique (pas décoratif)
- [ ] Button press feedback < 100ms
- [ ] Animations interruptibles (pas bloquantes)
- [ ] Reduced motion respecté (`UIAccessibility.isReduceMotionEnabled`)

---

### 61. Reduced Motion Mobile

| Platform | Detection | Alternative |
|----------|-----------|-------------|
| iOS | `UIAccessibility.isReduceMotionEnabled` | Crossfade au lieu de slide |
| Android | `Settings.Global.ANIMATOR_DURATION_SCALE` | Réduire durée à 0 |

**Code iOS:**
```swift
if UIAccessibility.isReduceMotionEnabled {
    // Crossfade instead of slide
    withAnimation(.easeInOut(duration: 0.2)) {
        showContent = true
    }
} else {
    // Normal spring animation
    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
        showContent = true
    }
}
```

**Code Android:**
```kotlin
val animatorScale = Settings.Global.getFloat(
    contentResolver,
    Settings.Global.ANIMATOR_DURATION_SCALE,
    1.0f
)
if (animatorScale == 0f) {
    // Skip animations
    view.alpha = 1f
} else {
    view.animate().alpha(1f).setDuration((300 * animatorScale).toLong())
}
```

**Checklist:**
- [ ] Vérifier `isReduceMotionEnabled` (iOS) / `ANIMATOR_DURATION_SCALE` (Android)
- [ ] Crossfade au lieu de motion complexe
- [ ] Animations essentielles: simplifier, pas supprimer
- [ ] Tester avec settings système activés
