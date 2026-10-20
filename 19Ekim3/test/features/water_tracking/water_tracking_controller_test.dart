import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracking/controllers/water_tracking_controller.dart';

void main() {
  group('WaterTrackingController Tests', () {
    late WaterTrackingController controller;

    setUp(() {
      controller = WaterTrackingController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan değerlerle başlatılmalıdır', () {
      expect(controller.state.value.currentWaterMl, 0);
      expect(controller.state.value.dailyGoalWaterMl, 2500);
      expect(controller.state.value.isGoalReached, false);
      expect(controller.state.value.progress, 0.0);
    });

    test('addWater çağrıldığında currentWaterMl artmalıdır', () {
      controller.addWater(250);
      expect(controller.state.value.currentWaterMl, 250);
      expect(controller.state.value.progress, 0.1);

      controller.addWater(500);
      expect(controller.state.value.currentWaterMl, 750);
    });

    test('resetWater çağrıldığında miktar sıfırlanmalıdır', () {
      controller.addWater(500);
      controller.resetWater();
      expect(controller.state.value.currentWaterMl, 0);
    });

    test('Hedefe ulaşıldığında isGoalReached true dönmelidir', () {
      controller.addWater(2500);
      expect(controller.state.value.isGoalReached, true);
      expect(controller.state.value.progress, 1.0);
      expect(controller.state.value.remainingWaterMl, 0);
    });
  });
}
