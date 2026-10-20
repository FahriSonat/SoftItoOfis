import 'package:flutter/foundation.dart';

/// [WaterTrackingModel]
/// Günlük su tüketimi verilerini tutan değişmez (immutable) veri modeli.
@immutable
class WaterTrackingModel {
  final int currentWaterMl;
  final int dailyGoalWaterMl;
  final DateTime lastUpdated;

  const WaterTrackingModel({
    this.currentWaterMl = 0,
    this.dailyGoalWaterMl = 2500,
    required this.lastUpdated,
  });

  /// İlerleme yüzdesi (0.0 ile 1.0 arasında)
  double get progress {
    if (dailyGoalWaterMl <= 0) return 0.0;
    return (currentWaterMl / dailyGoalWaterMl).clamp(0.0, 1.0);
  }

  /// Günlük hedefe kalan su miktarı (ml)
  int get remainingWaterMl {
    final remaining = dailyGoalWaterMl - currentWaterMl;
    return remaining > 0 ? remaining : 0;
  }

  /// Hedefe ulaşıldı mı kontrolü
  bool get isGoalReached => currentWaterMl >= dailyGoalWaterMl;

  /// Değişmez kopya üretim fonksiyonu
  WaterTrackingModel copyWith({
    int? currentWaterMl,
    int? dailyGoalWaterMl,
    DateTime? lastUpdated,
  }) {
    return WaterTrackingModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalWaterMl: dailyGoalWaterMl ?? this.dailyGoalWaterMl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory WaterTrackingModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackingModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalWaterMl: json['dailyGoalWaterMl'] as int? ?? 2500,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalWaterMl': dailyGoalWaterMl,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterTrackingModel &&
          runtimeType == other.runtimeType &&
          currentWaterMl == other.currentWaterMl &&
          dailyGoalWaterMl == other.dailyGoalWaterMl &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode =>
      currentWaterMl.hashCode ^ dailyGoalWaterMl.hashCode ^ lastUpdated.hashCode;
}
