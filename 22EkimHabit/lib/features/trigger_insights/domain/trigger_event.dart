enum TriggerOutcome {
  reduced('İstek Azaldı'),
  unchanged('Değişmedi'),
  increased('İstek Arttı'),
  lapse('Kayma Yaşandı'),
  unknown('Bilinmiyor');

  final String label;
  const TriggerOutcome(this.label);
}

class TriggerEvent {
  final String id;
  final String habitId;
  final DateTime occurredAtUtc;
  final String localDate; // YYYY-MM-DD
  final String timeZoneId;
  final int intensityBefore; // 1..5
  final int? intensityAfter; // 1..5
  final List<String> triggerTags;
  final String? customTrigger;
  final String? note;
  final String? selectedSolutionId;
  final TriggerOutcome outcome;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  const TriggerEvent({
    required this.id,
    required this.habitId,
    required this.occurredAtUtc,
    required this.localDate,
    this.timeZoneId = 'Europe/Istanbul',
    required this.intensityBefore,
    this.intensityAfter,
    this.triggerTags = const [],
    this.customTrigger,
    this.note,
    this.selectedSolutionId,
    this.outcome = TriggerOutcome.reduced,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'occurredAtUtc': occurredAtUtc.toIso8601String(),
    'localDate': localDate,
    'timeZoneId': timeZoneId,
    'intensityBefore': intensityBefore,
    'intensityAfter': intensityAfter,
    'triggerTags': triggerTags,
    'customTrigger': customTrigger,
    'note': note,
    'selectedSolutionId': selectedSolutionId,
    'outcome': outcome.name,
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
  };

  factory TriggerEvent.fromJson(Map<String, dynamic> json) {
    return TriggerEvent(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
      localDate: json['localDate'] as String,
      timeZoneId: json['timeZoneId'] as String? ?? 'Europe/Istanbul',
      intensityBefore: json['intensityBefore'] as int? ?? 3,
      intensityAfter: json['intensityAfter'] as int?,
      triggerTags:
          (json['triggerTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      customTrigger: json['customTrigger'] as String?,
      note: json['note'] as String?,
      selectedSolutionId: json['selectedSolutionId'] as String?,
      outcome: json['outcome'] != null
          ? TriggerOutcome.values.byName(json['outcome'] as String)
          : TriggerOutcome.reduced,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );
  }
}
