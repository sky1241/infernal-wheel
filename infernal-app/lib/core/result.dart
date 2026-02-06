/// Resultat type-safe pour operations qui peuvent echouer
///
/// Usage:
/// ```dart
/// Future<Result<DayEntry>> loadDay(String key) async {
///   try {
///     final entry = await _doLoad(key);
///     return Success(entry);
///   } catch (e) {
///     return Failure(AppError.io('Cannot load day', e));
///   }
/// }
///
/// // Consommation
/// final result = await storage.loadDay(key);
/// switch (result) {
///   case Success(:final data):
///     use(data);
///   case Failure(:final error):
///     showError(error);
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// True si succes
  bool get isSuccess => this is Success<T>;

  /// True si echec
  bool get isFailure => this is Failure<T>;

  /// Obtenir la valeur ou null
  T? get valueOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Obtenir la valeur ou une valeur par defaut
  T valueOr(T defaultValue) => valueOrNull ?? defaultValue;

  /// Obtenir l'erreur ou null
  AppError? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  /// Transformer la valeur si succes
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success(:final data) => Success(transform(data)),
    Failure(:final error) => Failure(error),
  };

  /// Transformer avec une operation qui peut echouer
  Future<Result<R>> flatMap<R>(Future<Result<R>> Function(T data) transform) async {
    return switch (this) {
      Success(:final data) => await transform(data),
      Failure(:final error) => Failure(error),
    };
  }
}

/// Resultat reussi
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

/// Resultat echoue
class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}

/// Erreur applicative typee
class AppError {
  final String code;
  final String message;
  final Object? cause;
  final StackTrace? stack;

  const AppError(this.code, this.message, [this.cause, this.stack]);

  // Factory constructors pour categories courantes
  factory AppError.io(String message, [Object? cause, StackTrace? stack]) {
    return AppError('IO_ERROR', message, cause, stack);
  }

  factory AppError.parse(String message, [Object? cause, StackTrace? stack]) {
    return AppError('PARSE_ERROR', message, cause, stack);
  }

  factory AppError.health(String message, [Object? cause, StackTrace? stack]) {
    return AppError('HEALTH_ERROR', message, cause, stack);
  }

  factory AppError.validation(String message) {
    return AppError('VALIDATION_ERROR', message);
  }

  factory AppError.timeout(String operation) {
    return AppError('TIMEOUT', 'Operation timed out: $operation');
  }

  factory AppError.unknown(Object? cause, [StackTrace? stack]) {
    return AppError('UNKNOWN', cause?.toString() ?? 'Unknown error', cause, stack);
  }

  @override
  String toString() => 'AppError($code: $message)';
}

/// Extension pour convertir les exceptions en Result
extension FutureResultExtension<T> on Future<T> {
  /// Convertir un Future en Result, catchant les exceptions
  Future<Result<T>> toResult() async {
    try {
      return Success(await this);
    } catch (e, stack) {
      return Failure(AppError.unknown(e, stack));
    }
  }

  /// Avec timeout
  Future<Result<T>> toResultWithTimeout(Duration timeout, String tag) async {
    try {
      return Success(await this.timeout(timeout));
    } on TimeoutException {
      return Failure(AppError.timeout(tag));
    } catch (e, stack) {
      return Failure(AppError.unknown(e, stack));
    }
  }
}

/// TimeoutException pour compatibilite
class TimeoutException implements Exception {
  final String? message;
  const TimeoutException([this.message]);

  @override
  String toString() => 'TimeoutException: $message';
}
