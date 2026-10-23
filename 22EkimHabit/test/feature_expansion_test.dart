import 'package:flutter_test/flutter_test.dart';

import 'package:denge/core/database/local_storage.dart';
import 'package:denge/features/habits/domain/habit.dart';
import 'package:denge/features/habits/domain/habit_entry.dart';
import 'package:denge/features/habits/data/habit_repository.dart';
import 'package:denge/features/streaks/domain/streak_engine.dart';
import 'package:denge/features/streaks/domain/streak_period.dart';
import 'package:denge/features/trigger_insights/domain/trigger_event.dart';
import 'package:denge/features/trigger_insights/domain/trigger_insights_calculator.dart';
import 'package:denge/features/support_mode/domain/support_session.dart';
import 'package:denge/features/motivation/domain/personal_motivation.dart';
import 'package:denge/features/support_contacts/domain/support_contact.dart';
import 'package:denge/features/flexible_goals/domain/goal_levels.dart';
import 'package:denge/features/freeze_mode/domain/freeze_period.dart';
import 'package:denge/features/mood_checkin/domain/mood_checkin.dart';
import 'package:denge/features/savings/domain/savings_model.dart';
import 'package:denge/features/savings/domain/savings_calculator.dart';
import 'package:denge/features/growth/domain/visual_growth.dart';
import 'package:denge/features/privacy_lock/domain/security_settings.dart';
import 'package:denge/features/export_backup/domain/export_backup_service.dart';
import 'package:denge/features/routines/domain/routine.dart';
import 'package:denge/features/health_integration/domain/health_adapter.dart';

void main() {
  group('Phase 1: Behavior Support & Pattern Insights', () {
    test('TriggerInsightsCalculator aggregates events and requires >= 3 uses for solution stats', () {
      const calc = TriggerInsightsCalculator();
      final now = DateTime.utc(2026, 10, 20, 14, 30); // Tuesday 14:30

      final List<TriggerEvent> events = [
        TriggerEvent(
          id: '1',
          habitId: 'h1',
          occurredAtUtc: now,
          localDate: '2026-10-20',
          intensityBefore: 4,
          intensityAfter: 2,
          triggerTags: const ['stres', 'yorgunluk'],
          selectedSolutionId: 'nefes_egzersizi',
          createdAtUtc: now,
          updatedAtUtc: now,
        ),
        TriggerEvent(
          id: '2',
          habitId: 'h1',
          occurredAtUtc: now.add(const Duration(hours: 1)), // Tuesday 15:30
          localDate: '2026-10-20',
          intensityBefore: 5,
          intensityAfter: 2,
          triggerTags: const ['stres'],
          selectedSolutionId: 'nefes_egzersizi',
          createdAtUtc: now,
          updatedAtUtc: now,
        ),
        TriggerEvent(
          id: '3',
          habitId: 'h1',
          occurredAtUtc: now.add(const Duration(days: 1)), // Wednesday 14:30
          localDate: '2026-10-21',
          intensityBefore: 3,
          intensityAfter: 1,
          triggerTags: const ['can_sikintisi'],
          selectedSolutionId: 'nefes_egzersizi',
          createdAtUtc: now,
          updatedAtUtc: now,
        ),
        TriggerEvent(
          id: '4',
          habitId: 'h1',
          occurredAtUtc: now.add(const Duration(days: 2)), // Thursday 14:30
          localDate: '2026-10-22',
          intensityBefore: 4,
          intensityAfter: 3,
          triggerTags: const ['stres'],
          selectedSolutionId: 'yuruyus', // Only used once
          createdAtUtc: now,
          updatedAtUtc: now,
        ),
      ];

      final insights = calc.calculate(events);

      expect(insights.hasSufficientData, isTrue);
      expect(insights.eventsAnalyzed, equals(4));
      expect(insights.topTriggerTag, equals('stres'));
      expect(insights.triggerFrequency['stres'], equals(3));
      expect(insights.triggerFrequency['can_sikintisi'], equals(1));

      // Nefes egzersizi used 3 times -> hasSufficientData is true
      final nefesStat = insights.solutionStats.firstWhere(
        (s) => s.solutionId == 'nefes_egzersizi',
      );
      expect(nefesStat.usageCount, equals(3));
      expect(nefesStat.hasSufficientData, isTrue);
      expect(nefesStat.averageIntensityReduction, closeTo(2.33, 0.05));

      // Yuruyus used only 1 time -> hasSufficientData is false (< 3 threshold)
      final yuruyusStat = insights.solutionStats.firstWhere(
        (s) => s.solutionId == 'yuruyus',
      );
      expect(yuruyusStat.usageCount, equals(1));
      expect(yuruyusStat.hasSufficientData, isFalse);

      expect(insights.mostEffectiveStrategy, equals('nefes_egzersizi'));
    });

    test(
      'SupportSession records and serializes urge support session accurately',
      () {
        final session = SupportSession(
          id: 'sess-1',
          habitId: 'h-neg-1',
          startedAtUtc: DateTime.utc(2026, 10, 21, 10, 0),
          completedAtUtc: DateTime.utc(2026, 10, 21, 10, 5),
          intensityBefore: 5,
          intensityAfter: 2,
          selectedSolutionId: '4-7-8 Nefes Egzersizi',
          outcome: SupportOutcome.reduced,
        );

        final json = session.toJson();
        final roundTrip = SupportSession.fromJson(json);

        expect(roundTrip.id, equals('sess-1'));
        expect(roundTrip.intensityBefore, equals(5));
        expect(roundTrip.intensityAfter, equals(2));
        expect(roundTrip.outcome, equals(SupportOutcome.reduced));
        expect(roundTrip.selectedSolutionId, equals('4-7-8 Nefes Egzersizi'));
      },
    );

    test(
      'PersonalMotivation and SupportContact models serialize correctly',
      () {
        final motivation = PersonalMotivation(
          id: 'm1',
          habitId: 'h1',
          shortReason: 'Daha sağlıklı bir kalp için',
          letterToSelf: 'Zorlandığında ilk günkü heyecanını hatırla.',
          futureMessage: '1 yıl sonraki kendime selam!',
          updatedAtUtc: DateTime.utc(2026, 10, 1),
        );
        final mJson = motivation.toJson();
        final mRestored = PersonalMotivation.fromJson(mJson);
        expect(mRestored.shortReason, equals('Daha sağlıklı bir kalp için'));
        expect(mRestored.futureMessage, equals('1 yıl sonraki kendime selam!'));

        final contact = SupportContact(
          id: 'c1',
          displayName: 'Dr. Ahmet Yılmaz',
          phoneNumber: '+905551234567',
          preferredChannel: PreferredChannel.call,
          linkedHabitIds: const ['h1'],
          createdAtUtc: DateTime.utc(2026, 10, 1),
          updatedAtUtc: DateTime.utc(2026, 10, 1),
        );
        final cJson = contact.toJson();
        final cRestored = SupportContact.fromJson(cJson);
        expect(cRestored.displayName, equals('Dr. Ahmet Yılmaz'));
        expect(cRestored.preferredChannel, equals(PreferredChannel.call));
        expect(cRestored.linkedHabitIds, contains('h1'));
      },
    );
  });

  group('Phase 2: Sustainable Goals & Freeze Engine', () {
    final baseHabit = Habit(
      id: 'h-pos-flex',
      userId: 'u1',
      name: 'Kitap Okuma',
      kind: HabitKind.positive,
      category: HabitCategory.reading,
      iconKey: 'menu_book',
      scheduleType: ScheduleType.daily,
      targetValue: 20.0,
      unit: 'sayfa',
      startAt: DateTime(2026, 10, 1),
      createdAt: DateTime(2026, 10, 1),
      updatedAt: DateTime(2026, 10, 1),
    );

    test('Flexible 3-tier goals: reaching minimumValue preserves streak even if below targetValue', () {
      const engine = StreakEngine();
      final now = DateTime(2026, 10, 3, 20, 0);

      const goalLevels = GoalLevels(
        habitId: 'h-pos-flex',
        minimumValue: 5.0,
        normalValue: 20.0,
        strongDayValue: 40.0,
      );

      final entries = [
        HabitEntry(
          id: 'e1',
          habitId: baseHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 20.0, // Met target
          occurredAt: DateTime(2026, 10, 1, 15, 0),
          createdAt: DateTime(2026, 10, 1),
          updatedAt: DateTime(2026, 10, 1),
        ),
        HabitEntry(
          id: 'e2',
          habitId: baseHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 6.0, // Only reached minimum (5.0 <= 6.0 < 20.0) -> streak must be preserved!
          occurredAt: DateTime(2026, 10, 2, 18, 0),
          createdAt: DateTime(2026, 10, 2),
          updatedAt: DateTime(2026, 10, 2),
        ),
        HabitEntry(
          id: 'e3',
          habitId: baseHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 10.0, // Again reached minimum on day 3
          occurredAt: DateTime(2026, 10, 3, 10, 0),
          createdAt: DateTime(2026, 10, 3),
          updatedAt: DateTime(2026, 10, 3),
        ),
      ];

      final result = engine.calculate(
        habit: baseHabit,
        entries: entries,
        periods: [],
        now: now,
        goalLevels: goalLevels,
      );

      expect(result.value, equals(3));
      expect(result.status, equals(StreakStatus.completedToday));
    });

    test('Freeze Mode: days inside FreezePeriod do not break streak', () {
      const engine = StreakEngine();
      final now = DateTime(2026, 10, 4, 12, 0);

      // October 2 is frozen (e.g. sick / travelling)
      final freezePeriods = [
        FreezePeriod(
          id: 'f1',
          habitId: baseHabit.id,
          startsOnLocalDate: DateTime(2026, 10, 2),
          endsOnLocalDate: DateTime(2026, 10, 2),
          reasonType: FreezeReason.illness,
          reasonNote: 'Grip oldum, dondurma hakkı kullandım',
          createdAtUtc: DateTime.utc(2026, 10, 2),
        ),
      ];

      final entries = [
        HabitEntry(
          id: 'e1',
          habitId: baseHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 20.0,
          occurredAt: DateTime(2026, 10, 1, 10, 0),
          createdAt: DateTime(2026, 10, 1),
          updatedAt: DateTime(2026, 10, 1),
        ),
        // October 2 has NO entries, but is in freezePeriods!
        HabitEntry(
          id: 'e3',
          habitId: baseHabit.id,
          userId: 'u1',
          entryType: EntryType.completion,
          value: 20.0,
          occurredAt: DateTime(2026, 10, 3, 10, 0),
          createdAt: DateTime(2026, 10, 3),
          updatedAt: DateTime(2026, 10, 3),
        ),
      ];

      final result = engine.calculate(
        habit: baseHabit,
        entries: entries,
        periods: [],
        now: now,
        freezePeriods: freezePeriods,
      );

      expect(result.value, equals(2));
      expect(result.status, equals(StreakStatus.pendingToday));
    });

    test('MoodCheckIn records and serializes 1-5 score and attributes', () {
      final checkin = MoodCheckIn(
        id: 'mood-1',
        occurredAtUtc: DateTime.utc(2026, 10, 22, 19, 0),
        localDate: '2026-10-22',
        mood: 4,
        energy: 4,
        stress: 2,
        note: 'Bugün çok verimli geçti.',
        createdAtUtc: DateTime.utc(2026, 10, 22, 19, 0),
        updatedAtUtc: DateTime.utc(2026, 10, 22, 19, 0),
      );

      final json = checkin.toJson();
      final restored = MoodCheckIn.fromJson(json);

      expect(restored.mood, equals(4));
      expect(restored.energy, equals(4));
      expect(restored.stress, equals(2));
      expect(restored.note, equals('Bugün çok verimli geçti.'));
    });
  });

  group('Phase 3: Tangible Gains & Growth Progression', () {
    test('SavingsCalculator separates active streak savings from all-time historical savings', () {
      const calc = SavingsCalculator();
      final baseline = BaselineConsumption(
        id: 'b1',
        habitId: 'h-smoke',
        costMinorUnits: 8000, // 80 TL per day
        minutesSpent: 45, // 45 minutes per day
        period: ConsumptionPeriod.day,
      );

      // Past broken streak that lasted 10 days
      final pastPeriod = StreakPeriod(
        id: 'p1',
        habitId: 'h-smoke',
        startedAt: DateTime(2026, 9, 1),
        endedAt: DateTime(2026, 9, 11),
        status: StreakPeriodStatus.broken,
      );

      // Active streak is 5 days
      final calculation = calc.calculate(
        baseline: baseline,
        activeStreakDays: 5,
        allPeriods: [pastPeriod],
      );

      // Active streak: 5 days * 80 TL = 400 TL, 5 * 45 = 225 minutes (3.75 hours)
      expect(calculation.currentStreakMoneySaved, equals(400.0));
      expect(calculation.currentStreakMinutesSaved, equals(225));
      expect(calculation.activeMoneySavedFormatted, equals('₺400'));
      expect(calculation.activeTimeSavedHoursFormatted, equals('3.8 saat'));

      // Total historical: 5 (active) + 10 (past) = 15 days
      // 15 * 80 TL = 1200 TL, 15 * 45 = 675 minutes (11.25 hours)
      expect(calculation.totalHistoricalMoneySaved, equals(1200.0));
      expect(calculation.totalHistoricalMinutesSaved, equals(675));
      expect(calculation.allTimeMoneySavedFormatted, equals('₺1200'));
      expect(calculation.allTimeTimeSavedHoursFormatted, equals('11.3 saat'));
    });

    test(
      'GrowthStage maps habit streak days to visual botanical tree stages',
      () {
        expect(GrowthStage.fromDays(0), equals(GrowthStage.seed));
        expect(GrowthStage.fromDays(2), equals(GrowthStage.seed));
        expect(GrowthStage.fromDays(3), equals(GrowthStage.sprout));
        expect(GrowthStage.fromDays(6), equals(GrowthStage.sprout));
        expect(GrowthStage.fromDays(7), equals(GrowthStage.sapling));
        expect(GrowthStage.fromDays(13), equals(GrowthStage.sapling));
        expect(GrowthStage.fromDays(14), equals(GrowthStage.youngTree));
        expect(GrowthStage.fromDays(29), equals(GrowthStage.youngTree));
        expect(GrowthStage.fromDays(30), equals(GrowthStage.bloomingTree));
        expect(GrowthStage.fromDays(60), equals(GrowthStage.ancientTree));
      },
    );
  });

  group('Phase 4: Privacy Lock & Sovereign Backup', () {
    test('AppSecuritySettings hashes PIN with salt and verifies correctly', () {
      const pin = '1234';
      final hash = AppSecuritySettings.hashPin(pin);

      final settings = AppSecuritySettings(
        pinEnabled: true,
        pinHash: hash,
        biometricEnabled: true,
      );

      expect(settings.verifyPin('1234'), isTrue);
      expect(settings.verifyPin('0000'), isFalse);
      expect(settings.verifyPin('123'), isFalse);
    });

    test(
      'ExportBackupService produces clean JSON export and imports back',
      () async {
        final storage = InMemoryStorage();
        final service = ExportBackupService(storage);
        final habitRepo = LocalHabitRepository(storage);
        final habit = Habit(
          id: 'exp-h1',
          userId: 'u1',
          name: 'Yoga',
          kind: HabitKind.positive,
          category: HabitCategory.yoga,
          iconKey: 'self_improvement',
          scheduleType: ScheduleType.daily,
          targetValue: 15.0,
          unit: 'dk',
          startAt: DateTime(2026, 10, 1),
          createdAt: DateTime(2026, 10, 1),
          updatedAt: DateTime(2026, 10, 1),
        );
        await habitRepo.saveHabit(habit);

        final jsonPayload = await service.exportAllDataAsJson();

        expect(jsonPayload, contains('Yoga'));
        expect(jsonPayload, contains('yoga'));

        final clearStorage = InMemoryStorage();
        final restoreService = ExportBackupService(clearStorage);
        final success = await restoreService.restoreFromJson(jsonPayload);
        expect(success, isTrue);

        final restoredRepo = LocalHabitRepository(clearStorage);
        final restoredHabits = await restoredRepo.getHabits();
        expect(restoredHabits.any((h) => h.name == 'Yoga'), isTrue);
      },
    );
  });

  group('Phase 5: Platform Integrations & Routine Steps', () {
    test('Routine step serialization and order integrity', () {
      final routine = Routine(
        id: 'r1',
        name: 'Sabah Rutini',
        steps: const [
          RoutineStep(
            id: 's1',
            routineId: 'r1',
            habitId: 'h-water',
            sortOrder: 1,
            durationSeconds: 120,
          ),
          RoutineStep(
            id: 's2',
            routineId: 'r1',
            habitId: 'h-reading',
            sortOrder: 2,
            durationSeconds: 600,
          ),
        ],
        createdAtUtc: DateTime.utc(2026, 10, 20),
      );

      final json = routine.toJson();
      final restored = Routine.fromJson(json);

      expect(restored.name, equals('Sabah Rutini'));
      expect(restored.steps.length, equals(2));
      expect(restored.steps.first.habitId, equals('h-water'));
    });

    test(
      'HealthIntegrationAdapter handles deduplication and graceful fallback',
      () async {
        final adapter = LocalHealthIntegrationAdapter();

        final supported = await adapter.isSupported();
        expect(supported, isFalse);

        final isFirst = adapter.deduplicateRecord('rec_steps_1020');
        expect(isFirst, isTrue);

        final isDuplicate = adapter.deduplicateRecord('rec_steps_1020');
        expect(isDuplicate, isFalse);
      },
    );
  });
}
