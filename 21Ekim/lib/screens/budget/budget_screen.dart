import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../data/models/budget.dart';
import '../../data/models/category.dart';
import '../../providers/finance_provider.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  BudgetMethod _selectedMethod = BudgetMethod.rule503020;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bütçe Dağılımı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bütçe Yöntemi Seçimi (50/30/20 veya Zarf Bütçesi)
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMethod = BudgetMethod.rule503020),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedMethod == BudgetMethod.rule503020
                              ? AppColors.indicatorBlue.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: _selectedMethod == BudgetMethod.rule503020
                              ? Border.all(color: AppColors.indicatorBlue)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '50 / 30 / 20 Bütçesi',
                            style: TextStyle(
                              color: _selectedMethod == BudgetMethod.rule503020
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMethod = BudgetMethod.envelope),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedMethod == BudgetMethod.envelope
                              ? AppColors.indicatorBlue.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: _selectedMethod == BudgetMethod.envelope
                              ? Border.all(color: AppColors.indicatorBlue)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Zarf / Kategori Bütçeleri',
                            style: TextStyle(
                              color: _selectedMethod == BudgetMethod.envelope
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (_selectedMethod == BudgetMethod.rule503020)
              _buildRule503020View(context, provider)
            else
              _buildEnvelopeView(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildRule503020View(BuildContext context, FinanceProvider provider) {
    // Toplam bütçe tabanı: Aylık gelir varsa aylık gelir, yoksa aylık limit esas alınır
    final int baseMinor = provider.selectedMonthIncomeMinor > 0
        ? provider.selectedMonthIncomeMinor
        : provider.settings.monthlyLimitMinor;

    final spending = provider.calculate503020Spending();
    final needsSpent = spending[Rule503020Type.needs] ?? 0;
    final wantsSpent = spending[Rule503020Type.wants] ?? 0;
    final savingsSpent = spending[Rule503020Type.savings] ?? 0;

    final needsTarget = (baseMinor * 0.50).round();
    final wantsTarget = (baseMinor * 0.30).round();
    final savingsTarget = (baseMinor * 0.20).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '50/30/20 Bütçe Hedefi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      'Taban: ${CurrencyFormatter.format(baseMinor)}',
                      style: const TextStyle(fontSize: 11, color: AppColors.indicatorBlue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Gelirinizin %50\'si zorunlu ihtiyaçlara, %30\'u kişisel isteklere, %20\'si tasarruf ve borç ödemelerine ayrılır.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildTierCard(
          title: 'Zorunlu İhtiyaçlar (%50)',
          subtitle: 'Kira, Mutfak/Market, Faturalar, Ulaşım, Sağlık',
          spentMinor: needsSpent,
          targetMinor: needsTarget,
          icon: Icons.home_work_outlined,
        ),
        const SizedBox(height: 12),

        _buildTierCard(
          title: 'İstekler & Yaşam (%30)',
          subtitle: 'Kafe, Eğlence, Hobi, Dışarıda Yemek, Bağış',
          spentMinor: wantsSpent,
          targetMinor: wantsTarget,
          icon: Icons.sports_esports_outlined,
        ),
        const SizedBox(height: 12),

        _buildTierCard(
          title: 'Tasarruf & Yatırım (%20)',
          subtitle: 'Birikim, Altın, Fon, Borç Kapama',
          spentMinor: savingsSpent,
          targetMinor: savingsTarget,
          icon: Icons.savings_outlined,
        ),
      ],
    );
  }

  Widget _buildTierCard({
    required String title,
    required String subtitle,
    required int spentMinor,
    required int targetMinor,
    required IconData icon,
  }) {
    final double ratio = targetMinor > 0 ? (spentMinor / targetMinor) : 0.0;
    final bool isOver = ratio >= 1.0;
    final bool isWarning = ratio >= 0.80 && !isOver;

    Color progressColor = AppColors.indicatorBlue;
    if (isOver) {
      progressColor = AppColors.criticalBackground;
    } else if (isWarning) {
      progressColor = AppColors.warningBackground;
    }

    final int diff = targetMinor - spentMinor;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.indicatorBlue, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '%${(ratio * 100).toInt()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isOver ? AppColors.expense : AppColors.indicatorBlue,
                    ),
                  ),
                  Text(
                    diff >= 0 ? '${CurrencyFormatter.format(diff)} kaldı' : '${CurrencyFormatter.format(-diff)} aşıldı',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isOver ? AppColors.expense : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.surfaceRaised,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('Harcanan: ', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  Text(
                    CurrencyFormatter.format(spentMinor),
                    style: const TextStyle(color: AppColors.expense, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Hedef Limit: ', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                  Text(
                    CurrencyFormatter.format(targetMinor),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvelopeView(BuildContext context, FinanceProvider provider) {
    final expenseCategories = provider.categories.where((c) => c.type == CategoryType.expense).toList();
    final categorySpending = provider.calculateCategorySpending();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori Bütçe Limitleri',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Limit Ekle/Düzenle', style: TextStyle(fontSize: 12)),
              onPressed: () => _showAddEnvelopeDialog(context, provider),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...expenseCategories.map((category) {
          final spent = categorySpending[category.id] ?? 0;
          final budget = provider.budgets.cast<Budget?>().firstWhere(
            (b) => b?.categoryId == category.id,
            orElse: () => null,
          );

          final limitMinor = budget?.amountMinor ?? 0;
          final hasBudget = limitMinor > 0;
          final double ratio = hasBudget ? (spent / limitMinor) : 0.0;
          final bool isOver = hasBudget && ratio >= 1.0;
          final bool isWarning = hasBudget && ratio >= 0.80 && !isOver;

          Color barColor = AppColors.indicatorBlue;
          if (isOver) {
            barColor = AppColors.criticalBackground;
          } else if (isWarning) {
            barColor = AppColors.warningBackground;
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
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.indicatorBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => _showEditCategoryBudget(context, provider, category, budget),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!hasBudget) ...[
                    const Text(
                      'Bu kategori için henüz harcama limiti belirlenmedi.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('Bu Ayki Harcama: ', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                        Text(
                          CurrencyFormatter.format(spent),
                          style: const TextStyle(color: AppColors.expense, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Harcanan: ', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                            Text(
                              CurrencyFormatter.format(spent),
                              style: const TextStyle(color: AppColors.expense, fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          'Limit: ${CurrencyFormatter.format(limitMinor)}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.surfaceRaised,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        limitMinor >= spent
                            ? '${CurrencyFormatter.format(limitMinor - spent)} kaldı'
                            : '${CurrencyFormatter.format(spent - limitMinor)} aşıldı!',
                        style: TextStyle(
                          color: isOver ? AppColors.expense : AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showAddEnvelopeDialog(BuildContext context, FinanceProvider provider) {
    String? categoryId;
    final controller = TextEditingController();

    final expenseCategories = provider.categories.where((c) => c.type == CategoryType.expense).toList();
    if (expenseCategories.isNotEmpty) {
      categoryId = expenseCategories.first.id;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Zarf Bütçesi Belirle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: categoryId,
              dropdownColor: AppColors.surfaceRaised,
              items: expenseCategories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (val) => categoryId = val,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Aylık Limit Tutarı (₺)', hintText: '0,00'),
            ),
          ],
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              final minor = CurrencyFormatter.parseToMinor(controller.text);
              if (categoryId != null && minor > 0) {
                final budget = Budget(
                  id: const Uuid().v4(),
                  period: BudgetPeriod.month,
                  amountMinor: minor,
                  categoryId: categoryId,
                  method: BudgetMethod.envelope,
                  startsOn: DateTime(DateTime.now().year, DateTime.now().month, 1),
                );
                await provider.saveBudget(budget);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryBudget(
    BuildContext context,
    FinanceProvider provider,
    Category category,
    Budget? budget,
  ) {
    final controller = TextEditingController(
      text: budget != null ? CurrencyFormatter.toEditString(budget.amountMinor) : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${category.name} Limiti'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Aylık Bütçe Limiti (₺)', hintText: '0,00'),
        ),
        actions: [
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          ElevatedButton(
            onPressed: () async {
              final minor = CurrencyFormatter.parseToMinor(controller.text);
              if (minor > 0) {
                final newBudget = budget != null
                    ? budget.copyWith(amountMinor: minor)
                    : Budget(
                        id: const Uuid().v4(),
                        period: BudgetPeriod.month,
                        amountMinor: minor,
                        categoryId: category.id,
                        method: BudgetMethod.envelope,
                        startsOn: DateTime(DateTime.now().year, DateTime.now().month, 1),
                      );
                await provider.saveBudget(newBudget);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}
