import 'package:flutter/foundation.dart';

/// Niveaux de log
enum LogLevel {
  trace,
  debug,
  info,
  warn,
  error,
  fatal,
  perf;

  String get prefix => '[${name.toUpperCase()}]';
}

/// Entree de log pour buffer (prod)
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final Map<String, dynamic>? data;
  final Object? error;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.data,
    this.error,
  });

  String format() {
    final dataStr = data != null
        ? ' | ${data!.entries.map((e) => '${e.key}=${e.value}').join(' ')}'
        : '';
    return '${timestamp.toIso8601String()} ${level.prefix} [$tag] $message$dataStr';
  }
}

/// Systeme de logging centralise
///
/// Usage:
/// ```dart
/// Log.info('STORAGE', 'Day saved', data: {'dayKey': key});
/// Log.error('STORAGE', 'Failed to save', error: e, stack: stack);
/// ```
class Log {
  static LogLevel minLevel = kDebugMode ? LogLevel.trace : LogLevel.info;
  static final List<LogEntry> _buffer = [];
  static const int _maxBufferSize = 500;

  static void _log(
    LogLevel level,
    String tag,
    String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stack,
  }) {
    if (level.index < minLevel.index) return;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      data: data,
      error: error,
    );

    // Buffer pour export futur
    _buffer.add(entry);
    if (_buffer.length > _maxBufferSize) {
      _buffer.removeAt(0);
    }

    // En dev: print
    if (kDebugMode) {
      final dataStr = data != null
          ? ' | ${data.entries.map((e) => '${e.key}=${e.value}').join(' ')}'
          : '';
      debugPrint('${level.prefix} [$tag] $message$dataStr');
      if (error != null) debugPrint('  Error: $error');
      if (stack != null) debugPrint('  Stack:\n$stack');
    }
  }

  /// Log niveau TRACE (dev only, tres verbeux)
  static void trace(String tag, String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.trace, tag, message, data: data);
  }

  /// Log niveau DEBUG (dev only)
  static void debug(String tag, String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.debug, tag, message, data: data);
  }

  /// Log niveau INFO (evenements normaux)
  static void info(String tag, String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.info, tag, message, data: data);
  }

  /// Log niveau WARN (anomalie non bloquante)
  static void warn(String tag, String message, {
    Object? error,
    Map<String, dynamic>? data,
  }) {
    _log(LogLevel.warn, tag, message, error: error, data: data);
  }

  /// Log niveau ERROR (erreur recuperable)
  static void error(String tag, String message, {
    Object? error,
    StackTrace? stack,
    Map<String, dynamic>? data,
  }) {
    _log(LogLevel.error, tag, message, error: error, stack: stack, data: data);
  }

  /// Log niveau FATAL (crash imminent)
  static void fatal(String tag, String message, {
    Object? error,
    StackTrace? stack,
  }) {
    _log(LogLevel.fatal, tag, message, error: error, stack: stack);
  }

  /// Log PERF (metriques performance)
  static void perf(String tag, String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.perf, tag, message, data: data);
  }

  /// Export des logs (pour debug sur device reel)
  static String export() {
    return _buffer.map((e) => e.format()).join('\n');
  }

  /// Vider le buffer
  static void clear() {
    _buffer.clear();
  }

  /// Nombre de logs en buffer
  static int get bufferSize => _buffer.length;
}

/// Helper pour mesurer les performances
class Perf {
  static final Map<String, DateTime> _starts = {};

  /// Demarrer un timer
  static void start(String tag) {
    _starts[tag] = DateTime.now();
  }

  /// Terminer et logger le temps
  static void end(String tag, {String? customMessage}) {
    final start = _starts.remove(tag);
    if (start == null) {
      Log.warn('PERF', 'No start found for tag: $tag');
      return;
    }

    final ms = DateTime.now().difference(start).inMilliseconds;
    Log.perf('PERF', customMessage ?? tag, data: {'duration': '${ms}ms'});
  }

  /// Mesurer une operation async
  static Future<T> measure<T>(String tag, Future<T> Function() operation) async {
    start(tag);
    try {
      return await operation();
    } finally {
      end(tag);
    }
  }
}
