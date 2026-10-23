import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/trigger_note.dart';

abstract class JournalRepository {
  Future<List<TriggerNote>> getNotes(String habitId);
  Future<void> addNote(TriggerNote note);
  Future<void> deleteNote(String id);
}

class LocalJournalRepository implements JournalRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_trigger_notes';

  LocalJournalRepository(this._storage);

  @override
  Future<List<TriggerNote>> getNotes(String habitId) async {
    final all = await _getAll();
    return all.where((n) => n.habitId == habitId).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  }

  @override
  Future<void> addNote(TriggerNote note) async {
    final all = await _getAll();
    all.add(note);
    await _saveAll(all);
  }

  @override
  Future<void> deleteNote(String id) async {
    final all = await _getAll();
    all.removeWhere((n) => n.id == id);
    await _saveAll(all);
  }

  Future<List<TriggerNote>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => TriggerNote.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<TriggerNote> notes) async {
    final raw = jsonEncode(notes.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
