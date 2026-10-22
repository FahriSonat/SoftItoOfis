# Denge — UI/UX ve Görsel Tasarım Sistemi

> Bu belge, `project.md` içindeki ürün kurallarını kullanıcı arayüzüne dönüştürür. Antigravity bu belgeyi ekran, bileşen, renk, tipografi, animasyon ve responsive davranışları için bağlayıcı tasarım kaynağı olarak kullanmalıdır. Geliştirme ve kalite yöntemi `skill.md` içinde tanımlanmıştır.

## 1. Tasarım yönü

Denge’nin görünümü sakin, modern, karanlık ve güven verici olmalıdır. Ürün bir oyun hissi taşıyabilir; ancak bağımlılık, sağlık ve kişisel mücadele gibi hassas konuları çocuklaştırmamalı veya kullanıcıyı cezalandırmamalıdır.

Tasarımın ana duyguları:

- **Kontrol:** Kullanıcı bugün ne yapacağını ve serisinin durumunu tek bakışta anlamalıdır.
- **İlerleme:** Renk, halka, sayı ve zaman çizelgesi gelişimi görünür kılmalıdır.
- **Sakinlik:** Koyu yüzeyler, sınırlı parlak renk ve geniş nefes alanları kullanılmalıdır.
- **Destek:** Seri bozulması bir alarm veya başarısızlık ekranı gibi değil, yeniden yön bulma anı gibi görünmelidir.
- **Kişisellik:** Kullanıcının notları, çözüm yöntemleri ve kendi sözü ürünün merkezinde olmalıdır.

## 2. Görsel konsept

Ana metafor **“karanlığın içinde büyüyen ışıklı halka”**dır. Her alışkanlık bir ilerleme halkasıyla temsil edilir:

- Negatif alışkanlık halkası kırmızıdan başlar ve uzak durulan süre arttıkça yeşile yaklaşır.
- Pozitif alışkanlık halkası maviden başlar ve tutarlılık arttıkça turkuaza yaklaşır.
- Seri bozulduğunda halka ve ilgili yüzey turuncu yeniden değerlendirme durumuna geçer.
- Halka yalnızca renk içermez; merkezinde streak değeri, altında birim ve yanında durum etiketi bulunur.

Arka planlarda saf siyah yerine çok koyu lacivert/grafit tonları kullanılmalıdır. Renkli neon etkiler yalnızca vurgu, ilerleme halkası ve odak alanlarında düşük yoğunlukta yer almalıdır.

## 3. Tasarım tokenları

Renkler bileşenlere doğrudan hex olarak yazılmamalı; aşağıdaki anlamsal tokenlara bağlanmalıdır.

### 3.1. Ana yüzeyler

| Token | Değer | Kullanım |
|---|---:|---|
| `color.bg.canvas` | `#070B12` | Uygulamanın ana arka planı |
| `color.bg.canvasElevated` | `#0B111C` | Sabit navigasyon ve geniş paneller |
| `color.bg.surface` | `#111827` | Kartlar ve formlar |
| `color.bg.surfaceHover` | `#172033` | Hover/odaklı kart yüzeyi |
| `color.bg.surfaceStrong` | `#1C273A` | Seçili veya yüksek yüzey |
| `color.bg.scrim` | `rgba(0,0,0,.68)` | Modal arka örtüsü |
| `color.border.subtle` | `#243044` | Normal kenarlık |
| `color.border.strong` | `#3A4962` | Aktif alan kenarlığı |

### 3.2. Metinler

| Token | Değer | Kullanım |
|---|---:|---|
| `color.text.primary` | `#F8FAFC` | Başlık ve ana bilgiler |
| `color.text.secondary` | `#B8C2D6` | Açıklamalar |
| `color.text.muted` | `#8491A8` | Yardımcı bilgiler |
| `color.text.disabled` | `#5F6B80` | Devre dışı içerik |
| `color.text.inverse` | `#071018` | Açık renkli dolu buton üzeri |

### 3.3. Negatif alışkanlık ilerleme paleti

| Aşama | Token | Değer | Varsayılan eşik |
|---|---|---:|---|
| Başlangıç | `negative.stage.0` | `#FF5D68` | 0–23 saat |
| İlk ilerleme | `negative.stage.1` | `#FF735C` | 1–2 gün |
| Dayanıklılık | `negative.stage.2` | `#F59E45` | 3–6 gün |
| Dönüşüm | `negative.stage.3` | `#C4C94A` | 7–13 gün |
| Güçlenme | `negative.stage.4` | `#71C96B` | 14–29 gün |
| İstikrar | `negative.stage.5` | `#35D083` | 30+ gün |

Kullanım ilkesi:

- Parlak renk büyük bir kartın tamamını kaplamamalıdır.
- Kartın koyu zemini korunmalı; renk ilerleme halkası, ince üst çizgi, ikon arka planı ve yumuşak glow üzerinde kullanılmalıdır.
- Renk değişimi sert basamak gibi değil, mümkünse mevcut ve sonraki aşama arasında kontrollü interpolasyonla gösterilmelidir.
- Renk adı veya durum etiketi görsel bilginin yanında bulunmalıdır.

### 3.4. Pozitif alışkanlık ilerleme paleti

| Aşama | Token | Değer | Varsayılan eşik |
|---|---|---:|---|
| Başlangıç | `positive.stage.0` | `#4D8DFF` | 0–2 başarılı periyot |
| Ritim | `positive.stage.1` | `#3B9EF3` | 3–6 periyot |
| Akış | `positive.stage.2` | `#2BAFE4` | 7–13 periyot |
| Devamlılık | `positive.stage.3` | `#22C1D0` | 14–29 periyot |
| İstikrar | `positive.stage.4` | `#20D3B0` | 30+ periyot |

### 3.5. Yeniden başlama ve sistem renkleri

| Token | Değer | Kullanım |
|---|---:|---|
| `restart.primary` | `#FF9F43` | Seri bozulması ve yeniden başlama |
| `restart.soft` | `rgba(255,159,67,.14)` | Turuncu panel yüzeyi |
| `success.primary` | `#35D083` | İşlem başarıları |
| `warning.primary` | `#F7C948` | Uyarılar |
| `danger.primary` | `#FF6673` | Geri alınması zor/silme işlemleri |
| `info.primary` | `#60A5FA` | Bilgi durumları |

Turuncu ekran, kırmızı hata ekranıyla karıştırılmamalıdır. Turuncu; düşünme, yön değiştirme ve yeniden söz verme anlamına gelir.

### 3.6. Gradyanlar

```css
--gradient-negative-start: linear-gradient(135deg, #FF5D68 0%, #F59E45 100%);
--gradient-negative-progress: linear-gradient(135deg, #F59E45 0%, #35D083 100%);
--gradient-positive: linear-gradient(135deg, #4D8DFF 0%, #20D3B0 100%);
--gradient-restart: linear-gradient(135deg, #FF7A45 0%, #FFB347 100%);
--gradient-canvas: radial-gradient(circle at 50% -10%, #15213A 0%, #070B12 46%);
```

Gradyanlar yalnızca ana ilerleme vurgularında kullanılmalıdır. Aynı ekranda birden fazla güçlü gradyan yarıştırılmamalıdır.

## 4. Tipografi

Önerilen yazı tipi: `Inter`, `SF Pro`, `Roboto` veya işletim sistemi sans-serif zinciri. Türkçe karakter desteği zorunludur.

| Stil | Boyut / Satır | Ağırlık | Kullanım |
|---|---|---:|---|
| Display | 32 / 38 px | 700 | Büyük streak sayısı, özel durum |
| H1 | 28 / 34 px | 700 | Sayfa başlığı |
| H2 | 22 / 28 px | 650–700 | Bölüm başlığı |
| H3 | 18 / 24 px | 600 | Kart başlığı |
| Body | 16 / 24 px | 400 | Ana içerik |
| Body Small | 14 / 20 px | 400 | Yardımcı açıklama |
| Label | 13 / 18 px | 600 | Etiket ve durum |
| Caption | 12 / 16 px | 500 | Tarih ve ikincil meta veri |

Kurallar:

- Gövde metni mobilde 16 px altına düşmemelidir.
- Streak sayılarında tabular numerals tercih edilmelidir.
- Tamamı büyük harf uzun metinlerde kullanılmamalıdır.
- Bir kart içinde en fazla üç tipografik seviye gösterilmelidir.
- Başlıklarda kısa ve doğrudan Türkçe kullanılmalıdır.

## 5. Ölçü, boşluk ve şekil sistemi

### 5.1. Boşluk ölçeği

`4, 8, 12, 16, 20, 24, 32, 40, 48, 64 px`

- Telefon ekranının yatay iç boşluğu: 20 px
- Küçük cihazda: minimum 16 px
- Kart iç boşluğu: 16 veya 20 px
- Ana bölüm aralığı: 24–32 px
- Form alanları arası: 16 px
- Alt navigasyon güvenlik payı dahil yüksekliği: 72–88 px

### 5.2. Köşe yarıçapları

| Token | Değer | Kullanım |
|---|---:|---|
| `radius.sm` | 8 px | Küçük etiketler |
| `radius.md` | 12 px | Form alanları, küçük kart |
| `radius.lg` | 16 px | Standart kart |
| `radius.xl` | 24 px | Büyük özet kartı, alt panel |
| `radius.full` | 999 px | Pill, avatar, dairesel buton |

### 5.3. Gölgeler ve ışık

Koyu temada ağır siyah gölge yerine yüzey ayrımı ve renkli düşük yoğunluklu ışık kullan:

```css
--shadow-card: 0 12px 32px rgba(0, 0, 0, .26);
--glow-negative: 0 0 28px rgba(255, 93, 104, .16);
--glow-positive: 0 0 28px rgba(32, 211, 176, .14);
--glow-restart: 0 0 30px rgba(255, 159, 67, .18);
```

## 6. İkonografi ve görseller

- Yuvarlatılmış çizgi ikonları kullanılmalıdır.
- Standart ikon boyutları: 18, 20, 24 ve 28 px.
- İkonlar tek başına anlam taşıdığında erişilebilir etiketi bulunmalıdır.
- Negatif alışkanlıklarda korkutucu hastalık veya ölüm görselleri kullanılmamalıdır.
- Kumar kategorisinde slot makinesi animasyonu gibi davranışı çekici hale getiren görsellerden kaçınılmalıdır.
- Sigara, alkol ve ilaç görselleri gerçekçi ürün reklamı gibi görünmemelidir; soyut ikon tercih edilmelidir.
- Pozitif alışkanlıklarda sade, enerjik çizimler kullanılabilir.
- Avatar yaş veya cinsiyet stereotiplerine dayanmamalıdır; nötr avatar seçimi sunulmalıdır.

## 7. Uygulama kabuğu

### 7.1. Mobil yerleşim

```text
┌──────────────────────────────┐
│ Durum çubuğu / safe area     │
│                              │
│ Sayfa başlığı          Profil│
│ Açıklama / tarih             │
│                              │
│ Kaydırılabilir ana içerik    │
│                              │
│                              │
│  Negatif    ◎ Ana    Pozitif │
└──────────────────────────────┘
```

- İçerik alt navigasyonun arkasında kalmamalıdır.
- Üst bar sayfaya göre sabit veya normal akışta olabilir; navigasyon tutarlı kalmalıdır.
- Orta Ana Sayfa butonu diğer iki sekmeden 8–12 px daha yukarıda, dairesel veya yuvarlatılmış kare biçiminde olabilir.
- Orta buton yalnızca ikonla gösterilirse `Ana Sayfa` erişilebilir adı zorunludur.

### 7.2. Tablet ve masaüstü

- `768 px` üzerindeki genişlikte içerik maksimum 1120–1200 px kapsayıcıya alınır.
- Alt navigasyon tablet görünümünde korunabilir.
- `1024 px` ve üzerinde alt navigasyon sol kenar çubuğuna dönüşebilir.
- Masaüstünde ana sayfa özet ve alışkanlık listeleri iki sütun olabilir.
- Detay sayfasında ana metrikler solda, günlük/çözümler sağda gösterilebilir.
- Mobilde bulunan hiçbir işlev yalnızca hover ile erişilebilir olmamalıdır.

## 8. Alt navigasyon

Üç sabit hedef:

| Konum | Etiket | Önerilen ikon | Aktif vurgu |
|---|---|---|---|
| Sol | Negatif | Kalkan / bırakma halkası | Mevcut negatif aşama rengi |
| Orta | Ana Sayfa | Ev / denge halkası | Beyaz + nötr turkuaz glow |
| Sağ | Pozitif | Filiz / artı halkası | Mevcut pozitif aşama rengi |

Durumlar:

- Aktif: ikon ve etiket açık, 2 px üst gösterge veya yumuşak dolgu
- Pasif: ikincil metin rengi
- Basılı: yüzey bir seviye açılır, ölçek en fazla `%98`
- Klavye odağı: 2 px görünür odak halkası

Alt navigasyon, seri bozulması sırasında tamamen turuncuya dönüşmemelidir; yalnızca ilgili alışkanlığın akışındaki içerik turuncu durum taşır. Böylece global navigasyon kararlı kalır.

## 9. Ortak bileşenler

### 9.1. Birincil buton

- Yükseklik: 52 px
- Köşe: 14–16 px
- Tam genişlik mobilde tercih edilir
- Etiket eylem fiiliyle başlar: `Alışkanlık ekle`, `Bugünü tamamla`, `Söz ver ve yeniden başla`
- Disabled durum yalnızca opaklıkla değil, imleç ve `aria-disabled/disabled` ile belirtilir
- Loading durumunda genişlik değişmemeli; spinner ve `Kaydediliyor…` metni gösterilmelidir

### 9.2. İkincil buton

- Koyu yüzey, belirgin kenarlık
- Birincil eylemle yarışmamalıdır
- `Daha sonra`, `Not ekle`, `Düzenle` gibi eylemler için kullanılır

### 9.3. Tehlikeli eylem

- Silme butonu kırmızı metin/çerçeveyle gösterilir.
- Ana ekranda yanlışlıkla dokunulacak birincil konumda bulunmaz.
- Silme ve arşivleme görsel olarak ayrılır.

### 9.4. Form alanı

- Etiket alanın üstünde bulunur.
- Yardımcı metin ve hata metni için sabit alan ayrılabilir.
- Normal yükseklik 52–56 px.
- Odakta kategoriye göre renkli kenarlık kullanılabilir.
- Hata durumunda ikon + metin + kırmızı kenarlık bulunur.
- Placeholder, etiket yerine kullanılmaz.

### 9.5. Chip ve filtre

- Minimum yükseklik 36 px.
- Seçili durumda dolu koyu-renkli yüzey ve onay ikonu kullanılabilir.
- Çoklu seçim ile tekli seçim görsel olarak ayırt edilmelidir.

### 9.6. Modal ve alt panel

- Mobilde veri girişi için çoğunlukla alt panel kullanılır.
- Panel maksimum yüksekliği ekranın `%92`si; içerik kendi içinde kayabilir.
- Masaüstünde ortalanmış modal kullanılabilir.
- Başlık, kapatma butonu ve birincil eylem daima erişilebilir kalmalıdır.
- Destructive onay dışında dışarı dokunarak kapatma desteklenebilir.

### 9.7. Toast ve inline mesaj

- Toast kısa işlem sonucu içindir.
- Kalıcı veya kritik hata ilgili bileşen içinde gösterilmelidir.
- Başarı toast’ı 3–5 saniye içinde kaybolabilir.
- Silme toast’ında süreli `Geri al` eylemi bulunabilir.

## 10. Alışkanlık kartı anatomisi

```text
┌──────────────────────────────────┐
│ [ikon] Alışkanlık adı    [durum] │
│        Kısa hedef/program        │
│                                  │
│  ◯ 12 gün     En iyi: 18 gün    │
│                                  │
│ [Birincil hızlı eylem]     [›]   │
└──────────────────────────────────┘
```

Kartın içeriği:

- 40–44 px ikon kabı
- en fazla iki satır alışkanlık adı
- açık durum etiketi: `Aktif`, `Bugün tamamlandı`, `2 saat kaldı`, `Yeniden başla`
- streak halkası veya kompakt ilerleme göstergesi
- mevcut değer ve birim
- bir sonraki hedef veya hatırlatma
- türe uygun hızlı eylem

Kart davranışı:

- Kart gövdesine dokunmak detay sayfasını açar.
- İç eylemler olay yayılımıyla yanlışlıkla detay sayfasını açmamalıdır.
- Kartın seçili/pressed durumu 100–160 ms içinde görünmelidir.
- Uzun basarak silme desteklenecekse ilerleyen dairesel gösterge ve titreşim geri bildirimi bulunmalı; erişilebilir alternatif olarak menüde `Sil` eylemi de sunulmalıdır.

## 11. İlerleme halkası

İlerleme halkası ürünün imza bileşenidir.

Boyut varyantları:

- Küçük: 40 px — kart içi
- Orta: 72 px — özet alanı
- Büyük: 160–200 px — detay kahraman alanı

Katmanlar:

1. Koyu arka ray
2. Türe ve aşamaya göre renkli ilerleme yayı
3. Çok düşük opaklıklı glow
4. Merkezde sayı/süre
5. Halkanın altında veya içinde birim

Kurallar:

- Negatif seride halka zamanı kesin hedefe ilerliyormuş gibi yanıltmamalıdır. Renk aşamasına geçiş için kullanılabilir; sonsuz süreyi `%100` tamamlanmış gibi göstermemelidir.
- Pozitif günlük miktar hedefinde halka hedef yüzdesini gösterebilir.
- Tamamlanan periyotta kısa bir onay animasyonu oynar.
- Seri bozulduğunda halka turuncuya dönüşür ve tam daire yerine kısa bir açıklıkla “yeniden başlama” durumunu simgeler.
- Ekran okuyucu etiketi örneği: “Su içme, bugün 1,5 litreden 1,1 litre tamamlandı.”

## 12. Ana sayfa tasarımı

### 12.1. Üst bölüm

- Sol: `Günaydın, [ad]` veya zamandan bağımsız `Bugün nasıl gidiyor?`
- Alt satır: gün ve tarih
- Sağ: bildirim veya profil/avatar butonu

### 12.2. Günlük denge kartı

Büyük özet kartı şu bilgileri içerir:

- günlük ilerleme yüzdesi,
- tamamlanan pozitif hedef sayısı,
- devam eden negatif seri sayısı,
- kısa motivasyon cümlesi,
- gerekliyse bir sonraki eylem.

Örnek:

```text
Bugünkü dengen
4 hedefin 3'ü yolunda
[████████░░] %75
Sıradaki: 18.30 · 20 dakika yürüyüş
```

Kart nötr koyu yüzeyde olmalı; negatif ve pozitif renkler ince iki parçalı ilerleme çizgisinde birleşebilir.

### 12.3. Kritik eylem sıralaması

1. Süresi yaklaşan pozitif hedef
2. Kullanıcının `Zorlanıyorum` işareti verdiği negatif alışkanlık
3. Henüz kayıt girilmemiş günlük hedef
4. Tamamlananlar

### 12.4. Ana sayfa boş durumu

- Sade halka illüstrasyonu
- Başlık: `İlk adımını seç`
- Açıklama: pozitif veya negatif bir alışkanlıkla başlanabileceği
- Birincil buton: `Alışkanlık ekle`
- İki küçük öneri: `Pozitif alışkanlık`, `Uzak durmak istediğim alışkanlık`

## 13. Negatif alışkanlıklar ekranı

### 13.1. Sayfa başlığı

- Başlık: `Uzak durduklarım`
- Açıklama: `Geçen her süre ilerlemenin bir parçası.`
- Sağda `+` butonu

### 13.2. Öne çıkan aktif seri

En uzun veya kullanıcı tarafından sabitlenen alışkanlık büyük kartta gösterilir:

- büyük ilerleme halkası,
- gün/saat değeri,
- `Başlangıç: 14 Ekim, 21.30`,
- `En iyi seri`,
- `Zorlanıyorum` birincil destek butonu,
- detay bağlantısı.

### 13.3. Diğer alışkanlıklar

- Tek sütun kart listesi
- Aşamaya göre ince renk çizgisi
- Gerçek zamanlı süre gösterimi
- Kart içi kırılma eylemi doğrudan görünmemelidir; detay/menü içinde yanlış dokunmayı önleyen onaylı akış olmalıdır.

### 13.4. Negatif boş durumu

Metin kullanıcıyı zararlı bir alışkanlığı olduğunu kabul etmeye zorlamamalıdır:

- Başlık: `Uzak durmak istediğin bir şey var mı?`
- Açıklama: `Hazır olduğunda bir hedef ekleyebilir ve kendi hızında ilerleyebilirsin.`
- Buton: `Hedef ekle`

## 14. Pozitif alışkanlıklar ekranı

### 14.1. Sayfa başlığı

- Başlık: `Hayatıma kattıklarım`
- Açıklama: `Küçük adımlar, tekrarlandığında güçlenir.`
- Sağda `+` butonu

### 14.2. Bugünün planı

Kartlar zamana göre gruplanabilir:

- Sabah
- Gün içinde
- Akşam
- Belirli saati olmayanlar

Tamamlanan alışkanlıklar listenin altında daraltılmış `Bugün tamamlananlar` bölümüne taşınabilir; tamamen kaybolmamalıdır.

### 14.3. Hızlı girişler

- Su: `+250 ml`, `+500 ml`, `Diğer`
- Kitap: `Sayfa ekle` veya `Dakika ekle`
- Yürüyüş/koşu: `Başlat` ve `Manuel ekle`
- Sağlıklı beslenme: `Öğün ekle`
- Süre bazlı alışkanlık: `Zamanlayıcı başlat` veya `Tamamlandı`

Hızlı giriş sonrası değer hemen güncellenmeli; geri alma kısa süre görünmelidir.

## 15. Alışkanlık ekleme akışı

Akış tam ekran modal veya çok adımlı alt panel olabilir.

### Adım 1 — Tür seçimi

İki büyük seçim kartı:

- `Pozitif alışkanlık kazan`
- `Bir alışkanlıktan uzak dur`

Kartlarda mavi/turkuaz ve kırmızı/yeşil ilerleme örneği bulunur.

### Adım 2 — Kategori seçimi

- Arama alanı
- Sık kullanılan hazır kategoriler
- İkonlu 2 sütun grid
- En altta `Kendim oluşturacağım`

### Adım 3 — Hedef ve program

Pozitif için:

- ölçüm türü,
- hedef miktarı/süresi,
- günlük, seçili günler, haftalık sıklık veya aralık,
- başlangıç tarihi.

Negatif için:

- uzak durma başlangıç tarih ve saati,
- isteğe bağlı önceki kullanım ve maliyet bilgisi,
- kritik saatler.

### Adım 4 — Hatırlatmalar

- saat seçimleri,
- sessiz günler,
- nötr bildirim seçeneği,
- bildirim önizlemesi.

### Adım 5 — Özet

- alışkanlık adı,
- hedef/program,
- ilk hatırlatma,
- düzenleme bağlantıları,
- `Alışkanlığı oluştur` eylemi.

Adım göstergesi `2 / 5` gibi metinle birlikte bulunmalı; yalnızca noktalar kullanılmamalıdır.

## 16. Negatif alışkanlık detay sayfası

### 16.1. Kahraman alanı

- Geri butonu
- Alışkanlık adı ve seçenek menüsü
- Büyük halka
- Canlı uzak durma süresi
- Durum etiketi: `İstikrar güçleniyor`
- Başlangıç zamanı ve en iyi seri
- `Zorlanıyorum` belirgin butonu

### 16.2. İçerik sekmeleri

- `Genel Bakış`
- `Geçmiş`
- `Beni Zorlayanlar`
- `Çözümlerim`

Mobilde sekmeler yatay kayabilir; aktif sekme görünür kalmalıdır.

### 16.3. Genel bakış

- son 7/30 gün özeti,
- varsa tahmini kazanılan zaman/para,
- bir sonraki renk aşaması,
- son not,
- en etkili çözüm.

Tahmini kazanımların yanında `Tahmini` etiketi ve hesap açıklaması bulunmalıdır.

### 16.4. Kırılma kaydı

`Seriyi bozdum` eylemi seçenek menüsünde veya sayfanın altındaki ikincil alanda yer alır. Dokunulduğunda:

- olay tarihi/saati,
- isteğe bağlı miktar,
- kısa not,
- `Bu işlem mevcut seriyi sonlandırır` açıklaması,
- onay ve vazgeçme

gösterilir. Eylem kırmızı değil, ciddi ama yargılamayan nötr/turuncu biçimde sunulmalıdır.

## 17. Pozitif alışkanlık detay sayfası

### 17.1. Kahraman alanı

- Büyük hedef halkası
- Bugünkü ilerleme veya mevcut streak
- `Bugünü tamamla`, `Miktar ekle` veya `Zamanlayıcı başlat` ana eylemi
- Program özeti
- Sonraki hatırlatma

### 17.2. Genel bakış

- haftalık tamamlanma oranı,
- mevcut ve en uzun streak,
- toplam miktar/süre,
- küçük trend grafiği,
- son çalışma notu.

### 17.3. Tür özel bileşenleri

- Kitap: kapak placeholder'ı, sayfa ilerleme çubuğu, biten kitap sayısı
- Su: bardak/şişe hızlı ekleme, günlük hedef halkası
- Koşu/yürüyüş: mesafe, süre, tempo kartları
- Spor: aktivite türü ve aktif dakika
- Sağlıklı beslenme: öğün zaman çizelgesi ve günlük değerlendirme
- Enstrüman/sanat: süre ve çalışma günlüğü

## 18. “Beni Zorlayanlar” günlüğü

### 18.1. Liste görünümü

Her kayıt:

- tarih/saat,
- tetikleyici etiketleri,
- yoğunluk `1–5`,
- duygu etiketi,
- en fazla iki satır not önizlemesi,
- kullanıldıysa çözüm yöntemi.

Yoğunluk yalnızca kırmızı tonla gösterilmemeli; `3/5 · Orta` gibi metin bulunmalıdır.

### 18.2. Yeni kayıt formu

- `Şu anda seni zorlayan ne?`
- Hazır tetikleyiciler: stres, yalnızlık, sıkılma, sosyal ortam, yorgunluk, bildirim, para erişimi ve özel seçenek
- Duygu seçimi
- Yoğunluk slider’ı ve sayısal metin
- Ortam/bağlam
- Serbest not
- `Kaydet ve çözüm seç` ana eylemi
- `Yalnızca kaydet` ikincil eylemi

## 19. “Çözüm yöntemlerim” alanı

Çözüm kartı:

- kısa eylem başlığı,
- tahmini süre,
- uygun tetikleyici chip’leri,
- etkinlik puanı,
- kullanım sayısı,
- favori işareti,
- `Şimdi uygula` eylemi.

Önerilen gruplar:

- 2 dakikadan kısa
- 5–10 dakika
- Birinden destek iste
- Ortamı değiştir

Boş durumda hazır güvenli örnekler gösterilebilir; kullanıcı onaylamadan kişisel listeye eklenmemelidir.

## 20. “Zorlanıyorum” odak modu

Bu ekran dikkat dağıtıcı navigasyonu azaltan, tam ekran bir odak deneyimidir.

### Aşama 1 — Dur ve nefes alanı aç

```text
Bu dürtü geçici.
Önce iki dakika kendine alan açalım.

[2 dakikayı başlat]
[Başka bir çözüm seç]
```

- Büyük sakin halka animasyonu
- Turuncu yerine alışkanlığın mevcut aşama rengi düşük yoğunlukta kullanılabilir
- Geri/çıkış her zaman erişilebilir olmalıdır

### Aşama 2 — Küçük eylem

- Kullanıcının favori veya geçmişte etkili çözümü
- Tahmini süre
- `Şimdi yapıyorum`
- `Başka öneri`

### Aşama 3 — Yeniden değerlendir

- `Dürtü şu anda ne kadar güçlü?`
- 1–5 ölçeği
- `Azaldı`, `Aynı`, `Arttı`
- isteğe bağlı not
- ciddi kategoriler için görünür `Profesyonel destek seçenekleri` bağlantısı

Bu deneyimde konfeti, puan kazanımı veya agresif başarı animasyonu kullanılmamalıdır.

## 21. Seri bozulması ve söz verme ekranı

Ekranın ana rengi turuncudur; arka plan yine koyu kalır.

### 21.1. Üst alan

- Açık halkalı turuncu ilerleme görseli
- Başlık: `Bir an, bütün yolculuğu silmez.`
- Önceki seri: `12 gün boyunca devam ettin.`
- Destek metni: `Ne olduğunu fark etmek, yeniden başlamanın ilk adımıdır.`

### 21.2. Yansıtma alanı

- `Seni ne zorladı?` chip seçimi
- isteğe bağlı kısa not
- `Bir sonraki benzer anda ne denemek istersin?` çözüm kartı

### 21.3. Söz alanı

- Varsayılan söz: `Bugün kendim için yeniden başlıyorum.`
- `Kendi sözümü yaz` seçeneği
- Onay checkbox’ı yerine anlamlı bir eylem butonu
- Ana buton: `Söz ver ve yeniden başla`
- İkincil buton: `Şimdilik kapat`

### 21.4. Başarılı yeniden başlama

- Turuncu halka kısa bir geçişle alışkanlık türünün başlangıç rengine döner.
- Mesaj: `Yeni başlangıcın kaydedildi.`
- Yeni seri zamanı gösterilir.
- Önceki serinin geçmişte korunduğu açıkça belirtilir.

## 22. Takvim ve geçmiş tasarımı

### 22.1. Takvim

- Haftalık/aylık segment kontrolü
- Ay değiştirme butonları
- Gün hücreleri minimum 40–44 px dokunma alanı
- Bugün için beyaz dış halka
- Seçili gün için dolu koyu yüzey + açık kenarlık

Durum işaretleri:

- Pozitif tamamlandı: turkuaz/mavi küçük halka + onay
- Pozitif kısmi: yarım halka + yüzde
- Kaçırıldı: nötr kesik halka + `—`
- Negatif uzak duruldu: aşama renginde tam halka
- Kırılma: turuncu nokta/açıklık + metin etiketi
- Plansız gün: düşük kontrastlı nötr nokta

Bir güne dokunulduğunda aşağıda veya alt panelde o günün olay zaman çizelgesi açılır.

### 22.2. Isı haritası

Masaüstünde GitHub benzeri 12 haftalık görünüm eklenebilir. Mobilde hücreler okunamayacak kadar küçültülmemeli; yatay kaydırma veya 4 haftalık pencere kullanılmalıdır.

## 23. Grafikler ve istatistikler

- Grafikler dekoratif değil, karar verdiren kısa içgörü sunmalıdır.
- Eksen ve değer etiketleri okunabilir olmalıdır.
- Negatif seriler için “uzak durulan süre”, pozitif için “tamamlama oranı/miktar” gösterilir.
- Çizgi ve barlar kategori rengiyle gösterilebilir; başarı/başarısızlık yalnızca renk farkına bağlı kalmamalıdır.
- Az veri varsa grafik uydurulmamalı; açıklayıcı boş durum gösterilmelidir.
- Grafik altında bir cümlelik yorum olabilir: `Son 4 haftanın 3'ünde hedefini tamamladın.`

## 24. Bildirim ayarları ekranı

Her alışkanlık için:

- ana aç/kapat anahtarı,
- hatırlatma saatleri,
- tekrar günleri,
- erteleme süresi,
- sessiz saat uyumu,
- kilit ekranı metni: `Açık` veya `Nötr`,
- bildirim önizlemesi.

Nötr örnek:

> `Kendin için ayırdığın küçük zamanı hatırla.`

Açık örnek:

> `20 dakikalık yürüyüş hedefin seni bekliyor.`

İzin kapalıysa en üstte inline panel:

> `Bildirim izni kapalı. Hatırlatmaları almak için cihaz ayarlarından izin verebilirsin.`

Buton: `Ayarları aç`

## 25. Profil ve rozetler

### 25.1. Profil üst alanı

- Avatar
- Kullanıcı adı
- Katılım tarihi
- Aktif alışkanlık sayısı
- Toplam başarılı periyot

Yaş ve cinsiyet profil ekranının görsel odağı yapılmamalıdır.

### 25.2. Rozetler

- 2 veya 3 sütun grid
- Kazanılan rozet: canlı renk, tarih ve seviye
- Kilitli rozet: düşük kontrast değil, okunabilir nötr yüzey; ilerleme değeri
- Rozete dokununca koşul ve ilerleme açıklaması
- Seri bozulması sonucunda kazanılmış rozet geri alınmamalıdır.

## 26. Ayarlar ve veri yönetimi

Bölümler:

- Hesap
- Bildirimler
- Görünüm ve erişilebilirlik
- Ölçü birimleri
- Gizlilik
- Verileri dışa aktar
- Hesabı ve verileri sil
- Çıkış yap

Hesap silme ayrı bir tehlikeli bölge içinde bulunmalıdır. Son onay ekranı silinecek verileri açıkça sıralamalıdır.

## 27. Boş, yüklenme ve hata durumları

### 27.1. Boş durum

- Küçük, sakin illüstrasyon veya ikon
- Durumu açıklayan başlık
- Tek cümle yönlendirme
- Bir ana eylem

### 27.2. Yüklenme

- Kart ve metin yapısını taklit eden skeleton
- Sonsuz spinner yalnızca kısa ve küçük alanlarda
- 300 ms’den kısa yüklemede gereksiz titreşim yaratmamak için gecikmeli skeleton kullanılabilir

### 27.3. Hata

- Ne olduğuna dair sade açıklama
- Kullanıcının yapabileceği eylem
- `Tekrar dene`
- Veri kaybı olasılığı varsa açık uyarı

### 27.4. Çevrimdışı

- Üstte ince, kalıcı olmayan `Çevrimdışısın` bandı
- Yerel kaydedilen işlemde `Bağlantı gelince eşitlenecek` etiketi
- Senkronizasyon tamamlanınca sessiz başarı geri bildirimi

## 28. Mikro etkileşim ve hareket

### 28.1. Süreler

| Hareket | Süre |
|---|---:|
| Buton basma | 100–140 ms |
| Hover/renk geçişi | 160–220 ms |
| Kart açılma | 220–280 ms |
| Alt panel | 280–340 ms |
| Renk aşaması dönüşümü | 500–800 ms |
| Başarı halkası | 650–900 ms |

Easing: doğal giriş/çıkış için `cubic-bezier(.2,.8,.2,1)` benzeri eğri.

### 28.2. İzin verilen animasyonlar

- halka dolumu,
- düşük yoğunluklu nefes alma etkisi,
- kayıt sonrası kısa onay çizimi,
- aşama değişiminde renk dönüşümü,
- uzun basmada ilerleme halkası.

### 28.3. Kaçınılacak animasyonlar

- sürekli zıplayan CTA,
- kırılma ekranında sarsılma,
- kumar hissi veren ödül patlamaları,
- dikkat dağıtan sürekli neon glow,
- sayfalar arası uzun sinematik geçiş.

`prefers-reduced-motion` durumunda hareketler fade veya anlık durum değişimine indirgenmelidir.

## 29. Dokunsal geri bildirim

Native/PWA ortamı destekliyorsa:

- hızlı kayıt: hafif geri bildirim,
- hedef tamamlandı: tek orta geri bildirim,
- uzun basma onayı: kademeli/hafif geri bildirim,
- tehlikeli işlem onayı: belirgin fakat tek geri bildirim.

Dokunsal geri bildirim olmadan da durum anlaşılır olmalıdır.

## 30. İçerik tasarımı ve ton

### 30.1. Dil ilkeleri

- Kullanıcıya `sen` diliyle, saygılı ve sıcak biçimde hitap et.
- Cümleleri kısa tut.
- Emir yerine davet kullan: `Şimdi küçük bir adım seçebilirsin.`
- “Temiz/kirli”, “iradesiz”, “başarısız” gibi damgalayıcı ifadeler kullanma.
- Emeği yalnızca streak sayısıyla eşitleme.
- Tahminleri kesin sonuç gibi sunma.

### 30.2. Örnek mikro metinler

Başarı:

- `Bugünkü hedefin tamamlandı.`
- `Bir adım daha eklendi.`
- `Ritmini koruyorsun.`

Hatırlatma:

- `Bugün için 500 ml su kaldı.`
- `10 dakikalık okuma için uygun bir an mı?`

Zorlanma:

- `Önce iki dakika ertelemeyi deneyelim.`
- `Geçmişte işe yarayan bir çözümün var.`
- `Bu anı tek başına çözmek zorunda değilsin.`

Kırılma:

- `Bir an, bütün emeğini silmez.`
- `Ne olduğunu fark ettin. Şimdi bir sonraki adımı seçebilirsin.`

## 31. Sağlık ve hassas kategori sunumu

- Uygulama tıbbi tedavi izlenimi veren beyaz önlük, EKG ve hastane estetiğine dayanmamalıdır.
- “Gereksiz ilaç kullanımı” ekranında sabit bilgi paneli bulunmalıdır:

> `Reçeteli bir ilacı bırakmadan veya dozunu değiştirmeden önce doktoruna ya da eczacına danış.`

- Bu panel kapatılabilir olsa bile ayarlar/detay içinde yeniden erişilebilir olmalıdır.
- Profesyonel destek bağlantısı korkutucu kırmızı alarm yerine güven verici bilgi panelinde sunulmalıdır.
- Acil durum içeriği normal motivasyon kartlarıyla karıştırılmamalıdır.

## 32. Erişilebilirlik ayrıntıları

- Normal metinde minimum `4.5:1`, büyük metin ve temel grafiklerde minimum `3:1` kontrast hedeflenmelidir.
- Parlak vurgu üzerinde beyaz metin yeterli kontrast sağlamıyorsa `color.text.inverse` kullanılmalıdır.
- Renk aşamalarının her biri isim veya sayısal ilerlemeyle desteklenmelidir.
- Dokunma alanı en az 44×44 px olmalıdır.
- Klavye sırası görsel sırayla aynı olmalıdır.
- Skip link masaüstü/web görünümünde sunulmalıdır.
- Modal, menü ve alt panelde odak yönetimi yapılmalıdır.
- Sayaçlar sürekli canlı bölge olmamalı; anlamlı eşiklerde veya kullanıcı isteğinde okunmalıdır.
- Grafiklerin metinsel özeti bulunmalıdır.
- Slider yanında değer ve artır/azalt alternatifleri sunulmalıdır.
- Form hata özeti ilk hataya odaklanabilmelidir.

## 33. Responsive kırılma noktaları

Önerilen yaklaşım:

| Aralık | Düzen |
|---|---|
| `< 360 px` | Dar telefon; 16 px kenar, tek sütun, kısa etiketler |
| `360–767 px` | Standart mobil; 20 px kenar, alt navigasyon |
| `768–1023 px` | Tablet; 2 sütun uygun alanlarda, alt navigasyon veya kompakt rail |
| `≥ 1024 px` | Masaüstü; sol navigasyon, 2–3 sütun dashboard |

Kırılma noktaları içeriğin bozulduğu yere göre ayarlanabilir. Cihaz adına göre özel yerleşim yazılmamalıdır.

## 34. Ekran listesi

MVP ekran envanteri:

1. Karşılama
2. Kayıt ol / giriş yap
3. İlk hedef seçimi
4. Alışkanlık kurulum adımları
5. Ana sayfa
6. Negatif alışkanlıklar listesi
7. Pozitif alışkanlıklar listesi
8. Negatif alışkanlık detayı
9. Pozitif alışkanlık detayı
10. Günlük kayıt alt paneli
11. Takvim/geçmiş
12. Beni Zorlayanlar listesi ve formu
13. Çözüm Yöntemlerim listesi ve formu
14. Zorlanıyorum odak modu
15. Seri bozulması/yansıtma
16. Söz verme ve yeniden başlama
17. Bildirim ayarları
18. Profil ve rozetler
19. Genel ayarlar
20. Veri ve hesap yönetimi

Bu ekranlar route olmak zorunda değildir; uygun olanlar modal veya alt panel olarak uygulanabilir.

## 35. Temel kullanıcı akışları

### 35.1. Pozitif alışkanlık oluşturma

```text
Ana Sayfa
→ +
→ Pozitif alışkanlık
→ Kategori
→ Hedef ve program
→ Hatırlatmalar
→ Özet
→ Oluştur
→ Pozitif detay
```

### 35.2. Negatif alışkanlık ve zorlanma

```text
Negatif
→ Alışkanlık kartı
→ Detay
→ Zorlanıyorum
→ Küçük eylem seç
→ Süreyi tamamla
→ Dürtüyü değerlendir
→ Sonucu kaydet
```

### 35.3. Seri bozulması

```text
Negatif detay
→ Seriyi bozdum
→ Tarih/saat ve onay
→ Turuncu yansıtma ekranı
→ Tetikleyici ve çözüm
→ Söz ver ve yeniden başla
→ Yeni seri
```

### 35.4. Günlük su takibi

```text
Pozitif / Ana Sayfa
→ Su kartı
→ +250 ml
→ Halka güncellenir
→ Hedef tamamlanır
→ Kısa başarı geri bildirimi
```

## 36. Uygulama ikonu ve marka önerisi

Çalışma adı: **Denge**

Logo fikri:

- ortasında küçük bir boşluk bulunan iki parçalı halka,
- sol yay sıcak kırmızıdan yeşile,
- sağ yay maviden turkuaza geçer,
- iki yay birlikte denge ve devamlılığı simgeler,
- koyu zemin üzerinde sade ve küçük boyutta okunabilir olmalıdır.

Logo, yin-yang sembolünü doğrudan kopyalamamalı ve sağlık kuruluşu amblemi gibi görünmemelidir.

## 37. Tasarım teslim ve uygulama kontrol listesi

Antigravity her ekranı tamamlamadan önce şunları doğrulamalıdır:

- [ ] Koyu arka plan ve yüksek kontrastlı metin kullanıldı.
- [ ] Negatif/pozitif/yeniden başlama durumları doğru tokenlara bağlı.
- [ ] Durum yalnızca renkle anlatılmıyor.
- [ ] Normal, boş, yükleniyor ve hata durumları tasarlandı.
- [ ] Ana eylem mobilde başparmak erişimine uygun.
- [ ] Dokunma alanları en az 44×44 px.
- [ ] Klavye odağı görünür.
- [ ] Uzun Türkçe metinde taşma yok.
- [ ] Alt navigasyon içerikle çakışmıyor.
- [ ] Modal/alt panel odak yönetimi çalışıyor.
- [ ] Reduced motion seçeneği uygulanıyor.
- [ ] Hassas alışkanlık metni kilit ekranında gizlenebiliyor.
- [ ] Motivasyon dili yargılayıcı değil.
- [ ] İşlem sonrası görünür geri bildirim var.
- [ ] Mobil, tablet ve masaüstü görünümü kontrol edildi.

## 38. Tasarımın tamamlanma tanımı

Tasarım; tüm MVP ekranları ve ana durumlar tanımlandığında, renk tokenları uygulamada merkezi olarak kullanıldığında, pozitif/negatif ilerleme ile turuncu yeniden başlama hali tutarlı biçimde çalıştığında, erişilebilirlik kontrolleri geçtiğinde ve gerçek Türkçe içerikle mobil–masaüstü görsel doğrulama yapıldığında tamamlanmış kabul edilir.

Ortaya çıkacak deneyim kullanıcıya şu hissi vermelidir: **“Geçmişimi görebiliyorum, şu an ne yapacağımı biliyorum ve bir aksama yaşasam bile yeniden başlayabilirim.”**
