# Patterns de Defaillance Courants

## Objectif

Documenter les bugs UI les plus frequents pour **les prevenir** avant qu'ils n'arrivent.

---

## Top 10 des bugs UI

### 1. RenderFlex Overflow (Le plus frequent)

**Symptome** : Bandes jaunes/noires "OVERFLOW"

**Cause** :
```dart
// MAUVAIS
Row(
  children: [
    Text(veryLongText), // Pas de contrainte!
    Icon(Icons.star),
  ],
)
```

**Solution** :
```dart
// BON
Row(
  children: [
    Expanded(
      child: Text(
        veryLongText,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    Icon(Icons.star),
  ],
)
```

---

### 2. Texte tronque sans indication

**Symptome** : Texte coupe brutalement

**Cause** :
```dart
// MAUVAIS
Container(
  width: 100,
  child: Text(longLabel), // Pas d'overflow
)
```

**Solution** :
```dart
// BON
Container(
  constraints: BoxConstraints(minWidth: 100),
  child: Text(
    longLabel,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  ),
)
```

---

### 3. Boutons inaccessibles (touch target)

**Symptome** : Difficile a cliquer sur mobile

**Cause** :
```dart
// MAUVAIS
IconButton(
  iconSize: 16, // Trop petit!
  onPressed: () {},
  icon: Icon(Icons.close),
)
```

**Solution** :
```dart
// BON
IconButton(
  iconSize: 16,
  constraints: BoxConstraints(minWidth: 48, minHeight: 48),
  onPressed: () {},
  icon: Icon(Icons.close),
)
```

---

### 4. Layout casse en RTL

**Symptome** : Elements mal places en arabe/hebreu

**Cause** :
```dart
// MAUVAIS
Padding(padding: EdgeInsets.only(left: 16))
Row(children: [icon, Spacer(), text]) // Ordre fixe
```

**Solution** :
```dart
// BON
Padding(padding: EdgeInsetsDirectional.only(start: 16))
Row(
  textDirection: null, // Respecte la direction
  children: [icon, Spacer(), text],
)
```

---

### 5. Texte illisible avec grand scale

**Symptome** : Texte deforme quand textScaleFactor > 1.5

**Cause** :
```dart
// MAUVAIS
Container(
  height: 50, // Hauteur fixe!
  child: Text(label),
)
```

**Solution** :
```dart
// BON
Container(
  constraints: BoxConstraints(minHeight: 50),
  child: Text(label),
)
```

---

### 6. Chevauchement d'elements

**Symptome** : Textes/icones superposes

**Cause** :
```dart
// MAUVAIS
Stack(
  children: [
    Positioned(top: 0, child: Title()),
    Positioned(top: 20, child: Subtitle()), // Overlap!
  ],
)
```

**Solution** :
```dart
// BON
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [Title(), Subtitle()],
)
```

---

### 7. Scroll bloque

**Symptome** : Contenu coupe sans possibilite de scroll

**Cause** :
```dart
// MAUVAIS
Column(
  children: [
    // Beaucoup de contenu qui depasse l'ecran
  ],
)
```

**Solution** :
```dart
// BON
SingleChildScrollView(
  child: Column(
    children: [
      // Contenu scrollable
    ],
  ),
)
```

---

### 8. Images deformees

**Symptome** : Images etirées ou ecrasées

**Cause** :
```dart
// MAUVAIS
Image.network(url, width: 100, height: 100) // Force ratio
```

**Solution** :
```dart
// BON
Image.network(
  url,
  width: 100,
  height: 100,
  fit: BoxFit.cover, // ou contain
)
```

---

### 9. Clavier cache les inputs

**Symptome** : TextField cache par le clavier

**Cause** :
```dart
// MAUVAIS
Scaffold(
  body: Column(
    children: [
      // Inputs en bas
      TextField(),
    ],
  ),
)
```

**Solution** :
```dart
// BON
Scaffold(
  resizeToAvoidBottomInset: true,
  body: SingleChildScrollView(
    child: Column(
      children: [TextField()],
    ),
  ),
)
```

---

### 10. Safe area ignoree

**Symptome** : Contenu sous le notch/home indicator

**Cause** :
```dart
// MAUVAIS
Scaffold(
  body: MyContent(), // Pas de SafeArea
)
```

**Solution** :
```dart
// BON
Scaffold(
  body: SafeArea(
    child: MyContent(),
  ),
)
```

---

## Matrice de prevention

| Bug | Test manuel | Test auto | Prevention code |
|-----|-------------|-----------|-----------------|
| Overflow | Pseudo-locale | Widget test | `Expanded` + `overflow` |
| Truncation | Texte long | Golden test | `maxLines` + `overflow` |
| Touch target | Tap test | Size check | `minWidth: 48` |
| RTL | Arabe | Directionality | `EdgeInsetsDirectional` |
| Scale | x2 setting | MediaQuery | `minHeight` pas `height` |
| Chevauchement | Visual | Bounds check | `Column` pas `Stack` |
| Scroll | Petit ecran | - | `SingleChildScrollView` |
| Image | Assets varies | - | `BoxFit.cover` |
| Clavier | Focus input | - | `resizeToAvoidBottomInset` |
| Safe area | iPhone X+ | - | `SafeArea` |

---

## Checklist pre-release

- [ ] Teste sur 320dp de large
- [ ] Teste avec textScaleFactor 2.0
- [ ] Teste en pseudo-locale (texte +50%)
- [ ] Teste en arabe (RTL)
- [ ] Teste sur iPhone avec notch
- [ ] Teste rotation portrait/paysage
- [ ] Aucune erreur jaune/noire visible
- [ ] Tous les boutons cliquables facilement
