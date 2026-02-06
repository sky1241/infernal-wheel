# Format de Logging

## Systeme de log

### Niveaux

| Niveau | Usage | Couleur console |
|--------|-------|-----------------|
| `TRACE` | Debug tres verbeux (dev only) | Gris |
| `DEBUG` | Info dev, pas en prod | Bleu |
| `INFO` | Evenements normaux | Vert |
| `WARN` | Anomalie non bloquante | Jaune |
| `ERROR` | Erreur recuperable | Rouge |
| `FATAL` | Crash imminent | Rouge gras |
| `PERF` | Metriques performance | Cyan |

### Format

```
[LEVEL] [TAG] Message | key=value key2=value2
```

Exemple :
```
[INFO] [STORAGE] Day loaded | dayKey=2024-02-06 duration=45ms
[ERROR] [STORAGE] Failed to save | dayKey=2024-02-06 error=disk_full
[PERF] [STARTUP] Cold start complete | time=1850ms
```

---

## Implementation

### Classe Log (`lib/core/logger.dart`)

```dart
enum LogLevel { trace, debug, info, warn, error, fatal, perf }

class Log {
  static LogLevel minLevel = kDebugMode ? LogLevel.trace : LogLevel.info;

  static void _log(LogLevel level, String tag, String message, {
    Object? error,
    StackTrace? stack,
    Map<String, dynamic>? data,
  }) {
    if (level.index < minLevel.index) return;

    final prefix = '[${level.name.toUpperCase()}] [$tag]';
    final suffix = data != null
        ? ' | ${data.entries.map((e) => '${e.key}=${e.value}').join(' ')}'
        : '';

    final line = '$prefix $message$suffix';

    if (kDebugMode) {
      // En dev: print avec couleur
      debugPrint(line);
      if (error != null) debugPrint('  Error: $error');
      if (stack != null) debugPrint('  Stack: $stack');
    } else {
      // En prod: stocker pour export
      _buffer.add(LogEntry(DateTime.now(), level, line));
    }
  }

  // Raccourcis
  static void trace(String tag, String msg, {Map<String, dynamic>? data}) =>
      _log(LogLevel.trace, tag, msg, data: data);

  static void debug(String tag, String msg, {Map<String, dynamic>? data}) =>
      _log(LogLevel.debug, tag, msg, data: data);

  static void info(String tag, String msg, {Map<String, dynamic>? data}) =>
      _log(LogLevel.info, tag, msg, data: data);

  static void warn(String tag, String msg, {Object? error, Map<String, dynamic>? data}) =>
      _log(LogLevel.warn, tag, msg, error: error, data: data);

  static void error(String tag, String msg, {Object? error, StackTrace? stack, Map<String, dynamic>? data}) =>
      _log(LogLevel.error, tag, msg, error: error, stack: stack, data: data);

  static void fatal(String tag, String msg, {Object? error, StackTrace? stack}) =>
      _log(LogLevel.fatal, tag, msg, error: error, stack: stack);

  static void perf(String tag, String msg, {Map<String, dynamic>? data}) =>
      _log(LogLevel.perf, tag, msg, data: data);
}
```

---

## Tags standards

| Tag | Fichiers |
|-----|----------|
| `STORAGE` | storage_service.dart |
| `HEALTH` | health_service.dart |
| `UI` | views/*.dart |
| `MODEL` | models/*.dart |
| `NAV` | Navigation, routing |
| `STARTUP` | main.dart, init |
| `LIFECYCLE` | AppLifecycle events |

---

## Quand logger quoi

### TRACE
```dart
Log.trace('STORAGE', 'Reading file', data: {'path': path});
```

### DEBUG
```dart
Log.debug('UI', 'Building dashboard', data: {'addictions': count});
```

### INFO
```dart
Log.info('STORAGE', 'Day saved', data: {'dayKey': key});
Log.info('HEALTH', 'Sleep data fetched', data: {'source': 'healthKit'});
```

### WARN
```dart
Log.warn('STORAGE', 'File not found, creating new', data: {'path': path});
Log.warn('HEALTH', 'Permission not granted');
```

### ERROR
```dart
Log.error('STORAGE', 'Failed to parse JSON',
    error: e,
    stack: stack,
    data: {'dayKey': key});
```

### FATAL
```dart
Log.fatal('STARTUP', 'Cannot initialize storage', error: e, stack: stack);
```

### PERF
```dart
Log.perf('STARTUP', 'Init complete', data: {'duration': '${ms}ms'});
Log.perf('STORAGE', 'Load day', data: {'dayKey': key, 'duration': '${ms}ms'});
```

---

## Export des logs (futur)

```dart
// Pour debug sur device reel
static Future<String> exportLogs() async {
  return _buffer.map((e) => '${e.time.toIso8601String()} ${e.line}').join('\n');
}

// Peut etre partage via share_plus
final logs = await Log.exportLogs();
await Share.share(logs, subject: 'InfernalWheel Debug Logs');
```
