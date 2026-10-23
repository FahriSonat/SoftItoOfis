class MoodCheckIn {
  final String id;
  final DateTime occurredAtUtc;
  final String localDate; // YYYY-MM-DD
  final String timeZoneId;
  final int mood; // 1..5
  final int energy; // 1..5
  final int stress; // 1..5
  final int? sleepMinutes;
  final int? sleepQuality; // 1..5
  final String? note;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  const MoodCheckIn({
    required this.id,
    required this.occurredAtUtc,
    required this.localDate,
    this.timeZoneId = 'Europe/Istanbul',
    required this.mood,
    required this.energy,
    required this.stress,
    this.sleepMinutes,
    this.sleepQuality,
    this.note,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'occurredAtUtc': occurredAtUtc.toIso8601String(),
    'localDate': localDate,
    'timeZoneId': timeZoneId,
    'mood': mood,
    'energy': energy,
    'stress': stress,
    'sleepMinutes': sleepMinutes,
    'sleepQuality': sleepQuality,
    'note': note,
    'createdAtUtc': createdAtUtc.toIso8601String(),
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
  };

  factory MoodCheckIn.fromJson(Map<String, dynamic> json) {
    return MoodCheckIn(
      id: json['id'] as String,
      occurredAtUtc: DateTime.parse(json['occurredAtUtc'] as String),
      localDate: json['localDate'] as String,
      timeZoneId: json['timeZoneId'] as String? ?? 'Europe/Istanbul',
      mood: json['mood'] as int? ?? 3,
      energy: json['energy'] as int? ?? 3,
      stress: json['stress'] as int? ?? 3,
      sleepMinutes: json['sleepMinutes'] as int?,
      sleepQuality: json['sleepQuality'] as int?,
      note: json['note'] as String?,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );
  }
}
