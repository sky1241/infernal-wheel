import 'package:health/health.dart';
import 'package:flutter/foundation.dart';

/// Reads sleep data from Health Connect (Samsung Health syncs here automatically).
/// Returns sleep duration + bed/wake times for the dashboard.
class SleepService {
  static final SleepService _instance = SleepService._internal();
  factory SleepService() => _instance;
  SleepService._internal();

  final _health = Health();
  bool _authorized = false;

  /// Request permission to read sleep data from Health Connect.
  Future<bool> authorize() async {
    try {
      final types = [
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_SESSION,
      ];
      final permissions = types.map((_) => HealthDataAccess.READ).toList();

      _authorized = await _health.requestAuthorization(types, permissions: permissions);
      debugPrint('SleepService: authorized=$_authorized');
      return _authorized;
    } catch (e) {
      debugPrint('SleepService: auth error: $e');
      return false;
    }
  }

  /// Get last night's sleep data.
  /// Returns map with: bedTime, wakeTime, durationMinutes, stages (if available).
  Future<Map<String, dynamic>> getLastNightSleep() async {
    if (!_authorized) {
      final ok = await authorize();
      if (!ok) return _emptySleep('Not authorized');
    }

    try {
      final now = DateTime.now();
      // Look back 24h for sleep data
      final yesterday = now.subtract(const Duration(hours: 24));

      final types = [
        HealthDataType.SLEEP_SESSION,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_IN_BED,
      ];

      final data = await _health.getHealthDataFromTypes(
        types: types,
        startTime: yesterday,
        endTime: now,
      );

      if (data.isEmpty) return _emptySleep('No sleep data');

      // Find the main sleep session (longest one)
      DateTime? bedTime;
      DateTime? wakeTime;
      int totalMinutes = 0;

      // Try SLEEP_SESSION first (most reliable)
      final sessions = data.where((d) =>
        d.type == HealthDataType.SLEEP_SESSION ||
        d.type == HealthDataType.SLEEP_IN_BED
      ).toList();

      if (sessions.isNotEmpty) {
        // Sort by duration, take longest (= main sleep, not nap)
        sessions.sort((a, b) =>
          b.dateTo.difference(b.dateFrom).compareTo(a.dateTo.difference(a.dateFrom))
        );
        final main = sessions.first;
        bedTime = main.dateFrom;
        wakeTime = main.dateTo;
        totalMinutes = wakeTime.difference(bedTime).inMinutes;
      }

      // Count actual asleep time (if available). BUG+029 fix: keep the
      // in-bed total separate so durationMinutes can prefer asleep when
      // available but asleepMinutes always reflects actual asleep records
      // (0 if Health Connect didn't return any). The previous code
      // overwrote totalMinutes and used it as a fallback for asleepMinutes,
      // making the two fields indistinguishable on most devices.
      final inBedMinutes = bedTime != null && wakeTime != null
          ? wakeTime.difference(bedTime).inMinutes
          : totalMinutes;

      final asleepData = data.where((d) => d.type == HealthDataType.SLEEP_ASLEEP).toList();
      int asleepMinutes = 0;
      for (final d in asleepData) {
        asleepMinutes += d.dateTo.difference(d.dateFrom).inMinutes;
      }

      // Primary number for the dashboard: prefer asleep when available,
      // fall back to in-bed otherwise.
      final durationMinutes = asleepMinutes > 0 ? asleepMinutes : inBedMinutes;

      return {
        'ok': true,
        'bedTime': bedTime?.toIso8601String(),
        'wakeTime': wakeTime?.toIso8601String(),
        'durationMinutes': durationMinutes,
        'inBedMinutes': inBedMinutes,
        'asleepMinutes': asleepMinutes,
        'source': 'Health Connect',
      };
    } catch (e) {
      debugPrint('SleepService: error reading sleep: $e');
      return _emptySleep('Error: $e');
    }
  }

  /// Get sleep history for the last N days.
  Future<List<Map<String, dynamic>>> getSleepHistory(int days) async {
    if (!_authorized) {
      final ok = await authorize();
      if (!ok) return [];
    }

    try {
      final now = DateTime.now();
      final start = now.subtract(Duration(days: days));

      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_SESSION, HealthDataType.SLEEP_IN_BED],
        startTime: start,
        endTime: now,
      );

      // Group by night (date of bedTime)
      final byNight = <String, Map<String, dynamic>>{};
      for (final d in data) {
        final nightKey = d.dateFrom.toIso8601String().substring(0, 10);
        final duration = d.dateTo.difference(d.dateFrom).inMinutes;
        if (!byNight.containsKey(nightKey) || duration > (byNight[nightKey]!['durationMinutes'] as int)) {
          byNight[nightKey] = {
            'date': nightKey,
            'bedTime': d.dateFrom.toIso8601String(),
            'wakeTime': d.dateTo.toIso8601String(),
            'durationMinutes': duration,
          };
        }
      }

      final result = byNight.values.toList();
      result.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
      return result;
    } catch (e) {
      debugPrint('SleepService: history error: $e');
      return [];
    }
  }

  Map<String, dynamic> _emptySleep(String reason) {
    return {
      'ok': false,
      'reason': reason,
      'bedTime': null,
      'wakeTime': null,
      'durationMinutes': 0,
      'inBedMinutes': 0,
      'asleepMinutes': 0,
      'source': 'none',
    };
  }
}
