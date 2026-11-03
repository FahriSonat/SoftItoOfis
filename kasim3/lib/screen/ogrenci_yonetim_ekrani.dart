import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ogrenci_models.dart';
import '../services/firestore_servisi.dart';

/// Öğrencilerin eklendiği, canlı listelendiği, güncellendiği ve silindiği ana ekran.
/// Dinamik veri girişi ve durum takibi olduğu için StatefulWidget kullanılmıştır.
class FirestoreYonetimEkrani extends StatefulWidget {
  const FirestoreYonetimEkrani({super.key});

  @override
  State<FirestoreYonetimEkrani> createState() => FirestoreYonetimEkraniState();
}

class FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  // Veritabanı işlemlerini yürütecek servis nesnemiz
  final FirestoreOgrenciServisi _servis = FirestoreOgrenciServisi();

  // Form alanlarındaki metinleri okumak ve temizlemek için kontrolcüler (Controllers)
  final TextEditingController _adSoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  /// Ekran kapatıldığında veya yok edildiğinde kontrolcüleri bellekten temizler (Memory Leak önlenir).
  @override
  void dispose() {
    _adSoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    super.dispose();
  }

  /// Yeni öğrenci kaydetme butonuna basıldığında çalışan fonksiyon.
  void _yeniOgrenciKaydet() {
    // 1. Firebase bağlantısının hazır olup olmadığını kontrol ediyoruz.
    if (Firebase.apps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Firebase bağlantısı henüz kurulu değil.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. Metin kutularından verileri alıp boşlukları kırpıyoruz (.trim).
    final adSoyad = _adSoyadKontrolcusu.text.trim();
    final proje = _projeKontrolcusu.text.trim();
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

    // 3. Basit doğrulama (Validation): İsim veya proje adı boş bırakılamaz.
    if (adSoyad.isEmpty || proje.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ad soyad ve proje adını giriniz')),
      );
      return;
    }

    // 4. Veritabanına öğrenciyi ekliyoruz.
    _servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);

    // 5. Kayıt başarılı olunca giriş kutularını temizliyoruz.
    _adSoyadKontrolcusu.clear();
    _projeKontrolcusu.clear();
    _notKontrolcusu.clear();

    // 6. Kullanıcıya işlem başarılı bildirimi (SnackBar) gösteriyoruz.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$adSoyad başarıyla kaydedildi')),
    );
  }

  /// Düzenle (kalem) ikonuna basıldığında açılan not güncelleme penceresi (AlertDialog).
  void _notGuncelleDialog(OgrenciModels ogrenci) {
    if (Firebase.apps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Firebase bağlantısı henüz kurulu değil.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Açılan pencerede kutunun içine öğrencinin mevcut notunu yazdırıyoruz.
    final TextEditingController notGuncelleKontrolcusu =
        TextEditingController(text: ogrenci.notu.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${ogrenci.adSoyad} - Not Güncelle"),
          content: TextField(
            controller: notGuncelleKontrolcusu,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "Yeni Not (0-100)",
              prefixIcon: Icon(Icons.edit_note),
            ),
          ),
          actions: [
            // İptal butonu: Pencereyi kapatır
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal"),
            ),
            // Güncelle butonu: Yeni notu kaydeder
            ElevatedButton(
              onPressed: () async {
                final yeniNot = int.tryParse(notGuncelleKontrolcusu.text.trim());
                if (yeniNot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Geçerli bir not giriniz')),
                  );
                  return;
                }

                // Servis üzerinden Firestore'daki dokümanı güncelliyoruz.
                await _servis.ogrenciNotuGuncelle(ogrenci.id, yeniNot);

                // Ekran hala açıksa pencereyi kapatıp bildirim gösteriyoruz.
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${ogrenci.adSoyad} notu güncellendi: $yeniNot'),
                    ),
                  );
                }
              },
              child: const Text("Güncelle"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFirebaseReady = Firebase.apps.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Firestore Ekranı"),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Column(
        children: [
          // Üst Kısım: Öğrenci Ekleme Form Alanı
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // 1. Öğrenci Adı Soyadı Input'u
                TextField(
                  controller: _adSoyadKontrolcusu,
                  decoration: const InputDecoration(
                    labelText: "Öğrenci Adı Soyadı",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),

                // 2. Yan Yana Alanlar: Proje Adı (Expanded) ve Not Alanı
                Row(
                  children: [
                    // Expanded: Proje adı kutusunun satırda kalan tüm genişliği kaplamasını sağlar.
                    Expanded(
                      child: TextField(
                        controller: _projeKontrolcusu,
                        decoration: const InputDecoration(
                          labelText: "Proje Adı",
                          prefixIcon: Icon(Icons.assignment),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Not Alanı: Sabit genişlikte (100 piksel) kutu
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _notKontrolcusu,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Not (0-100)",
                          prefixIcon: Icon(Icons.grade),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 3. Buluta Kaydet Butonu
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: _yeniOgrenciKaydet,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Buluta Kaydet"),
                ),
              ],
            ),
          ),
          const Divider(thickness: 2),

          // Alt Kısım: Canlı Öğrenci Listesi
          // Expanded: Listenin ekranın kalan alt kısmını kaplamasını sağlar.
          Expanded(
            child: !isFirebaseReady
                // Firebase henüz bağlanmadıysa bilgilendirici uyarı göster
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off, size: 64, color: Colors.orange),
                          SizedBox(height: 12),
                          Text(
                            "Firebase Henüz Başlatılmadı",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Projenizde Firebase ayarları tamamlandığında liste burada canlı olarak akacaktır.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                // Firebase hazırsa Firestore'u anlık canlı dinleyen StreamBuilder
                : StreamBuilder<QuerySnapshot>(
                    // snapshots(): Veritabanında bir değişiklik olduğunda (ekleme, silme, güncelleme)
                    // sayfayı yenilemeye gerek kalmadan anlık olarak ekrana yansıtır (Real-time).
                    stream: FirebaseFirestore.instance
                        .collection('ogrenciler')
                        .orderBy('notu', descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Durum 1: Hata varsa
                      if (snapshot.hasError) {
                        return Center(child: Text("Bulut hatası: ${snapshot.error}"));
                      }
                      // Durum 2: Veri bekleniyorsa (yükleniyor)
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Durum 3: Veri boşsa veya hiç kayıt yoksa
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text("Henüz bulutta kayıtlı öğrenci yoktur."),
                        );
                      }

                      // Durum 4: Veriler başarıyla geldiğinde ListView oluşturulur
                      final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: dokumanlar.length,
                        itemBuilder: (context, index) {
                          final doc = dokumanlar[index];
                          // Ham dokümanı model nesnemize çeviriyoruz
                          final ogrenci = OgrenciModels.fromFireStore(doc);

                          // Dismissible: Sağa/sola kaydırarak silme hareketi sağlar
                          return Dismissible(
                            key: Key(ogrenci.id), // Her elemanın benzersiz kimliği
                            direction: DismissDirection.endToStart, // Yalnızca sağdan sola kaydırma
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete_forever, color: Colors.white),
                            ),
                            // Kaydırılarak silindiğinde çalışacak işlem
                            onDismissed: (direction) {
                              _servis.ogrenciSil(ogrenci.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${ogrenci.adSoyad} buluttan silindi')),
                              );
                            },
                            child: ListTile(
                              // Sol taraftaki daire: Not aralığına göre renk alır (Yeşil/Turuncu/Kırmızı)
                              leading: CircleAvatar(
                                backgroundColor: ogrenci.notu >= 80
                                    ? Colors.green
                                    : (ogrenci.notu >= 50 ? Colors.orange : Colors.red),
                                child: Text(
                                  '${ogrenci.notu}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                ogrenci.adSoyad,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('Proje: ${ogrenci.projeAdi}'),
                              // Sağ taraftaki buton: Not güncelleme penceresini açar
                              trailing: IconButton(
                                onPressed: () => _notGuncelleDialog(ogrenci),
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
