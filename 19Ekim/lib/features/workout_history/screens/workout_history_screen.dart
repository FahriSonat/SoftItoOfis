import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/core/utils/formatters.dart';
import 'package:susadim/features/exercise/providers/exercise_provider.dart';
import 'package:susadim/features/water_tracking/providers/water_provider.dart';

class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterState = ref.watch(waterProvider);
    final exerciseState = ref.watch(exerciseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrenman ve Sağlık Geçmişi'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Haftalık Özet Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Haftalık Performans',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _DayIndicator(day: 'Pzt', active: true, value: '100%'),
                      _DayIndicator(day: 'Sal', active: true, value: '80%'),
                      _DayIndicator(day: 'Çar', active: false, value: '-'),
                      _DayIndicator(day: 'Per', active: true, value: '95%'),
                      _DayIndicator(day: 'Cum', active: true, value: '100%'),
                      _DayIndicator(day: 'Cmt', active: true, value: '70%'),
                      _DayIndicator(day: 'Paz', active: false, value: '-'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Bugünün İstatistikleri',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _HistoryStatCard(
              title: 'Toplam Su Tüketimi',
              value: Formatters.formatWater(waterState.currentAmountMl),
              subtitle: 'Hedef: ${Formatters.formatWater(waterState.dailyGoalMl)}',
              icon: Icons.water_drop_rounded,
              accentColor: AppColors.primary,
            ),
            const SizedBox(height: 10),
            _HistoryStatCard(
              title: 'Antrenman Süresi',
              value: '${exerciseState.totalMinutes} Dakika',
              subtitle: 'Yakılan: ${exerciseState.totalCaloriesBurned} kcal',
              icon: Icons.fitness_center_rounded,
              accentColor: AppColors.secondary,
            ),
            const SizedBox(height: 10),
            _HistoryStatCard(
              title: 'Tamamlanan Hedef Oranı',
              value: '%${(waterState.progressPercentage * 100).toInt()}',
              subtitle: 'Günün genel hidrasyon başarısı',
              icon: Icons.emoji_events_rounded,
              accentColor: AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }
}

class _DayIndicator extends StatelessWidget {
  final String day;
  final bool active;
  final String value;

  const _DayIndicator({
    required this.day,
    required this.active,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primaryContainer : AppColors.surfaceLight,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Icon(
              active ? Icons.check_rounded : Icons.remove_rounded,
              size: 20,
              color: active ? AppColors.primary : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _HistoryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _HistoryStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withAlpha(30),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
