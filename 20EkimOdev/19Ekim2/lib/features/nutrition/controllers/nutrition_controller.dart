import 'package:flutter/foundation.dart';
import '../models/nutrition_model.dart';

class NutritionController {
  static final NutritionController _instance = NutritionController._internal();
  factory NutritionController() => _instance;

  NutritionController._internal() {
    _initDefaults();
  }

  final ValueNotifier<int> totalConsumedCalories = ValueNotifier<int>(1450);
  final int dailyCalorieGoal = 2200;
  final ValueNotifier<List<NutritionModel>> meals = ValueNotifier<List<NutritionModel>>([]);

  void _initDefaults() {
    meals.value = const [
      NutritionModel(
        id: '1',
        mealName: 'Yulaf Lapası & Muz & Fıstık Ezmesi',
        calories: 520,
        proteinGrams: 22,
        carbsGrams: 75,
        fatGrams: 14,
        mealType: 'Kahvaltı',
      ),
      NutritionModel(
        id: '2',
        mealName: 'Izgara Tavuk Göğsü & Basmati Pirinç',
        calories: 680,
        proteinGrams: 55,
        carbsGrams: 80,
        fatGrams: 12,
        mealType: 'Öğle Yemeği',
      ),
      NutritionModel(
        id: '3',
        mealName: 'Whey Protein Shake',
        calories: 250,
        proteinGrams: 30,
        carbsGrams: 8,
        fatGrams: 3,
        mealType: 'Ara Öğün',
      ),
    ];
  }

  void addMeal(String name, int calories, double protein, double carbs, double fat, String mealType) {
    final item = NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      mealName: name,
      calories: calories,
      proteinGrams: protein,
      carbsGrams: carbs,
      fatGrams: fat,
      mealType: mealType,
    );
    meals.value = [item, ...meals.value];
    totalConsumedCalories.value += calories;
  }

  void dispose() {
    totalConsumedCalories.dispose();
    meals.dispose();
  }
}
