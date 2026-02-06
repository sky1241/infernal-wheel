import 'package:flutter/material.dart';
import '../core/logger.dart';

/// Types d'addictions supportees
enum AddictionType {
  tabac('tabac', '🚬', 'Cigarettes', Color(0xFFFF4D4D)),
  alcoolBiere('biere', '🍺', 'Bieres', Color(0xFFC4722A)),
  alcoolVin('vin', '🍷', 'Verres vin', Color(0xFF8B4557)),
  alcoolFort('fort', '🥃', 'Alcool fort', Color(0xFFC4722A)),
  jeuxVideo('jeux', '🎮', 'Heures jeux', Color(0xFF9966FF)),
  porn('porn', '🔞', 'Sessions', Color(0xFFFF3399)),
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
  bool get isDefault =>
      this == tabac ||
      this == alcoolBiere ||
      this == alcoolVin ||
      this == alcoolFort;

  /// Couleur pour le fond (opacity)
  Color get backgroundColor => color.withOpacity(0.12);

  /// Couleur pour la bordure
  Color get borderColor => color.withOpacity(0.4);

  /// Trouver par ID avec fallback safe
  static AddictionType? fromId(String? id) {
    if (id == null || id.isEmpty) return null;
    try {
      return AddictionType.values.firstWhere((t) => t.id == id);
    } catch (e) {
      Log.warn('MODEL', 'Unknown addiction type', data: {'id': id});
      return null;
    }
  }

  /// Trouver par ID avec fallback vers tabac
  static AddictionType fromIdOrDefault(String? id) {
    return fromId(id) ?? AddictionType.tabac;
  }
}

/// Entree d'addiction pour une journee
class AddictionEntry {
  final AddictionType type;
  int _count;
  DateTime? firstTime;

  /// Limite max pour eviter valeurs aberrantes
  static const int maxCount = 9999;

  AddictionEntry({
    required this.type,
    int count = 0,
    this.firstTime,
  }) : _count = count.clamp(0, maxCount);

  /// Compteur (toujours >= 0 et <= maxCount)
  int get count => _count;

  /// Incrementer le compteur
  void increment() {
    if (_count < maxCount) {
      _count++;
      firstTime ??= DateTime.now();
      Log.trace('MODEL', 'Incremented', data: {'type': type.id, 'count': _count});
    }
  }

  /// Decrementer le compteur
  void decrement() {
    if (_count > 0) {
      _count--;
      if (_count == 0) firstTime = null;
      Log.trace('MODEL', 'Decremented', data: {'type': type.id, 'count': _count});
    }
  }

  /// Reset le compteur
  void reset() {
    _count = 0;
    firstTime = null;
  }

  /// Delai depuis le reveil (en minutes, toujours positif)
  int? delayFromWake(DateTime? wakeTime) {
    if (firstTime == null || wakeTime == null) return null;
    return firstTime!.difference(wakeTime).inMinutes.abs();
  }

  /// Serialization JSON
  Map<String, dynamic> toJson() => {
        'type': type.id,
        'count': _count,
        'firstTime': firstTime?.toIso8601String(),
      };

  /// Deserialization avec guards complets
  factory AddictionEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      Log.warn('MODEL', 'Null json for AddictionEntry');
      return AddictionEntry(type: AddictionType.tabac);
    }

    try {
      // Type avec fallback
      final typeId = json['type'] as String?;
      final type = AddictionType.fromIdOrDefault(typeId);

      // Count avec clamp
      final rawCount = json['count'];
      final count = (rawCount is num) ? rawCount.toInt() : 0;

      // FirstTime avec parsing safe
      DateTime? firstTime;
      final firstTimeValue = json['firstTime'];
      if (firstTimeValue is String && firstTimeValue.isNotEmpty) {
        try {
          firstTime = DateTime.parse(firstTimeValue);
        } catch (e) {
          Log.warn('MODEL', 'Invalid firstTime', data: {'value': firstTimeValue});
        }
      }

      return AddictionEntry(
        type: type,
        count: count,
        firstTime: firstTime,
      );
    } catch (e, stack) {
      Log.error('MODEL', 'Parse AddictionEntry failed', error: e, stack: stack);
      return AddictionEntry(type: AddictionType.tabac);
    }
  }

  @override
  String toString() => 'AddictionEntry(${type.id}: $_count)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddictionEntry &&
          type == other.type &&
          _count == other._count;

  @override
  int get hashCode => Object.hash(type, _count);
}
