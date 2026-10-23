import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/streak_ring.dart';
import '../../habits/presentation/providers/habit_providers.dart';

class RestartPledgeScreen extends ConsumerStatefulWidget {
  final String habitId;
  final int previousStreak;

  const RestartPledgeScreen({
    super.key,
    required this.habitId,
    this.previousStreak = 0,
  });

  @override
  ConsumerState<RestartPledgeScreen> createState() =>
      _RestartPledgeScreenState();
}

class _RestartPledgeScreenState extends ConsumerState<RestartPledgeScreen> {
  final _pledgeController = TextEditingController(
    text: 'Bugün kendim için yeniden başlıyorum.',
  );
  final _reflectionController = TextEditingController();
  final Set<String> _selectedTriggers = {'Stres'};

  final List<String> _triggers = [
    'Stres',
    'Sosyal Ortam',
    'Yorgunluk',
    'Can Sıkıntısı',
    'Öfke / Kaygı',
    'Dürtüye Teslim Olma',
  ];

  @override
  void dispose() {
    _pledgeController.dispose();
    _reflectionController.dispose();
    super.dispose();
  }

  Future<void> _commitRestart() async {
    final pledgeText = _pledgeController.text.trim().isEmpty
        ? 'Bugün kendim için yeniden başlıyorum.'
        : _pledgeController.text.trim();

    await ref
        .read(habitsListProvider.notifier)
        .restartWithPledge(
          habitId: widget.habitId,
          pledgeText: pledgeText,
          reflection: _reflectionController.text.trim().isEmpty
              ? null
              : _reflectionController.text.trim(),
          previousStreakDays: widget.previousStreak,
        );

    // Yeniden başlama rozetini ver (Section 17)
    final badgeRepo = ref.read(badgeRepositoryProvider);
    await badgeRepo.awardBadge('restarted');
    ref.invalidate(earnedBadgesProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Yeniden başlama sözün kaydedildi. Yeni serin başladı!',
          ),
          backgroundColor: AppColors.restart,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Yeniden Başlama'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Geri',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/habit/${widget.habitId}');
            }
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Turuncu Kırık Halka Görseli
            Center(
              child: StreakRing(
                size: 110,
                progress: 0.0,
                strokeColor: AppColors.restart,
                strokeWidth: 8,
                isBroken: true,
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 44,
                  color: AppColors.restart,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Empatik Başlık ve Mesaj
            const Text(
              'Bir an, bütün yolculuğu silmez.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.previousStreak > 0
                  ? '${widget.previousStreak} gün boyunca harika bir irade gösterdin. Bu emek kaybolmadı, kayıtlarda korundu.'
                  : 'Ne olduğunu fark etmek yeniden başlamanın en güçlü adımıdır.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Yansıtma: Ne tetikledi?
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.roundedLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ne olduğunu fark edelim:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _triggers.map((tag) {
                      final isSelected = _selectedTriggers.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        selectedColor: AppColors.restart.withOpacity(0.2),
                        checkmarkColor: AppColors.restart,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTriggers.add(tag);
                            } else {
                              _selectedTriggers.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _reflectionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Bir sonraki benzer an için notun:',
                      hintText: 'Bir dahaki sefere ne yapabilirsin?',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Söz Verme Alanı
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.roundedLg,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kendine Söz Ver:',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _pledgeController,
                    decoration: const InputDecoration(labelText: 'Söz Metni'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Aksiyon Butonları
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.restart,
                foregroundColor: AppColors.textOnBright,
                minimumSize: const Size(double.infinity, 54),
              ),
              onPressed: _commitRestart,
              icon: const Icon(Icons.handshake_rounded),
              label: const Text(
                'Söz Ver ve Yeniden Başla',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Şimdilik Kapat'),
            ),
          ],
        ),
      ),
    );
  }
}
