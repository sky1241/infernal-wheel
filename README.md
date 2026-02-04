# InfernalWheel

Dashboard personnel de suivi quotidien construit en PowerShell avec interface web HTML/CSS/JS.

## Fonctionnalites

- **Suivi du temps** : Work, Sleep, Breaks avec timeline visuelle
- **Tracking d'habitudes** : Cigarettes, alcool, sport, etc.
- **Notes quotidiennes** : Template de check-in matin/soir avec scores /10
- **Statistiques mensuelles** : Graphiques et KPIs
- **Records personnels** : Suivi des meilleurs scores
- **100% local** : Aucune donnee envoyee, tout reste sur votre machine

## Structure

```
hellwell/
  InfernalDashboard.ps1   # Serveur web principal
  InfernalWheel.ps1       # Moteur de tracking
  InfernalIO.psm1         # Module I/O atomique
  dashboard/
    Dashboard.Page.ps1    # Generation HTML/CSS/JS
    Dashboard.Functions.ps1
  engine/
    Engine.Functions.ps1
```

## Demarrage

```powershell
# Lancer le dashboard (port 8011)
pwsh -NoProfile -ExecutionPolicy Bypass -File hellwell/InfernalDashboard.ps1

# Lancer le moteur de tracking
pwsh -NoProfile -ExecutionPolicy Bypass -File hellwell/InfernalWheel.ps1
```

Ouvrir http://127.0.0.1:8011/ dans le navigateur.

## UX/UI Standards

Le projet suit les standards d'accessibilite et UX documentes dans les PDFs inclus :

- `Color Cheatsheet.pdf` - Guide des variations de couleurs HSB
- `universal_ui_rulebook_v1_audit_matrice_v3.pdf` - Regles WCAG (Web, iOS, Android)
- `UX_Behavioral_Patterns_2024-2025_Checklist_FULL_v3.pdf` - Patterns UX comportementaux
- `ux_checklist/` - Checklist detaillee

### Standards appliques

- **Spacing** : Systeme 4px (4, 8, 12, 16, 20, 24, 32, 48)
- **Touch targets** : 44px minimum (WCAG 2.5.8)
- **Focus styles** : Outline 2px + offset 2px (WCAG 2.4.7, 2.4.11, 2.4.13)
- **Motion** : Respect de `prefers-reduced-motion`
- **Contrast** : Support du mode contraste eleve
- **Landmarks** : Navigation, main, footer avec ARIA

## Commandes

Les commandes sont envoyees via l'interface web ou le fichier `commands.in` :

- `start` - Demarrer la journee
- `work` - Commencer a travailler
- `dodo` - Mode sommeil
- `clope` - Pause cigarette
- `manger` - Pause repas
- `sport` - Session sport
- `ok` - Terminer l'action en cours

## Donnees

Toutes les donnees sont stockees localement dans `~/.infernal_wheel/` :

- `state.json` - Etat actuel
- `settings.json` - Configuration
- `log.csv` - Historique des actions
- `drinks.csv` - Suivi alcool
- `notes/` - Notes quotidiennes

## Licence

Usage personnel.
