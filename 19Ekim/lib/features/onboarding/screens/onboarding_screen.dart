import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:susadim/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      title: 'Akıllı Su Takibi',
      description:
          'Günlük hidrasyon hedeflerinizi belirleyin, spor salonunda ve gün boyunca su tüketiminizi kolayca takip edin.',
      icon: Icons.water_drop_rounded,
      color: AppColors.primary,
    ),
    _OnboardingItem(
      title: 'Egzersiz ve Antrenman',
      description:
          'Kardiyo ve ağırlık antrenmanlarınızı kaydedin, yakılan kalorileri anlık izleyin.',
      icon: Icons.fitness_center_rounded,
      color: AppColors.secondary,
    ),
    _OnboardingItem(
      title: 'Dengeli Beslenme',
      description:
          'Günlük kalori ve makro besin hedeflerinizi takip ederek formunuzu zirveye taşıyın.',
      icon: Icons.restaurant_rounded,
      color: AppColors.tertiary,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text(
                    'Atla',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final item = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withAlpha(30),
                            border: Border.all(color: item.color, width: 2),
                          ),
                          child: Icon(item.icon, size: 70, color: item.color),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_currentIndex < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go('/login');
                  }
                },
                child: Text(
                  _currentIndex == _pages.length - 1 ? 'Başlayalım' : 'Devam Et',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
