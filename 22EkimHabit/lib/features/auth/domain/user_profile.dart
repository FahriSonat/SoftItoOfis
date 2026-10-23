class UserProfile {
  final String id;
  final String displayName;
  final String email;
  final String avatar;
  final String timezone;
  final String locale;
  final String? quietHoursStart; // örn: "23:00"
  final String? quietHoursEnd; // örn: "07:00"
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.avatar = '🌱',
    this.timezone = 'Europe/Istanbul',
    this.locale = 'tr_TR',
    this.quietHoursStart = '23:00',
    this.quietHoursEnd = '07:00',
    required this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatar,
    String? timezone,
    String? locale,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      timezone: timezone ?? this.timezone,
      locale: locale ?? this.locale,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'email': email,
    'avatar': avatar,
    'timezone': timezone,
    'locale': locale,
    'quietHoursStart': quietHoursStart,
    'quietHoursEnd': quietHoursEnd,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String? ?? 'Kullanıcı',
      email: json['email'] as String? ?? 'kullanici@denge.app',
      avatar: json['avatar'] as String? ?? '🌱',
      timezone: json['timezone'] as String? ?? 'Europe/Istanbul',
      locale: json['locale'] as String? ?? 'tr_TR',
      quietHoursStart: json['quietHoursStart'] as String? ?? '23:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
