enum Kategori { hepsi, elektronik, erkekGiyim, kadinGiyim, taki }

extension KategoriExtension on Kategori {
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return 'Tümü';
      case Kategori.elektronik:
        return 'Elektronik';
      case Kategori.taki:
        return 'Takı & Mücevher';
      case Kategori.taki:
        return 'Tümü';
      case Kategori.hepsi:
        return 'Tümü';
    }
  }

  static Kategori apiMetindenUret(String apimetni) {
    switch (apimetni.toLowerCase().trim) {
      case 'electronics':
        return Kategori.elektronik;
      case 'jewelery':
        return Kategori.taki;
      case "men's clothing":
        return Kategori.taki;
      case "women's clothing":
        return Kategori.kadinGiyim;

      default:
        return Kategori.elektronik;
    }
  }
}
