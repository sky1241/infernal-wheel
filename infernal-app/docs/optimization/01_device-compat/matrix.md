# Matrice de Compatibilite

## Ecrans cibles

### iOS [iOS]

| Device | Largeur (pt) | Safe Area Top | Safe Area Bottom | Densite |
|--------|--------------|---------------|------------------|---------|
| iPhone SE (2nd/3rd) | 375 | 20 | 0 | 2x |
| iPhone 8/SE | 375 | 20 | 0 | 2x |
| iPhone 12 mini | 375 | 50 | 34 | 3x |
| iPhone 12/13/14 | 390 | 47 | 34 | 3x |
| iPhone 14 Pro | 393 | 59 | 34 | 3x |
| iPhone 14 Pro Max | 430 | 59 | 34 | 3x |
| iPhone 15 | 393 | 59 | 34 | 3x |

### Android [Android]

| Categorie | Largeur (dp) | Densite typique |
|-----------|--------------|-----------------|
| Compact (low-end) | 320-360 | mdpi-hdpi |
| Normal | 360-400 | xhdpi |
| Large | 400-480 | xxhdpi |
| XLarge (tablette) | 600+ | xxxhdpi |

## OS Versions

### iOS [iOS]
- **Minimum** : iOS 14.0
- **Cible** : iOS 17+
- **Raison** : HealthKit APIs stables, SwiftUI optionnel

### Android [Android]
- **Minimum** : API 26 (Android 8.0)
- **Cible** : API 34 (Android 14)
- **Raison** : Health Connect necessite API 28+, mais fallback possible

## Safe Areas

### Regles [Universal]

```dart
// TOUJOURS utiliser SafeArea pour le contenu scrollable
SafeArea(
  child: /* content */,
)

// Pour les FAB, respecter le bottom inset
Positioned(
  bottom: MediaQuery.of(context).padding.bottom + 16,
  child: FloatingActionButton(...),
)
```

### Points sensibles

| Element | Risque | Solution |
|---------|--------|----------|
| Bottom nav | Chevauche home indicator | `SafeArea` ou padding manuel |
| Header | Chevauche notch/dynamic island | `SafeArea` top |
| FAB | Cache par clavier/nav bar | Positionner avec padding bottom |
| Modal bottom sheet | Coupe par home indicator | `SafeArea` dans le sheet |

## Orientations

| Mode | Support | Notes |
|------|---------|-------|
| Portrait | Oui | Mode principal |
| Paysage | TBD | A evaluer selon usage |

## Low-End Devices

### Caracteristiques cibles

| Spec | Minimum | Recommande |
|------|---------|------------|
| RAM | 2 GB | 4 GB+ |
| CPU | Quad-core 1.4GHz | Octa-core 2.0GHz+ |
| Stockage libre | 50 MB | 100 MB+ |

### Optimisations requises

1. **Pas d'animations lourdes** sur `prefers-reduced-motion`
2. **Images optimisees** (WebP, tailles adaptees)
3. **Lazy loading** des listes longues
4. **Throttling** des sauvegardes (debounce 500ms)
