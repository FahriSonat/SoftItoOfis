import 'savings_model.dart';
import '../../streaks/domain/streak_period.dart';

class SavingsCalculation {
  final double currentStreakMoneySaved; // TL
  final double totalHistoricalMoneySaved; // TL
  final int currentStreakMinutesSaved; // Dakika
  final int totalHistoricalMinutesSaved; // Dakika

  const SavingsCalculation({
    required this.currentStreakMoneySaved,
    required this.totalHistoricalMoneySaved,
    required this.currentStreakMinutesSaved,
    required this.totalHistoricalMinutesSaved,
  });

  String get activeMoneySavedFormatted =>
      '₺${currentStreakMoneySaved.toStringAsFixed(0)}';
  String get allTimeMoneySavedFormatted =>
      '₺${totalHistoricalMoneySaved.toStringAsFixed(0)}';
  String get activeTimeSavedHoursFormatted =>
      '${(currentStreakMinutesSaved / 60.0).toStringAsFixed(1)} saat';
  String get allTimeTimeSavedHoursFormatted =>
      '${(totalHistoricalMinutesSaved / 60.0).toStringAsFixed(1)} saat';
}

class SavingsCalculator {
  const SavingsCalculator();

  SavingsCalculation calculate({
    required BaselineConsumption baseline,
    required int activeStreakDays,
    required List<StreakPeriod> allPeriods,
  }) {
    double dailyCost = (baseline.costMinorUnits ?? 0) / 100.0;
    double dailyMinutes = (baseline.minutesSpent ?? 0).toDouble();

    if (baseline.period == ConsumptionPeriod.week) {
      dailyCost /= 7.0;
      dailyMinutes /= 7.0;
    } else if (baseline.period == ConsumptionPeriod.month) {
      dailyCost /= 30.0;
      dailyMinutes /= 30.0;
    }

    final currentMoney = activeStreakDays * dailyCost;
    final currentMinutes = (activeStreakDays * dailyMinutes).toInt();

    // Toplam tarihsel gün sayısı (tüm periyotların toplam süresi)
    int totalHistoricalDays = activeStreakDays;
    for (final p in allPeriods) {
      if (p.endedAt != null) {
        final diff = p.endedAt!.difference(p.startedAt).inDays;
        if (diff > 0) {
          totalHistoricalDays += diff;
        }
      }
    }

    final totalMoney = totalHistoricalDays * dailyCost;
    final totalMinutes = (totalHistoricalDays * dailyMinutes).toInt();

    return SavingsCalculation(
      currentStreakMoneySaved: currentMoney,
      totalHistoricalMoneySaved: totalMoney,
      currentStreakMinutesSaved: currentMinutes,
      totalHistoricalMinutesSaved: totalMinutes,
    );
  }
}
