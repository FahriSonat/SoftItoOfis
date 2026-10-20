# RotaRent — Araç Kiralama Uygulaması

RotaRent; konum ve tarihe göre araç arama, gelişmiş filtreleme, şeffaf ödeme ve yükümlülükler sözleşmesi, kullanıcı hesap yönetimi ve anlık canlı GPS araç takibi sunan modern bir Flutter uygulamasıdır.

Bu proje `project.md`, `design.md` ve `.agents/skill/SKILL.md` yönergelerine tam sadık kalarak Material Design 3 prensipleriyle geliştirilmiştir.

---

## 📱 5 Temel Ekran & Alt Navigasyon Mimarisi

Kullanıcı talebine uygun olarak ekranlar alt navigasyon çubuğunda 5 buton halinde düzenlenmiştir:

1. **[0] Ödeme Ekranı (En Sol Buton):**
   - Kart Bilgileri: Kart Sahibi Adı, 16 haneli Kart Numarası, Son Kullanma Tarihi (AA/YY), CVV/CVC, 3D Secure onay seçeneği.
   - Kiralama Yükümlülükleri: Yaş/ehliyet şartı (en az 21 yaş, 2 yıllık ehliyet), 350 km günlük sınır, yakıt teslim politikası, kaza prosedürü ve sözleşme onay kutusu.
   - Şeffaf Ücret Dökümü: Kiralama bedeli, kasko, hizmet bedeli, indirim kuponu ve toplam tutar.
   - Başarılı ödeme sonrası canlı GPS takip ekranına anında yönlendirme.

2. **[1] Araç Kiralama Ekranı (Orta Butonun Solu):**
   - Detaylı Araç Filtreleri:
     - **Model:** Dinamik metin arama çubuğu
     - **Sınıf:** Ekonomik, Konfor, Prestij, Lüks, SUV, Spor
     - **Cinsi / Kasa:** Sedan, Hatchback, SUV, Coupe
     - **Marka:** Renault, Fiat, BMW, Mercedes-Benz, Peugeot, Toyota, Volkswagen, Volvo, Tesla, Porsche, Hyundai
     - **Üretim Yılı:** 2022, 2023, 2024 ve üzeri
     - **Motor:** 1.0 TSI, 1.3 TCe, 1.4 Fire, 1.5 BlueHDi, 1.8 Hybrid, 2.0 TwinPower, Tam Elektrikli
     - **Şanzıman:** Otomatik, Manuel
     - **Yakıt:** Benzin, Dizel, Hibrit, Elektrik
     - **Fiyat:** Günlük maksimum bütçe slider'ı (800 ₺ - 10.000 ₺)
   - Canlı filtrelenen araç kartları listesi ve filtre temizleme.

3. **[2] Ana Ekran (TAM ORTA BUTON):**
   - **En Üstte:** "RotaRent" marka logosu ve "Hoş Geldiniz, Ahmet Yılmaz 👋" kişiselleştirilmiş selamlama.
   - **Üst Bölüm:** Kiralama Konumu (Alış ve İade Yeri seçimi) ve Takvim (Alış Tarihi/Saati, İade Tarihi/Saati seçici modal).
   - **Ortada:** Yüksek kaliteli **Araç Filosu** görseli & hero banner'ı ("150+ SUV, Sedan, Elektrikli ve Lüks Araç").
   - **Altında:** İndirim & Fırsat bandı ("YAZ SEZONUNA ÖZEL %25 İNDİRİM! Kod: ROTA25").
   - **Popüler Araçlar:** Hızlı kiralama önerileri ve araç kartları.

4. **[3] Hesabım Ekranı (Orta Butonun Sağı):**
   - Kullanıcı Profil Kartı: Avatar, İsim, E-posta, Telefon, Rozet.
   - 6 Ayrı Bölüm:
     - **Aktif Kiralamalar:** Devam eden kiralama detayı, kalan süre sayacı ve "Aracımı Haritada Canlı Takip Et" butonu.
     - **Önceki Kiralamalar:** Geçmiş kiralamalar ve fatura görüntüleme.
     - **Ödeme Bilgileri:** Kayıtlı kredi kartları ve fatura adresi.
     - **Hesap Ayarları & Tema:** Material 3 Sistem / Açık / Koyu tema değiştirici (`SegmentedButton`).
     - **İndirimler:** Mevcut kuponlar (ROTA25, HOSGELDIN250, HAFTASONU15) ve kupon tanımlama.
     - **SSS:** Akordeon şeklinde sıkça sorulan sorular ve cevaplar.

5. **[4] Canlı GPS / Harita Ekranı (Son Ekran):**
   - Vektörel interaktif harita simülasyonu (Marmara sahili, Kadıköy, Bağdat Caddesi, arter yollar, parklar).
   - Canlı araç pin'i üzerinde radar nabız efekti (pulsating animation).
   - Canlı telemetri paneli: Anlık hız (km/s), Yakıt/Şarj seviyesi (%), Kapı kilidi durumu, Motor durumu, Açık adres bilgisi.
   - Araç kontrol simülasyonu: "Kapıları Kilitle / Aç", "Flaşörleri Yak / Korna Çal", "Aracımın Yanına Rota Başlat".

---

## 🛠️ Teknoloji & Mimari

- **Flutter & Null-safe Dart**
- **Material Design 3 (`useMaterial3: true`)**
- **State Yönetimi:** Riverpod (`flutter_riverpod` Notifier & Provider)
- **Tema:** Açık ve Koyu tema renkleri (`#3157D5` seed, `AppColors`, `AppTheme.light()`, `AppTheme.dark()`)
- **Tarih & Para Biçimlendirme:** Türkçe yerel ayar, TRY (`₺`), `dd.MM.yyyy, HH:mm`

---

## 🚀 Çalıştırma & Test

### Bağımlılıkları Yükleme
```bash
flutter pub get
```

### Uygulamayı Çalıştırma
```bash
flutter run
```

### Kod Biçimlendirme Kontrolü
```bash
dart format --set-exit-if-changed .
```

### Statik Kod Analizi
```bash
dart analyze
```

### Testleri Çalıştırma
```bash
flutter test
```
