import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/forms/app_form_field.dart';
import 'package:opto/core/widgets/inputs/app_input_field.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/auth/presentation/widgets/auth_scaffold.dart';

/// Screen 06 — Email & password auth.
///
/// Spec: `ScreenEmail` / `.scr-form` in `Opto Onboarding.html`.
///
/// Layout via [AuthFormScaffold]: back nav, scrollable body, pinned Continue.
/// "Forgot password?" → TODO snackbar (no Opto design for that screen).
/// Submit dispatches [AuthEvent.signInWithEmailPassword] to [AuthBloc].
class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthEvent.signInWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthError || curr is AuthAuthenticated,
        listener: (ctx, state) {
          state.mapOrNull(
            error: (s) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              announce(ctx, s.message);
            },
            authenticated: (_) => ctx.go(AppRoutes.home.path),
          );
        },
        buildWhen: (prev, curr) =>
            curr is AuthLoading ||
            curr is AuthInitial ||
            curr is AuthError ||
            curr is AuthAuthenticated,
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          final ThemeData theme = Theme.of(ctx);
          final Color ink2 =
              theme.extension<AppExtendedCustomColors>()?.ink2 ??
                  theme.colorScheme.onSurfaceVariant;

          return AuthFormScaffold(
            ctaLabel: 'Continue',
            ctaSuffixIcon: Icons.arrow_forward,
            onCta: isLoading ? null : _handleSubmit,
            isCtaLoading: isLoading,
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
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: ink2,
                      fontSize: 16.5,
                    ),
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
                  // Matches design's `.form-link`: 16px bold blue, no underline,
                  // left-aligned inline text. Min-height padded to meet ≥48dp tap target.
                  Semantics(
                    button: true,
                    label: 'Forgot password?',
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset — coming soon'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space12,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                            fontFamily: 'Atkinson Hyperlegible',
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Create account link ────────────────────────
                  Semantics(
                    button: true,
                    label: 'New to Opto? Create an account',
                    child: GestureDetector(
                      onTap: () => ctx.push(AppRoutes.authRegister.path),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space12,
                        ),
                        child: Text(
                          'New to Opto? Create an account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                            fontFamily: 'Atkinson Hyperlegible',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
