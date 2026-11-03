import 'package:cloud_firestore/cloud_firestore.dart';

class OgrenciModels {
  final String id;
  final String adSoyad;
  final String projeAdi;
  final int notu;
  final DateTime kayitTarihi;

  const OgrenciModels({
    required this.id,
    required this.adSoyad,
    required this.projeAdi,
    required this.notu,
    required this.kayitTarihi,
  });

  factory OgrenciModels.fromFireStore(DocumentSnapshot doc){
    final veri=doc.data() as Map<String, dynamic>? ?? {};

    return OgrenciModels(
      id:doc.id, 
      adSoyad: veri['adSoyad'] as String? ?? "İsimsiz Öğrenci",
      projeAdi: veri['projeAdi'] as String? ?? "Henüz proje yok", 
      notu: (veri['notu'] as num?)?.toInt() ?? 0, 
      kayitTarihi: (veri['kayitTarihi'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
  }
}

class FirestoreOgrenciServisi {
  final CollectionReference _ogrencilerKoleksiyonu = FirebaseFirestore.instance.collection('ogrenciler');

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
        'kayitTarihi': FieldValue.serverTimestamp(),
      });
      print('Öğrenci ');
    } catch (e) {
      print('');
    }
  }

  Future<void> ogrenciIdileKaydet({
    required String tcNo,
    required String adSoyad,
    required String projeAdi,
  }) async{
    await _ogrencilerKoleksiyonu.doc(tcNo).set({
      'adSoyad':adSoyad,
      'projeAdi':projeAdi,
      'guncellemeTarihi': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<OgrenciModels>> tumOgrencileriGetir() async{
    try{
      final QuerySnapshot snapshot=await _ogrencilerKoleksiyonu.orderBy('notu' , descending: true).get();
      return snapshot.docs.map((doc) => OgrenciModels.fromFireStore(doc)).toList();
    } catch (e) {
      print("Veri çekme hatası :$e");
      return[];
    }
  }

  Future<void> ogrennciNotuGuncelle(String documanId, int yeniNot) async {
    await _ogrencilerKoleksiyonu.doc(documanId).update({
      'notu': yeniNot,
      'sonDuzenleme': FieldValue.serverTimestamp(),
    });
  }

  Future<void> ogrenciSil(String documanId) async {
    await _ogrencilerKoleksiyonu.doc(documanId).delete();
    print('$documanId referanslı veri tamamen silindi');
  }
}