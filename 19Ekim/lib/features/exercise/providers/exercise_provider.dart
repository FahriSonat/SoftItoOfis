import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/features/exercise/models/exercise_item.dart';

class ExerciseState {
  final int dailyGoalMinutes;
  final List<ExerciseItem> exercises;

  const ExerciseState({
    this.dailyGoalMinutes = AppConstants.defaultDailyWorkoutMinutes,
    this.exercises = const [
      ExerciseItem(
        id: '1',
        title: 'Koşu Bandı (Kardiyo)',
        category: 'Kardiyo',
        durationMinutes: 20,
        caloriesBurned: 180,
        timestamp: null,
      ),
      ExerciseItem(
        id: '2',
        title: 'Göğüs & Triceps Antrenmanı',
        category: 'Kuvvet',
        durationMinutes: 35,
        caloriesBurned: 240,
        timestamp: null,
      ),
    ],
  });

  int get totalMinutes =>
      exercises.fold(0, (sum, item) => sum + item.durationMinutes);

  int get totalCaloriesBurned =>
      exercises.fold(0, (sum, item) => sum + item.caloriesBurned);

  double get progressPercentage {
    if (dailyGoalMinutes == 0) return 0.0;
    final progress = totalMinutes / dailyGoalMinutes;
    return progress > 1.0 ? 1.0 : progress;
  }

  ExerciseState copyWith({
    int? dailyGoalMinutes,
    List<ExerciseItem>? exercises,
  }) {
    return ExerciseState(
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      exercises: exercises ?? this.exercises,
    );
  }
}

class ExerciseNotifier extends Notifier<ExerciseState> {
  @override
  ExerciseState build() {
    return const ExerciseState();
  }

  void addExercise({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    final newItem = ExerciseItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(exercises: [newItem, ...state.exercises]);
  }

  void removeExercise(String id) {
    state = state.copyWith(
      exercises: state.exercises.where((e) => e.id != id).toList(),
    );
  }
}

final exerciseProvider =
    NotifierProvider<ExerciseNotifier, ExerciseState>(ExerciseNotifier.new);
