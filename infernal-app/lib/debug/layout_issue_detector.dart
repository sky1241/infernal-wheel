// lib/debug/layout_issue_detector.dart
// Detection automatique des problemes UI en debug

import 'package:flutter/foundation.dart';

/// Type de probleme UI detecte
enum IssueType {
  overflow,     // RenderFlex overflow
  truncation,   // Texte tronque
  smallTouch,   // Touch target < 44dp
  overlap,      // Elements superposes
  lowContrast,  // Contraste insuffisant
  missingSemantic, // Pas de label accessible
}

/// Severite du probleme
enum IssueSeverity {
  critical, // Fix immediat requis
  error,    // Fix urgent
  warning,  // Fix planifie
  info,     // Amelioration possible
}

/// Probleme UI detecte
class LayoutIssue {
  final IssueType type;
  final IssueSeverity severity;
  final String message;
  final String? widgetPath;
  final double? x;
  final double? y;
  final double? width;
  final double? height;
  final DateTime timestamp;
  final Map<String, dynamic>? context;

  LayoutIssue({
    required this.type,
    required this.severity,
    required this.message,
    this.widgetPath,
    this.x,
    this.y,
    this.width,
    this.height,
    this.context,
  }) : timestamp = DateTime.now();

  /// Hash pour deduplication
  String get hash {
    final normalizedMessage = message
        .replaceAll(RegExp(r'\d+\.?\d*'), 'N')
        .replaceAll(RegExp(r'"[^"]*"'), '"..."')
        .toLowerCase();
    return '${type.name}|${widgetPath ?? ""}|$normalizedMessage'.hashCode.toRadixString(16);
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'severity': severity.name,
    'message': message,
    'widgetPath': widgetPath,
    'bounds': (x != null && y != null && width != null && height != null)
        ? {'x': x, 'y': y, 'w': width, 'h': height}
        : null,
    'timestamp': timestamp.toIso8601String(),
    'context': context,
  };

  factory LayoutIssue.fromJson(Map<String, dynamic> json) {
    final bounds = json['bounds'] as Map<String, dynamic>?;
    return LayoutIssue(
      type: IssueType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => IssueType.overflow,
      ),
      severity: IssueSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => IssueSeverity.warning,
      ),
      message: json['message'] as String? ?? '',
      widgetPath: json['widgetPath'] as String?,
      x: (bounds?['x'] as num?)?.toDouble(),
      y: (bounds?['y'] as num?)?.toDouble(),
      width: (bounds?['w'] as num?)?.toDouble(),
      height: (bounds?['h'] as num?)?.toDouble(),
      context: json['context'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() => '[${severity.name.toUpperCase()}] ${type.name}: $message';
}

/// Detecteur singleton de problemes UI
class LayoutIssueDetector {
  LayoutIssueDetector._();
  static final LayoutIssueDetector _instance = LayoutIssueDetector._();
  static LayoutIssueDetector get instance => _instance;

  final List<LayoutIssue> _issues = [];
  final Set<String> _seenHashes = {};
  bool _isEnabled = kDebugMode;

  /// Liste des problemes detectes (lecture seule)
  List<LayoutIssue> get issues => List.unmodifiable(_issues);

  /// Nombre de problemes par severite
  Map<IssueSeverity, int> get summary {
    final counts = <IssueSeverity, int>{};
    for (final severity in IssueSeverity.values) {
      counts[severity] = _issues.where((i) => i.severity == severity).length;
    }
    return counts;
  }

  /// Active/desactive le detecteur
  void enable() => _isEnabled = true;
  void disable() => _isEnabled = false;

  /// Enregistre un probleme (avec deduplication)
  void report(LayoutIssue issue) {
    if (!_isEnabled) return;

    // Deduplication par hash
    if (_seenHashes.contains(issue.hash)) {
      return;
    }

    _seenHashes.add(issue.hash);
    _issues.add(issue);

    // Log en debug
    if (kDebugMode) {
      debugPrint('[UI-ISSUE] ${issue.toString()}');
    }
  }

  /// Detecte un overflow
  void reportOverflow({
    required String widgetName,
    required double overflowAmount,
    String direction = 'right',
  }) {
    report(LayoutIssue(
      type: IssueType.overflow,
      severity: IssueSeverity.critical,
      message: 'RenderFlex overflowed by ${overflowAmount.toStringAsFixed(1)}px to the $direction',
      widgetPath: widgetName,
      context: {
        'overflowAmount': overflowAmount,
        'direction': direction,
      },
    ));
  }

  /// Detecte un touch target trop petit
  void reportSmallTouchTarget({
    required String widgetName,
    required double actualWidth,
    required double actualHeight,
    double minimumSize = 44.0,
  }) {
    if (actualWidth >= minimumSize && actualHeight >= minimumSize) return;

    report(LayoutIssue(
      type: IssueType.smallTouch,
      severity: IssueSeverity.warning,
      message: 'Touch target too small: ${actualWidth.toInt()}x${actualHeight.toInt()} < ${minimumSize.toInt()}',
      widgetPath: widgetName,
      width: actualWidth,
      height: actualHeight,
      context: {
        'actualWidth': actualWidth,
        'actualHeight': actualHeight,
        'minimumSize': minimumSize,
      },
    ));
  }

  /// Detecte un texte tronque
  void reportTextTruncation({
    required String widgetName,
    required String text,
    required int visibleLines,
    required int totalLines,
  }) {
    if (visibleLines >= totalLines) return;

    final preview = text.length > 30 ? '${text.substring(0, 30)}...' : text;
    report(LayoutIssue(
      type: IssueType.truncation,
      severity: IssueSeverity.warning,
      message: 'Text truncated: "$preview" (showing $visibleLines of $totalLines lines)',
      widgetPath: widgetName,
      context: {
        'textPreview': preview,
        'visibleLines': visibleLines,
        'totalLines': totalLines,
      },
    ));
  }

  /// Reset pour nouveau jour/test
  void clear() {
    _issues.clear();
    _seenHashes.clear();
  }

  /// Restaure depuis stockage
  void restore(List<LayoutIssue> savedIssues) {
    for (final issue in savedIssues) {
      if (!_seenHashes.contains(issue.hash)) {
        _seenHashes.add(issue.hash);
        _issues.add(issue);
      }
    }
  }

  /// Export JSON pour rapport
  List<Map<String, dynamic>> exportJson() {
    return _issues.map((i) => i.toJson()).toList();
  }
}

/// Configure l'interception des erreurs Flutter
void setupLayoutErrorInterceptor() {
  if (!kDebugMode) return;

  FlutterError.onError = (FlutterErrorDetails details) {
    final message = details.toString();

    // Detecter les overflow
    if (message.contains('overflowed') || message.contains('RenderFlex')) {
      // Extraire la valeur d'overflow si possible
      final overflowMatch = RegExp(r'overflowed by ([\d.]+)').firstMatch(message);
      final amount = overflowMatch != null
          ? double.tryParse(overflowMatch.group(1) ?? '') ?? 0.0
          : 0.0;

      LayoutIssueDetector.instance.reportOverflow(
        widgetName: details.context?.toString() ?? 'unknown',
        overflowAmount: amount,
      );
    }

    // Log standard Flutter
    FlutterError.presentError(details);
  };
}
