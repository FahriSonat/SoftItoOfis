import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/personal_motivation.dart';

abstract class MotivationRepository {
  Future<PersonalMotivation?> getMotivation(String habitId);
  Future<void> saveMotivation(PersonalMotivation motivation);
  Future<void> deleteMotivation(String habitId);
}

class LocalMotivationRepository implements MotivationRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_personal_motivation';

  LocalMotivationRepository(this._storage);

  @override
  Future<PersonalMotivation?> getMotivation(String habitId) async {
    final all = await _getAll();
    return all.cast<PersonalMotivation?>().firstWhere(
      (m) => m?.habitId == habitId,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveMotivation(PersonalMotivation motivation) async {
    final all = await _getAll();
    final idx = all.indexWhere((m) => m.habitId == motivation.habitId);
    if (idx >= 0) {
      all[idx] = motivation;
    } else {
      all.add(motivation);
    }
    await _saveAll(all);
  }

  @override
  Future<void> deleteMotivation(String habitId) async {
    final all = await _getAll();
    all.removeWhere((m) => m.habitId == habitId);
    await _saveAll(all);
  }

  Future<List<PersonalMotivation>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => PersonalMotivation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<PersonalMotivation> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
