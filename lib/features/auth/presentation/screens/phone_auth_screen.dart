import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/auth/presentation/widgets/auth_scaffold.dart';

/// Screen 07 — Phone number entry.
///
/// Spec: `ScreenPhone` / `.scr-form` in `Opto Onboarding.html`.
///
/// Layout via [AuthFormScaffold]: back nav, scrollable body, pinned Send code.
/// Country-code box is static (🇮🇩 +62); only the number field is editable.
/// Submit dispatches [AuthEvent.requestOtp] to [AuthBloc].
/// On [AuthOtpSent]: pushes [OtpVerifyScreen] with the phone number.
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final raw = _phoneController.text.trim();
    if (raw.isEmpty) return;
    // Prepend +62 country code for E.164 format expected by Supabase.
    final phone = '+62$raw';
    context.read<AuthBloc>().add(AuthEvent.requestOtp(phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr is AuthOtpSent || curr is AuthError,
        listener: (ctx, state) {
          state.mapOrNull(
            otpSent: (s) => ctx.push(
              AppRoutes.authOtp.path,
              extra: s.phone,
            ),
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
          );
        },
        buildWhen: (prev, curr) =>
            curr is AuthLoading ||
            curr is AuthInitial ||
            curr is AuthError ||
            curr is AuthOtpSent,
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          final ThemeData theme = Theme.of(ctx);
          final ColorScheme cs = theme.colorScheme;
          final Color ink2 =
              theme.extension<AppExtendedCustomColors>()?.ink2 ??
                  cs.onSurfaceVariant;
          final Color ink3 =
              theme.extension<AppExtendedCustomColors>()?.ink3 ??
                  cs.onSurfaceVariant.withValues(alpha: 0.7);

          return AuthFormScaffold(
            ctaLabel: 'Send code',
            ctaSuffixIcon: Icons.arrow_forward,
            onCta: isLoading ? null : _handleSubmit,
            isCtaLoading: isLoading,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space8),

                // ── Title ────────────────────────────────────
                Semantics(
                  header: true,
                  child: Text(
                    "What's your number?",
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.space8),

                Text(
                  "We'll text a 6-digit code to confirm it's you.",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: ink2,
                    fontSize: 16.5,
                  ),
                ),

                const SizedBox(height: AppDimensions.space24),

                // ── Phone row: country-code + number ─────────
                Semantics(
                  label: 'Phone number — country code Indonesia +62',
                  child: Row(
                    children: [
                      // Country-code box — static, read-only.
                      Container(
                        height: AppDimensions.inputHeight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                          border: Border.all(color: cs.outline, width: 2),
                          color: cs.surface,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇮🇩', style: TextStyle(fontSize: 22)),
                            const SizedBox(width: AppDimensions.space8),
                            Text(
                              '+62',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: AppDimensions.space12),

                      // Number input.
                      Expanded(
                        child: SizedBox(
                          height: AppDimensions.inputHeight,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                isLoading ? null : _handleSubmit(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: cs.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: '812 3456 7890',
                              hintStyle: theme.textTheme.titleMedium?.copyWith(
                                color: ink3,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.space16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusInput,
                                ),
                                borderSide: BorderSide(
                                  color: cs.outline,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusInput,
                                ),
                                borderSide: BorderSide(
                                  color: cs.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: cs.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.space12),

                // ── Note ──────────────────────────────────────
                Text(
                  'Standard message rates may apply.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ink3,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: AppDimensions.space16),
              ],
            ),
          );
        },
      ),
    );
  }
}
