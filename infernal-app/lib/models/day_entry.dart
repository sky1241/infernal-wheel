import 'addiction.dart';
import 'sleep_data.dart';

/// Trend par rapport a hier
enum Trend {
  good('↓', 0xFF35D99A),   // Moins = mieux
  bad('↑', 0xFFFF4D4D),    // Plus = pire
  neutral('=', 0xFF808080);

  const Trend(this.symbol, this.colorValue);

  final String symbol;
  final int colorValue;
}

/// Donnees d'une journee complete
class DayEntry {
  final String dayKey;           // Format "yyyy-MM-dd" (InfernalDay)
  SleepData? sleep;
  List<AddictionEntry> addictions;
  String journalText;
  DateTime createdAt;
  DateTime updatedAt;

  DayEntry({
    required this.dayKey,
    this.sleep,
    List<AddictionEntry>? addictions,
    this.journalText = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) :
    addictions = addictions ?? [],
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  /// Obtenir le compteur pour un type
  int countFor(AddictionType type) {
    return addictions.where((a) => a.type == type).firstOrNull?.count ?? 0;
  }

  /// Obtenir l'heure de la premiere pour un type
  DateTime? firstTimeFor(AddictionType type) {
    return addictions.where((a) => a.type == type).firstOrNull?.firstTime;
  }

  /// Incrementer une addiction
  void increment(AddictionType type) {
    final entry = addictions.where((a) => a.type == type).firstOrNull;
    if (entry != null) {
      entry.increment();
    } else {
      final newEntry = AddictionEntry(type: type);
      newEntry.increment();
      addictions.add(newEntry);
    }
    updatedAt = DateTime.now();
  }

  /// Decrementer une addiction
  void decrement(AddictionType type) {
    final entry = addictions.where((a) => a.type == type).firstOrNull;
    entry?.decrement();
    updatedAt = DateTime.now();
  }

  /// Calculer le trend vs hier
  Trend trendFor(AddictionType type, DayEntry? yesterday) {
    final today = countFor(type);
    final yest = yesterday?.countFor(type) ?? 0;
    if (today < yest) return Trend.good;
    if (today > yest) return Trend.bad;
    return Trend.neutral;
  }

  /// Trend pour le delai premiere addiction
  Trend trendFirstTime(AddictionType type, DayEntry? yesterday) {
    final todayFirst = firstTimeFor(type);
    final yestFirst = yesterday?.firstTimeFor(type);
    if (todayFirst == null || yestFirst == null || sleep == null || yesterday?.sleep == null) {
      return Trend.neutral;
    }
    final todayDelay = todayFirst.difference(sleep!.wakeTime).inMinutes;
    final yestDelay = yestFirst.difference(yesterday!.sleep!.wakeTime).inMinutes;
    if (todayDelay > yestDelay) return Trend.good; // Plus tard = mieux
    if (todayDelay < yestDelay) return Trend.bad;
    return Trend.neutral;
  }

  /// Export pour le psy
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
    buf.writeln('--- ADDICTIONS ---');
    for (final a in addictions.where((a) => a.count > 0)) {
      buf.write('${a.type.emoji} ${a.type.label}: ${a.count}');
      final delay = a.delayFromWake(sleep?.wakeTime);
      if (delay != null) {
        buf.write(' (1ere a +${delay}min du reveil)');
      }
      buf.writeln();
    }
    buf.writeln();

    // Journal
    buf.writeln('--- NOTES LIBRES ---');
    buf.writeln(journalText.isEmpty ? '(vide)' : journalText);
    buf.writeln();

    buf.writeln(sep);
    buf.writeln('Exporte le ${DateTime.now().toString().substring(0, 16)}');

    return buf.toString();
  }

  /// Serialization
  Map<String, dynamic> toJson() => {
    'dayKey': dayKey,
    'sleep': sleep?.toJson(),
    'addictions': addictions.map((a) => a.toJson()).toList(),
    'journalText': journalText,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DayEntry.fromJson(Map<String, dynamic> json) {
    return DayEntry(
      dayKey: json['dayKey'],
      sleep: json['sleep'] != null ? SleepData.fromJson(json['sleep']) : null,
      addictions: (json['addictions'] as List?)
          ?.map((a) => AddictionEntry.fromJson(a))
          .toList() ?? [],
      journalText: json['journalText'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
