import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_card.dart';

class DailySpendableCard extends StatelessWidget {
  final int dailySpendableMinor;
  final int todayExpenseMinor;
  final int dailyLimitMinor;
  final int currentWeekExpenseMinor;
  final int weeklyLimitMinor;
  final int currentMonthExpenseMinor;
  final int monthlyLimitMinor;
  final bool isHidden;

  const DailySpendableCard({
    super.key,
    required this.dailySpendableMinor,
    required this.todayExpenseMinor,
    required this.dailyLimitMinor,
    required this.currentWeekExpenseMinor,
    required this.weeklyLimitMinor,
    required this.currentMonthExpenseMinor,
    required this.monthlyLimitMinor,
    required this.isHidden,
  });

  @override
  Widget build(BuildContext context) {
    final remainingDays = DateFormatter.daysRemainingInMonth(DateTime.now());

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.speed_rounded, color: AppColors.indicatorBlue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Kalan Günlük Harcanabilir',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Tahmin',
                  style: TextStyle(
                    color: AppColors.indicatorBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                CurrencyFormatter.format(dailySpendableMinor, isHidden: isHidden),
                style: const TextStyle(
                  color: AppColors.indicatorBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ gün (kalan $remainingDays gün)',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // Limit breakdowns: Günlük, Haftalık, Aylık
          _buildLimitRow(
            label: 'Bugünkü Harcama',
            spentMinor: todayExpenseMinor,
            limitMinor: dailyLimitMinor,
            isHidden: isHidden,
          ),
          const SizedBox(height: 10),
          _buildLimitRow(
            label: 'Bu Haftaki Harcama',
            spentMinor: currentWeekExpenseMinor,
            limitMinor: weeklyLimitMinor,
            isHidden: isHidden,
          ),
          const SizedBox(height: 10),
          _buildLimitRow(
            label: 'Bu Ayki Harcama',
            spentMinor: currentMonthExpenseMinor,
            limitMinor: monthlyLimitMinor,
            isHidden: isHidden,
          ),
        ],
      ),
    );
  }

  Widget _buildLimitRow({
    required String label,
    required int spentMinor,
    required int limitMinor,
    required bool isHidden,
  }) {
    final double ratio = limitMinor > 0 ? (spentMinor / limitMinor) : 0.0;
    final bool isOver = ratio >= 1.0;
    final bool isWarning = ratio >= 0.80 && !isOver;

    Color barColor = AppColors.indicatorBlue;
    if (isOver) {
      barColor = AppColors.criticalBackground;
    } else if (isWarning) {
      barColor = AppColors.warningBackground;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            Row(
              children: [
                Text(
                  CurrencyFormatter.format(spentMinor, isHidden: isHidden),
                  style: TextStyle(
                    color: isOver ? AppColors.expense : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  ' / ${CurrencyFormatter.format(limitMinor, isHidden: isHidden)}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: AppColors.surfaceRaised,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
