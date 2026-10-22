import 'budget.dart';

/// Kullanıcı tercihleri, bütçe limitleri ve bildirim ayarlarını temsil eden model sınıfı.
class UserSettings {
  final int salaryDay; // Ayın maaş günü (1 - 31, varsayılan: 15)
  final int dailyLimitMinor; // Günlük bütçe harcama limiti (kuruş)
  final int weeklyLimitMinor; // Haftalık bütçe harcama limiti (kuruş)
  final int monthlyLimitMinor; // Aylık genel bütçe harcama limiti (kuruş)
  final double alertThreshold; // Bütçe aşım öncesi uyarı yüzdesi (0.80 = %80)
  final BudgetMethod budgetMethod; // Tercih edilen bütçeleme yöntemi (50/30/20 veya Zarf)
  final bool censorHiddenInExport; // Excel çıktısında gizli tutarlar sansürlensin mi
  final String currency; // Varsayılan para birimi simgesi/kodu
  final bool notifyOnSalary; // Maaş günü ve sonraki 3 gün hatırlatması açık mı
  final bool notifyUpcomingBills; // Yaklaşan fatura bildirimleri açık mı
  final bool notifyDueDebts; // Yaklaşan borç vadesi bildirimleri açık mı

  UserSettings({
    this.salaryDay = 15,
    this.dailyLimitMinor = 150000,    // 1.500,00 ₺
    this.weeklyLimitMinor = 800000,   // 8.000,00 ₺
    this.monthlyLimitMinor = 3500000, // 35.000,00 ₺
    this.alertThreshold = 0.80,       // %80 harcama uyarısı
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
