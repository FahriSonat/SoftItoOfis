class GoalLevels {
  final String habitId;
  final double minimumValue;
  final double normalValue;
  final double? strongDayValue;

  const GoalLevels({
    required this.habitId,
    required this.minimumValue,
    required this.normalValue,
    this.strongDayValue,
  });

  bool get isValid =>
      minimumValue > 0 &&
      normalValue >= minimumValue &&
      (strongDayValue == null || strongDayValue! >= normalValue);

  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'minimumValue': minimumValue,
    'normalValue': normalValue,
    'strongDayValue': strongDayValue,
  };

  factory GoalLevels.fromJson(Map<String, dynamic> json) {
    return GoalLevels(
      habitId: json['habitId'] as String,
      minimumValue: (json['minimumValue'] as num).toDouble(),
      normalValue: (json['normalValue'] as num).toDouble(),
      strongDayValue: (json['strongDayValue'] as num?)?.toDouble(),
    );
  }
}
