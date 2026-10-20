import 'package:flutter/foundation.dart';
import '../models/water_tracking_model.dart';

class WaterTrackingController {
  // Singleton pattern for shared controller state across widgets/screens
  static final WaterTrackingController _instance = WaterTrackingController._internal();
  factory WaterTrackingController() => _instance;

  WaterTrackingController._internal() {
    _initDefaults();
  }

  final ValueNotifier<int> currentWater = ValueNotifier<int>(1250);
  final int dailyGoalWater = 2500;
  final ValueNotifier<List<WaterTrackingModel>> entries = ValueNotifier<List<WaterTrackingModel>>([]);

  void _initDefaults() {
    final now = DateTime.now();
    entries.value = [
      WaterTrackingModel(
        id: '1',
        amountMl: 500,
        timestamp: now.subtract(const Duration(hours: 4)),
        beverageType: 'Sabah Suyu',
      ),
      WaterTrackingModel(
        id: '2',
        amountMl: 250,
        timestamp: now.subtract(const Duration(hours: 2)),
        beverageType: 'Antrenman Öncesi',
      ),
      WaterTrackingModel(
        id: '3',
        amountMl: 500,
        timestamp: now.subtract(const Duration(minutes: 45)),
        beverageType: 'Antrenman Esnası',
      ),
    ];
  }

  void addWater([int ml = 250]) {
    currentWater.value += ml;
    final newEntry = WaterTrackingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: ml,
      timestamp: DateTime.now(),
      beverageType: 'Hızlı Ekleme',
    );
    entries.value = [newEntry, ...entries.value];
  }

  void resetWater() {
    currentWater.value = 0;
    entries.value = [];
  }

  void dispose() {
    currentWater.dispose();
    entries.dispose();
  }
}
