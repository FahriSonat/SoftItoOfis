import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/onboarding_model.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (item.iconName) {
      case 'water':
        icon = Icons.water_drop_rounded;
        color = AppColors.primary;
        break;
      case 'fitness':
        icon = Icons.fitness_center_rounded;
        color = AppColors.secondary;
        break;
      default:
        icon = Icons.restaurant_rounded;
        color = AppColors.tertiary;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 72),
          ),
          const SizedBox(height: 36),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
