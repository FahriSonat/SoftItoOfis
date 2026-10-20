import 'package:flutter/foundation.dart';
import '../models/onboarding_model.dart';

class OnboardingController {
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      title: 'Akıllı Su Takibi',
      description: 'Gün boyunca ihtiyaç duyduğun hidrasyonu adım adım takip et, spor performansını zirveye taşı.',
      iconName: 'water',
    ),
    OnboardingModel(
      title: 'Egzersiz ve Antrenman',
      description: 'Antrenmanlarını kaydet, yaktığın kalorileri anlık hesapla ve fitness hedeflerine ulaş.',
      iconName: 'fitness',
    ),
    OnboardingModel(
      title: 'Dengeli Beslenme',
      description: 'Makro besinlerini ve kalorilerini yönet, karanlık spor salonu modunda gözlerini yormadan takip et.',
      iconName: 'nutrition',
    ),
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      currentPage.value++;
    }
  }

  void setPage(int index) {
    currentPage.value = index;
  }

  void dispose() {
    currentPage.dispose();
  }
}
