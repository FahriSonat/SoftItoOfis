class PersonalMotivation {
  final String id;
  final String habitId;
  final String shortReason;
  final String? letterToSelf;
  final String? futureMessage;
  final String? localImagePath;
  final DateTime updatedAtUtc;

  const PersonalMotivation({
    required this.id,
    required this.habitId,
    required this.shortReason,
    this.letterToSelf,
    this.futureMessage,
    this.localImagePath,
    required this.updatedAtUtc,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'shortReason': shortReason,
    'letterToSelf': letterToSelf,
    'futureMessage': futureMessage,
    'localImagePath': localImagePath,
    'updatedAtUtc': updatedAtUtc.toIso8601String(),
  };

  factory PersonalMotivation.fromJson(Map<String, dynamic> json) {
    return PersonalMotivation(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      shortReason: json['shortReason'] as String,
      letterToSelf: json['letterToSelf'] as String?,
      futureMessage: json['futureMessage'] as String?,
      localImagePath: json['localImagePath'] as String?,
      updatedAtUtc: DateTime.parse(json['updatedAtUtc'] as String),
    );
  }
}
