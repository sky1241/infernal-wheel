// lib/widgets/safe_widgets.dart
// Widgets "safe" qui ne cassent jamais l'UI

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../debug/layout_issue_detector.dart';

/// Texte qui ne casse jamais (avec overflow ellipsis)
class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextAlign? textAlign;
  final String? debugName;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 2,
    this.textAlign,
    this.debugName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          softWrap: true,
          textAlign: textAlign,
        );
      },
    );
  }
}

/// Row qui ne casse jamais (avec Expanded sur le titre)
class SafeRow extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final double spacing;
  final String? debugName;

  const SafeRow({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.spacing = 12.0,
    this.debugName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        SizedBox(width: spacing),
        Expanded(child: title),
        if (trailing != null) ...[
          SizedBox(width: spacing),
          trailing!,
        ],
      ],
    );
  }
}

/// Bouton avec touch target garanti >= 48dp
class SafeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double minSize;
  final String? debugName;

  const SafeButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.minSize = 48.0,
    this.debugName,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(minSize / 2),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// IconButton avec touch target garanti >= 48dp
class SafeIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double iconSize;
  final Color? color;
  final double minTouchTarget;
  final String? tooltip;
  final String? debugName;

  const SafeIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize = 24.0,
    this.color,
    this.minTouchTarget = 48.0,
    this.tooltip,
    this.debugName,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: iconSize, color: color),
      constraints: BoxConstraints(
        minWidth: minTouchTarget,
        minHeight: minTouchTarget,
      ),
      padding: EdgeInsets.zero,
      tooltip: tooltip,
    );

    // Debug: verifier la taille
    if (kDebugMode && debugName != null) {
      button = _DebugSizeChecker(
        name: debugName!,
        minSize: minTouchTarget,
        child: button,
      );
    }

    return button;
  }
}

/// Container flexible pour texte (jamais de hauteur fixe)
class SafeTextContainer extends StatelessWidget {
  final Widget child;
  final double minHeight;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxDecoration? decoration;

  const SafeTextContainer({
    super.key,
    required this.child,
    this.minHeight = 0,
    this.padding,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: minHeight > 0
          ? BoxConstraints(minHeight: minHeight)
          : null,
      padding: padding,
      color: decoration == null ? color : null,
      decoration: decoration,
      child: child,
    );
  }
}

/// Wrap pour listes horizontales (evite overflow)
class SafeChipList extends StatelessWidget {
  final List<Widget> chips;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  const SafeChipList({
    super.key,
    required this.chips,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: alignment,
      children: chips,
    );
  }
}

/// Widget interne pour verifier la taille en debug
class _DebugSizeChecker extends StatelessWidget {
  final String name;
  final double minSize;
  final Widget child;

  const _DebugSizeChecker({
    required this.name,
    required this.minSize,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final size = box.size;
            if (size.width < minSize || size.height < minSize) {
              LayoutIssueDetector.instance.reportSmallTouchTarget(
                widgetName: name,
                actualWidth: size.width,
                actualHeight: size.height,
                minimumSize: minSize,
              );
            }
          }
        });
        return child;
      },
    );
  }
}

/// Padding directionnel (RTL-safe)
class SafePadding extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  final double top;
  final double bottom;

  const SafePadding({
    super.key,
    required this.child,
    this.start = 0,
    this.end = 0,
    this.top = 0,
    this.bottom = 0,
  });

  /// Padding horizontal symetrique
  const SafePadding.horizontal({
    super.key,
    required this.child,
    required double value,
  })  : start = value,
        end = value,
        top = 0,
        bottom = 0;

  /// Padding vertical symetrique
  const SafePadding.vertical({
    super.key,
    required this.child,
    required double value,
  })  : start = 0,
        end = 0,
        top = value,
        bottom = value;

  /// Padding uniforme
  const SafePadding.all({
    super.key,
    required this.child,
    required double value,
  })  : start = value,
        end = value,
        top = value,
        bottom = value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      ),
      child: child,
    );
  }
}

/// Page scrollable par defaut avec SafeArea
class SafePage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  const SafePage({
    super.key,
    required this.child,
    this.padding,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return SafeArea(child: content);
  }
}
