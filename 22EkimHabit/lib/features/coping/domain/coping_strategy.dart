class CopingStrategy {
  final String id;
  final String habitId;
  final String title;
  final String actionText;
  final int estimatedMinutes;
  final List<String> triggerTags;
  final double effectivenessScore; // 1.0 - 5.0
  final bool isFavorite;
  final int timesUsed;

  const CopingStrategy({
    required this.id,
    required this.habitId,
    required this.title,
    required this.actionText,
    this.estimatedMinutes = 2,
    this.triggerTags = const [],
    this.effectivenessScore = 4.0,
    this.isFavorite = false,
    this.timesUsed = 0,
  });

  CopingStrategy copyWith({
    String? id,
    String? habitId,
    String? title,
    String? actionText,
    int? estimatedMinutes,
    List<String>? triggerTags,
    double? effectivenessScore,
    bool? isFavorite,
    int? timesUsed,
  }) {
    return CopingStrategy(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      title: title ?? this.title,
      actionText: actionText ?? this.actionText,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      triggerTags: triggerTags ?? this.triggerTags,
      effectivenessScore: effectivenessScore ?? this.effectivenessScore,
      isFavorite: isFavorite ?? this.isFavorite,
      timesUsed: timesUsed ?? this.timesUsed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'title': title,
    'actionText': actionText,
    'estimatedMinutes': estimatedMinutes,
    'triggerTags': triggerTags,
    'effectivenessScore': effectivenessScore,
    'isFavorite': isFavorite,
    'timesUsed': timesUsed,
  };

  factory CopingStrategy.fromJson(Map<String, dynamic> json) {
    return CopingStrategy(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      title: json['title'] as String,
      actionText: json['actionText'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 2,
      triggerTags:
          (json['triggerTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      effectivenessScore:
          (json['effectivenessScore'] as num?)?.toDouble() ?? 4.0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      timesUsed: json['timesUsed'] as int? ?? 0,
    );
  }
}
