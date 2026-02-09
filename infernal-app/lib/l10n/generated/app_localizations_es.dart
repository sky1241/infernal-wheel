// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get cigarettes => 'Cigarrillos';

  @override
  String get beers => 'Cervezas';

  @override
  String get wine => 'Copas de vino';

  @override
  String get spirits => 'Licores';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cigarrillos',
      one: '1 cigarrillo',
      zero: 'Ningun cigarrillo',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cervezas',
      one: '1 cerveza',
      zero: 'Ninguna cerveza',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copas de vino',
      one: '1 copa de vino',
      zero: 'Ninguna copa',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copas',
      one: '1 copa',
      zero: 'Ninguna copa',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'Sueno';

  @override
  String get wakeTime => 'Despertar';

  @override
  String get bedTime => 'Acostarse';

  @override
  String get duration => 'Duracion';

  @override
  String get quality => 'Calidad';

  @override
  String get sleepQualityBad => 'Malo';

  @override
  String get sleepQualityPoor => 'Insuficiente';

  @override
  String get sleepQualityOkay => 'Regular';

  @override
  String get sleepQualityGood => 'Bueno';

  @override
  String get sleepQualityGreat => 'Excelente';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h${minutes}m';
  }

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Ajustes';

  @override
  String get export => 'Exportar';

  @override
  String get support => 'Apoyar';

  @override
  String get increment => 'Anadir';

  @override
  String get decrement => 'Quitar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Cerrar';

  @override
  String get retry => 'Reintentar';

  @override
  String get noData => 'Sin datos';

  @override
  String get noSleepData => 'Sin datos de sueno';

  @override
  String get manualEntry => 'Entrada manual';

  @override
  String get autoDetected => 'Detectado auto';

  @override
  String get errorSaveFailed => 'Error al guardar';

  @override
  String get errorLoadFailed => 'Error al cargar';

  @override
  String get errorNetworkFailed => 'Error de red';

  @override
  String get errorUnknown => 'Error desconocido';

  @override
  String get supportTitle => 'Apoyar InfernalWheel?';

  @override
  String get supportDesc => 'Esta app es 100% gratis y sin rastreo.';

  @override
  String get donate => 'Donar';

  @override
  String get watchAd => 'Ver un anuncio';

  @override
  String get noThanks => 'No gracias';

  @override
  String get bugReportTitle => 'Problemas detectados';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas detectados hoy',
      one: '1 problema detectado hoy',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'Ver detalles';

  @override
  String get bugReportIgnore => 'Ignorar por 24h';

  @override
  String get settingsSleepGoal => 'Objetivo de sueno';

  @override
  String get settingsAddictions => 'Mis adicciones';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsExportData => 'Exportar mis datos';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
