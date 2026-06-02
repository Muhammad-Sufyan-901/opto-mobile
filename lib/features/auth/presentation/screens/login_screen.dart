import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_routes.dart';

import '../../../../core/widgets/forms/app_form_field.dart';
import '../../../../core/widgets/inputs/app_input_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../layouts/auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _handleLogin(VoidCallback onPressed) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);

    onPressed();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return AuthLayout(
      title: 'Rehab App',
      subtitle:
          'Pemulihan adalah sebuah proses. Butuh waktu. Butuh kesabaran. Butuh segalanya yang kamu punya.',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 40,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Login',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan email dan password Anda untuk masuk ke akun Anda.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              AppFormField(
                label: 'Email',
                isRequired: true,
                child: AppInputField.email(
                  controller: _emailController,
                  hintText: 'Masukkan Email',
                ),
              ),
              const SizedBox(height: 20),

              AppFormField(
                label: 'Password',
                isRequired: true,
                child: AppInputField.password(
                  controller: _passwordController,
                  hintText: 'Masukkan Password',
                ),
              ),
              const SizedBox(height: 12),

              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppButton.link(
                  onPressed: () {
                    context.push(AppRoutes.forgotPassword.path);
                  },
                  text: 'Lupa Password?',
                ),
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AppButton.primary(
                  text: 'Masuk',
                  radius: 150,
                  onPressed: () {
                    _handleLogin(() {
                      context.go(AppRoutes.lansiaDashboard.path);
                    });
                  },
                  isLoading: _isLoading,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum Punya Akun? ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  AppButton.link(
                    onPressed: () {
                      context.push(AppRoutes.register.path);
                    },
                    text: 'Daftar Sekarang',
                  ),
                ],
              ),
              const SizedBox(height: 36),

              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Atau',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 36),

              AppButton.secondary(
                text: 'Masuk Dengan Google',
                isFullWidth: true,
                prefixIcon: PhosphorIconsFill.googleLogo,
                onPressed: () {},
                radius: 150,
              ),

              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
