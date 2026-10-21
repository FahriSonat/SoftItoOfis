---
name: personal-finance-flutter
description: Kişisel para takip uygulamasını Flutter ile geliştirir veya günceller. Gelir-gider, bütçe, borç, hatırlatma, rapor ve mobil arayüz çalışmalarında kullanılır.
---

# Kişisel Para Takip Uygulaması — Flutter

Bu beceri, kişisel günlük para takip uygulamasının Flutter mobil istemcisinde çalışırken uygulanır. Ürünün amacı, kullanıcı akışları, kapsamı ve iş kuralları için aynı klasördeki [`project.md`](project.md) dosyasını temel al.

Bu dosya kodlama yaklaşımını, ürün davranışlarını uygularken korunacak kuralları ve tamamlama beklentilerini tanımlar. `project.md` ürün kapsamının asıl kaynağıdır. Kullanıcının son talimatı her iki dosyadaki metinden önceliklidir. Yeni bir istek kapsamı veya veri modelini değiştiriyorsa ilgili dokümanları güncelle.

## 1. Göreve Başlamadan Önce

Her görevde:

1. `project.md` içindeki ilgili ürün gereksinimlerini ve açık ürün sorularını oku.
2. Flutter deposunun yapısını, `pubspec.yaml` dosyasını, mevcut ekranları, veri modellerini, yönlendirmeyi, durum yönetimini, yerelleştirme ve tema düzenini incele.
3. Özelliğin hangi kullanıcı akışını etkilediğini belirle. Yalnızca görünür widget'ı değil, etkilenen doğrulama, hesaplama, saklama ve rapor davranışlarını da göz önünde bulundur.
4. Var olan yaklaşımı izle. Projede belirlenmemiş bir teknoloji veya mimariyi sırf kişisel tercih nedeniyle değiştirme.
5. Ürün kararları `project.md` içinde açık değilse düşük etkili, geri alınabilir bir varsayımla ilerle ve bunu sonuçta bildir. Saklama yeri, senkronizasyon, kur kaynağı, otomatik dış teslimat veya tutarların Excel'de gizlenmesi gibi önemli kararları sessizce varsayma.

## 2. Ürün Yapısı ve Navigasyon

Uygulamanın beş ana alanı bulunur:

1. **Bütçe Özeti:** Gelir, gider, bakiye/net durum, kalan günlük harcanabilir tutar, limit durumu ve yaklaşan ödemelerin özeti.
2. **Gelir/Gider ve İşlem Detayları:** İşlem ekleme, düzenleme, listeleme, filtreleme ve ayrıntılı görüntüleme.
3. **Zarf/Kategori Bütçeleri:** 50/30/20 bütçe kuralı veya kullanıcının belirlediği zarf/kategori limitleri.
4. **Gelecek Ay Simülasyonu:** Beklenen gelir ve planlı ödemelere dayalı dönem tahmini.
5. **Harcama Raporları:** Günlük, haftalık ve aylık sonuçlar, kategori dağılımı ve Excel çıktısı.

Borçlar, düzenli faturalar, bildirim ayarları ve genel ayarlar uygun bir ana alanın alt sayfası veya bölümü olabilir. Mevcut yönlendirme modelini koru; beş ana alanı daha fazla üst seviye sekmeye dönüştürmek zorunlu değildir.

Ana sayfa hızlı karar vermek için özet sunar. Tam işlem ayrıntılarını ana sayfaya yığma. Özetteki kart veya satırlar ilgili detay ekranına ulaşmayı kolaylaştırabilir. Gelir ve gider toplamlarını ayrı göster; kullanıcıya gösterilen dönem açık olsun.

## 3. Temel Kullanıcı Akışları

### Gelir ve gider kaydı

- Kullanıcı gelir veya gider türünü açıkça seçer.
- Gider kaydında tutar, kategori, tarih ve açıklama zorunludur. Fiş/fatura açıklaması ve ek not, `project.md` içinde belirtilen biçimde sunulur.
- Gelir kaydında gelir türü, tutar, tarih ve açıklama bulunur. Maaş, borç geri ödemesi ve diğer gelir kaynaklarını ayırt et.
- Maaş veya borç geri ödemesi dışında bir gelir girildiğinde bilgilendirici olağan dışı gelir uyarısı göster. Uyarı, geçerli bir kaydı zorla engellememelidir.
- Form alanlarını doğrula; kullanıcıya hatanın ne olduğunu ve nasıl düzeltileceğini ilgili alanda açıkla.
- Düzenleme ve silme işlemlerinde mevcut veriyle tutarlı kal. Silme işlemi için uygulamanın tasarımına uygun onay al.

### Bütçe oluşturma ve izleme

- Kullanıcının 50/30/20 kuralını veya özel zarf/kategori bütçesini seçmesini sağla.
- Günlük, haftalık ve aylık limitleri ayrı dönemler olarak ele al. Bir limitin kaynağı ve başlangıç tarihi açık olsun.
- Eşik aşıldığında uyarı üret; aynı aşıma için her ekran açılışında tekrar tekrar bildirim oluşturma.
- Haftalık durum ve tasarruf önerileri bilgilendirici, anlaşılır ve kullanıcının verileriyle ilişkili olsun. Önerileri kesin finansal sonuç gibi sunma.
- Kalan günlük harcanabilir tutar bir hesaplama/tahmindir. Kullanılan gelir, dönem bütçesi, planlı giderler ve kalan gün sayısı açıkça tanımlansın. Ürün kuralı net değilse formülü sessizce sabitleme; açıklanabilir bir varsayım seç veya ürün kararını kullanıcıya sor.

### Fatura ve düzenli giderler

- Planlanmış/beklenen ödeme ile tamamlanmış gerçek gideri ayır.
- Bir ödeme tamamlandığında beklenen kaydı gider toplamına eklenmiş gibi sayma. Tamamlama sırasında gerçekleşen işlem oluştur veya var olan işlemle ilişkilendir.
- Tekrarlama sıklığı (günlük/haftalık/aylık) ile bildirimin ne zaman gönderileceği farklı kavramlardır; arayüzde bunları karıştırma.
- Kullanıcının planlı bir ödemeyi ertelemesine, tamamlandı olarak işaretlemesine veya tutarını gerçekleşen ödeme için düzeltmesine mevcut ürün akışına göre olanak sağla.

### Borç alma, borç verme ve geri ödeme

- Verilen ve alınan borçları yön, karşı taraf, ana tutar, kalan tutar, para birimi, vade, durum ve not ile ayırt et.
- Borç vadesinden bir hafta önce ve kullanıcının maaş gününde hatırlatma göster. Verilen borç vade gününde borç ekranında tek satırlık kayıt üzerinde uyarı üret.
- Maaşın hesaba geçtiği tarihten sonraki ilk üç gün içinde kart ve borç ödemelerini hatırlat.
- Borç bakiyesi ile nakit hareketini ilişkilendir. Borcun alınması/verilmesi ve geri ödenmesi toplam gelir veya gideri yanlışlıkla iki kez etkilememelidir.
- Kısmi ödemede kalan borcu ve ödeme geçmişini tutarlı biçimde güncelle. Yuvarlama veya para birimi dönüşümüyle kalan bakiyeyi kaybetme.

## 4. Finansal Veri ve Hesaplama Kuralları

### Para tutarları

- `double`/floating point değerlerini para tutarlarını saklamak veya toplamak için kullanma.
- Projenin veri modeliyle uyumlu olarak tutarı en küçük para biriminde tam sayı (ör. kuruş) veya hassas decimal biçiminde sakla.
- Para birimini her işlem ve bütçeyle ilişkilendir. Farklı para birimlerini kur dönüşümü kuralı ve tarihli kur bilgisi olmadan aynı toplamda birleştirme.
- Tutar girişinde yerel ayarın ondalık ve binlik ayraçlarını doğru ayrıştır; ekranda yine yerel biçimde göster.
- Negatif tutar modelini yalnızca ürün veri modeli gerektiriyorsa kullan. Temel akışta pozitif tutar ve ayrı işlem türü, gelir/gider yönünü belirler.

### Dönemler ve tarihler

- Gün, hafta ve ay sınırlarını kullanıcının yerel saat dilimi ve yerel takvimine göre belirle.
- Zaman damgası ile yalnızca takvim tarihini (vade günü gibi) ayırt et. Takvim gününe bağlı hatırlatmayı UTC dönüşümü nedeniyle önceki/sonraki güne kaydırma.
- Haftanın hangi gün başladığı ve maaş gününün ay içinde bulunmayan günlere (ör. 31 Şubat) denk gelmesi gibi tercihler ürün kararıdır. Mevcut yapı belirlemiyorsa davranışı açıkça tanımla.
- Ay sonunu sabit gün sayısıyla hesaplama; bir sonraki ayın ilk gününden geriye gitme gibi takvim temelli yöntem kullan.
- Raporlarda işlem tarihini, oluşturulma tarihini ve ödeme vadesini birbirinin yerine kullanma.

### Bakiye ve çift sayım

- Bakiye ve dönem toplamları tek, belirgin bir hesaplama kaynağından üretilsin.
- Beklenen fatura, gerçekleşmiş gider, borç bakiyesi ve nakit akışı farklı kavramlardır. Veriyi ve hesaplamayı buna göre ayır.
- Bir gelir veya gider birden fazla ekranda aynı kayıttan gösterilebilir; ekran bazında kopya finansal kayıt üretme.
- Filtreleme ve kategori toplamlarında her işlem yalnızca bir kez hesaba katılsın.
- Gizli tutarlı işlemler tüm hesaplamalarda yer almaya devam eder.

### Bütçe hesapları

- Dönemin başlangıç ve bitiş sınırlarını aynı yardımcı/alan kuralıyla hesapla; filtreler ve özetler farklı dönem sonuçları üretmemelidir.
- Bütçe kullanımı için gerçekleşmiş giderleri esas al. Tahmini ödemeleri ayrı göster veya seçilebilir bir projeksiyona dahil et; ikisini açıklamasız biçimde karıştırma.
- Kategori bütçesi ile genel bütçenin aynı gideri iki defa toplamamasını sağla. Genel ve kategori limitlerinin uyarı ilişkisini belirgin tut.
- Limit yaklaşma eşiği yapılandırılabiliyorsa varsayılanı ve kullanıcı seçimini sakla. `project.md` önerisi olan %80 eşiğini kullanıcı veya proje kararı yoksa değişmez kural gibi uygulama.
- Bütçe aşıldığında kalan tutarı negatif göstermek gerekiyorsa bunu açık biçimde, doğru para biçimiyle göster.

## 5. Hayır İşi ve Özel Gider Gizliliği

### Hayır işi giderleri

- Hayır işi işareti giderin kategorisini veya toplam gider davranışını değiştirmez.
- İşlem listesinde hayır işi kaydına diğer giderlerle aynı renk düzenini uygula. Hayır işi olduğunu ayrıca metin, ikon veya erişilebilir etiketle gösterebilirsin.
- Bu kayıtlar toplam gider, bütçe kullanımı ve aylık raporlara dahildir. Hayır işi filtresi veya alt toplamı sunuluyorsa ana gider toplamını değiştirmediğini açık tut.

### Özel tutarı sansürleme

- Gizlilik işareti tutarın hesaplanma, saklanma veya dışa aktarılma değerini kendiliğinden değiştirmez; bu işaret öncelikle gösterim tercihidir.
- Tutarı sansürlerken işlem satırı, detay, ana sayfa özeti, arama sonucu, grafik etiketi, ekran okuyucu metni ve bildirim gibi bütün kullanıcıya görünen yüzeyleri kontrol et.
- Bir işlem için yalnızca değer metnini sansürlemek yetmiyorsa, o tutarı doğrudan ortaya çıkaran bağlamı da gizle veya üründeki gizlilik kuralına göre sadeleştir.
- Gizli tutarı loglara, hata mesajlarına, analitik olaylara veya tanılama çıktısına koyma.
- Excel dışa aktarmada tutarların sansürlenmesi/gösterilmesi ürünün kullanıcı tercihine bağlıdır. Bu tercih tanımlı değilse davranışı açık ve güvenli bir ayar haline getir; dışa aktarma önizlemesinde hangi verinin paylaşılacağını kullanıcıya göster.

## 6. Flutter Kod Organizasyonu

- Projede kullanılan klasör, adlandırma ve katman düzenini sürdür. Var olan ekranı veya modülü sırf kişisel mimari tercihin farklı diye yeniden yazma.
- Mümkün olduğunda ekran sunumu, iş kuralları ve veri erişimini birbirinden ayır. Widget içinde karmaşık bakiye, borç veya dönem hesabı biriktirme.
- Aynı para biçimi, tarih dönemi veya tutar sansürleme kuralını farklı ekranlarda kopyalama; mevcut ortak yardımcıları kullan veya ihtiyaç varsa küçük, odaklı bir ortak bileşen oluştur.
- Durum yönetiminde projede kullanılan çözümü takip et. Yeni paket ancak mevcut çözüm ihtiyacı karşılamıyorsa ve özellik için gerçek bir yarar sağlıyorsa eklenmelidir.
- Yeni bağımlılık eklerken `pubspec.yaml`, platform uyumluluğu, bakım durumu ve gerekli iOS/Android yapılandırmasını incele. Sırf olası gelecek ihtiyaçlar için paket ekleme.
- `const` widget'ları uygun yerlerde kullan, widget'ları gereksiz yere büyütme ve kullanıcı akışını anlaşılır küçük bileşenlerle kur.
- Asenkron veri erişiminde yükleniyor, başarı, boş ve hata durumlarını açıkça modelle. Ekran kapanmışken tamamlanan işlemin disposed widget'ı güncellemesini önle.
- Form gönderiminde çift dokunuşla aynı kaydın iki kez oluşturulmasını engelle; başarısız kayıtta kullanıcının girdiği değerleri koru.
- Yerel veri deposu, backend veya senkronizasyon mimarisi `project.md` içinde karara bağlanmamıştır. Depoda mevcut çözümü kullan; kapsam dışı bir backend veya hesap sistemi kurma.

## 7. Mobil Arayüz ve Erişilebilirlik

- Önce telefon boyutlarında çalışacak düzen kur; dar ekran, büyük yazı boyutu, klavye görünürlüğü ve ekran yönü değişiminde taşma olup olmadığını dikkate al.
- Ana aksiyonları kolay dokunulabilir yap. Tutar girişi için uygun sayısal klavye kullan; para birimi ve ondalık girişini destekle.
- Gelir, gider, uyarı, başarılı işlem ve bütçe durumu yalnızca renkle anlatılmaz. Metin, ikon veya şekil gibi ikinci bir işaretleyici kullan.
- Form alanlarında görünür etiket kullan; yalnızca placeholder'ı etiket olarak bırakma. Hata ve zorunlu alan durumlarını ekran okuyuculara erişilebilir kıl.
- Klavye odağını mantıklı sırada tut, odak göstergesini koru ve önemli eylemleri ekran okuyucu için adlandır.
- Renk kontrastı, dokunma alanı ve metin ölçekleme konusunda mevcut tema tokenlarını kullan. Renkleri çok sayıda widget'a sabit değer olarak dağıtma.
- Grafikler tek başına bilgi kaynağı olmasın; önemli toplamları metinle de ver. Grafik kütüphanesi değişimi gerekiyorsa mevcut bağımlılıkları incele.
- Boş ekranlarda neyin boş olduğunu ve ilk kaydı nasıl ekleyeceğini belirt. Hata ekranlarında yeniden deneme veya geri dönme gibi uygulanabilir bir adım sun.
- Silme, bütçe aşımı ve dışa aktarma gibi önemli eylemlerde sonucu kullanıcıya önceden anlat.

## 8. Hatırlatmalar ve Mobil Zamanlama

- Hatırlatma kurallarını tek bir yerden oluşturup güncellemeyi hedefle. Ekran her açıldığında aynı bildirimleri yeniden zamanlama veya çoğaltma.
- Uygulama içi hatırlatmalarla işletim sistemi bildirimi aynı şey değildir. Cihaz bildirimi izni olmasa bile uygulama içi yaklaşan ödemeler görünür kalmalıdır.
- Bildirim iznini özellik bağlamında iste; uygulama ilk açılır açılmaz sebepsiz izin penceresi gösterme. İzin reddedilirse ayarlarda nasıl açılacağını açıklayabilirsin.
- Günlük/haftalık/aylık tekrarlama, vade günü, maaş günü ve “bir hafta önce” hesaplarını yerel takvim/saat dilimiyle yap.
- Kullanıcı tarih, maaş günü, tekrarlama veya hatırlatma ayarını değiştirdiğinde artık geçerli olmayan yerel bildirimleri iptal edip güncel olanları planla.
- Bildirime dokunulduğunda kullanıcıyı ilgili fatura, borç veya rapora götür; kayıt bulunmuyorsa güvenli varsayılan ekrana yönlendir.
- Android ve iOS bildirim izinleri, kesin zamanlama ve arka plan çalıştırma davranışları farklı olabilir. Platform yapılandırmasını ve mevcut paketleri doğrula; her platformda garanti edilmeyen davranışı garanti gibi sunma.
- Ay sonu Excel üretimi için cihazın uygulama kapalıyken belirli saatte çalışacağını varsayma. Uygulama içi gecikmiş üretim yaklaşımı, platform zamanlaması veya sunucu görevi arasında mevcut altyapıya uygun seçeneği kullan; güvenilir arka plan üretimi şartı ve altyapı yoksa sınırı açıkça bildir.

## 9. Raporlar ve Excel Dışa Aktarma

- Rapor kapsamı, tarih aralığı ve kullanılan para birimini görünür yap.
- Rapor toplamlarını ekrandaki işlem filtreleriyle aynı iş kurallarına dayandır.
- Gelir, gider, kategori, bütçe ve borç hareketlerini ayrı ve anlaşılır sütunlar/bölümler halinde dışa aktar; tahmini ve gerçekleşmiş hareketleri ayırt et.
- Excel oluştururken para birimini, tarihi, kategori adını ve toplam hesaplarını tutarlı biçimde yaz. Yerel tarih biçimi dosyada belirsizliğe yol açıyorsa tarih değerini makinece okunabilir biçimde de sakla.
- Kullanıcıya dosya üretim başarısı veya hatasını bildir. Geçici dosyaları uygulama depolama kurallarına göre yönet ve dışa aktarılan dosyanın nerede bulunduğunu açıkla.
- Ay sonu otomatik rapor, rapor dönemini yerel takvim ayına göre belirler ve bir dönem için yinelenen dosya oluşturmaz. Yeniden üretme/indirme akışı rapor tasarımına uygun olmalıdır.
- Otomatik e-posta, bulut yükleme veya üçüncü tarafa gönderim `project.md` içinde istenmediği sürece ekleme.

## 10. Gizlilik ve Güvenlik

- Finansal kayıtları hassas kişisel veri olarak ele al.
- Gerçek tutarları, kişi/kurum adlarını, fiş açıklamalarını, erişim belirteçlerini ve kimlik bilgilerini loglama.
- Uygulama erişim kontrolü gerektiriyorsa her kaydın doğru kullanıcıya ait olduğunu veri erişim sınırında denetle; yalnızca arayüzde filtrelemek erişim kontrolü değildir.
- Kimlik doğrulama, cihazlar arası senkronizasyon ve bulut saklama ürün kararlarıdır. Bunlar istenmeden yeni hesap sistemi veya uzak servis ekleme.
- Yerel depolama seçilmişse platformun sunduğu uygun korumalı saklama yöntemlerini ve yedekleme davranışını incele. Anahtarları veya sırları kaynak koduna koyma.
- Veri silme ve dışa aktarma akışlarında kullanıcıya hangi kayıtların dahil olduğunu göster. Silinen kaydın bağlı borç veya ödeme ilişkilerini tutarsız bırakma.
- Üçüncü taraf analitik/çökme raporlama mevcutsa hassas finansal alanların olay içeriğine girmediğini kontrol et.

## 11. Tasarım ve Metin Dili

- Uygulama dili varsayılan olarak Türkçe, para birimi varsayılan olarak TRY'dir; kullanıcı ayarı veya proje kararı varsa onu kullan.
- Finansal terimleri tutarlı kullan: gelir, gider, beklenen ödeme, gerçekleşen ödeme, borç bakiyesi, bütçe limiti ve kalan tutar birbirinin yerine geçmez.
- Sayı, tarih, para ve çoğul biçimlerini mevcut yerelleştirme düzeninden geçir. Arayüz metinlerini iş mantığından ayır.
- Uyarı mesajlarında durum ve sonraki adım net olsun. Gereksiz korkutucu veya yargılayıcı dil kullanma.
- Kullanıcıya tasarruf önerirken harcama davranışını suçlayıcı biçimde değerlendirme.
- Tema ve renk tokenları varsa onları kullan. Hayır işi giderlerini ayrı renkle kodlama; kullanıcının istediği gibi giderlerle aynı renk sisteminde göster.

## 12. Değişiklik ve Doğrulama Akışı

Bir özellik geliştirirken:

1. Gereksinimi ve etkilediği iş kurallarını belirle.
2. Veri modeli değişiyorsa kayıtların eski sürümlerle uyumluluğunu ve varsayılan değerleri düşün.
3. Gerekli doğrulama ve hesaplamaları arayüzden bağımsız veya tekrar kullanılabilir biçimde uygula.
4. Ekranın yükleniyor, boş, hata, başarı ve izin verilmemiş durumlarını tamamla.
5. Depoda mevcut analiz/biçimlendirme komutlarını ve ilgili test yapısını incele. Uygun doğrulamayı çalıştır; çalıştırmadığın veya ortam nedeniyle çalıştıramadığın kontrolü açıkça bildir.
6. Değişiklik `project.md` kapsamını, veri modelini veya ürün davranışını etkilediyse ilgili bölümü güncelle.

Özellikle doğrulanması gereken iş senaryoları:

- Sıfır, negatif, çok büyük ve ondalıklı tutar girişleri.
- Farklı para birimlerinde toplamların ayrılması.
- Ay, hafta, yıl ve saat dilimi sınırları.
- Gelir, gider, kategori ve tarih filtrelerinin doğru toplamı vermesi.
- Gizli tutarlı giderin tüm özetlerde sansürlenirken toplamda kalması.
- Hayır işi giderinin normal gider rengiyle görünmesi ve toplamdan çıkarılmaması.
- Beklenen faturanın gerçekleşen ödeme ile çift sayılmaması.
- Borç, kısmi geri ödeme ve kalan bakiye hesabı.
- Maaş günü çevresindeki üç günlük hatırlatma ve vade öncesi bildirim.
- Bildirim izni yokken uygulama içi hatırlatmaların erişilebilir olması.
- Excel'de tarih, para birimi, toplam ve gizlilik tercihinin doğru olması.

## 13. Tamamlanma ve Sonuç Bildirimi

Bir görev tamamlandığında kısa bir özet ver:

- Hangi kullanıcı davranışı veya ekran değişti?
- Hangi önemli ürün varsayımı veya açık karar kullanıldı?
- Hangi analiz, biçimlendirme ya da test komutları çalıştırıldı; sonucu ne oldu?
- Bilinen sınırlama varsa kullanıcıya etkisi nedir?

Yalnızca gerçekten çalıştırılan doğrulamaları başarılı olarak bildir. Ürün kapsamını, veri modelini veya açık ürün kararını etkileyen bir değişiklik yaptıysan `project.md` ile birlikte tutarlı hale getir.
