import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rotarent/core/data/fake_data.dart';
import 'package:rotarent/core/providers/app_providers.dart';
import 'package:rotarent/core/widgets/vehicle_card.dart';
import 'package:rotarent/main.dart';

void main() {
  group('RotaRent App & Navigation Tests', () {
    testWidgets('App renders correctly with 5-destination bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: RotaRentApp()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Check Brand and Greeting on Home screen (index 2)
      expect(find.text('RotaRent'), findsOneWidget);
      expect(find.textContaining('Ahmet Yılmaz'), findsOneWidget);

      // Check NavigationBar and the 5 destinations
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Ödeme'), findsOneWidget);
      expect(find.text('Kiralama'), findsOneWidget);
      expect(find.text('Ana Ekran'), findsOneWidget);
      expect(find.text('Hesabım'), findsOneWidget);
      expect(find.text('Harita (GPS)'), findsOneWidget);
    });

    testWidgets('Can switch tabs between 5 screens', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: RotaRentApp()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap on Kiralama tab (index 1)
      await tester.tap(find.text('Kiralama'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Araç Kiralama'), findsOneWidget);
      expect(find.byType(VehicleCard), findsWidgets);

      // Tap on Ödeme tab (index 0)
      await tester.tap(find.text('Ödeme'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Ödeme ve Rezervasyon'), findsOneWidget);

      // Tap on Hesabım tab (index 3)
      await tester.tap(find.text('Hesabım'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('demo@rotarent.com'), findsOneWidget);

      // Tap on Harita (GPS) tab (index 4)
      await tester.tap(find.text('Harita (GPS)'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Canlı GPS Araç Takibi'), findsOneWidget);
    });
  });

  group('Vehicle Filter Provider Unit Tests', () {
    test('Initial filter includes all vehicles', () {
      final container = ProviderContainer();
      final vehicles = container.read(filteredVehiclesProvider);
      expect(vehicles.length, equals(FakeData.vehicles.length));
    });

    test('Filter by Brand works', () {
      final container = ProviderContainer();
      container.read(vehicleFilterProvider.notifier).setBrand('BMW');
      final vehicles = container.read(filteredVehiclesProvider);

      expect(vehicles.every((v) => v.brand == 'BMW'), isTrue);
      expect(vehicles.isNotEmpty, isTrue);
    });

    test('Filter by Class and Transmission works', () {
      final container = ProviderContainer();
      container
          .read(vehicleFilterProvider.notifier)
          .setVehicleClass('Ekonomik');
      container
          .read(vehicleFilterProvider.notifier)
          .setTransmission('Otomatik');
      final vehicles = container.read(filteredVehiclesProvider);

      expect(vehicles.every((v) => v.vehicleClass == 'Ekonomik'), isTrue);
      expect(vehicles.every((v) => v.transmission == 'Otomatik'), isTrue);
    });

    test('Filter by Max Price works', () {
      final container = ProviderContainer();
      container.read(vehicleFilterProvider.notifier).setMaxPrice(1500);
      final vehicles = container.read(filteredVehiclesProvider);

      expect(vehicles.every((v) => v.dailyPrice <= 1500), isTrue);
    });

    test(
      'New vehicles exist in FakeData (Audi, Dacia, Ford, Honda, Cupra)',
      () {
        final container = ProviderContainer();
        final allVehicles = container.read(filteredVehiclesProvider);

        expect(allVehicles.length, equals(17));
        expect(
          allVehicles.any((v) => v.brand == 'Audi' && v.model.contains('A4')),
          isTrue,
        );
        expect(
          allVehicles.any(
            (v) => v.brand == 'Dacia' && v.model.contains('Duster'),
          ),
          isTrue,
        );
        expect(
          allVehicles.any(
            (v) => v.brand == 'Ford' && v.model.contains('Mustang'),
          ),
          isTrue,
        );
        expect(
          allVehicles.any(
            (v) => v.brand == 'Honda' && v.model.contains('Civic'),
          ),
          isTrue,
        );
        expect(
          allVehicles.any(
            (v) => v.brand == 'Cupra' && v.model.contains('Formentor'),
          ),
          isTrue,
        );
      },
    );
  });
}
