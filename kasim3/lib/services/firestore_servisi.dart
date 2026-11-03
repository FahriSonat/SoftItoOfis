import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/ogrenci_models.dart';

/// Firestore veritabanı işlemlerini (CRUD: Create, Read, Update, Delete)
/// yöneten servis sınıfı. Arayüz (UI) ile veritabanı arasındaki köprüdür.
class FirestoreOgrenciServisi {
  /// 'ogrenciler' koleksiyonuna referans veren getter (özellik).
  /// Doğrudan değişkene atamak yerine getter kullanıyoruz; böylece Firebase
  /// başlatılmadan önce gereksiz yere Firestore'a bağlanmaya çalışıp hata vermez.
  CollectionReference get _ogrencilerKoleksiyonu =>
      FirebaseFirestore.instance.collection('ogrenciler');

  /// 1. CREATE: Yeni bir öğrenci ekleme metodu.
  /// Firestore dokümana otomatik olarak benzersiz rastgele bir ID atar (.add).
  Future<void> ogrenciEkle({
    required String adSoyad,
    required String projeAdi,
    required int notu,
  }) async {
    try {
      await _ogrencilerKoleksiyonu.add({
        'adSoyad': adSoyad,
        'projeAdi': projeAdi,
        'notu': notu,
        // Sunucu saatini kaydediyoruz; kullanıcının telefon saati hatalı olsa bile doğru zamanı yazar.
        'kayitTarihi': FieldValue.serverTimestamp(),
      });
      print('Öğrenci Kaydedildi');
    } catch (e) {
      print('Öğrenci ekleme başarısız: $e');
      rethrow;
    }
  }

  /// 2. CREATE / UPDATE (Belirli ID ile):
  /// Otomatik ID yerine kendi belirlediğimiz bir ID (örn. TC No, Öğrenci No) ile kayıt yapar.
  /// SetOptions(merge: true) sayesinde varsa üzerine yazar, yoksa yeni oluşturur.
  Future<void> ogrenciIdileKaydet({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  }) async {
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad': adSoyad,
      'projeAdi': projeAdi,
      'guncellemeTarihi': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 3. READ: Tüm öğrencileri tek seferlik çeken metot (Future ile).
  /// Notu en yüksek olandan en düşüğe doğru sıralar (descending: true).
  Future<List<OgrenciModels>> tumOgrencileriGetir() async {
    try {
      final QuerySnapshot snapshot = await _ogrencilerKoleksiyonu
          .orderBy('notu', descending: true)
          .get();

      // Gelen her bir dokümanı OgrenciModels nesnesine dönüştürüp liste olarak döner.
      return snapshot.docs
          .map((doc) => OgrenciModels.fromFireStore(doc))
          .toList();
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
      return [];
    }
  }

  /// 4. UPDATE: Belirli bir öğrencinin notunu güncelleyen metot.
  /// Sadece değişen alanları ('notu' ve 'sonDuzenleme') günceller (.update).
  Future<void> ogrenciNotuGuncelle(String documanId, int yeniNot) async {
    await _ogrencilerKoleksiyonu.doc(documanId).update({
      'notu': yeniNot,
      'sonDuzenleme': FieldValue.serverTimestamp(),
    });
  }

  /// Geriye dönük uyumluluk için takma ad (alias) metot.
  Future<void> ogrennciNotuGuncelle(String documanId, int yeniNot) =>
      ogrenciNotuGuncelle(documanId, yeniNot);

  /// 5. DELETE: Belirli bir ID'ye sahip öğrenciyi veritabanından tamamen siler.
  Future<void> ogrenciSil(String documanId) async {
    await _ogrencilerKoleksiyonu.doc(documanId).delete();
    debugPrint('$documanId referanslı veri tamamen silindi');
  }
}
