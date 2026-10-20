import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// [WaterTrackingCard]
/// Su tüketimi durumunu ve ilerleme çubuğunu gösteren kart bileşeni.
class WaterTrackingCard extends StatelessWidget {
  final int currentWaterMl;
  final int dailyGoalWaterMl;
  final double progress;
  final bool isGoalReached;

  const WaterTrackingCard({
    super.key,
    required this.currentWaterMl,
    required this.dailyGoalWaterMl,
    required this.progress,
    required this.isGoalReached,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük Hedef',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dailyGoalWaterMl ml',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isGoalReached
                        ? AppColors.success.withAlpha(50)
                        : AppColors.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isGoalReached ? AppColors.success : AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isGoalReached ? Icons.check_circle : Icons.water_drop,
                        color: isGoalReached ? AppColors.success : AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isGoalReached ? 'Hedef Tamamlandı!' : '%${(progress * 100).toInt()}',
                        style: TextStyle(
                          color: isGoalReached ? AppColors.success : AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 18,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isGoalReached ? AppColors.success : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$currentWaterMl',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ $dailyGoalWaterMl ml',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
