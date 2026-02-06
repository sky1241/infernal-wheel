# Regles de Survie UI (Multi-Langue)

## Objectif

L'UI ne doit **JAMAIS** casser quelle que soit la langue.

---

## Regle 1 : Jamais de largeur/hauteur fixe sur du texte

```dart
// INTERDIT
Container(
  width: 100,
  child: Text(label), // Texte coupe en allemand
)

// AUTORISE
Container(
  constraints: BoxConstraints(minWidth: 100),
  child: Text(label),
)

// MIEUX
Flexible(
  child: Text(label, overflow: TextOverflow.ellipsis),
)
```

---

## Regle 2 : Toujours `Flexible` ou `Expanded` dans Row

```dart
// INTERDIT - overflow garanti
Row(
  children: [
    Icon(Icons.star),
    Text(veryLongGermanLabel),
    Text(count),
  ],
)

// AUTORISE
Row(
  children: [
    Icon(Icons.star),
    Expanded(
      child: Text(
        veryLongGermanLabel,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
    Text(count),
  ],
)
```

---

## Regle 3 : Overflow explicite sur TOUS les textes dynamiques

```dart
Text(
  userText,
  overflow: TextOverflow.ellipsis, // ou .fade
  maxLines: 2,
  softWrap: true,
)
```

---

## Regle 4 : `Wrap` pour les listes horizontales variables

```dart
// INTERDIT
Row(children: tagChips) // Depasse l'ecran

// AUTORISE
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: tagChips,
)
```

---

## Regle 5 : Utiliser `FittedBox` pour le texte critique

```dart
// Pour les titres qui DOIVENT tenir sur une ligne
FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
    title,
    style: TextStyle(fontSize: 24),
  ),
)
```

---

## Regle 6 : `EdgeInsetsDirectional` partout

```dart
// INTERDIT - casse en RTL
Padding(padding: EdgeInsets.only(left: 16))

// AUTORISE
Padding(padding: EdgeInsetsDirectional.only(start: 16))
```

---

## Regle 7 : Boutons avec `minWidth` pas `width`

```dart
// INTERDIT
SizedBox(
  width: 100,
  child: ElevatedButton(child: Text(label)),
)

// AUTORISE
ConstrainedBox(
  constraints: BoxConstraints(minWidth: 100),
  child: ElevatedButton(child: Text(label)),
)

// OU laisser Flutter gerer
ElevatedButton(child: Text(label))
```

---

## Regle 8 : `LayoutBuilder` pour adaptation contextuelle

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isNarrow = constraints.maxWidth < 300;

    return isNarrow
        ? Column(children: items)  // Vertical si etroit
        : Row(children: items);    // Horizontal si large
  },
)
```

---

## Regle 9 : Tester avec les extremes

| Langue | Caracteristique | Facteur |
|--------|-----------------|---------|
| Allemand | Mots tres longs | +30-50% |
| Russe | Mots longs | +20-30% |
| Chinois | Tres compact | -30-50% |
| Arabe | RTL + compact | Layout inverse |

---

## Regle 10 : SafeArea + Scrollable par defaut

```dart
Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: [
          // Contenu qui peut etre long
        ],
      ),
    ),
  ),
)
```

---

## Anti-patterns a eviter

| Pattern | Probleme | Solution |
|---------|----------|----------|
| `width: 100` sur texte | Coupe le texte | `minWidth` ou `Flexible` |
| `Row` sans `Expanded` | Overflow | Ajouter `Expanded` |
| `EdgeInsets.only(left:)` | Casse RTL | `EdgeInsetsDirectional` |
| Texte sans `overflow` | RenderFlex error | Ajouter `overflow: ellipsis` |
| `height` fixe sur texte | Coupe en textScale 2x | `minHeight` ou enlever |

---

## Widget "Safe" reutilisable

```dart
/// Texte qui ne casse jamais
class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;

  const SafeText(
    this.text, {
    this.style,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      softWrap: true,
    );
  }
}

/// Row qui ne casse jamais
class SafeRow extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;

  const SafeRow({
    required this.leading,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(child: title),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ],
      ],
    );
  }
}
```

---

## Checklist avant merge

- [ ] Aucun `width:` fixe sur du texte
- [ ] Tous les `Row` avec texte ont `Expanded`/`Flexible`
- [ ] Tous les textes dynamiques ont `overflow`
- [ ] `EdgeInsetsDirectional` utilise partout
- [ ] Teste en pseudo-locale
- [ ] Teste avec textScaleFactor 2.0
- [ ] Teste sur 320dp de large
