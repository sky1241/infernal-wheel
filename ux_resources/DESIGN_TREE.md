# DESIGN TREE - Arbre de Reflexion UX/UI

> L'arbre de decision ultime pour chaque phase du developpement
> Chaque branche = une decision, chaque feuille = une regle concrete
> Sources: Apple HIG, Material 3, WCAG 2.2, Stripe, Linear, Vercel, Baymard, NNG

---

## PHASE 0: GRAINE - Avant de Coder

### 0.1 Question Fondamentale
```
Qui est l'utilisateur et quel probleme resout-on?
         |
    +----+----+
    |         |
  Mobile    Desktop
  First?    First?
    |         |
    v         v
 MOBILE.md  WEB.md
```

### 0.2 Checklist Pre-Design
- [ ] Personas definis (qui utilise?)
- [ ] User journey mappe (quel parcours?)
- [ ] Contraintes techniques identifiees (offline? auth? temps reel?)
- [ ] Metriques de succes definies (conversion? retention? temps tache?)

---

## PHASE 1: RACINES - Fondations Systeme

### 1.1 Tokens de Base

```
                    DESIGN TOKENS
                         |
         +---------------+---------------+
         |               |               |
      SPACING         COLORS         TYPOGRAPHY
         |               |               |
    Base: 4px      Semantiques      Scale: rem
         |               |               |
   0,4,8,12,16,    Primary,        Body: 16px
   20,24,32,48     Surface,        Heading: scale
                   OnSurface,
                   Error/Success
```

#### Spacing System (Base 4px)
```css
:root {
  --sp-0: 0;
  --sp-1: 4px;   /* micro: icon-text */
  --sp-2: 8px;   /* small: related elements */
  --sp-3: 12px;  /* compact padding */
  --sp-4: 16px;  /* standard padding */
  --sp-6: 24px;  /* group separation */
  --sp-8: 32px;  /* section gap */
  --sp-12: 48px; /* major sections */
  --sp-16: 64px; /* page sections desktop */
}
```

#### Color Tokens (Semantiques)
```css
:root {
  /* Surfaces */
  --surface: #1a1a2e;
  --surface-variant: #252542;
  --on-surface: #ffffff;
  --on-surface-variant: rgba(255,255,255,0.7);

  /* Actions */
  --primary: #35d99a;
  --on-primary: #000000;
  --accessible-on-primary: #000000; /* Garantit 4.5:1 */

  /* Feedback */
  --error: #ff4d4d;
  --on-error: #ffffff;
  --success: #35d99a;
  --warning: #f6b73c;

  /* Utility */
  --border: rgba(255,255,255,0.08);
  --border-focus: rgba(53,217,154,0.5);
}
```

#### Typography Scale
```css
:root {
  /* Fluid base */
  --text-body: clamp(15px, 0.95rem + 0.2vw, 18px);
  --text-small: clamp(13px, 0.8rem + 0.1vw, 14px);

  /* Headings */
  --text-h1: clamp(28px, 1.5rem + 2vw, 48px);
  --text-h2: clamp(22px, 1.2rem + 1.2vw, 36px);
  --text-h3: clamp(18px, 1rem + 0.8vw, 24px);

  /* Labels vs Copy */
  --lh-label: 1.2;  /* single-line, icon alignment */
  --lh-copy: 1.5;   /* multi-line, readability */

  /* Weights */
  --fw-regular: 400;  /* body text */
  --fw-medium: 500;   /* labels, emphasis */
  --fw-bold: 700;     /* headings, CTA */
}
```

### 1.2 Regle de Densite (Linear)

> "Density is not smaller spacing. Density is more information per pixel without increasing visual entropy."

```
DENSITE = Alignment + Baselines + Typographic Roles + Restrained Contrast
              |            |              |                    |
         Grille 4px    Line-height    Label vs Copy      Max 3-4 niveaux
                       consistant     distinction        de contraste
```

---

## PHASE 2: TRONC - Structure & Layout

### 2.1 Arbre de Decision Layout

```
                    QUEL LAYOUT?
                         |
         +---------------+---------------+
         |                               |
    Mobile (<768px)              Desktop (>=1024px)
         |                               |
    +----+----+                  +-------+-------+
    |         |                  |               |
  Simple    Complex           Dashboard      Marketing
    |         |                  |               |
  Stack    Tab Bar           Sidebar +        Hero +
  vertical  bottom           Main area       Sections
```

### 2.2 Marges Responsives

| Breakpoint | Marge laterale | Max-width contenu |
|------------|----------------|-------------------|
| < 480px    | 16px           | 100%              |
| 768px      | 32px           | 100%              |
| 1024px+    | 80px           | 1120px            |

```css
.container {
  max-width: 1120px;
  margin-inline: auto;
  padding-inline: clamp(1rem, 5vw, 5rem);
}
```

### 2.3 Navigation Decision Tree

```
           COMBIEN DE DESTINATIONS?
                    |
        +-----------+-----------+
        |           |           |
      2-3         4-5          6+
        |           |           |
    Tabs ou     Tab Bar      Navigation
    Segmented   (mobile)      Drawer
    Control     Bottom Nav    ou Sidebar
                (Android)
                    |
              Labels TOUJOURS
              (jamais icons seuls)
```

#### Command Palette (Power Users)
```
Disponible partout (Cmd+K / Ctrl+K)
         |
    +----+----+
    |         |
 Predictable  Scoped
 shortcut     results
    |         |
 Toujours     Ranked by
 meme key     relevance
```

---

## PHASE 3: BRANCHES - Composants

### 3.1 Touch Targets Decision

```
         ELEMENT INTERACTIF?
                |
           +----+----+
           |         |
         Oui        Non
           |         |
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

### 3.2 Boutons

```css
.btn {
  /* Dimensions */
  min-height: 44px;           /* touch target */
  padding: 12px 24px;
  border-radius: 8px;

  /* Typography */
  font-size: var(--text-body);
  font-weight: var(--fw-medium);

  /* States */
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn:hover {
  filter: brightness(1.1) saturate(1.3);
}

.btn:active {
  filter: brightness(0.95) saturate(1.4);
  transform: scale(0.98);
}

.btn:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  /* TOUJOURS expliquer pourquoi via tooltip */
}
```

### 3.3 Inputs & Forms

```
        TYPE DE CHAMP?
              |
    +---------+---------+
    |         |         |
  Texte    Select    Toggle
    |         |         |
    v         v         v

Label VISIBLE (jamais placeholder seul)
         |
    +----+----+
    |         |
 Au-dessus  Floating
 (simple)   (compact)
```

#### Validation Decision Tree

```
         QUAND VALIDER?
              |
    +---------+---------+
    |                   |
 Pendant saisie      Au blur
 (JAMAIS rouge       (standard)
  des 1er char)          |
       |            Erreur si invalide
       v            Succes si valide
  Apres 3+ chars         |
  ET pause 250ms    Retirer erreur
       |            des correction
  Feedback positif
  discret si OK
```

```javascript
// Pattern Baymard: validation timing
function validateField(input) {
  const value = input.value;

  // Eviter validation prematuree
  if (value.length < 3) {
    input.dataset.state = "editing";
    return;
  }

  // Debounce 250ms
  clearTimeout(input._validateTimeout);
  input._validateTimeout = setTimeout(() => {
    const isValid = runValidation(value);
    input.dataset.state = isValid ? "valid" : "invalid";
  }, 250);
}

// Au blur: validation immediate
input.addEventListener("blur", () => {
  const isValid = runValidation(input.value);
  input.dataset.state = isValid ? "valid" : "invalid";
});
```

### 3.4 Cards

```css
.card {
  padding: var(--sp-4);        /* 16px */
  border-radius: 12px;
  background: var(--surface-variant);
  border: 1px solid var(--border);

  /* Elevation subtle */
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

/* Regle: 1 card = 1 sujet, hierarchie claire */
```

---

## PHASE 4: FEUILLES - Interactions & Feedback

### 4.1 Feedback Timing

```
         DUREE DE L'ACTION?
                |
    +-----------+-----------+
    |           |           |
  < 100ms    100ms-2s      > 2s
    |           |           |
  Aucun      Spinner     Progress
  indicateur  subtil       bar
    |           |           |
  Instantane  Ou skeleton  Avec %
              si contenu   si possible
              structure
```

### 4.2 Motion Tokens

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
    hover,       navigation,  entree/
    toggle,      modal,       sortie
    ripple       drawer       ecran
```

#### iOS Spring Values
```swift
// Subtil (plupart des cas)
bounce: 0.15

// Noticeable (feedback important)
bounce: 0.30

// Caution! (peut etre too much)
bounce: 0.40+
```

### 4.3 Toast/Snackbar Decision

```
         TYPE DE MESSAGE?
                |
    +-----------+-----------+
    |           |           |
  Succes      Erreur      Action
    |           |           |
  Toast       Alert ou    Snackbar
  auto 4s     inline      avec Undo
    |           |           |
  Position:   Focus sur   1 action max
  bottom      le champ    "ANNULER"
```

```css
.toast {
  position: fixed;
  bottom: calc(env(safe-area-inset-bottom) + 80px); /* Au-dessus nav */
  left: 50%;
  transform: translateX(-50%);

  padding: 12px 24px;
  border-radius: 8px;
  background: var(--surface-variant);

  /* Animation entree */
  animation: slideUp 0.3s ease-out;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}
```

### 4.4 Haptics (Mobile)

```
         QUEL MOMENT?
              |
    +---------+---------+---------+
    |         |         |         |
  Impact   Selection  Notification
    |         |         |         |
  Snap,    Picker,    Success,
  collision scroll    Warning,
    |       detent     Error
    |         |         |
  light/   JAMAIS     Coupler avec
  medium/  sur tap    visuel TOUJOURS
  heavy    confirmer
```

---

## PHASE 5: FRUITS - Conversion & Trust

### 5.1 Checkout Optimization (Baymard 2024)

```
BENCHMARKS 2024:
- Average: 5.1 steps, 11.3 fields
- Cart abandonment: 70.22%
- 18% abandon due to complexity

REGLE CRITIQUE:
"Field burden > step count"
= Reduire les CHAMPS, pas forcement les etapes
```

```
         CHECKOUT FLOW
              |
    +---------+---------+
    |                   |
 Guest checkout      Account
 PROMINENT!          required?
    |                   |
 62% sites            Delayed:
 le cachent           creer compte
    |                 APRES paiement
 = abandons
```

#### Two-Stage Validation (Credit Card)
```
1. Front-end: valider format, expiry, CVV length
   (non-sensitive, pas de re-saisie si erreur serveur)

2. Serveur: valider carte reelle
   (si echec, ne pas effacer les champs)
```

### 5.2 Trust Signals

```
         OU PLACER LA CONFIANCE?
                  |
    +-------------+-------------+
    |             |             |
 Paiement     Formulaire    Footer
    |             |             |
 Encadrer     Microcopy      Logos
 visuellement  rassurant     partenaires
 les champs       |          Contact
    |         "Securise"     Mentions
 Badges       "Pas de spam"
 proches
```

---

## PHASE 6: POLLINISATION - Accessibilite

### 6.1 WCAG 2.2 Quick Check

```
MUST-HAVE (Level AA):
         |
    +----+----+----+----+
    |    |    |    |    |
 Touch  Contrast Focus Keyboard
 24px+  4.5:1   visible  tout
        text    2px+     navigable
        3:1     outline
        UI
```

### 6.2 Focus Management

```css
:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
  box-shadow: 0 0 0 4px rgba(53, 217, 154, 0.3);
}

/* Skip link */
.skip-link {
  position: absolute;
  top: -100px;
  left: 16px;
  z-index: 9999;
  padding: 8px 16px;
  background: var(--primary);
  color: var(--on-primary);
  border-radius: 4px;
}

.skip-link:focus {
  top: 16px;
}
```

### 6.3 Reduced Motion

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

### 6.4 Text Spacing Resilience (WCAG 1.4.12)

```css
/* Doit survivre a ces overrides sans casser: */
body {
  line-height: 1.5;        /* Tolerance: 1.5x */
  letter-spacing: 0.02em;  /* Tolerance: 0.12x */
  word-spacing: 0.04em;    /* Tolerance: 0.16x */
}

/* Test: appliquer ces valeurs et verifier pas de chevauchement */
```

---

## PHASE 7: RECOLTE - Validation & Tests

### 7.1 Checklist Pre-Launch

#### Touch & Interaction
- [ ] Toutes cibles >= 44px (ou 24px avec spacing exception)
- [ ] Espacement entre cibles >= 8px
- [ ] Gestes ont alternatives visibles (boutons)

#### Visuel
- [ ] Contraste texte >= 4.5:1
- [ ] Contraste composants >= 3:1
- [ ] Couleur jamais seule pour info (+ icone ou texte)

#### Clavier
- [ ] Tab order logique
- [ ] Focus visible sur TOUT
- [ ] Modales piege pas le focus
- [ ] Esc ferme les overlays

#### Feedback
- [ ] Actions < 100ms = pas d'indicateur
- [ ] Actions > 100ms = spinner ou skeleton
- [ ] Erreurs = quoi + pourquoi + comment corriger
- [ ] Succes = confirmation appropriee

#### Forms
- [ ] Labels visibles (pas placeholder seul)
- [ ] Validation non prematuree
- [ ] Autocomplete sur champs standards
- [ ] Erreurs adjacentes au champ

### 7.2 DOM Measurement (Production Sites)

```javascript
// Mesurer les marges reelles d'un site de reference
(() => {
  const el = document.querySelector("main") || document.body;
  const r = el.getBoundingClientRect();
  return {
    viewport: { w: window.innerWidth, h: window.innerHeight },
    mainRect: { x: r.x, y: r.y, w: r.width, h: r.height },
    leftMargin: Math.round(r.x),
    rightMargin: Math.round(window.innerWidth - (r.x + r.width)),
  };
})();

// Repeter a 375, 768, 1024, 1440, 1920px
```

### 7.3 Test Matrix

| Test | Methode | Outils |
|------|---------|--------|
| Touch targets | Mesurer bounds | Accessibility Inspector |
| Contraste | Calculer ratio | WebAIM Contrast Checker |
| Clavier | Naviguer sans souris | Tab, Shift+Tab, Enter, Esc |
| Screen reader | Parcourir page | VoiceOver, NVDA, TalkBack |
| Responsive | Tester breakpoints | DevTools responsive |
| Motion | Activer reduce motion | OS settings |
| Dark mode | Toggle theme | OS settings |
| Offline | Mode avion | DevTools Network |

---

## QUICK REFERENCE - Valeurs Cles

| Domaine | Valeur | Source |
|---------|--------|--------|
| Touch iOS | 44pt | Apple HIG |
| Touch Android | 48dp | Material 3 |
| Touch Web min | 24px | WCAG 2.5.8 |
| Touch Web ideal | 44px | Best practice |
| Spacing base | 4px | Universal |
| Contraste texte | 4.5:1 | WCAG 1.4.3 |
| Contraste UI | 3:1 | WCAG 1.4.11 |
| Focus outline | 2px solid | WCAG 2.4.13 |
| Animation micro | 100-200ms | Universal |
| Animation standard | 250-350ms | Material 3 |
| Bounce subtle | 0.15 | Apple |
| Checkout fields avg | 11.3 | Baymard 2024 |
| Cart abandonment | 70.22% | Baymard 2025 |

---

## ARBRE MENTAL - Resume

```
                         DESIGN
                           |
              +------------+------------+
              |            |            |
           TOKENS       LAYOUT      COMPONENTS
              |            |            |
         Spacing       Responsive    Touch 44px+
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
                 Undo        Reduce motion
                     |           |
                     +-----+-----+
                           |
                      CONVERSION
                           |
                    Field burden
                    Guest checkout
                    Trust signals
                    Two-stage validation
```

---

*Document genere le 2026-02-09*
*Sources: Apple HIG, Material 3, WCAG 2.2, Stripe, Linear, Vercel, Baymard, NNG*
*Consolide depuis: WEB.md, MOBILE.md, ChatGPT Deep Research*
