enum BudgetPeriod { day, week, month }

enum BudgetMethod {
  envelope,    // Zarf/Kategori bütçesi
  rule503020,  // 50/30/20 kuralı
  custom,      // Özel limitler
}

class Budget {
  final String id;
  final BudgetPeriod period;
  final int amountMinor;
  final String? categoryId; // null = overall limit, non-null = category envelope
  final BudgetMethod method;
  final DateTime startsOn;
  final double alertThreshold; // default 0.80 (80%)

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
