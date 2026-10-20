import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/gps/presentation/gps_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/payment/presentation/payment_screen.dart';
import '../../features/rental/presentation/rental_screen.dart';
import '../bootstrap.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final atSplash = state.matchedLocation == '/splash';
      final atLogin = state.matchedLocation == '/login';
      if (auth.status == AuthStatus.restoring) {
        return atSplash ? null : '/splash';
      }
      if (auth.status == AuthStatus.signedOut) return atLogin ? null : '/login';
      if (atSplash || atLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const BootstrapScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) => const RentalScreen(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(path: '/gps', builder: (context, state) => const GpsScreen()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => context.go('/home'),
          child: const Text('Ana sayfaya dön'),
        ),
      ),
    ),
  );
});
