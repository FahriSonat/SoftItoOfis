import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'; as http

class UrunModel {
  final int id;
  final String baslik;
  final double fiyat;
  final String resimUrl;
  final String kategori;

  const UrunModel({
    required this.id,
    required this.baslik,
    required this.resimUrl,
    required this.fiyat,
    required this.kategori,
  });

  factory UrunModel.fromJson(Map<String, dynamic> json) {
    return UrunModel(
      id:json['id'] as int? ?? 0,
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      resimUrl: json['image'] as String? ?? '',
      kategori: json['category'] as String? ?? 'Genel',
    );
  }
}

abstract class IUrunServisi {
  Future<List<UrunModel>> UrunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi {
  static const String _base_url="https://fakestoreapi.com/products";
  @override
  Future<List<UrunModel>> urunleriGetir() async{
    try{
      final yanit = await http 
      .get(Uri.parse(_base_url))
      .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Ağ Zaman aşımına uğradı.');
        },
      );
      if(yanit.statusCode == 200){
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;

        return hamListe.map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Sunucu Hatası: ${yanit.statusCode}');
        }
    }catch (e) {
      print('Ağ hatası:$e');
      rethrow;
      }
  }
}