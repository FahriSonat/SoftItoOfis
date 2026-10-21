import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_finance_app/core/utils/currency_formatter.dart';
import 'package:personal_finance_app/data/models/transaction.dart';
import 'package:personal_finance_app/data/models/debt.dart';
import 'package:personal_finance_app/data/models/recurring_payment.dart';
import 'package:personal_finance_app/providers/finance_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CurrencyFormatter tests (Integer Minor Units / Kuruş)', () {
    test('Formats minor units without float inaccuracies', () {
      expect(CurrencyFormatter.format(15050), '₺150,50');
      expect(CurrencyFormatter.format(0), '₺0,00');
      expect(CurrencyFormatter.format(100000), '₺1.000,00');
    });

    test('Censors private amounts correctly when isHidden is true', () {
      expect(CurrencyFormatter.format(15050, isHidden: true), '₺••••');
    });

    test('Parses user decimal strings to minor integer accurately', () {
      expect(CurrencyFormatter.parseToMinor('150,50'), 15050);
      expect(CurrencyFormatter.parseToMinor('150.50'), 15050);
      expect(CurrencyFormatter.parseToMinor('1.500,00'), 150000);
      expect(CurrencyFormatter.parseToMinor('1500'), 150000);
    });
  });

  group('FinanceProvider business rules tests', () {
    test('Calculates income, expense and net balance accurately', () async {
      final provider = FinanceProvider();
      await provider.init();

      final now = DateTime.now();
      final initialIncome = provider.selectedMonthIncomeMinor;
      final initialExpense = provider.selectedMonthExpenseMinor;

      // Add a test expense
      final testExpense = Transaction(
        id: 'test-exp-1',
        type: TransactionType.expense,
        amountMinor: 25000, // 250,00 ₺
        categoryId: 'cat-groceries',
        occurredAt: now,
        description: 'Test Market Harcaması',
      );
      await provider.addTransaction(testExpense);

      expect(provider.selectedMonthExpenseMinor, initialExpense + 25000);
      expect(provider.selectedMonthIncomeMinor, initialIncome);
      expect(provider.selectedMonthNetBalanceMinor, initialIncome - (initialExpense + 25000));
    });

    test('Hidden amounts are included in total expense', () async {
      final provider = FinanceProvider();
      await provider.init();

      final now = DateTime.now();
      final beforeExpense = provider.selectedMonthExpenseMinor;

      final hiddenExpense = Transaction(
        id: 'test-hidden-1',
        type: TransactionType.expense,
        amountMinor: 50000, // 500,00 ₺
        categoryId: 'cat-dining',
        occurredAt: now,
        description: 'Özel Harcama',
        isAmountHidden: true,
      );
      await provider.addTransaction(hiddenExpense);

      // Verify it is included in total calculation
      expect(provider.selectedMonthExpenseMinor, beforeExpense + 50000);
    });

    test('Charity expenses are included in total expense and counted in charity subtotal', () async {
      final provider = FinanceProvider();
      await provider.init();

      final now = DateTime.now();
      final beforeExpense = provider.selectedMonthExpenseMinor;
      final beforeCharity = provider.selectedMonthCharityMinor;

      final charityExpense = Transaction(
        id: 'test-charity-1',
        type: TransactionType.expense,
        amountMinor: 75000, // 750,00 ₺
        categoryId: 'cat-charity',
        occurredAt: now,
        description: 'Yetim burs desteği',
        isCharity: true,
      );
      await provider.addTransaction(charityExpense);

      expect(provider.selectedMonthExpenseMinor, beforeExpense + 75000);
      expect(provider.selectedMonthCharityMinor, beforeCharity + 75000);
    });

    test('Debt repayment creates cash flow transaction and prevents double counting', () async {
      final provider = FinanceProvider();
      await provider.init();

      final debt = Debt(
        id: 'test-debt-lent',
        direction: DebtDirection.lent, // Verilen borç
        counterparty: 'Ali Kaya',
        principalMinor: 100000, // 1.000 ₺
        remainingMinor: 100000,
      );
      await provider.addDebt(debt);

      final beforeIncome = provider.selectedMonthIncomeMinor;

      // Collect 500 ₺ repayment
      await provider.recordDebtRepayment(
        debt: debt,
        paymentAmountMinor: 50000,
      );

      // Remaining debt should be 500 ₺
      final updated = provider.debts.firstWhere((d) => d.id == debt.id);
      expect(updated.remainingMinor, 50000);
      expect(updated.status, DebtStatus.partial);

      // Should have generated an income transaction
      expect(provider.selectedMonthIncomeMinor, beforeIncome + 50000);
    });

    test('Paying recurring bill generates expense and advances schedule', () async {
      final provider = FinanceProvider();
      await provider.init();

      final now = DateTime.now();
      final bill = RecurringPayment(
        id: 'test-bill-fiber',
        title: 'Test İnternet',
        expectedAmountMinor: 45000, // 450 ₺
        cadence: RecurringCadence.monthly,
        dueDate: DateTime(now.year, now.month, 20),
        categoryId: 'cat-bills',
        isPaidThisPeriod: false,
      );
      await provider.addRecurringPayment(bill);

      final beforeExpense = provider.selectedMonthExpenseMinor;

      await provider.markRecurringAsPaid(item: bill);

      // Verify expense transaction is added
      expect(provider.selectedMonthExpenseMinor, beforeExpense + 45000);

      // Verify bill is marked paid and dueDate advanced to next month
      final updatedBill = provider.recurringPayments.firstWhere((b) => b.id == bill.id);
      expect(updatedBill.isPaidThisPeriod, true);
      expect(updatedBill.dueDate.month, (now.month % 12) + 1);
    });
  });
}
