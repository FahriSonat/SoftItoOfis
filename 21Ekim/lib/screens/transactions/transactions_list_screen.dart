import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../../providers/finance_provider.dart';
import 'transaction_detail_screen.dart';
import 'transaction_form_screen.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;
  final bool _onlyCharity = false;
  bool _filterAllMonths = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinanceProvider>();
    final currentMonth = provider.selectedMonth;

    // Filter base: all transactions or selected month transactions
    final baseList = _filterAllMonths
        ? provider.transactions
        : provider.transactions.where((tx) =>
            tx.occurredAt.year == currentMonth.year &&
            tx.occurredAt.month == currentMonth.month
          ).toList();

    // Filter by Tab (0: Tümü, 1: Gelirler, 2: Giderler, 3: Hayır İşi) and Search/Category
    final List<Transaction> filtered = baseList.where((tx) {
      if (_tabController.index == 1 && !tx.isIncome) return false;
      if (_tabController.index == 2 && !tx.isExpense) return false;
      if (_tabController.index == 3 && (!tx.isExpense || !tx.isCharity)) return false;

      if (_onlyCharity && (!tx.isExpense || !tx.isCharity)) return false;

      if (_selectedCategoryId != null && tx.categoryId != _selectedCategoryId) {
        return false;
      }

      final query = _searchController.text.trim().toLowerCase();
      if (query.isNotEmpty) {
        final desc = tx.description.toLowerCase();
        final note = (tx.receiptNote ?? '').toLowerCase();
        if (!desc.contains(query) && !note.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text('İşlem Geçmişi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'Gelirler'),
            Tab(text: 'Giderler'),
            Tab(text: 'Hayır İşi'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.revealHiddenAmountsInSession
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
            ),
            tooltip: 'Gizli tutarları sansürle/göster',
            onPressed: () => provider.toggleRevealHiddenAmounts(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Tarih / Ay Değişim Çubuğu (Date & Month Navigation Bar)
          _buildMonthNavigator(context, provider),

          // 2. Arama ve Kategori Filtreleri (Tek Satırda Kompakt & Responsive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                // Arama Kutusu (Kalan genişliği doldurur)
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Açıklamada ara...',
                        hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textMuted),
                        prefixIconConstraints: const BoxConstraints(minWidth: 32),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.clear, size: 14),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Kompakt Kategori Filtre Butonu
                InkWell(
                  onTap: () => _showCategoryFilterSheet(context, provider),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: _selectedCategoryId != null
                          ? AppColors.indicatorBlue.withValues(alpha: 0.15)
                          : AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _selectedCategoryId != null
                            ? AppColors.indicatorBlue
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          size: 16,
                          color: _selectedCategoryId != null
                              ? AppColors.indicatorBlue
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 105),
                          child: Text(
                            _selectedCategoryId != null
                                ? (provider.categoryMap[_selectedCategoryId]?.name ?? 'Kategori')
                                : 'Kategori',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: _selectedCategoryId != null
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _selectedCategoryId != null
                                  ? AppColors.indicatorBlue
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (_selectedCategoryId != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() => _selectedCategoryId = null);
                            },
                            child: const Icon(Icons.close, size: 14, color: AppColors.indicatorBlue),
                          ),
                        ] else ...[
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textMuted),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Toplam Kayıt Bilgisi ve Dönem Göstergesi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surfaceRaised,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filtered.length} Kayıt Gösteriliyor',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Text(
                  _filterAllMonths ? 'Tüm Zamanlar' : DateFormatter.formatMonthYear(currentMonth),
                  style: const TextStyle(color: AppColors.indicatorBlue, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          // 4. İşlem Listesi
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'Seçili dönem ve kriterlere uygun işlem bulunamadı.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 1),
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      final category = provider.categoryMap[tx.categoryId];
                      final isIncome = tx.isIncome;
                      final isCensored = tx.isAmountHidden && provider.revealHiddenAmountsInSession;

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(transaction: tx),
                            ),
                          );
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isIncome ? AppColors.incomeSurface : AppColors.expenseSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isIncome ? Icons.payments_outlined : Icons.receipt_outlined,
                            color: isIncome ? AppColors.income : AppColors.expense,
                            size: 18,
                          ),
                        ),
                        title: Row(
                          children: [
                            if (tx.isCharity)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.favorite, size: 14, color: AppColors.expense),
                              ),
                            if (tx.isAmountHidden)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.lock_outline, size: 14, color: AppColors.indicatorBlue),
                              ),
                            Expanded(
                              child: Text(
                                tx.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${category?.name ?? "Genel"} • ${DateFormatter.formatDotted(tx.occurredAt)}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        trailing: Text(
                          '${isIncome ? "+" : "-"}${CurrencyFormatter.format(tx.amountMinor, isHidden: isCensored)}',
                          style: TextStyle(
                            color: isIncome ? AppColors.income : AppColors.expense,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.indicatorBlue,
        foregroundColor: AppColors.textPrimary,
        child: const Icon(Icons.add),
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

  Widget _buildMonthNavigator(BuildContext context, FinanceProvider provider) {
    final current = provider.selectedMonth;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Geri Butonu
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
            tooltip: 'Önceki Ay',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _filterAllMonths = false;
              });
              provider.setSelectedMonth(DateTime(current.year, current.month - 1, 1));
            },
          ),

          // Tarih Seçici / Açılır Takvim
          InkWell(
            onTap: () => _pickMonth(context, provider),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 15, color: AppColors.indicatorBlue),
                  const SizedBox(width: 8),
                  Text(
                    _filterAllMonths ? 'Tüm Zamanlar' : DateFormatter.formatMonthYear(current),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textMuted),
                ],
              ),
            ),
          ),

          // İleri Butonu
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
            tooltip: 'Sonraki Ay',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _filterAllMonths = false;
              });
              provider.setSelectedMonth(DateTime(current.year, current.month + 1, 1));
            },
          ),

          // Tüm Zamanlar / Ay Filtresi Butonu
          ActionChip(
            label: Text(
              _filterAllMonths ? 'Aya Dön' : 'Tümü',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            backgroundColor: _filterAllMonths
                ? AppColors.indicatorBlue.withOpacity(0.3)
                : AppColors.surfaceRaised,
            onPressed: () {
              setState(() {
                _filterAllMonths = !_filterAllMonths;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickMonth(BuildContext context, FinanceProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'DÖNEM AYI SEÇİNİZ',
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
        _filterAllMonths = false;
      });
      provider.setSelectedMonth(DateTime(picked.year, picked.month, 1));
    }
  }

  void _showCategoryFilterSheet(BuildContext context, FinanceProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kategoriye Göre Filtrele',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (_selectedCategoryId != null)
                        TextButton(
                          onPressed: () {
                            setState(() => _selectedCategoryId = null);
                            Navigator.pop(context);
                          },
                          child: const Text('Filtreyi Temizle'),
                        ),
                    ],
                  ),
                  const Divider(color: AppColors.border),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.apps, size: 18, color: AppColors.indicatorBlue),
                          ),
                          title: const Text('Tüm Kategoriler', style: TextStyle(fontWeight: FontWeight.w600)),
                          trailing: _selectedCategoryId == null
                              ? const Icon(Icons.check, color: AppColors.indicatorBlue)
                              : null,
                          selected: _selectedCategoryId == null,
                          selectedTileColor: AppColors.indicatorBlue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onTap: () {
                            setState(() => _selectedCategoryId = null);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 6),
                        ...provider.categories.map((c) {
                          final isSelected = _selectedCategoryId == c.id;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceRaised,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: c.type == CategoryType.income
                                        ? AppColors.income
                                        : AppColors.indicatorBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              title: Text(
                                c.name,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  color: isSelected ? AppColors.indicatorBlue : AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                c.type == CategoryType.income
                                    ? 'Gelir Kategorisi'
                                    : (c.type == CategoryType.expense ? 'Gider Kategorisi' : 'Ortak Kategori'),
                                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: AppColors.indicatorBlue)
                                  : null,
                              selected: isSelected,
                              selectedTileColor: AppColors.indicatorBlue.withOpacity(0.1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onTap: () {
                                setState(() => _selectedCategoryId = c.id);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
