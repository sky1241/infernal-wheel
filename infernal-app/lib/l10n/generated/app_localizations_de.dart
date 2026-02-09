// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get cigarettes => 'Zigaretten';

  @override
  String get beers => 'Biere';

  @override
  String get wine => 'Glaser Wein';

  @override
  String get spirits => 'Spirituosen';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zigaretten',
      one: '1 Zigarette',
      zero: 'Keine Zigaretten',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Biere',
      one: '1 Bier',
      zero: 'Keine Biere',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Glaser Wein',
      one: '1 Glas Wein',
      zero: 'Keine Glaser',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Getranke',
      one: '1 Getrank',
      zero: 'Keine Getranke',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'Schlaf';

  @override
  String get wakeTime => 'Aufwachzeit';

  @override
  String get bedTime => 'Schlafenszeit';

  @override
  String get duration => 'Dauer';

  @override
  String get quality => 'Qualitat';

  @override
  String get sleepQualityBad => 'Schlecht';

  @override
  String get sleepQualityPoor => 'Ungenuegend';

  @override
  String get sleepQualityOkay => 'Mittelmaessig';

  @override
  String get sleepQualityGood => 'Gut';

  @override
  String get sleepQualityGreat => 'Ausgezeichnet';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h${minutes}m';
  }

  @override
  String get journal => 'Tagebuch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get export => 'Exportieren';

  @override
  String get support => 'Unterstuetzen';

  @override
  String get increment => 'Hinzufuegen';

  @override
  String get decrement => 'Entfernen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get close => 'Schliessen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get noData => 'Keine Daten';

  @override
  String get noSleepData => 'Keine Schlafdaten';

  @override
  String get manualEntry => 'Manuelle Eingabe';

  @override
  String get autoDetected => 'Automatisch erkannt';

  @override
  String get errorSaveFailed => 'Speichern fehlgeschlagen';

  @override
  String get errorLoadFailed => 'Laden fehlgeschlagen';

  @override
  String get errorNetworkFailed => 'Netzwerkfehler';

  @override
  String get errorUnknown => 'Unbekannter Fehler';

  @override
  String get supportTitle => 'InfernalWheel unterstuetzen?';

  @override
  String get supportDesc => 'Diese App ist 100% kostenlos und ohne Tracking.';

  @override
  String get donate => 'Spenden';

  @override
  String get watchAd => 'Werbung ansehen';

  @override
  String get noThanks => 'Nein danke';

  @override
  String get bugReportTitle => 'Probleme erkannt';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Probleme heute erkannt',
      one: '1 Problem heute erkannt',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'Details anzeigen';

  @override
  String get bugReportIgnore => 'Fuer 24h ignorieren';

  @override
  String get settingsSleepGoal => 'Schlafziel';

  @override
  String get settingsAddictions => 'Meine Suechte';

  @override
  String get settingsNotifications => 'Benachrichtigungen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsExportData => 'Meine Daten exportieren';

  @override
  String get settingsAbout => 'Ueber';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
