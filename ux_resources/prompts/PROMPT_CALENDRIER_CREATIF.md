# Prompt - Refonte Creative du Calendrier

## Contexte

Dashboard PowerShell qui genere du HTML/CSS/JS.
- **Fichier principal:** `hellwell/dashboard/Dashboard.Page.ps1`
- **URL:** http://127.0.0.1:8011/
- **Section a modifier:** Le calendrier (lignes ~875 a ~1100 pour le CSS)

---

## Workflow OBLIGATOIRE

### 1. Lire les regles UX
```
ux_resources/WEB.md    (~200 regles web)
ux_resources/MOBILE.md (~300 regles mobile)
```

### 2. Lire le fichier Dashboard
```
hellwell/dashboard/Dashboard.Page.ps1
```
- CSS du calendrier: chercher `td.day{`
- HTML des cellules: chercher `# === BUILD CELL ===`

### 3. Modifier le CSS/HTML

### 4. RELANCER LE SERVEUR (obligatoire!)
```bash
taskkill /F /IM powershell.exe /T 2>nul
sleep 2
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "c:\Users\ludov\.infernal_wheel\hellwell\start_dashboard.ps1" &
sleep 4
netstat -an | grep ":8011"
```

### 5. Tester
- Hard refresh: `Ctrl+Shift+R`
- Verifier visuellement

### 6. Si valide, commit
```bash
cd "c:\Users\ludov\.infernal_wheel"
git add hellwell/dashboard/Dashboard.Page.ps1
git commit -m "feat(calendar): description"
git push
```

---

## Structure actuelle du calendrier

### HTML d'une cellule (simplifie)
```html
<td class="day today">
  <div class="dhead">
    <span class="dnum">7</span>
    <span class="dwork">💻 7h51m</span>
  </div>
  <div class="dstats">
    <span class="dstat dstat--sleep">💤 6h</span>
    <span class="dstat dstat--alc">🍷1 🍺3</span>
    <span class="dstat dstat--smoke">🚬9</span>
  </div>
  <div class="dacts">
    <span class="dacts-toggle">📋 5 activites</span>
  </div>
  <a class="dnote" href="/notes?d=...">📝</a>
</td>
```

### Classes CSS importantes
| Classe | Role |
|--------|------|
| `td.day` | Cellule de jour |
| `td.day.today` | Jour actuel |
| `td.day.empty` | Cellules vides debut/fin mois |
| `.dhead` | Header (numero + travail) |
| `.dnum` | Numero du jour |
| `.dwork` | Badge temps de travail |
| `.dstats` | Conteneur stats |
| `.dstat` | Un stat (sleep/alc/smoke) |
| `.dacts` | Activites |
| `.dnote` | Lien vers notes |

---

## Regles UX a respecter

### Touch targets
- Minimum 44px pour boutons/liens cliquables
- Espacement 8px entre elements interactifs

### Contraste
- Texte: 4.5:1 minimum
- Composants UI: 3:1 minimum

### Hierarchy visuelle
- Numero du jour = element le plus visible
- Stats = secondaire
- Actions = tertiaire

### Spacing (base 4px)
- 4, 8, 12, 16, 24, 32, 48px

### Couleurs coherentes
- Pas trop de couleurs differentes
- Accent unique pour "today"
- Stats en nuances de gris ou monochromes

---

## Idees creatives a explorer

### Option A: Ultra-minimaliste
- Juste le numero + icones sans texte
- Fond plat sans gradient
- Stats visibles au hover seulement

### Option B: Tiles colorees
- Chaque jour = couleur basee sur l'activite
- Plus de travail = plus intense
- Gradient du plus clair au plus fonce

### Option C: Heatmap style
- Cellules petites et carrees
- Couleur = niveau d'activite
- Tooltip au hover pour details

### Option D: Timeline verticale
- Abandonner la grille 7 colonnes
- Liste verticale avec jours groupes par semaine
- Plus d'espace pour les details

### Option E: Cards modernes
- Chaque jour = mini-card avec shadow
- Stats en icones alignees en bas
- Hover = expansion avec details

---

## Prompt a copier-coller

```
Je veux refaire completement le design du calendrier de mon dashboard.

WORKFLOW:
1. Lis d'abord ux_resources/WEB.md et ux_resources/MOBILE.md
2. Lis hellwell/dashboard/Dashboard.Page.ps1 (section CSS calendrier ~ligne 875)
3. Propose-moi 2-3 options de design radicalement differentes avec mockup ASCII
4. Je choisis, tu implementes
5. Tu relances le serveur OBLIGATOIREMENT apres chaque modif
6. On itere jusqu'a ce que ce soit beau

CONTRAINTES:
- Hauteur fixe pour toutes les cellules (symetrie)
- Pas de "sapin de Noel" (trop de couleurs)
- Hierarchy claire: numero > travail > stats > actions
- Touch targets 44px minimum
- Cellules vides quasi invisibles

STYLE SOUHAITE: [choisis: minimaliste / moderne / heatmap / cards / autre]

Sois CREATIF et AUDACIEUX - pas de changements timides!
```

---

## Pour annuler des changements

```bash
# Voir les derniers commits
git log --oneline -10

# Revenir a un commit specifique (juste le fichier)
git checkout <hash> -- hellwell/dashboard/Dashboard.Page.ps1

# Ou annuler tout ce qui n'est pas commit
git checkout -- hellwell/dashboard/Dashboard.Page.ps1
```
