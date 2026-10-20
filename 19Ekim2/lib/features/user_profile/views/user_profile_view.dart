import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/user_profile_controller.dart';
import '../models/user_profile_model.dart';
import '../widgets/user_profile_card.dart';

class UserProfileView extends StatelessWidget {
  final UserProfileController _controller = UserProfileController();

  UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<UserProfileModel>(
              valueListenable: _controller.profile,
              builder: (context, profile, _) {
                return UserProfileCard(
                  title: profile.name,
                  subtitle: profile.email,
                  level: profile.level,
                  coins: profile.coins,
                );
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fiziksel Bilgiler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<UserProfileModel>(
                      valueListenable: _controller.profile,
                      builder: (context, profile, _) {
                        return Row(
                          children: [
                            Expanded(
                              child: _ProfileMetricTile(
                                label: 'Kilo',
                                value: '${profile.weightKg} kg',
                                icon: Icons.monitor_weight_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ProfileMetricTile(
                                label: 'Boy',
                                value: '${profile.heightCm.toInt()} cm',
                                icon: Icons.height_rounded,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
                    title: const Text('Bildirim Tercihleri'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.security_outlined, color: AppColors.secondary),
                    title: const Text('Gizlilik ve Güvenlik'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.divider),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded, color: AppColors.tertiary),
                    title: const Text('Yardım ve Destek'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
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

class _ProfileMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileMetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
