import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/sepet_controller.dart';

/// ShellRoute'un gövde ve alt gezinme çubuğunu (BottomNavigationBar) tutan ana iskelet ekranı.
/// Sekmeler değiştikçe alt bar sabit kalır, sadece `ekranGovdesi` dinamik olarak değişir.
class AnaKasaEkrani extends StatelessWidget {
  /// O an seçili olan rotanın gösterilecek olan gövde widget'ı (VitrinEkrani veya ProfilEkrani)
  final Widget ekranGovdesi;

  const AnaKasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ortada o an aktif olan rotanın widget'ı gösterilir
      body: ekranGovdesi,

      // Ekranın altındaki modern Material 3 gezinme çubuğu
      bottomNavigationBar: NavigationBar(
        // URL konumuna bakarak o an hangi sekmenin seçili olduğunu belirler
        selectedIndex: _aktifIndexiBul(context),

        // Kullanıcı bir sekmeye tıkladığında çalışacak fonksiyon
        onDestinationSelected: (yeniIndex) {
          // 0. sekme seçildiyse /vitrin rotasına git
          if (yeniIndex == 0) context.go('/vitrin');
          // 1. sekme seçildiyse /profil rotasına git
          if (yeniIndex == 1) context.go('/profil');
        },

        // Gezinme çubuğundaki sekmeler listesi
        destinations: [
          // 1. Sekme: Vitrin
          const NavigationDestination(
            icon: Icon(Icons.store),
            label: 'Vitrin',
          ),

          // 2. Sekme: Profil (Sepet rozeti / Badge içerir)
          NavigationDestination(
            // ValueListenableBuilder: Sadece sepet sayısını dinler.
            // Sayı değiştiğinde bütün sayfayı değil, sadece bu ikondaki Badge rozetini yeniden çizer.
            icon: ValueListenableBuilder<int>(
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              builder: (context, sayi, child) {
                return Badge(
                  label: Text('$sayi'), // Rozette yazan sepet adedi
                  isLabelVisible: sayi > 0, // Ürün sayısı 0'dan büyükse rozeti göster, 0 ise gizle
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

  /// GoRouter'ın o anki aktif URL adresine bakarak alt barda hangi index'in seçili olması gerektiğini hesaplar.
  int _aktifIndexiBul(BuildContext context) {
    // Tarayıcı/uygulama içindeki anlık rota yolu (örneğin '/profil' veya '/vitrin')
    final String konum = GoRouterState.of(context).uri.toString();

    // URL '/profil' ile başlıyorsa 1. sekme (Profil), aksi takdirde 0. sekme (Vitrin) aktiftir
    if (konum.startsWith('/profil')) return 1;
    return 0;
  }
}
