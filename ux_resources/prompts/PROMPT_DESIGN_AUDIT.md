# MODE DESIGN AUDIT PRO - De noob a pro en un screenshot

## QUAND L'UTILISER
L'user envoie un screenshot (app, site, montre) et veut que ca devienne pro.
Trigger: "audit", "c'est moche", "fix le design", "rend ca pro", screenshot seul, ou n'importe quel commentaire negatif sur l'apparence.

## COMMENT L'UTILISER
1. Envoie un screenshot
2. Dis ce que tu veux OU juste envoie la photo
3. Je fais le diagnostic complet, je montre, tu valides, je code

---

## INSTRUCTIONS POUR CLAUDE

### CONTEXTE
- Stack: Flutter mobile + Wear OS watch + site web
- Bibles UX (TOUJOURS consulter AVANT de critiquer):
  - `ux_resources/WEB.md` (15,669 lignes, 107 sections A-CW)
  - `ux_resources/MOBILE.md` (15,508 lignes, 105 sections A-CZ)
  - `ux_resources/WEARABLE.md` (13,132 lignes, 76 sections A-BX)
  - `ux_resources/DESIGN_TREE.md` (index ~510 entrees)
- Regles basees sur les bibles = sources pro (Material Design 3, Apple HIG, WCAG 2.2, NNGroup, Baymard)
- JAMAIS proposer un fix sans reference bible

---

## PARTIE 1: LES 7 PECHES CAPITAUX DU NOOB

Ce sont les erreurs que TOUS les debutants font. Les detecter en priorite.

### PECHE 1: "L'arc-en-ciel" - Trop de couleurs
```
NOOB: 6-8 couleurs random, chaque bouton une couleur differente, fond bleu texte vert
PRO:  3 couleurs max (primary + neutral + 1 accent), tout le reste est gris/blanc/noir

DETECTION: compter les couleurs distinctes sur le screenshot
  > 4 couleurs non-neutres visibles = probleme garanti

FIX RAPIDE:
  1. Garder 1 seule couleur accent (la plus presente ou la marque)
  2. Tout le reste → neutres (gris, blanc, noir)
  3. Appliquer 60-30-10: 60% fond neutre, 30% surfaces secondaires, 10% accent
```

### PECHE 2: "Le sapin de Noel" - Tout est important
```
NOOB: 4 boutons colores, 3 titres en gras, texte rouge + vert + bleu sur la meme page
PRO:  1 seul CTA primary, 1 titre principal, hierarchie claire du plus au moins important

DETECTION: compter les elements "forts" (colores, gras, gros, encadres)
  > 2 elements qui crient "regarde-moi" = pas de hierarchie

FIX RAPIDE:
  1. Choisir LE truc le plus important de l'ecran → primary button (filled, colore)
  2. Tout le reste → secondary (outlined) ou tertiary (text only)
  3. 1 seul titre en gros, les sous-titres plus petits et plus legers
```

### PECHE 3: "Le tetris" - Spacing anarchique
```
NOOB: 7px ici, 13px la, 22px plus bas, rien n'est aligne
PRO:  TOUT est multiple de 4 ou 8 (4, 8, 12, 16, 24, 32, 48)

DETECTION: les elements semblent "poses au hasard", les gaps varient sans raison
  Comparer les espaces entre elements similaires: s'ils different = probleme

FIX RAPIDE:
  1. Padding dans les cards/containers: 16px partout
  2. Gap entre elements: 8px (serre) ou 16px (normal)
  3. Marge ecran: 16dp mobile, 24px web
  4. Entre sections: 24px ou 32px
  5. VERIFIER: tout est multiple de 4
```

### PECHE 4: "L'invisible" - Contraste insuffisant
```
NOOB: texte gris clair (#ccc) sur fond blanc, texte bleu sur fond violet
PRO:  ratio minimum 4.5:1 pour le texte, 3:1 pour les elements UI

DETECTION: plisser les yeux → si du texte disparait = probleme
  Texte secondaire souvent le pire (dates, labels, placeholders)

FIX RAPIDE:
  Texte principal: #111827 (quasi noir) sur fond clair
  Texte secondaire: #6b7280 (gris moyen), JAMAIS plus clair
  Texte sur fond colore: #fff (blanc) si fond sombre, #111 si fond clair
  Placeholder: #9ca3af (gris) mais label AU-DESSUS du champ en #374151
```

### PECHE 5: "Le frankenstein" - Mix de styles
```
NOOB: bouton rond + bouton carre + bouton pill sur la meme page, 3 tailles d'icones
PRO:  meme border-radius partout, meme taille d'icones, meme style partout

DETECTION: chaque element semble venir d'un template different

FIX RAPIDE:
  1. Choisir 1 border-radius pour les boutons (8px), 1 pour les cards (12px)
  2. Toutes les icones: meme style (outline OU filled), meme taille (24px)
  3. Meme font partout, meme poids (regular + semibold max)
  4. Meme style de shadow partout (ou pas de shadow du tout)
```

### PECHE 6: "Le roman" - Trop de texte, pas de hierarchie
```
NOOB: paragraphes denses, tout en meme taille, pas de titres, mur de texte
PRO:  hierarchie claire, texte court, whitespace genereux

DETECTION: les blocs de texte de > 3 lignes sans titre ni separation

FIX RAPIDE:
  1. Titre: 20-24sp bold → Sous-titre: 16sp semibold → Body: 14sp regular → Caption: 12sp
  2. Couper le texte: max 2-3 lignes par bloc
  3. Ajouter du whitespace: padding 24px entre sections
  4. Line-height: 1.5 pour le body (ca respire)
```

### PECHE 7: "Le claustrophobe" - Zero whitespace
```
NOOB: tout colle bord a bord, pas d'air, pas de respiration
PRO:  le vide est un element de design, il guide l'oeil

DETECTION: les elements se touchent presque, le fond est a peine visible

FIX RAPIDE:
  1. Ajouter padding 16px dans chaque card/container
  2. Gap 16px entre les cards
  3. Marge 16dp sur les cotes de l'ecran
  4. Section spacing 32px entre blocs logiques
  5. Regle: EN CAS DE DOUTE, AJOUTER DE L'ESPACE
```

---

## PARTIE 2: LE DESIGN SYSTEM PRET A COPIER

### PALETTE COULEUR - Copier-coller dans ton app

```
== PALETTE NEUTRE (obligatoire, c'est 80% de ton UI) ==
50:  #FAFAFA   ← fond de page (light mode)
100: #F5F5F5   ← fond de card, surface secondaire
200: #E5E5E5   ← bordures, dividers
300: #D4D4D4   ← bordures hover, inputs default
400: #A3A3A3   ← placeholder text, icones inactives
500: #737373   ← texte secondaire (dates, labels)
600: #525252   ← texte semi-important
700: #404040   ← texte important
800: #262626   ← titres
900: #171717   ← texte principal body
950: #0A0A0A   ← titres hero, maximum contraste

== 1 COULEUR PRIMAIRE (ta marque) ==
Prendre UNE couleur et generer les variantes:
  Light:  color-mix(in srgb, PRIMARY, white 40%)   ← fond de badge, bg hover
  Base:   ta couleur primaire                        ← boutons, liens, accents
  Dark:   color-mix(in srgb, PRIMARY, black 20%)    ← hover bouton, pressed
  Subtle: rgba(PRIMARY, 0.08)                        ← fond de selection, bg hover ghost

Exemple avec bleu:
  Light:  #BFDBFE
  Base:   #3B82F6
  Dark:   #1D4ED8
  Subtle: rgba(59,130,246,0.08)

== COULEURS SEMANTIQUES (ne pas changer, standards universels) ==
  Success:  #22C55E (vert)  ← confirmation, valide, reussi
  Warning:  #F59E0B (orange) ← attention, presque plein
  Error:    #EF4444 (rouge)  ← erreur, echec, destructif
  Info:     #3B82F6 (bleu)   ← aide, info, neutre positif

== DARK MODE (ne PAS inverser, REMAPPER) ==
  Fond page:     #121212
  Fond card:     #1E1E1E
  Fond elevated: #252525
  Bordures:      #333333
  Texte body:    #E5E5E5
  Texte secondaire: #A3A3A3
  Primary:       desaturer de 10% (moins vif)
```

### ECHELLE TYPO - Copier-coller

```
== MOBILE (Flutter) ==
  Display:    34sp, FontWeight.w400, height: 1.12   ← jamais ou presque
  Headline:   24sp, FontWeight.w400, height: 1.17   ← titre de page
  Title:      16sp, FontWeight.w600, height: 1.25   ← titre de card/section
  Body:       14sp, FontWeight.w400, height: 1.43   ← texte courant
  Label:      12sp, FontWeight.w500, height: 1.33   ← boutons, tabs, tags
  Caption:    11sp, FontWeight.w400, height: 1.45   ← dates, metadata, aide

== WEB ==
  h1:     32px, font-weight:700, line-height:1.2    ← titre de page
  h2:     24px, font-weight:600, line-height:1.25   ← titre de section
  h3:     20px, font-weight:600, line-height:1.3    ← sous-section
  body:   16px, font-weight:400, line-height:1.5    ← texte courant
  small:  14px, font-weight:400, line-height:1.43   ← labels, aide
  caption:12px, font-weight:400, line-height:1.5    ← metadata

== WATCH ==
  Title:  18sp, FontWeight.w500   ← titre ecran
  Body:   15sp, FontWeight.w400   ← contenu principal
  Caption:13sp, FontWeight.w400   ← secondaire
  REGLE: max 3 lignes visibles, texte court toujours
```

### ECHELLE SPACING - Copier-coller

```
Unites: TOUT est multiple de 4. Utiliser ces valeurs et RIEN d'autre.

  4px   ← espace icone-texte compact, gap entre avatar et nom
  8px   ← gap entre elements dans un groupe (boutons, chips, tags)
  12px  ← gap entre lignes dans une liste, padding petit
  16px  ← padding card standard, marge ecran mobile, gap entre cards
  24px  ← separation entre sections, padding section web
  32px  ← grande separation entre blocs
  48px  ← mega separation (hero → contenu), padding vertical section web
  64px  ← section padding web genereux

USAGE CONCRET:
  Icone + texte a cote:     gap 8px
  Boutons cote a cote:      gap 8px
  Champs de form empiles:   gap 16px
  Cards dans une grille:    gap 16px
  Section titre → contenu:  gap 8px (titre colle a son contenu)
  Section → section:        gap 32px
  Dernier element → bottom nav: 80px (pas cache derriere)
```

### ECHELLE BORDER-RADIUS - Copier-coller

```
  0px     ← tables, code, lignes horizontales
  4px     ← badges, tags, chips, petits elements
  8px     ← boutons, inputs, tooltips, toasts
  12px    ← cards, dropdowns, popovers, search bar
  16px    ← grandes cards, modals, panels
  9999px  ← pill buttons, avatars, status dots, toggle

REGLE: utiliser MAX 3 valeurs differentes dans toute l'app
  Exemple: 8 (boutons+inputs) + 12 (cards) + 9999 (avatars) = coherent
  Exemple nul: 4 + 6 + 8 + 10 + 12 + 16 + 20 = frankenstein
```

### ECHELLE SHADOW - Copier-coller

```
== WEB (CSS) ==
  --shadow-sm:  0 1px 2px rgba(0,0,0,0.05)                           ← cards repos
  --shadow:     0 1px 3px rgba(0,0,0,0.1), 0 1px 2px rgba(0,0,0,0.06) ← cards hover, dropdown
  --shadow-md:  0 4px 6px rgba(0,0,0,0.07), 0 2px 4px rgba(0,0,0,0.06) ← popover, tooltip
  --shadow-lg:  0 10px 15px rgba(0,0,0,0.1), 0 4px 6px rgba(0,0,0,0.05) ← modal, drawer
  --shadow-xl:  0 20px 25px rgba(0,0,0,0.1), 0 8px 10px rgba(0,0,0,0.04) ← toast, floating

== MOBILE (Flutter) ==
  Card:     BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: Offset(0,1))
  Elevated: BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: Offset(0,2))
  Modal:    BoxShadow(color: Colors.black.withOpacity(0.16), blurRadius: 24, offset: Offset(0,8))

== WATCH ==
  Pas de shadow. Utiliser surface color (tonal elevation M3).
  Level 1: surface + 5% primary tint
  Level 2: surface + 8% primary tint

REGLE DARK MODE: shadow presque invisible → utiliser bordure 1px rgba(255,255,255,0.05)
```

### BOUTONS - Copier-coller

```
== HIERARCHY (du plus fort au plus faible) ==

  PRIMARY (1 seul par ecran, l'action PRINCIPALE):
    Flutter: ElevatedButton / FilledButton
    Web:     bg primary, text white, border none, shadow-sm
    Taille:  40dp mobile, 36px web, 48dp watch

  SECONDARY (actions alternatives):
    Flutter: OutlinedButton
    Web:     bg white, text gray-700, border 1px solid gray-300
    Taille:  meme que primary

  TERTIARY (actions mineures, annuler, voir plus):
    Flutter: TextButton
    Web:     bg transparent, text primary, border none
    Taille:  meme hauteur, padding plus petit

  DESTRUCTIVE (supprimer, deconnexion, actions irreversibles):
    Flutter: FilledButton avec colorScheme.error
    Web:     bg #EF4444, text white
    TOUJOURS: confirmation avant execution (dialog/bottom sheet)

  GHOST/ICON ONLY (fermer, overflow menu, navigation):
    Flutter: IconButton
    Web:     bg transparent, icon 20px, hover bg rgba(0,0,0,0.04)
    Touch:   48dp minimum meme si icone fait 24dp

== ETATS ==
  Default:  couleurs normales
  Hover:    bg legrement plus sombre (+8% overlay noir) [web/desktop seulement]
  Pressed:  bg encore plus sombre (+12%), pas de shadow, leger translateY(1px)
  Disabled: opacity 0.38, cursor not-allowed, JAMAIS de click handler
  Loading:  spinner qui remplace le texte, meme taille bouton, pointer-events:none
  Focus:    ring 2px offset 2px primary color (clavier, a11y)
```

---

## PARTIE 3: WORKFLOW D'AUDIT SCREENSHOT

### ETAPE 1: SCANNER LE SCREENSHOT
```
Recevoir le screenshot → en 5 secondes identifier:
1. PLATEFORME: mobile? web? watch? → quelle bible lire
2. TYPE D'ECRAN: accueil? form? liste? detail? settings?
3. PREMIERE IMPRESSION: qu'est-ce qui "cloche" instinctivement?
4. LABELLISER chaque zone: [A] header, [B] card principale, [C] boutons, etc.
```

### ETAPE 2: CHECKER LES 7 PECHES
```
Pour chaque peche (dans l'ordre):
1. Arc-en-ciel? → Compter les couleurs non-neutres
2. Sapin de Noel? → Compter les elements "forts"
3. Tetris? → Les spacings sont-ils reguliers et multiples de 4/8?
4. Invisible? → Plisser les yeux, du texte disparait?
5. Frankenstein? → Chaque element a le meme style?
6. Roman? → Des blocs de texte de > 3 lignes sans hierarchie?
7. Claustrophobe? → Les elements respirent?
```

### ETAPE 3: AUDIT TECHNIQUE (12 axes)

#### Axe 1: COULEURS
Bible: WEB CP / MOBILE CR / WEARABLE AS
- [ ] 60-30-10 respecte (60% neutre bg, 30% surface secondaire, 10% accent)
- [ ] Contraste AA: 4.5:1 texte normal, 3:1 texte large + UI elements
- [ ] Semantique: success=vert, error=rouge, warning=orange
- [ ] Max 1 couleur primaire + neutres (pas de rainbow)
- [ ] Dark mode: fond #121212, surfaces #1E1E1E, pas de pur noir #000 pour les textes

#### Axe 2: TYPOGRAPHIE
Bible: WEB G / MOBILE A-B / WEARABLE D
- [ ] Hierarchie visible: titre >> sous-titre >> body >> caption (taille ET weight)
- [ ] Body: 16px web, 14sp mobile, 15sp watch (MINIMUM)
- [ ] Line-height: 1.5 body, 1.2-1.3 titres
- [ ] Max 2 font-weights (400 regular + 600 semibold)
- [ ] Texte tronque proprement: ellipsis, maxLines, pas de mot coupe

#### Axe 3: SPACING
Bible: WEB CQ / MOBILE CW / WEARABLE 8
- [ ] Grille 4/8px: TOUT multiple de 4 (padding, margin, gap)
- [ ] Padding cards: 16px uniforme (pas 12 gauche 20 droite)
- [ ] Marge ecran: 16dp mobile, 24px web
- [ ] Gap uniforme entre elements similaires
- [ ] Whitespace suffisant: ca respire, pas colle

#### Axe 4: BOUTONS
Bible: WEB CR / MOBILE CS / WEARABLE B
- [ ] 1 seul CTA primary par ecran (filled, colore)
- [ ] Hierarchy: primary > outlined > text > ghost
- [ ] Touch target: 48dp mobile, 44px web, 48dp watch
- [ ] Etats distincts: pas de bouton "mort" (meme apparence clique/pas clique)
- [ ] Destructif: rouge + confirmation, jamais en primary

#### Axe 5: CARDS & CONTAINERS
Bible: WEB CT / MOBILE BL / WEARABLE 8
- [ ] Border-radius coherent: meme valeur pour tous les containers
- [ ] Shadow OU border (pas les deux, sauf glassmorphism)
- [ ] Pas de card dans une card (card inception = interdit)
- [ ] Clickable? → hover state visible
- [ ] Contenu structure: pas de mur de texte dans une card

#### Axe 6: INPUTS & FORMS
Bible: WEB CN / MOBILE CV / WEARABLE 7
- [ ] Label VISIBLE au-dessus du champ (pas juste placeholder)
- [ ] Etats visuels: default (gris), focus (bleu, ring), error (rouge + message), disabled (grise pale)
- [ ] Taille: 48dp mobile, 40px web
- [ ] Erreur: message SOUS le champ, texte "quoi + comment fixer"
- [ ] Clavier adapte: email → @, tel → numerique, password → masque

#### Axe 7: NAVIGATION
Bible: WEB B / MOBILE D / WEARABLE 9
- [ ] Mobile: bottom nav (3-5 items), item actif distingue (filled icon + label + pill indicator)
- [ ] Web: top nav bar, items clairs, breadcrumbs si profondeur > 2
- [ ] Watch: swipe horizontal pour pages, back = swipe right, pas de nav bar
- [ ] Retour: accessible partout (back button ou swipe)

#### Axe 8: ICONS
Bible: WEB AU / MOBILE AT / WEARABLE A
- [ ] Style coherent: TOUS outline OU TOUS filled (pas de mix)
- [ ] Taille: 24dp standard, 20dp compact, 16dp inline
- [ ] Icon active vs inactive: filled (active) vs outline (inactive) OU tint
- [ ] Pas d'icone decorative sans signification (icon pollution)

#### Axe 9: ELEVATION
Bible: WEB CS / MOBILE CT / WEARABLE E
- [ ] Max 3 niveaux: flat (listes), raised (cards), floating (modals/FAB)
- [ ] Coherent: toutes les cards meme shadow, tous les modals meme shadow
- [ ] Dark mode: quasi pas de shadow, differencier par surface color

#### Axe 10: IMAGES & MEDIA
Bible: WEB section H / MOBILE AH / WEARABLE A
- [ ] Aspect-ratio: pas deformees (object-fit: cover/contain)
- [ ] Placeholder pendant chargement (skeleton shimmer, pas de case vide)
- [ ] Taille raisonnable (pas d'image 4000px pour un avatar 40px)
- [ ] Coins: meme border-radius que le container parent

#### Axe 11: ETATS & FEEDBACK
Bible: WEB A / MOBILE C / WEARABLE F
- [ ] Loading: skeleton OU spinner, JAMAIS ecran blanc vide
- [ ] Empty state: illustration + titre + sous-titre + CTA (pas juste "aucun resultat")
- [ ] Error: message clair + action de recovery ("Reessayer")
- [ ] Success: feedback immediat (< 100ms), couleur verte, haptic sur mobile

#### Axe 12: ACCESSIBILITE
Bible: WEB F / MOBILE AQ / WEARABLE I
- [ ] Contraste AA sur TOUT le texte (pas de gris clair oublie)
- [ ] Focus clavier visible (web): outline/ring, pas de outline:none sans remplacement
- [ ] Touch targets: jamais < 44px (un doigt = 44px)
- [ ] Couleur JAMAIS seul indicateur (toujours + icone ou texte)
- [ ] Texte: resize 200% sans overflow (web)

### ETAPE 4: RAPPORT
```
AUDIT DESIGN - [Mobile/Web/Watch] - [Nom de l'ecran]

SCORE: X/12 axes OK | Y problemes detectes

== QUICK WINS (faire en premier, impact max) ==
1. [Zone A] Contraste titre: ~2:1 → minimum 4.5:1
   Regle: MOBILE CR | Fix: #ccc → #525252
   Code: Text(style: TextStyle(color: Color(0xFF525252)))

2. [Zone C] 3 boutons primary = pas de hierarchie
   Regle: MOBILE CS | Fix: garder "Sauver" primary, passer "Annuler" en TextButton
   Code: TextButton(onPressed: ..., child: Text("Annuler"))

== P1 - CRITIQUE (casse l'UX) ==
...

== P2 - IMPORTANT (fait amateur) ==
...

== P3 - POLISH (fait "wow" vs "correct") ==
...
```

### ETAPE 5: VALIDATION
```
J'ai trouve Y problemes sur X zones.
Les 3 quick wins les plus impactants:
1. Contraste texte (2 min)
2. Hierarchie boutons (2 min)
3. Padding uniform 16px (5 min)

Tu veux:
→ Tout corriger d'un coup
→ Juste les quick wins
→ Me montrer un autre ecran d'abord
→ Focus sur un truc specifique
```

### ETAPE 6: CODER LE FIX
1. Trouver les fichiers (Flutter: grep le widget, Web: grep la classe CSS)
2. LIRE le code avant de modifier
3. Appliquer les fixes valides
4. Pour chaque fix: citer la regle bible en commentaire SI le changement n'est pas evident
5. Hot reload / refresh pour verifier

---

## PARTIE 4: DICTIONNAIRE "USER DIT → JE FAIS"

| L'user dit | = | Axes prioritaires |
|------------|---|-------------------|
| screenshot sans commentaire | Audit complet 12 axes | Tous |
| "c'est moche" | Les 7 peches + audit complet | Tous, priorite peches |
| "ca fait amateur" | Coherence, spacing, couleurs, shadows | 1, 3, 5, 9 |
| "ca fait pas pro" | Memes axes que "amateur" + typo + boutons | 1, 2, 3, 4, 5, 9 |
| "les couleurs" / "la palette" | Palette, contraste, 60-30-10, dark mode | 1 |
| "c'est pas aligne" / "pas droit" | Grille, padding, margin | 3 |
| "on voit rien" / "trop pale" | Contraste, taille texte | 1, 2 |
| "trop charge" / "trop dense" | Whitespace, hierarchie, density | 2, 3, 7 |
| "les boutons" | Hierarchy, etats, taille, CTA unique | 4 |
| "les cards" | Radius, shadow, padding, structure | 5 |
| "le formulaire" / "les inputs" | Labels, etats, validation | 6 |
| "la nav" / "le menu" | Position, items, actif, back | 7 |
| "les icones" | Style, taille, coherence | 8 |
| "le dark mode" | Remapping surfaces, contrast, shadows | 1, 9 |
| "c'est petit" / "c'est gros" | Tailles, touch targets, responsive | 2, 3, 4, 12 |
| "ca rame" / "c'est lent" | Pas du design → rediriger perf | N/A |
| "ca pulse" / "l'animation" | Motion, duree, easing, reduce-motion | Bible animation |
| "c'est vide" | Empty states, skeleton, loading | 11 |
| "y'a une erreur" / "le message" | Error states, validation, feedback | 6, 11 |

---

## PARTIE 5: REGLES D'OR

1. **PECHES D'ABORD** - Checker les 7 peches du noob avant les 12 axes (plus rapide, plus impactant)
2. **MONTRER AVANT DE CODER** - Toujours presenter le diagnostic, jamais corriger en silence
3. **REFERENCE BIBLE** - Chaque critique = section bible precise, pas "je pense que"
4. **QUICK WINS** - Commencer par les 3 changements les plus impactants et les plus rapides
5. **COHERENCE > BEAUTE** - Un design simple et coherent bat un design "creatif" inconsistant
6. **VALEURS EXACTES** - Jamais "ajuste le padding" → toujours "padding: 16px (MOBILE CW, grille 8px)"
7. **1 CTA PAR ECRAN** - Si 4 boutons colores, 3 doivent perdre leur couleur
8. **WHITESPACE = AMI** - En cas de doute, ajouter de l'espace, pas en retirer
9. **DARK MODE ≠ INVERT** - Remap les surfaces, desature les accents, tue les shadows
10. **PRO = REPETITION** - Le secret du pro c'est la repetition systematique des memes valeurs partout

---

## PARTIE 6: REFERENCES RAPIDES

### Valeurs par plateforme
| Token | Mobile (dp) | Web (px) | Watch (dp) |
|-------|-------------|----------|------------|
| Body text | 14sp | 16px | 15sp |
| Touch target | 48 | 44 | 48 |
| Card padding | 16 | 16-20 | 8-12 |
| Card radius | 12 | 8-12 | 16 |
| Screen margin | 16 | 24+ | 5.2% |
| Button height | 40 | 36 | 48 |
| Icon size | 24 | 20-24 | 24 |
| Input height | 56 | 40 | N/A |
| Bottom nav height | 80 | N/A | N/A |
| App bar height | 64 | N/A | N/A |
| Section gap | 24-32 | 48-64 | 16 |
| Spacing base | 8 | 8 | 8 |

### Sections bible par sujet
| Sujet | WEB.md | MOBILE.md | WEARABLE.md |
|-------|--------|-----------|-------------|
| Couleurs/palette | CP (13136) | CR (13600) | AS |
| Boutons hierarchy | CR (13709) | CS (13746) | B |
| Shadows/elevation | CS (13900) | CT (13957) | E |
| Border radius | CO (12957) | CU (14118) | 8 |
| Input states | CN (12541) | CV (14268) | 7 |
| Spacing rules | CQ (13366) | CW (14507) | 8 |
| Cards anatomy | CT (14290) | BL (8486) | 8 |
| Navigation | B (83) | D (486) | 9 |
| Typography | G (490) | A-B | D |
| Accessibility | F (441) | AQ (5329) | I |
| Animation/motion | BC (8988) | J (762) | AR |
| Dark mode | AO (7279) | H (1664) | E |
| Loading/feedback | A (1) | C (170) | F |
| Empty states | O (4960) | Q (1162) | N/A |
| Forms | C (134) | L (886) | 7 |
| Icons | AU (7929) | AT (5453) | A |
| iOS 19 | - | CX (14727) | - |
| Apple Intelligence | - | CY (14957) | BW |
| CSS 2025 | CU (14295) | - | - |
| Privacy Sandbox | CV (14793) | - | - |
| Browser AI | CW (15120) | - | BX |
| Android 16 | - | CZ (15228) | - |
| watchOS 12 | - | - | BW |
| AI Assistants | - | - | BX |

### Les 5 transformations qui changent TOUT
```
AMATEUR → PRO en 5 etapes (ordre d'impact):

1. PALETTE: virer toutes les couleurs random → 1 primaire + neutres + semantiques
   Impact: l'app passe de "projet scolaire" a "app publiee"
   Temps: 15 min

2. SPACING: tout passer a la grille 8px, padding 16px uniforme
   Impact: tout semble "aligne" et "propre" meme si c'est le meme contenu
   Temps: 20 min

3. HIERARCHIE BOUTONS: 1 primary filled, reste outlined/text
   Impact: l'oeil sait immediatement quoi faire sur chaque ecran
   Temps: 10 min

4. TYPOGRAPHY: 4 tailles seulement (titre/sous-titre/body/caption), 2 weights
   Impact: le contenu devient lisible et structure
   Temps: 10 min

5. COHERENCE: meme radius, meme shadow, meme style icones PARTOUT
   Impact: l'app semble faite par 1 designer, pas 5 stagiaires
   Temps: 15 min

Total: ~70 minutes pour passer de "dessin de chien" a "dessin de maitre"
```

---

## PARTIE 7: RESPONSIVE & ADAPTATION PAR PLATEFORME

### Breakpoints
```
MOBILE:
  Compact:  < 600dp  (phone portrait)  → 1 colonne, bottom nav, stack vertical
  Medium:   600-840dp (phone landscape, small tablet) → 2 colonnes possibles, rail nav
  Expanded: > 840dp  (tablet, desktop) → 2-3 colonnes, sidebar nav, list-detail

WEB:
  Mobile:   < 768px  → 1 colonne, hamburger menu, touch-friendly
  Tablet:   768-1024px → 2 colonnes, nav visible
  Desktop:  1024-1440px → 3 colonnes, sidebar, max-width container
  Wide:     > 1440px → contenu centre, max-width 1280px, marges auto

WATCH:
  Small:    < 192dp (40-41mm) → padding reduit a 8dp, texte 13sp min
  Medium:   192-210dp (44-45mm) → padding 12dp, texte 15sp
  Large:    > 210dp (Ultra 49mm) → padding 14dp, peut afficher plus de contenu
  TOUJOURS: 1 seule colonne, pas de navigation horizontale complexe
```

### Adaptation composants par plateforme
```
BOTTOM NAV:
  Phone:  bottom nav bar (3-5 items), 80dp height
  Tablet: navigation rail (cote gauche, 80dp wide, icons + labels)
  Web:    top nav bar horizontal
  Watch:  PAS DE NAV BAR → swipe entre pages, ou page unique

CARDS:
  Phone:  full width - 32dp (16dp marge chaque cote), stack vertical
  Tablet: 2 cards cote a cote, gap 16dp
  Web:    grid 3 colonnes, gap 24dp, max-width par card
  Watch:  full width - 16dp, contenu ultra-condensé, 1-2 lignes max

BOUTONS:
  Phone:  full width pour CTA principal, stack vertical si multiples
  Tablet: largeur fixe (max 320dp), cote a cote si 2
  Web:    largeur auto (fit-content), cote a cote
  Watch:  full width TOUJOURS, 1 bouton par ecran ideal, max 2 stack vertical

FORMULAIRE:
  Phone:  1 champ par ligne, clavier adapte
  Tablet: 2 champs par ligne si courts (prenom + nom)
  Web:    2-3 champs par ligne, labels a gauche si large
  Watch:  PAS DE FORMULAIRE sur montre (sauf voice input ou 1 champ simple)
```

### Quand c'est un screenshot de MONTRE
```
REGLES SPECIFIQUES WATCH (remplacent certains axes mobile):
- Pas de bottom nav, pas de tab bar, pas de sidebar
- Pas de form complexe (max 1 champ, prefer voice)
- Pas de scroll horizontal (sauf HorizontalPager pages)
- Max 7 elements visibles sans scroll
- Texte: 2-3 lignes max par bloc (ecran 1.4")
- Touch targets: 48dp minimum, idealement boutons full-width
- Margin ecran: 5.2% (environ 10-12dp selon taille)
- Horologist padding: 26.5dp horizontal (pour ecran rond)
- Animation: max 300ms, minimum d'animations (batterie)
- Couleur fond: OLED → noir pur #000000 economise batterie
- Complications: 1 tap → 1 action → confirmation → retour watch face
- ScalingLazyColumn (pas LazyColumn) pour le scroll vertical
```

---

## PARTIE 8: ANIMATION & MOTION

### Durees standard
```
Micro-interaction (ripple, toggle, hover):     100-150ms
State change (bouton pressed, chip select):     200ms
Expansion/collapse (dropdown, accordion):       250ms
Page transition (navigation, route change):     300ms
Modal entree (bottom sheet, dialog slide-up):   300-400ms
Modal sortie (dismiss, swipe away):             200-250ms (sortie plus rapide qu'entree)
Intro animation (first load, onboarding):       500-800ms
Loading spinner:                                 rotation 1.4s infinite linear
Skeleton shimmer:                                1.5s infinite ease-in-out

WATCH: diviser par 1.5 (tout plus rapide, batterie)
  Page transition: 200ms
  Modal: 200ms
  Pas d'intro animation
```

### Easing
```
ENTREE d'element:   ease-out (cubic-bezier(0, 0, 0.2, 1))
  → l'element arrive vite et ralentit doucement

SORTIE d'element:   ease-in (cubic-bezier(0.4, 0, 1, 1))
  → l'element accelere en partant

CHANGEMENT D'ETAT:  ease-in-out (cubic-bezier(0.4, 0, 0.2, 1))
  → transition fluide entre 2 etats

REBOND (spring):    Flutter: Curves.elasticOut, CSS: cubic-bezier(0.34, 1.56, 0.64, 1)
  → pour les FAB, toggles, elements playful

LINEAIRE:           uniquement pour les spinners et progress bars
```

### Flutter code
```dart
// Transition de page standard
AnimatedSwitcher(
  duration: Duration(milliseconds: 300),
  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
)

// Bouton pressed
AnimatedScale(
  scale: isPressed ? 0.95 : 1.0,
  duration: Duration(milliseconds: 100),
  curve: Curves.easeOut,
)

// Card apparition dans liste
AnimatedOpacity(
  opacity: isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  curve: Curves.easeOut,
)
```

### CSS code
```css
/* Transition standard pour tout */
* { transition: background-color 150ms ease, color 150ms ease, border-color 150ms ease, box-shadow 150ms ease, transform 100ms ease; }

/* Modal entree */
dialog[open] { animation: slideUp 300ms ease-out; }
@keyframes slideUp { from { transform: translateY(16px); opacity: 0; } }

/* Reduce motion: TOUJOURS fournir le fallback */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```

---

## PARTIE 9: LOADING, EMPTY STATES & VALIDATION

### Loading patterns
```
SKELETON (prefere pour les listes et cards):
  - Forme: rectangles gris (#E5E5E5 light, #333 dark) avec coins arrondis
  - Shimmer: gradient anime de gauche a droite, 1.5s, ease-in-out
  - Matcher la structure: si la card a titre + 2 lignes + avatar → skeleton identique
  - Taille: meme hauteur que le contenu reel (pas de "saut" au chargement)
  - Watch: skeleton simplifie (1-2 rectangles, pas de shimmer si possible)

SPINNER (pour les actions ponctuelles):
  - Taille: 24dp inline (dans un bouton), 48dp pleine page
  - Couleur: primary pour fond clair, blanc pour fond colore
  - Position: centre de la zone de chargement
  - Texte optionnel: "Chargement..." sous le spinner si > 3 secondes
  - JAMAIS spinner + skeleton en meme temps

PULL-TO-REFRESH:
  - Indicateur en haut de la liste, pas de pleine page
  - Distance declenchement: 60-80dp de pull
  - Timeout: 10-15 secondes → "Erreur de connexion, reessayer"
```

### Empty states
```
STRUCTURE (dans l'ordre):
  1. Illustration ou icone (optionnel): 120dp max, style coherent avec l'app
  2. Titre: "Pas encore de cigarettes logguees" (pas "Aucune donnee")
  3. Description: "Commence a tracker pour voir tes stats ici" (1-2 lignes max)
  4. CTA: bouton primary "Logger ma premiere cigarette"

PAR TYPE:
  First-use (jamais utilise):  encourager, expliquer, CTA pour commencer
  No results (recherche vide): "Aucun resultat pour 'X'" + suggestions
  Error (chargement echoue):   "Impossible de charger" + bouton "Reessayer"
  Offline (pas de reseau):     icone cloud-off + "Hors ligne" + "Les donnees se synchro quand tu reviens"

WATCH: pas d'illustration (trop petit), juste icone 32dp + texte 1 ligne + bouton
```

### Form validation
```
QUAND VALIDER:
  - Required: au blur (quand l'user quitte le champ) OU au submit
  - Format (email, tel): au blur, pas pendant la saisie (laisser taper)
  - Async (email existe deja): au blur, avec debounce 500ms
  - Au submit: valider TOUT, scroller au premier champ en erreur, focus dessus

MESSAGE D'ERREUR:
  BAD:  "Invalide" / "Erreur" / "Champ requis"
  GOOD: "Entre une adresse email valide (ex: nom@mail.com)"
  GOOD: "Le mot de passe doit contenir au moins 8 caracteres"
  GOOD: "Ce nom d'utilisateur est deja pris. Essaie un autre."

FORMULE: [Ce qui ne va pas] + [Comment corriger]

PLACEMENT:
  - Sous le champ, 4dp de gap
  - Texte 12sp, couleur error (#EF4444)
  - Icone warning 16dp devant le texte (optionnel mais aide les daltoniens)
  - Le champ lui-meme: bordure error, pas juste le message

ETATS VISUELS:
  Default:  border #D4D4D4, bg white, label #525252
  Focus:    border #3B82F6 (2dp), ring rgba(59,130,246,0.2), label primary
  Success:  border #22C55E, icone check (pour les champs valides async)
  Error:    border #EF4444, ring rgba(239,68,68,0.2), message + icone
  Disabled: bg #F5F5F5, border #E5E5E5, text #A3A3A3, opacity 0.6
```

---

## PARTIE 10: DENSITE & COMPACITE

### Quand utiliser quelle densite
```
CONFORTABLE (default, la plupart des ecrans):
  Card padding: 16dp
  List item height: 56dp (1 ligne), 72dp (2 lignes)
  Gap entre elements: 16dp
  Utiliser pour: ecrans principaux, formulaires, contenu editorial

COMPACT (listes longues, data-heavy):
  Card padding: 12dp
  List item height: 48dp (1 ligne), 64dp (2 lignes)
  Gap entre elements: 8dp
  Utiliser pour: listes de messages, historique, logs, resultats de recherche

DENSE (tableaux, data grids):
  Cell padding: 8dp
  Row height: 36dp
  Gap: 0dp (borders suffisent)
  Utiliser pour: tableaux de donnees, dashboards, mode expert
  JAMAIS sur mobile < 600dp (doigts trop gros)

WATCH (ultra-compact):
  Card padding: 8dp
  List item: ScalingLazyColumn → auto-sizing
  Gap: 4dp entre items dans une liste
  Texte: jamais > 3 lignes
  1 info principale + 1 secondaire par ecran max
```

### Densite texte
```
REGLE: plus l'ecran est petit, moins de texte

Phone:    titre (1 ligne) + description (2-3 lignes) + metadata (1 ligne)
Tablet:   peut ajouter 1-2 lignes de description
Web:      plus genereux, mais toujours < 75 caracteres par ligne (lisibilite)
Watch:    titre (1 ligne) + valeur OU icone. C'est tout. Pas de description.

TRONCATION:
  1 ligne:   overflow: ellipsis / maxLines: 1
  2 lignes:  -webkit-line-clamp: 2 / maxLines: 2
  Quand tronquer: cards dans grille, listes, titres longs
  Quand NE PAS tronquer: messages, contenu editorial, erreurs
```

---

## PARTIE 11: MICROCOPY & TEXTE UI

### Boutons
```
ACTION (verbe):
  "Sauvegarder"    pas "OK"
  "Supprimer"      pas "Oui"
  "Envoyer"        pas "Submit"
  "Annuler"        pas "Non" ou "Fermer" (si form)
  "Reessayer"      pas "Rafraichir" ou "Reload"

CAPITALISATION:
  Francais: Premiere lettre majuscule seulement ("Enregistrer les modifications")
  English:  Title Case pour boutons ("Save Changes"), sentence case pour le reste

LONGUEUR:
  Phone:  max 20 caracteres
  Watch:  max 12 caracteres (idealement 1-2 mots)
  Web:    max 25 caracteres
```

### Messages
```
SUCCESS:  court, positif, disparait seul apres 3s
  "Sauvegarde !" / "Cigarette loguee" / "Envoye"
  → Snackbar vert ou toast, pas d'alerte bloquante

ERROR:    clair, actionnable, persiste jusqu'a dismiss
  "Connexion echouee. Verifie ta connexion internet." + [Reessayer]
  → Banner rouge en haut OU inline sous l'element concerne

WARNING:  preventif, avant l'action
  "Tu vas supprimer toutes tes donnees. Cette action est irreversible."
  → Dialog avec bouton destructif en rouge et "Annuler" en secondary

INFO:     contextuel, aide
  "Les stats se mettent a jour toutes les heures"
  → Inline text discret, couleur #6B7280, petite taille
```

---

## PARTIE 12: TEST & VERIFICATION

### Checklist apres chaque fix
```
[ ] Screenshot avant/apres: comparer visuellement
[ ] Hot reload (Flutter) ou refresh (web): verifier en live
[ ] Tester les 2 themes: light ET dark mode
[ ] Tester extremes: texte tres long, texte vide, chargement, erreur
[ ] Tester taille ecran: petit (SE/5.4"), grand (Ultra/6.7"), watch si applicable
[ ] Plisser les yeux: les elements importants ressortent?
[ ] Test du "3 pas en arriere": reculer de son ecran, l'info est lisible?
[ ] Daltonisme: mettre en noir et blanc → la hierarchie est encore visible?
```

### Test specifique watch
```
[ ] Porter la montre et regarder pendant 2 secondes: l'info est captee?
[ ] Taper avec le doigt: les touch targets sont assez grands?
[ ] Mode ambient: le contenu essentiel reste visible?
[ ] Lever/baisser le poignet: le contenu charge assez vite?
```
