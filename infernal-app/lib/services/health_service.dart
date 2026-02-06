import 'dart:io';
import '../core/logger.dart';
import '../models/sleep_data.dart';

/// Service pour integrer HealthKit (iOS) et Health Connect (Android)
///
/// INFRASTRUCTURE SEULEMENT - pas de connexion active.
/// Le code commente montre comment implementer avec le package 'health'.
///
/// Compatible:
/// - Apple Watch via HealthKit (iOS)
/// - Montres Android via Health Connect
/// - Fallback manuel si pas de montre
class HealthService {
  // En production, decommenter et utiliser le package 'health'
  // import 'package:health/health.dart';
  // final HealthFactory _health = HealthFactory();

  bool _isAuthorized = false;
  bool _isInitialized = false;

  /// True si le service est initialise
  bool get isInitialized => _isInitialized;

  /// True si les permissions sont accordees
  bool get isAuthorized => _isAuthorized;

  /// Platform actuelle
  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  /// Nom de la source selon la plateforme
  String get sourceName {
    if (isIOS) return 'HealthKit (Apple)';
    if (isAndroid) return 'Health Connect (Android)';
    return 'Unknown';
  }

  /// Initialiser le service
  Future<void> init() async {
    if (_isInitialized) return;

    Log.info('HEALTH', 'Initializing', data: {'platform': sourceName});

    // Verifier disponibilite
    final available = await isAvailable();
    if (!available) {
      Log.warn('HEALTH', 'Health data not available on this device');
    }

    _isInitialized = true;
    Log.info('HEALTH', 'Initialized', data: {'available': available});
  }

  /// Verifier si les donnees sante sont disponibles
  Future<bool> isAvailable() async {
    try {
      // Sur iOS: HealthKit toujours disponible
      if (isIOS) {
        return true;
      }

      // Sur Android: Health Connect doit etre installe
      if (isAndroid) {
        // TODO: Verifier si Health Connect est installe
        // return await _health.isHealthConnectAvailable();
        return true; // Placeholder
      }

      return false;
    } catch (e) {
      Log.error('HEALTH', 'isAvailable check failed', error: e);
      return false;
    }
  }

  /// Demander les permissions
  Future<bool> requestAuthorization() async {
    if (_isAuthorized) return true;

    Log.info('HEALTH', 'Requesting authorization');

    try {
      // Types qu'on veut lire (sommeil uniquement)
      // final types = [
      //   HealthDataType.SLEEP_ASLEEP,
      //   HealthDataType.SLEEP_IN_BED,
      // ];
      //
      // final permissions = types.map((t) => HealthDataAccess.READ).toList();
      // _isAuthorized = await _health.requestAuthorization(types, permissions: permissions);

      _isAuthorized = true; // Placeholder - a remplacer en prod

      Log.info('HEALTH', 'Authorization result', data: {'granted': _isAuthorized});
      return _isAuthorized;
    } catch (e, stack) {
      Log.error('HEALTH', 'Authorization failed', error: e, stack: stack);
      _isAuthorized = false;
      return false;
    }
  }

  /// Recuperer le sommeil de la nuit derniere
  ///
  /// Retourne null si:
  /// - Pas autorise
  /// - Pas de donnees
  /// - Erreur
  Future<SleepData?> fetchLastNightSleep({int goalMinutes = 480}) async {
    if (!_isAuthorized) {
      Log.warn('HEALTH', 'Cannot fetch sleep - not authorized');
      return null;
    }

    Log.debug('HEALTH', 'Fetching last night sleep');

    try {
      // final now = DateTime.now();
      // final yesterday = now.subtract(const Duration(hours: 24));
      //
      // // Recuperer les donnees de sommeil
      // final sleepData = await _health.getHealthDataFromTypes(
      //   yesterday,
      //   now,
      //   [HealthDataType.SLEEP_ASLEEP],
      // );
      //
      // if (sleepData.isEmpty) {
      //   Log.info('HEALTH', 'No sleep data found');
      //   return null;
      // }
      //
      // // Trouver debut et fin du sommeil
      // final sorted = sleepData..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
      // final bedTime = sorted.first.dateFrom;
      // final wakeTime = sorted.last.dateTo;
      //
      // final result = SleepData.fromHealth(
      //   bedTime: bedTime,
      //   wakeTime: wakeTime,
      //   isApple: isIOS,
      //   goalMinutes: goalMinutes,
      // );
      //
      // Log.info('HEALTH', 'Sleep data fetched', data: {
      //   'duration': result.durationFormatted,
      //   'quality': result.quality.label,
      // });
      //
      // return result;

      // Placeholder - pas de connexion reelle
      Log.debug('HEALTH', 'Placeholder mode - returning null');
      return null;
    } catch (e, stack) {
      Log.error('HEALTH', 'Fetch sleep failed', error: e, stack: stack);
      return null;
    }
  }

  /// Verifier si on a des donnees recentes
  Future<bool> hasRecentData() async {
    final sleep = await fetchLastNightSleep();
    return sleep != null;
  }

  /// Creer des donnees de sommeil manuelles
  ///
  /// Utilise quand:
  /// - Pas de montre connectee
  /// - Permission refusee
  /// - Pas de donnees disponibles
  SleepData createManualSleep({
    required DateTime wakeTime,
    required double estimatedHours,
    int goalMinutes = 480,
  }) {
    Log.info('HEALTH', 'Creating manual sleep', data: {
      'wakeTime': wakeTime.toIso8601String(),
      'hours': estimatedHours,
    });

    return SleepData.manual(
      wakeTime: wakeTime,
      estimatedHours: estimatedHours,
      goalMinutes: goalMinutes,
    );
  }

  /// Reset les permissions (pour tests/debug)
  void resetAuthorization() {
    _isAuthorized = false;
    Log.debug('HEALTH', 'Authorization reset');
  }
}
