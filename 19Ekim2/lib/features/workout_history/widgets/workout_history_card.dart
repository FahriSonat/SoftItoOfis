import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/workout_history_model.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final WorkoutHistoryModel item;
  final VoidCallback? onTap;

  const WorkoutHistoryCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = '${item.date.day}.${item.date.month}.${item.date.year}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.workoutName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatItem(
                  icon: Icons.timer_outlined,
                  value: '${item.durationMinutes} dk',
                  label: 'Süre',
                  color: AppColors.accent,
                ),
                _StatItem(
                  icon: Icons.local_fire_department_rounded,
                  value: '${item.burnedCalories} kcal',
                  label: 'Yakılan',
                  color: AppColors.secondary,
                ),
                _StatItem(
                  icon: Icons.water_drop_rounded,
                  value: '${item.totalWaterConsumedMl} ml',
                  label: 'İçilen Su',
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
