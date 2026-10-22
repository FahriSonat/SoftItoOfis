Const
1) ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez CPU ve pil tasarrufu sağlar.

final
1) ne işe yarar : çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler
const ve final farkı: const derlenirken bilinmek zorunda(const pi=3.14) final ise çalışma anında belirlene bilir(final saat = DateTime.now())---Model sınıflarında alanlar her zaman final olmalıdır.---

late
1) ne işe yarar: değişen tanımlandığı anda değil ,ilk kullanıldığında veya inisState anında başlayılacağı zaman kullanılır.

required
ne işe yarar : isimlendirlmiş parametrelerde o parametrenin(değişkenin ) zorunlu olduğunu belirtir.

@override
1) ne işe yarar: alt sınıfların üst sınıflardan devraldığı metodu ezdiğini belirtir 

2)eğer üst metodun ismini yanlış yazarsak alt sınıfın methodu ezilmez, override olmamış olur. Bu durumda üst metodun içindeki kodlar çalışmaz. Bu yüzden override kullanırken üst metodun isminin doğru yazıldığından emin olunmalıdır. Hata durumlarını önlemek için @override kullanılmalıdır.

Null-aware operatörleri (? ?? !)
?. - place?.title -> eğer place null ise hata vermez direkt null olarak 

! (null / force): final id = state.userId ! -> bu kod derleyiciye "bana güven bu değer o anda"


Spread operatörü(...)
1) ne işe yarar: bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler. Column ve ListView içinde dinamik 

initState()
Ne zaman çalışır : widget ağaca fiziksel olarak ilk olarak başladığında yalnızca 1 kere çalışır
Ne yapar : ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: içinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.

didChangeDependencies()
Ne zaman çalışır : widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır 
Ne yapar : ScrollController başlatmaları ve ilk api istekleri burda kural 

shrinkWrap: true 
Bir ListView baş bir dikay kaydırıcı (singleChildScrollview) içine konursa Vertical viewport hatası verir
shrinkWrap true verilerek bu çözülebilir ancak: ListView'un sonsuza kayma (sonsuz scroll) özelliği kaybolur. 

**Sadece 3 5


form mimarisi 

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışardan erişilemiyor. Bu yüzden Widgetin en üstüne koyduğumuz globalkey 

Curves 
İvmelenme Karakterleri 

Curves.linear: Sabit hız (robotik hareketler)
Curves.easeInout:Yavaş başlar ortada hızlanır yavaşça durur
Curves.bounceOut:Hedefe çarptığında top gibi 2 3 kez yaylanarak seker
Curves.elasticOut:Lastik gibi ileri geri titreyerek yerine oturur

Gorouter

context.go('/profil'): Route Yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir.

context.push('/profil/5') stack yönlendirmedir. Kullanıcı nereden gelirse gelsin mecvut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler 

context.pop() sayfanın en üstteki yığını kapatır.

state.pathParameters["id"]: Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır 

/profil?user=Fahri
state.uri.queryParameters["user"]: opsiyonel filtreleme yada arama zamanlarında kullanılır.

Cihaz içi Yerel Depolama mimarileri 

SharedPreferences:
Küçük kullanıcı ayarları
düşük güvenilirlik
Okuma yazma hızları: okuma hızı orta / yazma hızı yavaş

FlutterSecureStorage:
şifre token vb. saklama 
en yüksek güvence
orta


Hive/Isar:
yüksek performanslı nesne depolama
orta (isteğe bağlı şifreleme açılabilir)
aşırı hızlı