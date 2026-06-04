import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';
import 'package:ids_elder_rehab_app/core/widgets/forms/app_form_field.dart';
import 'package:ids_elder_rehab_app/core/widgets/inputs/app_input_field.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/widgets/auth_scaffold.dart';

/// Screen 06 — Email & password auth.
///
/// Spec: `ScreenEmail` / `.scr-form` in `Opto Onboarding.html`.
///
/// Layout via [AuthFormScaffold]: back nav, scrollable body, pinned Continue.
/// "Forgot password?" → TODO snackbar (no Opto design for that screen).
/// Simulated submit: 1.5s delay then navigate to onboarding setup.
class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Simulated auth delay — replace with BLoC dispatch when backend is ready.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);
    // Navigate to the first onboarding/setup step (Vision profile).
    context.go(AppRoutes.setupVision.path);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color ink2 =
        theme.extension<AppExtendedCustomColors>()?.ink2 ??
            theme.colorScheme.onSurfaceVariant;

    return AuthFormScaffold(
      ctaLabel: 'Continue',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: _isLoading ? null : _handleSubmit,
      isCtaLoading: _isLoading,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.space8),

            // ── Title ──────────────────────────────────────
            Semantics(
              header: true,
              child: Text(
                'Your email & password',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space8),

            Text(
              "We'll keep your account safe and synced.",
              style: theme.textTheme.bodyLarge?.copyWith(color: ink2),
            ),

            const SizedBox(height: AppDimensions.space24),

            // ── Email field ────────────────────────────────
            AppFormField(
              label: 'Email address',
              isRequired: true,
              child: AppInputField.email(
                controller: _emailController,
                hintText: 'you@example.com',
                textInputAction: TextInputAction.next,
              ),
            ),

            const SizedBox(height: AppDimensions.space16),

            // ── Password field ─────────────────────────────
            AppFormField(
              label: 'Password',
              isRequired: true,
              child: AppInputField.password(
                controller: _passwordController,
                hintText: 'At least 8 characters',
                textInputAction: TextInputAction.done,
              ),
            ),

            const SizedBox(height: AppDimensions.space8),

            // ── Forgot password link ───────────────────────
            AppButton.link(
              text: 'Forgot password?',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset — coming soon'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            const SizedBox(height: AppDimensions.space16),
          ],
        ),
      ),
    );
  }
}
