// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get cigarettes => 'Cigarros';

  @override
  String get beers => 'Cervejas';

  @override
  String get wine => 'Copos de vinho';

  @override
  String get spirits => 'Destilados';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cigarros',
      one: '1 cigarro',
      zero: 'Nenhum cigarro',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cervejas',
      one: '1 cerveja',
      zero: 'Nenhuma cerveja',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count copos de vinho',
      one: '1 copo de vinho',
      zero: 'Nenhum copo',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses',
      one: '1 dose',
      zero: 'Nenhuma dose',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'Sono';

  @override
  String get wakeTime => 'Acordar';

  @override
  String get bedTime => 'Dormir';

  @override
  String get duration => 'Duracao';

  @override
  String get quality => 'Qualidade';

  @override
  String get sleepQualityBad => 'Ruim';

  @override
  String get sleepQualityPoor => 'Insuficiente';

  @override
  String get sleepQualityOkay => 'Regular';

  @override
  String get sleepQualityGood => 'Bom';

  @override
  String get sleepQualityGreat => 'Excelente';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '${hours}h${minutes}m';
  }

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Configuracoes';

  @override
  String get export => 'Exportar';

  @override
  String get support => 'Apoiar';

  @override
  String get increment => 'Adicionar';

  @override
  String get decrement => 'Remover';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get close => 'Fechar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get noData => 'Sem dados';

  @override
  String get noSleepData => 'Sem dados de sono';

  @override
  String get manualEntry => 'Entrada manual';

  @override
  String get autoDetected => 'Detectado auto';

  @override
  String get errorSaveFailed => 'Falha ao salvar';

  @override
  String get errorLoadFailed => 'Falha ao carregar';

  @override
  String get errorNetworkFailed => 'Erro de rede';

  @override
  String get errorUnknown => 'Erro desconhecido';

  @override
  String get supportTitle => 'Apoiar InfernalWheel?';

  @override
  String get supportDesc => 'Este app e 100% gratis e sem rastreamento.';

  @override
  String get donate => 'Doar';

  @override
  String get watchAd => 'Assistir anuncio';

  @override
  String get noThanks => 'Nao obrigado';

  @override
  String get bugReportTitle => 'Problemas detectados';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count problemas detectados hoje',
      one: '1 problema detectado hoje',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'Ver detalhes';

  @override
  String get bugReportIgnore => 'Ignorar por 24h';

  @override
  String get settingsSleepGoal => 'Meta de sono';

  @override
  String get settingsAddictions => 'Minhas adicoes';

  @override
  String get settingsNotifications => 'Notificacoes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsExportData => 'Exportar meus dados';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
