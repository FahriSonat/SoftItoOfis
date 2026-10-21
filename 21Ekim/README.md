# 💰 Kişisel Günlük Para Takip Uygulaması (Personal Finance App)

Modern, güvenilir, mobil öncelikli ve koyu temalı kişisel finans takip uygulaması. Gelirleri, zorunlu giderleri, borçları, düzenli faturaları ve bütçe hedeflerini kuruş hassasiyetinde takip etmeye yardımcı olur.

Uygulama, [`project.md`](project.md) iş kurallarına, [`.agents/Skill/SKILL.md`](.agents/Skill/SKILL.md) geliştirme yönergelerine ve [`.agents/Skill/design.md`](.agents/Skill/design.md) tasarım rehberine %100 sadık kalınarak Flutter mimarisinde geliştirilmiştir.

---

## 📌 İçindekiler

- [Öne Çıkan Özellikler](#-öne-çıkan-özellikler)
- [Mimari ve Ekran Yapısı](#-mimari-ve-ekran-yapısı)
- [Finansal İş Kuralları](#-finansal-iş-kuralları)
- [Tasarım Sistemi ve Renk Paleti](#-tasarım-sistemi-ve-renk-paleti)
- [Kullanılan Teknolojiler ve Kütüphaneler](#-kullanılan-teknolojiler-ve-kütüphaneler)
- [Proje Dosya Yapısı](#-proje-dosya-yapısı)
- [Kurulum ve Çalıştırma](#-kurulum-ve-çalıştırma)
- [Test ve Doğrulama](#-test-ve-doğrulama)

---

## 🚀 Öne Çıkan Özellikler

### 1. Bütçe Özeti Dashboard
- **Dönem Net Bakiyesi:** Ayın toplam geliri, gideri ve net nakit akışını tek kartta özetler.
- **Yarım Daire (Semicircular) Gösterge:** 180° yay biçiminde bütçe kullanım oranı (%...), kalan veya aşım tutarını görselleştirir. %80 üzerinde sarı uyarıya, %100 aşımında kırmızıya döner.
- **Yan Yana Gelir ve Gider Panelleri:** Solda yeşil zeminli gelir özeti (`#153224`), sağda kırmızı zeminli gider özeti (`#382027`).
- **Kalan Günlük Harcanabilir Tutar:** Ayın kalan günlerine göre harcanabilecek dinamik tutarı `(Tahmin)` etiketiyle hesaplar. Günlük, haftalık ve aylık limit göstergeleri sunar.

- **İnteraktif Dönem / Ay Gezintisi:** İşlem geçmişi ekranında `<` ve `>` butonları, açılır takvim seçicisi ve "Tüm Zamanlar" filtresi ile aylar arasında kolayca geçiş yapılabilir.
- **Zorunlu Alan Validasyonu:** Tutar, kategori, tarih ve açıklama zorunludur.
- **Hayır İşi / Bağış Giderleri:** Toplam gideri ve bütçeyi etkiler; standart gider rengiyle (kırmızı) gösterilir ve raporlarda alt toplam olarak filtrelenebilir.
- **Özel Tutar Gizleme:** Kullanıcı istediği bir giderin tutarını sansürleyebilir (`₺••••`). Sansürlenen tutar hesaplamalara dahil edilmeye devam eder.
- **Olağan Dışı Gelir Uyarısı:** Maaş veya borç tahsilatı harici bir gelir kaynağı seçildiğinde kullanıcıyı bilgilendiren standart sarı uyarı kartı gösterilir.

### 3. Zarf / Kategori Bütçe Dağılımı
- **50/30/20 Bütçeleme Yöntemi:** Gelirin %50'si Zorunlu İhtiyaçlar (Kira, Mutfak, Fatura), %30'u İstekler & Yaşam (Kafe, Eğlence), %20'si Tasarruf & Borç Ödemelerine ayrılır.
- **Zarf Bütçesi:** Kategori bazında aylık harcama limitleri tanımlama, limit düzenleme ve ilerleme takibi.

### 4. Borç Takibi ve Düzenli Faturalar
- **Verilen ve Alınan Borçlar:** Kişi/kurum, ana para, kalan tutar ve vade bilgileriyle takip edilir.
- **Çift Sayım Koruması:** Borç geri ödemesi yapıldığında veya tahsil edildiğinde nakit akışı işlemi (gelir veya gider) otomatik oluşturulur; çift sayım engellenir.
- **Düzenli Faturalar:** Ödendi olarak işaretlendiğinde gerçekleşen tek seferlik gider kaydı açılır ve fatura sonraki aya ötelenir.
- **Maaş Günü ve Vade Hatırlatmaları:** Vadeye 1 hafta kala ve maaş gününde hatırlatma; maaş gününden sonraki ilk 3 gün borç/kart ödeme penceresi uyarısı.

### 5. Gelecek Ay Simülasyonu
- Beklenen maaş, ek gelir, düzenli faturalar ve borç taksitlerine dayalı projeksiyon (`Tahmin` etiketiyle).
- İnteraktif maaş, ek gelir ve enflasyon/gider artış kaydırıcıları.
- Kalan tasarruf tutarı için bilgilendirici **Dolar ($)**, **Euro (€)** ve **Gram Altın** varlık karşılaştırma senaryoları (yatırım tavsiyesi içermez).

### 6. Raporlar ve Excel (`.xlsx`) Dışa Aktarma
- Günlük, haftalık ve aylık gelir-gider dağılımları.
- Kategori bazında yüzdelik harcama grafikleri.
- Çok sayfalı kapsamlı Excel (`.xlsx`) çıktısı:
  - *Finansal Özet:* Temel finansal göstergeler, toplam gelir/gider, net akış, işlem adetleri, ortalama günlük harcama ve tasarruf oranı.
  - *İşlem Detayları:* Sıra no, tarih, işlem türü (metin olarak "Gelir"/"Gider", ok işareti kullanılmaz), kategori, açıklama, fiş/fatura notu, kaynak, hayır işi ve tutar.
  - *Kategori Analizi:* Kategori bazında toplam harcama, gider payı (%) ve işlem adedi.
  - *Bütçe ve Limitler:* Limit uyumu, kalan/aşım ve tüketim oranı.
  - *Borçlar ve Alacaklar:* Alınan/verilen borçlar, ana para, kalan, ödenen ve vade durumları.
  - *Düzenli Faturalar:* Fatura adı, periyot, tutar ve ödeme durumları.
- Görsel olarak gelir ve gider kayıtlarının yanında ok işaretleri (`↑`, `↓`, `▲`, `▼`, vb.) kullanılmaz; temiz semantik simgelerle (cüzdan, dekont, fatura) ve renklerle ifade edilir.
- Dışa aktarma öncesinde gizli tutarların sansürlenip sansürlenmeyeceği kullanıcıya sorulur (`censorHiddenAmounts`).

---

## 🧠 Finansal İş Kuralları

1. **Floating-Point Yasağı (Kuruş Seviyesinde Integer Temsili):**
   - Para hesaplamalarında `double` kullanılmaz. Tüm tutarlar en küçük para biriminde (`amountMinor: int`, yani kuruş) saklanır (`15050` = `150,50 ₺`). Bu sayede yuvarlama ve ondalık hassasiyet kayıpları engellenir.
2. **Çift Sayım Önleme:**
   - Beklenen fatura ile gerçekleşen gider birbirinden ayrı tutulur.
   - Borç bakiyesi ile gelir-gider nakit akışları ilişkilendirilir; aynı işlem mükerrer sayılmaz.
3. **Gizlilik ve Sansürleme:**
   - Sansürlenen tutarlar genel bakiye, bütçe tüketimi ve rapor toplamlarında tam değerleriyle hesaplanır; yalnızca kullanıcı arayüzünde ve dışa aktarım tercihinde maskelenir.

---

## 🎨 Tasarım Sistemi ve Renk Paleti

`design.md` belgesine göre koyu lacivert-siyah, sakin ve güven veren tema sistemi:

| Belirteç (Token) | Renk Kodu | Kullanım Alanı |
|---|---|---|
| `background` | `#090D18` | Uygulama ana zemin rengi |
| `surface` | `#111827` | Kart, tablo ve modal yüzeyleri |
| `surfaceRaised` | `#192235` | Form alanları, açılır menüler |
| `border` | `#293449` | Kart sınır çizgileri ve ayraçlar |
| `income` | `#22C55E` | Gelir tutarı, ikonu ve pozitif akış |
| `incomeSurface` | `#153224` | Gelir paneli yeşil tonlu kutu zemini |
| `expense` | `#F04452` | Gider tutarı, ikonu ve negatif akış |
| `expenseSurface` | `#382027` | Gider paneli kırmızı tonlu kutu zemini |
| `indicatorBlue` | `#4EA1FF` | Tablo göstergeleri, nötr ilerleme, ana butonlar |
| `warningBackground` | `#FACC15` | Standart uyarı zemini (**Siyah metinle kullanılır**) |
| `warningText` | `#111111` | Standart sarı uyarı metni ve ikonu |
| `criticalBackground` | `#D92D3A` | Kritik uyarı zemini (**Beyaz metinle kullanılır**) |
| `criticalText` | `#FFFFFF` | Kritik kırmızı uyarı metni ve ikonu |

---

## 🛠 Kullanılan Teknolojiler ve Kütüphaneler

| Kütüphane / Teknoloji | Sürüm | Kullanım Amacı |
|---|---|---|
| **Flutter SDK** | `^3.47.7` | Çapraz platform (iOS, Android, macOS, Web) mobil istemci çatısı |
| **Dart** | `^3.13.5` | Tip güvenli programlama dili |
| **provider** | `^6.1.5` | Durum yönetimi (State Management), reaktif veri akışı |
| **shared_preferences**| `^2.5.6` | Yerel cihazda kalıcı veri depolama (Offline-first) |
| **intl** | `^0.20.3` | Türkçe tarih, sayı ve para birimi formatlayıcıları |
| **excel** | `^4.0.6` | Çok sayfalı `.xlsx` finansal rapor dosyaları üretimi |
| **path_provider** | `^2.1.6` | Cihaz belge ve dosya saklama dizinlerine erişim |
| **uuid** | `^4.6.0` | İşlemler, kategoriler ve borçlar için benzersiz kimlik (UUID v4) |

---

## 📂 Proje Dosya Yapısı

```text
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          # design.md renk tokenları
│   │   └── app_theme.dart           # Koyu tema, tipografi ve bileşen stilleri
│   ├── utils/
│   │   ├── currency_formatter.dart  # Kuruş (int) para dönüştürücü ve sansürleme
│   │   ├── date_formatter.dart      # Türkçe yerelleştirilmiş tarih yardımcıları
│   │   └── excel_exporter.dart      # Çok sekmeli Excel (.xlsx) rapor üreticisi
│   └── widgets/
│       ├── app_banner.dart          # Standart sarı/siyah ve kritik kırmızı/beyaz uyarılar
│       ├── app_card.dart            # Temaya uygun standart kart kapsayıcısı
│       ├── confirm_dialog.dart      # Silme ve kritik işlemler için onay diyaloğu
│       └── semicircular_gauge.dart  # 180° yarım daire bütçe göstergesi (CustomPainter)
├── data/
│   ├── mock/
│   │   └── sample_data.dart         # Başlangıç test verileri (Kira, maaş, market, borçlar)
│   ├── models/
│   │   ├── budget.dart              # Bütçe modeli (50/30/20 ve Zarf)
│   │   ├── category.dart            # Kategori modeli (İhtiyaç, İstek, Tasarruf eşleşmesi)
│   │   ├── debt.dart                # Verilen/alınan borç modeli
│   │   ├── recurring_payment.dart   # Düzenli faturalar modeli
│   │   ├── transaction.dart         # Gelir ve gider işlem modeli
│   │   └── user_settings.dart       # Maaş günü, limitler ve bildirim ayarları
│   └── services/
│       ├── finance_repository.dart  # SharedPreferences tabanlı yerel veri servisi
│       └── notification_service.dart# Maaş günü, fatura ve bütçe aşım bildirim motoru
├── providers/
│   └── finance_provider.dart        # Merkezi finans durumu, hesaplamalar ve eylemler
├── screens/
│   ├── budget/
│   │   └── budget_screen.dart       # 50/30/20 ve Zarf bütçe ekranı
│   ├── debts_bills/
│   │   └── debts_bills_screen.dart  # Borç ve düzenli fatura takip ekranı
│   ├── home/
│   │   ├── home_dashboard_screen.dart # Ana özet paneli (Dashboard)
│   │   └── widgets/
│   │       ├── balance_card.dart
│   │       ├── daily_spendable_card.dart
│   │       ├── income_expense_summary_panel.dart
│   │       └── upcoming_reminders_card.dart
│   ├── reports/
│   │   └── reports_screen.dart      # Harcama raporları ve Excel dışa aktarım
│   ├── settings/
│   │   └── settings_screen.dart     # Maaş günü, bütçe ve bildirim tercihleri
│   ├── simulation/
│   │   └── simulation_screen.dart   # Gelecek ay projeksiyonu ve varlık senaryoları
│   └── transactions/
│       ├── transaction_detail_screen.dart # İşlem ayrıntısı, düzenleme ve silme
│       ├── transaction_form_screen.dart   # Gelir/gider ekleme formu
│       └── transactions_list_screen.dart  # Arama, filtreleme ve işlem geçmişi
└── main.dart                        # Uygulama başlangıcı ve 5 sekmeli alt navigasyon
```

---

## 💻 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK 3.20 veya üzeri
- Dart SDK 3.3 veya üzeri
- macOS, Linux veya Windows işletim sistemi
- Tercihen Chrome (Web) veya Xcode/Android Studio (Mobil testler için)

### Adımlar

1. **Bağımlılıkları Yükleyin:**
   ```bash
   flutter pub get
   ```

2. **Statik Kod Analizini Çalıştırın:**
   ```bash
   flutter analyze
   ```

3. **Birim ve Widget Testlerini Çalıştırın:**
   ```bash
   flutter test
   ```

4. **Uygulamayı Başlatın:**
   ```bash
   # Web üzerinde çalıştırmak için:
   flutter run -d chrome

   # macOS masaüstünde çalıştırmak için:
   flutter run -d macos
   ```

5. **Web Paketini Derleyin:**
   ```bash
   flutter build web
   ```

---

## 🧪 Test ve Doğrulama

Uygulamada tüm iş mantığı ve arayüz elementleri otomatik testlerle güvenceye alınmıştır:

- `test/finance_provider_test.dart`:
  - Kuruş tamsayı formatlama ve float hassasiyet kontrolü
  - Sansürlenen özel harcamaların toplamlara eksiksiz dahil edilmesi
  - Hayır işi harcamalarının standart gider rengiyle toplamda ve raporda ayrıştırılması
  - Borç ödemelerinde nakit akışı işlemi oluşturularak çift sayım engellenmesi
  - Fatura ödendiğinde tekil gerçekleşmiş gider oluşumu ve sonraki aya vade aktarımı
- `test/widget_test.dart`:
  - Ana sayfa Dashboard, net bakiye kartı ve bütçe bileşenlerinin duman testi (`smoke test`).
