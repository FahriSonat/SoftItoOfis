import 'package:flutter/material.dart';

/// Uygulama tasarım sistemi ve renk paleti belirteçleri (Design Tokens).
/// Modern, koyu temaya (dark theme) uygun finansal renk kodlarını içerir.
class AppColors {
  AppColors._();

  // Arka Plan ve Yüzey Renkleri
  static const Color background = Color(0xFF090D18);      // Ana arka plan (en koyu zemin)
  static const Color surface = Color(0xFF111827);         // Kart ve panel yüzey rengi
  static const Color surfaceRaised = Color(0xFF192235);   // Vurgulanmış veya bir üst katman kart yüzeyi
  static const Color border = Color(0xFF293449);          // İnce kenarlık ve ayırıcı çizgiler

  // Tipografi ve Metin Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);     // Birincil başlık ve önemli metinler
  static const Color textSecondary = Color(0xFFB8C2D3);   // İkincil açıklamalar ve etiketler
  static const Color textMuted = Color(0xFF8995A8);       // Pasif veya arka plandaki küçük ipuçları

  // Finansal Gösterge Renkleri
  static const Color income = Color(0xFF22C55E);          // Gelir yeşili
  static const Color incomeSurface = Color(0xFF153224);   // Gelir kartı hafif yeşil zemin rengi
  static const Color expense = Color(0xFFF04452);         // Gider kırmızısı (hayır işi dahil)
  static const Color expenseSurface = Color(0xFF382027);  // Gider kartı hafif kırmızı zemin rengi

  // Nötr ve Vurgu Renkleri
  static const Color indicatorBlue = Color(0xFF4EA1FF);   // Buton, aktif sekme ve genel aksan mavisi

  // Uyarı, Kritik Durum ve Bildirim Renkleri
  static const Color warningBackground = Color(0xFFFACC15); // Yaklaşan limit uyarısı (sarı zemin)
  static const Color warningText = Color(0xFF111111);       // Sarı zemin üzeri koyu okunabilir metin
  static const Color criticalBackground = Color(0xFFD92D3A);// Bütçe aşımı / geciken borç (kırmızı zemin)
  static const Color criticalText = Color(0xFFFFFFFF);      // Kırmızı zemin üzeri beyaz metin
  static const Color successBackground = Color(0xFF153224); // Başarılı işlem bildirimi
}
