/// Turkish date formatting utilities
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  static const List<String> _monthsShort = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'
  ];

  static const List<String> _weekdays = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'
  ];

  /// Returns full date: "21 Ekim 2026"
  static String formatFull(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Returns short date: "21 Eki"
  static String formatShort(DateTime date) {
    return '${date.day} ${_monthsShort[date.month - 1]}';
  }

  /// Returns month and year: "Ekim 2026"
  static String formatMonthYear(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
  }

  /// Returns standard dot format: "21.10.2026"
  static String formatDotted(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d.$m.${date.year}';
  }

  /// Returns friendly relative date: "Bugün", "Dün", or "21 Eki"
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final difference = target.difference(today).inDays;
    if (difference == 0) return 'Bugün';
    if (difference == -1) return 'Dün';
    if (difference == 1) return 'Yarın';

    return formatShort(date);
  }

  /// Returns remaining days in current month
  static int daysRemainingInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0).day;
    final remaining = lastDay - date.day + 1;
    return remaining > 0 ? remaining : 1;
  }
}
