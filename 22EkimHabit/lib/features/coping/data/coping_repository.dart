import 'dart:convert';

import '../../../core/database/local_storage.dart';
import '../domain/coping_strategy.dart';

abstract class CopingRepository {
  Future<List<CopingStrategy>> getStrategies(String habitId);
  Future<void> saveStrategy(CopingStrategy strategy);
  Future<void> recordStrategyUsage(String id, double rating);
  Future<void> deleteStrategy(String id);
}

class LocalCopingRepository implements CopingRepository {
  final KeyValueStorage _storage;
  static const String _key = 'denge_coping_strategies';

  LocalCopingRepository(this._storage);

  @override
  Future<List<CopingStrategy>> getStrategies(String habitId) async {
    final all = await _getAll();
    final habitStrategies = all
        .where((s) => s.habitId == habitId || s.habitId == 'global')
        .toList();
    if (habitStrategies.isEmpty) {
      // Varsayılan hazır küçük adımları sağla
      final defaults = _seedDefaults(habitId);
      for (final d in defaults) {
        all.add(d);
      }
      await _saveAll(all);
      return defaults;
    }
    return habitStrategies;
  }

  @override
  Future<void> saveStrategy(CopingStrategy strategy) async {
    final all = await _getAll();
    final index = all.indexWhere((s) => s.id == strategy.id);
    if (index >= 0) {
      all[index] = strategy;
    } else {
      all.add(strategy);
    }
    await _saveAll(all);
  }

  @override
  Future<void> recordStrategyUsage(String id, double rating) async {
    final all = await _getAll();
    final index = all.indexWhere((s) => s.id == id);
    if (index >= 0) {
      final old = all[index];
      final newTimes = old.timesUsed + 1;
      final newScore =
          ((old.effectivenessScore * old.timesUsed) + rating) / newTimes;
      all[index] = old.copyWith(
        timesUsed: newTimes,
        effectivenessScore: double.parse(newScore.toStringAsFixed(1)),
      );
      await _saveAll(all);
    }
  }

  @override
  Future<void> deleteStrategy(String id) async {
    final all = await _getAll();
    all.removeWhere((s) => s.id == id);
    await _saveAll(all);
  }

  Future<List<CopingStrategy>> _getAll() async {
    final raw = await _storage.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CopingStrategy.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAll(List<CopingStrategy> list) async {
    final raw = jsonEncode(list.map((e) => e.toJson()).toList());
    await _storage.setString(_key, raw);
  }

  List<CopingStrategy> _seedDefaults(String habitId) {
    return [
      CopingStrategy(
        id: 'strat_${habitId}_1',
        habitId: habitId,
        title: '2 Dakikalık Nefes Molası',
        actionText:
            'Derin nefes alıp vererek 2 dakika boyunca zihnini sakinleştir.',
        estimatedMinutes: 2,
        triggerTags: ['Stres', 'Dürtü', 'Kaygı'],
        effectivenessScore: 4.8,
        isFavorite: true,
        timesUsed: 3,
      ),
      CopingStrategy(
        id: 'strat_${habitId}_2',
        habitId: habitId,
        title: 'Büyük Bir Bardak Soğuk Su İç',
        actionText:
            'Mutfağa git, yavaşça bir bardak su iç ve dikkatini ana odakla.',
        estimatedMinutes: 2,
        triggerTags: ['Alışkanlık', 'Can sıkıntısı'],
        effectivenessScore: 4.5,
        isFavorite: true,
        timesUsed: 5,
      ),
      CopingStrategy(
        id: 'strat_${habitId}_3',
        habitId: habitId,
        title: 'Odayı veya Ortamı Değiştir',
        actionText:
            'Bulunduğun odadan çık, balkona veya açık havaya 5 dakika adım at.',
        estimatedMinutes: 5,
        triggerTags: ['Ortam', 'Tetikleyici mekan'],
        effectivenessScore: 4.2,
        timesUsed: 2,
      ),
    ];
  }
}
