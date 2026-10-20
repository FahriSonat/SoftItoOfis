import 'package:go_router/go_router.dart';
import '../../features/login/views/login_view.dart';
import '../../features/navigation/views/main_shell_view.dart';
import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/register/views/register_view.dart';
import '../../features/reset_password/views/reset_password_view.dart';
import '../../features/settings/views/settings_view.dart';
import '../../features/splash/views/splash_view.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterView(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordView(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShellView(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsView(),
      ),
    ],
  );
}
