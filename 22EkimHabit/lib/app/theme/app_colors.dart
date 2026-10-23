import 'package:flutter/material.dart';

/// Denge Uygulaması Renk Tokenları (design.md uyumlu)
class AppColors {
  AppColors._();

  // Koyu yüzeyler
  static const Color canvas = Color(0xFF070B12);
  static const Color canvasElevated = Color(0xFF0B111C);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceHigh = Color(0xFF172033);
  static const Color surfaceStrong = Color(0xFF1C273A);
  static const Color borderSubtle = Color(0xFF243044);
  static const Color borderStrong = Color(0xFF3A4962);
  static const Color scrim = Color(0xAD000000);

  // Metin renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB8C2D6);
  static const Color textMuted = Color(0xFF8491A8);
  static const Color textDisabled = Color(0xFF5F6B80);
  static const Color textOnBright = Color(0xFF071018);

  // Sistem durumları
  static const Color restart = Color(0xFFFF9F43);
  static const Color success = Color(0xFF35D083);
  static const Color warning = Color(0xFFF7C948);
  static const Color danger = Color(0xFFFF6673);
  static const Color info = Color(0xFF60A5FA);

  // Negatif ilerleme aşama renkleri (0 - 5)
  // 0: 0-23 saat, 1: 1-2 gün, 2: 3-6 gün, 3: 7-13 gün, 4: 14-29 gün, 5: 30+ gün
  static const List<Color> negativeStages = [
    Color(0xFFFF5D68), // 0: Başlangıç (0-23s)
    Color(0xFFFF735C), // 1: İlk adım (1-2g)
    Color(0xFFF59E45), // 2: Dayanıklılık (3-6g)
    Color(0xFFC4C94A), // 3: Dönüşüm (7-13g)
    Color(0xFF71C96B), // 4: Güçlenme (14-29g)
    Color(0xFF35D083), // 5: İstikrar (30+g)
  ];

  // Pozitif ilerleme aşama renkleri (0 - 4)
  // 0: 0-2 periyot, 1: 3-6 periyot, 2: 7-13 periyot, 3: 14-29 periyot, 4: 30+ periyot
  static const List<Color> positiveStages = [
    Color(0xFF4D8DFF), // 0: Başlangıç (0-2)
    Color(0xFF3B9EF3), // 1: Ritim (3-6)
    Color(0xFF2BAFE4), // 2: Akış (7-13)
    Color(0xFF22C1D0), // 3: Devamlılık (14-29)
    Color(0xFF20D3B0), // 4: İstikrar (30+)
  ];
}
