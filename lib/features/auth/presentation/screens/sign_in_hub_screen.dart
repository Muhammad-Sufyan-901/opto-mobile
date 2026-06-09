import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/auth/presentation/widgets/auth_method_button.dart';
import 'package:opto/features/onboarding/presentation/widgets/opto_brand_mark.dart';

/// Screen 05 — Sign-in hub.
///
/// Spec: `ScreenSignIn` / `.auth-head` in `Opto Onboarding.html`.
///
/// Layout (white Scaffold, 24dp h-padding, scrollable):
///   - Brand mark (60×60, radius 18, blue-tint bg, blue aperture)
///   - "Welcome to Opto" title (displaySmall)
///   - Sub "Sign in or create your account to begin."
///   - 3 method buttons: Google / email / phone
///   - "or" divider
///   - Assisted-setup card → /auth/caregiver
///   - Terms note (centred, bodySmall, underlined links)
///
/// A [BlocListener] on [AuthBloc] handles the [AuthAuthenticated] state in case
/// authentication completes while this screen is active (e.g. deep-link flow).
class SignInHubScreen extends StatelessWidget {
  const SignInHubScreen({super.key});

  void _showTodoSnackbar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (ctx, state) {
          state.mapOrNull(
            authenticated: (_) => ctx.go(AppRoutes.home.path),
          );
        },
        child: Builder(
          builder: (ctx) {
            final ThemeData theme = Theme.of(ctx);
            final ColorScheme cs = theme.colorScheme;
            final Color blueTint =
                theme.extension<AppExtendedCustomColors>()?.blueTint ??
                cs.primaryContainer;
            final Color ink2 =
                theme.extension<AppExtendedCustomColors>()?.ink2 ??
                cs.onSurfaceVariant;
            final Color ink3 =
                theme.extension<AppExtendedCustomColors>()?.ink3 ??
                cs.onSurfaceVariant.withValues(alpha: 0.7);

            return Scaffold(
              backgroundColor: cs.surface,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.space24),

                      // ── Brand mark ───────────────────────────────
                      OptoBrandMark(
                        size: 60,
                        iconSize: 30,
                        radius: 18,
                        backgroundColor: blueTint,
                        color: cs.primary,
                      ),

                      const SizedBox(height: AppDimensions.space16),

                      // ── Title ────────────────────────────────────
                      Semantics(
                        header: true,
                        child: Text(
                          'Welcome to Opto',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: cs.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space8),

                      // ── Subtitle ─────────────────────────────────
                      Text(
                        'Sign in or create your account to begin.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: ink2,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 26), // .auth-methods margin-top 26
                      // ── Method buttons ────────────────────────────
                      AuthMethodButton(
                        label: 'Continue with Google',
                        icon: _GoogleIcon(),
                        onPressed: () =>
                            _showTodoSnackbar(ctx, 'Google sign-in'),
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      AuthMethodButton(
                        label: 'Continue with email',
                        icon: const Icon(Icons.mail_outline, size: 24),
                        onPressed: () => ctx.push(AppRoutes.authEmail.path),
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      AuthMethodButton(
                        label: 'Continue with phone',
                        icon: const Icon(Icons.smartphone_outlined, size: 24),
                        onPressed: () => ctx.push(AppRoutes.authPhone.path),
                      ),

                      const SizedBox(height: AppDimensions.space12),

                      // ── Create account link ───────────────────────
                      Semantics(
                        button: true,
                        label: 'Create account',
                        child: GestureDetector(
                          onTap: () =>
                              ctx.push(AppRoutes.authRegister.path),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.space12,
                            ),
                            child: Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: cs.primary,
                                fontFamily: 'Atkinson Hyperlegible',
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18), // .auth-or margin 18 (before divider)
                      // ── "or" divider ─────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: cs.outlineVariant,
                              thickness: 1.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.space16,
                            ),
                            child: Text(
                              'or',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ink3,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: cs.outlineVariant,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18), // .auth-or margin 18 (after divider)
                      // ── Assisted-setup card ───────────────────────
                      Semantics(
                        button: true,
                        label:
                            "I'm helping someone set up. Assisted setup for a family member or friend.",
                        child: GestureDetector(
                          onTap: () =>
                              ctx.push(AppRoutes.authCaregiver.path),
                          child: Container(
                            padding: const EdgeInsets.all(AppDimensions.space16),
                            decoration: BoxDecoration(
                              color: blueTint,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusRow,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Hands icon chip
                                Container(
                                  width: AppDimensions.minTapTarget,
                                  height: AppDimensions.minTapTarget,
                                  decoration: BoxDecoration(
                                    color: cs.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusChip,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.people_outline,
                                      size: AppDimensions.iconLg,
                                      color: cs.primary,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: AppDimensions.space16),

                                // Text block
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "I'm helping someone set up",
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                      const SizedBox(height: AppDimensions.space4),
                                      Text(
                                        'Assisted setup for a family member or friend',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: ink2,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward,
                                  size: AppDimensions.iconLg,
                                  color: cs.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space24),

                      // ── Terms note ────────────────────────────────
                      Semantics(
                        label:
                            "By continuing you agree to Opto's Terms and Privacy Policy.",
                        child: Text.rich(
                          TextSpan(
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink3,
                              fontSize: 13.5,
                            ),
                            children: [
                              const TextSpan(
                                text: "By continuing you agree to Opto's ",
                              ),
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: ink2,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: ink2,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Google icon — drawn inline to avoid an SVG dep; matches design's 'G' mark.
// ---------------------------------------------------------------------------

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            'G',
            style: TextStyle(
              fontFamily: 'Atkinson Hyperlegible',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
