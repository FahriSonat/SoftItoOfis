import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/reset_password_controller.dart';
import '../models/reset_password_model.dart';
import '../widgets/reset_password_card.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordController _controller = ResetPasswordController();

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırla'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<ResetPasswordModel>(
                valueListenable: _controller.formState,
                builder: (context, state, _) {
                  if (state.isEmailSent) {
                    return ResetPasswordCard(
                      child: Column(
                        children: [
                          const Icon(Icons.mark_email_read_outlined, size: 60, color: AppColors.secondary),
                          const SizedBox(height: 16),
                          const Text(
                            'Sıfırlama Bağlantısı Gönderildi',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.email} adresine talimatlar iletildi. Lütfen gelen kutunuzu kontrol edin.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.pop(),
                            child: const Text('Giriş Ekranına Dön'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ResetPasswordCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Şifrenizi mi Unuttunuz?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Kayıtlı e-posta adresinizi girin, size şifre yenileme bağlantısı gönderelim.',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          onChanged: _controller.updateEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-posta Adresi',
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ValueListenableBuilder<bool>(
                          valueListenable: _controller.isLoading,
                          builder: (context, loading, _) {
                            return ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                      await _controller.sendResetLink();
                                    },
                              child: loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Sıfırlama Bağlantısı Gönder'),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
