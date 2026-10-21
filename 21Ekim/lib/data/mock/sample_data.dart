import '../models/category.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/recurring_payment.dart';
import '../models/debt.dart';

class SampleData {
  SampleData._();

  static final List<Category> defaultCategories = [
    // Expenses - Needs (%50)
    Category(
      id: 'cat-rent',
      name: 'Kira & Konut',
      type: CategoryType.expense,
      colorHex: '#3B82F6',
      iconName: 'home',
      isSystem: true,
      rule503020Type: Rule503020Type.needs,
    ),
    Category(
      id: 'cat-groceries',
      name: 'Mutfak & Market',
      type: CategoryType.expense,
      colorHex: '#10B981',
      iconName: 'shopping_cart',
      isSystem: true,
      rule503020Type: Rule503020Type.needs,
    ),
    Category(
      id: 'cat-bills',
      name: 'Faturalar & Abonelikler',
      type: CategoryType.expense,
      colorHex: '#F59E0B',
      iconName: 'receipt_long',
      isSystem: true,
      rule503020Type: Rule503020Type.needs,
    ),
    Category(
      id: 'cat-transport',
      name: 'Ulaşım & Yakıt',
      type: CategoryType.expense,
      colorHex: '#6366F1',
      iconName: 'directions_car',
      isSystem: true,
      rule503020Type: Rule503020Type.needs,
    ),
    Category(
      id: 'cat-health',
      name: 'Sağlık & İlaç',
      type: CategoryType.expense,
      colorHex: '#EC4899',
      iconName: 'medical_services',
      isSystem: true,
      rule503020Type: Rule503020Type.needs,
    ),

    // Expenses - Wants (%30)
    Category(
      id: 'cat-dining',
      name: 'Kafe & Restoran',
      type: CategoryType.expense,
      colorHex: '#F97316',
      iconName: 'restaurant',
      isSystem: true,
      rule503020Type: Rule503020Type.wants,
    ),
    Category(
      id: 'cat-entertainment',
      name: 'Eğlence & Hobi',
      type: CategoryType.expense,
      colorHex: '#8B5CF6',
      iconName: 'sports_esports',
      isSystem: true,
      rule503020Type: Rule503020Type.wants,
    ),
    Category(
      id: 'cat-charity',
      name: 'Hayır İşi & Bağış',
      type: CategoryType.expense,
      colorHex: '#14B8A6',
      iconName: 'volunteer_activism',
      isSystem: true,
      rule503020Type: Rule503020Type.wants,
    ),

    // Expenses - Savings (%20)
    Category(
      id: 'cat-savings',
      name: 'Tasarruf & Yatırım',
      type: CategoryType.expense,
      colorHex: '#06B6D4',
      iconName: 'savings',
      isSystem: true,
      rule503020Type: Rule503020Type.savings,
    ),

    // Incomes
    Category(
      id: 'cat-salary',
      name: 'Maaş Geliri',
      type: CategoryType.income,
      colorHex: '#22C55E',
      iconName: 'payments',
      isSystem: true,
    ),
    Category(
      id: 'cat-debt-repay',
      name: 'Borç Geri Ödemesi',
      type: CategoryType.income,
      colorHex: '#4EA1FF',
      iconName: 'assignment_return',
      isSystem: true,
    ),
    Category(
      id: 'cat-extra-income',
      name: 'Ek Gelir & Serbest İş',
      type: CategoryType.income,
      colorHex: '#10B981',
      iconName: 'work',
      isSystem: true,
    ),
  ];

  static List<Transaction> generateInitialTransactions() {
    final now = DateTime.now();
    return [
      Transaction(
        id: 'tx-1',
        type: TransactionType.income,
        amountMinor: 6500000, // 65.000,00 ₺
        categoryId: 'cat-salary',
        occurredAt: DateTime(now.year, now.month, 15),
        description: 'Ekim Ayı Maaş Ödemesi',
        incomeSource: IncomeSource.salary,
      ),
      Transaction(
        id: 'tx-2',
        type: TransactionType.income,
        amountMinor: 500000, // 5.000,00 ₺
        categoryId: 'cat-debt-repay',
        occurredAt: DateTime(now.year, now.month, 18),
        description: 'Ahmet borç iadesi',
        incomeSource: IncomeSource.debt_repayment,
      ),
      Transaction(
        id: 'tx-3',
        type: TransactionType.expense,
        amountMinor: 1800000, // 18.000,00 ₺
        categoryId: 'cat-rent',
        occurredAt: DateTime(now.year, now.month, 1),
        description: 'Ekim Ayı Ev Kirası',
        receiptNote: 'Ev sahibi banka dekontu #98214',
      ),
      Transaction(
        id: 'tx-4',
        type: TransactionType.expense,
        amountMinor: 245050, // 2.450,50 ₺
        categoryId: 'cat-groceries',
        occurredAt: DateTime(now.year, now.month, 16),
        description: 'Haftalık süpermarket alışverişi',
        receiptNote: 'Migros fiş No: 0492',
      ),
      Transaction(
        id: 'tx-5',
        type: TransactionType.expense,
        amountMinor: 85000, // 850,00 ₺
        categoryId: 'cat-bills',
        occurredAt: DateTime(now.year, now.month, 17),
        description: 'Fiber İnternet ve TV Faturası',
        receiptNote: 'Fatura ref: TR99182',
      ),
      Transaction(
        id: 'tx-6',
        type: TransactionType.expense,
        amountMinor: 150000, // 1.500,00 ₺
        categoryId: 'cat-charity',
        occurredAt: DateTime(now.year, now.month, 19),
        description: 'Öğrenci burs desteği bağışı',
        isCharity: true, // Hayır işi
      ),
      Transaction(
        id: 'tx-7',
        type: TransactionType.expense,
        amountMinor: 120000, // 1.200,00 ₺
        categoryId: 'cat-dining',
        occurredAt: DateTime(now.year, now.month, 20),
        description: 'Özel akşam yemeği hediyesi',
        isAmountHidden: true, // Özel tutar gizli
      ),
    ];
  }

  static List<RecurringPayment> generateInitialRecurringPayments() {
    final now = DateTime.now();
    return [
      RecurringPayment(
        id: 'rec-1',
        title: 'Ev Kirası',
        expectedAmountMinor: 1800000, // 18.000,00 ₺
        cadence: RecurringCadence.monthly,
        dueDate: DateTime(now.year, now.month + 1, 1),
        categoryId: 'cat-rent',
        isPaidThisPeriod: true,
      ),
      RecurringPayment(
        id: 'rec-2',
        title: 'Elektrik Faturası',
        expectedAmountMinor: 68000, // 680,00 ₺
        cadence: RecurringCadence.monthly,
        dueDate: DateTime(now.year, now.month, 26),
        categoryId: 'cat-bills',
        isPaidThisPeriod: false,
      ),
      RecurringPayment(
        id: 'rec-3',
        title: 'Fiber İnternet',
        expectedAmountMinor: 85000, // 850,00 ₺
        cadence: RecurringCadence.monthly,
        dueDate: DateTime(now.year, now.month + 1, 15),
        categoryId: 'cat-bills',
        isPaidThisPeriod: true,
      ),
      RecurringPayment(
        id: 'rec-4',
        title: 'Spor Salonu Üyeliği',
        expectedAmountMinor: 120000, // 1.200,00 ₺
        cadence: RecurringCadence.monthly,
        dueDate: DateTime(now.year, now.month, 28),
        categoryId: 'cat-entertainment',
        isPaidThisPeriod: false,
      ),
    ];
  }

  static List<Debt> generateInitialDebts() {
    final now = DateTime.now();
    return [
      Debt(
        id: 'debt-1',
        direction: DebtDirection.borrowed, // Alınan borç (kullanıcı ödeyecek)
        counterparty: 'Akbank Taksitli Avans',
        principalMinor: 1500000, // 15.000,00 ₺
        remainingMinor: 500000,  // 5.000,00 ₺
        dueDate: DateTime(now.year, now.month, 25),
        status: DebtStatus.partial,
        note: 'Son taksit ödemesi maaş haftasında yapılacak',
      ),
      Debt(
        id: 'debt-2',
        direction: DebtDirection.lent, // Verilen borç (kullanıcıya ödenecek)
        counterparty: 'Ahmet Yılmaz',
        principalMinor: 1000000, // 10.000,00 ₺
        remainingMinor: 500000,  // 5.000,00 ₺
        dueDate: DateTime(now.year, now.month, 30),
        status: DebtStatus.partial,
        note: 'Geri kalan 5.000 TL ay sonu ödenecek',
      ),
    ];
  }

  static List<Budget> generateInitialBudgets() {
    final now = DateTime.now();
    return [
      Budget(
        id: 'b-needs',
        period: BudgetPeriod.month,
        amountMinor: 3500000, // 35.000,00 ₺
        categoryId: null,
        method: BudgetMethod.rule503020,
        startsOn: DateTime(now.year, now.month, 1),
        alertThreshold: 0.80,
      ),
      Budget(
        id: 'b-groceries',
        period: BudgetPeriod.month,
        amountMinor: 1000000, // 10.000,00 ₺
        categoryId: 'cat-groceries',
        method: BudgetMethod.envelope,
        startsOn: DateTime(now.year, now.month, 1),
        alertThreshold: 0.80,
      ),
      Budget(
        id: 'b-dining',
        period: BudgetPeriod.month,
        amountMinor: 400000, // 4.000,00 ₺
        categoryId: 'cat-dining',
        method: BudgetMethod.envelope,
        startsOn: DateTime(now.year, now.month, 1),
        alertThreshold: 0.80,
      ),
    ];
  }
}
