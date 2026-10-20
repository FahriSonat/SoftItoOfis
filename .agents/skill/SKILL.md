Antigravity Uygulama Talimatı — RotaRent

## Amaç

Bu repository'de `project.md` ve `design.md` şartlarına uyan, çalışan Flutter araç kiralama uygulamasını üret. Bu belge Antigravity için uygulama sözleşmesidir. Belirsizlikte en basit, test edilebilir ve genişletilebilir çözümü seç; zorunlu şartları atlama.

## Öncelik sırası

1. Kullanıcının doğrudan talebi.
2. `project.md` ürün ve kabul kriterleri.
3. `design.md` UI/UX kuralları.
4. Bu dosyadaki uygulama akışı.
5. Flutter/Dart resmi iyi uygulamaları.

## Değiştirilemez kurallar

- Flutter stable, null safety ve Material Design 3 kullan.
- Feature-first katmanlı mimariyi koru: presentation, domain, data.
- State/DI için Riverpod; navigation için GoRouter kullan.
- UI'dan repository/data source'a doğrudan erişme.
- Widget `build()` içinde side effect, API, navigation veya mutation yapma.
- İş kurallarını widget içine yazma.
- Her formda gerçek validasyon ve Türkçe hata metni kullan.
- Controller, focus node, subscription, timer ve animation controller'ları dispose et.
- Async callback sonrası context kullanmadan önce mounted kontrolü yap.
- Açık, koyu ve sistem temasını eksiksiz uygula.
- Ana akışı fake data ile tamamen çalıştır; boş callback/TODO ekranı bırakma.
- Generated dosyaları elle düzenleme; gerekli codegen komutunu çalıştır.
- Secret, gerçek token veya kişisel veri commit etme/loglama.

## Çalışma biçimi

Küçük ve doğrulanabilir adımlarla ilerle. Her aşamada ilgili analiz/testi çalıştır. Mevcut çalışan kodu topluca yeniden yazmak yerine katman sınırlarını koruyan değişiklikleri tercih et.

### Aşama 1 — Bootstrap

1. Flutter projesi yoksa mevcut klasörde oluştur; üç markdown dosyasını koru.
2. Android ve iOS hedeflerini hazırla.
3. Gerekli runtime/dev paketlerini ekle.
4. `main.dart` küçük kalsın; `ProviderScope` ve `bootstrap()` ile başlat.
5. En az `fake` ve ileride `remote` uygulanabilecek environment yapısı oluştur; varsayılan fake.
6. Global hata yakalama stratejisi kur; hassas veri loglama.

### Aşama 2 — Tasarım sistemi

1. `AppTheme` içinde açık/koyu `ThemeData` üret.
2. `ColorScheme.fromSeed` ve `ThemeMode.system/light/dark` yönetimini kur.
3. Tema tercihini `shared_preferences` ile kalıcılaştır.
4. `design.md` token'larını `ThemeExtension` veya merkezi immutable token sınıflarıyla uygula.
5. Ortak `AppButton`, `AppTextField`, `AppCard`, `AsyncValueView`, `EmptyState`, `ErrorState` oluştur.
6. Feature kodunda tema renklerini hard-code etme; `Theme.of(context)` kullan.

### Aşama 3 — Domain ve data

1. Entity, repository contract ve use case'leri oluştur.
2. DTO ile domain entity'yi ayır ve mapper kullan.
3. Fake auth, vehicle, booking ve favorites data source'larını kur.
4. Fake data deterministik olsun; testleri rastgele bozmasın.
5. Exception'ları typed/sealed `Failure` tiplerine dönüştür.
6. Repository'leri provider ile inject et; global mutable singleton oluşturma.

### Aşama 4 — Auth ve router

1. Splash/session restore akışını tamamla.
2. Login/register formlarını bütün validasyonlarla oluştur.
3. Session'ı secure storage üzerinden sakla/temizle.
4. GoRouter auth redirect'i tek merkezde yönet.
5. Login, logout ve session-expired testlerini ekle.

### Aşama 5 — Ana yolculuk

Şu sırayla, her ekranın loading/data/empty/error durumlarını tamamlayarak ilerle:

1. Home ve arama formu.
2. Arama sonuçları, sıralama ve filtre.
3. Araç detayı ve favori.
4. Rezervasyon formu ve ücret özeti.
5. Rezervasyon başarı ekranı.
6. Rezervasyon listesi/detayı.
7. Favoriler.
8. Profil ve tema ayarı.

### Aşama 6 — Kalite

1. Unit, provider/ViewModel ve widget testlerini yaz.
2. Kritik ana akış integration testi ekle.
3. Light/dark golden testleri ekle.
4. Semantics, tooltip, klavye ve 200% text scale kontrolü yap.
5. Küçük ekran, uzun Türkçe metin ve dark mode taşmalarını düzelt.
6. README'yi kurulum/çalıştırma/test bilgileriyle tamamla.

## Kod standartları

- Dosya/klasör `snake_case`, sınıf `UpperCamelCase`, değişken/metot `lowerCamelCase`.
- Public API için anlaşılır isim; gerektiğinde kısa DartDoc.
- Fonksiyonlar tek sorumlulukta; büyük ekranlar küçük widget'lara bölünür.
- Ortak widget veri/callback alır; repository/provider okuması sayfa/ViewModel sınırında kalır.
- Mümkün olduğunda `const` constructor.
- `dynamic`, gereksiz `!`, magic number ve feature içinde sabit renkten kaçın.
- Kullanıcı metinlerini localization-ready merkezi yapıda tut; widget'lara dağıtma.
- Para/tarih biçimini merkezi formatter ile üret.
- Loglar sanitize edilmiş ve debug odaklıdır.

## ViewModel sözleşmesi

Her ViewModel/Notifier:

- Immutable, açık ve test edilebilir state yayınlar.
- Niyet belirten metotlar sunar: `signIn`, `searchVehicles`, `toggleFavorite`, `createBooking`.
- Loading'i başlatır, sonucu state'e yazar ve Failure'ı taşır.
- Eşzamanlı duplicate submit'i engeller.
- Repository dışında HTTP/storage ayrıntısı bilmez.
- Fake repository ile bağımsız test edilebilir.

Örnek:

```dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.submitting() = LoginSubmitting;
  const factory LoginState.success(User user) = LoginSuccess;
  const factory LoginState.failure(Failure failure) = LoginFailure;
}
```

Riverpod `AsyncValue` daha doğal olduğunda kullanılabilir; loading/empty/error/success durumları yine açık olmalıdır.

## Widget yaşam döngüsü kontrolü

Bir `StatefulWidget` eklerken:

- Gerçekten yerel mutable state gerekiyor mu? Gerekmiyorsa `ConsumerWidget`.
- Controller/focus node `initState` içinde bir kez mi oluşuyor?
- Parent değeri değişebiliyorsa `didUpdateWidget` var mı?
- Context bağımlı işlem doğru lifecycle metodunda mı?
- `build` saf ve ucuz mu?
- Async dönüşte `mounted` kontrol ediliyor mu?
- Bütün kaynaklar `dispose` içinde kapatılıyor mu?
- Navigation/SnackBar side effect'i güvenli listener üzerinden mi çalışıyor?

## Form kontrolü

- Her alanın kalıcı label'ı vardır; yalnız hint kullanılmaz.
- `textInputAction`, `keyboardType`, `autofillHints` ve focus sırası doğrudur.
- Trim/normalize validasyon öncesi tutarlı uygulanır.
- Hata submit veya uygun etkileşimden sonra gösterilir.
- İlk hatalı alana focus verilir.
- Submit sırasında çift tıklama engellenir.
- Başarı/hata sonucu görünür biçimde bildirilir.
- Form controller'ları dispose edilir.

## Buton ve etkileşim sözleşmesi

- Ekranda yalnız bir baskın primary action.
- `FilledButton`: ana ilerleme/rezervasyon.
- `FilledButton.tonal`: orta önem.
- `OutlinedButton`: ikincil.
- `TextButton`: düşük önem/iptal.
- `IconButton`: yaygın ikon ve zorunlu tooltip.
- Loading'de genişlik değişmez; label yerine küçük progress ve semantics.
- Disabled neden belirsizse yardımcı metin göster.
- Destructive eylem açık ad, uygun renk ve gerekirse confirmation kullanır.
- Tap handler içinde uzun senkron iş çalıştırma.

## Test zorunlulukları

- Validator ve ücret/tarih kuralları unit test.
- Repository success/failure mapping test.
- ViewModel state transition test.
- Login, vehicle card, filter ve theme widget test.
- Auth redirect/navigation test.
- Ana akış integration test.
- Home ve vehicle detail için light/dark golden test.

Testler gerçek ağ, saat veya rastgele veriye bağımlı olmamalı; clock/data dependency inject edilmelidir.

## Her görev sonrası doğrulama

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Codegen değiştiyse önce:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Tamamlanmış sayılma koşulu

- Uygulama derlenir ve emülatör/cihazda açılır.
- Format, analyze ve test geçer.
- Değişen davranışın testi vardır.
- Loading, empty, error ve success görünür/erişilebilirdir.
- Light/dark kontrol edilmiştir.
- TODO, boş callback, geçici secret ve commented-out kod yoktur.
- README günceldir.

## Kaçınılacak anti-pattern'ler

- Tüm uygulamayı `main.dart` içine yazmak.
- Auth/tema/rezervasyonu global `setState` ile yönetmek.
- Widget içinde Dio/storage/JSON işlemi.
- DTO'yu doğrudan UI'da kullanmak.
- Route'ta yalnız geçici extra nesnesine bağımlı olmak.
- Hatayı yutan genel `catch`.
- Loading sırasında aktif submit butonu.
- Renk/radius/spacing'i ekranlarda tekrar hard-code etmek.
- Dispose edilmeyen controller/listener/timer.
- Testi geçirmek için ürün davranışını zayıflatmak.

