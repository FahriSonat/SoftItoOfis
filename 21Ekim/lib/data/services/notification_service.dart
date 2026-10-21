import '../models/budget.dart';
import '../models/recurring_payment.dart';
import '../models/debt.dart';
import '../models/user_settings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';

enum AppNotificationType { info, warning, critical, success }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final AppNotificationType type;
  final String targetScreen;
  final DateTime date;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.targetScreen,
    required this.date,
    this.isRead = false,
  });
}

class NotificationService {
  NotificationService._();

  /// Evaluates and generates all in-app notifications and reminders
  static List<AppNotification> evaluateNotifications({
    required int monthlyExpenseMinor,
    required int monthlyLimitMinor,
    required double alertThreshold,
    required List<Budget> budgets,
    required List<RecurringPayment> recurringPayments,
    required List<Debt> debts,
    required UserSettings settings,
  }) {
    final List<AppNotification> list = [];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Budget limits evaluation
    if (monthlyLimitMinor > 0) {
      final double ratio = monthlyExpenseMinor / monthlyLimitMinor;
      if (ratio >= 1.0) {
        final over = monthlyExpenseMinor - monthlyLimitMinor;
        list.add(AppNotification(
          id: 'limit-exceeded',
          title: 'Aylık Harcama Limiti Aşıldı!',
          message: 'Aylık bütçeniz ${CurrencyFormatter.format(over)} tutarında aşıldı. Harcamalarınızı gözden geçirin.',
          type: AppNotificationType.critical,
          targetScreen: 'budget',
          date: now,
        ));
      } else if (ratio >= alertThreshold) {
        final pct = (ratio * 100).toInt();
        list.add(AppNotification(
          id: 'limit-warning',
          title: 'Aylık Limit Eşiğine Yaklaşıldı',
          message: 'Aylık bütçenizin %$pct oranını kullandınız (${CurrencyFormatter.format(monthlyExpenseMinor)}).',
          type: AppNotificationType.warning,
          targetScreen: 'budget',
          date: now,
        ));
      }
    }

    // 2. Upcoming bills / recurring payments
    for (final bill in recurringPayments) {
      if (!bill.isPaidThisPeriod) {
        final billDate = DateTime(bill.dueDate.year, bill.dueDate.month, bill.dueDate.day);
        final diffDays = billDate.difference(today).inDays;

        if (diffDays == 0) {
          list.add(AppNotification(
            id: 'bill-${bill.id}',
            title: 'Fatura Ödeme Günü: ${bill.title}',
            message: '${bill.title} için bugün son ödeme günü.${bill.expectedAmountMinor != null ? " Tutar: ${CurrencyFormatter.format(bill.expectedAmountMinor!)}" : ""}',
            type: AppNotificationType.critical,
            targetScreen: 'recurring',
            date: now,
          ));
        } else if (diffDays > 0 && diffDays <= 3) {
          list.add(AppNotification(
            id: 'bill-upcoming-${bill.id}',
            title: 'Yaklaşan Fatura: ${bill.title}',
            message: '${bill.title} faturanızın vadesine $diffDays gün kaldı (${DateFormatter.formatShort(bill.dueDate)}).',
            type: AppNotificationType.warning,
            targetScreen: 'recurring',
            date: now,
          ));
        }
      }
    }

    // 3. Debts (lent and borrowed) reminders
    for (final debt in debts) {
      if (!debt.isSettled && debt.dueDate != null) {
        final dueDate = DateTime(debt.dueDate!.year, debt.dueDate!.month, debt.dueDate!.day);
        final diffDays = dueDate.difference(today).inDays;

        if (debt.isBorrowed) {
          // Borrowed debt (kullanıcı ödeyecek)
          if (diffDays <= 7 && diffDays > 0) {
            list.add(AppNotification(
              id: 'debt-borrowed-${debt.id}',
              title: 'Borç Vadesi Yaklaşıyor',
              message: '${debt.counterparty} borcunun vadesine $diffDays gün kaldı (${CurrencyFormatter.format(debt.remainingMinor)}).',
              type: diffDays <= 2 ? AppNotificationType.critical : AppNotificationType.warning,
              targetScreen: 'debts',
              date: now,
            ));
          } else if (diffDays == 0) {
            list.add(AppNotification(
              id: 'debt-borrowed-today-${debt.id}',
              title: 'Borç Ödeme Günü!',
              message: '${debt.counterparty} borcunuzun ödeme günü bugün! (${CurrencyFormatter.format(debt.remainingMinor)}).',
              type: AppNotificationType.critical,
              targetScreen: 'debts',
              date: now,
            ));
          }
        } else {
          // Lent debt (kullanıcı tahsil edecek)
          if (diffDays == 0) {
            list.add(AppNotification(
              id: 'debt-lent-today-${debt.id}',
              title: 'Verilen Borç Tahsilat Günü',
              message: '${debt.counterparty} kişisinden ${CurrencyFormatter.format(debt.remainingMinor)} tahsilat vadesi bugün.',
              type: AppNotificationType.info,
              targetScreen: 'debts',
              date: now,
            ));
          }
        }
      }
    }

    // 4. Salary day and 3-day post-salary reminders
    final salaryDay = settings.salaryDay;
    if (now.day == salaryDay) {
      list.add(AppNotification(
        id: 'salary-day',
        title: 'Maaş Günü Hatırlatması',
        message: 'Maaş gününüz kutlu olsun! Planlı ödemelerinizi ve borç taksitlerinizi gerçekleştirmeyi unutmayın.',
        type: AppNotificationType.info,
        targetScreen: 'home',
        date: now,
      ));
    } else if (now.day > salaryDay && now.day <= salaryDay + 3) {
      list.add(AppNotification(
        id: 'post-salary-window',
        title: 'Maaş Sonrası Ödeme Penceresi',
        message: 'Maaş sonrası ilk 3 gün içindesiniz. Kredi kartı ve borç taksitlerinizi tamamlayarak gecikme faizini önleyin.',
        type: AppNotificationType.warning,
        targetScreen: 'debts',
        date: now,
      ));
    }

    // 5. Month-end Excel report ready
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    if (now.day == lastDayOfMonth) {
      list.add(AppNotification(
        id: 'month-end-excel',
        title: 'Aylık Excel Raporu Hazır',
        message: '${DateFormatter.formatMonthYear(now)} dönemi harcama ve bütçe raporunuz Excel formatında indirilmeye hazır.',
        type: AppNotificationType.success,
        targetScreen: 'reports',
        date: now,
      ));
    }

    return list;
  }
}
