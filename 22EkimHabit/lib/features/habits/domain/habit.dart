enum HabitKind {
  negative,
  positive;

  bool get isNegative => this == HabitKind.negative;
  bool get isPositive => this == HabitKind.positive;
}

enum HabitCategory {
  // Negatif
  unhealthyEating('Sağlıksız Beslenme', 'fastfood', HabitKind.negative),
  alcohol('Alkol', 'local_bar', HabitKind.negative),
  smoking('Sigara', 'smoke_free', HabitKind.negative),
  gambling('Kumar', 'casino', HabitKind.negative),
  gaming('Oyun Bağımlılığı', 'sports_esports', HabitKind.negative),
  medication('Gereksiz İlaç Kullanımı', 'medication', HabitKind.negative),
  socialMedia(
    'Sosyal Medya Bağımlılığı',
    'phonelink_erase',
    HabitKind.negative,
  ),
  shopping('Alışveriş Bağımlılığı', 'shopping_bag', HabitKind.negative),
  customNegative('Özel Negatif Alışkanlık', 'flag', HabitKind.negative),

  // Pozitif
  healthyEating('Sağlıklı Beslenme', 'restaurant', HabitKind.positive),
  water('Su İçme', 'water_drop', HabitKind.positive),
  walking('Yürüyüş', 'directions_walk', HabitKind.positive),
  running('Koşu', 'directions_run', HabitKind.positive),
  fitness('Fitness / Spor', 'fitness_center', HabitKind.positive),
  swimming('Yüzme', 'pool', HabitKind.positive),
  yoga('Yoga / Pilates', 'self_improvement', HabitKind.positive),
  reading('Kitap Okuma', 'menu_book', HabitKind.positive),
  instrument('Enstrüman Çalma', 'music_note', HabitKind.positive),
  art('Resim / Sanat', 'palette', HabitKind.positive),
  brainTraining('Zekâ Oyunları', 'psychology', HabitKind.positive),
  customPositive('Özel Pozitif Alışkanlık', 'star', HabitKind.positive);

  final String title;
  final String iconKey;
  final HabitKind kind;

  const HabitCategory(this.title, this.iconKey, this.kind);
}

enum MeasurementType {
  boolean('Tamamlandı / Yapıldı'),
  count('Adet / Sayı'),
  durationMinutes('Süre (Dakika)'),
  distanceKm('Mesafe (Km)'),
  volumeMl('Hacim (ml / L)');

  final String label;
  const MeasurementType(this.label);
}

enum ScheduleType {
  daily('Her Gün'),
  selectedDays('Haftanın Seçili Günleri'),
  weeklyFrequency('Haftalık Hedef Sayısı');

  final String label;
  const ScheduleType(this.label);
}

enum HabitStatus { active, paused, archived }

class Habit {
  final String id;
  final String userId;
  final String name;
  final HabitKind kind;
  final HabitCategory category;
  final String iconKey;
  final HabitStatus status;
  final DateTime startAt; // Başlangıç tarihi ve saati
  final MeasurementType measurementType;
  final double targetValue; // örn: 2000 (ml), 30 (dk), 1 (adet)
  final String unit; // ml, sayfa, dk, km vb.
  final ScheduleType scheduleType;
  final List<int> scheduleDays; // 1 = Pazartesi ... 7 = Pazar
  final int weeklyTargetCount; // haftada X gün
  final double? unitCost; // negatif için birim maliyeti (TL)
  final double?
  dailyUsageBefore; // negatif için önceki günlük tüketim adedi/miktarı
  final bool privacyMode; // bildirimde nötr metin kullanılsın mı
  final DateTime createdAt;
  final DateTime updatedAt;

  const Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.kind,
    required this.category,
    required this.iconKey,
    this.status = HabitStatus.active,
    required this.startAt,
    this.measurementType = MeasurementType.boolean,
    this.targetValue = 1.0,
    this.unit = '',
    this.scheduleType = ScheduleType.daily,
    this.scheduleDays = const [1, 2, 3, 4, 5, 6, 7],
    this.weeklyTargetCount = 7,
    this.unitCost,
    this.dailyUsageBefore,
    this.privacyMode = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    HabitKind? kind,
    HabitCategory? category,
    String? iconKey,
    HabitStatus? status,
    DateTime? startAt,
    MeasurementType? measurementType,
    double? targetValue,
    String? unit,
    ScheduleType? scheduleType,
    List<int>? scheduleDays,
    int? weeklyTargetCount,
    double? unitCost,
    double? dailyUsageBefore,
    bool? privacyMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      category: category ?? this.category,
      iconKey: iconKey ?? this.iconKey,
      status: status ?? this.status,
      startAt: startAt ?? this.startAt,
      measurementType: measurementType ?? this.measurementType,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      scheduleType: scheduleType ?? this.scheduleType,
      scheduleDays: scheduleDays ?? this.scheduleDays,
      weeklyTargetCount: weeklyTargetCount ?? this.weeklyTargetCount,
      unitCost: unitCost ?? this.unitCost,
      dailyUsageBefore: dailyUsageBefore ?? this.dailyUsageBefore,
      privacyMode: privacyMode ?? this.privacyMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'kind': kind.name,
    'category': category.name,
    'iconKey': iconKey,
    'status': status.name,
    'startAt': startAt.toIso8601String(),
    'measurementType': measurementType.name,
    'targetValue': targetValue,
    'unit': unit,
    'scheduleType': scheduleType.name,
    'scheduleDays': scheduleDays,
    'weeklyTargetCount': weeklyTargetCount,
    'unitCost': unitCost,
    'dailyUsageBefore': dailyUsageBefore,
    'privacyMode': privacyMode,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'default_user',
      name: json['name'] as String,
      kind: HabitKind.values.byName(json['kind'] as String),
      category: HabitCategory.values.byName(json['category'] as String),
      iconKey: json['iconKey'] as String? ?? 'flag',
      status: json['status'] != null
          ? HabitStatus.values.byName(json['status'] as String)
          : HabitStatus.active,
      startAt: DateTime.parse(json['startAt'] as String),
      measurementType: json['measurementType'] != null
          ? MeasurementType.values.byName(json['measurementType'] as String)
          : MeasurementType.boolean,
      targetValue: (json['targetValue'] as num?)?.toDouble() ?? 1.0,
      unit: json['unit'] as String? ?? '',
      scheduleType: json['scheduleType'] != null
          ? ScheduleType.values.byName(json['scheduleType'] as String)
          : ScheduleType.daily,
      scheduleDays:
          (json['scheduleDays'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3, 4, 5, 6, 7],
      weeklyTargetCount: json['weeklyTargetCount'] as int? ?? 7,
      unitCost: (json['unitCost'] as num?)?.toDouble(),
      dailyUsageBefore: (json['dailyUsageBefore'] as num?)?.toDouble(),
      privacyMode: json['privacyMode'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
