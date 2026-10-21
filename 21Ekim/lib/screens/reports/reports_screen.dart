import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/excel_exporter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_banner.dart';
import '../../data/services/notification_service.dart';
import '../../providers/finance_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isExporting = false;
  String? _lastExportedPath;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final selectedMonth = provider.selectedMonth;

    final incomeMinor = provider.selectedMonthIncomeMinor;
    final expenseMinor = provider.selectedMonthExpenseMinor;
    final netMinor = provider.selectedMonthNetBalanceMinor;
    final charityMinor = provider.selectedMonthCharityMinor;
    final categorySpending = provider.calculateCategorySpending();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcama ve Finans Raporları'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.indicatorBlue),
            tooltip: 'Excel Raporu İndir',
            onPressed: _isExporting ? null : () => _showExportDialog(context, provider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Export Success Banner
            if (_lastExportedPath != null) ...[
              AppBanner(
                title: 'Excel Raporu Başarıyla Oluşturuldu',
                message: 'Dosya kaydedildi: $_lastExportedPath',
                type: AppNotificationType.success,
                onDismiss: () => setState(() => _lastExportedPath = null),
              ),
              const SizedBox(height: 12),
            ],

            // Dönem Seçim Kartı
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rapor Dönemi', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                      Text(
                        DateFormatter.formatMonthYear(selectedMonth),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: _isExporting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.table_view, size: 16),
                    label: const Text('Excel Çıktısı Al', style: TextStyle(fontSize: 12)),
                    onPressed: _isExporting ? null : () => _showExportDialog(context, provider),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dönemsel Özet Kartları
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    backgroundColor: AppColors.incomeSurface,
                    border: Border.all(color: AppColors.income.withOpacity(0.3)),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dönem Geliri', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.format(incomeMinor),
                          style: const TextStyle(color: AppColors.income, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    backgroundColor: AppColors.expenseSurface,
                    border: Border.all(color: AppColors.expense.withOpacity(0.3)),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dönem Gideri', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          CurrencyFormatter.format(expenseMinor),
                          style: const TextStyle(color: AppColors.expense, fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Net Bakiye ve Hayır İşi Detay Kartı
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dönem Net Durumu', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text(
                        CurrencyFormatter.format(netMinor, showSign: true),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: netMinor >= 0 ? AppColors.income : AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.favorite, size: 16, color: AppColors.expense),
                          SizedBox(width: 8),
                          Text('Hayır İşi / Bağış Giderleri', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Text(
                        CurrencyFormatter.format(charityMinor),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.expense,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hayır işleri genel gider toplamına dahildir; burada alt toplam olarak raporlanmaktadır.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kategori Bazlı Dağılım Listesi
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kategori Bazında Harcama Dağılımı',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${categorySpending.length} Kategori',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (categorySpending.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text('Bu dönemde henüz kategori harcaması yok.', style: TextStyle(color: AppColors.textMuted)),
                      ),
                    )
                  else
                    ...categorySpending.entries.map((entry) {
                      final category = provider.categoryMap[entry.key];
                      final amount = entry.value;
                      final double ratio = expenseMinor > 0 ? (amount / expenseMinor) : 0.0;
                      final int pct = (ratio * 100).round();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: AppColors.indicatorBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category?.name ?? 'Diğer Gider',
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      CurrencyFormatter.format(amount),
                                      style: const TextStyle(color: AppColors.expense, fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '(%$pct)',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio.clamp(0.0, 1.0),
                                minHeight: 6,
                                backgroundColor: AppColors.surfaceRaised,
                                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.indicatorBlue),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context, FinanceProvider provider) {
    bool censorHidden = provider.settings.censorHiddenInExport;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Excel Raporu Oluştur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${DateFormatter.formatMonthYear(provider.selectedMonth)} dönemine ait tüm gelir, gider, bütçe ve borç kayıtları Excel tablosuna aktarılacaktır.',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.indicatorBlue,
                title: const Text('Özel Gider Tutarlarını Sansürle', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: const Text(
                  'İşaretlenirse gizli giderlerin tutarları Excel dosyasında ₺•••• olarak yazılır.',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
                value: censorHidden,
                onChanged: (val) {
                  setDialogState(() {
                    censorHidden = val ?? true;
                  });
                },
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isExporting = true);

                try {
                  final path = await ExcelExporter.exportReport(
                    transactions: provider.transactions,
                    categories: provider.categories,
                    budgets: provider.budgets,
                    debts: provider.debts,
                    recurringPayments: provider.recurringPayments,
                    censorHiddenAmounts: censorHidden,
                    selectedDate: provider.selectedMonth,
                  );

                  setState(() {
                    _lastExportedPath = path;
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.criticalBackground,
                        content: Text('Dışa aktarma hatası: $e'),
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isExporting = false);
                  }
                }
              },
              child: const Text('Excel Oluştur'),
            ),
          ],
        ),
      ),
    );
  }
}
