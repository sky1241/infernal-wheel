// lib/services/addiction_tracker.dart
// Tracker d'addictions : cigarettes, alcool, etc.
// Calcule les deltas depuis le reveil automatiquement

import 'package:flutter/foundation.dart';
import '../core/infernal_day.dart';
import 'wake_tracker.dart';

/// Type d'addiction trackee
enum AddictionType {
  cigarette('cigarette', 'Cigarette', '🚬'),
  beer('beer', 'Biere', '🍺'),
  wine('wine', 'Vin', '🍷'),
  spirits('spirits', 'Alcool fort', '🥃');

  final String id;
  final String label;
  final String emoji;

  const AddictionType(this.id, this.label, this.emoji);

  static AddictionType? fromId(String id) {
    for (final type in values) {
      if (type.id == id) return type;
    }
    return null;
  }
}

/// Evenement d'addiction (une consommation)
class AddictionEvent {
  final AddictionType type;
  final DateTime timestamp;
  final int count;
  final String dayKey;

  AddictionEvent({
    required this.type,
    required this.timestamp,
    this.count = 1,
  }) : dayKey = timestamp.infernalDayKey;

  Map<String, dynamic> toJson() => {
    'type': type.id,
    'timestamp': timestamp.toIso8601String(),
    'count': count,
    'dayKey': dayKey,
  };

  factory AddictionEvent.fromJson(Map<String, dynamic> json) {
    return AddictionEvent(
      type: AddictionType.fromId(json['type'] as String? ?? '') ?? AddictionType.cigarette,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      count: (json['count'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Stats d'une addiction pour un jour
class DailyAddictionStats {
  final AddictionType type;
  final InfernalDay day;
  final int totalCount;
  final DateTime? firstTime;
  final DateTime? lastTime;
  final int? minutesFromWake;  // Minutes entre reveil et premiere conso

  const DailyAddictionStats({
    required this.type,
    required this.day,
    required this.totalCount,
    this.firstTime,
    this.lastTime,
    this.minutesFromWake,
  });

  /// Aucune consommation
  bool get isClean => totalCount == 0;

  /// Difference avec hier (positif = plus tot, negatif = plus tard)
  int? compareTo(DailyAddictionStats? yesterday) {
    if (yesterday == null) return null;
    if (minutesFromWake == null || yesterday.minutesFromWake == null) return null;
    return yesterday.minutesFromWake! - minutesFromWake!;
  }
}

/// Tracker d'addictions
class AddictionTracker {
  AddictionTracker._();
  static final AddictionTracker _instance = AddictionTracker._();
  static AddictionTracker get instance => _instance;

  final WakeTracker _wakeTracker = WakeTracker.instance;

  // Events stockes en memoire (sera persist par StorageService)
  final List<AddictionEvent> _events = [];

  // Callbacks
  final List<VoidCallback> _changeCallbacks = [];

  /// Tous les evenements
  List<AddictionEvent> get events => List.unmodifiable(_events);

  /// Ajoute une consommation
  void add(AddictionType type, {int count = 1, DateTime? timestamp}) {
    final time = timestamp ?? DateTime.now();
    final event = AddictionEvent(type: type, timestamp: time, count: count);
    _events.add(event);
    _notifyChange();
    debugPrint('[AddictionTracker] Added: ${type.id} x$count at $time');
  }

  /// Retire la derniere consommation d'un type (aujourd'hui)
  bool removeLast(AddictionType type) {
    final today = InfernalDay.today();

    // Trouver le dernier event de ce type aujourd'hui
    for (int i = _events.length - 1; i >= 0; i--) {
      final event = _events[i];
      if (event.type == type && event.dayKey == today.key) {
        _events.removeAt(i);
        _notifyChange();
        debugPrint('[AddictionTracker] Removed last: ${type.id}');
        return true;
      }
    }
    return false;
  }

  /// Compte pour un type aujourd'hui
  int getTodayCount(AddictionType type) {
    final today = InfernalDay.today();
    return _events
        .where((e) => e.type == type && e.dayKey == today.key)
        .fold(0, (sum, e) => sum + e.count);
  }

  /// Premier evenement d'un type aujourd'hui
  DateTime? getFirstToday(AddictionType type) {
    final today = InfernalDay.today();
    final todayEvents = _events
        .where((e) => e.type == type && e.dayKey == today.key)
        .toList();
    if (todayEvents.isEmpty) return null;
    todayEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return todayEvents.first.timestamp;
  }

  /// Minutes depuis le reveil jusqu'a la premiere conso
  int? getMinutesFromWakeToday(AddictionType type) {
    final wakeTime = _wakeTracker.todayWakeTime;
    final firstTime = getFirstToday(type);

    if (wakeTime == null || firstTime == null) return null;
    if (firstTime.isBefore(wakeTime)) return null;  // Conso avant reveil?

    return firstTime.difference(wakeTime).inMinutes;
  }

  /// Stats pour un jour
  DailyAddictionStats getStatsForDay(AddictionType type, InfernalDay day) {
    final dayEvents = _events
        .where((e) => e.type == type && e.dayKey == day.key)
        .toList();

    if (dayEvents.isEmpty) {
      return DailyAddictionStats(type: type, day: day, totalCount: 0);
    }

    dayEvents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final firstTime = dayEvents.first.timestamp;
    final lastTime = dayEvents.last.timestamp;
    final totalCount = dayEvents.fold(0, (sum, e) => sum + e.count);

    // Calculer minutes depuis reveil (si jour actuel)
    int? minutesFromWake;
    if (day == InfernalDay.today()) {
      minutesFromWake = getMinutesFromWakeToday(type);
    }

    return DailyAddictionStats(
      type: type,
      day: day,
      totalCount: totalCount,
      firstTime: firstTime,
      lastTime: lastTime,
      minutesFromWake: minutesFromWake,
    );
  }

  /// Stats aujourd'hui vs hier
  ({DailyAddictionStats today, DailyAddictionStats yesterday, int? delta})
  getTodayVsYesterday(AddictionType type) {
    final today = InfernalDay.today();
    final yesterday = today.previous;

    final todayStats = getStatsForDay(type, today);
    final yesterdayStats = getStatsForDay(type, yesterday);
    final delta = todayStats.compareTo(yesterdayStats);

    return (today: todayStats, yesterday: yesterdayStats, delta: delta);
  }

  /// Temps ecoule depuis derniere consommation (en minutes eveil)
  int? getAwakeMinutesSinceLast(AddictionType type) {
    final wakeTime = _wakeTracker.todayWakeTime;
    if (wakeTime == null) return null;

    // Trouver la derniere conso (toutes periodes)
    final typeEvents = _events.where((e) => e.type == type).toList();
    if (typeEvents.isEmpty) return null;

    typeEvents.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final lastTime = typeEvents.first.timestamp;

    // Si derniere conso avant reveil → compter depuis reveil
    if (lastTime.isBefore(wakeTime)) {
      return DateTime.now().difference(wakeTime).inMinutes;
    }

    return DateTime.now().difference(lastTime).inMinutes;
  }

  /// Charge les events depuis le stockage
  void loadEvents(List<AddictionEvent> events) {
    _events.clear();
    _events.addAll(events);
    debugPrint('[AddictionTracker] Loaded ${events.length} events');
  }

  /// Exporte les events pour stockage
  List<Map<String, dynamic>> exportEvents() {
    return _events.map((e) => e.toJson()).toList();
  }

  /// Enregistre un callback
  void addChangeListener(VoidCallback callback) {
    _changeCallbacks.add(callback);
  }

  void removeChangeListener(VoidCallback callback) {
    _changeCallbacks.remove(callback);
  }

  void _notifyChange() {
    for (final callback in _changeCallbacks) {
      try {
        callback();
      } catch (e) {
        debugPrint('[AddictionTracker] Callback error: $e');
      }
    }
  }

  /// Nettoie les vieux events (> 90 jours)
  void cleanup({int keepDays = 90}) {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    final before = _events.length;
    _events.removeWhere((e) => e.timestamp.isBefore(cutoff));
    final removed = before - _events.length;
    if (removed > 0) {
      debugPrint('[AddictionTracker] Cleaned up $removed old events');
    }
  }
}

/// Extension pour le formatage
extension AddictionTrackerFormat on AddictionTracker {
  /// Formate le delta (ex: "+15min" ou "-30min")
  String? formatDelta(int? delta) {
    if (delta == null) return null;
    final sign = delta > 0 ? '+' : '';
    return '$sign${delta}min';
  }

  /// Formate le temps ecoule (ex: "2h15 sans")
  String? formatTimeSince(AddictionType type) {
    final minutes = getAwakeMinutesSinceLast(type);
    if (minutes == null) return null;

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '${hours}h${mins.toString().padLeft(2, '0')} sans ${type.emoji}';
    }
    return '${mins}min sans ${type.emoji}';
  }
}
