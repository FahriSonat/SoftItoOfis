import '../../features/habits/domain/habit.dart';

abstract class NotificationScheduler {
  Future<void> scheduleHabitReminder(
    Habit habit,
    String timeOfDay, {
    bool neutralText = false,
  });
  Future<void> cancelHabitReminders(String habitId);
  Future<void> cancelAll();
  Future<bool> requestPermissions();
}

class LocalNotificationScheduler implements NotificationScheduler {
  final bool _permissionGranted = true;

  @override
  Future<bool> requestPermissions() async {
    // Mobil izin diyalogu simülasyonu / adaptörü
    return _permissionGranted;
  }

  @override
  Future<void> scheduleHabitReminder(
    Habit habit,
    String timeOfDay, {
    bool neutralText = false,
  }) async {
    // Sessiz saatler veya nötr bildirim metni:
    // Eğer habit.privacyMode ise nötr metin:
    // "Kendin için ayırdığın küçük zamanı hatırla."
  }

  @override
  Future<void> cancelHabitReminders(String habitId) async {
    // Alışkanlık hatırlatıcılarını iptal et
  }

  @override
  Future<void> cancelAll() async {}
}
