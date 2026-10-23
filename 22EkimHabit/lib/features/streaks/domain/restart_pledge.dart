class RestartPledge {
  final String id;
  final String habitId;
  final int previousStreakDays;
  final String pledgeText;
  final String? reflection;
  final String? strategyId;
  final DateTime committedAt;

  const RestartPledge({
    required this.id,
    required this.habitId,
    required this.previousStreakDays,
    required this.pledgeText,
    this.reflection,
    this.strategyId,
    required this.committedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'previousStreakDays': previousStreakDays,
    'pledgeText': pledgeText,
    'reflection': reflection,
    'strategyId': strategyId,
    'committedAt': committedAt.toIso8601String(),
  };

  factory RestartPledge.fromJson(Map<String, dynamic> json) {
    return RestartPledge(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      previousStreakDays: json['previousStreakDays'] as int? ?? 0,
      pledgeText: json['pledgeText'] as String,
      reflection: json['reflection'] as String?,
      strategyId: json['strategyId'] as String?,
      committedAt: DateTime.parse(json['committedAt'] as String),
    );
  }
}
