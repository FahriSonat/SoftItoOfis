import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/semicircular_gauge.dart';
import '../../providers/finance_provider.dart';
import 'widgets/balance_card.dart';
import 'widgets/income_expense_summary_panel.dart';
import 'widgets/daily_spendable_card.dart';
import 'widgets/upcoming_reminders_card.dart';
import '../transactions/transaction_form_screen.dart';
import '../transactions/transaction_detail_screen.dart';

/// Ana Bütçe Özeti / Dashboard Ekranı.
/// Kullanıcının net bakiyesini, bütçe kullanım göstergesini (Semicircular Gauge),
/// gelir-gider dağılımını, günlük harcanabilir tutar tahminini, yaklaşan fatura/borç
/// bildirimlerini ve son 5 işlemi tek bir bakışta sunar.
class HomeDashboardScreen extends StatelessWidget {
  /// Ana kabukta sekmeler arası yönlendirme callback fonksiyonu (örn: 1 nolu İşlemler sekmesine geçiş)
  final Function(int tabIndex)? onNavigateTab;

  const HomeDashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    // FinanceProvider üzerinden anlık veriler izlenir
    final provider = context.watch<FinanceProvider>();

    // Veriler henüz yükleniyorsa yükleniyor indikatörü gösterilir
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.indicatorBlue)),
      );
    }

    final now = provider.selectedMonth;
    final int monthlyExpense = provider.selectedMonthExpenseMinor;
    final int monthlyLimit = provider.settings.monthlyLimitMinor;
    final double actualRatio = monthlyLimit > 0 ? (monthlyExpense / monthlyLimit) : 0.0;
    final int remainingMonthMinor = monthlyLimit - monthlyExpense;

    final notifications = provider.notifications;
    final recentTransactions = provider.selectedMonthTransactions.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bütçe Özeti'),
        actions: [
          // Bildirim Zil İkonu ve Rozeti
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Hatırlatmalar ve Bildirimler',
                onPressed: () => _showNotificationSheet(context, provider),
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.criticalBackground,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.indicatorBlue,
        backgroundColor: AppColors.surfaceRaised,
        onRefresh: () => provider.init(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Ay / Dönem Seçici
              _buildMonthSelector(context, provider),
              const SizedBox(height: 14),

              // Aktif Banner Uyarıları (varsa ilk kritik veya uyarı bildirimi)
              if (notifications.isNotEmpty) ...[
                AppBanner(
                  title: notifications.first.title,
                  message: notifications.first.message,
                  type: notifications.first.type,
                  onDismiss: () => provider.dismissNotification(notifications.first.id),
                  onTap: () => _showNotificationSheet(context, provider),
                ),
                const SizedBox(height: 10),
              ],

              // 2. Bakiye / Net Durum Kartı
              BalanceCard(
                netBalanceMinor: provider.selectedMonthNetBalanceMinor,
                incomeMinor: provider.selectedMonthIncomeMinor,
                expenseMinor: provider.selectedMonthExpenseMinor,
                isHidden: provider.revealHiddenAmountsInSession,
                onToggleHidden: () => provider.toggleRevealHiddenAmounts(),
              ),
              const SizedBox(height: 16),

              // 3. Yarım Daire Bütçe Göstergesi (design.md Section 6)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Aylık Bütçe Kullanımı',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Limit: ${CurrencyFormatter.format(monthlyLimit, isHidden: provider.revealHiddenAmountsInSession)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SemicircularGauge(
                      progress: actualRatio,
                      actualRatio: actualRatio,
                      periodLabel: 'Aylık Limit',
                      centerValue: '%${(actualRatio * 100).toInt()}',
                      subCaption: remainingMonthMinor >= 0
                          ? '${CurrencyFormatter.format(remainingMonthMinor, isHidden: provider.revealHiddenAmountsInSession)} kaldı'
                          : '${CurrencyFormatter.format(-remainingMonthMinor, isHidden: provider.revealHiddenAmountsInSession)} aşıldı!',
                      hasBudget: monthlyLimit > 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Yan Yana Gelir ve Gider Özet Panelleri (Solda yeşil gelir, sağda kırmızı gider)
              IncomeExpenseSummaryPanel(
                incomeTotalMinor: provider.selectedMonthIncomeMinor,
                expenseTotalMinor: provider.selectedMonthExpenseMinor,
                recentIncomes: provider.selectedMonthTransactions.where((t) => t.isIncome).toList(),
                recentExpenses: provider.selectedMonthTransactions.where((t) => t.isExpense).toList(),
                isHidden: provider.revealHiddenAmountsInSession,
                onIncomeTap: () {
                  if (onNavigateTab != null) onNavigateTab!(1); // Transactions tab
                },
                onExpenseTap: () {
                  if (onNavigateTab != null) onNavigateTab!(1); // Transactions tab
                },
              ),
              const SizedBox(height: 16),

              // 5. Günlük Harcanabilir Tutar ve Limitler
              DailySpendableCard(
                dailySpendableMinor: provider.dailySpendableMinor,
                todayExpenseMinor: provider.todayExpenseMinor,
                dailyLimitMinor: provider.settings.dailyLimitMinor,
                currentWeekExpenseMinor: provider.currentWeekExpenseMinor,
                weeklyLimitMinor: provider.settings.weeklyLimitMinor,
                currentMonthExpenseMinor: provider.selectedMonthExpenseMinor,
                monthlyLimitMinor: provider.settings.monthlyLimitMinor,
                isHidden: provider.revealHiddenAmountsInSession,
              ),
              const SizedBox(height: 16),

              // 6. Yaklaşan Faturalar ve Borçlar Hatırlatmaları
              UpcomingRemindersCard(
                upcomingBills: provider.recurringPayments,
                upcomingDebts: provider.debts,
                onViewAllTap: () {
                  if (onNavigateTab != null) onNavigateTab!(3); // Debts & Bills tab
                },
              ),
              const SizedBox(height: 16),

              // 7. Son İşlemler
              _buildRecentTransactionsSection(context, provider, recentTransactions),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.indicatorBlue,
        foregroundColor: AppColors.textPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Yeni İşlem', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionFormScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context, FinanceProvider provider) {
    final current = provider.selectedMonth;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              provider.setSelectedMonth(DateTime(current.year, current.month - 1, 1));
            },
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.indicatorBlue),
              const SizedBox(width: 8),
              Text(
                DateFormatter.formatMonthYear(current),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              provider.setSelectedMonth(DateTime(current.year, current.month + 1, 1));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsSection(
    BuildContext context,
    FinanceProvider provider,
    List<dynamic> recentTransactions,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Son İşlemler',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (onNavigateTab != null) onNavigateTab!(1);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Tümünü İncele', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (recentTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  'Bu ayda henüz bir gelir veya gider kaydı bulunmuyor.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ...recentTransactions.map((tx) {
              final category = provider.categoryMap[tx.categoryId];
              final isIncome = tx.isIncome;
              final isCensored = tx.isAmountHidden && provider.revealHiddenAmountsInSession;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailScreen(transaction: tx),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isIncome ? AppColors.incomeSurface : AppColors.expenseSurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isIncome ? Icons.payments_outlined : Icons.receipt_outlined,
                          size: 16,
                          color: isIncome ? AppColors.income : AppColors.expense,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (tx.isCharity)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.favorite, size: 12, color: AppColors.expense),
                                  ),
                                Expanded(
                                  child: Text(
                                    tx.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${category?.name ?? "Kategori Yok"} • ${DateFormatter.formatRelative(tx.occurredAt)}',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isIncome ? "+" : "-"}${CurrencyFormatter.format(tx.amountMinor, isHidden: isCensored)}',
                        style: TextStyle(
                          color: isIncome ? AppColors.income : AppColors.expense,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _showNotificationSheet(BuildContext context, FinanceProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final items = provider.notifications;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hatırlatmalar ve Bildirimler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Şu anda bekleyen veya yaklaşan bir hatırlatma yok.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return AppBanner(
                        title: item.title,
                        message: item.message,
                        type: item.type,
                        onDismiss: () {
                          provider.dismissNotification(item.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
