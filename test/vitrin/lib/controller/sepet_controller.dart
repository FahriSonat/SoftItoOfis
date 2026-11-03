import 'package:flutter/material.dart';

/// Singleton tasarım deseni ile oluşturulmuş, uygulama genelinde sepet durumunu (ürün sayısını)
/// yöneten ve reaktif olarak dinlenebilmesini sağlayan kontrolcü sınıfı.
class SepetKontrolu {
  /// Singleton nesnesi: Uygulama boyunca tek bir `SepetKontrolu` örneği olmasını sağlar.
  static final SepetKontrolu ornek = SepetKontrolu._dahili();

  /// Sınıfın dışarıdan `new` veya varsayılan yapıcı ile tekrar üretilmesini engelleyen gizli (private) yapıcı.
  SepetKontrolu._dahili();

  /// Sepetteki anlık ürün sayısını tutan ve değer değiştikçe dinleyicilerini (ValueListenableBuilder vb.)
  /// otomatik olarak tetikleyen reaktif sayaç nesnesi.
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  /// Sepetteki ürün sayısını bir artıran metot.
  void sepeteEkle() {
    urunSayisi.value++;
  }

  /// Sepetteki ürün sayısını sıfırlayan metot.
  void sepetiSifirla() {
    urunSayisi.value = 0;
  }
}
