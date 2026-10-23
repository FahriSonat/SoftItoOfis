import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../core/database/local_storage.dart';
import '../domain/habit.dart';
import '../domain/habit_entry.dart';
import '../../streaks/domain/streak_period.dart';
import '../../streaks/domain/restart_pledge.dart';

abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<Habit?> getHabitById(String id);
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Future<List<HabitEntry>> getEntries(String habitId);
  Future<void> addEntry(HabitEntry entry);
  Future<List<StreakPeriod>> getPeriods(String habitId);
  Future<void> savePeriod(StreakPeriod period);
  Future<void> breakNegativeStreak({
    required String habitId,
    required DateTime occurredAt,
    String? note,
    String? triggerTag,
  });
  Future<void> restartStreakWithPledge({
    required String habitId,
    required String pledgeText,
    String? reflection,
    String? strategyId,
    required int previousStreakDays,
  });
}

class LocalHabitRepository implements HabitRepository {
  final KeyValueStorage _storage;
  static const _uuid = Uuid();
  static const String _habitsKey = 'denge_habits';
  static const String _entriesKey = 'denge_entries';
  static const String _periodsKey = 'denge_periods';
  static const String _pledgesKey = 'denge_pledges';

  LocalHabitRepository(this._storage);

  @override
  Future<List<Habit>> getHabits() async {
    final raw = await _storage.getString(_habitsKey);
    if (raw == null || raw.isEmpty) {
      // Varsayılan ilk başlangıç alışkanlıklarını tohumla (seed)
      final defaults = _seedDefaultHabits();
      await _saveAllHabits(defaults);
      return defaults;
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Habit.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Habit?> getHabitById(String id) async {
    final habits = await getHabits();
    return habits.cast<Habit?>().firstWhere(
      (h) => h?.id == id,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    final habits = await getHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index >= 0) {
      habits[index] = habit;
    } else {
      habits.add(habit);
      // Yeni negatif alışkanlık için ilk aktif streak periyodunu oluştur
      if (habit.kind.isNegative) {
        final initialPeriod = StreakPeriod(
          id: _uuid.v4(),
          habitId: habit.id,
          startedAt: habit.startAt,
          status: StreakPeriodStatus.active,
        );
        await savePeriod(initialPeriod);
      }
    }
    await _saveAllHabits(habits);
  }

  @override
  Future<void> deleteHabit(String id) async {
    final habits = await getHabits();
    habits.removeWhere((h) => h.id == id);
    await _saveAllHabits(habits);
  }

  @override
  Future<List<HabitEntry>> getEntries(String habitId) async {
    final all = await _getAllEntries();
    return all.where((e) => e.habitId == habitId).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  }

  @override
  Future<void> addEntry(HabitEntry entry) async {
    final all = await _getAllEntries();
    all.add(entry);
    await _saveAllEntries(all);
  }

  @override
  Future<List<StreakPeriod>> getPeriods(String habitId) async {
    final all = await _getAllPeriods();
    return all.where((p) => p.habitId == habitId).toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<void> savePeriod(StreakPeriod period) async {
    final all = await _getAllPeriods();
    final index = all.indexWhere((p) => p.id == period.id);
    if (index >= 0) {
      all[index] = period;
    } else {
      all.add(period);
    }
    await _saveAllPeriods(all);
  }

  @override
  Future<void> breakNegativeStreak({
    required String habitId,
    required DateTime occurredAt,
    String? note,
    String? triggerTag,
  }) async {
    // 1. Kırılma kaydını oluştur
    final now = DateTime.now();
    final relapseEntry = HabitEntry(
      id: _uuid.v4(),
      habitId: habitId,
      userId: 'default_user',
      entryType: EntryType.relapse,
      value: 1.0,
      occurredAt: occurredAt,
      note: note,
      triggerTag: triggerTag,
      createdAt: now,
      updatedAt: now,
    );
    await addEntry(relapseEntry);

    // 2. Aktif periyodu kapat
    final periods = await getPeriods(habitId);
    final activeIndex = periods.indexWhere((p) => p.isCurrentActive);
    if (activeIndex >= 0) {
      final active = periods[activeIndex];
      final days = occurredAt.difference(active.startedAt).inDays;
      final closed = StreakPeriod(
        id: active.id,
        habitId: habitId,
        startedAt: active.startedAt,
        endedAt: occurredAt,
        status: StreakPeriodStatus.broken,
        successfulPeriods: days,
        endReason: note ?? 'Kırılma kaydı',
      );
      await savePeriod(closed);
    }
  }

  @override
  Future<void> restartStreakWithPledge({
    required String habitId,
    required String pledgeText,
    String? reflection,
    String? strategyId,
    required int previousStreakDays,
  }) async {
    final now = DateTime.now();
    final pledgeId = _uuid.v4();

    // Söz kaydet
    final pledge = RestartPledge(
      id: pledgeId,
      habitId: habitId,
      previousStreakDays: previousStreakDays,
      pledgeText: pledgeText,
      reflection: reflection,
      strategyId: strategyId,
      committedAt: now,
    );
    await _savePledge(pledge);

    // Yeni aktif periyot başlat
    final newPeriod = StreakPeriod(
      id: _uuid.v4(),
      habitId: habitId,
      startedAt: now,
      status: StreakPeriodStatus.active,
      restartPledgeId: pledgeId,
    );
    await savePeriod(newPeriod);
  }

  // Dahili yardımcı metotlar
  Future<List<HabitEntry>> _getAllEntries() async {
    final raw = await _storage.getString(_entriesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => HabitEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAllEntries(List<HabitEntry> entries) async {
    final raw = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _storage.setString(_entriesKey, raw);
  }

  Future<List<StreakPeriod>> _getAllPeriods() async {
    final raw = await _storage.getString(_periodsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => StreakPeriod.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAllPeriods(List<StreakPeriod> periods) async {
    final raw = jsonEncode(periods.map((p) => p.toJson()).toList());
    await _storage.setString(_periodsKey, raw);
  }

  Future<void> _saveAllHabits(List<Habit> habits) async {
    final raw = jsonEncode(habits.map((h) => h.toJson()).toList());
    await _storage.setString(_habitsKey, raw);
  }

  Future<void> _savePledge(RestartPledge pledge) async {
    final raw = await _storage.getString(_pledgesKey);
    List<dynamic> list = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        list = jsonDecode(raw) as List<dynamic>;
      } catch (_) {}
    }
    list.add(pledge.toJson());
    await _storage.setString(_pledgesKey, jsonEncode(list));
  }

  List<Habit> _seedDefaultHabits() {
    final now = DateTime.now();
    return [
      Habit(
        id: 'seed_neg_1',
        userId: 'default_user',
        name: 'Sigarayı Bırakma',
        kind: HabitKind.negative,
        category: HabitCategory.smoking,
        iconKey: 'smoke_free',
        startAt: now.subtract(const Duration(days: 4, hours: 3)),
        unitCost: 75.0, // Günlük paket maliyeti
        dailyUsageBefore: 1.0,
        createdAt: now,
        updatedAt: now,
      ),
      Habit(
        id: 'seed_pos_1',
        userId: 'default_user',
        name: 'Günlük Su Hedefi',
        kind: HabitKind.positive,
        category: HabitCategory.water,
        iconKey: 'water_drop',
        startAt: now.subtract(const Duration(days: 7)),
        measurementType: MeasurementType.volumeMl,
        targetValue: 2000.0,
        unit: 'ml',
        scheduleType: ScheduleType.daily,
        createdAt: now,
        updatedAt: now,
      ),
      Habit(
        id: 'seed_pos_2',
        userId: 'default_user',
        name: 'Kitap Okuma',
        kind: HabitKind.positive,
        category: HabitCategory.reading,
        iconKey: 'menu_book',
        startAt: now.subtract(const Duration(days: 10)),
        measurementType: MeasurementType.count,
        targetValue: 20.0,
        unit: 'sayfa',
        scheduleType: ScheduleType.daily,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
