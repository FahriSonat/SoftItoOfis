import 'package:flutter/material.dart';

/// Design tokens defined in design.md
class AppColors {
  AppColors._();

  // Background & Surfaces
  static const Color background = Color(0xFF090D18);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceRaised = Color(0xFF192235);
  static const Color border = Color(0xFF293449);

  // Typography
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB8C2D3);
  static const Color textMuted = Color(0xFF8995A8);

  // Financial colors
  static const Color income = Color(0xFF22C55E);
  static const Color incomeSurface = Color(0xFF153224);
  static const Color expense = Color(0xFFF04452);
  static const Color expenseSurface = Color(0xFF382027);

  // Neutral & Indicator
  static const Color indicatorBlue = Color(0xFF4EA1FF);

  // Warnings & Notifications
  static const Color warningBackground = Color(0xFFFACC15);
  static const Color warningText = Color(0xFF111111);
  static const Color criticalBackground = Color(0xFFD92D3A);
  static const Color criticalText = Color(0xFFFFFFFF);
  static const Color successBackground = Color(0xFF153224);
}
