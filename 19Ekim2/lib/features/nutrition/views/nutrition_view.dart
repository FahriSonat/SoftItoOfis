import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/nutrition_controller.dart';
import '../models/nutrition_model.dart';
import '../widgets/nutrition_card.dart';

class NutritionView extends StatelessWidget {
  final NutritionController _controller = NutritionController();

  NutritionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beslenme & Kalori'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'nutrition_fab',
        backgroundColor: AppColors.tertiary,
        foregroundColor: Colors.white,
        onPressed: () => _showAddMealDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Öğün Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Calorie Summary
            ValueListenableBuilder<int>(
              valueListenable: _controller.totalConsumedCalories,
              builder: (context, totalCalories, _) {
                final double progress = (totalCalories / _controller.dailyCalorieGoal).clamp(0.0, 1.0);
                final int remaining = (_controller.dailyCalorieGoal - totalCalories).clamp(0, 9999);

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
                              'Günlük Alınan Kalori',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '$remaining kcal kaldı',
                              style: const TextStyle(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w700,
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
                                color: AppColors.tertiary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '/ ${_controller.dailyCalorieGoal} kcal',
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
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tertiary),
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
                'Bugünkü Öğünler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            ValueListenableBuilder<List<NutritionModel>>(
              valueListenable: _controller.meals,
              builder: (context, meals, _) {
                if (meals.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text('Henüz eklenen öğün bulunmuyor.'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    return NutritionCard(meal: meals[index]);
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

  void _showAddMealDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: 'Ton Balıklı Salata');
    final calCtrl = TextEditingController(text: '350');
    final proteinCtrl = TextEditingController(text: '32');

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
                'Yeni Öğün Ekle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Yemek Adı'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: calCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Kalori (kcal)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: proteinCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Protein (g)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.tertiary),
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  final cal = int.tryParse(calCtrl.text) ?? 200;
                  final protein = double.tryParse(proteinCtrl.text) ?? 15.0;
                  if (name.isNotEmpty) {
                    _controller.addMeal(name, cal, protein, 20, 5, 'Öğün');
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
