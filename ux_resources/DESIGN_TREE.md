# DESIGN TREE - Mind Map UX/UI

> Arbres de decision UNIQUEMENT - pour le code, voir WEB.md et MOBILE.md

---

## ARBRE PRINCIPAL

```
                         DESIGN
                           |
              +------------+------------+
              |            |            |
           TOKENS       LAYOUT      COMPONENTS
              |            |            |
         Spacing 4px   Responsive    Touch 44px+
         Colors 4.5:1  Navigation    Focus visible
         Typography    Density       States clairs
              |            |            |
              +------+-----+-----+------+
                     |           |
                 FEEDBACK    ACCESSIBILITY
                     |           |
                 < 100ms     WCAG AA
                 skeleton    Keyboard
                 validation  Screen reader
                     |           |
                     +-----+-----+
                           |
                      CONVERSION
                           |
                    Field burden
                    Guest checkout
                    Trust signals
```

---

## PHASE 0: Avant de Coder

```
Qui est l'utilisateur?
         |
    +----+----+--------+
    |         |        |
  Mobile    Desktop  Wearable
  First?    First?   (montre)?
    |         |        |
    v         v        v
 MOBILE.md  WEB.md  WEARABLE.md
```

---

## PHASE 1: Tokens

```
                DESIGN TOKENS
                     |
     +---------------+---------------+
     |               |               |
  SPACING         COLORS         TYPOGRAPHY
     |               |               |
  Base: 4px     Semantiques      Body: 16px
     |               |               |
 0,4,8,12,16,   Primary,        Label: lh 1.2
 24,32,48       Surface,        Copy: lh 1.5
                Error/Success
```

---

## PHASE 2: Layout

```
            QUEL LAYOUT?
                 |
     +-----------+-----------+
     |                       |
Mobile (<768px)        Desktop (>=1024px)
     |                       |
+----+----+          +-------+-------+
|         |          |               |
Simple  Complex    Dashboard     Marketing
|         |          |               |
Stack   Tab Bar    Sidebar +      Hero +
vertical bottom    Main area     Sections
```

### Navigation

```
       COMBIEN DE DESTINATIONS?
                |
    +-----------+-----------+
    |           |           |
  2-3         4-5          6+
    |           |           |
  Tabs      Tab Bar     Navigation
  ou        (mobile)     Drawer
Segmented   Bottom Nav   ou Sidebar
            (Android)
                |
          Labels TOUJOURS
          (jamais icons seuls)
```

---

## PHASE 3: Composants

### Touch Targets

```
     ELEMENT INTERACTIF?
            |
       +----+----+
       |         |
      Oui       Non
       |
  Quelle plateforme?
       |
+------+------+------+
|      |      |      |
iOS  Android  Web   Universal
|      |      |      |
44pt   48dp   24px*   48px
              |
        *44px recommande
```

### Forms - Labels

```
    TYPE DE CHAMP?
          |
+---------+---------+
|         |         |
Texte   Select    Toggle
|         |         |
v         v         v

Label VISIBLE (jamais placeholder seul)
     |
+----+----+
|         |
Au-dessus  Floating
(simple)   (compact)
```

### Forms - Validation

```
     QUAND VALIDER?
          |
+---------+---------+
|                   |
Pendant saisie    Au blur
(JAMAIS rouge     (standard)
 des 1er char)        |
     |           Erreur si invalide
     v           Succes si valide
Apres 3+ chars        |
ET pause 250ms   Retirer erreur
     |           des correction
Feedback positif
discret si OK
```

---

## PHASE 4: Feedback

### Timing

```
     DUREE DE L'ACTION?
            |
+-----------+-----------+
|           |           |
< 100ms   100ms-2s     > 2s
|           |           |
Aucun     Spinner    Progress
indicateur subtil      bar
|           |           |
Instantane  Ou skeleton Avec %
            si contenu  si possible
```

### Motion

```
         QUEL TYPE D'ANIMATION?
                 |
     +-----------+-----------+
     |           |           |
  Micro       Standard     Large
(feedback)   (transition)  (page)
     |           |           |
100-200ms    250-350ms    450-600ms
     |           |           |
  hover,     navigation,  entree/
  toggle,    modal,       sortie
  ripple     drawer       ecran
```

### Toast vs Alert

```
     TYPE DE MESSAGE?
            |
+-----------+-----------+
|           |           |
Succes      Erreur     Action
|           |           |
Toast      Alert ou   Snackbar
auto 4s    inline     avec Undo
|           |           |
Position:  Focus sur  1 action max
bottom     le champ   "ANNULER"
```

---

## PHASE 5: Conversion

```
     CHECKOUT FLOW
          |
+---------+---------+
|                   |
Guest checkout    Account
PROMINENT!        required?
|                   |
62% sites         Delayed:
le cachent        creer compte
|                 APRES paiement
= abandons
```

### Trust Signals

```
     OU PLACER LA CONFIANCE?
              |
+-------------+-------------+
|             |             |
Paiement    Formulaire   Footer
|             |             |
Encadrer    Microcopy    Logos
visuellement rassurant   Contact
les champs      |        Mentions
|           "Securise"
Badges      "Pas de spam"
proches
```

---

## PHASE 6: Accessibilite

```
WCAG AA MUST-HAVE:
     |
+----+----+----+----+
|    |    |    |    |
Touch Contrast Focus Keyboard
24px+  4.5:1  visible tout
       text   2px+   navigable
       3:1    outline
       UI
```

---

## PHASE 7: Patterns Avances

### Gamification (Section N/W)

```
     OBJECTIF ENGAGEMENT?
            |
+-----------+-----------+
|           |           |
Quotidien  Progression  Social
|           |           |
STREAKS    BADGES       LEADERBOARD
|           |           |
7 jours    Tiers:       Friends-first
= +3.6x    C/R/E/L      puis Weekly
retention  |            puis Global
|          Unlock       |
Grace      animation    Position user
period     + haptic     toujours visible
24-48h
```

### Tables (Section O)

```
     AFFICHER DES DONNEES?
              |
+-------------+-------------+
|             |             |
Liste simple  Comparaison   Analyse
|             |             |
Cards/List    TABLE         Dashboard
              |             + Charts
     +--------+--------+
     |                 |
   < 1000 rows      > 1000 rows
     |                 |
   Client-side      Server-side
   sort/filter      + Pagination
```

### Pagination vs Scroll (Section O)

```
      TYPE DE CONTENU?
            |
+-----------+-----------+
|           |           |
Analytique  Feed/       E-commerce
|           Timeline    |
PAGINATION  INFINITE    LOAD MORE
|           SCROLL      |
Ref pages   Sans fin    Bouton
Compare     Back = top  explicite
|                       |
25-50 rows              Controle
par page                utilisateur
```

### Settings Controls (Section P/X)

```
      QUEL CONTROLE?
            |
+-----------+-----------+
|           |           |
Binaire     Selection   Range
On/Off      |           |
|       +---+---+       SLIDER
TOGGLE  |       |       ou STEPPER
|       Few    Many
Effet   |       |
immediat RADIO  DROPDOWN
        /SEGMENT PICKER
```

### Toggle vs Checkbox (Section P/X)

```
     BINAIRE ON/OFF?
            |
+-----------+-----------+
|                       |
Effet immediat?     Partie d'un form?
|                       |
OUI                   NON
|                       |
TOGGLE               CHECKBOX
(Switch)             |
|                    Bouton SAVE
Pas de Save          requis
button               |
|                    Peut etre
Mobile-first         indeterminate
```

### Search Pattern (Section Q/Y)

```
      RESULTATS ATTENDUS?
              |
+-------------+-------------+
|             |             |
Peu           Beaucoup      Catalogue
(< 100)       (> 1000)      produits
|             |             |
INSTANT       SUBMIT        FACETED
as-you-type   Enter/btn     + Filters
|             |             |
Debounce      Full page     Sidebar
200-300ms     results       (desktop)
|             |             ou Sheet
Suggestions   Query         (mobile)
5-10 items    in URL
```

### No Results (Section Q/Y)

```
     0 RESULTATS?
          |
     NE JAMAIS:
     - Page vide
     - Blamer user
          |
     TOUJOURS:
     +----+----+----+
     |    |    |    |
   Message  Suggest  Alternatives
   friendly  corriger  populaires
     |
  "Pas de resultats
   pour 'xyz'"
```

### Loading Pattern (Section R)

```
     TEMPS DE CHARGEMENT?
              |
+------+------+------+------+
|      |      |      |      |
< 100ms 100ms-1s  1-3s   > 3s
|      |      |      |
RIEN   SPINNER SKELETON PROGRESS
       subtil  screen   bar
              |        |
         Shapes qui   Avec %
         imitent     si possible
         le contenu    |
              |      Cancel
         Shimmer     option
         1.5-2s
```

### Optimistic UI (Section R)

```
     ACTION REVERSIBLE?
            |
+-----------+-----------+
|                       |
OUI                   NON
(like, save, toggle)  (delete, send, pay)
|                       |
OPTIMISTIC UI        CONFIRMATION
|                       |
Update instant       Modal ou
Sync background      double-check
|                       |
Si echec:            Loading state
Rollback +           puis feedback
Error toast
```

### Dark Mode (Section S)

```
     THEME PREFERENCE?
            |
+-----------+-----------+
|           |           |
User        System      Schedule
toggle      default     auto
|           |           |
localStorage prefers-   Time-based
persistence  color-     (sunset)
|           scheme      |
3 options:  query       Optionnel
Light/Dark/             |
System                  Geolocation
                        pour sunset
```

### Modal vs Sheet (Section T)

```
     TYPE D'OVERLAY?
            |
+-----------+-----------+-----------+
|           |           |           |
Info        Actions     Form        Nav
critique    rapides     complexe    panel
|           |           |           |
ALERT       BOTTOM      MODAL       DRAWER
Dialog      SHEET       ou Full     |
|           |           screen      Slide
Buttons     Swipe       (mobile)    from
only        dismiss     |           side
|           |           X button    |
No outside  Touch       + outside   Sidebar
click       target      click       content
            48px+       optional
```

### Bottom Sheet Sizing (Section T)

```
     CONTENU DU SHEET?
            |
+-----------+-----------+
|           |           |
Actions     Preview     Form/
simples     + detail    Wizard
(2-5)       |           |
|           MEDIUM      LARGE
SMALL       50%         90%
25%         expandable  ou
|           |           Full-screen
Quick       Drag to
dismiss     expand
```

### Animation Easing (Section U/Z)

```
     DIRECTION DU MOUVEMENT?
              |
+-------------+-------------+
|             |             |
ENTREE        SORTIE        SUR PLACE
(appearing)   (leaving)     (moving)
|             |             |
EASE-OUT      EASE-IN       EASE-IN-OUT
decelere      accelere      les deux
|             |             |
Element       Element       Transition
arrive,       part,         smooth
ralentit      accelere
|             |
Modals,       Dismiss,
menus,        close
reveals
```

### Onboarding Type (Section V)

```
     PREMIERE UTILISATION?
              |
+-------------+-------------+
|             |             |
App simple    App complexe  Permissions
|             |             necessaires
EMPTY STATE   PROGRESSIVE   PRE-PRIME
comme guide   DISCLOSURE    |
|             |             Expliquer
CTA dans      Coach marks   POURQUOI
l'etat vide   Just-in-time  avant
|             |             system
"Create       1 tip a       dialog
first X"      la fois       |
              dismissable   Benefice
                            clair
```

### Permission Timing (Section V)

```
     QUELLE PERMISSION?
              |
+------+------+------+------+
|      |      |      |      |
Push   Camera Location Contacts
|      |      |      |
APRES  QUAND  QUAND   QUAND
1er    user   feature  invite
value  tap    utilisee flow
moment photo  |        |
|      |      Map,     Share,
Jamais Si     Weather  Import
au     refus: |
cold   Settings Contextuel
start  guide   seulement
```

---

## VALEURS CLES (memo)

### Fondamentaux
| Quoi | Valeur |
|------|--------|
| Touch iOS | 44pt |
| Touch Android | 48dp |
| Touch Web | 24px min, 44px ideal |
| Spacing | 4px base |
| Contraste texte | 4.5:1 |
| Contraste UI | 3:1 |
| Focus | 2px solid + offset 2px |

### Animations
| Quoi | Valeur |
|------|--------|
| Anim micro | 100-200ms |
| Anim standard | 250-350ms |
| Anim large | 400-600ms |
| Spring subtle | 0.15 |
| Spring visible | 0.30 |
| Debounce search | 200-300ms |

### Gamification
| Quoi | Valeur |
|------|--------|
| Streak seuil | 7 jours (+3.6x retention) |
| Grace period | 24-48h |
| Suggestions max | 5-10 (8 mobile) |
| Leaderboard default | Weekly (pas All-time) |

### Tables
| Quoi | Valeur |
|------|--------|
| Row height compact | 32-36px |
| Row height default | 40-52px |
| Row height comfort | 52-64px |
| Page sizes | 10, 25, 50, 100 |
| Client-side limit | < 1000 rows |

### Loading
| Quoi | Valeur |
|------|--------|
| Instant | < 100ms (no feedback) |
| Spinner | 100ms - 1s |
| Skeleton | 1s - 3s |
| Progress bar | > 3s |
| Skeleton shimmer | 1.5-2s cycle |

### Dark Mode (Material)
| Elevation | Color |
|-----------|-------|
| 0dp | #121212 |
| 1dp | #1E1E1E |
| 4dp | #272727 |
| 8dp | #2E2E2E |
| 16dp | #363636 |

### Modals
| Quoi | Valeur |
|------|--------|
| Small modal | 400px max |
| Medium modal | 600px max |
| Large modal | 800px max |
| Max height | 90vh |
| Sheet small | 25% |
| Sheet medium | 50% |
| Sheet large | 90% |

---

## QUICK DECISION

```
PHOTO/DEMANDE → Identifier le pattern → Arbre de decision → Section WEB/MOBILE/WEARABLE
     |
     v
  Mobile?    → MOBILE.md sections A-Z
  Web?       → WEB.md sections A-V
  Wearable?  → WEARABLE.md sections A-Z (2217 lignes)
  Les deux+  → Croiser les fichiers concernes
```

### Index WEARABLE.md (recherche rapide)

| Besoin | Section | # |
|--------|---------|---|
| Ecrans, tailles, breakpoints | A. Fondamentaux Ecran | 1-3 |
| Touch targets, boutons M3 | B. Touch Targets | 4 |
| Gestures, bezel, crown, voice | B. Interactions | 5-7b |
| Composants Compose M3 | C. Composants UI | 8 |
| Migration M2.5 → M3 | C. Migration | 8b |
| TransformingLazyColumn | C. Composants | 8c |
| EdgeButton (nouveau M3) | C. Composants | 8d |
| Principes Google officiels | C. Principes | 8e |
| Checklist Play Store | C. Quality | 8g |
| M3 Expressive (shape morph, ButtonGroup) | C. Composants | 8e-bis |
| Dialogs, Pickers, Confirmations | C. Composants | 8f |
| Picker, Stepper, Settings (Toggle/Split) | C. Composants | 8g-bis |
| Navigation, profondeur | C. Navigation | 9 |
| Navigation Compose (SwipeDismissableNavHost) | C. Navigation | 9b |
| HorizontalPager, PageIndicator | C. Navigation | 9c |
| Tiles, Smart Stack | C. Tiles | 10, 10b |
| Tile interactions (code, +1 pattern) | C. Tiles | 10 |
| Complications | C. Complications | 11 |
| Complication implementation (code) | C. Complications | 11b |
| Typographie M3, watchOS | D. Typographie | 12-13 |
| Ambient / AOD | E. Ambient | 14-15 |
| Ambient mode implementation (code) | E. Ambient | 14b |
| Tracking addiction, compteur | F. Sante | 16 |
| Apps addiction existantes | F. Analyse apps | 16b |
| Gamification montre | F. Gamification | 16c |
| Health Connect | F. Health API | 17 |
| Battery, sensors, optimisation | G. Performance | 18-19 |
| Foreground services, Doze, Standby | G. Performance | 19 |
| Health Services API (3 clients) | G. Performance | 19b |
| Baseline profiles, R8, cold start | G. Performance | 19c |
| TensorFlow Lite montre | G. ML | 20 |
| Wear Data Layer API | H. Sync | 21 |
| watchOS Watch Connectivity | H. Sync | 21b |
| Testing montre | H. Testing | 21c |
| Accessibilite (TalkBack, motor) | I. Accessibilite | 22-22c |
| Haptics (VibrationEffect, WKHapticType) | J. Haptics | 23 |
| Notifications (bridged, local) | K. Notifications | 24 |
| App Lifecycle (cold/warm start) | K-bis. Lifecycle | 24b |
| Wrist detection | K-bis. Wrist | 24c |
| Charging / battery states | K-bis. Charging | 24d |
| Ongoing Activity API (code) | K-bis. Ongoing | 24e |
| Splash Screen (code) | K-bis. Splash | 24f |
| Onboarding, permissions | L. Onboarding | 25-26 |
| Permissions Wear (BODY_SENSORS, code) | L. Permissions | 26b |
| i18n, RTL, troncature | M. i18n | 27 |
| Distribution Play Store | N. Distribution | 28 |
| Couleurs OLED, M3 tokens 28 | O. Design System | 29-29c |
| Icones, design tokens | O. Design System | 30-30b |
| Curved UI, system overlay | P. Curved UI | 31-32 |
| Contextes (pluie, gants, nuit) | Q. Contextes | 33-34 |
| Data viz (sparkline, ring) | R. Data Viz | 35 |
| Securite, GDPR, encryption | S. Securite | 36 |
| Authentication (Credential Manager, OAuth) | S. Auth | 36b |
| Samsung One UI, BioActive | T. Samsung | 37 |
| Motion & animation tokens M3 | I-bis. Motion | 22d |
| Compose animation APIs (tween/spring/keyframes) | I-bis. Motion | 22e |
| MotionScheme (spatial vs effects) | I-bis. Motion | 22f |
| Tile animations (ProtoLayout, max 4) | I-bis. Motion | 22g |
| Shared element transitions | I-bis. Motion | 22h |
| Regles critiques animation montre | I-bis. Motion | 22i |
| Standalone vs Companion | U. Architecture | 38 |
| Detection companion, CapabilityClient | U. Architecture | 38b |
| Loading patterns, errors | V. Loading | 39-40 |
| Audio / son | W. Audio | 41 |
| Watch Faces (WFF v4) | X. Watch Faces | 42 |
| Responsive layouts, quality tiers | A. Ecran | 2b |
| Rotary input implementation (code) | B. Rotary | 6b |
| Deep linking (PendingIntent, NavGraph) | D. Navigation | 9d |
| State restoration (rememberSaveable, SavedStateHandle) | D. Navigation | 9e |
| Disconnection UI (placement, Data Layer observer) | D. Navigation | 9f |
| WearableListenerService (background sync) | H. Data Layer | 21 |
| TileService M3 (materialScope, primaryLayout) | E. Tiles | 10 |
| Anti-patterns + benchmarks | Y. Anti-patterns | 43-43b |
| NNGroup 6 types interactions | Y. Research | 43c |
| Quand construire app montre | Y. Research | 43d |
| Power conservation hierarchy | Y. Batterie | 43e |
| Touch lock, fitness UX | Y. Fitness | 43f |
| Fitts's Law ecran rond | Y. Research | 43g |
| Habit formation BCTs (smoking) | Y. Research | 43h |
| Notification triage (watch vs phone) | Y. Research | 43i |
| Cognitive load petit ecran | Y. Research | 43j |
| Marche global 2026, statistiques | Y. Stats | 43k |
| Text input sur montre (RemoteInput, voix, clavier) | B. Input | 7c |
| Battery saver mode (system, Wear OS 5+, watchOS) | K-bis. Lifecycle | 24d |
| Multi-device continuity (handoff watch↔phone) | U. Standalone | 38c |
| Testing Compose Wear OS (UI, screenshot, benchmark) | H. Testing | 21d |
| Dependencies BOM, SDK versions (2025-2026) | H. Testing | 21e |
| Outils prototypage (Figma, AS preview, workflow) | O. Design | 30c |
| Figma kits (M3 Wear OS Apps + Tiles, watchOS 26) | AA. Outils Prototypage | 44 |
| Ecran rond dans Figma (masque, safe area, workarounds) | AA. Outils Prototypage | 44c |
| M3 Figma variables (color, typo, shape tokens) | AA. Outils Prototypage | 44d |
| @WearPreviewDevices, @WearPreviewFontScales | AA. Outils Android Studio | 45a |
| Emulateurs Wear OS (profils, capteurs, Health Services) | AA. Outils Android Studio | 45b |
| Layout Inspector montre (3D, marges, clipping) | AA. Outils Android Studio | 45c |
| Direct Surface Launch (Tiles, Complications debug) | AA. Outils Android Studio | 45d |
| Samsung Watch Face Studio (WFF export) | AA. Autres Outils | 46a |
| ProtoPie (player Wear OS natif, interactions connectees) | AA. Autres Outils | 46b |
| Accessibilite testing (TalkBack, Scanner, font scaling) | AA. Autres Outils | 46c |
| Workflow design-to-dev wearable (9 etapes) | AA. Workflow | 47a |
| Rond vs carre (strategy design, 78.5% surface) | AA. Workflow | 47b |
| Emulateur vs device reel (12 criteres comparaison) | AA. Workflow | 47c |
| Memo rapide (toutes valeurs) | Z. Valeurs Cles | - |

---

*Mind map - pour le code complet voir WEB.md, MOBILE.md et WEARABLE.md*
