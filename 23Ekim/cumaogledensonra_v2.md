Sözleşmeler, SOLID Prensipleri & OOP Mimarisi
1. Interface Nedir? (Arayüz / Sözleşme)
Sözlük anlamı: İki bağımsız sistemin veya sınıfın birbirleriyle nasıl konuşacağını belirleyen, içi boş metot imzalarından oluşan kurallar bütünü.
Neden kullanılır: Bir sınıfa göbekten bağımlı kalmamak. Örneğin; gerçek şarj istasyonu cihazı olmadan sahte/mock şarj servisiyle testi çalıştırabilmek için.
Dart
abstract interface class StationContract {
  Future<void> startCharging(String socketId);
  Stream<double> watchLivePower();
}
1.2. implements vs extends vs with
1.2.1. implements (Arayüz Sözleşmesi)
Sözlük anlamı: Bir sınıfın, bir şablonun belirlediği kuralları kabul edip içini sıfırdan kendisinin doldurması zorunluluğudur.
Neden kullanılır: Farklı sınıflara ortak bir standart sözleşme dayatmak, çoklu arayüz desteği sağlamak ve koddaki bağımlılıkları azaltmak için.
1.2.2. extends (Kalıtım / Miras)
Sözlük anlamı: Bir sınıfın, başka bir sınıfın özelliklerini ve metotlarını doğrudan devralmasıdır.
Neden kullanılır: Kod tekrarını önlemek (DRY) ve mantıksal bir sınıf hiyerarşisi oluşturmak için.
1.2.3. with (Mixin / Yetenek Aşılama)
Sözlük anlamı: Sınıf hiyerarşisini bozmadan, bağımsız bir sınıfa hazır kod blokları (metotlar ve değişkenler) enjekte etme mekanizmasıdır.
Neden kullanılır: Akraba olmayan sınıflara ortak yetenekler kazandırmak, çoklu kalıtım karmaşasını önlemek ve modülerliği artırmak için.
1.3. SOLID Prensipleri
Spagetti kodları önlemek için geliştirilmiş 5 temel kural:
Single Responsibility Principle (Tek Sorumluluk Prensibi):
Kural: Bir sınıfın veya dosyanın değişmesi için yalnızca bir sebebi olmalıdır.
Open/Closed Principle (Açık/Kapalı Prensibi):
Kural: Yazılım varlıkları (sınıflar, modüller) genişletilmeye açık, ancak değiştirilmeye kapalı olmalıdır.
Liskov Substitution Principle (Liskov'un Yerine Geçme Prensibi):
Kural: Bir üst sınıfın yerine, onun alt sınıflarından herhangi biri geçirildiğinde sistemin davranışı bozulmamalı ve hata fırlatılmamalıdır.
Interface Segregation Principle (Arayüz Ayrıştırma Prensibi):
Kural: İstemciler (sınıflar), kullanmadıkları metotları içermeye zorlanmamalıdır. Şişman (fat) interface'ler yerine küçük, amaca yönelik arayüzler kurulmalıdır.
Dependency Inversion Principle (Bağımlılıkların Tersine Çevrilmesi Prensibi):
Kural: Yüksek seviyeli modüller (UI, iş mantığı), düşük seviyeli modüllere (veritabanı, HTTP istemcisi) doğrudan bağımlı olmamalıdır; her ikisi de soyutlamalara (interface) bağlı olmalıdır.
1.4. Coupling (Bağlaşıklık) & Cohesion (Uyum)
Tightly Coupled (Sıkı Bağlı): Sınıfların birbirinin her detayını bilmesi. Birinde yapılan 1 harflik değişiklik diğer 5 dosyayı bozuyorsa, sistem sıkı bağımlıdır.
Loosely Coupled (Gevşek Bağlı): Sınıfların birbirleri hakkındaki bilgileri minimumda tutması. Birinde yapılan bir değişiklik diğer dosyaları etkilememelidir.
High Cohesion (Yüksek Uyum): Bir sınıfın sadece ve sadece kendi uzmanlık alanını yapması.
Stream Temelleri, Cubit & Enterprise BLoC
2.1. Stream Nedir? (BLoC'un Kalbindeki Motor)
Sözlük anlamı: Zaman içinde parça parça gelen, akıp giden asenkron veri dizisidir.
BLoC sırrı: BLoC kütüphanesi sihirli bir şey yapmaz! BLoC'un içinde gizli bir StreamController vardır. Event'ler borunun bir ucundan girer (sink.add), BLoC onları işler ve diğer ucundan ekrana state'ler akıtır (stream.listen).
2.2. BLoC'un 3 Temel Elemanı: Event, State, Emitter
Event (Olay): Kullanıcının veya sistemin BLoC'a attığı emir fişidir.
State (Durum): Ekranın o milisaniyedeki dondurulmuş fotoğrafıdır (snapshot).
Dart
class ChargingActiveState extends ChargingState {
  final double kwh;
}
Emitter: BLoC'un ürettiği yeni state'i ekrana fırlattığı megafon borusudur.
3.1. Side Effect (Yan Etki) Neden Listener'da Yazılır?
BlocBuilder'ın tek görevi widget döndürmektir. Flutter motoru ekranı saniyede 60 kez çizebilir (rebuild). Eğer siz BlocBuilder içine ScaffoldMessenger.showSnackBar veya Navigator.push yazarsanız; kullanıcı cihazı yan çevirdiğinde veya klavye açıldığında kullanıcıya üst üste defalarca snackbar patlar ve yeni sayfa açılır.
Kural: Yan etkiler yalnızca BlocListener için yazılır çünkü listener, sayfa rebuild olduğunda değil, yalnızca state değiştiğinde 1 kez tetiklenir.
3.2. BlocSelector (Mikro Performans & Pil Tasarrufu)
Kavram: State'in içindeki onlarca alandan sadece 1 tanesini süzüp izlemek. BlocBuilder widget'ı state'in her değişiminde (örneğin 100 alanlı bir state değiştiğinde) ekranı tekrar çizmeye çalışır. BlocSelector ise "Sadece şu 1 alan değişirse ekranı çiz" diyerek gereksiz rebuild'leri engeller. Bu, özellikle pil tüketimini düşürmek için kritik öneme sahiptir.
4. Eşitlik, Değişmezlik ve BLoC Observer
4.1. Equality (Eşitlik) ve Değer Eşitliği
Dart varsayılanı (Referans Eşitliği): İki nesnenin bellekteki RAM adresi aynı mı? Socket('A') == Socket('A') ifadesi false çıkar! İçerikleri aynı olsa da RAM'deki adresleri farklıdır.
Değer Eşitliği (Value Equality): Nesnelerin içindeki veriler aynı mı? equatable paketi tam olarak bunu çözer; nesneleri RAM adresine göre değil, props listesindeki alanların değerlerine göre karşılaştırır.
4.2. props Listesi Yazılmazsa Ne Olur?
BLoC, ekran kartını yormamak için şu denetimi yapar: if (yeniState == eskiState) ekraniCizme();
Eğer siz StationLoaded state'ine yeni bir filterType alanı eklerseniz ama props içine yazmayı unutursanız, BLoC iki state'i eşit zanneder ve ekranı güncellemez; arayüz donuk kalır.
copyWith mantığı: Eski nesnenin alanlarını koruyup sadece istenen alanları değiştirmek için kullanılır.
4.3. BLoC Observer
Kavram: Uygulamadaki tüm BLoC ve Cubit'lerin arkasında çalışan merkezi bir kara kutu telemetri kaydedicisidir.
Ne işe yarar?: Hangi ekranda hangi event fırlatıldı, state nereden nereye geçti (onTransition) ve nerede hata fırlatıldı (onError) tek merkezden konsola loglanır. Kurumsal projelerde analitik ve hata çözme takibi için zorunludur.
Clean Architecture Katmanları & Sorumluluk Duvarları
1. Presentation (Görsel Katman)
İçerik: UI ekranları, butonlar, tıklama, theme, BLoC, Cubit.
Bağımlılık yönü: Presentation, Domain'e bakar; ama Domain, Presentation'a bakmaz.
2. Domain (İş Kuralları - En Kutsal Katman)
İçerik: Entity (saf veri), UseCase (iş kuralları), Repository Interface (sözleşmeler).
Kural: Dış dünyadan (JSON, Dio, SQLite) asla bilgi içermez! Sıfır harici paket importu!
Bağımlılık yönü: Data, sözleşmeyi uygular. Yani Data'dan Domain'e doğru bir ok işareti vardır.
3. Data (Veri Altyapısı)
İçerik: Model/DTO (fromJson, toJson), Remote DataSource (Dio ile API), Local DataSource (Hive / SharedPreferences ile disk), Repository Implementation.
5. Clean Architecture Detayları
5.1. Entity vs Model/DTO
Entity (Varlık): Saf iş nesnesidir. Bir ID, kW, durum tutar. fromJson veya toJson içermez, saf Dart kodundan oluşur ve final'dır.
Model (DTO - Data Transfer Object): API'den gelen ham JSON verisini karşılayan taşıyıcıdır. Entity'den türer. fromJson ve toJson metotlarını barındırır.
Neden Entity içine fromJson yazmıyoruz?: Yarın backend, JSON yerine XML veya Protocol Buffers formatına geçerse, domain katmanındaki iş kurallarımız ve UI sayfalarımız zerre kadar etkilenmesin, sadece data katmanındaki model etkilensin diye!
5.2. UseCase (Kullanım Senaryosu)
Kavram: Kullanıcının veya sistemin gerçekleştirebileceği tek ve atomik bir iş kuralıdır.
Örnekler: StartChargingSessionUseCase, GetStationSocketsUseCase vb.
Kural: Her UseCase sınıfının içinde sadece ve sadece tek bir call() veya execute() fonksiyonu bulunur.
5.3. Repository Contract vs Repository Implementation
Contract: Domain katmanında sadece sözleşmedir (abstract interface class StationRepository). Verinin nereden geleceğini bilmez.
Implementation: Data katmanındadır. Sözleşmeyi uygulayan somut sınıftır (class StationRepositoryImpl implements StationRepository). Verinin önce yerel diskten mi yoksa internetten mi çekileceğine karar verir.
6. Bağımlılık Yönetimi: Dependency Injection & GetIt
6.1. Neden new Dio() Yazmak Yasaktır?
Eğer 5 ayrı sayfada final dio = Dio(); derseniz:
Bellekte 5 ayrı bağlantı havuzu açılır, telefonun soket sınırını zorlar.
Base URL veya timeout değiştiğinde 5 ayrı dosyayı elle değiştirmek zorunda kalırsınız.
Test yazarken sahte/mock veri enjekte edemezsiniz.
6.2. GetIt Kayıt Tipleri: Singleton vs LazySingleton vs Factory
Singleton: Uygulama açıldığı milisaniyede nesneyi üretir ve belleğe çiviler.
LazySingleton: Uygulama açıldığında üretmez; ne zaman ilk kez birisi get<Dio>() derse o an üretir ve sonrasında hep aynı nesneyi verir. Bellek ve açılış hızı dostudur.
Factory: Her çağrıldığında yepyeni, sıfır bir kopya üretir.
7. Kurumsal Ağ Mimarisi: DTO, Interceptor & HTTP Durum Kodları
7.1. Interceptor
Sözlük anlamı: Ağ isteği telefondan çıkıp internete gitmeden veya sunucudan cevap gelip koda düşmeden önce araya girip paket inceleyen/değiştiren güvenlik noktasıdır.
7.2. Bearer Token & Payload
Bearer Token: Bu anahtarı taşıyan kişi giriş yapmaya yetkilidir anlamına gelen şifrelenmiş kimlik kartı metnidir (Authorization: Bearer eyJhb...).
Payload: Bir API isteğiyle sunucuya gönderilen veya sunucudan bize dönen asıl veri gövdesidir.
7.3. HTTP Durum Kodları
200 OK: Başarılı.
201 Created: Yeni kayıt oluşturuldu.
400 Bad Request: Hatalı istek.
401 Unauthorized: Giriş yapılmamış / Yetkisiz.
403 Forbidden: Erişim yasak.
404 Not Found: Bulunamadı.
500 Internal Server Error: Sunucu hatası.
8. Veri Dayanıklılığı: Cache First & Savunmacı Kodlama
8.1. Cache First (Önce Önbellek Stratejisi)
Mantık: Kullanıcı şarj istasyonu listesini açtığında 1 saniye bile beyaz ekranda spinner bekletme! Diskteki dünkü veriyi 0.01 ms'de ekrana bas, arka planda sunucudan taze veriyi çek, gelince ekranı ve diski sessizce güncelle.
8.2. Defensive Programming (Savunmacı Programlama)
Mantık: Sunucudan gelen veriye asla %100 güvenmeme prensibidir. Null güvenlik önlemleri alınarak her senaryoya karşı hazırlıklı olunur.