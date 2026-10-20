RotaRent — Material 3 Tasarım Sistemi

## 1. Tasarım yönü

RotaRent güven veren, temiz ve hızlı algılanan bir mobil deneyimdir. Görsel dil; net tipografi, geniş boşluklar, kaliteli araç görselleri, yumuşak yüzeyler ve ölçülü bir ana renge dayanır.

Ana fikir: “Aracını birkaç güvenli adımda bul ve ayırt.” Her ekranda birincil görev belirgin, ücretler şeffaf ve geri dönüş yolu açıktır.

## 2. Material 3 tema yönetimi

`MaterialApp.router` şu yapıyı kullanır:

```dart
MaterialApp.router(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: themeMode,
  routerConfig: router,
)
```

- `useMaterial3: true`.
- Renkler `ColorScheme.fromSeed` ile üretilir ve component theme'lerle rafine edilir.
- Tema seçenekleri: Sistem, Açık, Koyu.
- Seçim anında uygulanır ve `shared_preferences` ile saklanır.
- Sistem seçiliyken platform parlaklığı otomatik izlenir.
- Widget'lar renkleri `Theme.of(context).colorScheme` üzerinden alır.

### Renkler

- Primary seed: `#3157D5` — güven veren mavi.
- Secondary: turkuaz ailesi; vurgu ve seçili filtrelerde ölçülü.
- Error: `ColorScheme.error`; özel sabit kırmızı kullanılmaz.
- Success ve warning aileleri `ThemeExtension<AppSemanticColors>` ile açık/koyu uyumlu tanımlanır.
- Light yüzeyler beyaz/mavi-gri; dark yüzeyler tam siyah yerine koyu lacivert-gridir.
- Metin ve kontrol kontrastları erişilebilir olmalıdır.

## 3. Tasarım token'ları

### Spacing

```text
xxs 4 | xs 8 | sm 12 | md 16 | lg 24 | xl 32 | xxl 48
```

- Telefon ekran yatay padding: 16; geniş ekran: 24.
- Kart iç padding: 16.
- Form alanları: 16.
- Ana bölümler: 24–32.

### Radius

```text
small 8 | medium 12 | large 16 | extraLarge 24 | pill 999
```

Text field ve buton 12, kart 16, bottom sheet üst köşeleri 24, chip pill.

### Elevation

Düz kartlar 0–1, sabit alt eylem 2–3. Ağır gölge yerine yüzey tonu ve ince border tercih edilir.

### Tipografi

Material 3 `TextTheme` rolleri kullanılır:

- `headlineMedium`: ekran ana başlığı.
- `titleLarge`: app bar/bölüm.
- `titleMedium`: araç/kart başlığı.
- `bodyLarge/bodyMedium`: içerik.
- `labelLarge`: buton.
- `labelMedium`: chip/metadata.

Metinleri gereksiz büyük harf yapma. Sistem fontu varsayılandır.

## 4. Responsive kurallar

- `SafeArea` ve klavye inset'leri hesaba katılır.
- Telefon tek kolon; 600 dp üzeri sonuçlar iki kolon olabilir.
- Form maksimum 560 dp, liste/detay maksimum 960 dp ve ortalanmış.
- Sabit piksel genişlikte form/kart yok.
- Araç görseli yaklaşık 16:9, `BoxFit.cover`, placeholder ve error fallback.
- Breakpoint için `LayoutBuilder`; cihaz modeline özel koşul yok.

## 5. Temel UI bileşenleri

### AppButton

Varyantlar: primary filled, tonal, outlined, text, destructive.

- Default: label ve opsiyonel leading icon.
- Pressed: Material overlay/ripple.
- Focused: görünür focus halkası.
- Disabled: `onPressed: null`, yeterli kontrast.
- Loading: boyut değişmez, 18–20 dp progress, tekrar tap kapalı.
- Minimum yükseklik 48 dp, yatay padding 20 dp.
- Tam genişlik yalnız ana form eyleminde.

### AppTextField

- `TextFormField` tabanlı ve kalıcı label.
- Hint yalnız örnek/yardım içindir.
- Prefix/suffix icon semantiktir.
- Focus, error, disabled, filled durumları theme ile tanımlıdır.
- Parola görünürlük toggle'ında “Parolayı göster/gizle” tooltip.
- Hata metni alanın altında kontrollü büyür.

### VehicleCard

- Görsel, kategori badge, favori IconButton.
- Marka/model/yıl.
- Vites, yakıt, koltuk: ikon + kısa metin.
- Puan/yorum sayısı.
- Günlük fiyat ve “/ gün”.
- Tüm kart tıklanabilir; favori butonu ayrı semantics/handler.
- Favorite optimistic; hatada geri al ve SnackBar göster.

### SearchSummaryCard

Konum/tarih özetini ve “Değiştir” eylemini gösterir. Küçük ekranda dikey, genişte yataydır.

### Filtreler

- Aktif filtreler removable chip olarak görünür.
- Bottom sheet scroll-safe ve draggable.
- “Temizle” secondary, “Sonuçları göster (n)” primary.
- Geçici seçimler draft state'te; yalnız “Uygula” ile aktif.

### Async durumlar

- İlk loading: yapıyı yansıtan skeleton veya progress.
- Refresh: eski veri + küçük progress.
- Empty: ikon, başlık, açıklama, çözüm CTA.
- Error: anlaşılır açıklama ve “Tekrar dene”.
- Submit: form korunur, ana buton inline loading.

### Feedback

- SnackBar: kısa/geri alınabilir bildirim.
- Inline error: form ve içerik yükleme.
- Dialog: destructive veya geri dönüşü zor onay.
- Bottom sheet: filtre, sıralama, hızlı seçim.
- Rezervasyon başarısı ayrı ekran olmalıdır.

## 6. Ana navigasyon widget ağacı

```text
ProviderScope
└─ MaterialApp.router
   └─ Router / Auth redirect
      └─ StatefulShellRoute
         └─ Scaffold
            ├─ body: navigation branches
            └─ NavigationBar
               ├─ Ana Sayfa
               ├─ Rezervasyonlar
               ├─ Favoriler
               └─ Profil
```

NavigationBar seçimi route state'ten türetilir. Aynı taba tekrar basma davranışı tutarlı biçimde branch köküne dönmeli veya listeyi yukarı almalıdır.

## 7. Ekranlar ve widget ağaçları

### 7.1 Splash

```text
Scaffold
└─ Center
   └─ Column(mainAxisSize: min)
      ├─ AppLogo
      ├─ SizedBox(16)
      └─ CircularProgressIndicator
```

Session restore biter bitmez router karar verir; sabit yapay gecikme yoktur. Başlatma hatasında retry gösterilir.

### 7.2 Giriş

```text
Scaffold
└─ SafeArea
   └─ Center
      └─ SingleChildScrollView
         └─ ConstrainedBox(maxWidth: 480)
            └─ Padding(24)
               └─ Form
                  └─ Column(crossAxisAlignment: stretch)
                     ├─ Logo
                     ├─ “Tekrar hoş geldiniz”
                     ├─ Açıklama
                     ├─ Email AppTextField
                     ├─ Password AppTextField
                     ├─ Login AppButton
                     └─ Register yönlendirmesi
```

Submit: validate -> klavyeyi kapat -> loading -> auth. Başarı router redirect; hata alan veya form panelinde. Parola IME action formu gönderir. Çalışmayan “Şifremi unuttum” eklenmez.

### 7.3 Kayıt

Aynı form kabuğu; ad soyad, e-posta, telefon, parola, parola tekrarı, koşul checkbox'ı ve kayıt butonu. Koşul bağlantıları ayrı semantics taşır. MVP'de başarı sonrası otomatik giriş tercih edilir.

### 7.4 Ana sayfa

```text
Scaffold
├─ AppBar
│  ├─ kişiselleştirilmiş selamlama
│  └─ çalışan profil/tema eylemi
└─ CustomScrollView
   ├─ Hero başlık
   ├─ SearchFormCard
   │  ├─ PickupLocationField
   │  ├─ “Aynı konuma bırak” SwitchListTile
   │  ├─ DropoffLocationField (koşullu)
   │  ├─ PickupDateTimeField
   │  ├─ DropoffDateTimeField
   │  └─ “Araçları bul” FilledButton
   ├─ “Popüler araçlar”
   └─ SliverList / horizontal VehicleCard
```

Konum searchable modal list açar. Tarih/saat Material picker açar. Geçersiz iade tarihi kullanıcıya açıklanarak en erken uygun değere taşınabilir.

### 7.5 Arama sonuçları

```text
Scaffold
├─ AppBar(title: “Araçlar”)
└─ Column
   ├─ SearchSummaryCard
   ├─ Row
   │  ├─ sonuç sayısı
   │  ├─ “Sırala” OutlinedButton
   │  └─ “Filtrele” TonalButton + count badge
   ├─ ActiveFilterChips
   └─ Expanded
      └─ RefreshIndicator
         └─ ListView / GridView
            └─ VehicleCard...
```

Sıralama: önerilen, fiyat artan, fiyat azalan, puan. Detaydan dönünce scroll konumu korunur.

### 7.6 Araç detayı

```text
Scaffold
├─ CustomScrollView
│  ├─ SliverAppBar
│  │  ├─ görsel galerisi
│  │  ├─ geri IconButton
│  │  └─ favori IconButton
│  └─ SliverToBoxAdapter
│     └─ Column
│        ├─ marka/model + kategori
│        ├─ puan/yorum
│        ├─ özellik grid
│        ├─ açıklama
│        ├─ dahil olanlar
│        ├─ kiralama şirketi
│        └─ ücret politikası
└─ SafeArea(top: false)
   └─ BottomActionBar
      ├─ günlük fiyat
      └─ “Kirala” FilledButton
```

Araç uygun değilse buton disabled ve nedeni görünürdür.

### 7.7 Rezervasyon

```text
Scaffold
├─ AppBar(title: “Rezervasyonu tamamla”)
├─ Form
│  └─ CustomScrollView
│     ├─ Araç özeti
│     ├─ Tarih/konum özeti + değiştir
│     ├─ Sürücü bilgileri
│     ├─ Ek hizmet/sigorta
│     ├─ Ücret dökümü
│     │  ├─ günlük ücret × gün
│     │  ├─ hizmet bedeli
│     │  ├─ sigorta
│     │  └─ toplam
│     ├─ koşul onayı
│     └─ alt boşluk
└─ Sticky BottomActionBar
   ├─ toplam
   └─ “Rezervasyonu onayla” FilledButton
```

Submit öncesi toplam domain use case ile tekrar hesaplanır. İstek sürerken duplicate rezervasyon ve veri kaybına karşı çıkış korunur.

### 7.8 Başarı

```text
Scaffold
└─ SafeArea
   └─ Center
      └─ Column
         ├─ success icon
         ├─ “Rezervasyonunuz oluşturuldu”
         ├─ rezervasyon numarası
         ├─ kısa özet
         ├─ “Rezervasyonu görüntüle” FilledButton
         └─ “Ana sayfaya dön” TextButton
```

Geri tuşu formu tekrar submit edebilecek route'a dönmemelidir.

### 7.9 Rezervasyonlar

- “Yaklaşan” ve “Geçmiş” tab/segment.
- Kart: görsel, araç, tarih, konum, status chip, toplam.
- Kart rezervasyon detayına gider.
- Uygun durumda “İptal et” confirmation dialog açar.
- Boş durumda “Araç bul” CTA.

### 7.10 Favoriler

Liste/grid VehicleCard. Çıkarma optimistic, hatada rollback. Boş durumda “Henüz favori aracınız yok” ve “Araçlara göz at”.

### 7.11 Profil

```text
Scaffold
├─ AppBar(title: “Profil”)
└─ ListView
   ├─ UserHeader
   ├─ Kişisel bilgiler
   ├─ Tema: Sistem/Açık/Koyu
   ├─ Divider
   └─ Çıkış yap
```

Tema radio list içeren bottom sheet/ayrı sayfa; seçim anında preview. Çıkış session'ı temizler ve login redirect tetikler. Çalışmayan ayar satırı gösterilmez.

## 8. State → UI eşlemesi

| State | Görsel | Eylem |
|---|---|---|
| Initial | Gerektiğinde boş kabuk | İlk yükleme |
| Loading | Skeleton/progress | Duplicate eylem kapalı |
| Refreshing | Eski veri + küçük progress | Veri kullanılabilir |
| Data | Tam içerik | Eylemler açık |
| Empty | EmptyState + CTA | Arama/filtre değiştir |
| Error, veri yok | ErrorState | Tekrar dene/geri |
| Error, eski veri var | Eski veri + banner | Yeniden dene |
| Submitting | Form + loading CTA | Çift submit kapalı |
| Success | Başarı ekranı/navigation | Sonraki mantıklı eylem |

## 9. Etkileşimler ve hareket

- Material route/component varsayılanları.
- Basit state geçişleri 150–250 ms.
- Favori ikonunda hafif scale/fade olabilir.
- Listeye aşırı staggered animasyon yok.
- `MediaQuery.disableAnimations` tercihine saygı.
- Animasyon kritik bilgiyi tek başına iletmez.

## 10. İçerik dili

- Kısa, doğrudan Türkçe.
- “Gönder” yerine “Giriş yap”, “Araçları bul”, “Rezervasyonu onayla”.
- Hata: “E-posta adresinizi kontrol edin.”, “Araçlar yüklenemedi. Tekrar deneyin.”
- Kullanıcıyı suçlayan dil yok.
- Fiyat: `₺1.250 / gün`.
- Kısa tarih: `20 Eki, 10:00`; detay: `20 Ekim 2026, 10:00`.

## 11. Erişilebilirlik

- Minimum 48×48 dp tap target.
- IconButton tooltip ve semantics label.
- Form hataları screen reader tarafından okunur.
- Focus sırası görsel sırayla aynı.
- 200% text scale'de clipping/overflow yok.
- Renk tek başına seçim/hata/başarı anlatmaz.
- Görsellerin dekoratif/açıklayıcı semantics rolü bilinçli seçilir.
- Loading indicator uygun label taşır.
- Sheet/dialog focus'u içine alır, kapanınca tetikleyiciye döndürür.

## 12. Tasarım bitiş kriterleri

- Bütün ekranlar light/dark tutarlı.
- Renkler ColorScheme/theme token'dan gelir.
- Buton default, pressed, focused, disabled, loading durumlarına sahiptir.
- Form invalid, focused, filled, submitting durumları testlidir.
- Widget ağaçları sorumluluk sınırlarını korur.
- 320 dp genişlik ve 200% text scale'de kritik akış kullanılabilir.
- Loading, empty, error, success tasarlanmıştır; boş beyaz ekran yok.
- Geri navigasyon güvenlidir ve ana akış anlaşılırdır.
