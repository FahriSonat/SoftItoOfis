/// Bütçe periyodu (Günlük, Haftalık, Aylık)
enum BudgetPeriod { day, week, month }

/// Bütçeleme yöntemi
enum BudgetMethod {
  envelope,    // Zarf / Kategori bütçesi
  rule503020,  // 50/30/20 kuralı (İhtiyaç / İstek / Tasarruf)
  custom,      // Kullanıcının belirlediği özel limitler
}

/// Kategori veya genel harcamalar için tanımlanan bütçe modeli.
/// Tutar minor birim (kuruş) cinsinden tam sayı olarak saklanır.
class Budget {
  final String id;
  final BudgetPeriod period;
  final int amountMinor; // Kuruş cinsinden bütçe limiti (örn. 500000 = 5.000 TL)
  final String? categoryId; // null ise genel limit, dolu ise ilgili kategoriye özel zarf limiti
  final BudgetMethod method;
  final DateTime startsOn; // Bütçenin geçerlilik başlangıç tarihi
  final double alertThreshold; // Uyarı eşiği (varsayılan: 0.80 yani %80)

  Budget({
    required this.id,
    required this.period,
    required this.amountMinor,
    this.categoryId,
    this.method = BudgetMethod.envelope,
    required this.startsOn,
    this.alertThreshold = 0.80,
  });

  Budget copyWith({
    String? id,
    BudgetPeriod? period,
    int? amountMinor,
    String? categoryId,
    BudgetMethod? method,
    DateTime? startsOn,
    double? alertThreshold,
  }) {
    return Budget(
      id: id ?? this.id,
      period: period ?? this.period,
      amountMinor: amountMinor ?? this.amountMinor,
      categoryId: categoryId ?? this.categoryId,
      method: method ?? this.method,
      startsOn: startsOn ?? this.startsOn,
      alertThreshold: alertThreshold ?? this.alertThreshold,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period': period.name,
      'amountMinor': amountMinor,
      'categoryId': categoryId,
      'method': method.name,
      'startsOn': startsOn.toIso8601String(),
      'alertThreshold': alertThreshold,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      period: BudgetPeriod.values.byName(json['period'] as String),
      amountMinor: json['amountMinor'] as int,
      categoryId: json['categoryId'] as String?,
      method: BudgetMethod.values.byName(json['method'] as String),
      startsOn: DateTime.parse(json['startsOn'] as String),
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 0.80,
    );
  }
}
