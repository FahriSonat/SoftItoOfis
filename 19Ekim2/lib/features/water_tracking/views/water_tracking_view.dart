import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../controllers/water_tracking_controller.dart';
import '../models/water_tracking_model.dart';
import '../widgets/water_tracking_card.dart';

class WaterTrackingView extends StatelessWidget {
  final WaterTrackingController _controller = WaterTrackingController();

  WaterTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Takibi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
            tooltip: 'Sıfırla',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: const Text('Günlük Kaydı Sıfırla'),
                  content: const Text('Bugünkü su tüketim verilerini sıfırlamak istiyor musunuz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('İptal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                      onPressed: () {
                        _controller.resetWater();
                        Navigator.pop(ctx);
                      },
                      child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Circular Ring Tracker Display
            ValueListenableBuilder<int>(
              valueListenable: _controller.currentWater,
              builder: (context, currentWater, _) {
                final double progress = (currentWater / _controller.dailyGoalWater).clamp(0.0, 1.0);
                final int percent = (progress * 100).toInt();

                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background glow circle
                        Container(
                          width: 190,
                          height: 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Circular Progress indicator
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 16,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        // Inner content
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.water_drop_rounded,
                              color: AppColors.primary,
                              size: 38,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              Formatters.formatWater(currentWater),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              '/ ${Formatters.formatWater(_controller.dailyGoalWater)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '%$percent Tamamlandı',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Modular Feature Card
            ValueListenableBuilder<int>(
              valueListenable: _controller.currentWater,
              builder: (context, currentWater, _) {
                return WaterTrackingCard(
                  title: 'Günlük Hidrasyon',
                  subtitle: 'Spor performansın için su dengeni koru',
                  currentWater: currentWater,
                  goalWater: _controller.dailyGoalWater,
                );
              },
            ),

            const SizedBox(height: 16),

            // Quick Add Beverage Shortcuts
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'Hızlı Su Ekle',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _QuickAddButton(
                  ml: 200,
                  label: 'Küçük Bardak',
                  icon: Icons.local_drink_rounded,
                  onTap: () => _controller.addWater(200),
                ),
                const SizedBox(width: 8),
                _QuickAddButton(
                  ml: 250,
                  label: 'Su Bardağı',
                  icon: Icons.local_drink_rounded,
                  onTap: () => _controller.addWater(250),
                ),
                const SizedBox(width: 8),
                _QuickAddButton(
                  ml: 500,
                  label: 'Matara (500ml)',
                  icon: Icons.sports_bar_rounded,
                  onTap: () => _controller.addWater(500),
                ),
                const SizedBox(width: 8),
                _QuickAddButton(
                  ml: 750,
                  label: 'Büyük Şişe',
                  icon: Icons.fitness_center_rounded,
                  onTap: () => _controller.addWater(750),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Today's Intake Log History
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                'Bugünkü Tüketim Geçmişi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            ValueListenableBuilder<List<WaterTrackingModel>>(
              valueListenable: _controller.entries,
              builder: (context, entries, _) {
                if (entries.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Center(
                      child: Text(
                        'Henüz su kaydı bulunmuyor.\nYukarıdaki butonlardan su ekleyin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = entries[index];
                    final timeStr = '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.beverageType,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  timeStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${item.amountMl} ml',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final int ml;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddButton({
    required this.ml,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: 6),
              Text(
                '+$ml ml',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
