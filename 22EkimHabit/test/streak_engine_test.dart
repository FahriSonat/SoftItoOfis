import 'package:flutter_test/flutter_test.dart';
import 'package:denge/features/habits/domain/habit.dart';
import 'package:denge/features/habits/domain/habit_entry.dart';
import 'package:denge/features/streaks/domain/streak_period.dart';
import 'package:denge/features/streaks/domain/streak_engine.dart';

void main() {
  group('StreakEngine Unit Tests', () {
    late StreakEngine engine;
    late Habit positiveHabit;
    late Habit negativeHabit;

    setUp(() {
      engine = StreakEngine();

      positiveHabit = Habit(
        id: 'h_pos',
        userId: 'u1',
        name: 'Su İçme',
        kind: HabitKind.positive,
        category: HabitCategory.water,
        iconKey: 'water_drop',
        startAt: DateTime(2026, 10, 1),
        measurementType: MeasurementType.volumeMl,
        targetValue: 2000,
        unit: 'ml',
        scheduleType: ScheduleType.daily,
        createdAt: DateTime(2026, 10, 1),
        updatedAt: DateTime(2026, 10, 1),
      );

      negativeHabit = Habit(
        id: 'h_neg',
        userId: 'u1',
        name: 'Sigarayı Bırakma',
        kind: HabitKind.negative,
        category: HabitCategory.smoking,
        iconKey: 'smoke_free',
        startAt: DateTime(2026, 10, 20, 10, 0),
        unitCost: 75.0,
        createdAt: DateTime(2026, 10, 20),
        updatedAt: DateTime(2026, 10, 20),
      );
    });

    test('1. Üç ardışık günlük tamamlama pozitif seriyi 3 yapar', () {
      final now = DateTime(2026, 10, 23, 14, 0);
      final entries = [
        HabitEntry(
          id: 'e1',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 2000,
          occurredAt: DateTime(2026, 10, 21, 12, 0),
          createdAt: DateTime(2026, 10, 21),
          updatedAt: DateTime(2026, 10, 21),
        ),
        HabitEntry(
          id: 'e2',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 2000,
          occurredAt: DateTime(2026, 10, 22, 12, 0),
          createdAt: DateTime(2026, 10, 22),
          updatedAt: DateTime(2026, 10, 22),
        ),
        HabitEntry(
          id: 'e3',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 2000,
          occurredAt: DateTime(2026, 10, 23, 10, 0),
          createdAt: DateTime(2026, 10, 23),
          updatedAt: DateTime(2026, 10, 23),
        ),
      ];

      final result = engine.calculate(
        habit: positiveHabit,
        entries: entries,
        periods: [],
        now: now,
      );

      expect(result.value, equals(3));
      expect(result.status, equals(StreakStatus.completedToday));
      expect(result.colorStage, equals(1)); // 3-6 periyot = Aşama 1 (Ritim)
      expect(result.stageLabel, equals('Ritim'));
    });

    test(
      '2. Bir günlük kaçırma pozitif seriyi kırar ve bugüne göre hesaplar',
      () {
        final now = DateTime(2026, 10, 23, 14, 0);
        // 21'de yapıldı, 22'de kaçırıldı, 23'te yapıldı
        final entries = [
          HabitEntry(
            id: 'e1',
            habitId: positiveHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 21, 12, 0),
            createdAt: DateTime(2026, 10, 21),
            updatedAt: DateTime(2026, 10, 21),
          ),
          // 22 Ekim boş!
          HabitEntry(
            id: 'e3',
            habitId: positiveHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 23, 10, 0),
            createdAt: DateTime(2026, 10, 23),
            updatedAt: DateTime(2026, 10, 23),
          ),
        ];

        final result = engine.calculate(
          habit: positiveHabit,
          entries: entries,
          periods: [],
          now: now,
        );

        // 22'si kaçırıldığı için önceki zincir koptu, bugünküyle seri 1 oldu
        expect(result.value, equals(1));
        expect(result.longestStreak, equals(1));
      },
    );

    test(
      '3. Seçili günler arasında plansız gün seriyi bozmaz veya artırmaz',
      () {
        // Sadece Pazartesi (1), Çarşamba (3), Cuma (5) günleri planlı
        final selectedDaysHabit = positiveHabit.copyWith(
          scheduleType: ScheduleType.selectedDays,
          scheduleDays: [1, 3, 5],
        );

        // 2026-10-19: Pazartesi (yapıldı)
        // 2026-10-20: Salı (plansız gün)
        // 2026-10-21: Çarşamba (yapıldı)
        final now = DateTime(2026, 10, 21, 18, 0);
        final entries = [
          HabitEntry(
            id: 'e1',
            habitId: selectedDaysHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 19, 12, 0),
            createdAt: DateTime(2026, 10, 19),
            updatedAt: DateTime(2026, 10, 19),
          ),
          HabitEntry(
            id: 'e2',
            habitId: selectedDaysHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 21, 12, 0),
            createdAt: DateTime(2026, 10, 21),
            updatedAt: DateTime(2026, 10, 21),
          ),
        ];

        final result = engine.calculate(
          habit: selectedDaysHabit,
          entries: entries,
          periods: [],
          now: now,
        );

        // Salı günü plansız olduğu için seri bozulmadı, 2 periyot oldu!
        expect(result.value, equals(2));
      },
    );

    test('4. Aynı gün içindeki birden fazla miktar kaydı toplanır', () {
      final now = DateTime(2026, 10, 23, 18, 0);
      // Hedef 2000 ml. Sabah 500, öğlen 1000, akşam 500 eklendi
      final entries = [
        HabitEntry(
          id: 'e1',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 500,
          occurredAt: DateTime(2026, 10, 23, 9, 0),
          createdAt: DateTime(2026, 10, 23),
          updatedAt: DateTime(2026, 10, 23),
        ),
        HabitEntry(
          id: 'e2',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 1000,
          occurredAt: DateTime(2026, 10, 23, 13, 0),
          createdAt: DateTime(2026, 10, 23),
          updatedAt: DateTime(2026, 10, 23),
        ),
        HabitEntry(
          id: 'e3',
          habitId: positiveHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 500,
          occurredAt: DateTime(2026, 10, 23, 17, 0),
          createdAt: DateTime(2026, 10, 23),
          updatedAt: DateTime(2026, 10, 23),
        ),
      ];

      final result = engine.calculate(
        habit: positiveHabit,
        entries: entries,
        periods: [],
        now: now,
      );

      expect(result.status, equals(StreakStatus.completedToday));
      expect(result.currentProgress, equals(1.0));
      expect(result.value, equals(1));
    });

    test('5. Negatif seride gerçek zaman farkı saat ve güne doğru dönüşür', () {
      // 20 Ekim 10:00'da başladı
      // 20 Ekim 23:59 (13 saat)
      final atNight = DateTime(2026, 10, 20, 23, 59);
      final nightResult = engine.calculate(
        habit: negativeHabit,
        entries: [],
        periods: [],
        now: atNight,
      );

      expect(nightResult.unit, equals(StreakUnit.hours));
      expect(nightResult.value, equals(13));
      expect(
        nightResult.colorStage,
        equals(0),
      ); // 0-23 saat: Aşama 0 (Başlangıç)

      // 23 Ekim 10:00 (Tam 3 gün)
      final after3Days = DateTime(2026, 10, 23, 10, 0);
      final dayResult = engine.calculate(
        habit: negativeHabit,
        entries: [],
        periods: [],
        now: after3Days,
      );

      expect(dayResult.unit, equals(StreakUnit.days));
      expect(dayResult.value, equals(3));
      expect(
        dayResult.colorStage,
        equals(2),
      ); // 3-6 gün: Aşama 2 (Dayanıklılık)
    });

    test('6. Negatif seride kırılma (relapse) eski seriyi korur ve durumu broken yapar', () {
      final now = DateTime(2026, 10, 23, 14, 0);
      final periods = [
        StreakPeriod(
          id: 'p1',
          habitId: negativeHabit.id,
          startedAt: DateTime(2026, 10, 1),
          endedAt: DateTime(2026, 10, 15),
          status: StreakPeriodStatus.broken,
          successfulPeriods: 14,
        ),
        StreakPeriod(
          id: 'p2',
          habitId: negativeHabit.id,
          startedAt: DateTime(2026, 10, 15),
          status: StreakPeriodStatus.broken,
        ),
      ];

      final entries = [
        HabitEntry(
          id: 'r1',
          habitId: negativeHabit.id,
          userId: 'u1',
          entryType: EntryType.relapse,
          value: 1,
          occurredAt: DateTime(2026, 10, 23, 12, 0),
          createdAt: DateTime(2026, 10, 23),
          updatedAt: DateTime(2026, 10, 23),
        ),
      ];

      final result = engine.calculate(
        habit: negativeHabit,
        entries: entries,
        periods: periods,
        now: now,
      );

      expect(result.status, equals(StreakStatus.broken));
      expect(result.value, equals(0));
      // Önceki 14 günlük seri korunmuş olmalı
      expect(result.longestStreak, equals(14));
      expect(result.stageLabel, equals('Seri Bozuldu'));
    });

    test('7. Ay ve Yıl geçişlerinde süre kesintisiz hesaplanır', () {
      final newYearHabit = negativeHabit.copyWith(
        startAt: DateTime(2026, 12, 30, 0, 0),
      );
      final nowInNewYear = DateTime(2027, 1, 2, 0, 0);

      final result = engine.calculate(
        habit: newYearHabit,
        entries: [],
        periods: [],
        now: nowInNewYear,
      );

      expect(result.unit, equals(StreakUnit.days));
      expect(result.value, equals(3));
    });

    test(
      '8. 24 saat içinde giriş yapılmazsa ekstra 24 saat kurtarma süresi ve loading bar verileri sağlanır',
      () {
        // 21 Ekim tamamlandı (seri 1), 22 Ekim kaçırıldı (24 saat geçti)
        // 23 Ekim saat 14:00 (ekstra 24 saatlik kurtarma süresi içinde)
        final now = DateTime(2026, 10, 23, 14, 0);
        final entries = [
          HabitEntry(
            id: 'e1',
            habitId: positiveHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 21, 12, 0),
            createdAt: DateTime(2026, 10, 21),
            updatedAt: DateTime(2026, 10, 21),
          ),
        ];

        final result = engine.calculate(
          habit: positiveHabit,
          entries: entries,
          periods: [],
          now: now,
        );

        // Henüz kırılmadı! Ekstra 24 saatlik kurtarma süresinde
        expect(result.status, equals(StreakStatus.inGracePeriod));
        expect(result.isInGracePeriod, isTrue);
        expect(result.value, equals(1)); // Önceki seri korundu
        expect(result.gracePeriodRemaining, isNotNull);
        expect(result.gracePeriodRemaining!.inHours, greaterThan(0));
        expect(result.gracePeriodProgress, greaterThan(0.0));
      },
    );

    test(
      '9. Ekstra 24 saatlik sürede de giriş yapılmazsa zincir kırılır (broken, değer 0)',
      () {
        // 21 Ekim tamamlandı, 22 ve 23 Ekim kaçırıldı (> 48 saat geçti)
        // 24 Ekim saat 10:00 (ekstra 24 saat süresi de doldu)
        final now = DateTime(2026, 10, 24, 10, 0);
        final entries = [
          HabitEntry(
            id: 'e1',
            habitId: positiveHabit.id,
            userId: 'u1',
            entryType: EntryType.completion,
            value: 2000,
            occurredAt: DateTime(2026, 10, 21, 12, 0),
            createdAt: DateTime(2026, 10, 21),
            updatedAt: DateTime(2026, 10, 21),
          ),
        ];

        final result = engine.calculate(
          habit: positiveHabit,
          entries: entries,
          periods: [],
          now: now,
        );

        // Ek süre de dolduğu için zincir kırıldı!
        expect(result.status, equals(StreakStatus.broken));
        expect(result.value, equals(0));
        expect(result.stageLabel, equals('Zincir Kırıldı'));
      },
    );
  });
}
