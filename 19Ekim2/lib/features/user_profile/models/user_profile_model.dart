class UserProfileModel {
  final String name;
  final String email;
  final String profileimage;
  final int level;
  final int coins;
  final double weightKg;
  final double heightCm;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.profileimage,
    required this.level,
    required this.coins,
    this.weightKg = 75.0,
    this.heightCm = 180.0,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? profileimage,
    int? level,
    int? coins,
    double? weightKg,
    double? heightCm,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileimage: profileimage ?? this.profileimage,
      level: level ?? this.level,
      coins: coins ?? this.coins,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
    );
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileimage: json['profileimage'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      coins: json['coins'] as int? ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 75.0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 180.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileimage': profileimage,
      'level': level,
      'coins': coins,
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }
}
