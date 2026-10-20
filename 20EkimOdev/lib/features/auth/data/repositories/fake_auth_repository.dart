import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

/// Deliberately small fake implementation; secrets are never persisted.
class FakeAuthRepository implements AuthRepository {
  static const _sessionKey = 'rotarent_fake_session';
  static const _demoEmail = 'demo@rotarent.com';
  static const _demoPassword = 'Demo123!';
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  @override
  Future<AuthSession?> restoreSession() async {
    final email = await _storage.read(key: _sessionKey);
    if (email == null) return null;
    return const AuthSession(
      userId: 'demo-user',
      fullName: 'Ahmet Yılmaz',
      email: _demoEmail,
    );
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (email.trim().toLowerCase() != _demoEmail || password != _demoPassword) {
      throw const AuthException('E-posta veya parola hatalı.');
    }
    await _storage.write(key: _sessionKey, value: _demoEmail);
    return const AuthSession(
      userId: 'demo-user',
      fullName: 'Ahmet Yılmaz',
      email: _demoEmail,
    );
  }

  @override
  Future<void> signOut() => _storage.delete(key: _sessionKey);
}

class AuthException implements Exception {
  const AuthException(this.message);
  final String message;
}
