class ExerciseModel {
  final String id;
  final String title;
  final int durationMinutes;
  final int burnedCalories;
  final String category;

  const ExerciseModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.burnedCalories,
    required this.category,
  });

  ExerciseModel copyWith({
    String? id,
    String? title,
    int? durationMinutes,
    int? burnedCalories,
    String? category,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      burnedCalories: burnedCalories ?? this.burnedCalories,
      category: category ?? this.category,
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      burnedCalories: json['burnedCalories'] as int? ?? 0,
      category: json['category'] as String? ?? 'Kardiyo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationMinutes': durationMinutes,
      'burnedCalories': burnedCalories,
      'category': category,
    };
  }
}
