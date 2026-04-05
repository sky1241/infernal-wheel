import 'package:flutter/material.dart';

/// Palette de couleurs — harmonisee avec web + watch
/// Source de verite: CSS variables du dashboard web (index.html)
class AppColors {
  // Base (aligned with --bg, --panel, --panel-2, --border)
  static const background = Color(0xFF0E1319);
  static const surface = Color(0xFF121820);
  static const surfaceLight = Color(0xFF141C25);
  static const border = Color(0xFF24303C);

  // Text (aligned with --text, --muted)
  static const text = Color(0xFFE7EDF3);
  static const textSecondary = Color(0xFFA7B3BF);
  static const muted = Color(0xFF6B7280);

  // Accent (brand green — same everywhere)
  static const accent = Color(0xFF35D99A);
  static const accentLight = Color(0xFF5BEBB5);

  // Semantic (aligned with --danger, --warn, --blue)
  static const danger = Color(0xFFFF7A7A);
  static const dangerDark = Color(0xFFFF4D4D);
  static const warning = Color(0xFFF7BF54);
  static const success = Color(0xFF35D99A);
  static const blue = Color(0xFF6BBCFF);

  // Cigarette (coral — watch-harmonized)
  static const cigarette = Color(0xFFE57373);
  static const cigaretteContainer = Color(0xFF3D1A1A);

  // Alcohol types (watch-harmonized)
  static const alcoholBeer = Color(0xFFFFB74D);
  static const alcoholWine = Color(0xFFCE93D8);
  static const alcoholStrong = Color(0xFF9575CD);

  // Trends
  static const trendGood = Color(0xFF35D99A);
  static const trendBad = Color(0xFFFF7A7A);
  static const trendNeutral = Color(0xFF6B7280);

  // Sleep quality
  static const sleepBad = Color(0xFFFF4D4D);
  static const sleepPoor = Color(0xFFFF7A7A);
  static const sleepOkay = Color(0xFFF7BF54);
  static const sleepGood = Color(0xFF35D99A);
  static const sleepGreat = Color(0xFF00E5A0);

  // Gradients pour les cartes
  static LinearGradient cardGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withValues(alpha: 0.15),
        color.withValues(alpha: 0.05),
      ],
    );
  }

  // Glow pour les elements actifs
  static List<BoxShadow> glow(Color color, {double blur = 12}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }
}
