import 'package:flutter/foundation.dart' hide Category;
import '../data/models/transaction.dart';
import '../data/models/category.dart';
import '../data/models/budget.dart';
import '../data/models/recurring_payment.dart';
import '../data/models/debt.dart';
import '../data/models/user_settings.dart';
import '../data/services/finance_repository.dart';
import '../data/services/notification_service.dart';
import '../core/utils/date_formatter.dart';

class FinanceProvider with ChangeNotifier {
  final FinanceRepository _repository;

  FinanceProvider({FinanceRepository? repository})
      : _repository = repository ?? FinanceRepository();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  List<Budget> _budgets = [];
  List<RecurringPayment> _recurringPayments = [];
  List<Debt> _debts = [];
  UserSettings _settings = UserSettings();
  final Set<String> _dismissedNotificationIds = {};

  DateTime _selectedMonth = DateTime.now();
  bool _revealHiddenAmountsInSession = false;

  // Cached aggregates for high performance (O(1) access)
  List<Transaction> _selectedMonthTransactions = [];
  int _selectedMonthIncomeMinor = 0;
  int _selectedMonthExpenseMinor = 0;
  int _selectedMonthCharityMinor = 0;
  Map<String, Category> _categoryMap = {};

  // Getters
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Category> get categories => List.unmodifiable(_categories);
  List<Budget> get budgets => List.unmodifiable(_budgets);
  List<RecurringPayment> get recurringPayments => List.unmodifiable(_recurringPayments);
  List<Debt> get debts => List.unmodifiable(_debts);
  UserSettings get settings => _settings;
  DateTime get selectedMonth => _selectedMonth;
  bool get revealHiddenAmountsInSession => _revealHiddenAmountsInSession;

  Map<String, Category> get categoryMap => _categoryMap;

  void _recomputeCategoryMap() {
    _categoryMap = {for (var c in _categories) c.id: c};
  }

  void _recomputeMonthlyAggregates() {
    final filtered = <Transaction>[];
    int income = 0;
    int expense = 0;
    int charity = 0;

    for (final tx in _transactions) {
      if (tx.occurredAt.year == _selectedMonth.year &&
          tx.occurredAt.month == _selectedMonth.month) {
        filtered.add(tx);
        if (tx.isIncome) {
          income += tx.amountMinor;
        } else if (tx.isExpense) {
          expense += tx.amountMinor;
          if (tx.isCharity) {
            charity += tx.amountMinor;
          }
        }
      }
    }

    filtered.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    _selectedMonthTransactions = filtered;
    _selectedMonthIncomeMinor = income;
    _selectedMonthExpenseMinor = expense;
    _selectedMonthCharityMinor = charity;
  }

  void toggleRevealHiddenAmounts() {
    _revealHiddenAmountsInSession = !_revealHiddenAmountsInSession;
    notifyListeners();
  }

  void setSelectedMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    _recomputeMonthlyAggregates();
    notifyListeners();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _repository.loadTransactions();
      _categories = await _repository.loadCategories();
      _budgets = await _repository.loadBudgets();
      _recurringPayments = await _repository.loadRecurringPayments();
      _debts = await _repository.loadDebts();
      _settings = await _repository.loadSettings();
      _recomputeCategoryMap();
      _recomputeMonthlyAggregates();
    } catch (e) {
      debugPrint('Initialization error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Calculations for selected month (Cached O(1) Reads) ---

  List<Transaction> get selectedMonthTransactions => _selectedMonthTransactions;
  int get selectedMonthIncomeMinor => _selectedMonthIncomeMinor;
  int get selectedMonthExpenseMinor => _selectedMonthExpenseMinor;
  int get selectedMonthNetBalanceMinor => _selectedMonthIncomeMinor - _selectedMonthExpenseMinor;
  int get selectedMonthCharityMinor => _selectedMonthCharityMinor;

  // --- Today and Week Expenses ---

  int get todayExpenseMinor {
    final now = DateTime.now();
    int total = 0;
    for (final tx in _transactions) {
      if (tx.isExpense &&
          tx.occurredAt.year == now.year &&
          tx.occurredAt.month == now.month &&
          tx.occurredAt.day == now.day) {
        total += tx.amountMinor;
      }
    }
    return total;
  }

  int get currentWeekExpenseMinor {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    int total = 0;
    for (final tx in _transactions) {
      if (tx.isExpense && tx.occurredAt.isAfter(startDay.subtract(const Duration(seconds: 1)))) {
        total += tx.amountMinor;
      }
    }
    return total;
  }

  /// Kalan günlük harcanabilir para hesabı (Tahmin)
  /// Remaining monthly budget / days remaining in current month
  int get dailySpendableMinor {
    final now = DateTime.now();
    final remainingDays = DateFormatter.daysRemainingInMonth(now);
    final limit = _settings.monthlyLimitMinor;
    final currentExpense = selectedMonthExpenseMinor;

    final remainingBudget = limit - currentExpense;
    if (remainingBudget <= 0) return 0;

    return (remainingBudget / remainingDays).round();
  }

  // --- Notifications ---

  List<AppNotification> get notifications {
    final all = NotificationService.evaluateNotifications(
      monthlyExpenseMinor: selectedMonthExpenseMinor,
      monthlyLimitMinor: _settings.monthlyLimitMinor,
      alertThreshold: _settings.alertThreshold,
      budgets: _budgets,
      recurringPayments: _recurringPayments,
      debts: _debts,
      settings: _settings,
    );

    return all.where((n) => !_dismissedNotificationIds.contains(n.id)).toList();
  }

  void dismissNotification(String id) {
    _dismissedNotificationIds.add(id);
    notifyListeners();
  }

  // --- Transaction Actions ---

  Future<void> addTransaction(Transaction tx) async {
    _transactions.insert(0, tx);
    _recomputeMonthlyAggregates();
    await _repository.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction tx) async {
    final index = _transactions.indexWhere((t) => t.id == tx.id);
    if (index != -1) {
      _transactions[index] = tx;
      _recomputeMonthlyAggregates();
      await _repository.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    _recomputeMonthlyAggregates();
    await _repository.saveTransactions(_transactions);
    notifyListeners();
  }

  // --- Debts & Realized Cash Flow ---

  Future<void> addDebt(Debt debt) async {
    _debts.add(debt);
    await _repository.saveDebts(_debts);
    notifyListeners();
  }

  Future<void> updateDebt(Debt debt) async {
    final index = _debts.indexWhere((d) => d.id == debt.id);
    if (index != -1) {
      _debts[index] = debt;
      await _repository.saveDebts(_debts);
      notifyListeners();
    }
  }

  Future<void> deleteDebt(String id) async {
    _debts.removeWhere((d) => d.id == id);
    await _repository.saveDebts(_debts);
    notifyListeners();
  }

  /// Records partial or full repayment for a debt
  /// Prevents double counting by creating corresponding transaction
  Future<void> recordDebtRepayment({
    required Debt debt,
    required int paymentAmountMinor,
    String? note,
  }) async {
    final newRemaining = (debt.remainingMinor - paymentAmountMinor).clamp(0, debt.principalMinor);
    final isSettled = newRemaining == 0;

    final updatedDebt = debt.copyWith(
      remainingMinor: newRemaining,
      status: isSettled ? DebtStatus.settled : DebtStatus.partial,
      note: note ?? debt.note,
    );

    await updateDebt(updatedDebt);

    // Create corresponding cash flow transaction
    final now = DateTime.now();
    if (debt.isLent) {
      // Verilen borcun geri tahsilatı = Gelir
      final tx = Transaction(
        id: 'tx-debt-repay-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.income,
        amountMinor: paymentAmountMinor,
        categoryId: 'cat-debt-repay',
        occurredAt: now,
        description: '${debt.counterparty} borç tahsilatı',
        incomeSource: IncomeSource.debt_repayment,
      );
      await addTransaction(tx);
    } else {
      // Alınan borcun geri ödenmesi = Gider
      final tx = Transaction(
        id: 'tx-debt-pay-${DateTime.now().millisecondsSinceEpoch}',
        type: TransactionType.expense,
        amountMinor: paymentAmountMinor,
        categoryId: 'cat-bills',
        occurredAt: now,
        description: '${debt.counterparty} borç ödemesi',
        receiptNote: 'Borç kapama dekontu',
      );
      await addTransaction(tx);
    }
  }

  // --- Recurring Payments (Bills) ---

  Future<void> addRecurringPayment(RecurringPayment item) async {
    _recurringPayments.add(item);
    await _repository.saveRecurringPayments(_recurringPayments);
    notifyListeners();
  }

  Future<void> updateRecurringPayment(RecurringPayment item) async {
    final index = _recurringPayments.indexWhere((r) => r.id == item.id);
    if (index != -1) {
      _recurringPayments[index] = item;
      await _repository.saveRecurringPayments(_recurringPayments);
      notifyListeners();
    }
  }

  Future<void> deleteRecurringPayment(String id) async {
    _recurringPayments.removeWhere((r) => r.id == id);
    await _repository.saveRecurringPayments(_recurringPayments);
    notifyListeners();
  }

  /// Fatura ödendi olarak işaretlenir ve tek seferlik gerçekleşmiş gider kaydı oluşturulur
  /// Çift sayım önlenir
  Future<void> markRecurringAsPaid({
    required RecurringPayment item,
    int? actualAmountMinor,
  }) async {
    final amount = actualAmountMinor ?? item.expectedAmountMinor ?? 0;
    if (amount <= 0) return;

    // 1. Gider kaydı oluştur
    final tx = Transaction(
      id: 'tx-bill-${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.expense,
      amountMinor: amount,
      categoryId: item.categoryId ?? 'cat-bills',
      occurredAt: DateTime.now(),
      description: '${item.title} fatura ödemesi',
      receiptNote: 'Düzenli fatura ödemesi',
    );
    await addTransaction(tx);

    // 2. Faturayı bu dönem ödendi olarak işaretle ve sonraki vadeye taşı
    DateTime nextDue = item.dueDate;
    if (item.cadence == RecurringCadence.monthly) {
      nextDue = DateTime(item.dueDate.year, item.dueDate.month + 1, item.dueDate.day);
    } else if (item.cadence == RecurringCadence.weekly) {
      nextDue = item.dueDate.add(const Duration(days: 7));
    } else {
      nextDue = item.dueDate.add(const Duration(days: 1));
    }

    final updatedItem = item.copyWith(
      isPaidThisPeriod: true,
      dueDate: nextDue,
    );
    await updateRecurringPayment(updatedItem);
  }

  // --- Budgets & Settings ---

  Future<void> updateSettings(UserSettings settings) async {
    _settings = settings;
    await _repository.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> saveBudget(Budget budget) async {
    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index != -1) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    await _repository.saveBudgets(_budgets);
    notifyListeners();
  }

  // 50/30/20 rule calculation
  Map<Rule503020Type, int> calculate503020Spending() {
    int needs = 0;
    int wants = 0;
    int savings = 0;

    for (final tx in selectedMonthTransactions.where((t) => t.isExpense)) {
      final category = categoryMap[tx.categoryId];
      if (category?.rule503020Type == Rule503020Type.needs) {
        needs += tx.amountMinor;
      } else if (category?.rule503020Type == Rule503020Type.wants) {
        wants += tx.amountMinor;
      } else if (category?.rule503020Type == Rule503020Type.savings) {
        savings += tx.amountMinor;
      } else {
        // Default to needs if unspecified
        needs += tx.amountMinor;
      }
    }

    return {
      Rule503020Type.needs: needs,
      Rule503020Type.wants: wants,
      Rule503020Type.savings: savings,
    };
  }

  // Spending per category in selected month
  Map<String, int> calculateCategorySpending() {
    final Map<String, int> map = {};
    for (final tx in selectedMonthTransactions.where((t) => t.isExpense)) {
      map[tx.categoryId] = (map[tx.categoryId] ?? 0) + tx.amountMinor;
    }
    return map;
  }
}
