import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';

class SettingsController {
  static final SettingsController _instance = SettingsController._internal();
  factory SettingsController() => _instance;

  SettingsController._internal();

  final ValueNotifier<SettingsModel> settings = ValueNotifier<SettingsModel>(const SettingsModel());

  void toggleWaterReminder() {
    settings.value = settings.value.copyWith(
      waterReminderEnabled: !settings.value.waterReminderEnabled,
    );
  }

  void toggleSound() {
    settings.value = settings.value.copyWith(
      soundEnabled: !settings.value.soundEnabled,
    );
  }

  void toggleHaptics() {
    settings.value = settings.value.copyWith(
      hapticsEnabled: !settings.value.hapticsEnabled,
    );
  }

  void setInterval(int minutes) {
    settings.value = settings.value.copyWith(reminderIntervalMinutes: minutes);
  }

  void dispose() {
    settings.dispose();
  }
}
