import 'package:flutter/foundation.dart';
import '../models/splash_model.dart';

class SplashController {
  final ValueNotifier<SplashModel> state = ValueNotifier<SplashModel>(const SplashModel());

  Future<void> initializeApp() async {
    state.value = state.value.copyWith(statusText: 'Kullanıcı verileri yükleniyor...');
    await Future.delayed(const Duration(milliseconds: 700));
    state.value = state.value.copyWith(statusText: 'Günlük hedefler hazırlanıyor...');
    await Future.delayed(const Duration(milliseconds: 600));
    state.value = state.value.copyWith(isInitialized: true, statusText: 'Hazır');
  }

  void dispose() {
    state.dispose();
  }
}
