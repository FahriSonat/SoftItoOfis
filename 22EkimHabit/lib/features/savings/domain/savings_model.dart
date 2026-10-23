enum ConsumptionPeriod { day, week, month }

class BaselineConsumption {
  final String id;
  final String habitId;
  final ConsumptionPeriod period;
  final int? quantityMinorUnits; // örn: 20 dal sigara
  final int? costMinorUnits; // örn: 7500 kuruş = 75.00 TL
  final int? minutesSpent; // harcanan süre (dakika)
  final String currencyCode; // TRY

  const BaselineConsumption({
    required this.id,
    required this.habitId,
    this.period = ConsumptionPeriod.day,
    this.quantityMinorUnits,
    this.costMinorUnits,
    this.minutesSpent,
    this.currencyCode = 'TRY',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'period': period.name,
    'quantityMinorUnits': quantityMinorUnits,
    'costMinorUnits': costMinorUnits,
    'minutesSpent': minutesSpent,
    'currencyCode': currencyCode,
  };

  factory BaselineConsumption.fromJson(Map<String, dynamic> json) {
    return BaselineConsumption(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      period: json['period'] != null
          ? ConsumptionPeriod.values.byName(json['period'] as String)
          : ConsumptionPeriod.day,
      quantityMinorUnits: json['quantityMinorUnits'] as int?,
      costMinorUnits: json['costMinorUnits'] as int?,
      minutesSpent: json['minutesSpent'] as int?,
      currencyCode: json['currencyCode'] as String? ?? 'TRY',
    );
  }
}

class SavingsGoal {
  final String id;
  final String title;
  final int targetAmountMinorUnits; // Kuruş cinsinden (örn: 50000 = 500 TL)
  final String currencyCode;
  final List<String> linkedHabitIds;
  final DateTime createdAtUtc;
  final DateTime? archivedAtUtc;

  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmountMinorUnits,
    this.currencyCode = 'TRY',
    this.linkedHabitIds = const [],
    required this.createdAtUtc,
    this.archivedAtUtc,
  });

  double get targetAmountMajor => targetAmountMinorUnits / 100.0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'targetAmountMinorUnits': targetAmountMinorUnits,
    'currencyCode': currencyCode,
    'linkedHabitIds': linkedHabitIds,
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'archivedAtUtc': archivedAtUtc?.toIso8601String(),
  };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmountMinorUnits: json['targetAmountMinorUnits'] as int? ?? 10000,
      currencyCode: json['currencyCode'] as String? ?? 'TRY',
      linkedHabitIds:
          (json['linkedHabitIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] != null
          ? DateTime.parse(json['archivedAtUtc'] as String)
          : null,
    );
  }
}
