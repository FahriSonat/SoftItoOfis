abstract class HomeWidgetAdapter {
  Future<void> updateWidgetData({
    required int positiveHabitsCount,
    required int completedTodayCount,
    required int activeNegativeStreaks,
    required bool privacyMode,
  });
}

class LocalHomeWidgetAdapter implements HomeWidgetAdapter {
  @override
  Future<void> updateWidgetData({
    required int positiveHabitsCount,
    required int completedTodayCount,
    required int activeNegativeStreaks,
    required bool privacyMode,
  }) async {
    // Platform widget veri kanalını günceller
  }
}
