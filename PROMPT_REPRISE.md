# InfernalWheel - Prompt de Reprise

## Contexte Projet

Dashboard PowerShell generant HTML/CSS/JS pour tracker les addictions (alcool, tabac).
- **Fichier principal:** `hellwell/dashboard/Dashboard.Page.ps1`
- **URL:** http://127.0.0.1:8011/
- **Relancer:** `powershell -NoProfile -ExecutionPolicy Bypass -File "c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1"`

---

## MODE HOLISTIQUE UX - REGLE PRIORITAIRE

Quand je demande de modifier l'UI (meme vaguement: "j'aime pas", "c'est moche", "ameliore", "retouche"):

### Actions AUTOMATIQUES
1. **Lire les 2 fichiers UX et les MELANGER:**
   - `ux_resources/WEB.md` (~200 regles web)
   - `ux_resources/MOBILE.md` (~300 regles mobile)

2. **Voir la PAGE ENTIERE** - pas juste l'element mentionne

3. **Analyser la structure:**
   - Sections bien segmentees?
   - Textes groupes logiquement?
   - Hierarchie visuelle claire?
   - Flux utilisateur evident?

4. **Proposer des changements STRUCTURELS** - pas juste cosmetiques

5. **Etre CREATIF et AUDACIEUX** - effet "waow", pas litteral

### Standards auto-appliques
- Touch targets: 44-48px (mobile -> web)
- Spacing: base 4px (8, 12, 16, 24, 32, 48)
- Contraste: WCAG 4.5:1 texte, 3:1 composants
- Feedback: < 100-200ms
- Focus visible: `outline: 2px solid; outline-offset: 2px`
- Etats: loading, empty, error, success, disabled
- Font chiffres: `font-variant-numeric: tabular-nums`
- Poids typo: Regular(400) donnees, Medium(500) labels, Bold(700) titres/CTA

### Anti-patterns a eviter
- Demander 15 clarifications avant d'agir
- Appliquer les regles une par une mecaniquement
- Faire le minimum demande
- Etre trop litteral

---

## Workflow de modification UI

1. **Lire** `ux_resources/WEB.md` ET `ux_resources/MOBILE.md`
2. **Lire** le fichier `hellwell/dashboard/Dashboard.Page.ps1`
3. **Modifier** le CSS et/ou HTML
4. **Relancer** le dashboard:
   ```bash
   cmd /c "taskkill /F /IM powershell.exe /T" 2>nul
   start powershell -NoProfile -ExecutionPolicy Bypass -File "c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1"
   ```
5. **Commit et push**:
   ```bash
   cd "c:\Users\ludov\.infernal_wheel"
   git add hellwell/dashboard/Dashboard.Page.ps1
   git commit -m "feat/fix(ui): description

   Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
   git push
   ```

---

## Derniere Session (2026-02-07) - PROBLEME EN COURS

### Probleme a resoudre: Alignement des chips sous colonnes tableau

**Structure actuelle du tableau Alcool:**
```
| Semaine | Periode | Biere | Vin | Fort | Dose pure | Delta |
| col 1   | col 2   | col 3 | col 4| col 5| col 6     | delta |
```

**Objectif:** 4 chips d'explication alignes SOUS leurs colonnes respectives:
- Chip Biere -> centre sous colonne 3 (Biere)
- Chip Vin -> centre sous colonne 4 (Vin)
- Chip Fort -> centre sous colonne 5 (Fort)
- Chip Pure -> centre sous colonne 6 (Dose pure)

**Le probleme:** Les chips ne s'alignent pas correctement. Le MILIEU de chaque chip doit etre aligne avec le MILIEU de sa colonne.

**Structure CSS du tableau:**
```css
.weeksTable{
  --week-gap:8px;
  --delta-col:96px;
}
.weekLine{
  display:grid;
  grid-template-columns:minmax(0,1fr) var(--delta-col);
}
.weekRow{
  display:grid;
  grid-template-columns:repeat(6, minmax(0,1fr));
  column-gap:var(--week-gap);
  padding:8px;
}
```

**Ce qui a ete tente:**
- Grille `.alcUnitsRow` avec meme structure que `.weekRow`
- `grid-column:3/4/5/6` pour placer chaque chip
- `justify-self:center` pour centrer
- Reduction taille chips

**Pourquoi ca ne marche pas:**
- Le tableau `.weekRow` est DANS `.weekLine` (grille 2 cols: contenu + delta)
- Les chips `.alcUnitsRow` n'ont pas le wrapper `.weekLine`
- Donc les largeurs ne correspondent pas

**Solution probable:**
- Mettre les chips dans la MEME structure que le tableau:
  ```html
  <div class="weekLine">
    <div class="alcUnitsRow"><!-- chips --></div>
    <div class="weekDelta" style="visibility:hidden"></div>
  </div>
  ```

---

## Header Alcool actuel

```html
<div class="alcHeader">
  <div class="alcHeader__left">
    <h2>Alcool</h2>
    <span class="alcHeader__badge">Semaine en cours</span>
  </div>
  <div class="alcHeader__date">2026-02-07</div>
</div>
```

Style moderne: titre + badge vert a gauche, date a droite.

---

## IDs JavaScript CRITIQUES (NE PAS TOUCHER)

| Zone | IDs |
|------|-----|
| Stats | `statGoal`, `statDone`, `statBreak`, `kRemain`, `progressPct`, `bar` |
| Action | `kSeg`, `kSeg2`, `kTimerElapsed`, `kTimerRemain`, `currentBox` |
| Live | `liveCard`, `firstsToday`, `actionsToday`, `drinkToday`, `smokeToday` |
| Agenda | `agendaTimeline`, `agendaClock`, `agendaToggle`, `agendaDetails` |

---

## Fichiers UX de reference

- `ux_resources/WEB.md` - Regles WCAG, patterns web, accessibilite
- `ux_resources/MOBILE.md` - iOS HIG, Material 3, valeurs concretes (touch 44-48px, spacing, typo)

---

## Git - Derniers commits

```
f443c17 fix(ui): chips centres sous colonnes + taille reduite
d5f961e fix(ui): chips alignes sur grille colonnes tableau
0f0b571 feat(ui): refonte header Alcool + chips uniformes
```
