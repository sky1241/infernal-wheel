// lib/debug/debug_init.dart
// Point d'entree pour initialiser le systeme de debug

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'layout_issue_detector.dart';
import 'daily_bug_report.dart';

/// Initialise le systeme de debug (appeler dans main())
void initDebugSystem() {
  if (!kDebugMode) return;

  // Intercepter les erreurs Flutter
  setupLayoutErrorInterceptor();

  debugPrint('[DEBUG] Debug system initialized');
}

/// Verifie et genere le rapport quotidien si necessaire
/// Appeler apres que le BuildContext soit disponible
Future<DailyBugReport?> checkDailyBugReport({
  required BuildContext context,
  required String storagePath,
  required String appVersion,
  required int buildNumber,
}) async {
  if (!kDebugMode) return null;

  final mediaQuery = MediaQuery.of(context);
  final locale = Localizations.localeOf(context);

  final device = DeviceInfo(
    os: defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android',
    version: '1.0', // TODO: get from device_info_plus
    model: 'Unknown', // TODO: get from device_info_plus
    screenWidth: mediaQuery.size.width.toInt(),
    screenHeight: mediaQuery.size.height.toInt(),
    textScale: mediaQuery.textScaleFactor,
    locale: locale.toString(),
    isRTL: Directionality.of(context) == TextDirection.rtl,
  );

  return maybeGenerateDailyBugReport(
    device: device,
    appVersion: appVersion,
    buildNumber: buildNumber,
    storagePath: storagePath,
  );
}

/// Extension pour faciliter le debug dans les widgets
extension DebugContext on BuildContext {
  /// Verifie si le mode debug est actif
  bool get isDebugMode => kDebugMode;

  /// Reporte un probleme de touch target
  void reportSmallTouchTarget(String widgetName, Size size) {
    if (!kDebugMode) return;
    LayoutIssueDetector.instance.reportSmallTouchTarget(
      widgetName: widgetName,
      actualWidth: size.width,
      actualHeight: size.height,
    );
  }

  /// Reporte un texte tronque
  void reportTextTruncation(String widgetName, String text, int visible, int total) {
    if (!kDebugMode) return;
    LayoutIssueDetector.instance.reportTextTruncation(
      widgetName: widgetName,
      text: text,
      visibleLines: visible,
      totalLines: total,
    );
  }
}
