import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _waterReminder = true;
  bool _soundEnabled = true;
  bool _gymMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text(
              'Bildirim & Hatırlatıcılar',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _waterReminder,
                    title: const Text('Saatlik Su Hatırlatıcı', style: TextStyle(color: AppColors.textPrimary)),
                    subtitle: const Text('Günde 8 kez hidrasyon uyarısı', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _waterReminder = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _gymMode,
                    title: const Text('Spor Salonu Modu', style: TextStyle(color: AppColors.textPrimary)),
                    subtitle: const Text('Egzersiz esnasında sık su içme hatırlatması', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    activeThumbColor: AppColors.secondary,
                    onChanged: (val) => setState(() => _gymMode = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _soundEnabled,
                    title: const Text('Uygulama Ses Efektleri', style: TextStyle(color: AppColors.textPrimary)),
                    subtitle: const Text('Su ve antrenman ekleme sesleri', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _soundEnabled = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Uygulama Hakkında',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info_outline_rounded, color: AppColors.textSecondary),
                    title: Text('Sürüm', style: TextStyle(color: AppColors.textPrimary)),
                    trailing: Text('1.0.0 (v3.39.4)', style: TextStyle(color: AppColors.textMuted)),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.security_rounded, color: AppColors.textSecondary),
                    title: Text('Gizlilik Politikası', style: TextStyle(color: AppColors.textPrimary)),
                    trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ),
                  Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.fitness_center_rounded, color: AppColors.textSecondary),
                    title: Text('Tasarım & Mimari', style: TextStyle(color: AppColors.textPrimary)),
                    trailing: Text('Material 3 Dark', style: TextStyle(color: AppColors.textMuted)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                '${AppConstants.appName} • ${AppConstants.appSlogan}',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
