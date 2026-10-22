---
name: build-denge-flutter-app
description: Denge pozitif ve negatif alışkanlık takip uygulamasını Flutter ile Android ve iOS için geliştirmek, test etmek ve teslim etmek için kullanılır. Web tabanlı veya genel amaçlı uygulama taleplerinde kullanılmaz.
---

# Denge Flutter Uygulamasını Geliştirme Becerisi

Bu beceri Antigravity’nin `project.md` ve `design.md` belgelerini çalışan, kalıcı veri kullanan ve Android/iOS üzerinde doğrulanan bir Flutter uygulamasına dönüştürmesi için bağlayıcı çalışma kurallarını içerir.

## 1. Başlamadan önce

Şu kaynakları tamamen oku:

1. `project.md` — kapsam, iş kuralları, veri modeli ve kabul kriterleri
2. `design.md` — Flutter tema, widget, ekran ve etkileşim kuralları
3. Repository içindeki mevcut talimat ve yapılandırmalar

Çelişki önceliği:

1. Kullanıcının son açık isteği
2. `project.md` ürün ve güvenlik kuralları
3. `design.md` deneyim ve görsel kuralları
4. Bu dosyadaki geliştirme yöntemi
5. Mevcut kod alışkanlıkları

Mevcut projeyi incelemeden paket, mimari veya dosya yapısı değiştirme. Kullanıcıya ait ilgisiz değişiklikleri koru.

## 2. Teslim hedefi

Sonuç yalnızca tıklanabilir bir prototip değil, şu özelliklere sahip Flutter uygulaması olmalıdır:

- Android ve iOS’ta çalışan,
- Riverpod ile öngörülebilir durum yöneten,
- GoRouter ile güvenli navigasyon sağlayan,
- çevrimdışı kayıtları Drift/SQLite içinde koruyan,
- Supabase ile kullanıcı izolasyonu ve senkronizasyon sağlayan,
- yerel bildirimleri zaman dilimine göre planlayan,
- pozitif ve negatif streak’leri farklı kurallarla hesaplayan,
- widget, birim ve entegrasyon testlerinden geçen,
- TalkBack/VoiceOver ile kullanılabilen.

Backend anahtarları veya harici servisler sağlanmamışsa uygulama sahte çevrimiçi başarı göstermemelidir. Repository arayüzü arkasında açıkça işaretlenmiş yerel/demo adaptörü kullanılabilir.

## 3. Flutter proje ilkeleri

- Dart null safety’den taviz verme.
- `BuildContext` nesnesini async boşluk sonrasında güvenlik kontrolü olmadan kullanma.
- Widget içinde veri tabanı, HTTP veya streak hesabı çalıştırma.
- Büyük ekranları küçük, anlamlı widget’lara böl; anlamsız tek satırlık parçalanma yapma.
- `const` yapıcıları uygun yerlerde kullan.
- Tema değerlerini widget içine sabit renk ve ölçü olarak yayma.
- Kullanıcı metinlerini merkezi yerelleştirme katmanına uygun tut.
- Platforma özel kodu servis/adaptör arkasında izole et.
- Android ve iOS davranış farklarını kullanıcı deneyimini bozmayacak şekilde ele al.

## 4. Önerilen klasör yapısı

```text
lib/
  app/
    app.dart
    bootstrap.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_spacing.dart
      app_theme_extensions.dart
  core/
    database/
    errors/
    notifications/
    security/
    sync/
    time/
    widgets/
  features/
    auth/
    onboarding/
    home/
    habits/
    streaks/
    journal/
    coping/
    calendar/
    badges/
    settings/
test/
integration_test/
```

Her feature ihtiyacına göre:

```text
feature/
  data/
  domain/
  presentation/
```

katmanlarını kullanır. Sırf mimari görünmesi için boş klasör oluşturma.

## 5. Bağımlılık sınırları

### Presentation

- `Widget`, `Screen`, Riverpod provider/notifier ve kullanıcı etkileşimleri
- Domain kullanım senaryolarını çağırır
- Drift veya Supabase istemcisini doğrudan çağırmaz

### Domain

- Entity, value object, repository sözleşmesi, streak stratejisi ve kullanım senaryosu
- Flutter UI paketlerine bağımlı olmaz
- Saf Dart olarak test edilebilir kalır

### Data

- Drift DAO, Supabase datasource, DTO/mapping ve repository uygulaması
- Domain modeline dönüşümü tek yerde yapar
- Ağ ve yerel hata türlerini anlamlı uygulama hatalarına çevirir

## 6. Durum yönetimi

- Riverpod provider’larını feature sınırlarında tut.
- Salt okunur türetilmiş durumu ayrı provider ile hesapla.
- Form alanlarını gereksiz global state’e taşıma.
- Async durumlarda loading, data, empty ve error açıkça ele alınmalıdır.
- Aynı isteği ekran rebuild’lerinde tekrar başlatma.
- Optimistic güncellemede hata halinde rollback ve kullanıcı mesajı sağla.
- Provider yaşam döngüsünü veri kaybına yol açmayacak biçimde seç.
- Testlerde repository ve saat servisini override edilebilir yap.

## 7. Navigasyon

GoRouter içinde route isimlerini merkezi tut. Ana kabuk `StatefulShellRoute` veya eşdeğer yapıyla üç sekmenin durumunu korumalıdır:

- `/negative`
- `/home`
- `/positive`

İkincil route örnekleri:

- `/habit/new`
- `/habit/:id`
- `/habit/:id/history`
- `/habit/:id/triggers`
- `/habit/:id/strategies`
- `/habit/:id/urge-support`
- `/habit/:id/restart`
- `/profile`
- `/settings`

Oturum gerektiren route’larda redirect kullan. Deep link ile açılan alışkanlığın kullanıcıya ait olduğunu repository/backend katmanında doğrula. Sistem geri hareketi kaydedilmemiş değişikliği sessizce kaybetmemelidir.

## 8. Veri ve repository kuralları

- Yerel kimlikler UUID benzeri kararlı değerler olmalıdır.
- `createdAt`, `updatedAt` ve `occurredAt` ayrıdır.
- Tarih-saat UTC saklanır; takvim hesabı kullanıcı zaman diliminde yapılır.
- Her yerel değişiklik `syncState` ve benzersiz operasyon kimliği taşır.
- Silme mümkünse önce arşiv/soft-delete olarak işlenir.
- Repository işlemleri kullanıcı kapsamı olmadan çalışmamalıdır.
- Supabase RLS politikaları client filtresinin yerine değil, yanına konur.
- Migration test edilmeden Drift şeması değiştirilmez.
- Seed/demo veri üretim hesabına yazılmaz.

## 9. Streak motoru

Streak hesabı saf Dart domain servisidir. Cihazın `DateTime.now()` çağrısına doğrudan bağlanmaz; test edilebilir `Clock` ve `TimeZoneService` alır.

Örnek sözleşme:

```dart
class StreakResult {
  final int value;
  final StreakUnit unit;
  final StreakStatus status;
  final DateTime? startedAt;
  final DateTime? nextEvaluationAt;
  final String reasonCode;
}
```

### Negatif strateji

- Başlangıç zamanı ile son kırılma zamanı arasındaki gerçek süreyi hesaplar.
- Aktif seri, kullanıcı kırılma bildirmedikçe devam eder.
- Kırılma eski dönemi kapatır; silmez.
- Söz verme yeni bir `StreakPeriod` açar.
- Görsel sayaç süreyi gösterir; depolanan veri her saniye güncellenmez.

### Pozitif strateji

- Günlük, seçili gün, haftalık sıklık ve aralık programlarını destekler.
- Plansız gün nötrdür.
- Hatırlatma bildirimi hedef sonucu değildir.
- Aynı periyottaki miktarlar toplanır.
- Hedef periyodu bitmeden `missed` sonucu üretmez.

### Zorunlu birim testleri

- üç ardışık günlük tamamlama,
- bir günlük kaçırma,
- seçili günler arasında plansız gün,
- haftalık hedef,
- aynı gün birkaç miktar kaydı,
- 23:59 ve 24:00 negatif seri,
- kırılma ve yeniden başlama,
- geçmiş kayıt düzeltme,
- aynı olayın iki kez işlenmesi,
- ay/yıl sınırı,
- yaz/kış saati,
- cihaz zaman dilimi değişimi.

## 10. Bildirim servisi

Yerel bildirim paketi doğrudan ekranlardan çağrılmamalı; `NotificationScheduler` adaptörü kullanılmalıdır.

- Android notification channel’ları anlamlı biçimde tanımlanır.
- Android sürümüne göre bildirim izni yönetilir.
- iOS izin diyaloğu, uygulama içi açıklamadan sonra gösterilir.
- Saatler timezone-aware planlanır.
- Zaman dilimi/program değişince gelecek bildirimler yeniden oluşturulur.
- Her reminder kararlı notification ID’ye sahip olur.
- Silinen/arşivlenen alışkanlığın bildirimleri iptal edilir.
- Sessiz saat ve bugün sessize alma uygulanır.
- Hassas kategoride nötr başlık/gövde kullanılır.
- Exact alarm gibi özel platform izinleri yalnızca gerçekten gerekliyse istenir.

## 11. Çevrimdışı senkronizasyon

1. Kullanıcı eylemi önce yerel transaction içinde kaydedilir.
2. UI yerel stream/provider üzerinden güncellenir.
3. Operasyon kuyruğa eklenir.
4. Bağlantı olduğunda Supabase’e idempotent biçimde gönderilir.
5. Başarıda sync durumu güncellenir.
6. Geçici hatada kontrollü retry/backoff uygulanır.
7. Kalıcı yetki veya doğrulama hatası kullanıcıya gösterilir.

Sonsuz agresif retry yapma. Oturum kapanırken başka kullanıcıya ait bekleyen kayıtları yeni oturuma taşımama.

## 12. Formlar ve doğrulama

- Form doğrulaması domain kurallarıyla uyumlu olmalıdır.
- Negatif süre/miktar/para kabul etme.
- Tekrarlanan reminder saatini engelle.
- Özel alışkanlıkta ölçüm türü ve program zorunludur.
- Başlangıç tarihi gelecekteyse açıkça planlı başlangıç olarak ele al veya engelle.
- Gönderme sırasında çift tıklama/çift kayıt oluşmasını önle.
- Kaydedilmemiş değişiklikte geri çıkış uyarısı göster.
- Hata mesajını yalnızca SnackBar’da değil ilgili alanın yanında göster.

## 13. Seri bozulması işlemi

Tek transaction veya tutarlı kullanım senaryosu içinde:

1. Kırılma `HabitEntry` kaydı oluştur.
2. Aktif `StreakPeriod` kaydını kapat.
3. En uzun seri sonucunu yeniden hesapla.
4. Turuncu yeniden başlama state’ini göster.
5. Tetikleyici/not/çözüm girişlerini isteğe bağlı kaydet.
6. Söz verildiğinde `RestartPledge` ve yeni `StreakPeriod` oluştur.
7. Bildirimleri yeni başlangıca göre planla.

Herhangi bir adım başarısızsa arayüz sahte başarı göstermemeli ve kullanıcının girdiği metin kaybolmamalıdır.

## 14. Zorlanıyorum akışı

- Önce kullanıcının favori çözümünü, sonra benzer tetikleyicide etkili yöntemi öner.
- Hazır öneriler güvenliği önceden değerlendirilmiş küçük eylemler olmalıdır.
- Geri sayım uygulama arka plana geçtiğinde `Ticker` sayımına değil gerçek bitiş zamanına dayanmalıdır.
- Uygulama tekrar açıldığında doğru kalan süre gösterilmelidir.
- Önce/sonra yoğunluk ve sonuç isteğe bağlı kaydedilir.
- İlaç, alkol ve kumar için profesyonel yardım bağlantısı erişilebilir olmalıdır.
- Yapay zekâ metni varsa güvenli sabit fallback bulunmalıdır.

## 15. Tema ve widget kuralları

- `ThemeData` ve gerekiyorsa `ThemeExtension` kullan.
- Negatif, pozitif ve restart paletlerini anlamsal token olarak tanımla.
- Hard-code `Color(...)`, padding ve radius tekrarlarından kaçın.
- `MediaQuery.textScaler` ile büyük metni test et.
- SafeArea ve ekran kesitlerini hesaba kat.
- `NavigationBar`, `Scaffold`, sheet ve dialog davranışları platformlarda doğrulanmalıdır.
- Ağır animasyon ve grafiklerde gereksiz rebuild önlenmelidir.
- Durum bilgisi renk yanında Semantics label ve görünür metin taşır.

## 16. Erişilebilirlik

- İkon butonlarına tooltip ve semantic label ekle.
- Özel çizilen ilerleme halkasına anlamlı Semantics değeri ver.
- Birbirine yakın eylemleri en az 48×48 dp dokunma alanıyla ayır.
- TalkBack ve VoiceOver odak sırası görsel sırayla aynı olmalıdır.
- Bottom sheet/dialog açılışında erişilebilir başlığa odaklan.
- Canlı negatif sayaç her saniye announce edilmemelidir.
- Reduce motion tercihinde animasyonlar kaldırılır veya sadeleştirilir.
- `textScaleFactor`/text scaler yüksekken kırpılmış metin bırakma.

## 17. Güvenlik ve hassas veri

- Supabase servis anahtarı uygulamaya gömülmez.
- Anon public anahtar kullanılsa bile RLS zorunludur.
- Tokenlar güvenli depoda tutulur.
- Şifre ve hassas not loglanmaz.
- Crash raporlarına serbest metin, alışkanlık adı ve ilaç adı eklenmez.
- Kullanıcı A’nın yerel verisi oturum kapanınca kullanıcı B’ye gösterilmez.
- Hesap silme hem backend hem yerel veriyi kapsar.
- Reçeteli ilaç bırakma/doz önerisi metinlerde, seed veride ve test fixture’larında bulunmaz.

## 18. Motivasyon dili

Kullan:

- `Bir an bütün emeğini silmez.`
- `Şimdi küçük bir adım seçebilirsin.`
- `Önceki serin kaydedildi; yeniden başlayabilirsin.`

Kullanma:

- `Yine başarısız oldun.`
- `İradeni göster.`
- `Bir daha asla yapmayacağına söz ver.`
- kesin sağlık veya başarı vaatleri.

## 19. Test planı

### Birim

- streak stratejileri,
- program/periyot hesapları,
- renk aşaması,
- zaman dilimi dönüşümleri,
- tahmini kazanç,
- doğrulama,
- repository mapping.

### Widget

- ana navigasyon sırası,
- alışkanlık kartı durumları,
- form hata mesajları,
- ilerleme halkası Semantics,
- turuncu yeniden başlama ekranı,
- büyük metin ölçeği,
- loading/empty/error durumları.

### Entegrasyon

- onboarding → alışkanlık oluşturma,
- pozitif kayıt → streak artışı,
- negatif kırılma → söz → yeni seri,
- tetikleyici → çözüm → Zorlanıyorum sonucu,
- çevrimdışı kayıt → uygulama yeniden açma → senkronizasyon,
- reminder oluşturma/güncelleme/iptal.

### Platform doğrulaması

- Android emulator veya cihazda debug ve release build,
- iOS simulator veya cihazda debug ve release build,
- bildirim izinleri,
- uygulama arka plan/ön plan geçişi,
- zaman dilimi değişimi,
- Android geri hareketi ve iOS geri kaydırma,
- TalkBack/VoiceOver temel akışı.

## 20. Zorunlu kalite komutları

Projede eşdeğer yapı varsa onu kullan; aksi halde teslim öncesinde en az:

```bash
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter test integration_test
flutter build apk --release
flutter build ios --release --no-codesign
```

çalıştır. iOS build yalnızca macOS/Xcode ortamında mümkündür; ortam desteklemiyorsa bunu açıkça bildir, başarılı olmuş gibi yazma.

## 21. Uygulama sırası

1. Flutter bootstrap, tema ve router
2. Drift şeması ve repository sözleşmeleri
3. Auth ve kullanıcı kapsamı
4. Üçlü navigasyon ve boş ekranlar
5. Alışkanlık CRUD ve programlar
6. Streak motoru ve testleri
7. Liste, detay ve kayıt akışları
8. Takvim, günlük ve çözümler
9. Zorlanıyorum ve yeniden başlama
10. Bildirim adaptörü
11. Senkronizasyon
12. Rozet, analiz ve erişilebilirlik
13. Release build ve son doğrulama

Statik sahte ekranların tamamlanmasını beklemeden her aşamayı çalışan dikey dilim olarak doğrula.

## 22. Tamamlanma koşulu

Bir özellik ancak:

- UI eylemi gerçek veriyi güncelliyorsa,
- veri uygulama yeniden açıldığında korunuyorsa,
- hata/loading/empty durumları varsa,
- erişilebilirlik bilgileri ekliyse,
- ilgili testleri geçiyorsa,
- Android ve iOS davranışı değerlendirilmişse

tamamlanmış sayılır.

Teslim raporu; geliştirilen özellikleri, mimariyi, kullanılan gerçek/demo servisleri, çalıştırılan komutları, build sonuçlarını, bilinen kısıtları ve çalıştırma adımlarını içermelidir.

## 23. Kaçınılacak sonuçlar

- React, web/PWA veya HTML/CSS tabanlı uygulama üretmek
- Widget’lara gömülü streak ve SQL mantığı
- Sadece bellekte tutulan kayıtlar
- Pozitif ve negatif alışkanlıkta aynı streak hesabı
- Hatırlatma kaçınca seriyi anında bozmak
- Plansız günü başarısız saymak
- Kırılmada geçmişi silmek
- Sahte bildirim veya senkronizasyon başarısı göstermek
- Hard-code renklerle tasarım sistemini bölmek
- TalkBack/VoiceOver etiketi olmayan özel widget
- Reçeteli ilaç bırakma önerisi
- Suçlayıcı motivasyon dili
- Test edilmemiş tarih ve zaman dilimi hesabı

Temel amaç; güvenli, yerel-first çalışan, doğru streak hesaplayan ve Android/iOS üzerinde gerçek kullanıcı akışları doğrulanmış bir Flutter uygulaması teslim etmektir.
