import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/budget.dart';
import '../models/recurring_payment.dart';
import '../models/debt.dart';
import '../models/user_settings.dart';
import '../mock/sample_data.dart';

/// Uygulama verilerini yerel depolama biriminde (SharedPreferences) saklayan ve yükleyen depo sınıfı.
/// İlk kurulumda örnek verileri (SampleData) hazırlar ve sonraki açılışlarda JSON formatında depolar.
class FinanceRepository {
  // SharedPreferences anahtarları (Storage Keys)
  static const String _kTransactionsKey = 'app_transactions';
  static const String _kCategoriesKey = 'app_categories';
  static const String _kBudgetsKey = 'app_budgets';
  static const String _kRecurringKey = 'app_recurring';
  static const String _kDebtsKey = 'app_debts';
  static const String _kSettingsKey = 'app_settings';

  /// Gelir ve gider işlemlerini yerel depolamadan yükler.
  /// İlk açılışta veri yoksa varsayılan örnek verileri oluşturur ve kaydeder.
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

  /// Güncel işlem listesini JSON dizisi olarak SharedPreferences'a kaydeder.
  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(transactions.map((e) => e.toJson()).toList());
    await prefs.setString(_kTransactionsKey, jsonString);
  }

  /// Kategori listesini yerel depolamadan yükler.
  /// Kayıtlı kategori bulunamazsa varsayılan kategorileri yükler ve kaydeder.
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

  /// Kategori listesini JSON formatında kaydeder.
  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(categories.map((e) => e.toJson()).toList());
    await prefs.setString(_kCategoriesKey, jsonString);
  }

  /// Bütçe tanımlarını (kategori/zarf ve 50/30/20 limitleri) yükler.
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

  /// Bütçe tanımlarını kaydeder.
  Future<void> saveBudgets(List<Budget> budgets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(budgets.map((e) => e.toJson()).toList());
    await prefs.setString(_kBudgetsKey, jsonString);
  }

  /// Düzenli fatura ve abonelik ödemelerini yükler.
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

  /// Düzenli fatura ve abonelik ödemelerini kaydeder.
  Future<void> saveRecurringPayments(List<RecurringPayment> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kRecurringKey, jsonString);
  }

  /// Alınan ve verilen borç kayıtlarını yerel depolamadan yükler.
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

  /// Borç kayıtlarını kaydeder.
  Future<void> saveDebts(List<Debt> debts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(debts.map((e) => e.toJson()).toList());
    await prefs.setString(_kDebtsKey, jsonString);
  }

  /// Kullanıcı tercihlerini ve genel limit ayarlarını yükler.
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

  /// Kullanıcı tercihlerini ve limit ayarlarını kaydeder.
  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }
}
