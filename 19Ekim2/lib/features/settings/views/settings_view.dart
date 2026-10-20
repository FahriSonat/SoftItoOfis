import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';
import '../models/settings_model.dart';
import '../widgets/settings_card.dart';

class SettingsView extends StatelessWidget {
  final SettingsController _controller = SettingsController();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'Hatırlatıcı ve Bildirimler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ValueListenableBuilder<SettingsModel>(
              valueListenable: _controller.settings,
              builder: (context, settings, _) {
                return SettingsCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: settings.waterReminderEnabled,
                        onChanged: (_) => _controller.toggleWaterReminder(),
                        activeThumbColor: AppColors.primary,
                        title: const Text('Su İçme Hatırlatıcısı'),
                        subtitle: const Text('Gün boyunca düzenli su bildirimleri al'),
                      ),
                      const Divider(color: AppColors.divider),
                      ListTile(
                        title: const Text('Hatırlatma Sıklığı'),
                        trailing: Text(
                          '${settings.reminderIntervalMinutes} dk',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          // Cycle between 30, 45, 60, 90 mins
                          final intervals = [30, 45, 60, 90];
                          final nextIndex = (intervals.indexOf(settings.reminderIntervalMinutes) + 1) % intervals.length;
                          _controller.setInterval(intervals[nextIndex]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'Ses ve Titreşim',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ValueListenableBuilder<SettingsModel>(
              valueListenable: _controller.settings,
              builder: (context, settings, _) {
                return SettingsCard(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: settings.soundEnabled,
                        onChanged: (_) => _controller.toggleSound(),
                        activeThumbColor: AppColors.secondary,
                        title: const Text('Uygulama Sesleri'),
                      ),
                      const Divider(color: AppColors.divider),
                      SwitchListTile(
                        value: settings.hapticsEnabled,
                        onChanged: (_) => _controller.toggleHaptics(),
                        activeThumbColor: AppColors.secondary,
                        title: const Text('Dokunsal Geri Bildirim (Haptic)'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'Uygulama Hakkında',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SettingsCard(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Sürüm'),
                    trailing: Text('1.0.0 (Build 1)', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const Divider(color: AppColors.divider),
                  const ListTile(
                    title: Text('Geliştirici'),
                    trailing: Text('Susadım Health Tech', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
