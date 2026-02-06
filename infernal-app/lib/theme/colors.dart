import 'package:flutter/material.dart';

/// Palette de couleurs - Dark mode brutal
class AppColors {
  // Base
  static const background = Color(0xFF14171A);
  static const surface = Color(0xFF1A1E23);
  static const surfaceLight = Color(0xFF22272D);
  static const border = Color(0xFF2F3336);

  // Text
  static const text = Color(0xFFF2F2F2);
  static const textSecondary = Color(0xFFB0B0B0);
  static const muted = Color(0xFF6B7280);

  // Accent
  static const accent = Color(0xFF35D99A); // Vert
  static const accentLight = Color(0xFF5BEBB5);

  // Semantic
  static const danger = Color(0xFFFF4D4D);
  static const dangerLight = Color(0xFFFF7A7A);
  static const warning = Color(0xFFF6B73C);
  static const success = Color(0xFF35D99A);

  // Trends
  static const trendGood = Color(0xFF35D99A);
  static const trendBad = Color(0xFFFF4D4D);
  static const trendNeutral = Color(0xFF6B7280);

  // Sleep quality
  static const sleepBad = Color(0xFFFF4D4D);
  static const sleepPoor = Color(0xFFFF7A7A);
  static const sleepOkay = Color(0xFFF6B73C);
  static const sleepGood = Color(0xFF35D99A);
  static const sleepGreat = Color(0xFF00E5A0);

  // Gradients pour les cartes
  static LinearGradient cardGradient(Color color) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color.withOpacity(0.15),
        color.withOpacity(0.05),
      ],
    );
  }

  // Glow pour les elements actifs
  static List<BoxShadow> glow(Color color, {double blur = 12}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }
}
