// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get cigarettes => '香烟';

  @override
  String get beers => '啤酒';

  @override
  String get wine => '葡萄酒';

  @override
  String get spirits => '烈酒';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count支香烟',
      zero: '无香烟',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count杯啤酒',
      zero: '无啤酒',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count杯葡萄酒',
      zero: '无葡萄酒',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count杯烈酒',
      zero: '无烈酒',
    );
    return '$_temp0';
  }

  @override
  String get sleep => '睡眠';

  @override
  String get wakeTime => '起床时间';

  @override
  String get bedTime => '就寝时间';

  @override
  String get duration => '时长';

  @override
  String get quality => '质量';

  @override
  String get sleepQualityBad => '差';

  @override
  String get sleepQualityPoor => '较差';

  @override
  String get sleepQualityOkay => '一般';

  @override
  String get sleepQualityGood => '良好';

  @override
  String get sleepQualityGreat => '优秀';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '$hours小时$minutes分钟';
  }

  @override
  String get journal => '日记';

  @override
  String get settings => '设置';

  @override
  String get export => '导出';

  @override
  String get support => '支持';

  @override
  String get increment => '添加';

  @override
  String get decrement => '移除';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get close => '关闭';

  @override
  String get retry => '重试';

  @override
  String get noData => '无数据';

  @override
  String get noSleepData => '无睡眠数据';

  @override
  String get manualEntry => '手动输入';

  @override
  String get autoDetected => '自动检测';

  @override
  String get errorSaveFailed => '保存失败';

  @override
  String get errorLoadFailed => '加载失败';

  @override
  String get errorNetworkFailed => '网络错误';

  @override
  String get errorUnknown => '未知错误';

  @override
  String get supportTitle => '支持InfernalWheel？';

  @override
  String get supportDesc => '此应用100%免费且无追踪。';

  @override
  String get donate => '捐赠';

  @override
  String get watchAd => '观看广告';

  @override
  String get noThanks => '不用了';

  @override
  String get bugReportTitle => '检测到问题';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '今天检测到$count个问题',
      one: '今天检测到1个问题',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => '查看详情';

  @override
  String get bugReportIgnore => '忽略24小时';

  @override
  String get settingsSleepGoal => '睡眠目标';

  @override
  String get settingsAddictions => '我的成瘾';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsExportData => '导出我的数据';

  @override
  String get settingsAbout => '关于';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
