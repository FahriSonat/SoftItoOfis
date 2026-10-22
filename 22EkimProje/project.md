# Denge — Pozitif ve Negatif Alışkanlık Takip Uygulaması

> Bu belge, Antigravity tarafından geliştirilecek mobil öncelikli alışkanlık takip uygulamasının ürün kapsamını, iş kurallarını, kullanıcı akışlarını, veri gereksinimlerini ve kabul kriterlerini tanımlar. Görsel sistemin ayrıntıları `design.md`, geliştirme ajanının uygulama kuralları ise `skill.md` içinde ayrıca tanımlanacaktır.

## 1. Projenin özeti

Denge, kullanıcıların yararlı alışkanlıklar kazanmasına ve zararlı alışkanlıklardan uzak durmasına yardımcı olan, iki yönlü bir alışkanlık takip uygulamasıdır. Uygulama yalnızca “yapıldı/yapılmadı” kaydı tutmaz; kullanıcının zorlandığı anları fark etmesini, tetikleyicilerini not etmesini, çözüm yöntemleri oluşturmasını ve kritik anlarda küçük bir eyleme yönelmesini sağlar.

Uygulamanın iki ana takip alanı vardır:

- **Negatif alışkanlıklardan uzak durma:** Sağlıksız beslenme, alkol, sigara, kumar, oyun bağımlılığı, gereksiz ilaç kullanımı, sosyal medya bağımlılığı ve alışveriş bağımlılığı.
- **Pozitif alışkanlık kazanma:** Sağlıklı beslenme, su içme, yürüyüş/koşu, spor, kitap okuma, enstrüman çalma, resim ve diğer sanat etkinlikleri. Kullanıcı isterse özel bir pozitif alışkanlık da oluşturabilir.

Temel motivasyon modeli **streak (kesintisiz seri)** sistemidir. Negatif alışkanlıklarda streak, zararlı davranıştan uzak geçirilen süreyi; pozitif alışkanlıklarda ise kullanıcının belirlediği programa uygun tamamlanan periyotları gösterir.

## 2. Ürün vizyonu

Kullanıcı uygulamayı açtığında suçluluk veya baskı değil, ilerleme ve kontrol hissi yaşamalıdır. Uygulama:

- olumlu davranışı görünür ve ölçülebilir hale getirmeli,
- zorlanma anlarında kullanıcıyı yargılamadan desteklemeli,
- bir seri bozulduğunda “her şey bitti” algısını engellemeli,
- kullanıcının kendi çözüm repertuvarını oluşturmasına yardım etmeli,
- küçük, uygulanabilir eylemlerle yeniden başlamayı kolaylaştırmalıdır.

## 3. Hedef platform ve ürün biçimi

- Mobil öncelikli, responsive web uygulaması/PWA olarak tasarlanmalıdır.
- Telefon ekranı birincil kullanım ortamıdır; tablet ve masaüstünde düzen bozulmamalıdır.
- Temel akışlar dokunmatik kullanıma uygun olmalıdır.
- MVP, gerçek bir mobil uygulamaya dönüştürülebilecek modüler bir mimariye sahip olmalıdır.
- Kullanıcı hesabı ve bulut senkronizasyonu desteklenmelidir. Demo geliştirme sırasında gerçek backend hazır değilse kalıcı yerel veri ve açıkça ayrılmış bir veri-servis katmanı kullanılabilir.

## 4. Hedef kullanıcılar

- Zararlı bir davranışı bırakmak veya azaltmak isteyen yetişkin kullanıcılar.
- Günlük yaşamına yararlı rutinler eklemek isteyen kullanıcılar.
- Streak, hatırlatıcı ve görsel ilerleme ile motive olan kişiler.
- Tetikleyicilerini ve çözüm yollarını yazarak öz farkındalık geliştirmek isteyen kullanıcılar.

Uygulama bir tıbbi tedavi, psikoterapi veya kriz hizmeti değildir. Bağımlılık ya da ilaç kullanımıyla ilgili yüksek riskli durumlarda profesyonel desteğin yerini aldığı izlenimi verilmemelidir.

## 5. Temel ürün ilkeleri

1. **Yargılamayan dil:** “Başarısız oldun” gibi ifadeler kullanılmamalıdır. Bunun yerine “Serin kesintiye uğradı; bugün yeniden başlayabilirsin” gibi destekleyici metinler kullanılmalıdır.
2. **Gerçek ilerleme:** Streak değerleri cihaz saatine veya arayüz manipülasyonuna değil, kayıtlı zaman damgalarına ve açık kurallara göre hesaplanmalıdır.
3. **Kullanıcı kontrolü:** Hatırlatma saati, sıklık, hedef ve alışkanlık adı düzenlenebilir olmalıdır.
4. **Mahremiyet:** Bağımlılık, sağlık ve kişisel not verileri hassas kabul edilmelidir. Kullanıcı açıkça istemeden herkese açık paylaşım yapılmamalıdır.
5. **Erişilebilirlik:** Bilgi yalnızca renkle aktarılmamalı; renklerin yanında metin, ikon ve durum etiketi bulunmalıdır.
6. **Yeniden başlama kolaylığı:** Seri bozulması kalıcı ceza, veri kaybı veya utandırıcı iletişim üretmemelidir.

## 6. Bilgi mimarisi ve ana navigasyon

Alt navigasyon çubuğu uygulamanın ana iskeletidir ve üç sabit sekmeden oluşur:

1. **Negatif** — sol tarafta
2. **Ana Sayfa** — ortada ve görsel olarak birincil buton
3. **Pozitif** — sağ tarafta

İkincil ekranlar:

- Alışkanlık ekleme ve düzenleme
- Negatif alışkanlık detay sayfası
- Pozitif alışkanlık detay sayfası
- Günlük kayıt/tamamlama ekranı veya alt paneli
- Streak bozulması ve yeniden söz verme ekranı
- Takvim ve geçmiş kayıtlar
- Notlar, zorlayan konular ve çözüm yöntemleri
- Bildirim ayarları
- Profil, genel istatistikler ve rozetler
- Hesap ve gizlilik ayarları

## 7. Onboarding akışı

### 7.1. Karşılama

- Uygulamanın iki yönü kısa biçimde anlatılır: “Uzak durduklarını güçlendir, hayatına kattıklarını büyüt.”
- Kullanıcı kayıt olabilir veya giriş yapabilir.
- MVP’de e-posta ve şifre yeterlidir. Kullanıcı adı isteğe bağlı gösterim adı olarak alınabilir.

### 7.2. İlk hedeflerin seçilmesi

- Kullanıcı en az bir pozitif veya negatif alışkanlık seçebilir.
- Hazır seçenekler listelenir; kullanıcı özel alışkanlık ekleyebilir.
- Aynı isimli alışkanlık yanlışlıkla iki kez eklenmemelidir. Kullanıcı gerçekten ayrı hedefler istiyorsa ayırt edici ad girmelidir.

### 7.3. Başlangıç ayarları

Negatif alışkanlık için:

- bırakma/uzak durma başlangıç tarih ve saati,
- isteğe bağlı önceki kullanım sıklığı,
- isteğe bağlı maliyet bilgisi,
- tetikleyici saatler ve hatırlatma tercihi.

Pozitif alışkanlık için:

- hedef türü,
- hedef miktarı veya süresi,
- tekrar günleri ya da tekrar aralığı,
- hatırlatma saatleri,
- başlangıç tarihi.

### 7.4. Bildirim izni

- İşletim sistemi bildirim izni, kullanıcıya neden gerektiği anlatıldıktan sonra istenir.
- Kullanıcı izin vermese bile uygulama kullanılabilir.

## 8. Ana sayfa

Ana sayfa, iki alışkanlık grubunun genel durumunu tek bakışta sunar.

### 8.1. Üst alan

- Günün tarihi ve kullanıcıya kısa karşılama
- Profil/ayarlar erişimi
- Yeni alışkanlık eklemek için genel `+` butonu

### 8.2. Günlük özet

- Bugün tamamlanması gereken pozitif alışkanlık sayısı
- Aktif negatif alışkanlık streak sayısı
- Tamamlanan görev yüzdesi
- Yaklaşan en yakın hatırlatma

### 8.3. Hızlı kartlar

- Kritik veya zamanı yaklaşan alışkanlıklar önce gösterilir.
- Pozitif kartta “Tamamla / miktar ekle” eylemi bulunur.
- Negatif kartta aktif uzak durma süresi ve “Zorlanıyorum” eylemi bulunur.
- Kullanıcı bir karta dokunarak detay sayfasına gider.

### 8.4. Günlük motivasyon

- Kısa, gerçekçi ve tekrar etmeyen bir motivasyon mesajı gösterilir.
- Mesajlar suçluluk, korku veya kesin sağlık vaadi içermez.

## 9. Negatif alışkanlıklar sayfası

### 9.1. Hazır alışkanlık türleri

- Sağlıksız beslenme
- Alkol
- Sigara
- Kumar
- Oyun bağımlılığı
- Gereksiz ilaç kullanımı
- Sosyal medya bağımlılığı
- Alışveriş bağımlılığı
- Özel negatif alışkanlık

### 9.2. Kart içeriği

Her kartta şunlar bulunmalıdır:

- alışkanlık adı ve ikonu,
- mevcut kesintisiz uzak durma süresi,
- en uzun streak,
- başlangıç tarihi,
- bugünkü durum,
- renk ilerleme göstergesi,
- “Zorlanıyorum” hızlı eylemi,
- detay sayfası bağlantısı.

### 9.3. Negatif streak hesaplama kuralı

- Streak başlangıç zamanı kullanıcının belirlediği tarih ve saattir.
- Kullanıcı davranışı gerçekleştirmediği sürece süre gerçek zamanlı ilerler.
- Arayüz, ilk 24 saatte saat/dakika; sonrasında gün ağırlıklı gösterim yapabilir.
- Kullanıcı “seriyi bozdum” kaydı girerse aktif seri olay zamanında sona erer.
- Yeni seri, kullanıcının yeniden başlama onayından sonra seçilen gerçek başlangıç zamanında başlar.
- Geçmiş seri silinmez; önceki süre ve en uzun seri analitiklerde korunur.
- Kullanıcı yanlış kayıt girdiyse geçmiş kaydı düzenleyebilir; değişiklikler streak’i yeniden hesaplar.

### 9.4. İsteğe bağlı kazanım göstergeleri

Kullanıcı başlangıç verilerini girdiyse ilgili alışkanlıkta şu ölçümler hesaplanabilir:

- sigarada içilmeyen adet ve tahmini maddi tasarruf,
- alkolde tüketilmeyen birim ve tahmini maddi/kalori tasarrufu,
- kumar ve alışverişte harcanmayan tahmini tutar,
- sosyal medya ve oyunda geri kazanılan tahmini süre.

Bu değerler “kesin kazanç” değil, kullanıcının verdiği ortalamalara dayanan **tahmin** olarak etiketlenmelidir.

### 9.5. “Zorlanıyorum” akışı

Kullanıcı bu eyleme dokunduğunda tam ekran veya odaklı bir panel açılır:

1. Kısa ve sakin bir mesaj: “Bu dürtü geçici. Önce 2 dakika erteleyelim.”
2. Kullanıcının önceden kaydettiği çözüm yöntemlerinden biri önerilir.
3. Alışkanlığa uygun küçük bir eylem seçilir: su içmek, kısa yürüyüş, nefes molası, telefonu başka odaya bırakmak, destek kişisine ulaşmak gibi.
4. Kullanıcı `Şimdi yapıyorum` butonuyla eylemi başlatabilir.
5. İsteğe bağlı 2/5/10 dakikalık geri sayım başlatılır.
6. Süre sonunda kullanıcıya “Dürtü azaldı mı?” sorusu sorulur ve sonuç not edilebilir.

Alkol, kumar veya ilaç kullanımı gibi ciddi risklerde profesyonel yardım seçeneği görünür olmalıdır. Reçeteli ilaçlarla ilgili hiçbir ekran ilacı bırakmayı veya doz değiştirmeyi önermemelidir; kullanıcı doktoruna ya da eczacısına danışmaya yönlendirilmelidir.

## 10. Pozitif alışkanlıklar sayfası

### 10.1. Hazır alışkanlık türleri

- Sağlıklı beslenme
- Su içme
- Yürüyüş
- Koşu
- Fitness/spor
- Yüzme
- Yoga/Pilates
- Kitap okuma
- Enstrüman çalma
- Resim/sanat
- Zekâ oyunları
- Özel pozitif alışkanlık

### 10.2. Program ve hatırlatma kuralları

- **Su içme:** Günlük hedef ve gün içine dağıtılmış birden fazla hatırlatma desteklenir. Hızlı miktar girişi yapılabilir.
- **Sağlıklı beslenme:** Günlük hedef varsayılandır. Kullanıcı öğün bazlı veya gün sonu değerlendirmesi seçebilir.
- **Diğer pozitif alışkanlıklar:** Kullanıcı haftanın günlerini, günlük/haftalık sıklığı, hedef süresini veya hedef miktarını belirler.
- Bir alışkanlık için birden fazla hatırlatma saati eklenebilir.
- Erteleme, o gün sessize alma ve bildirimi kapatma seçenekleri bulunur.
- Hatırlatma saati geçince seri anında bozulmaz; ilgili periyot sona erdiğinde değerlendirilir.

### 10.3. Pozitif streak hesaplama kuralı

- Günlük hedeflerde, hedef gün içinde tamamlandıysa streak bir artar.
- Haftanın belirli günlerinde yapılan hedeflerde yalnızca planlı günler streak hesabına katılır. Plansız günler seriyi artırmaz veya bozmaz.
- Haftalık sıklık hedefinde kullanıcı belirlenen sayıya hafta bitmeden ulaşırsa o hafta başarılı sayılır.
- Miktar hedeflerinde (örneğin 2 litre su) hedef miktarına ulaşıldığında gün tamamlanır.
- Süre hedeflerinde (örneğin 30 dakika yürüyüş) toplam kayıt hedef süreye ulaştığında periyot tamamlanır.
- Kullanıcı aynı gün birden fazla kayıt ekleyebilir; kayıtlar günlük toplamda birleştirilir.
- Geçmiş tarih için kayıt ekleme seçeneği ayarlardan sınırlandırılabilir; varsayılan olarak son 24 saat içinde düzeltme yapılabilir.

### 10.4. Alışkanlığa özel veri girişleri

- **Kitap okuma:** Kitap adı, toplam sayfa, okunan sayfa veya dakika, ilerleme yüzdesi.
- **Koşu/yürüyüş:** Süre, mesafe, isteğe bağlı tempo ve kalori.
- **Diğer sporlar:** Spor türü, süre, isteğe bağlı kalori.
- **Su:** Mililitre/litre, hızlı ekleme değerleri.
- **Sağlıklı beslenme:** Öğün adı, hedefe uygunluk, isteğe bağlı kalori ve not.
- **Enstrüman/sanat:** Süre ve kısa çalışma notu.
- **Özel alışkanlık:** Evet/hayır, adet, süre veya miktar birimlerinden biri seçilir.

## 11. Alışkanlık detay sayfaları

Pozitif ve negatif alışkanlıkların kendi türüne uyarlanmış ayrı detay sayfaları olmalıdır; ancak ortak bilgi mimarisi korunmalıdır.

### 11.1. Ortak alanlar

- Alışkanlık adı, ikonu ve aktif/pasif durumu
- Mevcut streak ve en uzun streak
- Başlangıç tarihi
- Haftalık/aylık takvim
- Tamamlama veya uzak durma geçmişi
- Hatırlatma ayarları
- Düzenleme, arşivleme ve silme işlemleri
- İstatistikler

### 11.2. “Beni zorlayanlar” günlüğü

Kullanıcı her alışkanlık için ayrı notlar oluşturabilir:

- tarih ve saat,
- o anda zorlayan konu/tetikleyici,
- duygu veya ihtiyaç,
- yoğunluk seviyesi (1–5),
- bulunduğu ortam,
- isteğe bağlı serbest metin.

### 11.3. “Çözüm yöntemlerim” alanı

Kullanıcı kendi çözüm kartlarını oluşturabilir:

- çözüm başlığı,
- uygulanacak küçük eylem,
- tahmini süre,
- hangi tetikleyicilerde işe yaradığı,
- ne kadar etkili olduğu (1–5),
- favoriye alma.

“Zorlanıyorum” akışı, favori ve geçmişte etkili bulunan çözümleri öncelikli göstermelidir.

### 11.4. İçgörüler

Yeterli veri oluştuğunda şu içgörüler gösterilebilir:

- en sık zorlanılan saat veya gün,
- en yaygın tetikleyici,
- en etkili çözüm yöntemi,
- son 7/30 gündeki başarı oranı,
- önceki döneme göre değişim.

Az veri varsa kesin çıkarım yapılmamalı; “Henüz yeterli kayıt yok” durumu gösterilmelidir.

## 12. Streak bozulması ve yeniden söz verme deneyimi

Bir seri bozulduğunda ilgili alışkanlığın ekranı geçici olarak turuncu uyarı durumuna geçer.

### 12.1. Gösterilecek içerik

- Serinin sona erdiğini açık ama yargılamayan bir cümle
- Tamamlanan önceki seri: örneğin “12 günlük emeğin kaybolmadı; bu deneyim hâlâ senin.”
- Disiplin ve yeniden başlama üzerine kısa, gerçekçi motivasyon metni
- “Ne oldu?” kısa not alanı (isteğe bağlı)
- Tetikleyici seçimi (isteğe bağlı)
- Bir sonraki benzer durumda kullanılacak çözüm yöntemi
- Yeniden söz verme onayı

### 12.2. Söz verme mekanizması

- Kullanıcı, hazır bir cümleyi onaylayabilir: “Bugün kendim için yeniden başlıyorum.”
- İsterse kendi sözünü yazabilir.
- Ana eylem `Söz ver ve yeniden başla` şeklindedir.
- Kullanıcı söz vermeden de uygulamadan çıkabilir; ekran kilitlenmez ve manipülatif engel oluşturulmaz.
- Söz verildiğinde turuncu durum kapanır, normal tema geri gelir ve yeni seri başlatılır.
- Önceki kayıtlar ve en uzun streak korunur.

## 13. Renk ilerleme mantığı

Renkler yalnızca estetik değil, ilerlemeyi temsil eden durum göstergeleridir.

### 13.1. Negatif alışkanlık

- Yeni başlayan aktif seri kırmızı tonla başlar.
- Süre ilerledikçe renk kırmızı → mercan → amber → sarı-yeşil → yeşil yönünde yumuşak biçimde dönüşür.
- Varsayılan eşikler: başlangıç, 1 gün, 3 gün, 7 gün, 14 gün, 30 gün ve üzeri.
- Uzun hedeflerde renk dönüşümü ilerleme çubuğunda kademeli/gradyan olarak gösterilebilir.
- Kırmızı renk kullanıcıyı cezalandırmak için değil, yolculuğun başlangıç durumunu belirtmek için kullanılır.

### 13.2. Pozitif alışkanlık

- Yeni seri mavi tonla başlar.
- Süre ilerledikçe mavi → camgöbeği → turkuaz yönünde dönüşür.
- Varsayılan eşikler: başlangıç, 3 başarılı periyot, 7, 14 ve 30 başarılı periyot.

### 13.3. Bozulmuş seri

- Turuncu, yalnızca yeniden değerlendirme ve yeniden başlama durumudur.
- Durum renk körlüğüne uygun ikon ve metin etiketiyle birlikte gösterilir.
- Tüm ana arka planlar koyu, temel metinler beyaz/açık gri olmalıdır.

## 14. Takvim ve geçmiş

- Haftalık ve aylık görünüm bulunur.
- Pozitif alışkanlıklar için tamamlanan, kısmen tamamlanan, atlanan ve plansız günler ayrılır.
- Negatif alışkanlıklar için uzak durulan günler, kırılma kaydı ve yeniden başlama anı gösterilir.
- Aynı gün birden fazla alışkanlık varsa çoklu halka, küçük işaretler veya kategori özetleri kullanılabilir.
- Bir güne dokunulduğunda o güne ait tüm kayıtlar ve notlar açılır.
- Kayıt düzeltme işlemi kullanıcıya streak üzerindeki etkisi gösterildikten sonra onaylanır.

## 15. Bildirim sistemi

Bildirim türleri:

- planlı alışkanlık hatırlatmaları,
- su içme hatırlatmaları,
- sağlıklı beslenme/öğün hatırlatmaları,
- yaklaşan periyot sonu uyarısı,
- isteğe bağlı günlük özet,
- uzun süredir kayıt girilmeyen alışkanlık için nazik geri dönüş mesajı.

Kurallar:

- Kullanıcının sessiz saatlerine uyulur.
- Aynı zaman aralığında çok sayıda bildirim yığılmaz; mümkünse özetlenir.
- Bağımlılıklarla ilgili bildirim metni kilit ekranında hassas bilgi açığa çıkarmamalıdır. Kullanıcı nötr bildirim metnini seçebilmelidir.
- Bildirime dokunulduğunda doğrudan ilgili kayıt veya destek akışı açılır.

## 16. Oyunlaştırma ve rozetler

Rozetler destekleyici olmalı, ana motivasyonun önüne geçmemelidir.

Örnekler:

- İlk Adım: İlk alışkanlığı ekleme
- Bir Hafta Güçlü: 7 başarılı periyot
- İstikrar: 30 başarılı periyot
- Su Dostu: Toplam 100 litre su kaydı
- Kitap Kurdu: İlk kitabı bitirme
- Yolcu: Toplam 100 km yürüme/koşma
- Yeniden Başladım: Seri kırıldıktan sonra yeniden başlama

Kazanılmayan rozetler kilitli, kazanılanlar canlı görünür. Rozet şartları açıkça gösterilir.

## 17. Profil ve ayarlar

- Profil bilgileri ve isteğe bağlı avatar
- Genel aktif alışkanlık ve streak özeti
- Kazanılan rozetler
- Bildirim ve sessiz saat ayarları
- Varsayılan ölçü birimleri
- Tema tercihi: ürünün ana tasarımı koyu temadır; ileride açık tema eklenebilir
- Veri dışa aktarma
- Hesap ve tüm verileri silme
- Gizlilik metni
- Çıkış yapma

## 18. Veri modeli

Uygulama veri şeması yeni alışkanlık türleri eklenebilecek şekilde genişletilebilir olmalıdır.

### 18.1. User

- `id`
- `displayName`
- `email`
- `avatar`
- `timezone`
- `locale`
- `createdAt`
- `notificationPreferences`
- `quietHours`

### 18.2. Habit

- `id`
- `userId`
- `name`
- `kind`: `positive | negative`
- `category`
- `icon`
- `colorStage`
- `status`: `active | paused | archived`
- `startAt`
- `measurementType`: `boolean | count | duration | distance | volume | pages | amount`
- `targetValue`
- `unit`
- `scheduleType`: `daily | selected_days | weekly_frequency | interval`
- `scheduleConfig`
- `reminders[]`
- `privacyMode`
- `createdAt`
- `updatedAt`

### 18.3. HabitEntry

- `id`
- `habitId`
- `userId`
- `entryType`: `completion | progress | lapse | abstinence_check | correction`
- `value`
- `unit`
- `occurredAt`
- `note`
- `source`: `manual | wearable | import`
- `createdAt`
- `updatedAt`

### 18.4. StreakPeriod

- `id`
- `habitId`
- `startedAt`
- `endedAt`
- `status`: `active | completed | broken`
- `successfulPeriods`
- `durationSeconds`
- `endReason`
- `restartPledgeId`

### 18.5. TriggerNote

- `id`
- `habitId`
- `userId`
- `occurredAt`
- `triggerTags[]`
- `emotionTags[]`
- `intensity`
- `context`
- `note`

### 18.6. CopingStrategy

- `id`
- `habitId`
- `title`
- `actionText`
- `estimatedMinutes`
- `triggerTags[]`
- `effectivenessScore`
- `isFavorite`
- `timesUsed`
- `createdAt`

### 18.7. RestartPledge

- `id`
- `habitId`
- `previousStreakId`
- `pledgeText`
- `reflection`
- `selectedStrategyId`
- `committedAt`

### 18.8. Badge ve UserBadge

- rozet kimliği, adı, açıklaması, seviyesi, koşul türü ve eşik değeri
- kullanıcı, kazanılma tarihi ve ilerleme değeri

## 19. Streak hesaplama servisinin gereksinimleri

- Hesaplama tek bir merkezi servis/modül üzerinden yapılmalıdır.
- Kullanıcının saat dilimi hesaba katılmalıdır.
- Yaz/kış saati değişimleri seriyi yanlış bozmamalıdır.
- Kayıt silme veya düzeltme sonrasında ilgili tarihten itibaren seri yeniden hesaplanmalıdır.
- Pozitif ve negatif alışkanlıklar ayrı stratejiler kullanmalıdır.
- Hesaplanan sonuçla birlikte neden bilgisi döndürülmelidir: `active`, `completed`, `pending`, `missed`, `broken`.
- Aynı olay iki kez işlendiğinde çift kayıt/çift artış oluşmamalıdır.
- En uzun streak geçmiş veriden güvenilir biçimde türetilmelidir.

## 20. Akıllı saat ve sağlık verileri

Akıllı saat entegrasyonu MVP için zorunlu değildir; mimari daha sonra HealthKit/Health Connect benzeri sağlayıcıların eklenmesine izin vermelidir.

İleri sürümde:

- yürüyüş/koşu mesafesi ve süresi,
- spor aktivitesi ve aktif dakika,
- tahmini kalori,
- veri kaynağı ve son senkronizasyon zamanı

aktarılabilir. Otomatik gelen veri kullanıcı tarafından görülmeli ve gerekli olduğunda düzeltilebilmelidir.

## 21. Güvenlik, etik ve gizlilik gereksinimleri

- Şifreler düz metin saklanmamalıdır.
- Tüm kullanıcı kayıtları kullanıcı kimliğiyle yetkilendirilmelidir.
- Serbest metin notları hassas veri olarak korunmalıdır.
- Analitik veya hata kayıtlarına not içeriği, ilaç adı ya da bağımlılık ayrıntısı yazılmamalıdır.
- Kullanıcı hesabını ve ilişkili verileri silebilmelidir.
- Kumar, alkol, sigara ve ilaç kullanımında uygulama tanı koymamalı veya tıbbi sonuç garantisi vermemelidir.
- “Gereksiz ilaç” kategorisinde, reçeteli ilaçların hekim önerisi olmadan bırakılmaması gerektiği görünür biçimde belirtilmelidir.
- Kriz veya kendine zarar verme içerikleri genel motivasyon sistemiyle ele alınmamalı; uygun acil destek yönlendirmesi gösterilmelidir.

## 22. Erişilebilirlik ve kullanılabilirlik

- Minimum dokunma alanı 44×44 px olmalıdır.
- Metin ve arka plan kontrastı WCAG AA seviyesini hedeflemelidir.
- Tüm ikonların erişilebilir adı olmalıdır.
- Durumlar yalnızca renkle anlatılmamalıdır.
- Hareket azaltma tercihi desteklenmelidir.
- Form hataları ilgili alanın yanında açık bir çözüm cümlesiyle gösterilmelidir.
- Sayaçlar ekran okuyucuyu her saniye rahatsız edecek şekilde canlı bölge olarak güncellenmemelidir.

## 23. Hata ve boş durumları

- İlk alışkanlık yokken açıklayıcı boş durum ve `İlk alışkanlığını ekle` eylemi
- Veri yüklenemediğinde yeniden deneme
- Çevrimdışıyken yerel kayıt ve bağlantı gelince senkronizasyon
- Bildirim izni kapalıysa ayarlara yönlendirme
- Geçersiz hedef veya çakışan saat için alan bazlı hata
- Silme işleminde geri alınabilir bildirim veya onay
- Senkronizasyon çakışmasında en son güncelleme bilgisi ve güvenli birleştirme

## 24. MVP kapsamı

MVP’de mutlaka bulunması gerekenler:

- kayıt/giriş ve temel profil,
- üçlü alt navigasyon,
- hazır ve özel pozitif/negatif alışkanlık ekleme,
- alışkanlık düzenleme, arşivleme ve silme,
- iki türe uygun streak hesaplama,
- günlük/miktar/süre bazlı pozitif kayıt,
- negatif alışkanlıkta uzak durma süresi ve kırılma kaydı,
- kırmızıdan yeşile ve maviden turkuaza ilerleme,
- seri bozulduğunda turuncu yeniden başlama ekranı,
- söz verme akışı,
- alışkanlık detay sayfası,
- zorlayan konular ve çözüm yöntemleri,
- “Zorlanıyorum” destek akışı,
- kişiselleştirilebilir hatırlatmalar,
- haftalık ve aylık geçmiş,
- koyu tema ve erişilebilir durum etiketleri,
- temel rozetler ve genel istatistikler.

MVP sonrası:

- akıllı saat/sağlık platformu entegrasyonu,
- gelişmiş tahminler ve trend analizleri,
- veri dışa aktarma biçimleri,
- daha kapsamlı rozet sistemi,
- cihazlar arası gelişmiş çevrimdışı senkronizasyon.

## 25. Başarı ölçütleri

- İlk oturumda alışkanlık oluşturma oranı
- İlk hafta en az üç kayıt yapan kullanıcı oranı
- 7 ve 30 günlük geri dönüş oranı
- Hatırlatmadan sonra tamamlanan hedef oranı
- “Zorlanıyorum” akışından sonra seçilen eylemi tamamlama oranı
- Seri bozulduktan sonra yeniden başlayan kullanıcı oranı
- Bildirim kapatma ve uygulama terk oranı

Bu ölçümler kullanıcıyı manipüle etmek için değil, ürün deneyimini iyileştirmek için anonimleştirilmiş ve minimum veri ilkesiyle toplanmalıdır.

## 26. Temel kabul kriterleri

1. Kullanıcı pozitif veya negatif bir alışkanlığı hazır listeden ya da özel adla ekleyebilir.
2. Ana navigasyonda solda Negatif, ortada Ana Sayfa, sağda Pozitif sekmesi bulunur.
3. Negatif alışkanlığın aktif uzak durma süresi doğru biçimde ilerler; kırılma kaydında eski seri korunup yeni seri başlatılabilir.
4. Pozitif alışkanlık yalnızca planlı periyottaki hedef tamamlandığında streak kazanır.
5. Su ve sağlıklı beslenme varsayılan olarak günlük; diğer alışkanlıklar kullanıcı programına göre takip edilir.
6. Her alışkanlığın detay ekranında geçmiş, notlar, zorlayan konular ve çözüm yöntemleri bulunur.
7. Kullanıcı `Zorlanıyorum` eylemiyle motivasyon ve küçük eylem önerisi alabilir.
8. Negatif alışkanlık rengi zamanla kırmızıdan yeşile; pozitif alışkanlık rengi maviden turkuaza geçer.
9. Seri bozulduğunda ekran turuncu duruma geçer ve yeniden söz verme deneyimi açılır.
10. Söz verildiğinde normal renk düzeni geri gelir, yeni seri başlar ve eski kayıtlar silinmez.
11. Tüm ana arka planlar koyu, ana metinler açık renktir ve durum bilgisi yalnızca renge bağlı değildir.
12. Bildirimler alışkanlığın planına göre çalışır ve kullanıcı tarafından düzenlenebilir veya kapatılabilir.
13. Reçeteli ilaç kullanımını bırakmaya yönlendiren hiçbir otomatik öneri gösterilmez.
14. Hassas alışkanlık adları için nötr kilit ekranı bildirimleri seçilebilir.
15. Mobil, tablet ve masaüstü yerleşimlerinde temel işlevler kullanılabilir kalır.

## 27. Teslim aşamaları

### Aşama 1 — Ürün temeli ve tasarım sistemi

- bilgi mimarisi,
- veri modeli,
- temel bileşenler,
- koyu tema ve renk durumları,
- onboarding ve navigasyon.

### Aşama 2 — Alışkanlık ve streak çekirdeği

- alışkanlık CRUD işlemleri,
- pozitif/negatif streak motoru,
- kayıt girişleri,
- takvim ve geçmiş.

### Aşama 3 — Davranış desteği

- zorlayan konular günlüğü,
- çözüm yöntemleri,
- “Zorlanıyorum” akışı,
- turuncu yeniden söz verme ekranı,
- bildirimler.

### Aşama 4 — Analiz, kalite ve yayın hazırlığı

- istatistikler ve rozetler,
- erişilebilirlik,
- hata/boş/yüklenme durumları,
- otomatik testler,
- performans ve güvenlik kontrolleri.

## 28. Kapsam dışı varsayımlar

- Sosyal topluluk, herkese açık profil ve arkadaş rekabeti ilk sürümde yoktur.
- Uygulama para yatırma, ödül kazanma veya kumar benzeri oyunlaştırma içermez.
- Tıbbi teşhis, ilaç dozu tavsiyesi ve acil durum müdahalesi sunmaz.
- Yapay zekâ motivasyon metinleri kullanılsa bile güvenlik filtreleri ve önceden tanımlı güvenli alternatifler olmadan sağlık tavsiyesi üretmez.
- Akıllı saat entegrasyonu MVP teslimini engellemez.

## 29. Ürün tamamlanma tanımı

MVP; kabul kriterleri karşılandığında, kritik kullanıcı akışları otomatik ve manuel testlerden geçtiğinde, mobil görünümde kullanılabilirlik sorunları giderildiğinde, veri kaybına yol açan açık hata kalmadığında ve erişilebilirlik kontrolleri tamamlandığında teslim edilmeye hazır kabul edilir.
