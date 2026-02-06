# Pseudo-Locale (Test UI)

## Objectif

**Casser l'UI intentionnellement** pour detecter les problemes AVANT la production.

---

## Qu'est-ce qu'une pseudo-locale ?

Une fausse langue qui :
- Allonge tous les textes de 30-50%
- Ajoute des caracteres speciaux (accents, symbols)
- Encadre les textes pour voir les limites
- Simule le pire cas possible

---

## Format

```json
// app_pseudo.arb
{
  "@@locale": "pseudo",

  "home_title": "[ÅûjöûrdHûï ~~ ~~]",
  "home_addictionCard_increment": "[Åjöûtér ~~]",
  "settings_sleepGoal_label": "[Öbjéçtïf sömmëïl ~~~]",

  "home_cigarettes_count": "{count, plural, =0{[Åûçûné çïgàréttë ~~~~]} =1{[1 çïgàréttë ~~~]} other{[{count} çïgàréttës ~~~~]}}",

  "error_saveFailed_message": "[Sàûvëgàrdé ïmpössïblé. Vérïfïéz l'éspàçé dïsqûé. ~~~~~~~~~~~~]"
}
```

### Regles de transformation

| Original | Pseudo |
|----------|--------|
| a | à |
| e | é |
| i | ï |
| o | ö |
| u | û |
| + 30% longueur | `~~~` a la fin |
| Encadrement | `[...]` |

---

## Script de generation

```dart
// tools/generate_pseudo_locale.dart

String toPseudo(String text) {
  // Transformer les voyelles
  var result = text
    .replaceAll('a', 'à')
    .replaceAll('A', 'Å')
    .replaceAll('e', 'é')
    .replaceAll('E', 'É')
    .replaceAll('i', 'ï')
    .replaceAll('I', 'Ï')
    .replaceAll('o', 'ö')
    .replaceAll('O', 'Ö')
    .replaceAll('u', 'û')
    .replaceAll('U', 'Û');

  // Ajouter 30% de longueur
  final padding = '~' * (text.length * 0.3).ceil();

  // Encadrer
  return '[$result $padding]';
}
```

---

## Activation en debug

```dart
// main.dart
void main() {
  // Forcer pseudo-locale en debug
  if (kDebugMode && const bool.fromEnvironment('PSEUDO_LOCALE')) {
    // Utiliser pseudo-locale
  }

  runApp(const MyApp());
}
```

### Commande de lancement
```bash
flutter run --dart-define=PSEUDO_LOCALE=true
```

---

## Quoi verifier avec pseudo-locale

### 1. Overflow
- [ ] Aucun texte coupe
- [ ] Aucun RenderFlex overflow
- [ ] Boutons pas deformes

### 2. Layout
- [ ] Alignements corrects
- [ ] Espacement coherent
- [ ] Pas de chevauchement

### 3. Wrap
- [ ] Texte long wrap correctement
- [ ] Pas de scroll horizontal non voulu

### 4. Boutons
- [ ] Texte visible entierement
- [ ] Touch target toujours 48dp min

---

## Exemple visuel

### Normal (francais)
```
┌─────────────────────────────────┐
│ 🚬 Cigarettes              5    │
│    [+]  [-]                     │
└─────────────────────────────────┘
```

### Pseudo-locale (test)
```
┌─────────────────────────────────┐
│ 🚬 [Çïgàréttés ~~~~]       5    │
│    [+]  [-]                     │
└─────────────────────────────────┘
```

Si le texte deborde ou se chevauche → **BUG A CORRIGER**

---

## Integration CI (futur)

```yaml
# .github/workflows/ui-test.yml
- name: Test Pseudo-Locale
  run: |
    flutter test --dart-define=PSEUDO_LOCALE=true
    flutter drive --dart-define=PSEUDO_LOCALE=true
```

---

## Checklist pseudo-locale

- [ ] Fichier `app_pseudo.arb` genere
- [ ] Toutes les cles transformees
- [ ] Script de generation disponible
- [ ] Commande de lancement documentee
- [ ] Ecrans principaux testes visuellement
- [ ] Aucun overflow detecte
