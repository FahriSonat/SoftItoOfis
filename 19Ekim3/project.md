#Fitness Su Takip uygulaması
bu döküman Flutter projesinde geliştirme yapacak olan ajan yapay zeka ve geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.

##1.Projenin Özeti ve Teknolojiler
-**Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)
-**Hedef platform:** İOS VE ANDROİD öncelikli ardından web ve masaüstü platformları.
**Flutter SDK:** 3.39.4
**Dart SDK:** 3.14.0
**Tasarım Dili:** Material 3, Koyu Tema (gece spor salonunda göze çarpmayan şık bir görüntü) 

##Mimari Yapı : Özellik bazlı (feature-based) katmanlı mimari kullanılacaktır.

lib/
├─ core/
extensions/
│  ├─ theme/             # Temel tema ayarları
│  ├─ constants/         # Sabitler
│  ├─ utils/             # Yardımcı fonksiyonlar
│  └─ navigation/        # Navigasyon (go_router)
│
├─ features/
│  ├─ water_tracking/    # Su takibi
│  ├─ exercise/          # Egzersiz
│  ├─ nutrition/         # Beslenme
│  ├─ workout_history /   # Egzersiz Geçmişi 
│  ├─ user_profile/      # Kullanıcı Profili
│  ├─ login/             # Giriş Ekranı 
│  ├─ register/          # Kayıt Ekranı 
│  ├─ reset_password/    # Şifre Sıfırlama
│  ├─ splash/            # Açılış Ekranı 
│  ├─ onboarding/        # İlk Kullanım Ekranı 
│  └─ settings/          # Ayarlar Ekranı
│
└─ main.dart


## 3 Kırmızı Çizgiler kod kalite standartları
1- **State Yönetim Standartları:**
Sayfa düzeyinde ağır 'setState' KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans** 
Statik tüm widgetlarda `const` zorunludur.
Renk paleti 'lib/core/theme/app_theme.dart' dosyasında tanımlanan `AppColors` sınıfından alınacaktır.  

## 4 geliştirme kuralları 
ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutlarun çalıştığını doğrulamalıdır.

* **statik kod analizi**
```bash
flutter analyze
````

* **Birim testleri**
```bash
flutter test
```
* **projeyi çalıştırma**
```bash
flutter run
```
## % ajanın çıktı ve yanıt verme standartları 
**açıklamlar** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
** değişiklik önerileri ** her zaman projenin mevcut mimari ve kodlama standartlarına tam uyum sağlamalıdır.