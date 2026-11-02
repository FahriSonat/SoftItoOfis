import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

class MockUrunServisi implements IUrunServisi {
  final List<Urun> _urunDeposu = const [
    Urun(
      id: 1,
      baslik: "Macbook M5 Pro Laptop",
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
      fiyat: 179999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 5,
    ),
    Urun(
      id: 2,
      baslik: "iPhone 18 Pro Max",
      aciklama: "iPhone 18 Pro Max. Tıpkı iPhone 17 gibi, hem iPhone'larda hem de akıllı saatlerde kullanılan daha dayanıklı titanyumdan üretildi. Ayrıca iPhone 18 Pro Max, iPhone 17 Pro'dan daha fazla pil ömrü, daha güçlü bir kamera sistemi ve yeni kişiselleştirme seçenekleriyle geliyor.",
      fiyat: 1499999.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 7,
    ),

    Urun(
      id: 3,
      baslik: "Bluetooth Kulaklık",
      aciklama: "Aktif gürültü engelleme özellikli, uzun pil ömürlü kablosuz kulaklık.",
      fiyat: 3299.00,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 15,
    ),
    Urun(
      id: 4,
      baslik: "Kışlık Yün Kazak",
      aciklama:
          "Soğuk kış günleri için ideal, sıcak tutan %100 yün örme kazak.",
      fiyat: 899.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.giyim,
      stokAdedi: 25,
    ),
    Urun(
      id: 5,
      baslik: "Koşu Ayakkabısı",
      aciklama:
          "Hafif yapısı ve ergonomik tabanı ile rahat bir koşu deneyimi sunar.",
      fiyat: 2499.50,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 20,
    ),
    Urun(
      id: 6,
      baslik: "Güneş Gözlüğü",
      aciklama:
          "UV400 korumalı, polarize camlı şık yazlık unisex güneş gözlüğü.",
      fiyat: 549.90,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.aksesuar,
      stokAdedi: 40,
    ),
    Urun(
      id: 7,
      baslik: "Akıllı Saat",
      aciklama: "Adım sayar, nabız ölçer ve uyku takibi özellikli suya dayanıklı akıllı saat.",
      fiyat: 4199.00,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.elektronik,
      stokAdedi: 8,
    ),
    Urun(
      id: 8,
      baslik: "Deri Cüzdan",
      aciklama:
          "Çoklu kartlık bölmeli, minimal tasarımlı hakiki deri erkek cüzdanı.",
      fiyat: 450.00,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.aksesuar,
      stokAdedi: 50,
    ),
    Urun(
      id: 9,
      baslik: "Hakiki Deri Bot",
      aciklama: "Zorlu hava koşullarına dayanıklı, su geçirmez ve kaymaz tabanlı bot.",
      fiyat: 3899.99,
      resimUrl: "https://picsum.photos/400/400",
      kategori: Kategori.ayakkabi,
      stokAdedi: 12,
    ),
  ];

  @override
  Future<List<Urun>> tumUrunleriGetir() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return List.from(_urunDeposu);
  }

  @override
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (kategori == Kategori.hepsi) {
      return List.from(_urunDeposu);
    }
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  }


  @override
  Future<List<Urun>> adaGoreAra(String aramaMetni)async{
    await Future.delayed(const Duration(milliseconds: 300));
    if(aramaMetni.trim().isEmpty){
      return List.from(_urunDeposu);
    }

    //trim gereksiz boşlukları siler

    return _urunDeposu.where((urun){
      final baslikKucuk = urun.baslik.toLowerCase();
      final arananKucuk = aramaMetni.toLowerCase();
      return baslikKucuk.contains(arananKucuk);
    }).toList();
  }
}