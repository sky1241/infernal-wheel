import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/infernal_day.dart';

/// Stockage local des donnees (JSON/CSV)
/// Toutes les donnees restent sur l'appareil du client.
///
/// !!! BUG+018 PRIVACY GAP — see BUGS.md !!!
/// Cette classe écrit en CLAIR (jsonEncode + writeAsString). CryptoService
/// est initialisé par main.dart mais ses helpers encryptToFile/decryptFromFile
/// ne sont JAMAIS appelés ici. Le marketing dit "AES-256 encrypted" — ce n'est
/// pas vrai aujourd'hui. NE PAS pousser sur le Play Store sans avoir résolu
/// BUG+018 (rework architectural + migration des fichiers existants).
class DataStore {
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  late Directory _dataDir;
  late Directory _notesDir;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final appDir = await getApplicationDocumentsDirectory();
    _dataDir = Directory('${appDir.path}/infernal_data');
    _notesDir = Directory('${_dataDir.path}/notes');
    await _dataDir.create(recursive: true);
    await _notesDir.create(recursive: true);
    _initialized = true;
  }

  // --- Settings ---

  File get _settingsFile => File('${_dataDir.path}/settings.json');

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      if (await _settingsFile.exists()) {
        return jsonDecode(await _settingsFile.readAsString()) as Map<String, dynamic>;
      }
    } catch (_) {}
    return _defaultSettings();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _settingsFile.writeAsString(jsonEncode(settings));
  }

  Map<String, dynamic> _defaultSettings() => {
    'manualBreakOnly': true,
    'penalty': {'enableOvertimeCounter': true},
    'actions': [
      {'key': 'work', 'label': 'Work', 'mode': 'work', 'minutes': 0, 'requireOk': false},
      {'key': 'dodo', 'label': 'Dodo', 'mode': 'sleep', 'minutes': 0, 'requireOk': false},
      {'key': 'clope', 'label': 'Clope', 'mode': 'break', 'minutes': 10, 'requireOk': true},
      {'key': 'manger', 'label': 'Manger', 'mode': 'break', 'minutes': 30, 'requireOk': true},
      {'key': 'menage', 'label': 'Menage', 'mode': 'break', 'minutes': 20, 'requireOk': true},
      {'key': 'chier', 'label': 'Chier', 'mode': 'break', 'minutes': 10, 'requireOk': true},
      {'key': 'douche', 'label': 'Douche', 'mode': 'break', 'minutes': 10, 'requireOk': true},
      {'key': 'marche', 'label': 'Marche', 'mode': 'break', 'minutes': 15, 'requireOk': true},
      {'key': 'sport', 'label': 'Sport', 'mode': 'break', 'minutes': 45, 'requireOk': true},
    ],
    'alcoholVolumes': {'beer': 0.5, 'wine': 0.2, 'strong': 0.2},
  };

  // --- Engine state ---

  File get _stateFile => File('${_dataDir.path}/state.json');

  Future<Map<String, dynamic>?> loadState() async {
    try {
      if (await _stateFile.exists()) {
        return jsonDecode(await _stateFile.readAsString()) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveState(Map<String, dynamic> state) async {
    await _stateFile.writeAsString(jsonEncode(state));
  }

  // --- Notes ---

  Future<String> loadNote(String dayKey) async {
    if (!_isValidDayKey(dayKey)) return '';
    final file = File('${_notesDir.path}/$dayKey.txt');
    try {
      if (await file.exists()) return await file.readAsString();
    } catch (_) {}
    return '';
  }

  Future<void> saveNote(String dayKey, String content) async {
    if (!_isValidDayKey(dayKey)) return;
    final file = File('${_notesDir.path}/$dayKey.txt');
    await file.writeAsString(content);
  }

  Future<List<Map<String, dynamic>>> loadAllNotes() async {
    final notes = <Map<String, dynamic>>[];
    try {
      await for (final entity in _notesDir.list()) {
        if (entity is File && entity.path.endsWith('.txt')) {
          final name = entity.uri.pathSegments.last.replaceAll('.txt', '');
          final content = await entity.readAsString();
          if (content.isNotEmpty) {
            notes.add({'day': name, 'content': content});
          }
        }
      }
    } catch (_) {}
    notes.sort((a, b) => (b['day'] as String).compareTo(a['day'] as String));
    return notes;
  }

  // --- Quick note / Action note ---

  File get _quickNoteFile => File('${_dataDir.path}/quicknote.txt');
  File get _actionNoteFile => File('${_dataDir.path}/actionnote.txt');

  Future<String> loadQuickNote() async {
    try {
      if (await _quickNoteFile.exists()) return await _quickNoteFile.readAsString();
    } catch (_) {}
    return '';
  }

  Future<void> saveQuickNote(String content) async {
    await _quickNoteFile.writeAsString(content);
  }

  Future<String> loadActionNote() async {
    try {
      if (await _actionNoteFile.exists()) return await _actionNoteFile.readAsString();
    } catch (_) {}
    return '';
  }

  Future<void> saveActionNote(String content) async {
    await _actionNoteFile.writeAsString(content);
  }

  // --- Drinks (CSV) ---

  File get _drinksFile => File('${_dataDir.path}/drinks.csv');

  Future<void> addDrink(String type, int n, {String? day}) async {
    final now = DateTime.now();
    final dayKey = day == 'yesterday'
        ? InfernalDay.from(now.subtract(const Duration(days: 1))).key
        : (day != null && day.isNotEmpty ? day : InfernalDay.from(now).key);
    final wine = type == 'wine' ? n : 0;
    final beer = type == 'beer' ? n : 0;
    final strong = type == 'strong' ? n : 0;
    final at = now.toIso8601String().substring(0, 19).replaceAll('T', ' ');
    final line = '$at,$dayKey,$wine,$beer,$strong';

    if (!await _drinksFile.exists()) {
      await _drinksFile.writeAsString('At,InfernalDay,Wine,Beer,Strong\n');
    }
    await _drinksFile.writeAsString('$line\n', mode: FileMode.append);
  }

  Future<Map<String, int>> getDailyAlcohol(String dayKey) async {
    final totals = {'wine': 0, 'beer': 0, 'strong': 0};
    try {
      if (!await _drinksFile.exists()) return totals;
      final lines = (await _drinksFile.readAsString()).split('\n');
      for (final line in lines.skip(1)) {
        final parts = line.split(',');
        if (parts.length >= 5 && parts[1] == dayKey) {
          totals['wine'] = totals['wine']! + (int.tryParse(parts[2]) ?? 0);
          totals['beer'] = totals['beer']! + (int.tryParse(parts[3]) ?? 0);
          totals['strong'] = totals['strong']! + (int.tryParse(parts[4]) ?? 0);
        }
      }
    } catch (_) {}
    return totals;
  }

  Future<List<Map<String, dynamic>>> getAllConsumption() async {
    final byDay = <String, Map<String, int>>{};
    try {
      if (await _drinksFile.exists()) {
        final lines = (await _drinksFile.readAsString()).split('\n');
        for (final line in lines.skip(1)) {
          final parts = line.split(',');
          if (parts.length >= 5) {
            final day = parts[1];
            byDay.putIfAbsent(day, () => {'wine': 0, 'beer': 0, 'strong': 0, 'smokes': 0});
            byDay[day]!['wine'] = byDay[day]!['wine']! + (int.tryParse(parts[2]) ?? 0);
            byDay[day]!['beer'] = byDay[day]!['beer']! + (int.tryParse(parts[3]) ?? 0);
            byDay[day]!['strong'] = byDay[day]!['strong']! + (int.tryParse(parts[4]) ?? 0);
          }
        }
      }
    } catch (_) {}
    // Cigarette data from log.csv will be added here once implemented
    final result = byDay.entries.map((e) => {
      'date': e.key, ...e.value,
    }).toList();
    result.sort((a, b) => ((b['date'] ?? b['day'] ?? '') as String).compareTo((a['date'] ?? a['day'] ?? '') as String));
    return result;
  }

  /// Weekly alcohol aggregates for the dashboard table
  Future<Map<String, dynamic>> getDrinksWeeks() async {
    try {
      if (!await _drinksFile.exists()) return {'ok': true, 'weeks': []};

      // ABV constants (same as PowerShell)
      const beerAbv = 0.055, wineAbv = 0.135, strongAbv = 0.425;
      const beerL = 0.5, wineL = 0.2, strongL = 0.2;

      // Aggregate by ISO week
      final byWeek = <String, Map<String, dynamic>>{};
      final lines = (await _drinksFile.readAsString()).split('\n');
      for (final line in lines.skip(1)) {
        final parts = line.split(',');
        if (parts.length < 5) continue;
        final dayStr = parts[1].trim();
        if (dayStr.isEmpty) continue;
        final dt = DateTime.tryParse(dayStr);
        if (dt == null) continue;

        // ISO week key
        final dayOfYear = dt.difference(DateTime(dt.year, 1, 1)).inDays;
        final weekNum = ((dayOfYear - dt.weekday + 10) / 7).floor();
        final weekKey = '${dt.year}-W${weekNum.toString().padLeft(2, '0')}';

        if (!byWeek.containsKey(weekKey)) {
          final monday = dt.subtract(Duration(days: dt.weekday - 1));
          final sunday = monday.add(const Duration(days: 6));
          String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
          byWeek[weekKey] = <String, dynamic>{
            'weekKey': weekKey,
            'weekRange': '${fmt(monday)} - ${fmt(sunday)}',
            'beer': 0, 'wine': 0, 'strong': 0,
          };
        }

        byWeek[weekKey]!['beer'] = byWeek[weekKey]!['beer'] + (int.tryParse(parts[3]) ?? 0);
        byWeek[weekKey]!['wine'] = byWeek[weekKey]!['wine'] + (int.tryParse(parts[2]) ?? 0);
        byWeek[weekKey]!['strong'] = byWeek[weekKey]!['strong'] + (int.tryParse(parts[4]) ?? 0);
      }

      // Compute pure alcohol + deltas
      final weeks = byWeek.values.toList();
      weeks.sort((a, b) => (b['weekKey'] as String).compareTo(a['weekKey'] as String));

      for (int i = 0; i < weeks.length; i++) {
        final w = weeks[i];
        final pure = (w['beer'] as int) * beerL * beerAbv +
            (w['wine'] as int) * wineL * wineAbv +
            (w['strong'] as int) * strongL * strongAbv;
        w['beerCans'] = w['beer'];
        w['wineGlasses'] = w['wine'];
        w['strongGlasses'] = w['strong'];
        w['pureLiters'] = double.parse(pure.toStringAsFixed(3));

        if (i + 1 < weeks.length) {
          final prevPure = weeks[i + 1]['pureLiters'] as double? ?? 0;
          w['deltaPure'] = double.parse((pure - prevPure).toStringAsFixed(3));
        } else {
          w['deltaPure'] = 0.0;
        }
      }

      return {'ok': true, 'weeks': weeks};
    } catch (_) {
      return {'ok': true, 'weeks': []};
    }
  }

  // --- Log (CSV) ---

  File get _logFile => File('${_dataDir.path}/log.csv');

  Future<void> addLogRow(DateTime start, DateTime end, String name, bool isWork, bool isSleep) async {
    final dayKey = InfernalDay.from(start).key;
    final row = '${_fmtDt(start)},${_fmtDt(end)},${name.replaceAll(',', ' ')},$isWork,$isSleep,$dayKey';
    if (!await _logFile.exists()) {
      await _logFile.writeAsString('Start,End,Name,CountsAsWork,CountsAsSleep,InfernalDay\n');
    }
    await _logFile.writeAsString('$row\n', mode: FileMode.append);
  }

  // --- Helpers ---

  String _fmtDt(DateTime dt) => dt.toIso8601String().substring(0, 19).replaceAll('T', ' ');

  bool _isValidDayKey(String key) => RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(key);
}
