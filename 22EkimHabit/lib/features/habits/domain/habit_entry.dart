enum EntryType {
  completion, // Pozitif hedef tamamlama/ilerleme
  relapse, // Negatif seriyi bozma / kırılma
  skip, // İsteğe bağlı pas geçme
}

class HabitEntry {
  final String id;
  final String habitId;
  final String userId;
  final EntryType entryType;
  final double value;
  final String unit;
  final DateTime occurredAt;
  final String? note;
  final String? triggerTag;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HabitEntry({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.entryType,
    required this.value,
    this.unit = '',
    required this.occurredAt,
    this.note,
    this.triggerTag,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'userId': userId,
    'entryType': entryType.name,
    'value': value,
    'unit': unit,
    'occurredAt': occurredAt.toIso8601String(),
    'note': note,
    'triggerTag': triggerTag,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory HabitEntry.fromJson(Map<String, dynamic> json) {
    return HabitEntry(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      userId: json['userId'] as String? ?? 'default_user',
      entryType: EntryType.values.byName(json['entryType'] as String),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String? ?? '',
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      note: json['note'] as String?,
      triggerTag: json['triggerTag'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
