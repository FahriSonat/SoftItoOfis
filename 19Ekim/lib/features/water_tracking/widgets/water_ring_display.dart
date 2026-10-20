import 'package:flutter/material.dart';
import 'package:susadim/core/theme/app_theme.dart';
import 'package:susadim/core/utils/formatters.dart';

class WaterRingDisplay extends StatelessWidget {
  final int currentAmountMl;
  final int dailyGoalMl;
  final double progress;

  const WaterRingDisplay({
    super.key,
    required this.currentAmountMl,
    required this.dailyGoalMl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arka plan parlaması (Glow Effect)
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(40),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Halka İlerleme Çubuğu
          SizedBox(
            width: 210,
            height: 210,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 16,
              strokeCap: StrokeCap.round,
              backgroundColor: AppColors.surfaceLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          // İç Metinler
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.water_drop_rounded,
                color: AppColors.primary,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                Formatters.formatWater(currentAmountMl),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hedef: ${Formatters.formatWater(dailyGoalMl)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '%${(progress * 100).toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
