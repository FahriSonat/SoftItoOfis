import 'dart:convert';

import '../../../core/database/local_storage.dart';

class ExportBackupService {
  final KeyValueStorage _storage;

  ExportBackupService(this._storage);

  /// Bütün verileri tek bir JSON dizesi olarak dışa aktarır
  Future<String> exportAllDataAsJson() async {
    final Map<String, dynamic> exportMap = {
      'version': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'habits': await _storage.getString('denge_habits'),
      'entries': await _storage.getString('denge_entries'),
      'periods': await _storage.getString('denge_periods'),
      'triggers': await _storage.getString('denge_trigger_events'),
      'notes': await _storage.getString('denge_trigger_notes'),
      'baselines': await _storage.getString('denge_baselines'),
      'savingsGoals': await _storage.getString('denge_savings_goals'),
      'moods': await _storage.getString('denge_mood_checkins'),
      'badges': await _storage.getString('denge_user_badges'),
    };
    return jsonEncode(exportMap);
  }

  /// JSON yedeğinden verileri geri yükler
  Future<bool> restoreFromJson(String jsonContent) async {
    try {
      final Map<String, dynamic> map =
          jsonDecode(jsonContent) as Map<String, dynamic>;
      for (final entry in map.entries) {
        if (entry.key != 'version' && entry.key != 'exportedAt') {
          final storageKey = _mapToStorageKey(entry.key);
          if (storageKey != null && entry.value != null) {
            await _storage.setString(storageKey, entry.value.toString());
          }
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Tüm veritabanını sıfırlar
  Future<void> wipeAllData() async {
    await _storage.clear();
  }

  String? _mapToStorageKey(String exportKey) {
    switch (exportKey) {
      case 'habits':
        return 'denge_habits';
      case 'entries':
        return 'denge_entries';
      case 'periods':
        return 'denge_periods';
      case 'triggers':
        return 'denge_trigger_events';
      case 'notes':
        return 'denge_trigger_notes';
      case 'baselines':
        return 'denge_baselines';
      case 'savingsGoals':
        return 'denge_savings_goals';
      case 'moods':
        return 'denge_mood_checkins';
      case 'badges':
        return 'denge_user_badges';
      default:
        return null;
    }
  }
}
