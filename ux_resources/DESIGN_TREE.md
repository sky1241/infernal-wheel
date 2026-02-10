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
    +----+----+
    |         |
  Mobile    Desktop
  First?    First?
    |         |
    v         v
 MOBILE.md  WEB.md
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
PHOTO/DEMANDE → Identifier le pattern → Arbre de decision → Section WEB/MOBILE
     |
     v
  Mobile?  → MOBILE.md sections A-Z
  Web?     → WEB.md sections A-V
  Les deux → Croiser les deux fichiers
```

---

*Mind map - pour le code complet voir WEB.md et MOBILE.md*
