import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_card.dart';

class BalanceCard extends StatelessWidget {
  final int netBalanceMinor;
  final int incomeMinor;
  final int expenseMinor;
  final bool isHidden;
  final VoidCallback onToggleHidden;

  const BalanceCard({
    super.key,
    required this.netBalanceMinor,
    required this.incomeMinor,
    required this.expenseMinor,
    required this.isHidden,
    required this.onToggleHidden,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPositive = netBalanceMinor >= 0;

    return AppCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Dönem Net Bakiyesi',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: isHidden ? 'Tutarları göster' : 'Tutarları gizle',
                    onPressed: onToggleHidden,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? AppColors.incomeSurface : AppColors.expenseSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isPositive ? AppColors.income.withOpacity(0.4) : AppColors.expense.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.check_circle_outline : Icons.error_outline,
                      size: 14,
                      color: isPositive ? AppColors.income : AppColors.expense,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isPositive ? 'Pozitif Akış' : 'Negatif Akış',
                      style: TextStyle(
                        color: isPositive ? AppColors.income : AppColors.expense,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            CurrencyFormatter.format(netBalanceMinor, isHidden: isHidden, showSign: true),
            style: TextStyle(
              color: isPositive ? AppColors.textPrimary : AppColors.expense,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.income,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Toplam Gelir',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                        Text(
                          CurrencyFormatter.format(incomeMinor, isHidden: isHidden),
                          style: const TextStyle(
                            color: AppColors.income,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 28, color: AppColors.border),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.expense,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Toplam Gider',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                        ),
                        Text(
                          CurrencyFormatter.format(expenseMinor, isHidden: isHidden),
                          style: const TextStyle(
                            color: AppColors.expense,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
