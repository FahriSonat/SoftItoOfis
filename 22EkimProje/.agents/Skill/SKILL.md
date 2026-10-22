---
name: build-denge-habit-tracker
description: Denge adlı mobil öncelikli pozitif ve negatif alışkanlık takip uygulamasını project.md ve design.md şartlarına göre planlamak, geliştirmek, test etmek ve teslim etmek için kullanılır. Genel amaçlı uygulama geliştirme taleplerinde kullanılmaz.
---

# Denge Uygulamasını Geliştirme Becerisi

Bu becerinin amacı, Antigravity ajanının Denge uygulamasını yalnızca görsel bir prototip olarak değil; doğru streak hesapları, kalıcı veri, bildirim ayarları, erişilebilir durumlar ve güvenli davranış desteği bulunan çalışır bir ürün olarak geliştirmesini sağlamaktır.

## 1. Bağlayıcı kaynaklar ve öncelik sırası

Çalışmaya başlamadan önce aşağıdaki dosyaları tamamen oku:

1. `project.md` — ürün kapsamı, iş kuralları, veri modeli ve kabul kriterleri
2. `design.md` — görsel sistem, ekran yerleşimleri, bileşen davranışları ve responsive kurallar
3. Mevcut repository içindeki teknik talimatlar ve yapılandırmalar

Çelişki olduğunda şu öncelik sırasını kullan:

1. Kullanıcının son açık isteği
2. `project.md` içindeki ürün ve güvenlik kuralları
3. `design.md` içindeki deneyim ve görsel kurallar
4. Bu `skill.md` içindeki geliştirme yöntemi
5. Mevcut kod tabanının alışkanlıkları

Bir belgedeki örnekleri zorunlu ürün kapsamı olarak yorumlama. `project.md` içinde “MVP sonrası” olarak işaretlenen özellikler, kullanıcı ayrıca istemedikçe ilk teslimi engellememelidir.

## 2. Beklenen sonuç

Teslim edilen uygulama:

- mobil öncelikli ve responsive olmalı,
- pozitif ve negatif alışkanlıkları ayrı iş kurallarıyla takip etmeli,
- streak sonuçlarını kayıtlı olaylardan güvenilir biçimde hesaplamalı,
- sayfa yenileme ve yeniden giriş sonrasında veriyi korumalı,
- seri bozulmasını destekleyici bir yeniden başlama deneyimine dönüştürmeli,
- kullanıcı notlarını ve hassas alışkanlık verilerini korumalı,
- yalnızca renk değil metin ve ikonlarla da anlaşılabilir olmalı,
- boş, yükleniyor, hata ve çevrimdışı durumlarını ele almalı,
- test ve doğrulama yapılmadan tamamlanmış sayılmamalıdır.

## 3. Uygulama öncesi inceleme

Kod yazmadan önce:

- Repository yapısını, paket yöneticisini, mevcut framework'ü ve komutları incele.
- Mevcut tasarım sistemi, route yapısı, veri katmanı ve test düzeni varsa bunları koru.
- Kullanıcının mevcut dosyalarını veya ilgisiz değişikliklerini silme ya da üzerine yazma.
- Uygulamanın çalıştırma, test, lint ve build komutlarını tespit et.
- Eksik teknik tercihler için önce mevcut projeden çıkarım yap; yalnızca sonucu önemli ölçüde değiştirecek bir belirsizlik varsa kullanıcıya sor.
- Uygulamayı sıfırdan kuruyorsan sade, yaygın ve bakımı kolay bir yapı seç. Teknoloji seçimini ürün davranışlarından daha önemli hale getirme.

İlk uygulama planında en az şu bağımlılıkları görünür kıl:

- navigasyon,
- kalıcı veri ve kimlik doğrulama,
- streak hesaplama alanı,
- bildirimler,
- tema/tasarım sistemi,
- test altyapısı.

## 4. Önerilen teknik yaklaşım

Mevcut proje başka bir teknoloji zorunlu kılmıyorsa aşağıdaki yaklaşım uygundur:

- React + TypeScript tabanlı istemci
- Mobil öncelikli responsive CSS veya proje içinde mevcut utility/component sistemi
- Şema doğrulama için tip güvenli bir doğrulama katmanı
- Sunucu durumu ile arayüz durumunu birbirinden ayıran veri erişim katmanı
- Gerçek backend varsa PostgreSQL/Supabase benzeri ilişkisel veri modeli
- Demo/MVP yerel çalışacaksa repository katmanı arkasında IndexedDB veya güvenilir kalıcı depolama
- Birim testleri için mevcut test koşucusu; yoksa framework ile uyumlu hafif bir test çözümü
- Kritik mobil akışlar için en az bir uçtan uca test yolu

Bu liste zorunlu paket adları değildir. Mevcut kod tabanıyla uyumlu eşdeğerler kullanılabilir.

## 5. Mimari sınırlar

İş mantığını arayüz bileşenlerine dağıtma. En az aşağıdaki sorumlulukları ayır:

```text
UI / ekranlar
    ↓
Uygulama servisleri ve kullanım senaryoları
    ↓
Alan modeli: alışkanlık, kayıt, program, streak, tetikleyici, çözüm
    ↓
Repository / API / kalıcı veri
```

### 5.1. Alan katmanı

- Streak hesapları saf ve test edilebilir fonksiyonlar veya alan servisleri içinde bulunmalıdır.
- Pozitif ve negatif alışkanlıklar aynı `if/else` yığınına sıkıştırılmamalıdır; ortak bir sözleşme altında ayrı hesaplama stratejileri kullanılmalıdır.
- Tarih ve saat hesapları tek bir yardımcı katmanda toplanmalıdır.
- Birim dönüşümleri arayüz metinlerinden bağımsız olmalıdır.
- Rozet ve renk aşaması gibi türetilmiş değerler veritabanındaki tek doğruluk kaynağı yapılmamalı; mümkün olduğunda kayıtlardan hesaplanmalıdır.

### 5.2. Veri erişimi

- Arayüz doğrudan depolama API'sine bağlanmamalıdır.
- Repository fonksiyonları kullanıcı kapsamını açıkça taşımalıdır.
- Oluşturma ve güncelleme işlemleri doğrulanmış veri kabul etmelidir.
- Aynı kayıt iki kez gönderildiğinde çift sayım oluşmaması için olay kimliği/idempotency yaklaşımı kullanılmalıdır.
- Silme gereken yerlerde mümkünse geri alınabilir arşivleme tercih edilmelidir.

### 5.3. Arayüz durumu

- Sunucudan/depodan gelen kalıcı veri, geçici modal/form durumu ve türetilmiş gösterim durumu ayrılmalıdır.
- Bir ekrandaki değişiklik diğer ekranlarda aynı verinin eski kalmasına yol açmamalıdır.
- Optimistic güncelleme kullanılıyorsa hata halinde geri alma ve kullanıcı mesajı bulunmalıdır.

## 6. Veri modeli kuralları

`project.md` içindeki `User`, `Habit`, `HabitEntry`, `StreakPeriod`, `TriggerNote`, `CopingStrategy`, `RestartPledge`, `Badge` ve `UserBadge` yapılarını başlangıç sözleşmesi olarak kullan.

Ek kurallar:

- Kimlikler kararlı ve benzersiz olmalıdır.
- Tüm tarih-saat değerleri saklanırken zaman dilimi güvenli bir formata dönüştürülmelidir.
- Kullanıcının zaman dilimi ayrıca tutulmalıdır.
- `createdAt` ile olayın gerçekleştiği `occurredAt` birbirine karıştırılmamalıdır.
- Alışkanlık programı serbest metin değil doğrulanabilir yapılandırılmış veri olmalıdır.
- Kullanıcıya ait her kaydın yetkilendirme kapsamı bulunmalıdır.
- Hassas not içerikleri telemetriye, URL'ye veya istemci hata mesajına yazılmamalıdır.
- Şema değişiklikleri geriye dönük veriyi bozmayacak migration yaklaşımıyla yapılmalıdır.

## 7. Streak motoru: değişmez kurallar

Streak motoru ürünün kritik çekirdeğidir. Görsel kart sayacından bağımsız bir modül olarak geliştir.

### 7.1. Ortak kurallar

- Hesap, kullanıcının yerel takvim günü ve kayıtlı zaman dilimine göre yapılmalıdır.
- Yaz/kış saati geçişlerinde bir gün yanlışlıkla kısa veya uzun kabul edilmemelidir.
- Gelecek tarihli kayıtlar streak kazandırmamalıdır.
- Aynı kaydın tekrar gönderilmesi streak'i ikinci kez artırmamalıdır.
- Kayıt düzeltme veya silme işlemi etkilenen dönemden itibaren yeniden hesaplama yapmalıdır.
- Aktif seri, en uzun seri ve geçmiş seri birbirinden ayrı kavramlardır.
- Hesap sonucu yalnızca sayı değil, durum ve gerekçe de döndürmelidir.

Örnek sonuç sözleşmesi:

```ts
type StreakResult = {
  current: number;
  longest: number;
  unit: "hour" | "day" | "period" | "week";
  status: "active" | "pending" | "completed" | "missed" | "broken";
  startedAt: string | null;
  nextEvaluationAt: string | null;
  reason: string;
};
```

Bu örneğin isimleri teknolojiye göre değişebilir; taşıdığı anlam korunmalıdır.

### 7.2. Negatif alışkanlıklar

- Seri gerçek bırakma/yeniden başlama zamanında başlar.
- Kullanıcı bir kırılma olayı bildirmedikçe süre ilerler.
- Kırılma olayı önceki seriyi bitirir; geçmiş silinmez.
- Yeni seri yalnızca kullanıcının yeniden başlama eylemiyle oluşturulur.
- Kullanıcı yanlış kırılma kaydını düzenlediğinde tüm sonuçlar yeniden hesaplanır.
- İlk 24 saat saat/dakika, sonrasında gün/periyot gösterimi yapılabilir; depolanan gerçek süre yuvarlanmamalıdır.

### 7.3. Pozitif alışkanlıklar

- Günlük hedef yalnızca hedef miktarı tamamlanınca başarılı sayılır.
- Seçili gün programında plansız günler seriyi bozmaz ve artırmaz.
- Haftalık sıklık programında haftanın sınırı kullanıcının zaman dilimine göre belirlenir.
- Aynı periyottaki ilerleme kayıtları toplanır; hedef bir kez tamamlanır.
- Hatırlatmayı kaçırmak streak kırılması değildir; periyot bitiminde hedef eksikse kırılma oluşur.
- Kullanıcı alışkanlığı duraklattığında duraklama davranışı ürün kararına göre açıkça etiketlenmeli; sessizce tamamlanmış sayılmamalıdır.

### 7.4. Zorunlu streak testleri

En az şu senaryoları otomatik test et:

- günlük hedef art arda üç gün tamamlandı,
- günlük hedef bir gün kaçırıldı,
- seçili günler arasında plansız günler var,
- haftalık hedef hafta bitmeden tamamlandı,
- miktar hedefi aynı gün birkaç kayıtla tamamlandı,
- negatif seri 23 saat 59 dakika sürdü,
- negatif seri 24 saati geçti,
- kırılma sonrası yeni seri başladı,
- geçmiş kayıt düzeltildi,
- tekrar gönderilen aynı kayıt işlendi,
- ay/yıl sınırı,
- kullanıcının zaman dilimi değişti,
- yaz/kış saati geçiş günü.

## 8. Ekran geliştirme sırası

Bağımlılıkları azaltmak için şu sırayı tercih et:

1. Tasarım tokenları ve temel bileşenler
2. Uygulama kabuğu ve üçlü alt navigasyon
3. Veri modeli, repository ve örnek veri
4. Alışkanlık ekleme/düzenleme
5. Pozitif ve negatif liste ekranları
6. Streak motoru ve kartlara bağlanması
7. Alışkanlık detayları, geçmiş ve takvim
8. Zorlayan konular ve çözüm yöntemleri
9. `Zorlanıyorum` müdahale akışı
10. Seri bozulması ve yeniden söz verme
11. Bildirim ayarları
12. Profil, rozetler ve istatistikler
13. Hata, boş, çevrimdışı ve erişilebilirlik düzeltmeleri

Bu sıra katı değildir; mevcut repository daha verimli bir yol sunuyorsa uyarlanabilir. Ancak streak çekirdeğini en sona bırakma ve yalnızca statik sahte verilerle teslim etme.

## 9. Ekran ve etkileşim gereksinimleri

Her ekran için şu durumları uygula:

- normal,
- yükleniyor,
- boş,
- hata,
- çevrimdışı veya senkronizasyon bekliyor,
- başarı geri bildirimi,
- devre dışı eylem.

Ana gezinme sırası değişmemelidir:

- sol: Negatif,
- orta: Ana Sayfa,
- sağ: Pozitif.

Alışkanlık kartları:

- tek dokunuşla detay sayfasını açmalı,
- hızlı kayıt eylemini yanlış dokunmaya karşı ayırt etmelidir,
- streak, durum etiketi ve sonraki hedefi birlikte göstermelidir,
- yalnızca renkle anlam taşımamalıdır.

Silme işlemi:

- kullanıcıya hangi verilerin etkileneceğini açıklamalı,
- yanlış silmeye karşı onay veya geri alma sağlamalı,
- geçmiş istatistiklerin kalıp kalmayacağını açıkça belirtmelidir.

## 10. Seri bozulması akışının uygulanması

Seri bozulduğunda:

1. Kırılma olayı zaman damgasıyla kaydedilir.
2. Önceki seri kapatılır ve en uzun seri yeniden hesaplanır.
3. İlgili ekran turuncu durum temasına geçer.
4. Kullanıcıya önceki emeğini yok saymayan bir mesaj gösterilir.
5. Tetikleyici ve kısa düşünce notu isteğe bağlı sunulur.
6. Kullanıcı bir çözüm yöntemi seçebilir.
7. Hazır veya özel bir yeniden başlama sözü verilebilir.
8. `Söz ver ve yeniden başla` işlemi yeni seriyi oluşturur.
9. Tema alışkanlık türünün başlangıç rengine döner.

Kullanıcıyı söz vermeye zorlamak için uygulamayı kilitleme. Kapatma/geri dönme yolu bulunmalıdır. Yeniden başlatma işlemi başarısız olursa söz metnini kaybetme ve sahte başarı durumu gösterme.

## 11. “Zorlanıyorum” akışının uygulanması

Bu akış bir sohbet robotunun sınırsız tavsiye üretmesi gibi tasarlanmamalıdır. Öncelik sırası:

1. Kullanıcının favori çözüm yöntemi
2. Benzer tetikleyicide etkili olmuş yöntem
3. Alışkanlık türüne uygun, önceden güvenliği değerlendirilmiş küçük eylem

Akış:

- dürtüyü kısa süre erteleme,
- küçük eylem seçme,
- isteğe bağlı geri sayım,
- eylem tamamlandı işareti,
- dürtü yoğunluğunu yeniden değerlendirme,
- sonucu geçmişe kaydetme.

Alkol, kumar, sigara veya ilaç kullanımında kesin sağlık sonucu, teşhis ya da tedavi önerisi üretme. Reçeteli ilacı bırakmayı veya doz değiştirmeyi önermeme kuralı tüm hazır metinler, otomatik öneriler ve test verileri için geçerlidir.

## 12. Bildirimlerin uygulanması

- Bildirim planı alışkanlık programından türetilmelidir.
- Bir alışkanlık için birden fazla saat desteklenmelidir.
- Sessiz saatler ve kullanıcının zaman dilimi uygulanmalıdır.
- Bildirim izni reddedildiğinde uygulama çalışmaya devam etmelidir.
- Kullanıcı erteleme, bugün sessize alma ve tamamen kapatma yapabilmelidir.
- Hassas kategori adlarını gizleyen nötr kilit ekranı metni desteklenmelidir.
- Web/PWA ortamı güvenilir arka plan bildirimini desteklemiyorsa yetenek varmış gibi davranma; kısıtı açıkça belirt ve uygulama içi hatırlatmayı çalıştır.
- Geliştirme sırasında gerçek bildirim mümkün değilse test edilebilir bir bildirim planlama adaptörü kullan.

## 13. Görsel durum motoru

Renk aşaması sabit gün sayısını bileşen içinde kontrol eden dağınık koşullarla hesaplanmamalıdır.

Merkezi bir fonksiyon en az şunları kabul etmelidir:

- alışkanlık türü,
- mevcut streak değeri,
- hedef/periyot bilgisi,
- kırılma durumu.

Ve şunları döndürmelidir:

- anlamsal durum adı,
- renk tokenı veya gradyan tokenı,
- metin etiketi,
- erişilebilir açıklama.

Kurallar:

- negatif: kırmızıdan yeşile,
- pozitif: maviden turkuaza,
- kırılmış seri: geçici turuncu,
- arka plan: koyu,
- ana metin: beyaz veya yüksek kontrastlı açık ton.

Renk değerlerini doğrudan bileşenlere yayma; `design.md` içindeki token sistemini kullan.

## 14. Form ve doğrulama kuralları

- Zorunlu alanları etiketle.
- Hata mesajını formun üstünde toplamakla yetinme; ilgili alanın yanında göster.
- Negatif süre, mesafe, miktar ve para değeri kabul etme.
- Mantıksız derecede büyük değerlerde kullanıcıdan doğrulama iste.
- Başlangıç tarihi gelecekteyse bunu planlanmış alışkanlık olarak açıkça göster veya engelle.
- Hatırlatma saatlerinin tekrar etmesini önle.
- Özel alışkanlıkta ölçüm türü seçilmeden hedef oluşturma.
- Form kapatılırken kaydedilmemiş değişiklik varsa uyar.
- Gönderme sırasında butonu tekrar basıma karşı koru.

## 15. Motivasyon metni kuralları

Metinler:

- kısa, sıcak ve somut olmalı,
- kullanıcının iradesini küçümsememeli,
- korku veya utanç yaratmamalı,
- “bir daha asla”, “kesin başaracaksın” gibi gerçek dışı kesinlik kullanmamalı,
- önceki emeği streak sıfırlandı diye değersizleştirmemeli,
- uygulanabilir tek bir sonraki adım önermelidir.

Uygun örnek:

> “Serin kesintiye uğradı, fakat oluşturduğun deneyim hâlâ senin. Bir sonraki küçük adımı şimdi seçebilirsin.”

Uygun olmayan örnek:

> “Yine başarısız oldun. Bu kez disiplinli olacağına söz ver.”

Dinamik metin üretimi eklenirse güvenli sabit metinler her zaman fallback olarak bulunmalıdır.

## 16. Erişilebilirlik uygulama kontrolü

- Metin kontrastını WCAG AA hedefiyle ölç.
- İnteraktif alanları en az 44×44 px yap.
- Klavye odağı görünür olmalıdır.
- Modal açıldığında odak modal içine taşınmalı, kapandığında tetikleyiciye dönmelidir.
- Form alanlarının programatik etiketleri bulunmalıdır.
- İkon butonlarında erişilebilir ad olmalıdır.
- Renk durumları ikon ve metinle tekrarlanmalıdır.
- Animasyonlar `prefers-reduced-motion` tercihinde azaltılmalıdır.
- Gerçek zamanlı sayaç her saniye ekran okuyucu duyurusu yapmamalıdır.
- Toast mesajları kritik hataların tek göstergesi olmamalıdır.

## 17. Performans ve sağlamlık

- İlk ekran için gereksiz büyük bağımlılık ve görsel yükleme.
- Takvim ve uzun kayıt listelerinde gerektiğinde sayfalama veya sanallaştırma kullan.
- Sayaçları gereksiz tüm uygulama render'ına yol açmayacak biçimde güncelle.
- Ağ yavaşken iskelet/yüklenme durumu göster.
- İstek iptali ve ekran terkinde eski yanıtların yeni durumu ezmesini önle.
- Çevrimdışı kayıtlar için bekleyen/senkronize durumunu görünür kıl.
- Tarih ve grafik kütüphanesi eklemeden önce mevcut araçların yeterli olup olmadığını değerlendir.

## 18. Güvenlik ve mahremiyet kontrolü

- Kimlik doğrulama ve yetkilendirmeyi yalnızca istemci görünürlüğüne bırakma.
- Kullanıcı A, kullanıcı B'nin alışkanlık veya not kayıtlarına erişememelidir.
- Hassas notları loglama.
- Kimlik bilgilerini repository içine ekleme.
- HTML olarak gösterilen kullanıcı girdisini güvenli biçimde işle.
- Hesap silme, oturum kapatma ve veri dışa aktarma akışlarını tutarlı ele al.
- Analitik olay adlarında hassas alışkanlık adını veya not içeriğini gönderme.
- Tıbbi ve bağımlılık uyarılarını küçük, görünmez dipnotlara saklama.

## 19. Test stratejisi

### 19.1. Birim testleri

- streak motoru,
- tarih/saat yardımcıları,
- hedef ilerleme hesapları,
- renk aşaması hesapları,
- maddi ve süre tasarrufu tahminleri,
- form doğrulama şemaları.

### 19.2. Entegrasyon testleri

- alışkanlık oluşturma → kayıt ekleme → streak güncelleme,
- kırılma kaydı → turuncu ekran → söz verme → yeni seri,
- tetikleyici notu → çözüm oluşturma → `Zorlanıyorum` akışında öneri,
- program güncelleme → bildirim planının güncellenmesi,
- geçmiş kayıt düzeltme → istatistiklerin yeniden hesaplanması.

### 19.3. Uçtan uca kritik akışlar

- yeni kullanıcı onboarding ve ilk pozitif alışkanlık,
- ilk negatif alışkanlık ve aktif sayaç,
- su hedefi için birkaç hızlı kayıtla günlük tamamlama,
- seri bozulması ve yeniden başlama,
- mobil alt navigasyonla üç ana alan arasında geçiş.

### 19.4. Görsel ve manuel kontrol

- küçük telefon, büyük telefon, tablet ve masaüstü genişliği,
- uzun Türkçe metinler,
- klavye navigasyonu,
- hareket azaltma,
- renk körlüğünde durumların anlaşılması,
- çevrimdışı ve yavaş bağlantı,
- boş ve hata durumları.

Testleri yalnızca yeşil görünmesi için zayıflatma veya gerçek hatayı gizleyen snapshot güncellemesi yapma.

## 20. Uygulama sırasında kalite kapıları

Her önemli özellikten sonra:

1. İlgili birim ve entegrasyon testlerini çalıştır.
2. Type-check ve lint sonuçlarını kontrol et.
3. İlgili ekranı gerçek tarayıcıda mobil boyutta aç.
4. En az normal, boş ve hata durumunu gözle doğrula.
5. Konsol hatası ve erişilemeyen kontrol bırakma.

Tüm teslim öncesinde:

- temiz kurulumdan build alınmalı,
- test paketi çalışmalı,
- ana kullanıcı akışları manuel doğrulanmalı,
- kritik erişilebilirlik kontrolü yapılmalı,
- örnek veya seed verinin üretim verisi gibi görünmediği doğrulanmalı,
- bilinen kısıtlar açıkça raporlanmalıdır.

## 21. Antigravity çalışma davranışı

- Kullanıcı açıkça yalnızca plan istemediyse çalışan ürünü geliştir; statik mockup ile yetinme.
- Uzun bir plan yazıp uygulamayı erteleme. Küçük ve doğrulanabilir dikey dilimler halinde ilerle.
- Arayüzü sahte başarı durumlarına bağlama; eylemler gerçekten veri üretmelidir.
- Eksik bir entegrasyonu varmış gibi göstermeme. Demo adaptörü kullanılıyorsa bunu kod ve teslim notunda açıkça belirt.
- Bir sorunu düzeltirken ilgisiz kodu yeniden yazma.
- Mevcut kullanıcı değişikliklerini koru.
- Tehlikeli veya geri alınması zor işlemlerden önce kapsamı doğrula.
- Başarısız komutları sessizce geçme; kök nedeni düzelt veya teslim notunda net biçimde belirt.
- Kullanıcıdan yalnızca gerçekten gerekli kararları iste. Güvenli ve geri alınabilir ayrıntılarda belgelerden makul varsayım yap.

## 22. Tamamlanma ölçütü

Bir özellik ancak şu koşullarda tamamlanmış kabul edilir:

- kullanıcı tarafından görünür akış çalışıyor,
- kalıcı veri doğru güncelleniyor,
- hata ve boş durumları ele alınmış,
- erişilebilir adlar ve klavye davranışı mevcut,
- ilgili iş kuralları otomatik test edilmiş,
- mobil görünüm doğrulanmış,
- konsol, type-check, lint ve build hatası bırakılmamış,
- `project.md` kabul kriterleriyle çelişmiyor.

Tüm proje tamamlandığında teslim özeti şu bilgileri içermelidir:

- geliştirilen ana özellikler,
- kullanılan teknik yapı,
- çalıştırılan test ve doğrulamalar,
- gerçek entegrasyon yerine kullanılan demo/adapter noktaları,
- bilinen sınırlamalar,
- uygulamayı çalıştırma komutu,
- sonraki mantıklı geliştirme adımları.

## 23. Kaçınılması gereken sonuçlar

- Yalnızca güzel görünen fakat kayıtları kaydetmeyen prototip
- Pozitif ve negatif alışkanlıkları aynı streak mantığıyla hesaplama
- Hatırlatma kaçırıldığı anda streak bozma
- Plansız günleri başarısız sayma
- Önceki serileri yeniden başlatırken silme
- Seri bozulmasında suçlayıcı dil kullanma
- Reçeteli ilacı bırakma önerisi verme
- Hassas kategori adını kilit ekranında zorunlu gösterme
- Koyu arka planda yetersiz kontrast
- Durumu yalnızca renkle anlatma
- Hard-code edilmiş kartlar ve çalışmayan butonlar
- Test edilmemiş tarih/saat hesapları
- Akıllı saat veya bildirim entegrasyonu yokken çalışıyormuş gibi gösterme

Bu beceriyi kullanırken temel hedef; ölçülebilir biçimde doğru çalışan, kullanıcıyı yargılamayan, güvenli ve sürdürülebilir bir alışkanlık deneyimi üretmektir.
