import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/nutrition_model.dart';

class NutritionCard extends StatelessWidget {
  final NutritionModel meal;
  final VoidCallback? onTap;

  const NutritionCard({
    super.key,
    required this.meal,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.restaurant_rounded,
            color: AppColors.tertiary,
            size: 24,
          ),
        ),
        title: Text(
          meal.mealName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${meal.mealType} • P: ${meal.proteinGrams.toInt()}g | K: ${meal.carbsGrams.toInt()}g | Y: ${meal.fatGrams.toInt()}g',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          '+${meal.calories} kcal',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.tertiary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
