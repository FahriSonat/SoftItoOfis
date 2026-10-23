import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/local_storage.dart';
import '../../../../core/time/clock.dart';
import '../../domain/habit.dart';
import '../../domain/habit_entry.dart';
import '../../data/habit_repository.dart';
import '../../../streaks/domain/streak_period.dart';
import '../../../streaks/domain/streak_engine.dart';
import '../../../journal/domain/trigger_note.dart';
import '../../../journal/data/journal_repository.dart';
import '../../../coping/domain/coping_strategy.dart';
import '../../../coping/data/coping_repository.dart';
import '../../../badges/domain/badge_model.dart';
import '../../../badges/data/badge_repository.dart';
import '../../../auth/domain/user_profile.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../trigger_insights/domain/trigger_event.dart';
import '../../../trigger_insights/domain/trigger_insights_calculator.dart';
import '../../../trigger_insights/data/trigger_insights_repository.dart';
import '../../../support_contacts/domain/support_contact.dart';
import '../../../support_contacts/data/support_contacts_repository.dart';
import '../../../motivation/domain/personal_motivation.dart';
import '../../../motivation/data/motivation_repository.dart';
import '../../../flexible_goals/domain/goal_levels.dart';
import '../../../flexible_goals/data/goal_levels_repository.dart';
import '../../../freeze_mode/domain/freeze_period.dart';
import '../../../freeze_mode/data/freeze_repository.dart';
import '../../../mood_checkin/domain/mood_checkin.dart';
import '../../../mood_checkin/data/mood_repository.dart';
import '../../../savings/domain/savings_model.dart';
import '../../../savings/domain/savings_calculator.dart';
import '../../../savings/data/savings_repository.dart';
import '../../../privacy_lock/domain/security_settings.dart';
import '../../../privacy_lock/data/security_repository.dart';
import '../../../routines/domain/routine.dart';
import '../../../routines/data/routine_repository.dart';

// Temel Servis Provider'ları
final storageProvider = Provider<KeyValueStorage>((ref) {
  return SharedPreferencesStorage();
});

final clockProvider = Provider<Clock>((ref) {
  return const SystemClock();
});

final streakEngineProvider = Provider<StreakEngine>((ref) {
  return StreakEngine();
});

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalHabitRepository(storage);
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalJournalRepository(storage);
});

final copingRepositoryProvider = Provider<CopingRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalCopingRepository(storage);
});

final badgeRepositoryProvider = Provider<BadgeRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalBadgeRepository(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalAuthRepository(storage);
});

// Yeni Özellik Repository Provider'ları (feature.md)
final triggerInsightsRepositoryProvider = Provider<TriggerInsightsRepository>((
  ref,
) {
  final storage = ref.watch(storageProvider);
  return LocalTriggerInsightsRepository(storage);
});

final supportContactsRepositoryProvider = Provider<SupportContactsRepository>((
  ref,
) {
  final storage = ref.watch(storageProvider);
  return LocalSupportContactsRepository(storage);
});

final motivationRepositoryProvider = Provider<MotivationRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalMotivationRepository(storage);
});

final goalLevelsRepositoryProvider = Provider<GoalLevelsRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalGoalLevelsRepository(storage);
});

final freezeRepositoryProvider = Provider<FreezeRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalFreezeRepository(storage);
});

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalMoodRepository(storage);
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalSavingsRepository(storage);
});

final securityRepositoryProvider = Provider<SecurityRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalSecurityRepository(storage);
});

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final storage = ref.watch(storageProvider);
  return LocalRoutineRepository(storage);
});

// Profil Provider'ı
final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile>(
      UserProfileNotifier.new,
    );

class UserProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    final repo = ref.watch(authRepositoryProvider);
    return repo.getUserProfile();
  }

  Future<void> updateProfile(UserProfile profile) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.saveUserProfile(profile);
    state = AsyncData(profile);
  }

  Future<void> resetAll() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.clearAllData();
    ref.invalidate(habitsListProvider);
    ref.invalidateSelf();
  }
}

// Alışkanlıklar Listesi Provider'ı
final habitsListProvider =
    AsyncNotifierProvider<HabitsListNotifier, List<Habit>>(
      HabitsListNotifier.new,
    );

class HabitsListNotifier extends AsyncNotifier<List<Habit>> {
  @override
  Future<List<Habit>> build() async {
    final repo = ref.watch(habitRepositoryProvider);
    return repo.getHabits();
  }

  Future<void> addHabit(Habit habit) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.saveHabit(habit);
    ref.invalidateSelf();
  }

  Future<void> updateHabit(Habit habit) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.saveHabit(habit);
    ref.invalidateSelf();
  }

  Future<void> deleteHabit(String id) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.deleteHabit(id);
    ref.invalidateSelf();
  }

  Future<void> addEntry({
    required String habitId,
    required double value,
    String? note,
  }) async {
    final repo = ref.read(habitRepositoryProvider);
    final clock = ref.read(clockProvider);
    final now = clock.now();
    final entry = HabitEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      habitId: habitId,
      userId: 'default_user',
      entryType: EntryType.completion,
      value: value,
      occurredAt: now,
      note: note,
      createdAt: now,
      updatedAt: now,
    );
    await repo.addEntry(entry);
    ref.invalidate(habitEntriesProvider(habitId));
    ref.invalidate(habitDetailProvider(habitId));
    ref.invalidateSelf();
  }

  Future<void> breakNegativeStreak({
    required String habitId,
    String? note,
    String? triggerTag,
  }) async {
    final repo = ref.read(habitRepositoryProvider);
    final clock = ref.read(clockProvider);
    final now = clock.now();
    await repo.breakNegativeStreak(
      habitId: habitId,
      occurredAt: now,
      note: note,
      triggerTag: triggerTag,
    );
    ref.invalidate(habitPeriodsProvider(habitId));
    ref.invalidate(habitEntriesProvider(habitId));
    ref.invalidate(habitDetailProvider(habitId));
    ref.invalidateSelf();
  }

  Future<void> restartWithPledge({
    required String habitId,
    required String pledgeText,
    String? reflection,
    String? strategyId,
    required int previousStreakDays,
  }) async {
    final repo = ref.read(habitRepositoryProvider);
    await repo.restartStreakWithPledge(
      habitId: habitId,
      pledgeText: pledgeText,
      reflection: reflection,
      strategyId: strategyId,
      previousStreakDays: previousStreakDays,
    );
    ref.invalidate(habitPeriodsProvider(habitId));
    ref.invalidate(habitDetailProvider(habitId));
    ref.invalidateSelf();
  }
}

// Alışkanlığa özel Entries & Periods Provider'ları
final habitEntriesProvider = FutureProvider.family<List<HabitEntry>, String>((
  ref,
  habitId,
) async {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.getEntries(habitId);
});

final habitPeriodsProvider = FutureProvider.family<List<StreakPeriod>, String>((
  ref,
  habitId,
) async {
  final repo = ref.watch(habitRepositoryProvider);
  return repo.getPeriods(habitId);
});

// Alışkanlık Detayı ve Streak Durumu Veri Sınıfı
class HabitDetailState {
  final Habit habit;
  final List<HabitEntry> entries;
  final List<StreakPeriod> periods;
  final StreakResult streak;

  const HabitDetailState({
    required this.habit,
    required this.entries,
    required this.periods,
    required this.streak,
  });
}

final habitDetailProvider = FutureProvider.family<HabitDetailState?, String>((
  ref,
  habitId,
) async {
  final repo = ref.watch(habitRepositoryProvider);
  final habit = await repo.getHabitById(habitId);
  if (habit == null) return null;

  final entries = await repo.getEntries(habitId);
  final periods = await repo.getPeriods(habitId);
  final clock = ref.watch(clockProvider);
  final engine = ref.watch(streakEngineProvider);

  final streak = engine.calculate(
    habit: habit,
    entries: entries,
    periods: periods,
    now: clock.now(),
  );

  return HabitDetailState(
    habit: habit,
    entries: entries,
    periods: periods,
    streak: streak,
  );
});

// Beni Zorlayanlar Notları Provider'ı
final triggerNotesProvider = FutureProvider.family<List<TriggerNote>, String>((
  ref,
  habitId,
) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getNotes(habitId);
});

// Çözüm Yöntemleri Provider'ı
final copingStrategiesProvider =
    FutureProvider.family<List<CopingStrategy>, String>((ref, habitId) async {
      final repo = ref.watch(copingRepositoryProvider);
      return repo.getStrategies(habitId);
    });

// Rozetler Provider'ı
final earnedBadgesProvider = FutureProvider<List<UserBadge>>((ref) async {
  final repo = ref.watch(badgeRepositoryProvider);
  return repo.getEarnedBadges();
});

// Tetikleyici Haritası ve Çözüm Analizi Provider'ları (Section 5)
final triggerEventsProvider = FutureProvider.family<List<TriggerEvent>, String>(
  (ref, habitId) async {
    final repo = ref.watch(triggerInsightsRepositoryProvider);
    return repo.getEvents(habitId);
  },
);

final triggerInsightsProvider = FutureProvider.family<TriggerInsights, String>((
  ref,
  habitId,
) async {
  final events = await ref.watch(triggerEventsProvider(habitId).future);
  const calculator = TriggerInsightsCalculator();
  return calculator.calculate(events);
});

// Kişisel Motivasyon Provider'ı (Section 8)
final personalMotivationProvider =
    FutureProvider.family<PersonalMotivation?, String>((ref, habitId) async {
      final repo = ref.watch(motivationRepositoryProvider);
      return repo.getMotivation(habitId);
    });

// Destek Kişileri Provider'ı (Section 9)
final supportContactsProvider = FutureProvider<List<SupportContact>>((
  ref,
) async {
  final repo = ref.watch(supportContactsRepositoryProvider);
  return repo.getContacts();
});

// Esnek 3 Seviyeli Hedef Provider'ı (Section 12)
final goalLevelsProvider = FutureProvider.family<GoalLevels?, String>((
  ref,
  habitId,
) async {
  final repo = ref.watch(goalLevelsRepositoryProvider);
  return repo.getGoalLevels(habitId);
});

// Dondurma Modu Provider'ı (Section 13)
final freezePeriodsProvider = FutureProvider.family<List<FreezePeriod>, String>(
  (ref, habitId) async {
    final repo = ref.watch(freezeRepositoryProvider);
    return repo.getFreezePeriods(habitId);
  },
);

// Günlük Ruh Hali Provider'ı (Section 11)
final moodCheckInsProvider = FutureProvider<List<MoodCheckIn>>((ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getCheckIns();
});

// Tasarruf ve Hedef Cüzdanı Provider'ları (Section 7)
final savingsGoalsProvider = FutureProvider<List<SavingsGoal>>((ref) async {
  final repo = ref.watch(savingsRepositoryProvider);
  return repo.getGoals();
});

final habitSavingsCalculationProvider =
    FutureProvider.family<SavingsCalculation?, String>((ref, habitId) async {
      final habitRepo = ref.watch(habitRepositoryProvider);
      final savingsRepo = ref.watch(savingsRepositoryProvider);
      final habit = await habitRepo.getHabitById(habitId);
      if (habit == null || !habit.kind.isNegative) return null;

      final baseline = await savingsRepo.getBaseline(habitId);
      if (baseline == null) {
        if (habit.unitCost == null) return null;
        final defaultBaseline = BaselineConsumption(
          id: 'base_$habitId',
          habitId: habitId,
          costMinorUnits: ((habit.unitCost ?? 0) * 100).toInt(),
          minutesSpent: (habit.dailyUsageBefore != null
              ? (habit.dailyUsageBefore! * 60).toInt()
              : 60),
        );
        final periods = await habitRepo.getPeriods(habitId);
        final detail = await ref.watch(habitDetailProvider(habitId).future);
        final days = detail?.streak.value ?? 0;
        const calc = SavingsCalculator();
        return calc.calculate(
          baseline: defaultBaseline,
          activeStreakDays: days,
          allPeriods: periods,
        );
      }

      final periods = await habitRepo.getPeriods(habitId);
      final detail = await ref.watch(habitDetailProvider(habitId).future);
      final days = detail?.streak.value ?? 0;
      const calc = SavingsCalculator();
      return calc.calculate(
        baseline: baseline,
        activeStreakDays: days,
        allPeriods: periods,
      );
    });

// Güvenlik ve Gizlilik Ayarları Provider'ı (Section 20 & 24)
final securitySettingsProvider = FutureProvider<AppSecuritySettings>((
  ref,
) async {
  final repo = ref.watch(securityRepositoryProvider);
  return repo.getSettings();
});

// Rutinler Provider'ı (Section 30)
final routinesProvider = FutureProvider<List<Routine>>((ref) async {
  final repo = ref.watch(routineRepositoryProvider);
  return repo.getRoutines();
});
