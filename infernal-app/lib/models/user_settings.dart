import '../core/logger.dart';
import 'addiction.dart';

/// Configuration utilisateur
///
/// Stocke localement, jamais envoyee a l'exterieur.
class UserSettings {
  /// Addictions actives
  List<AddictionType> enabledAddictions;

  /// Objectif sommeil en heures (entre 4 et 12)
  double _sleepGoalHours;

  /// Utiliser les donnees de la montre si disponible
  bool useHealthData;

  /// Permettre saisie manuelle si pas de montre
  bool allowManualFallback;

  /// Theme sombre (toujours true pour l'instant)
  bool darkMode;

  /// Premiere utilisation terminee
  bool onboardingComplete;

  /// Limites
  static const double minSleepGoal = 4.0;
  static const double maxSleepGoal = 12.0;
  static const double defaultSleepGoal = 8.0;

  UserSettings({
    List<AddictionType>? enabledAddictions,
    double sleepGoalHours = defaultSleepGoal,
    this.useHealthData = true,
    this.allowManualFallback = true,
    this.darkMode = true,
    this.onboardingComplete = false,
  })  : enabledAddictions = enabledAddictions ??
            AddictionType.values.where((t) => t.isDefault).toList(),
        _sleepGoalHours = sleepGoalHours.clamp(minSleepGoal, maxSleepGoal);

  /// Objectif sommeil en heures
  double get sleepGoalHours => _sleepGoalHours;

  set sleepGoalHours(double value) {
    _sleepGoalHours = value.clamp(minSleepGoal, maxSleepGoal);
  }

  /// Settings par defaut
  factory UserSettings.defaults() => UserSettings();

  /// Toggle une addiction
  void toggleAddiction(AddictionType type) {
    if (enabledAddictions.contains(type)) {
      enabledAddictions.remove(type);
      Log.debug('SETTINGS', 'Addiction disabled', data: {'type': type.id});
    } else {
      enabledAddictions.add(type);
      Log.debug('SETTINGS', 'Addiction enabled', data: {'type': type.id});
    }
  }

  /// Activer une addiction
  void enableAddiction(AddictionType type) {
    if (!enabledAddictions.contains(type)) {
      enabledAddictions.add(type);
    }
  }

  /// Desactiver une addiction
  void disableAddiction(AddictionType type) {
    enabledAddictions.remove(type);
  }

  /// Verifier si une addiction est active
  bool isEnabled(AddictionType type) => enabledAddictions.contains(type);

  /// Objectif sommeil en minutes
  int get sleepGoalMinutes => (_sleepGoalHours * 60).round();

  /// Serialization JSON
  Map<String, dynamic> toJson() => {
        'enabledAddictions': enabledAddictions.map((a) => a.id).toList(),
        'sleepGoalHours': _sleepGoalHours,
        'useHealthData': useHealthData,
        'allowManualFallback': allowManualFallback,
        'darkMode': darkMode,
        'onboardingComplete': onboardingComplete,
      };

  /// Deserialization avec guards
  factory UserSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      Log.warn('SETTINGS', 'Null json, using defaults');
      return UserSettings.defaults();
    }

    try {
      // Parse addictions avec fallback
      List<AddictionType> addictions;
      final addictionsRaw = json['enabledAddictions'];
      if (addictionsRaw is List) {
        addictions = addictionsRaw
            .whereType<String>()
            .map((id) => AddictionType.fromId(id))
            .whereType<AddictionType>()
            .toList();
        // Si liste vide, utiliser les defaults
        if (addictions.isEmpty) {
          addictions = AddictionType.values.where((t) => t.isDefault).toList();
        }
      } else {
        addictions = AddictionType.values.where((t) => t.isDefault).toList();
      }

      // Parse sleepGoalHours
      final rawSleepGoal = json['sleepGoalHours'];
      final sleepGoalHours = (rawSleepGoal is num)
          ? rawSleepGoal.toDouble()
          : UserSettings.defaultSleepGoal;

      return UserSettings(
        enabledAddictions: addictions,
        sleepGoalHours: sleepGoalHours,
        useHealthData: json['useHealthData'] as bool? ?? true,
        allowManualFallback: json['allowManualFallback'] as bool? ?? true,
        darkMode: json['darkMode'] as bool? ?? true,
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      );
    } catch (e, stack) {
      Log.error('SETTINGS', 'Parse failed, using defaults', error: e, stack: stack);
      return UserSettings.defaults();
    }
  }

  @override
  String toString() =>
      'UserSettings(addictions: ${enabledAddictions.length}, sleep: ${_sleepGoalHours}h)';
}
