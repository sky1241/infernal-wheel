# MODE DESIGN AUDIT PRO - Critique & Fix UX/UI complet

## QUAND L'UTILISER
Screenshot de n'importe quoi (app mobile, site web, smartwatch) et tu veux que ca devienne pro.
Dis "audit", "c'est moche", "fix le design", "rend ca pro", ou envoie juste un screenshot.

## COMMENT L'UTILISER
1. Envoie ton screenshot (ou plusieurs)
2. Dis ce qui te gene OU juste "audit complet"
3. Je diagnostique tout, je te montre, tu valides, je code

---

## INSTRUCTIONS POUR CLAUDE

### CONTEXTE PROJET
- Stack: Flutter mobile + Wear OS watch + site web
- Bibles UX a consulter AVANT toute critique:
  - `ux_resources/WEB.md` (15,669 lignes, 107 sections A-CW) pour le web
  - `ux_resources/MOBILE.md` (15,508 lignes, 105 sections A-CZ) pour le mobile/Flutter
  - `ux_resources/WEARABLE.md` (13,132 lignes, 76 sections A-BX) pour la montre
  - `ux_resources/DESIGN_TREE.md` (index rapide ~510 entrees)
- TOUJOURS baser les corrections sur les regles documentees dans les bibles, pas sur l'intuition

### ETAPE 1: IDENTIFIER LA PLATEFORME
```
Screenshot recu → detecter:
- Mobile (Flutter/Android/iOS) → utiliser MOBILE.md
- Web (site/dashboard) → utiliser WEB.md
- Watch (Wear OS/watchOS) → utiliser WEARABLE.md
```

### ETAPE 2: AUDIT SYSTEMATIQUE (10 points)
Pour chaque screenshot, verifier ces 10 axes dans l'ordre:

#### 1. COULEURS
Bible: MOBILE CR / WEB CP / WEARABLE section AS
- [ ] Regle 60-30-10 respectee? (60% bg, 30% secondary, 10% accent)
- [ ] Contraste texte AA (4.5:1 min, 3:1 large text/UI)
- [ ] Couleurs semantiques correctes (success=vert, error=rouge, warning=orange, info=bleu)
- [ ] Dark mode: surfaces remappees (pas inversees), accent desature
- [ ] Pas plus de 3-4 couleurs distinctes visibles

#### 2. TYPOGRAPHIE
Bible: MOBILE section A-B / WEB section G / WEARABLE section D
- [ ] Hierarchie claire (titre > sous-titre > body > caption)
- [ ] Taille body minimum 16px web / 14sp mobile / 15sp watch
- [ ] Line-height: titres 1.2, body 1.5, dense 1.3
- [ ] Max 2 font-weights visibles (regular + bold/semibold)
- [ ] Pas de texte coupe ou tronque sans raison

#### 3. SPACING & LAYOUT
Bible: MOBILE CW / WEB CQ / WEARABLE section 8
- [ ] Grille 8px respectee (tous les spacings multiples de 4/8)
- [ ] Padding coherent dans les cards (16px standard)
- [ ] Gap regulier entre elements similaires
- [ ] Marges ecran: 16dp mobile, 16dp watch, 24px+ web
- [ ] Sections separees par au moins 24px

#### 4. BOUTONS & HIERARCHY
Bible: MOBILE CS / WEB CR / WEARABLE section B
- [ ] 1 seul CTA primaire visible par ecran
- [ ] Hierarchy: primary (filled) > secondary (outlined) > tertiary (text)
- [ ] Touch target 48dp mobile, 44pt iOS, 48dp watch, 44px web
- [ ] Etats visibles (hover/pressed/disabled pas identiques)
- [ ] Destructif en rouge, JAMAIS en primary sauf confirmation

#### 5. CARDS & CONTAINERS
Bible: MOBILE section BL / WEB CT / WEARABLE section 8
- [ ] Border-radius coherent (meme valeur partout, 8-12px standard)
- [ ] Shadow OU border, pas les deux (sauf cas rare)
- [ ] Structure: header > media > body > actions (si applicable)
- [ ] Cards clickables: hover state + curseur pointer
- [ ] Pas de nesting de cards (card dans card = interdit)

#### 6. INPUTS & FORMS
Bible: MOBILE CV / WEB CN / WEARABLE section 7
- [ ] Labels toujours visibles (pas seulement placeholder)
- [ ] Etats distincts: default, focus (ring bleu), error (rouge + message), disabled (grise)
- [ ] Taille 48dp+ mobile, 36px+ web
- [ ] Message d'erreur sous le champ (pas tooltip, pas alert)
- [ ] Groupes logiques separes visuellement

#### 7. NAVIGATION
Bible: MOBILE section D / WEB section B / WEARABLE section 9
- [ ] Position coherente (bottom nav mobile, top nav web, swipe watch)
- [ ] Item actif clairement distingue
- [ ] 3-5 items max en bottom nav
- [ ] Breadcrumbs sur web si profondeur > 2
- [ ] Back accessible partout

#### 8. ICONS & IMAGES
Bible: MOBILE AT / WEB section AU / WEARABLE section A
- [ ] Icons meme style (tous outline OU tous filled, pas de mix)
- [ ] Taille coherente (24dp standard, 20dp compact)
- [ ] Images: aspect-ratio respecte (pas deformees)
- [ ] Alt text / semantique (decoratif vs informatif)

#### 9. ELEVATION & DEPTH
Bible: MOBILE CT / WEB CS / WEARABLE section E
- [ ] Max 3 niveaux visibles (flat, raised, floating)
- [ ] Elements importants plus eleves que le reste
- [ ] Dark mode: shadows reduites, differencier par surface color
- [ ] Pas de shadow sur element flat (table row, list item simple)

#### 10. ACCESSIBILITE RAPIDE
Bible: MOBILE AQ / WEB section F / WEARABLE section I
- [ ] Contraste AA passe sur TOUT le texte
- [ ] Focus visible au clavier (web)
- [ ] Taille texte minimum respectee
- [ ] Couleur jamais seul indicateur (toujours + icone ou texte)

### ETAPE 3: RAPPORT DE DIAGNOSTIC
Presenter comme ca:

```
AUDIT DESIGN - [Plateforme] - [Ecran]

SCORE: X/10 axes OK

PROBLEMES (par priorite):

[P1 - CRITIQUE]
1. Couleurs: contraste titre sur fond = 2.1:1 (minimum 4.5:1)
   → Regle: MOBILE.md section CR - contraste AA
   → Fix: changer couleur texte de #999 a #525252

2. Boutons: 3 boutons primary visibles = pas de hierarchie
   → Regle: MOBILE.md section CS - 1 seul CTA primary par ecran
   → Fix: garder "Ajouter" en primary, passer les autres en outlined

[P2 - IMPORTANT]
3. Spacing: padding card gauche 12px, droite 20px = asymetrique
   → Regle: WEB.md section CQ - padding cards 16px
   → Fix: uniformiser padding a 16px

[P3 - POLISH]
4. Border-radius: boutons 4px, cards 12px, chips 20px = 3 valeurs
   → Regle: WEB.md section CO - max 3 valeurs, coherence
   → Fix: boutons 8px, cards 12px, chips full (2 valeurs)
```

### ETAPE 4: DEMANDER VALIDATION
```
J'ai trouve X problemes.

Tu veux que je corrige:
- [ ] Tout d'un coup
- [ ] Seulement les P1 (critiques)
- [ ] Un truc specifique
- [ ] Tu veux me montrer autre chose d'abord?
```

**ATTENDRE LA REPONSE** avant de coder.

### ETAPE 5: CORRIGER LE CODE
1. Identifier les fichiers concernes (Flutter .dart, HTML/CSS, Compose)
2. Lire le code AVANT de modifier
3. Appliquer TOUTES les corrections validees
4. Chaque correction = reference a la regle bible utilisee en commentaire inline si pas evident
5. Proposer hot reload / refresh pour verifier visuellement

---

## DICTIONNAIRE RAPIDE "USER DIT → JE FAIS"

| L'user dit | Ce que ca veut dire | Axes a checker |
|------------|---------------------|----------------|
| "c'est moche" | Audit complet 10 axes | Tout |
| "les couleurs c'est nul" | Palette, contraste, 60-30-10 | Axe 1 |
| "c'est pas aligne" | Spacing, padding, grille | Axe 3 |
| "on voit rien" / "trop pale" | Contraste, hierarchie typo | Axe 1, 2 |
| "les boutons c'est le bordel" | Hierarchie boutons, taille, etats | Axe 4 |
| "ca fait amateur" | Spacing + shadows + border-radius + couleurs | Axe 1, 3, 5, 9 |
| "c'est trop charge" | Density, spacing, hierarchie info | Axe 3, 2, 10 |
| "le texte est bizarre" | Typo sizes, weights, line-height | Axe 2 |
| "les cards sont moches" | Border-radius, shadow, padding, structure | Axe 5 |
| "ca pulse" / "animation" | Motion, timing, reduce-motion | Bible section animation |
| "ca fait pas pro" | Tous les axes, focus sur cohérence | Tout, priorite coherence |
| "j'aime pas le dark mode" | Surface remapping, contrast, shadows | Axe 1, 9 |
| "c'est petit" / "c'est gros" | Touch targets, typo scale, spacing | Axe 2, 3, 4 |
| "l'icone la" | Style icone, taille, coherence set | Axe 8 |
| "le form est nul" | Labels, etats, validation, layout | Axe 6 |

## REGLES D'OR

1. **TOUJOURS lire la section bible correspondante** avant de proposer un fix
2. **TOUJOURS montrer le diagnostic** avant de coder
3. **JAMAIS changer le design sans reference** a une regle pro documentee
4. **PRIORITE**: contraste > spacing > hierarchie > polish
5. **Coherence > originalite**: mieux vaut un design systeme simple et coherent qu'un design "creatif" inconsistant
6. **Valeurs concretes**: jamais "ajuste le padding" → toujours "padding 16px (regle MOBILE CW, grille 8px)"
7. **Un CTA par ecran**: si l'user a 4 boutons colores, 3 doivent devenir outlined/text

## REFERENCES CROISEES RAPIDES

### Valeurs a connaitre par coeur
| Token | Mobile | Web | Watch |
|-------|--------|-----|-------|
| Body text | 14-16sp | 16px | 15sp |
| Touch target min | 48dp | 44px | 48dp |
| Card padding | 16dp | 16-20px | 8-12dp |
| Card radius | 12dp | 8px | 16dp |
| Screen margin | 16dp | 24px+ | 5.2% |
| Button height | 40dp | 36px | 48dp |
| Icon size | 24dp | 20-24px | 24dp |
| Shadow card | 0,1,4 blur | 0,1,2 blur | none (tonal) |
| Primary CTA | filled colorPrimary | bg #3b82f6 | filled M3 |
| Error color | #F44336 | #ef4444 | #F44336 |
| Success color | #4CAF50 | #22c55e | #4CAF50 |
| Spacing base | 8dp | 8px | 8dp |

### Sections bible par plateforme
| Sujet | WEB.md | MOBILE.md | WEARABLE.md |
|-------|--------|-----------|-------------|
| Couleurs | CP (13136) | CR (13600) | AS |
| Boutons | CR (13709) | CS (13746) | B (8) |
| Shadows | CS (13900) | CT (13957) | E |
| Radius | CO (12957) | CU (14118) | 8 |
| Inputs | CN (12541) | CV (14268) | 7 |
| Spacing | CQ (13366) | CW (14507) | 8 |
| Cards | CT (14290) | BL (8486) | 8 |
| Navigation | B (83) | D (486) | 9 |
| Typo | G (490) | A-B | D |
| A11y | F (441) | AQ (5329) | I |
| Animation | BC (8988) | J (762) | AR |
| Dark mode | AO (7279) | H (1664) | E (14) |
| iOS 19 | - | CX (14727) | - |
| Apple Intelligence | - | CY (14957) | BW |
| CSS 2025 | CU (14295) | - | - |
| AI browser | CW (15120) | - | BX |
