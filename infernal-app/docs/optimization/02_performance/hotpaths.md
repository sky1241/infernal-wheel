# Chemins Critiques (Hot Paths)

## Definition

Un "hot path" est un chemin de code execute frequemment ou dans un contexte sensible a la performance (build, scroll, tap).

---

## Hot Paths identifies

### 1. Build du Dashboard principal

**Fichier** : `lib/views/home_screen.dart`

**Frequence** : A chaque setState (increment/decrement)

**Risques** :
- Rebuild de toute la liste d'addictions
- Recalcul des trends

**Optimisations appliquees** :
```dart
// Utiliser const pour les widgets statiques
const SizedBox(height: Spacing.md),

// Extraire les widgets en classes separees
class AddictionCard extends StatelessWidget {
  const AddictionCard({...}); // const constructor
}
```

**Optimisations futures** :
- [ ] Utiliser `ValueNotifier` + `ValueListenableBuilder` pour updates granulaires
- [ ] `RepaintBoundary` autour des cartes

---

### 2. Sauvegarde auto du journal

**Fichier** : `lib/services/storage_service.dart`

**Frequence** : A chaque frappe clavier (debounce necessaire)

**Risques** :
- I/O excessif
- Lag clavier

**Optimisations appliquees** :
```dart
// Debounce de 500ms avant sauvegarde
Timer? _saveTimer;

void scheduleSave(DayEntry entry) {
  _saveTimer?.cancel();
  _saveTimer = Timer(const Duration(milliseconds: 500), () {
    saveDay(entry);
  });
}
```

---

### 3. Calcul des trends

**Fichier** : `lib/models/day_entry.dart`

**Frequence** : A chaque affichage de carte

**Risques** :
- Appel a `countFor()` multiple fois
- Comparaison avec hier (chargement fichier)

**Optimisations appliquees** :
```dart
// Hier est charge une seule fois au demarrage
// Pas de rechargement a chaque rebuild
```

**Optimisations futures** :
- [ ] Cache les trends calcules jusqu'au prochain increment

---

### 4. Parsing JSON au chargement

**Fichier** : `lib/models/*.dart` (fromJson)

**Frequence** : Au demarrage, changement de jour

**Risques** :
- JSON malformed -> crash
- Champs manquants -> null pointer

**Optimisations appliquees** :
```dart
// Valeurs par defaut partout
count: json['count'] as int? ?? 0,

// Try-catch au niveau service
try {
  return DayEntry.fromJson(json);
} catch (e) {
  Log.error('Parse failed', error: e);
  return DayEntry(dayKey: key); // Fallback vide
}
```

---

### 5. Scroll de liste longue (futur calendrier)

**Fichier** : TBD

**Frequence** : 60 fois/seconde pendant scroll

**Risques** :
- Jank si items complexes
- Memory si pas de recycling

**Optimisations prevues** :
```dart
// Utiliser ListView.builder (pas ListView avec children)
ListView.builder(
  itemCount: days.length,
  itemBuilder: (context, index) => DayTile(day: days[index]),
)

// Ou SliverList pour CustomScrollView
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) => DayTile(day: days[index]),
    childCount: days.length,
  ),
)
```

---

## Regles generales

1. **Jamais d'I/O dans build()** : toujours async + setState apres
2. **Const partout** : `const Widget()`, `const EdgeInsets.all()`
3. **Extraire les widgets** : un widget = une responsabilite
4. **Debounce les saves** : pas de sauvegarde a chaque keystroke
5. **Cache les calculs** : ne pas recalculer ce qui n'a pas change
