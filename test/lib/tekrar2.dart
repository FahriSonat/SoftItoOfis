import 'package:flutter/material.dart';

/// Flutter'da Row ve Column düzenlerinde (Layout) sıkça karşılaşılan
/// ekran taşma hatalarını (A overflowed by pixels / sarı-siyah şerit)
/// ve bunların Expanded/Flexible ile nasıl çözüldüğünü gösteren örnek ekran.
class HataliveDogruRow extends StatelessWidget {
  const HataliveDogruRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Row ve Layout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HATALI YAPI GÖSTERİMİ ---
            const Text(
              'Hatalı Yapı: A overflowed by *** pixels (sarı-siyah şerit)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 8),

            // Sınırlandırılmamış Row yapısı:
            // İçindeki metin uzadığında ekran genişliğini aşarsa taşma hatası (overflow) oluşur.
            Container(
              color: Colors.amber.shade100,
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Kısa Metin (Hata vermez ama uzarsa Render Patlar)'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- 2. DOĞRU YAPI GÖSTERİMİ ---
            const Text(
              'Doğru Yapı: Flexible ve Expanded ile sınırlandırılmıştır.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),

            // Doğru yapılandırılmış Row:
            // Expanded widget'ı metin kolonunu kalan tüm boşluğa sınırlar.
            // Bu sayede metin ne kadar uzun olursa olsun alt satıra geçer ve taşma yaşanmaz.
            const Row(
              children: [
                // Başarı durumunu simgeleyen yeşil ikon
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                SizedBox(width: 12),

                // Expanded: Satırda kalan yatay alanın tamamını kaplar ve taşmayı engeller
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Softito 4.Dönem Mobil Standartı',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Bu metin ne kadar uzun olursa olsun telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez.',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
