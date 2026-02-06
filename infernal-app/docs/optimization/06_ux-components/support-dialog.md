# Fiche "Soutenir le Projet"

## Objectif

Demander a l'utilisateur de soutenir le projet de maniere non-intrusive.
3 options claires : Oui (don), Non merci, Regarder une pub.

**Important** : Cette fiche est pour le FUTUR. Pas de pub ni paiement implementes maintenant.

---

## Quand afficher ?

| Declencheur | Condition |
|-------------|-----------|
| Apres X jours d'usage | 7 jours consecutifs minimum |
| Apres X actions | 50 increments total |
| Jamais si deja fait | Une seule fois |
| Respecter refus | Si "Non merci", ne plus afficher pendant 30 jours |

**Jamais** au premier lancement ou pendant une action importante.

---

## Specs Visuelles

### Layout
```
┌─────────────────────────────────┐
│              🔥                 │
│                                 │
│     Soutenir InfernalWheel?     │
│                                 │
│   Cette app est 100% gratuite   │
│   et sans tracking. Tu peux     │
│   aider a la maintenir.         │
│                                 │
│  ┌─────────────────────────┐    │
│  │   ❤️ Faire un don       │    │  <- Primary button
│  └─────────────────────────┘    │
│                                 │
│  ┌─────────────────────────┐    │
│  │   📺 Regarder une pub   │    │  <- Secondary button
│  └─────────────────────────┘    │
│                                 │
│       Non merci, plus tard      │   <- Text link
│                                 │
└─────────────────────────────────┘
```

### Dimensions
| Element | Valeur |
|---------|--------|
| Modal width | 90% ecran (max 320dp) |
| Padding | 24dp |
| Border radius | 16dp |
| Boutons height | 48dp |
| Gap entre boutons | 12dp |

### Couleurs
| Element | Couleur |
|---------|---------|
| Background modal | `#1A1E23` (surface) |
| Titre | `#F2F2F2` (text) |
| Description | `#B0B0B0` (textSecondary) |
| Bouton don | `#35D99A` (accent) |
| Bouton pub | `#22272D` (surfaceLight) + border |
| Lien "Non merci" | `#6B7280` (muted) |

---

## Comportement

### Affichage
- Modal center avec overlay sombre (50% opacity)
- Fade in + scale (200ms)
- Bloque le scroll arriere

### Actions
| Bouton | Action |
|--------|--------|
| "Faire un don" | Ouvre page web externe (futur) |
| "Regarder une pub" | Lance pub rewarded (futur) |
| "Non merci" | Ferme et flag 30 jours |
| Tap overlay | Ferme (compte comme "Non merci") |
| Back button | Ferme (compte comme "Non merci") |

### Persistance
```dart
// Stocker dans UserSettings
DateTime? lastSupportPrompt;
bool supportPromptDismissed = false;

// Logique d'affichage
bool shouldShowSupportPrompt() {
  if (supportPromptDismissed) return false;
  if (lastSupportPrompt != null) {
    final daysSince = DateTime.now().difference(lastSupportPrompt!).inDays;
    if (daysSince < 30) return false;
  }
  return daysUsed >= 7 && totalIncrements >= 50;
}
```

---

## Accessibilite

- Focus trap dans le modal
- Ordre de lecture : titre > description > boutons
- Bouton "Non merci" accessible au clavier
- `aria-modal="true"` / `isModal: true`
- Annonce VoiceOver : "Dialogue soutenir le projet"

---

## Textes

### Version francaise
```
Titre: "Soutenir InfernalWheel?"

Description: "Cette app est 100% gratuite, sans pub et sans tracking.
Tu peux aider a la maintenir en vie."

Bouton 1: "❤️ Faire un don"
Bouton 2: "📺 Regarder une pub"
Lien: "Non merci, plus tard"
```

### Ton
- Pas culpabilisant
- Pas de pression
- Transparent sur le "gratuit sans tracking"
- Option "Non" visible et facile

---

## Implementation Flutter (structure)

```dart
class SupportDialog extends StatelessWidget {
  final VoidCallback onDonate;
  final VoidCallback onWatchAd;
  final VoidCallback onDismiss;

  const SupportDialog({
    required this.onDonate,
    required this.onWatchAd,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 48)),
            const SizedBox(height: Spacing.md),
            Text(
              'Soutenir InfernalWheel?',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              'Cette app est 100% gratuite, sans pub et sans tracking. '
              'Tu peux aider a la maintenir.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.xl),
            // Boutons...
          ],
        ),
      ),
    );
  }
}
```

---

## Notes IMPORTANTES

1. **PAS DE PUB MAINTENANT** - Juste la structure pour le futur
2. **PAS DE PAIEMENT MAINTENANT** - Juste la structure
3. Le bouton "Faire un don" peut rediriger vers une page web simple
4. Le bouton "Regarder une pub" est desactive/cache si pas configure
5. **100% optionnel** - L'app fonctionne parfaitement sans jamais cliquer
