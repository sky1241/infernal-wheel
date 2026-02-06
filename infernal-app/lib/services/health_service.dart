// lib/services/health_service.dart
// Service de sante unifie : HealthKit (iOS) + Health Connect (Android)
// Auto-detection reveil via donnees sommeil montre connectee

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../core/infernal_day.dart';

/// Source des donnees de sante
enum HealthSource {
  healthKit,      // iOS (Apple Watch, iPhone)
  healthConnect,  // Android (Wear OS, Samsung, Fitbit, Xiaomi, etc.)
  manual,         // Saisie manuelle (pas de montre)
  unknown,
}

/// Etat de la permission sante
enum HealthPermission {
  notDetermined,  // Jamais demande
  authorized,     // Autorise
  denied,         // Refuse
  unavailable,    // Pas supporte sur cet appareil
}

/// Donnees de sommeil d'une nuit
class SleepSession {
  final DateTime bedTime;      // Heure coucher
  final DateTime wakeTime;     // Heure reveil
  final int durationMinutes;   // Duree totale
  final HealthSource source;   // Source des donnees
  final String? deviceName;    // Nom de la montre/appareil

  const SleepSession({
    required this.bedTime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.source,
    this.deviceName,
  });

  /// Qualite estimee basee sur la duree
  String get qualityEstimate {
    if (durationMinutes < 300) return 'bad';       // < 5h
    if (durationMinutes < 360) return 'poor';      // < 6h
    if (durationMinutes < 420) return 'okay';      // < 7h
    if (durationMinutes < 540) return 'good';      // < 9h
    return 'great';                                 // >= 9h
  }

  Map<String, dynamic> toJson() => {
    'bedTime': bedTime.toIso8601String(),
    'wakeTime': wakeTime.toIso8601String(),
    'durationMinutes': durationMinutes,
    'source': source.name,
    'deviceName': deviceName,
  };

  factory SleepSession.fromJson(Map<String, dynamic> json) {
    return SleepSession(
      bedTime: DateTime.tryParse(json['bedTime'] as String? ?? '') ?? DateTime.now(),
      wakeTime: DateTime.tryParse(json['wakeTime'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.unknown,
      ),
      deviceName: json['deviceName'] as String?,
    );
  }
}

/// Evenement de reveil detecte
class WakeEvent {
  final DateTime wakeTime;
  final HealthSource source;
  final bool isAutoDetected;  // true = montre, false = manuel

  const WakeEvent({
    required this.wakeTime,
    required this.source,
    required this.isAutoDetected,
  });
}

/// Callback quand un reveil est detecte
typedef WakeDetectedCallback = void Function(WakeEvent event);

/// Service de sante principal
class HealthService {
  HealthService._();
  static final HealthService _instance = HealthService._();
  static HealthService get instance => _instance;

  // Etat interne
  HealthSource _source = HealthSource.unknown;
  HealthPermission _permission = HealthPermission.notDetermined;
  bool _isMonitoring = false;
  Timer? _pollTimer;
  DateTime? _lastKnownWakeTime;
  String? _connectedDeviceName;

  // Callbacks
  final List<WakeDetectedCallback> _wakeCallbacks = [];

  /// Source actuelle des donnees
  HealthSource get source => _source;

  /// Permission actuelle
  HealthPermission get permission => _permission;

  /// Est-ce qu'une montre est connectee?
  bool get hasSmartwatch => _source == HealthSource.healthKit || _source == HealthSource.healthConnect;

  /// Nom de l'appareil connecte
  String? get connectedDeviceName => _connectedDeviceName;

  /// Dernier reveil connu
  DateTime? get lastKnownWakeTime => _lastKnownWakeTime;

  /// Initialise le service et detecte la plateforme
  Future<void> initialize() async {
    if (Platform.isIOS) {
      await _initHealthKit();
    } else if (Platform.isAndroid) {
      await _initHealthConnect();
    } else {
      _source = HealthSource.manual;
      _permission = HealthPermission.unavailable;
    }

    debugPrint('[Health] Initialized: source=$_source, permission=$_permission');
  }

  /// Demande les permissions sante
  Future<HealthPermission> requestPermission() async {
    if (_source == HealthSource.manual) {
      return HealthPermission.unavailable;
    }

    try {
      if (Platform.isIOS) {
        _permission = await _requestHealthKitPermission();
      } else if (Platform.isAndroid) {
        _permission = await _requestHealthConnectPermission();
      }
    } catch (e) {
      debugPrint('[Health] Permission request failed: $e');
      _permission = HealthPermission.denied;
    }

    return _permission;
  }

  /// Demarre la surveillance du reveil
  void startWakeMonitoring() {
    if (_isMonitoring) return;
    if (_permission != HealthPermission.authorized) return;

    _isMonitoring = true;

    // Poll toutes les 5 minutes pour detecter le reveil
    _pollTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _checkForWakeUp();
    });

    // Check immediat
    _checkForWakeUp();

    debugPrint('[Health] Wake monitoring started');
  }

  /// Arrete la surveillance
  void stopWakeMonitoring() {
    _isMonitoring = false;
    _pollTimer?.cancel();
    _pollTimer = null;
    debugPrint('[Health] Wake monitoring stopped');
  }

  /// Enregistre un callback pour les reveils detectes
  void onWakeDetected(WakeDetectedCallback callback) {
    _wakeCallbacks.add(callback);
  }

  /// Supprime un callback
  void removeWakeCallback(WakeDetectedCallback callback) {
    _wakeCallbacks.remove(callback);
  }

  /// Recupere les donnees de sommeil pour un jour InfernalWheel
  Future<SleepSession?> getSleepForDay(InfernalDay day) async {
    if (_permission != HealthPermission.authorized) return null;

    try {
      if (Platform.isIOS) {
        return await _getHealthKitSleep(day);
      } else if (Platform.isAndroid) {
        return await _getHealthConnectSleep(day);
      }
    } catch (e) {
      debugPrint('[Health] Failed to get sleep data: $e');
    }

    return null;
  }

  /// Recupere le dernier reveil detecte (aujourd'hui)
  Future<DateTime?> getTodayWakeTime() async {
    final today = InfernalDay.today();
    final sleep = await getSleepForDay(today);
    return sleep?.wakeTime;
  }

  /// Signale un reveil manuel (sans montre)
  void reportManualWake(DateTime wakeTime) {
    _lastKnownWakeTime = wakeTime;
    _notifyWake(WakeEvent(
      wakeTime: wakeTime,
      source: HealthSource.manual,
      isAutoDetected: false,
    ));
  }

  // ============================================================
  // HEALTH KIT (iOS) - Apple Watch, iPhone
  // ============================================================
  // Supporte: Apple Watch Series 1-9, Ultra, SE
  //           iPhone avec app Sante
  // ============================================================

  Future<void> _initHealthKit() async {
    _source = HealthSource.healthKit;
    _permission = HealthPermission.notDetermined;

    // TODO: Avec le package 'health':
    // final health = HealthFactory();
    // final available = await health.hasPermissions([HealthDataType.SLEEP_ASLEEP]);
    // _permission = available == true ? HealthPermission.authorized : HealthPermission.notDetermined;
    //
    // // Detecter Apple Watch
    // final devices = await health.getHealthConnectSdkStatus(); // iOS equivalent
    // _connectedDeviceName = 'Apple Watch';
  }

  Future<HealthPermission> _requestHealthKitPermission() async {
    // TODO: Implementer avec health package
    //
    // final health = HealthFactory();
    // final types = [
    //   HealthDataType.SLEEP_ASLEEP,
    //   HealthDataType.SLEEP_AWAKE,
    //   HealthDataType.SLEEP_IN_BED,
    //   HealthDataType.SLEEP_LIGHT,
    //   HealthDataType.SLEEP_DEEP,
    //   HealthDataType.SLEEP_REM,
    // ];
    // final permissions = types.map((_) => HealthDataAccess.READ).toList();
    // final granted = await health.requestAuthorization(types, permissions: permissions);
    // return granted ? HealthPermission.authorized : HealthPermission.denied;

    return HealthPermission.authorized; // Placeholder
  }

  Future<SleepSession?> _getHealthKitSleep(InfernalDay day) async {
    // TODO: Implementer avec health package
    //
    // final health = HealthFactory();
    // final startTime = day.startTime.subtract(const Duration(hours: 12));
    // final endTime = day.endTime;
    //
    // final data = await health.getHealthDataFromTypes(
    //   startTime,
    //   endTime,
    //   [HealthDataType.SLEEP_ASLEEP],
    // );
    //
    // if (data.isEmpty) return null;
    //
    // // Grouper les sessions et trouver la plus recente
    // data.sort((a, b) => b.dateTo.compareTo(a.dateTo));
    //
    // // Trouver debut et fin de la nuit
    // final sleepStart = data.last.dateFrom;
    // final sleepEnd = data.first.dateTo;
    //
    // return SleepSession(
    //   bedTime: sleepStart,
    //   wakeTime: sleepEnd,
    //   durationMinutes: sleepEnd.difference(sleepStart).inMinutes,
    //   source: HealthSource.healthKit,
    //   deviceName: data.first.sourceName ?? 'Apple Watch',
    // );

    return null; // Placeholder
  }

  // ============================================================
  // HEALTH CONNECT (Android) - Toutes montres Android
  // ============================================================
  // Supporte:
  // - Wear OS (Google Pixel Watch, Samsung Galaxy Watch 4+, TicWatch, etc.)
  // - Samsung Health (Galaxy Watch, Galaxy Fit)
  // - Fitbit (Versa, Sense, Charge, etc.)
  // - Xiaomi/Mi Band (Mi Band, Amazfit)
  // - Huawei (Watch GT, Band)
  // - Garmin (via Health Connect sync)
  // - Withings (ScanWatch, Steel HR)
  // - Oura Ring
  // - Whoop
  // ============================================================

  Future<void> _initHealthConnect() async {
    _source = HealthSource.healthConnect;
    _permission = HealthPermission.notDetermined;

    // TODO: Avec le package 'health':
    // final health = HealthFactory();
    // final status = await health.getHealthConnectSdkStatus();
    //
    // if (status == HealthConnectSdkStatus.sdkUnavailable) {
    //   // Health Connect pas installe
    //   _source = HealthSource.manual;
    //   _permission = HealthPermission.unavailable;
    //   return;
    // }
    //
    // if (status == HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
    //   // Mise a jour necessaire
    //   debugPrint('[Health] Health Connect needs update');
    // }
  }

  Future<HealthPermission> _requestHealthConnectPermission() async {
    // TODO: Implementer avec health package
    //
    // final health = HealthFactory();
    // final types = [
    //   HealthDataType.SLEEP_SESSION,
    //   HealthDataType.SLEEP_ASLEEP,
    //   HealthDataType.SLEEP_AWAKE,
    //   HealthDataType.SLEEP_LIGHT,
    //   HealthDataType.SLEEP_DEEP,
    //   HealthDataType.SLEEP_REM,
    // ];
    // final permissions = types.map((_) => HealthDataAccess.READ).toList();
    // final granted = await health.requestAuthorization(types, permissions: permissions);
    // return granted ? HealthPermission.authorized : HealthPermission.denied;

    return HealthPermission.authorized; // Placeholder
  }

  Future<SleepSession?> _getHealthConnectSleep(InfernalDay day) async {
    // TODO: Implementer avec health package
    //
    // final health = HealthFactory();
    // final startTime = day.startTime.subtract(const Duration(hours: 12));
    // final endTime = day.endTime;
    //
    // // Health Connect utilise SLEEP_SESSION pour les sessions completes
    // final sessions = await health.getHealthDataFromTypes(
    //   startTime,
    //   endTime,
    //   [HealthDataType.SLEEP_SESSION],
    // );
    //
    // if (sessions.isEmpty) {
    //   // Fallback sur SLEEP_ASLEEP
    //   final asleep = await health.getHealthDataFromTypes(
    //     startTime,
    //     endTime,
    //     [HealthDataType.SLEEP_ASLEEP],
    //   );
    //   if (asleep.isEmpty) return null;
    //   sessions.addAll(asleep);
    // }
    //
    // sessions.sort((a, b) => b.dateTo.compareTo(a.dateTo));
    // final latest = sessions.first;
    //
    // return SleepSession(
    //   bedTime: latest.dateFrom,
    //   wakeTime: latest.dateTo,
    //   durationMinutes: latest.dateTo.difference(latest.dateFrom).inMinutes,
    //   source: HealthSource.healthConnect,
    //   deviceName: latest.sourceName,
    // );

    return null; // Placeholder
  }

  // ============================================================
  // DETECTION REVEIL AUTOMATIQUE
  // ============================================================

  Future<void> _checkForWakeUp() async {
    if (!_isMonitoring) return;

    final today = InfernalDay.today();

    try {
      final sleep = await getSleepForDay(today);
      if (sleep == null) return;

      // Nouveau reveil detecte?
      if (_lastKnownWakeTime == null || sleep.wakeTime.isAfter(_lastKnownWakeTime!)) {
        // Verifier que c'est bien aujourd'hui (jour InfernalWheel)
        if (today.contains(sleep.wakeTime)) {
          _lastKnownWakeTime = sleep.wakeTime;
          _notifyWake(WakeEvent(
            wakeTime: sleep.wakeTime,
            source: _source,
            isAutoDetected: true,
          ));
        }
      }
    } catch (e) {
      debugPrint('[Health] Wake check failed: $e');
    }
  }

  void _notifyWake(WakeEvent event) {
    debugPrint('[Health] Wake detected: ${event.wakeTime} (auto=${event.isAutoDetected})');
    for (final callback in _wakeCallbacks) {
      try {
        callback(event);
      } catch (e) {
        debugPrint('[Health] Callback error: $e');
      }
    }
  }

  /// Libere les ressources
  void dispose() {
    stopWakeMonitoring();
    _wakeCallbacks.clear();
  }
}

/// Extension pour faciliter l'acces au service
extension HealthServiceX on HealthService {
  /// Verifie si le service est pret a etre utilise
  bool get isReady => permission == HealthPermission.authorized;

  /// Description de la source actuelle
  String get sourceDescription {
    switch (source) {
      case HealthSource.healthKit:
        return connectedDeviceName ?? 'Apple Watch';
      case HealthSource.healthConnect:
        return connectedDeviceName ?? 'Montre Android';
      case HealthSource.manual:
        return 'Saisie manuelle';
      case HealthSource.unknown:
        return 'Non configure';
    }
  }

  /// Liste des montres supportees (pour affichage)
  static const List<String> supportedWatches = [
    // iOS
    'Apple Watch (toutes series)',
    // Wear OS
    'Google Pixel Watch',
    'Samsung Galaxy Watch 4/5/6',
    'TicWatch Pro/E',
    'Fossil Gen 6',
    'Mobvoi',
    // Samsung
    'Samsung Galaxy Watch (toutes)',
    'Samsung Galaxy Fit',
    // Fitbit
    'Fitbit Versa/Sense',
    'Fitbit Charge',
    'Fitbit Luxe/Inspire',
    // Xiaomi
    'Xiaomi Mi Band',
    'Amazfit GTR/GTS/Bip',
    // Huawei
    'Huawei Watch GT/Fit',
    'Huawei Band',
    // Autres
    'Garmin (via Health Connect)',
    'Withings ScanWatch/Steel HR',
    'Oura Ring',
    'Whoop',
  ];
}
