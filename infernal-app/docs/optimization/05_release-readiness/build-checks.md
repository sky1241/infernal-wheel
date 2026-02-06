# Verifications Build

## Pre-commit (local)

### 1. Format du code

```bash
# Formatter tout le code
dart format lib/

# Verifier sans modifier
dart format --output=none --set-exit-if-changed lib/
```

### 2. Analyse statique

```bash
# Lancer l'analyseur
flutter analyze

# Doit retourner "No issues found!"
```

### 3. Tests

```bash
# Lancer tous les tests
flutter test

# Avec couverture
flutter test --coverage
```

---

## Pre-push

### 4. Build debug

```bash
# iOS (Mac requis)
flutter build ios --debug --no-codesign

# Android
flutter build apk --debug
```

### 5. Build release (verification)

```bash
# Android
flutter build apk --release

# iOS (necessite signing pour vrai build)
flutter build ios --release --no-codesign
```

---

## Checklist manuelle

### Code quality
- [ ] Pas de `print()` - utiliser `Log.*`
- [ ] Pas de `// TODO` non resolu
- [ ] Pas de code commente inutile
- [ ] Imports organises (dart:, package:, relative)

### Dependances
- [ ] `flutter pub outdated` - pas de majeure en retard
- [ ] `flutter pub deps` - pas de conflit

### Assets
- [ ] Tous les assets listes dans `pubspec.yaml`
- [ ] Pas d'asset inutilise

### Permissions
- [ ] iOS `Info.plist` : permissions necessaires declarees
- [ ] Android `AndroidManifest.xml` : permissions minimales

---

## CI/CD (futur)

### GitHub Actions (exemple)

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter analyze
      - run: dart format --output=none --set-exit-if-changed lib/

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test

  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
```

---

## Erreurs courantes

| Erreur | Cause | Solution |
|--------|-------|----------|
| `Unresolved import` | Package manquant | `flutter pub get` |
| `Target of URI doesn't exist` | Fichier deplace/supprime | Verifier les imports |
| `Invalid constant value` | `const` sur non-constant | Retirer `const` ou corriger |
| `Missing concrete implementation` | Interface non implementee | Implementer les methodes |
| `Undefined name` | Typo ou import manquant | Verifier orthographe + imports |

---

## Script de verification complete

```bash
#!/bin/bash
# scripts/check.sh

set -e

echo "=== Format ==="
dart format --output=none --set-exit-if-changed lib/

echo "=== Analyze ==="
flutter analyze

echo "=== Tests ==="
flutter test

echo "=== Build Android ==="
flutter build apk --release

echo "=== All checks passed! ==="
```

Usage :
```bash
chmod +x scripts/check.sh
./scripts/check.sh
```
