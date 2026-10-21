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
      HomeScreen(), // Index 0: Ana Ekran (Varsayılan ve en başta!)
      RentalScreen(), // Index 1: Araç Kiralama & Filtreler
      GpsScreen(), // Index 2: Canlı GPS Harita
      PaymentScreen(), // Index 3: Ödeme ve Rezervasyon
      ProfileScreen(), // Index 4: Hesabım ve Ayarlar
    ];

    return PopScope(
      canPop: currentIndex == NavIndex.home,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Eğer başka bir sekmedeyse fiziksel/sanal geri tuşuna basınca Ana Ekrana dönsün
        if (currentIndex != NavIndex.home) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(NavIndex.home);
        }
      },
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(bottomNavIndexProvider.notifier).setIndex(index);
          },
          destinations: const [
            // 0: Ana Ekran (Sol Baştaki Buton)
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Ana Ekran',
              tooltip: 'Ana Sayfa',
            ),
            // 1: Araç Kiralama Ekranı
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(Icons.directions_car),
              label: 'Kiralama',
              tooltip: 'Araç Kiralama ve Filtreler',
            ),
            // 2: Canlı GPS Haritası
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              selectedIcon: Icon(Icons.location_on),
              label: 'Harita (GPS)',
              tooltip: 'Canlı Araç Takip Haritası',
            ),
            // 3: Ödeme Ekranı
            NavigationDestination(
              icon: Icon(Icons.payment_outlined),
              selectedIcon: Icon(Icons.payment),
              label: 'Ödeme',
              tooltip: 'Ödeme ve Rezervasyon',
            ),
            // 4: Hesabım Ekranı
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Hesabım',
              tooltip: 'Hesabım ve Ayarlar',
            ),
          ],
        ),
      ),
    );
  }
}
