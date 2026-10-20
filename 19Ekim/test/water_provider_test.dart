import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracking/providers/water_provider.dart';

void main() {
  group('WaterNotifier Unit Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('İlk durum varsayılan değerleri doğru olmalı', () {
      final state = container.read(waterProvider);
      expect(state.dailyGoalMl, 2500);
      expect(state.currentAmountMl, 0);
      expect(state.remainingMl, 2500);
      expect(state.progressPercentage, 0.0);
    });

    test('Su eklendiğinde miktar ve ilerleme güncellenmeli', () {
      final notifier = container.read(waterProvider.notifier);
      notifier.addWater(500);

      final state = container.read(waterProvider);
      expect(state.currentAmountMl, 500);
      expect(state.remainingMl, 2000);
      expect(state.progressPercentage, 0.2);
      expect(state.entries.length, 1);
    });

    test('Kayıt silindiğinde miktar düşmeli', () {
      final notifier = container.read(waterProvider.notifier);
      notifier.addWater(250);
      final id = container.read(waterProvider).entries.first.id;

      notifier.removeEntry(id);
      final state = container.read(waterProvider);
      expect(state.currentAmountMl, 0);
      expect(state.entries.isEmpty, true);
    });

    test('Günlük sıfırlama çalıştığında tüm kayıtlar temizlenmeli', () {
      final notifier = container.read(waterProvider.notifier);
      notifier.addWater(330);
      notifier.addWater(500);
      expect(container.read(waterProvider).entries.length, 2);

      notifier.resetDaily();
      final state = container.read(waterProvider);
      expect(state.currentAmountMl, 0);
      expect(state.entries.isEmpty, true);
    });
  });
}
