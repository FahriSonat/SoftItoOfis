class WorkoutHistoryModel {
  final String id;
  final String workoutName;
  final DateTime date;
  final int durationMinutes;
  final int burnedCalories;
  final int totalWaterConsumedMl;

  const WorkoutHistoryModel({
    required this.id,
    required this.workoutName,
    required this.date,
    required this.durationMinutes,
    required this.burnedCalories,
    required this.totalWaterConsumedMl,
  });

  WorkoutHistoryModel copyWith({
    String? id,
    String? workoutName,
    DateTime? date,
    int? durationMinutes,
    int? burnedCalories,
    int? totalWaterConsumedMl,
  }) {
    return WorkoutHistoryModel(
      id: id ?? this.id,
      workoutName: workoutName ?? this.workoutName,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      burnedCalories: burnedCalories ?? this.burnedCalories,
      totalWaterConsumedMl: totalWaterConsumedMl ?? this.totalWaterConsumedMl,
    );
  }

  factory WorkoutHistoryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryModel(
      id: json['id'] as String? ?? '',
      workoutName: json['workoutName'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      burnedCalories: json['burnedCalories'] as int? ?? 0,
      totalWaterConsumedMl: json['totalWaterConsumedMl'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutName': workoutName,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'burnedCalories': burnedCalories,
      'totalWaterConsumedMl': totalWaterConsumedMl,
    };
  }
}
