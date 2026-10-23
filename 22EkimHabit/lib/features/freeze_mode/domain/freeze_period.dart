enum FreezeReason {
  illness('Hastalık'),
  travel('Seyahat'),
  busyPeriod('Yoğun Dönem'),
  medicalAdvice('Tıbbi Tavsiye'),
  other('Diğer');

  final String label;
  const FreezeReason(this.label);
}

class FreezePeriod {
  final String id;
  final String habitId;
  final DateTime startsOnLocalDate;
  final DateTime endsOnLocalDate;
  final FreezeReason reasonType;
  final String? reasonNote;
  final DateTime createdAtUtc;

  const FreezePeriod({
    required this.id,
    required this.habitId,
    required this.startsOnLocalDate,
    required this.endsOnLocalDate,
    this.reasonType = FreezeReason.illness,
    this.reasonNote,
    required this.createdAtUtc,
  });

  bool containsDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final s = DateTime(
      startsOnLocalDate.year,
      startsOnLocalDate.month,
      startsOnLocalDate.day,
    );
    final e = DateTime(
      endsOnLocalDate.year,
      endsOnLocalDate.month,
      endsOnLocalDate.day,
    );
    return !d.isBefore(s) && !d.isAfter(e);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'startsOnLocalDate': startsOnLocalDate.toIso8601String(),
    'endsOnLocalDate': endsOnLocalDate.toIso8601String(),
    'reasonType': reasonType.name,
    'reasonNote': reasonNote,
    'createdAtUtc': createdAtUtc.toIso8601String(),
  };

  factory FreezePeriod.fromJson(Map<String, dynamic> json) {
    return FreezePeriod(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      startsOnLocalDate: DateTime.parse(json['startsOnLocalDate'] as String),
      endsOnLocalDate: DateTime.parse(json['endsOnLocalDate'] as String),
      reasonType: json['reasonType'] != null
          ? FreezeReason.values.byName(json['reasonType'] as String)
          : FreezeReason.illness,
      reasonNote: json['reasonNote'] as String?,
      createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
    );
  }
}
