import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_banner.dart';
import '../../data/services/notification_service.dart';
import '../../providers/finance_provider.dart';

/// Gelecek Ay Finansal Simülasyonu ve Dönem Projeksiyonu Ekranı.
/// Beklenen maaş, ek gelir, düzenli faturalar ve borç taksitlerine dayalı olarak
/// gelecek ayki net tasarruf ve tahmini varlık senaryolarını (Döviz / Altın eşdeğeri) simüle eder.
class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  int _expectedSalaryMinor = 6500000; // 65.000 ₺
  int _expectedExtraMinor = 500000;   // 5.000 ₺
  double _inflationAdjustmentPercent = 0.0;

  // Approximate reference scenario rates (clearly labeled informative simulation)
  final double _usdRate = 41.50;
  final double _eurRate = 48.20;
  final double _goldGramRate = 3450.0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();

    // Calculate regular bills expected next month
    int totalExpectedBills = 0;
    for (final bill in provider.recurringPayments) {
      totalExpectedBills += bill.expectedAmountMinor ?? 0;
    }

    // Calculate debt installments for next month
    int totalDebtInstallments = 0;
    for (final debt in provider.debts.where((d) => !d.isSettled && d.isBorrowed)) {
      totalDebtInstallments += debt.remainingMinor;
    }

    final int totalExpectedIncome = _expectedSalaryMinor + _expectedExtraMinor;
    final int plannedBudget = provider.settings.monthlyLimitMinor;
    final int adjustedPlannedBudget = (plannedBudget * (1.0 + (_inflationAdjustmentPercent / 100.0))).round();

    final int estimatedExpenses = totalExpectedBills + adjustedPlannedBudget;
    final int estimatedNetRemaining = totalExpectedIncome - estimatedExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelecek Ay Simülasyonu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner bilgilendirmesi
            const AppBanner(
              title: 'Tahmini Dönem Simülasyonu',
              message: 'Bu ekrandaki tüm değerler kullanıcı varsayımlarına dayalı projeksiyon ve tahminlerdir. Kesin mali sonuç teşkil etmez.',
              type: AppNotificationType.info,
            ),
            const SizedBox(height: 14),

            // Özet Tahmin Kartı
            AppCard(
              backgroundColor: estimatedNetRemaining >= 0 ? AppColors.incomeSurface : AppColors.expenseSurface,
              border: Border.all(
                color: estimatedNetRemaining >= 0 ? AppColors.income.withOpacity(0.4) : AppColors.expense.withOpacity(0.4),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tahmini Gelecek Ay Neti',
                        style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text('Tahmin', style: TextStyle(color: AppColors.indicatorBlue, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    CurrencyFormatter.format(estimatedNetRemaining, showSign: true),
                    style: TextStyle(
                      color: estimatedNetRemaining >= 0 ? AppColors.income : AppColors.expense,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Beklenen Gelir: ${CurrencyFormatter.format(totalExpectedIncome)}',
                        style: const TextStyle(color: AppColors.income, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Tahmini Gider: ${CurrencyFormatter.format(estimatedExpenses)}',
                        style: const TextStyle(color: AppColors.expense, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Simülasyon Parametreleri & Varsayımları
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Simülasyon Varsayımlarını Özelleştir',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),

                  // Maaş Varsayımı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Beklenen Maaş Tutarı:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        CurrencyFormatter.format(_expectedSalaryMinor),
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.income),
                      ),
                    ],
                  ),
                  Slider(
                    value: _expectedSalaryMinor.toDouble(),
                    min: 2000000,
                    max: 15000000,
                    divisions: 130,
                    activeColor: AppColors.indicatorBlue,
                    onChanged: (val) {
                      setState(() {
                        _expectedSalaryMinor = val.round();
                      });
                    },
                  ),

                  // Ek Gelir Varsayımı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Beklenen Ek Gelir:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        CurrencyFormatter.format(_expectedExtraMinor),
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.income),
                      ),
                    ],
                  ),
                  Slider(
                    value: _expectedExtraMinor.toDouble(),
                    min: 0,
                    max: 5000000,
                    divisions: 50,
                    activeColor: AppColors.indicatorBlue,
                    onChanged: (val) {
                      setState(() {
                        _expectedExtraMinor = val.round();
                      });
                    },
                  ),

                  // Gider Değişimi %
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Beklenen Gider Değişimi (%):', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        '%${_inflationAdjustmentPercent.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.indicatorBlue),
                      ),
                    ],
                  ),
                  Slider(
                    value: _inflationAdjustmentPercent,
                    min: -20.0,
                    max: 50.0,
                    divisions: 14,
                    activeColor: AppColors.indicatorBlue,
                    onChanged: (val) {
                      setState(() {
                        _inflationAdjustmentPercent = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Planlı Ödemeler Dökümü (Tahmin)
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Planlı Gelecek Ay Ödemeleri',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _buildSimDetailRow(
                    'Düzenli Faturalar Toplamı',
                    CurrencyFormatter.format(totalExpectedBills),
                    Icons.receipt_long,
                  ),
                  const Divider(color: AppColors.border),
                  _buildSimDetailRow(
                    'Planlanan Bütçe Harcaması',
                    CurrencyFormatter.format(adjustedPlannedBudget),
                    Icons.pie_chart_outline,
                  ),
                  const Divider(color: AppColors.border),
                  _buildSimDetailRow(
                    'Açık Borç Taksitleri',
                    CurrencyFormatter.format(totalDebtInstallments),
                    Icons.account_balance_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kalan Tutar İçin Bilgilendirici Senaryolar (Dolar, Euro, Altın)
            if (estimatedNetRemaining > 0) ...[
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Kalan Maaş Değerlendirme Senaryoları',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Icon(Icons.info_outline, size: 16, color: AppColors.textMuted),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tasarruf edilebilecek tahmini tutarın örnek varlıklara karşılığı (Yatırım tavsiyesi içermez):',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _buildAssetScenarioCard(
                          assetName: 'USD (\$)',
                          rateLabel: '1 USD = ${_usdRate.toStringAsFixed(2)} ₺',
                          assetValue: '\$${((estimatedNetRemaining / 100.0) / _usdRate).toStringAsFixed(1)}',
                          color: AppColors.indicatorBlue,
                        ),
                        const SizedBox(width: 8),
                        _buildAssetScenarioCard(
                          assetName: 'EUR (€)',
                          rateLabel: '1 EUR = ${_eurRate.toStringAsFixed(2)} ₺',
                          assetValue: '€${((estimatedNetRemaining / 100.0) / _eurRate).toStringAsFixed(1)}',
                          color: const Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 8),
                        _buildAssetScenarioCard(
                          assetName: 'Gram Altın',
                          rateLabel: '1 Gr = ${_goldGramRate.toStringAsFixed(0)} ₺',
                          assetValue: '${((estimatedNetRemaining / 100.0) / _goldGramRate).toStringAsFixed(2)} gr',
                          color: const Color(0xFFFBBF24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSimDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textMuted),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetScenarioCard({
    required String assetName,
    required String rateLabel,
    required String assetValue,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assetName, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
            const SizedBox(height: 6),
            Text(assetValue, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(rateLabel, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
