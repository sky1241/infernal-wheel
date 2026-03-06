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
