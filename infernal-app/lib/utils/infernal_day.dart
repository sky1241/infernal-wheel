/// Logique du "jour infernal"
/// Le jour commence a 4h du matin, pas minuit
/// Ca correspond mieux a la realite des gens qui se couchent tard

class InfernalDay {
  final DateTime date;
  final String key;

  InfernalDay._(this.date, this.key);

  /// Creer depuis une date
  factory InfernalDay.fromDate(DateTime dateTime) {
    final hour = dateTime.hour;

    // Si avant 4h du matin, on est encore sur le jour precedent
    DateTime adjustedDate;
    if (hour < 4) {
      adjustedDate = dateTime.subtract(const Duration(days: 1));
    } else {
      adjustedDate = dateTime;
    }

    // Normaliser au debut du jour
    adjustedDate = DateTime(adjustedDate.year, adjustedDate.month, adjustedDate.day);

    final key = _formatKey(adjustedDate);
    return InfernalDay._(adjustedDate, key);
  }

  /// Jour actuel
  factory InfernalDay.current() => InfernalDay.fromDate(DateTime.now());

  /// Hier
  factory InfernalDay.yesterday() {
    final today = InfernalDay.current();
    return InfernalDay.fromDate(today.date.subtract(const Duration(days: 1)));
  }

  /// Creer depuis une key
  factory InfernalDay.fromKey(String key) {
    final parts = key.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return InfernalDay._(date, key);
  }

  static String _formatKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Noms des jours en francais
  static const _dayNames = [
    'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
  ];

  static const _monthNames = [
    'janvier', 'fevrier', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'aout', 'septembre', 'octobre', 'novembre', 'decembre'
  ];

  /// Nom du jour
  String get dayName => _dayNames[date.weekday - 1];

  /// Date formatee "5 fevrier 2024"
  String get formattedDate => '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

  /// Header complet "Jeudi 5 fevrier"
  String get headerText => '$dayName ${date.day} ${_monthNames[date.month - 1]}';

  /// Est-ce aujourd'hui?
  bool get isToday => key == InfernalDay.current().key;

  /// Est-ce hier?
  bool get isYesterday => key == InfernalDay.yesterday().key;

  @override
  bool operator ==(Object other) =>
      other is InfernalDay && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Extension pour DateTime
extension DateTimeInfernal on DateTime {
  InfernalDay get infernalDay => InfernalDay.fromDate(this);
  String get infernalDayKey => infernalDay.key;
}
