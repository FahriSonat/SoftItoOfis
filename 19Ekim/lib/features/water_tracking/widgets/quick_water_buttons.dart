import 'package:flutter/material.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/core/theme/app_theme.dart';

class QuickWaterButtons extends StatelessWidget {
  final ValueChanged<int> onAmountSelected;

  const QuickWaterButtons({
    super.key,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AppConstants.quickWaterAmounts.map((amount) {
        return _QuickAddChip(
          amount: amount,
          onTap: () => onAmountSelected(amount),
        );
      }).toList(),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const _QuickAddChip({
    required this.amount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(height: 6),
              Text(
                '$amount ml',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
