import 'package:cloud_firestore/cloud_firestore.dart';

/// Öğrenci verilerini temsil eden Model sınıfı.
/// Veritabanındaki her bir öğrenci dokümanını Flutter içinde
/// tip güvenli (type-safe) bir Dart nesnesine dönüştürmek için kullanılır.
class OgrenciModels {
  final String id; // Firestore'daki benzersiz doküman ID'si
  final String adSoyad; // Öğrencinin adı ve soyadı
  final String projeAdi; // Öğrencinin geliştirdiği projenin adı
  final int notu; // Öğrencinin aldığı not (0 - 100 arası)
  final DateTime kayitTarihi; // Verinin oluşturulduğu tarih ve saat

  // Kurucu metot (Constructor): Tüm alanların verilmesi zorunludur (required).
  const OgrenciModels({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  /// Firestore'dan gelen ham dokümanı (DocumentSnapshot) alıp
  /// OgrenciModels nesnesine dönüştüren fabrika (factory) metodu.
  factory OgrenciModels.fromFireStore(DocumentSnapshot doc) {
    // Doküman içerisindeki veriyi bir Map (anahtar-değer) olarak alıyoruz.
    // Eğer veri boşsa veya okunamazsa çökmemesi için boş map ({}) veriyoruz.
    final veri = doc.data() as Map<String, dynamic>? ?? {};

    // Not alanını güvenli şekilde int'e çeviriyoruz:
    // Firestore'da not hem sayı hem de metin ("85") olarak kaydedilmiş olsa dahi hata vermez.
    int parsedNot = 0;
    if (veri['notu'] is num) {
      parsedNot = (veri['notu'] as num).toInt();
    } else if (veri['notu'] is String) {
      parsedNot = int.tryParse(veri['notu'] as String) ?? 0;
    }

    // Kayıt tarihini güvenli şekilde DateTime nesnesine çeviriyoruz:
    // Firestore zaman damgalarını Timestamp türünde tutar.
    DateTime parsedTarih = DateTime.now();
    if (veri['kayitTarihi'] is Timestamp) {
      parsedTarih = (veri['kayitTarihi'] as Timestamp).toDate();
    }

    // Okunan ve güvenliği sağlanan verilerle yeni bir OgrenciModels nesnesi oluşturup dönüyoruz.
    return OgrenciModels(
      id: doc.id,
      adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci",
      projeAdi: veri['projeAdi'] as String? ?? "Henüz proje yok",
      notu: parsedNot,
      kayitTarihi: parsedTarih,
    );
  }
}
