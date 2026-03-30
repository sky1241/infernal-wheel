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

  /// Alias: compatibilite avec ancien code
  factory InfernalDay.fromDate(DateTime dt) => InfernalDay.from(dt);

  /// Jour InfernalWheel actuel
  factory InfernalDay.today() => InfernalDay.from(DateTime.now());

  /// Alias: compatibilite avec ancien code
  factory InfernalDay.current() => InfernalDay.today();

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

  /// DateTime interne (debut calendaire du jour, 00:00)
  DateTime get date => DateTime(year, month, day);

  /// DateTime du debut du jour (4h00)
  DateTime get startTime => DateTime(year, month, day, kInfernalDayStartHour, 0, 0);

  /// DateTime de fin du jour (3h59:59 lendemain)
  DateTime get endTime {
    final nextDay = DateTime(year, month, day).add(const Duration(days: 1));
    return DateTime(nextDay.year, nextDay.month, nextDay.day, kInfernalDayStartHour, 0, 0).subtract(const Duration(milliseconds: 1));
  }

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

  /// Verifie si un DateTime est dans ce jour InfernalWheel
  bool contains(DateTime dt) {
    return InfernalDay.from(dt) == this;
  }

  /// Est-ce aujourd'hui?
  bool get isToday => this == InfernalDay.today();

  /// Est-ce hier?
  bool get isYesterday => this == InfernalDay.yesterday();

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

  /// Header complet "Jeudi 5 fevrier"
  String get headerText => '$dayName ${date.day} ${_monthNames[date.month - 1]}';

  // --- Equality ---

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
