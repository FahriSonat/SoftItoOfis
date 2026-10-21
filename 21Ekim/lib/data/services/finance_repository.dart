import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/budget.dart';
import '../models/recurring_payment.dart';
import '../models/debt.dart';
import '../models/user_settings.dart';
import '../mock/sample_data.dart';

class FinanceRepository {
  static const String _kTransactionsKey = 'app_transactions';
  static const String _kCategoriesKey = 'app_categories';
  static const String _kBudgetsKey = 'app_budgets';
  static const String _kRecurringKey = 'app_recurring';
  static const String _kDebtsKey = 'app_debts';
  static const String _kSettingsKey = 'app_settings';

  Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kTransactionsKey);
    if (jsonString == null) {
      final initial = SampleData.generateInitialTransactions();
      await saveTransactions(initial);
      return initial;
    }
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => Transaction.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(transactions.map((e) => e.toJson()).toList());
    await prefs.setString(_kTransactionsKey, jsonString);
  }

  Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kCategoriesKey);
    if (jsonString == null) {
      final initial = SampleData.defaultCategories;
      await saveCategories(initial);
      return initial;
    }
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString(_kCategoriesKey, jsonString);
  }

  Future<List<Budget>> loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kBudgetsKey);
    if (jsonString == null) {
      final initial = SampleData.generateInitialBudgets();
      await saveBudgets(initial);
      return initial;
    }
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => Budget.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveBudgets(List<Budget> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(budgets.map((e) => e.toJson()).toList());
    await prefs.setString(_kBudgetsKey, jsonString);
  }

  Future<List<RecurringPayment>> loadRecurringPayments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kRecurringKey);
    if (jsonString == null) {
      final initial = SampleData.generateInitialRecurringPayments();
      await saveRecurringPayments(initial);
      return initial;
    }
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => RecurringPayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveRecurringPayments(List<RecurringPayment> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kRecurringKey, jsonString);
  }

  Future<List<Debt>> loadDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kDebtsKey);
    if (jsonString == null) {
      final initial = SampleData.generateInitialDebts();
      await saveDebts(initial);
      return initial;
    }
    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => Debt.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveDebts(List<Debt> debts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(debts.map((e) => e.toJson()).toList());
    await prefs.setString(_kDebtsKey, jsonString);
  }

  Future<UserSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_kSettingsKey);
    if (jsonString == null) {
      final initial = UserSettings();
      await saveSettings(initial);
      return initial;
    }
    return UserSettings.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }
}
