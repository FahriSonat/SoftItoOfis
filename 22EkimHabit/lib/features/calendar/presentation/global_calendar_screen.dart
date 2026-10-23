import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class GlobalCalendarScreen extends ConsumerStatefulWidget {
  const GlobalCalendarScreen({super.key});

  @override
  ConsumerState<GlobalCalendarScreen> createState() =>
      _GlobalCalendarScreenState();
}

class _GlobalCalendarScreenState extends ConsumerState<GlobalCalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsListProvider);
    final now = DateTime.now();

    // Son 14 günü gösteren yatay takvim
    final days = List.generate(14, (i) => now.subtract(Duration(days: 13 - i)));

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
        title: const Text('Takvim ve Geçmiş'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yatay Gün Seçici
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            color: AppColors.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: days.length,
              itemBuilder: (ctx, i) {
                final d = days[i];
                final isSelected =
                    d.year == _selectedDate.year &&
                    d.month == _selectedDate.month &&
                    d.day == _selectedDate.day;
                final isToday =
                    d.year == now.year &&
                    d.month == now.month &&
                    d.day == now.day;

                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = d),
                  child: Container(
                    width: 54,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.surfaceHigh
                          : Colors.transparent,
                      borderRadius: AppSpacing.roundedMd,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.info
                            : (isToday
                                  ? AppColors.borderStrong
                                  : AppColors.borderSubtle),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E', 'tr_TR').format(d),
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.info
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle),

          // Seçili Gün Başlığı
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const Icon(
                  Icons.event_note_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat(
                    'd MMMM yyyy, EEEE',
                    'tr_TR',
                  ).format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // O günkü durum
          Expanded(
            child: habitsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (habits) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  children: [
                    ...habits.map((h) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: Icon(
                            h.kind.isNegative
                                ? Icons.shield_rounded
                                : Icons.star_rounded,
                            color: h.kind.isNegative
                                ? AppColors.negativeStages.first
                                : AppColors.positiveStages.first,
                          ),
                          title: Text(
                            h.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            h.kind.isNegative
                                ? 'Uzak durma devam ediyor'
                                : 'Hedef: ${h.targetValue} ${h.unit}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
