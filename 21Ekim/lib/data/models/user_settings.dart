import 'budget.dart';

class UserSettings {
  final int salaryDay; // 1 - 31 (e.g. 15)
  final int dailyLimitMinor;
  final int weeklyLimitMinor;
  final int monthlyLimitMinor;
  final double alertThreshold; // 0.80 = 80%
  final BudgetMethod budgetMethod;
  final bool censorHiddenInExport;
  final String currency;
  final bool notifyOnSalary;
  final bool notifyUpcomingBills;
  final bool notifyDueDebts;

  UserSettings({
    this.salaryDay = 15,
    this.dailyLimitMinor = 150000,    // 1.500,00 ₺
    this.weeklyLimitMinor = 800000,   // 8.000,00 ₺
    this.monthlyLimitMinor = 3500000, // 35.000,00 ₺
    this.alertThreshold = 0.80,
    this.budgetMethod = BudgetMethod.rule503020,
    this.censorHiddenInExport = true,
    this.currency = 'TRY',
    this.notifyOnSalary = true,
    this.notifyUpcomingBills = true,
    this.notifyDueDebts = true,
  });

  UserSettings copyWith({
    int? salaryDay,
    int? dailyLimitMinor,
    int? weeklyLimitMinor,
    int? monthlyLimitMinor,
    double? alertThreshold,
    BudgetMethod? budgetMethod,
    bool? censorHiddenInExport,
    String? currency,
    bool? notifyOnSalary,
    bool? notifyUpcomingBills,
    bool? notifyDueDebts,
  }) {
    return UserSettings(
      salaryDay: salaryDay ?? this.salaryDay,
      dailyLimitMinor: dailyLimitMinor ?? this.dailyLimitMinor,
      weeklyLimitMinor: weeklyLimitMinor ?? this.weeklyLimitMinor,
      monthlyLimitMinor: monthlyLimitMinor ?? this.monthlyLimitMinor,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      budgetMethod: budgetMethod ?? this.budgetMethod,
      censorHiddenInExport: censorHiddenInExport ?? this.censorHiddenInExport,
      currency: currency ?? this.currency,
      notifyOnSalary: notifyOnSalary ?? this.notifyOnSalary,
      notifyUpcomingBills: notifyUpcomingBills ?? this.notifyUpcomingBills,
      notifyDueDebts: notifyDueDebts ?? this.notifyDueDebts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salaryDay': salaryDay,
      'dailyLimitMinor': dailyLimitMinor,
      'weeklyLimitMinor': weeklyLimitMinor,
      'monthlyLimitMinor': monthlyLimitMinor,
      'alertThreshold': alertThreshold,
      'budgetMethod': budgetMethod.name,
      'censorHiddenInExport': censorHiddenInExport,
      'currency': currency,
      'notifyOnSalary': notifyOnSalary,
      'notifyUpcomingBills': notifyUpcomingBills,
      'notifyDueDebts': notifyDueDebts,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      salaryDay: json['salaryDay'] as int? ?? 15,
      dailyLimitMinor: json['dailyLimitMinor'] as int? ?? 150000,
      weeklyLimitMinor: json['weeklyLimitMinor'] as int? ?? 800000,
      monthlyLimitMinor: json['monthlyLimitMinor'] as int? ?? 3500000,
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 0.80,
      budgetMethod: json['budgetMethod'] != null
          ? BudgetMethod.values.byName(json['budgetMethod'] as String)
          : BudgetMethod.rule503020,
      censorHiddenInExport: json['censorHiddenInExport'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'TRY',
      notifyOnSalary: json['notifyOnSalary'] as bool? ?? true,
      notifyUpcomingBills: json['notifyUpcomingBills'] as bool? ?? true,
      notifyDueDebts: json['notifyDueDebts'] as bool? ?? true,
    );
  }
}
