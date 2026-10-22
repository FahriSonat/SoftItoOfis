import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../data/services/notification_service.dart';

/// Uygulama içi kritik uyarıları ve bilgilendirmeleri gösteren afiş (Banner) bileşeni.
/// Tasarım kılavuzu kurallarına tam uyumludur:
/// - Uyarı (warning): Sarı zemin üzerinde yüksek kontrastlı siyah metin ve ikon
/// - Kritik (critical): Kırmızı zemin üzerinde beyaz metin ve ikon
/// - Kapatılabilir (dismiss) ve dokunulabilir (onTap) eylemleri destekler.
class AppBanner extends StatelessWidget {
  final String title;
  final String message;
  final AppNotificationType type;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const AppBanner({
    super.key,
    required this.title,
    required this.message,
    this.type = AppNotificationType.warning,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    IconData icon;

    switch (type) {
      case AppNotificationType.warning:
        // Design guide rule: Sarı zemin üzerinde siyah metin ve ikon
        bg = AppColors.warningBackground;
        textColor = AppColors.warningText;
        icon = Icons.warning_amber_rounded;
        break;
      case AppNotificationType.critical:
        // Design guide rule: Kırmızı zemin üzerinde beyaz metin ve ikon
        bg = AppColors.criticalBackground;
        textColor = AppColors.criticalText;
        icon = Icons.error_outline_rounded;
        break;
      case AppNotificationType.info:
        bg = AppColors.surfaceRaised;
        textColor = AppColors.textPrimary;
        icon = Icons.info_outline_rounded;
        break;
      case AppNotificationType.success:
        bg = AppColors.successBackground;
        textColor = AppColors.textPrimary;
        icon = Icons.check_circle_outline_rounded;
        break;
    }

    final Color iconColor = type == AppNotificationType.info
        ? AppColors.indicatorBlue
        : textColor;

    return Semantics(
      label: '$title: $message',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: type == AppNotificationType.info
              ? Border.all(color: AppColors.border, width: 1)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          message,
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDismiss != null)
                    IconButton(
                      icon: Icon(Icons.close, size: 16, color: iconColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDismiss,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
