import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile> getUserProfile();
  Future<void> saveUserProfile(UserProfile profile);
  Future<void> clearAllData();
}

class LocalAuthRepository implements AuthRepository {
  final KeyValueStorage _storage;
  static const String _profileKey = 'denge_user_profile';

  LocalAuthRepository(this._storage);

  @override
  Future<UserProfile> getUserProfile() async {
    final raw = await _storage.getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      final defaultProfile = UserProfile(
        id: 'user_1',
        displayName: 'Fahri Sonat',
        email: 'fahri@denge.app',
        avatar: '🌱',
        timezone: 'Europe/Istanbul',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      );
      await saveUserProfile(defaultProfile);
      return defaultProfile;
    }
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return UserProfile(
        id: 'user_1',
        displayName: 'Kullanıcı',
        email: 'kullanici@denge.app',
        createdAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    await _storage.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<void> clearAllData() async {
    await _storage.clear();
  }
}
