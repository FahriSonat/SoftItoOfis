import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/freeze_period.dart';

abstract class FreezeRepository {
  Future<List<FreezePeriod>> getFreezePeriods(String habitId);
  Future<void> addFreezePeriod(FreezePeriod period);
  Future<void> deleteFreezePeriod(String id);
}

class LocalFreezeRepository implements FreezeRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_freeze_periods';

  LocalFreezeRepository(this._storage);

  @override
  Future<List<FreezePeriod>> getFreezePeriods(String habitId) async {
    final all = await _getAll();
    return all.where((p) => p.habitId == habitId).toList()
      ..sort((a, b) => b.startsOnLocalDate.compareTo(a.startsOnLocalDate));
  }

  @override
  Future<void> addFreezePeriod(FreezePeriod period) async {
    final all = await _getAll();
    all.add(period);
    await _saveAll(all);
  }

  @override
  Future<void> deleteFreezePeriod(String id) async {
    final all = await _getAll();
    all.removeWhere((p) => p.id == id);
    await _saveAll(all);
  }

  Future<List<FreezePeriod>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => FreezePeriod.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<FreezePeriod> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
