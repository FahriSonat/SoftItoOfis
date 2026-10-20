import 'package:flutter/foundation.dart';
import '../models/water_tracking_model.dart';

/// [WaterTrackingController]
/// Su takibi ekranı için iş mantığı ve reaktif State (ValueNotifier) yöneticisi.
class WaterTrackingController {
  /// Ana durum bildirimcisi
  final ValueNotifier<WaterTrackingModel> state;

  WaterTrackingController({WaterTrackingModel? initialState})
      : state = ValueNotifier<WaterTrackingModel>(
          initialState ?? WaterTrackingModel(lastUpdated: DateTime.now()),
        );

  /// Su ekleme işlemi (varsayılan: 250 ml)
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

  /// Controller bellekten atılırken dinleyicileri serbest bırakır
  void dispose() {
    state.dispose();
  }
}
