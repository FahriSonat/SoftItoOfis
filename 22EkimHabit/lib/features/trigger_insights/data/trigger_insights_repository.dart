import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/trigger_event.dart';

abstract class TriggerInsightsRepository {
  Future<List<TriggerEvent>> getEvents(String habitId);
  Future<void> addEvent(TriggerEvent event);
  Future<void> deleteEvent(String id);
}

class LocalTriggerInsightsRepository implements TriggerInsightsRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_trigger_events';

  LocalTriggerInsightsRepository(this._storage);

  @override
  Future<List<TriggerEvent>> getEvents(String habitId) async {
    final all = await _getAll();
    return all.where((e) => e.habitId == habitId).toList()
      ..sort((a, b) => b.occurredAtUtc.compareTo(a.occurredAtUtc));
  }

  @override
  Future<void> addEvent(TriggerEvent event) async {
    final all = await _getAll();
    all.add(event);
    await _saveAll(all);
  }

  @override
  Future<void> deleteEvent(String id) async {
    final all = await _getAll();
    all.removeWhere((e) => e.id == id);
    await _saveAll(all);
  }

  Future<List<TriggerEvent>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TriggerEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<TriggerEvent> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
