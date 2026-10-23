import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../domain/habit.dart';
import 'providers/habit_providers.dart';

class HabitWizardScreen extends ConsumerStatefulWidget {
  final String? initialKind;
  const HabitWizardScreen({super.key, this.initialKind});

  @override
  ConsumerState<HabitWizardScreen> createState() => _HabitWizardScreenState();
}

class _HabitWizardScreenState extends ConsumerState<HabitWizardScreen> {
  int _currentStep = 0;
  late HabitKind _kind;
  HabitCategory _category = HabitCategory.water;
  final _nameController = TextEditingController();
  final _targetValueController = TextEditingController(text: '2000');
  final _unitController = TextEditingController(text: 'ml');
  final _costController = TextEditingController(text: '75');
  ScheduleType _scheduleType = ScheduleType.daily;
  Set<int> _selectedDays = {1, 2, 3, 4, 5};
  int _weeklyTargetCount = 3;
  bool _privacyMode = false;
  final DateTime _startAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind == 'negative'
        ? HabitKind.negative
        : HabitKind.positive;
    _category = _kind.isNegative ? HabitCategory.smoking : HabitCategory.water;
    _nameController.text = _category.title;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetValueController.dispose();
    _unitController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _onCategorySelected(HabitCategory cat) {
    setState(() {
      _category = cat;
      _nameController.text = cat.title;
      if (cat == HabitCategory.water) {
        _targetValueController.text = '2000';
        _unitController.text = 'ml';
      } else if (cat == HabitCategory.reading) {
        _targetValueController.text = '20';
        _unitController.text = 'sayfa';
      } else if (cat == HabitCategory.walking || cat == HabitCategory.running) {
        _targetValueController.text = '5';
        _unitController.text = 'km';
      } else if (cat == HabitCategory.fitness || cat == HabitCategory.yoga) {
        _targetValueController.text = '30';
        _unitController.text = 'dk';
      }
    });
  }

  Future<void> _submit() async {
    final habitId = const Uuid().v4();
    final now = DateTime.now();

    final targetVal = double.tryParse(_targetValueController.text) ?? 1.0;
    final costVal = double.tryParse(_costController.text);

    final habit = Habit(
      id: habitId,
      userId: 'default_user',
      name: _nameController.text.trim().isEmpty
          ? _category.title
          : _nameController.text.trim(),
      kind: _kind,
      category: _category,
      iconKey: _category.iconKey,
      startAt: _startAt,
      measurementType: _kind.isNegative
          ? MeasurementType.boolean
          : MeasurementType.count,
      targetValue: targetVal,
      unit: _unitController.text.trim(),
      scheduleType: _scheduleType,
      scheduleDays: _selectedDays.isEmpty
          ? const [1, 2, 3, 4, 5, 6, 7]
          : (_selectedDays.toList()..sort()),
      weeklyTargetCount: _weeklyTargetCount,
      unitCost: costVal,
      privacyMode: _privacyMode,
      createdAt: now,
      updatedAt: now,
    );

    await ref.read(habitsListProvider.notifier).addHabit(habit);
    if (mounted) {
      context.go('/habit/$habitId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Geri',
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            }
          },
        ),
        title: Text(
          'Yeni ${_kind.isNegative ? 'Uzak Durma Hedefi' : 'Alışkanlık'}',
        ),
      ),

      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep++);
          } else {
            _submit();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          final isLast = _currentStep == 3;
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xl),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: details.onStepContinue,
                    child: Text(isLast ? 'Oluştur ve Başla' : 'Devam Et'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Geri'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          // Adım 1: Tür Seçimi
          Step(
            title: const Text('Hedef Türü'),
            isActive: _currentStep >= 0,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SegmentedButton<HabitKind>(
                  segments: const [
                    ButtonSegment(
                      value: HabitKind.positive,
                      label: Text('Pozitif Alışkanlık'),
                      icon: Icon(Icons.star_rounded),
                    ),
                    ButtonSegment(
                      value: HabitKind.negative,
                      label: Text('Uzak Durma'),
                      icon: Icon(Icons.shield_rounded),
                    ),
                  ],
                  selected: {_kind},
                  onSelectionChanged: (set) {
                    setState(() {
                      _kind = set.first;
                      _category = _kind.isNegative
                          ? HabitCategory.smoking
                          : HabitCategory.water;
                      _nameController.text = _category.title;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _kind.isNegative
                      ? 'Sigara, alkol veya sağlıksız bir davranışı geride bırakmak için gerçek zamanlı sayaç başlat.'
                      : 'Su içme, spor, kitap gibi hayatına değer katacak sürdürülebilir bir alışkanlık kazan.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Adım 2: Kategori & İsim
          Step(
            title: const Text('Kategori ve Başlık'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Önerilen Kategoriler:',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: HabitCategory.values
                      .where((c) => c.kind == _kind)
                      .map((cat) {
                        final isSelected = _category == cat;
                        return ChoiceChip(
                          label: Text(cat.title),
                          selected: isSelected,
                          onSelected: (_) => _onCategorySelected(cat),
                          selectedColor: _kind.isNegative
                              ? AppColors.negativeStages.first.withOpacity(0.3)
                              : AppColors.positiveStages.first.withOpacity(0.3),
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Alışkanlık Adı',
                    hintText: 'Örn: Günlük Su Hedefi',
                  ),
                ),
              ],
            ),
          ),

          // Adım 3: Hedef / Maliyet
          Step(
            title: Text(
              _kind.isNegative ? 'Zaman ve Maliyet' : 'Hedef ve Sıklık',
            ),
            isActive: _currentStep >= 2,
            content: _kind.isNegative
                ? Column(
                    children: [
                      TextField(
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Günlük Tahmini Maliyet (TL)',
                          hintText: 'Örn: 75',
                          suffixText: 'TL / gün',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'Bu bilgi ne kadar tasarruf ettiğinizi hesaplamak için kullanılır.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _targetValueController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Hedef Miktar',
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _unitController,
                              decoration: const InputDecoration(
                                labelText: 'Birim',
                                hintText: 'ml, sayfa',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DropdownButtonFormField<ScheduleType>(
                        value: _scheduleType,
                        decoration: const InputDecoration(labelText: 'Sıklık'),
                        items: ScheduleType.values.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s.label),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _scheduleType = val);
                        },
                      ),
                      if (_scheduleType == ScheduleType.selectedDays) ...[
                        const SizedBox(height: AppSpacing.md),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Uygulanacak Günleri Seçin',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${_selectedDays.length} gün seçili',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ActionChip(
                                    label: const Text(
                                      'Hafta İçi',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDays = {1, 2, 3, 4, 5};
                                      });
                                    },
                                  ),
                                  ActionChip(
                                    label: const Text(
                                      'Hafta Sonu',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDays = {6, 7};
                                      });
                                    },
                                  ),
                                  ActionChip(
                                    label: const Text(
                                      'Tüm Günler',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedDays = {1, 2, 3, 4, 5, 6, 7};
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _dayToggleButton(1, 'Pzt'),
                                  _dayToggleButton(2, 'Sal'),
                                  _dayToggleButton(3, 'Çar'),
                                  _dayToggleButton(4, 'Per'),
                                  _dayToggleButton(5, 'Cum'),
                                  _dayToggleButton(6, 'Cmt'),
                                  _dayToggleButton(7, 'Paz'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Seçili olmayan günlerde serin bozulmaz veya sıfırlanmaz.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_scheduleType == ScheduleType.weeklyFrequency) ...[
                        const SizedBox(height: AppSpacing.md),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Haftalık Hedef Sayısı',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Haftada $_weeklyTargetCount gün',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.info,
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _weeklyTargetCount.toDouble(),
                                min: 1,
                                max: 7,
                                divisions: 6,
                                label: '$_weeklyTargetCount gün',
                                onChanged: (val) {
                                  setState(() {
                                    _weeklyTargetCount = val.round();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
          ),

          // Adım 4: Hatırlatma ve Gizlilik
          Step(
            title: const Text('Gizlilik ve Bildirim'),
            isActive: _currentStep >= 3,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Gizli / Nötr Bildirimler'),
                  subtitle: const Text(
                    'Kilit ekranında alışkanlığın adı yerine "Kendin için ayırdığın küçük zamanı hatırla" şeklinde nötr metin göster.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  value: _privacyMode,
                  onChanged: (val) => setState(() => _privacyMode = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dayToggleButton(int dayIndex, String label) {
    final isSelected = _selectedDays.contains(dayIndex);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            if (_selectedDays.length > 1) {
              _selectedDays.remove(dayIndex);
            }
          } else {
            _selectedDays.add(dayIndex);
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.positiveStages[2]
              : AppColors.surfaceHigh,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.borderSubtle,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? AppColors.textOnBright
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
