class SuggestedAction {
  final String id;
  final String type; // 'start_support_timer', 'create_challenge_note', 'complete_positive_habit', 'open_plan'
  final String label;
  final Map<String, dynamic> payload;
  final bool requiresConfirmation;
  final bool isExecuted;

  const SuggestedAction({
    required this.id,
    required this.type,
    required this.label,
    this.payload = const {},
    this.requiresConfirmation = true,
    this.isExecuted = false,
  });

  SuggestedAction copyWith({
    String? id,
    String? type,
    String? label,
    Map<String, dynamic>? payload,
    bool? requiresConfirmation,
    bool? isExecuted,
  }) {
    return SuggestedAction(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      payload: payload ?? this.payload,
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
      isExecuted: isExecuted ?? this.isExecuted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'label': label,
        'payload': payload,
        'requiresConfirmation': requiresConfirmation,
        'isExecuted': isExecuted,
      };

  factory SuggestedAction.fromJson(Map<String, dynamic> json) {
    return SuggestedAction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'action',
      label: json['label'] as String? ?? '',
      payload: (json['payload'] as Map<String, dynamic>?) ?? {},
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? true,
      isExecuted: json['isExecuted'] as bool? ?? false,
    );
  }
}
