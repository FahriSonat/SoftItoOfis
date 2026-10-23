import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/streaks/domain/streak_engine.dart';
import 'streak_ring.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final StreakResult streak;
  final VoidCallback onTap;
  final VoidCallback? onQuickAction;
  final String? quickActionLabel;

  const HabitCard({
    super.key,
    required this.habit,
    required this.streak,
    required this.onTap,
    this.onQuickAction,
    this.quickActionLabel,
  });

  Color _getStageColor() {
    if (streak.status == StreakStatus.broken || streak.isInGracePeriod) {
      return AppColors.restart;
    }
    if (habit.kind.isNegative) {
      final stage = streak.colorStage.clamp(
        0,
        AppColors.negativeStages.length - 1,
      );
      return AppColors.negativeStages[stage];
    } else {
      final stage = streak.colorStage.clamp(
        0,
        AppColors.positiveStages.length - 1,
      );
      return AppColors.positiveStages[stage];
    }
  }

  IconData _getCategoryIcon() {
    switch (habit.category) {
      case HabitCategory.smoking:
        return Icons.smoke_free_rounded;
      case HabitCategory.alcohol:
        return Icons.no_drinks_rounded;
      case HabitCategory.unhealthyEating:
      case HabitCategory.healthyEating:
        return Icons.restaurant_rounded;
      case HabitCategory.gambling:
        return Icons.casino_rounded;
      case HabitCategory.gaming:
        return Icons.sports_esports_rounded;
      case HabitCategory.medication:
        return Icons.medication_rounded;
      case HabitCategory.socialMedia:
        return Icons.phonelink_erase_rounded;
      case HabitCategory.shopping:
        return Icons.shopping_bag_rounded;
      case HabitCategory.water:
        return Icons.water_drop_rounded;
      case HabitCategory.walking:
        return Icons.directions_walk_rounded;
      case HabitCategory.running:
        return Icons.directions_run_rounded;
      case HabitCategory.fitness:
        return Icons.fitness_center_rounded;
      case HabitCategory.swimming:
        return Icons.pool_rounded;
      case HabitCategory.yoga:
        return Icons.self_improvement_rounded;
      case HabitCategory.reading:
        return Icons.menu_book_rounded;
      case HabitCategory.instrument:
        return Icons.music_note_rounded;
      case HabitCategory.art:
        return Icons.palette_rounded;
      case HabitCategory.brainTraining:
        return Icons.psychology_rounded;
      default:
        return habit.kind.isNegative
            ? Icons.shield_rounded
            : Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stageColor = _getStageColor();
    final isBroken = streak.status == StreakStatus.broken;
    final isGrace = streak.isInGracePeriod;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedLg,
        side: BorderSide(
          color: (isBroken || isGrace)
              ? AppColors.restart
              : AppColors.borderSubtle,
          width: (isBroken || isGrace) ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedLg,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Küçük Streak Halkası ve İkon
                  StreakRing(
                    size: 48,
                    strokeWidth: 4.5,
                    progress: habit.kind.isNegative
                        ? (isBroken ? 0.0 : (streak.colorStage + 1) / 6)
                        : streak.currentProgress,
                    strokeColor: stageColor,
                    isBroken: isBroken,
                    child: Icon(
                      _getCategoryIcon(),
                      size: 22,
                      color: stageColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Başlık ve Aşama
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: stageColor.withOpacity(0.15),
                                borderRadius: AppSpacing.roundedSm,
                                border: Border.all(
                                  color: stageColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                streak.stageLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: stageColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              habit.kind.isNegative
                                  ? 'Uzak durma'
                                  : 'Düzenli hedef',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Streak Değeri
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isBroken ? '0' : '${streak.value}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isBroken
                              ? AppColors.restart
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        streak.unit == StreakUnit.hours
                            ? 'saat'
                            : (streak.unit == StreakUnit.days
                                  ? 'gün'
                                  : 'periyot'),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (streak.isInGracePeriod) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.hourglass_top_rounded,
                      color: AppColors.restart,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Ekstra 24s Süre:',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.restart,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${streak.gracePeriodRemaining?.inHours ?? 0}s kaldı',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.restart,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: streak.gracePeriodProgress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceHigh,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.restart,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.borderSubtle),
              const SizedBox(height: AppSpacing.sm),
              // Hızlı Eylem veya Durum Özeti
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.kind.isNegative
                        ? 'En iyi seri: ${streak.longestStreak} gün'
                        : 'En iyi seri: ${streak.longestStreak} periyot',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (onQuickAction != null && quickActionLabel != null)
                    FilledButton.tonal(
                      onPressed: onQuickAction,
                      style: FilledButton.styleFrom(
                        backgroundColor: habit.kind.isNegative
                            ? AppColors.surfaceHigh
                            : stageColor.withOpacity(0.2),
                        foregroundColor: habit.kind.isNegative
                            ? AppColors.restart
                            : stageColor,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(quickActionLabel!),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
