import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/goal_levels.dart';

abstract class GoalLevelsRepository {
  Future<GoalLevels?> getGoalLevels(String habitId);
  Future<void> saveGoalLevels(GoalLevels levels);
  Future<void> deleteGoalLevels(String habitId);
}

class LocalGoalLevelsRepository implements GoalLevelsRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_goal_levels';

  LocalGoalLevelsRepository(this._storage);

  @override
  Future<GoalLevels?> getGoalLevels(String habitId) async {
    final all = await _getAll();
    return all.cast<GoalLevels?>().firstWhere(
      (g) => g?.habitId == habitId,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveGoalLevels(GoalLevels levels) async {
    final all = await _getAll();
    final idx = all.indexWhere((g) => g.habitId == levels.habitId);
    if (idx >= 0) {
      all[idx] = levels;
    } else {
      all.add(levels);
    }
    await _saveAll(all);
  }

  @override
  Future<void> deleteGoalLevels(String habitId) async {
    final all = await _getAll();
    all.removeWhere((g) => g.habitId == habitId);
    await _saveAll(all);
  }

  Future<List<GoalLevels>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => GoalLevels.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<GoalLevels> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
