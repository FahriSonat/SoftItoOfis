// Sealed sınıflar dışarıdan extend edilmez (yalnızca aynı kütüphanede genişletilebilir).
// Switch ifadesi içinde tüm alt sınıflar kapsanmak (tüketilmek) zorundadır, default gerekmez.
sealed class OdemeDurumu {}

/// Başarılı ödeme durumunu temsil eden sınıf.
/// Dart 3 'Record' tipi ile referans kodu ve tutar verisini bir arada tutar.
class OdemeBasarili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri;
  OdemeBasarili(this.veri);
}

/// Başarısız ödeme durumunu temsil eden sınıf.
/// Hatanın nedenini açıklayan bir metin tutar.
class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

/// Banka servislerinin uyması gereken soyut sözleşme (Interface).
abstract class IBankaServisi {
  /// Asenkron olarak ödeme işlemini başlatan metot.
  Future<OdemeDurumu> odeme({required double miktar});
}

/// Güvenlik kontrollerini sınıflara eklemek için kullanılan Mixin.
mixin GuvenlikDenetimiMixin {
  /// Token'ın boş olmadığını ve en az 32 karakter olduğunu doğrulayan metot.
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

/// İşlem adımlarını tarih ve saat ile loglayan Mixin.
mixin AuditLogMixin {
  /// Verilen mesajı anlık ISO 8601 zaman damgasıyla konsola basan metot.
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}

/// IBankaServisi arayüzünü uygulayan, GuvenlikDenetimiMixin ve AuditLogMixin özelliklerini alan servis sınıfı.
class GarantiBankasiServisi
    with GuvenlikDenetimiMixin, AuditLogMixin
    implements IBankaServisi {
  /// Banka API anahtarı (token)
  final String apiAnahtari;

  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odeme({required double miktar}) async {
    // 1. Adım: Mixin'den gelen metot ile token geçerliliği kontrol edilir
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Ödeme Reddildi. Geçersiz Api Anahtarı');
      return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token');
    }

    // 2. Adım: Banka sunucusu cevabı için 1 saniyelik gecikme simülasyonu
    await Future.delayed(const Duration(milliseconds: 1000));

    // 3. Adım: İşlem loglanır
    islemKaydet(
      '$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI',
    );

    // 4. Adım: Başarılı ödeme nesnesi ve oluşturulan referans kodu döndürülür
    return OdemeBasarili((
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      tutar: miktar,
    ));
  }
}

/// Dart 3 switch expression (desen eşleme) yapısını kullanarak
/// ödeme sonucunu analiz eden ve ekrana yazdıran fonksiyon.
void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  final mesaj = switch (durum) {
    OdemeBasarili b =>
      'Ödeme Başarılı. Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    OdemeBasarisiz h => 'Ödeme Başarısız. Gerekçe: ${h.hataNedeni}',
  };
  print(mesaj);
}
