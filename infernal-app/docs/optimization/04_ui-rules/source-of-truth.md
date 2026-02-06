# Sources de Verite UI

## PDFs de reference

### 1. UX Behavioral Checklist (`ux_checklist/UX_Behavioral_Checklist.pdf`)
- **Pages** : 23
- **Contenu** : Patterns comportementaux UX
- **Usage** : Loading states, toasts, empty states, form validation, animations

### 2. Universal UI Rulebook (`universal_ui_rulebook_v1_audit_matrice_v3.pdf`)
- **Pages** : 37
- **Contenu** : Regles WCAG, accessibilite, layouts
- **Usage** : Focus styles, contraste, touch targets, landmarks

### 3. Color Cheatsheet (`Color Cheatsheet.pdf`)
- **Contenu** : Guide variations HSB
- **Usage** : Hover/active states, couleurs derivees

---

## Valeurs extraites et appliquees

### Spacing System [PDF: UI Rulebook]

| Token | Valeur | Source |
|-------|--------|--------|
| `--sp-4` | 4px | PDF page X (TBD: verifier) |
| `--sp-8` | 8px | PDF |
| `--sp-12` | 12px | PDF |
| `--sp-16` | 16px | PDF |
| `--sp-20` | 20px | PDF |
| `--sp-24` | 24px | PDF |
| `--sp-32` | 32px | PDF |
| `--sp-48` | 48px | PDF |

**Implementation** : `lib/theme/spacing.dart`

### Touch Targets [PDF: UI Rulebook - WCAG 2.5.8]

| Plateforme | Minimum | Source |
|------------|---------|--------|
| iOS | 44pt | PDF (WCAG 2.5.8) |
| Android | 48dp | PDF (WCAG 2.5.8) |
| Web | 24px (44px preferred) | PDF |

**Implementation** : `lib/theme/spacing.dart` -> `Spacing.touchTarget = 48`

### Focus Styles [PDF: UI Rulebook - WCAG 2.4.7, 2.4.11, 2.4.13]

| Propriete | Valeur | Source |
|-----------|--------|--------|
| Outline width | 2px | PDF (WCAG 2.4.7) |
| Outline offset | 2px | PDF |
| Minimum focus area | 4px | PDF (WCAG 2.4.13) |

**Implementation** : `lib/theme/app_theme.dart` -> focusedBorder

### Couleurs hover/active [PDF: Color Cheatsheet]

| Etat | Transformation | Source |
|------|----------------|--------|
| Hover | `brightness(1.1) saturate(1.3)` | PDF Color Cheatsheet |
| Active | `brightness(0.95) saturate(1.4)` | PDF Color Cheatsheet |
| Lighter | +brightness, -saturation, hue toward cyan/magenta/yellow | PDF |
| Darker | -brightness, +saturation, hue toward red/green/blue | PDF |

---

## Valeurs NON sourcees (TBD)

Ces valeurs sont des estimations raisonnables, pas des sources PDF :

| Valeur | Actuel | Statut |
|--------|--------|--------|
| Animation durations | 200ms | TBD - pas de source PDF |
| Border radius | 8/12/16px | TBD - estimation |
| Shadow blur | 12px | TBD - estimation |
| Icon sizes | 16/24/32px | TBD - standard Material |

---

## Regles d'application

### Principe 1 : Ne pas inventer

Si une valeur n'est pas dans un PDF :
1. Utiliser une valeur standard (Material, Human Interface Guidelines)
2. Marquer comme "TBD" dans le code
3. Documenter dans ce fichier

### Principe 2 : Tracer la source

```dart
// BON - source tracee
/// Touch target minimum (WCAG 2.5.8, PDF UI Rulebook)
static const double touchTarget = 48;

// MAUVAIS - source inconnue
static const double touchTarget = 48;
```

### Principe 3 : Une seule source de verite

- Les valeurs vivent dans `lib/theme/`
- Les PDFs sont la reference
- Ce fichier fait le lien entre les deux
