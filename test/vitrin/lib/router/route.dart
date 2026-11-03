import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/anakasa.dart';
import '../screens/profile.dart';
import '../screens/vitrin.dart';

/// Uygulamanın tüm sayfa rotalarını, hiyerarşisini ve başlangıç konumunu yöneten GoRouter yapılandırması.
final GoRouter uygulamaRotalari = GoRouter(
  // Uygulama ilk açıldığında doğrudan yönlendirilecek varsayılan rota
  initialLocation: '/vitrin',

  // Rotalar listesi
  routes: [
    // ShellRoute: Alt sayfalar değiştikçe dış çerçeveyi (AnaKasaEkrani / BottomNavigationBar) koruyan sarmalayıcı rota
    ShellRoute(
      // Ortak çerçevenin builder metodu: child parametresi o anki alt rotanın ekranını (Vitrin veya Profil) taşır
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnaKasaEkrani(ekranGovdesi: child);
      },

      // Ana çerçevenin içerisinde değişecek olan alt sayfalar
      routes: [
        // '/vitrin' rotası -> VitrinEkrani widget'ını açar
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),

        // '/profil' rotası -> ProfilEkrani widget'ını açar
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);
