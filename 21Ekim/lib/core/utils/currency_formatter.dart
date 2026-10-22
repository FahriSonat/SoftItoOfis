import 'package:intl/intl.dart';

/// Para formatlama ve kuruş (minor unit) hesaplama yardımcı sınıfı.
/// Proje kuralları gereği kayan noktalı sayı (float) hassasiyet hatalarını önlemek amacıyla
/// tüm hesaplamalar tam sayı kuruş (integer minor units) cinsinden yapılır.
class CurrencyFormatter {
  CurrencyFormatter._();

  // Türkçe yerel para birimi biçimlendiricisi
  static final NumberFormat _tryFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );

  /// Kuruş tutarını (örn. 15050 kuruş) biçimlendirilmiş metne dönüştürür (örn. "150,50 ₺").
  /// Eğer [isHidden] doğru ise tutar yerine sansürlenmiş "₺••••" döndürülür.
  /// [showSign] doğru ise pozitif tutarların başına "+" ve negatif tutarların başına "-" eklenir.
  static String format(
    int minorAmount, {
    String currency = 'TRY',
    bool isHidden = false,
    bool showSign = false,
  }) {
    // Gizli tutar kontrolü: Özel işlemler için sansürleme
    if (isHidden) {
      return '₺••••';
    }

    // Kuruşu ana para birimine (Lira) çevir
    final double majorAmount = minorAmount / 100.0;
    String formatted = _tryFormat.format(majorAmount.abs());

    // Farklı bir para birimi varsa simgeyi değiştir
    if (currency != 'TRY') {
      formatted = formatted.replaceAll('₺', currency);
    }

    // İşaret gösterimi (+ / -)
    if (showSign) {
      if (minorAmount > 0) {
        return '+$formatted';
      } else if (minorAmount < 0) {
        return '-$formatted';
      }
    }

    return formatted;
  }

  /// Kullanıcının form alanına girdiği "150,50", "150.50" veya "1.250,50" gibi metinleri
  /// hatasız bir şekilde kuruş (minor unit) tam sayısına çevirir.
  static int parseToMinor(String input) {
    if (input.trim().isEmpty) return 0;
    
    // Para birimi simgeleri, boşluklar ve gereksiz karakterler temizlenir
    String clean = input
        .replaceAll('₺', '')
        .replaceAll('TRY', '')
        .replaceAll(' ', '')
        .trim();

    // Hem nokta hem virgül varsa (örn: 1.250,50 veya 1,250.50) hangisinin ondalık olduğunu belirle
    if (clean.contains('.') && clean.contains(',')) {
      if (clean.lastIndexOf(',') > clean.lastIndexOf('.')) {
        // Türkiye formatı: 1.250,50 -> noktaları sil, virgülü noktaya çevir
        clean = clean.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // ABD formatı: 1,250.50 -> virgülleri sil
        clean = clean.replaceAll(',', '');
      }
    } else if (clean.contains(',')) {
      // Yalnızca virgül varsa (örn. 150,50) noktaya dönüştür
      clean = clean.replaceAll(',', '.');
    }

    final double? parsed = double.tryParse(clean);
    if (parsed == null) return 0;

    // Kuruşa çevir ve yuvarlayarak float kayıplarını engelle
    return (parsed * 100).round();
  }

  /// Kuruş tutarını metin düzenleme kutusunda (TextFormField) düzenlenebilir
  /// sade ondalık metne dönüştürür (örn. "150,50")
  static String toEditString(int minorAmount) {
    if (minorAmount == 0) return '';
    final double major = minorAmount / 100.0;
    return major.toStringAsFixed(2).replaceAll('.', ',');
  }
}
