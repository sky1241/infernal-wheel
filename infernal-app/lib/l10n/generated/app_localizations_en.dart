// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get cigarettes => 'Cigarettes';

  @override
  String get beers => 'Beers';

  @override
  String get wine => 'Glasses of wine';

  @override
  String get spirits => 'Spirits';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cigarettes',
      one: '1 cigarette',
      zero: 'No cigarettes',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count beers',
      one: '1 beer',
      zero: 'No beers',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count glasses of wine',
      one: '1 glass of wine',
      zero: 'No glasses',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count drinks',
      one: '1 drink',
      zero: 'No drinks',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'Sleep';

  @override
  String get wakeTime => 'Wake time';

  @override
  String get bedTime => 'Bed time';

  @override
  String get duration => 'Duration';

  @override
  String get quality => 'Quality';

  @override
  String get sleepQualityBad => 'Bad';

  @override
  String get sleepQualityPoor => 'Poor';

  @override
  String get sleepQualityOkay => 'Okay';

  @override
  String get sleepQualityGood => 'Good';

  @override
  String get sleepQualityGreat => 'Great';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h${minutes}m';
  }

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Settings';

  @override
  String get export => 'Export';

  @override
  String get support => 'Support';

  @override
  String get increment => 'Add';

  @override
  String get decrement => 'Remove';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No data';

  @override
  String get noSleepData => 'No sleep data';

  @override
  String get manualEntry => 'Manual entry';

  @override
  String get autoDetected => 'Auto detected';

  @override
  String get errorSaveFailed => 'Save failed';

  @override
  String get errorLoadFailed => 'Load failed';

  @override
  String get errorNetworkFailed => 'Network error';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get supportTitle => 'Support InfernalWheel?';

  @override
  String get supportDesc => 'This app is 100% free with no tracking.';

  @override
  String get donate => 'Donate';

  @override
  String get watchAd => 'Watch an ad';

  @override
  String get noThanks => 'No thanks';

  @override
  String get bugReportTitle => 'Issues detected';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count issues detected today',
      one: '1 issue detected today',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'View details';

  @override
  String get bugReportIgnore => 'Ignore for 24h';

  @override
  String get settingsSleepGoal => 'Sleep goal';

  @override
  String get settingsAddictions => 'My addictions';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsExportData => 'Export my data';

  @override
  String get settingsAbout => 'About';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
