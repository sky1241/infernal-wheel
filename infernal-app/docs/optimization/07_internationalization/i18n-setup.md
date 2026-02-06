# Internationalisation (i18n)

## Objectif

App utilisable dans TOUTES les langues. UX coherent peu importe la langue.

---

## Langues prioritaires

| Priorite | Langue | Code | Population touchee |
|----------|--------|------|-------------------|
| 1 | Francais | `fr` | Base initiale |
| 2 | Anglais | `en` | Monde entier |
| 3 | Espagnol | `es` | 500M+ |
| 4 | Portugais | `pt` | 250M+ (Bresil) |
| 5 | Allemand | `de` | 100M+ |
| 6 | Arabe | `ar` | 400M+ (RTL!) |
| 7 | Chinois | `zh` | 1B+ |

---

## Structure fichiers

```
lib/
└── l10n/
    ├── app_fr.arb      <- Francais (source)
    ├── app_en.arb      <- Anglais
    ├── app_es.arb      <- Espagnol
    ├── app_pt.arb      <- Portugais
    ├── app_de.arb      <- Allemand
    ├── app_ar.arb      <- Arabe (RTL)
    └── app_zh.arb      <- Chinois
```

---

## Format ARB (Application Resource Bundle)

```json
// app_fr.arb (source)
{
  "@@locale": "fr",
  "appName": "InfernalWheel",
  "today": "Aujourd'hui",
  "yesterday": "Hier",
  "cigarettes": "Cigarettes",
  "beers": "Bieres",
  "wine": "Verres de vin",
  "spirits": "Alcool fort",
  "sleep": "Sommeil",
  "wakeTime": "Reveil",
  "duration": "Duree",
  "quality": "Qualite",
  "journal": "Journal",
  "settings": "Config",
  "export": "Exporter",
  "support": "Soutenir",
  "increment": "Ajouter",
  "decrement": "Retirer",

  "sleepQualityBad": "Mauvais",
  "sleepQualityPoor": "Insuffisant",
  "sleepQualityOkay": "Moyen",
  "sleepQualityGood": "Bon",
  "sleepQualityGreat": "Excellent",

  "errorSaveFailed": "Sauvegarde impossible",
  "errorLoadFailed": "Chargement echoue",
  "noSleepData": "Pas de donnees sommeil",
  "manualEntry": "Saisie manuelle",

  "supportTitle": "Soutenir InfernalWheel?",
  "supportDesc": "Cette app est 100% gratuite et sans tracking.",
  "donate": "Faire un don",
  "watchAd": "Regarder une pub",
  "noThanks": "Non merci"
}
```

```json
// app_en.arb
{
  "@@locale": "en",
  "appName": "InfernalWheel",
  "today": "Today",
  "yesterday": "Yesterday",
  "cigarettes": "Cigarettes",
  "beers": "Beers",
  "wine": "Glasses of wine",
  "spirits": "Spirits",
  "sleep": "Sleep",
  "wakeTime": "Wake time",
  "duration": "Duration",
  "quality": "Quality",
  "journal": "Journal",
  "settings": "Settings",
  "export": "Export",
  "support": "Support",
  "increment": "Add",
  "decrement": "Remove",

  "sleepQualityBad": "Bad",
  "sleepQualityPoor": "Poor",
  "sleepQualityOkay": "Okay",
  "sleepQualityGood": "Good",
  "sleepQualityGreat": "Great",

  "errorSaveFailed": "Save failed",
  "errorLoadFailed": "Load failed",
  "noSleepData": "No sleep data",
  "manualEntry": "Manual entry",

  "supportTitle": "Support InfernalWheel?",
  "supportDesc": "This app is 100% free with no tracking.",
  "donate": "Donate",
  "watchAd": "Watch an ad",
  "noThanks": "No thanks"
}
```

---

## Configuration pubspec.yaml

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.1

flutter:
  generate: true
```

## Configuration l10n.yaml

```yaml
arb-dir: lib/l10n
template-arb-file: app_fr.arb
output-localization-file: app_localizations.dart
output-class: L
```

---

## Usage dans le code

```dart
// main.dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  // Auto-detect system locale
  locale: null,
)

// Dans un widget
Text(L.of(context)!.today)
Text(L.of(context)!.cigarettes)
```

---

## Regles UX multi-langue

### 1. Taille du texte variable
- Allemand = +30% plus long que anglais
- Chinois = -50% plus court
- **Solution** : `Flexible` + `overflow: TextOverflow.ellipsis`

### 2. Direction RTL (arabe, hebreu)
- Tout le layout s'inverse
- **Solution** : `Directionality.of(context)` + pas de `left/right` hardcodes

### 3. Pluralisation
```json
"cigarettesCount": "{count, plural, =0{Aucune cigarette} =1{1 cigarette} other{{count} cigarettes}}"
```

### 4. Dates et nombres
- Format date : `DateFormat.yMMMd(locale)`
- Format nombre : `NumberFormat.decimalPattern(locale)`

---

## Detection automatique langue

```dart
String getDeviceLocale(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return locale.languageCode; // 'fr', 'en', 'es', etc.
}

// Fallback si langue non supportee
Locale resolveLocale(Locale? locale, Iterable<Locale> supported) {
  if (locale == null) return const Locale('en');

  // Match exact
  if (supported.contains(locale)) return locale;

  // Match langue sans region (fr_CA -> fr)
  final langOnly = Locale(locale.languageCode);
  if (supported.contains(langOnly)) return langOnly;

  // Fallback anglais
  return const Locale('en');
}
```

---

## Checklist i18n

- [ ] Aucun texte hardcode dans les widgets
- [ ] Tous les textes dans fichiers .arb
- [ ] Pluralisation pour les compteurs
- [ ] Dates formatees selon locale
- [ ] Nombres formatees selon locale
- [ ] RTL teste (arabe)
- [ ] Texte long teste (allemand)
- [ ] Texte court teste (chinois)
