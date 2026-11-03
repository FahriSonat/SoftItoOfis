import 'package:flutter/material.dart';
import 'models/urun.dart';
import 'services/apiurun.dart';

/// Flutter uygulamasının giriş noktası
void main() {
  runApp(const MyApp());
}

/// Uygulamanın kök (root) StatelessWidget'ı.
/// Tema, başlık ve başlangıç ekranını yapılandırır.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki 'DEBUG' bandını gizler
      title: 'Ürün Listesi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UrunEkrani(), // Uygulama açıldığında gösterilecek ilk ekran
    );
  }
}

/// API'den gelen ürünleri listeleyen dinamik (durumu değişebilen) StatefulWidget ekranı.
class UrunEkrani extends StatefulWidget {
  const UrunEkrani({super.key});

  @override
  State<UrunEkrani> createState() => _UrunEkraniState();
}

/// `UrunEkrani`'nın durum (State) yönetimi sınıfı.
/// API isteğini tetikler, yüklenme, hata ve veri listeleme durumlarını kontrol eder.
class _UrunEkraniState extends State<UrunEkrani> {
  /// API'den başarılı şekilde çekilen ürün nesnelerini tutan liste
  List<UrunModel> urunler = [];

  /// Verilerin henüz yüklenip yüklenmediğini takip eden bayrak (true ise döner çember görünür)
  bool yukleniyor = true;

  /// API veya ağ hatası oluştuğunda gösterilecek hata metni
  String? hataMesaji;

  @override
  void initState() {
    super.initState();
    // Ekran ilk kez çizilmeden önce API'den ürünleri çekmek için metot çağrılır
    urunleriYukle();
  }

  /// CanliApiUrunServisi kullanarak ürünleri asenkron olarak çeken ve arayüzü güncelleyen fonksiyon
  Future<void> urunleriYukle() async {
    try {
      // API servisine istek atılır ve ürün listesi beklenir
      final sonuc = await CanliApiUrunServisi().urunleriGetir();

      // Eğer kullanıcı veri yüklenirken sayfadan ayrıldıysa setState çağırma
      if (!mounted) return;

      // Gelen veriler state'e kaydedilir, yüklenme durumu kapatılır ve ekran yeniden çizilir
      setState(() {
        urunler = sonuc;
        yukleniyor = false;
        hataMesaji = null;
      });
    } catch (e) {
      // Sayfadan ayrılma kontrolü
      if (!mounted) return;

      // Hata durumunda yükleniyor kapatılır ve hata mesajı ekranda gösterilmek üzere kaydedilir
      setState(() {
        yukleniyor = false;
        hataMesaji = 'Ürünler yüklenemedi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfanın üst başlık çubuğu (AppBar)
      appBar: AppBar(
        title: const Text('Ürün Listesi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      // Gövde (Body): 3 farklı duruma göre farklı widget çizer:
      // 1. Durum: Veriler yükleniyorsa dairesel ilerleme çubuğu gösterilir
      body: yukleniyor
          ? const Center(
              child: CircularProgressIndicator(),
            )
          // 2. Durum: Hata oluştuysa ortada hata mesajı gösterilir
          : hataMesaji != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      hataMesaji!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              // 3. Durum: Veriler başarıyla geldiyse liste oluşturulur (ListView.builder)
              : ListView.builder(
                  itemCount: urunler.length, // Listedeki toplam eleman sayısı
                  itemBuilder: (context, index) {
                    final urun = urunler[index]; // O anki sıradaki ürün

                    return ListTile(
                      // Sol taraftaki ürün görseli (Ağdan yüklenir)
                      leading: Image.network(
                        urun.resimUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain, // Görseli oranlarını bozmadan sığdırır
                        // Görsel yüklenemezse veya URL geçersizse kırık ikon gösterilir
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image_not_supported);
                        },
                      ),

                      // Ürün başlığı
                      title: Text(
                        urun.baslik,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Uzun başlıklarda sonuna '...' koyar
                      ),

                      // Alt başlık: Kategori adı ve fiyat bilgisi
                      subtitle: Text(
                        '${urun.kategori} - ${urun.fiyat} \$',
                      ),
                    );
                  },
                ),
    );
  }
}
