import 'package:intl/intl.dart';

/// Formats and parses currency using integer minor units (kuruş)
/// As mandated by project.md: "Para hesaplamaları kayan noktalı sayı (float) ile yapılmaz"
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _tryFormat = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '₺',
    decimalDigits: 2,
  );

  /// Converts minor units (e.g. 15050 kuruş) to formatted string (e.g. "150,50 ₺")
  /// If [isHidden] is true, returns censored placeholder "₺••••"
  static String format(
    int minorAmount, {
    String currency = 'TRY',
    bool isHidden = false,
    bool showSign = false,
  }) {
    if (isHidden) {
      return '₺••••';
    }

    final double majorAmount = minorAmount / 100.0;
    String formatted = _tryFormat.format(majorAmount.abs());

    if (currency != 'TRY') {
      formatted = formatted.replaceAll('₺', currency);
    }

    if (showSign) {
      if (minorAmount > 0) {
        return '+$formatted';
      } else if (minorAmount < 0) {
        return '-$formatted';
      }
    }

    return formatted;
  }

  /// Parses input string like "150,50" or "150.50" or "150" into minor units integer (e.g. 15050)
  static int parseToMinor(String input) {
    if (input.trim().isEmpty) return 0;
    
    // Clean string from currency symbols, whitespace, thousand separators
    String clean = input
        .replaceAll('₺', '')
        .replaceAll('TRY', '')
        .replaceAll(' ', '')
        .trim();

    // If both '.' and ',' exist, determine which is decimal
    if (clean.contains('.') && clean.contains(',')) {
      if (clean.lastIndexOf(',') > clean.lastIndexOf('.')) {
        // Turkish style: 1.250,50
        clean = clean.replaceAll('.', '').replaceAll(',', '.');
      } else {
        // US style: 1,250.50
        clean = clean.replaceAll(',', '');
      }
    } else if (clean.contains(',')) {
      clean = clean.replaceAll(',', '.');
    }

    final double? parsed = double.tryParse(clean);
    if (parsed == null) return 0;

    // Convert to minor unit without floating point inaccuracy
    return (parsed * 100).round();
  }

  /// Converts minor units to a simple decimal string for editing in text fields (e.g. "150,50")
  static String toEditString(int minorAmount) {
    if (minorAmount == 0) return '';
    final double major = minorAmount / 100.0;
    return major.toStringAsFixed(2).replaceAll('.', ',');
  }
}
