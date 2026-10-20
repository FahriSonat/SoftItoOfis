import 'package:flutter/material.dart';

/// [AppColors]
/// Susadım uygulaması için karanlık spor salonu temasına uygun renk paleti.
class AppColors {
  AppColors._();

  // Arka plan ve yüzey renkleri
  static const Color background = Color(0xFF0F172A); // Çok koyu arduvaz mavisi
  static const Color surface = Color(0xFF1E293B);    // Koyu yüzey kart rengi
  static const Color surfaceVariant = Color(0xFF334155);

  // Vurgu renkleri (Su ve hidrasyon teması)
  static const Color primary = Color(0xFF00E5FF);     // Parlak camgöbeği/su mavisi
  static const Color primaryDark = Color(0xFF00B0FF);
  static const Color secondary = Color(0xFF38BDF8);
  static const Color accent = Color(0xFF06B6D4);

  // Başarı ve durum renkleri
  static const Color success = Color(0xFF10B981);     // Hedefe ulaşıldığında yeşil
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Metin renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}

/// [AppTheme]
/// Material 3 destekli karanlık tema yapılandırması.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
