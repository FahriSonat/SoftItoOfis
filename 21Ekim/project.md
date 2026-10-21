# Kişisel Günlük Para Takip Uygulaması

## 1. Proje Özeti

Gelirleri, zorunlu giderleri, borçları ve bütçe hedeflerini ayrıntılı biçimde takip etmeye yardımcı olan kişisel finans uygulaması. Kullanıcı ana ekranda sade bir özet görür; işlemlerin ayrıntılarını ilgili ekranlarda inceler. Uygulama bütçe limitlerini ve yaklaşan ödemeleri hatırlatır, dönemsel raporlar sunar ve Excel çıktısı oluşturur.

## 2. Projenin Amacı

- Gelir ve giderleri düzenli, ayrıntılı ve izlenebilir biçimde kaydetmek.
- Günlük, haftalık ve aylık harcama limitlerini takip etmek.
- Zarf/kategori bütçeleri veya 50/30/20 kuralıyla bütçe planlamak.
- Fatura, borç ve kart ödemelerini zamanında hatırlatmak.
- Maaş ve diğer gelirlerin ay içindeki durumunu görünür kılmak.
- Kullanıcının harcama davranışını raporlarla anlamasına yardımcı olmak.

## 3. Hedef Kullanıcı

Kişisel gelirini, günlük harcamalarını, faturalarını, borçlarını ve tasarruf hedeflerini tek bir yerde takip etmek isteyen bireysel kullanıcı.

## 4. Tahmini Ekran ve Sayfa Sayısı

Uygulama beş ana ekrandan oluşur:

1. **Bütçe Özeti Dashboard:** Gelir, gider, mevcut bakiye, kalan günlük harcanabilir tutar, limit durumu ve yaklaşan hatırlatmaların özeti.
2. **Gelir/Gider Girişi ve İşlem Detayları:** Gelir veya gider ekleme; giderin ve gelirin tüm ayrıntılarını inceleme, düzenleme ve gerektiğinde silme.
3. **Zarf/Kategori Bütçe Dağılımı:** 50/30/20 bütçesi veya kullanıcının belirlediği zarf ve kategori limitleri.
4. **Gelecek Ay Simülasyonu:** Beklenen gelir, düzenli faturalar, borç taksitleri, bütçe planı ve kullanıcının seçtiği varsayımlara göre gelecek ay tahmini.
5. **Harcama Raporları:** Günlük, haftalık ve aylık gelir-gider özetleri, kategori dağılımları, limitlere uyum ve Excel dışa aktarma.

Borçlar, faturalar, bildirimler ve ayarlar bu ana ekranlardan erişilen bölümler veya ilgili ekran içi görünümler olarak tasarlanabilir. Nihai navigasyon prototip aşamasında netleştirilecektir.

## 5. Kullanıcının İstediği Temel Özellikler

### 5.1 Bütçe ve harcama takibi

- 50/30/20 bütçe kuralı veya kullanıcı tarafından tanımlanabilen zarf/kategori bütçeleri desteklenir. Kullanıcı bütçeleme yöntemini seçebilir.
- Günlük, haftalık ve aylık harcama limitleri ayrı ayrı belirlenebilir.
- Limit yaklaşıldığında ve aşıldığında uyarı gösterilir.
- Kalan günlük harcanabilir para hesaplanıp ana ekranda gösterilir. Hesaplamada kullanıcı tarafından tanımlanmış dönem, gelir ve bütçe varsayımları esas alınır.
- Haftalık bütçe durumu ve tasarruf önerileri sunulur.

### 5.2 Gelir ve gider kayıtları

- Gelir ve giderler ilgili detay ekranında listelenir; ana ekranda yalnızca toplamlar ve kısa özet gösterilir.
- Kullanıcının giderleri zorunlu olarak ayrıntılı kaydedilir. Bir gider kaydı için tutar, kategori, tarih ve açıklama zorunludur; fiş/fatura bilgisi veya ek notlar ilgili gider türüne göre istenebilir.
- Gider girişinde fiş/fatura açıklaması ve isteğe bağlı ek not girilebilir. Görsel fiş/fatura ekleme, ilk sürüm kapsamı dışındadır; ayrıca kararlaştırılabilir.
- Hatalı kayıtlar düzenlenebilir. Kayıt silme işleminde onay istenir.
- Gelir kaydında tür, tutar, tarih ve açıklama yer alır.

### 5.3 Hayır işi olarak işaretlenen giderler

- Gider kaydında **“Hayır işi”** seçeneği bulunur.
- Hayır işi olarak işaretlenen kayıtlar gider tablosunda diğer giderlerle aynı renk düzenini kullanır ve toplam gider içinde sayılır.
- Hayır işi tutarları raporlarda ayrıca filtrelenebilir veya alt toplam olarak gösterilebilir; genel gider toplamından çıkarılmaz.

### 5.4 Özel gider tutarını gizleme

- Kullanıcı özel olarak işaretlediği bir giderin tutarını isteğe bağlı gizleyebilir.
- Gizli tutar, uygulamanın desteklediği tutar gösterim alanlarında sansürlü görünür; bu kayıt gider toplamı ve hesaplamalara dahil olmaya devam eder.
- Tutarı gösterme/gizleme yetkisi kullanıcıya ait olur. Dışa aktarma sırasında gizli tutarların nasıl ele alınacağı kullanıcı ayarıyla belirlenir.

### 5.5 Düzenli gider ve fatura hatırlatmaları

- Kullanıcı düzenli faturaları ve beklenen giderleri tanımlayabilir.
- Hatırlatma aralığı günlük, haftalık veya aylık olarak seçilebilir.
- Yaklaşan ödeme bildirimleri uygulama içinde ve cihaz bildirimleri destekleniyorsa bildirim olarak gösterilir.
- Ödeme yapıldığında kullanıcı gideri gerçekleşmiş olarak kaydedebilir; beklenen gider ile gerçekleşen gider raporlarda ayırt edilir.

### 5.6 Borç alma, borç verme ve ödeme hatırlatmaları

- Kullanıcı verdiği ve aldığı borçları; tutar, ilgili kişi/kurum, vade ve not bilgileriyle kaydedebilir.
- Borç taksitleri ve geri ödemeler için vade tarihinden bir hafta önce ve kullanıcının belirlediği maaş günü hatırlatma gönderilir.
- Maaş günü hatırlatmaları ana ekranda görünür.
- Verilen borçlar borç ekranında tek satır özet halinde listelenir; vade geldiğinde ilgili borç için uyarı gösterilir.
- Borç geri ödemesi gerçekleştiğinde ödeme durumu güncellenir ve ilgili nakit akışı kaydı oluşturulur ya da kullanıcıdan mevcut işlemle eşleştirmesi istenir.

### 5.7 Gelir tahmini ve olağan dışı gelir uyarısı

- Gelir ekranı düzenli gelir tarihleri ve tutarları üzerinden gelecek dönem gelir tahmini sunar.
- Maaş veya borç geri ödemesi olarak sınıflandırılmayan yeni bir gelir kaydedildiğinde, kullanıcıya bu gelirin olağan dışı olabileceği yönünde uyarı gösterilir.
- Uyarı bilgilendirme amaçlıdır; kullanıcı kaydı onaylayabilir veya gelir türünü değiştirebilir.

### 5.8 Maaş günü ve yatırım senaryosu

- Kullanıcı maaş gününü tanımlar.
- Maaşın hesaba geçtiği tarihten sonraki ilk üç gün içinde kredi kartı ve borç ödemeleri için hatırlatma gösterilir.
- Maaş, planlı ödemeler ve kalan tutar özetlenir.
- Kalan maaş için dolar, euro ve altınla ilgili senaryolar gösterilebilir. Bu bölüm kullanıcı tarafından seçilen tutar, zaman aralığı ve varsayımlara dayalı bilgilendirici bir karşılaştırma/simülasyon olarak tasarlanır; kesin getiri vaadi veya kişiye özel yatırım talimatı vermez.
- Güncel kur veya altın fiyatı kullanılacaksa kaynak, güncelleme zamanı ve veri bulunamadığında gösterilecek durum ayrıca belirlenmelidir. Harici finansal veri sağlayıcısı entegrasyonu ayrıca kararlaştırılacaktır.

### 5.9 Excel raporları

- Her ayın son günü, kullanıcının yerel saatine göre aylık rapor Excel dosyası olarak otomatik hazırlanır.
- Raporun üretildiği/indirilebilir olduğu kullanıcıya uygulama içinde bildirilir. Otomatik e-posta veya başka bir kanaldan teslimat istenirse ayrıca tanımlanır.
- Kullanıcı istediği zaman raporlardan Excel çıktısı alabilir.
- Rapor en azından gelirleri, giderleri, kategorileri, bütçe durumunu, borç hareketlerini ve aylık toplamları kapsar.
- Özel tutar gizleme ayarı dışa aktarmada da uygulanabilir; tercih kullanıcı tarafından belirlenir.

## 6. Ana Sayfa ve Bilgi Hiyerarşisi

Ana sayfa hızlı bir özet sunar ve ayrıntılı işlem tablosunu barındırmaz. Önerilen özet alanları:

- Bu ayın toplam geliri ve toplam gideri
- Mevcut bakiye veya dönem neti
- Kalan günlük harcanabilir tutar
- Günlük/haftalık/aylık limit durumu
- Yaklaşan faturalar, borçlar ve kart ödemeleri
- Haftalık bütçe durumu
- Son işlemlerden kısa bir liste

Gider ve gelirlerin tam ayrıntıları kendi ekranlarında okunur. Ana sayfadaki özetlerden ilgili ayrıntı ekranına geçiş yapılabilir.

## 7. Önerilen İlk Sürüm Kapsamı (MVP)

İlk çalışan sürüm için önerilen öncelik sırası:

1. Gelir ve zorunlu ayrıntıları olan gider kaydı.
2. Ana sayfada gelir, gider, bakiye ve kalan günlük tutar özeti.
3. Günlük, haftalık ve aylık limitler ile limit uyarıları.
4. 50/30/20 veya zarf bütçesi seçimi ve kategori dağılımı.
5. Düzenli fatura tanımı ve yaklaşan ödeme hatırlatmaları.
6. Borç alma/verme kaydı ve vade hatırlatmaları.
7. Hayır işi işaretleme ve özel gider tutarı gizleme.
8. Aylık raporlar ve isteğe bağlı Excel dışa aktarma.

Gelecek ay simülasyonu, otomatik ay sonu Excel üretimi, yatırım senaryoları ve dış finansal veri kaynağı entegrasyonu ikinci aşamaya bırakılabilir. Kullanıcı isterse öncelikler değiştirilebilir.

## 8. Veri Modeli Önerisi

### Transaction (Gelir/Gider)

| Alan | Tür | Açıklama |
|---|---|---|
| id | UUID | Benzersiz kayıt kimliği |
| type | income / expense | Kayıt türü |
| amountMinor | integer | En küçük para biriminde tutar (ör. kuruş) |
| currency | ISO 4217 kodu | Para birimi |
| categoryId | UUID | Kategori kimliği |
| occurredAt | date/datetime | Gelir veya giderin gerçekleştiği tarih |
| description | string | Zorunlu açıklama |
| receiptNote | string / null | Fiş/fatura açıklaması veya referansı |
| isCharity | boolean | Hayır işi olarak işaretlenmiş gider mi? |
| isAmountHidden | boolean | Tutar arayüzde sansürlensin mi? |
| incomeSource | salary / debt_repayment / other / null | Gelir kaynağı sınıflandırması |
| createdAt | datetime | Oluşturulma zamanı |
| updatedAt | datetime | Son güncelleme zamanı |

### Category (Kategori/Zarf)

| Alan | Tür | Açıklama |
|---|---|---|
| id | UUID | Benzersiz kategori kimliği |
| name | string | Kategori adı |
| type | income / expense / both | Kategorinin kullanılabildiği işlem türü |
| color | string | Görsel renk |
| icon | string / null | İsteğe bağlı ikon |
| isSystem | boolean | Sistem kategorisi mi? |

### Budget (Bütçe)

| Alan | Tür | Açıklama |
|---|---|---|
| id | UUID | Benzersiz bütçe kimliği |
| period | day / week / month | Bütçe dönemi |
| amountMinor | integer | Limit tutarı |
| categoryId | UUID / null | Boşsa genel bütçe; doluysa kategori bütçesi |
| method | envelope / 50-30-20 / custom | Bütçe yöntemi |
| startsOn | date | Başlangıç tarihi |
| alertThreshold | percentage | Uyarı eşiği |

### RecurringPayment (Düzenli ödeme)

| Alan | Tür | Açıklama |
|---|---|---|
| id | UUID | Benzersiz ödeme kimliği |
| title | string | Fatura/ödeme adı |
| expectedAmountMinor | integer / null | Beklenen tutar; bilinmiyorsa boş olabilir |
| currency | ISO 4217 kodu | Para birimi |
| cadence | daily / weekly / monthly | Tekrarlama sıklığı |
| dueDate | date | Sonraki vade |
| reminderSettings | object | Hatırlatma zamanları |
| categoryId | UUID / null | İlişkili kategori |

### Debt (Borç)

| Alan | Tür | Açıklama |
|---|---|---|
| id | UUID | Borç kaydı kimliği |
| direction | lent / borrowed | Verilen veya alınan borç |
| counterparty | string | Kişi/kurum |
| principalMinor | integer | Ana tutar |
| remainingMinor | integer | Kalan tutar |
| currency | ISO 4217 kodu | Para birimi |
| dueDate | date / null | Vade tarihi |
| status | open / partial / settled | Ödeme durumu |
| note | string / null | İsteğe bağlı not |

## 9. Temel İş Kuralları

- Para hesaplamaları kayan noktalı sayı (`float`) ile yapılmaz; tutarlar en küçük para biriminde tam sayı veya uygun decimal türüyle tutulur.
- Para birimi her işlemde açıkça belirlenir. Farklı para birimleri, kur dönüşümü tanımlanmadan tek bakiyede toplanmaz.
- Gider tutarları ve gelir tutarları sıfırdan büyük girilir; yönünü işlem türü belirler.
- Her giderin tutarı, kategorisi, tarihi ve açıklaması zorunludur.
- Hayır işi giderleri toplam giderlere dahil edilir ve gider raporlarında aynı gider renk düzeniyle gösterilir.
- Tutarı gizli giderler tüm hesaplamalara dahil edilir; yalnızca gösterim ve seçilen dışa aktarma davranışı değişir.
- Limit aşımları, seçilen limit dönemi ve kullanıcının yerel tarih/saat dilimine göre hesaplanır.
- Beklenen fatura ile gerçekleşmiş ödeme ayrı durumlar olarak tutulur; beklenen ödeme gerçekleşmiş gider gibi iki kez sayılmaz.
- Borç verme/alma, geri ödeme ve gelir/gider hareketlerinin çift sayılmaması için borç bakiyesi ile nakit akışı ayrı ama ilişkilendirilebilir kayıtlar olarak tasarlanır.
- Gelir türü maaş veya borç geri ödemesi değilse olağan dışı gelir uyarısı gösterilir; kullanıcı işlemi kaydetmeye devam edebilir.
- Maaş günü hatırlatma penceresi kullanıcının yerel saat diliminde hesaplanır.
- Aylık Excel dosyası ayın son yerel gününde bir kez oluşturulur; üretim başarısız olursa uygulama durumu ve tekrar deneme yöntemi tanımlanmalıdır.

## 10. Hatırlatma ve Bildirim Özeti

| Olay | Zamanlama | Gösterim |
|---|---|---|
| Bütçe limitine yaklaşma/aşma | Kullanıcının belirlediği eşik ve limit aşımında | Uygulama içi; cihaz bildirimi destekleniyorsa push |
| Fatura veya düzenli gider | Kullanıcının günlük/haftalık/aylık ayarına göre | Takvim/hatırlatma ve ana sayfa |
| Borç vadesi | Vade tarihinden 1 hafta önce ve maaş gününde | Ana sayfa ve borç ekranı |
| Verilen borcun vadesi | Vade tarihinde | Borç ekranında tek satır kayıt üzerinde uyarı |
| Maaş sonrası kart/borç ödemeleri | Maaş tarihinden sonraki ilk 3 gün | Ana sayfa ve bildirim |
| Ay sonu Excel raporu | Her ayın son günü | Rapor hazır bildirimi ve indirme bağlantısı |

Bildirim izinleri kapalıysa ilgili uyarılar uygulama içinde görünmeye devam eder.

## 11. Güvenlik ve Gizlilik

- Finansal kayıtlar kişisel ve hassas veri olarak ele alınır.
- Kullanıcı yalnızca kendi verilerine erişebilir; hesaplı kullanım seçilirse sunucu tarafı erişim kuralları uygulanır.
- Hassas tutarlar ve kimlik bilgileri loglara yazılmaz.
- Özel gider tutarını gizleme özelliği, toplamların doğruluğunu bozmadan arayüzde sansürlü gösterim sağlar.
- Dışa aktarılan Excel dosyası hassas finansal bilgi içerebilir; indirme ve paylaşım kullanıcı kontrolünde olmalıdır.
- Kullanıcı verilerini dışa aktarma ve silme seçenekleri bulunmalıdır.
- Verilerin cihazda mı, bulutta mı tutulacağı ürünün teknik mimarisi belirlenirken kararlaştırılacaktır.

## 12. Başarı Ölçütleri ve Kabul Kriterleri

- Kullanıcı gelir ve zorunlu ayrıntıları içeren gider kaydı oluşturup düzenleyebilir.
- Ana ekranda gelir ve gider toplamları, bakiye ve kalan günlük tutar tutarlı biçimde görüntülenir.
- Gelir ve gider ayrıntıları ayrı işlem ekranlarında okunabilir.
- Seçilen günlük, haftalık ve aylık limitler doğru dönemde hesaplanır; yaklaşma ve aşım uyarıları çalışır.
- Hayır işi giderleri gider tablosunda aynı renk sistemini kullanır ve gider toplamına dahildir.
- Gizli tutarlı giderler toplam ve rapor hesaplamalarına dahildir; kullanıcı arayüzünde sansürlü görünür.
- Fatura ve borç hatırlatmaları doğru tarihte gösterilir; borç vadesi bir hafta önce ve maaş gününde hatırlatılır.
- Maaş sonrası ilk üç günlük kart/borç hatırlatmaları kullanıcının seçtiği maaş tarihine göre hesaplanır.
- Aylık rapor Excel olarak indirilebilir; otomatik üretim durumu kullanıcıya bildirilir.
- Gelir, gider, borç ve fatura hareketlerinde çift sayım oluşmaz.

## 13. Önerilerim ve Ürün Kararları

Bu bölüm, başlangıç için önerilen ek kararları içerir; uygulama geliştikçe değiştirilebilir.

- **Mobil öncelikli tasarım:** Günlük kayıt ve hatırlatma kullanımı nedeniyle önce telefon ekranlarını tasarlamak.
- **Para birimi ve dil ayarı:** İlk sürümde varsayılan olarak Türkçe ve TRY kullanmak; para birimini ayarlardan değiştirilebilir tasarlamak.
- **Hatırlatma esnekliği:** Bir olay için birden fazla bildirim istemeyen kullanıcıya hatırlatmaları açıp kapatma ve zamanını değiştirme kontrolü vermek.
- **Limit yaklaşma uyarısı:** Varsayılan eşik olarak bütçenin %80'inde uyarı önermek; kullanıcıya eşiği değiştirme olanağı sağlamak.
- **Günlük harcanabilir tutar:** Kalan dönem bütçesini ayın/haftanın kalan günlerine bölerek tahmin göstermek ve bunun bir tahmin olduğunu belirtmek.
- **Düzenli işlemler:** Maaş, kira ve faturalar için tekrarlayan kayıt şablonları sağlamak; tahmini kayıtları kullanıcı onayı olmadan gerçekleşmiş gelir/gider saymamak.
- **Yedekleme ve dışa aktarma:** Excel'e ek olarak ileride CSV veya yedek dosyası seçeneğini değerlendirmek.
- **Yatırım simülasyonu:** Dolar, euro ve altın seçeneklerini yalnızca güncel ve kaynağı belirtilmiş veri varsa göstermek; aksi halde manuel değer girişi veya simülasyon varsayımları kullanmak.
- **Karanlık tema ve erişilebilirlik:** Yüksek kontrast, ekran okuyucu etiketleri ve açık/karanlık tema desteğini tasarım aşamasında gözetmek.
- **Çevrim dışı kullanım:** İlk sürüm mimarisi uygunsa kayıtların internet bağlantısı olmadan da eklenebilmesini değerlendirmek.

## 14. İlk Sürüm Dışında Tutulabilecek Özellikler

- Banka hesabına bağlanarak otomatik işlem alma
- Kredi kartı veya banka sağlayıcısı entegrasyonu
- Otomatik alım-satım veya yatırım hesabı işlemi
- Birden fazla kullanıcının ortak bütçe yönetimi
- Fiş görüntüsünden otomatik veri çıkarma
- Vergi, muhasebe veya kurumsal finans özellikleri

Bu özellikler ayrı kapsam ve güvenlik değerlendirmesiyle daha sonra ele alınabilir.

## 15. Açık Ürün Soruları

- Uygulama ilk aşamada mobil, web veya her ikisi olarak mı geliştirilecek?
- Kullanıcı hesabı ve cihazlar arası senkronizasyon gerekli mi?
- Veriler cihazda mı, bulutta mı saklanacak?
- Varsayılan ve desteklenecek para birimleri hangileri olacak?
- Aylık otomatik Excel dosyası uygulama içinden mi sunulacak, e-posta ile de gönderilecek mi?
- Yatırım simülasyonu için güncel kur/altın verisi kullanılacak mı; kullanılacaksa hangi veri kaynağı seçilecek?
- Maaş günü ayın belirli tarihi mi olacak, yoksa her ay değiştirilebilir mi?
- “Günlük/haftalık/aylık hatırlatma” faturanın tekrar sıklığını mı, yoksa hatırlatma sıklığını mı ifade edecek? Ekran tasarımında bu iki ayar ayrı isimlendirilmelidir.
- Özel gider tutarı Excel çıktısında varsayılan olarak sansürlü mü olmalı, yoksa kullanıcının açık seçimiyle mi dahil edilmeli?
