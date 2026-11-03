import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screen/ogrenci_yonetim_ekrani.dart';

/// Flutter uygulamasının başlangıç noktası (Giriş fonksiyonu).
void main() async {
  // Flutter widget ağacının başlatıldığından emin olunur.
  // Asenkron (async) başlatma işlemleri (örn. Firebase) yapılmadan önce çağrılması zorunludur.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase servislerini platforma özel ayarlarla (Android, Web, iOS vb.) başlatıyoruz.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Olası bir başlatma hatasında uygulamanın çökmemesi için hatayı konsola yazdırıyoruz.
    debugPrint("Firebase başlatılamadı: $e");
  }

  // Ana widget'ı ekrana çizdirerek uygulamayı başlatır.
  runApp(const SoftitoFirestoreUygulamasi());
}

/// Uygulamanın kök (root) widget'ı.
/// Temel tema, renkler ve açılış sayfasını belirler.
class SoftitoFirestoreUygulamasi extends StatelessWidget {
  const SoftitoFirestoreUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki 'DEBUG' bandını gizler
      title: "Cloud Firestore",
      theme: ThemeData(
        // Uygulamanın ana renk paletini belirler
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true, // Modern Material 3 tasarım dilini aktif eder
      ),
      // Uygulama ilk açıldığında gösterilecek ana sayfa
      home: const FirestoreYonetimEkrani(),
    );
  }
}
