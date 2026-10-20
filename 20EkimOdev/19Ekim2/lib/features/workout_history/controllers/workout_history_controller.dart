import 'package:flutter/foundation.dart';
import '../models/workout_history_model.dart';

class WorkoutHistoryController {
  static final WorkoutHistoryController _instance = WorkoutHistoryController._internal();
  factory WorkoutHistoryController() => _instance;

  WorkoutHistoryController._internal() {
    _initDefaults();
  }

  final ValueNotifier<List<WorkoutHistoryModel>> history = ValueNotifier<List<WorkoutHistoryModel>>([]);

  void _initDefaults() {
    final now = DateTime.now();
    history.value = [
      WorkoutHistoryModel(
        id: '1',
        workoutName: 'Tüm Vücut Fonksiyonel Antrenman',
        date: now.subtract(const Duration(days: 1)),
        durationMinutes: 55,
        burnedCalories: 450,
        totalWaterConsumedMl: 1000,
      ),
      WorkoutHistoryModel(
        id: '2',
        workoutName: 'Bacak & Karın Günü',
        date: now.subtract(const Duration(days: 2)),
        durationMinutes: 50,
        burnedCalories: 380,
        totalWaterConsumedMl: 750,
      ),
      WorkoutHistoryModel(
        id: '3',
        workoutName: 'Açık Hava Koşusu & Esneme',
        date: now.subtract(const Duration(days: 3)),
        durationMinutes: 40,
        burnedCalories: 320,
        totalWaterConsumedMl: 500,
      ),
    ];
  }

  void dispose() {
    history.dispose();
  }
}
