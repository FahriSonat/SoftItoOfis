import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/exercise_controller.dart';
import '../models/exercise_model.dart';
import '../widgets/exercise_card.dart';

class ExerciseView extends StatelessWidget {
  final ExerciseController _controller = ExerciseController();

  ExerciseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egzersiz & Antrenman'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'exercise_fab',
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.background,
        onPressed: () => _showAddExerciseDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Antrenman Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exercise Calorie Summary Card
            ValueListenableBuilder<int>(
              valueListenable: _controller.totalBurnedCalories,
              builder: (context, totalCalories, _) {
                final double progress = (totalCalories / _controller.dailyBurnedGoal).clamp(0.0, 1.0);
                final int percent = (progress * 100).toInt();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Bugün Yakılan Kalori',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '%$percent',
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$totalCalories',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '/ ${_controller.dailyBurnedGoal} kcal',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'Yapılan Antrenmanlar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            ValueListenableBuilder<List<ExerciseModel>>(
              valueListenable: _controller.exercises,
              builder: (context, exercises, _) {
                if (exercises.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text('Henüz egzersiz kaydı bulunmuyor.'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseCard(exercise: exercises[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'Kuvvet Antrenmanı');
    final durationCtrl = TextEditingController(text: '45');
    final caloriesCtrl = TextEditingController(text: '220');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Yeni Antrenman Ekle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Egzersiz Adı'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Süre (dk)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: caloriesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Kalori (kcal)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                onPressed: () {
                  final title = titleCtrl.text.trim();
                  final duration = int.tryParse(durationCtrl.text) ?? 30;
                  final calories = int.tryParse(caloriesCtrl.text) ?? 150;
                  if (title.isNotEmpty) {
                    _controller.addExercise(title, duration, calories, 'Fitness');
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Kaydet', style: TextStyle(color: AppColors.background)),
              ),
            ],
          ),
        );
      },
    );
  }
}
