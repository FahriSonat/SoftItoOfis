import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rotarent/core/data/fake_data.dart';
import 'package:rotarent/core/providers/app_providers.dart';

void main() {
  group('Araç filtreleri', () {
    test('başlangıçta tüm demo araçlarını döndürür', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(filteredVehiclesProvider).length,
        FakeData.vehicles.length,
      );
    });

    test('marka ve fiyat filtrelerini birlikte uygular', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleFilterProvider.notifier);

      notifier.setBrand('BMW');
      notifier.setMaxPrice(4000);

      final vehicles = container.read(filteredVehiclesProvider);
      expect(vehicles, hasLength(1));
      expect(vehicles.single.brand, 'BMW');
      expect(vehicles.single.dailyPrice, lessThanOrEqualTo(4000));
    });

    test('filtre sıfırlama tüm araçları yeniden görünür yapar', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(vehicleFilterProvider.notifier);

      notifier.setFuelType('Elektrik');
      expect(container.read(filteredVehiclesProvider), isNotEmpty);
      notifier.reset();

      expect(
        container.read(filteredVehiclesProvider).length,
        FakeData.vehicles.length,
      );
    });
  });
}
