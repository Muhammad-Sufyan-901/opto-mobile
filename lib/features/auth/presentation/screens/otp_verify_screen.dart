import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/core/widgets/inputs/app_otp_field.dart';
import 'package:ids_elder_rehab_app/features/auth/presentation/widgets/auth_scaffold.dart';

/// Screen 08 — OTP verification.
///
/// Spec: `ScreenOTP` / `.scr-form` in `Opto Onboarding.html`.
///   - Title "Enter your code" / sub "Sent to +62 …"
///   - [AppOTPField] (length 6) — canonical input primitive.
///   - Resend countdown (30 s); "Resend" link enables after countdown.
///   - Pinned "Verify" CTA with check icon.
///
/// Simulated verification: 1.5 s delay then navigates to onboarding setup.
/// Screen-reader: announces result via [SemanticsService.sendAnnouncement].
class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({
    super.key,
    this.phoneNumber = '+62 …',
  });

  /// Phone number displayed in the subtitle (passed via `GoRouter.extra`
  /// when available, otherwise defaults to a placeholder).
  final String phoneNumber;

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String _otpValue = '';
  bool _isLoading = false;
  int _resendCountdown = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _resendTimer?.cancel();
    setState(() => _resendCountdown = 30);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown <= 1) {
        t.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  bool get _canVerify => _otpValue.length == 6 && !_isLoading;

  Future<void> _handleVerify() async {
    if (!_canVerify) return;
    setState(() => _isLoading = true);
    // Simulated verification — replace with BLoC dispatch when backend is ready.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isLoading = false);
    SemanticsService.sendAnnouncement(
      View.of(context),
      'Code verified. Setting up your account.',
      TextDirection.ltr,
    );
    context.go(AppRoutes.setupVision.path);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color ink2 =
        theme.extension<AppExtendedCustomColors>()?.ink2 ??
            cs.onSurfaceVariant;
    final Color ink3 =
        theme.extension<AppExtendedCustomColors>()?.ink3 ??
            cs.onSurfaceVariant.withValues(alpha: 0.7);

    final String resendText = _resendCountdown > 0
        ? 'Resend in 0:${_resendCountdown.toString().padLeft(2, '0')}'
        : 'Resend';

    return AuthFormScaffold(
      ctaLabel: 'Verify',
      ctaSuffixIcon: Icons.check,
      onCta: _canVerify ? _handleVerify : null,
      isCtaLoading: _isLoading,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space8),

          // ── Title ────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'Enter your code',
              style: theme.textTheme.displaySmall?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          Text(
            'Sent to ${widget.phoneNumber}. It may take a moment.',
            style: theme.textTheme.bodyLarge?.copyWith(color: ink2),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── OTP input ─────────────────────────────────
          // AppOTPField fills available width and exposes each digit box to
          // screen readers (from the widget's internal implementation).
          AppOTPField(
            length: 6,
            onChanged: (val) => setState(() => _otpValue = val),
          ),

          const SizedBox(height: AppDimensions.space16),

          // ── Resend line ───────────────────────────────
          Semantics(
            label: _resendCountdown > 0
                ? "Didn't get it? Resend in $resendText"
                : "Didn't get it? Tap to resend",
            child: Row(
              children: [
                Text(
                  "Didn't get it? ",
                  style: theme.textTheme.bodyMedium?.copyWith(color: ink2),
                ),
                GestureDetector(
                  onTap: _resendCountdown == 0 ? _startResendCountdown : null,
                  child: Text(
                    resendText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: _resendCountdown == 0 ? cs.primary : ink3,
                      decoration: _resendCountdown == 0
                          ? TextDecoration.underline
                          : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.space16),
        ],
      ),
    );
  }
}
