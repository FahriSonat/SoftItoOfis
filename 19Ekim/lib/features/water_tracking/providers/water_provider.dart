import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/features/water_tracking/models/water_entry.dart';

class WaterState {
  final int dailyGoalMl;
  final List<WaterEntry> entries;

  const WaterState({
    this.dailyGoalMl = AppConstants.defaultDailyWaterMl,
    this.entries = const [],
  });

  int get currentAmountMl =>
      entries.fold(0, (sum, item) => sum + item.amountMl);

  double get progressPercentage {
    if (dailyGoalMl == 0) return 0.0;
    final progress = currentAmountMl / dailyGoalMl;
    return progress > 1.0 ? 1.0 : progress;
  }

  int get remainingMl {
    final diff = dailyGoalMl - currentAmountMl;
    return diff > 0 ? diff : 0;
  }

  WaterState copyWith({
    int? dailyGoalMl,
    List<WaterEntry>? entries,
  }) {
    return WaterState(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      entries: entries ?? this.entries,
    );
  }
}

class WaterNotifier extends Notifier<WaterState> {
  @override
  WaterState build() {
    return const WaterState();
  }

  void addWater(int amountMl) {
    final newEntry = WaterEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      entries: [newEntry, ...state.entries],
    );
  }

  void removeEntry(String id) {
    state = state.copyWith(
      entries: state.entries.where((e) => e.id != id).toList(),
    );
  }

  void updateDailyGoal(int newGoalMl) {
    state = state.copyWith(dailyGoalMl: newGoalMl);
  }

  void resetDaily() {
    state = state.copyWith(entries: const []);
  }
}

final waterProvider = NotifierProvider<WaterNotifier, WaterState>(WaterNotifier.new);
