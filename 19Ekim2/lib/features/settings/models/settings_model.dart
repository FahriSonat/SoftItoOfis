class SettingsModel {
  final bool waterReminderEnabled;
  final int reminderIntervalMinutes;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool darkMode;

  const SettingsModel({
    this.waterReminderEnabled = true,
    this.reminderIntervalMinutes = 60,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.darkMode = true,
  });

  SettingsModel copyWith({
    bool? waterReminderEnabled,
    int? reminderIntervalMinutes,
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? darkMode,
  }) {
    return SettingsModel(
      waterReminderEnabled: waterReminderEnabled ?? this.waterReminderEnabled,
      reminderIntervalMinutes: reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      waterReminderEnabled: json['waterReminderEnabled'] as bool? ?? true,
      reminderIntervalMinutes: json['reminderIntervalMinutes'] as int? ?? 60,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterReminderEnabled': waterReminderEnabled,
      'reminderIntervalMinutes': reminderIntervalMinutes,
      'soundEnabled': soundEnabled,
      'hapticsEnabled': hapticsEnabled,
      'darkMode': darkMode,
    };
  }
}
