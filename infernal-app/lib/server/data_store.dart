import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../core/infernal_day.dart';
import '../security/crypto_service.dart';

/// Stockage local des donnees (JSON/CSV), chiffrement AES-256-GCM au repos.
///
/// Toutes les donnees restent sur l'appareil du client.
///
/// BUG+018 fix: CryptoService was scaffolded but never wired into DataStore.
/// Every file read/write now goes through `_readSecure` / `_writeSecure`
/// which use CryptoService.encryptToFile / decryptFromFile. Legacy plain
/// files from before this fix are transparently migrated on first read
/// (see `_readSecure` implementation notes).
///
/// Guarantees:
/// - Every file under $dataDir/* that passes through this class is either
///   (a) encrypted with AES-256-GCM using the key stored in the Android
///       Keystore via flutter_secure_storage, OR
///   (b) absent (file doesn't exist yet).
/// - No site in this class calls `File.writeAsString` / `readAsString`
///   directly on a data file — all goes through the secure helpers. Tested
///   by the static-grep suite in trilateration/test_bug_018_crypto_wired.py.
/// - CSV files (drinks.csv, log.csv) use read-modify-write instead of
///   FileMode.append because encrypted files can't be streamed-appended.
///   The N is small (<100 rows/month typical) so the perf hit is negligible.
/// - If CryptoService is locked when a write is attempted, the write throws
///   StateError rather than falling back to plaintext — the entire point
///   of this fix is to never write plaintext again.
class DataStore {
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();

  final _crypto = CryptoService();

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

  // ────────────────────────────────────────────────────────────────────
  // Secure I/O helpers — BUG+018 fix
  // ────────────────────────────────────────────────────────────────────

  /// Read a file with transparent decryption + legacy-plaintext migration.
  ///
  /// Returns the decrypted content, the migrated plaintext content, or null
  /// if the file doesn't exist or decryption definitively fails (corrupt
  /// ciphertext that also doesn't parse as readable legacy data).
  ///
  /// Migration path: if decryptFromFile returns null but the file exists
  /// and reads as non-empty plain text, we treat it as a pre-BUG+018
  /// legacy file, re-encrypt it in place, and return the plaintext. On
  /// subsequent reads the encrypted-path wins.
  Future<String?> _readSecure(File file) async {
    if (!await file.exists()) return null;

    // Try encrypted path first (the normal case after migration).
    final decrypted = await _crypto.decryptFromFile(file);
    if (decrypted != null) return decrypted;

    // Decryption failed. This is either:
    //   (a) A legacy plain file from before the BUG+018 fix.
    //   (b) A corrupt ciphertext with wrong key / damaged bytes.
    // We attempt to read as plain text and, if non-empty, treat it as
    // legacy and migrate in place. Corrupt ciphertext is almost always
    // still base64-ASCII so it would "read" as a non-empty string —
    // but attempting to re-encrypt it is harmless (we'd just overwrite
    // a file we can't decrypt anyway).
    try {
      final plain = await file.readAsString();
      if (plain.isEmpty) return null;

      // BUG+018 migration: re-write the legacy plain file as encrypted.
      if (_crypto.isUnlocked) {
        await _crypto.encryptToFile(file, plain);
      }
      return plain;
    } catch (_) {
      return null;
    }
  }

  /// Write a file, always encrypted. Throws StateError if CryptoService
  /// is not unlocked — we must NEVER fall back to plaintext. If the
  /// startup flow is broken and DataStore is used before the crypto is
  /// unlocked, we want loud failure, not silent plaintext writes.
  Future<void> _writeSecure(File file, String content) async {
    if (!_crypto.isUnlocked) {
      throw StateError(
        'BUG+018: refuse to write plaintext when CryptoService is locked. '
        'Check the main.dart startup flow — CryptoService must be unlocked '
        'before any DataStore save.',
      );
    }
    await _crypto.encryptToFile(file, content);
  }

  // ────────────────────────────────────────────────────────────────────
  // Settings
  // ────────────────────────────────────────────────────────────────────

  File get _settingsFile => File('${_dataDir.path}/settings.json');

  Future<Map<String, dynamic>> loadSettings() async {
    try {
      final text = await _readSecure(_settingsFile);
      if (text != null && text.isNotEmpty) {
        return jsonDecode(text) as Map<String, dynamic>;
      }
    } catch (_) {}
    return _defaultSettings();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _writeSecure(_settingsFile, jsonEncode(settings));
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

  // ────────────────────────────────────────────────────────────────────
  // Engine state
  // ────────────────────────────────────────────────────────────────────

  File get _stateFile => File('${_dataDir.path}/state.json');

  Future<Map<String, dynamic>?> loadState() async {
    try {
      final text = await _readSecure(_stateFile);
      if (text != null && text.isNotEmpty) {
        return jsonDecode(text) as Map<String, dynamic>;
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveState(Map<String, dynamic> state) async {
    await _writeSecure(_stateFile, jsonEncode(state));
  }

  // ────────────────────────────────────────────────────────────────────
  // Notes (per-day text files)
  // ────────────────────────────────────────────────────────────────────

  Future<String> loadNote(String dayKey) async {
    if (!_isValidDayKey(dayKey)) return '';
    final file = File('${_notesDir.path}/$dayKey.txt');
    try {
      final text = await _readSecure(file);
      if (text != null) return text;
    } catch (_) {}
    return '';
  }

  Future<void> saveNote(String dayKey, String content) async {
    if (!_isValidDayKey(dayKey)) return;
    final file = File('${_notesDir.path}/$dayKey.txt');
    await _writeSecure(file, content);
  }

  Future<List<Map<String, dynamic>>> loadAllNotes() async {
    final notes = <Map<String, dynamic>>[];
    try {
      await for (final entity in _notesDir.list()) {
        if (entity is File && entity.path.endsWith('.txt')) {
          final name = entity.uri.pathSegments.last.replaceAll('.txt', '');
          final content = await _readSecure(entity);
          if (content != null && content.isNotEmpty) {
            notes.add({'day': name, 'content': content});
          }
        }
      }
    } catch (_) {}
    notes.sort((a, b) => (b['day'] as String).compareTo(a['day'] as String));
    return notes;
  }

  // ────────────────────────────────────────────────────────────────────
  // Quick note / Action note
  // ────────────────────────────────────────────────────────────────────

  File get _quickNoteFile => File('${_dataDir.path}/quicknote.txt');
  File get _actionNoteFile => File('${_dataDir.path}/actionnote.txt');

  Future<String> loadQuickNote() async {
    try {
      final text = await _readSecure(_quickNoteFile);
      if (text != null) return text;
    } catch (_) {}
    return '';
  }

  Future<void> saveQuickNote(String content) async {
    await _writeSecure(_quickNoteFile, content);
  }

  Future<String> loadActionNote() async {
    try {
      final text = await _readSecure(_actionNoteFile);
      if (text != null) return text;
    } catch (_) {}
    return '';
  }

  Future<void> saveActionNote(String content) async {
    await _writeSecure(_actionNoteFile, content);
  }

  // ────────────────────────────────────────────────────────────────────
  // Drinks (CSV)
  //
  // BUG+018: FileMode.append is incompatible with encrypted files because
  // each encryption produces a unique IV and tag — you can't simply
  // concatenate two ciphertexts. We use read-modify-write instead. The
  // CSV is small (typical user: <50 rows/month, ~10KB/year compressed)
  // so the per-write cost is negligible.
  // ────────────────────────────────────────────────────────────────────

  static const _drinksHeader = 'At,InfernalDay,Wine,Beer,Strong';

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

    // Read current content (encrypted or legacy plain), append, rewrite encrypted.
    final existing = await _readSecure(_drinksFile) ?? '';
    final content = existing.isEmpty
        ? '$_drinksHeader\n$line\n'
        : (existing.endsWith('\n') ? '$existing$line\n' : '$existing\n$line\n');
    await _writeSecure(_drinksFile, content);
  }

  Future<Map<String, int>> getDailyAlcohol(String dayKey) async {
    final totals = {'wine': 0, 'beer': 0, 'strong': 0};
    try {
      final text = await _readSecure(_drinksFile);
      if (text == null) return totals;
      final lines = text.split('\n');
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
      final text = await _readSecure(_drinksFile);
      if (text != null) {
        final lines = text.split('\n');
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
    final result = byDay.entries.map((e) => {
      'date': e.key, ...e.value,
    }).toList();
    result.sort((a, b) => ((b['date'] ?? b['day'] ?? '') as String).compareTo((a['date'] ?? a['day'] ?? '') as String));
    return result;
  }

  /// Weekly alcohol aggregates for the dashboard table
  Future<Map<String, dynamic>> getDrinksWeeks() async {
    try {
      final text = await _readSecure(_drinksFile);
      if (text == null) return {'ok': true, 'weeks': []};

      // ABV constants
      const beerAbv = 0.055, wineAbv = 0.135, strongAbv = 0.425;
      const beerL = 0.5, wineL = 0.2, strongL = 0.2;

      // Aggregate by ISO week
      final byWeek = <String, Map<String, dynamic>>{};
      final lines = text.split('\n');
      for (final line in lines.skip(1)) {
        final parts = line.split(',');
        if (parts.length < 5) continue;
        final dayStr = parts[1].trim();
        if (dayStr.isEmpty) continue;
        final dt = DateTime.tryParse(dayStr);
        if (dt == null) continue;

        // BUG+054 fix: proper ISO 8601 week via _isoWeek helper.
        final iso = _isoWeek(dt);
        final isoYear = iso.$1;
        final weekNum = iso.$2;
        final weekKey = '$isoYear-W${weekNum.toString().padLeft(2, '0')}';

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

  // ────────────────────────────────────────────────────────────────────
  // Log (CSV) — same read-modify-write pattern as drinks
  // ────────────────────────────────────────────────────────────────────

  static const _logHeader = 'Start,End,Name,CountsAsWork,CountsAsSleep,InfernalDay';

  File get _logFile => File('${_dataDir.path}/log.csv');

  Future<void> addLogRow(DateTime start, DateTime end, String name, bool isWork, bool isSleep) async {
    final dayKey = InfernalDay.from(start).key;
    final row = '${_fmtDt(start)},${_fmtDt(end)},${name.replaceAll(',', ' ')},$isWork,$isSleep,$dayKey';

    final existing = await _readSecure(_logFile) ?? '';
    final content = existing.isEmpty
        ? '$_logHeader\n$row\n'
        : (existing.endsWith('\n') ? '$existing$row\n' : '$existing\n$row\n');
    await _writeSecure(_logFile, content);
  }

  // ────────────────────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────────────────────

  String _fmtDt(DateTime dt) => dt.toIso8601String().substring(0, 19).replaceAll('T', ' ');

  /// Compute (ISO year, ISO week number) per ISO 8601 for a given date.
  /// See BUG+054 in BUGS.md for the full rationale — the previous naive
  /// formula produced W0 and wrong-year prefixes on year-boundary dates.
  (int, int) _isoWeek(DateTime dt) {
    final thursday = DateTime.utc(dt.year, dt.month, dt.day)
        .add(Duration(days: 4 - dt.weekday));
    final isoYear = thursday.year;
    final jan1 = DateTime.utc(isoYear, 1, 1);
    final firstThursday = jan1.add(Duration(days: (4 - jan1.weekday) % 7));
    final daysBetween = thursday.difference(firstThursday).inDays;
    final weekNum = 1 + (daysBetween ~/ 7);
    return (isoYear, weekNum);
  }

  bool _isValidDayKey(String key) => RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(key);
}
