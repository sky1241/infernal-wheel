import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/logger.dart';
import '../core/result.dart';
import '../models/day_entry.dart';
import '../models/user_settings.dart';
import '../utils/infernal_day.dart';

/// Service de stockage local (100% offline, rien envoye)
///
/// Toutes les donnees restent sur l'appareil.
/// Pas de cloud, pas de sync, pas de tracking.
class StorageService {
  static const String _daysDir = 'days';
  static const String _settingsFile = 'settings.json';
  static const String _backupSuffix = '.bak';

  /// Timeouts pour les operations I/O
  static const Duration _readTimeout = Duration(seconds: 5);
  static const Duration _writeTimeout = Duration(seconds: 10);

  String? _basePath;
  bool _initialized = false;

  /// True si le service est initialise
  bool get isInitialized => _initialized;

  /// Initialiser le stockage
  Future<Result<void>> init() async {
    if (_initialized) return const Success(null);

    Perf.start('storage_init');
    try {
      final dir = await getApplicationDocumentsDirectory()
          .timeout(_readTimeout, onTimeout: () {
        throw TimeoutException('getApplicationDocumentsDirectory');
      });
      _basePath = dir.path;

      // Creer le dossier days si necessaire
      final daysPath = Directory('$_basePath/$_daysDir');
      if (!await daysPath.exists()) {
        await daysPath.create(recursive: true);
        Log.info('STORAGE', 'Created days directory');
      }

      _initialized = true;
      Perf.end('storage_init');
      Log.info('STORAGE', 'Initialized', data: {'path': _basePath});
      return const Success(null);
    } catch (e, stack) {
      Log.fatal('STORAGE', 'Init failed', error: e, stack: stack);
      return Failure(AppError.io('Storage init failed', e, stack));
    }
  }

  /// Verifier que le service est init (throw si non)
  void _ensureInitialized() {
    if (!_initialized || _basePath == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
  }

  // =====================
  // SETTINGS
  // =====================

  /// Charger les settings (avec fallback vers defaults)
  Future<UserSettings> loadSettings() async {
    _ensureInitialized();

    try {
      final file = File('$_basePath/$_settingsFile');
      if (!await file.exists()) {
        Log.debug('STORAGE', 'No settings file, using defaults');
        return UserSettings.defaults();
      }

      final content = await file.readAsString().timeout(_readTimeout);
      final json = jsonDecode(content) as Map<String, dynamic>;
      final settings = UserSettings.fromJson(json);

      Log.debug('STORAGE', 'Settings loaded');
      return settings;
    } catch (e, stack) {
      Log.error('STORAGE', 'Load settings failed, using defaults',
          error: e, stack: stack);
      return UserSettings.defaults();
    }
  }

  /// Sauvegarder les settings
  Future<Result<void>> saveSettings(UserSettings settings) async {
    _ensureInitialized();

    try {
      final file = File('$_basePath/$_settingsFile');
      final content = jsonEncode(settings.toJson());

      await _writeAtomically(file, content);

      Log.info('STORAGE', 'Settings saved');
      return const Success(null);
    } catch (e, stack) {
      Log.error('STORAGE', 'Save settings failed', error: e, stack: stack);
      return Failure(AppError.io('Save settings failed', e, stack));
    }
  }

  // =====================
  // DAY ENTRIES
  // =====================

  String _dayPath(String dayKey) => '$_basePath/$_daysDir/$dayKey.json';

  /// Charger un jour (null si inexistant)
  Future<DayEntry?> loadDay(String dayKey) async {
    _ensureInitialized();
    Perf.start('loadDay_$dayKey');

    try {
      final file = File(_dayPath(dayKey));
      if (!await file.exists()) {
        Perf.end('loadDay_$dayKey');
        return null;
      }

      final content = await file.readAsString().timeout(_readTimeout);
      final json = jsonDecode(content) as Map<String, dynamic>;
      final entry = DayEntry.fromJson(json);

      Perf.end('loadDay_$dayKey');
      Log.debug('STORAGE', 'Day loaded', data: {'dayKey': dayKey});
      return entry;
    } catch (e, stack) {
      Log.error('STORAGE', 'Load day failed',
          error: e, stack: stack, data: {'dayKey': dayKey});
      Perf.end('loadDay_$dayKey');
      return null;
    }
  }

  /// Sauvegarder un jour (avec backup atomique)
  Future<Result<void>> saveDay(DayEntry entry) async {
    _ensureInitialized();
    Perf.start('saveDay_${entry.dayKey}');

    try {
      final file = File(_dayPath(entry.dayKey));

      // Mettre a jour le timestamp
      entry.updatedAt = DateTime.now();

      final content = jsonEncode(entry.toJson());
      await _writeAtomically(file, content);

      Perf.end('saveDay_${entry.dayKey}');
      Log.info('STORAGE', 'Day saved', data: {'dayKey': entry.dayKey});
      return const Success(null);
    } catch (e, stack) {
      Log.error('STORAGE', 'Save day failed',
          error: e, stack: stack, data: {'dayKey': entry.dayKey});
      Perf.end('saveDay_${entry.dayKey}');
      return Failure(AppError.io('Save day failed', e, stack));
    }
  }

  /// Ecriture atomique avec backup
  Future<void> _writeAtomically(File file, String content) async {
    final backup = File('${file.path}$_backupSuffix');
    final temp = File('${file.path}.tmp');

    // 1. Backup existant
    if (await file.exists()) {
      try {
        await file.copy(backup.path);
      } catch (e) {
        Log.warn('STORAGE', 'Backup copy failed', error: e);
      }
    }

    // 2. Ecrire dans temp
    await temp.writeAsString(content).timeout(_writeTimeout);

    // 3. Renommer temp -> fichier final
    await temp.rename(file.path);

    // 4. Supprimer backup si succes
    if (await backup.exists()) {
      try {
        await backup.delete();
      } catch (e) {
        // Ignorer, pas critique
      }
    }
  }

  /// Charger ou creer le jour actuel
  Future<DayEntry> loadOrCreateToday() async {
    final todayKey = InfernalDay.current().key;
    final existing = await loadDay(todayKey);
    if (existing != null) return existing;

    Log.info('STORAGE', 'Creating new day', data: {'dayKey': todayKey});
    return DayEntry(dayKey: todayKey);
  }

  /// Charger le jour precedent
  Future<DayEntry?> loadYesterday() async {
    final yestKey = InfernalDay.yesterday().key;
    return await loadDay(yestKey);
  }

  // =====================
  // HISTORIQUE
  // =====================

  /// Charger les N derniers jours
  Future<List<DayEntry>> loadLastDays(int count) async {
    _ensureInitialized();
    if (count <= 0) return [];

    final entries = <DayEntry>[];
    var date = DateTime.now();

    for (var i = 0; i < count; i++) {
      final dayKey = InfernalDay.fromDate(date).key;
      final entry = await loadDay(dayKey);
      if (entry != null) {
        entries.add(entry);
      }
      date = date.subtract(const Duration(days: 1));
    }

    Log.debug('STORAGE', 'Loaded history',
        data: {'requested': count, 'found': entries.length});
    return entries;
  }

  /// Lister tous les jours disponibles (tries par date desc)
  Future<List<String>> listAllDayKeys() async {
    _ensureInitialized();

    try {
      final dir = Directory('$_basePath/$_daysDir');
      if (!await dir.exists()) return [];

      final files = await dir.list().toList();
      final keys = files
          .whereType<File>()
          .map((f) {
            final name = f.path.split(Platform.pathSeparator).last;
            return name.replaceAll('.json', '');
          })
          .where((k) => !k.endsWith('.bak') && !k.endsWith('.tmp'))
          .toList()
        ..sort((a, b) => b.compareTo(a));

      return keys;
    } catch (e, stack) {
      Log.error('STORAGE', 'List days failed', error: e, stack: stack);
      return [];
    }
  }

  /// Supprimer un jour (avec confirmation)
  Future<Result<void>> deleteDay(String dayKey) async {
    _ensureInitialized();

    try {
      final file = File(_dayPath(dayKey));
      if (await file.exists()) {
        await file.delete();
        Log.info('STORAGE', 'Day deleted', data: {'dayKey': dayKey});
      }
      return const Success(null);
    } catch (e, stack) {
      Log.error('STORAGE', 'Delete day failed',
          error: e, stack: stack, data: {'dayKey': dayKey});
      return Failure(AppError.io('Delete failed', e, stack));
    }
  }

  /// Exporter toutes les donnees (pour debug/backup)
  Future<String> exportAll() async {
    _ensureInitialized();

    final keys = await listAllDayKeys();
    final buffer = StringBuffer();

    buffer.writeln('=== InfernalWheel Export ===');
    buffer.writeln('Date: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Days: ${keys.length}');
    buffer.writeln();

    for (final key in keys) {
      final entry = await loadDay(key);
      if (entry != null) {
        buffer.writeln(entry.exportForPsy());
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}
