# Responsive & Scale - Anti-Chevauchement

## Objectif

**ZERO probleme visuel** peu importe :
- Taille d'ecran
- Densite de pixels
- Taille de police systeme
- Langue (texte court/long)
- Orientation

---

## Problemes a prevenir

| Probleme | Cause | Impact utilisateur |
|----------|-------|-------------------|
| Texte tronque | Container trop petit | "Je vois pas tout" |
| Chevauchement | Pas de wrap/overflow | "C'est moche" |
| Texte minuscule | Ignore textScaleFactor | "Je peux pas lire" |
| Boutons coupes | Pas de safe area | "Je peux pas cliquer" |
| Scroll impossible | Height fixe | "Ca bloque" |

---

## Regles anti-chevauchement

### 1. Jamais de hauteur fixe sur du texte

```dart
// MAUVAIS - texte coupe si long
Container(
  height: 50,
  child: Text(longText),
)

// BON - hauteur flexible
Container(
  constraints: BoxConstraints(minHeight: 50),
  child: Text(longText),
)

// MIEUX - laisser Flutter gerer
Padding(
  padding: EdgeInsets.all(16),
  child: Text(longText),
)
```

### 2. Toujours `Flexible` ou `Expanded` dans les Row

```dart
// MAUVAIS - overflow si texte long
Row(
  children: [
    Icon(Icons.star),
    Text(veryLongLabel), // OVERFLOW!
    Text(count),
  ],
)

// BON
Row(
  children: [
    Icon(Icons.star),
    Expanded(
      child: Text(
        veryLongLabel,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Text(count),
  ],
)
```

### 3. Overflow explicite sur TOUS les textes dynamiques

```dart
Text(
  userGeneratedText,
  overflow: TextOverflow.ellipsis, // ou .fade ou .clip
  maxLines: 2,
)
```

### 4. Wrap pour les listes horizontales

```dart
// MAUVAIS - depasse l'ecran
Row(children: chips)

// BON
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: chips,
)
```

---

## Support textScaleFactor

L'utilisateur peut avoir une taille de police x2 dans ses settings systeme.

### Detection

```dart
final scaleFactor = MediaQuery.textScaleFactorOf(context);
// 1.0 = normal, 2.0 = double, etc.
```

### Adaptation

```dart
// Taille minimum garantie
Text(
  label,
  style: TextStyle(
    fontSize: 14, // Base
  ),
  // Flutter applique automatiquement textScaleFactor
)

// Si besoin de limiter (rare)
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaleFactor: MediaQuery.textScaleFactorOf(context).clamp(1.0, 1.5),
  ),
  child: MyWidget(),
)
```

### Test obligatoire

```dart
// Dans les tests
testWidgets('handles large text', (tester) async {
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaleFactor: 2.0),
      child: MyApp(),
    ),
  );
  // Verifier pas d'overflow
});
```

---

## Breakpoints responsive

| Nom | Largeur | Usage |
|-----|---------|-------|
| Compact | < 360dp | Tres petit Android |
| Normal | 360-400dp | Telephones standard |
| Large | 400-600dp | Grands telephones |
| Tablet | > 600dp | Tablettes |

### Implementation

```dart
enum ScreenSize { compact, normal, large, tablet }

ScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 360) return ScreenSize.compact;
  if (width < 400) return ScreenSize.normal;
  if (width < 600) return ScreenSize.large;
  return ScreenSize.tablet;
}

// Usage
final size = getScreenSize(context);
final padding = switch (size) {
  ScreenSize.compact => 8.0,
  ScreenSize.normal => 12.0,
  ScreenSize.large => 16.0,
  ScreenSize.tablet => 24.0,
};
```

---

## Safe Areas

### Toujours respecter

```dart
Scaffold(
  body: SafeArea(
    child: content,
  ),
)

// Ou manuellement
Padding(
  padding: EdgeInsets.only(
    top: MediaQuery.paddingOf(context).top,
    bottom: MediaQuery.paddingOf(context).bottom,
  ),
  child: content,
)
```

### Bottom nav avec home indicator

```dart
BottomNavigationBar(
  // Flutter gere automatiquement si dans Scaffold
)

// Si custom
Container(
  padding: EdgeInsets.only(
    bottom: MediaQuery.paddingOf(context).bottom,
  ),
  child: MyCustomNav(),
)
```

---

## Detection problemes automatique

### Widget de debug (dev only)

```dart
class OverflowDetector extends StatelessWidget {
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return Stack(
      children: [
        child,
        // En debug, Flutter affiche deja les overflow en jaune/noir
      ],
    );
  }
}
```

### Checklist test manuel

1. **Petit ecran** : Emulateur 320x480
2. **Grand ecran** : Emulateur 1080x2400
3. **Texte x2** : Settings > Display > Font size > Largest
4. **Allemand** : Texte +30% plus long
5. **Arabe** : RTL, tout inverse
6. **Rotation** : Portrait <-> Paysage

---

## Pattern "Fit or Scroll"

Si le contenu PEUT depasser l'ecran, TOUJOURS wrapper dans un scrollable.

```dart
// Page avec contenu variable
Scaffold(
  body: SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Contenu qui peut etre long
        ],
      ),
    ),
  ),
)

// Liste d'items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)
```

---

## Checklist finale

- [ ] Aucune hauteur fixe sur du texte
- [ ] `Expanded`/`Flexible` dans toutes les Row avec texte
- [ ] `overflow: TextOverflow.ellipsis` sur textes dynamiques
- [ ] `Wrap` pour listes horizontales variables
- [ ] `SafeArea` sur toutes les pages
- [ ] Teste avec textScaleFactor 2.0
- [ ] Teste sur 320dp de large
- [ ] Teste en allemand (texte long)
- [ ] Teste en arabe (RTL)
- [ ] Tout contenu scrollable si peut depasser
