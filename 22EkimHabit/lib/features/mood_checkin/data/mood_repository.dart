import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/mood_checkin.dart';

abstract class MoodRepository {
  Future<List<MoodCheckIn>> getCheckIns();
  Future<MoodCheckIn?> getCheckInForDate(String localDate);
  Future<void> saveCheckIn(MoodCheckIn checkIn);
}

class LocalMoodRepository implements MoodRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_mood_checkins';

  LocalMoodRepository(this._storage);

  @override
  Future<List<MoodCheckIn>> getCheckIns() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MoodCheckIn.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.localDate.compareTo(a.localDate));
    } catch (_) {
      return [];
    }
  }

  @override
  Future<MoodCheckIn?> getCheckInForDate(String localDate) async {
    final list = await getCheckIns();
    return list.cast<MoodCheckIn?>().firstWhere(
      (m) => m?.localDate == localDate,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveCheckIn(MoodCheckIn checkIn) async {
    final list = await getCheckIns();
    final idx = list.indexWhere((m) => m.localDate == checkIn.localDate);
    if (idx >= 0) {
      list[idx] = checkIn;
    } else {
      list.add(checkIn);
    }
    await _storage.setString(
      _key,
      jsonEncode(list.map((m) => m.toJson()).toList()),
    );
  }
}
