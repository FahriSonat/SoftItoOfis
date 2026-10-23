import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/routine.dart';

abstract class RoutineRepository {
  Future<List<Routine>> getRoutines();
  Future<void> saveRoutine(Routine routine);
  Future<void> deleteRoutine(String id);
}

class LocalRoutineRepository implements RoutineRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_routines';

  LocalRoutineRepository(this._storage);

  @override
  Future<List<Routine>> getRoutines() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) {
      // Varsayılan sabah rutini
      final defaultRoutine = Routine(
        id: 'routine_morning',
        name: 'Sabah Canlanma Rutini',
        createdAtUtc: DateTime.now(),
        steps: const [
          RoutineStep(
            id: 'step_1',
            routineId: 'routine_morning',
            habitId: 'seed_pos_1', // Su içme
            sortOrder: 1,
            durationSeconds: 120,
          ),
          RoutineStep(
            id: 'step_2',
            routineId: 'routine_morning',
            habitId: 'seed_pos_2', // Kitap okuma
            sortOrder: 2,
            durationSeconds: 600,
          ),
        ],
      );
      await saveRoutine(defaultRoutine);
      return [defaultRoutine];
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => Routine.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveRoutine(Routine routine) async {
    final all = await getRoutines();
    final idx = all.indexWhere((r) => r.id == routine.id);
    if (idx >= 0) {
      all[idx] = routine;
    } else {
      all.add(routine);
    }
    await _storage.setString(
      _key,
      jsonEncode(all.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteRoutine(String id) async {
    final all = await getRoutines();
    all.removeWhere((r) => r.id == id);
    await _storage.setString(
      _key,
      jsonEncode(all.map((r) => r.toJson()).toList()),
    );
  }
}
