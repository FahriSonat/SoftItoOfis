class AuthSession {
  const AuthSession({
    required this.userId,
    required this.fullName,
    required this.email,
  });

  final String userId;
  final String fullName;
  final String email;
}
