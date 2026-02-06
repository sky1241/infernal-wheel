// lib/debug/daily_bug_report.dart
// Systeme de rapport de bug quotidien (1x/jour max)

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'layout_issue_detector.dart';

/// Informations sur l'appareil
class DeviceInfo {
  final String os;
  final String version;
  final String model;
  final int screenWidth;
  final int screenHeight;
  final double textScale;
  final String locale;
  final bool isRTL;

  const DeviceInfo({
    required this.os,
    required this.version,
    required this.model,
    required this.screenWidth,
    required this.screenHeight,
    required this.textScale,
    required this.locale,
    required this.isRTL,
  });

  Map<String, dynamic> toJson() => {
    'os': os,
    'version': version,
    'model': model,
    'screenWidth': screenWidth,
    'screenHeight': screenHeight,
    'textScale': textScale,
    'locale': locale,
    'isRTL': isRTL,
  };

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      os: json['os'] as String? ?? 'unknown',
      version: json['version'] as String? ?? '0',
      model: json['model'] as String? ?? 'unknown',
      screenWidth: (json['screenWidth'] as num?)?.toInt() ?? 0,
      screenHeight: (json['screenHeight'] as num?)?.toInt() ?? 0,
      textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
      locale: json['locale'] as String? ?? 'en',
      isRTL: json['isRTL'] as bool? ?? false,
    );
  }
}

/// Resume du rapport
class ReportSummary {
  final int total;
  final int critical;
  final int error;
  final int warning;
  final int info;

  const ReportSummary({
    required this.total,
    required this.critical,
    required this.error,
    required this.warning,
    required this.info,
  });

  Map<String, dynamic> toJson() => {
    'total': total,
    'critical': critical,
    'error': error,
    'warning': warning,
    'info': info,
  };

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      total: (json['total'] as num?)?.toInt() ?? 0,
      critical: (json['critical'] as num?)?.toInt() ?? 0,
      error: (json['error'] as num?)?.toInt() ?? 0,
      warning: (json['warning'] as num?)?.toInt() ?? 0,
      info: (json['info'] as num?)?.toInt() ?? 0,
    );
  }

  /// Rapport vide?
  bool get isEmpty => total == 0;

  /// A des problemes critiques?
  bool get hasCritical => critical > 0;
}

/// Issue agregee (dedupliquee)
class AggregatedIssue {
  final String id;
  final String type;
  final String severity;
  final String message;
  final String widgetPath;
  final int occurrences;
  final DateTime firstSeen;
  final DateTime lastSeen;
  final Map<String, dynamic>? context;
  final String? suggestion;

  const AggregatedIssue({
    required this.id,
    required this.type,
    required this.severity,
    required this.message,
    required this.widgetPath,
    required this.occurrences,
    required this.firstSeen,
    required this.lastSeen,
    this.context,
    this.suggestion,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'severity': severity,
    'message': message,
    'widget': widgetPath,
    'occurrences': occurrences,
    'firstSeen': firstSeen.toIso8601String(),
    'lastSeen': lastSeen.toIso8601String(),
    'context': context,
    'suggestion': suggestion,
  };

  factory AggregatedIssue.fromJson(Map<String, dynamic> json) {
    return AggregatedIssue(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      severity: json['severity'] as String? ?? 'WARNING',
      message: json['message'] as String? ?? '',
      widgetPath: json['widget'] as String? ?? 'unknown',
      occurrences: (json['occurrences'] as num?)?.toInt() ?? 1,
      firstSeen: DateTime.tryParse(json['firstSeen'] as String? ?? '') ?? DateTime.now(),
      lastSeen: DateTime.tryParse(json['lastSeen'] as String? ?? '') ?? DateTime.now(),
      context: json['context'] as Map<String, dynamic>?,
      suggestion: json['suggestion'] as String?,
    );
  }
}

/// Rapport de bug quotidien
class DailyBugReport {
  final String reportId;
  final DateTime generatedAt;
  final DeviceInfo device;
  final String appVersion;
  final int buildNumber;
  final ReportSummary summary;
  final List<AggregatedIssue> issues;

  const DailyBugReport({
    required this.reportId,
    required this.generatedAt,
    required this.device,
    required this.appVersion,
    required this.buildNumber,
    required this.summary,
    required this.issues,
  });

  Map<String, dynamic> toJson() => {
    'reportId': reportId,
    'generatedAt': generatedAt.toIso8601String(),
    'device': device.toJson(),
    'app': {
      'version': appVersion,
      'buildNumber': buildNumber,
    },
    'summary': summary.toJson(),
    'issues': issues.map((i) => i.toJson()).toList(),
  };

  factory DailyBugReport.fromJson(Map<String, dynamic> json) {
    final app = json['app'] as Map<String, dynamic>? ?? {};
    return DailyBugReport(
      reportId: json['reportId'] as String? ?? '',
      generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? '') ?? DateTime.now(),
      device: DeviceInfo.fromJson(json['device'] as Map<String, dynamic>? ?? {}),
      appVersion: app['version'] as String? ?? '0.0.0',
      buildNumber: (app['buildNumber'] as num?)?.toInt() ?? 0,
      summary: ReportSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      issues: (json['issues'] as List<dynamic>? ?? [])
          .map((i) => AggregatedIssue.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Rapport vide?
  bool get isEmpty => summary.isEmpty;
}

/// Suggestions de fix par type de probleme
const Map<String, String> _suggestions = {
  'overflow': 'Add Expanded wrapper with TextOverflow.ellipsis',
  'truncation': 'Consider increasing maxLines or using FittedBox',
  'smallTouch': 'Add constraints: BoxConstraints(minWidth: 48, minHeight: 48)',
  'overlap': 'Use Column instead of Stack, or adjust positioning',
  'lowContrast': 'Increase contrast ratio to at least 4.5:1',
  'missingSemantic': 'Add Semantics widget with label property',
};

/// Generateur de rapport quotidien
class DailyBugReportGenerator {
  DailyBugReportGenerator._();
  static final DailyBugReportGenerator _instance = DailyBugReportGenerator._();
  static DailyBugReportGenerator get instance => _instance;

  DateTime? _lastReportDate;
  static const int maxIssuesPerReport = 20;

  /// Verifie si un rapport peut etre genere (1x/jour max)
  bool canGenerateReport() {
    if (_lastReportDate == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(
      _lastReportDate!.year,
      _lastReportDate!.month,
      _lastReportDate!.day,
    );

    return today.isAfter(lastDay);
  }

  /// Genere le rapport du jour
  DailyBugReport generate({
    required List<LayoutIssue> issues,
    required DeviceInfo device,
    required String appVersion,
    required int buildNumber,
  }) {
    _lastReportDate = DateTime.now();

    // Agreger et dedupliquer
    final aggregated = _aggregateIssues(issues);

    // Trier par severite
    aggregated.sort((a, b) {
      final severityOrder = ['CRITICAL', 'ERROR', 'WARNING', 'INFO'];
      return severityOrder.indexOf(a.severity) - severityOrder.indexOf(b.severity);
    });

    // Limiter le nombre
    final limited = aggregated.take(maxIssuesPerReport).toList();

    // Calculer le resume
    final summary = ReportSummary(
      total: limited.length,
      critical: limited.where((i) => i.severity == 'CRITICAL').length,
      error: limited.where((i) => i.severity == 'ERROR').length,
      warning: limited.where((i) => i.severity == 'WARNING').length,
      info: limited.where((i) => i.severity == 'INFO').length,
    );

    final now = DateTime.now();
    return DailyBugReport(
      reportId: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      generatedAt: now,
      device: device,
      appVersion: appVersion,
      buildNumber: buildNumber,
      summary: summary,
      issues: limited,
    );
  }

  /// Agrege les issues par hash
  List<AggregatedIssue> _aggregateIssues(List<LayoutIssue> issues) {
    final Map<String, List<LayoutIssue>> grouped = {};

    for (final issue in issues) {
      final hash = issue.hash;
      grouped.putIfAbsent(hash, () => []).add(issue);
    }

    return grouped.entries.map((entry) {
      final hash = entry.key;
      final group = entry.value;
      final first = group.first;

      // Trouver timestamps extremes
      final timestamps = group.map((i) => i.timestamp).toList();
      timestamps.sort();

      return AggregatedIssue(
        id: hash,
        type: first.type.name,
        severity: first.severity.name.toUpperCase(),
        message: first.message,
        widgetPath: first.widgetPath ?? 'unknown',
        occurrences: group.length,
        firstSeen: timestamps.first,
        lastSeen: timestamps.last,
        context: first.context,
        suggestion: _suggestions[first.type.name],
      );
    }).toList();
  }
}

/// Service de stockage des rapports
class BugReportStorage {
  final String basePath;

  BugReportStorage(this.basePath);

  String get _reportsDir => '$basePath/bug_reports';

  /// Sauvegarde un rapport
  Future<void> saveReport(DailyBugReport report) async {
    if (!kDebugMode) return;

    try {
      final dir = Directory(_reportsDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('$_reportsDir/${report.reportId}.json');
      final json = const JsonEncoder.withIndent('  ').convert(report.toJson());
      await file.writeAsString(json);

      debugPrint('[BugReport] Saved: ${report.reportId}');
    } catch (e) {
      debugPrint('[BugReport] Save failed: $e');
    }
  }

  /// Charge le dernier rapport
  Future<DailyBugReport?> loadLatestReport() async {
    if (!kDebugMode) return null;

    try {
      final dir = Directory(_reportsDir);
      if (!await dir.exists()) return null;

      final files = await dir.list().where((f) => f.path.endsWith('.json')).toList();
      if (files.isEmpty) return null;

      // Trier par nom (date)
      files.sort((a, b) => b.path.compareTo(a.path));

      final file = files.first as File;
      final content = await file.readAsString();
      return DailyBugReport.fromJson(jsonDecode(content) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[BugReport] Load failed: $e');
      return null;
    }
  }

  /// Charge la date du dernier rapport
  Future<DateTime?> getLastReportDate() async {
    final report = await loadLatestReport();
    return report?.generatedAt;
  }

  /// Nettoie les rapports anciens (> 7 jours)
  Future<void> cleanOldReports({int keepDays = 7}) async {
    if (!kDebugMode) return;

    try {
      final dir = Directory(_reportsDir);
      if (!await dir.exists()) return;

      final cutoff = DateTime.now().subtract(Duration(days: keepDays));

      await for (final file in dir.list()) {
        if (file is File && file.path.endsWith('.json')) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoff)) {
            await file.delete();
            debugPrint('[BugReport] Deleted old: ${file.path}');
          }
        }
      }
    } catch (e) {
      debugPrint('[BugReport] Cleanup failed: $e');
    }
  }
}

/// Point d'entree pour generer le rapport quotidien
Future<DailyBugReport?> maybeGenerateDailyBugReport({
  required DeviceInfo device,
  required String appVersion,
  required int buildNumber,
  required String storagePath,
}) async {
  if (!kDebugMode) return null;

  final generator = DailyBugReportGenerator.instance;
  final storage = BugReportStorage(storagePath);

  // Verifier si on peut generer
  if (!generator.canGenerateReport()) {
    debugPrint('[BugReport] Already generated today, skipping');
    return null;
  }

  final issues = LayoutIssueDetector.instance.issues;
  if (issues.isEmpty) {
    debugPrint('[BugReport] No issues to report');
    return null;
  }

  // Generer
  final report = generator.generate(
    issues: issues,
    device: device,
    appVersion: appVersion,
    buildNumber: buildNumber,
  );

  // Sauvegarder
  await storage.saveReport(report);

  // Nettoyer anciens
  await storage.cleanOldReports();

  // Reset detecteur
  LayoutIssueDetector.instance.clear();

  return report;
}
