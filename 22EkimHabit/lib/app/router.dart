import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/habits/presentation/negative_habits_screen.dart';
import '../features/habits/presentation/positive_habits_screen.dart';
import '../features/habits/presentation/habit_wizard_screen.dart';
import '../features/habits/presentation/habit_detail_screen.dart';
import '../features/coping/presentation/urge_support_screen.dart';
import '../features/streaks/presentation/restart_pledge_screen.dart';
import '../features/badges/presentation/badges_screen.dart';
import '../features/auth/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/calendar/presentation/global_calendar_screen.dart';
import '../features/ai_coach/presentation/pages/ai_coach_page.dart';
import 'theme/app_colors.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.shield_outlined),
                selectedIcon: Icon(
                  Icons.shield_rounded,
                  color: AppColors.negativeStages.first,
                ),
                label: 'Negatif',
              ),
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: Icon(
                  Icons.home_rounded,
                  color: AppColors.positiveStages.last,
                ),
                label: 'Ana Sayfa',
              ),
              NavigationDestination(
                icon: const Icon(Icons.spa_outlined),
                selectedIcon: Icon(
                  Icons.spa_rounded,
                  color: AppColors.positiveStages.first,
                ),
                label: 'Pozitif',
              ),
            ],
          ),
        );
      },
      branches: [
        // Sol Sekme: Negatif
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/negative',
              builder: (context, state) => const NegativeHabitsScreen(),
            ),
          ],
        ),
        // Orta Sekme: Ana Sayfa
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Sağ Sekme: Pozitif
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/positive',
              builder: (context, state) => const PositiveHabitsScreen(),
            ),
          ],
        ),
      ],
    ),

    // İkincil Route'lar
    GoRoute(
      path: '/habit/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final kind = state.uri.queryParameters['kind'];
        return HabitWizardScreen(initialKind: kind);
      },
    ),
    GoRoute(
      path: '/habit/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return HabitDetailScreen(habitId: id);
      },
      routes: [
        GoRoute(
          path: 'urge-support',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return UrgeSupportScreen(habitId: id);
          },
        ),
        GoRoute(
          path: 'restart',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final prevStreak =
                int.tryParse(
                  state.uri.queryParameters['previousStreak'] ?? '0',
                ) ??
                0;
            return RestartPledgeScreen(habitId: id, previousStreak: prevStreak);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/badges',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BadgesScreen(),
    ),
    GoRoute(
      path: '/profile',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/calendar',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const GlobalCalendarScreen(),
    ),
    GoRoute(
      path: '/ai-coach',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final habit = state.uri.queryParameters['habit'];
        return AiCoachPage(initialHabitContext: habit);
      },
    ),
  ],
);
