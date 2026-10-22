/// Düzenli ödeme tekrarlanma sıklığı (Günlük, Haftalık, Aylık)
enum RecurringCadence { daily, weekly, monthly }

/// Düzenli fatura, kira veya abonelik gibi tekrarlayan ödemelerin veri modeli.
class RecurringPayment {
  final String id;
  final String title;               // Fatura/Ödeme başlığı (örn. 'Ev Kirası', 'Elektrik')
  final int? expectedAmountMinor;   // Tahmini beklenen tutar (kuruş), null ise değişken fatura
  final String currency;            // Para birimi (TRY vb.)
  final RecurringCadence cadence;   // Tekrar sıklığı
  final DateTime dueDate;           // Bu dönemki son ödeme / vade tarihi
  final String? categoryId;         // İlişkili gider kategorisi
  final bool isPaidThisPeriod;      // Bu dönem ödendi mi?

  RecurringPayment({
    required this.id,
    required this.title,
    this.expectedAmountMinor,
    this.currency = 'TRY',
    required this.cadence,
    required this.dueDate,
    this.categoryId,
    this.isPaidThisPeriod = false,
  });

  RecurringPayment copyWith({
    String? id,
    String? title,
    int? expectedAmountMinor,
    String? currency,
    RecurringCadence? cadence,
    DateTime? dueDate,
    String? categoryId,
    bool? isPaidThisPeriod,
  }) {
    return RecurringPayment(
      id: id ?? this.id,
      title: title ?? this.title,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      currency: currency ?? this.currency,
      cadence: cadence ?? this.cadence,
      dueDate: dueDate ?? this.dueDate,
      categoryId: categoryId ?? this.categoryId,
      isPaidThisPeriod: isPaidThisPeriod ?? this.isPaidThisPeriod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'expectedAmountMinor': expectedAmountMinor,
      'currency': currency,
      'cadence': cadence.name,
      'dueDate': dueDate.toIso8601String(),
      'categoryId': categoryId,
      'isPaidThisPeriod': isPaidThisPeriod,
    };
  }

  factory RecurringPayment.fromJson(Map<String, dynamic> json) {
    return RecurringPayment(
      id: json['id'] as String,
      title: json['title'] as String,
      expectedAmountMinor: json['expectedAmountMinor'] as int?,
      currency: json['currency'] as String? ?? 'TRY',
      cadence: RecurringCadence.values.byName(json['cadence'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      categoryId: json['categoryId'] as String?,
      isPaidThisPeriod: json['isPaidThisPeriod'] as bool? ?? false,
    );
  }
}
