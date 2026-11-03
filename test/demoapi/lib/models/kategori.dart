// sabit sçeneklerden oluşan özel bir veri türüdür
enum Kategori { hepsi, elektronik, taki, erkekGiyim, kadinGiyim }

//enumlara ek özellik kazandıran extension
extension KategoriExtension on Kategori {
  //her kategori için türkçe ad dödndürür ve hangi kategori seçiliyse ona işlem yapılır
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return 'Tümü';

      case Kategori.elektronik:
        return 'Elektronik';

      case Kategori.taki:
        return 'Takı & Mücevher';

      case Kategori.erkekGiyim:
        return 'Erkek Giyim';

      case Kategori.kadinGiyim:
        return 'Kadın Giyim';
    }
  }


//apiden gelen kategori enum değerine dönüştürür static olduğu için sınıf üzerinden çağrılabilir
  static Kategori apiMetnindenUret(String apiMetni) {
    //apiden gelen metni küçük harflere dönüştürür ve eksta gereksiz boşlukları siler 
    //apiden gelenleri enum kategorilerine (uygun olanına) çevirir
    switch (apiMetni.toLowerCase().trim()) {
      case 'electronics':
        return Kategori.elektronik;

      case 'jewelery':
        return Kategori.taki;

      case "men's clothing":
        return Kategori.erkekGiyim;

      case "women's clothing":
        return Kategori.kadinGiyim;
      //hiçbir kategori eşleşmezse  varsaıylan olarak elektronik olur
      default:
        return Kategori.elektronik;
    }
  }
}