# Scope du Projet

## Application

**InfernalWheel** - App de suivi d'addictions avec integration montres connectees

## Plateformes cibles

| Plateforme | Version min | Status |
|------------|-------------|--------|
| iOS | 14.0+ | Cible |
| Android | API 26 (8.0)+ | Cible |
| Web | Non supporte | - |
| Desktop | Non supporte | - |

## Fonctionnalites core (offline-first)

1. **Compteurs d'addictions**
   - Increment/decrement avec un tap
   - Historique par jour (InfernalDay: jour commence a 4h)
   - Trends vs jour precedent

2. **Suivi sommeil**
   - Import automatique depuis HealthKit/Health Connect
   - Fallback saisie manuelle
   - Score qualite calcule

3. **Journal libre**
   - Texte quotidien
   - Export pour psy

4. **Configuration**
   - Addictions personnalisables
   - Objectif sommeil

## Contraintes techniques

### Ce qu'on fait
- Stockage local JSON (path_provider)
- Lecture donnees sante (package health)
- UI Material 3 dark mode
- Responsive (portrait/paysage si applicable)

### Ce qu'on ne fait PAS
- Authentification / compte utilisateur
- Synchronisation cloud
- Analytics / tracking
- Paiements in-app
- Notifications push (pour l'instant)
- Backend / API externe

## Dependances autorisees

```yaml
# Core Flutter
flutter: sdk

# Stockage local
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.1.1

# Donnees sante
health: ^4.4.0

# State management
provider: ^6.1.1

# Utils
intl: ^0.18.1
share_plus: ^7.2.1
```

## Structure de donnees

### Stockage local
```
/documents/
├── settings.json       <- Configuration utilisateur
└── days/
    ├── 2024-02-05.json <- Donnees du jour
    ├── 2024-02-06.json
    └── ...
```

### Format DayEntry
```json
{
  "dayKey": "2024-02-06",
  "sleep": {
    "source": "healthKit|healthConnect|manual",
    "wakeTime": "2024-02-06T10:30:00",
    "durationMinutes": 450,
    "quality": "good"
  },
  "addictions": [
    {"type": "tabac", "count": 5, "firstTime": "..."}
  ],
  "journalText": "Notes libres...",
  "createdAt": "...",
  "updatedAt": "..."
}
```
