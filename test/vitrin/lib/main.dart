import 'package:flutter/material.dart';
// GoRouter ile tanımlanan sayfa rotalarının import edilmesi
import 'router/route.dart';

/// Vitrin uygulamasının ana başlangıç noktası
void main() {
  runApp(const BenimUygulamam());
}

/// Uygulamanın en üst seviyedeki ana widget'ı.
/// Klasik MaterialApp yerine GoRouter ile yönlendirme (routing) yapabilmek için `MaterialApp.router` kullanır.
class BenimUygulamam extends StatelessWidget {
  const BenimUygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vitrin & Sepet Uygulaması',
      theme: ThemeData(
        useMaterial3: true, // Modern Material 3 tasarım bileşenlerini aktif eder
        colorSchemeSeed: Colors.blue, // Uygulama renk paletini mavi tonundan üretir
      ),
      // Uygulamanın yönlendirme motoru olarak route.dart dosyasında oluşturulan GoRouter yapılandırması atanır
      routerConfig: uygulamaRotalari,
      debugShowCheckedModeBanner: false, // Hata ayıklama (DEBUG) bandını kapatır
    );
  }
}
