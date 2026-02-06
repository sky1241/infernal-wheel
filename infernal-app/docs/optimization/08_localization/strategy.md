# Strategie Localisation (i18n/l10n)

## Objectif

App utilisable dans TOUTES les langues sans casser l'UI.

---

## Architecture fichiers

```
lib/
├── l10n/
│   ├── app_fr.arb         <- Source (francais)
│   ├── app_en.arb         <- Anglais
│   ├── app_es.arb         <- Espagnol
│   ├── app_pt.arb         <- Portugais
│   ├── app_de.arb         <- Allemand (LONG)
│   ├── app_ar.arb         <- Arabe (RTL)
│   ├── app_zh.arb         <- Chinois (COURT)
│   └── app_pseudo.arb     <- PSEUDO-LOCALE (test)
└── generated/
    └── l10n.dart          <- Auto-genere par Flutter
```

---

## Conventions de cles

### Nommage
```
{screen}_{element}_{variant}
```

Exemples:
```json
"home_title": "Aujourd'hui",
"home_addictionCard_increment": "Ajouter",
"settings_sleepGoal_label": "Objectif sommeil",
"error_saveFailed_message": "Sauvegarde impossible"
```

### Pluralisation (ICU MessageFormat)
```json
"home_cigarettes_count": "{count, plural, =0{Aucune cigarette} =1{1 cigarette} other{{count} cigarettes}}"
```

### Variables
```json
"journal_export_date": "Exporte le {date}",
"sleep_duration_format": "{hours}h{minutes}"
```

---

## Fallback chain

```
1. Locale exacte (fr_CA)
2. Langue seule (fr)
3. Anglais (en)
4. Francais (fr) <- fallback ultime car source
```

```dart
Locale resolveLocale(Locale? deviceLocale, Iterable<Locale> supported) {
  if (deviceLocale == null) return const Locale('en');

  // Exact match
  for (final locale in supported) {
    if (locale == deviceLocale) return locale;
  }

  // Language only match
  for (final locale in supported) {
    if (locale.languageCode == deviceLocale.languageCode) return locale;
  }

  // Fallback
  return const Locale('en');
}
```

---

## RTL Support (Arabe, Hebreu)

### Detection
```dart
bool isRTL(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl;
}
```

### Regles de code
```dart
// MAUVAIS - hardcode left/right
Padding(padding: EdgeInsets.only(left: 16))

// BON - utilise start/end
Padding(padding: EdgeInsetsDirectional.only(start: 16))

// MAUVAIS - Row avec ordre fixe
Row(children: [icon, text, arrow])

// BON - si l'ordre doit changer en RTL
Row(
  textDirection: TextDirection.ltr, // Force LTR si necessaire
  children: [icon, text, arrow],
)
```

### Assets directionnels
```dart
// Fleche qui doit pointer dans la bonne direction
Icon(
  isRTL(context) ? Icons.arrow_back : Icons.arrow_forward,
)
```

---

## Text Scale (Accessibilite)

### Detection
```dart
double getTextScale(BuildContext context) {
  return MediaQuery.textScaleFactorOf(context);
}

bool isLargeText(BuildContext context) {
  return getTextScale(context) > 1.3;
}
```

### Adaptation UI
```dart
// Reduire padding si texte tres grand
final padding = isLargeText(context) ? 8.0 : 16.0;

// Limiter scale si vraiment necessaire (rare)
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaleFactor: getTextScale(context).clamp(1.0, 1.5),
  ),
  child: CriticalWidget(),
)
```

---

## Formats locaux

### Dates
```dart
import 'package:intl/intl.dart';

String formatDate(DateTime date, String locale) {
  return DateFormat.yMMMd(locale).format(date);
}

// fr: "6 fevr. 2024"
// en: "Feb 6, 2024"
// de: "6. Feb. 2024"
```

### Nombres
```dart
String formatNumber(num value, String locale) {
  return NumberFormat.decimalPattern(locale).format(value);
}

// fr: "1 234,56"
// en: "1,234.56"
// de: "1.234,56"
```

### Heures
```dart
String formatTime(DateTime time, String locale) {
  return DateFormat.Hm(locale).format(time);
}

// fr: "14:30"
// en (US): "2:30 PM"
```

---

## Checklist localisation

- [ ] Aucun texte hardcode dans les widgets
- [ ] Toutes les cles dans fichiers .arb
- [ ] Pluralisation pour tous les compteurs
- [ ] Dates/nombres via `intl` package
- [ ] `EdgeInsetsDirectional` partout (pas `EdgeInsets.only(left:)`)
- [ ] Teste en pseudo-locale
- [ ] Teste en RTL (arabe)
- [ ] Teste avec textScaleFactor 2.0
