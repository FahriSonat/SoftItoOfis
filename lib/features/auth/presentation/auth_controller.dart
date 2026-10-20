import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/fake_auth_repository.dart';
import '../domain/entities/auth_session.dart';
import '../domain/repositories/auth_repository.dart';

enum AuthStatus { restoring, signedOut, signedIn }

class AuthState {
  const AuthState({required this.status, this.session, this.error});
  final AuthStatus status;
  final AuthSession? session;
  final String? error;

  const AuthState.restoring() : this(status: AuthStatus.restoring);
  const AuthState.signedOut({String? error})
    : this(status: AuthStatus.signedOut, error: error);
  const AuthState.signedIn(AuthSession session)
    : this(status: AuthStatus.signedIn, session: session);
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(),
);

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState.restoring();

  Future<void> restore() async {
    state = const AuthState.restoring();
    try {
      final session = await ref.read(authRepositoryProvider).restoreSession();
      state = session == null
          ? const AuthState.signedOut()
          : AuthState.signedIn(session);
    } catch (_) {
      state = const AuthState.signedOut(error: 'Oturum geri yüklenemedi.');
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = const AuthState.restoring();
    try {
      final session = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      state = AuthState.signedIn(session);
      return true;
    } on AuthException catch (error) {
      state = AuthState.signedOut(error: error.message);
    } catch (_) {
      state = const AuthState.signedOut(
        error: 'Giriş yapılamadı. Lütfen tekrar deneyin.',
      );
    }
    return false;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState.signedOut();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
