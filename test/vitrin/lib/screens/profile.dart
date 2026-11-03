import 'package:flutter/material.dart';
import '../controller/sepet_controller.dart';

/// Kullanıcı Profili sekmesini temsil eden StatelessWidget ekranı.
/// Kullanıcının sepeti sıfırlamasını sağlar.
class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Profil sayfasının üst başlığı
      appBar: AppBar(
        title: const Text('Kullanıcı Profili'),
      ),
      // Sayfa ortasında sepeti sıfırlama butonu
      body: Center(
        child: TextButton(
          onPressed: () {
            // Sepet kontrolcüsündeki ürün sayısını sıfırlar (0 yapar).
            // ValueNotifier dinleyicisi otomatik olarak arayüzdeki sayacı 0'a çeker.
            SepetKontrolu.ornek.sepetiSifirla();
          },
          child: const Text('Sepeti Temizle (0 Yap)'),
        ),
      ),
    );
  }
}
