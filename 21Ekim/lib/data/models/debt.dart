enum DebtDirection { lent, borrowed }

enum DebtStatus { open, partial, settled }

class Debt {
  final String id;
  final DebtDirection direction;
  final String counterparty;
  final int principalMinor;
  final int remainingMinor;
  final String currency;
  final DateTime? dueDate;
  final DebtStatus status;
  final String? note;

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

  bool get isLent => direction == DebtDirection.lent;
  bool get isBorrowed => direction == DebtDirection.borrowed;
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
