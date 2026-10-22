/// Borç yönü:
/// - lent: Verilen borç (alacak, kullanıcıya geri ödenecek)
/// - borrowed: Alınan borç (yükümlülük, kullanıcının ödeyeceği)
enum DebtDirection { lent, borrowed }

/// Borcun güncel durumu:
/// - open: Henüz hiç ödeme yapılmamış
/// - partial: Kısmi ödeme yapılmış, kalan bakiye var
/// - settled: Tamamen kapanmış / tahsil edilmiş
enum DebtStatus { open, partial, settled }

/// Borç ve alacak takibi veri modeli.
class Debt {
  final String id;
  final DebtDirection direction; // Alacak mı borç mu
  final String counterparty;     // Karşı taraf (Kişi / Kurum adı)
  final int principalMinor;      // Başlangıç anapara tutarı (kuruş)
  final int remainingMinor;      // Kalan borç tutarı (kuruş)
  final String currency;         // Para birimi (TRY, USD, EUR vb.)
  final DateTime? dueDate;       // Vade veya geri ödeme tarihi
  final DebtStatus status;       // Borcun durumu (açık, kısmi, kapandı)
  final String? note;            // Açıklama veya dekont notu

  Debt({
    required this.id,
    required this.direction,
    required this.counterparty,
    required this.principalMinor,
    required this.remainingMinor,
    this.currency = 'TRY',
    this.dueDate,
    this.status = DebtStatus.open,
    this.note,
  });

  /// Verilen borç (alacak) kontrolü
  bool get isLent => direction == DebtDirection.lent;
  /// Alınan borç kontrolü
  bool get isBorrowed => direction == DebtDirection.borrowed;
  /// Borcun tamamen kapatılıp kapatılmadığı kontrolü
  bool get isSettled => status == DebtStatus.settled || remainingMinor <= 0;

  Debt copyWith({
    String? id,
    DebtDirection? direction,
    String? counterparty,
    int? principalMinor,
    int? remainingMinor,
    String? currency,
    DateTime? dueDate,
    DebtStatus? status,
    String? note,
  }) {
    return Debt(
      id: id ?? this.id,
      direction: direction ?? this.direction,
      counterparty: counterparty ?? this.counterparty,
      principalMinor: principalMinor ?? this.principalMinor,
      remainingMinor: remainingMinor ?? this.remainingMinor,
      currency: currency ?? this.currency,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'direction': direction.name,
      'counterparty': counterparty,
      'principalMinor': principalMinor,
      'remainingMinor': remainingMinor,
      'currency': currency,
      'dueDate': dueDate?.toIso8601String(),
      'status': status.name,
      'note': note,
    };
  }

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      id: json['id'] as String,
      direction: DebtDirection.values.byName(json['direction'] as String),
      counterparty: json['counterparty'] as String,
      principalMinor: json['principalMinor'] as int,
      remainingMinor: json['remainingMinor'] as int,
      currency: json['currency'] as String? ?? 'TRY',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      status: DebtStatus.values.byName(json['status'] as String),
      note: json['note'] as String?,
    );
  }
}
