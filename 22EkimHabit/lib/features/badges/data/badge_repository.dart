import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/badge_model.dart';

abstract class BadgeRepository {
  Future<List<UserBadge>> getEarnedBadges();
  Future<void> awardBadge(String badgeId);
  Future<bool> hasBadge(String badgeId);
}

class LocalBadgeRepository implements BadgeRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_user_badges';

  LocalBadgeRepository(this._storage);

  @override
  Future<List<UserBadge>> getEarnedBadges() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) {
      // Varsayılan olarak İlk Adım rozetini ver
      final initial = [
        UserBadge(
          badgeId: 'first_step',
          earnedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      await _saveAll(initial);
      return initial;
    }
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => UserBadge.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> awardBadge(String badgeId) async {
    final badges = await getEarnedBadges();
    if (!badges.any((b) => b.badgeId == badgeId)) {
      badges.add(UserBadge(badgeId: badgeId, earnedAt: DateTime.now()));
      await _saveAll(badges);
    }
  }

  @override
  Future<bool> hasBadge(String badgeId) async {
    final badges = await getEarnedBadges();
    return badges.any((b) => b.badgeId == badgeId);
  }

  Future<void> _saveAll(List<UserBadge> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }
}
