import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../data/models/transaction.dart';
import '../../providers/finance_provider.dart';
import 'transaction_form_screen.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late bool _locallyRevealed;

  @override
  void initState() {
    super.initState();
    _locallyRevealed = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    // Fetch latest instance of the transaction from provider
    final currentTx = provider.transactions.firstWhere(
      (t) => t.id == widget.transaction.id,
      orElse: () => widget.transaction,
    );

    final category = provider.categoryMap[currentTx.categoryId];
    final isIncome = currentTx.isIncome;
    final isHidden = currentTx.isAmountHidden && !_locallyRevealed && !provider.revealHiddenAmountsInSession;

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlem Ayrıntısı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Düzenle',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionFormScreen(initialTransaction: currentTx),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.expense),
            tooltip: 'Sil',
            onPressed: () => _handleDelete(context, provider, currentTx),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Card
            AppCard(
              backgroundColor: isIncome ? AppColors.incomeSurface : AppColors.expenseSurface,
              border: Border.all(
                color: isIncome ? AppColors.income.withOpacity(0.4) : AppColors.expense.withOpacity(0.4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isIncome ? Icons.payments_outlined : Icons.receipt_outlined,
                        color: isIncome ? AppColors.income : AppColors.expense,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isIncome ? 'GELİR İŞLEMİ' : 'GİDER İŞLEMİ',
                        style: TextStyle(
                          color: isIncome ? AppColors.income : AppColors.expense,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${isIncome ? "+" : "-"}${CurrencyFormatter.format(currentTx.amountMinor, isHidden: isHidden)}',
                        style: TextStyle(
                          color: isIncome ? AppColors.income : AppColors.expense,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (currentTx.isAmountHidden) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            _locallyRevealed ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _locallyRevealed = !_locallyRevealed;
                            });
                          },
                          tooltip: _locallyRevealed ? 'Tutarı gizle' : 'Gizli tutarı göster',
                        ),
                      ],
                    ],
                  ),
                  if (currentTx.isCharity) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.expense.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.expense.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.favorite, size: 14, color: AppColors.expense),
                          SizedBox(width: 6),
                          Text(
                            'Hayır İşi / Bağış Gideri',
                            style: TextStyle(
                              color: AppColors.expense,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Details List Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildDetailRow(
                    label: 'Açıklama',
                    value: currentTx.description,
                    icon: Icons.description_outlined,
                  ),
                  const Divider(color: AppColors.border),
                  _buildDetailRow(
                    label: 'Kategori',
                    value: category?.name ?? 'Kategori Yok',
                    icon: Icons.category_outlined,
                  ),
                  const Divider(color: AppColors.border),
                  _buildDetailRow(
                    label: 'Tarih',
                    value: DateFormatter.formatFull(currentTx.occurredAt),
                    icon: Icons.calendar_today_outlined,
                  ),
                  if (currentTx.receiptNote != null && currentTx.receiptNote!.isNotEmpty) ...[
                    const Divider(color: AppColors.border),
                    _buildDetailRow(
                      label: 'Fiş / Fatura Notu',
                      value: currentTx.receiptNote!,
                      icon: Icons.receipt_long_outlined,
                    ),
                  ],
                  if (isIncome && currentTx.incomeSource != null) ...[
                    const Divider(color: AppColors.border),
                    _buildDetailRow(
                      label: 'Gelir Kaynağı',
                      value: currentTx.incomeSource == IncomeSource.salary
                          ? 'Maaş Geliri'
                          : currentTx.incomeSource == IncomeSource.debt_repayment
                              ? 'Borç Geri Ödemesi'
                              : 'Diğer Gelir',
                      icon: Icons.source_outlined,
                    ),
                  ],
                  if (currentTx.isAmountHidden) ...[
                    const Divider(color: AppColors.border),
                    _buildDetailRow(
                      label: 'Gizlilik',
                      value: 'Özel Tutar (Sansürlü)',
                      icon: Icons.lock_outline,
                      valueColor: AppColors.indicatorBlue,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Düzenle'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionFormScreen(initialTransaction: currentTx),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.expenseSurface,
                      foregroundColor: AppColors.expense,
                      side: const BorderSide(color: AppColors.expense, width: 1),
                    ),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Sil'),
                    onPressed: () => _handleDelete(context, provider, currentTx),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, FinanceProvider provider, Transaction tx) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'İşlemi Sil',
      message: '"${tx.description}" kaydını kalıcı olarak silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
      confirmText: 'Sil',
      isDestructive: true,
    );

    if (confirmed) {
      await provider.deleteTransaction(tx.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.surfaceRaised,
            content: Text('İşlem kaydı silindi.', style: TextStyle(color: AppColors.textPrimary)),
          ),
        );
      }
    }
  }
}
