import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class HabitColors extends ThemeExtension<HabitColors> {
  final List<Color> negativeStages;
  final List<Color> positiveStages;
  final Color restart;
  final Color negativeGlow;
  final Color positiveGlow;

  const HabitColors({
    required this.negativeStages,
    required this.positiveStages,
    required this.restart,
    required this.negativeGlow,
    required this.positiveGlow,
  });

  static const HabitColors standard = HabitColors(
    negativeStages: AppColors.negativeStages,
    positiveStages: AppColors.positiveStages,
    restart: AppColors.restart,
    negativeGlow: Color(0x33FF5D68),
    positiveGlow: Color(0x334D8DFF),
  );

  @override
  HabitColors copyWith({
    List<Color>? negativeStages,
    List<Color>? positiveStages,
    Color? restart,
    Color? negativeGlow,
    Color? positiveGlow,
  }) {
    return HabitColors(
      negativeStages: negativeStages ?? this.negativeStages,
      positiveStages: positiveStages ?? this.positiveStages,
      restart: restart ?? this.restart,
      negativeGlow: negativeGlow ?? this.negativeGlow,
      positiveGlow: positiveGlow ?? this.positiveGlow,
    );
  }

  @override
  HabitColors lerp(ThemeExtension<HabitColors>? other, double t) {
    if (other is! HabitColors) return this;
    return HabitColors(
      negativeStages: List.generate(
        negativeStages.length,
        (i) => Color.lerp(negativeStages[i], other.negativeStages[i], t)!,
      ),
      positiveStages: List.generate(
        positiveStages.length,
        (i) => Color.lerp(positiveStages[i], other.positiveStages[i], t)!,
      ),
      restart: Color.lerp(restart, other.restart, t)!,
      negativeGlow: Color.lerp(negativeGlow, other.negativeGlow, t)!,
      positiveGlow: Color.lerp(positiveGlow, other.positiveGlow, t)!,
    );
  }
}
