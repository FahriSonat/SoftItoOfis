/// FakeStore API'den veya harici kaynaktan gelen ürün verilerini temsil eden model sınıfı.
class UrunModel {
  /// Ürünün benzersiz kimlik numarası (ID)
  final int id;

  /// Ürünün başlığı / adı
  final String baslik;

  /// Ürünün satış fiyatı
  final double fiyat;

  /// Ürünün görsel bağlantı adresi (URL)
  final String resimUrl;

  /// Ürünün ait olduğu kategori adı
  final String kategori;

  /// Değişmez (immutable) ürün nesnesi oluşturan yapıcı metot (constructor)
  const UrunModel({
    required this.id,
    required this.baslik,
    required this.resimUrl,
    required this.fiyat,
    required this.kategori,
  });

  /// API'den gelen JSON haritasını (Map) Dart UrunModel nesnesine dönüştüren fabrika metodu (factory constructor)
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      // API'den gelen id int değilse veya null ise varsayılan olarak 0 atanır
      id: json['id'] as int? ?? 0,
      // API'deki 'title' alanı okunur, null ise 'İsimsiz Ürün' atanır
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // Fiyat int veya double gelebileceği için önce num türüne çevrilir, sonra toDouble() yapılır
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // 'image' alanından görsel URL'si alınır
      resimUrl: json['image'] as String? ?? '',
      // 'category' alanından kategori metni alınır
      kategori: json['category'] as String? ?? 'Genel',
    );
  }

  /// Dart nesnesini API'ye göndermek veya saklamak için JSON formatına (Map) dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': baslik,
      'price': fiyat,
      'image': resimUrl,
      'category': kategori,
    };
  }
}
