import 'package:flutter_test/flutter_test.dart';
import 'package:denge/core/database/local_storage.dart';
import 'package:denge/features/habits/domain/habit.dart';
import 'package:denge/features/habits/data/habit_repository.dart';

void main() {
  group('LocalHabitRepository Tests', () {
    late InMemoryStorage storage;
    late LocalHabitRepository repository;

    setUp(() {
      storage = InMemoryStorage();
      repository = LocalHabitRepository(storage);
    });

    test('getHabits seeds default habits when storage is empty', () async {
      final habits = await repository.getHabits();
      expect(habits, isNotEmpty);
      expect(habits.any((h) => h.kind.isNegative), isTrue);
      expect(habits.any((h) => h.kind.isPositive), isTrue);
    });

    test('saveHabit and deleteHabit work correctly', () async {
      final newHabit = Habit(
        id: 'test_1',
        userId: 'u1',
        name: 'Meditasyon',
        kind: HabitKind.positive,
        category: HabitCategory.yoga,
        iconKey: 'self_improvement',
        startAt: DateTime(2026, 10, 23),
        createdAt: DateTime(2026, 10, 23),
        updatedAt: DateTime(2026, 10, 23),
      );

      await repository.saveHabit(newHabit);
      var fetched = await repository.getHabitById('test_1');
      expect(fetched, isNotNull);
      expect(fetched!.name, equals('Meditasyon'));

      await repository.deleteHabit('test_1');
      fetched = await repository.getHabitById('test_1');
      expect(fetched, isNull);
    });

    test(
      'breakNegativeStreak closes active period and creates relapse entry',
      () async {
        final negHabit = Habit(
          id: 'neg_test',
          userId: 'u1',
          name: 'Oyun Bağımlılığı',
          kind: HabitKind.negative,
          category: HabitCategory.gaming,
          iconKey: 'sports_esports',
          startAt: DateTime(2026, 10, 20),
          createdAt: DateTime(2026, 10, 20),
          updatedAt: DateTime(2026, 10, 20),
        );

        await repository.saveHabit(negHabit);
        final periodsBefore = await repository.getPeriods('neg_test');
        expect(periodsBefore.any((p) => p.isCurrentActive), isTrue);

        await repository.breakNegativeStreak(
          habitId: 'neg_test',
          occurredAt: DateTime(2026, 10, 23, 15, 0),
          note: 'Stresli bir gündü',
        );

        final entries = await repository.getEntries('neg_test');
        expect(entries.length, equals(1));
        expect(entries.first.note, equals('Stresli bir gündü'));

        final periodsAfter = await repository.getPeriods('neg_test');
        expect(periodsAfter.any((p) => p.isCurrentActive), isFalse);
      },
    );

    test(
      'restartStreakWithPledge starts a new active period and saves pledge',
      () async {
        await repository.restartStreakWithPledge(
          habitId: 'neg_test',
          pledgeText: 'Yeniden başlıyorum',
          reflection: 'Nefes egzersizi yapacağım',
          previousStreakDays: 3,
        );

        final periods = await repository.getPeriods('neg_test');
        expect(periods.any((p) => p.isCurrentActive), isTrue);
      },
    );
  });
}
