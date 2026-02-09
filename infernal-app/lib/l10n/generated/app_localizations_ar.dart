// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'InfernalWheel';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get cigarettes => 'سجائر';

  @override
  String get beers => 'بيرة';

  @override
  String get wine => 'كؤوس نبيذ';

  @override
  String get spirits => 'مشروبات روحية';

  @override
  String cigarettesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سجائر',
      one: 'سيجارة واحدة',
      zero: 'لا سجائر',
    );
    return '$_temp0';
  }

  @override
  String beersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بيرة',
      one: 'بيرة واحدة',
      zero: 'لا بيرة',
    );
    return '$_temp0';
  }

  @override
  String wineCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كؤوس نبيذ',
      one: 'كأس نبيذ واحد',
      zero: 'لا كؤوس',
    );
    return '$_temp0';
  }

  @override
  String spiritsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشروبات',
      one: 'مشروب واحد',
      zero: 'لا مشروبات',
    );
    return '$_temp0';
  }

  @override
  String get sleep => 'النوم';

  @override
  String get wakeTime => 'وقت الاستيقاظ';

  @override
  String get bedTime => 'وقت النوم';

  @override
  String get duration => 'المدة';

  @override
  String get quality => 'الجودة';

  @override
  String get sleepQualityBad => 'سيء';

  @override
  String get sleepQualityPoor => 'ضعيف';

  @override
  String get sleepQualityOkay => 'مقبول';

  @override
  String get sleepQualityGood => 'جيد';

  @override
  String get sleepQualityGreat => 'ممتاز';

  @override
  String sleepDurationFormat(int hours, int minutes) {
    return '$hoursس$minutesد';
  }

  @override
  String get journal => 'اليومية';

  @override
  String get settings => 'الإعدادات';

  @override
  String get export => 'تصدير';

  @override
  String get support => 'دعم';

  @override
  String get increment => 'إضافة';

  @override
  String get decrement => 'إزالة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get close => 'إغلاق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noSleepData => 'لا توجد بيانات نوم';

  @override
  String get manualEntry => 'إدخال يدوي';

  @override
  String get autoDetected => 'اكتشاف تلقائي';

  @override
  String get errorSaveFailed => 'فشل الحفظ';

  @override
  String get errorLoadFailed => 'فشل التحميل';

  @override
  String get errorNetworkFailed => 'خطأ في الشبكة';

  @override
  String get errorUnknown => 'خطأ غير معروف';

  @override
  String get supportTitle => 'دعم InfernalWheel؟';

  @override
  String get supportDesc => 'هذا التطبيق مجاني 100% وبدون تتبع.';

  @override
  String get donate => 'تبرع';

  @override
  String get watchAd => 'مشاهدة إعلان';

  @override
  String get noThanks => 'لا شكراً';

  @override
  String get bugReportTitle => 'مشاكل مكتشفة';

  @override
  String bugReportDesc(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشاكل مكتشفة اليوم',
      one: 'مشكلة واحدة مكتشفة اليوم',
    );
    return '$_temp0';
  }

  @override
  String get bugReportView => 'عرض التفاصيل';

  @override
  String get bugReportIgnore => 'تجاهل لـ 24 ساعة';

  @override
  String get settingsSleepGoal => 'هدف النوم';

  @override
  String get settingsAddictions => 'إدماناتي';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsExportData => 'تصدير بياناتي';

  @override
  String get settingsAbout => 'حول';

  @override
  String dateFormatted(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
