# Denge — Flutter Alışkanlık Takip Uygulaması

> Bu belge, Flutter ile geliştirilecek Denge mobil uygulamasının ürün kapsamını, iş kurallarını, ekranlarını, veri modelini ve kabul kriterlerini tanımlar. Uygulama Android ve iOS için hazırlanacaktır. Ajan çalışma kuralları `skill.md`, Flutter arayüz sistemi ise `design.md` içindedir.

## 1. Ürün özeti

Denge; kullanıcının pozitif alışkanlıklar kazanmasına ve negatif alışkanlıklardan uzak durmasına yardımcı olan, streak temelli bir mobil uygulamadır. Uygulama yalnızca günlük işaretleme yapmaz; zorlanma anlarını kaydetme, kişisel çözüm yöntemleri geliştirme, hatırlatma alma ve seri bozulduğunda destekleyici biçimde yeniden başlama özellikleri sunar.

İki temel alan bulunur:

- **Negatif alışkanlıklar:** Sağlıksız beslenme, alkol, sigara, kumar, oyun bağımlılığı, gereksiz ilaç kullanımı, sosyal medya bağımlılığı, alışveriş bağımlılığı ve özel hedefler.
- **Pozitif alışkanlıklar:** Sağlıklı beslenme, su içme, yürüyüş/koşu, spor, yüzme, yoga/pilates, kitap okuma, enstrüman çalma, resim/sanat, zekâ oyunları ve özel hedefler.

Negatif alışkanlıklarda streak, davranıştan uzak geçirilen gerçek süreyi; pozitif alışkanlıklarda kullanıcının belirlediği programa uygun tamamlanan periyotları ifade eder.

## 2. Ürün hedefi

- Zararlı davranıştan uzak geçirilen süreyi görünür ve motive edici hale getirmek.
- Pozitif alışkanlıklarda küçük ve sürdürülebilir hedefler oluşturmak.
- Kritik anlarda kullanıcıyı önceden belirlediği çözümlere yönlendirmek.
- Seri bozulmasını suçlama yerine öğrenme ve yeniden başlama anına dönüştürmek.
- Hatırlatma, takvim, istatistik ve rozetlerle devamlılığı desteklemek.
- Hassas sağlık ve bağımlılık verilerini güvenli biçimde saklamak.

## 3. Hedef platformlar

### Birincil hedef

- Flutter ile Android ve iOS mobil uygulaması
- Telefon ekranları için mobile-first tasarım
- Tabletlerde uyarlanabilir yerleşim

### İkincil hedef

- Mimari Flutter Web ve masaüstüne genişlemeye uygun olabilir; MVP tesliminin parçası değildir.
- Apple Health/HealthKit ve Android Health Connect entegrasyonu MVP sonrası eklenebilir.

## 4. Flutter teknoloji yığını

- **UI:** Flutter ve Material 3 tabanlı özel koyu tema
- **Dil:** Dart, null safety zorunlu
- **Durum yönetimi:** Riverpod
- **Navigasyon:** GoRouter
- **Model/serileştirme:** Freezed ve json_serializable benzeri tip güvenli yaklaşım
- **Yerel veri:** Drift/SQLite tabanlı repository
- **Backend:** Supabase Auth, PostgreSQL ve Row Level Security
- **Bildirim:** flutter_local_notifications benzeri adaptör
- **Zaman dilimi:** timezone ve cihaz zaman dilimi adaptörü
- **Güvenli saklama:** flutter_secure_storage
- **Test:** flutter_test ve integration_test

Paketlerin kesin sürümleri proje oluşturulurken güncel Flutter stable sürümüyle uyumlu olanlardan seçilmelidir. İş mantığı belirli bir pakete kilitlenmemelidir.

## 5. Kullanıcı deneyimi ilkeleri

1. Kullanıcı hiçbir ekranda utandırılmamalı veya korkutulmamalıdır.
2. Streak sıfırlansa bile geçmiş başarı ve en uzun seri korunmalıdır.
3. Hatırlatma kaçırılması, pozitif hedef periyodu bitmeden streak’i bozmamalıdır.
4. Negatif alışkanlık, kullanıcı bir kırılma kaydı oluşturana kadar ilerlemeye devam eder.
5. Renk tek bilgi kanalı olmamalı; ikon ve metin etiketi kullanılmalıdır.
6. Bildirim, not ve bağımlılık verileri hassas kabul edilmelidir.
7. Reçeteli ilacı bırakma veya doz değiştirme önerisi verilmemelidir.
8. Çevrimdışı kayıt desteklenmeli ve bağlantı geldiğinde güvenli biçimde eşitlenmelidir.

## 6. Ana navigasyon

Flutter `NavigationBar` veya eşdeğer uyarlanabilir bileşen üç hedef içerir:

1. **Negatif** — sol
2. **Ana Sayfa** — orta ve görsel olarak birincil
3. **Pozitif** — sağ

İkincil sayfalar:

- onboarding ve oturum,
- alışkanlık ekleme/düzenleme,
- pozitif ve negatif alışkanlık detayları,
- takvim ve geçmiş,
- Beni Zorlayanlar,
- Çözüm Yöntemlerim,
- Zorlanıyorum odak modu,
- seri bozulması ve söz verme,
- bildirim ayarları,
- profil, rozetler ve genel ayarlar.

Android geri hareketi ve iOS geri kaydırma davranışı desteklenmelidir. Kaydedilmemiş form varsa kullanıcı uyarılmalıdır.

## 7. Onboarding ve hesap

### 7.1. Karşılama

- Ürün iki cümleyle açıklanır.
- Kullanıcı kayıt olabilir veya giriş yapabilir.
- Ürün kararı uygunsa sınırlı misafir modu eklenebilir.

### 7.2. Hesap oluşturma

- E-posta, şifre ve gösterim adı
- Zaman dilimi cihazdan alınır, kullanıcı değiştirebilir.
- Yaş ve cinsiyet zorunlu değildir.
- Avatar nötr seçeneklerden kullanıcı tarafından seçilir.

### 7.3. İlk hedef

- Kullanıcı pozitif veya negatif hedef seçer.
- Hazır kategori ya da özel alışkanlık oluşturur.
- Hedef/program ve hatırlatmalar ayarlanır.
- Bildirim izni, yararı açıklandıktan sonra sistem diyaloğuyla istenir.

## 8. Ana sayfa

Ana sayfa şunları tek bakışta göstermelidir:

- gün ve kısa karşılama,
- bugünkü pozitif hedeflerin tamamlanma oranı,
- aktif negatif streak sayısı,
- yaklaşan hatırlatma,
- hızlı işlem gerektiren alışkanlıklar,
- kısa ve yargılamayan motivasyon mesajı,
- yeni alışkanlık için `+` eylemi.

Kartlara dokunmak detay sayfasını açar. Pozitif kartta hızlı kayıt; negatif kartta `Zorlanıyorum` eylemi bulunabilir.

## 9. Negatif alışkanlıklar

### 9.1. Kategoriler

- Sağlıksız beslenme
- Alkol
- Sigara
- Kumar
- Oyun bağımlılığı
- Gereksiz ilaç kullanımı
- Sosyal medya bağımlılığı
- Alışveriş bağımlılığı
- Özel negatif alışkanlık

### 9.2. Kurulum verileri

- alışkanlık adı ve kategori,
- bırakma/uzak durma başlangıç tarihi ve saati,
- isteğe bağlı önceki kullanım sıklığı,
- isteğe bağlı birim maliyeti,
- kritik gün/saatler,
- hatırlatma ve gizli bildirim tercihi.

### 9.3. Kart bilgileri

- mevcut uzak durma süresi,
- başlangıç zamanı,
- en uzun seri,
- ilerleme aşaması,
- varsa tahmini maddi veya zaman kazancı,
- `Zorlanıyorum` eylemi.

### 9.4. Negatif streak kuralı

- Seri kesin bir `startedAt` zamanında başlar.
- Süre saklanmaz; başlangıç ve bitiş zamanlarından türetilir.
- İlk 24 saatte saat/dakika, daha sonra gün ağırlıklı gösterim kullanılabilir.
- Kullanıcı `Seriyi bozdum` kaydı oluşturduğunda aktif dönem sona erer.
- Önceki dönem ve en uzun seri silinmez.
- Kullanıcının söz verip yeniden başlaması yeni dönem oluşturur.
- Yanlış kayıt düzenlenirse ilgili tarihten itibaren hesap yeniden yapılır.

### 9.5. Tahmini kazanımlar

Kullanıcı yeterli başlangıç verisi girdiyse:

- sigara: içilmeyen adet ve tahmini maddi tasarruf,
- alkol: tüketilmeyen birim ve tahmini kalori/maliyet,
- kumar/alışveriş: harcanmayan tahmini tutar,
- sosyal medya/oyun: geri kazanılan tahmini süre

gösterilebilir. Bunlar `Tahmini` etiketi taşır. Güvenilir tıbbi kaynak ve açık ürün kararı olmadan “kazanılan yaşam süresi” gösterilmez.

## 10. Pozitif alışkanlıklar

### 10.1. Kategoriler

- Sağlıklı beslenme
- Su içme
- Yürüyüş
- Koşu
- Fitness/spor
- Yüzme
- Yoga/pilates
- Kitap okuma
- Enstrüman çalma
- Resim/sanat
- Zekâ oyunları
- Özel pozitif alışkanlık

### 10.2. Program kuralları

- **Su içme:** Varsayılan günlük hedef; ml/litre ve çoklu hatırlatma.
- **Sağlıklı beslenme:** Varsayılan günlük hedef; öğün bazlı veya gün sonu değerlendirme.
- **Diğer alışkanlıklar:** Günlük, haftanın seçili günleri, haftalık sıklık veya belirli aralık.
- Kullanıcı hedef miktarı, süreyi, mesafeyi, adedi ya da tamamlandı durumunu seçebilir.
- Aynı gün içindeki birden fazla kayıt günlük toplamda birleştirilir.

### 10.3. Pozitif streak kuralı

- Günlük hedef tamamlanınca seri bir periyot artar.
- Plansız günler seriyi artırmaz veya bozmaz.
- Haftalık sıklık hedefi kullanıcının yerel haftası içinde değerlendirilir.
- Hatırlatmayı kaçırmak streak’i bozmaz.
- Hedef periyodu tamamlanmadan `kaçırıldı` durumu verilmez.
- Miktar ve süre hedefleri toplam değer hedefe ulaşınca tamamlanır.
- Geçmiş kayıt düzeltmesi streak ve istatistikleri yeniden hesaplatır.

### 10.4. Tür bazlı kayıtlar

- Kitap: kitap adı, toplam sayfa, okunan sayfa/dakika
- Koşu/yürüyüş: süre, mesafe, isteğe bağlı tempo ve kalori
- Spor/yüzme/yoga: aktivite türü, süre, isteğe bağlı kalori
- Su: ml/litre ve hızlı ekleme
- Sağlıklı beslenme: öğün, hedefe uygunluk, isteğe bağlı kalori/not
- Enstrüman/sanat: süre ve çalışma notu
- Özel alışkanlık: boolean, adet, süre, mesafe, hacim veya miktar

## 11. Alışkanlık detay sayfaları

Her iki tür için ayrı Flutter sayfaları veya aynı sözleşmeyi uygulayan tür özel bileşenler bulunur.

Ortak içerik:

- büyük streak/ilerleme halkası,
- aktif ve en uzun seri,
- program ve sonraki hatırlatma,
- haftalık/aylık takvim,
- kayıt geçmişi,
- istatistikler,
- notlar,
- Beni Zorlayanlar,
- Çözüm Yöntemlerim,
- düzenleme, duraklatma, arşivleme ve silme.

## 12. Beni Zorlayanlar günlüğü

Her kayıt şunları içerebilir:

- tarih ve saat,
- tetikleyici etiketleri,
- duygu/ihtiyaç,
- yoğunluk `1–5`,
- ortam veya bağlam,
- serbest not,
- kullanılan çözüm,
- çözüm sonrası yoğunluk.

Kayıtlar yalnızca ilgili kullanıcı tarafından erişilebilir olmalıdır.

## 13. Çözüm Yöntemlerim

Kullanıcı alışkanlık bazında çözüm kartları oluşturabilir:

- başlık,
- küçük eylem,
- tahmini süre,
- ilişkili tetikleyiciler,
- etkinlik puanı,
- favori durumu,
- kullanım sayısı.

Öneri sırası: favori çözüm → benzer tetikleyicide etkili çözüm → güvenli hazır öneri.

## 14. Zorlanıyorum akışı

Negatif alışkanlık detayından veya kartından açılır:

1. Kısa ve sakin motivasyon mesajı
2. Dürtüyü 2/5/10 dakika erteleme seçeneği
3. Kişisel çözüm veya güvenli küçük eylem seçimi
4. İsteğe bağlı geri sayım
5. Eylemin tamamlanması
6. Önce/sonra yoğunluk değerlendirmesi
7. Sonucun günlüğe kaydedilmesi

Örnek küçük eylemler: su içmek, kısa yürüyüş, nefes molası, telefonu başka odaya bırakmak veya güvenilen bir kişiye ulaşmak.

Alkol, kumar ve ilaç kategorilerinde profesyonel destek seçeneği görünür olmalıdır. Reçeteli ilaç için uygulama bırakma ya da doz değiştirme tavsiyesi vermez.

## 15. Seri bozulması ve söz verme

Kırılma kaydı sonrasında ilgili ekran turuncu yeniden başlama durumuna geçer:

- önceki seri ve emeği görünür kalır,
- yargılamayan motivasyon mesajı gösterilir,
- isteğe bağlı `Ne oldu?` notu alınır,
- tetikleyici ve sonraki çözüm seçilebilir,
- hazır söz veya özel söz yazılabilir,
- `Söz ver ve yeniden başla` yeni seri oluşturur,
- ekran alışkanlığın başlangıç rengine döner.

Kullanıcı söz vermeden uygulamadan çıkabilir. Uygulama kilitlenmez ve geçmiş veri silinmez.

## 16. Renk ilerleme kuralları

### Negatif

Kırmızı → mercan → amber → sarı-yeşil → yeşil.

Varsayılan eşikler: başlangıç, 1 gün, 3 gün, 7 gün, 14 gün, 30+ gün.

### Pozitif

Mavi → açık mavi → camgöbeği → turkuaz.

Varsayılan eşikler: başlangıç, 3, 7, 14 ve 30 başarılı periyot.

### Bozulmuş seri

Turuncu, geçici yeniden değerlendirme durumudur. Uygulamanın arka planları koyu, ana metinleri beyaz/açık gri olmalıdır.

## 17. Takvim, analiz ve rozetler

### Takvim

- Haftalık ve aylık görünüm
- Tamamlandı, kısmi, kaçırıldı, plansız ve kırılma durumları
- Bir güne dokunulduğunda günlük olay özeti
- Birden fazla alışkanlık için çoklu halka veya işaret

### Analiz

- 7/30 günlük başarı oranı
- mevcut ve en uzun seri
- toplam süre/miktar
- en sık tetikleyici
- en etkili çözüm
- yeterli veri yoksa açık boş durum

### Rozetler

- İlk Adım
- 7 Gün Güçlü
- 30 Periyot İstikrar
- Su Dostu
- Kitap Kurdu
- 100 km Yolcu
- Yeniden Başladım

Kazanılmış rozet, seri bozulduğunda geri alınmaz.

## 18. Bildirimler

- Günlük ve programlı alışkanlık hatırlatmaları
- Su için birden fazla günlük bildirim
- Sağlıklı beslenme/öğün hatırlatmaları
- Periyot sona ermeden nazik hatırlatma
- İsteğe bağlı günlük özet
- Sessiz saatler
- Erteleme ve bugün sessize alma
- Hassas alışkanlıklar için nötr bildirim metni

Bildirim planları cihazın yerel saat dilimine göre üretilmelidir. İzin reddedilirse uygulama çalışmaya devam eder. Zaman dilimi değişiminde gelecek bildirimler yeniden planlanır.

## 19. Çevrimdışı çalışma ve senkronizasyon

- Kullanıcı internet olmadan kayıt ekleyebilir ve not yazabilir.
- Yerel Drift veritabanı arayüzü besler.
- Değişiklikler senkronizasyon kuyruğuna alınır.
- Bağlantı geldiğinde Supabase ile eşitlenir.
- Her değişiklik benzersiz olay kimliği ve `updatedAt` taşır.
- Çakışmalar veri türüne göre çözülür; olay kayıtları birleştirilir, aynı nesne alanlarında güvenli son-güncelleme veya kullanıcı seçimi uygulanır.
- Bekleyen, başarılı ve hatalı senkronizasyon durumu görünür olmalıdır.

## 20. Flutter uygulama mimarisi

Önerilen feature-first yapı:

```text
lib/
  app/
    app.dart
    router.dart
    theme/
  core/
    database/
    notifications/
    sync/
    time/
    security/
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
```

Her feature mümkün olduğunda `data`, `domain` ve `presentation` sorumluluklarını ayırır. Widget’lar doğrudan SQLite veya Supabase çağrısı yapmaz.

## 21. Temel veri modelleri

### User

`id`, `displayName`, `email`, `avatar`, `timezone`, `locale`, `quietHours`, `createdAt`

### Habit

`id`, `userId`, `name`, `kind`, `category`, `iconKey`, `status`, `startAt`, `measurementType`, `targetValue`, `unit`, `scheduleType`, `scheduleConfig`, `privacyMode`, `createdAt`, `updatedAt`

### HabitEntry

`id`, `habitId`, `userId`, `entryType`, `value`, `unit`, `occurredAt`, `note`, `source`, `createdAt`, `updatedAt`, `syncState`

### StreakPeriod

`id`, `habitId`, `startedAt`, `endedAt`, `status`, `successfulPeriods`, `endReason`, `restartPledgeId`

### Reminder

`id`, `habitId`, `localTime`, `weekdays`, `enabled`, `neutralText`, `snoozeMinutes`, `notificationId`

### TriggerNote

`id`, `habitId`, `occurredAt`, `triggerTags`, `emotionTags`, `intensityBefore`, `intensityAfter`, `context`, `note`, `strategyId`

### CopingStrategy

`id`, `habitId`, `title`, `actionText`, `estimatedMinutes`, `triggerTags`, `effectivenessScore`, `isFavorite`, `timesUsed`

### RestartPledge

`id`, `habitId`, `previousStreakId`, `pledgeText`, `reflection`, `strategyId`, `committedAt`

### Badge/UserBadge

Rozet tanımı, koşul, eşik, seviye; kullanıcı rozeti, ilerleme ve kazanılma tarihi.

## 22. Streak motoru gereksinimleri

- UI’dan bağımsız, saf ve test edilebilir Dart servisleri kullanılmalıdır.
- Pozitif ve negatif hesaplama ayrı stratejiler olmalıdır.
- UTC saklama ve kullanıcı zaman diliminde takvim değerlendirmesi yapılmalıdır.
- Yaz/kış saati ve zaman dilimi değişimi test edilmelidir.
- Aynı olay iki kez işlendiğinde çift artış oluşmamalıdır.
- Geçmiş kayıt değiştiğinde sonuç yeniden hesaplanmalıdır.
- Sonuç; değer, birim, durum, başlangıç, sonraki değerlendirme zamanı ve gerekçe içermelidir.

## 23. Güvenlik ve etik

- Supabase RLS ile her kullanıcı yalnızca kendi kayıtlarına erişebilmelidir.
- Oturum tokenları güvenli depoda tutulmalıdır.
- Şifreler uygulama veritabanında saklanmamalıdır.
- Not ve bağımlılık içeriği analitik/log sistemine gönderilmemelidir.
- Hesap ve ilişkili veriler silinebilmelidir.
- Bildirim önizlemesinde hassas içerik gizleme seçeneği olmalıdır.
- Uygulama tanı, tedavi veya garanti sunmamalıdır.
- Reçeteli ilaç değişikliği için doktora/eczacıya danışma uyarısı gösterilmelidir.
- Kriz veya kendine zarar verme durumu standart motivasyon mesajıyla ele alınmamalıdır.

## 24. Erişilebilirlik

- Flutter Semantics kullanılmalıdır.
- Dokunma alanları en az 48×48 dp hedeflemelidir.
- Metin ölçeklendirmesinde düzen bozulmamalıdır.
- Renk dışında ikon ve durum metni kullanılmalıdır.
- Ekran okuyucu odağı modal ve sayfa geçişlerinde yönetilmelidir.
- Animasyon azaltma tercihi desteklenmelidir.
- Canlı sayaç her saniye ekran okuyucu tarafından duyurulmamalıdır.
- Kontrast WCAG AA seviyesini hedeflemelidir.

## 25. MVP kapsamı

MVP’de zorunlu:

- kayıt/giriş ve profil,
- üçlü ana navigasyon,
- pozitif/negatif alışkanlık CRUD,
- hazır ve özel kategoriler,
- iki ayrı streak hesabı,
- tür bazlı kayıt formları,
- renk aşamaları,
- detay, takvim ve geçmiş,
- Beni Zorlayanlar,
- Çözüm Yöntemlerim,
- Zorlanıyorum akışı,
- turuncu seri bozulması ve söz verme,
- yerel bildirimler,
- koyu tema,
- temel istatistik ve rozetler,
- çevrimdışı yerel kayıt,
- güvenli kullanıcı izolasyonu.

MVP sonrası:

- HealthKit/Health Connect,
- gelişmiş akıllı saat verileri,
- gelişmiş senkronizasyon çakışma ekranı,
- dışa aktarma seçenekleri,
- daha kapsamlı grafik ve rozetler,
- Flutter Web/masaüstü dağıtımı.

## 26. Kabul kriterleri

1. Uygulama Flutter ile Android ve iOS üzerinde derlenir.
2. Alt navigasyonda solda Negatif, ortada Ana Sayfa, sağda Pozitif bulunur.
3. Kullanıcı hazır veya özel alışkanlık oluşturabilir, düzenleyebilir, arşivleyebilir ve silebilir.
4. Negatif uzak durma süresi gerçek zaman damgalarından doğru hesaplanır.
5. Pozitif streak yalnızca programdaki başarılı periyotlarla artar; plansız günlerde bozulmaz.
6. Su ve sağlıklı beslenme günlük, diğerleri kullanıcı programına göre hatırlatılabilir.
7. Negatif renk kırmızıdan yeşile, pozitif renk maviden turkuaza ilerler.
8. Kırılma sonrası turuncu ekran açılır; eski seri korunur ve sözle yeni seri başlatılabilir.
9. Her detay sayfasında zorlayan konular ve çözüm yöntemleri bulunur.
10. Zorlanıyorum akışı küçük eylem, zamanlayıcı ve değerlendirme sunar.
11. Yerel bildirimler zaman dilimi ve sessiz saat kurallarına uyar.
12. Çevrimdışı kayıt uygulamayı kapatıp açınca korunur.
13. Farklı kullanıcılar birbirinin verisini göremez.
14. Hassas bildirimler nötr metinle gösterilebilir.
15. Reçeteli ilaç bırakma/doz önerisi hiçbir akışta üretilmez.
16. TalkBack ve VoiceOver ile ana akışlar tamamlanabilir.
17. Kritik streak, repository ve widget testleri geçer.

## 27. Teslim aşamaları

### Aşama 1 — Flutter temeli

Proje yapısı, tema, router, Riverpod kapsamı, yerel veri, auth kabuğu ve ana navigasyon.

### Aşama 2 — Alışkanlık çekirdeği

CRUD, programlar, kayıtlar, streak motoru, liste ve detay sayfaları.

### Aşama 3 — Davranış desteği

Günlük, çözümler, Zorlanıyorum, kırılma/söz verme ve bildirimler.

### Aşama 4 — Kalite ve yayın hazırlığı

Senkronizasyon, istatistikler, rozetler, erişilebilirlik, testler, Android/iOS release build ve mağaza hazırlığı.

## 28. Tamamlanma tanımı

MVP; Android ve iOS release build alınabildiğinde, tüm kabul kriterleri karşılandığında, kritik otomatik testler geçtiğinde, gerçek cihaz veya emülatörde bildirim ve çevrimdışı akışlar doğrulandığında, erişilebilirlik kontrolleri tamamlandığında ve kritik veri kaybı/güvenlik sorunu kalmadığında teslim edilebilir kabul edilir.
