import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/features/nutrition/models/meal_item.dart';

class NutritionState {
  final int dailyGoalCalories;
  final List<MealItem> meals;

  const NutritionState({
    this.dailyGoalCalories = AppConstants.defaultDailyCalories,
    this.meals = const [
      MealItem(
        id: '1',
        title: 'Yulaf Lapası & Muz & Fıstık Ezmesi',
        mealType: 'Kahvaltı',
        calories: 450,
        proteinGrams: 18.0,
        timestamp: null,
      ),
      MealItem(
        id: '2',
        title: 'Izgara Tavuk Göğsü & Basmati Pirinç',
        mealType: 'Öğle',
        calories: 620,
        proteinGrams: 48.0,
        timestamp: null,
      ),
    ],
  });

  int get totalCalories => meals.fold(0, (sum, m) => sum + m.calories);

  double get totalProtein => meals.fold(0.0, (sum, m) => sum + m.proteinGrams);

  int get remainingCalories {
    final diff = dailyGoalCalories - totalCalories;
    return diff > 0 ? diff : 0;
  }

  double get progressPercentage {
    if (dailyGoalCalories == 0) return 0.0;
    final progress = totalCalories / dailyGoalCalories;
    return progress > 1.0 ? 1.0 : progress;
  }

  NutritionState copyWith({
    int? dailyGoalCalories,
    List<MealItem>? meals,
  }) {
    return NutritionState(
      dailyGoalCalories: dailyGoalCalories ?? this.dailyGoalCalories,
      meals: meals ?? this.meals,
    );
  }
}

class NutritionNotifier extends Notifier<NutritionState> {
  @override
  NutritionState build() {
    return const NutritionState();
  }

  void addMeal({
    required String title,
    required String mealType,
    required int calories,
    required double proteinGrams,
  }) {
    final newMeal = MealItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      mealType: mealType,
      calories: calories,
      proteinGrams: proteinGrams,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(meals: [newMeal, ...state.meals]);
  }

  void removeMeal(String id) {
    state = state.copyWith(
      meals: state.meals.where((m) => m.id != id).toList(),
    );
  }
}

final nutritionProvider =
    NotifierProvider<NutritionNotifier, NutritionState>(NutritionNotifier.new);
