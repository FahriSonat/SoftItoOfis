class WaterTrackingModel {
  final String id;
  final int amountMl;
  final DateTime timestamp;
  final String beverageType;

  const WaterTrackingModel({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.beverageType = 'Su',
  });

  WaterTrackingModel copyWith({
    String? id,
    int? amountMl,
    DateTime? timestamp,
    String? beverageType,
  }) {
    return WaterTrackingModel(
      id: id ?? this.id,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      beverageType: beverageType ?? this.beverageType,
    );
  }

  factory WaterTrackingModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackingModel(
      id: json['id'] as String? ?? '',
      amountMl: json['amountMl'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      beverageType: json['beverageType'] as String? ?? 'Su',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'beverageType': beverageType,
    };
  }
}
