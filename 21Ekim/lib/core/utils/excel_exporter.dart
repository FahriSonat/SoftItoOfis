import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/transaction.dart';
import '../../data/models/category.dart';
import '../../data/models/budget.dart';
import '../../data/models/debt.dart';
import '../../data/models/recurring_payment.dart';
import 'currency_formatter.dart';
import 'date_formatter.dart';

class ExcelExporter {
  ExcelExporter._();

  static Future<String> exportReport({
    required List<Transaction> transactions,
    required List<Category> categories,
    required List<Budget> budgets,
    required List<Debt> debts,
    List<RecurringPayment>? recurringPayments,
    required bool censorHiddenAmounts,
    required DateTime selectedDate,
  }) async {
    final excel = Excel.createExcel();

    final categoryMap = {for (var c in categories) c.id: c.name};

    // Filter transactions for the selected month
    final monthTxs = transactions.where((tx) =>
      tx.occurredAt.year == selectedDate.year &&
      tx.occurredAt.month == selectedDate.month
    ).toList()
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

    int totalIncomeMinor = 0;
    int totalExpenseMinor = 0;
    int totalCharityMinor = 0;
    int incomeCount = 0;
    int expenseCount = 0;

    for (final tx in monthTxs) {
      if (tx.isIncome) {
        totalIncomeMinor += tx.amountMinor;
        incomeCount++;
      } else {
        totalExpenseMinor += tx.amountMinor;
        expenseCount++;
        if (tx.isCharity) {
          totalCharityMinor += tx.amountMinor;
        }
      }
    }

    final int netBalanceMinor = totalIncomeMinor - totalExpenseMinor;
    final int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final double dailyAvgExpense = (totalExpenseMinor / 100.0) / daysInMonth;

    // =========================================================================
    // SAYFA 1: AYLIk FINANSAL ÖZET (Detailed Overview)
    // =========================================================================
    final Sheet summarySheet = excel['Finansal Özet'];
    summarySheet.appendRow([TextCellValue('KİŞİSEL GÜNLÜK PARA TAKİP UYGULAMASI')]);
    summarySheet.appendRow([TextCellValue('AYLIK DETAYLI FİNANSAL RAPOR')]);
    summarySheet.appendRow([TextCellValue('')]);

    summarySheet.appendRow([TextCellValue('Rapor Dönemi:'), TextCellValue(DateFormatter.formatMonthYear(selectedDate))]);
    summarySheet.appendRow([TextCellValue('Oluşturulma Tarihi:'), TextCellValue(DateFormatter.formatDotted(DateTime.now()))]);
    summarySheet.appendRow([TextCellValue('Para Birimi:'), TextCellValue('Türk Lirası (TRY)')]);
    summarySheet.appendRow([TextCellValue('')]);

    summarySheet.appendRow([TextCellValue('TEMEL FİNANSAL GÖSTERGELER'), TextCellValue('DEĞER')]);
    summarySheet.appendRow([TextCellValue('Toplam Gelir'), TextCellValue(CurrencyFormatter.format(totalIncomeMinor))]);
    summarySheet.appendRow([TextCellValue('Toplam Gider'), TextCellValue(CurrencyFormatter.format(totalExpenseMinor))]);
    summarySheet.appendRow([TextCellValue('Dönem Net Bakiyesi (Tasarruf / Açık)'), TextCellValue(CurrencyFormatter.format(netBalanceMinor))]);
    summarySheet.appendRow([TextCellValue('Hayır İşi / Bağış Giderleri'), TextCellValue(CurrencyFormatter.format(totalCharityMinor))]);
    summarySheet.appendRow([TextCellValue('Günlük Ortalama Harcama'), TextCellValue('₺${dailyAvgExpense.toStringAsFixed(2)}')]);
    summarySheet.appendRow([TextCellValue('Toplam İşlem Adedi'), IntCellValue(monthTxs.length)]);
    summarySheet.appendRow([TextCellValue('Gelir İşlem Adedi'), IntCellValue(incomeCount)]);
    summarySheet.appendRow([TextCellValue('Gider İşlem Adedi'), IntCellValue(expenseCount)]);
    if (totalIncomeMinor > 0) {
      final double savingsRate = (netBalanceMinor / totalIncomeMinor) * 100.0;
      summarySheet.appendRow([TextCellValue('Tasarruf Oranı'), TextCellValue('%${savingsRate.toStringAsFixed(1)}')]);
    }

    // =========================================================================
    // SAYFA 2: TÜM İŞLEMLER DETAYLI DÖKÜMÜ (Transactions Detail)
    // Not: Gelir ve gider yanında ok işaretleri KULLANILMAZ
    // =========================================================================
    final Sheet txSheet = excel['İşlem Detayları'];
    txSheet.appendRow([
      TextCellValue('Sıra No'),
      TextCellValue('Tarih'),
      TextCellValue('İşlem Türü'),
      TextCellValue('Kategori'),
      TextCellValue('Açıklama'),
      TextCellValue('Fiş / Fatura Notu'),
      TextCellValue('Gelir Kaynağı'),
      TextCellValue('Hayır İşi mi?'),
      TextCellValue('Gizlilik Durumu'),
      TextCellValue('Tutar (TRY)'),
    ]);

    int rowIdx = 1;
    for (final tx in monthTxs) {
      final isHidden = tx.isAmountHidden && censorHiddenAmounts;

      String sourceStr = '-';
      if (tx.isIncome && tx.incomeSource != null) {
        sourceStr = tx.incomeSource == IncomeSource.salary
            ? 'Maaş'
            : tx.incomeSource == IncomeSource.debt_repayment
                ? 'Borç İadesi'
                : 'Diğer Gelir';
      }

      txSheet.appendRow([
        IntCellValue(rowIdx++),
        TextCellValue(DateFormatter.formatDotted(tx.occurredAt)),
        TextCellValue(tx.isIncome ? 'Gelir' : 'Gider'), // OK İŞARETİ YOK
        TextCellValue(categoryMap[tx.categoryId] ?? 'Genel'),
        TextCellValue(tx.description),
        TextCellValue(tx.receiptNote ?? '-'),
        TextCellValue(sourceStr),
        TextCellValue(tx.isCharity ? 'Evet' : 'Hayır'),
        TextCellValue(tx.isAmountHidden ? 'Özel Tutar' : 'Standart'),
        isHidden
            ? TextCellValue('₺••••')
            : DoubleCellValue(tx.amountMinor / 100.0),
      ]);
    }

    // =========================================================================
    // SAYFA 3: KATEGORİ HARCAMA ANALİZİ (Category Breakdown)
    // =========================================================================
    final Sheet categorySheet = excel['Kategori Analizi'];
    categorySheet.appendRow([
      TextCellValue('Kategori Adı'),
      TextCellValue('Toplam Harcama (TRY)'),
      TextCellValue('Gider Payı (%)'),
      TextCellValue('İşlem Adedi'),
    ]);

    final Map<String, int> catSpending = {};
    final Map<String, int> catCount = {};
    for (final tx in monthTxs.where((t) => t.isExpense)) {
      catSpending[tx.categoryId] = (catSpending[tx.categoryId] ?? 0) + tx.amountMinor;
      catCount[tx.categoryId] = (catCount[tx.categoryId] ?? 0) + 1;
    }

    final sortedCats = catSpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedCats) {
      final catName = categoryMap[entry.key] ?? 'Diğer Gider';
      final spent = entry.value;
      final count = catCount[entry.key] ?? 1;
      final double pct = totalExpenseMinor > 0 ? (spent / totalExpenseMinor) * 100.0 : 0.0;

      categorySheet.appendRow([
        TextCellValue(catName),
        DoubleCellValue(spent / 100.0),
        TextCellValue('%${pct.toStringAsFixed(1)}'),
        IntCellValue(count),
      ]);
    }

    // =========================================================================
    // SAYFA 4: BÜTÇE VE LİMİT UYUMU (Budgets Compliance)
    // =========================================================================
    final Sheet budgetSheet = excel['Bütçe ve Limitler'];
    budgetSheet.appendRow([
      TextCellValue('Bütçe Türü / Kategori'),
      TextCellValue('Tanımlı Limit (TRY)'),
      TextCellValue('Gerçekleşen Harcama (TRY)'),
      TextCellValue('Kalan / Aşım Tutarı (TRY)'),
      TextCellValue('Kullanım Oranı (%)'),
      TextCellValue('Limit Durumu'),
    ]);

    for (final b in budgets) {
      int spent = 0;
      String name = 'Genel Bütçe';

      if (b.categoryId != null) {
        name = categoryMap[b.categoryId] ?? 'Kategori';
        spent = catSpending[b.categoryId] ?? 0;
      } else {
        name = b.method == BudgetMethod.rule503020 ? '50/30/20 Genel Limit' : 'Aylık Genel Limit';
        spent = totalExpenseMinor;
      }

      final limit = b.amountMinor;
      final diff = limit - spent;
      final double ratio = limit > 0 ? (spent / limit) * 100.0 : 0.0;
      final String status = spent > limit
          ? 'Limit Aşıldı'
          : (ratio >= 80.0 ? 'Uyarı Eşiğinde' : 'Limit İçi');

      budgetSheet.appendRow([
        TextCellValue(name),
        DoubleCellValue(limit / 100.0),
        DoubleCellValue(spent / 100.0),
        DoubleCellValue(diff / 100.0),
        TextCellValue('%${ratio.toStringAsFixed(1)}'),
        TextCellValue(status),
      ]);
    }

    // =========================================================================
    // SAYFA 5: BORÇ VE ALACAKLAR (Debts & Receivables)
    // =========================================================================
    final Sheet debtSheet = excel['Borçlar ve Alacaklar'];
    debtSheet.appendRow([
      TextCellValue('İşlem Yönü'),
      TextCellValue('Kişi / Kurum'),
      TextCellValue('Ana Para (TRY)'),
      TextCellValue('Kalan Tutar (TRY)'),
      TextCellValue('Ödenen / Tahsil Edilen (TRY)'),
      TextCellValue('Vade Tarihi'),
      TextCellValue('Durum'),
      TextCellValue('Açıklama / Not'),
    ]);

    for (final d in debts) {
      final paid = d.principalMinor - d.remainingMinor;
      debtSheet.appendRow([
        TextCellValue(d.isLent ? 'Verilen Borç (Alacak)' : 'Alınan Borç (Borcumuz)'), // OK İŞARETİ YOK
        TextCellValue(d.counterparty),
        DoubleCellValue(d.principalMinor / 100.0),
        DoubleCellValue(d.remainingMinor / 100.0),
        DoubleCellValue(paid / 100.0),
        TextCellValue(d.dueDate != null ? DateFormatter.formatDotted(d.dueDate!) : 'Belirtilmedi'),
        TextCellValue(d.isSettled ? 'Kapandı' : (d.status == DebtStatus.partial ? 'Kısmi Ödendi' : 'Açık')),
        TextCellValue(d.note ?? '-'),
      ]);
    }

    // =========================================================================
    // SAYFA 6: DÜZENLİ FATURALAR (Recurring Bills)
    // =========================================================================
    if (recurringPayments != null && recurringPayments.isNotEmpty) {
      final Sheet billSheet = excel['Düzenli Faturalar'];
      billSheet.appendRow([
        TextCellValue('Fatura / Ödeme Adı'),
        TextCellValue('Kategori'),
        TextCellValue('Tekrarlama Sıklığı'),
        TextCellValue('Beklenen Tutar (TRY)'),
        TextCellValue('Sonraki Vade'),
        TextCellValue('Bu Dönem Ödendi mi?'),
      ]);

      for (final bill in recurringPayments) {
        final cadenceStr = bill.cadence == RecurringCadence.monthly
            ? 'Aylık'
            : bill.cadence == RecurringCadence.weekly
                ? 'Haftalık'
                : 'Günlük';

        billSheet.appendRow([
          TextCellValue(bill.title),
          TextCellValue(categoryMap[bill.categoryId] ?? 'Faturalar'),
          TextCellValue(cadenceStr),
          bill.expectedAmountMinor != null
              ? DoubleCellValue(bill.expectedAmountMinor! / 100.0)
              : TextCellValue('Değişken'),
          TextCellValue(DateFormatter.formatDotted(bill.dueDate)),
          TextCellValue(bill.isPaidThisPeriod ? 'Evet' : 'Hayır'),
        ]);
      }
    }

    // Remove default sheet created by excel package if it exists
    excel.delete('Sheet1');

    final List<int>? fileBytes = excel.save();
    if (fileBytes == null) {
      throw Exception('Excel dosyası oluşturulamadı.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'Detayli_Finans_Raporu_${selectedDate.year}_${selectedDate.month}.xlsx';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(Uint8List.fromList(fileBytes));

    return file.path;
  }
}
