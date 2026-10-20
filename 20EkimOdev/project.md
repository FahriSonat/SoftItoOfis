# RotaRent — Flutter Araç Kiralama Uygulaması

## 1. Proje özeti

RotaRent; konum ve tarihe göre araç arama, filtreleme, araç detayı inceleme, rezervasyon oluşturma, favori ve rezervasyon yönetimi sunan bir mobil uygulamadır.

İlk sürüm Android ve iOS'u hedefler. Arayüz Türkçe, para birimi TRY, tarih biçimi `dd.MM.yyyy`, saat biçimi `HH:mm` olacaktır. Bu dosya ürün kapsamını ve teknik kabul kriterlerini tanımlar. Uygulama talimatları `skill.md`, görsel sistem `design.md` içindedir.

## 2. MVP kapsamı

- E-posta/parola ile kayıt, giriş, oturum geri yükleme ve çıkış.
- Alış/iade konumu ve tarih-saat seçerek araç arama.
- Fiyat, vites, yakıt, koltuk ve kategori filtreleri.
- Fiyat veya puana göre sıralama.
- Araç listesi, detayları ve favori işlemi.
- Şeffaf ücret dökümüyle rezervasyon oluşturma.
- Yaklaşan/geçmiş rezervasyonları görüntüleme.
- Açık, koyu ve sistem teması.
- Loading, data, empty ve error durumlarının tamamı.

MVP dışında: gerçek ödeme, ehliyet OCR, canlı harita, canlı destek, kurumsal panel ve çoklu dil. Bunlar için genişleme noktası bırakılabilir; çalışmayan buton veya sahte ekran eklenmez.

## 3. Roller ve ana akış

Misafir splash/session kontrolünden sonra giriş veya kayıt ekranına gider. Giriş yapmış kullanıcı:

1. Ana sayfada konum ve tarih seçer.
2. Sonuçları filtreler/sıralar.
3. Araç detayını açar ve favorileyebilir.
4. Rezervasyon formunu doğrular.
5. Ücret özetini onaylar ve başarı ekranını görür.
6. Rezervasyonlar, favoriler, profil ve tema ayarını yönetir.

## 4. Zorunlu teknoloji kararları

- Flutter stable ve null-safe Dart.
- Material Design 3.
- State yönetimi ve dependency injection: `flutter_riverpod`.
- Navigation ve auth redirect: `go_router`.
- Ağ istemcisi: `dio`; MVP varsayılanı aynı sözleşmeleri uygulayan fake servisler.
- Immutable model/değer eşitliği: `freezed`; JSON: `json_serializable`.
- Token/session: `flutter_secure_storage`.
- Tema ve zararsız tercihler: `shared_preferences`.
- Tarih/sayı biçimlendirme: `intl`.
- Paketlerde güncel Flutter stable ile uyumlu kararlı sürümleri kullan ve `pubspec.lock` dosyasını ekle.

## 5. Mimari

Feature-first katmanlı MVVM/Clean yaklaşımı zorunludur:

```text
presentation -> domain <- data
                    ^
                    |
                  core
```

### Presentation

Ekranlar, yeniden kullanılabilir widget'lar, route'lar ve ViewModel/Notifier sınıflarıdır. Widget yalnızca state render eder ve olayı ViewModel'e iletir. Widget içinde iş kuralı, HTTP/storage erişimi veya DTO dönüşümü bulunmaz.

### Domain

Flutter'dan bağımsız entity, repository sözleşmesi, use case ve iş kurallarıdır. Rezervasyon tutarı, tarih uygunluğu ve iptal edilebilirlik burada yaşar. Bu katman Flutter import etmez.

### Data

DTO, mapper, remote/local/fake data source ve repository implementasyonlarıdır. DTO presentation katmanına sızmaz. Teknik exception'lar anlamlı `Failure` tiplerine çevrilir.

### Core/App

Tema, router, ağ, storage adaptörleri, hata tipleri, formatter ve gerçekten ortak widget'lar. Feature'a özgü iş kuralı `core` içine taşınmaz.

## 6. Klasör yapısı

```text
lib/
  main.dart
  app/
    app.dart
    bootstrap.dart
    router/app_router.dart
    theme/
  core/
    constants/
    errors/
    extensions/
    network/
    storage/
    utils/
    widgets/
  features/
    auth/
    home/
    search/
    vehicle_detail/
    booking/
    favorites/
    profile/
```

Her işlevsel feature gerektiği kadar şu alt klasörleri kullanır:

```text
feature/
  data/
    datasources/
    dtos/
    mappers/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    pages/
    viewmodels/
    widgets/
```

Testler `test/unit`, `test/widget`, `test/golden` ve `integration_test` altında organize edilir.

## 7. Domain modeli

- **User:** id, fullName, email, phone?, avatarUrl?
- **AuthSession:** accessToken, refreshToken?, expiresAt, user.
- **Location:** id, name, city, address, latitude?, longitude?
- **Vehicle:** id, brand, model, year, category, imageUrls, dailyPrice, currency, transmission, fuelType, seatCount, luggageCount, rating, reviewCount, isAvailable, features, rentalCompany.
- **SearchCriteria:** pickupLocation, dropoffLocation, pickupAt, dropoffAt.
- **Booking:** id, userId, vehicle, criteria, status, dailyRate, dayCount, subtotal, serviceFee, insuranceFee, total, driverFullName, driverPhone, createdAt.
- **BookingStatus:** pending, confirmed, active, completed, cancelled.

Para kayan nokta ile tutulmaz; kuruş cinsinden `int` veya güvenilir decimal value object kullanılır. İade zamanı alıştan sonra, alış zamanı ise geçmişten sonra olmalıdır.

## 8. State yönetimi ve yaşam döngüsü

### State kapsamları

- **Ephemeral:** parola görünürlüğü, focus, animasyon gibi yalnız widget'ı ilgilendiren state; yerel state.
- **Screen:** arama, detay, form gönderimi; Riverpod `Notifier/AsyncNotifier`.
- **App:** auth session, tema ve favoriler; repository/provider tek doğruluk kaynağı.
- Türetilebilir değer ikinci mutable kopya halinde saklanmaz.

### Yaşam döngüsü kuralları

- `initState`: controller, FocusNode, animation controller ve subscription oluştur.
- `didChangeDependencies`: locale/tema/InheritedWidget bağımlılıklarına tepki ver.
- `didUpdateWidget`: parent'tan gelen değişiklikleri senkronize et.
- `build`: saf ve hızlıdır; API, storage, navigation ve state mutation içermez.
- `dispose`: TextEditingController, FocusNode, AnimationController, subscription ve timer kapatılır.
- Async dönüşte context/state öncesi `mounted/context.mounted` kontrol edilir.
- Ekran-sınırlı provider'lar `autoDispose`; cache yalnız bilinçli `keepAlive`.
- Arama girdisi 300–500 ms debounce edilir; eski istek iptal edilir/yok sayılır.

```text
Kullanıcı olayı -> Widget -> ViewModel -> UseCase -> Repository
-> DataSource -> immutable state -> Widget rebuild
```

## 9. Kimlik doğrulama

- Splash sırasında secure storage session okunur.
- Geçerli session `/home`, yoksa `/login`.
- Kontrol merkezi GoRouter redirect ile yapılır.
- Fake hesap: `demo@rotarent.com` / `Demo123!`; sadece fake/debug ortamında yardımcı metin olabilir.
- Parola loglanmaz veya preferences içine yazılmaz.
- Submit sırasında klavye kapanır, buton loading olur ve çift gönderim engellenir.
- 401 durumunda session temizlenip güvenli biçimde login'e dönülür.

## 10. Form ve validasyon

Tüm formlarda `Form`, benzersiz `GlobalKey<FormState>`, `TextFormField` ve merkezi test edilebilir validator'lar kullan.

### Giriş

- E-posta: trim, zorunlu, geçerli biçim.
- Parola: zorunlu, en az 8 karakter.

### Kayıt

- Ad soyad: trim, zorunlu, en az 2 karakter.
- Telefon: normalize edilmiş geçerli Türkiye numarası.
- Parola: en az 8 karakter, bir büyük, bir küçük harf ve rakam.
- Parola tekrarı eşleşmeli.
- KVKK/kullanım koşulları onayı zorunlu.

### Rezervasyon

- Sürücü adı, telefon, konum ve tarihler zorunlu.
- Geçmiş alış ve alıştan önce/eşit iade reddedilir.
- Submit: `validate()` -> normalize/save -> ViewModel command.
- Sunucu alan hatası doğru alanda, genel hata görünür hata paneli/SnackBar ile gösterilir.
- Submit sırasında alanlar ve ana buton güvenli biçimde devre dışıdır.
- Hassas parola global state'te tutulmaz; controller'lar dispose edilir.

## 11. Rotalar

```text
/splash
/login
/register
/home
/search
/vehicles/:vehicleId
/booking/:vehicleId
/booking/success/:bookingId
/bookings
/favorites
/profile
/settings/theme
```

Alt navigasyon: Ana Sayfa, Rezervasyonlar, Favoriler, Profil. Detay ve rezervasyon tam sayfa açılır. Bilinmeyen kimlikte hata ekranı ve geri dönüş eylemi gösterilir.

## 12. Veri ve hata davranışı

- En az 10 araç ve 4 konum içeren deterministik fake data.
- Farklı kategori, vites, yakıt ve fiyat kombinasyonları.
- Fake çağrılarda 400–900 ms gecikme.
- İlk loading'de skeleton/progress; boş beyaz ekran yok.
- Empty state filtre temizleme/arama değiştirme eylemi sunar.
- Error state kullanıcı dostu mesaj ve `Tekrar dene` içerir.
- Ham exception, stack trace ve status code kullanıcıya gösterilmez.
- Cache/retry politikasının sahibi repository'dir.

## 13. Erişilebilirlik ve kalite

- Dokunma hedefi minimum 48×48 dp.
- İkon-only butonlarda tooltip ve semantics.
- Text scale 200% seviyesinde ana akış kullanılabilir.
- Renk tek başına durum belirtmez.
- Doğru keyboard type, IME action ve autofill hint.
- Küçük ekran, uzun Türkçe metin ve klavye açık durumları test edilir.

## 14. Test stratejisi

- Unit: validator, ücret hesabı, tarih kuralları, use case, mapper ve repository hata dönüşümü.
- ViewModel: loading/success/empty/error ve double-submit koruması.
- Widget: login, araç kartı, filtre sheet, tema ve async state'ler.
- Navigation: auth redirect, logout ve deep link.
- Golden: home ve araç detayı light/dark.
- Integration: login -> arama -> detay -> rezervasyon -> başarı -> rezervasyonlar.

Bitiş kontrolü:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

## 15. Teslim kabul kriterleri

- `flutter run` ile ek manuel düzenleme olmadan açılır.
- Fake repository varsayılandır ve ana yolculuk tamamen çalışır.
- Presentation doğrudan Dio/storage kullanmaz.
- Zorunlu ekranlarda loading, empty, error ve başarı state'leri bulunur.
- Giriş, kayıt, arama ve rezervasyon validasyonları çalışır.
- Material 3 açık/koyu/sistem temaları anında değişir ve kalıcıdır.
- Butonlarda normal, pressed, focused, disabled ve loading davranışı vardır.
- Format, analyze ve test komutları hatasız geçer.
- README kurulum, çalıştırma, codegen, test ve fake hesabı açıklar.
