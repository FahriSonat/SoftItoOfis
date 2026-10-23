import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../habits/domain/habit.dart';
import '../../habits/presentation/providers/habit_providers.dart';
import '../../journal/domain/trigger_note.dart';

class UrgeSupportScreen extends ConsumerStatefulWidget {
  final String habitId;
  const UrgeSupportScreen({super.key, required this.habitId});

  @override
  ConsumerState<UrgeSupportScreen> createState() => _UrgeSupportScreenState();
}

class _UrgeSupportScreenState extends ConsumerState<UrgeSupportScreen> {
  int _step =
      0; // 0: Dur & Zamanlayıcı, 1: Küçük Eylem, 2: Değerlendir & Kaydet
  Timer? _timer;
  DateTime? _timerEndTime;
  int _secondsLeft = 120; // Varsayılan 2 dakika

  // Değerlendirme durumları
  final int _intensityBefore = 4;
  int _intensityAfter = 2;
  final _noteController = TextEditingController();
  final Set<String> _selectedTriggers = {'Stres'};

  final List<String> _triggerOptions = [
    'Stres',
    'Can Sıkıntısı',
    'Sosyal Baskı',
    'Yalnızlık',
    'Öfke',
    'Alışkanlık Anı',
    'Yorgunluk',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _secondsLeft = minutes * 60;
    _timerEndTime = DateTime.now().add(Duration(minutes: minutes));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerEndTime == null) return;
      final remaining = _timerEndTime!.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _step = 1; // Küçük eyleme geç
        });
      } else {
        setState(() {
          _secondsLeft = remaining;
        });
      }
    });
  }

  Future<void> _saveJournalAndFinish(Habit habit) async {
    final note = TriggerNote(
      id: const Uuid().v4(),
      habitId: habit.id,
      occurredAt: DateTime.now(),
      triggerTags: _selectedTriggers.toList(),
      intensityBefore: _intensityBefore,
      intensityAfter: _intensityAfter,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final journalRepo = ref.read(journalRepositoryProvider);
    await journalRepo.addNote(note);
    ref.invalidate(triggerNotesProvider(habit.id));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Zorlanma anını başarıyla atlattın ve kaydettin. Tebrikler!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitDetailAsync = ref.watch(habitDetailProvider(widget.habitId));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: const Text('Zorlanıyorum (Odak Modu)'),
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

      body: habitDetailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (detail) {
          final habit = detail?.habit;
          if (habit == null) return const Center(child: Text('Bulunamadı'));

          final isSensitiveCategory =
              habit.category == HabitCategory.alcohol ||
              habit.category == HabitCategory.gambling ||
              habit.category == HabitCategory.medication;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Adım Göstergesi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _stepCircle(0, '1. Dur'),
                    _stepDivider(),
                    _stepCircle(1, '2. Eylem'),
                    _stepDivider(),
                    _stepCircle(2, '3. Değerlendir'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Hassas Kategoriler için Profesyonel Destek Kartı
                if (isSensitiveCategory) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh,
                      borderRadius: AppSpacing.roundedMd,
                      border: Border.all(
                        color: AppColors.info.withOpacity(0.4),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.support_agent_rounded,
                          color: AppColors.info,
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            'Ücretsiz ve gizli destek için ALO 191 veya YEDAM 115 danışma hattını arayabilirsin.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Adım 0: Dur & Zamanlayıcı
                if (_step == 0) ...[
                  const Text(
                    'Bu dürtü geçici.\nÖnce iki dakika kendine alan açalım.',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Geri Sayım Çemberi
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.restart, width: 4),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(_secondsLeft ~/ 60).toString().padLeft(2, '0')}:${(_secondsLeft % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: AppColors.restart,
                            ),
                          ),
                          const Text(
                            'Kalan Süre',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionChip(
                        label: const Text('2 Dakika'),
                        onPressed: () => _startTimer(2),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ActionChip(
                        label: const Text('5 Dakika'),
                        onPressed: () => _startTimer(5),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ActionChip(
                        label: const Text('10 Dakika'),
                        onPressed: () => _startTimer(10),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FilledButton(
                    onPressed: () => setState(() => _step = 1),
                    child: const Text('Süre Doldu / Eyleme Geç'),
                  ),
                ],

                // Adım 1: Küçük Eylem
                if (_step == 1) ...[
                  const Text(
                    'Şimdi dikkatini dağıtacak küçük bir eylem yapalım.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _actionOptionCard(
                    icon: Icons.air_rounded,
                    title: '2 Dakika Derin Nefes',
                    desc: '4 saniye nefes al, 4 saniye tut, 4 saniye ver.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _actionOptionCard(
                    icon: Icons.water_drop_outlined,
                    title: 'Bir Bardak Soğuk Su İç',
                    desc: 'Yavaşça bir bardak su içerek ana dön.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _actionOptionCard(
                    icon: Icons.directions_walk_rounded,
                    title: 'Ortamı Değiştir',
                    desc: 'Odayı değiştir veya balkona çıkıp temiz hava al.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FilledButton(
                    onPressed: () => setState(() => _step = 2),
                    child: const Text('Eylemi Yaptım, Değerlendir'),
                  ),
                ],

                // Adım 2: Değerlendir & Kaydet
                if (_step == 2) ...[
                  const Text(
                    'Dürtü şimdi ne kadar güçlü?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Önceki Yoğunluk: $_intensityBefore / 5',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Şimdiki Yoğunluk: $_intensityAfter / 5',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Slider(
                    value: _intensityAfter.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '$_intensityAfter',
                    onChanged: (val) =>
                        setState(() => _intensityAfter = val.toInt()),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text(
                    'Seni ne tetikledi?',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _triggerOptions.map((tag) {
                      final isSelected = _selectedTriggers.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
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
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Kısa Not (İsteğe bağlı)',
                      hintText: 'Nasıl hissettin, ne yardımcı oldu?',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                    onPressed: () => _saveJournalAndFinish(habit),
                    child: const Text('Zorlanmayı Günlüğe Kaydet ve Kapat'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stepCircle(int index, String label) {
    final isActive = _step >= index;
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.positiveStages.first
                : AppColors.surfaceHigh,
          ),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider() {
    return Container(
      width: 32,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      color: AppColors.borderSubtle,
    );
  }

  Widget _actionOptionCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, size: 32, color: AppColors.info),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
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
