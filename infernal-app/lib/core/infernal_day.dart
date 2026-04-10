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
    if (dt.hour < kInfernalDayStartHour) {
      final yesterday = dt.subtract(const Duration(days: 1));
      return InfernalDay(yesterday.year, yesterday.month, yesterday.day);
    }
    return InfernalDay(dt.year, dt.month, dt.day);
  }

  /// Jour InfernalWheel actuel
  factory InfernalDay.today() => InfernalDay.from(DateTime.now());

  /// Hier
  factory InfernalDay.yesterday() {
    final today = InfernalDay.today();
    return today.previous;
  }

  /// Parse depuis une cle (yyyy-MM-dd)
  factory InfernalDay.fromKey(String key) {
    final parts = key.split('-');
    return InfernalDay(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Parse depuis une cle (yyyy-MM-dd), retourne null si invalide
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

  // --- Storage ---

  /// Cle unique pour stockage (yyyy-MM-dd)
  String get key => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// DateTime interne (debut calendaire du jour, 00:00) — used by dayName + formattedDate
  DateTime get date => DateTime(year, month, day);

  // --- Navigation ---

  /// Jour precedent (DST-safe: pas de Duration)
  InfernalDay get previous {
    final prev = DateTime(year, month, day - 1);
    return InfernalDay(prev.year, prev.month, prev.day);
  }

  /// Jour suivant (DST-safe: pas de Duration)
  InfernalDay get next {
    final nxt = DateTime(year, month, day + 1);
    return InfernalDay(nxt.year, nxt.month, nxt.day);
  }

  // --- Display ---

  static const _dayNames = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
  ];

  static const _monthNames = [
    'janvier', 'fevrier', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'aout', 'septembre', 'octobre', 'novembre', 'decembre'
  ];

  /// Nom du jour (Lundi, Mardi, ...)
  String get dayName => _dayNames[date.weekday - 1];

  /// Date formatee "5 fevrier 2024"
  String get formattedDate => '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  // --- Equality ---

  @override
  bool operator ==(Object other) =>
      other is InfernalDay && year == other.year && month == other.month && day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'InfernalDay($key)';
}
