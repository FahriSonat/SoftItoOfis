import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SemicircularGauge extends StatelessWidget {
  final double progress; // 0.0 to 1.0 (capped at 1.0 for arc)
  final double actualRatio; // actual ratio (can be > 1.0 for over-budget)
  final String periodLabel; // "Aylık", "Haftalık", "Günlük"
  final String centerValue; // e.g. "%64"
  final String subCaption; // e.g. "₺12.450,00 kaldı" or "₺2.100,00 aşıldı"
  final bool hasBudget;
  final double strokeWidth;
  final double size;

  const SemicircularGauge({
    super.key,
    required this.progress,
    required this.actualRatio,
    required this.periodLabel,
    required this.centerValue,
    required this.subCaption,
    this.hasBudget = true,
    this.strokeWidth = 12.0,
    this.size = 220.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasBudget) {
      return Semantics(
        label: '$periodLabel: Henüz bütçe belirlenmedi',
        child: SizedBox(
          width: size,
          height: size / 1.7,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size / 1.8),
                painter: _GaugePainter(
                  progress: 0.0,
                  trackColor: AppColors.border,
                  progressColor: AppColors.indicatorBlue,
                  strokeWidth: strokeWidth,
                ),
              ),
              Positioned(
                bottom: 12,
                child: Column(
                  children: [
                    Text(
                      periodLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bütçe Tanımlanmadı',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determine color based on limit threshold
    Color progressColor = AppColors.indicatorBlue;
    if (actualRatio >= 1.0) {
      progressColor = AppColors.criticalBackground; // Over limit
    } else if (actualRatio >= 0.80) {
      progressColor = AppColors.warningBackground; // Warning threshold %80
    }

    final clampedProgress = progress.clamp(0.0, 1.0);

    return Semantics(
      label: '$periodLabel Bütçe Durumu: $centerValue kullanıldı, $subCaption',
      child: SizedBox(
        width: size,
        height: size / 1.7,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(size, size / 1.8),
              painter: _GaugePainter(
                progress: clampedProgress,
                trackColor: AppColors.surfaceRaised,
                progressColor: progressColor,
                strokeWidth: strokeWidth,
              ),
            ),
            Positioned(
              bottom: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      periodLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    centerValue,
                    style: TextStyle(
                      color: progressColor == AppColors.warningBackground
                          ? AppColors.warningBackground
                          : progressColor == AppColors.criticalBackground
                              ? AppColors.expense
                              : AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subCaption,
                    style: TextStyle(
                      color: actualRatio >= 1.0
                          ? AppColors.expense
                          : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _GaugePainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height - (strokeWidth / 2);
    final double radius = (size.width - strokeWidth) / 2;

    final Rect arcRect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: radius,
    );

    // Track arc (180 degrees from pi to 0)
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, math.pi, math.pi, false, trackPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final double sweepAngle = math.pi * progress;
      canvas.drawArc(arcRect, math.pi, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
