import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/app_providers.dart';
import '../features/gps/presentation/gps_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/payment/presentation/payment_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/rental/presentation/rental_screen.dart';

class MainNavigationScaffold extends ConsumerWidget {
  const MainNavigationScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      PaymentScreen(), // Index 0: Ödeme (kart bilgileri, ödeme & kiralama yükümlülükleri)
      RentalScreen(), // Index 1: Araç Kiralama (Orta butonun solu!)
      HomeScreen(), // Index 2: Ana Ekran (TAM ORTA BUTON!)
      ProfileScreen(), // Index 3: Hesabım (Orta butonun sağı!)
      GpsScreen(), // Index 4: Canlı GPS Harita (Son ekran!)
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(index);
        },
        destinations: const [
          // 0: Ödeme Ekranı (Sol Baştaki Buton)
          NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Ödeme',
            tooltip: 'Ödeme ve Rezervasyon',
          ),
          // 1: Araç Kiralama Ekranı (Orta Butonun Solu)
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car),
            label: 'Kiralama',
            tooltip: 'Araç Kiralama ve Filtreler',
          ),
          // 2: Ana Ekran (TAM ORTA BUTON)
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Ekran',
            tooltip: 'Ana Sayfa',
          ),
          // 3: Hesabım Ekranı (Orta Butonun Sağı)
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hesabım',
            tooltip: 'Hesabım ve Ayarlar',
          ),
          // 4: Canlı GPS Haritası (Son Ekran)
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Harita (GPS)',
            tooltip: 'Canlı Araç Takip Haritası',
          ),
        ],
      ),
    );
  }
}
