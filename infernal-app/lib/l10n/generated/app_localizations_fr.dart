// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get cigarettes => 'Cigarettes';

  @override
  String get beers => 'Bieres';

  @override
  String get wine => 'Verres de vin';

  @override
  String get spirits => 'Alcool fort';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cigarettes',
      one: '1 cigarette',
      zero: 'Aucune cigarette',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bieres',
      one: '1 biere',
      zero: 'Aucune biere',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verres de vin',
      one: '1 verre de vin',
      zero: 'Aucun verre',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count verres',
      one: '1 verre',
      zero: 'Aucun verre',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'Sommeil';

  @override
  String get wakeTime => 'Reveil';

  @override
  String get bedTime => 'Coucher';

  @override
  String get duration => 'Duree';

  @override
  String get quality => 'Qualite';

  @override
  String get sleepQualityBad => 'Mauvais';

  @override
  String get sleepQualityPoor => 'Insuffisant';

  @override
  String get sleepQualityOkay => 'Moyen';

  @override
  String get sleepQualityGood => 'Bon';

  @override
  String get sleepQualityGreat => 'Excellent';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h$minutes';
  }

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Parametres';

  @override
  String get export => 'Exporter';

  @override
  String get support => 'Soutenir';

  @override
  String get increment => 'Ajouter';

  @override
  String get decrement => 'Retirer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get close => 'Fermer';

  @override
  String get retry => 'Reessayer';

  @override
  String get noData => 'Aucune donnee';

  @override
  String get noSleepData => 'Pas de donnees sommeil';

  @override
  String get manualEntry => 'Saisie manuelle';

  @override
  String get autoDetected => 'Detection auto';

  @override
  String get errorSaveFailed => 'Sauvegarde impossible';

  @override
  String get errorLoadFailed => 'Chargement echoue';

  @override
  String get errorNetworkFailed => 'Erreur reseau';

  @override
  String get errorUnknown => 'Erreur inconnue';

  @override
  String get supportTitle => 'Soutenir InfernalWheel ?';

  @override
  String get supportDesc => 'Cette app est 100% gratuite et sans tracking.';

  @override
  String get donate => 'Faire un don';

  @override
  String get watchAd => 'Regarder une pub';

  @override
  String get noThanks => 'Non merci';

  @override
  String get bugReportTitle => 'Problemes detectes';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemes detectes aujourd\'hui',
      one: '1 probleme detecte aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'Voir details';

  @override
  String get bugReportIgnore => 'Ignorer pour 24h';

  @override
  String get settingsSleepGoal => 'Objectif sommeil';

  @override
  String get settingsAddictions => 'Mes addictions';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsExportData => 'Exporter mes donnees';

  @override
  String get settingsAbout => 'A propos';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
