import 'package:flutter/material.dart';

class BildirimListesiKarti extends StatelessWidget {
  final dynamic bildirimler;
  final String token;
  final bool konuyaAboneMi;
  final Function(bool) onAboneDegisti;

  const BildirimListesiKarti({
    super.key,
    required this.bildirimler,
    required this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.notifications, color: Colors.blue),
                SizedBox(width: 8),
                Text("Bildirim Kartı İçeriği"),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Bildirim Başlığı",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText(
                token ?? 'token alınıyor',
                style: const TextStyle(fontSize: 14),
              ),  
            ),
            const SizedBox(height: 14),
            Text(
              'Gelen Bildirimler: (${bildirimler.length})',
              style: const TextStyle
              (
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(0, 5,249, 253),

              )
            )
          : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bildirimler.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final bildirim = bildirimler[index];
              return ListTile(
                title: Text(bildirim['title'] ?? 'Başlık yok'),
                subtitle: Text(bildirim['body'] ?? 'İçerik yok'),
              );
            },
          )
          ],
        ),
      ),
    );
  }
}