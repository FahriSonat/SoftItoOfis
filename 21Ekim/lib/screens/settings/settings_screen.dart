import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../data/models/budget.dart';
import '../../providers/finance_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _dailyLimitController;
  late TextEditingController _weeklyLimitController;
  late TextEditingController _monthlyLimitController;
  late int _salaryDay;
  late double _alertThreshold;
  late BudgetMethod _budgetMethod;
  late bool _censorHiddenInExport;
  late bool _notifyOnSalary;
  late bool _notifyUpcomingBills;
  late bool _notifyDueDebts;

  @override
  void initState() {
    super.initState();
    final s = context.read<FinanceProvider>().settings;
    _dailyLimitController = TextEditingController(text: CurrencyFormatter.toEditString(s.dailyLimitMinor));
    _weeklyLimitController = TextEditingController(text: CurrencyFormatter.toEditString(s.weeklyLimitMinor));
    _monthlyLimitController = TextEditingController(text: CurrencyFormatter.toEditString(s.monthlyLimitMinor));
    _salaryDay = s.salaryDay;
    _alertThreshold = s.alertThreshold;
    _budgetMethod = s.budgetMethod;
    _censorHiddenInExport = s.censorHiddenInExport;
    _notifyOnSalary = s.notifyOnSalary;
    _notifyUpcomingBills = s.notifyUpcomingBills;
    _notifyDueDebts = s.notifyDueDebts;
  }

  @override
  void dispose() {
    _dailyLimitController.dispose();
    _weeklyLimitController.dispose();
    _monthlyLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar ve Tercihler'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Maaş Günü Ayarı
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_today, size: 18, color: AppColors.income),
                      SizedBox(width: 8),
                      Text('Maaş Günü ve Hatırlatma Penceresi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Maaş gününüzden sonraki ilk 3 gün boyunca borç ve kredi kartı ödemeleriniz ana ekranda öncelikli hatırlatılır.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Her Ayın Günü:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          'Her ayın $_salaryDay. günü',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.indicatorBlue),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _salaryDay.toDouble(),
                    min: 1,
                    max: 31,
                    divisions: 30,
                    activeColor: AppColors.indicatorBlue,
                    onChanged: (val) {
                      setState(() => _salaryDay = val.round());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Harcama Limitleri Ayarları
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.tune, size: 18, color: AppColors.indicatorBlue),
                      SizedBox(width: 8),
                      Text('Dönemsel Harcama Limitleri', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _dailyLimitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Günlük Harcama Limiti (₺)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _weeklyLimitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Haftalık Harcama Limiti (₺)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _monthlyLimitController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Aylık Harcama Limiti (₺)'),
                  ),
                  const SizedBox(height: 16),

                  // Uyarı Eşiği
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Limit Yaklaşma Uyarı Eşiği:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(
                        '%${(_alertThreshold * 100).toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.warningBackground),
                      ),
                    ],
                  ),
                  Slider(
                    value: _alertThreshold,
                    min: 0.50,
                    max: 0.95,
                    divisions: 9,
                    activeColor: AppColors.warningBackground,
                    onChanged: (val) {
                      setState(() => _alertThreshold = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bütçe Metodu ve Gizlilik
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Varsayılan Bütçe ve Rapor Tercihleri', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 12),
                  RadioListTile<BudgetMethod>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('50/30/20 Bütçeleme Yöntemi', style: TextStyle(fontSize: 13)),
                    value: BudgetMethod.rule503020,
                    groupValue: _budgetMethod,
                    onChanged: (val) {
                      if (val != null) setState(() => _budgetMethod = val);
                    },
                  ),
                  RadioListTile<BudgetMethod>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('Zarf / Kategori Bütçeleme Yöntemi', style: TextStyle(fontSize: 13)),
                    value: BudgetMethod.envelope,
                    groupValue: _budgetMethod,
                    onChanged: (val) {
                      if (val != null) setState(() => _budgetMethod = val);
                    },
                  ),
                  const Divider(color: AppColors.border),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('Excel Çıktısında Gizli Tutarları Sansürle', style: TextStyle(fontSize: 13)),
                    subtitle: const Text(
                      'Özel olarak işaretlenmiş harcamalar varsayılan olarak sansürlü aktarılır.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    value: _censorHiddenInExport,
                    onChanged: (val) => setState(() => _censorHiddenInExport = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bildirim Tercihleri
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Uygulama İçi Hatırlatma Tercihleri', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('Maaş Günü Hatırlatmaları', style: TextStyle(fontSize: 13)),
                    value: _notifyOnSalary,
                    onChanged: (val) => setState(() => _notifyOnSalary = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('Fatura Yaklaşma Bildirimleri', style: TextStyle(fontSize: 13)),
                    value: _notifyUpcomingBills,
                    onChanged: (val) => setState(() => _notifyUpcomingBills = val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.indicatorBlue,
                    title: const Text('Borç Vade Hatırlatmaları', style: TextStyle(fontSize: 13)),
                    value: _notifyDueDebts,
                    onChanged: (val) => setState(() => _notifyDueDebts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Kaydet Butonu
            ElevatedButton(
              onPressed: () => _saveSettings(context, provider),
              child: const Text('Ayarları Kaydet', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings(BuildContext context, FinanceProvider provider) async {
    final daily = CurrencyFormatter.parseToMinor(_dailyLimitController.text);
    final weekly = CurrencyFormatter.parseToMinor(_weeklyLimitController.text);
    final monthly = CurrencyFormatter.parseToMinor(_monthlyLimitController.text);

    final updated = provider.settings.copyWith(
      salaryDay: _salaryDay,
      dailyLimitMinor: daily > 0 ? daily : provider.settings.dailyLimitMinor,
      weeklyLimitMinor: weekly > 0 ? weekly : provider.settings.weeklyLimitMinor,
      monthlyLimitMinor: monthly > 0 ? monthly : provider.settings.monthlyLimitMinor,
      alertThreshold: _alertThreshold,
      budgetMethod: _budgetMethod,
      censorHiddenInExport: _censorHiddenInExport,
      notifyOnSalary: _notifyOnSalary,
      notifyUpcomingBills: _notifyUpcomingBills,
      notifyDueDebts: _notifyDueDebts,
    );

    await provider.updateSettings(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.successBackground,
          content: Text('Ayarlar başarıyla kaydedildi.', style: TextStyle(color: AppColors.textPrimary)),
        ),
      );
    }
  }
}
