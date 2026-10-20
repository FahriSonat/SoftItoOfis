class LoginModel {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginModel({
    this.email = '',
    this.password = '',
    this.rememberMe = true,
  });

  LoginModel copyWith({
    String? email,
    String? password,
    bool? rememberMe,
  }) {
    return LoginModel(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      rememberMe: json['rememberMe'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}
