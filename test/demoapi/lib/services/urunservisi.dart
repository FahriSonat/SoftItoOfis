import '../models/urun.dart';

/// Ürün servisi işlemlerini tanımlayan soyut sözleşme (interface / abstract class).
/// Bu sınıfı uygulayan (implements eden) tüm servis sınıfları bu metotları zorunlu olarak doldurmalıdır.
abstract class IUrunServisi {
  /// API'den veya yerel veri kaynağından tüm ürünleri asenkron (Future) olarak listeleyen metot.
  Future<List<UrunModel>> urunleriGetir();

  /// Belirli bir ID'ye göre tek bir ürünü asenkron getiren metot.
  /// Ürün bulunamazsa veya hata oluşursa geriye `null` dönebilir.
  Future<UrunModel?> urunGetirById(int id);
}
