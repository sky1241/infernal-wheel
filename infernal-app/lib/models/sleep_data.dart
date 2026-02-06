import '../core/logger.dart';

/// Source des donnees sommeil
enum SleepSource {
  healthKit,     // Apple Watch via HealthKit
  healthConnect, // Android via Health Connect
  manual;        // Saisie manuelle

  /// Parse safe depuis string
  static SleepSource fromName(String? name) {
    if (name == null) return manual;
    try {
      return SleepSource.values.byName(name);
    } catch (e) {
      Log.warn('MODEL', 'Unknown SleepSource', data: {'name': name});
      return manual;
    }
  }
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
    if (goalMinutes <= 0) goalMinutes = 480;
    final ratio = minutes / goalMinutes;
    if (ratio < 0.625) return bad;   // < 5h sur 8h
    if (ratio < 0.75) return poor;   // 5-6h
    if (ratio < 0.875) return okay;  // 6-7h
    if (ratio < 1.0) return good;    // 7-8h
    return great;                     // 8h+
  }

  /// Parse safe depuis string
  static SleepQuality fromName(String? name) {
    if (name == null) return okay;
    try {
      return SleepQuality.values.byName(name);
    } catch (e) {
      Log.warn('MODEL', 'Unknown SleepQuality', data: {'name': name});
      return okay;
    }
  }
}

/// Donnees de sommeil pour une nuit
class SleepData {
  final SleepSource source;
  final DateTime? bedTime;
  final DateTime wakeTime;
  final int durationMinutes;
  final SleepQuality quality;

  /// Limites de validation
  static const int minDuration = 0;
  static const int maxDuration = 24 * 60; // 24h max

  SleepData({
    required this.source,
    this.bedTime,
    required this.wakeTime,
    required int durationMinutes,
    required this.quality,
  }) : durationMinutes = durationMinutes.clamp(minDuration, maxDuration);

  /// Creer depuis HealthKit/Health Connect
  factory SleepData.fromHealth({
    required DateTime bedTime,
    required DateTime wakeTime,
    required bool isApple,
    int goalMinutes = 480,
  }) {
    final duration = wakeTime.difference(bedTime).inMinutes.abs();
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
    final duration = (estimatedHours.clamp(0, 24) * 60).round();
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

  /// Serialization JSON
  Map<String, dynamic> toJson() => {
        'source': source.name,
        'bedTime': bedTime?.toIso8601String(),
        'wakeTime': wakeTime.toIso8601String(),
        'durationMinutes': durationMinutes,
        'quality': quality.name,
      };

  /// Deserialization avec guards
  factory SleepData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      Log.warn('MODEL', 'Null json for SleepData');
      return SleepData(
        source: SleepSource.manual,
        wakeTime: DateTime.now(),
        durationMinutes: 420,
        quality: SleepQuality.okay,
      );
    }

    try {
      // Source
      final source = SleepSource.fromName(json['source'] as String?);

      // BedTime (optionnel)
      DateTime? bedTime;
      final bedTimeStr = json['bedTime'] as String?;
      if (bedTimeStr != null && bedTimeStr.isNotEmpty) {
        try {
          bedTime = DateTime.parse(bedTimeStr);
        } catch (e) {
          Log.warn('MODEL', 'Invalid bedTime', data: {'value': bedTimeStr});
        }
      }

      // WakeTime (requis)
      DateTime wakeTime;
      final wakeTimeStr = json['wakeTime'] as String?;
      if (wakeTimeStr != null && wakeTimeStr.isNotEmpty) {
        try {
          wakeTime = DateTime.parse(wakeTimeStr);
        } catch (e) {
          Log.warn('MODEL', 'Invalid wakeTime', data: {'value': wakeTimeStr});
          wakeTime = DateTime.now();
        }
      } else {
        wakeTime = DateTime.now();
      }

      // Duration
      final rawDuration = json['durationMinutes'];
      final durationMinutes = (rawDuration is num) ? rawDuration.toInt() : 420;

      // Quality
      final quality = SleepQuality.fromName(json['quality'] as String?);

      return SleepData(
        source: source,
        bedTime: bedTime,
        wakeTime: wakeTime,
        durationMinutes: durationMinutes,
        quality: quality,
      );
    } catch (e, stack) {
      Log.error('MODEL', 'Parse SleepData failed', error: e, stack: stack);
      return SleepData(
        source: SleepSource.manual,
        wakeTime: DateTime.now(),
        durationMinutes: 420,
        quality: SleepQuality.okay,
      );
    }
  }

  @override
  String toString() => 'SleepData($source, ${durationFormatted}, ${quality.label})';
}
