import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ==============================================================================
// ÖRNEK EKRAN UYGULAMASI: Susadım - Su Takibi (Water Tracking)
// 
// Bu dosya, SKILL.md ve project.md standartlarına uygun Clean UI ve ValueNotifier
// reaktif mimarisini tek bir referans dosyada eksiksiz olarak gösterir.
//
// ⚠️ DİKKAT (SKILL.md Kural 1):
// Gerçek projede bu katmanlar asla tek bir dosyada toplanmaz.
// Aşağıdaki açıklamalar her bileşenin ait olduğu dosyayı belirtir:
// 1. Model:      lib/features/water_tracking/models/water_tracking_model.dart
// 2. Controller: lib/features/water_tracking/controllers/water_tracking_controller.dart
// 3. Widget:     lib/features/water_tracking/widgets/water_progress_card.dart
// 4. View (UI):  lib/features/water_tracking/views/water_tracking_view.dart
// ==============================================================================

// -----------------------------------------------------------------------------
// KATMAN 1: MODEL (lib/features/water_tracking/models/water_tracking_model.dart)
// Kural: Immutable (değişmez), copyWith, fromJson, toJson zorunludur.
// -----------------------------------------------------------------------------
@immutable
class WaterTrackingModel {
  final int currentWaterMl;
  final int dailyGoalWaterMl;
  final DateTime lastUpdated;

  const WaterTrackingModel({
    this.currentWaterMl = 0,
    this.dailyGoalWaterMl = 2500,
    required this.lastUpdated,
  });

  /// İlerleme yüzdesi (0.0 ile 1.0 arasında)
  double get progress {
    if (dailyGoalWaterMl <= 0) return 0.0;
    return (currentWaterMl / dailyGoalWaterMl).clamp(0.0, 1.0);
  }

  /// Günlük hedefe kalan su miktarı (ml)
  int get remainingWaterMl {
    final remaining = dailyGoalWaterMl - currentWaterMl;
    return remaining > 0 ? remaining : 0;
  }

  /// Hedefe ulaşıldı mı kontrolü
  bool get isGoalReached => currentWaterMl >= dailyGoalWaterMl;

  /// Değişmez kopya üretim fonksiyonu
  WaterTrackingModel copyWith({
    int? currentWaterMl,
    int? dailyGoalWaterMl,
    DateTime? lastUpdated,
  }) {
    return WaterTrackingModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalWaterMl: dailyGoalWaterMl ?? this.dailyGoalWaterMl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory WaterTrackingModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackingModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalWaterMl: json['dailyGoalWaterMl'] as int? ?? 2500,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalWaterMl': dailyGoalWaterMl,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

// -----------------------------------------------------------------------------
// KATMAN 2: CONTROLLER (lib/features/water_tracking/controllers/water_tracking_controller.dart)
// Kural: ValueNotifier ile reaktif yönetim. Sayfa düzeyinde setState KULLANILMAZ.
// -----------------------------------------------------------------------------
class WaterTrackingController {
  /// Ana durum bildirimcisi
  final ValueNotifier<WaterTrackingModel> state;

  WaterTrackingController({WaterTrackingModel? initialState})
      : state = ValueNotifier<WaterTrackingModel>(
          initialState ?? WaterTrackingModel(lastUpdated: DateTime.now()),
        );

  /// Su ekleme işlemi (örn: 250 ml veya 500 ml)
  void addWater([int amountMl = 250]) {
    state.value = state.value.copyWith(
      currentWaterMl: state.value.currentWaterMl + amountMl,
      lastUpdated: DateTime.now(),
    );
  }

  /// Su tüketimini sıfırlama işlemi
  void resetWater() {
    state.value = state.value.copyWith(
      currentWaterMl: 0,
      lastUpdated: DateTime.now(),
    );
  }

  /// Günlük hedefi güncelleme
  void updateDailyGoal(int newGoalMl) {
    if (newGoalMl > 0) {
      state.value = state.value.copyWith(
        dailyGoalWaterMl: newGoalMl,
        lastUpdated: DateTime.now(),
      );
    }
  }

  /// Controller yaşam döngüsü sonlandığında ValueNotifier serbest bırakılmalıdır
  void dispose() {
    state.dispose();
  }
}

// -----------------------------------------------------------------------------
// KATMAN 3: WIDGET (lib/features/water_tracking/widgets/water_progress_card.dart)
// Kural: StatelessWidget, const constructor, Material 3 uyumu, AppColors entegrasyonu.
// -----------------------------------------------------------------------------
class WaterProgressCard extends StatelessWidget {
  final int currentWaterMl;
  final int dailyGoalWaterMl;
  final double progress;
  final bool isGoalReached;

  const WaterProgressCard({
    super.key,
    required this.currentWaterMl,
    required this.dailyGoalWaterMl,
    required this.progress,
    required this.isGoalReached,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const cyanAccent = Color(0xFF00E5FF);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Günlük Hedef',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dailyGoalWaterMl ml',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isGoalReached
                        ? Colors.green.withAlpha(51)
                        : cyanAccent.withAlpha(51),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isGoalReached ? Icons.check_circle : Icons.water_drop,
                        color: isGoalReached ? Colors.greenAccent : cyanAccent,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isGoalReached ? 'Hedef Tamamlandı!' : '%${(progress * 100).toInt()}',
                        style: TextStyle(
                          color: isGoalReached ? Colors.greenAccent : cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            // Dairesel veya çubuk gösterge
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 16,
                backgroundColor: Colors.white10,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isGoalReached ? Colors.greenAccent : cyanAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$currentWaterMl',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cyanAccent,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '/ $dailyGoalWaterMl ml',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KATMAN 4: VIEW (lib/features/water_tracking/views/water_tracking_view.dart)
// Kural: StatelessWidget, ValueListenableBuilder ile reaktif dinleme, const zorunluluğu.
// -----------------------------------------------------------------------------
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
        title: const Text('Su Takibi'),
        centerTitle: true,
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // İlerleme Kartı Bileşeni
                  WaterProgressCard(
                    currentWaterMl: state.currentWaterMl,
                    dailyGoalWaterMl: state.dailyGoalWaterMl,
                    progress: state.progress,
                    isGoalReached: state.isGoalReached,
                  ),
                  const SizedBox(height: 32),

                  // Hızlı Su Ekleme Butonları Başlığı
                  const Text(
                    'Hızlı Ekle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hızlı Ekleme Butonları Grid/Row
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
                          icon: Icons.sports_gymnastics,
                          onPressed: () => controller.addWater(750),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Kalan Miktar Bilgilendirmesi
                  if (!state.isGoalReached)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blueAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hedefine ulaşmak için ${state.remainingWaterMl} ml daha su içmelisin!',
                              style: const TextStyle(fontSize: 14),
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

/// Özel Hızlı Ekleme Butonu (Özel Bileşen)
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 8),
          Text(
            '+$amountMl ml',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
