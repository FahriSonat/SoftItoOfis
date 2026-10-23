import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/streak_ring.dart';
import '../domain/habit.dart';
import '../domain/habit_entry.dart';
import '../../streaks/domain/streak_engine.dart';
import 'providers/habit_providers.dart';

class HabitDetailScreen extends ConsumerStatefulWidget {
  final String habitId;
  const HabitDetailScreen({super.key, required this.habitId});

  @override
  ConsumerState<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends ConsumerState<HabitDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddPositiveEntryDialog(BuildContext context, Habit habit) {
    final controller = TextEditingController(
      text: habit.targetValue.toString(),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${habit.name} İlerlemesi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Miktar (${habit.unit})',
                suffixText: habit.unit,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () {
              final val = double.tryParse(controller.text) ?? 1.0;
              ref
                  .read(habitsListProvider.notifier)
                  .addEntry(
                    habitId: habit.id,
                    value: val,
                    note: 'Kayıt eklendi',
                  );
              Navigator.pop(ctx);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  void _confirmBreakStreak(
    BuildContext context,
    Habit habit,
    StreakResult streak,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Seriyi Bozdum'),
        content: const Text(
          'Bir an bütün yolculuğunu silmez. Bu durumu fark etmek yeniden başlamanın ilk adımıdır.\n\nKırılma kaydını oluşturup yeni bir başlangıç için söz vermek ister misin?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.restart),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(habitsListProvider.notifier)
                  .breakNegativeStreak(
                    habitId: habit.id,
                    note: 'Kullanıcı kırılma bildirdi',
                  );
              if (context.mounted) {
                context.push(
                  '/habit/${habit.id}/restart?previousStreak=${streak.value}',
                );
              }
            },
            child: const Text('Evet, Yeniden Başlayalım'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(habitDetailProvider(widget.habitId));

    return detailAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Hata: $err'))),
      data: (detail) {
        if (detail == null) {
          return const Scaffold(
            body: Center(child: Text('Alışkanlık bulunamadı')),
          );
        }

        final habit = detail.habit;
        final streak = detail.streak;
        final isBroken = streak.status == StreakStatus.broken;

        Color stageColor;
        if (isBroken) {
          stageColor = AppColors.restart;
        } else if (habit.kind.isNegative) {
          final idx = streak.colorStage.clamp(
            0,
            AppColors.negativeStages.length - 1,
          );
          stageColor = AppColors.negativeStages[idx];
        } else {
          final idx = streak.colorStage.clamp(
            0,
            AppColors.positiveStages.length - 1,
          );
          stageColor = AppColors.positiveStages[idx];
        }

        return Scaffold(
          backgroundColor: isBroken ? const Color(0xFF1D1208) : AppColors.canvas,
          appBar: AppBar(
            backgroundColor: isBroken
                ? AppColors.restart.withValues(alpha: 0.35)
                : AppColors.surface,
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
            title: Text(habit.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.psychology, color: AppColors.info),
                tooltip: 'Denge Koçuna Danış',
                onPressed: () {
                  context.push(
                    '/ai-coach?habit=${Uri.encodeComponent(habit.name)}',
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'break') {
                    _confirmBreakStreak(context, habit, streak);
                  } else if (val == 'delete') {
                    ref.read(habitsListProvider.notifier).deleteHabit(habit.id);
                    context.pop();
                  }
                },
                itemBuilder: (ctx) => [
                  if (habit.kind.isNegative && !isBroken)
                    const PopupMenuItem(
                      value: 'break',
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: AppColors.restart,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Seriyi Bozdum',
                            style: TextStyle(color: AppColors.restart),
                          ),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.danger,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Alışkanlığı Sil',
                          style: TextStyle(color: AppColors.danger),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Zincir kırıldıysa turuncu acil uyarı bandı
              if (isBroken)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: AppColors.restart,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.link_off_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ZİNCİR KIRILDI',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '24 saatlik ek süre içinde giriş yapılmadığı için zincir bozuldu.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // 24 saatlik Kurtarma Süresi & Loading Bar Kartı
              if (streak.isInGracePeriod)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.restart.withValues(alpha: 0.15),
                    borderRadius: AppSpacing.roundedMd,
                    border: Border.all(color: AppColors.restart, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.hourglass_top_rounded,
                            color: AppColors.restart,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Zincir Tehlikede! Ekstra 24 Saat Süre',
                              style: TextStyle(
                                color: AppColors.restart,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.restart,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${streak.gracePeriodRemaining?.inHours ?? 0}s ${((streak.gracePeriodRemaining?.inMinutes ?? 0) % 60)}dk kaldı',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '24 saat içinde giriş yapılmadığı için kurtarma süresi başladı. Bu süre dolmadan giriş yapmazsan zincir kırılacak ve sıfırlanacak!',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: streak.gracePeriodProgress,
                          minHeight: 10,
                          backgroundColor: AppColors.surfaceHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.restart,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.restart,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              _showAddPositiveEntryDialog(context, habit),
                          icon: const Icon(Icons.flash_on_rounded, size: 18),
                          label: const Text('Zinciri Kurtar ve Giriş Yap'),
                        ),
                      ),
                    ],
                  ),
                ),

              // Kahraman Alanı (Hero Area)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                  horizontal: AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: isBroken
                      ? AppColors.restart.withValues(alpha: 0.18)
                      : (streak.isInGracePeriod
                            ? AppColors.restart.withValues(alpha: 0.08)
                            : AppColors.surface),
                  border: isBroken
                      ? Border.all(color: AppColors.restart, width: 2)
                      : (streak.isInGracePeriod
                            ? Border.all(
                                color: AppColors.restart.withValues(alpha: 0.4),
                              )
                            : null),
                ),
                child: Column(
                  children: [
                    StreakRing(
                      size: 160,
                      strokeWidth: 10,
                      progress: habit.kind.isNegative
                          ? (isBroken ? 0.0 : (streak.colorStage + 1) / 6)
                          : streak.currentProgress,
                      strokeColor: stageColor,
                      isBroken: isBroken,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isBroken ? '0' : '${streak.value}',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: isBroken
                                  ? AppColors.restart
                                  : AppColors.textPrimary,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            streak.unit == StreakUnit.hours
                                ? 'saat'
                                : (streak.unit == StreakUnit.days
                                      ? 'gün'
                                      : 'periyot'),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Aşama etiketi
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: stageColor.withOpacity(0.15),
                        borderRadius: AppSpacing.roundedSm,
                        border: Border.all(color: stageColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        streak.stageLabel,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: stageColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Ana Aksiyon Butonu
                    if (isBroken)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.restart,
                        ),
                        onPressed: () => context.push(
                          '/habit/${habit.id}/restart?previousStreak=${streak.longestStreak}',
                        ),
                        icon: const Icon(Icons.handshake_rounded),
                        label: const Text('Söz Ver ve Yeniden Başla'),
                      )
                    else if (habit.kind.isNegative)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.surfaceHigh,
                          foregroundColor: AppColors.restart,
                        ),
                        onPressed: () =>
                            context.push('/habit/${habit.id}/urge-support'),
                        icon: const Icon(Icons.timer_outlined),
                        label: const Text('Zorlanıyorum (Odak Modu)'),
                      )
                    else
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: stageColor,
                        ),
                        onPressed: () =>
                            _showAddPositiveEntryDialog(context, habit),
                        icon: const Icon(Icons.add_task_rounded),
                        label: Text(
                          streak.status == StreakStatus.completedToday
                              ? 'Bugün Tamamlandı ✓'
                              : 'İlerleme Kaydet',
                        ),
                      ),
                  ],
                ),
              ),

              // Sekmeler
              TabBar(
                controller: _tabController,
                indicatorColor: stageColor,
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: AppColors.textMuted,
                tabs: const [
                  Tab(text: 'Genel'),
                  Tab(text: 'Geçmiş'),
                  Tab(text: 'Zorlayanlar'),
                  Tab(text: 'Çözümler'),
                ],
              ),

              // Sekme İçerikleri
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _OverviewTab(habit: habit, streak: streak),
                    _HistoryTab(entries: detail.entries),
                    _TriggersTab(habitId: habit.id),
                    _StrategiesTab(habitId: habit.id),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Habit habit;
  final StreakResult streak;

  const _OverviewTab({required this.habit, required this.streak});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Reçeteli İlaç Uyarısı (Etik ve Güvenlik kuralı)
        if (habit.category == HabitCategory.medication)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: AppSpacing.roundedMd,
              border: Border.all(color: AppColors.warning.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Reçeteli bir ilacı bırakmadan veya dozunu değiştirmeden önce lütfen doktoruna ya da eczacına danış.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Neden Başladım? Kişisel Motivasyon Kartı (Section 8)
        _PersonalMotivationCard(habitId: habit.id),
        const SizedBox(height: AppSpacing.lg),

        // Örüntüler ve Tetikleyici Analizi (Section 5)
        if (habit.kind.isNegative) ...[
          _TriggerInsightsCard(habitId: habit.id),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Tahmini Tasarruf: Aktif Seri vs Tarihsel Toplam (Section 7.3)
        if (habit.kind.isNegative && habit.unitCost != null) ...[
          _SavingsOverviewCard(habit: habit, streak: streak),
          const SizedBox(height: AppSpacing.lg),
        ],

        // Pozitif Alışkanlık Planı ve Sıklığı
        if (habit.kind.isPositive) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppSpacing.roundedMd,
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.info,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'Uygulama Planı',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      habit.scheduleType.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ],
                ),
                if (habit.scheduleType == ScheduleType.selectedDays) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 6,
                    children: [
                      _dayBadge('Pzt', habit.scheduleDays.contains(1)),
                      _dayBadge('Sal', habit.scheduleDays.contains(2)),
                      _dayBadge('Çar', habit.scheduleDays.contains(3)),
                      _dayBadge('Per', habit.scheduleDays.contains(4)),
                      _dayBadge('Cum', habit.scheduleDays.contains(5)),
                      _dayBadge('Cmt', habit.scheduleDays.contains(6)),
                      _dayBadge('Paz', habit.scheduleDays.contains(7)),
                    ],
                  ),
                ],
                if (habit.scheduleType == ScheduleType.weeklyFrequency) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Haftada ${habit.weeklyTargetCount} gün hedefleniyor.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],

        // Bilgi Kartları
        Row(
          children: [
            Expanded(
              child: _statCard('En İyi Seri', '${streak.longestStreak} gün'),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _statCard(
                'Başlangıç',
                DateFormat('d MMM yyyy', 'tr_TR').format(habit.startAt),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _dayBadge(String name, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? AppColors.positiveStages[2].withOpacity(0.2)
            : AppColors.surfaceHigh,
        borderRadius: AppSpacing.roundedSm,
        border: Border.all(
          color: active ? AppColors.positiveStages[2] : AppColors.borderSubtle,
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 11,
          fontWeight: active ? FontWeight.w700 : FontWeight.normal,
          color: active ? AppColors.positiveStages[2] : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<HabitEntry> entries;
  const _HistoryTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'Henüz geçmiş kaydı bulunmuyor.',
          style: TextStyle(color: AppColors.textMuted),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: entries.length,
      itemBuilder: (ctx, i) {
        final e = entries[i];
        final isRelapse = e.entryType == EntryType.relapse;
        final dateStr = DateFormat(
          'd MMM yyyy, HH:mm',
          'tr_TR',
        ).format(e.occurredAt);

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(
              isRelapse ? Icons.refresh_rounded : Icons.check_circle_rounded,
              color: isRelapse ? AppColors.restart : AppColors.success,
            ),
            title: Text(isRelapse ? 'Seri Bozuldu' : '+${e.value} ${e.unit}'),
            subtitle: Text(
              e.note ?? dateStr,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            trailing: Text(
              dateStr,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
        );
      },
    );
  }
}

class _TriggersTab extends ConsumerWidget {
  final String habitId;
  const _TriggersTab({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(triggerNotesProvider(habitId));

    return notesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (notes) {
        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Zorlandığın bir an kaydedilmedi.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.tonal(
                  onPressed: () => context.push('/habit/$habitId/urge-support'),
                  child: const Text('Zorlanma Kaydı Ekle'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: notes.length,
          itemBuilder: (ctx, i) {
            final n = notes[i];
            final dateStr = DateFormat(
              'd MMM, HH:mm',
              'tr_TR',
            ).format(n.occurredAt);
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Yoğunluk: ${n.intensityBefore}/5',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.restart,
                          ),
                        ),
                        Text(
                          dateStr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    if (n.triggerTags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        children: n.triggerTags
                            .map(
                              (t) => Chip(
                                label: Text(t),
                                padding: EdgeInsets.zero,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    if (n.note != null && n.note!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        n.note!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _StrategiesTab extends ConsumerWidget {
  final String habitId;
  const _StrategiesTab({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stratsAsync = ref.watch(copingStrategiesProvider(habitId));

    return stratsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (strategies) {
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: strategies.length,
          itemBuilder: (ctx, i) {
            final s = strategies[i];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(
                  Icons.psychology_outlined,
                  color: AppColors.info,
                ),
                title: Text(
                  s.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  s.actionText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Text(
                  '${s.estimatedMinutes} dk',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PersonalMotivationCard extends ConsumerWidget {
  final String habitId;
  const _PersonalMotivationCard({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final motivationAsync = ref.watch(personalMotivationProvider(habitId));

    return motivationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (motivation) {
        if (motivation == null ||
            (motivation.shortReason.isEmpty &&
                (motivation.futureMessage?.isEmpty ?? true))) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.roundedMd,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.flag_outlined, size: 18, color: AppColors.info),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Neden Başladım?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (motivation.shortReason.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  motivation.shortReason,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
              if (motivation.futureMessage != null &&
                  motivation.futureMessage!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Gelecek Mesajım: ${motivation.futureMessage!}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _TriggerInsightsCard extends ConsumerWidget {
  final String habitId;
  const _TriggerInsightsCard({required this.habitId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(triggerInsightsProvider(habitId));

    return insightsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (insights) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppSpacing.roundedMd,
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.auto_graph_rounded,
                    size: 18,
                    color: AppColors.info,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Örüntüler ve Risk Analizi',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (insights.eventsAnalyzed < 3)
                Text(
                  'Örüntü analizi için en az 3 kayıt gerekiyor (Şu an: ${insights.eventsAnalyzed})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                )
              else ...[
                if (insights.topTriggerTag != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'En sık tetikleyici: ${insights.topTriggerTag}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                if (insights.peakHourWindow != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'En riskli saat dilimi: ${insights.peakHourWindow}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                if (insights.peakDayName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      'En riskli gün: ${insights.peakDayName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                if (insights.mostEffectiveStrategy != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Text(
                        'En çok işe yarayan yöntem: ${insights.mostEffectiveStrategy}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SavingsOverviewCard extends ConsumerWidget {
  final Habit habit;
  final StreakResult streak;
  const _SavingsOverviewCard({required this.habit, required this.streak});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savingsAsync = ref.watch(habitSavingsCalculationProvider(habit.id));

    return savingsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
      data: (calc) {
        if (calc == null) return const SizedBox.shrink();

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.roundedMd,
                border: Border.all(color: AppColors.success.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        size: 18,
                        color: AppColors.success,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Aktif Seri Tasarrufu',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kazanılan Para',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            calc.activeMoneySavedFormatted,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Kazanılan Zaman',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            calc.activeTimeSavedHoursFormatted,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppSpacing.roundedMd,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Tarihsel Toplam Tasarruf (Tüm Seriler)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        calc.allTimeMoneySavedFormatted,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        calc.allTimeTimeSavedHoursFormatted,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
