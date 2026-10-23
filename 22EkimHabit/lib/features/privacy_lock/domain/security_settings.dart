import 'dart:convert';

import 'package:crypto/crypto.dart';

enum NotificationPrivacy {
  full('Tam İçerik'),
  hideHabit('Alışkanlık Adını Gizle'),
  generic('Yalnızca Genel Hatırlatma');

  final String label;
  const NotificationPrivacy(this.label);
}

class AppSecuritySettings {
  final bool biometricEnabled;
  final bool pinEnabled;
  final String? pinHash; // Salted SHA-256
  final int lockDelaySeconds; // 0, 30, 60, 300
  final bool hideInAppSwitcher;
  final NotificationPrivacy notificationPrivacy;
  final bool privacyModeEnabled; // Bulanıklaştırma

  const AppSecuritySettings({
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.pinHash,
    this.lockDelaySeconds = 0,
    this.hideInAppSwitcher = true,
    this.notificationPrivacy = NotificationPrivacy.full,
    this.privacyModeEnabled = false,
  });

  bool verifyPin(String pin) {
    if (pinHash == null) return false;
    final computed = hashPin(pin);
    return computed == pinHash;
  }

  static String hashPin(String pin) {
    const salt = 'denge_privacy_salt_2026';
    final bytes = utf8.encode('$salt$pin$salt');
    return sha256.convert(bytes).toString();
  }

  AppSecuritySettings copyWith({
    bool? biometricEnabled,
    bool? pinEnabled,
    String? pinHash,
    int? lockDelaySeconds,
    bool? hideInAppSwitcher,
    NotificationPrivacy? notificationPrivacy,
    bool? privacyModeEnabled,
  }) {
    return AppSecuritySettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      pinHash: pinHash ?? this.pinHash,
      lockDelaySeconds: lockDelaySeconds ?? this.lockDelaySeconds,
      hideInAppSwitcher: hideInAppSwitcher ?? this.hideInAppSwitcher,
      notificationPrivacy: notificationPrivacy ?? this.notificationPrivacy,
      privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'biometricEnabled': biometricEnabled,
    'pinEnabled': pinEnabled,
    'pinHash': pinHash,
    'lockDelaySeconds': lockDelaySeconds,
    'hideInAppSwitcher': hideInAppSwitcher,
    'notificationPrivacy': notificationPrivacy.name,
    'privacyModeEnabled': privacyModeEnabled,
  };

  factory AppSecuritySettings.fromJson(Map<String, dynamic> json) {
    return AppSecuritySettings(
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      pinEnabled: json['pinEnabled'] as bool? ?? false,
      pinHash: json['pinHash'] as String?,
      lockDelaySeconds: json['lockDelaySeconds'] as int? ?? 0,
      hideInAppSwitcher: json['hideInAppSwitcher'] as bool? ?? true,
      notificationPrivacy: json['notificationPrivacy'] != null
          ? NotificationPrivacy.values.byName(
              json['notificationPrivacy'] as String,
            )
          : NotificationPrivacy.full,
      privacyModeEnabled: json['privacyModeEnabled'] as bool? ?? false,
    );
  }
}
