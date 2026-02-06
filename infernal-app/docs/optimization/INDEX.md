# Index - Documentation Optimisation

## Navigation rapide

### Fondamentaux
- [Scope du projet](./00_scope.md)

### Compatibilite Devices
- [Matrice de compatibilite](./01_device-compat/matrix.md)
- [Bugs connus](./01_device-compat/known-issues.md)
- [Protocoles de test](./01_device-compat/test-protocol.md)

### Performance
- [Budgets performance](./02_performance/budget.md)
- [Guide profiling](./02_performance/profiling.md)
- [Chemins critiques](./02_performance/hotpaths.md)

### Stabilite
- [Securite anti-crash](./03_stability/crash-safety.md)
- [Format de logging](./03_stability/logging.md)
- [Taxonomie des erreurs](./03_stability/error-taxonomy.md)

### Regles UI
- [Sources de verite](./04_ui-rules/source-of-truth.md)
- [Checklist UI](./04_ui-rules/checklist.md)

### Release
- [Verifications build](./05_release-readiness/build-checks.md)
- [Configurations](./05_release-readiness/configs.md)

### Composants UX
- [Banderole Bug (Bottom Banner)](./06_ux-components/banner-bug.md)
- [Fiche Support Projet](./06_ux-components/support-dialog.md)

### Internationalisation & Responsive
- [Setup i18n Multi-Langue](./07_internationalization/i18n-setup.md)
- [Responsive & Anti-Chevauchement](./07_internationalization/responsive-scale.md)

### Localisation (i18n/l10n)
- [Strategie Localisation](./08_localization/strategy.md)
- [Pseudo-Locale (Test UI)](./08_localization/pseudo-locale.md)
- [Regles de Survie UI Multi-Langue](./08_localization/ui-survival-rules.md)

### Stabilite UI
- [Detection Automatique Problemes](./09_ui-stability/layout-issue-detection.md)
- [Patterns de Defaillance Courants](./09_ui-stability/common-failures.md)

### Rapport de Bug Quotidien
- [Schema du Rapport](./10_daily-bug-report/schema.md)
- [Regles de Deduplication](./10_daily-bug-report/dedup-rules.md)

---

## Fichiers de reference (hors ce dossier)

| Fichier | Contenu |
|---------|---------|
| `../WEARABLE_UX.md` | Patterns UX montres connectees |
| `../../pubspec.yaml` | Dependances Flutter |
| `../../lib/theme/spacing.dart` | Systeme de spacing (4px base) |
| `../../lib/theme/colors.dart` | Palette de couleurs |
| `../../lib/debug/layout_issue_detector.dart` | Detection bugs UI automatique |
| `../../lib/debug/daily_bug_report.dart` | Rapport quotidien (1x/jour) |
| `../../lib/l10n/*.arb` | Fichiers traduction (ARB) |

## Tags utilises

- `[iOS]` : specifique Apple
- `[Android]` : specifique Android
- `[Universal]` : applicable partout
- `[TBD]` : valeur a definir (pas de source)
- `[PDF:nom]` : valeur sourcee depuis un PDF
