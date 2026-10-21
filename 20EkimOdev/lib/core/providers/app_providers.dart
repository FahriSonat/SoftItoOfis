import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/fake_data.dart';
import '../models/vehicle.dart';
import '../storage/theme_preference_store.dart';

final themePreferenceStoreProvider = Provider<ThemePreferenceStore>(
  (ref) => ThemePreferenceStore(),
);

// Theme Mode Notifier (Riverpod 3.x Notifier)
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setMode(ThemeMode mode) {
    state = mode;
    ref.read(themePreferenceStoreProvider).save(mode);
  }

  Future<void> restore() async {
    state = await ref.read(themePreferenceStoreProvider).read();
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

// Selected Vehicle for Payment / Checkout Screen
class SelectedVehicleNotifier extends Notifier<Vehicle> {
  @override
  Vehicle build() => FakeData.vehicles.first;

  void selectVehicle(Vehicle vehicle) {
    state = vehicle;
  }
}

final selectedVehicleForPaymentProvider =
    NotifierProvider<SelectedVehicleNotifier, Vehicle>(
      SelectedVehicleNotifier.new,
    );

// Currently Active Rented Vehicle (Shown on Live GPS tracking & Hesabım)
class ActiveRentalVehicleNotifier extends Notifier<Vehicle> {
  @override
  Vehicle build() => FakeData.vehicles[2]; // BMW 320i M Sport with active GPS

  void setActiveVehicle(Vehicle vehicle) {
    state = vehicle;
  }
}

final activeRentalVehicleProvider =
    NotifierProvider<ActiveRentalVehicleNotifier, Vehicle>(
      ActiveRentalVehicleNotifier.new,
    );

// Filter state model for Vehicle Rental Search Screen
class VehicleFilterState {
  final String brand;
  final String modelQuery;
  final String vehicleClass;
  final String bodyType;
  final int minYear;
  final String engine;
  final String transmission;
  final String fuelType;
  final double maxPrice;

  const VehicleFilterState({
    this.brand = 'Hepsi',
    this.modelQuery = '',
    this.vehicleClass = 'Hepsi',
    this.bodyType = 'Hepsi',
    this.minYear = 0,
    this.engine = 'Hepsi',
    this.transmission = 'Hepsi',
    this.fuelType = 'Hepsi',
    this.maxPrice = 10000,
  });

  int get activeFilterCount {
    int count = 0;
    if (brand != 'Hepsi') count++;
    if (modelQuery.trim().isNotEmpty) count++;
    if (vehicleClass != 'Hepsi') count++;
    if (bodyType != 'Hepsi') count++;
    if (minYear > 0) count++;
    if (engine != 'Hepsi') count++;
    if (transmission != 'Hepsi') count++;
    if (fuelType != 'Hepsi') count++;
    if (maxPrice < 10000) count++;
    return count;
  }

  VehicleFilterState copyWith({
    String? brand,
    String? modelQuery,
    String? vehicleClass,
    String? bodyType,
    int? minYear,
    String? engine,
    String? transmission,
    String? fuelType,
    double? maxPrice,
  }) {
    return VehicleFilterState(
      brand: brand ?? this.brand,
      modelQuery: modelQuery ?? this.modelQuery,
      vehicleClass: vehicleClass ?? this.vehicleClass,
      bodyType: bodyType ?? this.bodyType,
      minYear: minYear ?? this.minYear,
      engine: engine ?? this.engine,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}

// Filter Notifier using Riverpod 3.x Notifier
class VehicleFilterNotifier extends Notifier<VehicleFilterState> {
  @override
  VehicleFilterState build() => const VehicleFilterState();

  void setBrand(String brand) {
    state = state.copyWith(brand: brand);
  }

  void setModelQuery(String query) {
    state = state.copyWith(modelQuery: query);
  }

  void setVehicleClass(String vClass) {
    state = state.copyWith(vehicleClass: vClass);
  }

  void setBodyType(String bodyType) {
    state = state.copyWith(bodyType: bodyType);
  }

  void setMinYear(int year) {
    state = state.copyWith(minYear: year);
  }

  void setEngine(String engine) {
    state = state.copyWith(engine: engine);
  }

  void setTransmission(String transmission) {
    state = state.copyWith(transmission: transmission);
  }

  void setFuelType(String fuelType) {
    state = state.copyWith(fuelType: fuelType);
  }

  void setMaxPrice(double price) {
    state = state.copyWith(maxPrice: price);
  }

  void reset() {
    state = const VehicleFilterState();
  }
}

final vehicleFilterProvider =
    NotifierProvider<VehicleFilterNotifier, VehicleFilterState>(
      VehicleFilterNotifier.new,
    );

// Filtered vehicles list derived provider
final filteredVehiclesProvider = Provider<List<Vehicle>>((ref) {
  final filter = ref.watch(vehicleFilterProvider);
  return FakeData.vehicles.where((v) {
    if (filter.brand != 'Hepsi' && v.brand != filter.brand) {
      return false;
    }
    if (filter.vehicleClass != 'Hepsi' &&
        v.vehicleClass != filter.vehicleClass) {
      return false;
    }
    if (filter.bodyType != 'Hepsi' && v.bodyType != filter.bodyType) {
      return false;
    }
    if (filter.transmission != 'Hepsi' &&
        v.transmission != filter.transmission) {
      return false;
    }
    if (filter.fuelType != 'Hepsi' && v.fuelType != filter.fuelType) {
      return false;
    }
    if (filter.minYear > 0 && v.year < filter.minYear) {
      return false;
    }
    if (v.dailyPrice > filter.maxPrice) {
      return false;
    }
    if (filter.engine != 'Hepsi') {
      final selected = filter.engine.toLowerCase();
      final vEng = v.engine.toLowerCase();
      bool match = false;
      if (selected.contains('elektrik')) {
        match = vEng.contains('elektrik') || v.fuelType == 'Elektrik';
      } else if (selected.contains('1.3')) {
        match = vEng.contains('1.3');
      } else if (selected.contains('1.4')) {
        match = vEng.contains('1.4');
      } else if (selected.contains('1.5 vtec')) {
        match = vEng.contains('vtec') || (v.brand == 'Honda');
      } else if (selected.contains('1.5')) {
        match = vEng.contains('1.5');
      } else if (selected.contains('1.8')) {
        match = vEng.contains('1.8');
      } else if (selected.contains('2.0')) {
        match = vEng.contains('2.0');
      } else if (selected.contains('5.0')) {
        match = vEng.contains('5.0');
      } else {
        match = vEng.contains(selected);
      }
      if (!match) return false;
    }
    if (filter.modelQuery.trim().isNotEmpty) {
      final query = filter.modelQuery.trim().toLowerCase();
      final match =
          v.fullName.toLowerCase().contains(query) ||
          v.model.toLowerCase().contains(query) ||
          v.brand.toLowerCase().contains(query);
      if (!match) {
        return false;
      }
    }
    return true;
  }).toList();
});

// Navigation index constants for classic standard ordering
class NavIndex {
  static const int home = 0; // Ana Ekran (En başta)
  static const int rental = 1; // Araç Kiralama & Filtreleme
  static const int gps = 2; // Canlı GPS Araç Takip Haritası
  static const int payment = 3; // Ödeme & Rezervasyon
  static const int profile = 4; // Hesabım & Ayarlar (En sonda)
}

// Navigation Bottom Bar current tab index Notifier
class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => NavIndex.home; // Default to index 0 (Ana Ekran)

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(
  BottomNavIndexNotifier.new,
);
