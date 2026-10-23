# 🌿 Denge — Çift Yönlü Alışkanlık Takip ve Farkındalık Uygulaması

<p align="center">
  <img src="https://img.shields.io/badge/React-19.3-61dafb?style=for-the-badge&logo=react&logoColor=black" alt="React 19" />
  <img src="https://img.shields.io/badge/TypeScript-6.0-3178c6?style=for-the-badge&logo=typescript&logoColor=white" alt="TypeScript" />
  <img src="https://img.shields.io/badge/Vite-8.3-646cff?style=for-the-badge&logo=vite&logoColor=white" alt="Vite" />
  <img src="https://img.shields.io/badge/Vitest-16%20Passed-44cf6c?style=for-the-badge&logo=vitest&logoColor=white" alt="Vitest Tests" />
  <img src="https://img.shields.io/badge/Design-Dark%20Mode-121826?style=for-the-badge" alt="Dark Mode" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
</p>

<p align="center">
  <strong>"Uzak durduklarını güçlendir, hayatına kattıklarını büyüt."</strong>
</p>

<p align="center">
  Denge, kullanıcıların sağlıklı ve yapıcı rutinler kazanırken aynı zamanda zararlı alışkanlıklardan yargılanmadan uzaklaşmasını sağlayan modern, mobil öncelikli bir <strong>çift yönlü alışkanlık takip ve davranış yönetimi</strong> web uygulamasıdır.
</p>

---

## 📑 İçindekiler

- [🌟 Neden Denge?](#-neden-denge)
- [✨ Temel Özellikler](#-temel-özellikler)
- [🧱 Sistem Mimarisi & Dizin Yapısı](#-sistem-mimarisi--dizin-yapısı)
- [🛠️ Teknoloji Yığını](#️-teknoloji-yığını)
- [🚀 Hızlı Başlangıç & Kurulum](#-hızlı-başlangıç--kurulum)
- [🧪 Testler ve Kalite Kontrol](#-testler-ve-kalite-kontrol)
- [📖 Kullanım Rehberi](#-kullanım-rehberi)
- [🐙 Projeyi GitHub'a Yükleme Rehberi](#-projeyi-githuba-yükleme-rehberi)
- [🤝 Katkıda Bulunma (Contributing)](#-katkıda-bulunma-contributing)
- [📄 Lisans](#-lisans)

---

## 🌟 Neden Denge?

Geleneksel alışkanlık takip uygulamaları genellikle yalnızca "yapıldı / yapılmadı" onay kutuları sunar ve bir gün kaçırıldığında kullanıcıda suçluluk veya yetersizlik hissi uyandırır.

**Denge'nin Farkı:**
1. **Yargılamayan Destek Dili:** Bir seri bozulduğunda kullanıcıya "Başarısız oldun!" denmez; *"12 günlük emeğin kaybolmadı; bu deneyim hâlâ senin"* felsefesiyle yaklaşılır.
2. **Çift Yönlü Takip:**
   - **Pozitif Alışkanlıklar:** Su içme, kitap okuma, spor, sanat vb.
   - **Negatif Alışkanlıklar:** Sigara, alkol, sağlıksız beslenme, kumar, sosyal medya vb.
3. **Bilişsel & Davranışsal Araçlar:** Yalnızca sayaç değil; tetikleyici notları, duygu yoğunluğu (1-5), kişiselleştirilmiş çözüm yöntemleri ve anlık krizlerde **"Zorlanıyorum"** destek akışı sunar.
4. **Dinamik Renk Aşamaları:** Negatif alışkanlıklarda uzak durulan süre uzadıkça kırmızıdan canlı yeşile; pozitif alışkanlıklarda maviden turkuaza dönen motivasyonel renk sistemi.

---

## ✨ Temel Özellikler

### 🛡️ 1. Negatif Alışkanlıklardan Uzak Durma
- **Gerçek Zamanlı Sayaç:** Başlangıç anından itibaren saniye, dakika, saat ve gün bazında kesintisiz süre ölçümü.
- **Tasarruf & Kazanım Tahmini:** 
  - Sigarada içilmeyen adet ve kurtarılan bütçe,
  - Alkolde tasarruf edilen kalori ve para,
  - Ekran ve oyun bağımlılığında hayata geri kazanılan saatler.
- **Kademeli Renk Gelişimi:** 1. gün (Kırmızı) ➔ 3. gün (Mercan) ➔ 7. gün (Amber) ➔ 14. gün (Sarı-Yeşil) ➔ 30+ gün (Yeşil).

### 🌟 2. Pozitif Alışkanlık Kazanma
- **Esnek Programlar:** Günlük, haftalık belirli günler (Pzt, Çar, Cum), haftalık sıklık (haftada 3 kez) veya aralıklı hedefler.
- **Ölçüm Çeşitleri:** Sayfa sayısı (kitap), litre/ml (su), süre (spor/meditasyon), adet ve evet/hayır.
- **Tek Dokunuşla Kayıt:** Miktar artırma, hızlı tamamlama ve geçmiş 24 saat için kayıt düzenleme imkanı.

### 🆘 3. "Zorlanıyorum" Acil Eylem Modu
- Kullanıcı zararlı bir eyleme yönelme dürtüsü hissettiğinde tek dokunuşla açılır.
- **Dürtü Erteleme:** 2, 5 veya 10 dakikalık odaklanma sayacı.
- **Hızlı Mikroeylem:** Su içme, derin nefes alma, odayı değiştirme veya favori çözüm yöntemini uygulama.
- **Dürtü Değerlendirmesi:** Sayaç sonunda dürtünün azalıp azalmadığını kaydetme.

### 🧡 4. Seri Kırılması ve Yeniden Söz Verme (Pledge)
- Seri bozulduğunda ekran yumuşak **turuncu** duruma geçer.
- Kullanıcının önceki birikimi ve en uzun serisi korunur.
- Kullanıcı nedenini ve tetikleyicisini not edip kendine yeni bir söz vererek sıfırdan değil, **deneyimle** yeniden başlar.

### 🧠 5. Tetikleyici ve Çözüm Günlüğü
- Hangi ortamda, hangi duyguyla (stres, can sıkıntısı, yorgunluk) zorlanıldığını kaydetme.
- İşe yarayan çözümleri puanlayıp favorilere ekleme.

### 🏆 6. Rozetler ve Başarılar
- *İlk Adım* (İlk alışkanlık), *Bir Hafta Güçlü* (7 gün seri), *İstikrar Şampiyonu* (30 gün), *Su Dostu* (100L su), *Kitap Kurdu* (İlk kitap), *Yeniden Başladım* gibi motivasyon rozetleri.

### 📅 7. İnteraktif Takvim ve İstatistikler
- Haftalık ve aylık görünüm. Tamamlanan, kısmi, atlanan ve arınma günleri görsel işaretçilerle listelenir.

### 🔒 8. Gizlilik ve Güvenlik
- **Yerel Depolama (Local Storage):** Tüm veriler kullanıcının cihazında güvenle saklanır.
- **Nötr Bildirimler:** Hassas alışkanlıklar için kilit ekranında içeriği gizleyen bildirim başlıkları.

---

## 🧱 Sistem Mimarisi & Dizin Yapısı

```text
denge-habit-tracker/
├── public/                 # Statik varlıklar ve ikonlar
├── src/
│   ├── assets/             # Görseller ve fontlar
│   ├── components/         # Modüler UI Bileşenleri
│   │   ├── Calendar/       # Haftalık/Aylık interaktif takvim
│   │   ├── Common/         # Butonlar, kartlar, rozetler
│   │   ├── Detail/         # Alışkanlık detay ve istatistik sayfası
│   │   ├── HabitCard/      # Ana sayfa ve liste kartları
│   │   ├── Modals/         # Ekleme, Kırılma, Dürtü, Profil, Tetikleyici modalları
│   │   └── Navigation/     # Alt navigasyon barı (Negatif | Ana Sayfa | Pozitif)
│   ├── domain/             # İş Mantığı & Saf Fonksiyonlar (Core Engine)
│   │   ├── badgeEngine.ts      # Rozet kontrol ve kazanım kuralları
│   │   ├── colorStage.ts       # Kademeli renk eşik hesaplamaları
│   │   ├── dateUtils.ts        # Tarih ve saat dilimi yönetimi
│   │   ├── savingsEstimator.ts # Maddi / zaman tasarruf hesaplayıcısı
│   │   └── streakEngine.ts     # Pozitif ve negatif streak motoru
│   ├── storage/            # LocalStorage veri erişim ve kalıcılık katmanı
│   ├── styles/             # Temalar, değişkenler ve modern CSS
│   ├── types/              # TypeScript veri modelleri ve arayüzler
│   ├── App.tsx             # Ana uygulama konteyneri ve sekme yönetimi
│   └── main.tsx            # React başlangıç noktası
├── tests/                  # Vitest otomatik test senaryoları
│   ├── complexScenarios.test.ts # Uç durumlar, saat farkları, seriler
│   └── streakEngine.test.ts     # Streak matematik testleri (16 test)
├── project.md              # Kapsamlı ürün gereksinim dokümanı
├── package.json            # Bağımlılıklar ve npm scriptleri
└── vite.config.ts          # Vite derleyici yapılandırması
```

---

## 🛠️ Teknoloji Yığını

| Alan | Teknoloji | Açıklama |
|---|---|---|
| **Kütüphane** | [React 19](https://react.dev/) | Modern Hooks, declarative UI |
| **Dil** | [TypeScript 6](https://www.typescriptlang.org/) | Tip güvenliği ve ölçeklenebilirlik |
| **Derleyici / Build** | [Vite 8](https://vitejs.dev/) | Hızlı HMR ve hafif üretim paketi |
| **İkonlar** | [Lucide React](https://lucide.dev/) | Minimalist ve modern arayüz ikonları |
| **Stil** | Vanilla CSS3 / CSS Variables | Sıfır harici CSS bağımlılığı, tam kontrol |
| **Test** | [Vitest 4](https://vitest.dev/) | Hızlı birim ve entegrasyon testleri |
| **Linter** | [Oxlint](https://oxc.rs/) | Yüksek hızlı kod kalitesi denetleyicisi |

---

## 🚀 Hızlı Başlangıç & Kurulum

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

### Önkoşullar
- Bilgisayarınızda **Node.js** (v18.0 veya üzeri) yüklü olmalıdır. [Node.js İndir](https://nodejs.org/)
- **Git** yüklü olmalıdır.

### 1. Depoyu Klonlayın
```bash
git clone https://github.com/KULLANICI_ADINIZ/denge-habit-tracker.git
cd denge-habit-tracker
```

### 2. Bağımlılıkları Yükleyin
```bash
npm install
```

### 3. Geliştirme Sunucusunu Başlatın
```bash
npm run dev
```

Sunucu başladığında terminalde belirtilen adresi tarayıcınızda açın (Genellikle: `http://localhost:5173`).

---

## 🧪 Testler ve Kalite Kontrol

Uygulama, serilerin yanlış hesaplanmasını veya saat dilimi kaymalarını önlemek amacıyla kapsamlı testlerle donatılmıştır:

```bash
# Tüm birim testlerini çalıştır
npm test

# Kod stili ve lint kontrolü yap
npm run lint

# Üretim (production) derlemesini doğrula
npm run build
```

> 🎯 **16/16 Test Başarılı:** Negatif gün hesabı, haftalık esnek hedefler, seri sıfırlanması ve tasarruf hesaplayıcıları tam test kapsamındadır.

---

## 📖 Kullanım Rehberi

1. **Yeni Alışkanlık Ekle:** Sağ üstteki `+` butonuna veya ilgili sekmeye tıklayın. Hazır şablonlardan seçin (Su, Sigara, Spor vb.) veya kendi özel hedefinizi tanımlayın.
2. **İlerleme Kaydet:** Pozitif kartlarda "Miktar Ekle / Tamamla" butonunu kullanarak gününüzü kaydedin.
3. **Zorlandığın An:** Bir kriz durumunda negatif karttaki **"Zorlanıyorum"** butonuna basın; 2 dakikalık sayaç ve mikro eylem ile dürtüyü kontrol altına alın.
4. **Seri Kırıldığında:** Suçluluk hissetmeden durumu not edin, bir sonraki sefere yeni bir yöntem belirleyin ve **"Söz Ver ve Yeniden Başla"** diyerek devam edin.
5. **Geçmişi İncele:** Alışkanlık kartına dokunarak takvim geçmişinizi, tetikleyici istatistiklerinizi ve başarı rozetlerinizi görüntüleyin.

---

## 🐙 Projeyi GitHub'a Yükleme Rehberi

Eğer bu projeyi kendi GitHub hesabınıza ilk kez yükleyecekseniz, aşağıdaki adımları sırayla takip edebilirsiniz:

### 1. GitHub'da Yeni Bir Repo Oluşturun
1. [GitHub](https://github.com/) hesabınıza giriş yapın.
2. Sağ üstteki `+` simgesine tıklayıp **"New repository"** seçeneğini seçin.
3. Depo adı olarak `denge-habit-tracker` (veya istediğiniz bir isim) girin.
4. Repoyu **Public** veya **Private** olarak seçin (README ekleme kutucuğunu **işaretlemeyin**, çünkü yerelde zaten oluşturduk).
5. **"Create repository"** butonuna tıklayın.

### 2. Proje Dizininde Terminali Açın ve Komutları Çalıştırın
```bash
# 1. Git'i başlatın (eğer daha önce başlatılmadıysa)
git init

# 2. Tüm dosyaları sahneye (stage) ekleyin
git add .

# 3. İlk commit'inizi oluşturun
git commit -m "feat: Denge habit tracker ilk tam sürüm"

# 4. Ana dal adını main olarak belirleyin
git branch -M main

# 5. GitHub reponuzu uzak sunucu (remote) olarak bağlayın
# (Aşağıdaki URL'yi kendi oluşturduğunuz GitHub repo URL'si ile değiştirin)
git remote add origin https://github.com/KULLANICI_ADINIZ/denge-habit-tracker.git

# 6. Kodları GitHub'a gönderin
git push -u origin main
```

---

## 🤝 Katkıda Bulunma (Contributing)

Katkılarınız Denge'yi daha da iyi hale getirecektir! Katkıda bulunmak için:

1. Bu depoyu Fork'layın (`Fork` butonuna tıklayın).
2. Yeni bir özellik dalı açın (`git checkout -b feature/harika-ozellik`).
3. Değişikliklerinizi commit edin (`git commit -m 'feat: Yeni bir rozet eklendi'`).
4. Dalınıza push yapın (`git push origin feature/harika-ozellik`).
5. Bir **Pull Request (PR)** açın.

---

## 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) kapsamında lisanslanmıştır. Detaylar için `LICENSE` dosyasına göz atabilirsiniz.

---

<p align="center">
  Sevgi ve denge ile geliştirildi. 🌿<br/>
  <em>Her yeni gün, kendinize verdiğiniz sözü tutmak için yeni bir fırsattır.</em>
</p>
