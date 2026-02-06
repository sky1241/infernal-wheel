// lib/core/infernal_day.dart
// Jour InfernalWheel : commence a 4h du matin, pas minuit

/// Heure de debut du jour InfernalWheel (4h00)
const int kInfernalDayStartHour = 4;

/// Represente un jour InfernalWheel (4h -> 3h59 lendemain)
class InfernalDay {
  final int year;
  final int month;
  final int day;

  const InfernalDay(this.year, this.month, this.day);

  /// Jour InfernalWheel pour une date/heure donnee
  factory InfernalDay.from(DateTime dt) {
    // Si avant 4h du matin → jour precedent
    if (dt.hour < kInfernalDayStartHour) {
      final yesterday = dt.subtract(const Duration(days: 1));
      return InfernalDay(yesterday.year, yesterday.month, yesterday.day);
    }
    return InfernalDay(dt.year, dt.month, dt.day);
  }

  /// Jour InfernalWheel actuel
  factory InfernalDay.today() => InfernalDay.from(DateTime.now());

  /// Cle unique pour stockage (yyyy-MM-dd)
  String get key => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// DateTime du debut du jour (4h00)
  DateTime get startTime => DateTime(year, month, day, kInfernalDayStartHour, 0, 0);

  /// DateTime de fin du jour (3h59:59 lendemain)
  DateTime get endTime {
    final nextDay = DateTime(year, month, day).add(const Duration(days: 1));
    return DateTime(nextDay.year, nextDay.month, nextDay.day, kInfernalDayStartHour - 1, 59, 59);
  }

  /// Jour precedent
  InfernalDay get previous {
    final prev = DateTime(year, month, day).subtract(const Duration(days: 1));
    return InfernalDay(prev.year, prev.month, prev.day);
  }

  /// Jour suivant
  InfernalDay get next {
    final nxt = DateTime(year, month, day).add(const Duration(days: 1));
    return InfernalDay(nxt.year, nxt.month, nxt.day);
  }

  /// Verifie si un DateTime est dans ce jour InfernalWheel
  bool contains(DateTime dt) {
    return InfernalDay.from(dt) == this;
  }

  /// Parse depuis une cle (yyyy-MM-dd)
  static InfernalDay? tryParse(String key) {
    try {
      final parts = key.split('-');
      if (parts.length != 3) return null;
      return InfernalDay(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is InfernalDay && year == other.year && month == other.month && day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'InfernalDay($key)';
}

/// Extensions utiles sur DateTime
extension InfernalDateTime on DateTime {
  /// Jour InfernalWheel de cette date
  InfernalDay get infernalDay => InfernalDay.from(this);

  /// Cle du jour InfernalWheel
  String get infernalDayKey => infernalDay.key;

  /// Est-ce le meme jour InfernalWheel qu'une autre date?
  bool isSameInfernalDay(DateTime other) => infernalDay == other.infernalDay;
}
