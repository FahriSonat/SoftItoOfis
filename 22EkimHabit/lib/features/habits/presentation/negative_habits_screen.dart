import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/habit_card.dart';
import '../domain/habit.dart';
import 'providers/habit_providers.dart';

class NegativeHabitsScreen extends ConsumerWidget {
  const NegativeHabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uzak Durduklarım'),
        actions: [
          IconButton(
            tooltip: 'Yeni Negatif Hedef',
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/habit/new?kind=negative'),
          ),
        ],
      ),
      body: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Hata: $err')),
        data: (habits) {
          final negatives = habits.where((h) => h.kind.isNegative).toList();

          if (negatives.isEmpty) {
            return EmptyStateView(
              icon: Icons.shield_rounded,
              title: 'Henüz Bir Hedef Yok',
              description: 'Hazır olduğunda bir hedef ekleyebilir ve kendi hızında ilerleyebilirsin.',
              buttonText: '+ Negatif Alışkanlık Ekle',
              onButtonPressed: () => context.push('/habit/new?kind=negative'),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              const Text(
                'Geçen her süre ilerlemenin bir parçası.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...negatives.map((habit) => _NegativeHabitItem(habit: habit)),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
    );
  }
}

class _NegativeHabitItem extends ConsumerWidget {
  final Habit habit;
  const _NegativeHabitItem({required this.habit});

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

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: HabitCard(
            habit: habit,
            streak: detail.streak,
            onTap: () => context.push('/habit/${habit.id}'),
            quickActionLabel: 'Zorlanıyorum',
            onQuickAction: () =>
                context.push('/habit/${habit.id}/urge-support'),
          ),
        );
      },
    );
  }
}
