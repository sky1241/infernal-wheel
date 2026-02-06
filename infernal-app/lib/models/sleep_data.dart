/// Source des donnees sommeil
enum SleepSource {
  healthKit,    // Apple Watch via HealthKit
  healthConnect, // Android via Health Connect
  manual,       // Saisie manuelle
}

/// Qualite du sommeil
enum SleepQuality {
  bad(2, 'Mauvais', 0xFFFF4D4D),
  poor(4, 'Insuffisant', 0xFFFF7A7A),
  okay(6, 'Moyen', 0xFFF6B73C),
  good(8, 'Bon', 0xFF35D99A),
  great(10, 'Excellent', 0xFF00E5A0);

  const SleepQuality(this.score, this.label, this.colorValue);

  final int score;
  final String label;
  final int colorValue;

  /// Calculer la qualite depuis la duree
  static SleepQuality fromDuration(int minutes, {int goalMinutes = 480}) {
    final ratio = minutes / goalMinutes;
    if (ratio < 0.625) return bad;      // < 5h sur 8h
    if (ratio < 0.75) return poor;      // 5-6h
    if (ratio < 0.875) return okay;     // 6-7h
    if (ratio < 1.0) return good;       // 7-8h
    return great;                        // 8h+
  }
}

/// Donnees de sommeil pour une nuit
class SleepData {
  final SleepSource source;
  final DateTime? bedTime;      // Heure coucher (optionnel si manuel)
  final DateTime wakeTime;      // Heure reveil
  final int durationMinutes;    // Duree totale
  final SleepQuality quality;

  SleepData({
    required this.source,
    this.bedTime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.quality,
  });

  /// Creer depuis HealthKit/Health Connect
  factory SleepData.fromHealth({
    required DateTime bedTime,
    required DateTime wakeTime,
    required bool isApple,
    int goalMinutes = 480,
  }) {
    final duration = wakeTime.difference(bedTime).inMinutes;
    return SleepData(
      source: isApple ? SleepSource.healthKit : SleepSource.healthConnect,
      bedTime: bedTime,
      wakeTime: wakeTime,
      durationMinutes: duration,
      quality: SleepQuality.fromDuration(duration, goalMinutes: goalMinutes),
    );
  }

  /// Creer manuellement
  factory SleepData.manual({
    required DateTime wakeTime,
    required double estimatedHours,
    int goalMinutes = 480,
  }) {
    final duration = (estimatedHours * 60).round();
    return SleepData(
      source: SleepSource.manual,
      bedTime: null,
      wakeTime: wakeTime,
      durationMinutes: duration,
      quality: SleepQuality.fromDuration(duration, goalMinutes: goalMinutes),
    );
  }

  /// Format duree "7h30"
  String get durationFormatted {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return m > 0 ? '${h}h${m.toString().padLeft(2, '0')}' : '${h}h';
  }

  /// Format heure "07:30"
  String get wakeTimeFormatted {
    return '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';
  }

  /// Serialization
  Map<String, dynamic> toJson() => {
    'source': source.name,
    'bedTime': bedTime?.toIso8601String(),
    'wakeTime': wakeTime.toIso8601String(),
    'durationMinutes': durationMinutes,
    'quality': quality.name,
  };

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      source: SleepSource.values.byName(json['source']),
      bedTime: json['bedTime'] != null ? DateTime.parse(json['bedTime']) : null,
      wakeTime: DateTime.parse(json['wakeTime']),
      durationMinutes: json['durationMinutes'],
      quality: SleepQuality.values.byName(json['quality']),
    );
  }
}
