# Guide de Profiling

## Outils

### Flutter DevTools (recommande)

```bash
# Lancer l'app en mode profile
flutter run --profile

# Ouvrir DevTools
# URL affichee dans la console, ou:
flutter pub global activate devtools
devtools
```

### Metriques disponibles

| Onglet | Usage |
|--------|-------|
| Performance | FPS, frame times, jank |
| CPU Profiler | Hotspots, call stacks |
| Memory | Allocations, leaks, snapshots |
| Network | N/A (app offline) |

---

## Profiling Performance (FPS)

### Etapes

1. Lancer en mode `--profile` (pas debug)
2. Ouvrir DevTools > Performance
3. Cliquer "Record"
4. Effectuer l'action a tester (scroll, tap, etc.)
5. Cliquer "Stop"
6. Analyser le timeline

### Que chercher

| Symptome | Cause probable | Solution |
|----------|----------------|----------|
| Frame > 16ms | Rebuild couteux | `const` widgets, `RepaintBoundary` |
| Jank regulier | GC pause | Reduire allocations |
| Spike isole | Layout force | Eviter `GlobalKey` excessifs |

---

## Profiling Memoire

### Etapes

1. DevTools > Memory
2. Prendre un snapshot (baseline)
3. Effectuer des actions
4. Prendre un autre snapshot
5. Comparer les deux

### Red flags

| Pattern | Probleme |
|---------|----------|
| Memoire monte sans redescendre | Memory leak |
| Beaucoup de meme type d'objet | Pas de dispose() |
| Strings en double | Pas d'interning |

### Verifications communes

```dart
// TOUJOURS dispose les controllers
@override
void dispose() {
  _textController.dispose();
  _scrollController.dispose();
  super.dispose();
}

// TOUJOURS cancel les subscriptions
StreamSubscription? _sub;

@override
void dispose() {
  _sub?.cancel();
  super.dispose();
}
```

---

## Profiling Startup

### Mesurer le cold start

```bash
# iOS
flutter run --profile --trace-startup

# Android
flutter run --profile --trace-startup
```

Resultat dans `build/start_up_info.json`

### Optimisations startup

1. **Lazy init** : ne pas charger tout au demarrage
2. **Async init** : initialiser en parallele
3. **Splash screen natif** : afficher quelque chose immediatement

---

## Profiling sans outils externes

### Logs de timing manuels

```dart
// Dans lib/core/logger.dart
class Perf {
  static final _times = <String, DateTime>{};

  static void start(String tag) {
    _times[tag] = DateTime.now();
  }

  static void end(String tag) {
    final start = _times.remove(tag);
    if (start != null) {
      final ms = DateTime.now().difference(start).inMilliseconds;
      Log.perf('$tag completed in ${ms}ms');
    }
  }
}

// Usage
Perf.start('loadDay');
final day = await storage.loadDay(key);
Perf.end('loadDay'); // Log: [PERF] loadDay completed in 45ms
```

---

## Checklist avant release

- [ ] Aucun frame > 32ms en scroll normal
- [ ] Memoire stable apres 5 min d'usage
- [ ] Cold start < 2s sur device low-end
- [ ] Pas de warning "Skipped X frames" en console
