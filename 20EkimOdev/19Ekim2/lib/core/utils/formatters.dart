class Formatters {
  Formatters._();

  static String formatWater(int ml) {
    if (ml >= 1000) {
      final liters = (ml / 1000).toStringAsFixed(1);
      return '$liters L';
    }
    return '$ml ml';
  }

  static String formatCalories(int kcal) {
    return '$kcal kcal';
  }

  static String formatPercentage(double percent) {
    final value = (percent * 100).clamp(0, 999).toInt();
    return '%$value';
  }
}
