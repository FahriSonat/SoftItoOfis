import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class UserProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int level;
  final int coins;
  final VoidCallback? onTap;

  const UserProfileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.coins,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.military_tech_rounded, color: AppColors.secondary, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'Seviye $level',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: AppColors.divider,
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: AppColors.tertiary, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      '$coins Puan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
