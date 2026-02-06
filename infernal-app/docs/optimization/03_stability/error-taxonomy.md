# Taxonomie des Erreurs

## Categories

### 1. Erreurs I/O (Storage)

| Code | Nom | Cause | Comportement attendu |
|------|-----|-------|---------------------|
| `IO_READ_FAIL` | Lecture echouee | Fichier corrompu, permissions | Retourner null, creer nouveau |
| `IO_WRITE_FAIL` | Ecriture echouee | Disque plein, permissions | Retry 1x, puis toast erreur |
| `IO_NOT_FOUND` | Fichier absent | Premier lancement, supprime | Creer avec valeurs defaut |
| `IO_PARSE_FAIL` | JSON invalide | Corruption, version incompatible | Log + retourner defaut |

### 2. Erreurs Health (HealthKit/Health Connect)

| Code | Nom | Cause | Comportement attendu |
|------|-----|-------|---------------------|
| `HEALTH_NOT_AVAILABLE` | Service absent | Health Connect non installe | Afficher lien install |
| `HEALTH_DENIED` | Permission refusee | User a refuse | Fallback manuel + message |
| `HEALTH_NO_DATA` | Pas de donnees | Montre non portee | Message + saisie manuelle |
| `HEALTH_TIMEOUT` | Timeout | Service lent | Retry 1x, puis fallback |

### 3. Erreurs UI

| Code | Nom | Cause | Comportement attendu |
|------|-----|-------|---------------------|
| `UI_BUILD_FAIL` | Build echoue | Null non gere, overflow | Error boundary, log |
| `UI_STATE_INVALID` | Etat invalide | Race condition | Reset vers etat connu |
| `UI_DISPOSED` | Widget dispose | setState apres dispose | Ignorer silencieusement |

### 4. Erreurs Donnees

| Code | Nom | Cause | Comportement attendu |
|------|-----|-------|---------------------|
| `DATA_INVALID` | Donnee invalide | Valeur hors range | Clamp ou ignorer |
| `DATA_MISSING` | Donnee manquante | Champ requis absent | Valeur par defaut |
| `DATA_CONFLICT` | Conflit | Deux sources contradictoires | Priorite a la plus recente |

---

## Gestion par categorie

### Pattern general

```dart
sealed class AppError {
  final String code;
  final String message;
  final Object? cause;

  const AppError(this.code, this.message, [this.cause]);
}

class IOError extends AppError {
  const IOError(super.code, super.message, [super.cause]);
}

class HealthError extends AppError {
  const HealthError(super.code, super.message, [super.cause]);
}
```

### Resultat type-safe

```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

// Usage
Future<Result<DayEntry>> loadDay(String key) async {
  try {
    final entry = await _doLoad(key);
    return Success(entry);
  } catch (e) {
    return Failure(IOError('IO_READ_FAIL', 'Cannot load day', e));
  }
}

// Consommation
final result = await storage.loadDay(key);
switch (result) {
  case Success(:final data):
    setState(() => _day = data);
  case Failure(:final error):
    showToast(error.message);
}
```

---

## UI pour les erreurs

### Toast simple

```dart
void showErrorToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.danger,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}
```

### Etat vide avec action

```dart
Widget buildErrorState(String message, VoidCallback onRetry) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 48, color: AppColors.danger),
        const SizedBox(height: Spacing.md),
        Text(message, style: TextStyle(color: AppColors.muted)),
        const SizedBox(height: Spacing.md),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Reessayer'),
        ),
      ],
    ),
  );
}
```

### Banner persistant (erreur critique)

```dart
MaterialBanner buildCriticalError(String message) {
  return MaterialBanner(
    content: Text(message),
    backgroundColor: AppColors.danger.withOpacity(0.1),
    leading: Icon(Icons.warning, color: AppColors.danger),
    actions: [
      TextButton(
        onPressed: () => /* restart app */,
        child: const Text('Redemarrer'),
      ),
    ],
  );
}
```

---

## Matrice erreur -> action

| Erreur | Toast | Retry | Fallback | Log level |
|--------|-------|-------|----------|-----------|
| `IO_READ_FAIL` | Non | Non | Oui (nouveau) | ERROR |
| `IO_WRITE_FAIL` | Oui | 1x auto | Non | ERROR |
| `HEALTH_DENIED` | Oui | Non | Oui (manuel) | WARN |
| `HEALTH_NO_DATA` | Non | Non | Oui (manuel) | INFO |
| `UI_BUILD_FAIL` | Non | Non | Error boundary | FATAL |
| `DATA_INVALID` | Non | Non | Oui (clamp) | WARN |
