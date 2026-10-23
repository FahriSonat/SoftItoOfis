import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/security_settings.dart';

abstract class SecurityRepository {
  Future<AppSecuritySettings> getSettings();
  Future<void> saveSettings(AppSecuritySettings settings);
}

class LocalSecurityRepository implements SecurityRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_security_settings';

  LocalSecurityRepository(this._storage);

  @override
  Future<AppSecuritySettings> getSettings() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) {
      return const AppSecuritySettings();
    }
    try {
      return AppSecuritySettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const AppSecuritySettings();
    }
  }

  @override
  Future<void> saveSettings(AppSecuritySettings settings) async {
    await _storage.setString(_key, jsonEncode(settings.toJson()));
  }
}
