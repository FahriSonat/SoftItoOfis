import 'package:go_router/go_router.dart';
import 'package:susadim/features/login/screens/login_screen.dart';
import 'package:susadim/features/navigation/screens/main_shell_screen.dart';
import 'package:susadim/features/onboarding/screens/onboarding_screen.dart';
import 'package:susadim/features/register/screens/register_screen.dart';
import 'package:susadim/features/reset_password/screens/reset_password_screen.dart';
import 'package:susadim/features/settings/screens/settings_screen.dart';
import 'package:susadim/features/splash/screens/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const MainShellScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
