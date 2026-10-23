import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../domain/badge_model.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  IconData _getBadgeIcon(String key) {
    switch (key) {
      case 'flag':
        return Icons.flag_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'verified':
        return Icons.verified_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'menu_book':
        return Icons.menu_book_rounded;
      case 'directions_run':
        return Icons.directions_run_rounded;
      case 'refresh':
        return Icons.refresh_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earnedAsync = ref.watch(earnedBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Geri',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('Rozetlerim ve Başarılar'),
      ),

      body: earnedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (earnedBadges) {
          final earnedMap = {for (final b in earnedBadges) b.badgeId: b};

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.9,
            ),
            itemCount: BadgeDefinition.all.length,
            itemBuilder: (ctx, i) {
              final badge = BadgeDefinition.all[i];
              final userBadge = earnedMap[badge.id];
              final isUnlocked = userBadge != null;

              return Card(
                color: isUnlocked
                    ? AppColors.surface
                    : AppColors.surface.withOpacity(0.4),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dCtx) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              _getBadgeIcon(badge.iconKey),
                              color: isUnlocked
                                  ? AppColors.warning
                                  : AppColors.textDisabled,
                            ),
                            const SizedBox(width: 8),
                            Text(badge.title),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.description,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Koşul: ${badge.requirementDescription}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                            if (isUnlocked) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Kazanıldı: ${DateFormat('d MMMM yyyy', 'tr_TR').format(userBadge.earnedAt)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dCtx),
                            child: const Text('Kapat'),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: AppSpacing.roundedLg,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isUnlocked
                                ? AppColors.warning.withOpacity(0.15)
                                : AppColors.surfaceHigh,
                          ),
                          child: Icon(
                            _getBadgeIcon(badge.iconKey),
                            size: 36,
                            color: isUnlocked
                                ? AppColors.warning
                                : AppColors.textDisabled,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          badge.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isUnlocked
                                ? AppColors.textPrimary
                                : AppColors.textDisabled,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isUnlocked ? 'Kazanıldı ✓' : 'Kilitli',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isUnlocked
                                ? AppColors.success
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
