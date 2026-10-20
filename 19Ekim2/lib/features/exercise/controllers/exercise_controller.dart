import 'package:flutter/foundation.dart';
import '../models/exercise_model.dart';

class ExerciseController {
  static final ExerciseController _instance = ExerciseController._internal();
  factory ExerciseController() => _instance;

  ExerciseController._internal() {
    _initDefaults();
  }

  final ValueNotifier<int> totalBurnedCalories = ValueNotifier<int>(420);
  final int dailyBurnedGoal = 600;
  final ValueNotifier<List<ExerciseModel>> exercises = ValueNotifier<List<ExerciseModel>>([]);

  void _initDefaults() {
    exercises.value = const [
      ExerciseModel(
        id: '1',
        title: 'HIIT & Koşu Bandı',
        durationMinutes: 30,
        burnedCalories: 280,
        category: 'Kardiyo',
      ),
      ExerciseModel(
        id: '2',
        title: 'Göğüs & Kol Antrenmanı',
        durationMinutes: 45,
        burnedCalories: 140,
        category: 'Ağırlık',
      ),
    ];
  }

  void addExercise(String title, int duration, int calories, String category) {
    final item = ExerciseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      durationMinutes: duration,
      burnedCalories: calories,
      category: category,
    );
    exercises.value = [item, ...exercises.value];
    totalBurnedCalories.value += calories;
  }

  void dispose() {
    totalBurnedCalories.dispose();
    exercises.dispose();
  }
}
