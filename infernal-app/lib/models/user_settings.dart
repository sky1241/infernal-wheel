import 'addiction.dart';

/// Configuration utilisateur
class UserSettings {
  /// Addictions actives
  List<AddictionType> enabledAddictions;

  /// Objectif sommeil en heures
  double sleepGoalHours;

  /// Utiliser les donnees de la montre si disponible
  bool useHealthData;

  /// Permettre saisie manuelle si pas de montre
  bool allowManualFallback;

  /// Theme sombre (toujours true pour l'instant)
  bool darkMode;

  /// Premiere utilisation terminee
  bool onboardingComplete;

  UserSettings({
    List<AddictionType>? enabledAddictions,
    this.sleepGoalHours = 8.0,
    this.useHealthData = true,
    this.allowManualFallback = true,
    this.darkMode = true,
    this.onboardingComplete = false,
  }) : enabledAddictions = enabledAddictions ??
      AddictionType.values.where((t) => t.isDefault).toList();

  /// Settings par defaut
  factory UserSettings.defaults() => UserSettings();

  /// Toggle une addiction
  void toggleAddiction(AddictionType type) {
    if (enabledAddictions.contains(type)) {
      enabledAddictions.remove(type);
    } else {
      enabledAddictions.add(type);
    }
  }

  /// Objectif sommeil en minutes
  int get sleepGoalMinutes => (sleepGoalHours * 60).round();

  /// Serialization
  Map<String, dynamic> toJson() => {
    'enabledAddictions': enabledAddictions.map((a) => a.id).toList(),
    'sleepGoalHours': sleepGoalHours,
    'useHealthData': useHealthData,
    'allowManualFallback': allowManualFallback,
    'darkMode': darkMode,
    'onboardingComplete': onboardingComplete,
  };

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    final addictionIds = (json['enabledAddictions'] as List?)?.cast<String>() ?? [];
    return UserSettings(
      enabledAddictions: addictionIds
          .map((id) => AddictionType.values.where((t) => t.id == id).firstOrNull)
          .whereType<AddictionType>()
          .toList(),
      sleepGoalHours: (json['sleepGoalHours'] as num?)?.toDouble() ?? 8.0,
      useHealthData: json['useHealthData'] ?? true,
      allowManualFallback: json['allowManualFallback'] ?? true,
      darkMode: json['darkMode'] ?? true,
      onboardingComplete: json['onboardingComplete'] ?? false,
    );
  }
}
