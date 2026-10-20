import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/water_tracking_controller.dart';
import '../models/water_tracking_model.dart';
import '../widgets/water_tracking_card.dart';

/// [WaterTrackingView]
/// Clean UI kuralına uygun StatelessWidget ekranı.
/// Durum yönetimini ValueListenableBuilder ile reaktif olarak gerçekleştirir.
class WaterTrackingView extends StatelessWidget {
  final WaterTrackingController controller;

  WaterTrackingView({
    super.key,
    WaterTrackingController? controller,
  }) : controller = controller ?? WaterTrackingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - Su Takibi'),
        actions: [
          IconButton(
            tooltip: 'Sıfırla',
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetWater,
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<WaterTrackingModel>(
          valueListenable: controller.state,
          builder: (context, state, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WaterTrackingCard(
                    currentWaterMl: state.currentWaterMl,
                    dailyGoalWaterMl: state.dailyGoalWaterMl,
                    progress: state.progress,
                    isGoalReached: state.isGoalReached,
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Hızlı Su Ekle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickAddButton(
                          amountMl: 250,
                          icon: Icons.local_drink,
                          onPressed: () => controller.addWater(250),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAddButton(
                          amountMl: 500,
                          icon: Icons.water_drop,
                          onPressed: () => controller.addWater(500),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickAddButton(
                          amountMl: 750,
                          icon: Icons.fitness_center,
                          onPressed: () => controller.addWater(750),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (!state.isGoalReached)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.surfaceVariant,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hedefe ulaşmak için ${state.remainingWaterMl} ml daha su içmelisin!',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int amountMl;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuickAddButton({
    required this.amountMl,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surfaceVariant),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            '+$amountMl ml',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
