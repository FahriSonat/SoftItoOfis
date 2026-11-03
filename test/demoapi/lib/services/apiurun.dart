import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/urun.dart';
import 'urunservisi.dart';

/// IUrunServisi arayüzünü (interface) uygulayan ve gerçek FakeStore REST API üzerinden
/// HTTP istekleri yaparak verileri çeken canlı servis sınıfı.
class CanliApiUrunServisi implements IUrunServisi {
  /// İstek atılacak ana API adresi
  static const String baseUrl = "https://fakestoreapi.com/products";

  /// Sunucu yanıt vermediğinde uygulanacak maksimum bekleme süresi (10 saniye)
  static const Duration _zamanAsimi = Duration(seconds: 10);

  /// FakeStore API'den tüm ürünleri HTTP GET isteği ile çeken asenkron metot.
  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      // Belirtilen adrese HTTP GET isteği gönderilir ve zaman aşımı süresi bağlanır
      final yanit = await http
          .get(Uri.parse(baseUrl))
          .timeout(
            _zamanAsimi,
            onTimeout: () {
              // 10 saniye içinde yanıt gelmezse zaman aşımı hatası fırlatılır
              throw Exception('Ağ zaman aşımına uğradı.');
            },
          );

      // HTTP 200 (OK) kodu geldiyse istek başarılıdır
      if (yanit.statusCode == 200) {
        // Gelen JSON metni Dart dinamik listesine dönüştürülür
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;

        // Listedeki her JSON nesnesi UrunModel.fromJson ile Dart modeline çevrilip listelenir
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        // 200 haricinde bir durum kodu (404, 500 vb.) gelirse hata fırlatılır
        throw Exception('Sunucu Hatası: ${yanit.statusCode}');
      }
    } catch (e) {
      // Hata durumunda konsola bilgilendirme basılır ve çağıran yere hata fırlatılır (rethrow)
      debugPrint('Ağ hatası: $e');
      rethrow;
    }
  }

  /// Belirli bir ID'ye sahip ürünü API'den çağıran metot (Örn: https://fakestoreapi.com/products/1)
  /// Ürün bulunamazsa veya hata alınırsa geriye `null` döner.
  @override
  Future<UrunModel?> urunGetirById(int id) async {
    try {
      // Ürün ID'si URL'in sonuna eklenir
      final uri = Uri.parse('$baseUrl/$id');

      // İstek gönderilir
      final yanit = await http.get(uri).timeout(_zamanAsimi);

      // Yanıt başarılı ise UTF-8 formatında çözülüp modele dönüştürülür
      if (yanit.statusCode == 200) {
        // Türkçe ve özel karakterlerin bozulmaması için bodyBytes UTF-8 ile decode edilir
        final cozulmusGovde = utf8.decode(yanit.bodyBytes);

        final Map<String, dynamic> jsonHaritasi =
            jsonDecode(cozulmusGovde) as Map<String, dynamic>;

        return UrunModel.fromJson(jsonHaritasi);
      } else {
        // Sunucu 200 dışında döndüyse null döndür
        return null;
      }
    } catch (hata) {
      // Hata oluşursa (ağ kopması vb.) null döndür
      return null;
    }
  }
}
