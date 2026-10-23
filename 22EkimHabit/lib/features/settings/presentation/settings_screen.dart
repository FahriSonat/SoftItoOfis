import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Geri',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
        title: const Text('Ayarlar'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Bildirimler Bölümü
          const Text(
            'Bildirimler ve Zaman',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.info,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bedtime_outlined),
                  title: const Text('Sessiz Saatler'),
                  subtitle: Text(
                    userAsync.value != null
                        ? '${userAsync.value!.quietHoursStart} - ${userAsync.value!.quietHoursEnd}'
                        : '23:00 - 07:00',
                  ),
                  trailing: const Icon(Icons.edit_outlined, size: 20),
                ),
                const Divider(height: 1, color: AppColors.borderSubtle),
                ListTile(
                  leading: const Icon(Icons.public_rounded),
                  title: const Text('Zaman Dilimi'),
                  subtitle: Text(
                    userAsync.value?.timezone ?? 'Europe/Istanbul',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Görünüm & Erişilebilirlik
          const Text(
            'Görünüm ve Erişilebilirlik',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.info,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.dark_mode_outlined),
                  title: Text('Tema Modu'),
                  subtitle: Text('Koyu Tema (Denge Özel Koyu Renkler)'),
                ),
                Divider(height: 1, color: AppColors.borderSubtle),
                ListTile(
                  leading: Icon(Icons.accessibility_new_rounded),
                  title: Text('TalkBack / VoiceOver Desteği'),
                  subtitle: Text('Aktif (WCAG AA Kontrast & Semantics)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Tehlikeli Bölge (Hesap ve Verileri Sıfırlama)
          const Text(
            'Tehlikeli Bölge',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.danger,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedLg,
              side: const BorderSide(color: AppColors.danger, width: 1),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.delete_forever_rounded,
                color: AppColors.danger,
              ),
              title: const Text(
                'Tüm Verileri Temizle ve Sıfırla',
                style: TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: const Text(
                'Tüm alışkanlıklar, geçmiş kayıtları ve rozetler silinir.',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Tüm Verileri Sil'),
                    content: const Text(
                      'Bu işlem geri alınamaz. Yerel veritabanındaki bütün alışkanlıklarınız, günlükleriniz ve rozetleriniz silinecektir. Devam etmek istiyor musunuz?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Vazgeç'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.danger,
                        ),
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await ref
                              .read(userProfileProvider.notifier)
                              .resetAll();
                          if (context.mounted) {
                            context.go('/home');
                          }
                        },
                        child: const Text('Evet, Hepsini Sil'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
