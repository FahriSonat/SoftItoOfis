import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/savings_model.dart';

abstract class SavingsRepository {
  Future<BaselineConsumption?> getBaseline(String habitId);
  Future<void> saveBaseline(BaselineConsumption baseline);
  Future<List<SavingsGoal>> getGoals();
  Future<void> saveGoal(SavingsGoal goal);
  Future<void> deleteGoal(String id);
}

class LocalSavingsRepository implements SavingsRepository {
  final KeyValueStorage _storage;
  static const String _baselineKey = 'denge_baselines';
  static const String _goalsKey = 'denge_savings_goals';

  LocalSavingsRepository(this._storage);

  @override
  Future<BaselineConsumption?> getBaseline(String habitId) async {
    final all = await _getAllBaselines();
    return all.cast<BaselineConsumption?>().firstWhere(
      (b) => b?.habitId == habitId,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveBaseline(BaselineConsumption baseline) async {
    final all = await _getAllBaselines();
    final idx = all.indexWhere((b) => b.habitId == baseline.habitId);
    if (idx >= 0) {
      all[idx] = baseline;
    } else {
      all.add(baseline);
    }
    await _saveAllBaselines(all);
  }

  @override
  Future<List<SavingsGoal>> getGoals() async {
    final raw = await _storage.getString(_goalsKey);
    if (raw == null || raw.isEmpty) {
      // Varsayılan sembolik hedef
      final defaultGoal = SavingsGoal(
        id: 'goal_seed_1',
        title: 'Yeni Kitap Seti',
        targetAmountMinorUnits: 50000, // 500 TL
        currencyCode: 'TRY',
        createdAtUtc: DateTime.now(),
      );
      await saveGoal(defaultGoal);
      return [defaultGoal];
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SavingsGoal.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveGoal(SavingsGoal goal) async {
    final all = await getGoals();
    final idx = all.indexWhere((g) => g.id == goal.id);
    if (idx >= 0) {
      all[idx] = goal;
    } else {
      all.add(goal);
    }
    await _storage.setString(
      _goalsKey,
      jsonEncode(all.map((g) => g.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteGoal(String id) async {
    final all = await getGoals();
    all.removeWhere((g) => g.id == id);
    await _storage.setString(
      _goalsKey,
      jsonEncode(all.map((g) => g.toJson()).toList()),
    );
  }

  Future<List<BaselineConsumption>> _getAllBaselines() async {
    final raw = await _storage.getString(_baselineKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => BaselineConsumption.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAllBaselines(List<BaselineConsumption> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_baselineKey, raw);
  }
}
