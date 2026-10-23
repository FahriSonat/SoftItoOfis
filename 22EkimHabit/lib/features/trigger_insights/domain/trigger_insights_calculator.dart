import 'trigger_event.dart';

class TriggerInsights {
  final Map<String, int> triggerFrequency;
  final Map<int, int> hourlyDistribution; // 0..23 -> count
  final Map<int, int> weekdayDistribution; // 1..7 -> count
  final double averageIntensity;
  final List<SolutionStat> solutionStats;
  final bool hasSufficientData;

  const TriggerInsights({
    required this.triggerFrequency,
    required this.hourlyDistribution,
    required this.weekdayDistribution,
    required this.averageIntensity,
    required this.solutionStats,
    required this.hasSufficientData,
  });

  String? get mostRiskyHourRange {
    if (hourlyDistribution.isEmpty) return null;
    var maxHour = 0;
    var maxCount = 0;
    hourlyDistribution.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        maxHour = hour;
      }
    });
    if (maxCount == 0) return null;
    final nextHour = (maxHour + 2) % 24;
    return '${maxHour.toString().padLeft(2, '0')}:00 - ${nextHour.toString().padLeft(2, '0')}:00';
  }

  String? get mostRiskyWeekdayName {
    if (weekdayDistribution.isEmpty) return null;
    var maxDay = 1;
    var maxCount = 0;
    weekdayDistribution.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        maxDay = day;
      }
    });
    if (maxCount == 0) return null;
    const names = [
      '',
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar',
    ];
    return names[maxDay];
  }

  int get eventsAnalyzed {
    int total = 0;
    hourlyDistribution.forEach((_, count) => total += count);
    return total;
  }

  String? get peakHourWindow => mostRiskyHourRange;
  String? get peakDayName => mostRiskyWeekdayName;

  String? get topTriggerTag {
    if (triggerFrequency.isEmpty) return null;
    String? top;
    int maxCount = 0;
    triggerFrequency.forEach((tag, count) {
      if (count > maxCount) {
        maxCount = count;
        top = tag;
      }
    });
    return top;
  }

  String? get mostEffectiveStrategy {
    final viable = solutionStats.where((s) => s.hasSufficientData).toList();
    if (viable.isEmpty) return null;
    viable.sort(
      (a, b) =>
          b.averageIntensityReduction.compareTo(a.averageIntensityReduction),
    );
    return viable.first.solutionId;
  }
}

class SolutionStat {
  final String solutionId;
  final int usageCount;
  final double averageIntensityReduction;
  final double successRate; // 0.0 .. 1.0 (reduced or unchanged vs lapse)
  final bool hasSufficientData; // >= 3 uses

  const SolutionStat({
    required this.solutionId,
    required this.usageCount,
    required this.averageIntensityReduction,
    required this.successRate,
    required this.hasSufficientData,
  });
}

class TriggerInsightsCalculator {
  const TriggerInsightsCalculator();

  TriggerInsights calculate(List<TriggerEvent> events) {
    if (events.isEmpty) {
      return const TriggerInsights(
        triggerFrequency: {},
        hourlyDistribution: {},
        weekdayDistribution: {},
        averageIntensity: 0.0,
        solutionStats: [],
        hasSufficientData: false,
      );
    }

    final Map<String, int> triggerFreq = {};
    final Map<int, int> hourlyDist = {};
    final Map<int, int> weekdayDist = {};
    int totalIntensity = 0;

    final Map<String, List<TriggerEvent>> solutionEvents = {};

    for (final event in events) {
      totalIntensity += event.intensityBefore;

      // Saat ve gün dağılımı
      final localDt = event.occurredAtUtc.toLocal();
      hourlyDist[localDt.hour] = (hourlyDist[localDt.hour] ?? 0) + 1;
      weekdayDist[localDt.weekday] = (weekdayDist[localDt.weekday] ?? 0) + 1;

      // Tetikleyici etiketleri
      for (final tag in event.triggerTags) {
        triggerFreq[tag] = (triggerFreq[tag] ?? 0) + 1;
      }
      if (event.customTrigger != null && event.customTrigger!.isNotEmpty) {
        triggerFreq[event.customTrigger!] =
            (triggerFreq[event.customTrigger!] ?? 0) + 1;
      }

      // Çözüm istatistiği
      if (event.selectedSolutionId != null) {
        solutionEvents
            .putIfAbsent(event.selectedSolutionId!, () => [])
            .add(event);
      }
    }

    // Çözüm analizleri (en az 3 kullanım kuralı)
    final List<SolutionStat> stats = [];
    solutionEvents.forEach((solId, solList) {
      final count = solList.length;
      final hasSufficient = count >= 3;

      double totalReduction = 0;
      int successCount = 0;

      for (final e in solList) {
        final after = e.intensityAfter ?? e.intensityBefore;
        totalReduction += (e.intensityBefore - after);
        if (e.outcome == TriggerOutcome.reduced ||
            e.outcome == TriggerOutcome.unchanged) {
          successCount++;
        }
      }

      stats.add(
        SolutionStat(
          solutionId: solId,
          usageCount: count,
          averageIntensityReduction: count > 0 ? totalReduction / count : 0.0,
          successRate: count > 0 ? successCount / count : 0.0,
          hasSufficientData: hasSufficient,
        ),
      );
    });

    stats.sort((a, b) {
      if (a.hasSufficientData && !b.hasSufficientData) return -1;
      if (!a.hasSufficientData && b.hasSufficientData) return 1;
      return b.averageIntensityReduction.compareTo(a.averageIntensityReduction);
    });

    return TriggerInsights(
      triggerFrequency: triggerFreq,
      hourlyDistribution: hourlyDist,
      weekdayDistribution: weekdayDist,
      averageIntensity: totalIntensity / events.length,
      solutionStats: stats,
      hasSufficientData: events.length >= 3,
    );
  }
}
