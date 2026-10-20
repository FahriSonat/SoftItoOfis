import 'package:flutter/foundation.dart';
import '../models/login_model.dart';

class LoginController {
  final ValueNotifier<LoginModel> formState = ValueNotifier<LoginModel>(const LoginModel());
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  void updateEmail(String email) {
    formState.value = formState.value.copyWith(email: email);
  }

  void updatePassword(String password) {
    formState.value = formState.value.copyWith(password: password);
  }

  void toggleRememberMe() {
    formState.value = formState.value.copyWith(rememberMe: !formState.value.rememberMe);
  }

  Future<bool> login() async {
    isLoading.value = true;
    errorMessage.value = null;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    return true;
  }

  void dispose() {
    formState.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
