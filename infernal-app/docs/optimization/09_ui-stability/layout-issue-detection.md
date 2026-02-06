# Detection Automatique des Problemes UI

## Objectif

Detecter **AUTOMATIQUEMENT** les problemes de layout en debug :
- Overflow (RenderFlex)
- Chevauchement
- Texte tronque
- Touch targets trop petits
- Contraste insuffisant

---

## Architecture

```
lib/debug/
├── layout_issue_detector.dart    <- Detecteur principal
├── issue_types.dart              <- Types de problemes
├── daily_bug_report.dart         <- Agregation quotidienne
└── ui_overlay.dart               <- Overlay visuel debug
```

---

## Types de problemes detectes

| Type | Detection | Severite |
|------|-----------|----------|
| `overflow` | RenderFlex error | CRITICAL |
| `truncation` | Text avec ellipsis actif | WARNING |
| `overlap` | Bounds intersection | ERROR |
| `small_touch` | Size < 44dp | WARNING |
| `low_contrast` | Ratio < 4.5:1 | WARNING |
| `missing_semantics` | Pas de label accessible | INFO |

---

## Implementation Detector

```dart
// lib/debug/layout_issue_detector.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Probleme UI detecte
class LayoutIssue {
  final String type;
  final String message;
  final String? widgetPath;
  final Rect? bounds;
  final DateTime timestamp;
  final String severity; // CRITICAL, ERROR, WARNING, INFO

  LayoutIssue({
    required this.type,
    required this.message,
    this.widgetPath,
    this.bounds,
    required this.severity,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    'widgetPath': widgetPath,
    'bounds': bounds != null
        ? {'x': bounds!.left, 'y': bounds!.top, 'w': bounds!.width, 'h': bounds!.height}
        : null,
    'timestamp': timestamp.toIso8601String(),
    'severity': severity,
  };

  @override
  String toString() => '[$severity] $type: $message';
}

/// Detecteur de problemes UI
class LayoutIssueDetector {
  static final LayoutIssueDetector _instance = LayoutIssueDetector._();
  static LayoutIssueDetector get instance => _instance;

  LayoutIssueDetector._();

  final List<LayoutIssue> _issues = [];
  bool _isEnabled = kDebugMode;

  List<LayoutIssue> get issues => List.unmodifiable(_issues);

  void enable() => _isEnabled = true;
  void disable() => _isEnabled = false;

  /// Enregistre un probleme
  void report(LayoutIssue issue) {
    if (!_isEnabled) return;

    // Eviter les doublons consecutifs
    if (_issues.isNotEmpty) {
      final last = _issues.last;
      if (last.type == issue.type &&
          last.message == issue.message &&
          last.widgetPath == issue.widgetPath) {
        return; // Doublon
      }
    }

    _issues.add(issue);

    // Log en debug
    if (kDebugMode) {
      debugPrint('[UI-ISSUE] ${issue.toString()}');
    }
  }

  /// Detecte overflow RenderFlex
  void checkOverflow(RenderBox renderBox, String widgetName) {
    if (!_isEnabled) return;

    // Flutter affiche deja les overflow en jaune/noir
    // On capture pour le rapport
    final hasOverflow = renderBox.debugNeedsLayout;

    if (hasOverflow) {
      report(LayoutIssue(
        type: 'overflow',
        message: 'RenderFlex overflow detected',
        widgetPath: widgetName,
        bounds: renderBox.paintBounds,
        severity: 'CRITICAL',
      ));
    }
  }

  /// Detecte touch targets trop petits
  void checkTouchTarget(Size size, String widgetName) {
    if (!_isEnabled) return;

    const minSize = 44.0; // iOS minimum

    if (size.width < minSize || size.height < minSize) {
      report(LayoutIssue(
        type: 'small_touch',
        message: 'Touch target too small: ${size.width.toInt()}x${size.height.toInt()} < ${minSize.toInt()}',
        widgetPath: widgetName,
        severity: 'WARNING',
      ));
    }
  }

  /// Detecte texte tronque (ellipsis actif)
  void checkTextTruncation(TextPainter painter, String text, String widgetName) {
    if (!_isEnabled) return;

    if (painter.didExceedMaxLines) {
      report(LayoutIssue(
        type: 'truncation',
        message: 'Text truncated: "${text.substring(0, text.length.clamp(0, 30))}..."',
        widgetPath: widgetName,
        severity: 'WARNING',
      ));
    }
  }

  /// Reset pour nouveaux tests
  void clear() => _issues.clear();

  /// Export pour rapport quotidien
  List<Map<String, dynamic>> exportJson() {
    return _issues.map((i) => i.toJson()).toList();
  }
}
```

---

## Widget Wrapper pour detection

```dart
// lib/debug/debug_wrapper.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'layout_issue_detector.dart';

/// Wrapper qui detecte les problemes sur ses enfants
class DebugLayoutCheck extends StatelessWidget {
  final Widget child;
  final String name;

  const DebugLayoutCheck({
    super.key,
    required this.child,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Post-frame check
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkLayout(context);
        });

        return child;
      },
    );
  }

  void _checkLayout(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;

    // Check touch target
    LayoutIssueDetector.instance.checkTouchTarget(size, name);
  }
}

/// Extension pour faciliter l'usage
extension DebugLayoutX on Widget {
  Widget debugLayout(String name) {
    if (!kDebugMode) return this;
    return DebugLayoutCheck(name: name, child: this);
  }
}
```

---

## Intercepteur Flutter Errors

```dart
// lib/debug/error_interceptor.dart

import 'package:flutter/foundation.dart';
import 'layout_issue_detector.dart';

/// Configure l'interception des erreurs Flutter
void setupErrorInterceptor() {
  if (!kDebugMode) return;

  // Intercepter les erreurs de rendu
  FlutterError.onError = (FlutterErrorDetails details) {
    // Detecter les overflow
    final message = details.toString();

    if (message.contains('overflowed') || message.contains('RenderFlex')) {
      LayoutIssueDetector.instance.report(LayoutIssue(
        type: 'overflow',
        message: details.summary.toString(),
        widgetPath: details.context?.toString(),
        severity: 'CRITICAL',
      ));
    }

    // Log standard
    FlutterError.presentError(details);
  };
}
```

---

## Usage dans l'app

```dart
// main.dart
void main() {
  setupErrorInterceptor();
  runApp(const MyApp());
}

// Dans les widgets
ElevatedButton(
  onPressed: () {},
  child: Text(label),
).debugLayout('home_addButton'); // Debug wrapper
```

---

## Checklist detection

- [ ] `LayoutIssueDetector` implemente
- [ ] Wrapper `DebugLayoutCheck` disponible
- [ ] Intercepteur erreurs configure
- [ ] Types de problemes couverts
- [ ] Export JSON pour rapport
- [ ] Desactive en release
