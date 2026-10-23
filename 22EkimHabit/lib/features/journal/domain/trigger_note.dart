class TriggerNote {
  final String id;
  final String habitId;
  final DateTime occurredAt;
  final List<String> triggerTags;
  final List<String> emotionTags;
  final int intensityBefore; // 1 - 5
  final int? intensityAfter; // 1 - 5 (çözüm sonrası)
  final String? context; // ortam / bağlam
  final String? note;
  final String? strategyId;

  const TriggerNote({
    required this.id,
    required this.habitId,
    required this.occurredAt,
    this.triggerTags = const [],
    this.emotionTags = const [],
    required this.intensityBefore,
    this.intensityAfter,
    this.context,
    this.note,
    this.strategyId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'occurredAt': occurredAt.toIso8601String(),
    'triggerTags': triggerTags,
    'emotionTags': emotionTags,
    'intensityBefore': intensityBefore,
    'intensityAfter': intensityAfter,
    'context': context,
    'note': note,
    'strategyId': strategyId,
  };

  factory TriggerNote.fromJson(Map<String, dynamic> json) {
    return TriggerNote(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      triggerTags:
          (json['triggerTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      emotionTags:
          (json['emotionTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      intensityBefore: json['intensityBefore'] as int? ?? 3,
      intensityAfter: json['intensityAfter'] as int?,
      context: json['context'] as String?,
      note: json['note'] as String?,
      strategyId: json['strategyId'] as String?,
    );
  }
}
