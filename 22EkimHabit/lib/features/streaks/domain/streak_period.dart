enum StreakPeriodStatus { active, broken, completed }

class StreakPeriod {
  final String id;
  final String habitId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final StreakPeriodStatus status;
  final int successfulPeriods;
  final String? endReason;
  final String? restartPledgeId;

  const StreakPeriod({
    required this.id,
    required this.habitId,
    required this.startedAt,
    this.endedAt,
    this.status = StreakPeriodStatus.active,
    this.successfulPeriods = 0,
    this.endReason,
    this.restartPledgeId,
  });

  bool get isCurrentActive =>
      status == StreakPeriodStatus.active && endedAt == null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt?.toIso8601String(),
    'status': status.name,
    'successfulPeriods': successfulPeriods,
    'endReason': endReason,
    'restartPledgeId': restartPledgeId,
  };

  factory StreakPeriod.fromJson(Map<String, dynamic> json) {
    return StreakPeriod(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      status: StreakPeriodStatus.values.byName(json['status'] as String),
      successfulPeriods: json['successfulPeriods'] as int? ?? 0,
      endReason: json['endReason'] as String?,
      restartPledgeId: json['restartPledgeId'] as String?,
    );
  }
}
