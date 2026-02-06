# Securite Anti-Crash

## Principes

1. **Fail gracefully** : jamais de crash visible utilisateur
2. **Fallback safe** : toujours une valeur par defaut
3. **Recover** : reprendre apres une erreur sans perdre de donnees

---

## Guards obligatoires

### 1. Parsing JSON

```dart
// MAUVAIS - crash si json null ou mal forme
factory Model.fromJson(Map<String, dynamic> json) {
  return Model(
    name: json['name'],  // Crash si null
    count: json['count'], // Crash si mauvais type
  );
}

// BON - defensif
factory Model.fromJson(Map<String, dynamic> json) {
  return Model(
    name: json['name'] as String? ?? 'unknown',
    count: (json['count'] as num?)?.toInt() ?? 0,
  );
}
```

### 2. Acces fichiers

```dart
// MAUVAIS
Future<DayEntry> loadDay(String key) async {
  final file = File(path);
  final content = await file.readAsString(); // Crash si n'existe pas
  return DayEntry.fromJson(jsonDecode(content)); // Crash si malformed
}

// BON
Future<DayEntry?> loadDay(String key) async {
  try {
    final file = File(_dayPath(key));
    if (!await file.exists()) return null;

    final content = await file.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return DayEntry.fromJson(json);
  } catch (e, stack) {
    Log.error('Failed to load day $key', error: e, stack: stack);
    return null;
  }
}
```

### 3. Ecriture fichiers

```dart
// BON - avec backup
Future<void> saveDay(DayEntry entry) async {
  final file = File(_dayPath(entry.dayKey));
  final backup = File('${file.path}.bak');

  try {
    // Backup de l'existant
    if (await file.exists()) {
      await file.copy(backup.path);
    }

    // Ecriture atomique
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(jsonEncode(entry.toJson()));
    await temp.rename(file.path);

    // Supprimer backup si succes
    if (await backup.exists()) {
      await backup.delete();
    }
  } catch (e, stack) {
    Log.error('Failed to save day', error: e, stack: stack);

    // Restaurer backup si echec
    if (await backup.exists()) {
      await backup.rename(file.path);
    }

    rethrow; // Propager pour UI
  }
}
```

### 4. Async dans StatefulWidget

```dart
// MAUVAIS - peut appeler setState apres dispose
Future<void> loadData() async {
  final data = await fetchData();
  setState(() => _data = data); // Crash si widget dispose
}

// BON - verifier mounted
Future<void> loadData() async {
  final data = await fetchData();
  if (!mounted) return;
  setState(() => _data = data);
}
```

### 5. Null safety strict

```dart
// MAUVAIS
String getText() {
  return _controller.text; // _controller peut etre null
}

// BON - late ou nullable
late final TextEditingController _controller;

// ou
TextEditingController? _controller;
String getText() => _controller?.text ?? '';
```

---

## Timeouts obligatoires

| Operation | Timeout | Action si timeout |
|-----------|---------|-------------------|
| Lecture fichier | 5s | Retourner null |
| Ecriture fichier | 10s | Log + retry 1x |
| Health fetch | 30s | Fallback manuel |

```dart
Future<T?> withTimeout<T>(
  Future<T> operation,
  Duration timeout,
  String tag,
) async {
  try {
    return await operation.timeout(timeout);
  } on TimeoutException {
    Log.warn('$tag timed out after ${timeout.inSeconds}s');
    return null;
  }
}
```

---

## Error Boundary global

```dart
// Dans main.dart
void main() {
  // Catch toutes les erreurs Flutter
  FlutterError.onError = (details) {
    Log.fatal('Flutter error', error: details.exception, stack: details.stack);
    // En prod: envoyer a crashlytics (si configure)
  };

  // Catch erreurs async non gerees
  runZonedGuarded(
    () => runApp(const MyApp()),
    (error, stack) {
      Log.fatal('Unhandled error', error: error, stack: stack);
    },
  );
}
```

---

## Checklist par fichier

### Models (`lib/models/*.dart`)
- [ ] Tous les `fromJson` ont des valeurs par defaut
- [ ] Pas de `!` sur des valeurs potentiellement null
- [ ] Enums ont un fallback pour valeurs inconnues

### Services (`lib/services/*.dart`)
- [ ] Toutes les operations I/O dans try/catch
- [ ] Timeouts sur operations longues
- [ ] Logs structuree sur erreurs

### Views (`lib/views/*.dart`)
- [ ] `if (!mounted) return;` apres tout await dans StatefulWidget
- [ ] Pas d'exception dans build()
- [ ] Etats d'erreur prevus dans l'UI
