# Regles de Deduplication

## Objectif

**Eviter le spam** : 100 occurrences du meme bug = 1 entree dans le rapport.

---

## Algorithme de deduplication

### 1. Calcul du hash unique

```dart
String computeIssueHash(LayoutIssue issue) {
  // Hash base sur : type + widget + message (simplifie)
  final key = '${issue.type}|${issue.widgetPath}|${_normalizeMessage(issue.message)}';
  return key.hashCode.toRadixString(16);
}

String _normalizeMessage(String message) {
  // Enlever les valeurs variables pour grouper
  return message
      .replaceAll(RegExp(r'\d+'), 'N')  // "280px" -> "Npx"
      .replaceAll(RegExp(r'"[^"]*"'), '"..."')  // Texte variable
      .toLowerCase();
}
```

### 2. Agregation

```dart
Map<String, AggregatedIssue> aggregate(List<LayoutIssue> issues) {
  final Map<String, AggregatedIssue> result = {};

  for (final issue in issues) {
    final hash = computeIssueHash(issue);

    if (result.containsKey(hash)) {
      result[hash]!.addOccurrence(issue);
    } else {
      result[hash] = AggregatedIssue.from(issue);
    }
  }

  return result;
}
```

---

## Regles de groupement

### Par type

| Type | Groupement | Exemple |
|------|------------|---------|
| `overflow` | widget + direction | "Row overflow left" |
| `truncation` | widget seul | "Text truncated in Card" |
| `small_touch` | widget seul | "IconButton too small" |
| `overlap` | widget pair | "A overlaps B" |

### Par widget path

```
Niveau de precision : 3 derniers elements

HomeScreen > AddictionCard > Row > Text > RichText
                           ^^^^^^^^^^^^^^^^^^^^^^^
                           Garde uniquement ceci
```

### Par message normalise

```
Original:  "Text overflow by 45.5px in container width 200"
Normalise: "text overflow by Npx in container width N"

Original:  "Touch target 32x32 too small"
Normalise: "touch target NxN too small"
```

---

## Priorite dans le groupement

Si plusieurs bugs similaires avec severites differentes :

```dart
// Garder la severite la plus haute
final severityOrder = ['CRITICAL', 'ERROR', 'WARNING', 'INFO'];

String highestSeverity(List<String> severities) {
  for (final level in severityOrder) {
    if (severities.contains(level)) return level;
  }
  return 'INFO';
}
```

---

## Exemples concrets

### Exemple 1 : Overflow repete

**Entrees brutes** (10 occurrences) :
```
[CRITICAL] overflow: RenderFlex overflowed by 45px to the right
[CRITICAL] overflow: RenderFlex overflowed by 52px to the right
[CRITICAL] overflow: RenderFlex overflowed by 38px to the right
... (7 autres)
```

**Apres deduplication** (1 entree) :
```json
{
  "type": "overflow",
  "message": "RenderFlex overflowed to the right",
  "occurrences": 10,
  "severity": "CRITICAL",
  "context": {
    "minOverflow": 38,
    "maxOverflow": 52,
    "avgOverflow": 45
  }
}
```

### Exemple 2 : Plusieurs widgets similaires

**Entrees brutes** :
```
[WARNING] small_touch: Button 32x32 in SettingsScreen
[WARNING] small_touch: Button 36x36 in SettingsScreen
[WARNING] small_touch: Button 28x28 in HomeScreen
```

**Apres deduplication** (2 entrees - par ecran) :
```json
[
  {
    "type": "small_touch",
    "message": "Buttons too small in SettingsScreen",
    "occurrences": 2
  },
  {
    "type": "small_touch",
    "message": "Button too small in HomeScreen",
    "occurrences": 1
  }
]
```

---

## Seuils de groupement

| Parametre | Valeur | Raison |
|-----------|--------|--------|
| Max entrees/rapport | 20 | Lisibilite |
| Min occurrences affichees | 1 | Tout montrer |
| Groupement par ecran | Oui | Localisation |
| Groupement cross-session | Non | Rapport quotidien |

---

## Gestion du timing

### Fenetre de deduplication

```
4:00 AM Jour 1  ────────────────────►  4:00 AM Jour 2
        │                                     │
        │  Bugs accumules                     │  Nouveau rapport
        │  Dedupliques en temps reel          │  Reset compteur
        ▼                                     ▼
```

### Persistance inter-session

```dart
// Si app fermee et rouverte le meme jour
// Les bugs precedents sont recuperes

void restoreIssues() {
  final today = InfernalDay.current();
  final saved = storage.loadTodayIssues(today);

  if (saved != null) {
    LayoutIssueDetector.instance.restore(saved);
  }
}
```

---

## Code implementation

```dart
class AggregatedIssue {
  final String hash;
  final String type;
  final String severity;
  final String message;
  final String widgetPath;
  final List<DateTime> timestamps;
  final List<Map<String, dynamic>> contexts;

  int get occurrences => timestamps.length;
  DateTime get firstSeen => timestamps.reduce((a, b) => a.isBefore(b) ? a : b);
  DateTime get lastSeen => timestamps.reduce((a, b) => a.isAfter(b) ? a : b);

  AggregatedIssue({
    required this.hash,
    required this.type,
    required this.severity,
    required this.message,
    required this.widgetPath,
    required this.timestamps,
    required this.contexts,
  });

  factory AggregatedIssue.from(LayoutIssue issue) {
    return AggregatedIssue(
      hash: computeIssueHash(issue),
      type: issue.type,
      severity: issue.severity,
      message: _normalizeMessage(issue.message),
      widgetPath: issue.widgetPath ?? 'unknown',
      timestamps: [issue.timestamp],
      contexts: [if (issue.bounds != null) {'bounds': issue.bounds}],
    );
  }

  void addOccurrence(LayoutIssue issue) {
    timestamps.add(issue.timestamp);
    if (issue.bounds != null) {
      contexts.add({'bounds': issue.bounds});
    }
    // Upgrade severity si plus grave
    if (_severityRank(issue.severity) < _severityRank(severity)) {
      // Note: severity est final, donc on cree une nouvelle instance en pratique
    }
  }

  static int _severityRank(String s) {
    return ['CRITICAL', 'ERROR', 'WARNING', 'INFO'].indexOf(s);
  }
}
```

---

## Checklist deduplication

- [ ] Hash calcule sur type + widget + message normalise
- [ ] Nombres remplaces par 'N'
- [ ] Texte variable supprime
- [ ] Agregation par hash
- [ ] Severite max conservee
- [ ] Timestamps accumules
- [ ] Contextes preserves (min/max/avg)
- [ ] Max 20 entrees par rapport
