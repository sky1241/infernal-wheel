# DESIGN TREE - Mind Map UX/UI

> Arbres de decision UNIQUEMENT - pour le code, voir WEB.md, MOBILE.md, WEARABLE.md et ICONS.md

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
  Mobile?    → MOBILE.md sections A-CZ (15508 lignes, 105 sections majeures)
  Web?       → WEB.md sections A-CW (15669 lignes, 107 sections majeures)
  Wearable?  → WEARABLE.md sections A-BX (13132 lignes, 76 sections majeures)
  Les deux+  → Croiser les fichiers concernes
```

---

### Index WEB.md (recherche rapide)

| Besoin | Section | # |
|--------|---------|---|
| Loading states, skeleton, optimistic UI | A. Etats & Feedback | 1-5 |
| Empty states, error messages, success | A. Etats & Feedback | 2-4 |
| Disabled states | A. Etats & Feedback | 5 |
| Navigation, breadcrumbs, back behavior | B. Flux utilisateur | 6 |
| Onboarding, progressive disclosure | B. Flux utilisateur | 7-8 |
| Wizard, multi-step forms | B. Flux utilisateur | 9 |
| Search, autocomplete, filters | B. Flux utilisateur | 10 |
| Forms, labels, validation inline | C. Interactions | 11 |
| Actions, confirmations, undo, dialogs | C. Interactions | 12 |
| Selections (radio, checkbox, range) | C. Interactions | 13 |
| Drag & drop | C. Interactions | 14 |
| Data display, tables, pagination | D. Information | 16 |
| Notifications (web) | D. Information | 17 |
| Help & support, chatbot | D. Information | 18 |
| Trust patterns, social proof, prix | E. Confiance | 19 |
| Privacy, consent, GDPR basique | E. Confiance | 20 |
| WCAG 2.2 touch targets (24px/44px) | F. Accessibilite | 21 |
| Contraste (4.5:1 text, 3:1 UI) | F. Accessibilite | 22 |
| Focus clavier (outline, trap, order) | F. Accessibilite | 23-24 |
| Pointeur, gestes, drag alternatives | F. Accessibilite | 25 |
| Texte reflow, resize 200%, spacing | F. Accessibilite | 26 |
| Animation, reduced motion, flashes | F. Accessibilite | 27 |
| Changements de contexte | F. Accessibilite | 28 |
| Structure page (skip link, headings) | F. Accessibilite | 29 |
| Formulaires accessibles, autocomplete | F. Accessibilite | 30 |
| ARIA, roles, status messages | F. Accessibilite | 31 |
| Couleurs HSB, variations, hue shift | G. Couleurs HSB | 32-35 |
| Spacing 4px, marges, grille 12 col | H. Espacement | 36-42 |
| Tutoriel invisible "Mario" | I. Checklist Mario | 43-48 |
| Densite, typography fluide, tokens | J. Ajouts 2024-2026 | 49-61 |
| Checkout benchmarks Baymard | J. Ajouts 2024-2026 | 55-57 |
| Premium feel, 10 erreurs "meh" | Premium Feel | 60-61 |
| Data viz, charts, sparklines, dashboard | K. Data Viz | 62-69 |
| Microcopy, labels boutons, ton | L. Microcopy | 70-71 |
| i18n, expansion texte, RTL, formats | M. i18n | 72-74 |
| Gamification (streaks, PBL, loops) | N. Gamification | 75-77 |
| Tables, data grids, sorting, responsive | O. Tables | 78-82 |
| Settings, toggle vs checkbox, destructive | P. Settings | 83-85 |
| Search UX, autocomplete, no results | Q. Search | 86-89 |
| Loading, skeleton, optimistic, offline | R. Loading | 90-93 |
| Dark mode surfaces, text, implementation | S. Dark Mode | 94-96 |
| Modals, bottom sheets, sizing, a11y | T. Modals | 97-100 |
| Animations, easing, micro-interactions | U. Animations | 101-104 |
| Onboarding types, permissions, empty | V. Onboarding | 105-108 |
| **Core Web Vitals (LCP, CLS, INP)** | **W. Performance** | **109** |
| Critical rendering path, CSS/JS loading | W. Performance | 110 |
| Font loading (swap, optional, preload) | W. Performance | 111 |
| Image optimization (WebP, AVIF, srcset) | W. Performance | 112 |
| Code splitting, bundle, tree shaking | W. Performance | 113 |
| Service workers, caching strategies | W. Performance | 114 |
| Above-the-fold, performance budget | W. Performance | 115 |
| **PWA manifest, icons, display modes** | **X. PWA** | **116** |
| Service worker lifecycle, update UX | X. PWA | 117 |
| Install prompt (beforeinstallprompt) | X. PWA | 118 |
| Offline-first patterns, app shell | X. PWA | 119 |
| Push notifications web (VAPID) | X. PWA | 120 |
| Web Share API, App Badge | X. PWA | 121 |
| **Container queries** | **Y. Responsive** | **122** |
| CSS Grid advanced, subgrid, named areas | Y. Responsive | 123 |
| Fluid typography (clamp) | Y. Responsive | 124 |
| Breakpoint strategy, touch/pointer | Y. Responsive | 125 |
| Responsive tables, responsive images | Y. Responsive | 126 |
| **Login form, social login, magic link** | **Z. Auth** | **127** |
| Registration flow, password strength | Z. Auth | 128 |
| 2FA/MFA UX (SMS, TOTP, passkey) | Z. Auth | 129 |
| Session management, timeout warning | Z. Auth | 130 |
| Passkeys, WebAuthn | Z. Auth | 131 |
| **Product page, cart, checkout** | **AA. E-commerce** | **132-134** |
| Pricing page design (SaaS tiers) | AA. E-commerce | 135 |
| Order confirmation, tracking, returns | AA. E-commerce | 136 |
| **Hero section patterns** | **AB. Landing** | **137** |
| Social proof placement | AB. Landing | 138 |
| CTA hierarchy & placement | AB. Landing | 139 |
| Footer patterns | AB. Landing | 140 |
| **404, 500, 503, 429 error pages** | **AC. Error Pages** | **141-142** |
| Browser fallbacks, print stylesheet | AC. Error Pages | 143 |
| **File upload, drop zone, progress** | **AD. Upload** | **144-145** |
| Gallery, carousel, video player | AD. Upload | 146 |
| **Map integration, lazy loading** | **AE. Maps** | **147** |
| Location permission UX, address autocomplete | AE. Maps | 148 |
| **WebSocket UX, reconnection** | **AF. Real-time** | **149** |
| Presence indicators, live cursors | AF. Real-time | 150 |
| Chat patterns, message states | AF. Real-time | 151 |
| **CRUD interfaces, delete confirmation** | **AG. Admin** | **152** |
| Data tables bulk operations | AG. Admin | 153 |
| Dashboard layout, KPI cards, sidebar | AG. Admin | 154 |
| **Mega menu, hover intent** | **AH. Navigation** | **155** |
| Command palette (Cmd+K) | AH. Navigation | 156 |
| Breadcrumbs, sticky header show/hide | AH. Navigation | 157 |
| **Cookie banner, GDPR consent** | **AI. GDPR** | **158** |
| Privacy & data rights (delete, export) | AI. GDPR | 159 |
| **Rich text editor, toolbar patterns** | **AJ. Rich Text** | **160** |
| Draft, autosave, version history | AJ. Rich Text | 161 |
| **Share buttons, comments, reactions** | **AK. Social** | **162** |
| User profiles, activity feed | AK. Social | 163 |
| **Memo rapide: performance budgets** | **AL. Valeurs Cles** | **164** |
| Breakpoints, z-index scale | AL. Valeurs Cles | 165-166 |
| Typography scale, spacing scale | AL. Valeurs Cles | 167-168 |
| Animation timings, WCAG reference | AL. Valeurs Cles | 169-170 |
| Media queries, autocomplete, HTTP codes | AL. Valeurs Cles | 171-174 |
| Minimum dimensions reference | AL. Valeurs Cles | 175 |
| **Design tokens, CSS variables, theming** | **AM. Design Tokens** | **176-178** |
| Token naming (primitive/semantic/component) | AM. Design Tokens | 176 |
| Theme switching (light/dark/brand) | AM. Design Tokens | 177 |
| Style Dictionary, Figma variables sync | AM. Design Tokens | 178 |
| **SEO, structured data, JSON-LD** | **AN. SEO** | **179-181** |
| Semantic HTML, meta tags, og:image | AN. SEO | 179 |
| Schema.org (Product, FAQ, Breadcrumb) | AN. SEO | 180 |
| Core Web Vitals as ranking signal | AN. SEO | 181 |
| **AI chat UI, conversational interfaces** | **AO. AI & Chat** | **182-184** |
| Prompt input, streaming response | AO. AI & Chat | 182 |
| Citations, confidence, regenerate | AO. AI & Chat | 183 |
| AI loading states, feedback (thumbs) | AO. AI & Chat | 184 |
| **Font pairing, variable fonts, system stacks** | **AP. Typography Advanced** | **185-187** |
| Variable font axes (wght/wdth/opsz) | AP. Typography Advanced | 185 |
| CJK font stacks, subsetting | AP. Typography Advanced | 186 |
| Google Fonts vs self-hosted, fallback | AP. Typography Advanced | 187 |
| **Accessibility testing methodology** | **AQ. A11y Testing** | **188-190** |
| axe-core, Lighthouse, Pa11y, NVDA | AQ. A11y Testing | 188 |
| Screen reader matrix, test cadence | AQ. A11y Testing | 189 |
| Bug severity P0-P3, compliance | AQ. A11y Testing | 190 |
| **Checkout address, payment deep** | **AR-bis. Checkout Deep** | **191-193** |
| Address autocomplete, Google Places | AR-bis. Checkout Deep | 191 |
| Express checkout (Apple Pay/Google Pay) | AR-bis. Checkout Deep | 192 |
| Subscription billing, promo code UX | AR-bis. Checkout Deep | 193 |
| **Content strategy, info architecture** | **AS. Content Strategy** | **194-196** |
| F-pattern, Z-pattern, inverted pyramid | AS. Content Strategy | 194 |
| Flesch-Kincaid, line length 45-75 chars | AS. Content Strategy | 195 |
| Heading hierarchy, above-the-fold | AS. Content Strategy | 196 |
| **Voice UI, Web Speech API** | **AT. Voice UI** | **197** |
| **Comparison tables, feature matrix** | **AU. Comparison Tables** | **198** |
| **FAQ, help center, accordion** | **AV. FAQ Patterns** | **199** |
| **Blog/article layout, reading time** | **AW. Blog Layout** | **200** |
| **Gallery, masonry, lightbox** | **AX. Gallery** | **201** |
| **Notification center, bell badge** | **AY. Notifications** | **202** |
| **Wizard/stepper visual specs** | **AZ. Wizard Specs** | **203** |
| **Date/time pickers, calendar** | **BA. Date Pickers** | **204** |
| **Conditional forms, branching logic** | **BB. Conditional Forms** | **205** |
| **Scroll animations, CSS scroll-timeline** | **BC. Scroll Animations** | **206** |
| **Print CSS, @page, invoice template** | **BD. Print Styles** | **207** |
| **Email design, table layout, dark mode** | **BE. Email Design** | **208** |
| **Reviews, star rating, testimonials** | **BF. Reviews** | **209** |
| **User profile, avatar, account pages** | **BG. Profile Pages** | **210** |
| **Pricing page extended, downgrade flow** | **BH. Pricing Extended** | **211** |
| **Tooltips, popovers, placement** | **BI. Tooltip Specs** | **212** |
| **Keyboard shortcuts, cheatsheet, Cmd+K** | **BJ. Keyboard Shortcuts** | **213** |
| **High contrast, forced-colors mode** | **BK. Forced Colors** | **214** |
| **Drag & drop, sortable lists, kanban** | **BL. Drag & Drop** | **215** |
| **Command palette, omnibar, fuzzy search** | **BM. Command Palette** | **216** |
| **Tab & accordion specs, ARIA pattern** | **BN. Tab & Accordion** | **217** |
| **Phone/currency/tag input, masked fields** | **BO. Form Fields Deep** | **218** |
| **Urgency/scarcity ethical patterns, FTC** | **BP. Urgency Ethical** | **219** |
| **A/B testing, anti-flicker, sample size** | **BQ. A/B Testing** | **220** |
| **Cognitive accessibility, WCAG 2.2, ADHD** | **BR. Cognitive A11y** | **221** |
| **CSP, XSS prevention, DOMPurify, Trusted Types** | **BS. Content Security** | **222** |
| **Web components, shadow DOM, slots** | **BT. Web Components** | **223** |
| **Multi-device continuity, QR handoff, PWA** | **BU. Multi-Device** | **224** |
| **Micro-frontends UX, module federation** | **BV. Micro-Frontends** | **225** |
| **Drag & drop advanced: kanban, file tree, multi-select** | **BW. DnD Advanced** | **226** |
| **View Transitions API, startViewTransition, MPA** | **BX. View Transitions** | **227** |
| **Popover API, light-dismiss, invoker buttons** | **BY. Popover API** | **228** |
| **CSS Anchor Positioning, @position-try** | **BZ. Anchor Positioning** | **229** |
| **Speculation Rules API, prefetch/prerender** | **CA. Speculation Rules** | **230** |
| **CSS @starting-style, entry animations** | **CB. @starting-style** | **231** |
| **CSS Cascade Layers, @layer, specificity** | **CC. Cascade Layers** | **232** |
| **CSS :has() selector, parent selection** | **CD. :has() Selector** | **233** |
| **CSS Nesting, native & selector** | **CE. CSS Nesting** | **234** |
| **List virtualization, windowing, content-visibility** | **CF. Virtualization** | **235** |
| **SSR/SSG/ISR/RSC, rendering patterns** | **CG. Rendering Patterns** | **236** |
| **CRDT, collaborative editing, presence** | **CH. CRDT & Collab** | **237** |
| **Navigation API, SPA navigation** | **CI. Navigation API** | **238** |
| **Third-party script performance, Partytown** | **CJ. 3P Scripts** | **239** |
| **Permissions Policy headers, feature control** | **CK. Permissions Policy** | **240** |
| **Web Vitals RUM, CrUX, performance monitoring** | **CL. Web Vitals RUM** | **241** |
| **Flexbox patterns, centering, sticky footer, grid** | **CM. Flexbox & Layout** | **242** |
| **Input field states (hover/focus/error/disabled)** | **CN. Input States** | **243** |
| **Border radius system (0-2-4-6-8-12-16-full)** | **CO. Border Radius** | **244** |
| **Color palette 60-30-10, neutral scale, semantic** | **CP. Color Palette** | **245** |
| **Spacing rules (margin vs padding vs gap)** | **CQ. Spacing Rules** | **246** |
| **Button hierarchy (primary/secondary/ghost/destructive)** | **CR. Button Hierarchy** | **247** |
| **Shadow & elevation system (6 levels + CSS values)** | **CS. Shadow System** | **248** |
| **Card component anatomy (header/media/body/actions)** | **CT. Card Anatomy** | **249** |
| **New CSS 2025 (@scope, color-mix, text-wrap, field-sizing, accordion, dialog)** | **CU. CSS 2025** | **250** |
| **Privacy Sandbox, Topics API, Attribution Reporting, post-cookie** | **CV. Privacy Sandbox** | **251** |
| **WebNN, Gemini Nano browser, on-device AI/ML, Prompt API** | **CW. Browser AI/ML** | **252** |

---

### Index MOBILE.md (recherche rapide)

| Besoin | Section | # |
|--------|---------|---|
| Touch targets iOS (44pt) | A. iOS HIG | 1 |
| Layout margins, safe areas iOS | A. iOS HIG | 2-3 |
| Typography SF Pro, Dynamic Type | A. iOS HIG | 4 |
| Tab bar iOS, navigation iOS | A. iOS HIG | 5-6 |
| Composants iOS dimensions | A. iOS HIG | 7 |
| Touch targets Android (48dp) | B. Android M3 | 8 |
| Spacing 8dp, typography Roboto M3 | B. Android M3 | 9-10 |
| Bottom navigation, drawer Android | B. Android M3 | 11-12 |
| Composants Android dimensions | B. Android M3 | 13 |
| Pull-to-refresh | C. Patterns Universels | 14 |
| Bottom sheets mobile | C. Patterns Universels | 15 |
| FAB (Floating Action Button) | C. Patterns Universels | 16 |
| Snackbar & toast | C. Patterns Universels | 17 |
| Gestes standards mobile | C. Patterns Universels | 18 |
| Push notifications mobile | C. Patterns Universels | 19 |
| Etats de chargement mobile | C. Patterns Universels | 20 |
| Tab bar vs bottom nav vs drawer | D. Navigation | 21 |
| App bars comparatif iOS/Android | D. Navigation | 22 |
| VoiceOver / TalkBack | E. Accessibilite | 23 |
| Modes accessibilite (text, contrast, motion) | E. Accessibilite | 24 |
| Touch targets tableau final | F. Dimensions | 25 |
| Composants tableau comparatif | F. Dimensions | 26 |
| Audit rapide 10 points, tests | G. Checklist | 27-28 |
| Dark mode couleurs semantiques, elevation | H. Dark Mode | 29-30 |
| Haptics (impact, notification, selection) | I. Haptics | 31 |
| Animation durees, easing iOS/Android | J. Animations | 32 |
| Keyboard handling | K. Keyboard | 33 |
| Autofill, types clavier, validation | L. Forms | 34-35 |
| Face ID, Touch ID, fingerprint | M. Biometrics | 36 |
| Demande de permissions (timing, flow) | N. Permissions | 37 |
| Offline mode, sync, connectivity | O. Offline | 38 |
| Splash / Launch screens | P. Splash | 39 |
| Empty states mobile | Q. Empty States | 40 |
| Tablets, iPad, multi-window | R. Tablets | 41 |
| Foldables Android, postures, hinge | S. Foldables | 42 |
| Spring animations, cross-env nav | T. Ajouts 2024-2026 | 43-46 |
| Quick reference valeurs critiques | U. Quick Reference | - |
| i18n mobile, RTL, formats locaux | V. i18n | 47-49 |
| Gamification (streaks, PBL, loops) | W. Gamification | 50-52 |
| Settings mobile (architecture, toggle) | X. Settings | 53-55 |
| Search mobile (input, autocomplete) | Y. Search | 56-58 |
| Animations mobile (timing, micro, reduce) | Z. Animations | 59-61 |
| **iOS Universal Links, Android App Links** | **AA. Deep Linking** | **62-63** |
| Deferred deep links, routing, debugging | AA. Deep Linking | 64-66 |
| **WidgetKit iOS, Jetpack Glance Android** | **AB. Widgets** | **67-68** |
| Widget design, interactive widgets | AB. Widgets | 69-70 |
| Lock screen widgets iOS 16+ | AB. Widgets | 71 |
| **Live Activities iOS, Dynamic Island** | **AC. Live Activities** | **72-73** |
| ActivityKit, ongoing notifications Android | AC. Live Activities | 74-75 |
| **App Clips iOS, Instant Apps Android** | **AD. App Clips** | **76-77** |
| Size limits, auth in clips | AD. App Clips | 78 |
| **StoreKit 2, Play Billing** | **AE. In-App Purchases** | **79** |
| Paywall design (soft vs hard) | AE. In-App Purchases | 80 |
| Subscription tiers, free trial, cancel | AE. In-App Purchases | 81-82 |
| **App icon guidelines (1024x1024, adaptive)** | **AF. ASO** | **83** |
| Screenshots, preview videos, keywords | AF. ASO | 84 |
| Review prompt timing (SKStoreReview) | AF. ASO | 85 |
| Privacy labels, Data safety | AF. ASO | 86 |
| **Share extension iOS/Android** | **AG. Share** | **87** |
| Quick Actions, Home shortcuts | AG. Share | 88 |
| App Intents, Siri Shortcuts | AG. Share | 89 |
| Photo/Document picker (PHPicker, SAF) | AG. Share | 90 |
| **Camera permission, viewfinder, capture** | **AH. Camera** | **91** |
| QR/Barcode scanning, image editing | AH. Camera | 92-93 |
| ARKit / ARCore patterns | AH. Camera | 94 |
| **MapKit, Google Maps SDK** | **AI. Maps** | **95** |
| Location permission (Always vs When In Use) | AI. Maps | 96 |
| Geofencing, store locator, offline maps | AI. Maps | 97 |
| **BGTaskScheduler iOS, WorkManager Android** | **AJ. Background** | **98** |
| Background location, silent push, battery | AJ. Background | 99 |
| **CoreData/SwiftData, Room/DataStore** | **AK. Data** | **100** |
| Keychain, EncryptedSharedPreferences | AK. Data | 101 |
| CloudKit/Firebase sync, data migration | AK. Data | 102 |
| **Certificate pinning, jailbreak detection** | **AL. Security** | **103** |
| Play Integrity API, OWASP Mobile Top 10 | AL. Security | 104 |
| Data encryption at rest | AL. Security | 105 |
| **UI testing (XCUITest, Espresso, Maestro)** | **AM. Testing** | **106** |
| Snapshot testing (swift-snapshot, Paparazzi) | AM. Testing | 107 |
| Performance profiling, crash monitoring | AM. Testing | 108 |
| **Navigation architecture, state restoration** | **AN. Architecture** | **109** |
| Feature flags, remote config, kill switch | AN. Architecture | 110 |
| **iOS app icon system, iOS 18 variants** | **AO. App Identity** | **111** |
| Android adaptive icons, splash screen API | AO. App Identity | 112 |
| **Apple Handoff, NSUserActivity** | **AP. Multi-Device** | **113** |
| Cross-device sync, conflict resolution | AP. Multi-Device | 114 |
| Companion device patterns (phone+watch) | AP. Multi-Device | 115 |
| **Switch Control, Voice Access** | **AQ. Accessibility** | **116** |
| Dynamic Type extreme (AX5), layout adapt | AQ. Accessibility | 117 |
| Smart Invert, high contrast, bold text | AQ. Accessibility | 118 |
| **Memo rapide: touch, typo, anim, colors** | **AR. Valeurs Cles** | **119-124** |
| Component size comparison iOS/Android | AR. Valeurs Cles | 122 |
| Platform-specific values (status bar, etc) | AR. Valeurs Cles | 123 |
| Checklist rapide universel mobile | AR. Valeurs Cles | 124 |
| **Color system, Material You, tint colors** | **AS. Color System** | **125-127** |
| Dynamic color (dynamicColorScheme) | AS. Color System | 125 |
| Design token naming (color.surface.elevated) | AS. Color System | 126 |
| Brand color mapping to M3 scheme | AS. Color System | 127 |
| **SF Symbols, Material Symbols, icon sizing** | **AT. Iconography** | **128-130** |
| Rendering modes (monochrome/hierarchical) | AT. Iconography | 128 |
| Icon sizing table (16/20/24/40/48dp) | AT. Iconography | 129 |
| Custom icon grid (24dp, 2dp padding) | AT. Iconography | 130 |
| **Gesture vocabulary complete** | **AU. Gestures** | **131-133** |
| Gesture conflict resolution hierarchy | AU. Gestures | 131 |
| Swipe-to-dismiss thresholds | AU. Gestures | 132 |
| Gesture discoverability (coach marks) | AU. Gestures | 133 |
| **Context menus, long press, peek** | **AV. Context Menus** | **134** |
| **Swipe actions on list items** | **AW. Swipe Actions** | **135** |
| **In-app messaging, banners, tooltips** | **AX. In-App Messaging** | **136** |
| **Onboarding patterns (carousel, progressive)** | **AY. Onboarding** | **137** |
| **Skeleton screens, shimmer specs** | **AZ. Skeletons** | **138** |
| **Infinite scroll vs pagination** | **BA. Infinite Scroll** | **139** |
| **Sticky headers, section indexing** | **BB. Sticky Headers** | **140** |
| **Crash recovery, state restoration** | **BC. Crash Recovery** | **141** |
| **Force update, soft update patterns** | **BD. Force Update** | **142** |
| **Bottom sheet detents, drag handle** | **BE. Bottom Sheets** | **143** |
| **Parallax, collapsing toolbar** | **BF. Parallax** | **144** |
| **Split view, multi-window, WindowSizeClass** | **BG. Split View** | **145** |
| **Picture-in-Picture** | **BH. PiP** | **146** |
| **Clipboard, paste permission iOS 16+** | **BI. Clipboard** | **147** |
| **Audio/video player, mini player** | **BJ. Media Player** | **148** |
| **Chat/messaging UI, bubbles, typing** | **BK. Chat UI** | **149** |
| **Social features, feeds, likes, double-tap** | **BL. Social** | **150** |
| **E-commerce mobile, product grid, cart** | **BM. E-Commerce** | **151** |
| **Financial app, balance, transactions** | **BN. Finance** | **152** |
| **Calendar, scheduling, time slots** | **BO. Calendar** | **153** |
| **Fitness/health tracking, rings, streaks** | **BP. Fitness** | **154** |
| **Push notification strategy, channels** | **BQ. Push Notifications** | **155** |
| **Voice interaction, Siri/Assistant** | **BR. Voice** | **156** |
| **QR code scanning, NFC UX** | **BS. QR/NFC** | **157** |
| **Bluetooth UX, pairing, connection** | **BT. Bluetooth** | **158** |
| **User profiles, avatars, upload** | **BU. Profiles** | **159** |
| **Design handoff, Figma to code, tokens** | **BV. Design Handoff** | **160** |
| **App rating prompt strategy** | **BW. App Rating** | **161** |
| **Error handling UX (comprehensive)** | **BX. Error Handling** | **162** |
| **Accessibility automation testing (CI)** | **BY. A11y Automation** | **163** |
| **AI/ML UX patterns, Core ML, ML Kit** | **BZ. AI/ML UX** | **164** |
| **Privacy regulation UX, GDPR, ATT, CCPA** | **CA. Privacy Regulation** | **165** |
| **Android 15 edge-to-edge mandatory** | **CB. Edge-to-Edge** | **166** |
| **Material You Expressive 2025** | **CC. Material Expressive** | **167** |
| **Passkeys, Credential Manager, FIDO2** | **CD. Passkeys** | **168** |
| **Thumb zone reachability, one-handed** | **CE. Thumb Zone** | **169** |
| **Scroll performance, list virtualization** | **CF. Scroll Perf** | **170** |
| **App launch, cold start performance** | **CG. App Launch** | **171** |
| **Image loading pipeline, caching** | **CH. Image Loading** | **172** |
| **Cross-platform pitfalls (Flutter/RN/KMP)** | **CI. Cross-Platform** | **173** |
| **visionOS spatial computing UX** | **CJ. visionOS** | **174** |
| **Samsung One UI guidelines** | **CK. Samsung One UI** | **175** |
| **Data visualization on mobile** | **CL. Data Viz Mobile** | **176** |
| **App size budget, thinning, bundles** | **CM. App Size** | **177** |
| **Predictive back gesture (Android 13+)** | **CN. Predictive Back** | **178** |
| **Per-app language (Android 13+ / iOS)** | **CO. Per-App Language** | **179** |
| **iOS 18 Control Center widgets** | **CP. Control Center** | **180** |
| **Baymard mobile checkout research data** | **CQ. Checkout Research** | **181** |
| **Color palette 60-30-10, brand-to-system, semantic** | **CR. Color Palette** | **182** |
| **Button hierarchy (filled/tonal/outlined/text/FAB)** | **CS. Button Hierarchy** | **183** |
| **Shadow & elevation (M3 tonal + iOS shadow + Flutter)** | **CT. Shadow System** | **184** |
| **Border radius system (0-4-8-12-16-20-28)** | **CU. Border Radius** | **185** |
| **Input field states (default/focus/error/disabled)** | **CV. Input States** | **186** |
| **Spacing decision framework (padding/margin/gap)** | **CW. Spacing Framework** | **187** |
| **iOS 19 Liquid Glass, SwiftUI 2025, glass modifiers** | **CX. iOS 19 Liquid Glass** | **188** |
| **Apple Intelligence (Writing Tools, Image Playground, Genmoji, Siri)** | **CY. Apple Intelligence** | **189** |
| **Android 16, Live Updates, Glance 2.0, Store requirements 2025** | **CZ. Android 16 & Store** | **190** |

---

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
| Outils prototypage (renvoi vers section complete) | AA. Outils Prototypage | 44-47 |
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
| **Multi-device continuity & handoff** | **AC. Cross-Device** | **50-54** |
| RemoteActivityHelper (ouvrir app phone depuis montre) | AC. Wear OS Handoff | 50a |
| ConfirmationActivity (SUCCESS, FAILURE, OPEN_ON_PHONE) | AC. Wear OS Handoff | 50b |
| Ongoing Activity API (continuite watch face + recents) | AC. Wear OS Handoff | 50c |
| Deep link notification montre -> app phone | AC. Wear OS Handoff | 50d |
| CapabilityClient (verifier app phone installee) | AC. Wear OS Handoff | 50e |
| Phone confirmation pattern (montre initie, phone confirme) | AC. Wear OS Handoff | 50f |
| MessageClient (sendMessage, sendRequest, 100KB max) | AC. Wear OS Handoff | 50g |
| Android 17 Handoff (setHandoffEnabled, HandoffActivityData) | AC. Wear OS Handoff | 50h |
| NSUserActivity Handoff (watchOS -> iPhone) | AC. watchOS Handoff | 51a |
| WCSession (5 methodes: sendMessage, transferUserInfo, etc.) | AC. watchOS Handoff | 51b |
| Arbre decision WCSession (quelle methode utiliser) | AC. watchOS Handoff | 51c |
| Quand rediriger vers phone vs gerer sur montre | AC. UX Cross-Device | 52a |
| Loading/waiting states pendant handoff | AC. UX Cross-Device | 52b |
| Error handling phone inatteignable (5 cas) | AC. UX Cross-Device | 52c |
| Reconnexion delais (Doze 4min, Bluetooth <1s) | AC. UX Cross-Device | 52d |
| NNGroup 5 composantes omnichannel (continuite, proactivite) | AC. UX Cross-Device | 52e |
| Decision tree handoff vs local | AC. UX Cross-Device | 52f |
| Standalone manifest + Horologist helpers | AC. Standalone Config | 53 |
| Checklist implementateur cross-device (14 items) | AC. Checklist | 54 |
| **Workout/exercise tracking UI** | **AD. Workout** | **55-57** |
| Real-time metrics layout (HR, pace, distance) | AD. Workout | 55 |
| Auto-pause/resume, GPS lock, multi-sport | AD. Workout | 56 |
| Post-workout summary, HR zone colors | AD. Workout | 57 |
| **Heart rate, SpO2, health data display** | **AE. Health Data** | **58-60** |
| HR zones (5 zones, color coding) | AE. Health Data | 58 |
| ECG recording flow, blood oxygen | AE. Health Data | 59 |
| Abnormal HR alerts, resting HR trend | AE. Health Data | 60 |
| **Sleep tracking UI, sleep stages** | **AF. Sleep** | **61-63** |
| Sleep stage visualization (REM/light/deep) | AF. Sleep | 61 |
| Sleep score, bedtime reminder | AF. Sleep | 62 |
| Night mode (dim, no haptics) | AF. Sleep | 63 |
| **Maps, turn-by-turn navigation on watch** | **AG. Maps Watch** | **64-66** |
| Map rendering constraints, haptic directions | AG. Maps Watch | 64 |
| Turn-by-turn layout (arrow + street + distance) | AG. Maps Watch | 65 |
| Compass, breadcrumb trail, route deviation | AG. Maps Watch | 66 |
| **Cellular vs Bluetooth-only UX** | **AH. Connectivity** | **67-68** |
| Connection state indicators, feature matrix | AH. Connectivity | 67 |
| LTE power, streaming vs offline | AH. Connectivity | 68 |
| **Music/media control on watch** | **AI. Media Control** | **69-70** |
| Now Playing layout, volume via crown | AI. Media Control | 69 |
| Offline sync, BT audio output selection | AI. Media Control | 70 |
| **Phone calls on watch** | **AJ. Phone Calls** | **71** |
| **Notification grouping, stacking** | **AK. Notif Grouping** | **72** |
| **Payment on watch (Apple Pay/Google Wallet)** | **AL. Payment** | **73** |
| **Messaging on watch** | **AM. Messaging** | **74** |
| **Fall detection, emergency SOS** | **AN. Emergency** | **75** |
| **watchOS 10+ changes (NavigationStack, Smart Stack)** | **AO. watchOS 10+** | **76** |
| **Wear OS 4/5 Material 3 migration** | **AP. Wear OS 4/5** | **77** |
| **Circular vs rectangular screen adaptation** | **AQ. Screen Shape** | **78** |
| **Animation constraints on watch** | **AR. Animation Limits** | **79** |
| Max simultaneous (2-3), duration limits | AR. Animation Limits | 79 |
| Lottie size limits tiles (<50KB), ambient rule | AR. Animation Limits | 79 |
| **Charging screen, dock/nightstand mode** | **AS. Charging** | **80** |
| **Water lock mode** | **AT. Water Lock** | **81** |
| **Smart home control on watch** | **AU. Smart Home** | **82** |
| **Camera remote control** | **AV. Camera Remote** | **83** |
| **Data density limits (consolidated reference)** | **AW. Data Density** | **84-85** |
| Max text chars per component table | AW. Data Density | 84 |
| Component count limits, visual density | AW. Data Density | 85 |
| **Medication reminder UI, adherence tracking** | **AX. Medication** | **86** |
| **Theater mode UX, wake suppression** | **AY. Theater Mode** | **87** |
| **Watch-to-watch communication, limitations** | **AZ. Watch-to-Watch** | **88** |
| **Multi-window/PiP: N/A on wearable (explicit)** | **BA. N/A Multi-Window** | **89** |
| **Voice interaction extended, dictation, assistant** | **BB. Voice Extended** | **90** |
| **Ultra-Wideband (UWB), precision finding** | **BC. UWB** | **91** |
| **watchOS background execution, refresh budgets** | **BD. Background Exec** | **92** |
| **watchOS WidgetKit complications** | **BE. WidgetKit Complic** | **93** |
| **watchOS 11 HealthKit APIs** | **BF. HealthKit 11** | **94** |
| **Wear OS 5 power efficiency** | **BG. Wear OS Power** | **95** |
| **App Store privacy labels for health data** | **BH. Privacy Labels** | **96** |
| **CoreML / TFLite on wearable** | **BI. On-Device ML** | **97** |
| **Garmin Connect IQ development** | **BJ. Garmin IQ** | **98** |
| **Fitbit OS / SDK (legacy + transition)** | **BK. Fitbit Legacy** | **99** |
| **ECG waveform rendering** | **BL. ECG Rendering** | **100** |
| **CGM integration (continuous glucose)** | **BM. CGM** | **101** |
| **AFib / irregular rhythm notification** | **BN. AFib Detection** | **102** |
| **Academic validation studies** | **BO. Academic Studies** | **103** |
| **watchOS SwiftUI app architecture** | **BP. watchOS SwiftUI** | **104** |
| **Health data confidence & quality indicators** | **BQ. Data Quality** | **105** |
| **Menstrual cycle tracking UX** | **BR. Cycle Tracking** | **106** |
| **Productivity app patterns on watch** | **BS. Productivity** | **107** |
| **Data sync indicator UI (syncing/synced/failed)** | **BT. Sync Indicator** | **108** |
| **Complication-to-instant-action (tap→action→confirm)** | **BU. Complication Action** | **109** |
| **Watch app icon specs (safe zone, sizes, adaptive)** | **BV. App Icon Specs** | **110** |
| **watchOS 12, Liquid Glass watch, Apple Intelligence, sleep apnea, Ultra depth** | **BW. watchOS 12 & AI** | **111** |
| **Gemini on Wear OS, Siri 2025, voice best practices, assistant comparison** | **BX. AI Assistants** | **112** |

---

*Mind map - pour le code complet voir WEB.md, MOBILE.md et WEARABLE.md*
