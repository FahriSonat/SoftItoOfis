class MealItem {
  final String id;
  final String title;
  final String mealType; // Kahvaltı, Öğle, Akşam, Ara Öğün
  final int calories;
  final double proteinGrams;
  final DateTime? timestamp;

  const MealItem({
    required this.id,
    required this.title,
    required this.mealType,
    required this.calories,
    required this.proteinGrams,
    this.timestamp,
  });
}
