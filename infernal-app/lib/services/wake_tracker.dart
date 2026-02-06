// lib/services/wake_tracker.dart
// Tracker de reveil : gere la logique metier du reveil quotidien

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/infernal_day.dart';
import 'health_service.dart';

/// Etat du tracker de reveil
enum WakeState {
  unknown,      // Pas encore d'info
  sleeping,     // En train de dormir (suppose)
  awake,        // Reveille (confirme)
  waiting,      // En attente de confirmation manuelle
}

/// Tracker de reveil quotidien
class WakeTracker {
  WakeTracker._();
  static final WakeTracker _instance = WakeTracker._();
  static WakeTracker get instance => _instance;

  final HealthService _health = HealthService.instance;

  // Etat
  WakeState _state = WakeState.unknown;
  DateTime? _todayWakeTime;
  InfernalDay? _lastCheckedDay;
  bool _initialized = false;

  // Callbacks
  final List<VoidCallback> _stateCallbacks = [];

  /// Etat actuel
  WakeState get state => _state;

  /// Heure de reveil du jour (null si pas encore reveille)
  DateTime? get todayWakeTime => _todayWakeTime;

  /// Minutes depuis le reveil (null si pas reveille)
  int? get minutesSinceWake {
    if (_todayWakeTime == null) return null;
    return DateTime.now().difference(_todayWakeTime!).inMinutes;
  }

  /// Est reveille aujourd'hui?
  bool get isAwakeToday => _state == WakeState.awake && _todayWakeTime != null;

  /// Initialise le tracker
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialiser le service de sante
    await _health.initialize();

    // Ecouter les reveils detectes automatiquement
    _health.onWakeDetected(_onWakeDetected);

    // Verifier si deja reveille aujourd'hui
    await _checkTodayWake();

    // Demarrer la surveillance si autorise
    if (_health.permission == HealthPermission.authorized) {
      _health.startWakeMonitoring();
    }

    _initialized = true;
    debugPrint('[WakeTracker] Initialized: state=$_state, wakeTime=$_todayWakeTime');
  }

  /// Demande les permissions et demarre la surveillance
  Future<bool> requestPermissionAndStart() async {
    final permission = await _health.requestPermission();

    if (permission == HealthPermission.authorized) {
      _health.startWakeMonitoring();
      await _checkTodayWake();
      return true;
    }

    // Pas de montre ou refuse → mode manuel
    _state = WakeState.waiting;
    _notifyStateChange();
    return false;
  }

  /// Signale un reveil manuel
  void reportManualWake([DateTime? wakeTime]) {
    final time = wakeTime ?? DateTime.now();
    final today = InfernalDay.today();

    // Verifier que c'est bien aujourd'hui
    if (!today.contains(time)) {
      debugPrint('[WakeTracker] Manual wake rejected: not today');
      return;
    }

    _todayWakeTime = time;
    _state = WakeState.awake;
    _lastCheckedDay = today;

    _health.reportManualWake(time);
    _notifyStateChange();

    debugPrint('[WakeTracker] Manual wake reported: $time');
  }

  /// Reset pour nouveau jour (appele a 4h ou au changement de jour)
  void resetForNewDay() {
    final today = InfernalDay.today();

    if (_lastCheckedDay != today) {
      _todayWakeTime = null;
      _state = _health.hasSmartwatch ? WakeState.sleeping : WakeState.waiting;
      _lastCheckedDay = today;
      _notifyStateChange();

      debugPrint('[WakeTracker] Reset for new day: ${today.key}');
    }
  }

  /// Enregistre un callback pour les changements d'etat
  void addStateListener(VoidCallback callback) {
    _stateCallbacks.add(callback);
  }

  /// Supprime un callback
  void removeStateListener(VoidCallback callback) {
    _stateCallbacks.remove(callback);
  }

  /// Verifie le reveil du jour
  Future<void> _checkTodayWake() async {
    final today = InfernalDay.today();

    // Nouveau jour?
    if (_lastCheckedDay != today) {
      resetForNewDay();
    }

    // Deja reveille?
    if (_todayWakeTime != null) return;

    // Essayer de recuperer depuis la montre
    final wakeTime = await _health.getTodayWakeTime();
    if (wakeTime != null && today.contains(wakeTime)) {
      _todayWakeTime = wakeTime;
      _state = WakeState.awake;
      _notifyStateChange();
      debugPrint('[WakeTracker] Found wake time from health: $wakeTime');
    }
  }

  /// Callback quand un reveil est detecte
  void _onWakeDetected(WakeEvent event) {
    final today = InfernalDay.today();

    // Ignorer si pas aujourd'hui
    if (!today.contains(event.wakeTime)) return;

    // Ignorer si deja un reveil plus tot
    if (_todayWakeTime != null && event.wakeTime.isAfter(_todayWakeTime!)) return;

    _todayWakeTime = event.wakeTime;
    _state = WakeState.awake;
    _lastCheckedDay = today;
    _notifyStateChange();

    debugPrint('[WakeTracker] Wake detected: ${event.wakeTime} (auto=${event.isAutoDetected})');
  }

  void _notifyStateChange() {
    for (final callback in _stateCallbacks) {
      try {
        callback();
      } catch (e) {
        debugPrint('[WakeTracker] Callback error: $e');
      }
    }
  }

  /// Libere les ressources
  void dispose() {
    _health.removeWakeCallback(_onWakeDetected);
    _stateCallbacks.clear();
  }
}

/// Extension pour les calculs de temps
extension WakeTrackerTime on WakeTracker {
  /// Formate le temps depuis le reveil (ex: "2h15")
  String? get formattedTimeSinceWake {
    final minutes = minutesSinceWake;
    if (minutes == null) return null;

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0) {
      return '${hours}h${mins.toString().padLeft(2, '0')}';
    }
    return '${mins}min';
  }

  /// Formate l'heure de reveil (ex: "07:30")
  String? get formattedWakeTime {
    if (todayWakeTime == null) return null;
    final h = todayWakeTime!.hour.toString().padLeft(2, '0');
    final m = todayWakeTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
