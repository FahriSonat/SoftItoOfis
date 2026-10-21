import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/recurring_payment.dart';
import '../../../data/models/debt.dart';
import '../../../core/widgets/app_card.dart';

class UpcomingRemindersCard extends StatelessWidget {
  final List<RecurringPayment> upcomingBills;
  final List<Debt> upcomingDebts;
  final VoidCallback onViewAllTap;

  const UpcomingRemindersCard({
    super.key,
    required this.upcomingBills,
    required this.upcomingDebts,
    required this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeBills = upcomingBills.where((b) => !b.isPaidThisPeriod).take(2).toList();
    final activeDebts = upcomingDebts.where((d) => !d.isSettled && d.dueDate != null).take(2).toList();

    final bool hasItems = activeBills.isNotEmpty || activeDebts.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: const [
                    Icon(Icons.calendar_month_rounded, color: AppColors.indicatorBlue, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Yaklaşan Ödemeler',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Tümünü Gör', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!hasItems)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Yaklaşan planlı bir fatura veya borç ödemesi bulunmuyor.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            )
          else ...[
            ...activeBills.map((bill) => _buildReminderItem(
              icon: Icons.receipt_long,
              iconColor: AppColors.warningBackground,
              title: bill.title,
              subtitle: 'Son Ödeme: ${DateFormatter.formatShort(bill.dueDate)}',
              amountStr: bill.expectedAmountMinor != null
                  ? CurrencyFormatter.format(bill.expectedAmountMinor!)
                  : 'Tutar belirtilmedi',
              badgeText: 'Fatura',
            )),
            ...activeDebts.map((debt) => _buildReminderItem(
              icon: debt.isBorrowed ? Icons.account_balance_outlined : Icons.handshake_outlined,
              iconColor: debt.isBorrowed ? AppColors.expense : AppColors.income,
              title: debt.counterparty,
              subtitle: 'Vade: ${DateFormatter.formatShort(debt.dueDate!)}',
              amountStr: CurrencyFormatter.format(debt.remainingMinor),
              badgeText: debt.isBorrowed ? 'Borç Ödeme' : 'Alacak',
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String amountStr,
    required String badgeText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              amountStr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
