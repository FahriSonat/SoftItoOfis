# Clean UI ve Reaktif State (ValueNotifier) Mimarisi Referans Kılavuzu

Bu kılavuz, Flutter projelerinde feature bazlı modüler geliştirme yapılırken uyulması gereken mimari kuralları ve standartları özetler.

---

## 1. Katmanlar ve Sorumluluklar

| Katman | Dosya Kalıbı | Temel Sorumluluk | İzin Verilenler | Yasaklar |
| :--- | :--- | :--- | :--- | :--- |
| **Model** | `<feature>_model.dart` | Saf veri modeli ve serileştirme | `immutable`, `copyWith`, `fromJson`, `toJson` | UI bağımlılığı, Mutable alanlar |
| **Controller** | `<feature>_controller.dart` | İş mantığı ve reaktif durum yönetimi | `ValueNotifier`, iş metotları, `dispose()` | `BuildContext`, UI kodu, `setState` |
| **Widget** | `<feature>_<component>.dart` | Tekrar kullanılabilir UI parçaları | `StatelessWidget`, `const` constructor, parametreler | State yönetimi, doğrudan ağ/veritabanı istekleri |
| **View** | `<feature>_view.dart` | Sayfa iskeleti ve ekran montajı | `StatelessWidget`, `ValueListenableBuilder`, `Scaffold` | Ağır `setState`, iş mantığı hesaplamaları |

---

## 2. Temel Kurallar ve Standartlar

### Kural 1: Asla Tek Dosyada Toplama
Her katman her zaman kendi alt klasöründe (`controllers/`, `models/`, `views/`, `widgets/`) bağımsız bir dosya olarak yer almalıdır.

### Kural 2: Reaktif Durum Yönetimi (ValueNotifier)
- Durum değişiklikleri doğrudan `ValueNotifier<T>` üzerinden bildirilir.
- Ekran düzeyinde `setState` yerine `ValueListenableBuilder<T>` kullanılır. Böylece yalnızca durumdan etkilenen widget ağacı yeniden çizilir.
- Controller yaşam döngüsü tamamlandığında `dispose()` çağrılarak bellek sızıntıları önlenir.

### Kural 3: Const Zorunluluğu
- Statik olan tüm widget ve veri tanımlarında `const` anahtar kelimesi zorunludur.
- Constructor metotları mümkün olduğunca `const` olarak tanımlanmalıdır.

### Kural 4: Değişmez (Immutable) Veri Modelleri
- Modeller `@immutable` olarak işaretlenmeli ve tüm alanlar `final` olmalıdır.
- Durum güncellemeleri mutasyon yerine `copyWith()` aracılığıyla yeni bir nesne örneği üreterek gerçekleştirilir.

---

## 3. Kod Üretici Script Kullanımı

Yeni bir özellik oluştururken `script/generate_feature.sh` scripti çalıştırılır:

```bash
# Proje kök dizininde veya script klasöründen:
./.agents/skills/script/generate_feature.sh <ozellik_adi>

# Örnek:
./.agents/skills/script/generate_feature.sh exercise
```

Bu script aşağıdaki dosya yapısını otomatik olarak üretir:
```text
lib/features/<ozellik_adi>/
├── controllers/<ozellik_adi>_controller.dart
├── models/<ozellik_adi>_model.dart
├── views/<ozellik_adi>_view.dart
└── widgets/<ozellik_adi>_card.dart
test/features/<ozellik_adi>/
└── <ozellik_adi>_controller_test.dart
```
