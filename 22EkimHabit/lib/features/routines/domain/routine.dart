class RoutineStep {
  final String id;
  final String routineId;
  final String habitId;
  final int sortOrder;
  final int? durationSeconds;
  final bool optional;

  const RoutineStep({
    required this.id,
    required this.routineId,
    required this.habitId,
    required this.sortOrder,
    this.durationSeconds,
    this.optional = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'routineId': routineId,
    'habitId': habitId,
    'sortOrder': sortOrder,
    'durationSeconds': durationSeconds,
    'optional': optional,
  };

  factory RoutineStep.fromJson(Map<String, dynamic> json) {
    return RoutineStep(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      habitId: json['habitId'] as String,
      sortOrder: json['sortOrder'] as int? ?? 0,
      durationSeconds: json['durationSeconds'] as int?,
      optional: json['optional'] as bool? ?? false,
    );
  }
}

class Routine {
  final String id;
  final String name;
  final List<RoutineStep> steps;
  final DateTime createdAtUtc;
  final DateTime? archivedAtUtc;

  const Routine({
    required this.id,
    required this.name,
    this.steps = const [],
    required this.createdAtUtc,
    this.archivedAtUtc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'steps': steps.map((s) => s.toJson()).toList(),
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'archivedAtUtc': archivedAtUtc?.toIso8601String(),
  };

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((s) => RoutineStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      archivedAtUtc: json['archivedAtUtc'] != null
          ? DateTime.parse(json['archivedAtUtc'] as String)
          : null,
    );
  }
}
