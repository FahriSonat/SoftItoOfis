import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_banner.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import '../../data/services/notification_service.dart';
import '../../providers/finance_provider.dart';

/// Yeni gelir/gider ekleme veya mevcut işlemi düzenleme formu ekranı.
/// Zorunlu alan doğrulamaları, kategori seçimi, tarih seçici,
/// hayır işi ve özel tutar gizlilik anahtarlarını barındırır.
class TransactionFormScreen extends StatefulWidget {
  /// Düzenleme modunda mevcut işlem verisi geçirilir; null ise yeni işlem ekleme modundadır.
  final Transaction? initialTransaction;

  const TransactionFormScreen({super.key, this.initialTransaction});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form durum değişkenleri
  late TransactionType _type;                 // İşlem türü (Gelir / Gider)
  late TextEditingController _amountController; // Tutar giriş kontrolcüsü
  late TextEditingController _descController;   // Açıklama kontrolcüsü
  late TextEditingController _receiptController;// Fiş/Fatura notu kontrolcüsü
  late DateTime _selectedDate;                // Seçilen işlem tarihi
  String? _selectedCategoryId;                // Seçili kategori kimliği
  bool _isCharity = false;                    // Hayır işi / bağış mı?
  bool _isAmountHidden = false;               // Özel gizli tutar mı?
  IncomeSource? _incomeSource;                // Gelir kaynağı (Maaş / Borç İadesi / Diğer)
  bool _isSaving = false;                     // Kayıt işlemi devam ediyor mu?

  @override
  void initState() {
    super.initState();
    final tx = widget.initialTransaction;
    if (tx != null) {
      _type = tx.type;
      _amountController = TextEditingController(text: CurrencyFormatter.toEditString(tx.amountMinor));
      _descController = TextEditingController(text: tx.description);
      _receiptController = TextEditingController(text: tx.receiptNote ?? '');
      _selectedDate = tx.occurredAt;
      _selectedCategoryId = tx.categoryId;
      _isCharity = tx.isCharity;
      _isAmountHidden = tx.isAmountHidden;
      _incomeSource = tx.incomeSource;
    } else {
      _type = TransactionType.expense;
      _amountController = TextEditingController();
      _descController = TextEditingController();
      _receiptController = TextEditingController();
      _selectedDate = DateTime.now();
      _incomeSource = IncomeSource.salary;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    _receiptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final isEditing = widget.initialTransaction != null;

    final filteredCategories = provider.categories.where((c) {
      if (_type == TransactionType.income) {
        return c.type == CategoryType.income || c.type == CategoryType.both;
      } else {
        return c.type == CategoryType.expense || c.type == CategoryType.both;
      }
    }).toList();

    // Default category if not set or invalid for current type
    if (_selectedCategoryId == null || !filteredCategories.any((c) => c.id == _selectedCategoryId)) {
      if (filteredCategories.isNotEmpty) {
        _selectedCategoryId = filteredCategories.first.id;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'İşlemi Düzenle' : 'Yeni İşlem Kaydı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. İşlem Türü Seçimi (Gelir / Gider)
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
                        onTap: () {
                          setState(() {
                            _type = TransactionType.expense;
                            _incomeSource = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == TransactionType.expense
                                ? AppColors.expenseSurface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _type == TransactionType.expense
                                ? Border.all(color: AppColors.expense, width: 1.5)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.receipt_outlined, size: 16, color: AppColors.expense),
                              SizedBox(width: 6),
                              Text(
                                'Gider Kaydı',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _type = TransactionType.income;
                            _incomeSource = IncomeSource.salary;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _type == TransactionType.income
                                ? AppColors.incomeSurface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _type == TransactionType.income
                                ? Border.all(color: AppColors.income, width: 1.5)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.payments_outlined, size: 16, color: AppColors.income),
                              SizedBox(width: 6),
                              Text(
                                'Gelir Kaydı',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Gelir ise: Gelir Kaynağı Seçimi & Olağan Dışı Gelir Uyarısı
              if (_type == TransactionType.income) ...[
                const Text(
                  'Gelir Kaynağı',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildSourceChip('Maaş', IncomeSource.salary),
                    const SizedBox(width: 8),
                    _buildSourceChip('Borç İadesi', IncomeSource.debt_repayment),
                    const SizedBox(width: 8),
                    _buildSourceChip('Diğer Gelir', IncomeSource.other),
                  ],
                ),
                if (_incomeSource == IncomeSource.other) ...[
                  const SizedBox(height: 10),
                  const AppBanner(
                    title: 'Olağan Dışı Gelir Bilgilendirmesi',
                    message: 'Maaş veya borç geri ödemesi dışındaki gelirler olağan dışı kabul edilebilir. Bu bilgilendirme amaçlıdır, işleme devam edebilirsiniz.',
                    type: AppNotificationType.warning,
                  ),
                ],
                const SizedBox(height: 16),
              ],

              // 2. Tutar Girişi (Zorunlu, float değil minor kuruş olarak saklanır)
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Tutar (₺) *',
                  hintText: '0,00',
                  prefixIcon: const Icon(Icons.attach_money, color: AppColors.indicatorBlue),
                  suffixText: 'TRY',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen tutar giriniz';
                  }
                  final minor = CurrencyFormatter.parseToMinor(val);
                  if (minor <= 0) {
                    return 'Tutar sıfırdan büyük olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Açıklama (Zorunlu)
              TextFormField(
                controller: _descController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Açıklama *',
                  hintText: 'Örn: Süpermarket alışverişi, kira ödemesi...',
                  prefixIcon: Icon(Icons.edit_note, color: AppColors.textSecondary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Açıklama zorunludur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Kategori Seçimi (Zorunlu)
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategori *',
                  prefixIcon: Icon(Icons.category_outlined, color: AppColors.textSecondary),
                ),
                dropdownColor: AppColors.surfaceRaised,
                items: filteredCategories.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name, style: const TextStyle(color: AppColors.textPrimary)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategoryId = val;
                  });
                },
                validator: (val) => val == null ? 'Lütfen kategori seçiniz' : null,
              ),
              const SizedBox(height: 16),

              // 5. Tarih Seçici
              InkWell(
                onTap: () => _pickDate(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('İşlem Tarihi', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                              Text(
                                DateFormatter.formatFull(_selectedDate),
                                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 6. Fiş / Fatura Notu (Opsiyonel)
              TextFormField(
                controller: _receiptController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Fiş / Fatura Notu veya Referans (İsteğe bağlı)',
                  hintText: 'Örn: Fiş no: 1948, dekont ref: 84931',
                  prefixIcon: Icon(Icons.receipt, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 20),

              // Gider Özel Alanları: Hayır İşi ve Özel Tutar Gizleme
              if (_type == TransactionType.expense) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.indicatorBlue,
                        title: Row(
                          children: const [
                            Icon(Icons.favorite, size: 18, color: AppColors.expense),
                            SizedBox(width: 8),
                            Text(
                              'Hayır İşi Olarak İşaretle',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        subtitle: const Text(
                          'Hayır işleri gider toplamına dahil edilir, raporda filtrelenebilir.',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        value: _isCharity,
                        onChanged: (val) => setState(() => _isCharity = val),
                      ),
                      const Divider(color: AppColors.border),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: AppColors.indicatorBlue,
                        title: Row(
                          children: const [
                            Icon(Icons.lock_outline, size: 18, color: AppColors.indicatorBlue),
                            SizedBox(width: 8),
                            Text(
                              'Özel Gider Tutarını Gizle',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        subtitle: const Text(
                          'Tutar arayüzde sansürlü görünür (₺••••), toplam hesaplamalarına katılır.',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                        value: _isAmountHidden,
                        onChanged: (val) => setState(() => _isAmountHidden = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // 7. Kaydet Düğmesi (Çift dokunuş korumalı)
              ElevatedButton(
                onPressed: _isSaving ? null : () => _handleSave(context, provider),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        isEditing ? 'Değişiklikleri Kaydet' : 'İşlemi Kaydet',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceChip(String label, IncomeSource source) {
    final bool isSelected = _incomeSource == source;
    return Expanded(
      child: ChoiceChip(
        label: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.indicatorBlue.withOpacity(0.3),
        backgroundColor: AppColors.surfaceRaised,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _incomeSource = source;
            });
          }
        },
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.indicatorBlue,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSave(BuildContext context, FinanceProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    setState(() => _isSaving = true);

    try {
      final amountMinor = CurrencyFormatter.parseToMinor(_amountController.text);
      final receipt = _receiptController.text.trim();

      if (widget.initialTransaction != null) {
        final updated = widget.initialTransaction!.copyWith(
          type: _type,
          amountMinor: amountMinor,
          description: _descController.text.trim(),
          categoryId: _selectedCategoryId,
          occurredAt: _selectedDate,
          receiptNote: receipt.isNotEmpty ? receipt : null,
          isCharity: _type == TransactionType.expense ? _isCharity : false,
          isAmountHidden: _type == TransactionType.expense ? _isAmountHidden : false,
          incomeSource: _type == TransactionType.income ? _incomeSource : null,
        );
        await provider.updateTransaction(updated);
      } else {
        final newTx = Transaction(
          id: const Uuid().v4(),
          type: _type,
          amountMinor: amountMinor,
          description: _descController.text.trim(),
          categoryId: _selectedCategoryId!,
          occurredAt: _selectedDate,
          receiptNote: receipt.isNotEmpty ? receipt : null,
          isCharity: _type == TransactionType.expense ? _isCharity : false,
          isAmountHidden: _type == TransactionType.expense ? _isAmountHidden : false,
          incomeSource: _type == TransactionType.income ? _incomeSource : null,
        );
        await provider.addTransaction(newTx);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.successBackground,
            content: Text(
              widget.initialTransaction != null ? 'İşlem güncellendi.' : 'Yeni işlem başarıyla kaydedildi.',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.criticalBackground,
            content: Text('Hata oluştu: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
