import 'package:flutter/foundation.dart';
import '../models/reset_password_model.dart';

class ResetPasswordController {
  final ValueNotifier<ResetPasswordModel> formState = ValueNotifier<ResetPasswordModel>(const ResetPasswordModel());
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void updateEmail(String email) {
    formState.value = formState.value.copyWith(email: email);
  }

  Future<void> sendResetLink() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isLoading.value = false;
    formState.value = formState.value.copyWith(isEmailSent: true);
  }

  void dispose() {
    formState.dispose();
    isLoading.dispose();
  }
}
