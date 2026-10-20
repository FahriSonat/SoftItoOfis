import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary Seed from design.md: #3157D5
  static const Color primarySeed = Color(0xFF3157D5);
  static const Color primary = Color(0xFF3157D5);
  static const Color primaryDark = Color(0xFF1E3BB0);
  static const Color primaryLight = Color(0xFF5B7CF0);

  // Secondary & Accents
  static const Color secondary = Color(0xFF009688); // Turquoise family
  static const Color accent = Color(0xFFFF9800);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBorder = Color(0xFFE2E8F0);

  // Dark surfaces from design.md (koyu lacivert-gri)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCardBorder = Color(0xFF334155);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
}

class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double extraLarge = 24.0;
  static const double pill = 999.0;
}
