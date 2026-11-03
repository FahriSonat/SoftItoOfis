import 'dart:convert';
import 'package:http/http.dart' as http;

/// FakeStore API'den çekilen ürün verilerini modelleyen sınıf.
class UrunModel {
  /// Ürün ID'si
  final int id;

  /// Ürün başlığı / adı
  final String baslik;

  /// Ürünün fiyatı
  final double fiyat;

  /// Ürünün görsel adresi (URL)
  final String resimUrl;

  /// Ürünün kategorisi
  final String kategori;

  /// Değişmez (immutable) yapıcı metot
  const UrunModel({
    required this.id,
    required this.baslik,
    required this.resimUrl,
    required this.fiyat,
    required this.kategori,
  });

  /// Gelen JSON haritasını (`Map<String, dynamic>`) UrunModel nesnesine dönüştüren fabrika metot.
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id: json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? '',
      kategori: json['category'] as String? ?? 'Genel',
    );
  }
}

/// Ürün servisi arayüzü (Interface / Soyut sınıf)
abstract class IUrunServisi {
  /// Ürünleri getiren asenkron metot tanımı
  Future<List<UrunModel>> urunleriGetir();
}

/// FakeStore API üzerinden gerçek ağ isteği atan servis implementasyonu
class CanliApiUrunServisi implements IUrunServisi {
  /// İstek atılacak endpoint URL adresi
  static const String _baseUrl = "https://fakestoreapi.com/products";

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      // API'ye GET isteği atılır ve 10 saniye zaman aşımı (timeout) tanımlanır
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Ağ Zaman aşımına uğradı.');
        },
      );

      // Başarılı HTTP 200 yanıtı durumunda JSON decode edilir
      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;

        // Ham liste elemanları UrunModel.fromJson ile nesneye çevrilip liste olarak döndürülür
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu Hatası: ${yanit.statusCode}');
      }
    } catch (e) {
      print('Ağ hatası: $e');
      rethrow;
    }
  }
}
