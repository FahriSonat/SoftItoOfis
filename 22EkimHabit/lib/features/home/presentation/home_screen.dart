import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/habit_card.dart';
import '../../habits/domain/habit.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsListProvider);
    final userAsync = ref.watch(userProfileProvider);
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM', 'tr_TR').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userAsync.value != null
                  ? 'Merhaba, ${userAsync.value!.displayName}'
                  : 'Bugün nasıl gidiyor?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              dateStr,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceHigh,
              child: Text(
                userAsync.value?.avatar ?? '🌱',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Hata: $err')),
        data: (habits) {
          if (habits.isEmpty) {
            return EmptyStateView(
              icon: Icons.track_changes_rounded,
              title: 'İlk Adımını Seç',
              description: 'Pozitif ve negatif alışkanlıklarını takip ederek dengeni kur.',
              buttonText: '+ Alışkanlık Ekle',
              onButtonPressed: () => context.push('/habit/new'),
            );
          }

          final negativeHabits = habits
              .where((h) => h.kind.isNegative)
              .toList();
          final positiveHabits = habits
              .where((h) => h.kind.isPositive)
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              // Günlük Denge Özeti Kartı
              _buildBalanceSummaryCard(
                context,
                negativeHabits.length,
                positiveHabits.length,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Motivasyon Mesajı
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh.withOpacity(0.5),
                  borderRadius: AppSpacing.roundedMd,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.info,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Bir an bütün emeğini silmez. Şimdi küçük bir adım seçebilirsin.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Denge Koçu AI Kartı
              InkWell(
                onTap: () => context.push('/ai-coach'),
                borderRadius: AppSpacing.roundedMd,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: AppSpacing.roundedMd,
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: AppColors.info,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Denge Koçu ile Konuş',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Zorlandığın anlarda şefkatli rehberlik ve mikro adımlar al.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Alışkanlıklar Başlığı ve Hızlı İşlemler
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Aktif Alışkanlıklar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/habit/new'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Yeni Ekle'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Tüm alışkanlık kartları
              ...habits.map((habit) => _HabitCardItem(habit: habit)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/habit/new'),
        backgroundColor: AppColors.positiveStages[1],
        foregroundColor: AppColors.textPrimary,
        tooltip: 'Yeni Alışkanlık Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBalanceSummaryCard(
    BuildContext context,
    int negativeCount,
    int positiveCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.borderStrong),
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surfaceHigh.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Günlük Denge',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.balance_rounded,
                color: AppColors.positiveStages.last,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$negativeCount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.negativeStages.first,
                      ),
                    ),
                    const Text(
                      'Uzak Durulan',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 36, color: AppColors.borderSubtle),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$positiveCount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.positiveStages.first,
                      ),
                    ),
                    const Text(
                      'Hayata Katılan',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Çift renkli ince ilerleme çizgisi
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: negativeCount == 0 ? 1 : negativeCount,
                    child: Container(color: AppColors.negativeStages.first),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: positiveCount == 0 ? 1 : positiveCount,
                    child: Container(color: AppColors.positiveStages.first),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitCardItem extends ConsumerWidget {
  final Habit habit;
  const _HabitCardItem({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(habitDetailProvider(habit.id));

    return detailAsync.when(
      loading: () => const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const SizedBox(),
      data: (detail) {
        if (detail == null) return const SizedBox();

        String? quickLabel;
        VoidCallback? quickAction;

        if (habit.kind.isNegative) {
          quickLabel = 'Zorlanıyorum';
          quickAction = () => context.push('/habit/${habit.id}/urge-support');
        } else {
          if (habit.category == HabitCategory.water) {
            quickLabel = '+250 ml';
            quickAction = () => ref
                .read(habitsListProvider.notifier)
                .addEntry(
                  habitId: habit.id,
                  value: 250.0,
                  note: 'Hızlı 250 ml eklendi',
                );
          } else if (habit.category == HabitCategory.reading) {
            quickLabel = '+10 Sayfa';
            quickAction = () => ref
                .read(habitsListProvider.notifier)
                .addEntry(
                  habitId: habit.id,
                  value: 10.0,
                  note: 'Hızlı 10 sayfa eklendi',
                );
          } else {
            quickLabel = 'Tamamla';
            quickAction = () => ref
                .read(habitsListProvider.notifier)
                .addEntry(
                  habitId: habit.id,
                  value: habit.targetValue,
                  note: 'Bugün tamamlandı',
                );
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: HabitCard(
            habit: habit,
            streak: detail.streak,
            onTap: () => context.push('/habit/${habit.id}'),
            quickActionLabel: quickLabel,
            onQuickAction: quickAction,
          ),
        );
      },
    );
  }
}
