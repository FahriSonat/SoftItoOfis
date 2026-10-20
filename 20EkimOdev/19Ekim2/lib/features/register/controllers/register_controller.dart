import 'package:flutter/foundation.dart';
import '../models/register_model.dart';

class RegisterController {
  final ValueNotifier<RegisterModel> formState = ValueNotifier<RegisterModel>(const RegisterModel());
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void updateFullName(String name) {
    formState.value = formState.value.copyWith(fullName: name);
  }

  void updateEmail(String email) {
    formState.value = formState.value.copyWith(email: email);
  }

  void updatePassword(String password) {
    formState.value = formState.value.copyWith(password: password);
  }

  Future<bool> register() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    return true;
  }

  void dispose() {
    formState.dispose();
    isLoading.dispose();
  }
}
