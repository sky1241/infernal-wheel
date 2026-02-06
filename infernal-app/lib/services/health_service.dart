import 'dart:io';
import '../models/sleep_data.dart';

// Note: Necessite le package 'health' dans pubspec.yaml
// health: ^4.4.0

/// Service pour integrer HealthKit (iOS) et Health Connect (Android)
class HealthService {
  // En production, utiliser le package 'health'
  // import 'package:health/health.dart';
  // final HealthFactory _health = HealthFactory();

  bool _isAuthorized = false;

  /// Platform actuelle
  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  /// Verifier si les donnees sante sont disponibles
  Future<bool> isAvailable() async {
    // Sur iOS: HealthKit toujours dispo
    // Sur Android: Health Connect doit etre installe
    return true; // Simplification pour le code de base
  }

  /// Demander les permissions
  Future<bool> requestAuthorization() async {
    // Types qu'on veut lire
    // final types = [
    //   HealthDataType.SLEEP_ASLEEP,
    //   HealthDataType.SLEEP_IN_BED,
    //   HealthDataType.HEART_RATE, // Optionnel
    // ];
    //
    // final permissions = types.map((t) => HealthDataAccess.READ).toList();
    // _isAuthorized = await _health.requestAuthorization(types, permissions: permissions);

    _isAuthorized = true; // Placeholder
    return _isAuthorized;
  }

  bool get isAuthorized => _isAuthorized;

  /// Recuperer le sommeil de la nuit derniere
  Future<SleepData?> fetchLastNightSleep({int goalMinutes = 480}) async {
    if (!_isAuthorized) return null;

    // final now = DateTime.now();
    // final yesterday = now.subtract(Duration(hours: 24));
    //
    // // Recuperer les donnees de sommeil
    // final sleepData = await _health.getHealthDataFromTypes(
    //   yesterday,
    //   now,
    //   [HealthDataType.SLEEP_ASLEEP],
    // );
    //
    // if (sleepData.isEmpty) return null;
    //
    // // Trouver debut et fin du sommeil
    // final sorted = sleepData..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    // final bedTime = sorted.first.dateFrom;
    // final wakeTime = sorted.last.dateTo;
    //
    // return SleepData.fromHealth(
    //   bedTime: bedTime,
    //   wakeTime: wakeTime,
    //   isApple: isIOS,
    //   goalMinutes: goalMinutes,
    // );

    // Placeholder pour le dev
    return null;
  }

  /// Verifier si on a des donnees recentes
  Future<bool> hasRecentData() async {
    final sleep = await fetchLastNightSleep();
    return sleep != null;
  }
}

/// Extension pour creer des donnees manuelles
extension HealthServiceManual on HealthService {
  SleepData createManualSleep({
    required DateTime wakeTime,
    required double estimatedHours,
    int goalMinutes = 480,
  }) {
    return SleepData.manual(
      wakeTime: wakeTime,
      estimatedHours: estimatedHours,
      goalMinutes: goalMinutes,
    );
  }
}
