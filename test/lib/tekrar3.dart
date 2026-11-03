import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Singleton tasarım deseniyle sepet durumunu tutan ve
/// ValueNotifier ile reaktif olarak dinlenebilen kontrol sınıfı.
class SepetKontrolu {
  /// Sınıfın tekil örneği (Singleton instance)
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  SepetKontrolu._dahili();

  /// Sepetteki ürün sayısını tutan reaktif ValueNotifier nesnesi
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  /// Ürün sayısını 1 artıran metot
  void sepeteEkle() {
    urunSayisi.value++;
  }

  /// Ürün sayısını sıfırlayan metot
  void sepetSifirla() {
    urunSayisi.value = 0;
  }
}

/// GoRouter sayfa rota yapılandırması
final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/vitrin', // Başlangıç rotası
  routes: [
    // ShellRoute: Alt çubuğu (BottomBar) sabit tutup içerideki sayfayı değiştiren sarmalayıcı
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnaKasaEkrani(ekranGovdesi: child);
      },
      routes: [
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);

/// Alt gezinme çubuğunu (NavigationBar) ve seçili ekranın gövdesini gösteren iskelet widget.
class AnaKasaEkrani extends StatelessWidget {
  final Widget ekranGovdesi;
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ekranGovdesi,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aktifIndexiBul(context),
        onDestinationSelected: (yeniIndeks) {
          if (yeniIndeks == 0) context.go('/vitrin');
          if (yeniIndeks == 1) context.go('/profil');
        },
        destinations: [
          const NavigationDestination(icon: Icon(Icons.store), label: 'Vitrin'),
          NavigationDestination(
            // ValueListenableBuilder: Tüm widget ağacını yeniden çizmeden
            // yalnızca rozet (Badge) içindeki sepet sayısını reaktif olarak günceller.
            icon: ValueListenableBuilder<int>(
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              builder: (context, sayi, child) {
                return Badge(
                  label: Text('$sayi'),
                  isLabelVisible: sayi > 0,
                  child: const Icon(Icons.person),
                );
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  /// Aktif rota URL'sine göre gezinme çubuğundaki seçili sekme dizinini (0 veya 1) bulur.
  int _aktifIndexiBul(BuildContext context) {
    final String konum = GoRouterState.of(context).uri.toString();
    if (konum.startsWith('/profil')) return 1;
    return 0;
  }
}

/// Vitrin sekmesi ekranı: Ürün ekleme butonu içerir.
class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Vitrin(ValueNotifier)')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // Sepete ürün ekler
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ürün ekle(+1)'),
        ),
      ),
    );
  }
}

/// Profil sekmesi ekranı: Sepeti sıfırlama butonu içerir.
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: Center(
        child: TextButton(
          onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
          child: const Text('Sepeti Temizle(0 yap)'),
        ),
      ),
    );
  }
}
