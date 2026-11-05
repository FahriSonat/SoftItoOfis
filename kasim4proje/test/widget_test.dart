import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_7/models/bildirim_modeli.dart';
import 'package:flutter_application_7/widgets/bildirim_listesi_karti.dart';
import 'package:flutter_application_7/widgets/gorsel_yukleme_karti.dart';

void main() {
  group('BildirimModeli Testleri', () {
    test('BildirimModeli doğru değerlerle oluşturulur', () {
      final now = DateTime.now();
      final bildirim = BildirimModeli(
        id: '123',
        baslik: 'Test Başlık',
        icerik: 'Test İçerik',
        tarih: now,
        okunduMu: false,
      );

      expect(bildirim.id, '123');
      expect(bildirim.baslik, 'Test Başlık');
      expect(bildirim.icerik, 'Test İçerik');
      expect(bildirim.tarih, now);
      expect(bildirim.okunduMu, isFalse);
    });

    test('copyWith metodu alanları doğru günceller', () {
      final bildirim = BildirimModeli(
        id: '1',
        baslik: 'İlk',
        icerik: 'İçerik',
        tarih: DateTime(2026, 11, 5),
      );

      final guncel = bildirim.copyWith(okunduMu: true, baslik: 'Yeni');
      expect(guncel.okunduMu, isTrue);
      expect(guncel.baslik, 'Yeni');
      expect(guncel.icerik, 'İçerik');
    });
  });

  group('GorselYuklemeKarti Widget Testleri', () {
    testWidgets('Görsel seçilmediğinde varsayılan arayüzü gösterir', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GorselYuklemeKarti(
              secilenDosya: null,
              yuklenenUrl: null,
              yuklenmeOrani: 0.0,
              yukleniyorMu: false,
              onGaleridenSec: () {},
              onKameradanCek: () {},
              onBulutaYukle: () {},
            ),
          ),
        ),
      );

      expect(find.text('Firebase Medya Yükleyici'), findsOneWidget);
      expect(find.text('henüz bir görsel seçilmedi'), findsOneWidget);
      expect(find.text('Galeri'), findsOneWidget);
      expect(find.text('Kamera'), findsOneWidget);
    });

    testWidgets('Yükleme esnasında ilerleme yüzdesini gösterir', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GorselYuklemeKarti(
              secilenDosya: null,
              yuklenenUrl: null,
              yuklenmeOrani: 0.75,
              yukleniyorMu: true,
              onGaleridenSec: () {},
              onKameradanCek: () {},
              onBulutaYukle: () {},
            ),
          ),
        ),
      );

      expect(find.text('Yükleniyor: 75'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });

  group('BildirimListesiKarti Widget Testleri', () {
    testWidgets('Bildirim listesi boş olduğunda bilgilendirme mesajı gösterir', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BildirimListesiKarti(
              bildirimler: const [],
              token: 'test_token_123',
              konuyaAboneMi: false,
              onAboneDegisti: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('FCM Bildirim Merkezi'), findsOneWidget);
      expect(find.text('test_token_123'), findsOneWidget);
      expect(find.text('Henüz gelen bildirim yok'), findsOneWidget);
    });

    testWidgets('Bildirimler listelendiğinde başlık ve içerik gösterir', (WidgetTester tester) async {
      final bildirimler = [
        BildirimModeli(
          id: '1',
          baslik: 'Önemli Duyuru',
          icerik: 'Ders saat 14:00te başlayacaktır.',
          tarih: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BildirimListesiKarti(
              bildirimler: bildirimler,
              token: null,
              konuyaAboneMi: true,
              onAboneDegisti: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Önemli Duyuru'), findsOneWidget);
      expect(find.text('Ders saat 14:00te başlayacaktır.'), findsOneWidget);
      expect(find.text('tüm sınıf yayını aktif'), findsOneWidget);
    });
  });
}
