import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/habit_card.dart';
import '../domain/habit.dart';
import '../../streaks/domain/streak_engine.dart';
import 'providers/habit_providers.dart';

class PositiveHabitsScreen extends ConsumerWidget {
  const PositiveHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hayatıma Kattıklarım'),
        actions: [
          IconButton(
            tooltip: 'Yeni Pozitif Hedef',
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/habit/new?kind=positive'),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Hata: $err')),
        data: (habits) {
          final positives = habits.where((h) => h.kind.isPositive).toList();

          if (positives.isEmpty) {
            return EmptyStateView(
              icon: Icons.star_rounded,
              title: 'İlk Pozitif Adım',
              description: 'Su içme, kitap okuma veya yürüyüş gibi sürdürülebilir alışkanlıklar edin.',
              buttonText: '+ Pozitif Alışkanlık Ekle',
              onButtonPressed: () => context.push('/habit/new?kind=positive'),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              const Text(
                'Küçük adımlar tekrarlandığında güçlenir.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...positives.map((habit) => _PositiveHabitItem(habit: habit)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _PositiveHabitItem extends ConsumerWidget {
  final Habit habit;
  const _PositiveHabitItem({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(habitDetailProvider(habit.id));

    return detailAsync.when(
      loading: () => const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox(),
      data: (detail) {
        if (detail == null) return const SizedBox();

        String quickLabel = 'Tamamla';
        VoidCallback quickAction = () => ref
            .read(habitsListProvider.notifier)
            .addEntry(
              habitId: habit.id,
              value: habit.targetValue,
              note: 'Bugün tamamlandı',
            );

        if (habit.category == HabitCategory.water) {
          quickLabel = '+250 ml';
          quickAction = () => ref
              .read(habitsListProvider.notifier)
              .addEntry(
                habitId: habit.id,
                value: 250.0,
                note: '250 ml su içildi',
              );
        } else if (habit.category == HabitCategory.reading) {
          quickLabel = '+10 Sayfa';
          quickAction = () => ref
              .read(habitsListProvider.notifier)
              .addEntry(
                habitId: habit.id,
                value: 10.0,
                note: '10 sayfa kitap okundu',
              );
        }

        final isDoneToday = detail.streak.status == StreakStatus.completedToday;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: HabitCard(
            habit: habit,
            streak: detail.streak,
            onTap: () => context.push('/habit/${habit.id}'),
            quickActionLabel: isDoneToday ? 'Tamamlandı ✓' : quickLabel,
            onQuickAction: isDoneToday ? null : quickAction,
          ),
        );
      },
    );
  }
}
