import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/widgets/forms/app_form_field.dart';
import '../../../../core/widgets/inputs/app_input_field.dart';
import '../../../../core/widgets/inputs/app_select_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../layouts/auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCountry;

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Konfirmasi password tidak cocok',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.login.path); // Default successful route simulation
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                'Registrasi',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan isi form di bawah ini untuk membuat akun baru.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),

              AppFormField(
                label: 'Nama Lengkap',
                isRequired: true,
                child: AppInputField(
                  controller: _nameController,
                  hintText: 'Masukkan Nama Lengkap',
                  prefixIcon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 20),

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
                label: 'Negara',
                isRequired: true,
                child: AppSelectField<String>(
                  hintText: 'Pilih Negara',
                  value: _selectedCountry,
                  items: const [
                    AppSelectItem(value: 'Indonesia', label: 'Indonesia'),
                    AppSelectItem(value: 'Malaysia', label: 'Malaysia'),
                    AppSelectItem(value: 'Singapura', label: 'Singapura'),
                    AppSelectItem(value: 'Inggris', label: 'Inggris'),
                    AppSelectItem(
                      value: 'Amerika Serikat',
                      label: 'Amerika Serikat',
                    ),
                  ],
                  prefixIcon: Icons.public_outlined,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              AppFormField(
                label: 'Nomor WhatsApp',
                isRequired: true,
                child: AppInputField.number(
                  controller: _whatsappController,
                  hintText: '08123456789',
                  prefixIcon: Icons.phone_outlined,
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
              const SizedBox(height: 20),

              AppFormField(
                label: 'Konfirmasi Password',
                isRequired: true,
                child: AppInputField.password(
                  controller: _confirmPasswordController,
                  hintText: 'Ulangi Password',
                ),
              ),
              const SizedBox(height: 32),

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
                  text: 'Daftar',
                  radius: 150,
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                  isFullWidth: true,
                ),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah Punya Akun? ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                  AppButton.link(
                    onPressed: () {
                      context.push(AppRoutes.login.path);
                    },
                    text: 'Masuk Sekarang',
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
