import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/app_providers.dart';
import '../features/auth/presentation/auth_controller.dart';

class BootstrapScreen extends ConsumerStatefulWidget {
  const BootstrapScreen({super.key});

  @override
  ConsumerState<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends ConsumerState<BootstrapScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.wait([
        ref.read(themeModeProvider.notifier).restore(),
        ref.read(authControllerProvider.notifier).restore(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car_filled, size: 56),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ],
      ),
    ),
  );
}
