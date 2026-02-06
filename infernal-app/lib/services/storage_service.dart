import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/day_entry.dart';
import '../models/user_settings.dart';
import '../utils/infernal_day.dart';

// Note: Pour production, utiliser Hive pour plus de performance
// import 'package:hive_flutter/hive_flutter.dart';

/// Service de stockage local (100% local, rien envoye)
class StorageService {
  static const String _daysDir = 'days';
  static const String _settingsFile = 'settings.json';

  String? _basePath;

  /// Initialiser le stockage
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _basePath = dir.path;

    // Creer le dossier days si necessaire
    final daysPath = Directory('$_basePath/$_daysDir');
    if (!await daysPath.exists()) {
      await daysPath.create(recursive: true);
    }
  }

  // =====================
  // SETTINGS
  // =====================

  Future<UserSettings> loadSettings() async {
    try {
      final file = File('$_basePath/$_settingsFile');
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        return UserSettings.fromJson(json);
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
    return UserSettings.defaults();
  }

  Future<void> saveSettings(UserSettings settings) async {
    try {
      final file = File('$_basePath/$_settingsFile');
      await file.writeAsString(jsonEncode(settings.toJson()));
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // =====================
  // DAY ENTRIES
  // =====================

  String _dayPath(String dayKey) => '$_basePath/$_daysDir/$dayKey.json';

  Future<DayEntry?> loadDay(String dayKey) async {
    try {
      final file = File(_dayPath(dayKey));
      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        return DayEntry.fromJson(json);
      }
    } catch (e) {
      print('Error loading day $dayKey: $e');
    }
    return null;
  }

  Future<void> saveDay(DayEntry entry) async {
    try {
      final file = File(_dayPath(entry.dayKey));
      await file.writeAsString(jsonEncode(entry.toJson()));
    } catch (e) {
      print('Error saving day: $e');
    }
  }

  Future<DayEntry> loadOrCreateToday() async {
    final todayKey = InfernalDay.current().key;
    return await loadDay(todayKey) ?? DayEntry(dayKey: todayKey);
  }

  Future<DayEntry?> loadYesterday() async {
    final yestKey = InfernalDay.yesterday().key;
    return await loadDay(yestKey);
  }

  // =====================
  // HISTORIQUE
  // =====================

  /// Charger les N derniers jours
  Future<List<DayEntry>> loadLastDays(int count) async {
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

    return entries;
  }

  /// Lister tous les jours disponibles
  Future<List<String>> listAllDayKeys() async {
    try {
      final dir = Directory('$_basePath/$_daysDir');
      if (!await dir.exists()) return [];

      final files = await dir.list().toList();
      return files
          .whereType<File>()
          .map((f) => f.path.split('/').last.replaceAll('.json', ''))
          .toList()
        ..sort((a, b) => b.compareTo(a)); // Plus recent en premier
    } catch (e) {
      return [];
    }
  }
}
