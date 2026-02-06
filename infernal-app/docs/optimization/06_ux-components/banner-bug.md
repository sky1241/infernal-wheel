# Banderole Bug (Bottom Banner)

## Objectif

Afficher les erreurs/bugs de maniere non-intrusive en bas de l'ecran.
L'utilisateur peut continuer a utiliser l'app pendant que le message est visible.

---

## Specs Visuelles

### Position
```
┌─────────────────────────────────┐
│                                 │
│         CONTENU APP             │
│                                 │
│                                 │
├─────────────────────────────────┤
│ ⚠️ Message d'erreur ici    [X]  │  <- Banner
└─────────────────────────────────┘
     ↑ Safe area bottom respectee
```

### Dimensions
| Propriete | Valeur | Source |
|-----------|--------|--------|
| Hauteur min | 48dp | WCAG touch target |
| Padding horizontal | 16dp | Spacing system |
| Padding vertical | 12dp | Spacing system |
| Marge bottom | safe area + 8dp | Device compat |

### Couleurs par type

| Type | Background | Border | Icone | Texte |
|------|------------|--------|-------|-------|
| Error | `#FF4D4D` 15% | `#FF4D4D` 40% | `#FF4D4D` | `#F2F2F2` |
| Warning | `#F6B73C` 15% | `#F6B73C` 40% | `#F6B73C` | `#F2F2F2` |
| Info | `#1DA1F2` 15% | `#1DA1F2` 40% | `#1DA1F2` | `#F2F2F2` |
| Success | `#35D99A` 15% | `#35D99A` 40% | `#35D99A` | `#F2F2F2` |

---

## Comportement

### Apparition
- Slide up depuis le bas (200ms, ease-out)
- Respecte `prefers-reduced-motion` (apparition instantanee si active)

### Disparition
- Auto-dismiss apres 5s (configurable)
- Dismiss manuel via bouton X ou swipe down
- Slide down (150ms, ease-in)

### Accessibilite
- `aria-live="polite"` / `accessibilityLiveRegion`
- Bouton X avec label "Fermer le message"
- Touch target X >= 44x44

### Queue
- Max 1 banner visible a la fois
- Nouveaux messages remplacent l'ancien
- Messages critiques (error) prioritaires sur info/warning

### Limitation frequence
- **MAX 1 banner bug par jour** (erreurs utilisateur)
- Exceptions: erreurs critiques systeme (crash imminent)
- Stocke `lastBugBannerDate` dans settings
- Reset a minuit (InfernalDay = 4h du matin)

```dart
bool canShowBugBanner() {
  final lastShown = settings.lastBugBannerDate;
  if (lastShown == null) return true;
  return InfernalDay.fromDate(lastShown).key != InfernalDay.current().key;
}
```

---

## Implementation Flutter

```dart
enum BannerType { error, warning, info, success }

class AppBanner {
  final BannerType type;
  final String message;
  final Duration duration;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  const AppBanner({
    required this.type,
    required this.message,
    this.duration = const Duration(seconds: 5),
    this.onDismiss,
    this.onAction,
    this.actionLabel,
  });
}

// Usage
BannerController.show(AppBanner(
  type: BannerType.error,
  message: 'Impossible de sauvegarder. Reessayez.',
  onAction: () => retry(),
  actionLabel: 'Reessayer',
));
```

---

## Exemples de messages

| Contexte | Type | Message |
|----------|------|---------|
| Sauvegarde echouee | error | "Sauvegarde impossible. Verifiez l'espace disque." |
| Donnees corrompues | warning | "Donnees du jour corrompues. Reinitialise." |
| Export reussi | success | "Export copie dans le presse-papier." |
| Nouvelle version | info | "Mise a jour disponible." |
| Pas de montre | info | "Montre non detectee. Saisie manuelle activee." |

---

## Animation CSS (reference web)

```css
.banner {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  transform: translateY(100%);
  transition: transform 200ms ease-out;
}

.banner.visible {
  transform: translateY(0);
}

@media (prefers-reduced-motion: reduce) {
  .banner {
    transition: none;
  }
}
```
