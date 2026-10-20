class ResetPasswordModel {
  final String email;
  final bool isEmailSent;

  const ResetPasswordModel({
    this.email = '',
    this.isEmailSent = false,
  });

  ResetPasswordModel copyWith({
    String? email,
    bool? isEmailSent,
  }) {
    return ResetPasswordModel(
      email: email ?? this.email,
      isEmailSent: isEmailSent ?? this.isEmailSent,
    );
  }

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      email: json['email'] as String? ?? '',
      isEmailSent: json['isEmailSent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isEmailSent': isEmailSent,
    };
  }
}
