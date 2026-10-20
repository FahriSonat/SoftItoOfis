import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_card.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final OnboardingController _controller = OnboardingController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Atla', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _controller.pages.length,
                onPageChanged: _controller.setPage,
                itemBuilder: (context, index) {
                  return OnboardingCard(item: _controller.pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _controller.currentPage,
                    builder: (context, page, _) {
                      return Row(
                        children: List.generate(
                          _controller.pages.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: page == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: page == index ? AppColors.primary : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _controller.currentPage,
                    builder: (context, page, _) {
                      final isLast = page == _controller.pages.length - 1;
                      return ElevatedButton(
                        onPressed: () {
                          if (isLast) {
                            context.go('/login');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(isLast ? 'Hemen Başla' : 'İleri'),
                      );
                    },
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
