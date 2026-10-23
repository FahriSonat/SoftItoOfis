class SpecialistReportData {
  final String dateRange;
  final List<String> habitNames;
  final int totalPositiveCompletions;
  final int totalNegativeLapses;
  final Map<String, int> topTriggers;
  final String disclaimer;

  const SpecialistReportData({
    required this.dateRange,
    required this.habitNames,
    required this.totalPositiveCompletions,
    required this.totalNegativeLapses,
    required this.topTriggers,
    this.disclaimer = 'Bu belge bir tıbbi teşhis veya tedavi planı değildir; yalnızca kullanıcının kişisel öz-takip verilerini içerir.',
  });

  String toFormattedText() {
    final buffer = StringBuffer();
    buffer.writeln('=== DENGE UYGULAMASI ALIŞKANLIK VE DÖNÜŞÜM RAPORU ===');
    buffer.writeln('Tarih Aralığı: $dateRange');
    buffer.writeln('İncelenen Alışkanlıklar: ${habitNames.join(", ")}');
    buffer.writeln('Tamamlanan Pozitif Periyotlar: $totalPositiveCompletions');
    buffer.writeln('Kayma / Kırılma Sayısı: $totalNegativeLapses');
    buffer.writeln('\nEn Sık Karşılaşılan Tetikleyiciler:');
    topTriggers.forEach((tag, count) {
      buffer.writeln(' - $tag: $count kez');
    });
    buffer.writeln('\nUYARI: $disclaimer');
    return buffer.toString();
  }
}
