import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Onayla',
    this.cancelText = 'Vazgeç',
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Onayla',
    String cancelText = 'Vazgeç',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      content: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? AppColors.criticalBackground : AppColors.indicatorBlue,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
