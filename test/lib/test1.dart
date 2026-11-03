// setState() bulunduğu State nesnesinin build() metodunu baştan aşağı tekrar tetikler.
// Scaffold, appbar, tabbar ve eğer varsa 20 tane container baştan hesaplanır.
// Bu yüzden sadece küçük bir parçanın (örneğin sayaç veya rozet) güncellenmesi gereken
// durumlarda ValueNotifier / ValueListenableBuilder tercih edilir.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Singleton tasarım deseni ile oluşturulan ve uygulama genelinde
/// sepet durumunu (ürün adedini) reaktif yöneten kontrol sınıfı.
class SepetKontrolu {
  /// Tekil örnek (Singleton instance)
  static final SepetKontrolu ornek = SepetKontrolu._dahili();
  SepetKontrolu._dahili();

  // default ürün sayısı = 0
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  // Ürün arttırma metodu
  void sepeteEkle() {
    urunSayisi.value++;
  }

  // Ürün sıfırlama metodu
  void sepetSifirla() {
    urunSayisi.value = 0;
  }
}

/// GoRouter sayfa rotalandırma nesnesi
final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/vitrin', // Başlangıç sayfası
  routes: [
    // ShellRoute: Alt sekmeleri sabit tutarken iç ekranı (body) dinamik değiştiren sarmalayıcı rota
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

/// Alt bar (NavigationBar) ve seçili ekranın gövdesini gösteren iskelet widget.
class AnaKasaEkrani extends StatelessWidget {
  // BLoC / ValueNotifier ile StatelessWidget içinde veri güncellenebilir.
  // Komple ekranı boyamadan (rebuild etmeden) güncelleme yapılabilir.
  // Sadece 1 veri değişiyor (yazı/sayı), widget'ın tamamı değişmez, tamamı yenilenmiyor -> StatelessWidget kullanılabilir.
  // StatelessWidget'da komple widget yenilenmez, StatefulWidget'ta ise setState tüm widget'ı yeniler.

  final Widget ekranGovdesi;
  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ekranGovdesi,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _aktifIndexiBul(context),
        onDestinationSelected: (yeniIndex) {
          if (yeniIndex == 0) {
            context.go('/vitrin');
          } else if (yeniIndex == 1) {
            context.go('/profil');
          }
        },
        destinations: [
          const NavigationDestination(
              icon: Icon(Icons.store), label: 'Vitrin'),
          NavigationDestination(
            // ValueListenableBuilder ile yalnızca rozet (Badge) yeniden çizilir
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

  /// URL yoluna bakarak alt barda hangi sekmenin aktif olduğunu hesaplar
  int _aktifIndexiBul(BuildContext context) {
    final String konum = GoRouterState.of(context).uri.toString();
    if (konum.startsWith('/profil')) return 1;
    return 0;
  }
}

/// Vitrin sekmesi ekranı
class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Vitrin (ValueNotifier)'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // Sepete ürün ekler
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete ürün ekle (+1)'),
        ),
      ),
    );
  }
}

/// Profil sekmesi ekranı
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı profili'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
          child: const Text('Sepeti Sıfırla (Stateless İçinden)'),
        ),
      ),
    );
  }
}
