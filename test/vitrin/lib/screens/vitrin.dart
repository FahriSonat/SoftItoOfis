import 'package:flutter/material.dart';
import '../controller/sepet_controller.dart';

/// Vitrin sekmesini temsil eden StatelessWidget ekranı.
/// Kullanıcının sepete ürün eklemesini sağlar.
class VitrinEkrani extends StatelessWidget {
  const VitrinEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfanın üst başlığı
      appBar: AppBar(
        title: const Text('Canlı Vitrin (ValueNotifier)'),
      ),
      // Sayfanın ortasında yer alan buton
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // SepetKontrolu singleton nesnesindeki sepeteEkle metodunu çağırarak
            // ürün sayısını 1 artırır. Değer değiştiğinde alttaki profil sekmesindeki rozet (Badge) otomatik güncellenir.
            SepetKontrolu.ornek.sepeteEkle();
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ürün Ekle (+1)'),
        ),
      ),
    );
  }
}
