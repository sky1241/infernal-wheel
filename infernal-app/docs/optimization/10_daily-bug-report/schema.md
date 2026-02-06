# Schema du Rapport de Bug Quotidien

## Objectif

Un rapport **1 fois par jour maximum**, agrege, dedoublonne, **actionnable**.

---

## Principes

1. **Pas de spam** : 1 rapport max par 24h
2. **Agrege** : Meme bug x10 = 1 entree avec count
3. **Dedoublonne** : Bugs identiques fusionnes
4. **Actionnable** : Chaque bug a une solution suggeree
5. **Prioritise** : CRITICAL > ERROR > WARNING > INFO

---

## Format JSON du rapport

```json
{
  "reportId": "2024-02-06",
  "generatedAt": "2024-02-06T04:00:00Z",
  "device": {
    "os": "iOS",
    "version": "17.2",
    "model": "iPhone 14",
    "screenWidth": 390,
    "screenHeight": 844,
    "textScale": 1.0,
    "locale": "fr_FR",
    "isRTL": false
  },
  "app": {
    "version": "1.2.0",
    "buildNumber": 42
  },
  "summary": {
    "total": 5,
    "critical": 1,
    "error": 2,
    "warning": 2,
    "info": 0
  },
  "issues": [
    {
      "id": "overflow_home_card_title",
      "type": "overflow",
      "severity": "CRITICAL",
      "message": "RenderFlex overflow in home card title",
      "widget": "HomeScreen > AddictionCard > Row > Text",
      "occurrences": 3,
      "firstSeen": "2024-02-06T08:15:00Z",
      "lastSeen": "2024-02-06T14:30:00Z",
      "context": {
        "textContent": "Verres de vin blanc moelleux...",
        "containerWidth": 200,
        "textWidth": 280
      },
      "suggestion": "Add Expanded wrapper and TextOverflow.ellipsis"
    },
    {
      "id": "small_touch_settings_icon",
      "type": "small_touch",
      "severity": "WARNING",
      "message": "Touch target too small: 32x32 < 44",
      "widget": "SettingsScreen > IconButton",
      "occurrences": 1,
      "firstSeen": "2024-02-06T09:00:00Z",
      "lastSeen": "2024-02-06T09:00:00Z",
      "context": {
        "actualSize": "32x32",
        "minimumSize": "44x44"
      },
      "suggestion": "Add constraints: BoxConstraints(minWidth: 48, minHeight: 48)"
    }
  ]
}
```

---

## Champs du rapport

### Device

| Champ | Type | Description |
|-------|------|-------------|
| `os` | string | iOS / Android |
| `version` | string | Version OS |
| `model` | string | Modele appareil |
| `screenWidth` | int | Largeur ecran (dp) |
| `screenHeight` | int | Hauteur ecran (dp) |
| `textScale` | float | Facteur taille texte |
| `locale` | string | Langue + region |
| `isRTL` | bool | Right-to-left actif |

### Issue

| Champ | Type | Description |
|-------|------|-------------|
| `id` | string | Hash unique (type + widget) |
| `type` | string | overflow, truncation, small_touch, etc. |
| `severity` | string | CRITICAL, ERROR, WARNING, INFO |
| `message` | string | Description humaine |
| `widget` | string | Chemin widget dans l'arbre |
| `occurrences` | int | Nombre de fois detecte |
| `firstSeen` | datetime | Premiere occurrence |
| `lastSeen` | datetime | Derniere occurrence |
| `context` | object | Donnees specifiques au bug |
| `suggestion` | string | Solution recommandee |

---

## Types de severite

| Severite | Criteres | Action |
|----------|----------|--------|
| **CRITICAL** | Overflow visible, crash UI | Fix immediat |
| **ERROR** | Fonctionnalite degradee | Fix urgent |
| **WARNING** | UX sub-optimale | Fix planifie |
| **INFO** | Amelioration possible | Backlog |

---

## Stockage local

```
data/
└── bug_reports/
    ├── 2024-02-05.json
    ├── 2024-02-06.json  <- Aujourd'hui
    └── archive/
        └── 2024-01.zip  <- Mois archives
```

### Retention

- 7 derniers jours : JSON complet
- 30 derniers jours : Resume seul
- Au-dela : Archive compresse

---

## Affichage utilisateur (optionnel)

### Banner discret (1x/jour max)

```
┌─────────────────────────────────────────┐
│ ⚠️  2 problemes detectes aujourd'hui     │
│                                          │
│ [Voir details]  [Ignorer pour 24h]       │
└─────────────────────────────────────────┘
```

### Ecran details

```
┌─────────────────────────────────────────┐
│ Rapport du 6 fevrier 2024               │
│                                          │
│ 🔴 1 critique                            │
│ 🟠 2 erreurs                             │
│ 🟡 2 avertissements                      │
│                                          │
│ ─────────────────────────────────────── │
│                                          │
│ 🔴 Texte deborde sur carte addiction    │
│    HomeScreen > AddictionCard           │
│    Vu 3 fois aujourd'hui                │
│                                          │
│ 🟠 Bouton trop petit (settings)         │
│    32x32 pixels (min: 44x44)            │
│    Vu 1 fois                            │
│                                          │
└─────────────────────────────────────────┘
```

---

## Generation du rapport

```dart
// Trigger a 4h du matin (debut InfernalDay)
// ou au premier lancement de la journee

void maybeGenerateDailyReport() {
  final today = InfernalDay.current();
  final lastReport = storage.getLastReportDate();

  if (lastReport != today) {
    final report = DailyBugReport.generate(
      issues: LayoutIssueDetector.instance.issues,
      device: DeviceInfo.current(),
    );

    storage.saveReport(report);
    LayoutIssueDetector.instance.clear();

    // Notifier si bugs critiques
    if (report.summary.critical > 0) {
      showBugBanner(report);
    }
  }
}
```

---

## Checklist rapport

- [ ] Schema JSON defini
- [ ] Agregation par type+widget
- [ ] Deduplication par hash
- [ ] Limite 1 rapport/jour
- [ ] Stockage local securise
- [ ] Retention 7 jours
- [ ] Banner optionnel
- [ ] Export possible (debug)
