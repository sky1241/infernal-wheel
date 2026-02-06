import '../core/logger.dart';
import 'addiction.dart';
import 'sleep_data.dart';

/// Trend par rapport a hier
enum Trend {
  good('↓', 0xFF35D99A),    // Moins = mieux
  bad('↑', 0xFFFF4D4D),     // Plus = pire
  neutral('=', 0xFF808080); // Egal

  const Trend(this.symbol, this.colorValue);

  final String symbol;
  final int colorValue;
}

/// Donnees d'une journee complete
///
/// Contient: sommeil, addictions, notes libres
/// Identifie par dayKey au format "yyyy-MM-dd"
class DayEntry {
  /// Format "yyyy-MM-dd" (InfernalDay)
  final String dayKey;

  /// Donnees de sommeil (null si pas encore renseigne)
  SleepData? sleep;

  /// Liste des addictions du jour
  final List<AddictionEntry> _addictions;

  /// Notes libres de l'utilisateur
  String _journalText;

  /// Timestamps
  final DateTime createdAt;
  DateTime updatedAt;

  /// Longueur max du journal (securite)
  static const int maxJournalLength = 50000;

  DayEntry({
    required this.dayKey,
    this.sleep,
    List<AddictionEntry>? addictions,
    String journalText = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _addictions = addictions ?? [],
        _journalText = journalText.length > maxJournalLength
            ? journalText.substring(0, maxJournalLength)
            : journalText,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Acces aux addictions (copie pour eviter modifications externes)
  List<AddictionEntry> get addictions => List.unmodifiable(_addictions);

  /// Texte du journal
  String get journalText => _journalText;

  /// Modifier le texte du journal (avec limite de taille)
  set journalText(String value) {
    _journalText = value.length > maxJournalLength
        ? value.substring(0, maxJournalLength)
        : value;
    updatedAt = DateTime.now();
  }

  /// Obtenir le compteur pour un type
  int countFor(AddictionType type) {
    final entry = _addictions.where((a) => a.type == type).firstOrNull;
    return entry?.count ?? 0;
  }

  /// Obtenir l'entree pour un type (ou null)
  AddictionEntry? entryFor(AddictionType type) {
    return _addictions.where((a) => a.type == type).firstOrNull;
  }

  /// Obtenir l'heure de la premiere pour un type
  DateTime? firstTimeFor(AddictionType type) {
    return entryFor(type)?.firstTime;
  }

  /// Incrementer une addiction
  void increment(AddictionType type) {
    var entry = entryFor(type);
    if (entry != null) {
      entry.increment();
    } else {
      entry = AddictionEntry(type: type);
      entry.increment();
      _addictions.add(entry);
    }
    updatedAt = DateTime.now();
    Log.trace('MODEL', 'DayEntry increment', data: {
      'dayKey': dayKey,
      'type': type.id,
      'newCount': entry.count,
    });
  }

  /// Decrementer une addiction
  void decrement(AddictionType type) {
    final entry = entryFor(type);
    if (entry != null && entry.count > 0) {
      entry.decrement();
      updatedAt = DateTime.now();
      Log.trace('MODEL', 'DayEntry decrement', data: {
        'dayKey': dayKey,
        'type': type.id,
        'newCount': entry.count,
      });
    }
  }

  /// Reset une addiction a zero
  void resetAddiction(AddictionType type) {
    final entry = entryFor(type);
    if (entry != null) {
      entry.reset();
      updatedAt = DateTime.now();
    }
  }

  /// Calculer le trend vs hier
  Trend trendFor(AddictionType type, DayEntry? yesterday) {
    final today = countFor(type);
    final yest = yesterday?.countFor(type) ?? 0;
    if (today < yest) return Trend.good;
    if (today > yest) return Trend.bad;
    return Trend.neutral;
  }

  /// Trend pour le delai premiere addiction (plus tard = mieux)
  Trend trendFirstTime(AddictionType type, DayEntry? yesterday) {
    final todayFirst = firstTimeFor(type);
    final yestFirst = yesterday?.firstTimeFor(type);

    if (todayFirst == null || yestFirst == null) {
      return Trend.neutral;
    }
    if (sleep == null || yesterday?.sleep == null) {
      return Trend.neutral;
    }

    final todayDelay = todayFirst.difference(sleep!.wakeTime).inMinutes.abs();
    final yestDelay = yestFirst.difference(yesterday!.sleep!.wakeTime).inMinutes.abs();

    if (todayDelay > yestDelay) return Trend.good;
    if (todayDelay < yestDelay) return Trend.bad;
    return Trend.neutral;
  }

  /// Total des addictions du jour
  int get totalAddictions {
    return _addictions.fold(0, (sum, a) => sum + a.count);
  }

  /// True si le jour a des donnees
  bool get hasData {
    return sleep != null || totalAddictions > 0 || _journalText.isNotEmpty;
  }

  /// Export pour le psy (format texte lisible)
  String exportForPsy() {
    final sep = '=' * 50;
    final buf = StringBuffer();

    buf.writeln(sep);
    buf.writeln('JOURNAL - $dayKey');
    buf.writeln(sep);
    buf.writeln();

    // Sommeil
    if (sleep != null) {
      buf.writeln('--- SOMMEIL ---');
      buf.writeln('Reveil: ${sleep!.wakeTimeFormatted}');
      buf.writeln('Duree: ${sleep!.durationFormatted}');
      buf.writeln('Qualite: ${sleep!.quality.label} (${sleep!.quality.score}/10)');
      buf.writeln('Source: ${sleep!.source.name}');
      buf.writeln();
    }

    // Addictions
    final activeAddictions = _addictions.where((a) => a.count > 0).toList();
    if (activeAddictions.isNotEmpty) {
      buf.writeln('--- ADDICTIONS ---');
      for (final a in activeAddictions) {
        buf.write('${a.type.emoji} ${a.type.label}: ${a.count}');
        final delay = a.delayFromWake(sleep?.wakeTime);
        if (delay != null) {
          buf.write(' (1ere a +${delay}min du reveil)');
        }
        buf.writeln();
      }
      buf.writeln();
    }

    // Journal
    buf.writeln('--- NOTES LIBRES ---');
    buf.writeln(_journalText.isEmpty ? '(vide)' : _journalText);
    buf.writeln();

    buf.writeln(sep);
    buf.writeln('Exporte le ${DateTime.now().toString().substring(0, 16)}');

    return buf.toString();
  }

  /// Serialization JSON
  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'sleep': sleep?.toJson(),
        'addictions': _addictions.map((a) => a.toJson()).toList(),
        'journalText': _journalText,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Deserialization avec guards complets
  factory DayEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      Log.warn('MODEL', 'Null json for DayEntry');
      return DayEntry(dayKey: 'unknown');
    }

    try {
      // DayKey avec fallback
      final dayKey = json['dayKey'] as String? ?? 'unknown';

      // Sleep parsing safe
      SleepData? sleep;
      final sleepJson = json['sleep'];
      if (sleepJson is Map<String, dynamic>) {
        try {
          sleep = SleepData.fromJson(sleepJson);
        } catch (e) {
          Log.warn('MODEL', 'Invalid sleep data', error: e);
        }
      }

      // Addictions parsing safe
      List<AddictionEntry> addictions = [];
      final addictionsJson = json['addictions'];
      if (addictionsJson is List) {
        addictions = addictionsJson
            .whereType<Map<String, dynamic>>()
            .map((a) => AddictionEntry.fromJson(a))
            .toList();
      }

      // Journal text
      final journalText = json['journalText'] as String? ?? '';

      // Dates avec fallback
      DateTime? createdAt;
      DateTime? updatedAt;
      try {
        final createdStr = json['createdAt'] as String?;
        if (createdStr != null) createdAt = DateTime.parse(createdStr);
      } catch (e) {
        Log.warn('MODEL', 'Invalid createdAt');
      }
      try {
        final updatedStr = json['updatedAt'] as String?;
        if (updatedStr != null) updatedAt = DateTime.parse(updatedStr);
      } catch (e) {
        Log.warn('MODEL', 'Invalid updatedAt');
      }

      return DayEntry(
        dayKey: dayKey,
        sleep: sleep,
        addictions: addictions,
        journalText: journalText,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e, stack) {
      Log.error('MODEL', 'Parse DayEntry failed', error: e, stack: stack);
      return DayEntry(dayKey: json['dayKey'] as String? ?? 'unknown');
    }
  }

  @override
  String toString() => 'DayEntry($dayKey, addictions: ${totalAddictions})';
}
