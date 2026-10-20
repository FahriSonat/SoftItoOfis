import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores only the user's non-sensitive theme preference.
class ThemePreferenceStore {
  static const _key = 'theme_mode';

  Future<ThemeMode> read() async {
    final preferences = await SharedPreferences.getInstance();
    return switch (preferences.getString(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> save(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, mode.name);
  }
}
