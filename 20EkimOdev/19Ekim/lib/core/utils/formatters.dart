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

  static String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '$hours sa $mins dk';
    }
    return '$mins dk';
  }
}
