import '../../habits/domain/habit.dart';
import '../../habits/domain/habit_entry.dart';
import '../../flexible_goals/domain/goal_levels.dart';
import '../../freeze_mode/domain/freeze_period.dart';
import 'streak_period.dart';

enum StreakUnit { hours, days, periods }

enum StreakStatus {
  active,
  broken,
  pendingToday,
  completedToday,
  frozen,
  inGracePeriod,
}

class StreakResult {
  final int value;
  final StreakUnit unit;
  final StreakStatus status;
  final DateTime? startedAt;
  final DateTime? nextEvaluationAt;
  final String reasonCode;
  final int colorStage;
  final String stageLabel;
  final Duration elapsedDuration;
  final int longestStreak;
  final double currentProgress; // 0.0 - 1.0 (pozitif için bugünkü miktar / hedef)
  final bool isFrozenToday;
  final bool isInGracePeriod;
  final Duration? gracePeriodRemaining;
  final double gracePeriodProgress; // 0.0 - 1.0 (loading bar için)
  final DateTime? graceDeadline;

  const StreakResult({
    required this.value,
    required this.unit,
    required this.status,
    this.startedAt,
    this.nextEvaluationAt,
    required this.reasonCode,
    required this.colorStage,
    required this.stageLabel,
    this.elapsedDuration = Duration.zero,
    this.longestStreak = 0,
    this.currentProgress = 0.0,
    this.isFrozenToday = false,
    this.isInGracePeriod = false,
    this.gracePeriodRemaining,
    this.gracePeriodProgress = 0.0,
    this.graceDeadline,
  });

  String formattedStreak() {
    if (unit == StreakUnit.hours) {
      final hours = elapsedDuration.inHours;
      final minutes = elapsedDuration.inMinutes % 60;
      if (hours == 0) {
        return '$minutes dakika';
      }
      return '$hours saat $minutes dk';
    } else if (unit == StreakUnit.days) {
      return '$value gün';
    } else {
      return '$value periyot';
    }
  }
}

class StreakEngine {
  final NegativeStreakStrategy negativeStrategy;
  final PositiveStreakStrategy positiveStrategy;

  const StreakEngine({
    this.negativeStrategy = const NegativeStreakStrategy(),
    this.positiveStrategy = const PositiveStreakStrategy(),
  });

  StreakResult calculate({
    required Habit habit,
    required List<HabitEntry> entries,
    required List<StreakPeriod> periods,
    required DateTime now,
    GoalLevels? goalLevels,
    List<FreezePeriod>? freezePeriods,
  }) {
    if (habit.kind.isNegative) {
      return negativeStrategy.calculate(
        habit: habit,
        entries: entries,
        periods: periods,
        now: now,
        freezePeriods: freezePeriods,
      );
    } else {
      return positiveStrategy.calculate(
        habit: habit,
        entries: entries,
        periods: periods,
        now: now,
        goalLevels: goalLevels,
        freezePeriods: freezePeriods,
      );
    }
  }
}

/// Negatif Alışkanlıklar için Streak Hesaplama Stratejisi
class NegativeStreakStrategy {
  const NegativeStreakStrategy();

  StreakResult calculate({
    required Habit habit,
    required List<HabitEntry> entries,
    required List<StreakPeriod> periods,
    required DateTime now,
    List<FreezePeriod>? freezePeriods,
  }) {
    // Aktif bir dönem var mı?
    final activePeriod = periods.cast<StreakPeriod?>().firstWhere(
      (p) => p != null && p.isCurrentActive,
      orElse: () => null,
    );

    // Başlangıç tarihi: Aktif dönem varsa onun startedAt'i, yoksa habit.startAt
    final start = activePeriod?.startedAt ?? habit.startAt;

    // Son kırılma (relapse) kaydı var mı?
    final relapses =
        entries.where((e) => e.entryType == EntryType.relapse).toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    final lastRelapse = relapses.isNotEmpty ? relapses.first : null;

    // Eğer son kırılma aktif dönemden sonraysa veya dönem broken ise
    final isBroken =
        (activePeriod?.status == StreakPeriodStatus.broken) ||
        (lastRelapse != null && lastRelapse.occurredAt.isAfter(start));

    final effectiveStart = isBroken
        ? (lastRelapse?.occurredAt ?? start)
        : start;

    Duration elapsed = now.isAfter(effectiveStart)
        ? now.difference(effectiveStart)
        : Duration.zero;

    final days = elapsed.inDays;
    final stage = _calculateNegativeStage(days);
    final stageLabel = _getNegativeStageLabel(stage);

    // En uzun seriyi hesapla
    int longest = days;
    for (final p in periods) {
      if (p.endedAt != null) {
        final periodDays = p.endedAt!.difference(p.startedAt).inDays;
        if (periodDays > longest) {
          longest = periodDays;
        }
      }
    }

    if (isBroken) {
      return StreakResult(
        value: 0,
        unit: StreakUnit.days,
        status: StreakStatus.broken,
        startedAt: effectiveStart,
        reasonCode: 'STREAK_BROKEN',
        colorStage: 0,
        stageLabel: 'Seri Bozuldu',
        elapsedDuration: Duration.zero,
        longestStreak: longest,
        currentProgress: 0.0,
      );
    }

    final unit = days < 1 ? StreakUnit.hours : StreakUnit.days;
    final value = days < 1 ? elapsed.inHours : days;

    return StreakResult(
      value: value,
      unit: unit,
      status: StreakStatus.active,
      startedAt: effectiveStart,
      nextEvaluationAt: effectiveStart.add(Duration(days: days + 1)),
      reasonCode: 'STREAK_ACTIVE',
      colorStage: stage,
      stageLabel: stageLabel,
      elapsedDuration: elapsed,
      longestStreak: longest,
      currentProgress: 1.0,
    );
  }

  static int _calculateNegativeStage(int days) {
    if (days < 1) return 0; // 0-23 saat
    if (days < 3) return 1; // 1-2 gün
    if (days < 7) return 2; // 3-6 gün
    if (days < 14) return 3; // 7-13 gün
    if (days < 30) return 4; // 14-29 gün
    return 5; // 30+ gün
  }

  static String _getNegativeStageLabel(int stage) {
    switch (stage) {
      case 0:
        return 'Başlangıç';
      case 1:
        return 'İlk Adım';
      case 2:
        return 'Dayanıklılık';
      case 3:
        return 'Dönüşüm';
      case 4:
        return 'Güçlenme';
      case 5:
        return 'İstikrar';
      default:
        return 'Başlangıç';
    }
  }
}

/// Pozitif Alışkanlıklar için Streak Hesaplama Stratejisi
class PositiveStreakStrategy {
  const PositiveStreakStrategy();

  StreakResult calculate({
    required Habit habit,
    required List<HabitEntry> entries,
    required List<StreakPeriod> periods,
    required DateTime now,
    GoalLevels? goalLevels,
    List<FreezePeriod>? freezePeriods,
  }) {
    // Girişleri güne göre grupla ve aynı gün içindeki miktarları topla
    final Map<String, double> dailyTotals = {};
    for (final e in entries) {
      if (e.entryType == EntryType.completion) {
        final key = _dayKey(e.occurredAt);
        dailyTotals[key] = (dailyTotals[key] ?? 0.0) + e.value;
      }
    }

    final todayKey = _dayKey(now);
    final todayTotal = dailyTotals[todayKey] ?? 0.0;

    // Hedef değerler (Esnek 3 seviye varsa minimum seriyi kurtarır, normal ana hedeftir)
    final effectiveTarget = goalLevels?.minimumValue ?? habit.targetValue;
    final normalTarget = goalLevels?.normalValue ?? habit.targetValue;

    final isTodayCompleted = todayTotal >= effectiveTarget;
    final todayProgress = normalTarget > 0
        ? (todayTotal / normalTarget).clamp(0.0, 1.0)
        : 0.0;

    final isTodayFrozen =
        freezePeriods?.any((f) => f.containsDate(now)) ?? false;

    // Geriye doğru streak sayımı (başlangıç gününe kadar)
    int streak = 0;
    int longest = 0;
    int tempStreak = 0;

    DateTime checkDate = DateTime(now.year, now.month, now.day);
    final habitStart = DateTime(
      habit.startAt.year,
      habit.startAt.month,
      habit.startAt.day,
    );

    if (isTodayCompleted && !isTodayFrozen) {
      streak++;
    }

    checkDate = checkDate.subtract(const Duration(days: 1));
    bool streakChainActive = true;

    while (!checkDate.isBefore(habitStart)) {
      final key = _dayKey(checkDate);

      // 1. Dondurma kontrolü (Section 13.2: Dondurulan gün seriyi ne bozar ne artırır)
      final isFrozen =
          freezePeriods?.any((f) => f.containsDate(checkDate)) ?? false;
      if (isFrozen) {
        checkDate = checkDate.subtract(const Duration(days: 1));
        continue;
      }

      // 2. Planlı gün kontrolü
      final isScheduled = _isDayScheduled(habit, checkDate);
      if (!isScheduled) {
        checkDate = checkDate.subtract(const Duration(days: 1));
        continue;
      }

      final dayTotal = dailyTotals[key] ?? 0.0;
      final completed = dayTotal >= effectiveTarget;

      if (completed) {
        if (streakChainActive) {
          streak++;
        }
        tempStreak++;
        if (tempStreak > longest) {
          longest = tempStreak;
        }
      } else {
        streakChainActive = false;
        tempStreak = 0;
      }

      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    if (streak > longest) {
      longest = streak;
    }

    // Grace Period (Kurtarma Süresi: 24 saat içinde giriş yapılmazsa ekstra 24 saat süre)
    bool isInGracePeriod = false;
    Duration? graceRemaining;
    double graceProgress = 0.0;
    DateTime? graceDeadline;
    StreakStatus finalStatus;
    int finalValue = streak;
    int finalStage;
    String finalStageLabel;
    String finalReasonCode;

    if (isTodayFrozen) {
      finalStatus = StreakStatus.frozen;
      finalReasonCode = 'TODAY_FROZEN';
      finalStage = _calculatePositiveStage(streak);
      finalStageLabel = _getPositiveStageLabel(finalStage);
    } else if (isTodayCompleted) {
      finalStatus = StreakStatus.completedToday;
      finalReasonCode = 'TODAY_COMPLETED';
      finalStage = _calculatePositiveStage(streak);
      finalStageLabel = _getPositiveStageLabel(finalStage);
    } else {
      // Bugün henüz giriş yapılmadı. Dünden geriye doğru kaç gün kaçırıldığını bul:
      int consecutiveMissedDays = 0;
      int priorStreak = 0;
      DateTime checkBack = DateTime(now.year, now.month, now.day - 1);
      bool countingMissed = true;

      while (!checkBack.isBefore(habitStart)) {
        final isFrozen =
            freezePeriods?.any((f) => f.containsDate(checkBack)) ?? false;
        if (isFrozen) {
          checkBack = checkBack.subtract(const Duration(days: 1));
          continue;
        }
        if (!_isDayScheduled(habit, checkBack)) {
          checkBack = checkBack.subtract(const Duration(days: 1));
          continue;
        }

        final dayTotal = dailyTotals[_dayKey(checkBack)] ?? 0.0;
        final completed = dayTotal >= effectiveTarget;

        if (countingMissed) {
          if (!completed) {
            consecutiveMissedDays++;
          } else {
            countingMissed = false;
            priorStreak++;
          }
        } else {
          if (completed) {
            priorStreak++;
          } else {
            break;
          }
        }
        checkBack = checkBack.subtract(const Duration(days: 1));
      }

      if (consecutiveMissedDays == 0) {
        // Dün tamamlanmış, bugün normal 24 saatlik süre içindeyiz
        finalStatus = StreakStatus.pendingToday;
        finalReasonCode = 'TODAY_PENDING';
        finalStage = _calculatePositiveStage(streak);
        finalStageLabel = _getPositiveStageLabel(finalStage);
      } else if (consecutiveMissedDays == 1 && priorStreak > 0) {
        // 24 saat içinde giriş yapılmadı (dün kaçırıldı), ekstra 24 saat kurtarma süresi verilir!
        final deadline = DateTime(now.year, now.month, now.day, 23, 59, 59);
        graceDeadline = deadline;
        if (now.isBefore(deadline)) {
          isInGracePeriod = true;
          finalStatus = StreakStatus.inGracePeriod;
          finalValue = priorStreak;
          graceRemaining = deadline.difference(now);
          graceProgress =
              (graceRemaining.inSeconds / (24 * 3600)).clamp(0.0, 1.0);
          finalStage = _calculatePositiveStage(priorStreak);
          finalStageLabel = 'Kurtarma Süresi';
          finalReasonCode = 'IN_GRACE_PERIOD';
        } else {
          finalStatus = StreakStatus.broken;
          finalValue = 0;
          finalStage = 0;
          finalStageLabel = 'Zincir Kırıldı';
          finalReasonCode = 'GRACE_PERIOD_EXPIRED';
        }
      } else if (consecutiveMissedDays >= 2 && priorStreak > 0) {
        // Ekstra 24 saatlik sürede de giriş yapılmadı -> ZİNCİR KIRILDI!
        finalStatus = StreakStatus.broken;
        finalValue = 0;
        finalStage = 0;
        finalStageLabel = 'Zincir Kırıldı';
        finalReasonCode = 'GRACE_PERIOD_EXPIRED';
      } else {
        // Önceden de zincir yoktu
        finalStatus = StreakStatus.pendingToday;
        finalReasonCode = 'TODAY_PENDING';
        finalStage = 0;
        finalStageLabel = _getPositiveStageLabel(0);
      }
    }

    return StreakResult(
      value: finalValue,
      unit: StreakUnit.periods,
      status: finalStatus,
      startedAt: habit.startAt,
      nextEvaluationAt: DateTime(now.year, now.month, now.day + 1),
      reasonCode: finalReasonCode,
      colorStage: finalStage,
      stageLabel: finalStageLabel,
      longestStreak: longest,
      currentProgress: todayProgress,
      isFrozenToday: isTodayFrozen,
      isInGracePeriod: isInGracePeriod,
      gracePeriodRemaining: graceRemaining,
      gracePeriodProgress: graceProgress,
      graceDeadline: graceDeadline,
    );
  }

  static bool _isDayScheduled(Habit habit, DateTime date) {
    if (habit.scheduleType == ScheduleType.daily) {
      return true;
    }
    if (habit.scheduleType == ScheduleType.selectedDays) {
      return habit.scheduleDays.contains(date.weekday);
    }
    return true;
  }

  static int _calculatePositiveStage(int periods) {
    if (periods < 3) return 0; // 0-2 periyot
    if (periods < 7) return 1; // 3-6 periyot
    if (periods < 14) return 2; // 7-13 periyot
    if (periods < 30) return 3; // 14-29 periyot
    return 4; // 30+ periyot
  }

  static String _getPositiveStageLabel(int stage) {
    switch (stage) {
      case 0:
        return 'Başlangıç';
      case 1:
        return 'Ritim';
      case 2:
        return 'Akış';
      case 3:
        return 'Devamlılık';
      case 4:
        return 'İstikrar';
      default:
        return 'Başlangıç';
    }
  }

  static String _dayKey(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
