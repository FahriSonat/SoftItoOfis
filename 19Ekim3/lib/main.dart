import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/water_tracking/views/water_tracking_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: WaterTrackingView(),
    );
  }
}
