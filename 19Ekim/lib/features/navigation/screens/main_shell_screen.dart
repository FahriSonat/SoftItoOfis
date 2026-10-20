import 'package:flutter/material.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/features/exercise/screens/exercise_screen.dart';
import 'package:susadim/features/nutrition/screens/nutrition_screen.dart';
import 'package:susadim/features/user_profile/screens/user_profile_screen.dart';
import 'package:susadim/features/water_tracking/screens/water_tracking_screen.dart';
import 'package:susadim/features/workout_history/screens/workout_history_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    WaterTrackingScreen(),
    ExerciseScreen(),
    NutritionScreen(),
    WorkoutHistoryScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop_rounded, color: AppColors.primary),
            label: 'Su',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center_rounded, color: AppColors.secondary),
            label: 'Egzersiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_outlined),
            selectedIcon: Icon(Icons.restaurant_rounded, color: AppColors.tertiary),
            label: 'Beslenme',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded, color: AppColors.primary),
            label: 'Geçmiş',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
