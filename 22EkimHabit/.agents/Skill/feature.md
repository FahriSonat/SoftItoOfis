# Antigravity Uygulama Promptu — Denge Genişletilmiş Özellik Paketi

## 1. Görev

Mevcut **Denge** Flutter projesine bu belgede tanımlanan bütün özellikleri üretim kalitesinde ekle. Bu belge mevcut dosyaları tamamlayan ek bir ürün ve uygulama şartnamesidir.

Çalışmaya başlamadan önce aşağıdaki dosyaları tamamen oku:

1. `project.md`
2. `skill.md`
3. `design.md`
4. Bu dosya: `antigravity_full_feature_prompt.md`

## 2. Değiştirilemez tasarım kuralı

**`design.md` dosyasını hiçbir koşulda düzenleme, yeniden yazma, biçimlendirme veya silme.** Bu dosya salt okunur tasarım kaynağıdır. Yeni özelliklerin arayüzünü `design.md` içindeki mevcut koyu tema, renk tokenları, tipografi, boşluk sistemi, bileşenler, erişilebilirlik ve hareket kurallarına göre oluştur.

Yeni özellik için tasarım kararı gerektiğinde:

- önce mevcut tasarım sistemindeki semantik bileşenleri yeniden kullan,
- yeni ham renk veya bağımsız görsel dil oluşturma,
- negatif alışkanlıkta kırmızıdan yeşile, pozitif alışkanlıkta maviden turkuaza ve toparlanmada turuncu yaklaşımını koru,
- tasarım dosyasını değiştirmek yerine uygulama kodunda mevcut tokenlardan türeyen bileşen oluştur,
- önemli varsayımı teslim raporunda belirt.

## 3. Kaynak önceliği

Çelişki halinde öncelik:

1. Kullanıcının son açık talebi
2. Bu genişletilmiş özellik belgesindeki açık iş kuralları
3. `project.md`
4. `design.md` — görsel ve etkileşim kuralları için değiştirilemez kaynak
5. `skill.md` — mühendislik ve teslim yöntemi
6. Mevcut kod tabanındaki örüntüler

Bu belge mevcut streak, toparlanma, hatırlatma ve güvenlik kurallarını iptal etmez; onları genişletir.

## 4. Ana amaç

Denge yalnızca bir sayaç uygulaması olmamalıdır. Kullanıcının:

- davranışını tetikleyen koşulları fark etmesine,
- zorlanma anında güvenli ve küçük bir hareket seçmesine,
- pozitif alışkanlıklarını esnek hedeflerle sürdürebilmesine,
- para ve zaman gibi somut kazanımları görmesine,
- ruh hâli ile alışkanlıkları arasındaki örüntüleri anlamasına,
- kayma sonrasında suçluluk yerine öğrenme ve toparlanma süreci yaşamasına,
- hassas verilerini korumasına

yardım eden, local-first bir davranış destek uygulaması oluştur.

Uygulama teşhis, tedavi, tıbbi tavsiye veya acil yardım hizmeti sunduğunu iddia etmemelidir.

---

# BÖLÜM A — ÇEKİRDEK YENİ ÖZELLİKLER

## 5. Tetikleyici haritası ve çözüm analizi

### 5.1. Amaç

Kullanıcının hangi gün, saat, ortam ve ruh hâlinde daha çok zorlandığını; hangi çözüm yöntemlerinin kendisine daha çok yardımcı olduğunu anlaşılır biçimde göstermek.

### 5.2. Veri girişi

Kullanıcı zorlanma notu veya kayma kaydı oluştururken şunları ekleyebilmeli:

- Tarih ve saat
- İlgili alışkanlık
- Zorlanma şiddeti: 1–5
- Tetikleyiciler, çoklu seçim:
  - stres,
  - yalnızlık,
  - sıkılma,
  - öfke,
  - üzüntü,
  - sosyal ortam,
  - yorgunluk,
  - açlık,
  - uykusuzluk,
  - para/maaş günü,
  - belirli kişi veya ortam,
  - özel tetikleyici.
- Serbest metin notu
- Uygulanan çözüm
- Çözüm sonrası istek seviyesi: 1–5
- Sonuç: azaldı, değişmedi, arttı, kayma yaşandı

### 5.3. Analizler

Alışkanlık detayındaki **Örüntüler** bölümünde:

- En sık tetikleyiciler
- En riskli saat aralıkları
- En riskli haftanın günleri
- Zorlanma şiddeti eğilimi
- En çok kullanılan çözümler
- Kullanıcı kayıtlarına göre en yüksek fayda sağlayan çözümler
- Yeterli veri yoksa açıklayıcı boş durum

gösterilmelidir.

“En etkili çözüm” sıralaması, çözüm öncesi ve sonrası şiddet farkı ile başarılı sonuç oranının şeffaf bir bileşimine dayanmalıdır. En az üç kullanım olmadan kesin sıralama gösterme; bunun yerine “Henüz yeterli veri yok” de.

### 5.4. Güvenlik

- Korelasyonu nedensellik olarak sunma.
- “Bu tetikleyici bağımlılığının sebebidir” gibi teşhis kullanma.
- Serbest metin notlarını analitiğe, crash raporuna veya üçüncü tarafa gönderme.
- Grafiklerde renk tek bilgi kanalı olmasın.

## 6. Gelişmiş kriz anı modu

Mevcut “Şu an zorlanıyorum” akışını aşağıdaki yeteneklerle genişlet.

### 6.1. Giriş noktaları

- Ana sayfadaki destek kartı
- Her negatif alışkanlık kartı
- Negatif alışkanlık detay sayfası
- Riskli zaman bildirimi
- Ana ekran widget'ı veya saat uygulaması destekliyorsa hızlı eylem

Kullanıcı en fazla iki dokunuşla destek moduna ulaşmalıdır.

### 6.2. Akış

1. İlgili alışkanlığı seç veya bağlamdan otomatik getir.
2. “Şu anki istek ne kadar güçlü?” sorusuna 1–5 yanıtı al.
3. 60, 90 veya 120 saniyelik erteleme/nefes zamanlayıcısı sun.
4. En fazla üç kişisel çözüm ve üç güvenli varsayılan çözüm göster.
5. Kullanıcı tek bir somut eylem seçsin.
6. Eylem için kısa zamanlayıcı veya kontrol listesi başlat.
7. Sonunda istek seviyesini tekrar sor.
8. Sonucu kaydet: azaldı, aynı, arttı veya kayma yaşandı.

### 6.3. Somut eylemler

- Bir bardak su iç
- Telefonu başka bir odaya bırak
- 5 veya 10 dakikalık yürüyüş başlat
- Ortamdan uzaklaş
- 10 kontrollü nefes al
- Alışverişi 24 saat ertele
- İlgili uygulamayı kapat
- Kayıtlı destek kişisine ulaş
- Kullanıcının kendi çözümü

### 6.4. Davranış

- Zamanlayıcı uygulama arka plana alınsa da doğru devam etmeli.
- Yarım kalan destek oturumu yeniden açılabilmeli veya güvenle sonlandırılabilmeli.
- Sonuç kaydı zorunlu olmamalı.
- Reduce Motion tercihinde nefes animasyonu statik ilerleme göstergesine dönüşmeli.
- Kullanıcı “Kayma yaşadım” derse mevcut turuncu toparlanma akışına gitmeli.

### 6.5. Profesyonel destek sınırı

Kriz modu acil müdahale veya terapi gibi sunulmamalıdır. Ciddi tıbbi risk, tehlikeli alkol/ilaç bırakma belirtisi ya da kendine/başkasına zarar riski ifade edilirse uygulama otomatik teşhis koymadan profesyonel veya yerel acil desteğe başvurma mesajı göstermelidir. Reçeteli ilacı bırakma veya doz değiştirme önerisi üretme.

## 7. Para, zaman ve tahmini kazanım sistemi

### 7.1. Desteklenen alışkanlıklar

- Sigara
- Alkol
- Kumar
- Kontrolsüz alışveriş
- Oyun
- Sosyal medya
- Sağlıksız beslenme
- Kullanıcının birim maliyet veya süre tanımladığı özel negatif alışkanlıklar

### 7.2. Kurulum alanları

Kullanıcı isteğe bağlı olarak:

- normal kullanım/tüketim sıklığı,
- birim miktarı,
- birim maliyet,
- ortalama günlük/haftalık harcanan süre,
- para birimi

girebilir.

### 7.3. Hesaplama

- Tasarruf yalnızca kullanıcının girdiği referans değerlerinden türetilmeli.
- Para en küçük para biriminde tamsayı veya kesin decimal olarak saklanmalı.
- Oyun/sosyal medya için geri kazanılan süre dakika cinsinden hesaplanmalı.
- Kayma olduğunda geçmiş kazanım sıfırlanmamalı; mevcut seri kazanımı ve toplam tarihsel kazanım ayrı gösterilmeli.
- Tahminler “Yaklaşık” etiketi taşımalı.
- Sağlık veya yaşam süresi kazanımı kesin değer gibi hesaplanmamalı. Bilimsel ve yerelleştirilmiş içerik doğrulanmadan sağlık kazanımı gösterme.

### 7.4. Hedef cüzdanı

Kullanıcı tasarrufunu sembolik bir hedefe bağlayabilmeli:

- kitap,
- eğitim,
- tatil,
- spor ekipmanı,
- borç ödeme,
- özel hedef.

Bu sanal bütçedir; gerçek para transferi veya finansal hesap bağlantısı yapma. İlerleme `tasarruf / hedef tutarı` olarak gösterilir.

## 8. “Neden başladım?” kişisel motivasyon alanı

Her alışkanlıkta kullanıcı:

- kısa ana neden,
- isteğe bağlı uzun mektup,
- gelecekteki kendisine mesaj,
- isterse yerel cihazdan bir görsel

ekleyebilmelidir.

Bu içerik:

- alışkanlık detayında,
- kriz modunda,
- riskli zaman bildiriminde gizlilik tercihine uygun biçimde,
- seri bozulma/toparlanma ekranında

gösterilebilir.

Kullanıcı metni otomatik olarak değiştirme. Yapay motivasyon metni kişisel mesajın yerine geçmemeli. Görseller yalnızca yerel saklanmalı ve kullanıcı silince ilişkili dosya da güvenle kaldırılmalıdır.

## 9. Destek kişisi

### 9.1. Kurulum

Kullanıcı tamamen isteğe bağlı olarak bir veya daha fazla destek kişisi ekleyebilmeli:

- görünen ad,
- telefon numarası,
- iletişim yöntemi: arama veya SMS,
- hangi alışkanlıklarda gösterileceği,
- hazır mesaj şablonu.

Kişiler erişimi için izin ancak kullanıcı rehberden kişi seçmek istediğinde istenmelidir. Kullanıcı bilgiyi elle de yazabilmelidir.

### 9.2. Kullanım

Kriz modunda:

- “Ara” sistem arama ekranını açar.
- “Mesaj hazırla” sistem mesaj ekranını alıcı ve taslakla açar.
- Kullanıcı son gönderme eylemini kendisi yapar.

Uygulama kullanıcının açık, o anki onayı olmadan mesaj gönderemez veya arama başlatamaz. Destek kişisine streak, not veya sağlık verisi otomatik aktarılmaz.

Örnek taslak:

> “Şu an biraz zorlanıyorum. Müsaitsen kısa bir konuşmaya ihtiyacım var.”

## 10. Kural tabanlı akıllı hatırlatmalar

### 10.1. İlke

Akıllı hatırlatmalar ilk sürümde cihaz üzerinde çalışan, açıklanabilir ve kural tabanlı olmalıdır. Bulut yapay zekâsı veya hassas veriyi dışarı gönderen tahmin sistemi kullanma.

### 10.2. Kurallar

- En az beş zorlanma kaydı varsa sık görülen saatten 15–30 dakika önce destek hatırlatması önerebilir.
- Aynı bildirim üst üste üç kez ertelenirse sıklığı azaltmayı teklif eder.
- Kullanıcı bir bildirim türünü sürekli kapatıyorsa otomatik artırma yapmaz.
- Pozitif alışkanlık hedefi planlı periyodun sonuna yaklaşırken tamamlanmadıysa nazik bir hatırlatma sunabilir.
- Haftalık değerlendirme kullanıcının seçtiği gün ve saatte gelir.
- Sessiz saatlere ve sistem izinlerine uyar.
- Bildirim hassasiyet tercihi açıksa alışkanlık adı ve kişisel mesaj kilit ekranında gizlenir.

### 10.3. Açıklanabilirlik

Her adaptif önerinin yanında neden göster:

> “Son kayıtlarda en çok 20.00–22.00 arasında zorlandığını belirttin. Bu saatten önce hatırlatma ister misin?”

Kullanıcı kabul etmeden yeni adaptif bildirim oluşturma.

## 11. Günlük ruh hâli ve enerji kontrolü

### 11.1. Giriş

Günde en fazla bir ana check-in; kullanıcı isterse düzenleyebilir:

- Ruh hâli: 1–5
- Enerji: 1–5
- Stres: 1–5
- Uyku süresi: isteğe bağlı saat/dakika
- Uyku kalitesi: 1–5
- Kısa not: isteğe bağlı

### 11.2. Analiz

- Haftalık ruh hâli, enerji ve stres eğrisi
- Pozitif alışkanlık tamamlanan/tamamlanmayan günlerin karşılaştırması
- Negatif zorlanma kayıtlarıyla aynı güne denk gelen ruh hâli örüntüleri
- Yeterli veri yoksa yorum üretmeme
- En az 14 check-in olmadan güçlü örüntü cümlesi göstermeme

Kullanılabilecek dil:

> “Kayıtlarına göre yürüyüş yaptığın günlerde ruh hâli puanın ortalama olarak daha yüksek görünüyor.”

Kullanılmaması gereken dil:

> “Yürüyüş depresyonunu tedavi ediyor.”

## 12. Esnek üç seviyeli hedef sistemi

Pozitif alışkanlıklar için kullanıcı şu hedefleri tanımlayabilmeli:

- **Minimum hedef:** Zor günlerde streak'i koruyacak en küçük geçerli adım
- **Normal hedef:** Günlük/planlı ana hedef
- **Güçlü gün hedefi:** İsteğe bağlı yüksek hedef

Örnek:

```text
Kitap okuma
Minimum: 5 dakika
Normal: 20 dakika
Güçlü gün: 40 dakika
```

### 12.1. Streak davranışı

- Minimum hedef tamamlanırsa planlı periyot başarılı sayılır ve streak korunur.
- Normal hedef tamamlanırsa standart başarı işaretlenir.
- Güçlü gün hedefi tamamlanırsa ek kutlama/istatistik kazanılır fakat streak değeri fazladan artmaz.
- Minimum başarı ile normal başarı takvimde ikon/etiketle ayrılır; kullanıcı utandırılmaz.
- Bir periyotta yapılan çoklu girişler toplanır.
- Minimum `> 0`, normal `>= minimum`, güçlü gün `>= normal` olmalıdır.
- Güçlü gün hedefi zorunlu değildir.

### 12.2. İstatistik

- Minimum tamamlanan periyot sayısı
- Normal tamamlanan periyot sayısı
- Güçlü gün sayısı
- Toplam değer
- Normal hedefe ulaşma oranı

## 13. Dondurma ve izin modu

### 13.1. Amaç

Hastalık, seyahat, tıbbi süreç veya olağanüstü durumda kullanıcının planını dürüst biçimde duraklatmasını sağlamak.

### 13.2. Kurallar

- Kullanıcı başlangıç ve bitiş tarihi seçer.
- Sebep kategorisi isteğe bağlıdır: hastalık, seyahat, yoğun dönem, tıbbi tavsiye, diğer.
- Pozitif alışkanlıklarda dondurulmuş planlı periyotlar streak'i artırmaz veya bozmaz.
- Negatif alışkanlıkta “uzak kalma” gerçekte devam ediyorsa kronometreyi dondurmak yanlış olur. Bu nedenle negatif alışkanlık için iki ayrı işlem sun:
  - bildirimleri geçici durdur,
  - takibi tamamen duraklat ve yeni başlangıç gerektir.
- Geçmişe dönük dondurma yalnızca son 24 saat için ve açık onayla yapılabilir.
- Dondurulmuş günler takvimde ayrı ikon ve “Donduruldu” etiketiyle görünür.
- Dondurma başarı kaydı üretmez.
- Varsayılan üst sınır 30 gündür; daha uzun süre açık gerekçeyle yeniden onay ister.

Bu özellik streak'i yapay biçimde koruyan sınırsız “joker” mekanizmasına dönüşmemelidir.

## 14. Geri dönüş analizi

Toparlanma tamamlandıktan sonra kullanıcıya hemen değil, tercihine göre 24 saat sonra veya haftalık değerlendirmede kısa bir geri dönüş özeti sun.

Özet:

- Önceki seri süresi
- Olayın zamanı
- Seçilen tetikleyiciler
- Uygulanan veya atlanan çözüm
- Kullanıcının yeni küçük adımı
- Sonraki benzer zaman için hazırlık önerisi

Kullanıcı “Bundan ne öğrendim?” alanına not ekleyebilir ve bir çözümü sabitleyebilir. Analiz dili suçlayıcı olmamalı. Kayma sayısını rekabetçi skor gibi göstermemelidir.

---

# BÖLÜM B — MOTİVASYON VE OYUNLAŞTIRMA

## 15. Rozet sistemi

### 15.1. Eşikler

Varsayılan rozet eşikleri:

- 3
- 7
- 14
- 30
- 60
- 100
- 180
- 365

Negatif alışkanlıkta eşik uzak kalınan tamamlanmış gün; pozitif alışkanlıkta tamamlanmış planlı periyot olarak yorumlanır.

### 15.2. Kurallar

- Kazanılan rozet geri alınmaz.
- Kayma sonrası rozet kaybolmaz.
- Rozetler para, şans veya rastgele ödül içermez.
- Kumar mekaniğini çağrıştıran çark, loot box, rastgele sandık veya bahis benzeri ödül sistemi kullanma.
- Rozet bildirimi kullanıcı tarafından kapatılabilir.

## 16. Görsel büyüme sistemi

Kullanıcı rozetlere ek olarak bir görsel ilerleme metaforu seçebilir:

- büyüyen ağaç,
- gelişen bahçe,
- aydınlanan yol.

Bu görsel sistem:

- streak ve toplam tutarlılığa göre aşama değiştirir,
- kaymada yok olmaz veya solup ölmez,
- toparlanmada “yeni filiz/yeni yol” metaforu kullanır,
- `design.md` görsel diline uyar,
- kapatılabilir,
- ağır animasyon veya yüksek pil tüketimi oluşturmaz.

Gerekli görsel varlıklar henüz yoksa uygulamayı stok fotoğraf veya tutarsız emojiyle doldurma; semantik placeholder ve varlık sözleşmesi oluştur, eksik asset'i açıkça raporla.

## 17. Haftalık kişisel değerlendirme

Kullanıcının seçtiği zamanda şu özet hazırlanmalı:

- Tamamlanan planlı hedefler
- Korunan negatif seriler
- Minimum/normal/güçlü gün dağılımı
- Haftanın en sık tetikleyicisi
- En çok işe yarayan çözüm
- Ruh hâli ve enerji özeti
- Tahmini kazanılan para ve zaman
- “Bu haftanın güçlü anı” için kullanıcı seçimi veya önerilen kayıt
- Gelecek hafta için tek küçük niyet

Özet geçmiş haftayla karşılaştırma gösterebilir ancak aşağılayıcı kırmızı performans notu üretmemelidir.

## 18. Kişisel rekorlar

- En uzun negatif seri
- En uzun pozitif planlı periyot serisi
- En yüksek haftalık tamamlanma oranı
- En çok okunan sayfa, içilen su, yürüyüş süresi vb.
- En fazla geri kazanılan zaman veya tasarruf

Rekorlar tarihsel olarak korunmalı; aktif streak bozulduğunda silinmemelidir.

## 19. Günlük motivasyon kartları

- Yerel ve önceden gözden geçirilmiş içerik havuzu kullan.
- Aynı mesajı kısa aralıkta tekrar gösterme.
- Mesajı alışkanlık türü ve kullanıcının aşamasına göre seç.
- Kesin sağlık iddiası, utandırma, baskı veya sahte alıntı kullanma.
- Kullanıcı kartları tamamen kapatabilmeli.
- Kişisel “Neden başladım?” mesajı varsa önceliklendirilebilir.

---

# BÖLÜM C — GİZLİLİK VE VERİ KORUMASI

## 20. Uygulama kilidi

- Biyometrik doğrulama için platform özelliğini kullan (`local_auth` benzeri güncel çözüm).
- Biyometri yoksa veya başarısızsa kullanıcı tarafından tanımlanan uygulama PIN'i ile yedek giriş sağla.
- PIN'i düz metin saklama; güvenli, tuzlanmış doğrulama özeti kullan.
- Uygulama arka plana geçtiğinde kullanıcı tercihine göre hemen, 30 saniye, 1 dakika veya 5 dakika sonra kilitle.
- Uygulama geçiş ekranı/app switcher önizlemesinde hassas içeriği maskele.
- Biyometrik verinin kendisi uygulama tarafından saklanmaz.

## 21. Bildirim gizliliği

Üç seviye sun:

1. Tam içerik
2. Alışkanlık adını gizle
3. Yalnızca “Denge'de bir hatırlatman var” göster

Ayar bütün yeni bildirimlere uygulanmalı. Kriz, kayma, ilaç, kumar veya diğer hassas kelimeler gizli modda kilit ekranına yazılmamalıdır.

## 22. Yerel veri ve şifreleme

- Uygulama local-first çalışır.
- Hassas anahtarları platform güvenli depolamasında sakla.
- Veritabanı şifreleme çözümü kullanılacaksa Android/iOS desteğini ve migration stratejisini doğrula.
- Şifreleme eklemek mevcut kullanıcı verisini kaybetmemelidir.
- Not, kişi ve ruh hâli verisini loglama.
- Kullanıcının açık onayı olmadan reklam/analitik SDK'sı ekleme.

## 23. Dışa aktarma, yedekleme ve silme

Kullanıcı:

- JSON veri dışa aktarımı,
- okunabilir CSV özetleri,
- isteğe bağlı PDF raporu,
- parola ile şifrelenmiş tam yedek,
- yedekten geri yükleme,
- bütün verileri kalıcı silme

işlemlerini yapabilmelidir.

Kurallar:

- Dışa aktarmadan önce hassas veri uyarısı göster.
- Paylaşma ekranını yalnızca kullanıcı eylemiyle aç.
- Şifreli yedek parolası unutulursa geri alınamayacağını açıkça belirt.
- Geri yükleme öncesi mevcut veriyi koruma/birleştirme/değiştirme seçimini açıkla.
- Silme iki aşamalı onay ve yeniden kimlik doğrulama gerektirir.
- Silme; veritabanı, yerel görseller, bildirimler ve geçici dışa aktarma dosyalarını kapsar.

## 24. Gizli görünüm

- Kullanıcı tek eylemle seri adlarını ve sayıları bulanıklaştırabilmeli.
- App switcher önizlemesi otomatik gizlenebilmeli.
- Ana ekran widget'ında hassas mod için yalnızca nötr ilerleme göstergesi kullanılmalı.
- Gizli görünüm veri silmez, yalnızca sunumu maskeler.

---

# BÖLÜM D — PLATFORM VE ENTEGRASYON ÖZELLİKLERİ

## 25. Ana ekran widget'ı

Android ve iOS için platform desteklediği ölçüde:

- Bugünkü pozitif hedef sayısı
- Nötr streak özeti
- “Tamamla/Ekle” hızlı eylemi
- “Destek modunu aç” hızlı eylemi
- Gizlilik modu

sunulmalıdır.

Widget verisi ana uygulamayla güvenli ve tutarlı biçimde senkronize olmalı. Widget üzerinden yıkıcı “kayma” işlemi yapılmamalıdır.

## 26. Kilit ekranı ve canlı durum

Platform izin veriyorsa aktif yürüyüş, egzersiz veya kriz erteleme zamanlayıcısı için canlı durum gösterilebilir. Hassas alışkanlık adı varsayılan olarak gösterilmemelidir. Pil tüketimi ve platform kısıtları gözetilmelidir.

## 27. HealthKit ve Health Connect

Entegrasyon adapter tabanlı ve isteğe bağlı olmalıdır.

Desteklenebilecek veriler:

- adım,
- yürüyüş/koşu mesafesi,
- egzersiz süresi,
- aktif enerji,
- uyku süresi,
- su kaydı — platform ve izin uygunsa.

Kurallar:

- Her veri türü için ayrı ve bağlamlı izin iste.
- İzin reddedilince manuel giriş çalışmaya devam etsin.
- Kaynağı belirt: manuel, HealthKit, Health Connect, wearable.
- Aynı kaydı iki kez saymayı önleyen deduplication uygula.
- Sağlık verisini reklam, profil çıkarma veya gereksiz analitik için kullanma.
- Sağlık verisini yazmadan önce ayrı kullanıcı onayı al.

## 28. Akıllı saat uygulaması

Desteklenen platformlarda küçük companion deneyimi:

- Bugünkü alışkanlıkları görme
- Pozitif hedefe hızlı giriş
- Negatif streak özetini gizlilik ayarına göre görme
- Kriz destek zamanlayıcısını başlatma
- Kısa ruh hâli check-in

Saat tek başına ana veri kaynağı olmamalı; çevrimdışı olayları kimlikleriyle kuyruklayıp telefonla birleştiğinde yinelenmeden senkronize etmelidir.

## 29. Ekran süresi entegrasyonları

### Android

- Kullanıcı açıkça izin verirse Usage Access üzerinden uygulama kullanım istatistiklerini okuyabilecek adapter tasarla.
- İzin ekranına neden gerektiğini açıklayan ara ekran koy.
- Kullanım verisi yoksa manuel takip devam etsin.

### iOS

- Screen Time / Family Controls yetkilerinin entitlement ve App Store onayı gerektirebileceğini hesaba kat.
- Yetki sağlanmıyorsa özelliği taklit etme; manuel takip ve sistem ayarlarına yönlendirme sun.

### Ortak kurallar

- Sosyal medya ve oyun süresini kullanıcının seçtiği uygulamalarla sınırla.
- Kullanım verisini cihazdan çıkarmama varsayımı kullan.
- “Otomatik takip” sonuçlarını kullanıcı düzenleyebilsin.
- Platform desteği yoksa düzgün bir unavailable durumu göster.

## 30. Rutin oluşturucu

Kullanıcı birden fazla pozitif alışkanlığı sıraya koyarak rutin oluşturabilmeli:

- Sabah rutini
- Akşam rutini
- Spor öncesi/sonrası
- Kullanıcının özel rutini

Her rutin:

- sıralı adımlar,
- isteğe bağlı adım süreleri,
- başlama zamanı,
- günler,
- toplam tahmini süre,
- adım atlama davranışı

içermelidir.

Rutin streak'i ile alışkanlık streak'i ayrı tutulmalıdır. Bir rutin içindeki alışkanlık tamamlandığında ilgili alışkanlığın kaydına da bir kez yazılmalı; çift kayıt oluşmamalıdır.

## 31. Uzmanla paylaşılabilir PDF raporu

Kullanıcı seçtiği tarih aralığı ve alışkanlıklar için PDF üretebilmeli:

- seri ve tamamlanma özeti,
- ruh hâli/enerji grafiği,
- tetikleyici dağılımı,
- çözüm etkinliği,
- kaymalar ve toparlanmalar,
- kullanıcının paylaşmayı seçtiği notlar.

Varsayılan olarak serbest metin notlarını rapora ekleme. Kullanıcı her hassas veri kategorisini ayrı seçsin. Raporda “Bu belge tıbbi teşhis değildir” açıklaması bulunsun. PDF yalnızca kullanıcı paylaşım ekranını açarsa dışarı gönderilsin.

## 32. Çoklu dil

- Türkçe varsayılan içerik tamamlanmalı.
- İngilizce ARB karşılıkları eklenmeli.
- Tarih, saat, sayı, para ve çoğul ifadeler locale'e göre biçimlenmeli.
- Kullanıcı uygulama dilini sistemden bağımsız değiştirebilmeli.
- Sabit kullanıcı metni widget içinde bulunmamalı.
- Uzun İngilizce/Türkçe metinlerde taşma testi yapılmalı.

## 33. Şifreli cihazlar arası senkronizasyon

Bu özellik çekirdek uygulama tamamlandıktan sonra ayrı bir modül olarak uygulanmalıdır.

Gereksinimler:

- Hesap ve senkronizasyon isteğe bağlıdır; çevrimdışı kullanım korunur.
- Sunucu hassas içeriği düz metin görmemelidir; mümkünse uçtan uca şifreleme yaklaşımı kullan.
- Cihazlar olay tabanlı kayıt kimlikleriyle senkronize olmalı.
- Çakışmalarda sessiz veri kaybı yaşanmaz.
- Kullanıcı hangi cihazların bağlı olduğunu görebilir ve bir cihazın erişimini kaldırabilir.
- Kurtarma anahtarı/parolası güvenli biçimde açıklanır.
- Güvenli backend ve anahtar yönetimi hazır değilse sahte güvenlik iddiası veya güvensiz senkronizasyon ekleme. Adapter/sözleşme ve feature flag bırak, riski raporla.

---

# BÖLÜM E — VERİ MODELİ EKLERİ

## 34. Yeni varlıklar

Mevcut Drift şemasını yıkıcı olmayan migration ile genişlet. Alan adları mevcut kod standardına uyarlanabilir ancak davranış korunmalıdır.

### 34.1. TriggerEvent

```text
id: UUID
habitId: UUID
occurredAtUtc: datetime
localDate: date
timeZoneId: string
intensityBefore: int (1..5)
intensityAfter: nullable int (1..5)
triggerTags: list<string>
customTrigger: nullable string
note: nullable string
selectedSolutionId: nullable UUID
outcome: reduced | unchanged | increased | lapse | unknown
createdAtUtc: datetime
updatedAtUtc: datetime
```

### 34.2. CopingSolution

```text
id: UUID
habitId: nullable UUID
title: string
instructions: nullable string
actionType: water | breathing | walking | leaveEnvironment | delay | contact | closeApp | custom
durationSeconds: nullable int
isPinned: boolean
isSystemProvided: boolean
createdAtUtc: datetime
updatedAtUtc: datetime
```

### 34.3. SupportSession

```text
id: UUID
habitId: UUID
startedAtUtc: datetime
completedAtUtc: nullable datetime
intensityBefore: int
intensityAfter: nullable int
selectedSolutionId: nullable UUID
timerSeconds: nullable int
outcome: nullable reduced | unchanged | increased | lapse | abandoned
```

### 34.4. BaselineConsumption

```text
id: UUID
habitId: UUID
period: day | week | month
quantityMinorUnits: nullable int
costMinorUnits: nullable int
minutesSpent: nullable int
currencyCode: nullable string
effectiveFromLocalDate: date
effectiveUntilLocalDate: nullable date
```

### 34.5. SavingsGoal

```text
id: UUID
title: string
targetAmountMinorUnits: int
currencyCode: string
linkedHabitIds: list<UUID>
createdAtUtc: datetime
archivedAtUtc: nullable datetime
```

### 34.6. PersonalMotivation

```text
id: UUID
habitId: UUID
shortReason: string
letterToSelf: nullable string
futureMessage: nullable string
localImagePath: nullable string
updatedAtUtc: datetime
```

### 34.7. SupportContact

```text
id: UUID
displayName: string
phoneNumber: string
preferredChannel: call | sms
messageTemplate: nullable string
linkedHabitIds: list<UUID>
createdAtUtc: datetime
updatedAtUtc: datetime
```

### 34.8. MoodCheckIn

```text
id: UUID
occurredAtUtc: datetime
localDate: unique date
timeZoneId: string
mood: int (1..5)
energy: int (1..5)
stress: int (1..5)
sleepMinutes: nullable int
sleepQuality: nullable int (1..5)
note: nullable string
createdAtUtc: datetime
updatedAtUtc: datetime
```

### 34.9. GoalLevels

```text
habitId: UUID
minimumValue: decimal > 0
normalValue: decimal >= minimum
strongDayValue: nullable decimal >= normal
effectiveFromLocalDate: date
effectiveUntilLocalDate: nullable date
```

### 34.10. FreezePeriod

```text
id: UUID
habitId: UUID
startsOnLocalDate: date
endsOnLocalDate: date
reasonType: illness | travel | busyPeriod | medicalAdvice | other
reasonNote: nullable string
createdAtUtc: datetime
```

### 34.11. Achievement

```text
id: UUID
habitId: nullable UUID
achievementKey: string
earnedAtUtc: datetime
thresholdValue: decimal
isSeen: boolean
```

### 34.12. Routine ve RoutineStep

```text
Routine:
  id: UUID
  name: string
  scheduleId: UUID
  createdAtUtc: datetime
  archivedAtUtc: nullable datetime

RoutineStep:
  id: UUID
  routineId: UUID
  habitId: UUID
  sortOrder: int
  durationSeconds: nullable int
  optional: boolean
```

### 34.13. WeeklyReview

```text
id: UUID
weekStartLocalDate: date
generatedAtUtc: datetime
strongMomentText: nullable string
nextWeekIntention: nullable string
completedAtUtc: nullable datetime
```

### 34.14. AppSecuritySettings

```text
biometricEnabled: boolean
pinEnabled: boolean
lockDelaySeconds: int
hideInAppSwitcher: boolean
notificationPrivacy: full | hideHabit | generic
privacyModeEnabled: boolean
```

## 35. Migration kuralları

- Mevcut `Habit`, `HabitEntry`, `Schedule`, `Reminder`, `ChallengeNote`, `StreakSegment` ve `RecoveryCommitment` verilerini koru.
- Yeni zorunlu alanlara güvenli varsayılan koy.
- Migration transaction içinde çalışsın.
- Önceki her desteklenen şema sürümünden yükseltme testi yaz.
- Büyük hesaplanabilir özetleri kaynak kayıt yerine gerçek veri kabul etme; gerektiğinde yeniden üretilebilir cache olarak tut.

---

# BÖLÜM F — UYGULAMA PLANI

## 36. Feature flag ve modülerlik

Yeni özellikleri bağımsız modüller ve feature flag'lerle geliştir. Bir modül tamamlanmamışsa çekirdek alışkanlık takibi bozulmamalıdır.

Önerilen yeni feature klasörleri:

```text
features/
  trigger_insights/
  support_mode/
  savings/
  motivation/
  support_contacts/
  adaptive_reminders/
  mood_checkin/
  flexible_goals/
  freeze_mode/
  weekly_review/
  achievements/
  privacy_lock/
  export_backup/
  routines/
  health_integration/
  screen_time/
  widgets/
  wearable/
  sync/
```

## 37. Uygulama sırası

Bütün özellikler kapsam dahilindedir; ancak aşağıdaki sırayla uygulanmalıdır.

### Faz 1 — Davranış desteği

1. Tetikleyici haritası ve çözüm analizi
2. Gelişmiş kriz anı modu
3. “Neden başladım?” alanı
4. Destek kişisi
5. Geri dönüş analizi

### Faz 2 — Sürdürülebilir hedefler

1. Üç seviyeli hedef sistemi
2. Dondurma/izin modu
3. Ruh hâli ve enerji check-in
4. Kural tabanlı akıllı hatırlatmalar
5. Haftalık değerlendirme

### Faz 3 — Somut kazanım ve motivasyon

1. Para ve zaman kazanımı
2. Hedef cüzdanı
3. Rozet ve kişisel rekorlar
4. Günlük motivasyon kartları
5. Görsel büyüme sistemi

### Faz 4 — Gizlilik

1. Biyometrik/PIN uygulama kilidi
2. Bildirim gizlilik seviyeleri
3. App switcher maskeleme ve gizli görünüm
4. Dışa aktarma, şifreli yedek, geri yükleme ve silme

### Faz 5 — Platform özellikleri

1. Ana ekran widget'ı
2. Canlı durum / kilit ekranı desteği
3. HealthKit ve Health Connect
4. Ekran süresi adapterları
5. Rutin oluşturucu
6. Türkçe/İngilizce yerelleştirme tamamlama
7. PDF raporu
8. Akıllı saat companion
9. Güvenli cihazlar arası senkronizasyon

Her faz sonunda uygulama çalışır, test edilebilir ve yayımlanabilir durumda kalmalıdır. Boş buton, sahte veri veya çalışmayan “yakında” ekranı bırakma; hazır olmayan özellik flag ile kapalı olsun.

## 38. Test gereksinimleri

### 38.1. Birim testleri

- Tetikleyici saat/gün gruplama
- Çözüm etkinliği ve minimum örnek sayısı
- Para/tarih aralığı/tüketim değişikliği hesabı
- Mevcut seri ve tarihsel toplam kazanım ayrımı
- Minimum/normal/güçlü hedef validasyonu
- Minimum hedefin streak'i koruması
- Dondurulmuş periyodun streak'i artırmaması veya bozmaması
- Adaptif hatırlatma öneri kuralları
- Ruh hâli analizi için minimum veri eşiği
- Rozetlerin kayma sonrası korunması
- Rutin adımlarında çift kayıt engeli
- Health veri deduplication
- Senkronizasyon çakışma stratejisi

### 38.2. Widget testleri

- Kriz modunun bütün durumları
- Destek kişisine ulaşmadan önce kullanıcı onayı
- Hassas bildirim önizleme seviyeleri
- Uygulama kilidi ve yedek PIN akışı
- Üç seviyeli hedef formu
- Dondurma açıklamaları
- Veri yetersiz analiz boş durumu
- %200 metin ölçeği ve semantik etiketler

### 38.3. Entegrasyon testleri

- Zorlanma kaydı -> destek oturumu -> sonuç -> analiz
- Kayma -> toparlanma -> 24 saat sonra geri dönüş değerlendirmesi
- Minimum hedef -> streak devamı -> haftalık değerlendirme
- Dondurma -> periyot sonu -> doğru streak
- Uygulama arka planı -> otomatik kilit -> biyometri/PIN
- Export -> restore -> kayıt bütünlüğü
- Bildirim -> deep link -> doğru özellik
- Health/manual birleşimi -> çift saymama
- Widget hızlı girişi -> ana uygulama verisi

## 39. Performans hedefleri

- Ana sayfa yerel veriden algılanabilir gecikme olmadan açılmalı.
- Analiz sorguları büyük veri setinde UI thread'i bloke etmemeli.
- Grafikler yalnızca gerekli tarih aralığını sorgulamalı.
- Yıllık geçmişte sayfalama veya toplulaştırılmış sorgu kullanılmalı.
- Widget ve wearable senkronu pil tüketimini artıran sürekli polling yapmamalı.
- Arka plan görevleri platform kısıtlarına uymalı.

## 40. Erişilebilirlik

Mevcut `project.md`, `skill.md` ve `design.md` kurallarına ek olarak:

- Ruh hâli ikonları metin ve sayıyla açıklanmalı.
- Grafiklerin erişilebilir metin özeti bulunmalı.
- Zamanlayıcı yalnızca animasyonla bilgi vermemeli.
- Biyometrik hata mesajları ekran okuyucuyla okunmalı.
- Widget ve saat hızlı eylemleri anlamlı erişilebilir etiket taşımalı.
- Minimum/normal/güçlü başarılar yalnızca renkle ayrılmamalı.

## 41. Yasaklanan tasarım ve davranışlar

- `design.md` dosyasını değiştirmek
- Kumar benzeri ödül, çark, loot box veya rastgele ceza/ödül
- Kayma sonrası rozetleri, geçmişi veya büyüyen görseli yok etmek
- Kullanıcıya “başarısız”, “iradesiz” veya suçlayıcı dil kullanmak
- Reçeteli ilacı azaltma/bırakma talimatı vermek
- Kesin sağlık, tedavi veya yaşam süresi iddiası sunmak
- Destek kişisine otomatik mesaj göndermek
- Kullanıcı kabul etmeden adaptif bildirim oluşturmak
- Ruh hâli verisinden tıbbi teşhis çıkarmak
- Hassas veriyi loglamak veya varsayılan olarak buluta göndermek
- Platformun sağlamadığı özelliği çalışıyormuş gibi göstermek
- Dondurmayı sahte başarıya dönüştürmek
- Gerçek para transferi veya finans hesabı bağlantısı yapmak
- Test yerine sabit/hardcoded demo sonucu göstermek

---

# BÖLÜM G — KABUL KRİTERLERİ

## 42. Fonksiyonel kabul kriterleri

- Kullanıcı tetikleyici ve şiddet kaydı oluşturabilir; yeterli veri oluşunca saat, gün ve çözüm analizini görebilir.
- Kullanıcı en fazla iki dokunuşla kriz moduna girip zamanlayıcı ve küçük eylem başlatabilir.
- Kriz oturumunun önce/sonra şiddeti ve sonucu isteğe bağlı kaydedilir.
- Para ve zaman kazanımı kullanıcı referans değerlerine göre doğru hesaplanır, yaklaşık olarak etiketlenir ve kaymada tarihsel toplam silinmez.
- Kullanıcının “Neden başladım?” mesajı kriz ve toparlanma bağlamında gösterilebilir.
- Destek kişisi aranabilir veya mesaj taslağı açılabilir; uygulama otomatik gönderim yapmaz.
- Adaptif bildirim yalnızca açıklaması gösterilip kullanıcı onayladıktan sonra planlanır.
- Ruh hâli check-in'i kaydedilir; veri yetersizken nedensel yorum gösterilmez.
- Minimum hedef pozitif streak'i korur; normal ve güçlü hedef ayrı istatistiklenir.
- Dondurulan planlı periyot streak'i artırmaz veya bozmaz ve takvimde açıkça işaretlenir.
- Kayma sonrası geri dönüş analizi geçmiş emeği korur ve çözüm planına bağlanabilir.
- Rozetler ve kişisel rekorlar kayma sonrası kaybolmaz.
- Kumar benzeri oyunlaştırma bulunmaz.
- Biyometri/PIN kilidi, gizli bildirim ve app switcher maskeleme çalışır.
- Kullanıcı verisini dışa aktarabilir, şifreli yedekleyebilir, geri yükleyebilir ve kalıcı silebilir.
- Ana ekran widget'ı yıkıcı işlem sunmadan hızlı pozitif giriş ve destek modu erişimi sağlar.
- Health entegrasyonu manuel girişle birlikte çift sayım üretmez.
- Platform ekran süresi yetkisi yoksa özellik düzgün biçimde unavailable/manual duruma düşer.
- Rutin adımı, bağlı alışkanlığa yalnızca bir tamamlama kaydı ekler.
- Türkçe ve İngilizce tüm kullanıcı metinleri ARB dosyalarından gelir.
- PDF raporuna hassas serbest metin yalnızca ayrı kullanıcı seçimiyle eklenir.

## 43. Kalite kabul kriterleri

- `design.md` dosyasının içeriği ve dosya özeti değişmemiştir.
- Mevcut streak ve toparlanma testleri geçmeye devam eder.
- Yeni migration testleri veri kaybı olmadan geçer.
- `dart format`, `flutter analyze` ve `flutter test` başarılıdır.
- Android ve iOS debug build, uygun geliştirme ortamı varsa başarılıdır.
- Yeni izinlerin tamamı bağlamlı açıklamaya ve reddedilme durumuna sahiptir.
- Hassas serbest metinler loglarda bulunmaz.
- Bütün yeni ekranların boş, yükleme, hata ve başarı durumları vardır.
- Büyük yazı, ekran okuyucu ve Reduce Motion davranışları doğrulanmıştır.

## 44. Antigravity teslim yöntemi

Önce mevcut kod ve belgeleri incele. Ardından:

1. Uygulama planını ve etkilenecek modülleri çıkar.
2. Veri migration planını yaz.
3. Faz 1'den başlayarak özellikleri çalışan dikey dilimler halinde uygula.
4. Her dilimde domain testi, repository testi ve kritik widget testi ekle.
5. Her fazın sonunda format, analiz ve testleri çalıştır.
6. Platform entegrasyonlarında gerçek destek yoksa adapter ve dürüst unavailable durumu kullan.
7. `design.md` dosyasını değiştirmediğini dosya özeti veya diff kontrolüyle doğrula.
8. Son raporu aşağıdaki biçimde ver.

```text
Tamamlanan fazlar ve özellikler:
- ...

Veri modeli ve migration'lar:
- ...

Platform izinleri/yapılandırmaları:
- ...

Test ve doğrulama:
- dart format: ...
- flutter analyze: ...
- flutter test: ...
- Android build: ...
- iOS build: ...

design.md bütünlük kontrolü:
- değişmedi / sorun var

Feature flag arkasında kalanlar:
- ...

Bilinen riskler veya kullanıcı kararı gereken noktalar:
- ...
```

İşin bir bölümünü ortam, platform yetkisi veya eksik güvenlik altyapısı nedeniyle tamamlayamazsan bunu çalışanmış gibi gösterme. Mevcut uygulamayı bozmadan feature flag arkasında tut ve gerekli sonraki adımı açıkça belirt.
