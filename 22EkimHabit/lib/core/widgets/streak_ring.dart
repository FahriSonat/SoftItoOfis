import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class StreakRing extends StatelessWidget {
  final double size;
  final double progress; // 0.0 to 1.0
  final Color strokeColor;
  final double strokeWidth;
  final Widget? child;
  final String? semanticsLabel;
  final bool isBroken;

  const StreakRing({
    super.key,
    this.size = 72.0,
    required this.progress,
    required this.strokeColor,
    this.strokeWidth = 6.0,
    this.child,
    this.semanticsLabel,
    this.isBroken = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isBroken ? AppColors.restart : strokeColor;
    final contentChild = child;

    return Semantics(
      label: semanticsLabel ?? 'İlerleme halkası: ${(progress * 100).toInt()}%',
      child: RepaintBoundary(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _StreakRingPainter(
                  progress: progress.clamp(0.0, 1.0),
                  color: effectiveColor,
                  trackColor: AppColors.surfaceStrong,
                  strokeWidth: strokeWidth,
                  isBroken: isBroken,
                ),
              ),
              if (contentChild != null) contentChild,
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final bool isBroken;

  _StreakRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.isBroken,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Arka plan izi
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    if (isBroken) {
      // Kırık / bozulmuş halka: kesikli turuncu yay
      final brokenPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 1.5,
        false,
        brokenPaint,
      );
      return;
    }

    if (progress <= 0.0) return;

    // Hafif parıltı (Glow efekti)
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      glowPaint,
    );

    // Ön plan ilerleme yayı
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StreakRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isBroken != isBroken;
  }
}
