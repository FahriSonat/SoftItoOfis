import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final habitsAsync = ref.watch(habitsListProvider);
    final badgesAsync = ref.watch(earnedBadgesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Geri',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('Profilim'),
        actions: [
          IconButton(
            tooltip: 'Ayarlar',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (profile) {
          final habitsCount = habitsAsync.value?.length ?? 0;
          final badgesCount = badgesAsync.value?.length ?? 0;
          final joinDate = DateFormat(
            'd MMMM yyyy',
            'tr_TR',
          ).format(profile.createdAt);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              // Avatar ve İsim
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.surfaceHigh,
                      child: Text(
                        profile.avatar,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Katılım: $joinDate',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // İstatistik Kartı
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      'Alışkanlık',
                      '$habitsCount',
                      Icons.flag_rounded,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _infoCard(
                      'Kazanılan Rozet',
                      '$badgesCount',
                      Icons.military_tech_rounded,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Menü Öğeleri
              ListTile(
                leading: const Icon(
                  Icons.emoji_events_outlined,
                  color: AppColors.warning,
                ),
                title: const Text('Rozetlerimi Görüntüle'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/badges'),
              ),
              const Divider(height: 1, color: AppColors.borderSubtle),
              ListTile(
                leading: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.positiveStages.first,
                ),
                title: const Text('Genel Takvim ve Geçmiş'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/calendar'),
              ),
              const Divider(height: 1, color: AppColors.borderSubtle),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.textSecondary,
                ),
                title: const Text('Ayarlar ve Gizlilik'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/settings'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
