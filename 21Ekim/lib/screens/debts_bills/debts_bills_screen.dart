import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../data/models/debt.dart';
import '../../data/models/recurring_payment.dart';
import '../../providers/finance_provider.dart';

class DebtsBillsScreen extends StatefulWidget {
  const DebtsBillsScreen({super.key});

  @override
  State<DebtsBillsScreen> createState() => _DebtsBillsScreenState();
}

class _DebtsBillsScreenState extends State<DebtsBillsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borçlar ve Düzenli Faturalar'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Borç Takibi'),
            Tab(text: 'Düzenli Faturalar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDebtsTab(context, provider),
          _buildBillsTab(context, provider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.indicatorBlue,
        foregroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add),
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddDebtDialog(context, provider);
          } else {
            _showAddBillDialog(context, provider);
          }
        },
      ),
    );
  }

  // --- BORÇLAR SEKMESİ ---
  Widget _buildDebtsTab(BuildContext context, FinanceProvider provider) {
    final debts = provider.debts;
    final borrowed = debts.where((d) => d.isBorrowed).toList();
    final lent = debts.where((d) => d.isLent).toList();

    int totalBorrowedMinor = 0;
    for (final d in borrowed.where((d) => !d.isSettled)) {
      totalBorrowedMinor += d.remainingMinor;
    }

    int totalLentMinor = 0;
    for (final d in lent.where((d) => !d.isSettled)) {
      totalLentMinor += d.remainingMinor;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Özet Kartları
          Row(
            children: [
              Expanded(
                child: AppCard(
                  backgroundColor: AppColors.expenseSurface,
                  border: Border.all(color: AppColors.expense.withOpacity(0.3)),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alınan Borçlar (Ödenecek)', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.format(totalBorrowedMinor),
                        style: const TextStyle(color: AppColors.expense, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  backgroundColor: AppColors.incomeSurface,
                  border: Border.all(color: AppColors.income.withOpacity(0.3)),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Verilen Borçlar (Alacak)', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.format(totalLentMinor),
                        style: const TextStyle(color: AppColors.income, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          const Text('Borç & Alacak Listesi', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          if (debts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Kayıtlı borç veya alacak bulunmuyor.', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...debts.map((debt) => _buildDebtCard(context, provider, debt)),
        ],
      ),
    );
  }

  Widget _buildDebtCard(BuildContext context, FinanceProvider provider, Debt debt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool isDueToday = false;
    bool isDueSoon = false;

    if (debt.dueDate != null && !debt.isSettled) {
      final due = DateTime(debt.dueDate!.year, debt.dueDate!.month, debt.dueDate!.day);
      final diff = due.difference(today).inDays;
      if (diff == 0) isDueToday = true;
      if (diff > 0 && diff <= 7) isDueSoon = true;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: debt.isBorrowed ? AppColors.expenseSurface : AppColors.incomeSurface,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        debt.isBorrowed ? Icons.account_balance_outlined : Icons.handshake_outlined,
                        size: 16,
                        color: debt.isBorrowed ? AppColors.expense : AppColors.income,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      debt.counterparty,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: debt.isSettled
                        ? AppColors.surfaceRaised
                        : debt.isBorrowed
                            ? AppColors.expenseSurface
                            : AppColors.incomeSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    debt.isSettled
                        ? 'Kapandı'
                        : debt.isBorrowed
                            ? 'Borcumuz'
                            : 'Alacağımız',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: debt.isSettled
                          ? AppColors.textMuted
                          : debt.isBorrowed
                              ? AppColors.expense
                              : AppColors.income,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Due Date Alert Banner on the row (design.md & project.md Section 5.6)
            if (isDueToday) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.criticalBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.warning, size: 14, color: AppColors.criticalText),
                    SizedBox(width: 6),
                    Text(
                      'Vadesi Bugün Doluyor!',
                      style: TextStyle(color: AppColors.criticalText, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ] else if (isDueSoon) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warningBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.access_time, size: 14, color: AppColors.warningText),
                    SizedBox(width: 6),
                    Text(
                      'Vadesine 1 haftadan az kaldı',
                      style: TextStyle(color: AppColors.warningText, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kalan Bakiye', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(debt.remainingMinor),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: debt.isBorrowed ? AppColors.expense : AppColors.income,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Toplam Ana Para', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    Text(
                      CurrencyFormatter.format(debt.principalMinor),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            if (debt.dueDate != null) ...[
              const SizedBox(height: 6),
              Text(
                'Vade Tarihi: ${DateFormatter.formatFull(debt.dueDate!)}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
            if (debt.note != null && debt.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Not: ${debt.note!}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(color: AppColors.border),
            const SizedBox(height: 6),

            // Actions: Record payment or Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      title: 'Borç Kaydını Sil',
                      message: '"${debt.counterparty}" borç kaydını silmek istediğinize emin misiniz?',
                      confirmText: 'Sil',
                      isDestructive: true,
                    );
                    if (confirmed) {
                      await provider.deleteDebt(debt.id);
                    }
                  },
                ),
                if (!debt.isSettled) ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: const Icon(Icons.payment, size: 14),
                    label: Text(debt.isBorrowed ? 'Ödeme Yap' : 'Tahsil Et', style: const TextStyle(fontSize: 12)),
                    onPressed: () => _showRepaymentDialog(context, provider, debt),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- FATURALAR SEKMESİ ---
  Widget _buildBillsTab(BuildContext context, FinanceProvider provider) {
    final bills = provider.recurringPayments;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Düzenli Ödemeler & Faturalar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Fatura Ekle', style: TextStyle(fontSize: 12)),
                onPressed: () => _showAddBillDialog(context, provider),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (bills.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Kayıtlı düzenli fatura bulunmuyor.', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...bills.map((bill) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bill.isPaidThisPeriod
                              ? AppColors.incomeSurface
                              : AppColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          bill.isPaidThisPeriod ? Icons.check_circle : Icons.receipt_long,
                          color: bill.isPaidThisPeriod ? AppColors.income : AppColors.indicatorBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bill.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(
                              'Son Vade: ${DateFormatter.formatFull(bill.dueDate)}',
                              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                            ),
                            if (bill.isPaidThisPeriod) ...[
                              const SizedBox(height: 2),
                              const Text('Bu dönem ödendi', style: TextStyle(color: AppColors.income, fontSize: 11, fontWeight: FontWeight.w600)),
                            ],
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            bill.expectedAmountMinor != null
                                ? CurrencyFormatter.format(bill.expectedAmountMinor!)
                                : 'Değişken',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          const SizedBox(height: 6),
                          if (!bill.isPaidThisPeriod)
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                              onPressed: () => _markBillPaid(context, provider, bill),
                              child: const Text('Ödendi İşaretle', style: TextStyle(fontSize: 11)),
                            ),
                        ],
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

  void _showRepaymentDialog(BuildContext context, FinanceProvider provider, Debt debt) {
    final controller = TextEditingController(text: CurrencyFormatter.toEditString(debt.remainingMinor));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(debt.isBorrowed ? 'Borç Ödemesi Yap' : 'Borç Tahsilatı Kaydet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${debt.counterparty} için ödeme tutarı giriniz. Kalan bakiye: ${CurrencyFormatter.format(debt.remainingMinor)}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Ödeme Tutarı (₺)', hintText: '0,00'),
            ),
          ],
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              final minor = CurrencyFormatter.parseToMinor(controller.text);
              if (minor > 0) {
                await provider.recordDebtRepayment(
                  debt: debt,
                  paymentAmountMinor: minor,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.successBackground,
                      content: Text('Ödeme kaydedildi ve nakit akışı güncellendi.'),
                    ),
                  );
                }
              }
            },
            child: const Text('Ödemeyi Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _markBillPaid(BuildContext context, FinanceProvider provider, RecurringPayment bill) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Fatura Ödendi Olarak İşaretlensin mi?',
      message: '${bill.title} faturası için gerçekleşmiş gider kaydı oluşturulacaktır.',
      confirmText: 'Ödendi İşaretle',
    );

    if (confirmed) {
      await provider.markRecurringAsPaid(item: bill);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.successBackground,
            content: Text('Fatura ödendi olarak işaretlendi ve gider kaydı oluşturuldu.'),
          ),
        );
      }
    }
  }

  void _showAddDebtDialog(BuildContext context, FinanceProvider provider) {
    DebtDirection direction = DebtDirection.borrowed;
    final counterpartyController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Borç / Alacak Kaydı'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Alınan Borç')),
                        selected: direction == DebtDirection.borrowed,
                        selectedColor: AppColors.expense.withOpacity(0.3),
                        onSelected: (val) => setDialogState(() => direction = DebtDirection.borrowed),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Verilen Borç')),
                        selected: direction == DebtDirection.lent,
                        selectedColor: AppColors.income.withOpacity(0.3),
                        onSelected: (val) => setDialogState(() => direction = DebtDirection.lent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: counterpartyController,
                  decoration: const InputDecoration(labelText: 'Kişi / Kurum *', hintText: 'Örn: Ahmet Yılmaz, Akbank'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Ana Para Tutarı (₺) *', hintText: '0,00'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Açıklama / Not', hintText: 'Taksit detayı veya not'),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                final minor = CurrencyFormatter.parseToMinor(amountController.text);
                final counterparty = counterpartyController.text.trim();
                if (counterparty.isNotEmpty && minor > 0) {
                  final newDebt = Debt(
                    id: const Uuid().v4(),
                    direction: direction,
                    counterparty: counterparty,
                    principalMinor: minor,
                    remainingMinor: minor,
                    dueDate: dueDate,
                    note: noteController.text.trim(),
                  );
                  await provider.addDebt(newDebt);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBillDialog(BuildContext context, FinanceProvider provider) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    RecurringCadence cadence = RecurringCadence.monthly;
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Düzenli Fatura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Fatura Adı *', hintText: 'Örn: Ev Kirası, Elektrik'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Beklenen Tutar (₺)', hintText: '0,00'),
              ),
            ],
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final minor = CurrencyFormatter.parseToMinor(amountController.text);
                if (title.isNotEmpty) {
                  final bill = RecurringPayment(
                    id: const Uuid().v4(),
                    title: title,
                    expectedAmountMinor: minor > 0 ? minor : null,
                    cadence: cadence,
                    dueDate: dueDate,
                  );
                  await provider.addRecurringPayment(bill);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
