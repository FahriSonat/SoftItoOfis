class RegisterModel {
  final String fullName;
  final String email;
  final String password;
  final double weightKg;
  final double heightCm;

  const RegisterModel({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.weightKg = 70.0,
    this.heightCm = 175.0,
  });

  RegisterModel copyWith({
    String? fullName,
    String? email,
    String? password,
    double? weightKg,
    double? heightCm,
  }) {
    return RegisterModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
    );
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 70.0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }
}
