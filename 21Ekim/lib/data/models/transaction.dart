enum TransactionType { income, expense }

enum IncomeSource { salary, debt_repayment, other }

class Transaction {
  final String id;
  final TransactionType type;
  final int amountMinor;
  final String currency;
  final String categoryId;
  final DateTime occurredAt;
  final String description;
  final String? receiptNote;
  final bool isCharity;
  final bool isAmountHidden;
  final IncomeSource? incomeSource;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amountMinor,
    this.currency = 'TRY',
    required this.categoryId,
    required this.occurredAt,
    required this.description,
    this.receiptNote,
    this.isCharity = false,
    this.isAmountHidden = false,
    this.incomeSource,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  Transaction copyWith({
    String? id,
    TransactionType? type,
    int? amountMinor,
    String? currency,
    String? categoryId,
    DateTime? occurredAt,
    String? description,
    String? receiptNote,
    bool? isCharity,
    bool? isAmountHidden,
    IncomeSource? incomeSource,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      occurredAt: occurredAt ?? this.occurredAt,
      description: description ?? this.description,
      receiptNote: receiptNote ?? this.receiptNote,
      isCharity: isCharity ?? this.isCharity,
      isAmountHidden: isAmountHidden ?? this.isAmountHidden,
      incomeSource: incomeSource ?? this.incomeSource,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amountMinor': amountMinor,
      'currency': currency,
      'categoryId': categoryId,
      'occurredAt': occurredAt.toIso8601String(),
      'description': description,
      'receiptNote': receiptNote,
      'isCharity': isCharity,
      'isAmountHidden': isAmountHidden,
      'incomeSource': incomeSource?.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      amountMinor: json['amountMinor'] as int,
      currency: json['currency'] as String? ?? 'TRY',
      categoryId: json['categoryId'] as String,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      description: json['description'] as String,
      receiptNote: json['receiptNote'] as String?,
      isCharity: json['isCharity'] as bool? ?? false,
      isAmountHidden: json['isAmountHidden'] as bool? ?? false,
      incomeSource: json['incomeSource'] != null
          ? IncomeSource.values.byName(json['incomeSource'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
