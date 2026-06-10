import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/utils/input_validator.dart';
import 'package:opto/core/widgets/forms/app_form_field.dart';
import 'package:opto/core/widgets/inputs/app_input_field.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/auth/presentation/widgets/auth_scaffold.dart';

/// Screen — Email register / sign-up.
///
/// Mirrors [EmailAuthScreen] in layout and BLoC wiring, with two extra fields:
/// **Full name** and **Confirm password**.
///
/// Submit dispatches [AuthEvent.signUp] to [AuthBloc].
///
/// Possible outcomes:
/// - [AuthAuthenticated]: navigates to [AppRoutes.home] (auto-confirm ON, rare).
/// - [AuthEmailConfirmationRequired]: form is replaced by a "Check your email"
///   panel and the outcome is announced to the screen reader.
/// - [AuthError]: floating SnackBar + screen-reader live-region announcement.
class EmailRegisterScreen extends StatefulWidget {
  const EmailRegisterScreen({super.key});

  @override
  State<EmailRegisterScreen> createState() => _EmailRegisterScreenState();
}

class _EmailRegisterScreenState extends State<EmailRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
          AuthEvent.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthError ||
            curr is AuthAuthenticated ||
            curr is AuthEmailConfirmationRequired,
        listener: (ctx, state) {
          state.mapOrNull(
            error: (s) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(s.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              SemanticsService.sendAnnouncement(
                View.of(ctx),
                s.message,
                TextDirection.ltr,
              );
            },
            authenticated: (_) => ctx.go(AppRoutes.home.path),
            emailConfirmationRequired: (s) {
              // Announce for screen-reader users before the UI rebuilds.
              SemanticsService.sendAnnouncement(
                View.of(ctx),
                'Account created. Check your email at ${s.email} for a '
                'confirmation link, then sign in.',
                TextDirection.ltr,
              );
            },
          );
        },
        buildWhen: (prev, curr) =>
            curr is AuthLoading ||
            curr is AuthInitial ||
            curr is AuthError ||
            curr is AuthAuthenticated ||
            curr is AuthEmailConfirmationRequired,
        builder: (ctx, state) {
          // ── Email confirmation panel ──────────────────────────────────────
          if (state is AuthEmailConfirmationRequired) {
            return _ConfirmationPanel(email: state.email);
          }

          // ── Registration form ─────────────────────────────────────────────
          final isLoading = state is AuthLoading;
          final ThemeData theme = Theme.of(ctx);
          final Color ink2 =
              theme.extension<AppExtendedCustomColors>()?.ink2 ??
                  theme.colorScheme.onSurfaceVariant;

          return AuthFormScaffold(
            ctaLabel: 'Create account',
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
                      'Create your account',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space8),

                  Text(
                    "It only takes a moment to get started.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: ink2,
                      fontSize: 16.5,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // ── Full name field ────────────────────────────
                  AppFormField(
                    label: 'Full name',
                    isRequired: true,
                    child: AppInputField(
                      controller: _nameController,
                      hintText: 'Your full name',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: InputValidator.name,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // ── Email field ────────────────────────────────
                  AppFormField(
                    label: 'Email address',
                    isRequired: true,
                    child: AppInputField.email(
                      controller: _emailController,
                      hintText: 'you@example.com',
                      textInputAction: TextInputAction.next,
                      validator: InputValidator.email,
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
                      textInputAction: TextInputAction.next,
                      validator: InputValidator.password,
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // ── Confirm password field ─────────────────────
                  AppFormField(
                    label: 'Confirm password',
                    isRequired: true,
                    child: AppInputField.password(
                      controller: _confirmPasswordController,
                      hintText: 'Re-enter your password',
                      textInputAction: TextInputAction.done,
                      validator: (v) => InputValidator.confirmPassword(
                        v,
                        _passwordController.text,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.space16),

                  // ── Already have an account link ───────────────
                  Semantics(
                    button: true,
                    label: 'Already have an account? Sign in',
                    child: GestureDetector(
                      onTap: () => ctx.pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.space12,
                        ),
                        child: Text(
                          'Already have an account? Sign in',
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

// ─────────────────────────────────────────────────────────────────────────────
// Confirmation panel — shown after a successful sign-up when the Supabase
// project requires email confirmation before a session can be started.
// ─────────────────────────────────────────────────────────────────────────────

class _ConfirmationPanel extends StatelessWidget {
  const _ConfirmationPanel({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color ink2 =
        theme.extension<AppExtendedCustomColors>()?.ink2 ??
            cs.onSurfaceVariant;

    return AuthFormScaffold(
      ctaLabel: 'Back to sign in',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.go(AppRoutes.authEmail.path),
      isCtaLoading: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space8),

          // ── Envelope icon ──────────────────────────────────────
          ExcludeSemantics(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
              ),
              child: Icon(
                Icons.mark_email_unread_outlined,
                size: 32,
                color: cs.primary,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Title ──────────────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'Check your email',
              style: theme.textTheme.displaySmall?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          // ── Body ───────────────────────────────────────────────
          Text(
            'We sent a confirmation link to',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ink2,
              fontSize: 16.5,
            ),
          ),

          const SizedBox(height: AppDimensions.space4),

          Text(
            email,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface,
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          Text(
            'Click the link in the email to confirm your account, '
            'then come back and sign in.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ink2,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: AppDimensions.space32),
        ],
      ),
    );
  }
}
