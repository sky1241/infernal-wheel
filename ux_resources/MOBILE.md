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


---

## AA. Deep Linking & Universal Links

### 62. iOS Universal Links

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Fichier requis | `apple-app-site-association` (AASA) a `/.well-known/` | [Apple Docs](https://developer.apple.com/documentation/xcode/supporting-associated-domains) |
| Format AASA | JSON, pas de `.json` extension, `Content-Type: application/json` | Apple Docs |
| Taille max AASA | 128 KB non compresse | Apple Docs |
| Delai CDN Apple | Apple cache le fichier AASA via CDN, refresh ~24h | Apple Docs |
| HTTPS obligatoire | Le domaine doit servir en HTTPS avec certificat valide | Apple Docs |
| Entitlement | `com.apple.developer.associated-domains` dans le profil de provisioning | Apple Docs |
| Wildcard support | `"paths": ["*"]` ou `"paths": ["/product/*"]` | Apple Docs |
| Exclusion | Prefixe `"NOT"` dans paths: `["NOT /help/*", "*"]` | Apple Docs |

**Fichier AASA (apple-app-site-association):**
```json
{
  "applinks": {
    "details": [
      {
        "appIDs": ["TEAMID.com.example.app"],
        "components": [
          { "/": "/product/*", "comment": "Product deep links" },
          { "/": "/user/*", "comment": "User profiles" },
          { "/": "/invite/*", "comment": "Invitation links" }
        ]
      }
    ]
  }
}
```

**Code Swift (handling):**
```swift
// SceneDelegate
func scene(_ scene: UIScene,
           continue userActivity: NSUserActivity) {
    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL else { return }
    DeepLinkRouter.shared.handle(url)
}

// SwiftUI
WindowGroup {
    ContentView()
        .onOpenURL { url in
            DeepLinkRouter.shared.handle(url)
        }
}
```

---

### 63. Android App Links

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Fichier requis | `assetlinks.json` a `/.well-known/` | [Android Docs](https://developer.android.com/training/app-links) |
| Verification | Auto-verify via Digital Asset Links | Android Docs |
| Intent filter | `android:autoVerify="true"` sur l'activity | Android Docs |
| Scheme | `https` obligatoire pour App Links (vs Deep Links `myapp://`) | Android Docs |
| Fallback | Si app non installee, ouvre dans le navigateur | Android Docs |
| Multi-domaine | Un `assetlinks.json` par domaine | Android Docs |

**assetlinks.json:**
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.app",
    "sha256_cert_fingerprints": [
      "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
    ]
  }
}]
```

**AndroidManifest.xml:**
```xml
<activity android:name=".MainActivity"
          android:exported="true">
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https"
              android:host="example.com"
              android:pathPrefix="/product" />
    </intent-filter>
</activity>
```

**Code Kotlin (handling):**
```kotlin
// Activity
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    intent?.data?.let { uri ->
        DeepLinkRouter.handle(uri)
    }
}

// Navigation Compose
val navController = rememberNavController()
navController.handleDeepLink(intent)

// NavGraph deep link
composable(
    route = "product/{id}",
    deepLinks = listOf(
        navDeepLink { uriPattern = "https://example.com/product/{id}" }
    )
) { backStackEntry ->
    ProductScreen(backStackEntry.arguments?.getString("id"))
}
```

---

### 64. Deferred Deep Links

| Pattern | Description | Solution |
|---------|-------------|----------|
| First Install | User clique un lien, n'a pas l'app, installe, puis doit atterrir sur le bon ecran | Deferred deep link via attribution SDK |
| Clipboard check | App lit le clipboard au premier lancement pour URL | Deprecated iOS 16+ (paste permission) |
| Attribution SDK | Branch, Adjust, AppsFlyer stockent le lien cote serveur | SDK recupere le contexte apres install |
| Firebase Dynamic Links | Deprecated septembre 2025 | Migrer vers Branch ou solution custom |

**Alternatives post-Firebase Dynamic Links (2025+):**

| Solution | Plateforme | Pricing | Notes |
|----------|-----------|---------|-------|
| Branch.io | iOS + Android | Free tier + paid | Leader marche, UI dashboard |
| Adjust | iOS + Android | Paid | Fort en attribution |
| AppsFlyer | iOS + Android | Paid | OneLink pour deep links |
| Custom server | iOS + Android | Self-hosted | AASA + assetlinks + redirect logic |

**Pattern custom (sans SDK tiers):**
```
1. User clique https://app.example.com/invite/abc123
2. Serveur detecte User-Agent mobile
3. Si app installee -> Universal Link / App Link ouvre l'app
4. Si app non installee -> redirect vers Store avec parametre
5. Store URL: https://apps.apple.com/app/id123?referrer=invite_abc123
6. Au premier lancement, app query le serveur avec device fingerprint
7. Serveur matche et retourne le contexte du deep link
```

---

### 65. Deep Link Routing Architecture

| Pattern | Description | Usage |
|---------|-------------|-------|
| Centralized Router | Un seul point d'entree pour tous les deep links | Recommande |
| Path-based | `/product/123` -> ProductScreen(id=123) | Standard |
| Query-based | `/search?q=term&filter=active` | Filtres, recherche |
| Fragment-based | `/settings#notifications` | Scroll to section |

**Router Pattern (Swift):**
```swift
enum DeepLink {
    case product(id: String)
    case profile(username: String)
    case settings(section: String?)
    case invite(code: String)

    init?(url: URL) {
        let path = url.pathComponents
        switch path.dropFirst().first {
        case "product":
            self = .product(id: path[safe: 2] ?? "")
        case "user":
            self = .profile(username: path[safe: 2] ?? "")
        case "settings":
            self = .settings(section: url.fragment)
        case "invite":
            self = .invite(code: path[safe: 2] ?? "")
        default:
            return nil
        }
    }
}
```

**Router Pattern (Kotlin):**
```kotlin
sealed class DeepLink {
    data class Product(val id: String) : DeepLink()
    data class Profile(val username: String) : DeepLink()
    data class Settings(val section: String?) : DeepLink()
    data class Invite(val code: String) : DeepLink()

    companion object {
        fun parse(uri: Uri): DeepLink? {
            val segments = uri.pathSegments
            return when (segments.firstOrNull()) {
                "product" -> Product(segments.getOrNull(1) ?: "")
                "user" -> Profile(segments.getOrNull(1) ?: "")
                "settings" -> Settings(uri.fragment)
                "invite" -> Invite(segments.getOrNull(1) ?: "")
                else -> null
            }
        }
    }
}
```

**Deep Link Testing:**

| Outil | Plateforme | Commande / Usage |
|-------|-----------|-----------------|
| `xcrun simctl openurl` | iOS Simulator | `xcrun simctl openurl booted "https://example.com/product/123"` |
| `adb shell am start` | Android | `adb shell am start -a android.intent.action.VIEW -d "https://example.com/product/123"` |
| AASA Validator | iOS | `https://app-site-association.cdn-apple.com/a/v1/example.com` |
| DAL Validator | Android | `https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://example.com` |

**Checklist Deep Linking:**
- [ ] AASA file servi en HTTPS avec `Content-Type: application/json`
- [ ] assetlinks.json accessible a `/.well-known/assetlinks.json`
- [ ] App Links `autoVerify="true"` dans AndroidManifest
- [ ] Associated Domains entitlement configure dans Xcode
- [ ] Router centralise gere tous les deep links
- [ ] Fallback gracieux si route inconnue (home screen, pas crash)
- [ ] Deep links testes sur simulateur et device physique
- [ ] Deferred deep links fonctionnent apres first install
- [ ] Analytics tracke l'attribution des deep links
- [ ] Deep links fonctionnent en logged-out (auth gate puis redirect)

---

## AB. Widgets & Glanceable UI

### 66. iOS WidgetKit

| Type | Taille | Dimensions (pt) | Contenu | Source |
|------|--------|-----------------|---------|--------|
| Small | `systemSmall` | 169x169 (iPhone 15 Pro) | Single tap target, info rapide | [Apple WidgetKit](https://developer.apple.com/documentation/widgetkit) |
| Medium | `systemMedium` | 360x169 | Multi-info ou liste courte | Apple WidgetKit |
| Large | `systemLarge` | 360x376 | Liste ou dashboard | Apple WidgetKit |
| Extra Large | `systemExtraLarge` | iPad only, 715x376 | Dashboard complet | Apple WidgetKit |
| Lock Screen Circular | `accessoryCircular` | 76x76 (approx) | Gauge, icone | iOS 16+ |
| Lock Screen Rectangular | `accessoryRectangular` | 172x76 (approx) | 2-3 lignes info | iOS 16+ |
| Lock Screen Inline | `accessoryInline` | Pleine largeur, 1 ligne | Texte + SF Symbol | iOS 16+ |
| StandBy | Memes familles | Agrandies en StandBy mode | Horloge, compteurs | iOS 17+ |

**Principes de Design Widget:**

| Principe | Regle | Raison |
|----------|-------|--------|
| Glanceable | Info lisible en < 3 secondes | Users ne "utilisent" pas les widgets |
| Tap target unique (small) | Le widget entier est un seul lien | Pas de multi-bouton sur small |
| Contenu frais | Timeline provider avec refresh intelligent | Pas de refresh trop frequent |
| Pas d'interactivite lourde | iOS 17+ permet boutons/toggles limites | Avant iOS 17: tap = ouvre l'app |
| Placeholder | Skeleton/redacted pendant le chargement | Jamais d'etat vide au premier affichage |

**Code SwiftUI Widget:**
```swift
struct CigaretteWidget: Widget {
    let kind: String = "CigaretteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: CigaretteTimelineProvider()
        ) { entry in
            CigaretteWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Cigarette Tracker")
        .description("Today's cigarette count")
        .supportedFamilies([
            .systemSmall, .systemMedium,
            .accessoryCircular, .accessoryRectangular
        ])
    }
}

struct CigaretteTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> CigaretteEntry {
        CigaretteEntry(date: .now, count: 0, limit: 10)
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (CigaretteEntry) -> Void) {
        completion(CigaretteEntry(date: .now, count: 3, limit: 10))
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<CigaretteEntry>) -> Void) {
        let entry = CigaretteEntry(
            date: .now, count: fetchCount(), limit: fetchLimit()
        )
        let nextUpdate = Calendar.current.date(
            byAdding: .minute, value: 15, to: .now
        )!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
```

**Interactive Widgets (iOS 17+):**
```swift
struct CigaretteWidgetView: View {
    var entry: CigaretteEntry

    var body: some View {
        VStack {
            Text("\(entry.count)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
            Text("cigarettes today")
                .font(.caption)
            // iOS 17+ interactive button
            Button(intent: LogCigaretteIntent()) {
                Label("Log One", systemImage: "plus.circle.fill")
            }
            .tint(.orange)
        }
    }
}
```

---

### 67. Android Glance (Jetpack Glance API)

| Parametre | Valeur | Source |
|-----------|--------|--------|
| API minimum | Android 12 (API 31) pour Glance, AppWidget depuis API 21 | [Android Glance](https://developer.android.com/jetpack/compose/glance) |
| Taille min widget | 40dp x 40dp | Android Docs |
| Resize | `minWidth`, `minHeight`, `targetCellWidth`, `targetCellHeight` | Android Docs |
| Refresh min | 30 minutes pour `updatePeriodMillis` | Android Docs |
| Rounded corners | 16dp obligatoire Android 12+ | M3 Widgets |
| Background | `@android:color/system_accent1_100` (dynamic color) | M3 Widgets |

**Code Compose Glance:**
```kotlin
class CigaretteWidget : GlanceAppWidget() {
    override suspend fun provideGlance(
        context: Context, id: GlanceId
    ) {
        provideContent {
            CigaretteWidgetContent()
        }
    }
}

@Composable
fun CigaretteWidgetContent() {
    val count = currentState<Int>(key = "count") ?: 0
    Column(
        modifier = GlanceModifier
            .fillMaxSize()
            .background(GlanceTheme.colors.widgetBackground)
            .cornerRadius(16.dp)
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "$count",
            style = TextStyle(
                fontSize = 48.sp,
                fontWeight = FontWeight.Bold,
                color = GlanceTheme.colors.onSurface
            )
        )
        Text(text = "cigarettes today", style = TextStyle(fontSize = 14.sp))
        Spacer(modifier = GlanceModifier.height(8.dp))
        Button(
            text = "Log One",
            onClick = actionRunCallback<LogCigaretteAction>()
        )
    }
}

class CigaretteWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget = CigaretteWidget()
}
```

**AndroidManifest.xml (widget):**
```xml
<receiver android:name=".CigaretteWidgetReceiver"
          android:exported="true">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/cigarette_widget_info" />
</receiver>
```

---

### 68. Widget Design Best Practices

| Regle | iOS | Android | Raison |
|-------|-----|---------|--------|
| Contenu min | 1 metrique cle (small) | 1 metrique cle (1x1) | Glanceability |
| Refresh | TimelineProvider, 15min+ | updatePeriodMillis 30min+ | Batterie |
| Dark mode | Automatic via semantic colors | Dynamic color / GlanceTheme | Coherence systeme |
| Tap action | `widgetURL()` ou `Link` | `actionStartActivity()` | Deep link vers ecran pertinent |
| Configuration | WidgetConfigurationIntent | Configuration Activity | Personnalisation |
| Preview | `previewContext` dans WidgetKit | `previewLayout` dans widget_info | Galerie de widgets |
| Placeholder | `.redacted(reason: .placeholder)` | Skeleton layout | Premier affichage |
| Rounded corners | Automatic (containerBackground) | 16dp corners obligatoire (12+) | Coherence systeme |

**Timeline Refresh Strategies:**

| Strategie | Quand | Implementation |
|-----------|-------|---------------|
| Time-based | Donnees changent a intervalles previsibles | `.after(nextDate)` / `updatePeriodMillis` |
| Event-driven | Donnees changent sur action user | `WidgetCenter.shared.reloadTimelines(ofKind:)` / `GlanceAppWidgetManager.updateAll()` |
| Push-driven | Donnees serveur changent | Background push + widget reload |
| Attrition | Timeline avec plusieurs entrees futures | Pre-calculer les prochaines heures |

**Checklist Widgets:**
- [ ] Widget lisible en < 3 secondes (glanceable)
- [ ] Placeholder/skeleton au premier affichage
- [ ] Small widget = 1 seul tap target
- [ ] Tap ouvre l'app sur l'ecran pertinent (pas Home)
- [ ] Refresh strategy adaptee (pas trop frequent)
- [ ] Dark mode supporte
- [ ] Dynamic Type respecte (iOS)
- [ ] Dynamic colors utilisees (Android 12+)
- [ ] Widget preview dans la galerie de selection
- [ ] Lock screen widgets testes (iOS 16+)
- [ ] Contenu localise

---

## AC. Live Activities & Dynamic Island

### 69. iOS Live Activities

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Framework | ActivityKit | [Apple Live Activities](https://developer.apple.com/documentation/activitykit) |
| Disponibilite | iOS 16.1+ | Apple Docs |
| Duree max | 8 heures (puis passe en etat "ended") | Apple Docs |
| Duree etat ended | Reste affiche 4h supplementaires apres fin | Apple Docs |
| Frequence update | Push: budget ~12-24/heure; local: illimite | Apple Docs |
| Taille payload push | 4 KB max | Apple Docs |
| Info.plist | `NSSupportsLiveActivities = YES` | Apple Docs |

**Code Swift (demarrer une Live Activity):**
```swift
struct CigaretteTrackingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var count: Int
        var limit: Int
        var lastCigaretteTime: Date?
    }
    var sessionDate: Date
}

func startTracking() throws {
    let attributes = CigaretteTrackingAttributes(sessionDate: .now)
    let state = CigaretteTrackingAttributes.ContentState(
        count: 0, limit: 10, lastCigaretteTime: nil
    )
    let content = ActivityContent(state: state, staleDate: nil)
    let activity = try Activity.request(
        attributes: attributes,
        content: content,
        pushType: .token
    )
    // Get push token for server updates
    for await token in activity.pushTokenUpdates {
        let tokenString = token.map { String(format: "%02x", $0) }.joined()
        sendTokenToServer(tokenString)
    }
}

func updateCount(activity: Activity<CigaretteTrackingAttributes>,
                 newCount: Int) {
    let state = CigaretteTrackingAttributes.ContentState(
        count: newCount, limit: 10, lastCigaretteTime: .now
    )
    Task {
        await activity.update(ActivityContent(state: state, staleDate: nil))
    }
}

func endTracking(activity: Activity<CigaretteTrackingAttributes>,
                 finalCount: Int) {
    let finalState = CigaretteTrackingAttributes.ContentState(
        count: finalCount, limit: 10, lastCigaretteTime: .now
    )
    let finalContent = ActivityContent(state: finalState, staleDate: nil)
    Task {
        await activity.end(finalContent, dismissalPolicy: .after(.now + 3600))
    }
}
```

---

### 70. Dynamic Island UX

| Presentation | Taille | Usage | Interaction |
|-------------|--------|-------|-------------|
| Compact Leading | ~36x36 pt | Icone ou petite info | Tap ouvre l'app |
| Compact Trailing | ~36x36 pt | Valeur secondaire | Tap ouvre l'app |
| Minimal | ~36x36 pt (pilule droite) | Quand autre Live Activity occupe la leading | Tap ouvre l'app |
| Expanded | ~360x160 pt (max) | Long press sur Dynamic Island | Affichage detaille |
| Lock Screen | Banner style | Toujours visible sur lock screen | Tap ouvre l'app |

**Code SwiftUI (Dynamic Island views):**
```swift
struct CigaretteTrackingLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CigaretteTrackingAttributes.self) { context in
            // Lock Screen banner
            HStack {
                Image(systemName: "lungs.fill")
                    .foregroundColor(.orange)
                VStack(alignment: .leading) {
                    Text("\(context.state.count)/\(context.state.limit) cigarettes")
                        .font(.headline)
                    if let last = context.state.lastCigaretteTime {
                        Text("Last: \(last, style: .relative) ago")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text("\(context.state.count)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(
                        context.state.count > context.state.limit ? .red : .green
                    )
            }
            .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "lungs.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(context.state.count)")
                        .font(.title).fontWeight(.bold)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.count)/\(context.state.limit)")
                        .font(.caption)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(
                        value: Double(context.state.count),
                        total: Double(context.state.limit)
                    )
                    .tint(context.state.count > context.state.limit ? .red : .green)
                }
            } compactLeading: {
                Image(systemName: "lungs.fill")
                    .foregroundColor(.orange)
            } compactTrailing: {
                Text("\(context.state.count)")
                    .fontWeight(.bold)
            } minimal: {
                Image(systemName: "lungs.fill")
                    .foregroundColor(.orange)
            }
        }
    }
}
```

---

### 71. Android Equivalent: Ongoing Notifications

| Parametre | Valeur | Source |
|-----------|--------|--------|
| Type | Ongoing Notification (`setOngoing(true)`) | [Android Notification](https://developer.android.com/develop/ui/views/notifications) |
| Custom layout | `RemoteViews` ou `DecoratedCustomViewStyle` | Android Docs |
| Progress | `setProgress(max, progress, indeterminate)` | Android Docs |
| Foreground service | Requis pour notifications persistantes | Android Docs |
| Actions max | 3 actions par notification | Android Docs |
| Big style | `BigTextStyle`, `BigPictureStyle`, `InboxStyle` | Android Docs |
| Priority | `PRIORITY_LOW` pour tracker (pas intrusif) | Android Docs |

**Code Kotlin (ongoing notification):**
```kotlin
fun createTrackingNotification(count: Int, limit: Int): Notification {
    return NotificationCompat.Builder(context, TRACKING_CHANNEL_ID)
        .setSmallIcon(R.drawable.ic_lungs)
        .setContentTitle("Cigarette Tracker")
        .setContentText("$count / $limit cigarettes today")
        .setProgress(limit, count, false)
        .setOngoing(true)
        .setOnlyAlertOnce(true)
        .setCategory(NotificationCompat.CATEGORY_PROGRESS)
        .setPriority(NotificationCompat.PRIORITY_LOW)
        .setColor(if (count > limit) Color.RED else Color.GREEN)
        .addAction(
            R.drawable.ic_add, "Log One",
            PendingIntent.getBroadcast(
                context, 0,
                Intent(context, LogCigaretteReceiver::class.java),
                PendingIntent.FLAG_IMMUTABLE
            )
        )
        .setContentIntent(
            PendingIntent.getActivity(
                context, 0,
                Intent(context, MainActivity::class.java),
                PendingIntent.FLAG_IMMUTABLE
            )
        )
        .build()
}

// Update notification
fun updateTrackingNotification(count: Int, limit: Int) {
    val notification = createTrackingNotification(count, limit)
    NotificationManagerCompat.from(context).notify(TRACKING_NOTIFICATION_ID, notification)
}
```

**Comparaison Live Activity vs Ongoing Notification:**

| Aspect | iOS Live Activity | Android Ongoing Notification |
|--------|-------------------|------------------------------|
| Emplacement | Dynamic Island + Lock Screen + StandBy | Notification shade + status bar icon |
| Interactivite | Tap + long press expanded view | Tap + jusqu'a 3 action buttons |
| Update | Push token ou local | NotificationManager.notify() |
| Duree | 8h max + 4h ended | Illimitee (foreground service) |
| Visibilite | Tres haute (Dynamic Island) | Moyenne (notification shade) |
| Battery | Optimise par le systeme | Foreground service consomme plus |
| Custom UI | SwiftUI views | RemoteViews (limite) |

**Use Cases pour cessation tabac:**

| Use Case | iOS Implementation | Android Implementation |
|----------|-------------------|----------------------|
| Compteur journalier | Live Activity avec count en temps reel | Ongoing notification avec progress bar |
| Timer sans fumer | Live Activity avec timer elapsed | Chronometer notification |
| Challenge en cours | Live Activity avec progression | Big text notification |
| Craving countdown | Live Activity 5-min countdown | Countdown notification |

**Checklist Live Activities / Ongoing Notifications:**
- [ ] Live Activity affiche l'info essentielle en compact (1-2 valeurs)
- [ ] Expanded view fournit plus de detail sans surcharger
- [ ] Lock screen banner lisible en un coup d'oeil
- [ ] Updates pas trop frequentes (budget push respecte)
- [ ] Fin propre de l'activite (`activity.end()` avec dismissal policy)
- [ ] Android: ongoing notification avec `PRIORITY_LOW` (pas intrusif)
- [ ] Android: foreground service notification conforme aux guidelines
- [ ] Tap sur notification/live activity ouvre l'ecran pertinent
- [ ] StandBy mode (iOS 17+) affichage teste

---

## AD. App Clips & Instant Apps

### 72. iOS App Clips

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Taille max | 15 MB (apres thinning) | [Apple App Clips](https://developer.apple.com/documentation/app_clips) |
| Invocations | NFC tag, QR code, App Clip Code, Safari Smart Banner, Maps, Messages | Apple Docs |
| Duree cache | App Clip reste ~30 jours si pas reutilise | Apple Docs |
| Permissions | Location (8h), camera, Bluetooth (pendant usage) | Apple Docs |
| Pas de permission | Push notifications (sauf ephemeres 8h), tracking, HealthKit | Apple Docs |
| Sign In with Apple | Disponible et recommande | Apple Docs |
| Apple Pay | Disponible et recommande | Apple Docs |
| App Clip Card | Titre (30 char), sous-titre (56 char), image (3000x2000 px) | Apple Docs |
| Ephemeral notification | 8h apres invocation, pas besoin de permission | Apple Docs |

**App Clip Card Design:**

| Element | Spec | Notes |
|---------|------|-------|
| Image | 3000x2000 px, 3:2 ratio | Represente l'action, pas le branding |
| Titre | Max 30 caracteres | Verbe d'action: "Order Coffee" |
| Sous-titre | Max 56 caracteres | Contexte: "At Main Street Cafe" |
| CTA | "Open" (defaut) ou custom | "Order", "Pay", "Check In" |
| Header image | High quality, pas de texte dans l'image | Doit fonctionner sans texte |

**Code Swift (App Clip handling):**
```swift
// Detect App Clip invocation URL
func scene(_ scene: UIScene,
           continue userActivity: NSUserActivity) {
    guard let url = userActivity.webpageURL,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else { return }

    // Route based on invocation URL
    if components.path.contains("/checkin") {
        showCheckInFlow()
    } else if components.path.contains("/challenge") {
        showChallengePreview()
    }
}

// Prompt full app download
import StoreKit
func suggestFullApp() {
    guard let scene = UIApplication.shared.connectedScenes.first
            as? UIWindowScene else { return }
    let config = SKOverlay.AppClipConfiguration(position: .bottom)
    let overlay = SKOverlay(configuration: config)
    overlay.present(in: scene)
}

// Transfer data to full app via App Group
func saveDataForFullApp() {
    let defaults = UserDefaults(suiteName: "group.com.app.shared")
    defaults?.set(cigaretteCount, forKey: "clipCigaretteCount")
    defaults?.set(Date(), forKey: "clipSessionDate")
}
```

**App Clip Code (physical invocations):**

| Type | Description | Range |
|------|-------------|-------|
| NFC-only | Tap to invoke | Contact distance |
| Visual-only | Camera scan (like QR) | ~1 meter |
| NFC + Visual | Both methods | Best flexibility |
| Custom colors | Apple-approved color combinations | Brand matching |
| Size min | 27mm diameter | Visibility |

---

### 73. Android Instant Apps

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Nom actuel | Google Play Instant | [Android Instant](https://developer.android.com/topic/google-play-instant) |
| Taille max | 15 MB par feature module | Android Docs |
| Invocations | URL (navigateur, search, ads, NFC) | Android Docs |
| Permissions | Limitees (pas de background services, pas d'ID device unique) | Android Docs |
| API min | Android 5.0 (API 21), Android 6.0+ recommande | Android Docs |
| Dynamic Feature | `dist:instant="true"` dans le manifest du module | Android Docs |
| Google Sign-In | Disponible et recommande | Android Docs |
| Google Pay | Disponible | Android Docs |

**Code Kotlin (instant app detection + install prompt):**
```kotlin
// Check if running as instant app
val isInstantApp = InstantApps.isInstantApp(context)

// Prompt full install
if (isInstantApp) {
    InstantApps.showInstallPrompt(
        activity,
        intent,        // Post-install intent
        REQUEST_CODE,
        REFERRER       // Install referrer
    )
}

// Transfer data on install
if (isInstantApp) {
    // Use Cookie API for small data
    val cookieManager = packageManager.instantAppCookieMaxBytes
    val data = "count=5&date=2026-03-06".toByteArray()
    packageManager.instantAppCookie = data
}
```

**build.gradle (instant module):**
```groovy
plugins {
    id 'com.android.dynamic-feature'
}

android {
    namespace 'com.app.instant'
    // ...
}

// In base module's AndroidManifest.xml:
// <dist:module dist:instant="true" />
```

**Comparaison App Clip vs Instant App:**

| Aspect | iOS App Clip | Android Instant App |
|--------|-------------|---------------------|
| Taille max | 15 MB | 15 MB par module |
| Invocation | NFC, QR, Safari, Maps, Messages, App Clip Code | URL, Search, Ads, NFC |
| Auth | Sign In with Apple, Apple Pay | Google Sign-In, Google Pay |
| Persistence | 30 jours cache | Session-based |
| Transition | SKOverlay pour full app | InstantApps.showInstallPrompt() |
| Data migration | Shared App Group container | Cookie API (max ~16 KB) |
| Push notifications | Ephemeres 8h seulement | Non disponible |
| Background work | Limite | Non disponible |

**Checklist App Clips / Instant Apps:**
- [ ] Taille < 15 MB apres optimisation
- [ ] Focus sur UNE tache principale (pas l'app complete)
- [ ] Invocation -> action en < 3 taps
- [ ] Auth simplifiee (Sign In with Apple / Google Sign-In)
- [ ] Paiement via Apple Pay / Google Pay si applicable
- [ ] Transition vers full app claire et non-intrusive
- [ ] Data migree automatiquement vers full app (App Group / Cookie API)
- [ ] App Clip Card avec image/titre/CTA pertinents
- [ ] Teste sur tous les vecteurs d'invocation
- [ ] UX identique a l'experience full app pour la tache ciblee

---

## AE. In-App Purchases & Subscriptions

### 74. StoreKit 2 (iOS)

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Framework | StoreKit 2 (async/await, natif Swift) | [Apple StoreKit 2](https://developer.apple.com/documentation/storekit) |
| Disponibilite | iOS 15+ | Apple Docs |
| Types de produits | Consumable, Non-Consumable, Auto-Renewable, Non-Renewing | Apple Docs |
| Commission Apple | 30% (15% Small Business Program < $1M/an) | Apple Docs |
| Sandbox testing | StoreKit Configuration file dans Xcode | Apple Docs |
| Server notifications | App Store Server Notifications V2 | Apple Docs |
| Grace period | 6 ou 16 jours configurable dans App Store Connect | Apple Docs |
| Billing retry | Automatique, jusqu'a 60 jours | Apple Docs |
| Offer codes | Codes promotionnels one-time use | Apple Docs |
| Family sharing | Configurable par produit | Apple Docs |

**Code Swift (StoreKit 2 complet):**
```swift
// Fetch products
func fetchProducts() async throws -> [Product] {
    return try await Product.products(for: [
        "com.app.premium.monthly",
        "com.app.premium.yearly",
        "com.app.tip.small"
    ])
}

// Purchase
func purchase(_ product: Product) async throws -> Transaction? {
    let result = try await product.purchase()
    switch result {
    case .success(let verification):
        let transaction = try checkVerified(verification)
        await transaction.finish()
        return transaction
    case .userCancelled:
        return nil
    case .pending:
        // Ask user to approve (parental controls, etc.)
        return nil
    @unknown default:
        return nil
    }
}

// Verify transaction
func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
    switch result {
    case .unverified:
        throw StoreError.failedVerification
    case .verified(let safe):
        return safe
    }
}

// Listen for transactions (app launch - critical)
func listenForTransactions() -> Task<Void, Error> {
    Task.detached {
        for await result in Transaction.updates {
            guard let transaction = try? self.checkVerified(result)
            else { continue }
            await self.updateSubscriptionStatus(transaction)
            await transaction.finish()
        }
    }
}

// Check current entitlements
func checkSubscriptionStatus() async -> Bool {
    for await result in Transaction.currentEntitlements {
        if let transaction = try? checkVerified(result) {
            if transaction.productType == .autoRenewable &&
               transaction.revocationDate == nil {
                return true
            }
        }
    }
    return false
}

// Restore purchases
func restorePurchases() async {
    try? await AppStore.sync()
}
```

---

### 75. Google Play Billing Library

| Parametre | Valeur / Regle | Source |
|-----------|---------------|--------|
| Library | `com.android.billingclient:billing:7.+` | [Google Play Billing](https://developer.android.com/google/play/billing) |
| Commission Google | 15% premiere annee, 30% ensuite (15% < $1M/an) | Google Play |
| Types | INAPP (one-time), SUBS (subscription) | Google Play |
| Testing | License testers dans Google Play Console | Google Play |
| Grace period | Configurable dans Play Console | Google Play |
| Account hold | Jusqu'a 30 jours | Google Play |
| Acknowledge | Obligation d'acknowledge dans 3 jours sinon remboursement auto | Google Play |
| Billing retry | Automatique pendant grace period | Google Play |

**Code Kotlin (Play Billing complet):**
```kotlin
class BillingManager(private val context: Context) :
    PurchasesUpdatedListener, BillingClientStateListener {

    private val billingClient = BillingClient.newBuilder(context)
        .setListener(this)
        .enablePendingPurchases()
        .build()

    private val _products = MutableStateFlow<List<ProductDetails>>(emptyList())
    val products: StateFlow<List<ProductDetails>> = _products.asStateFlow()

    fun startConnection() {
        billingClient.startConnection(this)
    }

    override fun onBillingSetupFinished(result: BillingResult) {
        if (result.responseCode == BillingClient.BillingResponseCode.OK) {
            queryProducts()
        }
    }

    override fun onBillingServiceDisconnected() {
        // Retry with exponential backoff
        startConnection()
    }

    private fun queryProducts() {
        val subsParams = QueryProductDetailsParams.newBuilder()
            .setProductList(listOf(
                QueryProductDetailsParams.Product.newBuilder()
                    .setProductId("premium_monthly")
                    .setProductType(BillingClient.ProductType.SUBS)
                    .build(),
                QueryProductDetailsParams.Product.newBuilder()
                    .setProductId("premium_yearly")
                    .setProductType(BillingClient.ProductType.SUBS)
                    .build()
            ))
            .build()

        billingClient.queryProductDetailsAsync(subsParams) { result, details ->
            if (result.responseCode == BillingClient.BillingResponseCode.OK) {
                _products.value = details
            }
        }
    }

    fun launchPurchaseFlow(activity: Activity, productDetails: ProductDetails) {
        val offerToken = productDetails.subscriptionOfferDetails
            ?.firstOrNull()?.offerToken ?: return
        val params = BillingFlowParams.newBuilder()
            .setProductDetailsParamsList(listOf(
                BillingFlowParams.ProductDetailsParams.newBuilder()
                    .setProductDetails(productDetails)
                    .setOfferToken(offerToken)
                    .build()
            ))
            .build()
        billingClient.launchBillingFlow(activity, params)
    }

    override fun onPurchasesUpdated(
        billingResult: BillingResult,
        purchases: MutableList<Purchase>?
    ) {
        when (billingResult.responseCode) {
            BillingClient.BillingResponseCode.OK -> {
                purchases?.forEach { handlePurchase(it) }
            }
            BillingClient.BillingResponseCode.USER_CANCELED -> { /* no-op */ }
            else -> { /* log error */ }
        }
    }

    private fun handlePurchase(purchase: Purchase) {
        if (purchase.purchaseState == Purchase.PurchaseState.PURCHASED) {
            if (!purchase.isAcknowledged) {
                val params = AcknowledgePurchaseParams.newBuilder()
                    .setPurchaseToken(purchase.purchaseToken)
                    .build()
                billingClient.acknowledgePurchase(params) { /* verify */ }
            }
            // Grant entitlement
            unlockPremium()
        }
    }

    // Restore: query existing purchases
    fun restorePurchases() {
        val params = QueryPurchasesParams.newBuilder()
            .setProductType(BillingClient.ProductType.SUBS)
            .build()
        billingClient.queryPurchasesAsync(params) { result, purchases ->
            purchases.forEach { handlePurchase(it) }
        }
    }
}
```

---

### 76. Paywall Design

| Pattern | Description | Conversion typique | Usage |
|---------|-------------|-------------------|-------|
| Soft Paywall | Certaines features gratuites, premium debloque plus | 2-5% conversion | Apps freemium, productivite |
| Hard Paywall | App inutilisable sans abonnement | 5-15% trial start | News, streaming, fitness |
| Metered Paywall | N actions gratuites puis paywall | 3-8% conversion | News (X articles/mois) |
| Feature Gate | Feature specifique locked | Variable | Feature premium individuelle |
| Time-limited | Full access pendant X jours puis paywall | 10-20% trial start | Apps premium |
| Contextual | Paywall affiche quand user tente feature premium | Higher intent | Feature discovery |

**Paywall UI Best Practices:**

| Element | Regle | Raison |
|---------|-------|--------|
| Value proposition | 3 bullet points max avec icones | Clarte, scannabilite |
| Plan recommande | Visuellement mis en avant (border, badge "Best Value") | Orientation choix |
| Prix | Afficher prix/mois meme pour plan annuel | Comparabilite |
| Economie | "Save 40%" sur plan annuel | Incitation |
| CTA | Un seul CTA primaire, un secondaire discret | Focus |
| Free trial | Duree claire "7-day free trial, then $X.XX/month" | Transparence |
| Cancel | "Cancel anytime" visible sous le CTA | Confiance |
| Restore | Bouton "Restore Purchases" obligatoire (App Store guideline) | Compliance |
| Close | Bouton X ou "Not now" visible, >= 44pt | Pas de dark pattern |
| Legal | Links vers Terms et Privacy visibles | Compliance |
| Social proof | "Join 50,000+ users" ou rating | Confiance |
| Before/After | Montrer la transformation | Valeur concrte |

**Code SwiftUI (Paywall):**
```swift
struct PaywallView: View {
    @State private var selectedPlan: Plan = .yearly
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero
                    Text("Unlock Premium")
                        .font(.largeTitle.bold())

                    // Value props
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Detailed Analytics",
                            subtitle: "Track patterns and triggers"
                        )
                        FeatureRow(
                            icon: "bell.badge",
                            title: "Smart Alerts",
                            subtitle: "Craving predictions and support"
                        )
                        FeatureRow(
                            icon: "person.2",
                            title: "Community",
                            subtitle: "Join challenges and share progress"
                        )
                    }

                    // Plan selection
                    VStack(spacing: 12) {
                        PlanCard(
                            plan: .yearly,
                            price: "$29.99/year",
                            perMonth: "$2.49/mo",
                            badge: "Best Value - Save 58%",
                            isSelected: selectedPlan == .yearly
                        )
                        .onTapGesture { selectedPlan = .yearly }

                        PlanCard(
                            plan: .monthly,
                            price: "$5.99/month",
                            perMonth: "$5.99/mo",
                            badge: nil,
                            isSelected: selectedPlan == .monthly
                        )
                        .onTapGesture { selectedPlan = .monthly }
                    }

                    // CTA
                    Button {
                        startPurchase(selectedPlan)
                    } label: {
                        Text("Start 7-Day Free Trial")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    // Trust signals
                    Text("Cancel anytime. No commitment.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    // Restore + Legal
                    HStack {
                        Button("Restore Purchases") {
                            restorePurchases()
                        }
                        Spacer()
                        Link("Terms", destination: URL(string: "https://example.com/terms")!)
                        Link("Privacy", destination: URL(string: "https://example.com/privacy")!)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Not Now") { dismiss() }
                }
            }
        }
    }
}
```

---

### 77. Subscription Management UX

| Flow | iOS | Android |
|------|-----|---------|
| Voir abonnement | `UIApplication.openURL("https://apps.apple.com/account/subscriptions")` | `"https://play.google.com/store/account/subscriptions"` |
| Changer plan | Upgrade/downgrade via StoreKit 2 | `setOfferToken()` avec nouveau plan |
| Annuler | Redirect vers Settings iOS (system-managed) | Redirect vers Play Store (system-managed) |
| Grace period | App reste premium, banner discrete informant du probleme | App reste premium, notification |
| Billing retry | Transparent pour l'user | Notification "payment issue" |
| Expiration | Downgrade gracieux, pas de suppression de donnees | Idem |
| Refund | Geree par Apple (pas de controle app) | Geree par Google Play |

**Cancellation Flow (Retention):**

| Etape | Pattern | Objectif |
|-------|---------|----------|
| 1. Tap "Manage Subscription" | Deep link vers system settings | Transparence |
| 2. Pre-cancel survey (in-app) | Survey optionnel 3-5 choix | Analytics + opportunity |
| 3. Win-back offer | Discount ou pause subscription | Retention |
| 4. Confirm via system | Redirect vers iOS Settings / Play Store | Compliance (pas de cancel in-app) |

**Cancellation Survey Options (cessation tabac):**

| Option | Follow-up |
|--------|-----------|
| "Too expensive" | Offer annual plan or discount |
| "Not using it enough" | Suggest enabling reminders |
| "Didn't help me quit" | Offer 1-on-1 coaching (if available) |
| "Found another app" | Ask which one (competitive intel) |
| "Other reason" | Free text field |

**Introductory Offers:**

| Type | iOS | Android | UX Pattern |
|------|-----|---------|------------|
| Free Trial | 3, 7, 14, 30 jours | 3, 7, 14, 30 jours | "Try free for 7 days" |
| Pay Up Front | Prix reduit premiere periode | Introductory price | "First month $0.99" |
| Pay As You Go | Prix reduit sur N periodes | Free trial + reduced price | "$1.99/mo for 3 months" |
| Promotional | Offre pour users existants (offer codes) | Developer-determined | "Come back: 50% off" |
| Win-back | iOS 18+: automatic win-back offers | Play Console win-back | Re-engage lapsed subscribers |

**Grace Period Handling UI:**

| Etat | Banner | Acces | Action |
|------|--------|-------|--------|
| Active | Aucun | Premium complet | Rien |
| Grace Period | "Payment issue - update your payment method" | Premium complet | Link vers settings paiement |
| Billing Retry | "Subscription renewal failed" | Premium complet | Link vers settings paiement |
| Expired | "Your subscription has ended" | Free tier | CTA re-subscribe |
| Revoked (refund) | "Subscription cancelled" | Free tier | CTA re-subscribe |

**Checklist IAP & Subscriptions:**
- [ ] Paywall affiche clairement la valeur (3 bullet points max)
- [ ] Prix affiche par mois pour tous les plans
- [ ] Plan recommande visuellement distinct ("Best Value")
- [ ] Free trial duration claire et visible avec prix post-trial
- [ ] "Cancel anytime" visible sous le CTA
- [ ] Bouton "Restore Purchases" present et fonctionnel
- [ ] Bouton fermer/dismiss visible >= 44pt (pas de dark pattern)
- [ ] Terms of Service et Privacy Policy linkes
- [ ] Grace period geree (banner discret, pas de downgrade brutal)
- [ ] `Transaction.finish()` (iOS) / `acknowledgePurchase()` (Android) appele
- [ ] Server-side receipt validation implementee
- [ ] Downgrade gracieux preserve les donnees utilisateur
- [ ] Transaction listener actif au lancement de l'app
- [ ] Win-back offers configurees pour lapsed subscribers

---

## AF. App Store Optimization (ASO)

### 78. App Icon Guidelines

| Parametre | iOS | Android | Source |
|-----------|-----|---------|--------|
| Taille master | 1024x1024 px | 512x512 px (Play Store) | App Store / Play Store |
| Format | PNG, pas de transparence, pas de coins arrondis | PNG, 32-bit avec alpha | Guidelines |
| Coins arrondis | Appliques automatiquement par iOS (~17.5% radius) | Adaptive icon: masque systeme | Platform |
| Adaptive (Android) | N/A | Foreground 108x108dp + Background 108x108dp | [Android Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive) |
| Safe zone adaptive | N/A | 72x72dp centre (inner 66%) | Android Docs |
| Monochrome layer | N/A | Requis Android 13+ (themed icons) | Android 13 |
| Alternate icons | `setAlternateIconName(_:)` iOS 10.3+ | N/A nativement | Apple Docs |
| Dark mode icon | iOS 18+: dark + tinted variants | Android 13+ monochrome | 2024+ |

**Principes Design Icon:**

| Principe | Regle | Raison |
|----------|-------|--------|
| Simplicite | 1 forme reconnaissable, pas de texte | Lisible a 29x29 pt (small settings icon) |
| Unicite | Distinguable dans le dock/drawer | Differenciation |
| Coherence brand | Couleurs et formes alignees avec l'app | Reconnaissance |
| Pas de photo | Silhouettes, formes geometriques | Clarte a petite taille |
| Pas de badge | Pas de badge notification dans l'icon | Conflit avec badge systeme |
| Contraste | Fonctionne sur fond clair et sombre | Wallpapers varies |
| Pas de bord | Pas de bordure noire ou frame | Coins arrondis iOS l'ajoutent deja |

---

### 79. Screenshots & Preview Videos

| Parametre | iOS | Android |
|-----------|-----|---------|
| Nombre screenshots | 1-10 par locale | 2-8 par type d'appareil |
| Ordre | Les 3 premiers visibles dans search results | Les 2-3 premiers visibles |
| Taille iPhone 6.7" | 1290x2796 px (portrait) | Variable, min 320px, max 3840px |
| Taille iPhone 6.5" | 1284x2778 px (portrait) | Recommended 1080x1920 px |
| Taille iPad 12.9" | 2048x2732 px (portrait) | 7" et 10" tablets |
| Video preview | 15-30 secondes, muted autoplay | 30 sec - 2 min, YouTube link |
| Format video | MOV ou MP4, H.264 | YouTube URL dans Play Console |

**Screenshot Content Strategy:**

| Position | Contenu | Objectif |
|----------|---------|---------|
| 1 | Hero shot - valeur principale de l'app | Accroche immediate |
| 2 | Feature cle #1 (ex: tracking dashboard) | Differenciateur |
| 3 | Feature cle #2 (ex: analytics/charts) | Profondeur |
| 4 | Social proof ou resultats | Confiance |
| 5 | Feature secondaire (ex: widget, watch) | Completude |
| 6-8 | Features additionnelles, dark mode, personnalisation | Exhaustivite |

**Best Practices Screenshots:**

| Regle | Details |
|-------|---------|
| Titre au-dessus | Max 5-7 mots, font lisible a petite taille |
| Device frame | Optionnel (tendance 2025: sans frame, image plus grande) |
| Background | Couleur de marque, gradient subtil |
| Orientation | Portrait en priorite (95% des impressions sur mobile) |
| Localisation | Screenshots localises pour marches cles (FR, DE, JP, etc.) |
| A/B testing | Google Play Experiments pour tester variantes |
| Contenu reel | Montrer des donnees realistes, pas "Lorem ipsum" |
| Progression | Raconter une histoire a travers les screenshots |

---

### 80. Rating & Review Prompts

| Parametre | iOS | Android | Source |
|-----------|-----|---------|--------|
| API | `SKStoreReviewController.requestReview()` | `ReviewManager` (In-App Review API) | Platform docs |
| Frequence max | 3x / 365 jours (controle par le systeme) | Quota systeme, pas documente | Platform docs |
| Controle affichage | Le systeme decide si le dialog s'affiche vraiment | Le systeme decide | Platform docs |
| Custom UI | Interdit d'imiter le system dialog | Interdit | Guidelines |
| Redirect store | `UIApplication.open(appStoreURL)` pour reviews manuelles | Deep link Play Store review | Platform docs |

**Pre-prompt Pattern (recommande):**
```
1. Moment positif detecte (milestone, achievement)
2. App affiche dialog custom:
   "Enjoying Infernal Wheel?"
   [Yes, I love it!]  [Not really]
3a. "Yes" -> trigger SKStoreReviewController / ReviewManager
3b. "Not really" -> feedback form in-app (pas de store review)
```

**Code Swift (review prompt):**
```swift
import StoreKit

func requestReviewIfAppropriate() {
    let launchCount = UserDefaults.standard.integer(forKey: "launchCount")
    let lastReviewPrompt = UserDefaults.standard.object(forKey: "lastReviewPrompt") as? Date
    let daysSinceLastPrompt = lastReviewPrompt.map {
        Calendar.current.dateComponents([.day], from: $0, to: .now).day ?? 0
    } ?? 999

    // After 5+ launches, 30+ days since last prompt, positive moment
    if launchCount >= 5 && daysSinceLastPrompt >= 30 {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })
            as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
            UserDefaults.standard.set(Date(), forKey: "lastReviewPrompt")
        }
    }
}
```

**Code Kotlin (review prompt):**
```kotlin
val reviewManager = ReviewManagerFactory.create(context)

fun requestReviewIfAppropriate(activity: Activity) {
    val prefs = context.getSharedPreferences("review", Context.MODE_PRIVATE)
    val launchCount = prefs.getInt("launchCount", 0)
    val lastPrompt = prefs.getLong("lastReviewPrompt", 0L)
    val daysSince = TimeUnit.MILLISECONDS.toDays(
        System.currentTimeMillis() - lastPrompt
    )

    if (launchCount >= 5 && daysSince >= 30) {
        val request = reviewManager.requestReviewFlow()
        request.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                reviewManager.launchReviewFlow(activity, task.result)
                prefs.edit()
                    .putLong("lastReviewPrompt", System.currentTimeMillis())
                    .apply()
            }
        }
    }
}
```

**Timing optimal pour app cessation tabac:**

| Moment | Raison | Priorite |
|--------|--------|----------|
| Apres 7 jours consecutifs de reduction | Milestone positif, user engage | Haute |
| Apres premier badge/achievement debloque | Sentiment d'accomplissement | Haute |
| Apres 30 jours d'utilisation active | User engage long terme | Moyenne |
| Apres partage de progres reussi | Sentiment positif social | Moyenne |
| Apres un nouveau record (plus long sans fumer) | Celebration | Haute |

**Anti-patterns Rating Prompt:**

| A eviter | Raison |
|----------|--------|
| Premier lancement | User n'a pas encore de valeur |
| Apres un crash ou erreur | Sentiment negatif |
| Pendant une tache en cours | Interruption frustrante |
| Pop-up repetitif | Harassment -> mauvaise review |
| "Rate 5 stars" | Manipulation -> rejet App Store |
| Bloquer l'app | Dark pattern -> violation guidelines |

---

### 81. Privacy Labels & Data Safety

| Parametre | iOS (Privacy Labels) | Android (Data Safety) |
|-----------|---------------------|----------------------|
| Emplacement | App Store Connect | Google Play Console |
| Obligatoire | Oui, depuis iOS 14.5 | Oui, depuis juillet 2022 |
| Categories | Data collected, Data linked to you, Data used to track you | Data shared, Data collected, Security practices |
| Mise a jour | A chaque soumission | Obligation de maintenir a jour |
| Verification | Apple review | Self-declared + Google audits possibles |
| Sanctions | Rejet update si incorrect | Avertissement, retrait possible |

**Categories pour app cessation tabac:**

| Donnee | Collectee | Liee a l'identite | Tracking | Justification |
|--------|-----------|-------------------|----------|---------------|
| Health & Fitness data | Oui | Oui | Non | Cigarette tracking, health metrics |
| Usage data | Oui | Non | Non | Analytics (anonymise) |
| Device ID | Oui | Non | Non | Crash reporting |
| Location | Optionnel | Non | Non | Trigger/pattern analysis |
| Name/Email | Oui (si compte) | Oui | Non | Account management |
| Purchase history | Oui (si IAP) | Oui | Non | Subscription management |
| Diagnostics | Oui | Non | Non | Performance monitoring |

**Checklist ASO:**
- [ ] App icon 1024x1024 (iOS) et 512x512 (Android) conformes
- [ ] Android adaptive icon avec foreground, background, monochrome layers
- [ ] iOS 18+ dark/tinted icon variants si applicable
- [ ] 5+ screenshots optimises par plateforme
- [ ] Screenshot #1 = value proposition principale
- [ ] Texte screenshots localise pour marches cles
- [ ] Video preview 15-30s (iOS) si applicable
- [ ] Keywords/metadata optimises pour search
- [ ] Rating prompt au bon moment (apres action positive, pas au launch)
- [ ] Pre-prompt pattern pour filtrer feedback negatif
- [ ] Privacy labels / Data safety a jour et honnetes
- [ ] A/B test store listing (Google Play Experiments)
- [ ] App category et age rating corrects

---

## AG. Share Extensions & System Integration

### 82. Share Extensions

| Parametre | iOS | Android |
|-----------|-----|---------|
| Extension type | Share Extension (NSExtensionPointIdentifier) | ShareSheet / `Intent.ACTION_SEND` |
| Direct Share | N/A (system manages) | `ShortcutManager` pour Direct Share targets |
| UI | SLComposeServiceViewController ou custom SwiftUI | ChooserActivity ou custom |
| Data types | `NSItemProvider` avec UTType | `Intent` extras, `ClipData` |
| Memory limit | 120 MB (extension process) | Standard app memory |
| Process | Separate process from main app | Same process (ou intent receiver) |
| Communication | App Groups (shared container) | ContentProvider, FileProvider |
| SwiftUI | Possible via UIHostingController dans extension | N/A (standard activity) |

**Code Swift (Share Extension - receive):**
```swift
class ShareViewController: SLComposeServiceViewController {
    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first else {
            extensionContext?.completeRequest(returningItems: nil)
            return
        }

        if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.url.identifier) { item, _ in
                if let url = item as? URL {
                    // Save to shared container via App Group
                    let defaults = UserDefaults(suiteName: "group.com.app.shared")
                    defaults?.set(url.absoluteString, forKey: "sharedURL")
                    // Notify main app
                    DispatchQueue.main.async {
                        self.extensionContext?.completeRequest(returningItems: nil)
                    }
                }
            }
        } else if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier) { item, _ in
                if let text = item as? String {
                    let defaults = UserDefaults(suiteName: "group.com.app.shared")
                    defaults?.set(text, forKey: "sharedText")
                    DispatchQueue.main.async {
                        self.extensionContext?.completeRequest(returningItems: nil)
                    }
                }
            }
        }
    }
}
```

**Code Kotlin (receive share intent):**
```kotlin
// AndroidManifest.xml
// <activity android:name=".ShareReceiverActivity" android:exported="true">
//     <intent-filter>
//         <action android:name="android.intent.action.SEND" />
//         <category android:name="android.intent.category.DEFAULT" />
//         <data android:mimeType="text/plain" />
//     </intent-filter>
//     <intent-filter>
//         <action android:name="android.intent.action.SEND" />
//         <category android:name="android.intent.category.DEFAULT" />
//         <data android:mimeType="image/*" />
//     </intent-filter>
// </activity>

class ShareReceiverActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        when (intent?.action) {
            Intent.ACTION_SEND -> {
                when {
                    intent.type == "text/plain" -> {
                        intent.getStringExtra(Intent.EXTRA_TEXT)?.let { text ->
                            handleSharedText(text)
                        }
                    }
                    intent.type?.startsWith("image/") == true -> {
                        (intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM))?.let { uri ->
                            handleSharedImage(uri)
                        }
                    }
                }
            }
        }
    }
}
```

**Sharing from app (send):**

```swift
// iOS - Share Sheet
let activityVC = UIActivityViewController(
    activityItems: ["I've been smoke-free for 7 days!", URL(string: "https://app.example.com")!],
    applicationActivities: nil
)
activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
present(activityVC, animated: true)
```

```kotlin
// Android - Share Sheet
val sendIntent = Intent().apply {
    action = Intent.ACTION_SEND
    type = "text/plain"
    putExtra(Intent.EXTRA_TEXT, "I've been smoke-free for 7 days! https://app.example.com")
}
startActivity(Intent.createChooser(sendIntent, "Share your progress"))
```

---

### 83. Quick Actions & Home Screen Shortcuts

| Parametre | iOS | Android |
|-----------|-----|---------|
| Home Screen | UIApplicationShortcutItem (3D Touch / Long press) | ShortcutManager (static + dynamic) |
| Max shortcuts | 4 actions | 4-5 shortcuts (device-dependent) |
| Static | Info.plist `UIApplicationShortcutItems` | `<shortcuts>` dans res/xml |
| Dynamic | `UIApplication.shared.shortcutItems` | `ShortcutManager.addDynamicShortcuts()` |
| Icon | SF Symbols ou custom icon | Adaptive icon ou resource |
| Pinned | N/A | `ShortcutManager.requestPinShortcut()` (Android 8+) |

**Code Swift (Quick Actions):**
```swift
// Dynamic shortcuts
UIApplication.shared.shortcutItems = [
    UIApplicationShortcutItem(
        type: "com.app.logCigarette",
        localizedTitle: "Log Cigarette",
        localizedSubtitle: nil,
        icon: UIApplicationShortcutIcon(systemImageName: "plus.circle"),
        userInfo: nil
    ),
    UIApplicationShortcutItem(
        type: "com.app.viewStats",
        localizedTitle: "View Stats",
        localizedSubtitle: "Today's progress",
        icon: UIApplicationShortcutIcon(systemImageName: "chart.bar"),
        userInfo: nil
    ),
    UIApplicationShortcutItem(
        type: "com.app.startTimer",
        localizedTitle: "Start Timer",
        localizedSubtitle: "Track smoke-free time",
        icon: UIApplicationShortcutIcon(systemImageName: "timer"),
        userInfo: nil
    )
]

// Handle in SceneDelegate
func windowScene(_ windowScene: UIWindowScene,
                 performActionFor shortcutItem: UIApplicationShortcutItem,
                 completionHandler: @escaping (Bool) -> Void) {
    switch shortcutItem.type {
    case "com.app.logCigarette":
        DeepLinkRouter.shared.handle(.logCigarette)
    case "com.app.viewStats":
        DeepLinkRouter.shared.handle(.stats)
    case "com.app.startTimer":
        DeepLinkRouter.shared.handle(.timer)
    default: break
    }
    completionHandler(true)
}

// SwiftUI (iOS 16+)
WindowGroup {
    ContentView()
        .onContinueUserActivity(
            UIApplicationShortcutItem.type,
            perform: handleShortcut
        )
}
```

**Code Kotlin (shortcuts):**
```kotlin
val shortcutManager = getSystemService(ShortcutManager::class.java)

val shortcuts = listOf(
    ShortcutInfo.Builder(this, "log_cigarette")
        .setShortLabel("Log Cigarette")
        .setLongLabel("Log a cigarette")
        .setIcon(Icon.createWithResource(this, R.drawable.ic_add))
        .setIntent(Intent(this, MainActivity::class.java).apply {
            action = "com.app.LOG_CIGARETTE"
            flags = Intent.FLAG_ACTIVITY_CLEAR_TASK
        })
        .build(),
    ShortcutInfo.Builder(this, "view_stats")
        .setShortLabel("View Stats")
        .setLongLabel("View today's statistics")
        .setIcon(Icon.createWithResource(this, R.drawable.ic_stats))
        .setIntent(Intent(this, MainActivity::class.java).apply {
            action = "com.app.VIEW_STATS"
            flags = Intent.FLAG_ACTIVITY_CLEAR_TASK
        })
        .build()
)

shortcutManager.dynamicShortcuts = shortcuts
```

---

### 84. App Intents & Siri Shortcuts

| Parametre | iOS | Android |
|-----------|-----|---------|
| Framework | App Intents (iOS 16+) / SiriKit (legacy) | App Actions (actions.xml) |
| Voice | "Hey Siri, log a cigarette in [App]" | "Hey Google, log cigarette in [App]" |
| Spotlight | Indexed via App Intents + CSSearchableIndex | Firebase App Indexing |
| Automation | Shortcuts app integration | Google Assistant Routines |
| Widget actions | App Intent powering interactive widgets (iOS 17+) | N/A (Glance callbacks) |
| Parameterized | AppEntity + queries | Built-in intents (BII) parameters |
| Spotlight suggestions | Donated activities surface in search | N/A |

**Code Swift (App Intent):**
```swift
import AppIntents

struct LogCigaretteIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Cigarette"
    static var description = IntentDescription("Log a cigarette in your tracker")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Trigger")
    var trigger: String?

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let count = await CigaretteStore.shared.logOne(trigger: trigger)
        return .result(dialog: "Logged. Total today: \(count)")
    }
}

// Siri phrases
struct LogCigaretteShortcut: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogCigaretteIntent(),
            phrases: [
                "Log a cigarette in \(.applicationName)",
                "I smoked in \(.applicationName)",
                "Track cigarette in \(.applicationName)"
            ],
            shortTitle: "Log Cigarette",
            systemImageName: "plus.circle"
        )
    }
}

// Query intent (parameterized)
struct ViewStatsIntent: AppIntent {
    static var title: LocalizedStringResource = "View Stats"
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Time Period")
    var period: StatsPeriod

    func perform() async throws -> some IntentResult {
        // Opens app to stats screen for the given period
        return .result()
    }
}

enum StatsPeriod: String, AppEnum {
    case today, week, month
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Time Period")
    static var caseDisplayRepresentations: [StatsPeriod: DisplayRepresentation] = [
        .today: "Today",
        .week: "This Week",
        .month: "This Month"
    ]
}
```

**Code Android (App Actions - actions.xml):**
```xml
<actions>
    <action intentName="actions.intent.LOG_HEALTH_OBSERVATION">
        <parameter name="healthObservation.name">
            <entity-set-reference entitySetId="cigaretteTypes" />
        </parameter>
        <fulfillment urlTemplate="myapp://log{?type}"
                     fulfillmentMode="actions.fulfillment.DEEPLINK">
            <parameter-mapping
                intentParameter="healthObservation.name"
                urlParameter="type" />
        </fulfillment>
    </action>

    <action intentName="actions.intent.GET_HEALTH_OBSERVATION">
        <fulfillment urlTemplate="myapp://stats"
                     fulfillmentMode="actions.fulfillment.DEEPLINK" />
    </action>

    <entity-set entitySetId="cigaretteTypes">
        <entity
            identifier="cigarette"
            name="cigarette"
            alternateName="@array/cigarette_synonyms" />
    </entity-set>
</actions>
```

---

### 85. Photo & Document Pickers

| Parametre | iOS | Android |
|-----------|-----|---------|
| Photo picker | PHPickerViewController (iOS 14+) | Photo Picker (Android 13+) / MediaStore |
| Avantage principal | Pas besoin de permission Photos | Pas besoin de READ_MEDIA_IMAGES |
| Multi-selection | `selectionLimit` (0 = illimite) | `EXTRA_ALLOW_MULTIPLE` |
| Filter | `.images`, `.videos`, `.livePhotos`, `.screenshots` | `image/*`, `video/*` MIME types |
| Document | UIDocumentPickerViewController | ACTION_OPEN_DOCUMENT (SAF) |
| Drag & Drop | UIDragInteraction / UIDropInteraction (iPad) | DragAndDropPermissions (Android 7+) |
| Clipboard | UIPasteboard (iOS 16+: paste button/permission) | ClipboardManager |
| Paste button | `UIPasteControl` (iOS 16+) - no permission dialog | N/A |

**Code Swift (PHPicker):**
```swift
import PhotosUI

var config = PHPickerConfiguration()
config.selectionLimit = 1
config.filter = .images
config.preferredAssetRepresentationMode = .current

let picker = PHPickerViewController(configuration: config)
picker.delegate = self
present(picker, animated: true)

// Delegate
func picker(_ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let provider = results.first?.itemProvider,
          provider.canLoadObject(ofClass: UIImage.self) else { return }
    provider.loadObject(ofClass: UIImage.self) { image, error in
        DispatchQueue.main.async {
            self.selectedImage = image as? UIImage
        }
    }
}

// SwiftUI (iOS 16+)
PhotosPicker(selection: $selectedItem, matching: .images) {
    Label("Select Photo", systemImage: "photo")
}
.onChange(of: selectedItem) { newItem in
    Task {
        if let data = try? await newItem?.loadTransferable(type: Data.self) {
            selectedImage = UIImage(data: data)
        }
    }
}
```

**Code Kotlin (Photo Picker - Android 13+):**
```kotlin
// Activity Result API
val pickMedia = registerForActivityResult(ActivityResultContracts.PickVisualMedia()) { uri ->
    uri?.let { handleSelectedImage(it) }
}

// Launch
pickMedia.launch(PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly))

// Multi-select
val pickMultipleMedia = registerForActivityResult(
    ActivityResultContracts.PickMultipleVisualMedia(maxItems = 5)
) { uris ->
    uris.forEach { handleSelectedImage(it) }
}
```

**Checklist System Integration:**
- [ ] Share extension recoit et traite correctement les types attendus
- [ ] Share sheet pour envoyer du contenu depuis l'app
- [ ] Quick Actions (3-4 max) pour les actions les plus frequentes
- [ ] Siri Shortcuts / App Actions pour voice control
- [ ] PHPicker / Photo Picker utilise (pas de permission Photos requise)
- [ ] Document picker via system UI (pas de file browser custom)
- [ ] Clipboard: UIPasteControl (iOS 16+) pour eviter la permission dialog
- [ ] Deep link depuis shortcuts vers ecran pertinent
- [ ] App Groups pour communication extension <-> app (iOS)

---

## AH. Camera, AR & Media Capture

### 86. Camera Permission Flow

| Parametre | iOS | Android |
|-----------|-----|---------|
| Permission | `NSCameraUsageDescription` (Info.plist) | `android.permission.CAMERA` (runtime) |
| Pre-prompt | Dialog custom avant le system dialog | Dialog custom avant requestPermission |
| Denied handling | Redirect vers Settings (`UIApplication.openSettingsURL`) | `shouldShowRequestPermissionRationale()` puis Settings |
| Status check | `AVCaptureDevice.authorizationStatus(for: .video)` | `ContextCompat.checkSelfPermission()` |
| Microphone | `NSMicrophoneUsageDescription` (separate) | `android.permission.RECORD_AUDIO` (separate) |
| Photo library | PHPicker ne necessite pas de permission | Photo Picker ne necessite pas de permission |

**Pre-prompt Pattern:**
```
1. User tape "Scan QR Code"
2. App affiche dialog custom:
   "Camera Access Needed"
   "We need camera access to scan QR codes for [feature].
    Your camera feed is never recorded or stored."
   [Allow] [Not Now]
3a. "Allow" -> system permission dialog
3b. "Not Now" -> feature degradee (saisie manuelle du code)
```

**Code Swift (camera permission):**
```swift
func requestCameraAccess(completion: @escaping (Bool) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        completion(true)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async { completion(granted) }
        }
    case .denied, .restricted:
        showSettingsRedirectAlert(
            title: "Camera Access Required",
            message: "Please enable camera access in Settings to scan QR codes."
        )
        completion(false)
    @unknown default:
        completion(false)
    }
}

func showSettingsRedirectAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
}
```

**Code Kotlin (camera permission):**
```kotlin
val cameraPermissionLauncher = registerForActivityResult(
    ActivityResultContracts.RequestPermission()
) { isGranted ->
    if (isGranted) {
        openCamera()
    } else {
        showSettingsRedirect()
    }
}

fun requestCameraPermission() {
    when {
        ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            == PackageManager.PERMISSION_GRANTED -> openCamera()
        shouldShowRequestPermissionRationale(Manifest.permission.CAMERA) ->
            showRationaleDialog()
        else ->
            cameraPermissionLauncher.launch(Manifest.permission.CAMERA)
    }
}
```

---

### 87. Camera UI Patterns

| Element | Regle | Source |
|---------|-------|--------|
| Viewfinder | Plein ecran, pas de chrome excessif | Camera app conventions |
| Shutter button | Centre bas, min 60x60 pt / 60x60 dp | Touch target + thumb reach |
| Flash toggle | Coin superieur gauche, icone standard | Convention iOS Camera |
| Switch camera | Coin superieur droit ou inferieur | Convention |
| Zoom | Pinch gesture + slider ou segmented control | Convention |
| Focus | Tap-to-focus avec indicateur visuel carre | Convention |
| Capture feedback | Flash blanc + son shutter + haptic | Multi-sensory feedback |
| Mode selector | Horizontal swipe (Photo, Video, Portrait, etc.) | iOS Camera convention |
| Grid overlay | Optional, rule of thirds | Photography aid |

**QR/Barcode Scanning UX:**

| Element | Regle |
|---------|-------|
| Viewfinder frame | Carre semi-transparent avec coins mis en evidence |
| Instruction text | "Point camera at QR code" visible mais discret, en haut |
| Auto-detect | Scan automatique sans bouton "Scan" |
| Feedback | Haptic medium + highlight vert + son subtil quand code detecte |
| Torch button | Bouton lampe torche visible si luminosite basse (auto-suggest) |
| Result action | Afficher resultat avec action contextuelle (ouvrir URL, copier, ajouter) |
| Timeout | Message d'aide apres 10s sans detection: "Try moving closer" |
| Multi-code | Si plusieurs codes visibles, highlight le plus central |
| Flashlight auto | Proposer d'activer le flash si environnement sombre |

**Code Swift (QR scanner):**
```swift
import AVFoundation

class QRScannerViewController: UIViewController,
    AVCaptureMetadataOutputObjectsDelegate {

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            showCameraUnavailable()
            return
        }

        captureSession.addInput(input)

        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        addScannerOverlay()

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                       didOutput metadataObjects: [AVMetadataObject],
                       from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first
                as? AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else { return }

        captureSession.stopRunning()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        AudioServicesPlaySystemSound(SystemSoundID(1057)) // Subtle scan sound
        handleScannedCode(value)
    }
}
```

---

### 88. Image Editing & Upload

| Pattern | Regle | Notes |
|---------|-------|-------|
| Crop | System crop (UIImagePickerController.allowsEditing) ou custom | Custom pour ratio specifique |
| Rotate | Geste rotation 2 doigts ou bouton 90 degres | Standard |
| Filters | Preview en temps reel avec CIFilter (iOS) / GPUImage | Performance GPU |
| Compression | JPEG quality 0.7-0.8 pour upload | Balance qualite/taille |
| Max dimension | Resize to max 2048px avant upload | Bandwidth + storage |
| Upload progress | ProgressView visible avec pourcentage | Feedback utilisateur |
| Resume upload | Chunked upload avec resume capability (tus protocol) | Reseau instable |
| Background upload | URLSession background (iOS) / WorkManager (Android) | App en background |
| Max file size | Definir et communiquer: "Max 10 MB" | UX transparence |
| Format conversion | HEIF -> JPEG pour compatibilite serveur | Cross-platform support |

**Upload Progress UI:**

| Etat | UI | Action disponible |
|------|-----|-------------------|
| Preparing | Spinner + "Preparing..." | Cancel |
| Uploading | Progress bar + "42%" | Cancel |
| Processing | Spinner + "Processing..." | N/A |
| Complete | Checkmark + "Done" | View / Share |
| Failed | Error message + retry | Retry / Cancel |

**Checklist Camera & Media:**
- [ ] Pre-prompt expliquant pourquoi la camera est necessaire
- [ ] Fallback si permission refusee (saisie manuelle, upload fichier)
- [ ] Viewfinder plein ecran avec controles minimaux
- [ ] Shutter button >= 60pt/60dp, zone de thumb reach
- [ ] QR scanner avec auto-detect et feedback haptic
- [ ] Compression image avant upload (JPEG 0.7-0.8, max 2048px)
- [ ] Upload progress visible avec pourcentage
- [ ] Background upload pour gros fichiers
- [ ] Gestion erreur upload (retry, resume)
- [ ] Format conversion HEIF -> JPEG si necessaire

---

## AI. Maps & Location Mobile

### 89. Map SDKs

| Parametre | iOS (MapKit) | Android (Google Maps SDK) |
|-----------|-------------|--------------------------|
| Integration | Natif, pas de API key | API key requise (Google Cloud Console) |
| SwiftUI | `Map()` view (iOS 17+) | `GoogleMap()` via maps-compose |
| UIKit | `MKMapView` | `MapView` / `SupportMapFragment` |
| Markers | `Annotation` / `MKAnnotationView` | `Marker` / `MarkerOptions` |
| Clustering | `MKClusterAnnotation` (iOS 11+) | `ClusterManager` (Maps Utils library) |
| Custom tiles | `MKTileOverlay` | `TileOverlay` |
| Indoor maps | Support natif | Support natif |
| Offline | Pas de support natif MapKit | Offline areas download (Google Maps) |
| 3D | Globe view (iOS 17+), Flyover, Look Around | 3D buildings, tilt, Street View |
| Pricing | Gratuit | Gratuit jusqu'a $200/mois credit, puis pay-per-use |

**Code SwiftUI (Map iOS 17+):**
```swift
import MapKit

struct SmokingLocationsMap: View {
    @State private var position: MapCameraPosition = .automatic
    let locations: [CigaretteLocation]

    var body: some View {
        Map(position: $position) {
            // User location
            UserAnnotation()

            // Smoking locations
            ForEach(locations) { location in
                Annotation(
                    location.label,
                    coordinate: location.coordinate,
                    anchor: .bottom
                ) {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Text("\(location.count)")
                            .font(.caption2.bold())
                            .padding(4)
                            .background(.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}
```

**Code Kotlin (Maps Compose):**
```kotlin
@Composable
fun SmokingLocationsMap(locations: List<CigaretteLocation>) {
    val cameraPositionState = rememberCameraPositionState {
        position = CameraPosition.fromLatLngZoom(
            LatLng(48.8566, 2.3522), // Default: Paris
            13f
        )
    }

    GoogleMap(
        modifier = Modifier.fillMaxSize(),
        cameraPositionState = cameraPositionState,
        properties = MapProperties(
            isMyLocationEnabled = true,
            mapType = MapType.NORMAL
        ),
        uiSettings = MapUiSettings(
            myLocationButtonEnabled = true,
            zoomControlsEnabled = true,
            compassEnabled = true
        )
    ) {
        locations.forEach { location ->
            Marker(
                state = MarkerState(position = location.latLng),
                title = location.label,
                snippet = "${location.count} cigarettes here"
            )
        }
    }
}
```

---

### 90. Location Permissions

| Niveau | iOS | Android | Usage |
|--------|-----|---------|-------|
| When In Use | `NSLocationWhenInUseUsageDescription` | `ACCESS_FINE_LOCATION` | Map, nearby search |
| Always | `NSLocationAlwaysAndWhenInUseUsageDescription` | `ACCESS_BACKGROUND_LOCATION` (separate request) | Geofencing, tracking |
| Approximate | Approximate toggle (iOS 14+) | `ACCESS_COARSE_LOCATION` | Ville-level |
| Precise | Precise toggle (iOS 14+) | `ACCESS_FINE_LOCATION` | Exact position |
| Temporary | `.requestTemporaryFullAccuracyAuthorization(withPurposeKey:)` | N/A | Ponctuel precise fix |
| Background (Android) | N/A | Separate permission dialog (Android 10+) | Must request after foreground |

**Progressive Location Permission Pattern:**

| Etape | Contexte | Permission demandee |
|-------|----------|-------------------|
| 1 | User ouvre la carte des lieux de consommation | Request "When In Use" |
| 2 | User active les alertes geofencing | Request upgrade "Always" (iOS) / Background (Android) |
| 3 | User decline Always/Background | Fallback: manual check-in, pas de geofencing |
| 4 | User precise location decline | Fallback: approximate fonctionne pour la carte |

**Code Swift (location permission progressive):**
```swift
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var location: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestWhenInUse() {
        manager.requestWhenInUseAuthorization()
    }

    func requestAlways() {
        // Only call after When In Use is granted
        manager.requestAlwaysAuthorization()
    }

    func requestTemporaryPrecision() {
        manager.requestTemporaryFullAccuracyAuthorization(
            withPurposeKey: "MapPreciseLocation"
        ) { error in
            if error == nil {
                self.manager.requestLocation()
            }
        }
    }

    // Significant location changes (battery efficient)
    func startSignificantLocationMonitoring() {
        manager.startMonitoringSignificantLocationChanges()
    }

    // Continuous (battery intensive - use sparingly)
    func startContinuousTracking() {
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                        didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
```

---

### 91. Geofencing

| Parametre | iOS | Android |
|-----------|-----|---------|
| API | `CLLocationManager.startMonitoring(for: CLCircularRegion)` | `GeofencingClient.addGeofences()` |
| Max regions | 20 simultanees | 100 par app |
| Rayon min fiable | 100m (recommande, < 100m peu fiable) | 100m (recommande pour fiabilite) |
| Rayon max | Pas de limite explicite | 50,000m |
| Transitions | Enter, Exit | Enter, Exit, Dwell |
| Dwell time | N/A natif (implementer manuellement) | `setLoiteringDelay(ms)` |
| Battery impact | Faible (cell tower + WiFi based) | Faible (fused location provider) |
| Background | Necessite "Always" location permission | Necessite `ACCESS_BACKGROUND_LOCATION` |
| Precision | ~100-200m en pratique | ~100-200m en pratique |

**Code Swift (geofencing):**
```swift
func setupSmokingZoneGeofence(center: CLLocationCoordinate2D,
                               radius: CLLocationDistance = 200,
                               identifier: String) {
    let region = CLCircularRegion(
        center: center,
        radius: min(radius, manager.maximumRegionMonitoringDistance),
        identifier: identifier
    )
    region.notifyOnEntry = true
    region.notifyOnExit = false

    manager.startMonitoring(for: region)
}

func locationManager(_ manager: CLLocationManager,
                    didEnterRegion region: CLRegion) {
    // User entered a known smoking zone
    sendCravingAlert(region.identifier)
}
```

**Code Kotlin (geofencing):**
```kotlin
fun addSmokingZoneGeofence(latLng: LatLng, radius: Float = 200f, id: String) {
    val geofence = Geofence.Builder()
        .setRequestId(id)
        .setCircularRegion(latLng.latitude, latLng.longitude, radius)
        .setTransitionTypes(
            Geofence.GEOFENCE_TRANSITION_ENTER or
            Geofence.GEOFENCE_TRANSITION_DWELL
        )
        .setLoiteringDelay(60_000) // 1 min dwell
        .setExpirationDuration(Geofence.NEVER_EXPIRE)
        .build()

    val request = GeofencingRequest.Builder()
        .setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
        .addGeofence(geofence)
        .build()

    val intent = PendingIntent.getBroadcast(
        context, 0,
        Intent(context, GeofenceBroadcastReceiver::class.java),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
    )

    geofencingClient.addGeofences(request, intent)
}
```

**Use cases geofencing cessation tabac:**

| Scenario | Geofence | Action |
|----------|----------|--------|
| Zone a risque | Autour du bar/terrasse habituel | Notification: "Entering a trigger zone. Stay strong!" |
| Lieu de travail | Pause cigarette habituelle | Notification a l'heure habituelle de pause |
| Domicile | Zone de confort | Tracking automatique active/desactive |
| Pharmacie | A proximite | Suggestion: "Need nicotine patches?" |

**Checklist Maps & Location:**
- [ ] Location permission demandee au moment pertinent (pas au lancement)
- [ ] Pre-prompt expliquant pourquoi la localisation est necessaire
- [ ] Fallback si permission refusee (saisie manuelle d'adresse)
- [ ] "When In Use" par defaut, "Always" uniquement si geofencing necessaire
- [ ] Significant location changes pour economiser la batterie (pas continuous)
- [ ] Markers clustered quand trop nombreux
- [ ] Map controles (zoom, compass, user location) accessibles
- [ ] Geofencing: min 100m rayon pour fiabilite
- [ ] Background location indicator visible quand tracking actif (iOS)
- [ ] Location usage description claire et honnete

---

## AJ. Background Processing

### 92. iOS Background Tasks

| API | Type | Duree | Usage | Source |
|-----|------|-------|-------|--------|
| BGAppRefreshTask | App refresh | ~30 secondes | Sync donnees, prefetch | [Apple BGTaskScheduler](https://developer.apple.com/documentation/backgroundtasks) |
| BGProcessingTask | Long processing | Minutes (plugged in, idle) | ML training, cleanup, export | Apple Docs |
| Silent Push | Remote notification (`content-available: 1`) | ~30 secondes | Sync server-triggered | Apple Docs |
| Background URLSession | Upload/Download | Illimite | Gros fichiers | Apple Docs |
| Background Location | Location updates | Continu | Tracking position | Core Location |
| Background Audio | Audio playback | Continu | Musique, meditation guidee | AVAudioSession |
| Background fetch (legacy) | Periodic refresh | ~30 secondes | Deprecated en faveur de BGTaskScheduler | Apple Docs |

**Code Swift (BGTaskScheduler):**
```swift
// 1. Register in AppDelegate didFinishLaunching
BGTaskScheduler.shared.register(
    forTaskWithIdentifier: "com.app.cigarette.sync",
    using: nil
) { task in
    self.handleAppRefresh(task: task as! BGAppRefreshTask)
}

BGTaskScheduler.shared.register(
    forTaskWithIdentifier: "com.app.cigarette.export",
    using: nil
) { task in
    self.handleProcessingTask(task: task as! BGProcessingTask)
}

// 2. Schedule
func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(
        identifier: "com.app.cigarette.sync"
    )
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
    do {
        try BGTaskScheduler.shared.submit(request)
    } catch {
        print("Could not schedule app refresh: \(error)")
    }
}

func scheduleDataExport() {
    let request = BGProcessingTaskRequest(
        identifier: "com.app.cigarette.export"
    )
    request.requiresNetworkConnectivity = true
    request.requiresExternalPower = false
    try? BGTaskScheduler.shared.submit(request)
}

// 3. Handle
func handleAppRefresh(task: BGAppRefreshTask) {
    scheduleAppRefresh() // Schedule next occurrence

    let syncOperation = Task {
        do {
            try await SyncManager.shared.syncCigaretteData()
            task.setTaskCompleted(success: true)
        } catch {
            task.setTaskCompleted(success: false)
        }
    }

    task.expirationHandler = {
        syncOperation.cancel()
    }
}

// 4. Info.plist: BGTaskSchedulerPermittedIdentifiers
// ["com.app.cigarette.sync", "com.app.cigarette.export"]
```

---

### 93. Android WorkManager

| Parametre | Valeur | Source |
|-----------|--------|--------|
| API | WorkManager (`androidx.work:work-runtime-ktx:2.9+`) | [Android WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager) |
| Constraint types | NetworkType, BatteryNotLow, Charging, DeviceIdle, StorageNotLow | Android Docs |
| Work types | OneTimeWorkRequest, PeriodicWorkRequest (min 15 min interval) | Android Docs |
| Chaining | `beginWith().then().then().enqueue()` | Android Docs |
| Unique work | `enqueueUniqueWork()` / `enqueueUniquePeriodicWork()` | Android Docs |
| Retry policy | `BackoffPolicy.LINEAR` ou `EXPONENTIAL`, min 10s | Android Docs |
| Expedited | `setExpedited(OutOfQuotaPolicy)` pour travail urgent | Android 12+ |
| Foreground | `setForeground(ForegroundInfo)` pour long-running visible | Android Docs |
| Input/Output | `Data` objects, max 10 KB | Android Docs |

**Code Kotlin (WorkManager complet):**
```kotlin
class CigaretteSyncWorker(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result {
        return try {
            // Show progress (optional)
            setProgress(workDataOf("progress" to 0))

            val localData = database.cigaretteLogDao().getUnsyncedLogs()
            SyncManager.uploadLogs(localData)
            database.cigaretteLogDao().markAsSynced(localData.map { it.id })

            setProgress(workDataOf("progress" to 100))
            Result.success()
        } catch (e: IOException) {
            if (runAttemptCount < 3) Result.retry()
            else Result.failure(workDataOf("error" to e.message))
        } catch (e: Exception) {
            Result.failure(workDataOf("error" to e.message))
        }
    }
}

// Schedule periodic sync
fun schedulePeriodicSync(context: Context) {
    val constraints = Constraints.Builder()
        .setRequiredNetworkType(NetworkType.CONNECTED)
        .setRequiresBatteryNotLow(true)
        .build()

    val syncRequest = PeriodicWorkRequestBuilder<CigaretteSyncWorker>(
        repeatInterval = 1,
        repeatIntervalTimeUnit = TimeUnit.HOURS,
        flexTimeInterval = 15,
        flexTimeIntervalUnit = TimeUnit.MINUTES
    )
        .setConstraints(constraints)
        .setBackoffCriteria(
            BackoffPolicy.EXPONENTIAL,
            WorkRequest.MIN_BACKOFF_MILLIS,
            TimeUnit.MILLISECONDS
        )
        .addTag("cigarette_sync")
        .build()

    WorkManager.getInstance(context).enqueueUniquePeriodicWork(
        "cigarette_periodic_sync",
        ExistingPeriodicWorkPolicy.KEEP,
        syncRequest
    )
}

// One-time immediate sync
fun syncNow(context: Context) {
    val syncRequest = OneTimeWorkRequestBuilder<CigaretteSyncWorker>()
        .setConstraints(
            Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()
        )
        .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
        .build()

    WorkManager.getInstance(context).enqueueUniqueWork(
        "cigarette_immediate_sync",
        ExistingWorkPolicy.REPLACE,
        syncRequest
    )
}

// Observe work status
WorkManager.getInstance(context)
    .getWorkInfoByIdLiveData(syncRequest.id)
    .observe(lifecycleOwner) { info ->
        when (info?.state) {
            WorkInfo.State.RUNNING -> showSyncProgress()
            WorkInfo.State.SUCCEEDED -> showSyncComplete()
            WorkInfo.State.FAILED -> showSyncError()
            else -> { }
        }
    }
```

---

### 94. Battery Impact & User Control

| Pattern | Regle | Impact batterie |
|---------|-------|-----------------|
| Background refresh | 15-60 min intervals | Faible (~1%/h) |
| Significant location | Cell tower changes only | Tres faible (~0.5%/h) |
| Continuous GPS | GPS continu haute precision | Eleve (5-15%/h) |
| Foreground service | Notification visible obligatoire | Moyen (2-5%/h) |
| Silent push | Server-triggered, ~30s execution | Negligeable |
| Periodic WorkManager | 15 min+ intervals | Faible (~1%/h) |
| Sensor monitoring (watch) | Accelerometre continu | Moyen (2-4%/h) |

**User Control UI (Settings screen):**

| Setting | Options | Default | Description affichee |
|---------|---------|---------|---------------------|
| Background sync | On / Off | On | "Sync data in the background" |
| Sync frequency | 15min / 30min / 1h / Manual | 30min | "How often to sync automatically" |
| Location tracking | Always / While Using / Never | While Using | "When to track your location" |
| Craving zone alerts | On / Off | Off | "Alert when entering trigger zones" |
| Battery saver mode | On / Off | Off | "Reduce background activity" |

**Battery Saver Mode Behavior:**

| Feature | Normal | Battery Saver |
|---------|--------|---------------|
| Sync frequency | User preference | 1h minimum |
| Location | User preference | Significant changes only |
| Geofencing | Active | Disabled |
| Widgets | 15min refresh | 30min refresh |
| Live Activity updates | Real-time | Reduced frequency |
| Analytics | Real-time | Batched |

**Checklist Background Processing:**
- [ ] Background tasks registered au lancement (BGTaskScheduler / WorkManager)
- [ ] Constraints appropriees (network, battery, charging)
- [ ] Retry avec backoff exponentiel (max 3 tentatives)
- [ ] User peut desactiver le background processing dans Settings
- [ ] Battery impact communique clairement dans Settings
- [ ] Foreground service avec notification descriptive (Android)
- [ ] Silent push pour sync server-triggered
- [ ] Background URLSession / WorkManager pour uploads/downloads
- [ ] Battery saver mode reduit l'activite background
- [ ] Expiration handler pour cleanup si task interrompue (iOS)

---

## AK. Data Persistence & Storage

### 95. iOS Data Persistence

| Solution | Usage | Capacite | Thread Safety | Source |
|----------|-------|----------|--------------|--------|
| UserDefaults | Settings, preferences, petits flags | < 1 MB recommande | Main thread recommande | Apple Docs |
| SwiftData (iOS 17+) | Modeles complexes, relations, queries | Illimite (SQLite) | Actor-based | [Apple SwiftData](https://developer.apple.com/documentation/swiftdata) |
| Core Data | Legacy, modeles complexes | Illimite (SQLite) | NSManagedObjectContext per thread | Apple Docs |
| Keychain | Secrets, tokens, mots de passe | Items individuels | Thread-safe | Apple Docs |
| FileManager | Fichiers, images, documents | Limite par stockage device | Thread-safe | Apple Docs |
| CloudKit | Sync iCloud cross-device | 1 GB public DB, illimite private | Async | Apple Docs |
| NSUbiquitousKeyValueStore | Key-value sync iCloud | 1 MB, 1024 keys max | Thread-safe | Apple Docs |

**Code Swift (SwiftData):**
```swift
import SwiftData

@Model
class CigaretteLog {
    var timestamp: Date
    var location: String?
    var trigger: String?
    var mood: Int  // 1-5 scale
    var notes: String?
    var isSynced: Bool

    init(timestamp: Date = .now, location: String? = nil,
         trigger: String? = nil, mood: Int = 3,
         notes: String? = nil, isSynced: Bool = false) {
        self.timestamp = timestamp
        self.location = location
        self.trigger = trigger
        self.mood = mood
        self.notes = notes
        self.isSynced = isSynced
    }
}

@Model
class DailyGoal {
    var date: Date
    var limit: Int
    @Relationship(deleteRule: .cascade) var logs: [CigaretteLog]

    init(date: Date = .now, limit: Int = 10, logs: [CigaretteLog] = []) {
        self.date = date
        self.limit = limit
        self.logs = logs
    }
}

// Container setup
@main
struct InfernalWheelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [CigaretteLog.self, DailyGoal.self])
    }
}

// Queries
struct StatsView: View {
    @Query(sort: \CigaretteLog.timestamp, order: .reverse)
    var allLogs: [CigaretteLog]

    @Query(filter: #Predicate<CigaretteLog> { log in
        log.timestamp > Calendar.current.startOfDay(for: .now)
    }, sort: \CigaretteLog.timestamp)
    var todayLogs: [CigaretteLog]

    @Query(filter: #Predicate<CigaretteLog> { !$0.isSynced })
    var unsyncedLogs: [CigaretteLog]

    @Environment(\.modelContext) var context

    func logCigarette(trigger: String?, mood: Int) {
        let log = CigaretteLog(trigger: trigger, mood: mood)
        context.insert(log)
        try? context.save()
    }
}
```

---

### 96. Android Data Persistence

| Solution | Usage | API | Source |
|----------|-------|-----|--------|
| DataStore (Preferences) | Key-value settings | `datastore-preferences` | [Android DataStore](https://developer.android.com/topic/libraries/architecture/datastore) |
| DataStore (Proto) | Typed settings avec schema | `datastore` + protobuf | Android Docs |
| Room | Base de donnees relationnelle | `room-runtime`, `room-ktx` | [Android Room](https://developer.android.com/training/data-storage/room) |
| EncryptedSharedPreferences | Secrets, tokens | `security-crypto` | Android Docs |
| Android Keystore | Cles cryptographiques | `KeyStore` API | Android Docs |
| Firebase Firestore | Sync cloud real-time | Firebase SDK | Firebase Docs |
| SharedPreferences | Legacy key-value (prefer DataStore) | Android framework | Android Docs |

**Code Kotlin (Room complet):**
```kotlin
@Entity(tableName = "cigarette_logs")
data class CigaretteLog(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "timestamp") val timestamp: Long = System.currentTimeMillis(),
    val location: String? = null,
    val trigger: String? = null,
    val mood: Int = 3,
    val notes: String? = null,
    @ColumnInfo(name = "is_synced") val isSynced: Boolean = false
)

@Dao
interface CigaretteLogDao {
    @Query("SELECT * FROM cigarette_logs ORDER BY timestamp DESC")
    fun getAllLogs(): Flow<List<CigaretteLog>>

    @Query("SELECT * FROM cigarette_logs WHERE timestamp >= :startOfDay ORDER BY timestamp")
    fun getTodayLogs(startOfDay: Long): Flow<List<CigaretteLog>>

    @Query("SELECT COUNT(*) FROM cigarette_logs WHERE timestamp >= :startOfDay")
    fun getTodayCount(startOfDay: Long): Flow<Int>

    @Query("SELECT * FROM cigarette_logs WHERE is_synced = 0")
    suspend fun getUnsyncedLogs(): List<CigaretteLog>

    @Insert
    suspend fun insert(log: CigaretteLog): Long

    @Update
    suspend fun update(log: CigaretteLog)

    @Delete
    suspend fun delete(log: CigaretteLog)

    @Query("UPDATE cigarette_logs SET is_synced = 1 WHERE id IN (:ids)")
    suspend fun markAsSynced(ids: List<Long>)

    @Query("""
        SELECT trigger, COUNT(*) as count
        FROM cigarette_logs
        WHERE trigger IS NOT NULL AND timestamp >= :since
        GROUP BY trigger
        ORDER BY count DESC
    """)
    fun getTriggerStats(since: Long): Flow<List<TriggerStat>>
}

@Database(
    entities = [CigaretteLog::class],
    version = 2,
    autoMigrations = [AutoMigration(from = 1, to = 2)]
)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {
    abstract fun cigaretteLogDao(): CigaretteLogDao
}

// Build with migration
val db = Room.databaseBuilder(context, AppDatabase::class.java, "infernal_wheel")
    .addMigrations(MIGRATION_1_2)
    .build()

val MIGRATION_1_2 = object : Migration(1, 2) {
    override fun migrate(db: SupportSQLiteDatabase) {
        db.execSQL("ALTER TABLE cigarette_logs ADD COLUMN notes TEXT")
    }
}
```

**Code Kotlin (DataStore Preferences):**
```kotlin
val Context.dataStore by preferencesDataStore(name = "settings")

object PrefsKeys {
    val DAILY_LIMIT = intPreferencesKey("daily_limit")
    val NOTIFICATIONS_ENABLED = booleanPreferencesKey("notifications_enabled")
    val SYNC_INTERVAL = stringPreferencesKey("sync_interval")
    val ONBOARDING_COMPLETE = booleanPreferencesKey("onboarding_complete")
    val LAST_SYNC = longPreferencesKey("last_sync")
}

// Read
val dailyLimit: Flow<Int> = context.dataStore.data.map { prefs ->
    prefs[PrefsKeys.DAILY_LIMIT] ?: 10
}

// Write
suspend fun setDailyLimit(limit: Int) {
    context.dataStore.edit { prefs ->
        prefs[PrefsKeys.DAILY_LIMIT] = limit
    }
}

// Read multiple values
val settings: Flow<AppSettings> = context.dataStore.data.map { prefs ->
    AppSettings(
        dailyLimit = prefs[PrefsKeys.DAILY_LIMIT] ?: 10,
        notificationsEnabled = prefs[PrefsKeys.NOTIFICATIONS_ENABLED] ?: true,
        syncInterval = prefs[PrefsKeys.SYNC_INTERVAL] ?: "30min"
    )
}
```

---

### 97. Data Migration & Cache Management

| Pattern | iOS | Android |
|---------|-----|---------|
| Schema migration | SwiftData: `VersionedSchema` + `MigrationPlan` | Room: `Migration(from, to)` or `autoMigrations` |
| Lightweight migration | Automatic si rename/add column | `@AutoMigration(from = 1, to = 2)` Room 2.4+ |
| Destructive migration | `ModelContainer` sans migration plan | `.fallbackToDestructiveMigration()` |
| Cache eviction | `URLCache`, custom LRU | `DiskLruCache`, Coil/Glide cache |
| Cache size | URLCache: 50-100 MB typique | Disk cache: 50-250 MB |
| Image cache | NSCache (memory) + FileManager (disk) | Coil `MemoryCache` + `DiskCache` |
| Max app storage | Visible dans iOS Settings | Visible dans Android Settings > Storage |
| Clear cache | Offrir "Clear Cache" dans app Settings | Offrir "Clear Cache" dans app Settings |

**SwiftData Migration:**
```swift
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [CigaretteLogV1.self]
    }

    @Model class CigaretteLogV1 {
        var timestamp: Date
        var mood: Int
    }
}

enum SchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] {
        [CigaretteLog.self]  // Current model with notes field
    }
}

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self
    )
}
```

**Secure Storage Comparison:**

| Donnee | iOS | Android |
|--------|-----|---------|
| Auth token | Keychain (`kSecClassGenericPassword`) | EncryptedSharedPreferences |
| API key | Keychain | Android Keystore + EncryptedSharedPreferences |
| User password | Keychain (`kSecAttrAccessibleAfterFirstUnlock`) | EncryptedSharedPreferences |
| Biometric-protected | Keychain + `kSecAccessControlBiometryAny` | Keystore + `setUserAuthenticationRequired(true)` |
| Encryption key | Keychain | Android Keystore (hardware-backed) |
| Health data | Keychain + encrypted Core Data/SwiftData | Room + SQLCipher ou EncryptedFile |

**Code Swift (Keychain):**
```swift
func saveToKeychain(key: String, value: String) throws {
    let data = value.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: data,
        kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
    ]
    SecItemDelete(query as CFDictionary) // Remove existing
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
        throw KeychainError.saveFailed(status)
    }
}

func readFromKeychain(key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    guard status == errSecSuccess, let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
}
```

**Checklist Data Persistence:**
- [ ] UserDefaults/DataStore uniquement pour petites donnees simples (< 1 MB)
- [ ] SwiftData/Room pour donnees structurees avec relations
- [ ] Secrets dans Keychain/EncryptedSharedPreferences (jamais en clair)
- [ ] Migration plan pour chaque changement de schema
- [ ] Tested: migration de version N-1 a N
- [ ] Cache eviction policy definie (taille max, TTL)
- [ ] "Clear Cache" disponible dans Settings de l'app
- [ ] CloudKit/Firestore pour sync cross-device si necessaire
- [ ] Backup exclusions configurees (caches pas dans backup)
- [ ] Health data encrypted at rest

---

## AL. Security Mobile

### 98. Transport & Network Security

| Parametre | iOS | Android |
|-----------|-----|---------|
| HTTPS enforce | App Transport Security (ATS) par defaut | `networkSecurityConfig` in AndroidManifest |
| Certificate pinning | URLSession delegate + `didReceive challenge` | OkHttp `CertificatePinner` |
| ATS exceptions | `NSAppTransportSecurity` dans Info.plist | `<domain-config cleartextTrafficPermitted>` |
| TLS version min | TLS 1.2 (ATS default) | TLS 1.2 recommande |
| Debug bypass | `NSAllowsLocalNetworking` pour dev | `<debug-overrides>` dans network security config |
| Forward secrecy | Required par ATS | Recommande |
| Certificate transparency | Supported iOS 12.1.1+ | Supported Android 10+ |

**Code Swift (certificate pinning):**
```swift
class PinnedSessionDelegate: NSObject, URLSessionDelegate {
    // Pin the Subject Public Key Info (SPKI) hash
    let pinnedHashes: Set<String> = [
        "sha256/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=",  // Primary
        "sha256/YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY="   // Backup
    ]

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod ==
                NSURLAuthenticationMethodServerTrust,
              let trust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.cancelAuthenticationChallenge,
---

## AM. Testing & Quality Mobile

### 101. UI Testing

| Framework | Plateforme | Type | Source |
|-----------|-----------|------|--------|
| XCUITest | iOS | UI automation native | [Apple XCTest](https://developer.apple.com/documentation/xctest) |
| Espresso | Android (Views) | UI automation native | [Android Espresso](https://developer.android.com/training/testing/espresso) |
| Compose Testing | Android (Compose) | UI automation native | Android Compose Test |
| Maestro | Cross-platform | Flow-based, YAML config | [Maestro](https://maestro.mobile.dev/) |
| Appium | Cross-platform | WebDriver protocol | Appium.io |
| Detox | React Native | Grey-box testing | Wix Detox |

**Code Swift (XCUITest):**
```swift
import XCTest

class CigaretteTrackerUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    func testLogCigarette() throws {
        let logButton = app.buttons["Log Cigarette"]
        XCTAssertTrue(logButton.waitForExistence(timeout: 5))
        logButton.tap()

        let counter = app.staticTexts["cigaretteCount"]
        XCTAssertEqual(counter.label, "1")
    }

    func testViewStats() throws {
        app.tabBars.buttons["Stats"].tap()
        let chartView = app.otherElements["weeklyChart"]
        XCTAssertTrue(chartView.waitForExistence(timeout: 5))
    }
}
```

**Code Kotlin (Compose Testing):**
```kotlin
@get:Rule
val composeTestRule = createComposeRule()

@Test
fun testLogCigarette() {
    composeTestRule.setContent {
        InfernalWheelTheme {
            CigaretteTrackerScreen()
        }
    }

    composeTestRule
        .onNodeWithText("Log Cigarette")
        .assertIsDisplayed()
        .performClick()

    composeTestRule
        .onNodeWithTag("cigaretteCount")
        .assertTextEquals("1")
}
```

**Maestro (YAML, cross-platform):**
```yaml
appId: com.app.infernalwheel
---
- launchApp
- assertVisible: "Log Cigarette"
- tapOn: "Log Cigarette"
- assertVisible: "1"
- tapOn: "Stats"
- assertVisible: "Weekly Overview"
```

---

### 102. Snapshot Testing

| Outil | Plateforme | Avantage |
|-------|-----------|----------|
| swift-snapshot-testing (Point-Free) | iOS | SwiftUI + UIKit, multiple strategies |
| Paparazzi (Cash App) | Android | No device needed, fast, Compose support |
| Shot (Karumi) | Android | On-device, accurate rendering |
| Percy (BrowserStack) | Cross-platform | Cloud-based visual review + approval |

**Code Swift (snapshot test):**
```swift
import SnapshotTesting
import XCTest

class PaywallSnapshotTests: XCTestCase {
    func testPaywallLight() {
        let view = PaywallView()
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }

    func testPaywallDark() {
        let view = PaywallView()
        assertSnapshot(of: view, as: .image(
            layout: .device(config: .iPhone13),
            traits: .init(userInterfaceStyle: .dark)
        ))
    }

    func testPaywallAccessibility() {
        let view = PaywallView()
        assertSnapshot(of: view, as: .image(
            layout: .device(config: .iPhone13),
            traits: .init(preferredContentSizeCategory: .accessibilityExtraLarge)
        ))
    }
}
```

**Code Kotlin (Paparazzi):**
```kotlin
class PaywallSnapshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.PIXEL_6,
        theme = "Theme.InfernalWheel"
    )

    @Test
    fun paywallLight() {
        paparazzi.snapshot {
            InfernalWheelTheme(darkTheme = false) { PaywallScreen() }
        }
    }

    @Test
    fun paywallDark() {
        paparazzi.snapshot {
            InfernalWheelTheme(darkTheme = true) { PaywallScreen() }
        }
    }
}
```

---

### 103. Performance & Crash Monitoring

| Outil | Type | Plateforme |
|-------|------|-----------|
| Instruments | Profiling (CPU, Memory, Network, Energy, Leaks) | iOS |
| Android Profiler | Profiling (CPU, Memory, Network, Energy) | Android |
| Crashlytics | Crash reporting + analytics | iOS + Android |
| Sentry | Error tracking + performance + replays | iOS + Android |
| MetricKit | System-collected performance + diagnostics | iOS 13+ |
| JankStats | Frame timing and jank detection | Android Jetpack |
| LeakCanary | Memory leak detection (debug builds) | Android |

**Performance Budgets:**

| Metrique | Cible | Outil de mesure |
|----------|-------|-----------------|
| Cold start | < 400ms (iOS), < 500ms (Android) | Instruments / Macrobenchmark |
| Warm start | < 200ms | Time Profiler / Macrobenchmark |
| Frame rate | 60 fps constant (120 fps ProMotion) | Core Animation / JankStats |
| Jank frames | < 1% frames > 16ms | MetricKit / JankStats |
| Memory peak | < 150 MB typical usage | Memory Profiler |
| App binary size | < 50 MB download, < 200 MB install | App Store Connect / Play Console |
| ANR rate | N/A | < 0.5% (Android Vitals) |
| Crash-free rate | > 99.9% | > 99.9% |

**Beta Distribution:**

| Canal | iOS | Android |
|-------|-----|---------|
| Internal | TestFlight internal group (max 100) | Internal App Sharing (link-based) |
| Closed beta | TestFlight external (max 10,000) | Closed testing track |
| Open beta | TestFlight public link | Open testing track |
| CI/CD | Xcode Cloud, Fastlane, Bitrise | GitHub Actions, Fastlane, Bitrise |

**Checklist Testing & Quality:**
- [ ] UI tests pour les flows critiques (log, onboarding, purchase)
- [ ] Snapshot tests pour ecrans principaux (light + dark + accessibility)
- [ ] Accessibility audit avec Accessibility Inspector (iOS) / Scanner (Android)
- [ ] Performance: startup < 500ms, 60fps, < 150MB RAM
- [ ] Memory leak detection (Instruments Leaks / LeakCanary)
- [ ] Crash reporting integre (Crashlytics / Sentry)
- [ ] Beta testing via TestFlight / Play Console tracks
- [ ] ANR rate < 0.5% (Android)
- [ ] Crash-free rate > 99.9%

---

## AN. App Architecture UX Impact

### 104. Navigation Architecture

| Pattern | iOS | Android | UX Impact |
|---------|-----|---------|-----------|
| Coordinator | Protocol-based coordinators | N/A (NavGraph) | Deep links propres, testable |
| Router | Enum-based routing (typesafe) | Type-safe Navigation (Compose 2.8+) | URL-mappable, compile-time safe |
| Tab-based | UITabBarController / TabView | NavigationBar + NavHost per tab | Max 5 tabs, direct access |
| Stack | NavigationStack (SwiftUI) | NavHost with back stack | Clear hierarchy |
| Modal | Sheet / fullScreenCover | Dialog / BottomSheet | Secondary tasks |

**State Restoration:**

| Parametre | iOS | Android |
|-----------|-----|---------|
| API | NSUserActivity / `@SceneStorage` | SavedStateHandle / `rememberSaveable` |
| Automatic | SwiftUI `@SceneStorage` persists across kills | `rememberSaveable` survives process death |
| Navigation | NavigationPath codable serialization | NavController saved state (automatic) |

**Code Swift (state restoration):**
```swift
struct ContentView: View {
    @SceneStorage("selectedTab") var selectedTab: String = "home"

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag("home")
                .tabItem { Label("Home", systemImage: "house") }
            StatsView().tag("stats")
                .tabItem { Label("Stats", systemImage: "chart.bar") }
            SettingsView().tag("settings")
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
```

**Code Kotlin (saved state):**
```kotlin
@HiltViewModel
class TrackerViewModel @Inject constructor(
    private val savedStateHandle: SavedStateHandle,
    private val repository: CigaretteRepository
) : ViewModel() {
    val count = savedStateHandle.getStateFlow("count", 0)
    fun incrementCount() {
        savedStateHandle["count"] = (count.value) + 1
    }
}
```

---

### 105. Feature Flags & Remote Config

| Solution | Plateforme | Pricing |
|----------|-----------|---------|
| Firebase Remote Config | iOS + Android | Free |
| LaunchDarkly | Cross-platform | Paid (enterprise) |
| Statsig | Cross-platform | Free tier + paid |
| Unleash | Cross-platform | Open-source + paid |

**Feature Flag UX Patterns:**

| Pattern | Description | Usage |
|---------|-------------|-------|
| Kill switch | Disable feature remotely en < 1 min | Bug in production |
| Gradual rollout | 1% -> 10% -> 50% -> 100% | New feature launch |
| A/B test | 2+ variantes avec analytics | Paywall design, onboarding |
| User targeting | Segments specifiques | Premium beta, locale-specific |
| Maintenance mode | UI banner + feature disable | Server downtime |

**Checklist Architecture UX:**
- [ ] Navigation state restaure apres process death
- [ ] Deep links routes via architecture centralisee
- [ ] Feature flags pour rollout progressif
- [ ] Kill switch disponible pour chaque feature majeure
- [ ] Error boundaries isolent les crashes
- [ ] Analytics events standardises
- [ ] Remote config pour ajustements sans app update
- [ ] Form data preserved on process death

---

## AO. Adaptive Icons & App Identity

### 106. iOS App Icon System

| Context | Taille (@2x) | Taille (@3x) | Usage |
|---------|-------------|-------------|-------|
| App Store | 1024x1024 px | -- | Store listing |
| Home Screen iPhone | 120x120 px | 180x180 px | Home screen |
| Home Screen iPad | 152x152 px | -- | iPad |
| Settings | 58x58 px | 87x87 px | Settings app |
| Spotlight | 80x80 px | 120x120 px | Search results |
| Notification | 40x40 px | 60x60 px | Notification banner |

**iOS 18+ Icon Variants:**

| Variant | Description |
|---------|-------------|
| Light | Standard icon (default) |
| Dark | Dark-adapted version (iOS 18+) |
| Tinted | Monochrome + user tint color (iOS 18+) |

---

### 107. Android Adaptive Icons

| Layer | Taille | Description |
|-------|--------|-------------|
| Foreground | 108x108 dp (72dp safe zone) | Logo, symbole principal |
| Background | 108x108 dp | Couleur, gradient, pattern |
| Monochrome | 108x108 dp | Android 13+ themed icons |
| Masque systeme | Variable | Circle, squircle, rounded square |

**Safe Zone:** Le contenu important dans le cercle central de 72dp (66% de 108dp)

**Splash Screen API (Android 12+):**

| Parametre | Valeur |
|-----------|--------|
| Icon size | 240x240 dp (160dp visible dans masque) |
| Animation | Jusqu'a 1000ms, AnimatedVectorDrawable |
| Background | Couleur unique |

**Checklist App Identity:**
- [ ] Icon master 1024x1024 (iOS) lisible meme a 29pt
- [ ] iOS 18+ dark et tinted variants fournis
- [ ] Android adaptive icon foreground + background + monochrome
- [ ] Safe zone 72dp respectee (Android)
- [ ] Splash Screen API utilisee (Android 12+)
- [ ] Pas de texte dans l'icon
- [ ] Tester sur differents wallpapers et modes

---

## AP. Multi-Device & Continuity

### 108. Apple Handoff & Continuity

| Feature | API | Usage |
|---------|-----|-------|
| Handoff | NSUserActivity | Continuer tache sur autre device |
| Universal Clipboard | UIPasteboard (automatic) | Copier iPhone -> coller Mac |
| AirDrop | UIActivityViewController | Transfert fichiers |

**Code Swift (Handoff):**
```swift
let activity = NSUserActivity(activityType: "com.app.viewDailyStats")
activity.title = "Viewing Today's Stats"
activity.userInfo = ["date": Date().timeIntervalSince1970, "tab": "stats"]
activity.isEligibleForHandoff = true
activity.isEligibleForSearch = true
activity.isEligibleForPrediction = true
self.userActivity = activity
activity.becomeCurrent()
```

---

### 109. Cross-Device Sync Patterns

| Pattern | Solution | Latency | Offline |
|---------|----------|---------|---------|
| Real-time sync | CloudKit / Firestore | < 1s | Limited |
| Background sync | CloudKit push / FCM | Seconds-minutes | Yes (queue) |
| Conflict resolution | Last-writer-wins / CRDT | N/A | N/A |
| Offline-first | Local DB + sync queue | Deferred | Full |

**Conflict Resolution Strategies:**

| Strategie | Quand utiliser |
|-----------|---------------|
| Last-writer-wins | Donnees simples, settings |
| Server-wins | Critical business data |
| Merge | Lists, collections |
| CRDT | Collaborative editing |

**Companion Device Patterns (Phone + Watch + Tablet):**

| Device | Role | Sync Method |
|--------|------|-------------|
| Phone | Primary: full UI, analytics, settings | Cloud sync |
| Watch | Quick log, counter, live tracking | WatchConnectivity + cloud |
| Tablet | Dashboard, detailed analytics | Cloud sync |

**Checklist Multi-Device:**
- [ ] Handoff configure pour les activites cles
- [ ] Cloud sync avec conflict resolution definie
- [ ] Offline-first: donnees disponibles sans reseau
- [ ] Login shared across devices
- [ ] Watch companion sync via WatchConnectivity + cloud
- [ ] Etat de sync visible ("Last synced: 5 min ago")
- [ ] Session management: view/revoke other devices

---

## AQ. Accessibility Advanced Mobile

### 110. Switch Control & Voice Access

| Feature | iOS | Android |
|---------|-----|---------|
| Switch Control | Settings > Accessibility > Switch Control | Settings > Accessibility > Switch Access |
| Voice Control | Settings > Accessibility > Voice Control | Voice Access app (Google) |
| Full Keyboard Access | Settings > Accessibility > Keyboards | External keyboard navigation |
| Head tracking | Head-based cursor (iOS 17+) | Third-party |
| Eye tracking | Eye tracking API (iOS 18+, iPhone 16+) | N/A native |

**Optimisation Switch Control:**
- Groupes logiques via `accessibilityElements` grouping
- Ordre de scan naturel via `accessibilityElementsInNavigationOrder`
- Custom actions via `accessibilityCustomActions` pour reduire les etapes
- Large focus areas >= 44pt minimum

---

### 111. Dynamic Type Extreme Sizes

| Text Style | Default | AX1 | AX3 | AX5 |
|------------|---------|-----|-----|-----|
| Large Title | 34pt | 44pt | 52pt | 60pt |
| Title 1 | 28pt | 38pt | 48pt | 58pt |
| Body | 17pt | 28pt | 40pt | 53pt |
| Footnote | 13pt | 23pt | 33pt | 44pt |
| Caption 1 | 12pt | 22pt | 32pt | 44pt |

**Layout Strategies for Extreme Sizes:**

| Pattern | Normal Layout | AX Extreme Layout |
|---------|--------------|-------------------|
| HStack label + value | Side by side | VStack (stacked vertically) |
| Table cells | Fixed height 44pt | Self-sizing (automaticDimension) |
| Action buttons | Side by side HStack | Stacked VStack |
| Icons + text | Icon leading, text trailing | Icon above, text below |
| Tabs | All visible | Scrollable tab bar |

**Code SwiftUI (adaptive layout):**
```swift
struct AdaptiveStatRow: View {
    @Environment(\.dynamicTypeSize) var typeSize
    let label: String
    let value: String

    var body: some View {
        if typeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: 8) {
                Text(label).font(.headline)
                Text(value).font(.title2.bold())
            }
        } else {
            HStack {
                Text(label)
                Spacer()
                Text(value).font(.headline)
            }
        }
    }
}
```

**Code Kotlin (adaptive for large fonts):**
```kotlin
@Composable
fun AdaptiveStatRow(label: String, value: String) {
    val fontScale = LocalDensity.current.fontScale
    if (fontScale > 1.5f) {
        Column(modifier = Modifier.padding(vertical = 8.dp)) {
            Text(label, style = MaterialTheme.typography.titleSmall)
            Text(value, style = MaterialTheme.typography.headlineSmall, fontWeight = FontWeight.Bold)
        }
    } else {
        Row(modifier = Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
            Text(label, style = MaterialTheme.typography.bodyLarge)
            Spacer()
            Text(value, style = MaterialTheme.typography.titleMedium)
        }
    }
}
```

---

### 112. Smart Invert & High Contrast

| Mode | iOS | Android | Impact |
|------|-----|---------|--------|
| Smart Invert | Inverts except images/video/maps | N/A (Dark theme) | UI elements inverted |
| Increase Contrast | Stronger borders, darker colors | High Contrast Text | Better separation |
| Reduce Transparency | Solid backgrounds | Reduce transparency | Readability |
| Bold Text | All system text bold | Bold Text toggle | Legibility |
| Button Shapes | Underlines on interactive text | N/A | Discoverability |
| Differentiate Without Color | Icons/shapes supplement color | N/A | Color-blind support |

**Smart Invert Compatibility (iOS):**
```swift
imageView.accessibilityIgnoresInvertColors = true
mapView.accessibilityIgnoresInvertColors = true

// SwiftUI
Image("photo").accessibilityIgnoresInvertColors()
```

**Checklist Accessibility Advanced:**
- [ ] Switch Control: scan order logique, groupes pertinents
- [ ] Voice Control: tous les boutons ont labels descriptifs
- [ ] Dynamic Type AX5: layout s'adapte (vertical stacking)
- [ ] Self-sizing cells pour Dynamic Type
- [ ] Smart Invert: images/videos/maps marques ignoresInvertColors
- [ ] Bold Text: layout ne casse pas
- [ ] Increase Contrast: bordures et separateurs visibles
- [ ] Differentiate Without Color: icons/patterns supplement color
- [ ] WCAG 2.2 AA minimum
- [ ] Contrast ratio >= 4.5:1 (normal text), >= 3:1 (large text, UI)
- [ ] Orientation non verrouillee (sauf necessite)

---

## AR. Valeurs Cles Mobile (Memo Rapide)

### 113. Touch Targets & Spacing

| Valeur | iOS | Android | Notes |
|--------|-----|---------|-------|
| Touch target min | 44x44 pt | 48x48 dp | Apple HIG / M3 |
| Touch target WCAG AA | 24x24 px min | 24x24 px min | WCAG 2.5.8 |
| Espacement entre cibles | >= 8 pt | >= 8 dp | Eviter erreurs de tap |
| Marge laterale ecran | 16 pt (compact) / 20 pt (regular) | 16 dp | Layout margins |
| Bottom nav height | 49 pt | 80 dp | Composant systeme |
| Top app bar height | 44 pt | 64 dp | Standard |
| FAB size | N/A natif | 56 dp (regular) / 96 dp (large) | M3 FAB |
| Search bar height | 36 pt | 56 dp | Standard |

### 114. Typography Quick Reference

| Style | iOS (SF Pro) | Android M3 (Roboto) |
|-------|-------------|---------------------|
| Large Title | 34pt Bold | -- |
| Title 1 / Title Large | 28pt Bold | 22sp |
| Title 2 / Title Medium | 22pt Bold | 16sp |
| Body / Body Large | 17pt Regular | 16sp |
| Body Small | -- | 14sp |
| Footnote | 13pt Regular | -- |
| Caption 1 | 12pt Regular | -- |
| Label Large | -- | 14sp |
| Label Small | -- | 11sp |

### 115. Animation Timings

| Type | iOS | Android M3 |
|------|-----|-----------|
| Quick feedback | 100ms | 100ms |
| Standard transition | 250-350ms | 300ms |
| Complex animation | 350-500ms | 400-500ms |
| Spring default | response: 0.55, damping: 1.0 | N/A |
| Spring bouncy | response: 0.5, damping: 0.7 | N/A |
| Fade in | 200ms ease-in | 150ms LinearOutSlowIn |
| Fade out | 150ms ease-out | 75ms FastOutLinearIn |
| Reduced motion | Crossfade 200ms | Duration scale 0 |

### 116. Color & Elevation

| Parametre | iOS | Android M3 |
|-----------|-----|-----------|
| Primary bg | `systemBackground` | `surface` |
| Secondary bg | `secondarySystemBackground` | `surfaceContainer` |
| Tint/Accent | `tintColor` | `primary` |
| Destructive | `systemRed` | `error` |
| Separator | `separator` | `outlineVariant` |
| Label primary | `label` | `onSurface` |
| Label secondary | `secondaryLabel` | `onSurfaceVariant` |
| Elevation levels | 0-3 (shadow radius) | 0, 1, 3, 6, 8, 12 dp (tonal) |

### 117. Component Size Comparison

| Composant | iOS | Android M3 |
|-----------|-----|------------|
| Tab Bar / Navigation Bar | 49pt | 80dp |
| Navigation Bar / Top App Bar | 44pt | 64dp |
| Large Nav Bar | 96pt | 112dp |
| Search Bar | 36pt | 56dp |
| Text Field | 36pt | 56dp |
| Button (standard) | 34pt min | 40dp |
| Switch | 31pt h | 32dp h |
| Segmented Control | 32pt | 48dp |
| Chip | N/A | 32dp |
| Progress (linear) | 4pt | 4dp |

### 118. Platform-Specific Values

| Parametre | iOS | Android |
|-----------|-----|---------|
| Status bar height | 59pt (Dynamic Island) / 47pt (notch) | 24dp (default) |
| Home indicator zone | 34pt bottom | 48dp gesture bar |
| Keyboard height | ~291pt (iPhone) | ~260dp (varies) |
| Screen density | @2x, @3x | mdpi-xxxhdpi |
| iPhone 15 Pro | 393x852 pt | Pixel 8: 412x915 dp |
| Corner radius | ~55pt (iPhone 15) | Varies |

### 119. Checklist Rapide Universel

**Pre-release -- Obligatoire:**
- [ ] Touch targets >= 44pt (iOS) / 48dp (Android) partout
- [ ] Dynamic Type / font scaling teste de xSmall a AX5
- [ ] Dark mode complet (semantic colors)
- [ ] VoiceOver / TalkBack: tous les ecrans navigables
- [ ] Reduce Motion respecte
- [ ] Offline mode: donnees cachees, sync queue
- [ ] Deep links fonctionnels
- [ ] Permissions demandees en contexte
- [ ] Error states et empty states couverts
- [ ] Performance: cold start < 500ms, 60fps, < 150MB RAM
- [ ] Keyboard handling correct
- [ ] Safe areas respectees
- [ ] Back gesture fonctionne

**Post-release -- Monitoring:**
- [ ] Crash-free rate > 99.9%
- [ ] ANR rate < 0.5% (Android)
- [ ] Rating >= 4.0 etoiles
- [ ] Privacy labels / Data safety a jour
- [ ] Feature flags operationnels
- [ ] Beta channel actif

**Valeurs a retenir (top 10):**

| # | Valeur | iOS | Android |
|---|--------|-----|---------|
| 1 | Touch target min | 44x44 pt | 48x48 dp |
| 2 | Marge laterale | 16 pt | 16 dp |
| 3 | Espacement cibles | >= 8 pt | >= 8 dp |
| 4 | Body text | 17pt SF Pro | 16sp Roboto |
| 5 | Animation standard | 300ms | 300ms |
| 6 | Spring default | response 0.55, damping 1.0 | N/A |
| 7 | Tab bar / nav bar | 49pt | 80dp |
| 8 | Top app bar | 44pt | 64dp |
| 9 | Contrast ratio min | 4.5:1 text | 4.5:1 text |
| 10 | Cold start budget | < 400ms | < 500ms |

---

*MOBILE.md - Bible complete iOS + Android - sections A-AR, 119 subsections*

## AS. Color & Theming System

### Dynamic Color Overview

| Platform | System | API | Min Version |
|----------|--------|-----|-------------|
| Android | Material You | `dynamicDarkColorScheme()` / `dynamicLightColorScheme()` | Android 12 (API 31) |
| iOS | Tint System | `UIView.tintColor` / `.tint()` | iOS 7+ (SwiftUI iOS 15+) |

### M3 Color Roles

| Role | Usage | Light Token Example | Dark Token Example |
|------|-------|---------------------|--------------------|
| Primary | Key actions, FAB, active states | `#6750A4` | `#D0BCFF` |
| On Primary | Text/icon on primary | `#FFFFFF` | `#381E72` |
| Primary Container | Tonal fill behind primary elements | `#EADDFF` | `#4F378B` |
| On Primary Container | Text/icon on primary container | `#21005D` | `#EADDFF` |
| Secondary | Less prominent components | `#625B71` | `#CCC2DC` |
| Secondary Container | Tonal fill, chips, filter | `#E8DEF8` | `#4A4458` |
| Tertiary | Contrast accent, complement | `#7D5260` | `#EFB8C8` |
| Tertiary Container | Tertiary tonal fill | `#FFD8E4` | `#633B48` |
| Surface | Backgrounds, cards | `#FFFBFE` | `#1C1B1F` |
| Surface Variant | Dividers, subtle fills | `#E7E0EC` | `#49454F` |
| Error | Destructive / error states | `#B3261E` | `#F2B8B5` |
| On Error | Text/icon on error | `#FFFFFF` | `#601410` |
| Outline | Borders, dividers | `#79747E` | `#938F99` |
| Outline Variant | Subtle dividers | `#CAC4D0` | `#49454F` |

### Surface Elevation Tint (M3)

| Elevation Level | dp | Tint Opacity (Dark) | Tint Opacity (Light) |
|----------------|-----|----------------------|----------------------|
| 0 | 0 | 0% | 0% |
| 1 | 1 | 5% | 5% |
| 2 | 3 | 8% | 8% |
| 3 | 6 | 11% | 11% |
| 4 | 8 | 12% | 12% |
| 5 | 12 | 14% | 14% |

### Design Token Naming Convention

```
color.<role>.<variant>
color.surface.default          → #FFFBFE
color.surface.elevated         → #FFFBFE + tint overlay
color.surface.container.low    → #F7F2FA
color.surface.container.high   → #ECE6F0
color.on.surface               → #1C1B1F
color.primary.default          → #6750A4
color.primary.container        → #EADDFF
color.on.primary.container     → #21005D
```

### Kotlin — Dynamic Color

```kotlin
@Composable
fun AppTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val darkTheme = isSystemInDarkTheme()
    val colorScheme = when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && darkTheme ->
            dynamicDarkColorScheme(context)
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ->
            dynamicLightColorScheme(context)
        darkTheme -> darkColorScheme(
            primary = Color(0xFFD0BCFF),
            secondary = Color(0xFFCCC2DC),
            tertiary = Color(0xFFEFB8C8)
        )
        else -> lightColorScheme(
            primary = Color(0xFF6750A4),
            secondary = Color(0xFF625B71),
            tertiary = Color(0xFF7D5260)
        )
    }
    MaterialTheme(colorScheme = colorScheme, content = content)
}
```

### Swift — Dynamic Color Assets

```swift
// In Asset Catalog: define color set with Any/Dark appearances
// Programmatic approach:
extension Color {
    static let surfacePrimary = Color("SurfacePrimary")
    static let onSurface = Color("OnSurface")
}

// SwiftUI tint
NavigationStack {
    ContentView()
}
.tint(.indigo) // global tint

// Per-view override
Button("Action") { }
    .tint(.mint)
```

### Brand Color → M3 Mapping

1. Input brand primary hex into Material Theme Builder (material-foundation/material-theme-builder)
2. Tool generates full tonal palette (0–100 lightness, 13 tones)
3. Map tonal values to roles: Primary = tone 40 (light) / tone 80 (dark)
4. Container = tone 90 (light) / tone 30 (dark)
5. Export as Compose Theme / XML / SwiftUI Color extension

### Contrast & Accessibility

| Ratio | Usage | WCAG Level |
|-------|-------|------------|
| 4.5:1 | Body text (<24px / <18.66px bold) | AA |
| 3:1 | Large text (≥24px / ≥18.66px bold), UI components | AA |
| 7:1 | Body text | AAA |
| 3:1 | Non-text contrast (icons, borders, controls) | AA |

**Tooling:**
- Figma: Stark plugin, A11y Color Contrast Checker
- Android: Accessibility Scanner, `MaterialColors.getColorRoles()`
- iOS: Accessibility Inspector (Xcode), `UIColor.resolvedColor(with:)`

### Checklist

- ✅ Support both light and dark color schemes
- ✅ Use semantic color tokens, never hardcoded hex in UI code
- ✅ All text meets 4.5:1 contrast on its background
- ✅ Non-text elements (icons, borders) meet 3:1
- ✅ Dynamic Color supported on Android 12+ with static fallback
- ✅ High Contrast mode tested (iOS Increase Contrast, Android high-contrast text)
- ✅ Color is never the sole information carrier (use icons/labels too)
- ❌ Don't use pure black `#000000` on pure white `#FFFFFF` in dark mode (eye strain)
- ❌ Don't rely on wallpaper-extracted color for brand-critical elements
- ❌ Don't skip testing all surface elevation levels in dark mode

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Hardcoded hex values in views | Breaks dark mode, no theme support | Use semantic tokens |
| Only testing light mode | Dark mode colors untested | Test both systematically |
| Brand color at full saturation on surfaces | Fails contrast, fatigues eyes | Use tonal mapping |
| Ignoring dynamic color fallback | Crashes or blank on Android <12 | Always provide static fallback |
| Same color for error + destructive + warning | Ambiguous meaning | Distinct semantic roles |

### Sources

- Material Design 3 Color System: m3.material.io/styles/color
- Apple HIG — Color: developer.apple.com/design/human-interface-guidelines/color
- WCAG 2.1 Contrast: w3.org/WAI/WCAG21/Understanding/contrast-minimum
- Material Theme Builder: material-foundation/material-theme-builder

---

## AT. Iconography System

### SF Symbols (iOS/macOS)

| Property | Values | Default |
|----------|--------|---------|
| Weight | ultraLight / thin / light / regular / medium / semibold / bold / heavy / black | regular |
| Scale | small / medium / large | medium |
| Rendering Mode | monochrome / hierarchical / palette / multicolor | monochrome |
| Variable Value | 0.0–1.0 (progressive fill, e.g. speaker volume) | none |
| Version | SF Symbols 5 (iOS 17), 6000+ icons | — |

### Material Symbols (Android)

| Axis | Range | Default |
|------|-------|---------|
| Optical Size (opsz) | 20, 24, 40, 48 | 24 |
| Weight (wght) | 100–700 | 400 |
| Grade (GRAD) | -25 to 200 | 0 |
| Fill | 0 (outlined) or 1 (filled) | 0 |

### Icon Sizing Table

| Context | Size (dp/pt) | Touch Target (dp/pt) | Notes |
|---------|-------------|----------------------|-------|
| Inline with body text | 16–18 | — | Align to text baseline |
| List item leading | 24 | 48 | Standard content icon |
| Toolbar / App Bar | 24 | 48 | Navigation, action icons |
| Bottom Nav | 24 (inactive) / 24 (active) | 48 wide, full bar height | Active: filled, Inactive: outlined |
| Tab icon | 24 | 48 | Icon-only or icon+label |
| FAB mini | 24 | 40 | Mini FAB container |
| FAB standard | 24 | 56 | Standard FAB container |
| FAB large | 36 | 96 | Large FAB container |
| Empty state illustration | 48–120 | — | Decorative, not tappable |

### Custom Icon Grid

```
┌─────────────────────────┐
│  2dp padding all sides  │
│  ┌─────────────────┐    │  Live area: 20×20dp
│  │                 │    │  Total:     24×24dp
│  │   Live Area     │    │  Stroke:    2dp
│  │   20 × 20dp    │    │  Corner:    2dp radius (rounded)
│  │                 │    │  Keyline shapes:
│  └─────────────────┘    │    Circle: 20dp ø
│                         │    Square: 18×18dp
│                         │    Tall rect: 16×20dp
│                         │    Wide rect: 20×16dp
└─────────────────────────┘
```

### Icon-to-Text Alignment

| Technique | iOS | Android |
|-----------|-----|---------|
| Baseline alignment | `Image().baselineOffset(-2)` | `Icon(modifier = Modifier.alignByBaseline())` — not direct; use `drawableStart` on `TextView` |
| Vertical center | `Label("text", systemImage: "star")` | `Icon` inside `Row(verticalAlignment = CenterVertically)` |
| Optical padding | SF Symbols auto-align per weight | Set `opsz` = text size for optical match |
| Spacing icon→text | 8pt standard | 8dp standard |

### SwiftUI — SF Symbols

```swift
// Monochrome (tinted automatically)
Image(systemName: "heart.fill")
    .font(.system(size: 24, weight: .medium))

// Hierarchical (primary layer + reduced opacity secondary)
Image(systemName: "square.and.arrow.up")
    .symbolRenderingMode(.hierarchical)
    .foregroundStyle(.blue)

// Palette (explicit colors per layer)
Image(systemName: "person.crop.circle.badge.plus")
    .symbolRenderingMode(.palette)
    .foregroundStyle(.white, .blue)

// Multicolor (system-defined colors)
Image(systemName: "externaldrive.badge.wifi")
    .symbolRenderingMode(.multicolor)

// Variable value (0.0 to 1.0)
Image(systemName: "speaker.wave.3.fill", variableValue: 0.6)

// Symbol effect (iOS 17+)
Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative)
```

### Kotlin — Material Symbols

```kotlin
// Standard icon
Icon(
    imageVector = Icons.Outlined.Favorite,
    contentDescription = "Favorite",
    modifier = Modifier.size(24.dp),
    tint = MaterialTheme.colorScheme.onSurface
)

// Filled variant (active state)
Icon(
    imageVector = Icons.Filled.Favorite,
    contentDescription = "Favorited",
    tint = MaterialTheme.colorScheme.primary
)

// Custom variable font icon (Material Symbols)
// In build.gradle: implementation("androidx.compose.material3:material3")
// Download variable font .ttf, configure with:
// FontVariation.Setting("FILL", 1f),
// FontVariation.Setting("wght", 400f),
// FontVariation.Setting("GRAD", 0f),
// FontVariation.Setting("opsz", 24f)
```

### Icon Color Semantics

| Semantic Role | iOS Color | Android Token | Usage |
|--------------|-----------|---------------|-------|
| Primary action | `.tint` / `.accentColor` | `colorScheme.primary` | Key interactive icon |
| Default / neutral | `.secondary` label color | `colorScheme.onSurfaceVariant` | Navigation, secondary |
| Disabled | `.tertiary` label color @ 38% | `colorScheme.onSurface` @ 38% | Non-interactive |
| Error / destructive | `.red` | `colorScheme.error` | Delete, remove |
| Success | `.green` | Custom `color.success` | Checkmark, done |
| Warning | `.orange` | Custom `color.warning` | Alert triangle |

### Checklist

- ✅ Use SF Symbols on iOS and Material Symbols on Android for system consistency
- ✅ Match icon weight to adjacent font weight
- ✅ All interactive icons have 48×48dp minimum touch target
- ✅ All icons have contentDescription / accessibilityLabel (or null if decorative)
- ✅ Icons meet 3:1 contrast ratio against background
- ✅ Filled = active, Outlined = inactive for toggle states
- ✅ Custom icons follow 24dp grid with 2dp padding
- ❌ Don't mix icon families (SF Symbols on Android or vice versa)
- ❌ Don't use icons without text labels for primary navigation (unless universally understood: search, home, back)
- ❌ Don't scale raster icons; use vector (SVG/PDF → asset catalog, VectorDrawable)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Using PNG icons at fixed resolution | Blurry on high-density screens | Use SF Symbols / vector drawables |
| Icon-only buttons with no label or tooltip | Unclear meaning, accessibility failure | Add label or contentDescription |
| Different icon style per screen | Visual inconsistency | Standardize on one family+weight |
| Coloring icons arbitrarily | Breaks semantic meaning | Follow color role tokens |
| Oversized icons crammed in small spaces | Visual clutter | Use opsz axis or correct size variant |

### Sources

- SF Symbols: developer.apple.com/sf-symbols/
- Material Symbols: fonts.google.com/icons
- Material Design 3 Icons: m3.material.io/styles/icons
- Apple HIG — Icons: developer.apple.com/design/human-interface-guidelines/icons

---

## AU. Gesture Vocabulary (Complete)

### Full Gesture Catalog

| Gesture | Fingers | iOS Recognition | Android Recognition | Duration / Threshold | Haptic |
|---------|---------|-----------------|---------------------|---------------------|--------|
| Tap | 1 | `UITapGestureRecognizer` | `GestureDetector.onSingleTapConfirmed()` | < 150ms, < 10dp movement | Light impact |
| Double Tap | 1 | `UITapGestureRecognizer(numberOfTaps: 2)` | `GestureDetector.onDoubleTap()` | < 300ms between taps | Medium impact |
| Long Press | 1 | `UILongPressGestureRecognizer` | `GestureDetector.onLongPress()` | ≥ 500ms (iOS default), ≥ 400ms (Android) | Heavy impact (iOS), haptic tick (Android) |
| Swipe (directional) | 1 | `UISwipeGestureRecognizer` | `GestureDetector.onFling()` | velocity > 300dp/s, primary direction > 45° | None (action feedback instead) |
| Pan / Drag | 1 | `UIPanGestureRecognizer` | `OnDragListener` / `Modifier.draggable()` | > 10dp movement | Soft tick on snap points |
| Pinch (scale) | 2 | `UIPinchGestureRecognizer` | `ScaleGestureDetector` | Scale factor delta > 0.01 | None |
| Rotate | 2 | `UIRotationGestureRecognizer` | `RotateGestureDetector` (custom) | Rotation > 5° | None |
| Edge Swipe (back) | 1 | System (left edge 20pt) | System (predictive back, left edge) | Starts within 20dp of edge | System default |
| Two-finger Pan | 2 | `UIPanGestureRecognizer(minTouches: 2)` | — | Same as pan | None |
| Three-finger swipe | 3 | System (undo/redo iOS 13+) | — | — | System default |

### Gesture Conflict Resolution Hierarchy

```
Priority (highest → lowest):
1. System gestures (edge swipe back, status bar tap, notification pull)
2. Scroll (UIScrollView / LazyColumn inherent)
3. Long press (takes precedence after 500ms timeout)
4. Swipe actions (on list items)
5. Tap (fires only after double-tap timer expires if double-tap registered)
6. Custom gestures

Rule: When two gestures conflict, the more specific gesture wins.
iOS: requiresExclusiveRecognition, require(toFail:) to sequence.
Android: requestDisallowInterceptTouchEvent() for child priority.
```

### iOS — Gesture Recognizer Setup

```swift
// Simultaneous gestures (e.g., pinch + rotate on same view)
func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
) -> Bool { true }

// Require double-tap to fail before single-tap fires
singleTap.require(toFail: doubleTap)

// SwiftUI combined gestures
Image("photo")
    .gesture(
        MagnificationGesture()
            .simultaneously(with: RotationGesture())
            .onChanged { value in
                // value.first = scale, value.second = angle
            }
    )

// Long press → drag sequence
Text("Drag me")
    .gesture(
        LongPressGesture(minimumDuration: 0.5)
            .sequenced(before: DragGesture())
            .onEnded { value in /* handle */ }
    )
```

### Android — Gesture Detection

```kotlin
// Compose: combined gestures
Box(
    modifier = Modifier
        .pointerInput(Unit) {
            detectTapGestures(
                onTap = { /* single tap */ },
                onDoubleTap = { /* double tap */ },
                onLongPress = { /* long press (400ms default) */ },
                onPress = { /* immediate press feedback */ }
            )
        }
)

// Compose: drag + fling
Modifier.draggable(
    state = rememberDraggableState { delta -> offsetX += delta },
    orientation = Orientation.Horizontal,
    onDragStopped = { velocity ->
        if (velocity > 300f) { /* fling detected */ }
    }
)

// Compose: transform (pinch + rotate + pan)
Modifier.pointerInput(Unit) {
    detectTransformGestures { centroid, pan, zoom, rotation ->
        scale *= zoom
        angle += rotation
        offset += pan
    }
}
```

### Swipe-to-Dismiss Thresholds

| Parameter | Value | Notes |
|-----------|-------|-------|
| Horizontal dismiss threshold | 40–50% of width | Or velocity > 800dp/s |
| Vertical dismiss threshold | 30–40% of height | Modal/card dismiss |
| Velocity threshold | 800dp/s | Quick flick dismisses regardless of distance |
| Rubber-banding factor | 0.5 (50% of finger movement) | Beyond threshold, resistance increases |
| Snap-back animation | 300ms spring | If threshold not met, return to origin |
| Background reveal | Fade in destination/action behind | Scale 0.95→1.0 for depth |

### Gesture Discoverability

| Technique | When to Use | Duration |
|-----------|-------------|----------|
| Coach mark overlay | First time user encounters gesture surface | Dismiss on tap or after 5s |
| Tooltip with arrow | Long-press or swipe hint on specific element | 3s auto-dismiss |
| Animated hand icon | Swipe/pinch demo on first visit | Loop 2–3 times |
| Peek preview | Partially reveal content behind edge | First launch only |
| Haptic nudge | Suggest draggability on long press begin | Instant |
| Empty state instruction | "Swipe left to delete" text | Until first successful gesture |

### Platform Comparison — Gesture Defaults

| Gesture | iOS Behavior | Android Behavior |
|---------|-------------|-----------------|
| Back | Left edge swipe (20pt zone) | System back button / predictive back gesture (left/right edge) |
| Pull-to-refresh | UIRefreshControl (top overscroll) | SwipRefreshLayout / pullRefresh() Compose |
| Swipe between tabs | UIPageViewController default | ViewPager2 default |
| Dismiss modal | Swipe down on sheet | Swipe down, back gesture, or scrim tap |
| Reorder list | Long press → drag (edit mode) | Long press → drag (ItemTouchHelper) |
| Undo | Three-finger swipe left / shake | Snackbar with undo action |

### Checklist

- ✅ Tap is the primary interaction; never require a gesture as the only path
- ✅ Long press duration ≥ 500ms with haptic confirmation
- ✅ Swipe actions have visible alternative (button, menu)
- ✅ Edge swipe reserved for system back — don't override
- ✅ Pinch/rotate only on content that visually affords it (maps, photos)
- ✅ Coach marks shown once, then remembered via UserDefaults / SharedPreferences
- ✅ `accessibilityActions` provide non-gesture alternatives
- ❌ Don't require multi-finger gestures for core functionality
- ❌ Don't override three-finger gestures (iOS accessibility/undo)
- ❌ Don't fight scroll direction (horizontal swipe in vertical list = conflict)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Swipe-only delete with no visible button | Undiscoverable, accessibility failure | Add edit mode or context menu |
| Custom back gesture overriding edge swipe | Breaks system navigation | Use system back, put custom gesture elsewhere |
| Double-tap zoom + double-tap like on same element | Gesture conflict | Choose one; use dedicated button for the other |
| No haptic feedback on long press | User unsure gesture registered | Add `.impactOccurred()` / `HapticFeedbackConstants` |
| Gesture threshold too small (< 20dp) | Accidental triggers | Use platform defaults or increase |

### Sources

- Apple HIG — Gestures: developer.apple.com/design/human-interface-guidelines/gestures
- Material Design — Gestures: m3.material.io/foundations/interaction/gestures
- Android Gesture Navigation: developer.android.com/guide/navigation/predictive-back-gesture
- UIGestureRecognizer: developer.apple.com/documentation/uikit/uigesturerecognizer

---

## AV. Context Menus & Long Press

### Platform Mechanisms

| Feature | iOS | Android |
|---------|-----|---------|
| API | `UIContextMenuInteraction` / `.contextMenu {}` SwiftUI | `PopupMenu`, `ContextMenu` (legacy), `DropdownMenu` Compose |
| Trigger | Long press (500ms) or 3D Touch / Haptic Touch | Long press (400ms) |
| Preview | ✅ Blurred background + focused preview of element | ❌ No native preview (custom implementation possible) |
| Haptic | Medium impact on menu appear | `HapticFeedbackConstants.LONG_PRESS` |
| Dismiss | Tap outside or swipe away | Tap outside or back gesture |
| Animation | Scale-up from source (200ms spring) | Fade in (150ms) |

### Menu Item Ordering

```
1. Primary action (most frequent)       — Default style
2. Secondary actions (common)            — Default style
3. Section separator                     — Divider
4. Navigation actions (open in...)       — Default style
5. Section separator                     — Divider
6. Destructive actions (delete, remove)  — RED / destructive style, ALWAYS LAST
```

### Menu Item Limits

| Guideline | Value |
|-----------|-------|
| Max top-level items | 8–10 (prefer 5–7) |
| Max submenu depth | 1 level (never nest deeper) |
| Max items in submenu | 6 |
| Min touch target per item | 44×44pt (iOS) / 48×48dp (Android) |
| Menu item height | 44pt (iOS) / 48dp (Android) |
| Menu width | 250–320pt (iOS) / 200–280dp (Android) |

### SwiftUI — Context Menu with Preview

```swift
// Basic context menu
Text(message.body)
    .contextMenu {
        Button { copy(message) } label: {
            Label("Copy", systemImage: "doc.on.doc")
        }
        Button { reply(message) } label: {
            Label("Reply", systemImage: "arrowshape.turn.up.left")
        }
        Divider()
        Button(role: .destructive) { delete(message) } label: {
            Label("Delete", systemImage: "trash")
        }
    } preview: {
        // Custom preview view (optional)
        MessagePreview(message: message)
            .frame(width: 300, height: 200)
    }

// Inline section (iOS 16+)
.contextMenu {
    Section {
        Button("Copy") { }
        Button("Share") { }
    }
    Section {
        Button("Delete", role: .destructive) { }
    }
}
```

### Kotlin — Compose Dropdown Menu

```kotlin
var showMenu by remember { mutableStateOf(false) }

Box {
    Text(
        text = message.body,
        modifier = Modifier
            .combinedClickable(
                onClick = { /* navigate */ },
                onLongClick = {
                    haptics.performHapticFeedback(HapticFeedbackType.LongPress)
                    showMenu = true
                }
            )
    )
    DropdownMenu(
        expanded = showMenu,
        onDismissRequest = { showMenu = false }
    ) {
        DropdownMenuItem(
            text = { Text("Copy") },
            leadingIcon = { Icon(Icons.Outlined.ContentCopy, null) },
            onClick = { copy(message); showMenu = false }
        )
        DropdownMenuItem(
            text = { Text("Reply") },
            leadingIcon = { Icon(Icons.Outlined.Reply, null) },
            onClick = { reply(message); showMenu = false }
        )
        HorizontalDivider()
        DropdownMenuItem(
            text = { Text("Delete", color = MaterialTheme.colorScheme.error) },
            leadingIcon = { Icon(Icons.Outlined.Delete, null,
                tint = MaterialTheme.colorScheme.error) },
            onClick = { delete(message); showMenu = false }
        )
    }
}
```

### Long Press Timing

| Platform | Default | Custom Range | Notes |
|----------|---------|-------------|-------|
| iOS | 500ms | `minimumPressDuration` (UIKit), `minimumDuration` (SwiftUI) | < 200ms risks accidental |
| Android | 400ms | `ViewConfiguration.longPressTimeout` | System default; avoid overriding globally |
| Recommended | 500ms | 300–800ms | 500ms balances speed vs. accidental trigger |

### Checklist

- ✅ Long press has haptic feedback on activation
- ✅ Destructive actions are last, styled in red
- ✅ Menu items have icons (SF Symbol / Material Icon) + text label
- ✅ Preview (iOS) shows the element in context, not a blank box
- ✅ All menu actions are also reachable via visible UI (edit mode, toolbar)
- ✅ Menu dismisses on outside tap and system back
- ✅ Accessibility: `accessibilityCustomAction` exposes menu items to VoiceOver/TalkBack
- ❌ Don't nest submenus more than 1 level deep
- ❌ Don't show context menu on every element (reserve for content-rich items)
- ❌ Don't duplicate the tap action as a menu item

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| No visible affordance that long press exists | 0% discoverability | Add "..." overflow or coach mark |
| Delete as first menu item | Accidental destructive action | Place destructive items last with divider |
| Menu with 15+ items | Overwhelming, slow to scan | Group into sections, max 8–10 |
| Custom long-press timing < 200ms | Triggers during normal scrolling | Use ≥ 500ms |
| No haptic on menu appear | Feels unresponsive | Add medium impact haptic |

### Sources

- Apple HIG — Context Menus: developer.apple.com/design/human-interface-guidelines/context-menus
- Material Design — Menus: m3.material.io/components/menus
- UIContextMenuInteraction: developer.apple.com/documentation/uikit/uicontextmenuinteraction
- DropdownMenu Compose: developer.android.com/reference/kotlin/androidx/compose/material3/package-summary#DropdownMenu

---

## AW. Swipe Actions on List Items

### Anatomy

```
┌─────────────────────────────────────────────┐
│  Leading Actions          Content Row          Trailing Actions  │
│  ┌────┬────┐     ┌──────────────────┐     ┌────┬────┬────┐     │
│  │ Pin│Read│ ←── │  List Item       │ ──→ │Flag│Arch│ Del│     │
│  └────┴────┘     └──────────────────┘     └────┴────┴────┘     │
│  (swipe right)                            (swipe left)          │
└─────────────────────────────────────────────────────────────────┘
```

### Swipe Action Specs

| Parameter | iOS | Android | Notes |
|-----------|-----|---------|-------|
| Max actions per side | 3 | 3 | More than 3 becomes cramped |
| Action button width | 74–80pt | 72–80dp | Expands proportionally |
| Full swipe trigger | > 50% of row width OR velocity > 800pt/s | Custom threshold | iOS: `performsFirstActionWithFullSwipe` |
| Action height | Match row height | Match row height | — |
| Reveal distance for menu | 20–30% partial swipe | 20–30% partial swipe | Show all action buttons |
| Corner radius on action | 0 (flush) | 0 or match row radius | — |
| Animation duration | 250ms spring | 200ms | Slide + reveal |

### Color Coding Convention

| Action Type | Color | Icon Example | Side |
|-------------|-------|-------------|------|
| Destructive (delete) | Red `#FF3B30` / `error` | trash | Trailing (rightmost) |
| Archive | Purple `#AF52DE` / `tertiary` | archivebox | Trailing |
| Flag / Star | Orange `#FF9500` / `warning` | flag.fill | Trailing |
| Mark read/unread | Blue `#007AFF` / `primary` | envelope.open | Leading |
| Pin | Yellow `#FFCC00` | pin.fill | Leading |
| Constructive (done) | Green `#34C759` / `success` | checkmark | Leading |

### SwiftUI — Swipe Actions

```swift
List {
    ForEach(emails) { email in
        EmailRow(email: email)
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    delete(email)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button {
                    archive(email)
                } label: {
                    Label("Archive", systemImage: "archivebox")
                }
                .tint(.purple)
                Button {
                    flag(email)
                } label: {
                    Label("Flag", systemImage: "flag")
                }
                .tint(.orange)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    toggleRead(email)
                } label: {
                    Label(
                        email.isRead ? "Unread" : "Read",
                        systemImage: email.isRead ? "envelope.badge" : "envelope.open"
                    )
                }
                .tint(.blue)
            }
    }
}
```

### Kotlin — Compose SwipeToDismiss

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SwipeableEmailItem(email: Email, onDelete: () -> Unit, onArchive: () -> Unit) {
    val dismissState = rememberSwipeToDismissBoxState(
        confirmValueChange = { value ->
            when (value) {
                SwipeToDismissBoxValue.EndToStart -> { onDelete(); true }
                SwipeToDismissBoxValue.StartToEnd -> { onArchive(); true }
                else -> false
            }
        },
        positionalThreshold = { totalDistance -> totalDistance * 0.4f }
    )

    SwipeToDismissBox(
        state = dismissState,
        backgroundContent = {
            val direction = dismissState.dismissDirection
            val color by animateColorAsState(
                when (direction) {
                    SwipeToDismissBoxValue.EndToStart -> Color(0xFFFF3B30)
                    SwipeToDismissBoxValue.StartToEnd -> Color(0xFFAF52DE)
                    else -> Color.Transparent
                }
            )
            Box(
                Modifier.fillMaxSize().background(color).padding(horizontal = 20.dp),
                contentAlignment = if (direction == SwipeToDismissBoxValue.EndToStart)
                    Alignment.CenterEnd else Alignment.CenterStart
            ) {
                Icon(
                    if (direction == SwipeToDismissBoxValue.EndToStart)
                        Icons.Outlined.Delete else Icons.Outlined.Archive,
                    contentDescription = null,
                    tint = Color.White
                )
            }
        }
    ) {
        EmailRowContent(email)
    }
}
```

### Full-Swipe-to-Complete Pattern

| Step | Behavior |
|------|----------|
| 1 | User swipes > 50% or with velocity > 800dp/s |
| 2 | Action icon scales up / snaps to confirm |
| 3 | Haptic: medium impact at threshold crossing |
| 4 | Row slides off screen (200ms) |
| 5 | Snackbar appears with "Undo" action (5s timeout) |
| 6 | If undo tapped: row animates back in (300ms spring) |

### Undo Pattern

- **Always** provide undo for destructive full-swipe actions
- Snackbar duration: 5–8 seconds
- Snackbar placement: bottom, above bottom nav
- Delay actual server deletion until snackbar expires
- Queue multiple undos if user swipes several in succession

### Checklist

- ✅ Swipe actions have both icon and short label (≤ 6 chars)
- ✅ Destructive action is furthest from content (rightmost on trailing side)
- ✅ Full swipe performs the first (primary) action only
- ✅ Destructive full swipe triggers undo snackbar
- ✅ Colors follow semantic convention (red=delete, green=done)
- ✅ Accessibility: all swipe actions available via `accessibilityCustomAction`
- ✅ Max 3 actions per side
- ❌ Don't use swipe actions on items that also drag-to-reorder (gesture conflict)
- ❌ Don't use identical colors for different actions
- ❌ Don't perform destructive action without undo or confirmation

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Swipe-only actions, no alternative | Undiscoverable, inaccessible | Add context menu or edit mode |
| 4+ actions per side | Too cramped, icons illegible | Max 3; move extras to context menu |
| Full swipe delete with no undo | Data loss | Always offer 5s undo snackbar |
| Same color for archive and delete | Confusion → accidental delete | Distinct colors per action |
| Swipe actions on non-list content | Unexpected behavior | Reserve for list/feed items only |

### Sources

- Apple HIG — Swipe Actions: developer.apple.com/design/human-interface-guidelines/swipe-actions
- SwipeToDismissBox: developer.android.com/reference/kotlin/androidx/compose/material3/package-summary#SwipeToDismissBox
- iOS Mail app swipe behavior (design reference)

---

## AX. In-App Messaging & Banners

### Banner Types

| Type | Color (Light) | Color (Dark) | Icon | Auto-dismiss | Usage |
|------|--------------|-------------|------|-------------|-------|
| Info | Blue `#E8F0FE` bg, `#1A73E8` text | `#1A3A5C` bg, `#8AB4F8` text | `info.circle` / `Info` | 5–8s or manual | Neutral information |
| Success | Green `#E6F4EA` bg, `#1E8E3E` text | `#1E3A2F` bg, `#81C995` text | `checkmark.circle` / `CheckCircle` | 3–5s | Action completed |
| Warning | Yellow `#FEF7E0` bg, `#E37400` text | `#3D3222` bg, `#FDD663` text | `exclamationmark.triangle` / `Warning` | Manual only | Requires attention |
| Error | Red `#FCE8E6` bg, `#D93025` text | `#3C1F1E` bg, `#F28B82` text | `xmark.circle` / `Error` | Manual only | Action failed |

### Snackbar vs Banner Decision Tree

```
Is the message a response to a user action?
├── Yes → Snackbar (bottom, 4–8s, optional undo action)
└── No → Is it system/background info?
    ├── Yes → Banner (top, persistent or auto-dismiss)
    └── No → Is it blocking/critical?
        ├── Yes → Modal dialog
        └── No → Inline message near relevant content
```

### Placement & Sizing

| Component | Position | Height | Width | Z-index |
|-----------|----------|--------|-------|---------|
| Snackbar | Bottom, 16dp above bottom nav | 48dp (single line) / 68dp (two line) | Fill width - 16dp margins (phone) / max 568dp (tablet) | Above FAB |
| Banner (top) | Below status bar / nav bar | Auto (min 52dp) | Full width | Below nav bar, above content |
| Banner (persistent) | Top of scroll area | Auto | Full width | Pushes content down |
| Toast (Android) | Bottom center | Auto | Auto | System overlay |
| Tooltip | Near anchor element | Auto (max 2 lines) | max 200dp | Topmost |

### Auto-Dismiss Timing

| Severity | Duration | Rationale |
|----------|----------|-----------|
| Success | 3–4s | Quick confirmation, no action needed |
| Info | 5–8s | May need to read |
| Warning | No auto-dismiss | User must acknowledge |
| Error | No auto-dismiss | User must read and may need to retry |
| Snackbar with action | 8–10s | Extra time to tap "Undo" |

### SwiftUI — Banner Implementation

```swift
struct BannerView: View {
    let type: BannerType // .info, .success, .warning, .error
    let message: String
    let dismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
                .foregroundColor(type.foregroundColor)
            Text(message)
                .font(.subheadline)
                .foregroundColor(type.foregroundColor)
            Spacer()
            Button(action: dismiss) {
                Image(systemName: "xmark")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(type.foregroundColor.opacity(0.6))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.backgroundColor)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(duration: 0.3), value: true)
    }
}
```

### Kotlin — Snackbar

```kotlin
val snackbarHostState = remember { SnackbarHostState() }

Scaffold(
    snackbarHost = {
        SnackbarHost(hostState = snackbarHostState) { data ->
            Snackbar(
                snackbarData = data,
                containerColor = MaterialTheme.colorScheme.inverseSurface,
                contentColor = MaterialTheme.colorScheme.inverseOnSurface,
                actionColor = MaterialTheme.colorScheme.inversePrimary,
                shape = RoundedCornerShape(8.dp)
            )
        }
    }
) { padding ->
    // Content
}

// Show snackbar
scope.launch {
    val result = snackbarHostState.showSnackbar(
        message = "Item deleted",
        actionLabel = "Undo",
        duration = SnackbarDuration.Short // 4s
    )
    if (result == SnackbarResult.ActionPerformed) {
        viewModel.undoDelete()
    }
}
```

### Frequency Capping

| Rule | Value | Rationale |
|------|-------|-----------|
| Max banners visible simultaneously | 1 (queue others) | Prevent stacking |
| Rate limit same message | 1 per 60s | Avoid spam |
| Promotional in-app message | 1 per session | Respect attention |
| Feature announcement | 1 per feature, 1x ever | Don't repeat |
| Store between sessions | Track `lastShown` in UserDefaults/SharedPrefs | Cool-down enforcement |
| Queue priority | Error > Warning > Info > Promotional | Critical first |

### Coach Marks & Tooltips

| Spec | Value |
|------|-------|
| Background | `#000000` @ 80% (dark) or Surface Inverse |
| Text color | White / Inverse On Surface |
| Corner radius | 8dp |
| Arrow/caret size | 8×8dp |
| Max width | 200dp |
| Padding | 12dp |
| Dismiss | Tap anywhere or after 5s |
| Show frequency | Once per feature per user |
| Animation | Fade in 150ms, fade out 150ms |

### Checklist

- ✅ Error and warning banners require manual dismiss (no auto-dismiss)
- ✅ Snackbar has max 1 action button (typically "Undo" or "Retry")
- ✅ Banners don't overlap navigation elements
- ✅ Banner text is concise: ≤ 2 lines
- ✅ Queue multiple messages; never stack
- ✅ VoiceOver/TalkBack announces banner as assertive live region
- ✅ Frequency cap on promotional messages
- ❌ Don't use toast for errors (too brief, no action)
- ❌ Don't auto-dismiss errors or warnings
- ❌ Don't show banners during onboarding flow (overwhelming)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Stacking 3+ banners | Covers content, overwhelming | Queue and show one at a time |
| Error as toast (2s, no action) | User can't read or act | Use persistent banner with retry |
| Promotional popup on first launch | Hostile first impression | Wait ≥ 3 sessions |
| Banner blocking tap targets | Unusable UI | Position above/below interactive area |
| No accessibility announcement | Screen reader users miss message | `accessibilityLiveRegion = .assertive` / `LiveRegionMode.Assertive` |

### Sources

- Material Design 3 — Snackbar: m3.material.io/components/snackbar
- Apple HIG — Alerts: developer.apple.com/design/human-interface-guidelines/alerts
- Material Design 3 — Banners: m3.material.io/components/banners
- NNG — Indicators, Notifications, Alerts: nngroup.com/articles/indicators-validations-notifications

---

## AY. Onboarding Patterns (Comprehensive)

### Onboarding Strategy Decision Tree

```
New user?
├── Yes → Has account?
│   ├── Yes → Sign in → Personalization (optional) → Home
│   └── No → Guest browse OR Create account
│       ├── Guest → Minimal onboarding (1 screen) → Home → Prompt signup at value moment
│       └── Create account → 3-5 step carousel → Permission priming → Home
└── No → App updated?
    ├── Yes → What's New (1-3 slides) → Home
    └── No → Normal launch → Home
```

### Carousel Specs

| Parameter | Value | Notes |
|-----------|-------|-------|
| Max screens | 3–5 | Completion drops 20% per additional screen |
| Skip button | Always visible, top-right | "Skip" text, not icon |
| Progress indicator | Dots, bottom center | Active dot: 8dp ø, Inactive: 6dp ø @ 40% |
| CTA button | Bottom, full-width (margins 16dp) | "Next" → "Next" → "Get Started" (final) |
| Illustration size | 60% of screen height | Above the fold |
| Title | Max 6 words | Bold, 24–28sp |
| Description | Max 2 lines | 16sp, secondary color |
| Swipe between slides | ✅ Enabled | With dot animation |
| Auto-advance | ❌ Never | User controls pace |
| Completion rate benchmark | 65–80% | Below 50% = too many screens |

### Permission Priming Screen

```
┌─────────────────────────────┐
│        [Illustration]        │
│                              │
│   "Enable Notifications"     │  ← Custom title (value-focused)
│                              │
│  "Get reminders when it's    │  ← Explain WHY, not WHAT
│   time to log your day"      │
│                              │
│  ┌──────────────────────┐    │
│  │   Allow Notifications │    │  ← Primary CTA → triggers system prompt
│  └──────────────────────┘    │
│                              │
│      Maybe Later             │  ← Secondary, text-only
└─────────────────────────────┘
```

**Key rule:** Always show your custom primer BEFORE the system dialog. If user taps "Maybe Later," don't trigger system prompt. This preserves the one-time system prompt for later.

### Permission Priming Conversion Rates

| Approach | Acceptance Rate | Notes |
|----------|----------------|-------|
| Cold system prompt (no priming) | 50–55% | Baseline, one chance |
| Custom primer then system | 75–85% | "Maybe Later" preserves retry |
| Contextual (at moment of need) | 85–90% | Best: ask when user taps camera icon |
| Delayed (after 3+ sessions) | 70–80% | User already sees value |

### Account Creation Patterns

| Pattern | Pros | Cons | Best For |
|---------|------|------|----------|
| Email + password | Universal, familiar | Friction, forgot password | Enterprise |
| Social sign-in (Google/Apple) | 1-tap, fast | Privacy concerns, platform dependency | Consumer |
| Phone + OTP | Simple, no password | Requires cell signal, SMS cost | Emerging markets |
| Sign in with Apple (required if social login offered) | Privacy, App Store requirement | Apple ecosystem only | Any iOS app with social login |
| Passkeys | Phishing-proof, fast | New paradigm, support varies | Forward-looking apps |
| Guest mode | Zero friction | Limited features, data loss risk | E-commerce, content |

### Progressive Disclosure

| Session | Show | Hide |
|---------|------|------|
| 1–2 | Core tab (Home), primary action | Advanced settings, analytics, export |
| 3–5 | Introduce feature #2 via tooltip | Power features |
| 5+ | Introduce feature #3, "Did you know?" | — |
| 10+ | Full feature set available | Onboarding hints |

### Empty State as Onboarding

```
┌─────────────────────────────┐
│                              │
│      [Illustration/Icon]     │
│                              │
│   "No entries yet"           │  ← Clear state description
│                              │
│   "Tap + to log your first   │  ← Instructional text with
│    cigarette"                │     reference to specific UI
│                              │
│   ┌──────────────────┐       │
│   │  + Add First Entry│       │  ← Primary CTA
│   └──────────────────┘       │
└─────────────────────────────┘
```

### What's New on Update

| Guideline | Value |
|-----------|-------|
| Max slides | 1–3 |
| Show condition | First launch after version update with notable features |
| Dismiss | "Continue" button + swipe down (if sheet) |
| Don't show for | Bug fix releases (minor patches) |
| Content | Feature name + 1-line benefit + illustration |
| Storage | `lastSeenVersion` in UserDefaults / SharedPreferences |

### SwiftUI — Onboarding Carousel

```swift
struct OnboardingView: View {
    @State private var currentPage = 0
    let pages = OnboardingPage.all // [title, description, imageName]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Skip") { completeOnboarding() }
                    .padding(.trailing, 16)
            }
            
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                if currentPage == pages.count - 1 {
                    completeOnboarding()
                } else {
                    withAnimation { currentPage += 1 }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
}
```

### Kotlin — Onboarding Pager

```kotlin
@Composable
fun OnboardingScreen(onComplete: () -> Unit) {
    val pagerState = rememberPagerState(pageCount = { 3 })
    val scope = rememberCoroutineScope()

    Column(modifier = Modifier.fillMaxSize()) {
        Row(Modifier.fillMaxWidth().padding(16.dp), horizontalArrangement = Arrangement.End) {
            TextButton(onClick = onComplete) { Text("Skip") }
        }
        HorizontalPager(state = pagerState, modifier = Modifier.weight(1f)) { page ->
            OnboardingPage(pages[page])
        }
        HorizontalPagerIndicator(
            pagerState = pagerState,
            modifier = Modifier.align(Alignment.CenterHorizontally).padding(16.dp),
            activeColor = MaterialTheme.colorScheme.primary,
            inactiveColor = MaterialTheme.colorScheme.outlineVariant
        )
        Button(
            onClick = {
                if (pagerState.currentPage == 2) onComplete()
                else scope.launch { pagerState.animateScrollToPage(pagerState.currentPage + 1) }
            },
            modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 32.dp)
        ) {
            Text(if (pagerState.currentPage == 2) "Get Started" else "Next")
        }
    }
}
```

### Checklist

- ✅ Skip button visible on every onboarding screen
- ✅ Carousel ≤ 5 screens (ideally 3)
- ✅ Each screen: illustration + title (≤ 6 words) + description (≤ 2 lines)
- ✅ Permission priming before system prompt (never cold-prompt)
- ✅ Guest mode available if not security-critical
- ✅ Empty states guide user to first action
- ✅ `hasCompletedOnboarding` flag persisted locally
- ✅ What's New only for meaningful feature updates
- ❌ Don't force account creation before showing app value
- ❌ Don't auto-advance carousel slides
- ❌ Don't ask all permissions on first launch (spread contextually)
- ❌ Don't show onboarding on every launch (only first)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| 8+ onboarding slides | >70% abandonment | Max 3–5, front-load value |
| Cold permission prompt on launch | Low acceptance, can't re-prompt | Custom primer + contextual timing |
| No skip button | User feels trapped | Always show skip |
| Mandatory registration before browsing | Kills conversion | Offer guest mode |
| Repeating onboarding after reinstall | Annoying for existing users | Check account/backup for returning user |

### Sources

- Apple HIG — Onboarding: developer.apple.com/design/human-interface-guidelines/onboarding
- Material Design — Onboarding: material.io/design/communication/onboarding.html
- Localytics: 25% of users abandon apps after first use (2019 benchmark)
- CleverTap: Permission priming increases opt-in by 30–40%

---

## AZ. Skeleton Screens & Shimmer Specs

### Skeleton Shape Matching

| Content Type | Skeleton Shape | Dimensions | Corner Radius |
|-------------|----------------|------------|---------------|
| Avatar (circle) | Circle | 40×40dp | 20dp (full) |
| Title text | Rounded rect | 60–80% container width × 20dp | 4dp |
| Body text (line 1) | Rounded rect | 100% width × 14dp | 4dp |
| Body text (line 2) | Rounded rect | 70% width × 14dp | 4dp |
| Thumbnail image | Rounded rect | Match image container | Match image radius |
| Button | Rounded rect | Match button size | Match button radius |
| Card | Rounded rect | Match card dimensions | Match card radius |
| Icon placeholder | Circle or rounded square | Match icon size | 4dp or full |

### Shimmer Gradient Specs

```
Direction: LTR (or locale-aware: RTL for Arabic/Hebrew)
Gradient type: Linear, 3-stop
Stop 1: skeleton base color (0%)     — e.g. #E0E0E0 (light) / #2C2C2C (dark)
Stop 2: highlight color (50%)        — e.g. #F5F5F5 (light) / #3C3C3C (dark)
Stop 3: skeleton base color (100%)   — same as stop 1
Angle: 20–30° from horizontal (slight diagonal)
Animation: translateX from -100% to +200% of container width
Duration: 1.0–1.5s per cycle
Repeat: infinite until content loads
Easing: linear (no ease, constant speed for shimmer)
```

### Platform Colors

| Element | iOS (Light) | iOS (Dark) | Android (Light) | Android (Dark) |
|---------|-------------|------------|-----------------|----------------|
| Skeleton base | `systemFill` (`#787880` @ 20%) | `systemFill` (`#787880` @ 36%) | `surfaceVariant` | `surfaceVariant` |
| Shimmer highlight | `systemBackground` (`#FFFFFF`) | `secondarySystemBackground` | `surface` + 8% primary | `surface` + 8% primary |
| Text placeholder | `systemFill` | `systemFill` | `surfaceContainerHighest` | `surfaceContainerHighest` |

### Timing Specs

| Parameter | Value | Notes |
|-----------|-------|-------|
| Delay before showing skeleton | 200–300ms | Don't show for fast loads |
| Shimmer duration | 1.0–1.5s per sweep | Slower = calmer |
| Transition skeleton → content | Fade crossfade 200ms | `Modifier.animateContentSize()` or `.transition(.opacity)` |
| Max skeleton display | 10s then show error/retry | Don't shimmer forever |
| Content partial load | Replace skeletons individually as data arrives | Top-down progressive |

### Skeleton vs Spinner Decision Tree

```
Is the layout known before data loads?
├── Yes → Skeleton screen (matches layout shape)
│   Is it a list/feed?
│   ├── Yes → Show 3-5 skeleton items (fill viewport)
│   └── No → Show skeleton matching exact layout
└── No → Is it a brief operation (< 2s typical)?
    ├── Yes → Delay 300ms, then show spinner
    └── No → Full-screen loading with progress indicator
```

### SwiftUI — Shimmer Modifier

```swift
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1.0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .white.opacity(0.4), location: 0.5),
                        .init(color: .clear, location: 1)
                    ],
                    startPoint: .init(x: phase - 0.5, y: 0.3),
                    endPoint: .init(x: phase + 0.5, y: 0.7)
                )
                .blendMode(.sourceAtop)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 2.0
                }
            }
    }
}

// Usage
RoundedRectangle(cornerRadius: 4)
    .fill(Color(.systemFill))
    .frame(height: 20)
    .modifier(ShimmerModifier())
```

### Kotlin — Compose Shimmer

```kotlin
fun Modifier.shimmer(): Modifier = composed {
    val transition = rememberInfiniteTransition(label = "shimmer")
    val translateAnim = transition.animateFloat(
        initialValue = -300f,
        targetValue = 1000f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 1200, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ), label = "shimmer"
    )
    val brush = Brush.linearGradient(
        colors = listOf(
            MaterialTheme.colorScheme.surfaceVariant,
            MaterialTheme.colorScheme.surface,
            MaterialTheme.colorScheme.surfaceVariant,
        ),
        start = Offset(translateAnim.value, 0f),
        end = Offset(translateAnim.value + 300f, 50f)
    )
    background(brush, shape = RoundedCornerShape(4.dp))
}

// Usage
@Composable
fun SkeletonListItem() {
    Row(Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
        Box(Modifier.size(40.dp).clip(CircleShape).shimmer())
        Spacer(Modifier.width(12.dp))
        Column {
            Box(Modifier.fillMaxWidth(0.7f).height(18.dp).shimmer())
            Spacer(Modifier.height(8.dp))
            Box(Modifier.fillMaxWidth(0.5f).height(14.dp).shimmer())
        }
    }
}
```

### Reduce Motion Compliance

When `UIAccessibility.isReduceMotionEnabled` (iOS) or `Settings.Global.ANIMATOR_DURATION_SCALE == 0` (Android):
- Disable shimmer animation
- Show static skeleton with slightly different opacity (base @ 30%, no sweep)
- Still transition to content with simple cut (no fade)

### Checklist

- ✅ Skeleton shapes match actual content layout
- ✅ Shimmer sweep duration 1.0–1.5s, linear easing
- ✅ 200–300ms delay before showing skeleton (skip for fast loads)
- ✅ Transition skeleton → content with 200ms crossfade
- ✅ Show 3–5 skeleton items for lists (fill viewport, no more)
- ✅ Respect Reduce Motion: static skeleton, no shimmer
- ✅ RTL-aware shimmer direction
- ❌ Don't use skeleton for < 300ms loads (flash of skeleton = worse than nothing)
- ❌ Don't shimmer indefinitely — timeout at 10s then show error
- ❌ Don't mix skeleton and spinner on the same screen

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Spinner for content-rich screens | No layout preview, feels slower | Use skeleton matching layout |
| Skeleton that doesn't match content | Jarring shift when content loads | Match shapes exactly |
| Flash of skeleton on fast load | Worse than no indicator | Add 200–300ms delay |
| Shimmer running > 10s with no fallback | Feels broken | Timeout → error/retry state |
| Ignoring reduced motion | Accessibility violation | Static skeleton without animation |

### Sources

- Luke Wroblewski: "Skeleton Screens" (2013, lukew.com)
- Material Design — Progress Indicators: m3.material.io/components/progress-indicators
- Apple HIG — Loading: developer.apple.com/design/human-interface-guidelines/loading
- Perceptual speed: Skeleton screens perceived 10–20% faster than spinners (Google/Facebook internal studies)

---

## BA. Infinite Scroll & Pagination

### Trigger Distance

| Parameter | Value | Notes |
|-----------|-------|-------|
| Prefetch trigger | 5–10 items from bottom | Start loading when 5th-to-last item visible |
| Initial page size | 20–30 items | Fills ~2–3 viewports |
| Subsequent page size | 10–20 items | Consistent batch size |
| Loading indicator | Spinner at bottom, inside list | 48dp height, centered |
| Loading indicator delay | 300ms | Don't flash for fast responses |

### Cursor vs Offset Pagination

| Method | Pros | Cons | Best For |
|--------|------|------|----------|
| Cursor-based (after: "abc123") | Stable with inserts/deletes, O(1) | Can't jump to page N | Feeds, timelines |
| Offset-based (page=3, limit=20) | Simple, jump to any page | Duplicates/gaps on data changes | Static catalogs |
| Keyset (where id > 100 limit 20) | Performant, stable | Requires sortable key | Large datasets |

### End-of-Content Indicator

```
┌──────────────────────────┐
│      Last item           │
├──────────────────────────┤
│                          │
│     ─── ● ───            │  ← Divider + dot or icon
│                          │
│   "You're all caught up" │  ← Friendly message
│                          │
│   Back to Top ↑          │  ← Optional scroll-to-top
│                          │
│     [Footer padding]     │  ← 80dp so last item clears bottom nav
└──────────────────────────┘
```

### Scroll-to-Top FAB

| Spec | Value |
|------|-------|
| Show after | Scrolling down > 2 viewports (or > 20 items from top) |
| Position | Bottom-right, 16dp margin, above bottom nav |
| Size | 40dp (mini FAB) |
| Icon | `arrow.up` / `KeyboardArrowUp` |
| Animation in | Scale + fade, 200ms |
| Animation out | Fade 150ms |
| Behavior | Smooth scroll to top (or instant if > 100 items) |
| Hide on | Scroll up or within 1 viewport of top |

### Pull-to-Refresh Coexistence

```
User at top of list:
  Pull down → Refresh indicator → Reload page 1 → Reset pagination cursor
  
User mid-list:
  Scroll down → Trigger prefetch → Append page N+1
  
User navigated away then back:
  Restore scroll position from saved state
  If stale (> 5 min), refresh silently from top
```

### Error State in Pagination

| Error Type | UI | Behavior |
|-----------|-----|----------|
| Network error mid-load | Inline error + "Retry" button at list bottom | Tap retries same page |
| Server 500 | Same inline error | Retry with exponential backoff indicator |
| Empty first page | Full-screen empty state | Different from end-of-content |
| Timeout (> 15s) | Inline error | Auto-retry once, then show manual retry |

### SwiftUI — Infinite Scroll

```swift
struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                ItemRow(item: item)
                    .onAppear {
                        if item == viewModel.items.suffix(5).first {
                            viewModel.loadMore()
                        }
                    }
            }
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
            if viewModel.hasReachedEnd {
                Text("You're all caught up")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            }
            if let error = viewModel.paginationError {
                Button("Retry") { viewModel.loadMore() }
                    .frame(maxWidth: .infinity)
            }
        }
        .refreshable { await viewModel.refresh() }
    }
}
```

### Kotlin — Paging 3 with Compose

```kotlin
@Composable
fun FeedScreen(viewModel: FeedViewModel = hiltViewModel()) {
    val items = viewModel.items.collectAsLazyPagingItems()

    LazyColumn {
        items(count = items.itemCount, key = items.itemKey { it.id }) { index ->
            items[index]?.let { ItemRow(it) }
        }
        // Loading indicator
        when (items.loadState.append) {
            is LoadState.Loading -> item {
                CircularProgressIndicator(
                    modifier = Modifier.fillMaxWidth().padding(16.dp)
                        .wrapContentWidth(Alignment.CenterHorizontally)
                )
            }
            is LoadState.Error -> item {
                TextButton(
                    onClick = { items.retry() },
                    modifier = Modifier.fillMaxWidth()
                ) { Text("Retry") }
            }
            is LoadState.NotLoading -> {
                if (items.loadState.append.endOfPaginationReached) {
                    item {
                        Text("You're all caught up",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                            modifier = Modifier.fillMaxWidth().padding(24.dp),
                            textAlign = TextAlign.Center
                        )
                    }
                }
            }
        }
    }
}
```

### Scroll Position Preservation

| Scenario | iOS | Android |
|----------|-----|---------|
| Back navigation | Automatic (UIKit nav stack) | `SavedStateHandle` + `LazyListState` |
| Tab switch | Preserve per-tab scroll position | Same, store in ViewModel |
| Orientation change | UIKit auto-restores, SwiftUI needs `ScrollViewReader` | `rememberLazyListState()` survives recomposition |
| Process death | Save first visible item index + offset to disk | `SavedStateHandle` auto-saves to Bundle |

### Checklist

- ✅ Prefetch starts 5–10 items from bottom
- ✅ Loading indicator visible at list bottom during fetch
- ✅ End-of-content indicator when no more pages
- ✅ Pull-to-refresh resets pagination to page 1
- ✅ Error state with retry at list bottom
- ✅ Scroll position preserved on back navigation
- ✅ Scroll-to-top FAB appears after scrolling 2+ viewports
- ✅ Footer padding (≥ 80dp) so last item clears bottom nav
- ❌ Don't show full-screen spinner for subsequent pages (only first load)
- ❌ Don't reset scroll position on new page load
- ❌ Don't fetch all pages at once (memory + bandwidth)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Loading spinner blocks entire screen on page 2+ | Feels like a new load, not continuation | Inline bottom indicator |
| No end-of-content signal | User keeps scrolling expecting more | Show "all caught up" message |
| Offset pagination on live feed | Duplicated/missing items | Use cursor pagination |
| Trigger at absolute last item | Visible gap before load completes | Trigger at 5th-to-last |
| No scroll position save | Lost position on back nav, frustrating | Persist first visible index |

### Sources

- Android Paging 3: developer.android.com/topic/libraries/architecture/paging/v3-overview
- Infinite Scrolling Best Practices: uxdesign.cc/infinite-scrolling-best-practices
- NNG: Infinite Scrolling Is Not for Every Website (nngroup.com/articles/infinite-scrolling)

---

## BB. Sticky Headers & Section Indexing

### Platform Behavior

| Feature | iOS UIKit | iOS SwiftUI | Android Compose |
|---------|-----------|-------------|-----------------|
| Sticky headers | `UITableView` plain style (default sticky) | `Section { }` in `List` (plain style) | `LazyColumn { stickyHeader { } }` |
| Grouped (non-sticky) | `UITableView` grouped/insetGrouped | `List { Section { } }` grouped style | Standard items (no sticky) |
| Section index | `sectionIndexTitles(for:)` (A-Z sidebar) | No native API (custom overlay) | Custom overlay (no native) |
| Collapse/expand | Manual (`isCollapsed` state) | `DisclosureGroup` | `AnimatedVisibility` toggle |

### Sticky Header Specs

| Parameter | Value | Notes |
|-----------|-------|-------|
| Header height | 28–36dp (compact) / 48dp (standard) | Consistent across sections |
| Background | Surface with elevation tint (level 2) or blur | Differentiate from content |
| Typography | `titleSmall` (M3) / `.subheadline` weight `.semibold` | Smaller than content titles |
| Padding | 16dp horizontal | Align with content |
| Sticking behavior | Pins to top; next header pushes previous up | Default platform behavior |
| Divider | Bottom 1dp, `outlineVariant` | Optional, helps separation |
| Elevation/blur | iOS: `UIBlurEffect(.systemThinMaterial)` / Android: `elevation(3.dp)` | Visual "floating" when stuck |
| Z-index | Above content, below navigation | — |

### Section Index (Alphabetical Sidebar)

```
iOS (UITableView):
┌─────────────────────────────┐
│ Header: A          ▸│A│     │
│ ─────────────       │B│     │
│ Aaron               │C│     │  ← Right-side index
│ Alice               │·│     │     Touch + drag to jump
│ ─────────────       │D│     │     14pt font, 44pt touch target per letter
│ Header: B           │·│     │
│ ─────────────       │E│     │
│ Bob                 │·│     │
│ ...                 │Z│     │
└─────────────────────────────┘

Specs:
- Letter size: 11–12pt / 12sp
- Touch target per letter: 20×44pt / 20×44dp minimum
- Position: Right edge, vertically centered
- Background: semi-transparent on touch
- Haptic: selection tick on each letter change
- Large letter overlay: 60×60dp centered, shown during drag
```

### SwiftUI — Sticky Sections

```swift
List {
    ForEach(groupedContacts, id: \.key) { section in
        Section(header: Text(section.key)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(nil)
        ) {
            ForEach(section.contacts) { contact in
                ContactRow(contact: contact)
            }
        }
    }
}
.listStyle(.plain) // .plain = sticky headers, .insetGrouped = non-sticky
```

### Kotlin — Compose Sticky Headers

```kotlin
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun ContactList(groupedContacts: Map<Char, List<Contact>>) {
    LazyColumn {
        groupedContacts.forEach { (letter, contacts) ->
            stickyHeader(key = letter) {
                Surface(
                    modifier = Modifier.fillMaxWidth(),
                    color = MaterialTheme.colorScheme.surfaceContainerLow,
                    tonalElevation = 2.dp
                ) {
                    Text(
                        text = letter.toString(),
                        style = MaterialTheme.typography.titleSmall,
                        modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
            items(contacts, key = { it.id }) { contact ->
                ContactRow(contact)
            }
        }
    }
}
```

### Collapse/Expand Sections

| Spec | Value |
|------|-------|
| Chevron icon | `chevron.right` / `ExpandMore` | Rotates 90° on expand |
| Animation | 250ms ease-in-out | Content height animates |
| Default state | Expanded (unless user preference saved) |
| Persist state | Per section, stored in local prefs |
| Accessibility | `accessibilityTraits: .button`, announce "collapsed" / "expanded" |
| Content clip | Clip to bounds during animation | Prevents content overflow |

### Checklist

- ✅ Sticky headers have distinct background (blur/tint) from content
- ✅ Headers use smaller/secondary typography (not competing with content)
- ✅ Section index has haptic feedback per letter during drag
- ✅ Collapse/expand state persisted across sessions
- ✅ Accessibility: headers are announced, collapse state communicated
- ✅ Large letter overlay shown during fast section index scroll
- ❌ Don't use sticky headers in short lists (< 3 sections)
- ❌ Don't make headers too tall (> 48dp steals content space)
- ❌ Don't combine sticky headers with pull-to-refresh without testing (overlap risk)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Sticky header same style as content rows | Can't distinguish header from item | Use surface tint / blur |
| Section index with < 10 sections | Unnecessary, clutters UI | Only use for 15+ sections |
| Collapsed by default on first visit | User doesn't see content exists | Default expanded, let user collapse |
| No animation on collapse | Jarring content jump | Animate height 250ms |
| Sticky header covering content on tap | Header overlaps tappable item below | Ensure proper z-ordering + padding |

### Sources

- Apple HIG — Lists: developer.apple.com/design/human-interface-guidelines/lists-and-tables
- LazyColumn stickyHeader: developer.android.com/reference/kotlin/androidx/compose/foundation/lazy/LazyListScope#stickyHeader
- Contacts app pattern (iOS/Android reference)

---

## BC. Crash Recovery & State Restoration

### Platform State Saving Mechanisms

| Mechanism | Platform | Scope | Survives Process Death | Max Size |
|-----------|----------|-------|----------------------|----------|
| `onSaveInstanceState` / `Bundle` | Android | Activity/Fragment | ✅ | ~500KB (TransactionTooLargeException if exceeded) |
| `SavedStateHandle` (ViewModel) | Android | ViewModel | ✅ | Same as Bundle |
| `rememberSaveable` | Compose | Composable | ✅ | Same as Bundle |
| `NSUserActivity` | iOS | Scene | ✅ (state restoration) | Reasonable (system managed) |
| `@SceneStorage` | SwiftUI | Scene | ✅ | Simple types (String, Int, URL, Data) |
| `@AppStorage` | SwiftUI | App-wide | ✅ | UserDefaults limits (~1MB practical) |
| `NSCoder` + `restorationIdentifier` | UIKit | ViewController | ✅ | System managed |

### What to Save

| Data Type | Where to Save | Example |
|-----------|---------------|---------|
| Navigation stack | SavedStateHandle / NSUserActivity | Current screen + back stack |
| Form input (draft) | SavedStateHandle / @SceneStorage | Partially filled form |
| Scroll position | ViewModel (survives config change) + Bundle (survives process death) | First visible item index |
| Tab selection | SavedStateHandle / @SceneStorage | Active tab index |
| Search query | SavedStateHandle / @SceneStorage | Current filter text |
| List selection | SavedStateHandle | Selected item IDs |
| Media playback position | Local DB (Room/CoreData) | Timestamp in ms |
| User preferences | SharedPreferences / UserDefaults | Theme, language |

### Auto-Save Draft Frequency

| Content Type | Save Interval | Storage |
|-------------|---------------|---------|
| Short form (1–5 fields) | On every field change (debounced 500ms) | SavedStateHandle / @SceneStorage |
| Long text (notes, email) | Every 5–10 seconds + on background | Local DB |
| Rich content (editor) | Every 15–30 seconds + on background | Local DB + cloud sync |
| File upload in progress | Track progress offset | Local DB |

### iOS — State Restoration

```swift
// SwiftUI: @SceneStorage for lightweight state
struct ContentView: View {
    @SceneStorage("selectedTab") private var selectedTab = 0
    @SceneStorage("draftText") private var draftText = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag(0)
            ComposeView(draft: $draftText).tag(1)
            SettingsView().tag(2)
        }
    }
}

// UIKit: NSUserActivity-based restoration
class EditorViewController: UIViewController {
    override func updateUserActivityState(_ activity: NSUserActivity) {
        activity.addUserInfoEntries(from: [
            "documentID": documentID,
            "cursorPosition": textView.selectedRange.location,
            "scrollOffset": scrollView.contentOffset.y
        ])
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if let docID = activity.userInfo?["documentID"] as? String {
            loadDocument(docID)
        }
    }
}
```

### Android — SavedStateHandle + Compose

```kotlin
@HiltViewModel
class FormViewModel @Inject constructor(
    private val savedStateHandle: SavedStateHandle
) : ViewModel() {
    // Survives both config change AND process death
    var name by savedStateHandle.saveable { mutableStateOf("") }
    var email by savedStateHandle.saveable { mutableStateOf("") }
    val selectedTab = savedStateHandle.getStateFlow("tab", 0)
    
    fun selectTab(index: Int) { savedStateHandle["tab"] = index }
}

// Compose: rememberSaveable for UI-local state
@Composable
fun SearchScreen() {
    var query by rememberSaveable { mutableStateOf("") }
    val listState = rememberLazyListState()
    // listState automatically saved/restored with rememberSaveable internally
    
    LazyColumn(state = listState) { /* ... */ }
}
```

### Crash Detection & Recovery Dialog

```
App crashed → User relaunches:

┌──────────────────────────────┐
│                              │
│  "Welcome Back"              │
│                              │
│  We noticed the app closed   │
│  unexpectedly. Your draft    │
│  has been saved.             │
│                              │
│  ┌────────────────────────┐  │
│  │   Resume Where I Was   │  │  ← Primary: restore state
│  └────────────────────────┘  │
│                              │
│      Start Fresh             │  ← Secondary: clean state
│                              │
└──────────────────────────────┘
```

| Detection Method | Platform | Implementation |
|-----------------|----------|----------------|
| `didTerminateUnexpectedly` flag | Both | Set flag on launch, clear on clean exit/background |
| Firebase Crashlytics `didCrashOnPreviousExecution()` | Both | Third-party SDK |
| `ApplicationExitInfo.REASON_CRASH` | Android (API 30+) | `ActivityManager.getHistoricalProcessExitReasons()` |
| `MetricKit` crash diagnostics | iOS | `MXCrashDiagnostic` in `didReceive(_:)` |

### ViewModel Survival (Android Config Changes)

| Config Change | ViewModel Survives | SavedStateHandle Survives | Bundle Survives |
|--------------|-------------------|--------------------------|-----------------|
| Rotation | ✅ | ✅ | ✅ |
| Language change | ✅ | ✅ | ✅ |
| Dark mode toggle | ✅ | ✅ | ✅ |
| Process death (low memory) | ❌ | ✅ | ✅ |
| Force stop | ❌ | ❌ | ❌ |
| App update | ❌ | ❌ | ❌ |

### Checklist

- ✅ Form data auto-saved on field change (debounced) and on `onPause`/`scenePhase .background`
- ✅ Navigation stack restored after process death
- ✅ Scroll position preserved across config changes
- ✅ Crash detection shows recovery dialog on next launch
- ✅ Draft recovery offered for long-form content
- ✅ Tested with "Don't keep activities" developer option (Android)
- ✅ SavedStateHandle used for all ViewModel state that must survive process death
- ❌ Don't store large objects (bitmaps, full lists) in Bundle (500KB limit)
- ❌ Don't assume ViewModel survives process death (it doesn't)
- ❌ Don't skip restoration testing (most under-tested area)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| All state in ViewModel, none in SavedStateHandle | Lost on process death | Use `savedStateHandle.saveable` for critical state |
| Storing Parcelable list > 500KB in Bundle | `TransactionTooLargeException` crash | Store IDs only, re-fetch data |
| No auto-save on backgrounding | User loses work on process kill | Save in `onPause` / `scenePhase` observer |
| Ignoring iOS scene restoration | State lost on memory pressure | Implement `NSUserActivity` or `@SceneStorage` |
| Crash recovery with no user choice | Restoring corrupted state loops crash | Offer "Start Fresh" option |

### Sources

- Android Saved State: developer.android.com/topic/libraries/architecture/saving-states
- iOS State Restoration: developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches
- @SceneStorage: developer.apple.com/documentation/swiftui/scenestorage
- TransactionTooLargeException: developer.android.com/reference/android/os/TransactionTooLargeException

---

## BD. Force Update & Soft Update

### Update Type Comparison

| Attribute | Force Update (Hard Block) | Soft Update (Banner) |
|-----------|--------------------------|----------------------|
| Use case | Security vulnerability, broken API, legal compliance | New features, improvements, performance |
| UI | Full-screen blocking dialog, no dismiss | Banner or dialog with "Later" option |
| Frequency | Rare (1-2x per year) | As needed per release |
| User can skip | ❌ No | ✅ Yes |
| App usable | ❌ No (blocked) | ✅ Yes |
| Grace period | None (immediate) | 7–30 days before escalating |

### Version Checking Strategy

| Check Point | When | Method |
|-------------|------|--------|
| App launch | Every cold start | Remote config / API call |
| Resume from background | If > 4 hours since last check | Same |
| Periodic (in-session) | Every 24 hours while active | Silent background check |
| Server response header | Every API call | `X-Min-Version` response header |

### Force Update Screen

```
┌──────────────────────────────┐
│                              │
│      ┌──────────────┐        │
│      │  [App Icon]  │        │
│      └──────────────┘        │
│                              │
│     "Update Required"        │
│                              │
│  A new version is available  │
│  with important security     │
│  fixes. Please update to     │
│  continue.                   │
│                              │
│  Version 2.4.0 available     │
│  (You have 2.2.1)            │
│                              │
│  ┌────────────────────────┐  │
│  │    Update Now           │  │  ← Opens store
│  └────────────────────────┘  │
│                              │
│  No "Skip" or "Later"       │  ← Intentionally absent
│  No system back dismissal    │
└──────────────────────────────┘
```

### Soft Update Banner

```
┌──────────────────────────────────────────────┐
│ ┌──────────────────────────────────────────┐ │
│ │ [↑] A new version is available.  [Update]│ │  ← Dismissible banner
│ │     Tap to see what's new.       [Later] │ │     at top of home
│ └──────────────────────────────────────────┘ │
│                                              │
│  [Normal app content below]                  │
└──────────────────────────────────────────────┘

Escalation:
Day 1–7:   Subtle banner (dismissible, 1x/session)
Day 8–14:  Prominent banner (persistent, top of home)
Day 15–30: Dialog on launch (dismissible, 1x/day)
Day 30+:   Consider force update if critical
```

### Android — In-App Updates API

```kotlin
class MainActivity : ComponentActivity() {
    private val appUpdateManager by lazy { AppUpdateManagerFactory.create(this) }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        checkForUpdate()
    }
    
    private fun checkForUpdate() {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { info ->
            when {
                // Force update: IMMEDIATE blocks the app
                info.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                    && info.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
                    && isForceUpdateRequired(info.availableVersionCode()) -> {
                    appUpdateManager.startUpdateFlowForResult(
                        info, AppUpdateType.IMMEDIATE, this, UPDATE_REQUEST_CODE
                    )
                }
                // Soft update: FLEXIBLE downloads in background
                info.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
                    && info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE) -> {
                    appUpdateManager.startUpdateFlowForResult(
                        info, AppUpdateType.FLEXIBLE, this, UPDATE_REQUEST_CODE
                    )
                }
            }
        }
    }
    
    // For IMMEDIATE: check if update is stalled on resume
    override fun onResume() {
        super.onResume()
        appUpdateManager.appUpdateInfo.addOnSuccessListener { info ->
            if (info.updateAvailability() == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                appUpdateManager.startUpdateFlowForResult(
                    info, AppUpdateType.IMMEDIATE, this, UPDATE_REQUEST_CODE
                )
            }
        }
    }
}
```

### iOS — App Store Redirect

```swift
func checkForUpdate() async {
    guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
          let config = try? await RemoteConfig.shared.fetch(),
          let minVersion = config.string(forKey: "min_app_version"),
          let latestVersion = config.string(forKey: "latest_version") else { return }
    
    if currentVersion.compare(minVersion, options: .numeric) == .orderedAscending {
        showForceUpdate(version: latestVersion)
    } else if currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
        showSoftUpdate(version: latestVersion)
    }
}

func openAppStore() {
    // Replace with your App Store ID
    let appID = "123456789"
    if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") {
        UIApplication.shared.open(url)
    }
}

// Note: iOS has no native in-app update flow like Android
// SKStoreProductViewController can show App Store page in-app
```

### Changelog Display

| Guideline | Value |
|-----------|-------|
| Max items | 3–5 bullet points |
| Format | "• [Feature/Fix]: Short description" |
| Tone | Benefit-focused, not technical |
| Length per item | ≤ 1 line (≤ 80 chars) |
| Include version number | ✅ "What's new in v2.4.0" |
| Expandable "Read more" | For detailed changelog |

### Checklist

- ✅ Force update only for security/breaking API issues
- ✅ Version check on launch + resume (if > 4h)
- ✅ Force update screen has no dismiss/back capability
- ✅ Soft update has "Later" option with respectful frequency
- ✅ Soft update escalates over time (banner → dialog)
- ✅ Android uses In-App Updates API (IMMEDIATE/FLEXIBLE)
- ✅ iOS redirects to App Store (no native in-app update)
- ✅ Changelog is benefit-focused, 3–5 items
- ❌ Don't force update for minor features
- ❌ Don't check version on every API call (use response headers passively)
- ❌ Don't show update prompt during critical flows (checkout, upload)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Force update for every release | Users feel hostage, uninstall | Reserve for critical security/API breaks |
| No grace period on soft update | Annoying | Allow 7–30 days before escalating |
| Update dialog during checkout | Abandoned purchase | Suppress during critical user flows |
| No version comparison logic | Prompts for same/older version | Semantic version comparison (major.minor.patch) |
| Pointing to wrong store listing | 404, user can't update | Test deep link on both platforms |

### Sources

- Android In-App Updates: developer.android.com/guide/playcore/in-app-updates
- SKStoreProductViewController: developer.apple.com/documentation/storekit/skstoreproductviewcontroller
- Firebase Remote Config: firebase.google.com/docs/remote-config

---

## BE. Bottom Sheet Patterns (Detailed)

### iOS Detent System (iOS 16+)

| Detent | Height | Use Case |
|--------|--------|----------|
| `.medium` | ~50% of screen | Actions menu, filter panel |
| `.large` | ~100% (full with top margin) | Extended content, forms |
| Custom fraction | `.fraction(0.25)` | Compact picker (25%) |
| Custom height | `.height(200)` | Fixed-height content |

### Android BottomSheetBehavior States

| State | Description | Trigger |
|-------|-------------|---------|
| `STATE_COLLAPSED` | Peek height visible | Default, drag down |
| `STATE_EXPANDED` | Full height | Drag up past half |
| `STATE_HALF_EXPANDED` | 50% height (ratio configurable) | Drag to middle |
| `STATE_HIDDEN` | Off screen | Drag below peek, programmatic |
| `STATE_DRAGGING` | User is dragging | Active gesture |
| `STATE_SETTLING` | Animating to target | Released, snapping |

### Visual Specs

| Element | Value | Notes |
|---------|-------|-------|
| Drag indicator (handle) | 36×5dp, 4dp corner radius | Centered, 8dp from top |
| Drag indicator color | `onSurfaceVariant` @ 40% | Subtle but visible |
| Top corner radius | 28dp (M3) / 10pt (iOS default) | Only top-left + top-right |
| Scrim (modal) | `#000000` @ 32% (M3) / system default (iOS) | Tap to dismiss |
| Elevation | Level 1 (1dp) modal, Level 0 persistent | M3 surface tint |
| Min peek height | 56dp | Enough for drag handle + title |
| Max height | Screen height - status bar (or safe area) | Never cover status bar |
| Animation (drag release → settle) | 300ms, standard easing | Spring for iOS |

### Modal vs Persistent

| Attribute | Modal Bottom Sheet | Persistent (Standard) |
|-----------|-------------------|----------------------|
| Scrim | ✅ Yes (blocks content) | ❌ No |
| Dismiss on scrim tap | ✅ Yes | N/A |
| Content scrollable behind | ❌ No | ✅ Yes |
| Use case | Actions, confirmations, selections | Map controls, mini player |
| Back/swipe dismiss | ✅ Yes | ✅ (to collapsed) |

### Keyboard Coexistence

- Sheet must resize to accommodate keyboard
- Content scrolls up so focused input stays visible
- iOS: `sheet` with `.presentationDetents` auto-adjusts
- Android: `WindowInsets.ime` padding, `softInputMode = adjustResize`

### SwiftUI — Bottom Sheet

```swift
.sheet(isPresented: $showSheet) {
    FilterView()
        .presentationDetents([.medium, .large, .fraction(0.25)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        // ^ allows interacting with content behind when at .medium
}
```

### Kotlin — Compose Modal Bottom Sheet

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FilterSheet(onDismiss: () -> Unit) {
    val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = false)
    
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        sheetState = sheetState,
        dragHandle = { BottomSheetDefaults.DragHandle() }, // 36×4dp auto
        shape = RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp),
        containerColor = MaterialTheme.colorScheme.surface,
        scrimColor = MaterialTheme.colorScheme.scrim.copy(alpha = 0.32f)
    ) {
        Column(Modifier.padding(16.dp).navigationBarsPadding()) {
            Text("Filters", style = MaterialTheme.typography.titleLarge)
            Spacer(Modifier.height(16.dp))
            // Filter content
        }
    }
}
```

### Checklist

- ✅ Drag indicator visible and centered (36×5dp)
- ✅ Multiple detents for flexible sizing (iOS: medium/large, Android: collapsed/half/expanded)
- ✅ Modal sheet has scrim; tap scrim to dismiss
- ✅ Sheet adjusts when keyboard appears
- ✅ Nested scroll works inside sheet (scrollable content)
- ✅ Accessibility: sheet announced, dismiss via back/swipe
- ❌ Don't nest a bottom sheet inside another bottom sheet
- ❌ Don't use bottom sheet for critical confirmations (use dialog)
- ❌ Don't cover the entire screen without leaving room for scrim tap

### Sources

- Apple: developer.apple.com/documentation/swiftui/presentationdetent
- Material Design 3 — Bottom Sheets: m3.material.io/components/bottom-sheets
- ModalBottomSheet Compose: developer.android.com/reference/kotlin/androidx/compose/material3/package-summary#ModalBottomSheet

---

## BF. Parallax & Scroll Effects

### Collapsing Toolbar Parallax

| Parameter | Value | Notes |
|-----------|-------|-------|
| Parallax factor | 0.5 (image scrolls at 50% of content speed) | Standard value; 0.3–0.7 range acceptable |
| Expanded height | 200–300dp | Contains hero image + title overlay |
| Collapsed height | 56–64dp (standard app bar) | Title + nav icon only |
| Collapse animation | Continuous (scroll-linked) | Not animated on timer |
| Title transition | Large (28sp) → standard (22sp) | Fade + scale during collapse |
| Elevation on collapse | 0dp (expanded) → 3dp (collapsed) | Or surface tint level 2 |

### iOS — Large Title Collapse

```swift
NavigationStack {
    ScrollView {
        LazyVStack { /* content */ }
    }
    .navigationTitle("Feed")
    .navigationBarTitleDisplayMode(.large)
    // iOS automatically collapses large title → inline on scroll
    // Large: 34pt bold, left-aligned
    // Inline: 17pt semibold, centered
}

// Custom parallax header
struct ParallaxHeader: View {
    let image: Image
    let height: CGFloat = 300
    
    var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            image
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: max(height + (minY > 0 ? minY : 0), 0))
                .offset(y: minY > 0 ? -minY * 0.5 : -minY * 0.3)
                .clipped()
        }
        .frame(height: height)
    }
}
```

### Android — CollapsingToolbarLayout / Compose

```kotlin
// Compose: Collapsing toolbar with parallax
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CollapsingScreen() {
    val scrollBehavior = TopAppBarDefaults.exitUntilCollapsedScrollBehavior()
    
    Scaffold(
        topBar = {
            LargeTopAppBar(
                title = { Text("Feed") },
                scrollBehavior = scrollBehavior,
                navigationIcon = { IconButton(onClick = {}) { Icon(Icons.AutoMirrored.Filled.ArrowBack, null) } }
            )
        },
        modifier = Modifier.nestedScroll(scrollBehavior.nestedScrollConnection)
    ) { padding ->
        LazyColumn(contentPadding = padding) { /* content */ }
    }
}

// Custom parallax with offset
@Composable
fun ParallaxImage(scrollState: LazyListState, imageUrl: String) {
    val parallaxOffset = remember {
        derivedStateOf {
            if (scrollState.firstVisibleItemIndex == 0) {
                scrollState.firstVisibleItemScrollOffset * 0.5f
            } else 0f
        }
    }
    AsyncImage(
        model = imageUrl,
        modifier = Modifier
            .fillMaxWidth()
            .height(300.dp)
            .graphicsLayer { translationY = parallaxOffset.value }
    )
}
```

### Overscroll Behavior

| Platform | Default | Effect | Customization |
|----------|---------|--------|---------------|
| iOS | Bounce (rubber-band) | Content bounces past edge | `.scrollBounceBehavior(.basedOnSize)` to disable if content fits |
| Android 12+ | Stretch (EdgeEffect) | Content stretches at edges | `overScrollMode = OVER_SCROLL_NEVER` to disable |
| Android < 12 | Glow | Blue glow at edge | Replaced by stretch in 12+ |

### Performance Tips

| Tip | Details |
|-----|---------|
| Use `graphicsLayer` (Compose) / `transform` (iOS) | GPU-accelerated, avoids re-layout |
| Don't recalculate complex layouts on every scroll pixel | Derive state, throttle if needed |
| Avoid alpha animation on large surfaces | Causes overdraw; prefer clip or translation |
| Test at 60fps on mid-range devices | Galaxy A-series, iPhone SE |
| Reduce motion: disable parallax entirely | Check `UIAccessibility.isReduceMotionEnabled` / `ANIMATOR_DURATION_SCALE` |

### Reduced Motion Compliance

When Reduce Motion is enabled:
- Parallax factor → 0 (image scrolls with content, no parallax)
- Overscroll bounce/stretch → minimal or none
- Collapsing toolbar → instant snap (no smooth collapse)
- All scroll-linked animations → disabled

### Checklist

- ✅ Parallax factor 0.3–0.7 (0.5 standard)
- ✅ Collapsing toolbar transitions smoothly between expanded/collapsed
- ✅ Title text transitions from large to small with scroll
- ✅ Performance: use GPU-accelerated transforms only
- ✅ Reduced motion disables parallax entirely
- ✅ Test on low-end devices at 60fps
- ❌ Don't apply parallax to interactive elements (buttons become untappable)
- ❌ Don't use parallax on screens with heavy content (list + images = jank risk)
- ❌ Don't combine multiple scroll effects on the same screen

### Sources

- Material Design 3 — Top App Bar: m3.material.io/components/top-app-bar
- Apple HIG — Navigation Bars: developer.apple.com/design/human-interface-guidelines/navigation-bars
- CollapsingToolbarLayout: developer.android.com/reference/com/google/android/material/appbar/CollapsingToolbarLayout

---

## BG. Split View & Multi-Window

### Window Size Classes

| Class | Width | Examples | Nav Pattern |
|-------|-------|---------|-------------|
| Compact | < 600dp | Phone portrait | Bottom nav |
| Medium | 600–840dp | Tablet portrait, foldable inner | Navigation rail |
| Expanded | > 840dp | Tablet landscape, desktop | Navigation rail + permanent detail |

### Adaptive Layout Table

| Width | List-Detail | Navigation | Columns |
|-------|-------------|------------|---------|
| < 600dp (Compact) | Stacked (list → detail push) | Bottom nav (3–5 items) | 1 column |
| 600–840dp (Medium) | List pane (360dp) + detail pane | Navigation rail (80dp) | 2 columns |
| > 840dp (Expanded) | List pane (360dp) + detail pane (fill) | Navigation rail (80dp) + labels | 2–3 columns |

### Android Split-Screen & Multi-Window

| Property | Value | Notes |
|----------|-------|-------|
| Min width for split | 220dp | System enforced |
| `resizeableActivity` | `true` (default since API 24) | Set `false` to opt out (not recommended) |
| Config change on resize | `screenSize | smallestScreenSize | screenLayout` | Handle in manifest or ViewModel |
| Drag-drop between apps | `View.startDragAndDrop()` + `OnDragListener` | API 24+, requires ClipData |
| Freeform windows | Some OEMs (Samsung DeX, ChromeOS) | Test `isInMultiWindowMode` |

### iOS iPad Multi-Window

| Feature | API | Notes |
|---------|-----|-------|
| Split View | `UISceneDelegate`, `UIWindowScene` | 1/3, 1/2, 2/3 splits |
| Slide Over | Automatic if app supports split | Compact width in overlay |
| Stage Manager (iPadOS 16+) | Resizable windows, overlapping | Test all sizes dynamically |
| `UIScene` activation | `UIApplication.shared.requestSceneSessionActivation()` | Open new window |

### SwiftUI — Adaptive Navigation

```swift
struct ContentView: View {
    @State private var selectedItem: Item?
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .compact {
            // Phone: stacked navigation
            NavigationStack {
                ItemListView(selection: $selectedItem)
                    .navigationDestination(item: $selectedItem) { item in
                        ItemDetailView(item: item)
                    }
            }
        } else {
            // Tablet: side-by-side
            NavigationSplitView {
                ItemListView(selection: $selectedItem)
            } detail: {
                if let item = selectedItem {
                    ItemDetailView(item: item)
                } else {
                    Text("Select an item")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationSplitViewColumnWidth(min: 300, ideal: 360, max: 420)
        }
    }
}
```

### Kotlin — Adaptive Layout

```kotlin
@Composable
fun AdaptiveListDetail(windowSizeClass: WindowSizeClass) {
    val navigator = rememberListDetailPaneScaffoldNavigator<ItemId>()
    
    ListDetailPaneScaffold(
        directive = navigator.scaffoldDirective,
        value = navigator.scaffoldValue,
        listPane = {
            AnimatedPane {
                ItemList(onItemClick = { id ->
                    navigator.navigateTo(ListDetailPaneScaffoldRole.Detail, id)
                })
            }
        },
        detailPane = {
            AnimatedPane {
                navigator.currentDestination?.content?.let { id ->
                    ItemDetail(id)
                } ?: PlaceholderDetail()
            }
        }
    )
}

// WindowSizeClass calculation
@Composable
fun calculateWindowSizeClass(activity: Activity): WindowSizeClass {
    return WindowSizeClass.calculateFromSize(
        // Use window metrics API
        size = DpSize(widthDp, heightDp)
    )
}
```

### Checklist

- ✅ Test at compact (< 600dp), medium (600–840dp), expanded (> 840dp)
- ✅ Navigation switches from bottom nav → rail at medium width
- ✅ List-detail shows side-by-side at medium+ width
- ✅ `resizeableActivity = true` (Android default, don't opt out)
- ✅ Handle configuration changes on window resize
- ✅ iPad: test Split View (1/3, 1/2, 2/3) and Stage Manager
- ✅ Drag-and-drop between windows implemented for content apps
- ❌ Don't assume fixed screen size (foldables change at runtime)
- ❌ Don't hide navigation in expanded layouts (use persistent rail)
- ❌ Don't break at intermediate sizes (test 600dp boundary)

### Sources

- WindowSizeClass: developer.android.com/guide/topics/large-screens/support-different-screen-sizes
- NavigationSplitView: developer.apple.com/documentation/swiftui/navigationsplitview
- ListDetailPaneScaffold: developer.android.com/reference/kotlin/androidx/compose/material3/adaptive/layout
- Apple HIG — Layout: developer.apple.com/design/human-interface-guidelines/layout

---

## BH. Picture-in-Picture

### Platform Specs

| Spec | iOS | Android |
|------|-----|---------|
| API | `AVPictureInPictureController` | `PictureInPictureParams.Builder` |
| Min OS | iOS 14 (iPhone), iOS 9 (iPad) | Android 8.0 (API 26) |
| Aspect ratio range | 2.39:1 to 1:2.39 (auto from video) | 1:2.39 to 2.39:1 |
| Default size | System managed (~1/4 screen) | System managed |
| Resizable | ✅ Pinch to resize | ✅ Pinch to resize (Android 12+) |
| Stash (hide to edge) | ✅ (iOS 14+, swipe to edge) | ❌ |
| Auto-enter on home | `canStartPictureInPictureAutomaticallyFromInline = true` | `setAutoEnterEnabled(true)` (API 31+) |

### PiP Controls

| Control | iOS | Android |
|---------|-----|---------|
| Play/Pause | ✅ System default | ✅ System default |
| Skip forward/back | ✅ (if implemented) | ✅ Custom actions (max 3) |
| Close (return to full) | ✅ Expand button | ✅ Expand button |
| Dismiss | ✅ X button → minimizes or closes | ✅ X button or swipe down |
| Seek bar | ❌ Not in PiP | ❌ Not in PiP |

### iOS — PiP Setup

```swift
import AVKit

class VideoPlayerController: UIViewController {
    var pipController: AVPictureInPictureController?
    let playerLayer: AVPlayerLayer
    
    func setupPiP() {
        guard AVPictureInPictureController.isPictureInPictureSupported() else { return }
        pipController = AVPictureInPictureController(playerLayer: playerLayer)
        pipController?.canStartPictureInPictureAutomaticallyFromInline = true
        pipController?.delegate = self
    }
}

extension VideoPlayerController: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ controller: AVPictureInPictureController) {
        // Minimize player UI
    }
    func pictureInPictureController(_ controller: AVPictureInPictureController,
                                     restoreUserInterfaceForPictureInPictureStopWithCompletionHandler
                                     completionHandler: @escaping (Bool) -> Void) {
        // Restore full UI
        completionHandler(true)
    }
}
```

### Android — PiP Setup

```kotlin
class VideoActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Declare in manifest: android:supportsPictureInPicture="true"
        // android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"
    }
    
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        enterPipMode()
    }
    
    private fun enterPipMode() {
        val params = PictureInPictureParams.Builder()
            .setAspectRatio(Rational(16, 9))
            .setAutoEnterEnabled(true) // API 31+
            .setActions(listOf(
                RemoteAction(
                    Icon.createWithResource(this, R.drawable.ic_pause),
                    "Pause", "Pause playback",
                    PendingIntent.getBroadcast(this, 0,
                        Intent("PAUSE_ACTION"),
                        PendingIntent.FLAG_IMMUTABLE)
                )
            ))
            .build()
        enterPictureInPictureMode(params)
    }
    
    override fun onPictureInPictureModeChanged(isInPipMode: Boolean, newConfig: Configuration) {
        if (isInPipMode) {
            // Hide non-essential UI (controls, text)
        } else {
            // Restore full UI
        }
    }
}
```

### Seamless Transition Tips

- Hide UI controls before entering PiP (no overlapping buttons in tiny window)
- Scale animation handled by system
- Keep video playing; don't restart
- On restore: re-show controls, maintain playback position
- Test aspect ratio edge cases (vertical video = very tall PiP)

### Checklist

- ✅ Auto-enter PiP on home press (opt-in, not forced)
- ✅ Aspect ratio set correctly for content (16:9, 4:3, etc.)
- ✅ Non-essential UI hidden in PiP mode
- ✅ Play/pause action available in PiP
- ✅ Seamless restore to full screen (maintain position)
- ✅ Manifest declares `supportsPictureInPicture` + config changes (Android)
- ❌ Don't force PiP on user (respect preference)
- ❌ Don't show text overlays in PiP (too small to read)
- ❌ Don't stop playback when entering PiP

### Sources

- AVPictureInPictureController: developer.apple.com/documentation/avkit/avpictureinpicturecontroller
- Android PiP: developer.android.com/develop/ui/views/picture-in-picture
- Material Design — Video: material.io/design/communication/video.html

---

## BI. Clipboard & Pasteboard UX

### iOS Paste Permission (iOS 16+)

| Behavior | Version | User Experience |
|----------|---------|-----------------|
| System paste alert | iOS 16.0 | "App would like to paste from [OtherApp]" — Allow/Don't Allow |
| `UIPasteControl` | iOS 16.0 | System-rendered button; tapping grants paste without prompt |
| Programmatic `UIPasteboard.general.string` | iOS 16+ | Triggers system alert |
| Confirm on first paste per app session | iOS 16+ | Subsequent pastes in same session: no re-prompt |

### Platform API Comparison

| Feature | iOS | Android |
|---------|-----|---------|
| Read clipboard | `UIPasteboard.general.string` (prompts in iOS 16+) | `ClipboardManager.getPrimaryClip()` |
| Write clipboard | `UIPasteboard.general.string = "text"` | `ClipboardManager.setPrimaryClip(ClipData.newPlainText(...))` |
| Rich content | `UIPasteboard.general.items` (UTType) | `ClipData` with MIME types |
| Clipboard overlay | ❌ N/A | ✅ Android 13+: shows "Copied to clipboard" toast with edit/share |
| Auto-clear | After ~2 min if `localOnly = true` (iPadOS) | Android 13+: clipboard auto-clears after 1 hour for sensitive content |
| Privacy indicator | Status bar green dot (iOS 16+) if accessed | Android 12+: toast "App pasted from clipboard" |

### Paste Detection & Smart Actions

| Content Type | Detection | Action |
|-------------|-----------|--------|
| OTP code (6-digit) | `UITextContentType.oneTimeCode` / Autofill | Auto-fill OTP field |
| URL | `URL(string:)` / `Patterns.WEB_URL` | "Open link from clipboard?" banner |
| Address | `CNPostalAddress` / geocoder | "Navigate to copied address?" |
| Phone number | `NSDataDetector(.phoneNumber)` / `Patterns.PHONE` | "Call copied number?" |
| Tracking number | Regex pattern match | "Track package?" |

### UIPasteControl (iOS)

```swift
// System-rendered paste button — no permission prompt
UIPasteControl(configuration: .init())
    // Customization limited: system renders to prevent spoofing
    // Placed near text field for contextual paste

// SwiftUI wrapper
struct PasteButton: View {
    var body: some View {
        PasteButton(payloadType: String.self) { strings in
            if let text = strings.first {
                handlePaste(text)
            }
        }
    }
}
```

### Clipboard Banner Pattern

```
User copies a URL, switches to your app:

┌──────────────────────────────────────────────┐
│ ┌──────────────────────────────────────────┐ │
│ │ 📋 Open "https://example.com"    [Open]  │ │  ← Auto-detected
│ │    from clipboard               [Dismiss]│ │     1x per clipboard change
│ └──────────────────────────────────────────┘ │
│                                              │
│  [Normal app content]                        │
└──────────────────────────────────────────────┘

Timing: Show within 500ms of app foregrounding
Duration: Auto-dismiss after 8s or manual
Frequency: Only when clipboard content changed since last check
Privacy: Check clipboard ONLY if relevant to app function
```

### Universal Clipboard (Handoff)

| Feature | Requirement | Notes |
|---------|-------------|-------|
| iOS ↔ Mac | Same iCloud account, Bluetooth + WiFi on | Automatic, no API needed |
| Delay | 1–3s for text, longer for images | Show loading indicator if pasting |
| Large content | Transferred on demand when paste occurs | May show progress |
| Privacy | Same as local clipboard permissions | iOS 16+ paste prompt applies |

### Checklist

- ✅ Use `UIPasteControl` on iOS 16+ to avoid permission prompts
- ✅ Only access clipboard when user initiates paste or app function requires it
- ✅ Show clipboard content banner only when content is relevant to app
- ✅ Support OTP auto-fill via `textContentType(.oneTimeCode)`
- ✅ Confirm before acting on clipboard content (don't auto-navigate)
- ✅ Copy confirmation: show snackbar "Copied to clipboard"
- ❌ Don't read clipboard on every app launch (privacy violation, iOS blocks it)
- ❌ Don't store clipboard content permanently
- ❌ Don't access clipboard in background

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Reading clipboard on every `viewDidAppear` | Privacy alert spam (iOS 16+), user distrust | Only read when user taps paste or relevant |
| No paste confirmation | User doesn't know clipboard was accessed | Show brief banner with content preview |
| Auto-navigating to clipboard URL | Unexpected behavior, security risk | Ask user first with preview |
| Ignoring `UIPasteControl` | Triggers system alert every time | Use system paste button |
| Storing clipboard to analytics | Privacy violation, App Store rejection | Never log clipboard content |

### Sources

- UIPasteControl: developer.apple.com/documentation/uikit/uipastecontrol
- Android ClipboardManager: developer.android.com/develop/copy-paste
- iOS 16 Clipboard Privacy: developer.apple.com/videos/play/wwdc2022/10063/

---

## BJ. Audio/Video Player UX

### Mini Player (Persistent Bottom Bar)

| Spec | Value | Notes |
|------|-------|-------|
| Height | 56–64dp | Above bottom nav |
| Content | Thumbnail (40dp) + title + play/pause + close/expand | Minimal controls |
| Tap | Expands to full player | Not just play/pause |
| Swipe up | Expands to full player | Alternative to tap |
| Swipe down | Dismisses / stops playback | Optional |
| Background | Surface container + elevation 2 | Distinct from nav bar |
| Progress bar | 2dp height at top of mini player, primary color | Shows elapsed position |

### Full-Screen Player Layout

```
┌──────────────────────────────────────┐
│  ← Back              🔽 Minimize     │  ← Navigation
│                                      │
│  ┌──────────────────────────────┐    │
│  │                              │    │
│  │        Video / Album Art     │    │  ← 16:9 or square
│  │                              │    │
│  └──────────────────────────────┘    │
│                                      │
│  Song Title / Video Title            │  ← 20–24sp, bold
│  Artist / Channel                    │  ← 14–16sp, secondary
│                                      │
│  ━━━━━━━━━━━━━━━●━━━━━━━━━━━━━━━━━  │  ← Scrubber
│  1:23                       3:45     │  ← Elapsed / Remaining
│                                      │
│       ◀◀     ▶⏸      ▶▶            │  ← Transport controls
│                                      │
│  🔈━━━━━━━━━━━━━●━━━━━━━━━🔊       │  ← Volume
│                                      │
│  ⤴  📃  ⏩  📡  ···                │  ← AirPlay, queue, speed
└──────────────────────────────────────┘
```

### Scrubber / Seek Bar Specs

| Feature | Value | Notes |
|---------|-------|-------|
| Track height | 4dp (inactive) / 6dp (active on touch) | Expands on touch |
| Thumb size | 12dp (inactive) / 20dp (active) | Grows on touch |
| Fine scrubbing (iOS) | Drag down while scrubbing → finer control | 1/4 speed, 1/8 speed labels |
| Time format | mm:ss (< 1hr), h:mm:ss (≥ 1hr) | Elapsed left, remaining right |
| Seek preview | Thumbnail preview above scrubber | Video only, every 5–10s interval |
| Haptic | Light tick at chapter markers | If chapters available |

### Playback Speed

| Speed Options | Common Set |
|--------------|------------|
| Podcast/audiobook | 0.5×, 0.75×, 1×, 1.25×, 1.5×, 1.75×, 2× |
| Video | 0.25×, 0.5×, 0.75×, 1×, 1.25×, 1.5×, 2× |
| Display | "1×" button, shows current speed |

### Lock Screen / Background Controls

| Platform | API | Controls |
|-------
## BK. Chat/Messaging UI

### Message Bubble Layout

| Element | Sent (Outgoing) | Received (Incoming) |
|---------|-----------------|---------------------|
| Alignment | Right | Left |
| Max width | 70–80% of screen width | 70–80% of screen width |
| Background | Primary / brand color | Surface variant / secondary container |
| Text color | On primary / white | On surface |
| Corner radius | 18dp (all), 4dp on sent-side tail corner | 18dp (all), 4dp on received-side tail corner |
| Horizontal padding | 12dp | 12dp |
| Vertical padding | 8dp | 8dp |
| Avatar (group chat) | Hidden (sender is user) | 28dp circle, left of bubble |
| Spacing between bubbles | 2dp (same sender), 8dp (different sender) | Same |

### Timestamp Grouping

| Rule | Behavior |
|------|----------|
| Same sender, < 1 min apart | Group: no timestamp, minimal spacing (2dp) |
| Same sender, 1–5 min apart | Group: timestamp on last message only |
| Different sender or > 5 min | Show timestamp above message or inline |
| Different day | Full date header (centered, "Today", "Yesterday", "Mar 6, 2026") |
| Format (same day) | "3:42 PM" (12h) or "15:42" (24h per locale) |
| Format (other day) | "Mon 3:42 PM" or full date if > 7 days |

### Message Status Indicators

| Status | Icon | Position |
|--------|------|----------|
| Sending | Clock / spinner (12dp) | Below bubble, right |
| Sent | Single checkmark ✓ | Below bubble, right |
| Delivered | Double checkmark ✓✓ | Below bubble, right |
| Read | Double checkmark ✓✓ (blue/colored) | Below bubble, right |
| Failed | Red ⚠ + "Retry" tap target | Below bubble, right |

### Typing Indicator

```
┌──────────────┐
│  ●  ●  ●     │  ← Three dots, sequential bounce animation
└──────────────┘    Duration: 300ms per dot, 1s total cycle
                    Dot size: 8dp, spacing: 4dp
                    Color: onSurfaceVariant @ 60%
                    Show after: 500ms of typing activity
                    Hide after: 5s of inactivity
                    Position: left-aligned, where next received message would appear
```

### Input Bar

```
┌──────────────────────────────────────────────┐
│  [+] ┌─────────────────────────────┐ [Send]  │
│      │ Message...                  │          │  Height: 48dp min, grows to max 120dp
│      └─────────────────────────────┘          │  [+] = attachment menu
│                                               │  Send: enabled only when input non-empty
│  Attachment options (expanded):               │  Send color: primary (active) / disabled
│  [📷 Camera] [🖼 Gallery] [📎 File] [📍 Loc] │  Input: multiline, auto-grow
└──────────────────────────────────────────────┘
```

| Input Bar Spec | Value |
|---------------|-------|
| Min height | 48dp (single line) |
| Max height | 120dp (~5 lines), then scroll |
| Padding | 8dp vertical, 12dp horizontal |
| Send button size | 36dp |
| Keyboard avoidance | Input bar moves above keyboard |
| Safe area | Respect home indicator (bottom 34pt on iPhone) |

### Reply Threading

```
┌──────────────────────────────┐
│  ┌──────────────────────┐    │
│  │ ▍ Replying to Alex:  │    │  ← Quoted message preview
│  │ ▍ "Hey, are you..."  │    │     Left border: 3dp, primary color
│  └──────────────────────┘    │     Max 2 lines, truncated
│  Sure, I'll be there! ✓✓    │  ← Reply message
└──────────────────────────────┘
```

### Emoji Reactions

| Spec | Value |
|------|-------|
| Trigger | Long press on message → reaction bar |
| Quick reactions | 6 most-used emoji in horizontal bar above message |
| Full picker | "+" button → system emoji keyboard |
| Reaction display | Below bubble, pill shape (emoji + count) |
| Reaction pill | 24dp height, 8dp padding, surface variant bg |
| Tap own reaction | Removes it (toggle) |
| Animation | Scale spring 0→1, 200ms |

### SwiftUI — Message Bubble

```swift
struct MessageBubble: View {
    let message: Message
    let isSent: Bool
    
    var body: some View {
        HStack {
            if isSent { Spacer(minLength: UIScreen.main.bounds.width * 0.2) }
            VStack(alignment: isSent ? .trailing : .leading, spacing: 2) {
                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isSent ? Color.accentColor : Color(.systemGray5))
                    .foregroundColor(isSent ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            if !isSent { Spacer(minLength: UIScreen.main.bounds.width * 0.2) }
        }
    }
}
```

### Kotlin — Compose Message Bubble

```kotlin
@Composable
fun MessageBubble(message: Message, isSent: Boolean) {
    val maxWidth = LocalConfiguration.current.screenWidthDp.dp * 0.75f
    
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = if (isSent) Arrangement.End else Arrangement.Start
    ) {
        Column(horizontalAlignment = if (isSent) Alignment.End else Alignment.Start) {
            Surface(
                shape = RoundedCornerShape(
                    topStart = 18.dp, topEnd = 18.dp,
                    bottomStart = if (isSent) 18.dp else 4.dp,
                    bottomEnd = if (isSent) 4.dp else 18.dp
                ),
                color = if (isSent) MaterialTheme.colorScheme.primary
                        else MaterialTheme.colorScheme.secondaryContainer,
                modifier = Modifier.widthIn(max = maxWidth)
            ) {
                Text(
                    text = message.text,
                    modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp),
                    color = if (isSent) MaterialTheme.colorScheme.onPrimary
                            else MaterialTheme.colorScheme.onSecondaryContainer
                )
            }
            Text(
                text = formatTime(message.timestamp),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
    }
}
```

### Checklist

- ✅ Sent right, received left; max width 70–80%
- ✅ Timestamps grouped by time proximity and sender
- ✅ Typing indicator shows within 500ms of remote typing
- ✅ Input bar grows with content (max 5 lines, then scroll)
- ✅ Keyboard avoidance: input bar always above keyboard
- ✅ Message status (sent/delivered/read) visible
- ✅ Failed messages show retry option
- ✅ Long press → reactions + context menu (copy, reply, delete)
- ❌ Don't show timestamps on every single message (visual noise)
- ❌ Don't auto-scroll to bottom when user is reading history
- ❌ Don't block send button while previous message is in flight

### Sources

- Apple Messages app (design reference)
- Material Design — Communication patterns
- Signal / WhatsApp UX patterns (industry standard)

---

## BL. Social Features (Feeds/Comments/Likes)

### Feed Card Anatomy

```
┌──────────────────────────────────────┐
│  [Avatar 36dp] Username · 2h    ··· │  ← Header: avatar, name, time, overflow
│                                      │
│  Caption text with @mentions and     │  ← Body text (max 3 lines + "more")
│  #hashtags styled differently...     │
│                                      │
│  ┌──────────────────────────────┐    │
│  │                              │    │  ← Media (image/video/carousel)
│  │      Image / Video           │    │     Aspect ratio: 1:1, 4:5, 16:9
│  │                              │    │
│  └──────────────────────────────┘    │
│                                      │
│  ♡ 1,234    💬 56    ⤴ Share        │  ← Action bar: like, comment, share
│                                      │
│  View all 56 comments                │  ← Comment preview link
│  alex: Great post! 🔥               │  ← Top comment preview (1-2)
└──────────────────────────────────────┘
```

### Feed Card Specs

| Element | Size/Spec | Notes |
|---------|-----------|-------|
| Avatar | 36dp circle | Top-left, 12dp from edges |
| Username | `titleSmall` / `.subheadline` bold | Tappable → profile |
| Timestamp | `labelSmall` / `.caption` secondary | Relative: "2h", "3d", then "Mar 6" |
| Overflow menu | "···" icon, 48dp target | Report, mute, share link |
| Media height | Aspect ratio preserved, max 500dp | 1:1 square or 4:5 portrait preferred |
| Action icons | 24dp, 48dp touch target | Like, comment, share, bookmark |
| Card padding | 12–16dp horizontal | No card elevation (flat feed) |
| Card spacing | 1dp divider or 8dp gap | Between cards |

### Double-Tap to Like

| Spec | Value |
|------|-------|
| Gesture | Double tap on media/content area |
| Trigger zone | Media image or main content (not action bar) |
| Animation | Heart icon scales 0→1.3→1.0 at center, 600ms total |
| Heart size | 80dp, white with subtle shadow |
| Fade out | 200ms fade after 400ms hold |
| Haptic | Medium impact on like |
| Idempotent | Double-tap on already-liked = no change (don't unlike) |
| Accessibility | `accessibilityAction(named: "Like")` |

### Like Animation

```
t=0ms:    Heart appears, scale 0 → 1.3 (spring, 200ms)
t=200ms:  Heart settles 1.3 → 1.0 (spring, 150ms)
t=400ms:  Heart holds at 1.0
t=600ms:  Heart fades out (alpha 1 → 0, 200ms)
t=800ms:  Heart removed

Simultaneously:
- Like icon in action bar fills (outline → filled, red)
- Like count increments (optimistic, animate number change)
- Small particles/confetti optional (scale 0→1→0, 400ms)
```

### @Mention Autocomplete

| Spec | Value |
|------|-------|
| Trigger | Typing "@" in text input |
| Dropdown | Above keyboard, max 4 suggestions |
| Row content | Avatar (28dp) + display name + @username |
| Search | Fuzzy match on display name and username |
| Styling in text | `@username` in primary/link color, bold |
| Tap behavior | Navigates to profile |

### Hashtag Styling

| Spec | Value |
|------|-------|
| Color | Primary / link color |
| Weight | Same as body text (not bold) |
| Tap | Navigates to hashtag feed |
| Auto-detection | Regex: `#[a-zA-Z0-9_]+` |

### Share Sheet

| Platform | API | Notes |
|----------|-----|-------|
| iOS | `UIActivityViewController` / `ShareLink` (SwiftUI) | System sheet with app suggestions |
| Android | `Intent.ACTION_SEND` / `ShareSheet` | System chooser |
| Content | URL + text preview + image (optional) | Deep link preferred |
| "Copy Link" | Always include as option | Fallback for unsupported apps |

### Content Reporting Flow

```
Step 1: Overflow menu → "Report"
Step 2: Category selection:
  - Spam
  - Harassment/bullying
  - Hate speech
  - Nudity/sexual content
  - Violence
  - Misinformation
  - Other (free text)
Step 3: Optional details (text field, 500 char max)
Step 4: Confirmation: "Thank you. We'll review this."
  - Option: "Block this user" toggle
  - Option: "Hide this content" (immediate)
```

### Checklist

- ✅ Double-tap to like with heart animation and haptic
- ✅ Optimistic UI: like count updates instantly, revert on failure
- ✅ @mention autocomplete triggers on "@" character
- ✅ Hashtags styled and tappable
- ✅ Content reporting flow: 3 steps max
- ✅ Share sheet uses system API (deep link + preview)
- ✅ Feed pull-to-refresh + infinite scroll
- ✅ "View all N comments" link expands to full thread
- ❌ Don't block the feed while like request is in flight (optimistic update)
- ❌ Don't unlike on double-tap (only like, never toggle)
- ❌ Don't auto-play video with sound (muted default)

### Sources

- Instagram / Twitter (X) / Threads UX patterns (industry standard)
- Apple HIG — Sharing: developer.apple.com/design/human-interface-guidelines/sharing
- Android Sharing: developer.android.com/training/sharing

---

## BM. E-Commerce Mobile Patterns

### Product Card Grid

| Spec | Phone (Compact) | Tablet (Medium+) |
|------|----------------|-------------------|
| Columns | 2 | 3–4 |
| Card width | Fill (50% - margins) | ~180–220dp |
| Image aspect ratio | 1:1 or 4:5 | 1:1 or 4:5 |
| Image height | ~180dp | ~200dp |
| Title | 2 lines max, `bodySmall` / `.footnote` | Same |
| Price | `titleSmall` bold | Same |
| Spacing (gap) | 8dp horizontal, 12dp vertical | 12dp both |
| Card padding | 0 (image flush) + 8dp text area | Same |
| Quick action | Heart/wishlist overlay top-right of image | Same |

### Product Detail Page

```
┌──────────────────────────────────────┐
│  ← Back                    ♡  🛒(3) │  ← Nav bar with wishlist + cart badge
│                                      │
│  ┌──────────────────────────────┐    │
│  │                              │    │
│  │    Image Carousel            │    │  ← Horizontal pager, dots indicator
│  │    (1:1 or 4:5)             │    │     Pinch to zoom
│  │                              │    │
│  └──────────────────────────────┘    │
│  ● ○ ○ ○                            │  ← Page dots
│                                      │
│  Brand Name                          │  ← `labelLarge`, secondary color
│  Product Title Long Name Here        │  ← `headlineSmall`, primary
│  ★★★★☆ 4.2 (1,247 reviews)         │  ← Rating + count, tappable
│                                      │
│  $49.99  ̶$̶6̶9̶.̶9̶9̶  -29%            │  ← Price: large bold + strikethrough + badge
│                                      │
│  Size: [S] [M] [L●] [XL]           │  ← Chip selector, selected = filled
│  Color: ● ● ● ●                     │  ← Color swatches (24dp circles)
│                                      │
│  📏 Size Guide                       │  ← Opens bottom sheet
│                                      │
│  ▸ Description                       │  ← Expandable section
│  ▸ Specifications                    │
│  ▸ Reviews (1,247)                   │
│                                      │
│ ┌────────────────────────────────┐   │
│ │  Add to Cart — $49.99          │   │  ← STICKY bottom bar
│ └────────────────────────────────┘   │     Primary button, full-width
└──────────────────────────────────────┘
```

### Cart Badge

| Spec | Value |
|------|-------|
| Position | Top-right of cart icon, offset (-4, -4)dp |
| Size | 16dp min (circle), expands for 2+ digits |
| Color | Error/red background, white text |
| Font | 10sp bold |
| Max display | "99+" for 100+ items |
| Animation | Scale spring on increment (0.8→1.2→1.0, 300ms) |

### Checkout Flow

```
Cart → Shipping → Payment → Review → Confirmation

Step 1: Cart
  - Item list (image, title, qty stepper, price, remove)
  - Promo code input
  - Subtotal / shipping / tax / total

Step 2: Shipping
  - Address form or saved address selection
  - Shipping method selection (standard/express)

Step 3: Payment
  - Apple Pay / Google Pay button (TOP, most prominent)
  - Saved cards
  - Add new card (inline or separate screen)

Step 4: Review
  - Order summary (all items, address, payment, total)
  - Edit links back to each step
  - "Place Order" primary CTA

Step 5: Confirmation
  - Checkmark animation
  - Order number
  - Estimated delivery
  - "Continue Shopping" + "Track Order"
```

### Apple Pay / Google Pay Placement

| Guideline | Value |
|-----------|-------|
| Position | Top of payment step, above other methods |
| Button style | System-rendered (`PKPaymentButton` / `PayButton`) |
| Height | 48dp (min 30dp per Apple guidelines) |
| Width | Full width or min 140dp |
| Label | "Buy with Apple Pay" / "Pay with G Pay" |
| Don't | Alter button appearance, add custom styling |

### Quantity Stepper

```
┌───┬─────┬───┐
│ - │  2  │ + │    Height: 36dp
└───┴─────┴───┘    Button width: 36dp each
                   Count: centered, 16sp
                   Min: 1 (- disabled at 1)
                   Max: 99 (or stock limit)
                   Long press +/-: accelerate after 500ms
                   Haptic: light tick on each change
```

### Checklist

- ✅ Product grid: 2 columns on phone, 3–4 on tablet
- ✅ Product images pinch-to-zoom with carousel dots
- ✅ Sticky "Add to Cart" bar at bottom of product detail
- ✅ Apple Pay / Google Pay at top of payment options
- ✅ Cart badge animates on add
- ✅ Guest checkout available (don't force registration)
- ✅ Quantity stepper with min 1, clear +/- targets (36dp)
- ✅ Checkout progress indicator (steps or breadcrumb)
- ❌ Don't hide total price until final step (show running total)
- ❌ Don't require registration before viewing products
- ❌ Don't auto-add items to cart (require explicit action)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| No guest checkout | 35% cart abandonment (Baymard) | Always offer guest option |
| Hiding shipping cost until checkout | #1 reason for abandonment | Show estimate early |
| Tiny product images | Can't evaluate product | Large images, pinch zoom |
| No Apple Pay / Google Pay | Losing fastest checkout path | Implement, place prominently |
| Cart page with no edit capability | Must go back to product page | Inline quantity edit + remove |

### Sources

- Baymard Institute: baymard.com/lists/cart-abandonment-rate (70.19% average)
- Apple Pay HIG: developer.apple.com/design/human-interface-guidelines/apple-pay
- Google Pay Brand Guidelines: developers.google.com/pay/api/android/guides/brand-guidelines
- Material Design — Shopping patterns

---

## BN. Financial App Patterns

### Balance Display

| Spec | Value | Notes |
|------|-------|-------|
| Font size | 32–40sp / 34–40pt | Largest element on screen |
| Weight | Bold / heavy | Immediate scanability |
| Position | Top center, hero area | Above the fold |
| Hide/reveal | Eye icon toggle (👁/👁‍🗨) | Replaces digits with "••••••" |
| Animation | CountUp from 0 or morph digits on change | 300ms ease-out |
| Currency symbol | Prefix/suffix per locale (`$1,234.56` vs `1.234,56 €`) | Use `NumberFormatter` / `NumberFormat` |

### Transaction List

| Element | Spec |
|---------|------|
| Grouping | By date ("Today", "Yesterday", "March 5, 2026") |
| Row height | 64–72dp |
| Left: icon/logo | 40dp circle, merchant logo or category icon |
| Title | Merchant name, `bodyLarge`, primary color |
| Subtitle | Category or account, `bodySmall`, secondary |
| Amount (right) | `titleMedium` bold, right-aligned |
| Positive (credit) | Green `#34C759` / success color, "+" prefix |
| Negative (debit) | Default text color (no red — red = error, not "spent") |
| Pending | Italic or secondary color + "Pending" label |
| Tap | Opens transaction detail |

### Spending Visualization

| Chart Type | Use Case | Specs |
|-----------|----------|-------|
| Donut/pie | Category breakdown | Max 6 segments + "Other", labels outside |
| Bar (horizontal) | Category comparison | Sorted descending, primary color gradient |
| Bar (vertical) | Monthly spending over time | 6–12 bars, current month highlighted |
| Line | Balance over time | Smooth curve, area fill @ 10% opacity |

### Budget Progress Bar

```
┌──────────────────────────────────────┐
│  Groceries               $320/$500   │
│  ████████████████░░░░░░░  64%        │
│                                      │
│  Dining Out              $180/$200   │  ← Yellow at 80%+
│  ████████████████████░░░  90%  ⚠     │
│                                      │
│  Entertainment           $220/$150   │  ← Red when exceeded
│  ████████████████████████ 147% ⛔    │
└──────────────────────────────────────┘

Bar height: 8dp, corner radius: 4dp
Colors:
  0-74%: Primary / brand
  75-99%: Warning / yellow-orange
  100%+: Error / red
```

### Account Carousel

| Spec | Value |
|------|-------|
| Layout | Horizontal pager, card style |
| Card size | 85% of screen width × 180dp |
| Peek | 15% of next card visible |
| Content | Account name, last 4 digits, balance, card art |
| Page indicator | Dots (if 3+) or implicit from peek |
| Snap | Snap to nearest card center |

### Transfer Flow

```
Step 1: Select recipient (recent / search / new)
Step 2: Enter amount (large number pad, currency formatted)
Step 3: Confirm (summary + biometric auth)
Step 4: Success (checkmark + reference number)

Amount input:
  - Large centered display (32sp)
  - Format in real-time: "1234" → "$1,234"
  - Decimal: always show 2 places
  - Max amount validation (inline error)
  - "Send All" / "Max" shortcut button
```

### Biometric Confirmation

| Platform | API | Trigger |
|----------|-----|---------|
| iOS | `LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` | Transfers, view sensitive data, login |
| Android | `BiometricPrompt` with `BIOMETRIC_STRONG` | Same |
| Fallback | Device PIN/password | Always provide fallback |
| Prompt text | Describe action: "Authenticate to send $50 to Alex" | Never generic "Verify identity" |

### Currency Formatting

```swift
// iOS
let formatter = NumberFormatter()
formatter.numberStyle = .currency
formatter.locale = Locale.current // Respects device locale
formatter.string(from: 1234.56) // "$1,234.56" or "1.234,56 €"
```

```kotlin
// Android
val format = NumberFormat.getCurrencyInstance(Locale.getDefault())
format.format(1234.56) // "$1,234.56" or "1.234,56 €"
```

### Checklist

- ✅ Balance prominent (32–40sp), top center, hide/reveal toggle
- ✅ Transactions grouped by date, credit in green
- ✅ Biometric auth for sensitive actions (transfers, reveal account number)
- ✅ Currency formatting respects device locale
- ✅ Budget progress bars change color at thresholds (75%, 100%)
- ✅ Transfer requires explicit confirmation step
- ✅ Real-time amount formatting during input
- ❌ Don't show full account numbers (mask: ••••1234)
- ❌ Don't use red for normal debits (reserve red for errors/overdraft)
- ❌ Don't allow screenshots of sensitive screens (FLAG_SECURE on Android, hide in app switcher on iOS)

### Sources

- Baymard Institute: Financial UX patterns
- Apple HIG — Privacy: developer.apple.com/design/human-interface-guidelines/privacy
- Material Design — Data visualization: m3.material.io/styles/data-visualization
- PSD2 / Open Banking UX requirements

---

## BO. Calendar & Scheduling UI

### Calendar View Types

| View | Use Case | Key Spec |
|------|----------|----------|
| Month grid | Overview, date picking | 7 columns, 5–6 rows, cell min 44×44dp |
| Week strip | Quick day selection | Horizontal scroll, 7 visible, current highlighted |
| Day timeline | Detailed schedule | Vertical scroll, 1h = 60dp, 15min grid lines |
| Agenda (list) | Chronological events | Grouped by date, infinite scroll |

### Month Grid Specs

| Element | Value |
|---------|-------|
| Cell size | Min 44×44dp (touch target) |
| Day number | 14sp, centered |
| Today marker | Circle, primary color bg, white text |
| Selected day | Circle outline, primary color |
| Event dot | 6dp circle below number, max 3 dots |
| Dot color | Event category color |
| Outside month days | 30% opacity or hidden |
| Week start | Locale-aware (Sun in US, Mon in EU) |
| Header | "March 2026" + left/right arrows |
| Swipe | Horizontal to change month |

### Week Strip

```
┌─────────────────────────────────────────────┐
│  ◀  Mon   Tue   Wed   THU   Fri   Sat  Sun ▶│
│      3     4     5    [6]    7     8     9   │
│                       ●●                     │  ← Event dots
└─────────────────────────────────────────────┘
Selected (today): circle bg, bold
Specs: Height 64dp, day name 12sp, day number 16sp
Scroll: swipe left/right for adjacent weeks
```

### Day Timeline

```
┌──────────────────────────────────┐
│  8 AM ───────────────────────    │
│        ┌──────────────────┐      │
│  9 AM  │  Team Standup    │      │  ← Event block
│        │  9:00 - 9:30     │      │     Height = duration × 1dp/min
│        └──────────────────┘      │     Color: category
│ 10 AM ───────────────────────    │     Min height: 24dp (for < 15min)
│        ┌──────────────────┐      │
│        │  Design Review   │      │
│ 11 AM  │  10:00 - 11:30  │      │
│        │                  │      │
│        └──────────────────┘      │
│ 12 PM ───────────────────────    │
└──────────────────────────────────┘

Hour height: 60dp (1dp per minute)
Time labels: Left column, 48dp wide
Grid lines: 1dp, outline variant color
Current time: Red horizontal line + dot
Event block: 4dp left border (category color), 8dp padding
Overlapping events: Side by side (50% width each)
```

### Date Picker vs Calendar

| Use Case | Component | Notes |
|----------|-----------|-------|
| Single date (birthday, due date) | Date picker (modal) | iOS DatePicker, Android DatePickerDialog |
| Date range (travel, booking) | Range calendar (inline) | Two selection markers with range fill |
| Date + time | Combined picker | Date first, then time |
| Scheduling (event creation) | Inline calendar in form | Not modal |

### Time Slot Grid (Booking)

```
┌──────────────────────────────────────┐
│  Available times for March 6:        │
│                                      │
│  ┌────────┐ ┌────────┐ ┌────────┐  │
│  │ 9:00AM │ │ 9:30AM │ │10:00AM │  │  ← Chip/button grid
│  └────────┘ └────────┘ └────────┘  │     Available: outlined
│  ┌────────┐ ┌────────┐ ┌────────┐  │     Selected: filled primary
│  │10:30AM │ │[11:00] │ │11:30AM │  │     Unavailable: disabled, 38% opacity
│  └────────┘ └────────┘ └────────┘  │     Size: height 40dp, min width 80dp
│  ┌────────┐ ┌────────┐             │
│  │ 1:00PM │ │ 1:30PM │             │
│  └────────┘ └────────┘             │
└──────────────────────────────────────┘
```

### Event Creation Form

| Field | Type | Notes |
|-------|------|-------|
| Title | Text input | Required, placeholder "Add title" |
| Date | Date picker | Default: selected day or today |
| Start time | Time picker | Default: next round hour |
| End time | Time picker | Default: start + 1h |
| All day | Toggle | Hides time pickers |
| Location | Text input + map | Optional, autocomplete |
| Repeat | Selector | None / Daily / Weekly / Monthly / Custom |
| Reminder | Selector | None / 5min / 15min / 30min / 1hr / 1day |
| Calendar | Selector | Which calendar to add to |
| Notes | Multiline text | Optional |
| Color | Color picker dots (8 options) | Category/calendar color |

### Timezone Display

| Rule | Display |
|------|---------|
| Same timezone as device | Don't show timezone |
| Different timezone | Show both: "9:00 AM PST (12:00 PM your time)" |
| Travel/meeting across zones | Dual time display |
| Format | Abbreviated: PST, CET, JST |

### Checklist

- ✅ Today clearly marked in all views (circle, color)
- ✅ Week start day respects locale
- ✅ Current time indicator (red line) in day timeline
- ✅ Events color-coded by calendar/category
- ✅ Month grid cells meet 44×44dp touch target
- ✅ Swipe between months/weeks
- ✅ Timezone shown when different from device
- ✅ Recurring event UI with clear frequency options
- ❌ Don't force month grid only (offer agenda view as alternative)
- ❌ Don't truncate event titles without tooltip/tap to expand
- ❌ Don't use overlapping events without side-by-side layout

### Sources

- Apple HIG — Date Pickers: developer.apple.com/design/human-interface-guidelines/date-pickers
- Material Design — Date Pickers: m3.material.io/components/date-pickers
- Google Calendar / Apple Calendar UX patterns (industry reference)

---

## BP. Fitness/Health Tracking UI

### Ring/Arc Progress

| Spec | Value |
|------|-------|
| Ring diameter | 120–200dp (hero), 40–60dp (compact) |
| Ring thickness | 12–16dp (hero), 6–8dp (compact) |
| Background track | Same as ring color @ 20% opacity |
| End cap | Round |
| Overflow (> 100%) | Second lap at 50% opacity outside |
| Center content | Percentage or absolute value (e.g., "6,234 steps") |
| Colors | Move: red, Exercise: green, Stand: blue (Apple convention) |
| Animation | Draw from 0 to value over 800ms, ease-out |

### Ring Progress Implementation

```swift
// SwiftUI ring
struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0+
    let color: Color
    let lineWidth: CGFloat = 14
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.8), value: progress)
        }
    }
}
```

```kotlin
// Compose arc
@Composable
fun ProgressRing(progress: Float, color: Color, strokeWidth: Dp = 14.dp) {
    val animatedProgress by animateFloatAsState(
        targetValue = progress.coerceIn(0f, 1f),
        animationSpec = tween(800, easing = EaseOut)
    )
    Canvas(modifier = Modifier.size(160.dp)) {
        drawArc(color = color.copy(alpha = 0.2f), startAngle = 0f, sweepAngle = 360f,
            useCenter = false, style = Stroke(strokeWidth.toPx(), cap = StrokeCap.Round))
        drawArc(color = color, startAngle = -90f, sweepAngle = animatedProgress * 360f,
            useCenter = false, style = Stroke(strokeWidth.toPx(), cap = StrokeCap.Round))
    }
}
```

### Daily Goal Celebration

| Trigger | Animation | Duration |
|---------|-----------|----------|
| 100% of daily goal reached | Confetti / particles + haptic burst | 1.5–2s |
| Ring completes full circle | Ring pulses (scale 1.0→1.05→1.0) | 600ms |
| Haptic | `UINotificationFeedbackGenerator.notificationOccurred(.success)` | Instant |
| Sound | Optional subtle chime (respect silent mode) | 500ms |
| Show frequency | Once per goal per day | Don't repeat on reopen |

### Streak Calendar (Heat Map)

```
┌──────────────────────────────────────┐
│  March 2026                          │
│  Mo Tu We Th Fr Sa Su                │
│                          1  2  3     │
│   4  5  6  7  8  9 10               │
│  11 12 13 14 15 16 17               │
│                                      │
│  Legend: ░ = 0-25%  ▒ = 25-75%       │
│          ▓ = 75-99% █ = 100%+        │
└──────────────────────────────────────┘

Colors: 4-5 intensity levels of primary/green
  Level 0: surface (no activity)
  Level 1: primary @ 20%
  Level 2: primary @ 40%
  Level 3: primary @ 70%
  Level 4: primary @ 100%
Cell shape: Rounded square (4dp radius)
Cell size: 32×32dp with 4dp gap
Streak counter: "🔥 12 day streak" prominent
```

### Data Visualization Cards

| Data Type | Chart | Spec |
|-----------|-------|------|
| Heart rate | Line graph | Y: 40–200 BPM, zones colored (rest/fat burn/cardio/peak) |
| Steps | Bar chart | Daily bars, 7-day view, goal line dashed |
| Sleep | Stacked horizontal bar | Awake/REM/Light/Deep, color per stage |
| Activity timeline | Vertical timeline | Blocks of activity type throughout day |
| Weight trend | Line + dots | 30/90/365 day views, goal line |

### HealthKit / Health Connect Integration

| Feature | iOS (HealthKit) | Android (Health Connect) |
|---------|-----------------|------------------------|
| Permission | `HKHealthStore.requestAuthorization()` | `PermissionController.createRequestPermissionResultContract()` |
| Read steps | `HKQuantityType(.stepCount)` | `StepsRecord` |
| Read HR | `HKQuantityType(.heartRate)` | `HeartRateRecord` |
| Write workout | `HKWorkout` + `HKWorkoutBuilder` | `ExerciseSessionRecord` |
| Background delivery | `enableBackgroundDelivery(for:frequency:)` | Not supported (poll on foreground) |
| Min OS | iOS 8+ (HealthKit) | Android 14+ (native), API 26+ (APK) |

### Workout Summary Card

```
┌──────────────────────────────────────┐
│  🏃 Running — Today, 7:30 AM        │
│                                      │
│  5.2 km      32:15      6:12/km     │
│  Distance    Duration    Pace        │
│                                      │
│  ┌──────────────────────────────┐    │
│  │  Route map (static)          │    │  ← MapKit/Google Maps snapshot
│  └──────────────────────────────┘    │
│                                      │
│  ❤ Avg 152  ⬆ Max 178  🔥 320 cal  │
│                                      │
│  Splits: 1km 5:55 | 2km 6:08 |...  │
└──────────────────────────────────────┘
```

### Checklist

- ✅ Ring progress animates on appear (0 to value, 800ms)
- ✅ Goal celebration: haptic + visual, once per day
- ✅ Streak calendar uses intensity colors (heat map)
- ✅ Health data permissions requested contextually (not at launch)
- ✅ Data refresh on foreground return
- ✅ Charts use accessibility: VoiceOver reads data points
- ✅ Workout summary shows key metrics (distance, time, pace, HR)
- ❌ Don't show raw sensor data without context (show zones/targets)
- ❌ Don't auto-share health data (explicit user action only)
- ❌ Don't celebrate trivially (save celebration for meaningful goals)

### Sources

- Apple HealthKit: developer.apple.com/documentation/healthkit
- Health Connect: developer.android.com/health-and-fitness/guides
- Apple Fitness+ / Google Fit UX patterns
- Apple HIG — Activity Rings design

---

## BQ. Push Notification Strategy

### Timing Rules

| Rule | Value | Notes |
|------|-------|-------|
| Quiet hours | Don't send before 8:00 AM or after 9:00 PM local time | Respect device timezone |
| Weekend adjustment | Consider 9:00 AM – 8:00 PM | More conservative |
| Optimal engagement | 10:00 AM – 1:00 PM, 6:00 PM – 8:00 PM | Varies by app category |
| Rate limit | Max 3–5 per day per app | More = uninstalls |
| Re-engagement | After 3–7 days of inactivity | Max 1 per week |

### Notification Importance/Priority

| Android Channel Importance | iOS Interruption Level | Behavior |
|---------------------------|----------------------|----------|
| `IMPORTANCE_HIGH` | `.timeSensitive` | Sound + heads-up + lock screen |
| `IMPORTANCE_DEFAULT` | `.active` | Sound + notification tray |
| `IMPORTANCE_LOW` | `.passive` | No sound, tray only |
| `IMPORTANCE_MIN` | `.passive` | No sound, collapsed |
| — | `.critical` (entitlement required) | Breaks DND, alarm-level |

### Android Notification Channels

```kotlin
// Create channels at app startup
val channels = listOf(
    NotificationChannel("messages", "Messages", NotificationManager.IMPORTANCE_HIGH).apply {
        description = "Chat messages from contacts"
        enableVibration(true)
        enableLights(true)
    },
    NotificationChannel("updates", "App Updates", NotificationManager.IMPORTANCE_DEFAULT).apply {
        description = "Feature updates and announcements"
    },
    NotificationChannel("promotions", "Promotions", NotificationManager.IMPORTANCE_LOW).apply {
        description = "Deals and offers"
    }
)
val nm = getSystemService(NotificationManager::class.java)
channels.forEach { nm.createNotificationChannel(it) }
```

### Notification Grouping

| Platform | Mechanism | Key |
|----------|-----------|-----|
| iOS | `threadIdentifier` on `UNNotificationContent` | Group by conversation/topic |
| Android | `setGroup(groupKey)` + summary notification | Group by type/sender |
| Summary | "3 new messages from Team Chat" | Collapse when > 3 from same group |
| Max visible | 4–5 individual before collapsing | System managed |

### Rich Notifications

| Feature | iOS | Android |
|---------|-----|---------|
| Image | `UNNotificationAttachment` (max 10MB) | `setStyle(BigPictureStyle())` |
| Action buttons | `UNNotificationAction` (max 4) | `addAction()` (max 3) |
| Reply inline | `UNTextInputNotificationAction` | `RemoteInput` |
| Custom UI | `NotificationContentExtension` | Custom `RemoteViews` (limited) |
| Expandable text | Category + content extension | `BigTextStyle()` |
| Progress | ❌ (not native) | `setProgress(max, current, false)` |

### Permission Priming (iOS)

```swift
// Step 1: Custom primer screen (your UI)
func showNotificationPrimer() {
    // Show benefit-focused screen:
    // "Get reminders to log your progress"
    // [Enable] → requestPermission()
    // [Not Now] → save for later, don't call requestPermission
}

// Step 2: System prompt (only if user tapped Enable)
func requestPermission() {
    UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .sound, .badge]
    ) { granted, error in
        // Handle result
    }
}

// iOS 12+ Provisional notifications (delivered quietly, no prompt)
UNUserNotificationCenter.current().requestAuthorization(
    options: [.alert, .sound, .badge, .provisional]
) { granted, error in }
```

### Badge Count Management

| Rule | Value |
|------|-------|
| Update on | Every push, and on app foreground (sync with server) |
| Clear on | App open (all) or per-section (mark as read) |
| iOS API | `UNUserNotificationCenter.setBadgeCount(_:)` (iOS 16+) |
| Android API | `ShortcutBadger` (third-party) or launcher-specific |
| Don't | Let badge count grow indefinitely (max meaningful number) |

### Checklist

- ✅ Respect quiet hours (8AM–9PM local time)
- ✅ Custom primer before iOS system permission prompt
- ✅ Android: separate notification channels by type
- ✅ Group related notifications (thread ID / group key)
- ✅ Rich notifications with images and action buttons where relevant
- ✅ Rate limit: max 3–5 push per day
- ✅ Badge count cleared appropriately on app open
- ✅ Deep link from notification to relevant content
- ❌ Don't send marketing push without user opt-in to that channel
- ❌ Don't wake users during quiet hours (respect DND)
- ❌ Don't show generic "Open the app!" notifications (always provide value)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Cold system prompt on first launch | 40–50% decline permanently | Custom primer + contextual timing |
| All notifications in one channel (Android) | User can't control granularity | Separate channels by type |
| Push at 2 AM | Wakes user, immediate uninstall | Queue for morning delivery |
| 10+ push per day | Notification fatigue, app disabled | Rate limit 3–5/day |
| Badge count stuck at 99+ | Meaningless anxiety | Clear on open, keep meaningful |

### Sources

- Apple Push Notifications: developer.apple.com/documentation/usernotifications
- Android Notifications: developer.android.com/develop/ui/views/notifications
- Localytics: Push notification opt-in rates and engagement benchmarks
- OneSignal: Optimal notification timing research

---

## BR. Voice Interaction (Siri/Assistant)

### Siri Shortcuts (iOS)

| Component | Description |
|-----------|-------------|
| `INIntent` | Define the action (custom or system) |
| `INShortcut` | Wraps intent for Siri suggestion |
| `NSUserActivity` | Donate activity for suggestions |
| Trigger phrase | User-defined: "Log a cigarette" |
| Suggested phrase | App-provided: "Log with [AppName]" |
| Shortcut donation | Call after user performs action in-app |

```swift
import Intents

// Donate shortcut after user action
func donateLogCigaretteShortcut() {
    let intent = LogCigaretteIntent()
    intent.suggestedInvocationPhrase = "Log a cigarette"
    let interaction = INInteraction(intent: intent, response: nil)
    interaction.donate { error in
        if let error { print("Donation failed: \(error)") }
    }
}

// App Shortcuts (iOS 16+) — no donation needed, immediately available
struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogCigaretteIntent(),
            phrases: [
                "Log a cigarette with \(.applicationName)",
                "Track smoking with \(.applicationName)"
            ],
            shortTitle: "Log Cigarette",
            systemImageName: "plus.circle"
        )
    }
}
```

### Google Assistant Actions (Android)

```xml
<!-- shortcuts.xml -->
<shortcuts xmlns:android="http://schemas.android.com/apk/res/android">
    <capability android:name="actions.intent.CREATE_THING">
        <intent
            android:action="android.intent.action.VIEW"
            android:targetPackage="com.example.app"
            android:targetClass="com.example.app.LogActivity">
            <parameter
                android:name="thing.name"
                android:key="entry_type" />
        </intent>
    </capability>
    <shortcut android:shortcutId="log_cigarette"
              android:shortcutShortLabel="@string/log_cigarette">
        <capability-binding android:key="actions.intent.CREATE_THING">
            <parameter-binding
                android:key="thing.name"
                android:value="cigarette" />
        </capability-binding>
    </shortcut>
</shortcuts>
```

### Voice Trigger Phrase Design

| Guideline | Good | Bad |
|-----------|------|-----|
| Short (2–5 words) | "Log a cigarette" | "Please add a new cigarette entry to my log" |
| Action-oriented | "Start workout" | "Workout thing" |
| Include app name | "Track with AppName" | Generic phrase without context |
| Natural language | "How many today?" | "Query count cigarettes today" |
| Avoid ambiguity | "Check my balance in BankApp" | "Check balance" (which app?) |

### Conversational UI Principles

| Principle | Implementation |
|-----------|---------------|
| Confirm before action | "Log 1 cigarette at 3:42 PM?" → [Yes / Cancel] |
| Handle disambiguation | "Which account?" if multiple |
| Provide feedback | "Done! Logged at 3:42 PM. That's 5 today." |
| Error gracefully | "I didn't catch that. You can say 'Log a cigarette' or 'Check my count.'" |
| Keep turns short | Max 1–2 sentences per response |

### Voice + Visual Feedback

| Event | Voice Feedback | Visual Feedback | Haptic |
|-------|---------------|-----------------|--------|
| Command recognized | Siri/Assistant animation | App opens to relevant screen | None (system handles) |
| Action completed | "Done. Logged." | Success state in app | Success haptic |
| Action failed | "Something went wrong." | Error state | Error haptic |
| Needs input | "Which one?" | Selection UI presented | None |

### Accessibility Benefit

Voice interaction provides an alternative input method for users with:
- Motor impairments (can't tap precisely)
- Vision impairments (screen reader + voice commands)
- Situational disabilities (driving, hands full)
- Cognitive load reduction (don't need to navigate UI)

### Checklist

- ✅ Donate shortcuts after user performs corresponding action in-app
- ✅ Suggested invocation phrases are short, natural, action-oriented
- ✅ Voice action confirms before performing irreversible actions
- ✅ Voice response provides brief, relevant feedback
- ✅ Fallback to visual UI if voice fails
- ✅ Test with actual Siri/Assistant (not just in debugger)
- ❌ Don't require voice for any core feature (always have visual fallback)
- ❌ Don't use generic phrases that conflict with system commands
- ❌ Don't donate shortcuts for actions the user hasn't performed

### Sources

- Siri Shortcuts: developer.apple.com/documentation/sirikit
- App Shortcuts (iOS 16+): developer.apple.com/documentation/appintents/appshortcut
- Google Assistant App Actions: developer.android.com/guide/app-actions
- Conversational design: designguidelines.withgoogle.com/conversation

---

## BS. QR Code & NFC UX

### QR Scanner Viewfinder

| Spec | Value |
|------|-------|
| Viewfinder frame | 250×250dp centered, rounded corners (12dp) |
| Frame color | White, 3dp stroke |
| Corner accents | 40dp L-shaped corners, primary color, 4dp stroke |
| Background dim | #000000 @ 50% outside viewfinder |
| Instructions | "Point camera at QR code" below frame |
| Auto-detection | ✅ No button needed; scan on recognition |
| Flashlight toggle | Bottom center, torch icon, visible in low light |
| Gallery import | "Choose from gallery" link for saved QR images |
| Haptic on scan | Success haptic |
| Animation | Viewfinder pulses subtly (scale 1.0→1.02, 1.5s loop) |

### QR Scan Result Actions

| Content Type | Auto-action | User Confirmation |
|-------------|-------------|-------------------|
| URL (http/https) | Open in-app browser | Show URL + "Open" button |
| Deep link (app scheme) | Navigate in-app | Immediate if own app |
| WiFi config | Show network name + "Connect" | Require confirmation |
| vCard contact | Show contact preview + "Add" | Require confirmation |
| Plain text | Display in card | Copy button |
| Unknown | Display raw string | Copy button |

### QR Scanner Implementation

```swift
// iOS: AVCaptureSession + AVCaptureMetadataOutput
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let captureSession = AVCaptureSession()
    
    func setupScanner() {
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        captureSession.addInput(input)
        let output = AVCaptureMetadataOutput()
        captureSession.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr, .ean13, .ean8]
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let code = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = code.stringValue else { return }
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        handleScanResult(value)
    }
}
```

```kotlin
// Android: ML Kit Barcode Scanning
val scanner = BarcodeScanning.getClient(
    BarcodeScannerOptions.Builder()
        .setBarcodeFormats(Barcode.FORMAT_QR_CODE, Barcode.FORMAT_EAN_13)
        .build()
)

// With CameraX
val analysis = ImageAnalysis.Builder().build().also {
    it.setAnalyzer(executor) { imageProxy ->
        val inputImage = InputImage.fromMediaImage(
            imageProxy.image!!, imageProxy.imageInfo.rotationDegrees
        )
        scanner.process(inputImage)
            .addOnSuccessListener { barcodes ->
                barcodes.firstOrNull()?.rawValue?.let { value ->
                    haptics.performHapticFeedback(HapticFeedbackType.Confirm)
                    handleScanResult(value)
                }
            }
            .addOnCompleteListener { imageProxy.close() }
    }
}
```

### NFC Scan UX

| Platform | API | Prompt |
|----------|-----|--------|
| iOS | Core NFC (`NFCNDEFReaderSession`) | System sheet: "Ready to Scan — Hold your iPhone near the item" |
| Android | `NfcAdapter` + foreground dispatch | Custom UI — no system prompt |
| Read range | 1–4 cm typical | Instruct: "Hold phone within 2cm" |
| Scan duration | iOS: 60s timeout | Android: as long as activity is foreground |
| Haptic | System haptic on successful read | Add explicit haptic on Android |

### NFC Prompt Design

```
iOS (system-managed):
┌──────────────────────────────────────┐
│              Ready to Scan           │
│                                      │
│          ╭──── 📱 ────╮              │
│          │  NFC waves  │             │
│          ╰─────────────╯             │
│                                      │
│   Hold your iPhone near the item     │
│                                      │
│            [Cancel]                  │
└──────────────────────────────────────┘

Android (custom UI):
┌──────────────────────────────────────┐
│                                      │
│        ╭───── 📱 ─────╮             │
│        │  Animated     │             │
│        │  NFC waves    │             │
│        ╰───────────────╯             │
│                                      │
│     Hold phone near the reader       │
│                                      │
│  Tip: Try the top back of your phone │
│                                      │
│            [Cancel]                  │
└──────────────────────────────────────┘
```

### Error States

| Error | Message | Action |
|-------|---------|--------|
| Camera permission denied | "Camera access needed to scan QR codes" | "Open Settings" button |
| No QR detected (5s) | "No code found. Make sure QR code is visible" | Keep scanning |
| Invalid/corrupt QR | "This code couldn't be read" | "Try Again" |
| NFC not available | "NFC is not available on this device" | Hide NFC feature |
| NFC tag read error | "Couldn't read tag. Try holding phone closer" | Auto-retry |

### Checklist

- ✅ QR viewfinder clearly framed with contrast corners
- ✅ Auto-detect on recognition (no "Scan" button needed)
- ✅ Flashlight toggle visible for low-light scanning
- ✅ Haptic feedback on successful scan
- ✅ URL results show preview before opening (security)
- ✅ NFC prompt instructs where to hold device
- ✅ Camera permission priming screen before system prompt
- ❌ Don't auto-navigate to scanned URLs without user confirmation
- ❌ Don't keep camera active when scanner view is not visible
- ❌ Don't require NFC for core features (not all devices have it)

### Sources

- Core NFC: developer.apple.com/documentation/corenfc
- ML Kit Barcode: developers.google.com/ml-kit/vision/barcode-scanning
- Android NFC: developer.android.com/develop/connectivity/nfc
- Apple HIG — Camera: developer.apple.com/design/human-interface-guidelines/camera

---

## BT. Bluetooth UX Patterns

### Permission Flow

| Platform | Permissions Required | When to Request |
|----------|---------------------|-----------------|
| iOS | `NSBluetoothAlwaysUsageDescription` (Info.plist) | On first BLE scan; system prompts automatically |
| iOS (iOS 13+) | Bluetooth permission dialog (automatic on `CBCentralManager` init) | Contextual — explain benefit first |
| Android 11 and below | `BLUETOOTH`, `BLUETOOTH_ADMIN`, `ACCESS_FINE_LOCATION` | Before scanning |
| Android 12+ (API 31) | `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH_ADVERTISE` | Before scanning or connecting |
| Android 12+ | No location permission needed if `neverForLocation` flag set | Simplifies flow |

### Device Discovery List

```
┌──────────────────────────────────────┐
│  ← Scan for Devices                 │
│                                      │
│  ◌ Scanning...                       │  ← Animated spinner
│                                      │
│  NEARBY DEVICES                      │
│  ┌──────────────────────────────┐    │
│  │  📱 Living Room Speaker  -45dBm│   │  ← Name + signal strength
│  │     Bluetooth Audio           │    │     RSSI indicator (bars)
│  └──────────────────────────────┘    │
│  ┌──────────────────────────────┐    │
│  │  ⌚ Wear OS Watch       -62dBm│   │
│  │     Companion Device         │    │
│  └──────────────────────────────┘    │
│  ┌──────────────────────────────┐    │
│  │  🔊 JBL Flip 5          -78dBm│   │  ← Weaker signal
│  │     Bluetooth Audio           │    │
│  └──────────────────────────────┘    │
│                                      │
│  PREVIOUSLY CONNECTED                │
│  ┌──────────────────────────────┐    │
│  │  🎧 AirPods Pro     Not in range│  │
│  └──────────────────────────────┘    │
│                                      │
│  Scan timeout: 30s then show         │
│  "No devices found? [Retry]"        │
└──────────────────────────────────────┘
```

### Pairing Flow

| Step | UI | Notes |
|------|-----|-------|
| 1. Tap device | Loading indicator on row | "Connecting..." |
| 2. Pairing code (if required) | System dialog: "Enter PIN" or "Confirm code matches" | 6-digit display, large font |
| 3. Pairing success | Checkmark animation + "Connected" | Haptic success |
| 4. Navigate to device controls | Auto-transition 1s after success | Or manual "Done" |
| Pairing failure | Inline error: "Couldn't connect. Make sure device is in pairing mode." | "Retry" button |
| Timeout | 15–30s | "Connection timed out" |

### Connection Status Indicator

| State | Icon | Color | Label |
|-------|------|-------|-------|
| Connected | Filled Bluetooth icon | Green / primary | "Connected" |
| Connecting | Bluetooth + spinner | Secondary | "Connecting..." |
| Disconnected | Outline Bluetooth | onSurfaceVariant | "Disconnected" |
| Not in range | Outline Bluetooth + slash | Error / red | "Out of range" |
| Bluetooth off | Bluetooth with X | Error | "Bluetooth is off" |

### Signal Strength Visualization

| RSSI Range | Bars | Label |
|-----------|------|-------|
| > -50 dBm | ████ (4/4) | Excellent |
| -50 to -65 dBm | ███░ (3/4) | Good |
| -65 to -80 dBm | ██░░ (2/4) | Fair |
| -80 to -90 dBm | █░░░ (1/4) | Weak |
| < -90 dBm | ░░░░ (0/4) | Very weak / out of range |

### Auto-Reconnect Pattern

| Behavior | Spec |
|----------|------|
| On app launch | Check if last device is available, connect silently |
| On Bluetooth re-enabled | Auto-reconnect to known devices |
| Background reconnect (iOS) | `CBCentralManager` state restoration |
| Background reconnect (Android) | Foreground service or WorkManager |
| Retry strategy | 3 attempts, 2s → 5s → 10s backoff |
| User notification | Silent if successful; notify on persistent failure |

### Multiple Device Management

```
┌──────────────────────────────────────┐
│  My Devices                          │
│                                      │
│  ┌──────────────────────────────┐    │
│  │  ⌚ Wear OS Watch    Connected│   │
│  │     Battery: 67%     ●       │    │  ← Green dot = connected
│  │     [Disconnect]  [Settings] │    │
│  └──────────────────────────────┘    │
│  ┌──────────────────────────────┐    │
│  │  🔊 Speaker       Disconnected│   │
│  │     Last seen: 2h ago  ○     │    │  ← Gray dot = disconnected
│  │     [Connect]     [Forget]   │    │
│  └──────────────────────────────┘    │
│                                      │
│  + Add New Device                    │
└──────────────────────────────────────┘
```

### Checklist

- ✅ Permission priming screen explains why Bluetooth is needed
- ✅ Device list shows name, type icon, and signal strength
- ✅ Clear connection status indicator on device rows
- ✅ Pairing code displayed in large, readable font
- ✅ Auto-reconnect to previously paired devices
- ✅ "Forget device" option to unpair
- ✅ Scan timeout (30s) with retry option
- ✅ Handle Bluetooth-off state with prompt to enable
- ❌ Don't scan indefinitely (battery drain)
- ❌ Don't auto-pair without user confirmation
- ❌ Don't show raw MAC addresses to users (show friendly names)

### Sources

- Core Bluetooth: developer.apple.com/documentation/corebluetooth
- Android Bluetooth: developer.android.com/develop/connectivity/bluetooth
- Android 12 Bluetooth permissions: developer.android.com/develop/connectivity/bluetooth/bt-permissions
- Apple HIG — Bluetooth: developer.apple.com/design/human-interface-guidelines/bluetooth

---

## BU. User Profiles & Avatars

### Avatar Sizes

| Context | Size (dp/pt) | Use Case |
|---------|-------------|----------|
| Inline (list secondary) | 24 | Comment attribution, small mentions |
| List item | 32–40 | Contact list, message list |
| Card header | 40 | Feed card, post author |
| Profile header (compact) | 56 | Settings, account menu |
| Profile page hero | 72–96 | User's own profile page |
| Full profile (modal) | 120 | Profile edit, large display |

### Placeholder Strategy

| Method | Visual | When |
|--------|--------|------|
| Initials | First + Last initial, centered, bold | Name available, no photo |
| Default icon | `person.circle.fill` / `AccountCircle` | No name or photo |
| Color | Hash username → consistent background color from palette of 8–10 | Differentiate users without photos |

### Avatar Upload Flow

```
User taps avatar → Action sheet:
  ┌──────────────────────────┐
  │  📷  Take Photo           │
  │  🖼  Choose from Library  │
  │  🗑  Remove Photo         │  ← Only if photo exists
  │  ────────────────────────  │
  │  Cancel                   │
  └──────────────────────────┘

After selection:
  1. Show circular crop overlay (1:1 aspect)
  2. Pinch to zoom, pan to position
  3. "Choose" / "Cancel" buttons
  4. Upload with progress indicator on avatar
  5. Optimistic: show new photo immediately
  6. Error: revert to previous with toast
```

### Crop Specs

| Spec | Value |
|------|-------|
| Crop shape | Circle overlay |
| Min zoom | Fit image to circle |
| Max zoom | 5× |
| Background outside crop | #000000 @ 60% |
| Export size | 400×400px (2× for retina) |
| Format | JPEG @ 80% quality (for size) or PNG (for transparency) |
| Max upload size | 5MB |

### Profile Layout

```
┌──────────────────────────────────────┐
│  ← Back                   [Edit]     │
│                                      │
│           ┌────────┐                 │
│           │ Avatar │                 │  ← 96dp, centered
│           │  72dp  │                 │
│           └────────┘                 │
│         Display Name                 │  ← `headlineSmall`, bold
│         @username                    │  ← `bodyMedium`, secondary
│                                      │
│    12         345         1.2K       │
│   Posts    Following    Followers    │  ← Stats row
│                                      │
│  ┌────────────────────────────────┐  │
│  │  Follow / Edit Profile         │  │  ← Primary CTA
│  └────────────────────────────────┘  │
│                                      │
│  Bio text goes here, max 150 chars   │
│  📍 Paris, France  🔗 website.com   │
│                                      │
│  ═══════════════════════════════════ │
│  [Posts]  [Replies]  [Likes]         │  ← Tab bar for content
└──────────────────────────────────────┘
```

### Avatar Badge

| Badge | Size | Position | Color |
|-------|------|----------|-------|
| Online (green dot) | 12dp circle | Bottom-right, overlapping | Green (#34C759) with 2dp white border |
| Offline | No badge or gray dot | Same | Gray |
| Verified | Checkmark in circle | Bottom-right or after name | Primary/blue |
| Badge border | 2dp | Around badge circle | Match background color (punch-through effect) |

### Avatar Group (Stacked)

```
┌──────────────────┐
│  ○○○ +3           │  ← Overlapping circles
│  ╰╯╰╯╰╯           │
└──────────────────┘

Overlap: 25% of diameter (e.g., 8dp for 32dp avatars)
Max visible: 3–5 before "+N" counter
"+N" style: Gray circle, white text, same size as avatars
Z-order: First avatar on top (leftmost)
Border: 2dp white/surface between each
```

### Checklist

- ✅ Avatar sizes consistent across app (use design tokens)
- ✅ Initials placeholder with deterministic background color
- ✅ Circular crop for upload (1:1, pinch-zoom)
- ✅ Upload progress visible on avatar
- ✅ Optimistic UI: show new photo immediately, revert on error
- ✅ Online badge with border matching background
- ✅ Avatar group with overlap and "+N" counter
- ✅ `accessibilityLabel` = person's name (not "avatar" or "image")
- ❌ Don't use square avatars for people (circles are convention)
- ❌ Don't show broken image icon on load failure (show placeholder)
- ❌ Don't allow upload > 5MB without compression

### Sources

- Material Design 3 — Avatars (within Lists/Cards): m3.material.io/components
- Apple HIG — Images: developer.apple.com/design/human-interface-guidelines/images
- Gravatar/identicons for hash-based defaults

---

## BV. Design Handoff (Figma to Code)

### Design Token Categories

| Category | Examples | Token Format |
|----------|---------|-------------|
| Color | `color.primary`, `color.surface.elevated` | Hex + opacity |
| Spacing | `spacing.xs` (4dp), `spacing.sm` (8dp), `spacing.md` (16dp) | dp/pt |
| Typography | `typography.headline.large`, `typography.body.medium` | family/size/weight/lineHeight/letterSpacing |
| Elevation | `elevation.level0` (0dp), `elevation.level2` (3dp) | dp |
| Corner Radius | `radius.sm` (4dp), `radius.md` (12dp), `radius.full` (9999dp) | dp |
| Motion | `motion.duration.short` (150ms), `motion.easing.standard` | ms + easing curve |
| Opacity | `opacity.disabled` (0.38), `opacity.hover` (0.08) | Float 0–1 |

### Token Format (JSON)

```json
{
  "color": {
    "primary": { "$value": "#6750A4", "$type": "color" },
    "on-primary": { "$value": "#FFFFFF", "$type": "color" },
    "surface": {
      "default": { "$value": "#FFFBFE", "$type": "color" },
      "elevated": { "$value": "#F7F2FA", "$type": "color" }
    }
  },
  "spacing": {
    "xs": { "$value": "4", "$type": "dimension" },
    "sm": { "$value": "8", "$type": "dimension" },
    "md": { "$value": "16", "$type": "dimension" },
    "lg": { "$value": "24", "$type": "dimension" },
    "xl": { "$value": "32", "$type": "dimension" }
  },
  "radius": {
    "sm": { "$value": "4", "$type": "dimension" },
    "md": { "$value": "12", "$type": "dimension" },
    "lg": { "$value": "16", "$type": "dimension" },
    "xl": { "$value": "28", "$type": "dimension" },
    "full": { "$value": "9999", "$type": "dimension" }
  }
}
```

### Platform Token Mapping

| Design Token | Android (dp/sp) | iOS (pt) | Web (px/rem) |
|-------------|-----------------|----------|-------------|
| `spacing.md = 16` | 16dp | 16pt | 16px / 1rem |
| `typography.body.size = 16` | 16sp | 16pt | 16px / 1rem |
| `radius.md = 12` | 12dp | 12pt | 12px |
| `elevation.level2 = 3` | 3dp (tonal tint in M3) | Shadow: offset 0/2, blur 6, #000 @ 15% | box-shadow: 0 2px 6px rgba(0,0,0,0.15) |

### Figma Variables → Code Pipeline

```
1. Design in Figma
   └── Define Variables (Figma Variables panel)
       ├── Color modes: Light / Dark
       ├── Spacing scale: 4-8-12-16-24-32
       └── Typography: heading/body/label scales

2. Export tokens
   ├── Figma Tokens Studio plugin → JSON (DTCG format)
   ├── Or: Figma REST API → Variables endpoint
   └── Style Dictionary transforms JSON → platform code

3. Transform with Style Dictionary
   ├── Android: colors.xml, dimens.xml, Compose Theme.kt
   ├── iOS: Colors.xcassets, UIFont extensions, SwiftUI Theme
   └── Web: CSS custom properties, SCSS variables

4. Import into codebase
   └── CI/CD: auto-generate on Figma push (webhook)
```

### Component Spec Documentation

| Spec Element | What to Document |
|-------------|-----------------|
| Component name | Matches Figma component name exactly |
| Variants | All states: default, hover, pressed, focused, disabled |
| Dimensions | Width (fixed/fill), height, padding, margin |
| Typography | Token reference (not raw values) |
| Colors | Token reference for each state |
| Corner radius | Token reference |
| Elevation/shadow | Token reference |
| Motion | Enter/exit/state-change animation specs |
| Spacing to neighbors | Layout constraints, min/max |
| Responsive behavior | How component adapts at each breakpoint |

### Figma Dev Mode

| Feature | Benefit |
|---------|---------|
| Inspect panel | Auto-generated code snippets (SwiftUI, Compose, CSS) |
| Component playground | Interactive variant switching |
| Annotation markers | Designer-added notes on behavior |
| Variables inspect | See resolved token values |
| Redline measurements | Auto-measured spacing between elements |
| Version comparison | Diff between design versions |

### Accessibility Annotations in Figma

| Annotation | Format | Example |
|-----------|--------|---------|
| Reading order | Numbered sequence | 1→2→3→4 |
| Heading level | H1/H2/H3 tag | "Screen Title" = H1 |
| Role | Button / Link / Tab / Switch | "Add to Cart" = Button |
| Label | accessibilityLabel text | "Close" (for X icon) |
| State | Expandable, selected, disabled | "Expanded" / "Collapsed" |
| Live region | Assertive / Polite | Banner = Assertive |
| Focus order override | When reading order ≠ visual order | Custom sequence |

### Checklist

- ✅ All design values use tokens (no magic numbers in Figma or code)
- ✅ Token names are platform-agnostic (not `ios_blue` or `android_primary`)
- ✅ Tokens cover all categories: color, spacing, typography, elevation, radius, motion
- ✅ Dark mode tokens defined as aliases (not separate values)
- ✅ Component specs list all states and responsive behavior
- ✅ Accessibility annotations included in design files
- ✅ Token export automated (Style Dictionary or equivalent)
- ❌ Don't hardcode px/dp values in code — always reference token
- ❌ Don't create one-off colors — add to token system
- ❌ Don't design at fixed phone size only — include tablet breakpoints

### Sources

- Design Tokens W3C (DTCG): design-tokens.github.io/community-group/format/
- Style Dictionary: amzn.github.io/style-dictionary
- Figma Variables: figma.com/best-practices/variables-in-figma
- Figma Dev Mode: figma.com/dev-mode

---

## BW. App Rating Prompt Strategy

### Trigger Rules

| Rule | Value | Rationale |
|------|-------|-----------|
| Min sessions before prompt | 3–5 | User has experienced value |
| Min days since install | 7+ | Not on day 1 |
| Positive moment trigger | After completing key action (goal reached, purchase confirmed, level completed) | Positive sentiment = higher rating |
| Cooldown after prompt | 90+ days (iOS enforces 3x/365 days) | Don't pester |
| Cooldown after "Not Now" | 30–60 days | Respect the decline |
| Cooldown after rating given | Never prompt again (or 365 days for major update) | One and done |
| Max lifetime prompts | 3–4 ever | Diminishing returns |
| Never prompt after | Negative experience (error, crash, failed action) | Would get 1-star |

### Two-Stage Pattern (Custom Pre-Prompt)

```
Stage 1: Custom in-app prompt
┌──────────────────────────────────────┐
│                                      │
│        Enjoying AppName?             │
│                                      │
│  ┌──────────┐    ┌──────────┐       │
│  │    😊    │    │    😐    │       │
│  │  Yes!    │    │ Not Really│       │
│  └──────────┘    └──────────┘       │
└──────────────────────────────────────┘

If "Yes!" → Stage 2: system rating prompt
If "Not Really" → Feedback form (not App Store)
```

**Why this works:** Filters negative feedback to your support team instead of public reviews. Users who tap "Yes" rate 4–5 stars.

### iOS — SKStoreReviewController

```swift
import StoreKit

// iOS 16+ (preferred)
func requestReview() {
    guard shouldShowReview() else { return }
    
    if let scene = UIApplication.shared.connectedScenes
        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        AppStore.requestReview(in: scene)
    }
    
    UserDefaults.standard.set(Date(), forKey: "lastReviewPrompt")
    UserDefaults.standard.set(
        (UserDefaults.standard.integer(forKey: "reviewPromptCount")) + 1,
        forKey: "reviewPromptCount"
    )
}

func shouldShowReview() -> Bool {
    let sessions = UserDefaults.standard.integer(forKey: "sessionCount")
    let lastPrompt = UserDefaults.standard.object(forKey: "lastReviewPrompt") as? Date
    let promptCount = UserDefaults.standard.integer(forKey: "reviewPromptCount")
    
    guard sessions >= 5, promptCount < 3 else { return false }
    if let last = lastPrompt {
        return Date().timeIntervalSince(last) > 90 * 24 * 3600 // 90 days
    }
    return true
}
```

### Android — ReviewManager API

```kotlin
import com.google.android.play.core.review.ReviewManagerFactory

class ReviewHelper(private val activity: Activity) {
    private val reviewManager = ReviewManagerFactory.create(activity)
    
    fun requestReview() {
        if (!shouldShowReview()) return
        
        reviewManager.requestReviewFlow().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val reviewInfo = task.result
                reviewManager.launchReviewFlow(activity, reviewInfo)
                    .addOnCompleteListener {
                        // Can't know if user actually rated
                        saveReviewPromptTimestamp()
                    }
            }
        }
    }
    
    private fun shouldShowReview(): Boolean {
        val prefs = activity.getSharedPreferences("review", MODE_PRIVATE)
        val sessions = prefs.getInt("sessionCount", 0)
        val lastPrompt = prefs.getLong("lastPrompt", 0)
        val cooldown = 90L * 24 * 3600 * 1000 // 90 days in ms
        
        return sessions >= 5 && (System.currentTimeMillis() - lastPrompt > cooldown)
    }
}
```

### Platform Limits

| Platform | Limit | Notes |
|----------|-------|-------|
| iOS | System shows prompt max 3× per 365 days | Apple controls; `requestReview` may silently no-op |
| Android | No hard limit | Google recommends infrequent use |
| iOS | No customization of system dialog | Cannot change text or add incentive |
| Android | In-app review (no redirect to store) | User stays in app |
| Both | Cannot detect if user actually submitted rating | Privacy by design |

### Checklist

- ✅ Trigger after positive moment (not random or at launch)
- ✅ Min 5 sessions / 7 days before first prompt
- ✅ 90+ day cooldown between prompts
- ✅ Custom pre-prompt filters negative sentiment to feedback form
- ✅ Track prompt count; max 3–4 lifetime
- ✅ Never prompt after crash, error, or failed action
- ✅ Use system API (`SKStoreReviewController` / `ReviewManager`)
- ❌ Don't incentivize ratings ("Rate us for coins!")  — App Store violation
- ❌ Don't prompt on first launch
- ❌ Don't prompt during critical flows (onboarding, checkout)
- ❌ Don't redirect to store page manually (use in-app review API)

### Sources

- SKStoreReviewController: developer.apple.com/documentation/storekit/requesting-app-store-reviews
- Google Play In-App Review: developer.android.com/guide/playcore/in-app-review
- Apple App Store Review Guidelines §5.6.1 (no incentivized reviews)

---

## BX. Error Handling UX (Comprehensive)

### Error Anatomy

Every error message must answer three questions:

| Question | Component | Example |
|----------|-----------|---------|
| **What** happened? | Title | "Couldn't save your changes" |
| **Why** did it happen? | Description | "You appear to be offline." |
| **What can the user do?** | Action | "Try again when connected." + [Retry] button |

### Error Severity → UI Pattern

| Severity | UI Component | Dismiss | Example |
|----------|-------------|---------|---------|
| Inline validation | Red text below field, 12sp | Auto-clears on valid input | "Email address is invalid" |
| Field error (submitted) | Red border + error icon + message | On correction | "Password must be 8+ characters" |
| Snackbar (recoverable) | Bottom bar, 4–8s | Auto-dismiss + retry | "Couldn't load. [Retry]" |
| Banner (persistent) | Top of content area | Manual dismiss or auto-resolve | "No internet connection" |
| Dialog (blocking) | Modal center screen | Button dismiss | "Session expired. [Log in]" |
| Full-screen (fatal) | Entire viewport | Retry or navigate away | "Something went wrong" |

### Error Messaging by HTTP Status

| Status | User-Facing Message | Technical Cause |
|--------|-------------------|-----------------|
| 400 | "Please check your input and try again" | Bad request / validation |
| 401 | "Please log in to continue" | Unauthorized / session expired |
| 403 | "You don't have permission to do this" | Forbidden |
| 404 | "This content is no longer available" | Not found |
| 408 | "Request took too long. Check your connection." | Timeout |
| 409 | "This was updated by someone else. Refresh to see changes." | Conflict |
| 429 | "Too many requests. Please wait a moment." | Rate limited |
| 500 | "Something went wrong on our end. Try again shortly." | Server error |
| 502/503 | "Our servers are temporarily unavailable. Please try later." | Gateway/service down |
| Network error | "No internet connection. Check your WiFi or mobile data." | No connectivity |

**Never show:** raw status codes, stack traces, server error messages, or technical jargon to users.

### Inline Validation

```
Valid:
┌──────────────────────────────────┐
│  Email                           │
│  ┌──────────────────────────┐    │
│  │ user@example.com    ✓    │    │  ← Green check on valid
│  └──────────────────────────┘    │
│                                  │

Invalid:
┌──────────────────────────────────┐
│  Email                           │
│  ┌──────────────────────────┐    │  ← Red border (2dp)
│  │ user@              ⚠    │    │  ← Error icon
│  └──────────────────────────┘    │
│  ⚠ Enter a valid email address  │  ← Red text, 12sp
│                                  │
```

| Timing | Approach | Notes |
|--------|----------|-------|
| On blur (field exit) | Validate when user leaves field | Standard — not while typing |
| On submit | Validate all fields, scroll to first error | Fallback if no on-blur |
| Real-time (while typing) | Only for password strength, character count | Don't show "invalid" mid-typing |

### Retry & Exponential Backoff UX

| Attempt | Delay | User-Facing |
|---------|-------|-------------|
| 1 | Immediate | Spinner → error → [Retry] |
| 2 (auto) | 2s | "Retrying..." |
| 3 (auto) | 4s | "Still trying..." |
| 4+ | Manual only | "Couldn't connect. [Retry]" |
| Max auto-retries | 3 | Then require user action |

### Full-Screen Error State

```
┌──────────────────────────────────────┐
│                                      │
│                                      │
│         ┌──────────────┐             │
│         │  [Sad cloud]  │            │  ← Illustration (not emoji in prod)
│         └──────────────┘             │
│                                      │
│     "Something went wrong"           │  ← Title, 22sp
│                                      │
│  We couldn't load this page.         │  ← Description, 16sp, secondary
│  Please check your connection        │
│  and try again.                      │
│                                      │
│       ┌──────────────┐               │
│       │    Retry      │              │  ← Primary action
│       └──────────────┘               │
│                                      │
│        Go to Home                    │  ← Secondary text button
│                                      │
└──────────────────────────────────────┘
```

### Graceful Degradation (Cached Content)

| Strategy | When | Implementation |
|----------|------|---------------|
| Show cached data + offline banner | Network failure on refresh | Load from Room/Core Data; show "Offline — data may be outdated" banner |
| Stale-while-revalidate | Slow network | Show cache immediately, refresh in background |
| Partial content | Some API calls succeed, some fail | Show what loaded; error state for failed sections |
| Disable write actions | Offline | Gray out "Submit" + tooltip "Requires connection" |

### Error Boundary Pattern

```kotlin
// Compose: error boundary
@Composable
fun ErrorBoundary(
    fallback: @Composable (Throwable, () -> Unit) -> Unit = { error, retry ->
        FullScreenError(message = error.userMessage(), onRetry = retry)
    },
    content: @Composable () -> Unit
) {
    var error by remember { mutableStateOf<Throwable?>(null) }
    
    if (error != null) {
        fallback(error!!) { error = null }
    } else {
        // Wrap content with error catching via ViewModel/state
        content()
    }
}
```

```swift
// SwiftUI: error state pattern
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let data):
                DataView(data: data)
            case .error(let error):
                ErrorView(
                    message: error.userFacingMessage,
                    onRetry: { viewModel.load() }
                )
            }
        }
        .task { viewModel.load() }
    }
}
```

### Error Logging (Silent)

| What to Log | Don't Log |
|-------------|-----------|
| Error type + HTTP status | User passwords or tokens |
| Endpoint / screen name | Full request/response bodies |
| Timestamp + app version | PII (name, email) unless consented |
| Device model + OS version | Clipboard contents |
| Stack trace (crash only) | — |

### Checklist

- ✅ Every error says what happened, why, and what to do
- ✅ Inline validation on field blur (not while typing)
- ✅ Error messages are human-readable (no codes, no jargon)
- ✅ Retry available for all transient errors
- ✅ Exponential backoff with max 3 auto-retries
- ✅ Cached content shown when offline (with banner)
- ✅ Full-screen error has illustration + retry + alternative nav
- ✅ Errors logged silently for debugging (no PII)
- ✅ Scroll to first error on form submit
- ❌ Don't show raw HTTP status codes or server messages
- ❌ Don't use alert dialogs for every error (inline first)
- ❌ Don't leave user on blank screen (always show error state)
- ❌ Don't auto-retry indefinitely (max 3, then manual)

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| "An error occurred" (no detail) | User doesn't know what to do | Specify what+why+action |
| Alert for every API failure | Alert fatigue | Inline/snackbar for non-blocking, dialog for blocking only |
| Blank white screen on error | Looks broken/frozen | Always render error state |
| Showing stack trace in production | Confusing, security risk | Log silently, show friendly message |
| No offline fallback | Useless app without network | Cache essential data locally |
| Retry loops forever | Battery drain, user frustration | Max 3 auto, then manual |

### Sources

- Material Design — Communication (errors): m3.material.io/foundations/interaction/error-states
- Apple HIG — Alerts: developer.apple.com/design/human-interface-guidelines/alerts
- NNG — Error Message Guidelines: nngroup.com/articles/error-message-guidelines
- HTTP Status Codes: developer.mozilla.org/en-US/docs/Web/HTTP/Status
## BY. Accessibility Automation Testing

Automated accessibility testing integrated into CI pipelines catches regressions before they reach users. Both platforms provide first-party tooling that can be wired into pull-request checks.

### iOS — XCTest Accessibility Audit (Xcode 15+)

```swift
// UITests/AccessibilityAuditTests.swift
import XCTest

final class AccessibilityAuditTests: XCTestCase {
    func testHomeScreenAccessibility() throws {
        let app = XCUIApplication()
        app.launch()

        // Runs all audit categories by default (contrast, hit region, traits, labels)
        try app.performAccessibilityAudit()
    }

    func testSettingsScreenIgnoringDynamicType() throws {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons["Settings"].tap()

        // Exclude specific audit categories when justified
        try app.performAccessibilityAudit(for: [
            .contrast,
            .hitRegion,
            .sufficientElementDescription
        ]) { issue in
            // Filter known false positives by element identifier
            return issue.element?.identifier != "decorativeIcon"
        }
    }
}
```

Key audit categories: `.contrast` (WCAG AA 4.5:1 / 3:1 large), `.hitRegion` (44×44 pt minimum), `.sufficientElementDescription` (missing labels), `.dynamicType` (text responds to size settings).

Run headless in CI: `xcodebuild test -scheme App -destination 'platform=iOS Simulator,name=iPhone 15' -testPlan AccessibilityAudits`

### Android — Espresso + Accessibility Test Framework (ATF)

```kotlin
// app/src/androidTest/java/com/app/a11y/AccessibilityTests.kt
import androidx.test.espresso.accessibility.AccessibilityChecks
import androidx.test.ext.junit.runners.AndroidJUnit4
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class AccessibilityTests {

    companion object {
        @JvmStatic
        @BeforeClass
        fun setup() {
            // Enable ATF checks on every Espresso ViewAction
            AccessibilityChecks.enable()
                .setRunChecksFromRootView(true)  // check entire hierarchy
                .setThrowExceptionFor(
                    AccessibilityCheckResultType.ERROR  // fail on errors, warn on others
                )
        }
    }

    @Test
    fun homeScreen_passesAccessibilityChecks() {
        // Any Espresso interaction now automatically triggers ATF
        onView(withId(R.id.trackButton)).perform(click())
        // ATF checks: touch target ≥48dp, contrast, missing contentDescription,
        // duplicate clickable ancestors, traversal order
    }
}
```

Complement with Google Accessibility Scanner for manual sweeps during QA; it produces JSON reports importable into issue trackers.

### CI Pipeline Integration

```yaml
# .github/workflows/a11y.yml (relevant job excerpt)
a11y-gate:
  runs-on: macos-14
  steps:
    - uses: actions/checkout@v4
    - name: iOS Accessibility Audit
      run: |
        xcodebuild test -scheme App \
          -destination 'platform=iOS Simulator,name=iPhone 15' \
          -testPlan AccessibilityAudits \
          -resultBundlePath a11y-results.xcresult
    - name: Android ATF Checks
      run: ./gradlew connectedAndroidTest -Pandroid.testInstrumentationRunnerArguments.class=com.app.a11y.AccessibilityTests
```

**Severity tiers and build policy:**
| Tier | Examples | Build gate |
|------|----------|------------|
| P0 — Blocker | Missing label on primary action, 0 contrast, no focus target | Fail PR |
| P1 — Major | Touch target 42dp (below 48dp), contrast 4.0:1 (below 4.5) | Warn, block release |
| P2 — Minor | Redundant contentDescription, suboptimal traversal order | Track in backlog |

### Accessibility Tree Regression Testing

Capture and diff the accessibility hierarchy between builds to detect unintentional changes:

- **iOS:** `xcrun simctl accessibility <device> -json > a11y-tree.json` — diff against baseline.
- **Android:** `adb shell uiautomator dump /sdcard/a11y-tree.xml` — parse and compare node labels, roles, states.

Store baseline snapshots in the repo under `tests/a11y-baselines/`. On each PR, generate a fresh dump and diff against baseline. Flag any removed labels, changed roles, or deleted nodes as potential regressions. Update baselines intentionally via a dedicated `update-a11y-baseline` CI job requiring explicit reviewer approval.

---

## BZ. AI/ML UX Patterns on Mobile

### When to Use On-Device ML

On-device inference eliminates network latency, works offline, and keeps sensitive data local. Use server-side models only when the task exceeds device capability (large language models, complex generative tasks) or when the model exceeds reasonable download size (>50 MB compressed).

| Capability | iOS Framework | Android Framework | Typical Latency |
|-----------|--------------|-------------------|-----------------|
| Image classification | Core ML + Vision | ML Kit Image Labeling | 15-50 ms (on-device) |
| Object detection | Core ML + Vision | ML Kit Object Detection | 20-60 ms |
| Text recognition (OCR) | Vision | ML Kit Text Recognition | 30-100 ms |
| Face detection | Vision | ML Kit Face Detection | 10-30 ms |
| Barcode scanning | Vision | ML Kit Barcode Scanning | 5-20 ms |
| Smart Reply | Create ML (custom) | ML Kit Smart Reply | 10-40 ms |
| On-device translation | Translation framework (iOS 15+) | ML Kit Translation | 30-80 ms per sentence |
| Pose detection | Vision body pose (iOS 14+) | ML Kit Pose Detection | 20-50 ms |

Sources: Apple Core ML documentation, Google ML Kit documentation.

### Smart Suggestions UX

Present ML-generated suggestions as gentle nudges, never as forced choices. The user must always retain full control.

**Presentation hierarchy (by confidence):**

| Confidence Level | UI Treatment | Example |
|-----------------|-------------|---------|
| High (>90%) | Inline auto-fill, single tap to accept | QuickType keyboard suggestion |
| Medium (60-90%) | Chip row or dropdown, 2-3 options | Smart Reply bubbles |
| Low (30-60%) | Collapsed "Suggestions" section | "Did you mean..." link |
| Very low (<30%) | Do not show | Suppress prediction entirely |

**Rules:**
- Show at most 3 suggestions simultaneously (NNGroup recommendation for choice overload)
- Place suggestions near the input they relate to, within 8-16 dp/pt
- Use a distinct visual style (e.g., outlined chip, lighter background) to differentiate from user-generated content
- Always provide a dismiss/clear action (X button or swipe)

```kotlin
// ML Kit Smart Reply — Android
val smartReplyGenerator = SmartReply.getClient()
smartReplyGenerator.suggestReplies(conversation)
    .addOnSuccessListener { result ->
        if (result.status == SmartReplySuggestionResult.STATUS_SUCCESS) {
            result.suggestions.take(3).forEach { suggestion ->
                // Display as MaterialChip, confidence not exposed but
                // internally filtered by ML Kit (only high-confidence shown)
                addSuggestionChip(suggestion.text)
            }
        }
    }
```

```swift
// Core ML custom suggestion model — iOS
func predict(context: String) {
    guard let model = try? SmartSuggestionModel(configuration: .init()),
          let output = try? model.prediction(input: context) else {
        // Fallback: show no suggestions (graceful degradation)
        return
    }
    let suggestions = output.topK(3).filter { $0.confidence > 0.6 }
    DispatchQueue.main.async {
        self.showSuggestionChips(suggestions.map(\.label))
    }
}
```

### Camera-Based ML UX

| Guideline | Value | Source |
|-----------|-------|--------|
| Viewfinder frame rate | 30 fps minimum, 60 fps preferred | Apple AVFoundation docs |
| Detection overlay delay | < 100 ms from frame capture to bounding box render | Google ML Kit performance guidance |
| Bounding box stroke | 2-3 dp/pt, high-contrast color on semi-transparent scrim | Material Design guidance |
| Confidence label font | 12-14 sp, positioned above bounding box with 4 dp padding | Material Design typography |
| Haptic on detection | UIImpactFeedbackGenerator.style.light (iOS) / HapticFeedbackConstants.CONFIRM (Android) | Platform HIG |

**Camera permission flow:** Request access only when the user initiates a camera-based ML feature, not at app launch. Show a pre-permission screen explaining why the camera is needed and what the ML model will do with the visual data.

### Trust & Explainability

Users must understand why the system made a decision, especially for consequential outcomes (financial, health, safety).

| Principle | Implementation | Example |
|-----------|---------------|---------|
| Transparency | Show source data that influenced the result | "Based on your last 3 purchases" |
| Calibrated confidence | Map internal scores to user-friendly language | "Very likely" / "Possible" / "Uncertain" |
| Correction mechanism | Let users override or correct ML output | "Not relevant" button, edit suggestion |
| Attribution | Cite the model or data source when appropriate | "Suggested by on-device analysis" |
| Progressive disclosure | Summary first, details on tap | "Why this suggestion?" expandable row |

Source: Apple Machine Learning HIG ("People should always feel in control"), NNGroup AI UX guidelines (2023).

### Fallback When Model Fails

| Failure Mode | Detection | Fallback UX |
|-------------|-----------|-------------|
| Model file missing/corrupt | `try/catch` on model load | Offer manual input; download model in background |
| Low confidence on all classes | Max confidence < threshold (e.g., 30%) | "We're not sure. Please enter manually." |
| Timeout (inference > 2 s) | Watchdog timer | Cancel inference, show manual path |
| Out-of-distribution input | Anomaly detection layer or confidence check | "This doesn't look like [expected input]. Try again." |
| Hardware acceleration unavailable | Check GPU/NPU delegate availability | Fall back to CPU inference (slower but functional) |

```kotlin
// Android — graceful fallback on model load failure
val options = CustomImageLabelerOptions.Builder()
    .setConfidenceThreshold(0.5f)
    .setMaxResultCount(5)
    .build()

try {
    val labeler = ImageLabeling.getClient(localModel, options)
    labeler.process(image)
        .addOnSuccessListener { labels ->
            if (labels.isEmpty()) showManualInput()
            else displayResults(labels)
        }
        .addOnFailureListener { showManualInput() }
} catch (e: Exception) {
    // Model not available — degrade to manual
    showManualInput()
    downloadModelInBackground()
}
```

### Checklist

- [ ] ML suggestions show at most 3 options with clear dismiss action
- [ ] Confidence below 30% suppresses prediction entirely
- [ ] Camera ML overlay renders within 100 ms of frame capture
- [ ] Every ML decision has an explanation path ("Why this?")
- [ ] Users can correct or override every ML output
- [ ] Model load failure falls back to manual input without crash
- [ ] On-device models are under 50 MB compressed
- [ ] Pre-permission screen explains ML camera usage before requesting access
- [ ] Haptic feedback confirms detection events

### Anti-Patterns

- **Overconfident UI**: Presenting low-confidence predictions as certain facts
- **Black box**: No explanation for why a suggestion was made
- **Hard dependency**: App crashes or shows empty state when model fails instead of falling back to manual input
- **Permission grab**: Requesting camera at app launch "for ML features"
- **Suggestion fatigue**: Showing suggestions on every screen regardless of relevance

**Sources:** Apple Machine Learning Human Interface Guidelines, Google ML Kit documentation, NNGroup "AI and UX" research reports (2023), Core ML documentation (Apple Developer), TensorFlow Lite Android documentation.

---

## CA. Privacy Regulation UX (GDPR / ATT / CCPA)

### App Tracking Transparency (iOS 14.5+)

ATT requires apps to request user permission before tracking across apps and websites owned by other companies. The system dialog is non-customizable, but the pre-prompt screen is yours.

| Rule | Detail | Source |
|------|--------|--------|
| System prompt trigger | `ATTrackingManager.requestTrackingAuthorization()` | Apple ATT docs |
| Pre-prompt recommended | Explain value before system dialog appears | Apple HIG — Accessing Private Data |
| Prompt timing | After onboarding, during a natural pause — never on first launch | Apple HIG |
| Purpose string required | `NSUserTrackingUsageDescription` in Info.plist | Apple Developer docs |
| Rejection rate | ~75-85% of users deny tracking (industry average, 2023) | AppsFlyer, Adjust public reports |
| Re-prompt | Cannot re-trigger system dialog; guide user to Settings | Apple ATT docs |

**Pre-prompt pattern (recommended):**

```
┌──────────────────────────────────────┐
│                                      │
│     [App icon / illustration]        │
│                                      │
│   Help us show you relevant ads      │  <- Title, 20sp
│                                      │
│   We use an identifier to serve      │  <- Body, 16sp, secondary
│   ads that match your interests.     │
│   Your data is never sold.           │
│                                      │
│   ┌──────────────────────────┐       │
│   │      Continue             │      │  <- Primary CTA -> triggers system dialog
│   └──────────────────────────┘       │
│                                      │
│         Not Now                      │  <- Secondary: sets .denied without prompt
│                                      │
└──────────────────────────────────────┘
```

```swift
// iOS — ATT flow with pre-prompt
import AppTrackingTransparency

func requestTracking() {
    // Check current status first
    let status = ATTrackingManager.trackingAuthorizationStatus
    switch status {
    case .notDetermined:
        showPrePromptScreen {
            ATTrackingManager.requestTrackingAuthorization { newStatus in
                DispatchQueue.main.async {
                    self.configureAnalytics(for: newStatus)
                }
            }
        }
    case .denied, .restricted:
        configureAnalytics(for: status) // Use SKAdNetwork only
    case .authorized:
        configureAnalytics(for: status) // Full attribution
    @unknown default:
        break
    }
}
```

### GDPR Consent Flows

GDPR Article 7 requires consent to be freely given, specific, informed, and unambiguous. Pre-ticked boxes or bundled consent are invalid.

| Requirement | Implementation | Violation Example |
|------------|---------------|-------------------|
| Freely given | Equal visual weight for Accept/Reject | Giant "Accept" vs tiny "Manage" link |
| Specific | Separate toggles per purpose (analytics, ads, personalization) | Single "Accept all" with no granular option |
| Informed | Plain-language explanation of each purpose | Legal jargon only |
| Unambiguous | Affirmative action required (tap, toggle) | Pre-checked boxes |
| Withdrawable | Settings path to revoke at any time | No way to change consent later |
| Age-gated | Under-16 requires parental consent (varies by EU member state: 13-16) | No age verification |

**Consent banner layout:**

```
┌──────────────────────────────────────┐
│  We value your privacy               │  <- Title, 18sp bold
│                                      │
│  We use cookies and similar tech     │  <- Body, 14sp
│  for analytics and personalization.  │
│                                      │
│  ○ Essential (always on)             │  <- Non-toggleable
│  ○ Analytics         [toggle OFF]    │  <- Default OFF per GDPR
│  ○ Advertising       [toggle OFF]    │
│  ○ Personalization   [toggle OFF]    │
│                                      │
│  ┌────────────┐  ┌────────────┐      │
│  │  Accept All │  │ Save Choices│     │  <- Equal visual weight
│  └────────────┘  └────────────┘      │
│                                      │
│        Reject All                    │  <- Must be equally accessible
│                                      │
│  Privacy Policy                      │
└──────────────────────────────────────┘
```

**Critical sizing rules:**
- "Reject All" button must be the same size and prominence as "Accept All" (CNIL enforcement, 2022: fined Google EUR 150M for making rejection harder)
- Minimum touch target 48 dp / 44 pt for all consent buttons
- Consent toggles must default to OFF (opt-in, not opt-out)

### CCPA / CPRA — Do Not Sell

| Requirement | Implementation | Source |
|------------|---------------|--------|
| "Do Not Sell or Share" link | Visible in app Settings, accessible within 2 taps from home | CCPA Section 1798.135 |
| Opt-out mechanism | Toggle or explicit button, no account required | CCPA regulations |
| Response time | Honor request within 15 business days | CCPA Section 1798.135 |
| Annual reminder | For users who previously opted in, remind them of the right | CPRA amendment |
| Global Privacy Control | Respect GPC browser signal (`Sec-GPC: 1`) | California AG guidance |

### Privacy Nutrition Labels

Both platforms require disclosure of data practices before download.

| Platform | Label Name | Categories | Source |
|----------|-----------|-----------|--------|
| iOS | App Privacy (App Store) | Data Used to Track You, Data Linked to You, Data Not Linked to You, Data Not Collected | Apple App Store Review Guidelines 5.1.2 |
| Android | Data Safety section (Play Store) | Data shared, Data collected, Security practices | Google Play Data Safety policy |

**Data types to declare (both platforms):** Contact info, health/fitness, financial, location, contacts, user content, browsing history, search history, identifiers, usage data, diagnostics, purchases.

### Data Deletion Requests

| Platform | Requirement | Deadline | Source |
|---------|------------|----------|--------|
| iOS (App Store) | Must offer account deletion if app offers account creation | Within reasonable time | Apple App Store Review Guideline 5.1.1(v) |
| Android (Play Store) | Must offer in-app and web-based account/data deletion | Within reasonable time | Google Play User Data policy (2023) |
| GDPR | Right to erasure (Article 17) | 30 days | GDPR |
| CCPA | Right to delete | 45 days (extendable to 90) | CCPA Section 1798.105 |

**Deletion flow UX:**

```swift
// iOS — Account deletion with confirmation
func requestAccountDeletion() {
    let alert = UIAlertController(
        title: "Delete Account?",
        message: "This will permanently delete your account and all associated data. This action cannot be undone.",
        preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Delete Account", style: .destructive) { _ in
        self.showReauthentication { success in
            if success {
                self.performDeletion()
            }
        }
    })
    present(alert, animated: true)
}
```

### Consent Management UI Patterns

| Pattern | Use Case | Implementation |
|---------|----------|---------------|
| Just-in-time consent | Feature-specific permission | Show consent dialog when user first accesses feature |
| Layered notice | Complex privacy policy | Summary layer + full detail on tap |
| Preference center | Granular control | Settings screen with per-category toggles |
| Consent receipt | Audit trail | Store timestamp, version, and choices; export on request |
| Re-consent on change | Policy update | Block access until user reviews new terms |

### Checklist

- [ ] ATT pre-prompt explains value before system dialog (iOS)
- [ ] ATT is never triggered on first app launch
- [ ] GDPR consent toggles default to OFF
- [ ] "Reject All" has equal visual weight as "Accept All"
- [ ] CCPA "Do Not Sell" link accessible within 2 taps from home
- [ ] Account deletion offered in-app if account creation exists
- [ ] Privacy nutrition labels submitted and accurate on both stores
- [ ] Consent choices stored with timestamp and version for audit
- [ ] Under-16 consent gating implemented for EU users
- [ ] Re-authentication required before account deletion

### Anti-Patterns

- **Dark patterns**: Making "Reject" harder to find, smaller, or requiring more taps than "Accept"
- **Consent wall**: Blocking app usage entirely until all tracking is accepted (illegal under GDPR)
- **Bundled consent**: Single checkbox for all purposes without granular control
- **Zombie tracking**: Continuing to track after user revokes consent
- **Deletion theater**: Marking data as deleted but retaining it in backups indefinitely

**Sources:** Apple App Tracking Transparency documentation, Apple App Store Review Guidelines 5.1, GDPR Articles 7/17, CCPA Sections 1798.105/135, CNIL enforcement decisions (2022), Google Play Data Safety policy, ICO consent guidance.

---

## CB. Android 15 Edge-to-Edge Mandatory

### Overview

Starting with Android 15 (API 35), edge-to-edge rendering is enforced for all apps targeting the new SDK. Apps draw behind system bars (status bar and navigation bar) by default. The previously optional `enableEdgeToEdge()` behavior is now mandatory.

### What Changed in API 35

| Component | Gesture Navigation | 3-Button Navigation | Source |
|-----------|-------------------|---------------------|--------|
| Status bar | Transparent, no offset | Transparent, no offset | Android 15 behavior changes |
| Navigation bar | Transparent, no offset | 80% opaque, matches window background | Android 15 behavior changes |
| `setStatusBarColor()` | Deprecated, no effect | Deprecated, no effect | Android developer docs |
| `setNavigationBarColor()` | Deprecated, no effect | Deprecated, still functional | Android developer docs |
| `setNavigationBarContrastEnforced()` | No effect | Defaults to true (adds 80% scrim) | Android developer docs |
| `setDecorFitsSystemWindows()` | Deprecated, no effect | Deprecated, no effect | Android developer docs |
| Display cutout mode | Forced to `ALWAYS` | Forced to `ALWAYS` | Android developer docs |

### WindowInsets API — Core Types

```kotlin
// Primary inset types
WindowInsets.Type.statusBars()       // Height of the status bar
WindowInsets.Type.navigationBars()   // Height of the navigation bar
WindowInsets.Type.systemBars()       // Combined: status + navigation + caption bar
WindowInsets.Type.ime()              // Software keyboard
WindowInsets.Type.displayCutout()    // Notch / punch-hole / Dynamic Island
WindowInsets.Type.tappableElement()  // Tappable region of navigation bar (3-button)
WindowInsets.Type.systemGestures()   // System gesture zones (20 dp on edges)
WindowInsets.Type.mandatorySystemGestures() // Home gesture (bottom 16-24 dp)
```

### Migration: Jetpack Compose (Material 3)

Material 3 Compose components handle insets automatically when using `Scaffold`:

```kotlin
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppScreen() {
    Scaffold(
        topBar = {
            TopAppBar(title = { Text("Title") })
            // Automatically pads for status bar
        },
        bottomBar = {
            NavigationBar { /* ... */ }
            // Automatically pads for navigation bar
        }
    ) { innerPadding ->
        LazyColumn(
            contentPadding = innerPadding  // Apply scaffold padding
        ) {
            items(data) { item -> ItemRow(item) }
        }
    }
}
```

For custom layouts without Scaffold:

```kotlin
@Composable
fun CustomScreen() {
    val insets = WindowInsets.systemBars
    Column(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(insets)
    ) {
        // Content is within safe area
    }
}

// For LazyColumn — pad content, not the list itself
LazyColumn(
    contentPadding = WindowInsets.systemBars.asPaddingValues()
) { /* items */ }
```

### Migration: Android Views

```kotlin
// Activity setup — no longer needed for API 35, but required for backward compat
override fun onCreate(savedInstanceState: Bundle?) {
    enableEdgeToEdge()  // androidx.activity 1.8+
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_main)

    // Apply insets to your root content
    ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
        val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
        v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
        insets
    }
}
```

**RecyclerView with edge-to-edge:**

```kotlin
ViewCompat.setOnApplyWindowInsetsListener(recyclerView) { view, insets ->
    val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
    view.setPadding(systemBars.left, 0, systemBars.right, systemBars.bottom)
    insets
}
recyclerView.clipToPadding = false  // Critical: content scrolls behind nav bar
```

**AppBarLayout with Material Components:**

```xml
<com.google.android.material.appbar.AppBarLayout
    android:fitsSystemWindows="true"
    android:layout_width="match_parent"
    android:layout_height="wrap_content">
    <com.google.android.material.appbar.MaterialToolbar
        android:layout_width="match_parent"
        android:layout_height="?attr/actionBarSize" />
</com.google.android.material.appbar.AppBarLayout>
```

### Gesture Navigation Compatibility

| Zone | Width/Height | Behavior | Override Possible? |
|------|-------------|----------|-------------------|
| Back gesture (left/right edges) | 20 dp from each edge | System back swipe | Yes, via `setSystemGestureExclusionRects()` — max 200 dp total height |
| Home gesture (bottom) | 16-24 dp from bottom | Swipe up to go home | No — mandatory system gesture |
| Recent apps | Long swipe up from bottom | App switcher | No |

```kotlin
// Exclude a region from system back gesture (e.g., a custom slider)
view.doOnLayout {
    val exclusionRect = Rect(0, 0, 20.dpToPx(), it.height)
    it.systemGestureExclusionRects = listOf(exclusionRect)
}
// Total exclusion height capped at 200 dp per edge
```

### Configuration Class Change

`Configuration.screenWidthDp` and `screenHeightDp` now include system bars. Replace old checks:

```kotlin
// OLD — unreliable on API 35
val width = resources.configuration.screenWidthDp

// NEW — use WindowMetrics
val metrics = WindowMetricsCalculator.getOrCreate()
    .computeCurrentWindowMetrics(activity)
val widthDp = metrics.bounds.width() / resources.displayMetrics.density
```

### Testing Matrix

| Configuration | Test Points |
|--------------|------------|
| Gesture navigation | Content not obscured by transparent nav bar |
| 3-button navigation | Content not obscured by opaque nav bar (80%) |
| Display cutout (notch) | Content avoids cutout area |
| Landscape orientation | Side insets applied correctly |
| Foldable (unfolded) | Insets correct in tabletop and book postures |
| Keyboard open | `WindowInsets.ime()` pushes content above keyboard |

### Checklist

- [ ] `enableEdgeToEdge()` called in `onCreate()` before `setContentView()` (backward compat)
- [ ] `ViewCompat.setOnApplyWindowInsetsListener()` applied to root view (Views)
- [ ] `windowInsetsPadding()` or `contentPadding` used in Compose
- [ ] `RecyclerView.clipToPadding = false` for lists that scroll behind nav bar
- [ ] `fitsSystemWindows="true"` on AppBarLayout (Material Components)
- [ ] `Configuration.screenWidthDp` replaced with `WindowMetricsCalculator`
- [ ] Tested on gesture nav, 3-button nav, cutout devices, landscape, and foldables
- [ ] Splash screen uses `core-splashscreen:1.2.0-alpha01+` or handles cutout mode

### Anti-Patterns

- **Hardcoded status bar height**: Using `24 dp` instead of `WindowInsets.statusBars()`
- **Double padding**: Applying both `fitsSystemWindows` and manual inset padding
- **Ignoring IME insets**: Keyboard covers input fields because only `systemBars()` is handled
- **Opaque nav bar hack**: Trying to force an opaque color on gesture navigation bar (no longer possible)

**Sources:** Android 15 behavior changes documentation, Android developer WindowInsets guide, Material Design 3 Scaffold documentation, AndroidX Activity 1.8 release notes.

---

## CC. Material You Expressive (2025)

### Overview

Material Design Expressive, announced at Google I/O 2025, extends Material You's dynamic color with new theme dimensions that let apps express distinct emotional tones. It adds four expressive dimensions beyond the existing baseline theme, plus updated motion, shape, and component-level tokens.

### Expressive Theme Dimensions

| Dimension | Character | Color Treatment | Shape | Motion | Use Case |
|-----------|-----------|----------------|-------|--------|----------|
| **Casual** | Friendly, relaxed | Warmer tones, higher chroma | Rounded (full pill) | Bouncy, playful easing | Social, lifestyle apps |
| **Bold** | Confident, assertive | High contrast, saturated primaries | Angular, sharper corners | Snappy, decisive timing | Productivity, fintech |
| **Warm** | Inviting, comforting | Earth tones, amber/terracotta shifts | Soft squircle | Gentle, smooth easing | Health, wellness apps |
| **Playful** | Fun, energetic | Bright, multi-hue palette | Irregular, wavy | Springy, overshoot easing | Kids, games, creative apps |
| **Baseline** | Neutral, professional | Standard M3 tonal palette | Rounded rectangle (12 dp) | Standard M3 easing | Default, enterprise |

### Dynamic Color 2.0

Material You Expressive builds on the original dynamic color extraction from wallpaper/content:

| Feature | M3 Original | M3 Expressive | Source |
|---------|-------------|---------------|--------|
| Source colors | 1 seed from wallpaper | 1 seed + dimension adjustments | Material Design blog |
| Tonal palettes | 5 (Primary, Secondary, Tertiary, Neutral, Neutral Variant) | 5 + expressive overrides per dimension | M3 color system docs |
| Chroma range | Fixed per palette | Adjustable per dimension (e.g., Bold = +20% chroma) | Google I/O 2025 |
| Harmonized colors | Manual via `MaterialColors.harmonize()` | Automatic per-dimension harmonization | M3 Expressive docs |
| Color roles | 29 roles (surface, on-surface, primary, etc.) | 29 roles + 6 new expressive surface variants | M3 Expressive docs |

```kotlin
// Android — applying an expressive theme dimension
// build.gradle: implementation "com.google.android.material:material:1.13.0+"
import com.google.android.material.color.DynamicColors

class MyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // Apply expressive dynamic color with a specific dimension
        DynamicColors.applyToActivitiesIfAvailable(
            this,
            DynamicColorsOptions.Builder()
                .setThemeOverlay(R.style.ThemeOverlay_Material3_Expressive_Casual)
                .build()
        )
    }
}
```

### Motion Tokens

Expressive introduces named motion tokens that vary by dimension:

| Token | Baseline | Casual/Warm | Bold | Playful |
|-------|----------|-------------|------|---------|
| `duration.short1` | 50 ms | 50 ms | 50 ms | 50 ms |
| `duration.short2` | 100 ms | 100 ms | 80 ms | 120 ms |
| `duration.medium1` | 250 ms | 300 ms | 200 ms | 350 ms |
| `duration.medium2` | 350 ms | 400 ms | 300 ms | 450 ms |
| `duration.long1` | 450 ms | 500 ms | 350 ms | 550 ms |
| `easing.standard` | cubic-bezier(0.2, 0, 0, 1) | cubic-bezier(0.2, 0.1, 0, 1.1) | cubic-bezier(0.3, 0, 0.1, 1) | cubic-bezier(0.1, 0.2, 0, 1.2) |
| `easing.emphasized` | cubic-bezier(0.2, 0, 0, 1) | Springy overshoot | Sharp snap | Bouncy with overshoot |

Source: Material Design 3 motion specification, Google I/O 2025.

### Shape Morphing

Components can morph between shape states during interaction:

| Component State | Baseline Shape | Casual Shape | Playful Shape |
|----------------|---------------|--------------|---------------|
| FAB (resting) | 16 dp corner radius | Full pill (50%) | Squircle with 24 dp |
| FAB (pressed) | 12 dp corner radius | Slightly compressed pill | Blob morph |
| Card (resting) | 12 dp corner radius | 16 dp corner radius | Wavy border (SVG path) |
| Button (resting) | 20 dp corner radius (full) | Full pill | Asymmetric rounded |
| Button (pressed) | Scale 0.95 + corner stays | Scale 0.92 + squish | Scale 1.05 + bounce |

```kotlin
// Compose — shape morphing on press
val interactionSource = remember { MutableInteractionSource() }
val isPressed by interactionSource.collectIsPressedAsState()

val cornerRadius by animateDpAsState(
    targetValue = if (isPressed) 12.dp else 16.dp,
    animationSpec = spring(
        dampingRatio = Spring.DampingRatioMediumBouncy,  // Expressive: bouncy
        stiffness = Spring.StiffnessMedium
    )
)

Surface(
    shape = RoundedCornerShape(cornerRadius),
    interactionSource = interactionSource,
) { /* content */ }
```

### Component-Level Theming

Expressive allows different dimensions per component on the same screen:

```kotlin
// Apply Bold dimension to a specific card
MaterialTheme(
    colorScheme = dynamicExpressiveColorScheme(
        dimension = ExpressiveDimension.Bold
    )
) {
    ElevatedCard { /* High-impact CTA card */ }
}

// Rest of the screen uses Casual dimension
```

### Harmonized Colors

Custom brand colors automatically adjust to harmonize with the user's wallpaper-derived theme:

```kotlin
// Harmonize a fixed brand color with the dynamic theme
val brandRed = Color(0xFFE53935)
val harmonizedRed = MaterialColors.harmonize(
    brandRed.toArgb(),
    MaterialTheme.colorScheme.primary.toArgb()
).let { Color(it) }
// Result: brand red shifted slightly toward the user's primary hue
```

| Harmonization Shift | Effect | When to Use |
|-------------------|--------|-------------|
| Full harmonize | Shifts brand color up to 40 degrees toward primary | Non-brand UI elements |
| Partial harmonize | Shifts up to 15 degrees | Secondary brand elements |
| No harmonize | Brand color unchanged | Logo, critical brand marks |

### Checklist

- [ ] Selected appropriate expressive dimension for app personality
- [ ] Tested dynamic color with all 5 dimensions on multiple wallpapers
- [ ] Motion tokens match dimension (bouncy for Casual, snappy for Bold)
- [ ] Shape morphing animates smoothly at 60 fps
- [ ] Harmonized colors applied to non-brand custom colors
- [ ] Fallback theme defined for devices without dynamic color (pre-Android 12)
- [ ] Component-level theme overrides tested for visual coherence
- [ ] Dark theme variants tested for all dimensions

### Anti-Patterns

- **Dimension mismatch**: Using Playful shapes with Bold motion (inconsistent personality)
- **Over-morphing**: Shape animations on every component causing visual chaos
- **Ignoring fallback**: No static theme for pre-Android 12 devices (33% of active devices as of 2025)
- **Brand color conflict**: Fully harmonizing primary brand colors, making them unrecognizable

**Sources:** Material Design 3 Expressive documentation, Google I/O 2025 "What's new in Material Design" talk, Material Design 3 color system docs, Android Dynamic Colors API reference.

---

## CD. Passkeys & Credential Manager

### Overview

Passkeys replace passwords with cryptographic key pairs bound to the user's device. They use FIDO2/WebAuthn standards and are phishing-resistant by design because the private key never leaves the device and the credential is bound to the relying party origin.

### Platform APIs

| Platform | API | Min Version | Biometric Integration | Source |
|----------|-----|------------|----------------------|--------|
| Android | Credential Manager (`androidx.credentials`) | Android 4.4+ (via Play Services) | Integrated via BiometricPrompt | Android Credential Manager docs |
| iOS | `ASAuthorizationController` + `ASAuthorizationPlatformPublicKeyCredentialProvider` | iOS 16+ | Face ID / Touch ID automatic | Apple Authentication Services docs |
| Cross-device | Hybrid transport (QR + BLE) | Android 9+, iOS 16+ | On the authenticator device | FIDO Alliance spec |

### Passkey Creation Flow (Android)

```kotlin
// 1. Get challenge from server
val createRequest = CreatePublicKeyCredentialRequest(
    requestJson = """
    {
        "challenge": "${serverChallenge}",
        "rp": { "name": "My App", "id": "example.com" },
        "user": {
            "id": "${userId}",
            "name": "user@example.com",
            "displayName": "Jane Doe"
        },
        "pubKeyCredParams": [
            { "type": "public-key", "alg": -7 },
            { "type": "public-key", "alg": -257 }
        ],
        "authenticatorSelection": {
            "authenticatorAttachment": "platform",
            "residentKey": "required",
            "userVerification": "required"
        },
        "timeout": 300000
    }
    """.trimIndent()
)

// 2. Launch Credential Manager
val credentialManager = CredentialManager.create(context)
try {
    val result = credentialManager.createCredential(
        request = createRequest,
        context = activity
    )
    // 3. Send result.data to server for verification
    sendToServer((result as CreatePublicKeyCredentialResponse).registrationResponseJson)
} catch (e: CreateCredentialCancellationException) {
    // User cancelled
} catch (e: CreateCredentialException) {
    // Handle error — offer password fallback
}
```

### Passkey Sign-In Flow (Android)

```kotlin
val getRequest = GetCredentialRequest(listOf(
    GetPublicKeyCredentialOption(
        requestJson = """
        {
            "challenge": "${serverChallenge}",
            "rpId": "example.com",
            "userVerification": "required",
            "timeout": 300000
        }
        """.trimIndent()
    ),
    // Also offer password and Google Sign-In as fallbacks
    GetPasswordOption(),
    GetGoogleIdOption(serverClientId = "YOUR_SERVER_CLIENT_ID")
))

try {
    val result = credentialManager.getCredential(
        request = getRequest,
        context = activity
    )
    when (val credential = result.credential) {
        is PublicKeyCredential -> {
            sendToServer(credential.authenticationResponseJson)
        }
        is PasswordCredential -> {
            signInWithPassword(credential.id, credential.password)
        }
        is CustomCredential -> {
            if (credential.type == GoogleIdTokenCredential.TYPE_GOOGLE_ID_TOKEN_CREDENTIAL) {
                val googleId = GoogleIdTokenCredential.createFrom(credential.data)
                signInWithGoogle(googleId.idToken)
            }
        }
    }
} catch (e: GetCredentialCancellationException) {
    // User cancelled bottom sheet
} catch (e: NoCredentialException) {
    // No passkeys/passwords stored — show registration flow
}
```

### Passkey Flow (iOS)

```swift
// Passkey creation
import AuthenticationServices

class SignUpController: UIViewController, ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding {

    func createPasskey() {
        let provider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: "example.com"
        )
        let challenge = Data(serverChallenge.utf8) // From server
        let request = provider.createCredentialRegistrationRequest(
            challenge: challenge,
            name: "user@example.com",
            userID: Data(userId.utf8)
        )
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential
            as? ASAuthorizationPlatformPublicKeyCredentialRegistration else { return }
        // Send credential.rawAttestationObject to server
        sendRegistrationToServer(credential)
    }
}
```

### Migration from Passwords to Passkeys

| Phase | Action | UX Pattern | Timeline |
|-------|--------|-----------|----------|
| 1. Introduction | Offer passkey creation after successful password login | "Simplify your sign-in" banner at top of home screen | Months 1-3 |
| 2. Encouragement | Prompt passkey creation at natural moments (profile settings, security checkup) | Modal with benefits: "Sign in with your fingerprint" | Months 3-6 |
| 3. Default | Make passkey the default sign-in, password as fallback | Credential Manager bottom sheet shows passkey first | Months 6-12 |
| 4. Password-optional | Allow removing password once passkey + recovery method set | Settings > Security > "Remove password" | Month 12+ |

**FIDO Alliance UX recommendations:**
- Use the term "passkey" (lowercase), not "FIDO credential" or "WebAuthn key"
- Show the passkey icon (FIDO Alliance standard icon) next to passkey options
- Explain in one sentence: "Sign in with your fingerprint, face, or screen lock"
- Never require users to understand the cryptography; abstract it behind biometrics

### Biometric Prompt Integration

| Platform | Trigger | Customization | Source |
|----------|---------|---------------|--------|
| Android | Automatic via Credential Manager — `userVerification: "required"` | Title, subtitle via `BiometricPrompt.PromptInfo` | Android BiometricPrompt docs |
| iOS | Automatic via `ASAuthorizationController` | System dialog, non-customizable | Apple Authentication Services |
| Fallback | Device PIN/pattern if biometric fails 3 times | Platform-managed | Both platforms |

### Checklist

- [ ] Credential Manager / ASAuthorizationController used (not raw FIDO2 API)
- [ ] Both passkey and password offered in sign-in bottom sheet
- [ ] Passkey creation offered after successful password login (not forced)
- [ ] Server sends correct `challenge`, `rpId`, `userVerification` parameters
- [ ] Error handling covers cancellation, no-credential, and network failure
- [ ] "Passkey" terminology used (lowercase, no jargon)
- [ ] Cross-device sign-in supported via hybrid transport (QR code flow)
- [ ] Password fallback remains available during migration period
- [ ] Recovery method (email, phone) required alongside passkey

### Anti-Patterns

- **Forced migration**: Removing password sign-in before users have created passkeys
- **Jargon overload**: Saying "FIDO2 credential" or "public key" in user-facing text
- **Missing fallback**: No alternative when biometric fails and device has no PIN
- **Silent failure**: Credential Manager error caught but no feedback shown to user
- **Ignoring cross-device**: Only supporting same-device passkeys, breaking multi-device users

**Sources:** Android Credential Manager documentation, Apple Authentication Services (ASAuthorizationController) documentation, FIDO Alliance UX Guidelines for Passkeys (2023), WebAuthn Level 2 specification (W3C).

---

## CE. Thumb Zone Reachability

### One-Handed Reach Zones

Steven Hoober's research (2013, updated 2017) and Luke Wroblewski's analysis established three reachability zones for one-handed phone use:

| Zone | Reach Effort | Screen Position | Color Code |
|------|-------------|----------------|------------|
| Natural | Easy, no stretch | Bottom center, bottom-left (right hand) / bottom-right (left hand) | Green |
| Stretch | Requires finger extension | Middle band, opposite-side edges | Yellow |
| Hard | Requires grip shift or second hand | Top corners, far opposite edge | Red |

**Usage data (Hoober, 2013):**
- 49% of users hold phone with one hand
- 36% cradle with one hand, interact with the other
- 15% use two hands (both thumbs)

### Device Size Matrix

| Device Category | Screen Height | Natural Zone | Hard Zone Starts At |
|----------------|--------------|-------------|-------------------|
| Compact (iPhone SE, ~4.7") | ~667 pt | Bottom 40% | Top 25% |
| Standard (iPhone 15, ~6.1") | ~844 pt | Bottom 33% | Top 20% |
| Large (iPhone 15 Plus, ~6.7") | ~932 pt | Bottom 28% | Top 18% |
| Android compact (~6.0") | ~760 dp | Bottom 35% | Top 22% |
| Android standard (~6.4") | ~800 dp | Bottom 30% | Top 20% |
| Android large (~6.7"+) | ~850 dp | Bottom 25% | Top 18% |

Source: Scott Hurff "Designing Products People Love", Luke Wroblewski screen-size research.

### Bottom-Anchored Actions

Primary actions must live in the Natural zone. This is the foundational principle behind bottom navigation, bottom sheets, and FAB placement.

| Pattern | Placement | Rationale |
|---------|-----------|-----------|
| Primary CTA | Bottom 88 dp/pt bar, or inline at scroll end | Always reachable with natural thumb arc |
| Navigation | Bottom bar, 56-80 dp height | Most-used UI element in natural zone |
| Search | Bottom bar icon or pull-down header | Top-right search icon is in Hard zone on large phones |
| Contextual actions | Bottom sheet or FAB | Avoids top-right overflow menu |
| Form submit | Sticky bottom bar or keyboard accessory | Thumb can reach without grip shift |
| Destructive actions | Top area or behind confirmation | Harder to reach = harder to accidentally trigger |

```
┌──────────────────────────────────┐
│  ████  HARD ZONE  ████████████  │  <- Top bar, navigation title
│  ████████████████████████████   │
│                                  │
│  ░░░░  STRETCH ZONE  ░░░░░░░░  │  <- Content, scrollable area
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│                                  │
│  ▓▓▓▓  NATURAL ZONE  ▓▓▓▓▓▓▓  │  <- Primary actions here
│  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
│  ┌────────────────────────────┐ │
│  │  [Action 1]    [Action 2]  │ │  <- Bottom action bar
│  └────────────────────────────┘ │
└──────────────────────────────────┘
```

### Reachability Mode (iOS)

iOS provides a system-level reachability gesture (swipe down on bottom edge / double-tap Home button) that slides the top half of the screen down.

| Aspect | Detail | Source |
|--------|--------|--------|
| Trigger (Face ID devices) | Swipe down on bottom edge of screen | Apple HIG |
| Trigger (Touch ID devices) | Double-tap Home button | Apple HIG |
| Screen shift | Top half moves to mid-screen | Apple HIG |
| Auto-dismiss | After ~8 seconds of inactivity | iOS system behavior |
| Developer action | None required — system-managed | Apple HIG |
| Design implication | Do not rely on reachability; design for bottom-first | Apple HIG recommendation |

### One-Handed Mode (Android)

Android 12+ introduced a one-handed mode that shrinks the display:

| Aspect | Detail | Source |
|--------|--------|--------|
| Trigger | Swipe down on gesture bar (or Settings > One-handed mode) | Android developer docs |
| Effect | Screen shrinks to ~60% size, anchored bottom-left or bottom-right | Android 12 feature docs |
| User toggle | Settings > System > Gestures > One-handed mode | Android Settings |
| Developer action | None required — system-managed; ensure layouts scale correctly | Android docs |
| Samsung One UI | Separate "Reduce screen size" feature (long-press Home) | Samsung One UI docs |
| Timeout | Auto-restores after ~5 seconds of inactivity | System behavior |

### Floating Action Button Placement

| Guideline | Value | Source |
|-----------|-------|--------|
| Default position | Bottom-right, 16 dp margin from edges | Material Design 3 |
| Distance from bottom nav | 16 dp above BottomNavigationView | Material Design 3 |
| Size (standard) | 56 x 56 dp | Material Design 3 |
| Size (small) | 40 x 40 dp | Material Design 3 |
| Size (large) | 96 x 96 dp | Material Design 3 |
| Touch target | Minimum 48 x 48 dp (small FAB meets this) | Material Design 3 |
| Thumb reach | Bottom-right = natural zone for right-handed (75% of users) | Hoober research |

### Checklist

- [ ] Primary CTA positioned in bottom 33% of screen (natural zone)
- [ ] Navigation bar uses bottom placement, not top-only
- [ ] Search is accessible without reaching top-right corner
- [ ] Destructive actions placed in hard-to-reach zones or behind confirmation
- [ ] FAB positioned bottom-right with 16 dp margins
- [ ] Form submit buttons are sticky at bottom or in keyboard accessory
- [ ] Tested one-handed operation on largest supported device size
- [ ] No critical actions require reaching top-left or top-right corners

### Anti-Patterns

- **Top-only actions**: Placing the only "Save" or "Submit" button in the top-right nav bar
- **Hamburger-only navigation**: Forcing users to reach the top-left corner for primary nav
- **Center-top search**: Search bar at the very top of the screen with no bottom alternative
- **Ignoring handedness**: Assuming all users are right-handed (left-hand users struggle with bottom-right FAB)
- **Toolbar overload**: Putting 5+ actions in the top app bar where they require a grip shift to reach

**Sources:** Steven Hoober "How Do Users Really Hold Mobile Devices?" (UXmatters, 2013; updated 2017), Scott Hurff "Designing Products People Love" (2016), Luke Wroblewski mobile screen analysis, Material Design 3 FAB guidelines, Apple HIG Reachability documentation.

---

## CF. Scroll Performance & List Virtualization

### The Core Problem

Mobile screens display 8-15 items at a time, but lists may contain thousands. Rendering all items at once causes frame drops (jank), excessive memory use, and slow initial render. Virtualization creates and recycles only the visible items plus a small buffer.

### Android: RecyclerView (Views)

| Concept | Detail | Source |
|---------|--------|--------|
| ViewHolder pattern | Each item type has a ViewHolder; views are recycled, not re-created | Android RecyclerView docs |
| Default prefetch | Prefetches items during idle time on the UI thread | GapWorker (built-in since Support Library 25.1) |
| Prefetch count | Default: 2 items ahead of scroll direction | `LinearLayoutManager.setInitialPrefetchItemCount()` |
| Stable IDs | `setHasStableIds(true)` — enables `notifyDataSetChanged()` to animate rather than rebind all | RecyclerView.Adapter docs |
| Item animator | `DefaultItemAnimator` adds 250 ms animation per change | RecyclerView docs |
| View pool | `RecycledViewPool` shared across multiple RecyclerViews (e.g., ViewPager2 tabs) | Android developer docs |
| Max scrap | Default 5 per view type; increase for fast-scrolling lists: `setMaxRecycledViews(viewType, 20)` | RecyclerView.RecycledViewPool docs |

```kotlin
// Optimized RecyclerView setup
recyclerView.apply {
    layoutManager = LinearLayoutManager(context).apply {
        initialPrefetchItemCount = 4 // For nested horizontal lists
    }
    setHasFixedSize(true) // Skip layout pass when adapter changes
    setItemViewCacheSize(10) // Cache 10 off-screen views (default 2)
    recycledViewPool.setMaxRecycledViews(VIEW_TYPE_CARD, 15)
    itemAnimator = null // Remove animator for maximum scroll perf
}

// DiffUtil for efficient updates
class ItemDiffCallback : DiffUtil.ItemCallback<Item>() {
    override fun areItemsTheSame(old: Item, new: Item) = old.id == new.id
    override fun areContentsTheSame(old: Item, new: Item) = old == new
}
val adapter = ListAdapter(ItemDiffCallback())
```

### Android: LazyColumn / LazyRow (Compose)

| Optimization | Detail | Source |
|-------------|--------|--------|
| `key` parameter | Stable unique ID per item — enables state preservation and efficient recomposition | Compose lists docs |
| `contentType` | Differentiates item types for composition reuse (like ViewHolder types) | Compose 1.2+ |
| Avoid 0-px items | Items with no intrinsic size cause all items to be composed | Compose performance guide |
| `derivedStateOf` | For scroll-dependent UI (e.g., show/hide FAB) — prevents unnecessary recomposition | Compose state docs |
| No nested same-direction scroll | `LazyColumn` inside `Column(Modifier.verticalScroll())` throws `IllegalStateException` | Compose docs |

```kotlin
// Optimized LazyColumn
LazyColumn(
    state = rememberLazyListState(),
    contentPadding = PaddingValues(vertical = 8.dp)
) {
    items(
        items = dataList,
        key = { it.id },           // Stable key for reuse
        contentType = { it.type }  // Type-based composition reuse
    ) { item ->
        when (item.type) {
            ItemType.HEADER -> HeaderRow(item)
            ItemType.CONTENT -> ContentRow(item)
        }
    }
}

// Scroll-dependent FAB visibility without recomposition spam
val listState = rememberLazyListState()
val showFab by remember {
    derivedStateOf { listState.firstVisibleItemIndex > 0 }
}
```

### iOS: UICollectionView Compositional Layout

| Feature | Detail | Source |
|---------|--------|--------|
| Cell reuse | `dequeueReusableCell(withReuseIdentifier:for:)` — O(1) cell creation after initial | Apple UICollectionView docs |
| Prefetching | `UICollectionViewDataSourcePrefetching` — prefetch data (images, API) for upcoming cells | Apple WWDC 2016 |
| Self-sizing | `UICollectionViewCompositionalLayout` auto-sizes with `estimated()` dimensions | Apple WWDC 2019 |
| Diffable data source | `NSDiffableDataSourceSnapshot` — automatic, animated diff updates | Apple WWDC 2019 |
| Section snapshots | Hierarchical data (expandable sections) via `NSDiffableDataSourceSectionSnapshot` | iOS 14+ |
| Cell registration | `UICollectionView.CellRegistration` — type-safe, closure-based (no string identifiers) | iOS 14+ |

```swift
// Modern UICollectionView setup (iOS 14+)
var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        cell, indexPath, item in
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.subtitle
        content.image = UIImage(systemName: item.icon)
        cell.contentConfiguration = content
    }

    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
        collectionView, indexPath, item in
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
            for: indexPath, item: item)
    }
}

// Prefetching
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageLoader.prefetch(url: items[indexPath.item].imageURL)
        }
    }
}
```

### iOS: SwiftUI LazyVStack / LazyHStack

| Optimization | Detail | Source |
|-------------|--------|--------|
| Lazy instantiation | Views created only when scrolled into visible region | Apple SwiftUI docs |
| `id()` modifier | Stable identity for efficient diffing (like Compose `key`) | SwiftUI docs |
| Pinned headers | `pinnedViews: [.sectionHeaders]` in `LazyVStack` | iOS 14+ |
| `task` modifier | Async data loading triggered on appearance | iOS 15+ |
| ScrollView performance | `scrollTargetBehavior(.viewAligned)` for paging (iOS 17+) | Apple WWDC 2023 |

```swift
// Optimized SwiftUI list
ScrollView {
    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
        ForEach(sections) { section in
            Section {
                ForEach(section.items, id: \.id) { item in
                    ItemRow(item: item)
                        .task {
                            await prefetchImageIfNeeded(item)
                        }
                }
            } header: {
                SectionHeader(title: section.title)
            }
        }
    }
}
```

### Frame Budget & Jank Detection

| Metric | Target | Jank Threshold | Source |
|--------|--------|---------------|--------|
| Frame time (60 Hz) | 16.67 ms | > 16.67 ms = dropped frame | Android performance docs |
| Frame time (90 Hz) | 11.11 ms | > 11.11 ms = dropped frame | ProMotion / high refresh docs |
| Frame time (120 Hz) | 8.33 ms | > 8.33 ms = dropped frame | ProMotion / high refresh docs |
| Frozen frames | < 700 ms | > 700 ms = frozen frame (Android Vitals) | Android Vitals |
| Slow render rate | < 5% of frames | > 5% flagged in Android Vitals | Android Vitals |
| Hitch rate (iOS) | < 5 ms/s | > 5 ms/s = perceptible jank | Apple MetricKit / Instruments |

**Profiling tools:**

| Tool | Platform | What It Shows |
|------|----------|--------------|
| Android Studio Layout Inspector | Android | Recomposition counts, view hierarchy depth |
| Compose Compiler Metrics | Android | Skippable/restartable composable analysis |
| GPU Profiling (adb shell dumpsys gfxinfo) | Android | Per-frame render times |
| Xcode Instruments (Core Animation) | iOS | Offscreen rendering, blending, frame times |
| MetricKit (MXSignpostMetric) | iOS | Hitch rate in production |
| Compose `RecompositionHighlighter` | Android | Visual overlay showing recomposition frequency |

### Checklist

- [ ] All list items have stable unique keys/IDs
- [ ] `contentType` specified for multi-type lists (Compose)
- [ ] `DiffUtil` / `DiffableDataSource` used for updates (not `notifyDataSetChanged()`)
- [ ] Prefetching enabled for image-heavy lists
- [ ] No nested same-direction scrollables
- [ ] Frame time profiled under load (500+ items, fast scrolling)
- [ ] Jank rate below 5% of frames in production monitoring
- [ ] `setHasFixedSize(true)` set when RecyclerView dimensions are constant
- [ ] Item animations disabled for maximum scroll performance on long lists

### Anti-Patterns

- **`notifyDataSetChanged()`**: Rebuilds entire list, kills animations, O(n) instead of O(changes)
- **Nested scroll same direction**: `LazyColumn` inside `verticalScroll()` — crashes (Compose) or infinite height (Views)
- **Heavy `onBindViewHolder`**: Loading images synchronously, running regex, or formatting dates in bind
- **No keys**: List items without stable IDs cause unnecessary recomposition/rebinding on every update
- **Measuring in release only**: Debug builds are 5-10x slower than release; never profile in debug

**Sources:** Android RecyclerView documentation, Jetpack Compose Lists and Performance guides, Apple UICollectionView documentation, Apple WWDC sessions (2016: prefetching, 2019: compositional layout, 2023: scroll performance), Android Vitals documentation, Apple MetricKit documentation.

---

## CG. App Launch & Cold Start Performance

### Start Type Definitions

| Start Type | Definition | Process State | Android Vitals Threshold | Source |
|-----------|-----------|--------------|------------------------|--------|
| Cold start | No process exists; system creates process from scratch | Not running | >= 5 s is excessive | Android Vitals docs |
| Warm start | Process exists but activity must be recreated (`onCreate()`) | Running, activity destroyed | >= 2 s is excessive | Android Vitals docs |
| Hot start | Process + activity exist; brought to foreground | Running, activity stopped | >= 1.5 s is excessive | Android Vitals docs |

**iOS equivalents (Apple WWDC "Improving App Launch"):**

| Phase | Equivalent | Target | Source |
|-------|-----------|--------|--------|
| Pre-main (dylib loading, runtime init) | Cold start overhead | < 400 ms (recommended) | Apple WWDC 2019 (Optimizing App Launch) |
| Post-main (`application:didFinishLaunching`) | App initialization | < 200 ms | Apple WWDC 2019 |
| First frame render | TTID equivalent | < 1 s total | Apple performance guidelines |
| Full interactivity | TTFD equivalent | < 2 s total | Apple performance guidelines |

### Measuring Launch Time

**Android — Time to Initial Display (TTID):**

```bash
# ADB measurement
adb shell am start-activity -W -n com.example.app/.MainActivity
# Output: TotalTime: 534 (ms)

# Logcat
# ActivityManager: Displayed com.example.app/.MainActivity: +534ms
```

**Android — Time to Full Display (TTFD):**

```kotlin
// Signal when all async content is loaded
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Hold splash screen until data ready
        val content: View = findViewById(android.R.id.content)
        content.viewTreeObserver.addOnPreDrawListener(
            object : ViewTreeObserver.OnPreDrawListener {
                override fun onPreDraw(): Boolean {
                    return if (viewModel.isReady.value) {
                        content.viewTreeObserver.removeOnPreDrawListener(this)
                        true // Proceed with drawing
                    } else {
                        false // Keep splash screen
                    }
                }
            }
        )
    }

    private fun onAllContentLoaded() {
        reportFullyDrawn() // Logs "Fully drawn" in Logcat
    }
}
```

**iOS — Instruments measurement:**

```swift
// Xcode: Product > Profile > App Launch template
// Or use os_signpost for custom intervals:
import os.signpost

let log = OSLog(subsystem: "com.example.app", category: .pointsOfInterest)
let signpostID = OSSignpostID(log: log)

os_signpost(.begin, log: log, name: "AppLaunch", signpostID: signpostID)
// ... app initialization ...
os_signpost(.end, log: log, name: "AppLaunch", signpostID: signpostID)
```

### Android App Startup Library

Replaces multiple `ContentProvider` initializations (each adds ~2-4 ms) with a single merged provider:

```kotlin
// build.gradle
implementation("androidx.startup:startup-runtime:1.1.1")

// Initializer for WorkManager
class WorkManagerInitializer : Initializer<WorkManager> {
    override fun create(context: Context): WorkManager {
        val config = Configuration.Builder().build()
        WorkManager.initialize(context, config)
        return WorkManager.getInstance(context)
    }
    override fun dependencies(): List<Class<out Initializer<*>>> = emptyList()
}

// Declare in AndroidManifest.xml
<provider
    android:name="androidx.startup.InitializationProvider"
    android:authorities="${applicationId}.androidx-startup"
    android:exported="false"
    tools:node="merge">
    <meta-data
        android:name="com.example.WorkManagerInitializer"
        android:value="androidx.startup" />
</provider>
```

**Impact:** Apps with 5+ ContentProviders save 10-50 ms on cold start by merging into one.

### Baseline Profiles (Android)

Baseline Profiles provide AOT-compiled code paths for critical user journeys, eliminating JIT compilation stutter on first launch.

| Metric | Without Baseline Profile | With Baseline Profile | Improvement | Source |
|--------|------------------------|---------------------|-------------|--------|
| Cold start time | 100% (baseline) | 20-40% faster | 20-40% reduction | Android developer docs |
| Time to first frame | 100% | 15-30% faster | 15-30% reduction | Google I/O 2022 |
| Jank on first scroll | Present | Eliminated | 100% reduction | Android performance blog |

```kotlin
// benchmark/build.gradle.kts
dependencies {
    implementation("androidx.benchmark:benchmark-macro-junit4:1.2.0")
}

// Generate baseline profile
@RunWith(AndroidJUnit4::class)
class BaselineProfileGenerator {
    @get:Rule
    val rule = BaselineProfileRule()

    @Test
    fun generateProfile() {
        rule.collect(
            packageName = "com.example.app",
            includeInStartupProfile = true
        ) {
            // Critical user journey
            pressHome()
            startActivityAndWait()
            // Scroll main list
            device.findObject(By.res("main_list")).scroll(Direction.DOWN, 2f)
        }
    }
}
```

### iOS Launch Storyboard Optimization

| Optimization | Detail | Impact | Source |
|-------------|--------|--------|--------|
| Minimize launch storyboard complexity | Use solid color + logo only, no custom views | Saves 50-200 ms pre-main | Apple WWDC 2019 |
| Reduce dylib count | Each dynamic framework adds ~3-6 ms | Consolidate or use static linking | Apple WWDC 2019 |
| Remove +load / +initialize | ObjC class methods run before main() | Can add 100+ ms total | Apple WWDC 2016 |
| Use DYLD_PRINT_STATISTICS | `Edit Scheme > Environment Variables` | Shows pre-main breakdown | Apple developer tools |
| Static linking | Prefer static libraries over dynamic frameworks | Saves 3-6 ms per framework | Apple WWDC 2022 |

```swift
// Defer heavy initialization
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // FAST: only essential setup here
        configureAppearance()
        setupRootViewController()
        return true
        // DEFER: analytics, feature flags, non-critical SDKs
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Deferred initialization after first frame
        DispatchQueue.main.async {
            self.initializeAnalytics()
            self.fetchFeatureFlags()
            self.warmCaches()
        }
    }
}
```

### Splash Screen Timing (Android 12+)

| Attribute | Value | Source |
|-----------|-------|--------|
| Max animation duration (recommended) | 1,000 ms | Android splash screen docs |
| Max delayed start (entrance animation) | 166 ms | Android splash screen docs |
| Icon size (with background) | 240 x 240 dp; visible in 160 dp circle | Android splash screen docs |
| Icon size (no background) | 288 x 288 dp; visible in 192 dp circle | Android splash screen docs |
| Branding image size | 200 x 80 dp (bottom of splash) | Android splash screen docs |
| Exit animation | Custom via `setOnExitAnimationListener()` | Android splash screen docs |

### Checklist

- [ ] Cold start < 2 s on mid-range device (target), < 5 s (hard limit per Android Vitals)
- [ ] iOS total launch < 1 s to first frame, < 400 ms pre-main
- [ ] `reportFullyDrawn()` called when async content is loaded (Android)
- [ ] App Startup library used to merge ContentProvider initializations (Android)
- [ ] Baseline Profile generated for critical launch path (Android)
- [ ] Heavy SDK initialization deferred to after first frame
- [ ] Launch storyboard is minimal — solid color + logo only (iOS)
- [ ] Dynamic framework count minimized; static linking preferred (iOS)
- [ ] Splash screen animation under 1,000 ms (Android 12+)
- [ ] Launch time monitored in production (Firebase Performance / MetricKit)

### Anti-Patterns

- **Blocking main thread**: Network calls, database queries, or heavy computation in `onCreate()` / `application:didFinishLaunching`
- **Eager SDK init**: Initializing analytics, crash reporting, A/B testing all synchronously before first frame
- **ContentProvider bloat**: 10+ ContentProviders from third-party SDKs, each adding 2-4 ms
- **Complex splash layout**: Custom views, animations, and network calls in splash screen
- **No measurement**: Shipping without profiling launch time on low-end devices

**Sources:** Android Vitals launch time documentation, Android App Startup library docs, Android Baseline Profiles guide, Android 12+ Splash Screen API docs, Apple WWDC 2019 "Optimizing App Launch Time", Apple WWDC 2022 "Link Fast", Firebase Performance Monitoring documentation.

---

## CH. Image Loading Pipeline

### Library Landscape

| Library | Platform | Format Support | Cache Layers | Source |
|---------|----------|---------------|-------------|--------|
| Coil | Android (Kotlin-first) | JPEG, PNG, WebP, AVIF, GIF, SVG, HEIF | Memory (LRU) + Disk (OkHttp) | Coil docs (coil-kt.github.io) |
| Glide | Android (Java/Kotlin) | JPEG, PNG, WebP, GIF, HEIF | Memory (LRU) + Disk (DiskLruCache) | Glide docs (bumptech.github.io) |
| SDWebImage | iOS (Obj-C/Swift) | JPEG, PNG, WebP, AVIF, GIF, HEIF, SVG (plugin) | Memory (NSCache) + Disk (FileManager) | SDWebImage GitHub docs |
| Kingfisher | iOS (Swift) | JPEG, PNG, WebP, GIF, HEIF | Memory (NSCache) + Disk (FileManager) | Kingfisher docs |
| Compose AsyncImage | Android (Compose) | Via Coil backend | Via Coil | Coil Compose integration |

### Progressive Loading Strategy

The ideal image loading sequence provides instant visual feedback and progressively improves quality:

```
1. BlurHash placeholder (< 1 ms, ~30 bytes)    → Colored blur
2. Low-quality thumbnail (50-100 ms, ~2 KB)     → Recognizable shape
3. Full resolution (200-2000 ms, 50-500 KB)     → Final image
```

| Phase | Size | Timing | Visual |
|-------|------|--------|--------|
| BlurHash / ThumbHash | 20-30 bytes (encoded string) | Instant (decoded client-side) | Colored blur matching image palette |
| LQIP (Low Quality Image Placeholder) | 1-3 KB (JPEG q=10, 32px wide) | < 100 ms | Blurry but recognizable |
| Progressive JPEG | Streamed in passes | 200-1000 ms | Sharpens in 3-5 passes |
| Full resolution | 50-500 KB (optimized) | 200-2000 ms | Final crisp image |

```kotlin
// Android (Coil) — BlurHash placeholder + crossfade
AsyncImage(
    model = ImageRequest.Builder(LocalContext.current)
        .data(imageUrl)
        .crossfade(300)
        .placeholder(
            BlurHashDecoder.decode(item.blurHash, 32, 32)
                ?.toDrawable(resources)
        )
        .error(R.drawable.image_error)
        .build(),
    contentDescription = item.description,
    modifier = Modifier
        .fillMaxWidth()
        .aspectRatio(16f / 9f),  // Prevent layout shift
    contentScale = ContentScale.Crop
)
```

```swift
// iOS (Kingfisher) — progressive loading with blur placeholder
imageView.kf.setImage(
    with: URL(string: imageURL),
    placeholder: UIImage(blurHash: item.blurHash, size: CGSize(width: 32, height: 32)),
    options: [
        .transition(.fade(0.3)),
        .cacheOriginalImage,
        .progressiveJPEG(
            ImageProgressive(
                isBlur: true,         // Blur incomplete scans
                isFastestScan: true,  // Show first scan immediately
                scanInterval: 0       // No delay between scans
            )
        )
    ]
)
```

### Memory / Disk Cache Strategies

| Strategy | When to Use | Max Size Guideline | Source |
|----------|-----------|-------------------|--------|
| Memory cache (LRU) | All images currently/recently visible | 15-25% of available heap (default in Coil/Glide) | Library defaults |
| Disk cache | Persistent across sessions | 150-250 MB default; configurable | Coil: 250 MB, Glide: 250 MB |
| No cache | Sensitive images (banking, health) | 0 | Security best practice |
| Cache-only (offline) | Airplane mode fallback | Use disk cache as source of truth | Offline-first pattern |
| Short TTL | User avatars, frequently updated content | 1-24 hours disk, session for memory | App-specific |

```kotlin
// Android (Coil) — custom cache policy
val imageLoader = ImageLoader.Builder(context)
    .memoryCache {
        MemoryCache.Builder(context)
            .maxSizePercent(0.20)  // 20% of available heap
            .build()
    }
    .diskCache {
        DiskCache.Builder()
            .directory(context.cacheDir.resolve("image_cache"))
            .maxSizeBytes(200L * 1024 * 1024) // 200 MB
            .build()
    }
    .respectCacheHeaders(true) // Honor HTTP Cache-Control
    .build()
```

### Image Sizing Rules

Serving images at the correct resolution prevents wasted bandwidth and memory:

| Device Density | Scale Factor | Image for 200 dp/pt view | Source |
|---------------|-------------|--------------------------|--------|
| mdpi / @1x | 1.0x | 200 px | Android density docs / Apple HIG |
| hdpi | 1.5x | 300 px | Android density docs |
| xhdpi / @2x | 2.0x | 400 px | Android density docs / Apple HIG |
| xxhdpi / @3x | 3.0x | 600 px | Android density docs / Apple HIG |
| xxxhdpi | 4.0x | 800 px | Android density docs |

**Server-side sizing (recommended):** Request images at the exact pixel dimensions needed:

```kotlin
// URL-based resizing (common CDN pattern)
val density = resources.displayMetrics.density
val widthPx = (viewWidthDp * density).toInt()
val heightPx = (viewHeightDp * density).toInt()
val url = "https://cdn.example.com/image/${id}?w=${widthPx}&h=${heightPx}&q=80"
```

**Client-side downsampling:**

```kotlin
// Coil — downsample to view size
AsyncImage(
    model = ImageRequest.Builder(LocalContext.current)
        .data(imageUrl)
        .size(Size.ORIGINAL)  // Or specify exact: .size(400, 300)
        .scale(Scale.FILL)
        .build(),
    // ...
)

// Glide — explicit override
Glide.with(context)
    .load(imageUrl)
    .override(widthPx, heightPx)
    .into(imageView)
```

### WebP / AVIF Support

| Format | Android Support | iOS Support | Size vs JPEG | Quality | Source |
|--------|---------------|-------------|-------------|---------|--------|
| WebP (lossy) | Android 4.0+ | iOS 14+ | 25-35% smaller | Equivalent | Google WebP docs |
| WebP (lossless) | Android 4.0+ | iOS 14+ | 26% smaller than PNG | Lossless | Google WebP docs |
| AVIF | Android 12+ (API 31) | iOS 16+ | 30-50% smaller than JPEG | Superior | AOM / web.dev |
| HEIF/HEIC | Android 10+ (decode) | iOS 11+ (native) | 40-50% smaller than JPEG | Superior | Platform docs |

**Format selection strategy:**

```
if (device supports AVIF && server can encode)  → AVIF
else if (device supports WebP)                   → WebP
else                                             → JPEG (quality 80-85)
```

### Preventing Layout Shift

Always reserve space for images before they load:

```kotlin
// Compose — aspect ratio placeholder
AsyncImage(
    model = imageUrl,
    contentDescription = null,
    modifier = Modifier
        .fillMaxWidth()
        .aspectRatio(item.width.toFloat() / item.height.toFloat()),  // Server provides dimensions
    contentScale = ContentScale.Crop
)
```

```swift
// SwiftUI — aspect ratio placeholder
AsyncImage(url: URL(string: imageURL)) { phase in
    switch phase {
    case .empty:
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .aspectRatio(item.aspectRatio, contentMode: .fit)
    case .success(let image):
        image.resizable().aspectRatio(contentMode: .fill)
    case .failure:
        Image(systemName: "photo").foregroundColor(.gray)
    @unknown default:
        EmptyView()
    }
}
.frame(maxWidth: .infinity)
.aspectRatio(item.aspectRatio, contentMode: .fit)
```

### Checklist

- [ ] BlurHash or ThumbHash placeholder for all remote images
- [ ] Crossfade transition (200-300 ms) on image load
- [ ] Aspect ratio set to prevent layout shift before image loads
- [ ] Images requested at correct pixel dimensions for device density
- [ ] WebP served as default format (AVIF where supported)
- [ ] Memory cache limited to 15-25% of heap
- [ ] Disk cache limited to 150-250 MB with LRU eviction
- [ ] Error state image/icon shown on load failure
- [ ] Sensitive images bypass cache (no-store)
- [ ] Image list uses prefetching (UICollectionViewDataSourcePrefetching / Coil prefetch)

### Anti-Patterns

- **Full-resolution load**: Loading a 4000x3000 px image into a 200x150 dp thumbnail
- **No placeholder**: Blank white/black space while image loads, causing perceived slowness
- **Layout shift**: Image loads and pushes content down because no space was reserved
- **Cache everything**: Caching sensitive medical or financial images to disk
- **JPEG for everything**: Not using WebP/AVIF when platform supports them (25-50% bandwidth waste)
- **Synchronous decode**: Decoding large images on the main thread, causing frame drops

**Sources:** Coil documentation (coil-kt.github.io), Glide documentation (bumptech.github.io), Kingfisher documentation, SDWebImage documentation, Android image loading best practices, web.dev image optimization guide, Apple WWDC 2018 "Image and Graphics Best Practices".

---

## CI. Cross-Platform Framework Pitfalls

### Framework Overview

| Framework | Language | Rendering | Native Access | Market Share (2024) | Source |
|-----------|---------|-----------|--------------|-------------------|--------|
| Flutter | Dart | Custom (Skia/Impeller) | Platform channels | ~13% of cross-platform apps | Statista, JetBrains survey |
| React Native | JavaScript/TypeScript | Native components (via bridge/JSI) | Native modules / TurboModules | ~38% of cross-platform apps | Statista, JetBrains survey |
| Kotlin Multiplatform (KMP) | Kotlin | Native per-platform (Compose Multiplatform or SwiftUI) | Direct Kotlin/Swift interop | Growing (~5% in 2024) | JetBrains survey |
| Capacitor/Ionic | HTML/CSS/JS | WebView | Capacitor plugins | ~8% of cross-platform apps | Statista |

### Platform-Specific UX Expectations

Users expect apps to behave like native apps on their platform. Cross-platform frameworks must accommodate these differences:

| UX Element | iOS Expectation | Android Expectation | Common Pitfall |
|-----------|----------------|--------------------|--------------------|
| Back navigation | Swipe from left edge, no system back button | System back button/gesture (predictive back) | Flutter/RN override system back, breaking predictive back |
| Scroll physics | Bouncing overscroll (elastic) | Glow/stretch overscroll (Android 12+) | Flutter uses same physics on both; must customize |
| Page transitions | Slide from right (push), slide left (pop) | Fade through or shared axis (M3 motion) | React Native Navigator uses iOS transitions on Android |
| Tab bar position | Bottom (UITabBarController) | Bottom (Material) or top (TabLayout) | Forcing iOS-style tabs on Android or vice versa |
| Typography | SF Pro, Dynamic Type | Roboto, Material type scale | Using system-agnostic font, missing platform type features |
| Dialogs | Center, rounded, "Cancel" left / "OK" right | Center, Material shape, actions right-aligned | Using identical dialog style on both platforms |
| Pull-to-refresh | UIRefreshControl (spinner at top) | SwipeRefreshLayout (circular spinner) | Custom refresh that matches neither platform |
| Haptics | Taptic Engine (UIFeedbackGenerator) | Vibration API (limited variety) | No haptics, or iOS-quality haptics expected on all Android |

### Navigation Differences

| Pattern | iOS Native | Android Native | Cross-Platform Issue |
|---------|-----------|---------------|---------------------|
| Stack navigation | UINavigationController (push/pop) | Fragment/NavController (navigate/popBackStack) | React Navigation / GoRouter may not support predictive back |
| Tab switching | UITabBarController (state preserved per tab) | BottomNavigationView (Fragment re-creation or hide/show) | Flutter: tabs may lose scroll position on switch |
| Modal presentation | `.sheet()` / `present()` with drag-to-dismiss | BottomSheetDialogFragment or Dialog | Flutter BottomSheet doesn't support native pull-to-dismiss on iOS |
| Deep linking | Universal Links + `ASWebAuthenticationSession` | App Links + Intent filters | Cross-platform routers often miss platform-specific edge cases |

### Gesture Handling Gaps

| Gesture | iOS Native | Android Native | Framework Gap |
|---------|-----------|---------------|---------------|
| Edge swipe back | `UINavigationController` built-in | System gesture (20 dp zone) | Flutter `WillPopScope` blocks iOS swipe-back |
| Long press | `UILongPressGestureRecognizer` (500 ms default) | `onLongClick` (500 ms default) | RN `Pressable` long press may conflict with scroll |
| Drag and drop | `UIDragInteraction` / `UIDropInteraction` | `View.startDragAndDrop()` | Limited/no support in Flutter, partial in RN |
| Pinch-to-zoom | `UIPinchGestureRecognizer` | `ScaleGestureDetector` | Custom implementations often miss inertia/momentum |

### Accessibility Gaps

| Feature | iOS Native | Android Native | Cross-Platform Status |
|---------|-----------|---------------|-----------------------|
| Screen reader | VoiceOver | TalkBack | Flutter: `Semantics` widget (good). RN: `accessible` prop (partial) |
| Dynamic Type / font scaling | Full support via `UIFontMetrics` | Full support via `sp` units | Flutter: `MediaQuery.textScaleFactor`. RN: `PixelRatio.getFontScale()` |
| Reduce Motion | `UIAccessibility.isReduceMotionEnabled` | `Settings.Global.ANIMATOR_DURATION_SCALE` | Must check platform-specific API; not abstracted |
| Focus order | Automatic based on layout | Automatic + `accessibilityTraversalBefore/After` | Flutter: `FocusTraversalOrder`. RN: manual `accessibilityOrder` |
| Switch Control / Switch Access | Full support | Full support | Often broken — custom widgets may not expose correct roles |
| Live regions | `UIAccessibility.post(.announcement)` | `accessibilityLiveRegion` | Flutter: `Semantics(liveRegion:)`. RN: `accessibilityLiveRegion` |

### When Native Beats Cross-Platform

| Scenario | Why Native Wins | Source |
|----------|----------------|--------|
| Heavy animations (60+ fps, complex transitions) | No bridge overhead, direct GPU access | Flutter Impeller narrows this gap |
| Camera/AR/ML (real-time processing) | Direct sensor API access, lower latency | ARKit/ARCore native SDKs |
| Platform-latest APIs (Day-1 iOS/Android features) | No wait for framework support (weeks to months lag) | Historical pattern |
| Accessibility-critical apps | Full semantics tree, native screen reader behavior | NNGroup accessibility research |
| App size budget < 10 MB | Flutter adds ~5-8 MB, RN adds ~7-12 MB to baseline | Framework overhead measurements |
| OS integration (widgets, extensions, Siri/Assistant) | Requires native code regardless | Platform extension APIs |

### Checklist

- [ ] Scroll physics match platform (bouncing on iOS, stretch on Android)
- [ ] Page transitions follow platform conventions (slide on iOS, fade-through on Android)
- [ ] System back gesture works correctly on Android (predictive back compatible)
- [ ] iOS swipe-to-go-back gesture not blocked by custom gesture handlers
- [ ] Typography uses platform system font or matches platform type scale
- [ ] Dialog button order follows platform convention
- [ ] Screen reader (VoiceOver/TalkBack) tested on both platforms
- [ ] Dynamic Type / font scaling tested at 200% on both platforms
- [ ] Platform-specific haptic feedback implemented
- [ ] Deep linking tested with platform-specific URL schemes

### Anti-Patterns

- **"Write once, test once"**: Shipping without testing on both platforms — UI looks different, gestures behave differently
- **iOS-first design on Android**: Using iOS-style back arrows, bottom sheets, and navigation on Android
- **Ignoring platform font**: Using a custom font everywhere, breaking Dynamic Type on iOS and `sp` scaling on Android
- **Bridging everything**: Using platform channels for operations the framework already handles natively
- **Same animations everywhere**: Using identical transition curves on both platforms, feeling "off" on each

**Sources:** Flutter platform-specific documentation (flutter.dev/platform-integration), React Native Accessibility docs, Kotlin Multiplatform documentation (kotlinlang.org), Apple Human Interface Guidelines platform differences, Material Design 3 cross-platform guidance, NNGroup "Mobile UX" research.

---

## CJ. visionOS & Spatial Computing UX

### Input Model

visionOS uses indirect interaction as the primary input: the user looks at a target (eye tracking) and taps their fingers together (hand gesture) to select. This fundamentally changes UI design from touch-based mobile.

| Input Method | Action | Equivalent on Mobile | Source |
|-------------|--------|---------------------|--------|
| Look + tap (pinch) | Select / activate | Tap | Apple visionOS HIG |
| Look + pinch and drag | Scroll, move, resize | Scroll, drag | Apple visionOS HIG |
| Look + double tap | Zoom / expand | Double tap | Apple visionOS HIG |
| Look + long pinch | Context menu / secondary action | Long press | Apple visionOS HIG |
| Direct touch (near field) | Touch virtual objects in reach | Tap | Apple visionOS HIG |
| Eyes only (dwell) | Hover effect; never use as sole input | Hover on desktop | Apple visionOS HIG |

**Critical rule:** Eye position alone must never trigger an action — only the physical hand gesture confirms intent. This prevents the "Midas touch" problem where everything you look at activates.

### Spatial Layout Fundamentals

| Guideline | Value | Source |
|-----------|-------|--------|
| Default window distance from user | 1.5 meters (arm's length) | Apple visionOS HIG |
| Comfortable depth range | 0.5 m to 3.0 m | Apple spatial design WWDC 2023 |
| Window width (standard) | 1280 pt default, resizable | Apple visionOS HIG |
| Minimum text size | 17 pt (at 1.5 m distance) | Apple visionOS HIG |
| Recommended body text | 22 pt minimum for comfortable reading | Apple WWDC 2023 spatial design |
| Tap target minimum | 60 x 60 pt (larger than mobile due to eye tracking precision) | Apple visionOS HIG |
| Spacing between targets | 16 pt minimum to prevent selection ambiguity | Apple visionOS HIG |
| Maximum simultaneous windows | System-managed, typically 3-5 comfortably | Apple visionOS guidelines |
| Z-depth separation between layers | 4-20 pt for subtle depth, 40+ pt for distinct separation | Apple spatial design sessions |

### Content Hierarchy

| Container | Description | Use Case |
|-----------|------------|----------|
| Window | 2D SwiftUI content in a glass panel | Standard app interface, lists, forms |
| Volume | 3D bounded content visible from all angles | 3D model viewer, globe, game board |
| Full Space | Immersive 3D environment, app has exclusive scene control | AR/VR experiences, room-scale apps |
| Ornament | Floating toolbar attached to window edge | Controls, toolbars, media playback |
| Pop-up | Floating panel near parent element | Popovers, context menus |

```swift
// visionOS — Window with Ornament
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            Sidebar()
        } detail: {
            DetailView()
        }
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.bottom)
        ) {
            HStack(spacing: 12) {
                Button(action: { /* play */ }) {
                    Label("Play", systemImage: "play.fill")
                }
                Button(action: { /* pause */ }) {
                    Label("Pause", systemImage: "pause.fill")
                }
            }
            .padding(12)
            .glassBackgroundEffect()  // Frosted glass material
        }
    }
}
```

### Hover Effects (Essential for Eye Tracking)

Because eye tracking replaces cursor movement, every interactive element must provide a visible hover effect so users know what they are targeting before they pinch.

| Element | Hover Effect | Source |
|---------|-------------|--------|
| Buttons | Subtle highlight / lift (1-2 pt Z offset) | Apple visionOS HIG |
| List rows | Background highlight with rounded corners | Apple visionOS HIG |
| Custom interactive views | Must implement `.hoverEffect()` modifier | Apple visionOS docs |
| Non-interactive content | No hover effect (critical distinction) | Apple visionOS HIG |

```swift
// Apply hover effect to custom interactive view
Button(action: { selectItem() }) {
    ItemCard(item: item)
}
.buttonStyle(.plain)
.hoverEffect(.highlight) // System hover effect
// Options: .automatic, .highlight, .lift
```

### Vergence-Accommodation Conflict

The vergence-accommodation conflict is a key comfort concern: the user's eyes focus at a fixed display distance (accommodation) but converge to match virtual object depth (vergence). Mismatches cause discomfort.

| Guideline | Rule | Source |
|-----------|------|--------|
| Content depth range | Keep primary content between 0.5 m and 3.0 m | Apple WWDC 2023 |
| Avoid extreme near-field | No content closer than 0.3 m (causes eye strain) | Apple spatial comfort guidelines |
| Avoid extreme far-field | No content beyond 5 m (becomes hard to read) | Apple spatial comfort guidelines |
| Depth transitions | Animate smoothly over 200-400 ms, no instant jumps | Apple motion guidelines |
| Text depth | Keep all text at consistent depth (avoid text at varying Z) | Apple typography in visionOS |
| Head-locked content | Never — causes motion sickness. Anchor to world or window. | Apple visionOS HIG |

### Text Legibility in 3D

| Parameter | Value | Source |
|-----------|-------|--------|
| Minimum font size | 17 pt at standard 1.5 m distance | Apple visionOS HIG |
| Recommended body font | 22 pt for comfortable reading | Apple WWDC 2023 |
| Font weight | Medium weight minimum (Regular can be too thin in spatial context) | Apple visionOS typography |
| Line height | 1.4-1.6x (more generous than mobile) | Apple spatial typography guidelines |
| Contrast on glass material | System vibrancy materials provide sufficient contrast | Apple visionOS materials |
| Background for text | Use `.glassBackgroundEffect()` — never place text floating in space without backing | Apple visionOS HIG |
| Text max width | ~700 pt (similar to readable content guide on iPad) | Apple typography guidelines |

### Checklist

- [ ] All interactive elements have visible hover effects
- [ ] Tap targets minimum 60 x 60 pt
- [ ] No actions triggered by eye gaze alone (always require physical gesture)
- [ ] Primary content placed at 0.5-3.0 m depth range
- [ ] No content closer than 0.3 m from user
- [ ] Text minimum 17 pt, recommended 22 pt at standard distance
- [ ] All text has a glass or solid background — never floats in empty space
- [ ] Depth transitions animated over 200-400 ms (no instant jumps)
- [ ] No head-locked content (all content world-anchored or window-anchored)
- [ ] Ornaments used for persistent controls instead of overlaid buttons

### Anti-Patterns

- **Flat mobile port**: Directly porting a 2D mobile layout to a window without spatial design considerations
- **Head-locked HUD**: Attaching UI to the user's head position — causes immediate motion sickness
- **Tiny targets**: Using mobile-sized 44 pt targets — too small for eye tracking precision
- **Invisible interactivity**: No hover effect on interactive elements — users cannot tell what is tappable
- **Depth abuse**: Placing UI elements at wildly different Z depths, causing vergence-accommodation discomfort
- **Text in space**: Floating text without glass backing — poor contrast against any background

**Sources:** Apple visionOS Human Interface Guidelines, Apple WWDC 2023 "Principles of Spatial Design", Apple WWDC 2023 "Design for Spatial Input", Apple WWDC 2024 "Design Great visionOS Apps", Apple visionOS developer documentation.

---

## CK. Samsung One UI Guidelines

### Design Philosophy

Samsung One UI (version 6.x / 7.0 as of 2025) is built on a "Focus Block" layout: the top ~40% of the screen is reserved for contextual information (title, description) and the bottom ~60% contains interactive elements. This aligns with thumb zone reachability research (see section CE).

| Principle | Implementation | Source |
|-----------|---------------|--------|
| Focus Block | Top: large title + description. Bottom: actionable content | Samsung One UI design guidelines |
| One-handed operation | All primary actions within thumb reach | Samsung developer docs |
| Consistent headers | Large header area scrolls away, sticky compact header appears | One UI component docs |
| Reduced visual complexity | Generous whitespace, simplified iconography | Samsung design language |

### Samsung-Specific Components

| Component | Description | Usage | Source |
|-----------|------------|-------|--------|
| Edge Panel | Slide-in panel from screen edge (right side, configurable) | Quick actions, favorite apps, clipboard | Samsung Edge Panel SDK |
| Flex Mode | Foldable split layout when Galaxy Z Fold/Flip is partially folded (75-115 degrees) | Video calls on top, controls on bottom | Samsung Flex Mode docs |
| S Pen integration | Hover detection (Air Actions), pressure sensitivity (4096 levels on Note/Ultra) | Drawing, precise selection, Air Command | Samsung S Pen SDK |
| Multi-window | Split-screen and pop-up window support | Side-by-side multitasking | Samsung Multi-Window API |
| DeX mode | Desktop-like interface when connected to external display | Full windowed mode, keyboard/mouse input | Samsung DeX developer docs |
| Routine triggers | App actions triggered by Samsung Routines (Bixby Routines successor) | Automation hooks (location, time, Bluetooth) | Samsung Routines API |

### Flex Mode for Foldables

When a Galaxy Z Flip or Fold is in a partially folded posture (between 75 and 115 degrees), the screen splits into two logical halves:

| Zone | Position | Usage | Source |
|------|----------|-------|--------|
| Flex top panel | Upper half of fold | Content viewing: video, camera preview, maps | Samsung Flex Mode guide |
| Flex bottom panel | Lower half of fold | Controls: playback controls, shutter button, comments | Samsung Flex Mode guide |
| Hinge area | Center fold line | 24 dp avoidance zone (content may distort at hinge) | Samsung developer docs |

```kotlin
// Detect Flex Mode on Samsung foldables
import androidx.window.layout.WindowInfoTracker
import androidx.window.layout.FoldingFeature

class FlexModeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        lifecycleScope.launch {
            WindowInfoTracker.getOrCreate(this@FlexModeActivity)
                .windowLayoutInfo(this@FlexModeActivity)
                .collect { layoutInfo ->
                    val foldingFeature = layoutInfo.displayFeatures
                        .filterIsInstance<FoldingFeature>()
                        .firstOrNull()

                    when {
                        foldingFeature?.state == FoldingFeature.State.HALF_OPENED &&
                        foldingFeature.orientation == FoldingFeature.Orientation.HORIZONTAL -> {
                            // Flex Mode: top half = content, bottom half = controls
                            enableFlexLayout(foldingFeature.bounds)
                        }
                        foldingFeature?.state == FoldingFeature.State.FLAT -> {
                            // Fully open: normal layout
                            enableFullLayout()
                        }
                        else -> enableCompactLayout()
                    }
                }
        }
    }

    private fun enableFlexLayout(hingeBounds: Rect) {
        // Place video/content above hinge
        // Place controls below hinge
        // Avoid placing interactive elements within 24dp of hinge center
        val hingeCenter = hingeBounds.centerY()
        topPanel.layoutParams.height = hingeCenter - 12.dpToPx() // 12dp padding from hinge
        bottomPanel.layoutParams.height = screenHeight - hingeCenter - 12.dpToPx()
    }
}
```

### Edge Panel Integration

| Property | Value | Source |
|----------|-------|--------|
| Panel width | 60-90 dp (user-configurable) | Samsung Edge Panel docs |
| Trigger zone | Right edge (default), configurable position | Samsung Settings > Display |
| Max items | 10-12 in a single panel page | Samsung Edge Panel SDK |
| Icon size | 48 x 48 dp | Samsung Edge Panel design specs |
| Custom panel | Apps can provide a custom Edge Panel via `EdgePanelProvider` | Samsung Edge Panel SDK |

### S Pen Integration

| Feature | API | Min SDK | Source |
|---------|-----|---------|--------|
| Hover detection (Air View) | `View.onHoverEvent()` or `Modifier.hoverable()` | Android standard | Android developer docs |
| Pressure sensitivity | `MotionEvent.getPressure()` — 0.0 to 1.0 (4096 levels on supported devices) | API 1+ | Android MotionEvent docs |
| Button press (side button) | `MotionEvent.getButtonState() == BUTTON_STYLUS_PRIMARY` | API 14+ | Android MotionEvent docs |
| Air Command (S Pen menu) | Register app shortcuts in Samsung Air Command | Samsung S Pen SDK | Samsung developer docs |
| Palm rejection | Automatic when `MotionEvent.getToolType() == TOOL_TYPE_STYLUS` | API 14+ | Android docs |

### DeX Desktop Mode

When connected to an external display (or via Samsung DeX wireless), apps run in resizable windows with keyboard and mouse input:

| Adaptation | Implementation | Source |
|-----------|---------------|--------|
| Resizable window | Declare `android:resizeableActivity="true"` + handle `onConfigurationChanged` | Samsung DeX developer guide |
| Minimum window size | `android:minWidth="480dp"` `android:minHeight="320dp"` | Samsung DeX docs |
| Keyboard shortcuts | Implement `onKeyDown()` / `onKeyUp()` for common shortcuts (Ctrl+S, Ctrl+Z) | Android KeyEvent docs |
| Right-click context menu | Handle `MotionEvent.BUTTON_SECONDARY` for right-click | Android MotionEvent docs |
| Mouse hover | `View.onHoverEvent()` for desktop-style hover states | Android standard |
| Multi-window | Support drag-and-drop between windows via `View.startDragAndDrop()` | Android Drag and Drop docs |

### Checklist

- [ ] Primary actions in bottom 60% of screen (One UI Focus Block principle)
- [ ] Flex Mode detected and layout adapted on foldable devices
- [ ] 24 dp avoidance zone around hinge center in Flex Mode
- [ ] `resizeableActivity="true"` for DeX compatibility
- [ ] Keyboard shortcuts implemented for common actions (DeX)
- [ ] Right-click context menu supported for mouse input (DeX)
- [ ] S Pen hover effects implemented for stylus-capable devices
- [ ] Edge Panel custom shortcuts provided if app has quick actions
- [ ] Tested on Galaxy Z Flip (clamshell Flex), Z Fold (book Flex), and DeX mode

### Anti-Patterns

- **Ignoring Flex Mode**: Not adapting layout when foldable is half-opened — content is hidden at the hinge
- **Hinge collision**: Placing buttons or text directly on the hinge line where they are invisible/distorted
- **DeX as afterthought**: App crashes or shows phone layout on a 27" external display
- **No keyboard support**: DeX users with keyboard cannot use Ctrl+C/V or Tab navigation
- **Blocking multi-window**: Setting `resizeableActivity="false"` — breaks split-screen and DeX

**Sources:** Samsung One UI Design Guidelines (developer.samsung.com/one-ui), Samsung Flex Mode documentation, Samsung DeX Developer Guide, Samsung S Pen SDK documentation, Samsung Edge Panel SDK, AndroidX Window Manager library documentation.

---

## CL. Data Visualization on Mobile

### Chart Types for Small Screens

Mobile screens (320-430 dp wide) impose severe constraints on data visualization. Choose chart types that communicate clearly in limited space.

| Chart Type | Min Width Needed | Max Data Points (Mobile) | Best For | Avoid When |
|-----------|-----------------|------------------------|----------|------------|
| Line chart | 200 dp | 30-50 points | Trends over time | Few data points (<5) |
| Bar chart (vertical) | 200 dp | 6-8 bars visible | Category comparison | >12 categories (use horizontal) |
| Bar chart (horizontal) | 280 dp | 8-12 bars visible | Long labels, ranked data | <3 categories |
| Sparkline | 60-120 dp | 20-50 points | Inline trend indicator | Precise values needed |
| Donut/Pie chart | 160 dp diameter | 4-6 segments max | Part-of-whole (simple) | >6 segments (use bar chart) |
| Scatter plot | 280 dp | 50-200 points | Correlation | Exact value reading |
| Area chart (stacked) | 200 dp | 3-4 series max | Composition over time | >4 series (unreadable) |
| Gauge / radial | 120 dp | 1 value | Single KPI (e.g., progress) | Multiple values |
| Heat map | Full width | Grid-dependent | Dense time/category data | Color-blind users without labels |

Source: NNGroup "Data Visualization on Mobile" (2021), Edward Tufte "The Visual Display of Quantitative Information" adapted for mobile.

### Touch Interactions

| Interaction | Gesture | Implementation | Min Target |
|------------|---------|----------------|------------|
| Select data point | Tap | Tooltip/popover appears near tap point | 44 pt / 48 dp hit area around point |
| Pan (horizontal) | Horizontal drag | Shifts visible range, preserves Y axis | Entire chart area |
| Zoom (horizontal) | Pinch horizontal | Changes time range / granularity | Two-finger gesture zone |
| Zoom (vertical) | Pinch vertical | Changes value range (less common) | Two-finger gesture zone |
| Scrub / crosshair | Long press + drag | Moves a vertical line across chart, live tooltip follows | Chart area |
| Reset zoom | Double tap | Returns to default range | Entire chart area |

**Tooltip positioning rules:**

```
┌──────────────────────────────────┐
│   ┌─────────────────────────┐    │
│   │     LINE CHART          │    │
│   │         *───────────    │    │
│   │    ┌──────────┐         │    │
│   │    │ Mar 15    │←tooltip │    │  <- Tooltip above point
│   │    │ 2,340 steps│        │    │     if point in bottom half
│   │    └──────────┘         │    │     below point if top half
│   │  *                      │    │
│   │*────                    │    │
│   └─────────────────────────┘    │
│   Jan    Feb    Mar    Apr       │
└──────────────────────────────────┘
```

- Tooltip width: max 50% of chart width
- Tooltip offset from data point: 8-12 dp/pt
- Auto-flip: if tooltip would overflow screen edge, flip to opposite side
- Show only on interaction (tap/scrub), not permanently

### Responsive Chart Sizing

| Screen Width | Chart Height | Aspect Ratio | Source |
|-------------|-------------|-------------|--------|
| < 360 dp (compact) | 180-200 dp | ~2:1 | NNGroup mobile data viz |
| 360-430 dp (standard phone) | 200-240 dp | ~1.8:1 | NNGroup mobile data viz |
| 430-600 dp (large phone/small tablet) | 240-320 dp | ~1.5:1 | NNGroup mobile data viz |
| 600+ dp (tablet) | 320-400 dp | ~1.3:1 | NNGroup mobile data viz |

**Rules:**
- Chart minimum height: 160 dp (below this, trends are indistinguishable)
- Chart should never exceed 50% of viewport height (user needs to see surrounding context)
- Labels: 10-12 sp minimum, 14 sp recommended on mobile
- Axis tick count: 4-6 horizontal, 3-5 vertical (auto-select nice round numbers)

### Color-Blind Safe Palettes

8% of males and 0.5% of females have color vision deficiency. Charts must remain legible without relying solely on hue.

| Palette Type | Colors | Hex Values | Use Case |
|-------------|--------|-----------|----------|
| Sequential (single hue) | 5 steps | #f7fbff, #c6dbef, #6baed6, #2171b5, #084594 | Ordered data, heat maps |
| Diverging (blue-red safe) | 5 steps | #0571b0, #92c5de, #f7f7f7, #f4a582, #ca0020 | Deviation from center |
| Categorical (ColorBrewer safe) | 8 colors | #1b9e77, #d95f02, #7570b3, #e7298a, #66a61e, #e6ab02, #a6761d, #666666 | Distinct categories |
| Monochrome + pattern | Unlimited | Single hue + stripes, dots, hatching | Maximum accessibility |

**Supplementary encoding (always use at least one alongside color):**

| Encoding | Example | Implementation |
|----------|---------|---------------|
| Shape | Circle vs square vs triangle data points | MPAndroidChart: `setShape()` |
| Pattern | Striped vs solid vs dotted bar fills | iOS Charts: custom renderer |
| Label | Direct data labels on bars/segments | Preferred for < 8 categories |
| Thickness | Thin vs thick lines for different series | Line chart series differentiation |
| Position | Grouped bars side-by-side | Instead of color-only stacked bars |

### Annotation Patterns

| Pattern | Use Case | Implementation |
|---------|----------|---------------|
| Reference line | Target/goal, average, threshold | Dashed horizontal line with label |
| Highlight band | Date range, acceptable zone | Semi-transparent vertical/horizontal band |
| Point annotation | Notable event (launch, outage) | Marker + label on specific data point |
| Trend line | Linear regression, moving average | Overlaid dashed line, lighter color |
| Callout | Key insight summary | Text box with leader line to data |

### Sparklines

Compact inline charts (no axes, no labels) embedded in text or table cells:

| Guideline | Value | Source |
|-----------|-------|--------|
| Height | 16-32 dp/pt (inline with text) | Tufte, adapted |
| Width | 60-120 dp/pt | Context-dependent |
| Min/max indicators | Optional dot at highest and lowest point | Common pattern |
| Color | Single color, match text or accent | Tufte — minimize ink |
| Interaction | Tap to expand to full chart | Mobile adaptation |

```kotlin
// Android — minimal sparkline in Compose Canvas
@Composable
fun Sparkline(
    data: List<Float>,
    modifier: Modifier = Modifier
        .height(24.dp)
        .width(80.dp),
    color: Color = MaterialTheme.colorScheme.primary
) {
    Canvas(modifier = modifier) {
        if (data.size < 2) return@Canvas
        val max = data.max()
        val min = data.min()
        val range = (max - min).coerceAtLeast(1f)
        val stepX = size.width / (data.size - 1)
        val path = Path().apply {
            data.forEachIndexed { i, value ->
                val x = i * stepX
                val y = size.height - ((value - min) / range) * size.height
                if (i == 0) moveTo(x, y) else lineTo(x, y)
            }
        }
        drawPath(path, color, style = Stroke(width = 2.dp.toPx(), cap = StrokeCap.Round))
    }
}
```

### Checklist

- [ ] Chart type appropriate for data (line for trends, bar for comparison, sparkline for inline)
- [ ] Touch target >= 44 pt / 48 dp around data points
- [ ] Tooltip appears on tap/scrub, auto-positions to avoid screen edges
- [ ] Chart height >= 160 dp, aspect ratio between 1.3:1 and 2:1
- [ ] Axis labels 10-12 sp minimum, 4-6 ticks per axis
- [ ] Color palette is color-blind safe (tested with simulator)
- [ ] At least one supplementary encoding (shape, pattern, label) alongside color
- [ ] Pinch-to-zoom and pan implemented for time-series charts
- [ ] Double-tap resets zoom to default range
- [ ] Sparklines used for inline trend indication in tables/lists

### Anti-Patterns

- **3D charts on mobile**: 3D pie charts, 3D bar charts — distort data perception and waste pixels
- **Rainbow palette**: Using all hues of the rainbow for categories — indistinguishable for color-blind users
- **Axis label overflow**: Rotated 90-degree text on X axis that is unreadable at 10 sp
- **Permanent tooltip**: Always-visible tooltip that occludes chart data
- **Desktop chart on mobile**: Porting a 1200 px wide desktop chart to a 360 dp phone without adaptation
- **Too many series**: 6+ line series on a single mobile chart — unreadable spaghetti

**Sources:** NNGroup "Data Visualization for Mobile" (2021), Edward Tufte "The Visual Display of Quantitative Information", ColorBrewer 2.0 (colorbrewer2.org), MPAndroidChart documentation, iOS Charts (danielgindi/Charts) documentation, Vico chart library documentation.

---

## CM. App Size Budget

### Platform Size Limits

| Platform | Limit | Context | Source |
|----------|-------|---------|--------|
| App Store (iOS) | 200 MB | Maximum for cellular download (no WiFi prompt above this) | Apple App Store docs |
| App Store (iOS) | 4 GB | Absolute maximum app bundle size | Apple App Store docs |
| Play Store (Android) | 150 MB | Maximum APK size for download | Google Play Store policies |
| Play Store (AAB) | 150 MB base + 2 GB on-demand | AAB base module limit; feature modules downloaded on demand | Google Play AAB docs |
| Play Store install | ~500 MB | Approximate max expanded install size before user friction rises | Google Play research |
| Average user threshold | ~100 MB | Users hesitate to download apps >100 MB on mobile data | Google internal research (2022) |

### Download Size vs Install Size

| Metric | Definition | Typical Ratio | Source |
|--------|-----------|--------------|--------|
| Download size | Compressed size transferred over network | 1x | Store metrics |
| Install size | Uncompressed on-device size | 1.5-3x download size | Platform docs |
| Play Store displayed | Download size (pre-AAB) or estimated device-specific size (AAB) | Device-specific | Play Console |
| App Store displayed | Approximate download size (varies by device) | Device-specific since iOS 13 | App Store Connect |

### App Thinning (iOS)

App thinning automatically delivers only the resources needed for the specific device:

| Technology | What It Removes | Savings | Source |
|-----------|----------------|---------|--------|
| App Slicing | Unused device-specific assets (@1x on @3x device, unused architectures) | 20-60% reduction | Apple App Thinning docs |
| Bitcode | Recompiles for specific architecture server-side (deprecated in Xcode 14) | ~10-15% (historical) | Apple docs |
| On-Demand Resources (ODR) | Defers asset download until needed (game levels, rare features) | Varies (up to 80% of initial download) | Apple ODR docs |

```swift
// iOS — On-Demand Resources
// 1. Tag resources in Xcode: Select asset > Attributes Inspector > On Demand Resource Tags
// 2. Request at runtime:
let resourceRequest = NSBundleResourceRequest(tags: ["level_5_assets"])
resourceRequest.conditionallyBeginAccessingResources { available in
    if available {
        // Assets already cached — use immediately
        self.loadLevel5()
    } else {
        resourceRequest.beginAccessingResources { error in
            if let error = error {
                self.showDownloadError(error)
                return
            }
            DispatchQueue.main.async {
                self.loadLevel5()
            }
        }
    }
}
// 3. Release when done:
// resourceRequest.endAccessingResources()
```

### Android App Bundle (AAB)

AAB enables Play Store to generate optimized APKs per device configuration:

| Split Type | What It Splits | Typical Savings | Source |
|-----------|---------------|----------------|--------|
| ABI split | CPU architecture (arm64-v8a, x86_64, armeabi-v7a) | 30-50% (removes unused native libs) | Android AAB docs |
| Screen density split | Drawable resources (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi) | 15-30% (serves only matching density) | Android AAB docs |
| Language split | String resources, locale-specific assets | 5-10% | Android AAB docs |
| Feature modules | Dynamic Feature Modules downloaded on demand | Varies (up to 80%) | Android Dynamic Delivery docs |

```kotlin
// Android — Dynamic Feature Module (on-demand delivery)
// In the dynamic feature module's build.gradle:
android {
    dynamicFeatures = [":feature_ar_scanner"]
}

// Request installation at runtime:
val splitInstallManager = SplitInstallManagerFactory.create(context)
val request = SplitInstallRequest.newBuilder()
    .addModule("feature_ar_scanner")
    .build()

splitInstallManager.startInstall(request)
    .addOnSuccessListener { sessionId ->
        // Monitor download progress
    }
    .addOnFailureListener { exception ->
        // Handle failure — offer degraded experience
    }
```

### Size Budget Breakdown (Target: 30 MB Download)

| Category | Budget | Optimization | Source |
|----------|--------|-------------|--------|
| Code (DEX/Swift) | 5-8 MB | ProGuard/R8 shrinking, tree shaking | Android R8 / Swift compiler |
| Native libraries (.so) | 3-10 MB | ABI split (AAB), strip debug symbols | Android NDK docs |
| Images/drawables | 5-10 MB | WebP format, vector drawables where possible | Google image optimization |
| Fonts | 0.5-2 MB | Use system font, subset custom fonts (only needed glyphs) | Font optimization guides |
| ML models | 2-20 MB | Quantize (float32 -> int8 = 4x smaller), split to on-demand | TFLite / Core ML optimization |
| Third-party SDKs | 3-15 MB | Audit and remove unused SDKs, prefer lighter alternatives | Size analysis tools |
| Assets (audio, video, JSON) | 0-5 MB | Compress, stream instead of bundle, on-demand | Best practice |

### Size Monitoring in CI

```yaml
# .github/workflows/size-check.yml
name: App Size Check
on: [pull_request]

jobs:
  android-size:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build release AAB
        run: ./gradlew bundleRelease
      - name: Check APK size with bundletool
        run: |
          java -jar bundletool.jar get-size total \
            --apks=app/build/outputs/bundle/release/app-release.aab \
            --dimensions=ABI,SCREEN_DENSITY
      - name: Fail if base APK > 15 MB
        run: |
          SIZE=$(java -jar bundletool.jar get-size total --apks=*.aab | tail -1 | cut -f2)
          if [ "$SIZE" -gt 15728640 ]; then
            echo "FAIL: Base APK size $SIZE exceeds 15 MB budget"
            exit 1
          fi

  ios-size:
    runs-on: macos-14
    steps:
      - uses: actions/checkout@v4
      - name: Build and export IPA
        run: |
          xcodebuild archive -scheme App -archivePath build/App.xcarchive
          xcodebuild -exportArchive -archivePath build/App.xcarchive \
            -exportOptionsPlist ExportOptions.plist -exportPath build/
      - name: Report app thinning sizes
        run: |
          # App Thinning Size Report generated during export
          cat build/App-Thinning-Size-Report.txt
```

### Checklist

- [ ] Download size under 100 MB (ideal: under 30 MB for highest install conversion)
- [ ] AAB used for Play Store distribution (not APK)
- [ ] App Slicing / On-Demand Resources configured for iOS
- [ ] Native libraries split by ABI (no universal fat binary in production)
- [ ] Images use WebP/AVIF; vectors used for icons and simple illustrations
- [ ] ML models quantized (int8) and/or downloaded on demand
- [ ] Third-party SDK audit: each SDK justified by size impact
- [ ] CI pipeline measures and gates on app size per PR
- [ ] Custom fonts subsetted to only required glyphs/weights
- [ ] R8 full mode / ProGuard enabled for release builds (Android)

### Anti-Patterns

- **Shipping APK instead of AAB**: Includes all ABI, density, and language resources — 2-3x larger than needed
- **Bundled video/audio**: Including large media files in the binary instead of streaming
- **Unoptimized PNGs**: Using PNG for photographs instead of WebP (3-5x larger)
- **Debug symbols in release**: Shipping native libraries with debug symbols (2-10x larger)
- **Universal font**: Bundling all weights (Thin through Black) of a custom font when only Regular and Bold are used
- **No size monitoring**: Size creeps up with each SDK addition; no CI gate catches it

**Sources:** Apple App Store size limits documentation, Apple App Thinning guide, Google Play Store APK/AAB size policies, Android App Bundle documentation, Android Dynamic Delivery docs, Google Play Console size optimization report.

---

## CN. Predictive Back Gesture (Android 13+)

### Overview

Predictive back lets users see a preview of the destination before completing the back gesture. Instead of an immediate transition, the user sees an animated preview behind the current screen. Releasing completes the back action; pulling the finger back cancels it.

### System Animations

| Animation | Min API | Behavior | Source |
|-----------|---------|----------|--------|
| Back-to-home | API 33 (opt-in), API 35 (default) | Current app shrinks, wallpaper/home screen peeks behind | Android predictive back docs |
| Cross-activity | API 35 | Previous activity visible behind current during swipe | Android 15 docs |
| Cross-task | API 35 | Previous task visible when back crosses task boundary | Android 15 docs |
| Custom transitions | API 33+ | Developer-defined animations with progress tracking | AndroidX Activity 1.6+ |

### Opt-In Migration

| API Level | Behavior | Required Action |
|-----------|----------|----------------|
| API 33-34 | Opt-in via manifest; animations visible only with developer option enabled | Set `android:enableOnBackInvokedCallback="true"` in manifest |
| API 35+ | System animations (back-to-home, cross-activity) enabled by default | Migrate all `onBackPressed()` overrides |
| Any API | Custom AndroidX callbacks work regardless of manifest flag | Use `OnBackPressedCallback` |

```xml
<!-- AndroidManifest.xml — per-activity opt-in (recommended for gradual migration) -->
<application android:enableOnBackInvokedCallback="false">
    <!-- Migrated activity -->
    <activity
        android:name=".HomeActivity"
        android:enableOnBackInvokedCallback="true" />
    <!-- Not yet migrated -->
    <activity
        android:name=".LegacyActivity"
        android:enableOnBackInvokedCallback="false" />
</application>
```

### Migrating from onBackPressed()

**Before (deprecated):**

```kotlin
// DEPRECATED — blocks predictive back animation
override fun onBackPressed() {
    if (viewModel.hasUnsavedChanges()) {
        showUnsavedChangesDialog()
    } else {
        super.onBackPressed()
    }
}
```

**After (recommended):**

```kotlin
// AndroidX OnBackPressedCallback — works with predictive back
class EditActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val callback = object : OnBackPressedCallback(enabled = false) {
            override fun handleOnBackPressed() {
                showUnsavedChangesDialog()
            }
        }
        onBackPressedDispatcher.addCallback(this, callback)

        // Enable/disable based on UI state
        viewModel.hasUnsavedChanges.observe(this) { hasChanges ->
            callback.isEnabled = hasChanges
            // When disabled, system handles back (with animation)
            // When enabled, our callback intercepts
        }
    }
}
```

### Custom Transitions with Progress Tracking

```kotlin
// Compose — PredictiveBackHandler with animation progress
@Composable
fun BottomSheetWithPredictiveBack(onDismiss: () -> Unit) {
    var offsetY by remember { mutableFloatStateOf(0f) }

    PredictiveBackHandler(enabled = true) { progress: Flow<BackEventCompat> ->
        try {
            progress.collect { event ->
                // event.progress: 0.0 (start) to 1.0 (committed)
                // event.touchX, event.touchY: finger position
                // event.swipeEdge: LEFT or RIGHT
                offsetY = event.progress * 300f // Slide sheet down
            }
            // Back gesture completed — dismiss
            onDismiss()
        } catch (e: CancellationException) {
            // Back gesture cancelled — reset
            animate(offsetY, 0f) { value, _ -> offsetY = value }
        }
    }

    Surface(
        modifier = Modifier
            .offset { IntOffset(0, offsetY.toInt()) }
            .fillMaxWidth()
    ) {
        // Bottom sheet content
    }
}
```

### Shared Element Transitions with Predictive Back

```kotlin
// Android 15+ — shared element transitions respect predictive back
class DetailActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable shared element transitions that work with predictive back
        window.requestFeature(Window.FEATURE_ACTIVITY_TRANSITIONS)
        window.sharedElementEnterTransition = MaterialContainerTransform().apply {
            addTarget(R.id.detail_container)
            duration = 300
        }
        // The return transition automatically animates during predictive back swipe
        window.sharedElementReturnTransition = MaterialContainerTransform().apply {
            addTarget(R.id.detail_container)
            duration = 300
        }
        super.onCreate(savedInstanceState)
    }
}
```

### API Replacement Table

| Deprecated API | Replacement | Notes |
|---------------|------------|-------|
| `Activity.onBackPressed()` | `OnBackPressedDispatcher.addCallback()` | AndroidX Activity 1.6+ |
| `KeyEvent.KEYCODE_BACK` handling | `OnBackPressedCallback` | Same dispatcher |
| `Dialog.onBackPressed()` | `OnBackPressedCallback` added to dialog's dispatcher | Wrap in callback |
| `Fragment.onBackPressed()` | Callback scoped to fragment viewLifecycleOwner | Auto-removed on destroy |
| Analytics on back | `PRIORITY_SYSTEM_NAVIGATION_OBSERVER` (API 36+) | Observe without consuming |

### Testing Predictive Back

| Android Version | How to Test | Source |
|----------------|------------|--------|
| 13-14 | Settings > System > Developer options > "Predictive back animations" toggle | Android developer docs |
| 15+ | System animations appear automatically for opted-in activities | Android 15 docs |
| Emulator | Same developer option; use long-press back button to simulate slow gesture | Android Studio |

### Checklist

- [ ] `android:enableOnBackInvokedCallback="true"` set (per-activity or per-app)
- [ ] All `onBackPressed()` overrides migrated to `OnBackPressedCallback`
- [ ] All `KEYCODE_BACK` handling migrated to `OnBackPressedCallback`
- [ ] Callbacks tied to observable UI state (enabled/disabled dynamically)
- [ ] Custom transitions use `PredictiveBackHandler` (Compose) or progress-based animation
- [ ] Bottom sheets and dialogs support predictive back dismissal
- [ ] Shared element transitions tested with predictive back swipe
- [ ] Tested on API 33 (developer option), API 35 (default), and pre-13 (no animation)
- [ ] No analytics or business logic in back callbacks (use lifecycle instead)

### Anti-Patterns

- **Always-enabled callback**: Callback that is always enabled blocks all system back animations permanently
- **Business logic in back handler**: Running network calls or saving data in `handleOnBackPressed()` — use ViewModel + lifecycle
- **Ignoring cancellation**: Not resetting UI state when back gesture is cancelled (finger pulled back)
- **`onBackPressed()` + callback**: Having both deprecated override and new callback — causes double handling
- **Not testing**: Shipping without testing predictive back animations — users see broken transitions

**Sources:** Android Predictive Back Gesture documentation, AndroidX Activity 1.6+ release notes, Android 15 behavior changes (API 35), Material Motion guidance for Android, Google "Handling Back Navigation" codelab.

---

## CO. Per-App Language (Android 13+ / iOS)

### Overview

Per-app language preferences allow users to set a different language for each app independently of their device system language. This is critical for multilingual users (e.g., system in English but banking app in French).

### Android 13+ Implementation

**Method 1: Automatic (AGP 8.1+, recommended):**

```kotlin
// build.gradle.kts
android {
    androidResources {
        generateLocaleConfig = true  // Auto-generates locale list from res/values-*/
    }
}
```

```properties
# app/src/main/resources.properties
unqualifiedResLocale=en-US
```

**Method 2: Manual locale config:**

```xml
<!-- res/xml/locales_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<locale-config xmlns:android="http://schemas.android.com/apk/res/android">
    <locale android:name="en-US"/>
    <locale android:name="fr"/>
    <locale android:name="es"/>
    <locale android:name="de"/>
    <locale android:name="ja"/>
    <locale android:name="ar"/>    <!-- RTL language -->
    <locale android:name="zh-Hans"/>
</locale-config>
```

```xml
<!-- AndroidManifest.xml -->
<application
    android:localeConfig="@xml/locales_config"
    ...>
</application>
```

**User access points (system-managed):**
- Settings > System > Languages & Input > App Languages > [App]
- Settings > Apps > [App] > Language

### Programmatic Language Change (Android)

```kotlin
// Using AndroidX AppCompat 1.6.0+ (backward compatible to API 24)
import androidx.appcompat.app.AppCompatDelegate
import androidx.core.os.LocaleListCompat

// Set language programmatically (in-app language picker)
fun setAppLanguage(languageTag: String) {
    val localeList = LocaleListCompat.forLanguageTags(languageTag)
    // Must be called on main thread — may trigger Activity recreation
    AppCompatDelegate.setApplicationLocales(localeList)
}

// Get current app language
fun getCurrentLanguage(): String {
    val locales = AppCompatDelegate.getApplicationLocales()
    return if (locales.isEmpty) "system" else locales.toLanguageTags()
}

// Reset to system language
fun resetToSystemLanguage() {
    AppCompatDelegate.setApplicationLocales(LocaleListCompat.getEmptyLocaleList())
}
```

**Backward compatibility (Android 12 and below):**

```xml
<!-- AndroidManifest.xml — enable auto-storage for pre-13 devices -->
<application>
    <service
        android:name="androidx.appcompat.app.AppLocalesMetadataHolderService"
        android:enabled="false"
        android:exported="false">
        <meta-data
            android:name="autoStoreLocales"
            android:value="true" />
    </service>
</application>
```

### iOS Per-App Language

iOS has supported per-app language since iOS 13 via the system Settings app. No code is required for basic support — the system handles it based on your app's `.lproj` bundles.

**User access:**
- Settings > [App Name] > Language (listed under "Preferred Language")

**In-app language picker (optional, for custom UX):**

```swift
// iOS — programmatic language change (requires app restart)
// Option 1: Direct UserDefaults (traditional approach)
func setAppLanguage(_ languageCode: String) {
    UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
    // Show alert: "Please restart the app for the language change to take effect"
}

// Option 2: Use Bundle override (no restart, SwiftUI)
class LanguageManager: ObservableObject {
    @Published var currentLanguage: String = "en" {
        didSet {
            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
            Bundle.setLanguage(currentLanguage) // Custom extension
        }
    }
}

// Bundle extension for runtime language switching
extension Bundle {
    private static var onLanguageDispatchOnce: () = {
        object_setClass(Bundle.main, PrivateBundle.self)
    }()

    static func setLanguage(_ language: String) {
        _ = onLanguageDispatchOnce
        // ... swap main bundle's localization
    }
}
```

### In-App Language Picker UX

| Guideline | Implementation | Source |
|-----------|---------------|--------|
| Placement | Settings screen, near top | Common pattern |
| Display format | Native language name + English name: "Francais (French)" | FIDO Alliance, Google guidelines |
| Current selection | Clearly highlighted with checkmark | Standard list selection |
| Search | Provide search/filter for apps with 10+ languages | UX best practice |
| Restart warning | If restart required, warn before applying | iOS needs restart; Android may recreate Activity |
| Flag icons | Do not use flags for languages (flags = countries, not languages) | NNGroup, W3C i18n |

```
┌──────────────────────────────────┐
│  ← Settings                      │
│                                  │
│  Language                        │
│                                  │
│  ┌──────────────────────────┐   │
│  │ 🔍 Search languages      │   │
│  └──────────────────────────┘   │
│                                  │
│  ✓ English                       │  <- Current selection
│    Francais (French)             │
│    Espanol (Spanish)             │
│    Deutsch (German)              │
│    日本語 (Japanese)               │
│    العربية (Arabic)               │  <- RTL indicator
│    中文简体 (Chinese Simplified)   │
│                                  │
│  System Default                  │  <- Reset option
│                                  │
└──────────────────────────────────┘
```

### RTL Switching

When the user switches to an RTL language (Arabic, Hebrew, Farsi, Urdu), the entire layout must mirror:

| Element | LTR | RTL | Source |
|---------|-----|-----|--------|
| Text alignment | Left | Right | Android/iOS auto with `start`/`end` |
| Navigation back arrow | ← (left) | → (right) | Platform auto-mirrored |
| List chevrons | > (right) | < (left) | Auto-mirrored |
| Progress bars | Left to right | Right to left | Auto-mirrored |
| Icons with directionality | Original | Mirrored (send arrow, forward, etc.) | Must use `autoMirrored="true"` (Android) |
| Icons without directionality | Original | NOT mirrored (play, search, clock) | Leave as-is |
| Swipe gestures | Swipe right = back | Swipe left = back | Platform-managed |
| Number formatting | 123,456.78 | May use Hindi numerals (١٢٣) depending on locale | Locale-specific |

```kotlin
// Android — auto-mirrored vector drawable
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:autoMirrored="true"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path android:pathData="M20,11H7.83l5.59-5.59L12,4l-8,8 8,8 1.41-1.41L7.83,13H20v-2z"/>
</vector>
```

```kotlin
// Android — force layout direction for testing
// In Developer Options: "Force RTL layout direction"
// Or programmatically in tests:
ViewCompat.setLayoutDirection(view, ViewCompat.LAYOUT_DIRECTION_RTL)
```

### Dynamic Locale Configuration (Android 14+)

Customize available languages per region at runtime:

```kotlin
// Show different language options per region
val localeManager = getSystemService(LocaleManager::class.java)
localeManager.overrideLocaleConfig = LocaleConfig(
    LocaleList.forLanguageTags(
        when (userRegion) {
            "EU" -> "en-US,fr,de,es,it,pt,nl,pl"
            "APAC" -> "en-US,ja,ko,zh-Hans,zh-Hant,th,vi"
            else -> "en-US,fr,es,de,ja"
        }
    )
)
```

### Checklist

- [ ] `localeConfig` declared in manifest or auto-generated via AGP 8.1+
- [ ] All user-facing strings in `strings.xml` / `Localizable.strings` (no hardcoded text)
- [ ] In-app language picker shows native language names
- [ ] RTL layout tested for all RTL languages (Arabic, Hebrew, Farsi, Urdu)
- [ ] Directional icons use `autoMirrored="true"` (Android)
- [ ] Non-directional icons do NOT mirror in RTL
- [ ] Activity recreation handled gracefully on language change (no data loss)
- [ ] `AppleLanguages` UserDefaults honored on iOS
- [ ] Backward compatibility for Android 12 and below (autoStoreLocales service)
- [ ] No flag icons used to represent languages

### Anti-Patterns

- **Hardcoded strings**: Any user-visible text outside of resource files breaks all localization
- **Flag icons for languages**: Spanish flag for Spanish — but which Spanish? Spain, Mexico, Argentina? Languages are not countries
- **Forgetting RTL**: Layout breaks when Arabic or Hebrew user selects their language
- **No restart handling**: Language change causes Activity recreation, losing form data or scroll position
- **Missing plural forms**: Using string concatenation for counts ("3 item(s)") instead of proper plurals (`plurals.xml` / `stringsdict`)

**Sources:** Android per-app language preferences documentation, AndroidX AppCompat 1.6.0 release notes, Android 14 dynamic locale configuration docs, Apple Settings Bundle documentation, W3C Internationalization best practices, NNGroup localization guidelines.

---

## CP. iOS 18 Control Center Widgets

### Overview

iOS 18 (WWDC 2024) introduced the ControlWidget API, allowing third-party apps to place controls in Control Center, the Lock Screen, and the Action Button. Controls are lightweight, always-available toggles and buttons that perform a single action without opening the app.

### Control Types

| Type | Behavior | Use Case | Example |
|------|----------|----------|---------|
| Toggle | Binary on/off state, persists | Enable/disable a feature | Smart light toggle, Do Not Disturb, VPN on/off |
| Button | Momentary action, no persistent state | Trigger an action | Lock door, start timer, open camera |

### ControlWidget API

```swift
// Define a toggle control
import WidgetKit
import AppIntents

struct CaffeineTrackingControl: ControlWidget {
    static let kind: String = "com.example.app.caffeine-tracking"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: Self.kind,
            provider: CaffeineValueProvider()
        ) { value in
            ControlWidgetToggle(
                "Track Caffeine",
                isOn: value,
                action: ToggleCaffeineTrackingIntent()
            ) { isOn in
                Label(
                    isOn ? "Tracking" : "Paused",
                    systemImage: isOn ? "cup.and.saucer.fill" : "cup.and.saucer"
                )
            }
        }
        .displayName("Caffeine Tracking")
        .description("Toggle caffeine intake tracking")
    }
}

// Value provider
struct CaffeineValueProvider: ControlValueProvider {
    var previewValue: Bool { true }

    func currentValue() async throws -> Bool {
        // Read current state from your app's data store
        let store = CaffeineStore.shared
        return await store.isTrackingEnabled
    }
}

// App Intent for the toggle action
struct ToggleCaffeineTrackingIntent: SetValueIntent {
    static var title: LocalizedStringResource = "Toggle Caffeine Tracking"

    @Parameter(title: "Enabled")
    var value: Bool

    func perform() async throws -> some IntentResult {
        let store = CaffeineStore.shared
        await store.setTrackingEnabled(value)
        return .result()
    }
}
```

### Button Control

```swift
struct QuickLogControl: ControlWidget {
    static let kind: String = "com.example.app.quick-log"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: Self.kind
        ) {
            ControlWidgetButton(action: LogCigaretteIntent()) {
                Label("Log Entry", systemImage: "plus.circle.fill")
            }
        }
        .displayName("Quick Log")
        .description("Log an entry with one tap")
    }
}

struct LogCigaretteIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Entry"
    static var openAppWhenRun: Bool = false  // Runs without opening app

    func perform() async throws -> some IntentResult {
        let store = DataStore.shared
        await store.logEntry(date: .now)
        return .result()
    }
}
```

### Registration

```swift
// Register controls in your WidgetBundle
@main
struct AppWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Home Screen widgets
        DailySummaryWidget()
        WeeklyChartWidget()

        // Control Center controls
        CaffeineTrackingControl()
        QuickLogControl()
    }
}
```

### Design Constraints

| Constraint | Value | Source |
|-----------|-------|--------|
| Control size | System-defined, not customizable (similar to widget small size) | Apple WidgetKit docs |
| Tint color | System applies dynamic tinting; you provide a template image | Apple WWDC 2024 |
| Icon style | SF Symbols required (filled variant preferred) | Apple HIG |
| Label | Short text, 1-2 words (system truncates long text) | Apple WidgetKit docs |
| Interactivity | Toggle (on/off) or Button (momentary) only — no sliders, pickers, or text input | Apple ControlWidget docs |
| State updates | Via `ControlCenter.shared.reloadControls(ofKind:)` | Apple WidgetKit docs |
| App launch | Optional: set `openAppWhenRun = true` on AppIntent to open app | Apple AppIntents docs |
| Background execution | AppIntent runs in background (no UI), limited to 30 seconds | Apple AppIntents docs |

### Lock Screen Placement

Controls can also appear on the Lock Screen (iOS 18+):

| Placement | Access | Source |
|-----------|--------|--------|
| Control Center | Swipe down from top-right (Face ID) / swipe up from bottom (Touch ID) | iOS standard gesture |
| Lock Screen | Long-press Lock Screen > customize > add controls to bottom row | iOS 18 customization |
| Action Button (iPhone 15 Pro+) | Hardware button on left side — can be assigned to a control | Apple Action Button docs |

### Checklist

- [ ] ControlWidget conforms to `ControlWidget` protocol
- [ ] `StaticControlConfiguration` (or `AppIntentControlConfiguration`) used
- [ ] `displayName` and `description` provided for Controls Gallery
- [ ] SF Symbols used for icons (filled variant)
- [ ] Labels short (1-2 words, system truncates)
- [ ] Toggle: `ControlWidgetToggle` with `SetValueIntent`
- [ ] Button: `ControlWidgetButton` with `AppIntent`
- [ ] `openAppWhenRun = false` for actions that don't need the app foreground
- [ ] `reloadControls(ofKind:)` called when state changes from within the app
- [ ] Registered in `WidgetBundle`

### Anti-Patterns

- **Complex interactions**: Trying to build a mini-app in a control — controls are single-action only
- **Long-running intent**: AppIntent that takes > 5 seconds — user sees spinner, feels broken
- **Missing state sync**: Toggle shows "on" in Control Center but feature is actually off because `reloadControls` was not called
- **Verbose labels**: "Start Tracking My Daily Caffeine Intake" — will be truncated to "Start Tracking..."
- **Custom icons**: Using custom images instead of SF Symbols — inconsistent with system controls

**Sources:** Apple WWDC 2024 "Extend Your App's Controls Across the System", Apple WidgetKit documentation (ControlWidget), Apple AppIntents framework documentation, Apple Human Interface Guidelines (Controls).

---

## CQ. Baymard Mobile Checkout Research Data

### Mobile Checkout Abandonment

Baymard Institute's large-scale quantitative research (aggregated from 49 studies, 2012-2024) provides benchmark data for mobile e-commerce checkout:

| Metric | Value | Source |
|--------|-------|--------|
| Average cart abandonment rate (all devices) | 70.19% | Baymard Institute (49-study average, 2024) |
| Mobile cart abandonment rate | 85.65% | Baymard mobile-specific studies (2023) |
| Desktop cart abandonment rate | 73.07% | Baymard desktop benchmark |
| Mobile-to-desktop gap | +12.58 percentage points | Baymard comparative analysis |
| Checkout-specific abandonment (entered checkout but did not complete) | 27% of users | Baymard checkout usability study (2024) |

### Reasons for Abandonment (Mobile-Specific)

| Reason | % of Abandoners | UX Fix | Source |
|--------|----------------|--------|--------|
| Extra costs too high (shipping, tax, fees) | 48% | Show total cost early, before checkout | Baymard 2024 |
| Required to create an account | 26% | Offer guest checkout prominently | Baymard 2024 |
| Delivery too slow | 22% | Show estimated delivery date on product page | Baymard 2024 |
| Didn't trust site with credit card info | 25% | Security badges near payment form, padlock icon | Baymard 2024 |
| Too long/complicated checkout | 22% | Reduce to 3-5 steps; show progress indicator | Baymard 2024 |
| Couldn't see total order cost upfront | 21% | Running order summary visible at all times | Baymard 2024 |
| Returns policy not satisfactory | 10% | Link returns policy prominently in cart | Baymard 2024 |
| Website errors/crashes | 17% | Error recovery, retry mechanisms (see section BX) | Baymard 2024 |
| Not enough payment methods | 13% | Offer Apple Pay, Google Pay, PayPal, BNPL | Baymard 2024 |
| Card declined | 4% | Clear error message + alternative payment suggestion | Baymard 2024 |

### Form Field Ordering

Baymard's research on 220+ checkout flows identified the optimal field order for mobile:

| Order | Field | Notes | Source |
|-------|-------|-------|--------|
| 1 | Email address | First — enables cart recovery emails if abandoned | Baymard checkout research |
| 2 | First name | Before last name (Western convention) | Baymard |
| 3 | Last name | | Baymard |
| 4 | Street address (line 1) | Auto-complete with Google Places / Apple Maps | Baymard |
| 5 | Street address (line 2) | Optional — collapse behind "Add apt/suite" link | Baymard |
| 6 | City | Auto-fill from ZIP/postal code when possible | Baymard |
| 7 | State/Province | Dropdown, not free text (reduces errors) | Baymard |
| 8 | ZIP/Postal code | If entered first, can auto-fill city + state | Baymard |
| 9 | Country | Default to detected location; dropdown for override | Baymard |
| 10 | Phone number | With country code prefix | Baymard |

**Key finding:** 24% of e-commerce sites have suboptimal field ordering that increases cognitive load. The above order matches user mental models from Baymard's eye-tracking studies.

### Express Checkout Placement

| Guideline | Detail | Source |
|-----------|--------|--------|
| Position | Above the fold on cart page, before standard checkout CTA | Baymard checkout research |
| Methods to show | Apple Pay, Google Pay, PayPal — show only those available on device | Baymard + platform docs |
| Button styling | Use platform-specific branded buttons (Apple Pay black, Google Pay white) | Apple Pay HIG, Google Pay Brand Guidelines |
| Reduction in fields | Express checkout skips ~60% of form fields (address, name auto-filled from wallet) | Baymard 2023 |
| Conversion lift | Sites offering express checkout see 20-35% higher mobile conversion | Multiple industry reports |

```
┌──────────────────────────────────┐
│  Your Cart (2 items)    $89.97   │
│                                  │
│  ┌────────────────────────────┐  │
│  │    [Apple Pay]              │  │  <- Express checkout FIRST
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │    [Google Pay]             │  │
│  └────────────────────────────┘  │
│  ┌────────────────────────────┐  │
│  │    [PayPal]                 │  │
│  └────────────────────────────┘  │
│                                  │
│  ─────── or ────────             │  <- Visual separator
│                                  │
│  ┌────────────────────────────┐  │
│  │   Continue to Checkout     │  │  <- Standard checkout below
│  └────────────────────────────┘  │
│                                  │
└──────────────────────────────────┘
```

### Shipping / Billing Address UX

| Pattern | Recommendation | Impact | Source |
|---------|---------------|--------|--------|
| "Same as shipping" default | Pre-check "Billing same as shipping" (default ON) | 75% of users have same address — saves 8+ fields | Baymard checkout |
| Address autocomplete | Google Places / Apple MapKit autocomplete after 3 characters typed | Reduces typing by 70%, errors by 20% | Baymard address research |
| ZIP-first lookup | Enter ZIP code first, auto-fill city + state | Saves 2 fields of typing | Baymard field study |
| Country detection | Default country from IP/locale; allow override | 92% accuracy, saves 1 field interaction | Baymard |
| Address line 2 | Hide behind "Add apartment, suite, etc." link | 70% of users do not need this field | Baymard |
| International addresses | Adapt fields per country (UK: no State; Japan: different order) | Prevents confusion for international users | Baymard international study |

```kotlin
// Android — Google Places autocomplete for address
val autocompleteFragment = AutocompleteSupportFragment.newInstance()
autocompleteFragment.setTypesFilter(listOf("address"))
autocompleteFragment.setCountries("US", "CA", "GB") // Limit to shipping regions
autocompleteFragment.setPlaceFields(listOf(
    Place.Field.ADDRESS_COMPONENTS,
    Place.Field.FORMATTED_ADDRESS
))
autocompleteFragment.setOnPlaceSelectedListener(object : PlaceSelectionListener {
    override fun onPlaceSelected(place: Place) {
        place.addressComponents?.asList()?.forEach { component ->
            when {
                component.types.contains("street_number") -> streetNumberField.setText(component.name)
                component.types.contains("route") -> streetField.setText(component.name)
                component.types.contains("locality") -> cityField.setText(component.name)
                component.types.contains("administrative_area_level_1") -> stateField.setText(component.shortName)
                component.types.contains("postal_code") -> zipField.setText(component.name)
            }
        }
    }
    override fun onError(status: Status) { /* Handle error */ }
})
```

### Payment Method Selection

| Guideline | Detail | Source |
|-----------|--------|--------|
| Show all accepted methods upfront | Icons (Visa, MC, Amex, etc.) visible before entering card details | Baymard payment research |
| Card type auto-detection | Detect Visa/MC/Amex from first 4 digits, show icon | Baymard |
| Number formatting | Auto-format as "4242 4242 4242 4242" (groups of 4) | Baymard |
| Expiry format | MM/YY with auto-slash insertion | Baymard |
| CVV help | Info icon (?) showing where CVV is located on card | Baymard — 20% of users confused by CVV |
| Save card | "Save for next time" checkbox (default OFF for privacy) | Baymard + GDPR |
| BNPL placement | Show Buy Now Pay Later (Klarna, Afterpay) as separate payment option, not afterthought | Baymard 2023 |

**Card form layout (optimized for mobile):**

```
┌──────────────────────────────────┐
│  Payment                         │
│                                  │
│  💳 Visa  MC  Amex  Discover     │  <- Accepted cards
│                                  │
│  Card Number                     │
│  ┌──────────────────────────┐    │
│  │ 4242 4242 4242 4242  💳  │    │  <- Auto-detected icon
│  └──────────────────────────┘    │
│                                  │
│  ┌────────────┐ ┌────────────┐   │
│  │ MM/YY      │ │ CVV    (?) │   │  <- Side-by-side, CVV help
│  └────────────┘ └────────────┘   │
│                                  │
│  Name on Card                    │
│  ┌──────────────────────────┐    │
│  │                           │   │
│  └──────────────────────────┘    │
│                                  │
│  □ Save card for next time       │  <- Default OFF
│                                  │
└──────────────────────────────────┘
```

### Order Summary Visibility

| Guideline | Detail | Source |
|-----------|--------|--------|
| Always visible | Running total visible at all times during checkout (sticky footer or collapsible top) | Baymard 2024 — 21% abandon due to hidden costs |
| Itemized breakdown | Show subtotal, shipping, tax, discount as separate lines | Baymard |
| Line item thumbnail | Small product image (40x40 dp) + name + quantity + price per item | Baymard |
| Shipping cost timing | Show shipping cost before payment step (never surprise at the end) | Baymard — #1 abandonment reason |
| Editable from summary | Tap item to edit quantity or remove without leaving checkout | Baymard |
| Promo code field | Collapsible "Have a promo code?" link (not a prominent empty field) | Baymard — prominent field triggers "coupon hunting" |

```
┌──────────────────────────────────┐
│  Order Summary              ▼    │  <- Collapsible on mobile
│                                  │
│  ┌──┐ Widget Pro × 1    $49.99  │
│  └──┘                            │
│  ┌──┐ Case            × 1  $19.99│
│  └──┘                            │
│                                  │
│  Subtotal                $69.98  │
│  Shipping (Standard)      $5.99  │
│  Tax                      $5.60  │
│  ─────────────────────────────── │
│  Total                   $81.57  │
│                                  │
│  Have a promo code?              │  <- Collapsed by default
│                                  │
└──────────────────────────────────┘
```

### Checkout Step Count

| Steps | Conversion Impact | Recommendation | Source |
|-------|------------------|---------------|--------|
| 1 (one-page) | Best for simple orders (1-2 items) | Use for digital goods, subscriptions | Baymard |
| 2-3 steps | Optimal for most mobile checkouts | Shipping > Payment > Review | Baymard (2023 benchmark) |
| 4-5 steps | Acceptable if each step is short | Account > Shipping > Payment > Review > Confirm | Baymard |
| 6+ steps | Significant drop-off (22% cite "too long" as reason) | Consolidate into fewer steps | Baymard |

**Progress indicator (required for multi-step):**

```
┌──────────────────────────────────┐
│  ● Shipping ─── ○ Payment ─── ○ Review │  <- Step indicator
│                                        │
│  Step 1 of 3                           │  <- Text fallback for a11y
└────────────────────────────────────────┘
```

### Mobile-Specific Optimizations

| Optimization | Detail | Impact | Source |
|-------------|--------|--------|--------|
| Numeric keyboard for card/ZIP | `inputType="number"` / `keyboardType: .numberPad` | Reduces errors by 30% | Baymard input study |
| Auto-advance fields | After ZIP code, auto-focus next field | Saves 1-2 taps per form | Baymard |
| Inline validation | Validate on field exit, not on submit | 22% fewer form errors | Baymard (see also section BX) |
| Large touch targets | 48 dp minimum for all checkout buttons and form fields | Reduces mis-taps | Material Design 3 / Apple HIG |
| Sticky CTA | "Place Order" button sticky at bottom of viewport | Always reachable (thumb zone) | Baymard + section CE |
| Trust signals | Padlock icon, "Secure Checkout", payment logos near card form | 25% cite trust as concern | Baymard 2024 |

### Checklist

- [ ] Guest checkout available without forced account creation
- [ ] Express checkout (Apple Pay / Google Pay / PayPal) above the fold on cart page
- [ ] Total cost (including shipping and tax) visible before payment step
- [ ] "Billing same as shipping" pre-checked by default
- [ ] Address autocomplete implemented (Google Places / Apple MapKit)
- [ ] Form fields in optimal order (email first for cart recovery)
- [ ] Card type auto-detected from first digits
- [ ] CVV help tooltip explains location on card
- [ ] Progress indicator shown for multi-step checkout
- [ ] Numeric keyboard triggered for card number, ZIP, CVV, phone
- [ ] Promo code field collapsed by default (not a prominent empty field)
- [ ] Order summary collapsible but always accessible during checkout
- [ ] "Place Order" button sticky at bottom of viewport
- [ ] Inline validation on field exit (not on submit)

### Anti-Patterns

- **Forced account creation**: Requiring registration before checkout (26% abandonment cause)
- **Hidden shipping costs**: Revealing shipping cost only at the final step (48% cite this as #1 reason to abandon)
- **Prominent promo code field**: Large empty "Promo Code" input triggers users to leave and search for coupons, increasing abandonment
- **Desktop checkout on mobile**: Long scrolling single-page form with tiny fields designed for desktop
- **No express checkout**: Missing Apple Pay / Google Pay when 50%+ of mobile users prefer them
- **Billing address always expanded**: Showing all billing fields when 75% of users have same billing/shipping address
- **Submit-only validation**: Showing all errors only after tapping "Place Order" — forces scroll to find errors

**Sources:** Baymard Institute "Cart & Checkout UX" research study (2020-2024, based on 220+ checkout evaluations), Baymard Institute cart abandonment statistics (49-study aggregate, 2024 update), Baymard Institute mobile checkout benchmark data, Baymard Institute address form usability study, Baymard Institute payment form usability study.

---

## CR. Color Palette Construction & 60-30-10 Rule

Building a complete mobile color system from scratch, applicable to both iOS and Android, using systematic palette generation from a single brand color.

### The 60-30-10 Rule Adapted to Mobile

The classic interior-design proportion translates directly to mobile surfaces:

| Proportion | Role | Mobile Examples |
|---|---|---|
| **60% — Dominant** | Surface / background | `Surface`, `Background`, scaffold bg, list bg, empty states |
| **30% — Secondary** | Supporting surfaces | Cards, bottom sheets, nav bars, section headers, input field fills |
| **10% — Accent** | Key interactions | Primary CTA buttons, FAB, active tab indicator, toggle on-state, links |

Why it works on mobile: the 60% calm surface prevents visual fatigue during extended use. The 30% secondary creates visual grouping without competing for attention. The 10% accent preserves scannability — users instantly find the one tappable action on screen.

Common mistake: using accent color at 20–30% (e.g., colored headers + colored buttons + colored icons). This dilutes the signal-to-noise ratio and makes CTAs harder to spot.

### Generating a Full Palette from ONE Brand Color

Start with a single hex value (your brand color). All other colors derive from it using HSL manipulation.

#### Step 1: Primary Color Family

```
Brand color (example):  #6750A4  →  HSL(265, 35%, 48%)

Primary:                HSL(265, 35%, 48%)  →  #6750A4
OnPrimary:              #FFFFFF (white text on primary)
PrimaryContainer:       HSL(265, 60%, 90%)  →  light tint for backgrounds
OnPrimaryContainer:     HSL(265, 50%, 20%)  →  dark shade for text on container
```

#### Step 2: Secondary — Analogous Hue (±30°)

```
Secondary:              HSL(235, 30%, 48%)  →  shift hue -30°
SecondaryContainer:     HSL(235, 50%, 90%)
OnSecondaryContainer:   HSL(235, 40%, 20%)
```

Alternative: use complementary hue (±180°) for high-contrast palettes, or split-complementary (±150°) for balanced variety.

#### Step 3: Tertiary — Triadic Hue (+120°)

```
Tertiary:               HSL(25, 40%, 48%)  →  shift hue +120°
TertiaryContainer:      HSL(25, 55%, 90%)
OnTertiaryContainer:    HSL(25, 45%, 20%)
```

#### Step 4: Neutral Scale (10 Steps)

Desaturate the primary hue and generate a lightness ramp:

```
Hue: 265 (same as primary)
Saturation: 5-10% (barely tinted gray)

Neutral-50:   HSL(265, 8%, 97%)   →  lightest surface
Neutral-100:  HSL(265, 8%, 95%)
Neutral-200:  HSL(265, 8%, 88%)
Neutral-300:  HSL(265, 8%, 78%)
Neutral-400:  HSL(265, 7%, 65%)
Neutral-500:  HSL(265, 6%, 50%)
Neutral-600:  HSL(265, 6%, 40%)
Neutral-700:  HSL(265, 7%, 30%)
Neutral-800:  HSL(265, 8%, 20%)
Neutral-900:  HSL(265, 8%, 12%)
Neutral-950:  HSL(265, 8%, 6%)    →  darkest surface (dark mode bg)
```

#### Step 5: Semantic Colors (Platform Defaults)

| Role | iOS Default | Android M3 Default | Usage |
|---|---|---|---|
| Success | `#34C759` | `#4CAF50` | Confirmations, completed states, positive trends |
| Warning | `#FF9500` | `#FFC107` | Non-blocking alerts, approaching limits, caution states |
| Error | `#FF3B30` | `#F44336` | Validation errors, destructive confirmations, failures |
| Info | `#007AFF` | `#2196F3` | Informational banners, help indicators, neutral status |

Keep semantic colors independent from brand palette — users have ingrained associations (red = error, green = success).

### Material Theme Builder Workflow

1. Open [Material Theme Builder](https://m3.material.io/theme-builder)
2. Paste brand hex into "Primary" source color
3. Builder auto-generates Secondary, Tertiary, Neutral, NeutralVariant, Error
4. Review light and dark schemes in the preview
5. Export: **Jetpack Compose** (Theme.kt), **Flutter** (color_schemes.dart), **CSS** (tokens.css), or **DSP** (design token package)
6. The exported code includes all 29 color roles (surface, surfaceVariant, outline, outlineVariant, inverseSurface, etc.)

### iOS Dynamic Colors

Creating custom color sets in the asset catalog:

1. In Xcode → Assets.xcassets → New Color Set
2. Set **Appearances**: Any, Dark (optionally: Any, Dark, Tinted for visionOS)
3. Set **High Contrast** variants: check "High Contrast" in Attributes Inspector
4. In code: `Color("BrandPrimary")` or `UIColor(named: "BrandPrimary")`
5. SwiftUI: use `Color.accentColor` for system-integrated tinting

For programmatic generation:

```swift
// SwiftUI dynamic color
extension Color {
    static let brandPrimary = Color("BrandPrimary")     // from asset catalog
    static let brandSurface = Color(.systemBackground)   // system-adapting
    static let brandOnSurface = Color(.label)            // adapts to dark mode
}
```

### Contrast Requirements (WCAG 2.1)

| Element | Minimum Ratio | Test Tool |
|---|---|---|
| Body text (< 18pt) | **4.5:1** | Accessibility Inspector (Xcode), Accessibility Scanner (Android) |
| Large text (≥ 18pt bold / 24pt regular) | **3:1** | Same tools |
| UI components (icons, borders, controls) | **3:1** | Manual contrast checker |
| Decorative / disabled elements | No requirement | — |

Test workflow: Xcode → Accessibility Inspector → Color Contrast Calculator. Android Studio → Accessibility Scanner plugin or Lint warnings.

### Dark Mode Remapping

Never invert colors. Remap them:

| Light Mode | Dark Mode | Rationale |
|---|---|---|
| `#FFFFFF` (background) | `#121212` | Pure black (#000000) causes halation on OLED |
| `#F5F5F5` (surface) | `#1E1E1E` | Slight elevation above background |
| `#6750A4` (primary) | `#D0BCFF` | Desaturated + lightened for dark bg contrast |
| `#1C1B1F` (onSurface) | `#E6E1E5` | High-contrast text on dark surfaces |
| `#FFFBFE` (surfaceVariant) | `#49454F` | Cards / grouped content |

Key rules:
- Desaturate vibrant colors by 10–20% for dark mode (reduces eye strain)
- Surface color differentiation replaces shadow-based elevation in dark mode
- Error red: use `#F2B8B5` (light on dark) instead of `#F44336` (too harsh)
- Never use pure white `#FFFFFF` text — use `#E6E1E5` or 87% opacity white

**Sources:** Material Design 3 Color System documentation (m3.material.io/styles/color), Apple Human Interface Guidelines — Color (developer.apple.com/design/human-interface-guidelines/color), WCAG 2.1 Success Criterion 1.4.3 Contrast (Minimum), Material Theme Builder tool documentation.

---

## CS. Button Hierarchy Complete Specs

Every button variant with exact platform-specific values, states, and usage rules. Buttons are the primary interactive element — their hierarchy determines scannability and action clarity.

### Primary Button (Filled)

The highest-emphasis button. Use for the single most important action per screen.

**Android (Material 3):**
```
Background:       colorPrimary (#6750A4 default)
Text color:       colorOnPrimary (#FFFFFF)
Height:           40dp
Corner radius:    20dp (full pill shape = height / 2)
Horizontal padding: 24dp
Vertical padding: 10dp
Text style:       labelLarge (14sp, medium weight, 0.1sp tracking)
Min width:        none (content-sized)
Elevation:        0dp (M3 filled buttons are flat)
```

**iOS (SwiftUI):**
```swift
.buttonStyle(.borderedProminent)
.tint(.accentColor)
// System renders:
Height:           ~50pt (system default, varies by context)
Corner radius:    10pt (system default)
Horizontal padding: ~20pt
Font:             .body.bold() (17pt semibold)
```

**States:**
| State | Android M3 | iOS |
|---|---|---|
| Default | bg `colorPrimary` | bg `accentColor` |
| Hovered | +8% white overlay on bg | subtle brightness increase |
| Pressed | +12% black overlay on bg (ripple) | opacity 0.7 momentarily |
| Focused | +12% white overlay + focus ring | system focus ring |
| Disabled | bg 12% `colorOnSurface`, text 38% `colorOnSurface` | `.disabled()` → dimmed 38% |
| Loading | `CircularProgressIndicator` replaces text, button same size | `ProgressView()` replaces label |

### Secondary Button (Outlined / Tonal)

Medium emphasis. Use for alternative or supporting actions alongside a primary button.

**Android M3 — Tonal variant:**
```
Background:       colorSecondaryContainer (#E8DEF8)
Text color:       colorOnSecondaryContainer (#1D192B)
Height:           40dp
Corner radius:    20dp
Horizontal padding: 24dp
Elevation:        0dp
```

**Android M3 — Outlined variant:**
```
Background:       transparent
Border:           1dp solid colorOutline (#79747E)
Text color:       colorPrimary (#6750A4)
Height:           40dp
Corner radius:    20dp
Horizontal padding: 24dp
```

**iOS:**
```swift
.buttonStyle(.bordered)
.tint(.secondary)       // or custom tint
// System renders bordered capsule with tinted background
```

**States:** hover +8% container color overlay, pressed +12%, disabled 38% opacity on all elements.

### Tertiary Button (Text / Ghost)

Lowest emphasis. Use for dismissive actions ("Cancel", "Skip"), navigation links, or when space is tight.

**Android M3:**
```
Background:       transparent (no fill)
Text color:       colorPrimary (#6750A4)
Height:           40dp
Horizontal padding: 12dp (tighter than filled)
Ripple:           colorPrimary at 12% on press
No border, no elevation
```

**iOS:**
```swift
.buttonStyle(.borderless)
// or
.buttonStyle(.plain)
// Renders as tinted text, no background
```

**States:** hover shows subtle bg tint at 8% opacity, pressed 12% bg tint. No visible border ever.

### Destructive Button

For irreversible actions ONLY: permanent deletion, account removal, data wipe.

**Android M3:**
```
Background:       colorError (#F44336) — filled variant
Text color:       colorOnError (#FFFFFF)
OR outlined:      border 1dp colorError, text colorError, bg transparent
Height:           40dp
Corner radius:    20dp
```

**iOS:**
```swift
Button("Delete", role: .destructive) { }
.buttonStyle(.borderedProminent)
// System renders red-tinted button
// In alerts: .destructive role auto-styles red
```

**Rules:**
- ALWAYS confirm before executing: show Alert (iOS) or Dialog (Android)
- Never make destructive buttons more visually prominent than the primary safe action
- In confirmation dialogs, make the safe option ("Cancel") the default/prominent button
- Use outlined/text style for destructive buttons in lists (e.g., "Remove" in a row) — reserve filled destructive for final confirmation

### Floating Action Button (FAB)

**Android M3 sizes:**

| Variant | Size | Icon | Corner Radius | Elevation |
|---|---|---|---|---|
| Small FAB | 40dp × 40dp | 24dp | 12dp | 3dp |
| Standard FAB | 56dp × 56dp | 24dp | 16dp | 3dp |
| Large FAB | 96dp × 96dp | 36dp | 28dp | 3dp |
| Extended FAB | 56dp height × wrap | 24dp + label | 16dp | 3dp |

```
Background:       colorPrimaryContainer (#EADDFF)
Icon color:       colorOnPrimaryContainer (#21005D)
Position:         16dp from right edge, 16dp from bottom edge (above nav bar)
```

iOS equivalent: there is no native FAB. Implement as a custom overlay button, 56pt circle, with `.shadow(radius: 8)`. Place 16pt from trailing edge, above tab bar.

### Icon Buttons

```
Touch target:     48dp × 48dp (Android) / 44pt × 44pt (iOS)
Icon size:        24dp / 20pt
Visual size:      40dp circle or square (smaller than touch target)
Variants:         Standard (no bg), Filled, Tonal, Outlined
```

No label — icon must be universally recognizable (use tooltip / long-press label for accessibility).

### Loading State Pattern

When a button triggers an async action:

1. Button stays the same width and height (prevents layout shift)
2. Label text fades out, replaced by a centered spinner
3. Button becomes non-interactive (disabled state without dimming)
4. On completion: spinner fades out, label returns (or transitions to success icon briefly)

```
// Android Compose
Button(
    onClick = { },
    enabled = !isLoading
) {
    if (isLoading) CircularProgressIndicator(modifier = Modifier.size(20.dp), strokeWidth = 2.dp)
    else Text("Submit")
}
```

```swift
// SwiftUI
Button {
    // action
} label: {
    if isLoading { ProgressView().tint(.white) }
    else { Text("Submit") }
}
.disabled(isLoading)
```

### Minimum Touch Targets

| Platform | Minimum | Recommendation | Source |
|---|---|---|---|
| Android | 48 × 48 dp | 48dp for all interactive elements | Material Design 3 Accessibility |
| iOS | 44 × 44 pt | 44pt minimum, Apple enforces in review | Apple HIG Hit Targets |
| WCAG 2.2 | 24 × 24 CSS px | Target Size (Minimum) Level AA | WCAG 2.2 SC 2.5.8 |

Even if the visual element is smaller (e.g., 24dp icon), the tappable area must extend to the minimum. Use `Modifier.padding()` or `contentShape(Rectangle())` to expand hit area.

### Button Placement Conventions

| Context | Primary position | Secondary position |
|---|---|---|
| Full-screen form | Bottom sticky bar, full width | Text button left of primary |
| Dialog | Bottom-right (Android) / bottom stack (iOS) | Left of primary (Android), top of stack (iOS) |
| Card action area | Bottom-right of card | Left of primary in same row |
| Toolbar | Trailing edge | Leading edge |
| Onboarding | Bottom center, full width | "Skip" as text button top-right |

**Sources:** Material Design 3 Buttons documentation (m3.material.io/components/buttons), Apple Human Interface Guidelines — Buttons (developer.apple.com/design/human-interface-guidelines/buttons), Material Design 3 FAB documentation, WCAG 2.2 Success Criterion 2.5.8 Target Size.

---

## CT. Shadow & Elevation Practical System

Cross-platform elevation system with exact values for Android (tonal elevation), iOS (drop shadows), and Flutter (BoxShadow). Elevation creates visual hierarchy by implying which surfaces sit "above" others.

### Android M3: Tonal Elevation (Not Shadows)

Material 3 moved away from drop shadows. Elevation is now communicated via **surface tint** — higher surfaces get a slight primary color overlay.

| Level | Elevation | Surface Tint Opacity | Use Cases |
|---|---|---|---|
| Level 0 | 0dp | 0% | Flat background, scaffold |
| Level 1 | 1dp | 5% primary | Cards at rest, top app bar (scrolled), bottom app bar |
| Level 2 | 3dp | 8% primary | FAB at rest, elevated cards, bottom sheet (peek) |
| Level 3 | 6dp | 11% primary | FAB pressed, navigation drawer, expanded bottom sheet |
| Level 4 | 8dp | 12% primary | Menus, sub-menus |
| Level 5 | 12dp | 14% primary | Dialogs, modals, full-screen bottom sheets |

**How tonal elevation works in practice:**

```kotlin
// Jetpack Compose — M3 Surface with tonalElevation
Surface(
    tonalElevation = 3.dp,    // Level 2 — gets 8% primary tint
    shape = RoundedCornerShape(12.dp)
) {
    // Card content
}
```

The system automatically blends `colorPrimary` into `colorSurface` at the specified opacity. In dark mode, this is the primary way to distinguish layers (since shadows are barely visible on dark backgrounds).

**When M3 still uses shadows:**
- `shadowElevation` can be applied separately for legacy compatibility
- Some components (FAB, dialogs) still render a subtle shadow alongside tonal elevation for extra depth
- Shadows remain useful for elements that float over scrolling content (to separate layers clearly)

### iOS: Shadow-Based Elevation

iOS uses drop shadows exclusively. There is no tonal elevation system.

#### Subtle — Cards, List Sections

```swift
.shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
```
```
UIKit: layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.1
       layer.shadowRadius = 3
       layer.shadowOffset = CGSize(width: 0, height: 1)
```

Use for: cards in a scrollable feed, grouped table sections, slightly raised containers.

#### Medium — Popovers, Floating Elements

```swift
.shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 2)
```
```
UIKit: layer.shadowOpacity = 0.15
       layer.shadowRadius = 8
       layer.shadowOffset = CGSize(width: 0, height: 2)
```

Use for: popovers, dropdown menus, floating action buttons, tooltips.

#### Prominent — Modals, Sheets

```swift
.shadow(color: Color.black.opacity(0.2), radius: 24, x: 0, y: 8)
```
```
UIKit: layer.shadowOpacity = 0.2
       layer.shadowRadius = 24
       layer.shadowOffset = CGSize(width: 0, height: 8)
```

Use for: modal sheets, full-screen overlays, photo viewers, dialogs.

#### iOS Material Blur Effects

iOS also uses blur materials for elevation, especially in system UI:

```swift
.background(.ultraThinMaterial)    // very subtle blur, most transparent
.background(.thinMaterial)          // light blur
.background(.regularMaterial)       // default system blur (nav bars, tab bars)
.background(.thickMaterial)         // heavy blur
.background(.ultraThickMaterial)   // most opaque blur
```

These adapt automatically to light/dark mode. Use for: overlays over scrolling content, navigation bars, tab bars, status bar backgrounds.

### Flutter BoxShadow Equivalents

```dart
// Card (subtle)
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 4,
  offset: const Offset(0, 1),
  spreadRadius: 0,
)

// Elevated component (medium)
BoxShadow(
  color: Colors.black.withOpacity(0.12),
  blurRadius: 8,
  offset: const Offset(0, 2),
  spreadRadius: 0,
)

// Modal / dialog (prominent)
BoxShadow(
  color: Colors.black.withOpacity(0.16),
  blurRadius: 24,
  offset: const Offset(0, 8),
  spreadRadius: 0,
)

// Flutter Card widget built-in
Card(elevation: 1)   // subtle
Card(elevation: 4)   // medium
Card(elevation: 8)   // prominent
```

### Dark Mode Shadow Adjustments

Shadows are barely perceptible on dark backgrounds. Adjust your strategy:

| Technique | Light Mode | Dark Mode |
|---|---|---|
| Shadow opacity | 0.08–0.20 | Reduce by 50% → 0.04–0.10 |
| Primary elevation cue | Shadow | Surface color differentiation |
| Border separation | Not needed (shadow suffices) | Add 1dp border `rgba(255,255,255,0.08)` |
| Blur backdrop | `.regularMaterial` | System auto-adapts material |
| Android tonal elevation | Subtle effect | More visible (primary tint on dark surface) |

**Dark mode surface color ladder (Android M3):**
```
Level 0:  #121212  (background)
Level 1:  #1E1E1E  (cards, app bar)       — +5% white or primary tint
Level 2:  #232323  (elevated cards)        — +8%
Level 3:  #282828  (navigation drawer)     — +11%
Level 4:  #2C2C2C  (menus)                — +12%
Level 5:  #353535  (dialogs)               — +14%
```

### Performance Considerations

- Shadows are GPU-rendered; excessive shadows on long lists cause jank
- On iOS, always set `layer.shadowPath = UIBezierPath(roundedRect:cornerRadius:).cgPath` for cached shadow rendering
- On Android Compose, `tonalElevation` has zero GPU cost (it's a color calculation, not a rendered shadow)
- In Flutter, `PhysicalModel` is more performant than `BoxShadow` for simple rectangular shadows
- Limit shadows to 3–5 elements visible at once; flat design for list items in feeds

**Sources:** Material Design 3 Elevation documentation (m3.material.io/styles/elevation), Apple Human Interface Guidelines — Materials (developer.apple.com/design/human-interface-guidelines/materials), Flutter BoxShadow API documentation.

---

## CU. Border Radius Consolidated System

A systematic radius scale for mobile, with platform-specific defaults, the nested radius rule, and guidance on picking a consistent set for your app.

### The Radius Scale

| Value | Name | Use Cases |
|---|---|---|
| **0dp/pt** | Sharp | Table cells, full-bleed images, dividers, edge-to-edge banners |
| **4dp/pt** | XSmall | Small chips, badges, inline tags, progress bar corners, small avatars (square style) |
| **8dp/pt** | Small | Buttons (Android M3 default for small components), input fields, small cards, toast/snackbar, thumbnails |
| **12dp/pt** | Medium | Cards (M3 default), search bars, bottom sheet peek handle area, navigation bar items, segmented controls (Android) |
| **16dp/pt** | Large | FAB, large cards, widget containers, image placeholders, dialog body (iOS default ~14pt) |
| **20dp/pt** | XLarge / Pill | Full pill buttons (height/2 for 40dp button), pill-shaped chips, segmented controls (iOS), tags |
| **28dp/pt** | XXLarge | Modal bottom sheet top corners (M3), dialog corners (M3), large modal containers |
| **Full (50%)** | Circle | Avatars, icon button backgrounds, FAB (circular variant), status indicators |

### Platform Default Mappings

**Android M3 Shape System:**

```kotlin
// MaterialTheme.shapes (Compose defaults)
val Shapes = Shapes(
    extraSmall = RoundedCornerShape(4.dp),    // Chips, small badges
    small = RoundedCornerShape(8.dp),          // Buttons, text fields
    medium = RoundedCornerShape(12.dp),        // Cards, dialogs
    large = RoundedCornerShape(16.dp),         // Large cards, FAB
    extraLarge = RoundedCornerShape(28.dp),    // Bottom sheets, large dialogs
)
```

**iOS System Defaults:**

```swift
// Common iOS corner radii (points)
let buttonRadius: CGFloat = 10        // system buttons (.borderedProminent)
let cardRadius: CGFloat = 12          // grouped table section
let textFieldRadius: CGFloat = 10     // system text field
let sheetRadius: CGFloat = 10         // modal sheet top corners
let alertRadius: CGFloat = 14         // system alert dialog
let notificationRadius: CGFloat = 20  // notification banner
let appIconRadius: CGFloat = /*continuous*/ // ~22.37% of icon size
```

### iOS Continuous Corners (Squircle)

iOS uses a **continuous** (superellipse) corner curve, not circular arcs. The difference is subtle but visible at larger radii:

```swift
// SwiftUI — continuous corner (matches system UI)
RoundedRectangle(cornerRadius: 16, style: .continuous)

// UIKit
view.layer.cornerRadius = 16
view.layer.cornerCurve = .continuous    // iOS 13+
```

Circular corners have a hard transition from flat edge to curve. Continuous corners have a gradual onset, appearing more natural. Always use `.continuous` on iOS for parity with system elements.

Android does not have a native continuous corner — `RoundedCornerShape` uses circular arcs. For pixel-perfect cross-platform consistency, consider a custom `Shape` in Compose using a superellipse path.

### The Nested Radius Rule

When elements are nested (e.g., a button inside a card), the inner element's radius should be reduced by the padding between them:

```
Inner radius = Outer radius − Padding

Card radius:     16dp
Card padding:    12dp
Button radius:   16 - 12 = 4dp  ✓

Card radius:     12dp
Card padding:    8dp
Content radius:  12 - 8 = 4dp  ✓
```

**Why this matters:** If inner and outer radii are the same, the gap between the inner element and outer boundary appears uneven — wider at the corners, tighter on the straights. The nested rule makes the gap optically uniform.

Visual validation: if the padding is greater than the outer radius, set inner radius to 0 (sharp corners). If negative, clamp to 0.

```
Example that breaks:
Card radius:     8dp
Card padding:    16dp
Inner radius:    8 - 16 = -8 → clamp to 0dp (sharp)
```

### Choosing Your App's Radius Set

Pick **3 to 4 values maximum** and use them everywhere for visual consistency:

**Option A — Rounded Modern (most common):**
```
Small:   8dp/pt   → buttons, inputs, chips, toasts
Medium: 12dp/pt   → cards, search bar, list sections
Large:  20dp/pt   → pill buttons, FAB, prominent CTAs
Sheet:  28dp/pt   → bottom sheet top corners, modals
```

**Option B — Soft / Friendly:**
```
Small:  12dp/pt   → buttons, inputs
Medium: 16dp/pt   → cards, containers
Large:  24dp/pt   → prominent elements
Sheet:  32dp/pt   → modals
```

**Option C — Sharp / Professional:**
```
Small:   4dp/pt   → buttons, inputs
Medium:  8dp/pt   → cards
Large:  12dp/pt   → containers
Sheet:  16dp/pt   → modals
```

### Per-Corner Radius

Some elements need asymmetric radii:

```kotlin
// Android Compose — top corners only (bottom sheet)
RoundedCornerShape(topStart = 28.dp, topEnd = 28.dp, bottomStart = 0.dp, bottomEnd = 0.dp)
```

```swift
// SwiftUI — custom UnevenRoundedRectangle (iOS 17+)
UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)

// Pre-iOS 17: use Path with addArc
```

Common uses:
- Bottom sheet: top corners rounded, bottom sharp (attached to screen edge)
- Top app bar on scroll: bottom corners rounded for a floating effect
- First/last card in a group: outer corners rounded, inner edges sharp (like iOS grouped table style)

### Radius and Shadows Interaction

Shadows follow the corner radius of the element. Ensure:
- `clipToBounds` / `clipsToBounds` does NOT clip the shadow (shadow renders outside bounds)
- On iOS, set `layer.masksToBounds = false` for shadow visibility with rounded corners
- On Android Compose, `Modifier.shadow(elevation, shape)` automatically matches shape
- Large radii with large shadows look best; small radii with large shadows look disproportionate

**Sources:** Material Design 3 Shape documentation (m3.material.io/styles/shape), Apple Human Interface Guidelines — Layout (developer.apple.com/design/human-interface-guidelines/layout), iOS UIKit cornerCurve documentation, Material Design 3 ShapeDefaults reference.

---

## CV. Input Field States Complete Matrix

Every input field state with platform-specific exact values, covering outlined and filled variants, validation patterns, and helper text anatomy.

### Default State

**Android M3 — Outlined TextField:**
```
Border:           1dp solid colorOutline (#79747E)
Background:       transparent
Corner radius:    4dp (top) — labeled variant uses 4dp so label can sit on border
Label:            body-large (16sp), colorOnSurfaceVariant, positioned inside field
Text:             body-large (16sp), colorOnSurface (#1C1B1F)
Cursor:           colorPrimary (#6750A4)
Height:           56dp (single-line, including label)
Padding:          16dp horizontal
```

**Android M3 — Filled TextField:**
```
Background:       colorSurfaceVariant (#E7E0EC)
Bottom border:    1dp solid colorOnSurfaceVariant (#49454F)
Top corners:      4dp radius (bottom corners 0dp — flat base)
Label:            body-large, colorOnSurfaceVariant, inside field
Text:             body-large, colorOnSurface
Height:           56dp
Padding:          16dp horizontal, 8dp top (above text, below label)
```

**iOS:**
```swift
TextField("Placeholder", text: $value)
    .textFieldStyle(.roundedBorder)
// System renders:
Background:       .secondarySystemGroupedBackground (light gray #F2F2F7 light / #1C1C1E dark)
Border:           none visible (integrated into background)
Corner radius:    10pt
Text:             .body (17pt), Color(.label)
Height:           ~44pt
Padding:          8pt horizontal system default
Placeholder:      Color(.placeholderText) — #C7C7CC light / #636366 dark
```

### Focused State

**Android M3 — Outlined:**
```
Border:           2dp solid colorPrimary (#6750A4)  — doubles from 1dp to 2dp
Label:            animates UP to sit on top border line, shrinks to body-small (12sp)
Label color:      colorPrimary (#6750A4)
Caret:            colorPrimary, blinking
Active indicator: the 2dp border itself serves as active indicator
```

**Android M3 — Filled:**
```
Bottom border:    2dp solid colorPrimary (#6750A4)  — doubles from 1dp to 2dp
Background:       slightly darker (opacity shift)
Label:            animates up, shrinks to 12sp
Label color:      colorPrimary
```

**iOS:**
```
Visual change:    minimal — cursor appears, keyboard slides up
Ring:             no border change by default; custom implementations may add a tint
Keyboard:         animates up, content scrolls/resizes to avoid occlusion
Auto-scroll:      system automatically scrolls the focused field into view
```

### Error State

**Android M3:**
```
Border/underline: colorError (#B3261E) — replaces primary color
Border width:     2dp (same as focused, but error color)
Label:            colorError
Supporting text:  body-small (12sp), colorError, below field, 4dp gap
Trailing icon:    error icon (24dp, colorError) — exclamation mark in circle
```

**iOS:**
```swift
TextField("Email", text: $email)
    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 1))

Text("Please enter a valid email address")
    .font(.caption)       // 12pt
    .foregroundColor(.red)
```

**Error text formula — always include both what's wrong AND how to fix:**
```
Bad:   "Invalid input"
Good:  "Email must include @ and a domain (e.g., name@example.com)"

Bad:   "Password error"
Good:  "Password must be at least 8 characters with one uppercase letter"

Bad:   "Invalid phone"
Good:  "Enter a 10-digit phone number (e.g., 514-555-0123)"
```

### Disabled State

**Android M3:**
```
All elements:     38% opacity (border, label, text, icons)
Background:       filled variant gets 4% colorOnSurface overlay
No interaction:   no focus, no hover, no ripple
Cursor:           hidden
```

**iOS:**
```swift
TextField("Field", text: $value)
    .disabled(true)
// System applies:
//   - Dimmed appearance (reduced opacity)
//   - Text color shifts to .secondaryLabel
//   - No keyboard activation on tap
```

### Read-Only State (Distinct from Disabled)

Shows a value the user cannot edit but should be able to copy:
- Visual: looks like a default field but with no cursor and no keyboard activation
- Interaction: long-press to copy (iOS), long-press to select and copy (Android)
- Styling: slightly dimmed label, full-opacity text value, no underline/border animation

### Helper / Supporting Text

```
Position:         below the field, 4dp gap (Android) / 4pt gap (iOS)
Font:             body-small 12sp (Android) / .caption 11pt (iOS)
Color:            colorOnSurfaceVariant / .secondaryLabel
Max lines:        1-2 (keep brief; truncate with "..." if needed)
```

Use for: format hints ("MM/DD/YYYY"), character limits, input requirements visible before error.

### Character Counter

```
Position:         right-aligned within the helper text row
Format:           "23/100" (current / max)
Default color:    colorOnSurfaceVariant
Error color:      colorError — when count exceeds max
```

```kotlin
// Compose
OutlinedTextField(
    value = text,
    onValueChange = { if (it.length <= 100) text = it },
    supportingText = {
        Text("${text.length}/100",
             modifier = Modifier.fillMaxWidth(),
             textAlign = TextAlign.End)
    },
    isError = text.length > 100
)
```

### Leading & Trailing Icons

```
Icon size:        24dp (Android) / 20pt (iOS)
Leading icon:     padding-start 12dp from field edge, indicates field purpose (search, email, phone)
Trailing icon:    padding-end 12dp, tappable for actions:
                  - Clear (X): appears when field has text, taps clear text
                  - Visibility toggle: eye icon, toggles password visibility
                  - Info (i): shows tooltip or help sheet on tap
                  - Error: exclamation, shown in error state (not tappable)
Touch target:     48dp × 48dp for trailing tappable icons (even if icon is 24dp)
```

```swift
// SwiftUI trailing clear button
TextField("Search", text: $query)
    .overlay(alignment: .trailing) {
        if !query.isEmpty {
            Button { query = "" } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .padding(.trailing, 8)
        }
    }
```

### Prefix & Suffix Text

Inline text indicating format or unit:

```
Prefix:           "$", "+1", "https://"  — before user input
Suffix:           "kg", "cm", ".com"     — after user input
Color:            colorOnSurfaceVariant (#49454F) / .secondaryLabel
Font:             same as input text (body-large 16sp / .body 17pt)
Padding:          4dp gap between prefix/suffix and user text
```

```kotlin
OutlinedTextField(
    value = amount,
    onValueChange = { amount = it },
    prefix = { Text("$") },
    suffix = { Text("USD") },
    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
)
```

### Input Field Sizing

| Variant | Height | Use Case |
|---|---|---|
| Single-line | 56dp / 44pt | Email, name, phone, search, short inputs |
| Multi-line (expanding) | 56dp min, grows with content | Comments, notes, up to maxLines |
| Text area (fixed) | 112dp+ (multiple rows visible) | Descriptions, long-form, feedback |

### Complete State Transition Table

```
                DEFAULT  →  FOCUSED  →  TYPING  →  BLUR (validate)
                                                     ↓
                                              VALID (success) or ERROR
                                                                  ↓
                                              ERROR  →  FOCUSED (re-edit)  →  TYPING  →  BLUR
                                                                                          ↓
                                                                                    VALID ✓
```

Validate on blur (field exit), NOT on every keystroke. Exception: format-as-you-type fields (phone, credit card) can validate format live.

**Sources:** Material Design 3 Text Fields documentation (m3.material.io/components/text-fields), Apple Human Interface Guidelines — Text Fields (developer.apple.com/design/human-interface-guidelines/text-fields), Material Design 3 component specifications, WCAG 2.1 SC 3.3.1 Error Identification.

---

## CW. Spacing Decision Framework

When to use which spacing value, with exact platform-specific numbers. All spacing is based on a 4dp/pt base grid.

### The 4dp/pt Base Grid

Every spacing value should be a multiple of 4. The most common values:

```
4dp/pt    — tight: icon-to-label gap, badge offset, inline spacing
8dp/pt    — standard: default gap between related elements
12dp/pt   — comfortable: list item vertical padding, paragraph spacing
16dp/pt   — spacious: screen edge padding, card internal padding, section separation
24dp/pt   — section: major section breaks, dialog padding, generous card padding
32dp/pt   — large: between major content groups, hero-to-content gap
48dp/pt   — extra-large: between unrelated content blocks
```

Avoid: 5, 6, 7, 9, 10, 11, 13, 14, 15, 17, 18, 19... Non-grid values create visual inconsistency and make design tokens harder to maintain.

### Padding (Space Inside a Container)

#### Buttons

| Platform | Vertical | Horizontal | Source |
|---|---|---|---|
| Android M3 (filled) | 10dp | 24dp | Material specs |
| Android M3 (text) | 10dp | 12dp | Material specs |
| iOS (.borderedProminent) | ~11pt | ~20pt | System default |
| iOS (.bordered) | ~7pt | ~16pt | System default |

#### Cards

| Density | Padding | Use Case |
|---|---|---|
| Compact | 12dp/pt | Feed cards, high-density lists, dashboard widgets |
| Standard | 16dp/pt | Default card padding, most use cases |
| Spacious | 24dp/pt | Detail screens, hero cards, onboarding cards |

#### List Items

```
Horizontal padding:     16dp (Android) / 20pt (iOS, system default inset)
Vertical padding:
  - Single-line:        8dp/pt top + 8dp/pt bottom = 48dp total height (M3)
  - Two-line:           12dp top + 12dp bottom (with secondary text)
  - Three-line:         16dp top + 16dp bottom
Leading content gap:    16dp (icon/avatar to text)
Trailing content gap:   16dp (text to trailing icon/action)
```

#### Screen Edges

```
Android:                16dp left/right standard margin
iOS:                    20pt leading/trailing (matches system readableContentGuide)
                        16pt in compact layouts
Tablets:                24dp or dynamic max-width container (600dp max content width)
```

#### Section Content

```
Between sections:       24dp/pt vertical spacing (heading to next heading)
Heading to content:     8dp/pt (tight relationship)
Section header padding: 16dp horizontal, 12dp vertical
```

#### Modal / Dialog

```
Android M3 Dialog:      24dp all sides padding
iOS Alert:              system-managed (≈16pt, non-customizable)
iOS Sheet:              20pt horizontal, 24pt top
Bottom sheet content:   16dp horizontal, 16dp vertical from handle
```

### Margin (Space Between Sibling Elements)

#### Between Cards

| Style | Gap | Visual Effect |
|---|---|---|
| Tight feed | 8dp/pt | Dense, content-heavy (social feeds, news) |
| Default | 12dp/pt | Balanced, most card layouts |
| Spacious | 16dp/pt | Breathing room, premium feel, portfolios |

#### Between Form Fields

```
Vertical gap:           16dp/pt between fields (enough to visually separate)
Grouped fields:         8dp/pt between related fields in same group (e.g., first name / last name)
Group to group:         24dp/pt (visual section break)
Label to field:         4dp (when label is external, above field)
Field to helper text:   4dp
Helper text to next field: 16dp (from baseline of helper to top of next field)
```

#### Typography Spacing

```
Heading to body:        8dp/pt (tight, clearly associated)
Paragraph to paragraph: 12dp/pt
Body to CTA:            24dp/pt (breathing room before action)
```

### Gap (Flex/Row/Column Spacing)

#### Icon + Label Combinations

```
Standard (button):      8dp/pt icon-to-label gap
Compact (tab bar item): 4dp/pt icon-to-label gap (vertical stack)
List item leading:      16dp icon-to-text gap
Navigation rail:        4dp icon-to-label (vertical)
```

#### Button Groups

```
Horizontal row:         8dp/pt between buttons
Vertical stack:         8dp/pt between stacked full-width buttons
Action bar (dialog):    8dp between text buttons
```

#### Lists and Grids

```
List items (divider):   0dp gap (use dividers for separation)
List items (card):      8dp/pt gap (card-style list with visible gaps)
Grid items compact:     8dp both axes
Grid items spacious:    16dp both axes
Staggered grid:         8dp (consistent gaps despite varying item heights)
```

### Critical Clearances

#### Bottom Navigation Clearance

```
Content above nav bar:  80dp/pt minimum clearance
Why: last scrollable item must be fully visible above the nav bar (56dp) + padding (24dp)
Implementation:
  - Android: Scaffold handles this with innerPadding
  - iOS: TabView handles via safeAreaInsets
  - Flutter: Scaffold.bottomNavigationBar handles it, OR add SizedBox(height: 80) at list end
```

#### Keyboard Avoidance

```
Android:                windowSoftInputMode="adjustResize" in manifest (content resizes)
iOS:                    system auto-scrolls focused field above keyboard
Flutter:                Scaffold.resizeToAvoidBottomInset = true (default)
Best practice:          focused field should be 16dp above keyboard top edge
Never:                  let keyboard cover the active field or submit button
```

#### Safe Area Respect

```swift
// SwiftUI — always use SafeArea
var body: some View {
    ScrollView {
        content
    }
    .safeAreaInset(edge: .bottom) {
        bottomBar  // pinned above home indicator
    }
}
```

```kotlin
// Compose — use WindowInsets
Scaffold(
    modifier = Modifier.fillMaxSize(),
    contentWindowInsets = WindowInsets.safeDrawing
) { innerPadding ->
    Content(modifier = Modifier.padding(innerPadding))
}
```

```dart
// Flutter
SafeArea(
  child: Scaffold(
    body: content,
  ),
)
```

**Never hardcode** notch height (44pt), home indicator height (34pt), or status bar height (20/44pt). These vary by device. Always use system-provided safe area insets.

### Spacing Decision Cheat Sheet

When you're unsure which value to use, ask:

| Question | Answer → Value |
|---|---|
| Are these elements part of the same component? | Yes → 4–8dp |
| Are they related but distinct? | Yes → 12–16dp |
| Are they in different sections? | Yes → 24–32dp |
| Are they unrelated content blocks? | Yes → 32–48dp |
| Is this screen edge padding? | → 16dp (Android) / 20pt (iOS) |
| Is this inside a dialog/modal? | → 24dp all sides |
| Is this a touch target gap? | → min 8dp between targets (to prevent mis-taps) |

### Common Spacing Anti-Patterns

- **Inconsistent margins**: 12dp here, 15dp there, 18dp elsewhere — pick from the 4dp grid and stick to it
- **No breathing room before CTA**: text crammed right against the submit button — add 24dp minimum
- **Ignoring safe areas**: content hidden behind notch or home indicator
- **Hardcoded bottom padding**: using fixed 34pt for home indicator — breaks on devices without one
- **Zero spacing between tap targets**: adjacent buttons/links touching — minimum 8dp gap between interactive elements
- **Over-spacing on mobile**: desktop-like 48dp margins waste precious vertical space on mobile

**Sources:** Material Design 3 Layout documentation (m3.material.io/foundations/layout), Apple Human Interface Guidelines — Layout (developer.apple.com/design/human-interface-guidelines/layout), Material Design 3 spacing and component specs, Flutter SafeArea documentation, Android WindowInsets documentation.

---

## CX. iOS 19 & Liquid Glass Design Language

Apple's major visual overhaul announced at WWDC 2025 introduces Liquid Glass — a new glassmorphism-inspired design language that replaces the previous flat/material aesthetic across all Apple platforms. This is the most significant visual change since iOS 7's shift from skeuomorphism to flat design.

### Liquid Glass Visual System

**Core concept:** glass material is translucent, depth-aware, and adapts to the content behind it. Unlike a simple blur overlay, Liquid Glass dynamically responds to what's beneath, creating a sense of physical layering.

**Key properties of the glass material:**
- Translucency varies based on the element's role and depth in the view hierarchy
- Colors from content behind the glass surface bleed through, affecting the tint
- Blur radius is variable: ~8pt for foreground glass, ~24pt for background glass
- Specular highlights at glass edges create a subtle 3D "lens" effect
- Glass elements cast soft shadows to reinforce depth perception
- The material responds to device tilt via accelerometer for a parallax-like effect on supported devices

**Where glass appears by default:**
- Tab bars: fully glass material, content scrolls behind them
- Navigation bars: glass material, with title text adapting contrast
- Sidebars (iPad): glass with grouped list style, rounded section backgrounds
- Toolbars: glass material replaces previous blurred backgrounds
- Alerts and sheets: glass background with increased blur
- Popovers: glass material with rounded corners and shadow

**SwiftUI glass modifier:**
```swift
// Apply glass material to any view
myView
    .glassEffect()

// Glass with custom configuration
myView
    .glassEffect(.regular)     // Standard glass
    .glassEffect(.thin)        // More transparent, less blur
    .glassEffect(.thick)       // More opaque, more blur
    .glassEffect(.ultraThin)   // Maximum transparency

// Glass with tint color
myView
    .glassEffect(.regular.tint(.blue))
```

**UIKit glass material:**
```swift
// UIKit equivalent using visual effect views
let glassEffect = UIVisualEffectView(effect: UIBlurEffect(style: .systemGlass))
glassEffect.frame = containerView.bounds
containerView.addSubview(glassEffect)
```

**High contrast mode:** glass becomes fully opaque to ensure readability. Always test your glass surfaces with Settings → Accessibility → Increase Contrast enabled. System colors automatically adapt: label colors darken, backgrounds become solid.

**Dark mode interaction:** glass material in dark mode uses a darker base with lighter blur. The bleed-through effect is subtler to avoid distracting color shifts. Test both light and dark mode over varied backgrounds.

### Navigation Changes in iOS 19

**Fluid navigation transitions:**
- Default transition duration: 400ms with spring-based curve (damping ratio 0.85)
- Push/pop transitions: views slide with parallax depth — pushed view enters faster than popped view exits
- Shared element transitions integrated with NavigationLink
- Interactive swipe-back gesture has improved velocity tracking

**Tab bar redesign:**
- Tab bar items use glass pill backgrounds on the selected item
- SF Symbols animate on selection (bounce, variable color, or replace effect)
- Badge positioning adjusted for the pill shape
- Tab bar height increased to 52pt (was 49pt) to accommodate glass material
- More than 5 tabs: "More" tab still exists, but overflow tabs can be reordered with drag

```swift
TabView {
    Tab("Home", systemImage: "house.fill") {
        HomeView()
    }
    Tab("Search", systemImage: "magnifyingglass") {
        SearchView()
    }
    // Symbol animation on tab selection is automatic in iOS 19
}
.tabViewStyle(.tabBarOnly)    // Glass tab bar (default)
.tabViewStyle(.sidebarAdaptable) // Glass sidebar on iPad
```

**Navigation bar glass behavior:**
- Large title: title is opaque, navigation bar background is clear
- On scroll: title shrinks to inline, glass material fades in behind the bar
- Transition is continuous — no sudden opacity jump
- `.toolbarBackgroundVisibility(.visible)` forces glass to always show

### SwiftUI iOS 19 New & Expanded APIs

**MeshGradient (introduced iOS 18, expanded iOS 19):**
```swift
// Create organic, flowing gradients with control points
MeshGradient(
    width: 3, height: 3,
    points: [
        .init(0, 0), .init(0.5, 0),   .init(1, 0),
        .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
        .init(0, 1), .init(0.5, 1),   .init(1, 1)
    ],
    colors: [
        .red, .orange, .yellow,
        .green, .mint, .cyan,
        .blue, .indigo, .purple
    ]
)
// iOS 19: animated MeshGradient with keyframes
// iOS 19: MeshGradient as background material for glass
```

**Visual effects based on scroll position:**
```swift
ScrollView {
    ForEach(items) { item in
        ItemCard(item: item)
            .visualEffect { content, proxy in
                content
                    .opacity(proxy.isVisible ? 1 : 0.3)
                    .scaleEffect(proxy.isVisible ? 1 : 0.8)
                    .blur(radius: proxy.isVisible ? 0 : 5)
            }
    }
}
```

**Scroll transitions for enter/leave animations:**
```swift
ScrollView {
    ForEach(items) { item in
        ItemRow(item: item)
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0)
                    .offset(y: phase.isIdentity ? 0 : 30)
                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
            }
    }
}
```

**ContainerRelativeFrame (replaces many GeometryReader hacks):**
```swift
ScrollView(.horizontal) {
    HStack {
        ForEach(cards) { card in
            CardView(card: card)
                .containerRelativeFrame(.horizontal, count: 3, spacing: 16)
                // Card takes 1/3 of scroll view width minus spacing
        }
    }
}
```

**Declarative haptics:**
```swift
Button("Add to Cart") { addItem() }
    .sensoryFeedback(.impact(weight: .medium), trigger: cartCount)

Toggle("Notifications", isOn: $enabled)
    .sensoryFeedback(.selection, trigger: enabled)

// Available feedback types: .impact, .selection, .success, .warning, .error,
// .increase, .decrease, .start, .stop, .alignment, .levelChange
```

**@Observable macro improvements:**
```swift
// iOS 17+: simpler than ObservableObject + @Published
@Observable
class AppState {
    var username = ""           // Automatically observed
    var isLoggedIn = false      // No @Published needed
    var items: [Item] = []     // Changes trigger view updates
}

// In views — no @ObservedObject wrapper needed
struct ContentView: View {
    var state: AppState    // Just a regular property
    var body: some View {
        Text(state.username)   // Automatically subscribes
    }
}
```

### Migration Notes for Liquid Glass

**Automatic adoption:**
- Apps using system UINavigationBar, UITabBar, UIToolbar get glass automatically
- No code changes needed if using standard SwiftUI NavigationStack and TabView
- System colors (`.label`, `.systemBackground`, `.secondarySystemBackground`) adapt to glass

**Custom tab bars — adopting glass:**
```swift
// If you use a custom tab bar, adopt system glass:
.toolbar {
    ToolbarItem(placement: .bottomBar) {
        CustomTabContent()
    }
}
.toolbarBackgroundVisibility(.visible)
.toolbarBackground(.glass)
```

**Testing checklist for glass migration:**
- [ ] Test glass over photo/image backgrounds — text must remain readable
- [ ] Test over solid color backgrounds (white, black, bright colors)
- [ ] Test with Dynamic Type at all sizes — large text over glass needs contrast
- [ ] Test with Increase Contrast accessibility setting
- [ ] Test with Reduce Transparency setting (glass should degrade to solid)
- [ ] Test in both light and dark mode
- [ ] Test on older devices (iPhone XR, SE 3rd gen) — glass uses GPU compositing

**Performance considerations:**
- Glass material uses real-time GPU compositing with multi-pass rendering
- On older devices (A12–A14), heavy glass stacking can cause frame drops
- Avoid stacking more than 2–3 glass layers simultaneously
- If animating content behind glass, ensure 60fps by profiling with Instruments → GPU
- Consider `.drawingGroup()` modifier to flatten complex view hierarchies before glass

**Text contrast over glass:**
- Always use system label colors — they automatically increase contrast over glass
- Never use custom colors with opacity < 1.0 for text over glass
- For custom overlays, add `.background(.ultraThinMaterial)` before glass for a "double layer" effect that improves readability
- Minimum contrast ratio over glass: 4.5:1 (WCAG AA) — test with Accessibility Inspector

**Sources:** Apple WWDC 2025 sessions (What's New in SwiftUI, Design with Liquid Glass, Migrate to Liquid Glass), Apple Human Interface Guidelines iOS 19 updates, Apple Developer Documentation — SwiftUI glass modifiers, UIKit UIBlurEffect.Style.systemGlass.

---

## CY. Apple Intelligence & AI UX Patterns

On-device AI capabilities introduced across Apple platforms starting with iOS 18.1 (December 2024), expanding through iOS 18.4 and iOS 19. All Apple Intelligence features run on the Apple Neural Engine (ANE), keeping user data on-device. For tasks exceeding on-device capacity, Private Cloud Compute extends processing to Apple Silicon servers with cryptographic privacy guarantees.

### Writing Tools — System-Wide Text AI

**What it is:** AI-powered text editing available in any app that uses standard text views (UITextView, UITextField, SwiftUI TextEditor, TextInput).

**Available actions:**
- **Proofread**: grammar, spelling, punctuation fixes with tracked-changes UI
- **Rewrite**: three tones — Friendly, Professional, Concise
- **Summary**: condense text to a short paragraph
- **Key Points**: extract main points as bullet list
- **List**: restructure as bulleted/numbered list
- **Table**: restructure as table (if data is suitable)
- **Compose**: generate text from a prompt (iOS 18.4+)

**How it appears to users:**
- Select text → context menu → "Writing Tools" submenu
- Or: select text → toolbar shows Writing Tools icon (wand)
- Full-screen Writing Tools panel on iPad/Mac, sheet on iPhone
- Changes shown as inline diff: red strikethrough for removed, blue for added

**Implementation for developers:**
```swift
// Standard text views: Writing Tools enabled by default
TextEditor(text: $content)
    // Writing Tools available automatically

// Opt out if inappropriate (e.g., code editors, password fields)
TextEditor(text: $content)
    .writingToolsBehavior(.disabled)

// Limit to specific behaviors
TextEditor(text: $content)
    .writingToolsBehavior(.limited) // Only proofread, no rewrite/summary
```

**UIKit opt-out:**
```swift
textView.writingToolsBehavior = .none       // Fully disabled
textView.writingToolsBehavior = .limited    // Proofread only
textView.writingToolsBehavior = .complete   // All features (default)
```

**UX rules for Writing Tools:**
- Never auto-apply AI changes — always show the diff/preview first
- The user explicitly accepts or rejects each change
- For custom text editors (Canvas-based, WebView-based): implement `WritingToolsCoordinator` to integrate properly
- If your app has its own AI text features, they coexist with Writing Tools — no conflict
- Test that your text view's undo/redo works correctly after Writing Tools edits

### Image Generation — Image Playground

**What it is:** On-device image generation from text descriptions, available as a system framework.

**Styles available:**
- **Animation**: 3D-rendered character style (Pixar-like)
- **Illustration**: flat illustration with bold colors
- **Sketch**: pencil/charcoal sketch style
- No photorealistic generation — Apple intentionally limits to artistic styles

**Implementation:**
```swift
import ImagePlayground

// Present Image Playground as a sheet
struct CreateImageView: View {
    @State private var showPlayground = false
    @State private var generatedImage: URL?

    var body: some View {
        Button("Create Image") {
            showPlayground = true
        }
        .imagePlaygroundSheet(
            isPresented: $showPlayground,
            concepts: [
                .text("A golden retriever wearing a party hat"),
                .extracted(from: sourceImage, title: "Style reference")
            ]
        ) { url in
            generatedImage = url
        }
    }
}
```

**UIKit presentation:**
```swift
let controller = ImagePlaygroundViewController()
controller.concepts = [
    ImagePlaygroundConcept.text("Mountain landscape at sunset")
]
controller.delegate = self
present(controller, animated: true)

// Delegate callback
func imagePlaygroundViewController(
    _ controller: ImagePlaygroundViewController,
    didCreateImageAt url: URL
) {
    // Use the generated image
    let image = UIImage(contentsOfFile: url.path)
}
```

**UX guidelines for image generation:**
- Generation takes 5–30 seconds — show a progress indicator with animation
- Allow regeneration (user can tap "New Image" to get variations)
- Show the text prompt alongside the generated image for context
- Apple's safety filters block inappropriate content on-device — no developer action needed
- Generated images include EXIF metadata indicating AI generation
- Use cases: custom stickers, message illustrations, profile pictures, creative tools

### Genmoji — Custom Emoji Generation

**What it is:** AI-generated custom emoji from text descriptions, available through the standard emoji keyboard.

**Developer implications:**
- No API needed — Genmoji works in any standard text input
- Rendered as inline images, not Unicode emoji characters
- In text storage: represented as `NSAdaptiveImageGlyph` (attributed string attachment)
- Ensure your text rendering pipeline handles image attachments gracefully
- Fallback on older devices/platforms: displayed as image attachment or placeholder
- If your app sends text to a server: handle image attachments in your text serialization
- Rich text views (UITextView, TextEditor): Genmoji supported automatically
- Plain text fields (UITextField): Genmoji appears as image attachment in attributed text

**Testing considerations:**
- Test text input fields with Genmoji inserted at beginning, middle, end of text
- Test text truncation behavior with inline Genmoji
- Test copy/paste of text containing Genmoji between your app and others
- Test that your backend/API handles Genmoji data correctly (don't strip or corrupt it)

### Smart Notifications — Notification Summaries

**What it is:** iOS groups and summarizes multiple notifications from the same app into a concise summary using on-device language models.

**How it works:**
- When multiple notifications arrive from the same app, iOS may collapse them into a summary
- Summary uses notification titles, subtitles, and body text to generate a natural-language overview
- User can expand the summary to see individual notifications

**Developer best practices:**
```swift
// Prevent summarization for critical/time-sensitive notifications
let content = UNMutableNotificationContent()
content.title = "Your ride is arriving"
content.body = "Driver is 2 minutes away"
content.interruptionLevel = .timeSensitive  // Never summarized, always shown

// For messages: set thread identifier for proper grouping
content.threadIdentifier = "chat-\(conversationId)"

// Make titles self-contained — summaries rely heavily on title text
// BAD:  title: "New message"  body: "John said hello"
// GOOD: title: "John: Hello!" body: "John sent you a message in Team Chat"
```

**Summarization interaction levels:**
- `.passive` — may be summarized, delivered silently
- `.active` — may be summarized, delivered normally (default)
- `.timeSensitive` — never summarized, breaks through Focus modes
- `.critical` — never summarized, plays sound even when silenced (requires entitlement)

**Testing summaries:**
- Send 3+ notifications rapidly from your app to trigger summarization
- Long-press the summary → verify individual notifications are accessible
- Verify that the auto-generated summary is coherent and accurate for your notification content
- If summaries are poor quality, improve your notification title/body text

### Siri + App Intents — Voice-Driven Actions

**What it is:** Siri can now perform in-app actions through the App Intents framework, enabling voice commands that directly interact with your app.

**Implementation:**
```swift
import AppIntents

// Define an action Siri can perform
struct LogCigaretteIntent: AppIntent {
    static var title: LocalizedStringResource = "Log a Cigarette"
    static var description: IntentDescription = "Records a cigarette in your tracking history"

    // Parameters Siri will ask about if not provided
    @Parameter(title: "Number of cigarettes")
    var count: Int

    static var parameterSummary: some ParameterSummary {
        Summary("Log \(\.$count) cigarettes")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Perform the action
        await CigaretteTracker.shared.log(count: count)
        return .result(dialog: "Logged \(count) cigarette\(count > 1 ? "s" : "")")
    }
}

// Register with App Shortcuts for zero-setup voice commands
struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogCigaretteIntent(),
            phrases: [
                "Log a cigarette in \(.applicationName)",
                "Track smoking in \(.applicationName)"
            ],
            shortTitle: "Log Cigarette",
            systemImageName: "plus.circle"
        )
    }
}
```

**SiriTipView — teach users about voice commands:**
```swift
// Show a tip in your UI to educate users about available Siri commands
SiriTipView(intent: LogCigaretteIntent())
    .siriTipViewStyle(.automatic) // Adapts to light/dark mode
```

**Personal context (iOS 18.4+):**
- Siri can read on-screen content to answer contextual questions
- Users can ask "What's on my screen?" and Siri analyzes visible content
- No developer opt-in needed — works with standard UIKit/SwiftUI views
- Opt out for sensitive screens: `.sensitiveContentAnalysis(.disabled)`

### On-Device ML — General Guidelines

**Device requirements:**
- Apple Intelligence requires iPhone 15 Pro or later (A17 Pro+)
- iPad with M1 chip or later
- Mac with M1 chip or later
- All processing on Apple Neural Engine (ANE) — no data sent to Apple servers

**UX patterns for AI features:**
- Show the Apple Intelligence glyph/badge where AI features are active
- If device doesn't support Apple Intelligence, hide AI features entirely — don't show disabled/greyed-out buttons
- Provide clear loading states: text operations complete in <2 seconds, image generation takes 5–30 seconds
- Always show progress indicators for operations >1 second
- Let users undo/revert any AI-generated changes
- Make AI features discoverable but not intrusive — contextual placement, not splash screens

**Privacy communication:**
- Reassure users that processing is on-device
- If using Private Cloud Compute (for larger models), explain that data is processed on Apple Silicon servers with no persistent storage
- Never log or transmit AI inputs/outputs to your own servers without explicit user consent
- Include AI processing in your privacy policy/nutrition label

**Graceful degradation pattern:**
```swift
// Check availability before showing AI features
if #available(iOS 18.1, *) {
    // Check if device supports Apple Intelligence
    // (A17 Pro+ for iPhone, M1+ for iPad/Mac)
    if ProcessInfo.processInfo.isiOSAppOnMac ||
       deviceSupportsAppleIntelligence {
        showAIFeatures()
    }
} else {
    // Pre-iOS 18.1: AI features not available
    // Don't show disabled buttons — just omit the feature
}
```

**Sources:** Apple Intelligence documentation (developer.apple.com/apple-intelligence), WWDC 2024 sessions (Bring Apple Intelligence to Your App, Get Started with Writing Tools, Image Playground API), WWDC 2025 sessions (What's New in Apple Intelligence), Apple App Intents documentation, UNNotificationInterruptionLevel documentation.

---

## CZ. Android 16 & Store Requirements 2025–2026

Major Android platform changes and store policy updates that affect app development, submission, and compliance for 2025–2026.

### Android 16 (API 36) — Key Platform Changes

**Release timeline:**
- Developer Preview: November 2024
- Beta releases: January–May 2025
- Stable release: Q2 2025 (June expected)
- Platform stability (APIs finalized): April 2025

**Adaptive Layouts — Now Mandatory:**

Apps targeting API 36+ must properly support all screen sizes. Google Play will flag and potentially restrict apps that don't adapt to tablets, foldables, and desktop-mode displays.

**WindowSizeClass breakpoints:**
| Class | Width | Typical Devices |
|---|---|---|
| Compact | <600dp | Phone portrait |
| Medium | 600–840dp | Phone landscape, small tablet, foldable inner |
| Expanded | >840dp | Tablet, desktop, large foldable |

**Canonical layouts (Google-recommended patterns):**
```kotlin
// Jetpack Compose: adaptive layout with WindowSizeClass
@Composable
fun AdaptiveScreen(windowSizeClass: WindowSizeClass) {
    when (windowSizeClass.widthSizeClass) {
        WindowWidthSizeClass.Compact -> {
            // Single-column layout (phone)
            SinglePaneContent()
        }
        WindowWidthSizeClass.Medium -> {
            // List-detail or supporting pane
            ListDetailLayout()
        }
        WindowWidthSizeClass.Expanded -> {
            // Two-pane layout with navigation rail
            TwoPaneLayout()
        }
    }
}
```

**Three canonical layout patterns:**
1. **List-Detail**: master list on left, detail on right (email, messaging)
2. **Feed**: single content stream that widens and adds columns on larger screens
3. **Supporting Pane**: main content with supplementary panel (map + list, video + comments)

**Testing adaptive layouts:**
- Use Android Studio resizable emulator (drag window edges to test breakpoints)
- Desktop Device Streaming: test on real Pixel tablets remotely
- Foldable emulators: test folded/unfolded transitions
- Test with split-screen / multi-window mode active
- Verify no content is clipped or overlapping at each breakpoint

**Live Updates API — Richer Real-Time Notifications:**

Replaces certain notification patterns with persistent, auto-updating status displays.

```kotlin
// Create a Live Update for delivery tracking
val liveUpdate = Notification.Builder(context, CHANNEL_ID)
    .setSmallIcon(R.drawable.ic_delivery)
    .setContentTitle("Your order is on the way")
    .setLiveUpdateInfo(
        LiveUpdateInfo.Builder()
            .setProgress(0.65f)                    // 65% progress
            .setEta(System.currentTimeMillis() + 600_000) // ETA: 10 min
            .setCustomLayout(remoteViews)          // Custom layout with map
            .build()
    )
    .setOngoing(true)                              // Persistent
    .build()

notificationManager.notify(LIVE_UPDATE_ID, liveUpdate)
```

**Live Updates use cases:**
- Delivery tracking with progress bar and ETA
- Ride-sharing: driver location, arrival time
- Sports scores: live game updates
- Navigation: turn-by-turn directions
- Timers/stopwatches: countdown display
- Music/media: playback controls (already existed, now unified API)

**Live Updates UX rules:**
- Must be user-initiated (don't start Live Updates without user action)
- Provide a clear dismiss/end mechanism
- Update frequency: max once per second for progress, once per 5 seconds for content
- Don't use Live Updates for advertising or promotional content
- Automatically end when the tracked activity completes

**Richer Widgets with Glance 2.0:**

```kotlin
// Jetpack Glance: compound buttons in widgets
@Composable
fun TaskWidget() {
    LazyColumn {
        items(tasks) { task ->
            Row(
                modifier = GlanceModifier
                    .fillMaxWidth()
                    .padding(8.dp)
            ) {
                // Checkbox in widget (new in Glance 2.0)
                CheckBox(
                    checked = task.isComplete,
                    onCheckedChange = actionRunCallback<ToggleTaskAction>(
                        actionParametersOf(taskIdKey to task.id)
                    )
                )
                Text(task.title)
            }
        }
    }
}
```

**Glance 2.0 new capabilities:**
- Compound buttons: CheckBox, RadioButton, Switch within widgets
- Lazy lists: scrollable content in widgets (LazyColumn)
- `GlanceModifier.clickable()` for interactive elements beyond simple tap-to-open
- Background updates via WorkManager integration (periodic + event-driven)
- Improved error handling: `GlanceStateDefinition` for widget state persistence
- Sizing: `SizeMode.Responsive` with breakpoint-based layouts for different widget sizes

### Target SDK Requirements — Timeline

**Google Play Store deadlines:**

| Date | Requirement |
|---|---|
| August 2025 | New apps must target API 35 (Android 15) |
| November 2025 | App updates must target API 35 (Android 15) |
| Mid-2026 (est.) | New apps must target API 36 (Android 16) |
| Late 2026 (est.) | App updates must target API 36 (Android 16) |

**What targeting API 35+ requires:**
- **Edge-to-edge by default**: status bar and navigation bar are transparent, app draws behind them. Must handle `WindowInsets` properly
- **Predictive back gesture**: system back animation shows previous destination. Must implement `OnBackPressedCallback` correctly (no more `onBackPressed()` override)
- **Photo Picker**: must use system Photo Picker for media selection instead of requesting broad storage access (`READ_MEDIA_IMAGES`)
- **Foreground service types**: must declare specific type (location, mediaPlayback, health, etc.) — no more generic foreground services
- **Notification permission**: must request `POST_NOTIFICATIONS` runtime permission (Android 13+), but targeting 35 enforces stricter UX around the ask

**What targeting API 36+ will additionally require:**
- Adaptive layouts as described above
- Live Updates API adoption where applicable
- Enhanced privacy controls for health/fitness data
- Stricter background execution limits

### Privacy Manifest (iOS) & Data Safety (Android)

**iOS Privacy Manifest — Required since March 2024:**

Every app and third-party SDK must include a `PrivacyInfo.xcprivacy` file declaring:

1. **Required Reason APIs** — system APIs that Apple considers privacy-sensitive:
   - `NSUserDefaults` — must declare why you access user defaults
   - File timestamp APIs (`NSFileModificationDate`) — must declare reason
   - Disk space APIs (`NSFileSystemFreeSize`) — must declare reason
   - System boot time (`systemUptime`, `mach_absolute_time`) — must declare reason
   - Active keyboards list — must declare reason

2. **Tracking domains** — domains used for cross-app tracking:
   ```xml
   <!-- PrivacyInfo.xcprivacy -->
   <key>NSPrivacyTrackingDomains</key>
   <array>
       <string>analytics.example.com</string>
   </array>
   ```
   - Listed domains are blocked by default unless user opts in via App Tracking Transparency
   - Not listing a tracking domain that you use → App Store rejection

3. **Third-party SDK signatures:**
   - All SDKs must be signed with the developer's identity
   - Unsigned SDKs → App Store rejection (enforced since May 2024)
   - Use `codesign --verify` to check SDK signatures before submission

4. **App Store Connect validation:**
   - Privacy nutrition labels in App Store Connect must match the manifest
   - Apple automated scans compare declared APIs vs. actual binary usage
   - Discrepancy → rejection with specific guidance on what to fix

**Android Data Safety Section:**

Google Play requires an accurate Data Safety section declaring:

**Data categories you must declare:**
| Category | Examples |
|---|---|
| Location | Precise GPS, approximate/coarse location |
| Personal info | Name, email, address, phone, date of birth |
| Financial | Payment info, purchase history, credit score |
| Health & fitness | Health data, exercise data, sleep, nutrition |
| Messages | Emails, SMS, in-app messages |
| Photos & videos | Photos, videos, screenshots |
| Audio | Voice recordings, music files |
| Contacts | Contact list, social connections |
| App activity | App interactions, search history, installed apps |
| Device/IDs | Device ID, advertising ID, crash logs |

**Declaration requirements:**
- **Collection**: data your app gathers from the user
- **Sharing**: data sent to third parties (analytics SDKs count)
- **Security**: encryption in transit (required), encryption at rest
- **Data deletion**: must offer account/data deletion if you collect personal data
  - Deletion request handling within 60 days
  - Provide a web-accessible deletion mechanism (not just in-app)
  - Respond to deletion requests even for inactive/deleted accounts

**Compliance verification:**
- Google performs automated analysis of your APK/AAB (network calls, SDK fingerprints)
- Manual review for flagged apps
- Inaccurate declarations → policy strike, potential app removal
- Appeal process: 7 days to respond with corrected declaration

### Store Review Guidelines 2025 — Key Rules

**Apple App Store (2025 guidelines):**
- Non-public API usage → automatic rejection (runtime checks detect private method calls)
- All permission requests must include purpose strings (`NSCameraUsageDescription`, etc.)
- Apps with account creation must offer account deletion
- Subscription apps: must provide clear cancel flow accessible from subscription management
- Dark patterns: rejecting apps that use UI tricks to prevent cancellation, add hidden charges, or obscure opt-outs
- EU Digital Markets Act (DMA) compliance:
  - Alternative app marketplaces allowed in EU (iOS 17.4+)
  - Apps distributed outside App Store must be notarized by Apple
  - Core Technology Fee: €0.50 per annual install above 1M (for apps using alternative distribution)
  - Alternative payment processors allowed (Apple still collects reduced commission)
- AI-generated content: must disclose in app metadata if the app primarily generates AI content
- Health/medical claims: require supporting evidence and appropriate disclaimers

**Google Play Store (2025 policies):**
- Privacy policy required for all apps (not just those collecting personal data)
- Data deletion mechanism mandatory if collecting personal data
- Play Integrity API replaces SafetyNet Attestation:
  ```kotlin
  // Verify device and app integrity
  val integrityManager = IntegrityManagerFactory.create(context)
  val integrityTokenRequest = IntegrityTokenRequest.builder()
      .setNonce(generateNonce())
      .build()

  integrityManager.requestIntegrityToken(integrityTokenRequest)
      .addOnSuccessListener { response ->
          val token = response.token()
          // Send token to your server for verification
          verifyOnServer(token)
      }
  ```
- Device integrity verdicts: `MEETS_DEVICE_INTEGRITY`, `MEETS_BASIC_INTEGRITY`, `MEETS_STRONG_INTEGRITY`
- Subscription transparency: price must be visible before purchase, trial terms explicit
- AI-generated content labeling: apps generating synthetic media must label outputs
- Kids/families: COPPA compliance, no behavioral advertising, limited data collection

**Both platforms — universal requirements:**
- All subscription apps must allow easy cancellation (max 2 taps from settings)
- AI-generated content must be disclosed to users
- Biometric data: explicit consent required, must explain purpose and retention
- Third-party SDKs: developer is responsible for all SDK behavior (data collection, network calls)
- Accessibility: while not formally required for approval, both platforms increasingly flag apps with major accessibility issues during review

**Practical submission checklist 2025–2026:**
- [ ] iOS: `PrivacyInfo.xcprivacy` present and accurate
- [ ] iOS: all SDKs signed and include their own privacy manifests
- [ ] iOS: purpose strings for every permission requested
- [ ] iOS: account deletion flow tested end-to-end
- [ ] Android: Data Safety section matches actual app behavior
- [ ] Android: targeting API 35+ (August 2025 deadline)
- [ ] Android: `POST_NOTIFICATIONS` permission requested properly
- [ ] Android: edge-to-edge rendering with proper insets
- [ ] Android: predictive back gesture supported
- [ ] Both: privacy policy URL accessible and up-to-date
- [ ] Both: subscription cancel flow clear and functional
- [ ] Both: AI features disclosed in app metadata if applicable
- [ ] Both: test on latest OS version before submission

**Sources:** Android 16 Developer Preview documentation (developer.android.com/about/versions/16), Google Play Developer Policy Center (2025 updates), Apple App Review Guidelines v2025, Apple Privacy Manifest documentation, Google Play Integrity API documentation, EU Digital Markets Act compliance guidelines for app developers, WWDC 2024–2025 sessions on App Store guidelines.