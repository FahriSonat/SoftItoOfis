
# Kişisel Para Takip Uygulaması — Tasarım Rehberi

## 1. Tasarımın Amacı

Arayüz, kullanıcının gelirini, giderini, bütçe sınırlarını ve yaklaşan ödemelerini telefonda hızlıca anlayabilmesini sağlamalı. Finansal bilgiler yoğun olsa da ekranlar sade, tutarlı ve rahat okunur olmalı.

Bu belge, [`project.md`](project.md) içindeki ürün kapsamını görsel ve etkileşim kurallarına dönüştürür. Ürün davranışı için `project.md`, renk, yerleşim, tipografi ve bileşen görünümü için bu belge temel alınır. Kullanıcının sonraki açık tasarım talimatları bu kuralların önüne geçer.

## 2. Görsel Dil

- Koyu, sakin ve güven veren bir görünüm kullan.
- Uygulamanın ana arka planı siyah ile koyu lacivert arasında olmalı.
- Temel metinler beyaz veya yüksek kontrastlı açık gri olmalı.
- Gelir yeşil, gider kırmızı ile gösterilmeli.
- Tablolardaki nötr göstergeler ve tablo içi seçili durumlar mavi olmalı.
- Uyarı mesajları sarı zemin üzerinde siyah metinle, kritik uyarılar kırmızı zemin üzerinde beyaz metinle gösterilmeli.
- Renk tek başına anlam taşımamalı. Gelir/gider ve uyarı türleri metin, ikon veya şekille de ayrıştırılmalı.
- Dekoratif gradient, aşırı gölge ve gereksiz animasyon kullanma; sayıların okunabilirliği önceliklidir.

## 3. Renk Paleti ve Kullanım Kuralları

Renkleri tema tokenları olarak tanımla; bileşenlerin içine dağınık sabit renkler yazma.

| Token | Örnek renk | Kullanım |
|---|---|---|
| `background` | `#090D18` | Uygulamanın ana arka planı; siyah-lacivert arası |
| `surface` | `#111827` | Kart, tablo ve modal yüzeyleri |
| `surfaceRaised` | `#192235` | Yükseltilmiş kartlar ve açılır menüler |
| `textPrimary` | `#F8FAFC` | Başlıklar ve ana metinler |
| `textSecondary` | `#B8C2D3` | Açıklama ve ikincil bilgiler |
| `textMuted` | `#8995A8` | Tarih, yardımcı bilgi ve pasif etiketler |
| `border` | `#293449` | Kart, tablo satırı ve alan sınırları |
| `income` | `#22C55E` | Gelir tutarı, gelir ikonu ve gelir işareti |
| `incomeSurface` | `#153224` | Gelir kutusu/kartı için daha açık yeşil tonlu yüzey |
| `expense` | `#F04452` | Gider tutarı, gider ikonu ve gider işareti |
| `expenseSurface` | `#382027` | Gider kutusu/kartı için daha açık kırmızı tonlu yüzey |
| `indicatorBlue` | `#4EA1FF` | Tablo göstergeleri, nötr ilerleme ve seçili tablo durumu |
| `warningBackground` | `#FACC15` | Standart uyarı mesajı zemini |
| `warningText` | `#111111` | Standart sarı uyarı metni ve ikonu |
| `criticalBackground` | `#D92D3A` | Önemli/kritik uyarı zemini |
| `criticalText` | `#FFFFFF` | Kırmızı kritik uyarı metni ve ikonu |
| `successBackground` | `#153224` | Başarılı işlem bildirimi zemini |

### Renk önceliği

- Gelir olarak sınıflandırılmış her tutar yeşil; gider olarak sınıflandırılmış her tutar kırmızı gösterilir. Hayır işi giderleri de kırmızı kalır.
- Gelir ve gider kutularının zeminleri ana zeminden daha açık, sırasıyla yeşile ve kırmızıya tonlanmış olmalı. Metin beyaz, tutar ise ilgili parlak gelir/gider rengi olmalı.
- Tablodaki mavi göstergeler seçili satır, nötr durum/ilerleme, filtre veya görsel işaret içindir. Gelir ve gider tutarlarının yeşil/kırmızı kodlamasını maviye çevirmemelidir.
- Sarı uyarıda siyah metin; kritik kırmızı uyarıda beyaz metin kullan. Bu kombinasyonları tema genelinde sabit tut.
- Seçili olmayan, devre dışı veya ikincil içerik düşük kontrastlı olabilir ancak okunabilirlik kaybolmamalı.

## 4. Tipografi ve Sayı Biçimi

- Flutter projesinde mevcut yazı tipi tanımlanmışsa onu kullan; yoksa okunaklı bir sistem sans-serif yazı tipi tercih et.
- Sayfa başlığı: yaklaşık 24–28 sp.
- Bölüm başlığı: yaklaşık 18–20 sp.
- Kart ve tablo metni: yaklaşık 14–16 sp.
- Yardımcı metin: yaklaşık 12–14 sp; erişilebilirlik için kullanıcı büyütmesine izin ver.
- Ana bakiye ve gösterge merkezindeki tutarlar, sayfanın en belirgin metinleridir.
- Para değerlerinde hizalamayı kolaylaştırmak için uygun olduğunda tabular rakam kullan.
- Para ve tarihleri Türkçe yerel ayarına göre biçimlendir; tutarın para birimini görünür kıl. Varsayılan TRY/Türkçe tercihleri `project.md` ile uyumludur.
- Artı/eksi işareti işlem türünü destekleyebilir; yeşil/kırmızı kodlamanın yerine geçmez.

## 5. Ana Sayfa Yerleşimi

Ana sayfa, özet ve hızlı erişim ekranıdır. Tüm işlem ayrıntılarını burada göstermeye çalışma.

Önerilen içerik sırası:

1. Üst bölüm: sayfa başlığı, seçili ay/dönem ve bildirim erişimi.
2. Bakiye/net durum kartı.
3. Yarım daire bütçe göstergesi veya göstergeleri.
4. Yan yana gelir ve gider özet kutuları/tablo panelleri.
5. Günlük harcanabilir tutar ve günlük/haftalık/aylık limit durumu.
6. Yaklaşan faturalar, kart ödemeleri ve borç hatırlatmaları.
7. Son işlemlerden kısa bir liste ve ilgili ayrıntı ekranına geçiş.

Ana ekranda gelir özeti solda, gider özeti sağda yer alır. Tam gelir ve gider tabloları kendi detay ekranlarında bulunur; ana sayfadaki paneller özet satırları ve toplamları gösterir.

### Duyarlı yerleşim

- Tablet ve geniş ekranda gelir paneli solda, gider paneli sağda iki sütun halinde gösterilir.
- Telefon ekranında da gelir özeti solda, gider özeti sağda kalır; bu paneller kompakt toplam kartları olarak tasarlanır. Ayrıntılı satırlar kendi ekranlarında listelenir.
- Dar ekranda içerik sıkışıyorsa tabloları okunamaz hale getirme. Özet kartlarını koru ve detay listelerinde yatay kaydırma yerine satır/kart düzenine geç.
- Klavye açıldığında form alanları ve kaydet düğmesi erişilebilir kalmalı.

## 6. Yarım Daire Göstergeler

Bütçe kullanımı ve dönem durumu için yarım daire (semicircular) gösterge kullan.

- Gösterge, başlangıçtan sona uzanan 180 dereceye yakın bir yay biçiminde olmalı.
- Yayın arka izi koyu yüzey üzerinde ince ve düşük kontrastlı; dolu kısmı belirgin olmalı.
- Ortada veya yayın hemen altında ana değer ve kısa açıklaması gösterilmeli: örneğin “%64 kullanıldı” veya “₺… kaldı”.
- Göstergeyi ilgili dönem etiketiyle eşleştir: günlük, haftalık veya aylık. Birden fazla gösterge varsa her birinin hangi limite ait olduğu açık olmalı.
- Bütçe kullanımı için standart gösterge mavi olabilir. Limit yaklaşma veya aşımında durum rengi ilgili uyarı kuralıyla birlikte kullanılmalı; gider tutarlarının kırmızı olma kuralı değişmez.
- Bütçe aşıldığında yayı 100%'ün ötesinde yanıltıcı biçimde büyütme. Göstergeyi limitte sabitle ve aşım tutarını ayrıca metinle göster.
- Veri yoksa boş yayı göster ve “Henüz bütçe belirlenmedi” gibi bir açıklama sun; 0% kullanım ile eksik bütçeyi birbirine karıştırma.
- Gösterge bilgisi renk ve yay şekli dışında metin/erişilebilir etiket olarak da sunulmalı. Ekran okuyucu dönem, kullanım yüzdesi, limit ve kalan/aşım tutarını okuyabilmeli.
- Animasyon varsa kısa ve ölçülü olmalı; değer değişimini gizlememeli ve her ekran açılışında dikkat dağıtıcı biçimde tekrar etmemeli.

## 7. Gelir ve Gider Tabloları

### Ana sayfa özet tabloları

- Gelir paneli solda, gider paneli sağda gösterilir.
- Gelir panelinin başlığı/ikonu ve para değerleri yeşil; gider panelinin başlığı/ikonu ve para değerleri kırmızıdır.
- İki panelin kutu zemini ana arka plandan daha açık tonlu ve ilgili sınıfla aynı renk ailesinde olmalıdır: gelir için yeşil tonlu, gider için kırmızı tonlu.
- Panel içinde dönem toplamı ve az sayıda son/önemli kayıt gösterilebilir. Her panelden ilgili detay ekranına geçiş bulunmalı.

### Detay listeleri

- Her gelir ve gider ayrı detay ekranında veya açıkça ayrılmış filtrelenebilir işlem listesinde incelenebilir.
- Satırda işlem açıklaması/kategorisi, tarih ve tutar okunaklı biçimde yer alır. Uzun açıklama satırın yüksekliğini kontrolsüz büyütmemeli; detay ekranında tam metin gösterilebilir.
- Gelir satırındaki tutar yeşil; gider satırındaki tutar kırmızıdır.
- Tablo satır göstergeleri (seçim, filtre, ilerleme veya nötr durum işareti) mavi olabilir. İşlem türü rengini değiştirmez.
- Tablo başlıkları sade, satır ayraçları ince ve kontrastı yeterli olmalı. Alternatif satır zeminleri kullanılıyorsa fark hafif tutulmalı.
- İşlem türü yalnızca renkle anlatılmaz; “Gelir/Gider” etiketi, ikon veya erişilebilir metin de bulunur.
- Filtreler tarih, kategori, tür ve arama alanlarını kapsayabilir; seçili filtreler görünür ve kolay temizlenir olmalı.
- Özel gider tutarı gizliyse tutarın bulunduğu tüm satır/kart ve detay alanlarında sansür uygulanmalı. Satırın diğer alanları okunabilir kalır.
- Hayır işi giderleri gider tablosunda diğer giderlerle aynı kırmızı renk düzenini kullanır; hayır işi olduğunu ayrı bir rozet/ikon/metinle belirtebilirsin.

## 8. Ekranlara Özel Tasarım

### 8.1 Bütçe Özeti Dashboard

- İlk ekranda dönem ve toplam bakiye kolay bulunur.
- Gelir özeti solda ve gider özeti sağda yan yana gösterilir.
- Günlük harcanabilir tutar, hesaplamanın tahmin olduğunu belirten kısa bir etiket taşımalıdır.
- Yarım daire göstergeler seçili limit dönemini, kullanım yüzdesini ve kalan/aşım tutarını metinle de açıklar.
- Yaklaşan ödemeler vade tarihine göre sıralanır; yakın ve gecikmiş kayıtlar metinle belirtilir.
- Ana ekrandaki bildirim/hatırlatma alanı en önemli yaklaşan eylemleri öne çıkarır.

### 8.2 Gelir/Gider Girişi ve İşlem Detayları

- Gelir ve gider türü formun başında görünür ve kolay değiştirilebilir olmalı.
- Gider formunda zorunlu alanlar yıldız/etiketle belirtilmeli; yalnızca kaydetme sonrasında hata gösterme.
- Tutar girişi belirgin ve klavyeyle kolay kullanılabilir olmalı. Para birimi tutarla karışmamalı.
- Tarih ve kategori seçimi kısa, tutarlı ve mevcut mobil bileşen düzenine uygun olmalı.
- Hayır işi seçeneği ve tutarı gizleme kontrolü ayrı anlamlar taşımalı ve seçili durumları görünür olmalı.
- Kaydetme sırasında düğme tekrarlı gönderimi engellemeli; başarı veya hata durumu kullanıcıya bildirilmelidir.
- İşlem detayında düzenleme, silme ve varsa borç/fatura ile ilişki anlaşılır biçimde sunulmalı.

### 8.3 Zarf/Kategori Bütçe Dağılımı

- Bütçe yöntemi (50/30/20 veya zarf/kategori) ve aktif dönem açıkça gösterilmeli.
- Kategori satırında planlanan limit, gerçekleşmiş harcama, kalan/aşım tutarı ve ilerleme yer almalı.
- Tabloya ait ilerleme/gösterge mavi; gider tutarları kırmızı kalmalı.
- Limit değiştirme, yeni zarf ekleme ve kategori seçme eylemleri kolay bulunmalı.
- Kategori renkleri giderlerin kırmızı olma kuralını bozmamalı; farklı kategoriler renkli işlem tutarıyla değil ikon, ad veya mavi nötr işaretlerle ayrıştırılabilir.

### 8.4 Gelecek Ay Simülasyonu

- Beklenen gelir, düzenli ödemeler, borç taksitleri ve planlanan bütçeyi ayrı bloklarda göster.
- Gerçekleşmiş veriler ile tahmini değerler görsel olarak ayrılmalı ve metinle “Tahmin” olarak etiketlenmeli.
- Kullanıcının değiştirdiği varsayımlar (ör. beklenen maaş, fatura tutarı) simülasyon sonucuna nasıl yansıdığıyla birlikte gösterilmeli.
- Kur/altın senaryoları sunuluyorsa kaynak ve güncelleme zamanı görünür olmalı. Canlı veri yoksa manuel varsayım veya açıklamalı örnek senaryo göster; gerçek piyasa fiyatı izlenimi verme.
- Yatırım alanı bilgilendirici karşılaştırma/simülasyondur; kesin getiri, kişiye özel alım talimatı veya otomatik işlem sunmaz.

### 8.5 Harcama Raporları

- Rapor dönemi (gün/hafta/ay), filtreler ve kullanılan para birimi görünür olmalı.
- Gelir ve gider özetleri kendi renklerinde; kategori bütçe göstergeleri nötr/mavi kurallarla gösterilebilir.
- Grafiklerdeki değerler metin veya erişilebilir özetle desteklenmeli.
- Hayır işi gideri gider toplamına dahil edilir; isteğe bağlı olarak filtrelenebilir veya alt toplam olarak gösterilebilir.
- Excel üretme/indirme eylemi ile rapor dönemini açıkça belirt. Özel gider tutarlarının dosyada gösterilme tercihini dışa aktarmadan önce kullanıcıya sun.

### Borçlar, faturalar ve ayarlar

- Borç listesinde verilen/alınan yönü, karşı tarafı, kalan tutarı ve vade bilgisini tek bakışta anlaşılır yap.
- Vadesi yaklaşan veya gecikmiş borçları tarih ve metin etiketiyle ayırt et.
- Düzenli faturalarda tekrarlama sıklığı ve bildirim zamanı farklı alanlar olarak gösterilmeli.
- Maaş günü ayarı ve bildirim tercihleri kolay bulunmalı; kullanıcı her bildirim türünü yönetebilmelidir.
- Uygulama içi bildirimler için ayrı bir gelen kutusu/hatırlatma listesi varsa okunmuş, ertelenmiş ve tamamlanmış durumları açıkça ayrıştır.

## 9. Uyarı ve Bildirim Tasarımı

| Durum | Görünüm | Metin ve etkileşim |
|---|---|---|
| Bilgilendirici mesaj | Koyu yüzey, mavi ikon/işaret | Kısa durum açıklaması; gerekiyorsa detay bağlantısı |
| Standart uyarı (limit yaklaşıyor, olağan dışı gelir) | Sarı zemin, siyah yazı ve ikon | Durumu ve kullanıcının yapabileceği sonraki adımı açıkla |
| Kritik uyarı (limit aşıldı, geciken ödeme) | Kırmızı zemin, beyaz yazı ve ikon | Kritik durumu ve ilgili borç/limit ekranına geçişi göster |
| Başarı (kayıt/rapor tamamlandı) | Koyu yeşil tonlu yüzey, açık metin | İşlemin tamamlandığını ve gerekirse nerede görüleceğini belirt |

- Sarı ve kırmızı uyarıları yalnızca renk farkıyla ayırt etme; ikon ve başlık/etiket kullan.
- Uyarı cümleleri kısa ve somut olmalı. Örneğin hangi limitin yaklaştığını ve hangi döneme ait olduğunu söyle.
- Aynı uyarı arka arkaya yinelenmemeli; çözülmüş veya kullanıcı tarafından kapatılmış uyarı davranışı tutarlı olmalı.
- Sistem bildirimi ile uygulama içi uyarı aynı renkte/aynı metinde olabilir; bildirim izni reddedilmişse uygulama içi uyarı yine görünmelidir.
- Kritik bir ödeme uyarısı, kullanıcıyı doğrudan ilgili borç/fatura kaydına götürmelidir.

## 10. Kartlar, Butonlar ve Form Bileşenleri

- Kartlar `surface`/`surfaceRaised` tonlarında, hafif sınır çizgisi ve tutarlı köşe yarıçapıyla tasarlanmalı.
- Gelir/gider kutuları kendi renk ailesindeki daha açık tonlu yüzeyi kullanmalı; beyaz metin ve tür renginde tutar içermeli.
- Birincil buton mavi veya mevcut ürünün ana vurgu rengiyle tasarlanabilir; finansal gelir/gider renklerine müdahale etmemeli.
- Silme gibi yıkıcı eylemler kırmızı vurgu kullanabilir ancak kaydetme veya temel gezinme ile karıştırılmamalı.
- Giriş alanlarında koyu yüzey, açık metin, görünür sınır/focus durumu ve erişilebilir hata rengi olmalı.
- Seçili filtre ve tablo satırı vurgusunda mavi kullan; seçili olma durumu yalnızca ince renk değişimine bağlı kalmasın.
- Modal ve alt sayfalar küçük telefonlarda klavye ve sistem gezinme alanlarıyla çakışmamalı.

## 11. Boş, Yükleniyor ve Hata Durumları

- **Boş durum:** Ne gösterilmesi gerektiğini ve ilk işlemin nasıl eklenebileceğini söyle.
- **Yükleniyor:** Yerleşimi koruyan sade bir gösterge kullan; kullanıcıya ilerleme hissi ver ama işlem tamamlanmış gibi göstermeme.
- **Hata:** Teknik ayrıntı veya hassas veri göstermeden, kullanıcıya anlaşılır neden ve uygunsa yeniden deneme eylemi sun.
- **Çevrim dışı:** Kaydın yerel olarak saklanıp saklanmadığını açıkla; başarısız kaydı sessizce kaybolmuş gibi bırakma.
- **Bütçe yok:** Göstergeyi boş/etkisiz durumda sun ve bütçe ekleme eylemi öner; yüzde 0 kullanımı gibi göstermeme.
- **Rapor yok:** Dönem veya filtre nedeniyle sonuç bulunmadığını ayırt et; filtreyi temizleme seçeneği ver.
- **Bildirim izni yok:** Uygulama içi hatırlatmaları göstermeye devam et ve cihaz bildirimlerinin nasıl açılacağını kısa biçimde belirt.

## 12. Erişilebilirlik ve Kullanılabilirlik

- Metin ve arka plan arasında okunabilir kontrast koru; özellikle mavi, kırmızı ve yeşil tutarları koyu yüzeylerde kontrol et.
- Renk dışında metin/ikon desteğiyle gelir, gider, uyarı ve başarı durumlarını anlat.
- Ekran okuyucu açıklamalarında sansürlenmiş giderin gizli tutarını okuma.
- Yarım daire göstergeyi yüzdelik ve kalan/aşım tutarı metniyle eşleştir.
- Tabloları ekran okuyucu için satır/alan ilişkisi okunabilir biçimde kur; yalnızca sütun konumuyla anlam vermek zorunda bırakma.
- Metin büyütme, yeterli dokunma alanı, klavye/odak sırası ve sistem yazı boyutuna uyumu koru.
- Animasyon ve yanıp sönme kullanma; kullanıcı hareket azaltma tercihini gözet.

## 13. Tasarım Kalite Kontrolü

Her görsel değişiklikten sonra ilgili ekranları en azından dar telefon ve geniş telefon ölçülerinde gözden geçir. Değişiklik kapsamı uygunsa tablet yerleşimini de kontrol et.

Kontrol listesi:

- Gelir özeti solda ve yeşil; gider özeti sağda ve kırmızı mı?
- Ana zemin koyu lacivert-siyah, metinler beyaz/açık renkli mi?
- Gelir ve gider kutularının arka planları açık tonlu ve kendi renk ailesinde mi?
- Tablo göstergeleri mavi kalırken işlem tutarları doğru gelir/gider rengiyle gösteriliyor mu?
- Yarım daire göstergeler dönem, limit ve kalan/aşım bilgisini okunur veriyor mu?
- Sarı uyarıda siyah; kritik kırmızı uyarıda beyaz metin var mı?
- Özel gider tutarı özet, liste, detay, bildirim ve erişilebilir açıklamalarda sızıyor mu?
- Geniş ve dar ekranlarda metin, tablo, klavye veya alt menü taşması var mı?
- Renkle anlatılan her durum ayrıca metin/ikonla da anlaşılabiliyor mu?

## 14. Açık Tasarım Kararları

`project.md` içindeki ürün soruları ve mevcut uygulama kararlarıyla birlikte çöz:

- Uygulama yalnızca Flutter mobil mi olacak, ileride tablet/web düzeni de hedefleniyor mu?
- Ana ekrandaki yarım daire göstergeler günlük, haftalık ve aylık limitlerden hangilerini aynı anda gösterecek?
- Telefon boyutunda iki özet panelinin tam tabloları ayrı ekranlarda mı, sekmelerde mi listelenecek?
- Özel tutarlar Excel raporlarında varsayılan olarak gizli mi kalacak, kullanıcı dışa aktarmada mı seçecek?
- Açık/karanlık tema seçimi sunulacak mı? Kullanıcı koyu lacivert-siyah görünümü temel tema olarak istemiştir.

Bu kararlar verilene kadar kullanıcının açıkça belirttiği koyu tema, gelir/gider renkleri, tablo konumu, yarım daire göstergeler ve uyarı renklerini koru.