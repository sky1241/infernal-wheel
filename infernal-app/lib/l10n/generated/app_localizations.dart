import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('zh')
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'InfernalWheel'**
  String get appName;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get thisMonth;

  /// No description provided for @cigarettes.
  ///
  /// In fr, this message translates to:
  /// **'Cigarettes'**
  String get cigarettes;

  /// No description provided for @beers.
  ///
  /// In fr, this message translates to:
  /// **'Bieres'**
  String get beers;

  /// No description provided for @wine.
  ///
  /// In fr, this message translates to:
  /// **'Verres de vin'**
  String get wine;

  /// No description provided for @spirits.
  ///
  /// In fr, this message translates to:
  /// **'Alcool fort'**
  String get spirits;

  /// Nombre de cigarettes avec pluralisation
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune cigarette} =1{1 cigarette} other{{count} cigarettes}}'**
  String cigarettesCount(int count);

  /// No description provided for @beersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune biere} =1{1 biere} other{{count} bieres}}'**
  String beersCount(int count);

  /// No description provided for @wineCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun verre} =1{1 verre de vin} other{{count} verres de vin}}'**
  String wineCount(int count);

  /// No description provided for @spiritsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun verre} =1{1 verre} other{{count} verres}}'**
  String spiritsCount(int count);

  /// No description provided for @sleep.
  ///
  /// In fr, this message translates to:
  /// **'Sommeil'**
  String get sleep;

  /// No description provided for @wakeTime.
  ///
  /// In fr, this message translates to:
  /// **'Reveil'**
  String get wakeTime;

  /// No description provided for @bedTime.
  ///
  /// In fr, this message translates to:
  /// **'Coucher'**
  String get bedTime;

  /// No description provided for @duration.
  ///
  /// In fr, this message translates to:
  /// **'Duree'**
  String get duration;

  /// No description provided for @quality.
  ///
  /// In fr, this message translates to:
  /// **'Qualite'**
  String get quality;

  /// No description provided for @sleepQualityBad.
  ///
  /// In fr, this message translates to:
  /// **'Mauvais'**
  String get sleepQualityBad;

  /// No description provided for @sleepQualityPoor.
  ///
  /// In fr, this message translates to:
  /// **'Insuffisant'**
  String get sleepQualityPoor;

  /// No description provided for @sleepQualityOkay.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get sleepQualityOkay;

  /// No description provided for @sleepQualityGood.
  ///
  /// In fr, this message translates to:
  /// **'Bon'**
  String get sleepQualityGood;

  /// No description provided for @sleepQualityGreat.
  ///
  /// In fr, this message translates to:
  /// **'Excellent'**
  String get sleepQualityGreat;

  /// No description provided for @sleepDurationFormat.
  ///
  /// In fr, this message translates to:
  /// **'{hours}h{minutes}'**
  String sleepDurationFormat(int hours, int minutes);

  /// No description provided for @journal.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Parametres'**
  String get settings;

  /// No description provided for @export.
  ///
  /// In fr, this message translates to:
  /// **'Exporter'**
  String get export;

  /// No description provided for @support.
  ///
  /// In fr, this message translates to:
  /// **'Soutenir'**
  String get support;

  /// No description provided for @increment.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get increment;

  /// No description provided for @decrement.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get decrement;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Reessayer'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnee'**
  String get noData;

  /// No description provided for @noSleepData.
  ///
  /// In fr, this message translates to:
  /// **'Pas de donnees sommeil'**
  String get noSleepData;

  /// No description provided for @manualEntry.
  ///
  /// In fr, this message translates to:
  /// **'Saisie manuelle'**
  String get manualEntry;

  /// No description provided for @autoDetected.
  ///
  /// In fr, this message translates to:
  /// **'Detection auto'**
  String get autoDetected;

  /// No description provided for @errorSaveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde impossible'**
  String get errorSaveFailed;

  /// No description provided for @errorLoadFailed.
  ///
  /// In fr, this message translates to:
  /// **'Chargement echoue'**
  String get errorLoadFailed;

  /// No description provided for @errorNetworkFailed.
  ///
  /// In fr, this message translates to:
  /// **'Erreur reseau'**
  String get errorNetworkFailed;

  /// No description provided for @errorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get errorUnknown;

  /// No description provided for @supportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Soutenir InfernalWheel ?'**
  String get supportTitle;

  /// No description provided for @supportDesc.
  ///
  /// In fr, this message translates to:
  /// **'Cette app est 100% gratuite et sans tracking.'**
  String get supportDesc;

  /// No description provided for @donate.
  ///
  /// In fr, this message translates to:
  /// **'Faire un don'**
  String get donate;

  /// No description provided for @watchAd.
  ///
  /// In fr, this message translates to:
  /// **'Regarder une pub'**
  String get watchAd;

  /// No description provided for @noThanks.
  ///
  /// In fr, this message translates to:
  /// **'Non merci'**
  String get noThanks;

  /// No description provided for @bugReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Problemes detectes'**
  String get bugReportTitle;

  /// No description provided for @bugReportDesc.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 probleme detecte aujourd\'hui} other{{count} problemes detectes aujourd\'hui}}'**
  String bugReportDesc(int count);

  /// No description provided for @bugReportView.
  ///
  /// In fr, this message translates to:
  /// **'Voir details'**
  String get bugReportView;

  /// No description provided for @bugReportIgnore.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer pour 24h'**
  String get bugReportIgnore;

  /// No description provided for @settingsSleepGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif sommeil'**
  String get settingsSleepGoal;

  /// No description provided for @settingsAddictions.
  ///
  /// In fr, this message translates to:
  /// **'Mes addictions'**
  String get settingsAddictions;

  /// No description provided for @settingsNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsExportData.
  ///
  /// In fr, this message translates to:
  /// **'Exporter mes donnees'**
  String get settingsExportData;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'A propos'**
  String get settingsAbout;

  /// Date formatee selon la locale
  ///
  /// In fr, this message translates to:
  /// **'{date}'**
  String dateFormatted(DateTime date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'pt',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
