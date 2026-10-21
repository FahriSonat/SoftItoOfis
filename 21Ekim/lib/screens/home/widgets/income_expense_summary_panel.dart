import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/models/transaction.dart';
import '../../../core/widgets/app_card.dart';

class IncomeExpenseSummaryPanel extends StatelessWidget {
  final int incomeTotalMinor;
  final int expenseTotalMinor;
  final List<Transaction> recentIncomes;
  final List<Transaction> recentExpenses;
  final bool isHidden;
  final VoidCallback onIncomeTap;
  final VoidCallback onExpenseTap;

  const IncomeExpenseSummaryPanel({
    super.key,
    required this.incomeTotalMinor,
    required this.expenseTotalMinor,
    required this.recentIncomes,
    required this.recentExpenses,
    required this.isHidden,
    required this.onIncomeTap,
    required this.onExpenseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SOLDAN GELİR PANELİ (Yeşil zeminli ve yeşil değerler)
        Expanded(
          child: AppCard(
            backgroundColor: AppColors.incomeSurface,
            border: Border.all(color: AppColors.income.withOpacity(0.3), width: 1),
            padding: const EdgeInsets.all(14),
            onTap: onIncomeTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.payments_outlined, color: AppColors.income, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Gelir Özeti',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.income, size: 18),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  CurrencyFormatter.format(incomeTotalMinor, isHidden: isHidden),
                  style: const TextStyle(
                    color: AppColors.income,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${recentIncomes.length} işlem kaydı',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (recentIncomes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 8),
                  ...recentIncomes.take(2).map((tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tx.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(tx.amountMinor, isHidden: isHidden),
                          style: const TextStyle(
                            color: AppColors.income,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // SAĞDA GİDER PANELİ (Kırmızı zeminli ve kırmızı değerler)
        Expanded(
          child: AppCard(
            backgroundColor: AppColors.expenseSurface,
            border: Border.all(color: AppColors.expense.withOpacity(0.3), width: 1),
            padding: const EdgeInsets.all(14),
            onTap: onExpenseTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.receipt_outlined, color: AppColors.expense, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Gider Özeti',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.expense, size: 18),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  CurrencyFormatter.format(expenseTotalMinor, isHidden: isHidden),
                  style: const TextStyle(
                    color: AppColors.expense,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${recentExpenses.length} işlem kaydı',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (recentExpenses.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 8),
                  ...recentExpenses.take(2).map((tx) {
                    final isCensored = tx.isAmountHidden && isHidden;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (tx.isCharity)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 3),
                                    child: Icon(Icons.favorite, size: 10, color: AppColors.expense),
                                  ),
                                Expanded(
                                  child: Text(
                                    tx.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(tx.amountMinor, isHidden: isCensored),
                            style: const TextStyle(
                              color: AppColors.expense,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
