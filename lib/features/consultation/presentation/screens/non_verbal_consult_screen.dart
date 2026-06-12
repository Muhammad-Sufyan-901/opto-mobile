import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Screen 18d — Non-verbal consultation session (text/audio only, no video).
///
/// Receives [bookingId] (String) via GoRouter [state.extra].
/// No WebRTC, no camera. Provides structured text instructions with haptic
/// positioning cues and live-region announcements.
class NonVerbalConsultScreen extends StatelessWidget {
  const NonVerbalConsultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingId = GoRouterState.of(context).extra as String;
    return _NonVerbalView(bookingId: bookingId);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _NonVerbalView extends StatefulWidget {
  const _NonVerbalView({required this.bookingId});

  final String bookingId;

  @override
  State<_NonVerbalView> createState() => _NonVerbalViewState();
}

class _NonVerbalViewState extends State<_NonVerbalView> {
  // Tracks whether the patient has confirmed their position in step 1.
  bool _positionConfirmed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      HapticPatterns.focusTick();
      announce(
        context,
        'Non-verbal consultation session started. Listen to the instructions below.',
      );
    });
  }

  Future<void> _confirmPosition() async {
    await HapticPatterns.success();
    setState(() => _positionConfirmed = true);
    SemanticsService.announce(
      'Position confirmed. Please continue to the next step.',
      TextDirection.ltr,
    );
  }

  Future<void> _endSession() async {
    await HapticPatterns.warning();
    SemanticsService.announce('Session ended.', TextDirection.ltr);
    if (mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Session header ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: 16,
              ),
              child: _SessionHeader(cs: cs, onEndSession: _endSession),
            ),

            // ── Scrollable content ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppDimensions.screenPadding,
                  right: AppDimensions.screenPadding,
                  bottom: AppDimensions.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Medical disclaimer ────────────────────────────────
                    Semantics(
                      liveRegion: true,
                      child: _DisclaimerBox(cs: cs, ext: ext, theme: theme),
                    ),

                    const SizedBox(height: AppDimensions.space24),

                    // ── Step 1: Position ──────────────────────────────────
                    _StepCard(
                      stepNumber: 1,
                      title: 'Position yourself',
                      body:
                          'Find a quiet, comfortable spot. If you have low vision, ensure you are in a well-lit area. When ready, tap the button below to confirm.',
                      cs: cs,
                      ext: ext,
                      theme: theme,
                      action: _positionConfirmed
                          ? _ConfirmedBadge(cs: cs, ext: ext, theme: theme)
                          : Semantics(
                              button: true,
                              label: 'Tap to confirm your position',
                              child: ElevatedButton.icon(
                                onPressed: _confirmPosition,
                                icon: ExcludeSemantics(
                                  child: const Icon(Icons.check_circle_outline,
                                      size: 20),
                                ),
                                label: const Text('Confirm position'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(
                                    double.infinity,
                                    AppDimensions.minTapTarget,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusButton),
                                  ),
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: AppDimensions.space16),

                    // ── Step 2: Describe symptoms ─────────────────────────
                    _StepCard(
                      stepNumber: 2,
                      title: 'Describe your symptoms',
                      body:
                          'Speak or type your symptoms clearly. Your response will be securely shared with your doctor for review. Be as specific as possible about what you are experiencing.',
                      cs: cs,
                      ext: ext,
                      theme: theme,
                    ),

                    const SizedBox(height: AppDimensions.space16),

                    // ── Step 3: Await response ────────────────────────────
                    _StepCard(
                      stepNumber: 3,
                      title: 'Await your doctor\'s response',
                      body:
                          'Your doctor will review your information and respond via text within 24 hours. You will receive a notification when their reply is available.',
                      cs: cs,
                      ext: ext,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            ),

            // ── End session button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              child: Semantics(
                button: true,
                label: 'End consultation session',
                child: SizedBox(
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _endSession,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusButton),
                      ),
                    ),
                    child: const ExcludeSemantics(
                      child: Text(
                        'End Session',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.cs,
    required this.onEndSession,
  });

  final ColorScheme cs;
  final VoidCallback onEndSession;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) context.pop();
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'Non-verbal Consultation',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ),
        // Balance spacer equal to back button width
        const SizedBox(width: AppDimensions.minTapTarget),
      ],
    );
  }
}

class _DisclaimerBox extends StatelessWidget {
  const _DisclaimerBox({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = ext?.blueTint ?? cs.primaryContainer;
    final Color iconColor = cs.primary;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(Icons.info_outline, size: 20, color: iconColor),
          ),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Text(
              'This session uses structured text and audio guidance — no video. '
              'For medical emergencies, end this session and call emergency services immediately.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.body,
    required this.cs,
    required this.ext,
    required this.theme,
    this.action,
  });

  final int stepNumber;
  final String title;
  final String body;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;
    final String semanticsLabel = 'Step $stepNumber: $title. $body';

    return Semantics(
      header: true,
      label: semanticsLabel,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
        ),
        child: ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step number + title ──────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$stepNumber',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  Flexible(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── Body text ─────────────────────────────────────────────
              Text(
                body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  height: 1.55,
                ),
              ),

              if (action != null) ...[
                const SizedBox(height: AppDimensions.space16),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfirmedBadge extends StatelessWidget {
  const _ConfirmedBadge({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = ext?.greenTint ?? cs.secondaryContainer;
    final Color textColor = ext?.green ?? cs.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space8,
        horizontal: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: textColor),
          const SizedBox(width: AppDimensions.space8),
          Text(
            'Position confirmed',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
