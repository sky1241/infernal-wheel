import 'package:flutter/material.dart';

/// Types d'addictions supportees
enum AddictionType {
  tabac('tabac', '🚬', 'Cigarettes', Color(0xFFFF4D4D)),
  alcoolBiere('biere', '🍺', 'Bieres', Color(0xFFC4722A)),
  alcoolVin('vin', '🍷', 'Verres vin', Color(0xFF8B4557)),
  alcoolFort('fort', '🥃', 'Alcool fort', Color(0xFFC4722A)),
  jeuxVideo('jeux', '🎮', 'Heures jeux', Color(0xFF9966FF)),
  porn('porn', '🔞', 'Sessions', Color(0xFFFF3399)), // Icone SVG custom dispo
  drogues('drogues', '💉', 'Prises', Color(0xFF333333)),
  reseauxSociaux('social', '📱', 'Heures', Color(0xFF1DA1F2)),
  sucre('sucre', '🍬', 'Sucreries', Color(0xFFFF69B4)),
  cafe('cafe', '☕', 'Cafes', Color(0xFF6F4E37));

  const AddictionType(this.id, this.emoji, this.label, this.color);

  final String id;
  final String emoji;
  final String label;
  final Color color;

  /// True si c'est une addiction activee par defaut
  bool get isDefault => this == tabac || this == alcoolBiere || this == alcoolVin || this == alcoolFort;

  /// Couleur pour le fond (opacity)
  Color get backgroundColor => color.withOpacity(0.12);

  /// Couleur pour la bordure
  Color get borderColor => color.withOpacity(0.4);
}

/// Entree d'addiction pour une journee
class AddictionEntry {
  final AddictionType type;
  int count;
  DateTime? firstTime; // Heure de la premiere de la journee

  AddictionEntry({
    required this.type,
    this.count = 0,
    this.firstTime,
  });

  /// Incrementer le compteur
  void increment() {
    count++;
    firstTime ??= DateTime.now();
  }

  /// Decrementer le compteur
  void decrement() {
    if (count > 0) {
      count--;
      if (count == 0) firstTime = null;
    }
  }

  /// Delai depuis le reveil (en minutes)
  int? delayFromWake(DateTime? wakeTime) {
    if (firstTime == null || wakeTime == null) return null;
    return firstTime!.difference(wakeTime).inMinutes;
  }

  /// Serialization JSON
  Map<String, dynamic> toJson() => {
    'type': type.id,
    'count': count,
    'firstTime': firstTime?.toIso8601String(),
  };

  factory AddictionEntry.fromJson(Map<String, dynamic> json) {
    final typeId = json['type'] as String;
    final type = AddictionType.values.firstWhere((t) => t.id == typeId);
    return AddictionEntry(
      type: type,
      count: json['count'] as int? ?? 0,
      firstTime: json['firstTime'] != null ? DateTime.parse(json['firstTime']) : null,
    );
  }
}
