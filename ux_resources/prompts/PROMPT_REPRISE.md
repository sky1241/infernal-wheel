# InfernalWheel - Prompt de Reprise

> **FATIGUE?** → Utilise `PROMPT_REPRISE_ULTIME.md` (mode autonome)

## Contexte Projet

Dashboard PowerShell generant HTML/CSS/JS pour tracker les addictions (alcool, tabac).
- **Fichier principal:** `hellwell/dashboard/Dashboard.Page.ps1`
- **URL:** http://127.0.0.1:8011/
- **Taille fichier:** ~2800 lignes (CSS + HTML + JS + PowerShell)

---

## REGLE #1 - CREER AVEC LES 2 FICHIERS UX MELANGES

Pour etre CREATIF et pas juste mecanique, tu dois TOUJOURS lire et MELANGER:

| Fichier | Contenu | Pourquoi le melanger |
|---------|---------|---------------------|
| `ux_resources/WEB.md` | ~200 regles web (WCAG, patterns, accessibilite) | Les bases solides |
| `ux_resources/MOBILE.md` | ~300 regles mobile (iOS HIG, Material 3, valeurs concretes) | Les valeurs precises et le feeling tactile |

**Le secret:** Appliquer les standards MOBILE au WEB = meilleur resultat
- Touch targets 44-48px (pas 24px)
- Spacing genereux (8px minimum, 16px prefere)
- Feedback immediat < 100ms
- Etats clairs (hover, active, disabled, loading)

### Mode Holistique = PENSER comme un designer

Quand je dis "j'aime pas", "c'est moche", "ameliore", "retouche":
1. Lire les 2 fichiers UX
2. Voir la PAGE ENTIERE - pas juste l'element mentionne
3. Proposer des changements STRUCTURELS - pas juste cosmetiques
4. Etre CREATIF et AUDACIEUX - effet "waow"

**Anti-patterns:**
- Demander 15 clarifications avant d'agir
- Appliquer les regles mecaniquement
- Faire le minimum
- Etre trop litteral

---

## REGLE #1.5 - RECHERCHE UX INTELLIGENTE (OBLIGATOIRE)

Quand l'utilisateur dit **"intègre les règles UX"** ou mentionne un élément UI:

### Étape 1: Identifier le type d'élément

| Élément mentionné | Type |
|-------------------|------|
| bouton, btn, click, action | `BUTTON` |
| input, champ, formulaire, form, saisie | `FORM` |
| modal, popup, dialog, overlay | `MODAL` |
| menu, dropdown, navigation, nav | `NAV` |
| liste, table, grille, cards | `LIST` |
| toast, notification, alert, feedback | `FEEDBACK` |
| loading, spinner, skeleton | `LOADING` |
| couleur, color, contrast, theme | `COLOR` |
| spacing, margin, padding, gap | `SPACING` |
| texte, typo, font, label | `TYPO` |

### Étape 2: Grep les fichiers UX avec les bons mots-clés

```bash
# Pour chaque type, chercher dans WEB.md ET MOBILE.md:

# BUTTON
Grep -i "button|touch.target|click|tap|hover|active|disabled|focus" ux_resources/WEB.md
Grep -i "button|touch.target|44.*pt|48.*dp|press|tap" ux_resources/MOBILE.md

# FORM
Grep -i "input|form|validation|label|placeholder|error|field" ux_resources/WEB.md
Grep -i "input|form|keyboard|text.field|picker" ux_resources/MOBILE.md

# MODAL
Grep -i "modal|dialog|overlay|backdrop|dismiss|escape" ux_resources/WEB.md
Grep -i "modal|sheet|dialog|overlay|present" ux_resources/MOBILE.md

# NAV
Grep -i "navigation|menu|dropdown|breadcrumb|tab|link" ux_resources/WEB.md
Grep -i "navigation|tab.bar|bottom|drawer|back" ux_resources/MOBILE.md

# LIST
Grep -i "list|table|grid|card|item|row|cell" ux_resources/WEB.md
Grep -i "list|table|collection|cell|swipe" ux_resources/MOBILE.md

# FEEDBACK
Grep -i "toast|snackbar|notification|alert|success|error" ux_resources/WEB.md
Grep -i "toast|snackbar|haptic|feedback|banner" ux_resources/MOBILE.md

# LOADING
Grep -i "loading|spinner|skeleton|progress|async" ux_resources/WEB.md
Grep -i "loading|spinner|skeleton|indicator|activity" ux_resources/MOBILE.md

# COLOR
Grep -i "color|contrast|wcag|theme|dark|light|accent" ux_resources/WEB.md
Grep -i "color|dynamic|system|palette|semantic" ux_resources/MOBILE.md

# SPACING
Grep -i "spacing|margin|padding|gap|grid|layout" ux_resources/WEB.md
Grep -i "spacing|margin|padding|safe.area|inset" ux_resources/MOBILE.md

# TYPO
Grep -i "typography|font|text|label|size|weight|line" ux_resources/WEB.md
Grep -i "typography|font|dynamic.type|text.style|sf.pro" ux_resources/MOBILE.md
```

### Étape 3: Appliquer TOUTES les règles trouvées

Lire les résultats du Grep et appliquer chaque règle:
- Valeurs concrètes (44px, 4.5:1, etc.)
- États (hover, active, disabled, focus, loading)
- Feedback (animations, transitions, toasts)
- Accessibilité (contrast, ARIA, focus visible)

### Exemple concret

User dit: "améliore ce bouton"

1. Type = `BUTTON`
2. Grep:
   ```bash
   Grep -i "button|touch.target|click|hover|active|disabled|focus" ux_resources/WEB.md
   Grep -i "button|touch.target|44.*pt|48.*dp|press" ux_resources/MOBILE.md
   ```
3. Règles trouvées à appliquer:
   - min-height: 44px (touch target)
   - padding: 12px 24px
   - border-radius: 8px
   - hover: brightness(1.1)
   - active: scale(0.98)
   - focus: outline 2px solid + offset 2px
   - disabled: opacity 0.5 + cursor not-allowed
   - transition: all 0.2s ease

---

## REGLE #2 - TOUJOURS RELANCER LE SERVEUR

Apres CHAQUE modification du fichier `Dashboard.Page.ps1`, tu DOIS relancer.

### Commande one-liner (RECOMMANDEE)

```bash
taskkill /F /IM powershell.exe /T 2>nul & ping -n 2 127.0.0.1 >nul & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1' -WindowStyle Hidden"
```

### Verification (attendre 4-5 sec)

```bash
powershell.exe -NoProfile -Command "Start-Sleep -Seconds 4; Get-NetTCPConnection -LocalPort 8011 -State Listen"
```

**IMPORTANT:**
- Si tu oublies de relancer, l'utilisateur verra l'ancienne version!
- Dire a l'utilisateur de faire **Ctrl+F5** (hard refresh) pour vider le cache

---

## REGLE #3 - TOUJOURS SAUVER SUR GITHUB

Apres chaque modification VALIDEE par l'utilisateur:

```bash
cd "c:\Users\ludov\.infernal_wheel" && git add hellwell/dashboard/Dashboard.Page.ps1 && git commit -m "$(cat <<'EOF'
feat/fix(ui): description courte

- Detail 1
- Detail 2

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)" && git push
```

**Pourquoi:** Pour pouvoir REVENIR EN ARRIERE avec `git checkout` si ca ne plait pas!

```bash
# Annuler modifications non commitees:
git checkout -- hellwell/dashboard/Dashboard.Page.ps1

# Revenir a un commit precedent:
git log --oneline -5
git checkout <hash> -- hellwell/dashboard/Dashboard.Page.ps1
```

---

## Workflow Complet

1. **Lire** `ux_resources/WEB.md` + `ux_resources/MOBILE.md` (les melanger!)
2. **Lire** le fichier `hellwell/dashboard/Dashboard.Page.ps1` (section concernee)
3. **Modifier** le CSS et/ou HTML PowerShell
4. **Relancer** le serveur (OBLIGATOIRE)
5. **Dire** a l'utilisateur de faire Ctrl+F5
6. **Attendre** validation utilisateur
7. **Commit + Push** sur GitHub

---

## Structure du Fichier Dashboard.Page.ps1

Le fichier est organise ainsi (approximatif):

| Lignes | Contenu |
|--------|---------|
| 1-120 | **PowerShell** - Generation HTML calendrier |
| 120-220 | **PowerShell** - Calculs stats, timeline, rapports |
| 220-820 | **CSS** - Variables, layout, composants generaux |
| 820-1180 | **CSS** - Calendrier (table, cellules, badges) |
| 1180-1300 | **CSS** - Cards calendrier, legende |
| 1300-2100 | **HTML** - Structure page complete |
| 2100-2800 | **JavaScript** - Logique interactive |

### Pour chercher une section:

```bash
# Trouver le calendrier
Grep "calendar|calendrier" Dashboard.Page.ps1

# Trouver une classe CSS
Grep "\.maClasse" Dashboard.Page.ps1

# Trouver un ID JS
Grep "getElementById.*monId" Dashboard.Page.ps1
```

---

## Structure Cellule Calendrier (Refonte 2026-02)

Chaque cellule du calendrier suit cette structure:

```html
<td class="day today">
  <div class="dhead">
    <div class="dhead-left">
      <span class="dnum">7</span>
      <span class="dtoday-badge">Aujourd'hui</span>  <!-- si today -->
    </div>
    <span class="dwork">💻 7h51m</span>
  </div>
  <div class="dstats">
    <span class="dstat dstat--sleep">💤 6h</span>
    <span class="dstat dstat--alc">🍷1 🍺3 🍻1</span>
    <span class="dstat dstat--smoke">🚬9</span>
  </div>
  <div class="dacts">
    <span class="dacts-toggle">📋 5 activités</span>
    <div class="dacts-details"><!-- tooltip hover --></div>
  </div>
  <div class="dlink">
    <a href="/notes?d=2026-02-07">📝 Notes</a>
  </div>
</td>
```

### Classes CSS importantes calendrier

| Classe | Role |
|--------|------|
| `.dhead` | Header: numero + badge travail |
| `.dhead-left` | Conteneur numero + badge aujourd'hui |
| `.dnum` | Numero du jour (grand, bold) |
| `.dtoday-badge` | Badge "Aujourd'hui" (vert accent) |
| `.dwork` | Badge travail (rose/magenta) |
| `.dstats` | Ligne des stats compactes |
| `.dstat--sleep` | Badge sommeil (bleu/violet) |
| `.dstat--alc` | Badge alcool (jaune/or) |
| `.dstat--smoke` | Badge clopes (rouge) |
| `.dacts` | Conteneur activites avec tooltip |
| `.dacts-toggle` | Texte "X activites" |
| `.dacts-details` | Tooltip details (hover) |
| `.dlink` | Bouton Notes en bas |

---

## Pieges CSS a Eviter

### 1. Tooltips coupes
```css
/* PROBLEME: tooltip coupe par le parent */
td.day { overflow: hidden; }

/* SOLUTION: permettre le depassement */
td.day { overflow: visible; }
table { overflow: visible; }
.calSubCard--grid { overflow: visible; }
.tooltip { z-index: 9999; }
```

### 2. Position absolue qui chevauche
```css
/* PROBLEME: ::before en position absolue peut chevaucher d'autres elements */
td.day.today::before {
  content: "Aujourd'hui";
  position: absolute;
  top: 8px; right: 8px;  /* chevauche le badge travail! */
}

/* SOLUTION: integrer dans le flux HTML */
.dtoday-badge {
  display: inline-flex;
  /* pas de position absolute */
}
```

### 3. Flexbox justify-content avec elements manquants
```css
/* PROBLEME: si un element est vide, l'alignement casse */
.dhead { justify-content: space-between; }

/* SOLUTION: wrapper les elements gauche */
.dhead-left { display: flex; gap: 6px; }
```

---

## Standards Auto-Appliques

| Regle | Valeur |
|-------|--------|
| Touch targets | 44-48px (mobile -> web) |
| Spacing | base 4px (8, 12, 16, 24, 32, 48) |
| Contraste texte | WCAG 4.5:1 |
| Contraste composants | WCAG 3:1 |
| Feedback | < 100-200ms |
| Focus visible | `outline: 2px solid; outline-offset: 2px` |
| Font chiffres | `font-variant-numeric: tabular-nums` |
| Poids typo | Regular(400) donnees, Medium(500) labels, Bold(700) titres |
| Border radius | 4-6px petits, 8-12px cards |
| Transitions | `all .2s cubic-bezier(.4,0,.2,1)` |

---

## Couleurs Semantiques

| Element | Couleur | CSS |
|---------|---------|-----|
| Accent (succes) | Vert | `--accent: #35d99a` / `rgba(53,217,154,...)` |
| Travail | Rose/Magenta | `rgba(255,79,216,...)` |
| Sommeil | Bleu/Violet | `rgba(102,126,234,...)` |
| Alcool | Jaune/Or | `rgba(246,183,60,...)` |
| Clopes | Rouge | `rgba(255,77,77,...)` |
| Muted | Gris clair | `var(--muted)` |
| Border | Blanc tres transparent | `rgba(255,255,255,.06-.12)` |

---

## IDs JavaScript CRITIQUES (NE PAS TOUCHER)

| Zone | IDs |
|------|-----|
| Stats | `statGoal`, `statDone`, `statBreak`, `kRemain`, `progressPct`, `bar` |
| Action | `kSeg`, `kSeg2`, `kTimerElapsed`, `kTimerRemain`, `currentBox` |
| Live | `liveCard`, `firstsToday`, `actionsToday`, `drinkToday`, `smokeToday` |
| Agenda | `agendaTimeline`, `agendaClock`, `agendaToggle`, `agendaDetails` |

---

## Ameliorations Futures Identifiees

- [ ] **Responsive calendrier** - Actuellement 2 colonnes mobile, pourrait etre 1 colonne avec cards plus grandes
- [ ] **Dark/Light mode toggle** - Actuellement dark only
- [ ] **Animations entree** - Les `.reveal` cards pourraient avoir un stagger delay
- [ ] **Graphiques interactifs** - Hover sur chart.js pour details
- [ ] **Filtres calendrier** - Voir seulement jours avec alcool, ou seulement jours travailles
- [ ] **Export PDF** - Rapport mensuel exportable

---

## Fichiers Cles

```
c:\Users\ludov\.infernal_wheel\
  hellwell\
    dashboard\
      Dashboard.Page.ps1    <- UI principale (HTML/CSS/JS) ~2800 lignes
    start_dashboard.ps1     <- Script de demarrage
  ux_resources\
    DESIGN_TREE.md          <- ARBRE DE DECISION (lire en premier!)
    WEB.md                  <- ~260 regles web (maj 2026-02-09)
    MOBILE.md               <- ~320 regles mobile (maj 2026-02-09)
  PROMPT_REPRISE.md         <- CE FICHIER
```

---

## WORKFLOW OPTIMAL

### Ordre de Lecture
1. **DESIGN_TREE.md** - L'arbre de decision (structure mentale)
2. **WEB.md** ou **MOBILE.md** - Les regles detaillees selon la plateforme
3. **Dashboard.Page.ps1** - Le code a modifier

### Arbre Mental Resume
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

*Derniere mise a jour: 2026-02-09*

---

## MOTS MAGIQUES

| Phrase utilisateur | Action Claude |
|--------------------|---------------|
| "intègre les règles UX" | Exécuter REGLE #1.5 - Recherche intelligente |
| "mode holistique" | Lire WEB.md + MOBILE.md en entier |
| "c'est moche" / "améliore" | Mode holistique + propositions créatives |
| "push sur git" | Commit + push immédiat |
| "relance le serveur" | Exécuter commande restart |
