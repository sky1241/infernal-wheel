# InfernalWheel App

App cross-platform (iOS + Android) de suivi d'addictions avec integration montres connectees.

## Stack

- **Flutter** - Cross-platform iOS + Android
- **health** package - Acces HealthKit (iOS) + Health Connect (Android)
- **Hive** - Base locale NoSQL (rapide, pas de SQLite)
- **Provider/Riverpod** - State management

## Pour demarrer

```bash
# Installer Flutter
# https://docs.flutter.dev/get-started/install

# Cloner et lancer
cd infernal-app
flutter pub get
flutter run
```

## Structure

```
lib/
  main.dart                 # Entry point
  models/
    addiction.dart          # Types addictions
    sleep_data.dart         # Donnees sommeil
    day_entry.dart          # Journee complete
    user_settings.dart      # Config utilisateur
  views/
    home_screen.dart        # Ecran principal
    journal_screen.dart     # Texte libre + export
    settings_screen.dart    # Configuration
    onboarding_screen.dart  # Premier lancement
    components/
      addiction_card.dart   # Carte +/- addiction
      sleep_card.dart       # Carte sommeil
      trend_indicator.dart  # Fleche trend
      counter_button.dart   # Bouton +/-
  services/
    health_service.dart     # HealthKit + Health Connect
    storage_service.dart    # Persistance Hive
    migration_service.dart  # Import donnees PowerShell
    export_service.dart     # Export psy
  utils/
    infernal_day.dart       # Logique 4h du matin
    formatters.dart         # Formatage dates/durees
  theme/
    app_theme.dart          # Couleurs, typo
    colors.dart             # Palette
    spacing.dart            # Systeme 4px

assets/
  fonts/                    # Polices custom si besoin
  icons/                    # Icones SVG custom (porn, etc)
```

## Montres supportees

### iOS (via HealthKit)
- Apple Watch
- Toute montre qui sync avec l'app Sante

### Android (via Health Connect)
- Samsung Galaxy Watch
- Fitbit
- Garmin
- Xiaomi Mi Band
- Huawei Watch
- Withings
- Polar
- Oura Ring

## Permissions requises

### iOS (Info.plist)
- NSHealthShareUsageDescription

### Android (AndroidManifest.xml)
- android.permission.health.READ_SLEEP
- android.permission.health.READ_HEART_RATE (optionnel)

## Migration donnees PowerShell

Le dossier `infernal-migration/` contient les scripts pour:
1. Exporter les donnees du projet PowerShell actuel
2. Les convertir au format de l'app
3. Les importer au premier lancement

## UX Patterns Montres

Voir `docs/WEARABLE_UX.md` pour les patterns specifiques.
