# Denge — Flutter UI/UX Tasarım Sistemi

> Bu belge, Denge uygulamasının Flutter arayüzünü tanımlar. `project.md` ürün kurallarının, `skill.md` ise geliştirme yönteminin kaynağıdır. Android ve iOS birincil platformlardır; tasarım telefon odaklı, tablet uyarlanabilir olmalıdır.

## 1. Tasarım yaklaşımı

Denge sakin, modern, karanlık ve güven veren bir uygulamadır. Bağımlılık ve kişisel mücadele konularını oyunlaştırabilir; ancak çocuklaştırmaz, korkutmaz ve kullanıcıyı suçlamaz.

Ana görsel metafor **ilerleyen ışıklı halka**dır:

- Negatif alışkanlık kırmızıdan başlar, süre ilerledikçe yeşile dönüşür.
- Pozitif alışkanlık maviden başlar, başarılı periyotlarla turkuaza dönüşür.
- Seri bozulduğunda ilgili deneyim turuncu yeniden başlama durumuna geçer.
- Arka planlar koyu, ana metinler beyaz/açık gri kalır.

## 2. Flutter tema mimarisi

Arayüz Material 3 üzerine kurulmalı, ancak varsayılan Material görünümüne bırakılmamalıdır.

```dart
MaterialApp.router(
  themeMode: ThemeMode.dark,
  darkTheme: AppTheme.dark,
  routerConfig: appRouter,
)
```

Tema yapısı:

- `ColorScheme` — temel yüzey, metin ve sistem renkleri
- `TextTheme` — tipografi
- `NavigationBarThemeData`
- `CardThemeData`
- `InputDecorationTheme`
- `FilledButtonThemeData`
- `OutlinedButtonThemeData`
- `BottomSheetThemeData`
- `DialogThemeData`
- `SnackBarThemeData`
- Özel `ThemeExtension` — negatif/pozitif aşamalar, restart renkleri ve glow değerleri

Widget içinde tekrarlanan `Color`, `EdgeInsets`, `BorderRadius` veya `TextStyle` değerleri hard-code edilmemelidir.

## 3. Renk sistemi

### 3.1. Koyu yüzeyler

| Token | Hex | Flutter kullanımı |
|---|---:|---|
| `canvas` | `#070B12` | `scaffoldBackgroundColor` |
| `canvasElevated` | `#0B111C` | Navigation ve sabit yüzey |
| `surface` | `#111827` | Kart, sheet ve form |
| `surfaceHigh` | `#172033` | Seçili/hover/basılı yüzey |
| `surfaceStrong` | `#1C273A` | Yüksek vurgu paneli |
| `borderSubtle` | `#243044` | Normal kenarlık |
| `borderStrong` | `#3A4962` | Aktif kenarlık |
| `scrim` | `#AD000000` | Modal örtüsü |

### 3.2. Metin

| Token | Hex | Kullanım |
|---|---:|---|
| `textPrimary` | `#F8FAFC` | Başlık ve ana değer |
| `textSecondary` | `#B8C2D6` | Gövde ve açıklama |
| `textMuted` | `#8491A8` | Meta bilgi |
| `textDisabled` | `#5F6B80` | Devre dışı |
| `textOnBright` | `#071018` | Parlak dolu buton üzeri |

### 3.3. Negatif ilerleme

| Aşama | Hex | Varsayılan eşik | Etiket |
|---|---:|---|---|
| 0 | `#FF5D68` | 0–23 saat | Başlangıç |
| 1 | `#FF735C` | 1–2 gün | İlk adım |
| 2 | `#F59E45` | 3–6 gün | Dayanıklılık |
| 3 | `#C4C94A` | 7–13 gün | Dönüşüm |
| 4 | `#71C96B` | 14–29 gün | Güçlenme |
| 5 | `#35D083` | 30+ gün | İstikrar |

### 3.4. Pozitif ilerleme

| Aşama | Hex | Varsayılan eşik | Etiket |
|---|---:|---|---|
| 0 | `#4D8DFF` | 0–2 periyot | Başlangıç |
| 1 | `#3B9EF3` | 3–6 periyot | Ritim |
| 2 | `#2BAFE4` | 7–13 periyot | Akış |
| 3 | `#22C1D0` | 14–29 periyot | Devamlılık |
| 4 | `#20D3B0` | 30+ periyot | İstikrar |

### 3.5. Sistem durumları

| Token | Hex | Kullanım |
|---|---:|---|
| `restart` | `#FF9F43` | Seri bozulması ve söz verme |
| `success` | `#35D083` | İşlem başarısı |
| `warning` | `#F7C948` | Uyarı |
| `danger` | `#FF6673` | Silme ve hata |
| `info` | `#60A5FA` | Bilgi |

Parlak renkler büyük yüzeyleri kaplamaz; halka, ikon kabı, ince kenarlık ve düşük opaklıklı vurgu olarak kullanılır. Parlak zemin üzerinde kontrast yetmiyorsa beyaz yerine `textOnBright` kullanılır.

## 4. Tema uzantısı önerisi

```dart
@immutable
class HabitColors extends ThemeExtension<HabitColors> {
  final List<Color> negativeStages;
  final List<Color> positiveStages;
  final Color restart;
  final Color negativeGlow;
  final Color positiveGlow;
  // copyWith ve lerp
}
```

`lerp`, ekran tema geçişlerinde ve aşama renkleri arasında akıcı dönüşüm sağlamalıdır. Aşama hesaplaması tema sınıfında değil domain/presentation mapper içinde yapılmalıdır.

## 5. Tipografi

Sistem fontu veya Türkçe karakterleri eksiksiz destekleyen Inter kullanılabilir.

| Stil | Boyut / yükseklik | Ağırlık | Kullanım |
|---|---|---:|---|
| Display | 32 / 38 | 700 | Büyük streak değeri |
| Headline Large | 28 / 34 | 700 | Sayfa başlığı |
| Headline Medium | 22 / 28 | 700 | Bölüm başlığı |
| Title | 18 / 24 | 600 | Kart başlığı |
| Body Large | 16 / 24 | 400 | Ana metin |
| Body Medium | 14 / 20 | 400 | Yardımcı metin |
| Label | 13 / 18 | 600 | Buton ve durum |
| Caption | 12 / 16 | 500 | Tarih/meta |

Flutter text scaler yüksekken metin kırpılmamalıdır. Sabit yükseklikli metin kutularından kaçınılmalıdır. Streak sayılarında tabular numerals tercih edilir.

## 6. Ölçü ve boşluk

Boşluk ölçeği: `4, 8, 12, 16, 20, 24, 32, 40, 48, 64 dp`.

- Telefon yatay iç boşluğu: 20 dp
- Dar ekran: 16 dp
- Kart iç boşluğu: 16–20 dp
- Bölüm aralığı: 24–32 dp
- Form alanı aralığı: 16 dp
- Minimum dokunma alanı: 48×48 dp
- Alt navigasyon: SafeArea dahil yaklaşık 72–88 dp

Köşeler:

- küçük: 8 dp
- form/chip: 12 dp
- kart: 16 dp
- büyük kart/sheet: 24 dp
- dairesel: `StadiumBorder` veya tam yarıçap

## 7. Responsive Flutter düzeni

`LayoutBuilder`, `MediaQuery` ve gerekirse `NavigationRail` kullanılmalıdır.

| Genişlik | Düzen |
|---|---|
| `< 360 dp` | Dar telefon, 16 dp kenar, tek sütun |
| `360–599 dp` | Standart telefon, alt `NavigationBar` |
| `600–839 dp` | Tablet, iki sütun uygun alanlarda |
| `≥ 840 dp` | `NavigationRail` + geniş içerik |

- `SafeArea` üst/alt kesitleri korur.
- Klavye açıldığında formun aktif alanı görünür kalır.
- Katlanabilir ve yatay ekranlarda içerik maksimum genişlikle sınırlandırılır.
- Telefon tasarımı yalnızca ölçeklenerek tablete yayılmaz; liste ve detay yan yana kullanılabilir.

## 8. Uygulama kabuğu

### Telefon

```text
┌─────────────────────────────┐
│ SafeArea                    │
│ Başlık                Profil│
│ Alt açıklama / tarih        │
│                             │
│ Kaydırılabilir içerik       │
│                             │
│ Negatif   ◎ Ana   Pozitif   │
└─────────────────────────────┘
```

- `Scaffold` gövdesi navigasyonun altına gizlenmemelidir.
- Orta Ana Sayfa hedefi 8–12 dp yukarı taşan özel vurgu taşıyabilir; erişilebilir alanı bozmamalıdır.
- Sekme durumları `StatefulShellRoute` ile korunmalıdır.

### Tablet

- Sol `NavigationRail`: Negatif, Ana Sayfa, Pozitif
- İçerik maksimum 1200 dp genişlikte
- Detay sayfasında özet ve günlük iki sütun olabilir

## 9. Ana navigasyon

| Konum | Etiket | İkon | Aktif renk |
|---|---|---|---|
| Sol | Negatif | kalkan/kırık halka | Negatif mevcut aşama |
| Orta | Ana Sayfa | ev/denge halkası | Açık metin + turkuaz vurgu |
| Sağ | Pozitif | filiz/artı halka | Pozitif mevcut aşama |

`NavigationDestination` etiketleri görünür kalmalıdır. Aktif hedef renk, ikon ve göstergeyle belirtilir. Seri bozulması tüm navigasyonu turuncuya çevirmemelidir.

## 10. Ortak Flutter widget’ları

### `HabitCard`

Parametreler:

- alışkanlık türü ve ikon,
- başlık ve program özeti,
- streak değeri,
- durum etiketi,
- renk aşaması,
- hızlı eylem,
- detay callback’i.

Kart gövdesi detay sayfasını açar. İç butonlar yanlışlıkla kart dokunmasını tetiklemez. Uzun basarak silme varsa 3 saniyelik görsel ilerleme ve haptic feedback bulunur; `PopupMenuButton` içinde erişilebilir silme alternatifi de vardır.

### `StreakRing`

Varyantlar:

- 40 dp küçük,
- 72 dp orta,
- 168–200 dp büyük.

`CustomPainter` kullanılabilir. `RepaintBoundary` ile gereksiz çizim sınırlandırılır. `Semantics` örneği: “Su içme, 1,5 litrelik hedefin 1,1 litresi tamamlandı.”

Negatif seride halka sonsuz uzak durma süresini yüzde yüz tamamlanmış gibi göstermez; aşama ilerlemesini belirtir. Pozitif miktar hedefinde yüzdeyi gösterebilir.

### Butonlar

- Ana eylem: `FilledButton`, 52 dp yükseklik
- İkincil: `OutlinedButton`
- Metinsel: `TextButton`
- Silme: danger rengi; ana eylem konumunda değil
- Loading sırasında boyut sabit kalır ve etiket `Kaydediliyor…` olur

### Formlar

- `TextFormField`, `DropdownMenu`, `SegmentedButton`, `ChoiceChip`
- Label placeholder’ın yerine geçmez.
- Hata ilgili alanın altında görünür.
- Sayısal klavye ve birim suffix’i kullanılır.
- Tarih/saat için platform uyumlu picker veya tutarlı özel picker kullanılır.

### Bottom sheet ve dialog

- Kısa kayıtlar `showModalBottomSheet(isScrollControlled: true)` ile açılabilir.
- Klavye için `MediaQuery.viewInsets.bottom` hesaba katılır.
- Uzun çok adımlı formlar tam sayfa route olur.
- Silme gibi ciddi onaylar `AlertDialog` ile gösterilir.
- Sheet/dialog açılınca başlık erişilebilir odak alır.

### Geri bildirim

- Kısa sonuç: `SnackBar`
- Kalıcı hata: inline error panel
- Silme: `Geri al` içeren SnackBar
- Kritik hata yalnızca SnackBar’a bırakılmaz

## 11. Ana sayfa

### Üst alan

- `Bugün nasıl gidiyor?`
- gün ve tarih
- profil/avatar butonu

### Günlük denge kartı

- pozitif hedeflerin tamamlanma oranı,
- devam eden negatif seri sayısı,
- yaklaşan hatırlatma,
- kısa motivasyon,
- iki renkli ince ilerleme çizgisi.

### Öncelik sırası

1. Süresi yaklaşan pozitif hedef
2. Kullanıcının zorlanma kaydı verdiği negatif hedef
3. Kayıt bekleyen günlük hedef
4. Tamamlananlar

### Boş durum

- halka illüstrasyonu,
- `İlk adımını seç`,
- pozitif ve negatif başlangıç seçenekleri,
- `Alışkanlık ekle` butonu.

## 12. Negatif alışkanlıklar sayfası

- `CustomScrollView` ve `SliverAppBar` kullanılabilir.
- Başlık: `Uzak durduklarım`
- Alt metin: `Geçen her süre ilerlemenin bir parçası.`
- Büyük öne çıkan kartta en uzun veya sabitlenmiş aktif seri
- Diğer alışkanlıklar tek sütun listede
- Belirgin `Zorlanıyorum` butonu
- Kırılma eylemi yanlış dokunmayı önlemek için detay/menü içindedir

Boş durum:

> `Hazır olduğunda bir hedef ekleyebilir ve kendi hızında ilerleyebilirsin.`

## 13. Pozitif alışkanlıklar sayfası

- Başlık: `Hayatıma kattıklarım`
- Alt metin: `Küçük adımlar tekrarlandığında güçlenir.`
- Kartlar Sabah, Gün İçinde, Akşam ve Saatsiz olarak gruplanabilir.
- Tamamlananlar sayfanın altında daraltılabilir; kaybolmaz.

Hızlı eylemler:

- Su: `+250 ml`, `+500 ml`, `Diğer`
- Kitap: `Sayfa ekle`, `Dakika ekle`
- Yürüyüş/koşu: `Başlat`, `Manuel ekle`
- Spor: `Süre ekle`
- Sağlıklı beslenme: `Öğün ekle`

Kayıt sonrası halka animasyonla güncellenir ve kısa geri alma sunulur.

## 14. Alışkanlık oluşturma

Çok adımlı tam ekran route:

1. Tür: Pozitif / Negatif
2. Kategori: arama, hazır grid, özel seçenek
3. Hedef/program veya bırakma başlangıcı
4. Hatırlatmalar ve nötr bildirim
5. Özet ve oluşturma

`Stepper` kullanılabilir; ancak dar ekranda ağır dikey stepper yerine üstte `2 / 5` ve doğrusal gösterge tercih edilir. İleri butonu yalnızca mevcut adım geçerliyse çalışır. Geri dönüşte girilen veri korunur.

## 15. Negatif detay sayfası

### Kahraman alanı

- geri butonu ve menü,
- büyük `StreakRing`,
- canlı gün/saat,
- aşama etiketi,
- başlangıç ve en iyi seri,
- `Zorlanıyorum` ana eylemi.

### Sekmeler

- Genel Bakış
- Geçmiş
- Beni Zorlayanlar
- Çözümlerim

Flutter’da `TabBar` + `TabBarView` kullanılabilir. İç içe scroll davranışı gerçek cihazda doğrulanmalıdır.

### Kırılma kaydı

Menüde `Seriyi bozdum` seçeneği:

- olay tarih/saat,
- isteğe bağlı miktar/not,
- sonuç açıklaması,
- vazgeç ve onay.

Eylem yargılayıcı kırmızı alarm değil, ciddi nötr/turuncu sunum kullanır.

## 16. Pozitif detay sayfası

- büyük günlük hedef veya streak halkası,
- `Bugünü tamamla`, `Miktar ekle` ya da `Zamanlayıcı başlat`,
- program özeti,
- sonraki hatırlatma,
- 7/30 günlük oran,
- toplam miktar/süre,
- küçük trend grafiği,
- günlük ve çözümler sekmeleri.

Tür özel alanlar:

- Kitap: sayfa ilerlemesi ve biten kitaplar
- Su: hızlı ekleme ve günlük hacim
- Koşu/yürüyüş: mesafe, süre, tempo
- Spor: aktivite ve aktif dakika
- Beslenme: öğün zaman çizelgesi
- Enstrüman/sanat: süre ve çalışma notu

## 17. Beni Zorlayanlar

Liste kartı:

- tarih/saat,
- tetikleyici chip’leri,
- `3/5 · Orta` gibi yoğunluk,
- duygu,
- iki satır not,
- kullanılan çözüm.

Yeni kayıt formu:

- tetikleyici çoklu seçimi,
- duygu/ihtiyaç,
- yoğunluk 1–5 (`Slider` yanında değer ve +/- alternatifi),
- ortam,
- serbest not,
- `Kaydet ve çözüm seç`,
- `Yalnızca kaydet`.

## 18. Çözüm Yöntemlerim

Çözüm kartı:

- eylem başlığı,
- tahmini dakika,
- tetikleyici etiketleri,
- etkinlik puanı,
- kullanım sayısı,
- favori,
- `Şimdi uygula`.

Gruplar: `2 dakikadan kısa`, `5–10 dakika`, `Destek iste`, `Ortamı değiştir`.

## 19. Zorlanıyorum odak modu

Tam ekran, dikkat dağıtmayan route; alt navigasyon gizlenebilir ancak geri/çıkış her zaman vardır.

### 1. Dur

> `Bu dürtü geçici. Önce iki dakika kendine alan açalım.`

Butonlar: `2 dakikayı başlat`, `Başka çözüm seç`.

### 2. Küçük eylem

Favori veya etkili çözüm, tahmini süre, `Şimdi yapıyorum`, `Başka öneri`.

### 3. Değerlendir

`Dürtü şimdi ne kadar güçlü?`, 1–5 ölçeği, `Azaldı / Aynı / Arttı`, isteğe bağlı not.

Geri sayım gerçek bitiş zamanına dayanır. Uygulama arka plandan dönünce doğru süre gösterilir. Bu akışta konfeti veya agresif oyunlaştırma kullanılmaz.

## 20. Turuncu yeniden başlama ekranı

Koyu zemin korunur; halka, kenarlık ve ana CTA turuncudur.

### Üst alan

- açık halkalı restart görseli,
- `Bir an, bütün yolculuğu silmez.`,
- `12 gün boyunca devam ettin.`,
- `Ne olduğunu fark etmek yeniden başlamanın ilk adımıdır.`

### Yansıtma

- tetikleyici chip’leri,
- isteğe bağlı not,
- bir sonraki benzer an için çözüm seçimi.

### Söz

- varsayılan: `Bugün kendim için yeniden başlıyorum.`
- özel söz alanı,
- `Söz ver ve yeniden başla`,
- `Şimdilik kapat`.

Başarılı işlemde halka turuncudan ilgili başlangıç rengine `AnimatedSwitcher`, `TweenAnimationBuilder` veya tema animasyonu ile geçer. Önceki serinin korunduğu belirtilir.

## 21. Takvim

- Haftalık/aylık `SegmentedButton`
- Gün hücreleri en az 44–48 dp
- Bugün: beyaz dış halka
- Seçili: belirgin koyu dolgu + açık kenarlık

Durumlar:

- pozitif tamamlandı: turkuaz halka + onay,
- pozitif kısmi: yarım halka + yüzde,
- kaçırıldı: kesik nötr halka,
- negatif uzak duruldu: aşama rengi,
- kırılma: turuncu açıklık/nokta,
- plansız: nötr nokta.

Bir güne dokununca `DraggableScrollableSheet` veya alt panelde olay zaman çizelgesi gösterilebilir.

## 22. Bildirim ayarları

Her alışkanlık için:

- ana `Switch`,
- saat listesi,
- tekrar günleri,
- erteleme süresi,
- sessiz saat uyumu,
- `Açık / Nötr` kilit ekranı metni,
- bildirim önizlemesi.

Nötr örnek:

> `Kendin için ayırdığın küçük zamanı hatırla.`

İzin kapalıysa inline panel ve `Ayarları aç` eylemi gösterilir. Android ve iOS sistem ayarlarına uygun yönlendirme yapılır.

## 23. Profil ve rozetler

Profil:

- avatar,
- gösterim adı,
- katılım tarihi,
- aktif alışkanlık ve toplam başarılı periyot,
- ayarlar erişimi.

Rozetler `GridView` içinde 2–3 sütun:

- kazanılan: canlı, tarih ve seviye,
- kilitli: okunabilir nötr yüzey ve ilerleme,
- detay sheet’i: şart ve mevcut ilerleme.

Yaş ve cinsiyet görsel odağa alınmaz. Seri bozulması kazanılmış rozeti geri almaz.

## 24. Ayarlar

- Hesap
- Bildirimler
- Görünüm ve erişilebilirlik
- Ölçü birimleri
- Gizlilik
- Verileri dışa aktar
- Hesabı ve verileri sil
- Çıkış yap

Hesap silme ayrı tehlikeli bölgede bulunur. Onay, hem sunucu hem cihaz verisinin silineceğini açıklar.

## 25. Durum ekranları

### Loading

- Yapıyı taklit eden skeleton veya sınırlı `CircularProgressIndicator`
- Çok kısa yüklemede gereksiz yanıp sönme önlenir

### Empty

- küçük ikon/illüstrasyon,
- kısa açıklama,
- tek birincil eylem.

### Error

- anlaşılır hata,
- `Tekrar dene`,
- veri kaybı ihtimali varsa açık uyarı.

### Offline

- üstte ince `Çevrimdışısın` bandı,
- kayıt üzerinde `Eşitlenecek` durumu,
- senkronizasyon tamamlanınca sakin geri bildirim.

## 26. Animasyon

| Hareket | Süre |
|---|---:|
| Buton basma | 100–140 ms |
| Renk/hover | 160–220 ms |
| Kart/sayfa | 220–300 ms |
| Bottom sheet | 280–340 ms |
| Aşama rengi | 500–800 ms |
| Başarı halkası | 650–900 ms |

Flutter araçları:

- `AnimatedContainer`
- `AnimatedSwitcher`
- `TweenAnimationBuilder`
- `Hero` yalnızca anlamlı ortak öğede
- Özel halka için `AnimationController`

Kaçınılacaklar:

- sürekli zıplayan CTA,
- kırılma ekranında sarsılma,
- kumar hissi veren ödül patlaması,
- sürekli neon animasyonu,
- uzun sinematik geçiş.

`MediaQuery.disableAnimations` veya platform reduce-motion tercihinde hareket sadeleştirilir.

## 27. Haptic feedback

- hızlı kayıt: `HapticFeedback.selectionClick()`
- hedef tamamlama: hafif/orta tek geri bildirim
- uzun basma tamamlanması: belirgin tek geri bildirim
- tehlikeli onay: kontrollü uyarı geri bildirimi

Haptic olmadan da görsel ve metinsel sonuç anlaşılır olmalıdır.

## 28. İçerik dili

### Kullan

- `Bugünkü hedefin tamamlandı.`
- `Bir adım daha eklendi.`
- `Önce iki dakika ertelemeyi deneyelim.`
- `Bir an bütün emeğini silmez.`
- `Şimdi küçük bir adım seçebilirsin.`

### Kullanma

- `Yine başarısız oldun.`
- `İradesiz davrandın.`
- `Bu kez sözünü tut.`
- kesin tedavi veya başarı vaatleri.

Kullanıcıya sıcak ve saygılı `sen` diliyle hitap edilir. Tahmini değerler açıkça etiketlenir.

## 29. Sağlık ve hassas kategoriler

İlaç kategorisinde görünür bilgi paneli:

> `Reçeteli bir ilacı bırakmadan veya dozunu değiştirmeden önce doktoruna ya da eczacına danış.`

- Sigara, alkol ve kumar görselleri davranışı çekici hale getirmez.
- Korkutucu hastalık/ölüm görselleri kullanılmaz.
- Profesyonel destek seçeneği erişilebilir bilgi kartı olarak sunulur.
- Bildirimlerde nötr metin varsayılan yapılabilir.

## 30. Erişilebilirlik

- Özel widget’larda `Semantics` zorunludur.
- İkon butonlarında `Tooltip` ve semantic label bulunur.
- Kontrast normal metinde 4.5:1, büyük metin/grafikte 3:1 hedefler.
- Durumlar renk + ikon + metinle anlatılır.
- 48×48 dp dokunma alanı korunur.
- TalkBack/VoiceOver sırası görsel sırayla aynıdır.
- Büyük metinde `RenderFlex overflow` oluşmamalıdır.
- Slider yanında sayısal değer ve alternatif kontroller bulunur.
- Grafikler metinsel özet taşır.
- Canlı sayaç her saniye duyurulmaz.
- Dialog/sheet odağı yönetilir.

## 31. Ekran envanteri

1. Karşılama
2. Kayıt/giriş
3. İlk hedef seçimi
4. Alışkanlık oluşturma adımları
5. Ana Sayfa
6. Negatif listesi
7. Pozitif listesi
8. Negatif detay
9. Pozitif detay
10. Hızlı kayıt sheet’i
11. Takvim/geçmiş
12. Beni Zorlayanlar
13. Çözüm Yöntemlerim
14. Zorlanıyorum odak modu
15. Kırılma kaydı
16. Turuncu söz verme/yeniden başlama
17. Bildirim ayarları
18. Profil/rozetler
19. Genel ayarlar
20. Hesap/veri yönetimi

## 32. Ana akışlar

### Pozitif oluşturma

```text
Ana Sayfa → + → Pozitif → Kategori → Hedef/Program
→ Hatırlatma → Özet → Oluştur → Pozitif Detay
```

### Negatif destek

```text
Negatif → Kart → Detay → Zorlanıyorum
→ Çözüm → Zamanlayıcı → Değerlendir → Kaydet
```

### Seri bozulması

```text
Negatif Detay → Seriyi bozdum → Onay
→ Turuncu Yansıtma → Çözüm → Söz
→ Yeni Seri
```

### Su takibi

```text
Ana/Pozitif → Su Kartı → +250 ml
→ Halka Güncellenir → Hedef Tamamlanır → Geri Al
```

## 33. Marka ve uygulama ikonu

Çalışma adı: **Denge**.

Logo:

- iki parçalı açık halka,
- sol yay kırmızıdan yeşile,
- sağ yay maviden turkuaza,
- koyu zemin,
- küçük Android launcher/iOS app icon boyutunda okunabilir sade form.

Logo doğrudan yin-yang kopyası veya sağlık kuruluşu amblemi gibi görünmemelidir.

## 34. Flutter görsel QA kontrol listesi

- [ ] Android ve iOS’ta koyu tema aynı tasarım dilini koruyor.
- [ ] SafeArea ve sistem gesture alanlarıyla çakışma yok.
- [ ] Klavye açıldığında form alanları görünür.
- [ ] 320–360 dp dar ekranlarda taşma yok.
- [ ] Tablet yerleşimi gereksiz boşluk bırakmıyor.
- [ ] Metin ölçeği yükseltildiğinde kritik eylemler erişilebilir.
- [ ] Negatif, pozitif ve restart tokenları merkezi temadan geliyor.
- [ ] Durumlar renk dışında ikon ve metin taşıyor.
- [ ] Loading, empty, error ve offline durumları var.
- [ ] Bottom sheet/dialog odağı ve geri hareketi doğru.
- [ ] TalkBack/VoiceOver ana akışları okunabilir.
- [ ] Reduced motion destekleniyor.
- [ ] Hassas bildirim önizlemesi nötrleştirilebiliyor.
- [ ] Motivasyon dili yargılayıcı değil.
- [ ] Gerçek Türkçe içerikte overflow yok.

## 35. Tasarım tamamlanma tanımı

Tasarım; bütün MVP ekranları gerçek Flutter widget’larıyla uygulandığında, merkezi `ThemeData/ThemeExtension` sistemi kullanıldığında, negatif ve pozitif renk ilerlemeleri ile turuncu yeniden başlama davranışı doğru çalıştığında, telefon/tablet uyarlaması ve Android/iOS görsel kontrolleri yapıldığında, Semantics ve büyük metin testleri geçtiğinde tamamlanmış kabul edilir.

Kullanıcının uygulamadan alması gereken temel his: **“İlerlememi görebiliyorum, şu an ne yapacağımı biliyorum ve aksasam bile yeniden başlayabilirim.”**
