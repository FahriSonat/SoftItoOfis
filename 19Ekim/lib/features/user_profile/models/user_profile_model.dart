class UserProfileModel {
  final String name;
  final String email;
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender;
  final String activityLevel;

  const UserProfileModel({
    required this.name,
    required this.email,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  double get bmi {
    final heightM = heightCm / 100.0;
    if (heightM <= 0) return 0.0;
    return weightKg / (heightM * heightM);
  }

  UserProfileModel copyWith({
    String? name,
    String? email,
    double? weightKg,
    double? heightCm,
    int? age,
    String? gender,
    String? activityLevel,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
