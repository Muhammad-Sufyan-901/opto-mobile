import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Screen C5 — Connecting (waiting for doctor to join).
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity?}` via GoRouter extra.
/// [doctor] may be null when coming from the "Start voice consult" hero (next
/// available specialist flow).
///
/// Visual stub: animates pulse rings, shows connection steps, then auto-advances
/// to [CallRoomScreen] after a short delay. When reduce-motion is active the pulse
/// is static and a manual "Continue to call" button appears instead of the timer.
class ConnectingScreen extends StatelessWidget {
  const ConnectingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final doctor = extra?['doctor'] as DoctorEntity?;
    return _ConnectingView(doctor: doctor);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _ConnectingView extends StatefulWidget {
  const _ConnectingView({this.doctor});

  final DoctorEntity? doctor;

  @override
  State<_ConnectingView> createState() => _ConnectingViewState();
}

class _ConnectingViewState extends State<_ConnectingView>
    with TickerProviderStateMixin {
  late final AnimationController _pulse1;
  late final AnimationController _pulse2;
  Timer? _advanceTimer;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _pulse1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _pulse2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _reduceMotion = MediaQuery.of(context).disableAnimations;

      if (!_reduceMotion) {
        _pulse1.repeat();
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (mounted) _pulse2.repeat();
        });
        // Auto-advance to call room after 3 s.
        _advanceTimer = Timer(const Duration(seconds: 3), _goToCallRoom);
      }

      announce(
        context,
        'Connecting to ${widget.doctor?.fullName ?? 'next available specialist'}. '
        'End-to-end encrypted. Please wait.',
      );

      SemanticsService.announce(
        'Audio guidance is on. You will hear a tone when the doctor joins.',
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _pulse1.dispose();
    _pulse2.dispose();
    _advanceTimer?.cancel();
    super.dispose();
  }

  void _goToCallRoom() {
    if (!mounted) return;
    context.pushReplacement(
      AppRoutes.consultCallRoom.path,
      extra: {'doctor': widget.doctor},
    );
  }

  String get _initials {
    final name = widget.doctor?.fullName;
    if (name == null || name.trim().isEmpty) return 'NS';
    return name.trim().split(' ').take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final String doctorName =
        widget.doctor?.fullName ?? 'Next available specialist';
    final String specialty =
        widget.doctor?.specialty ?? 'Ocular Prosthetic Specialist';

    final steps = [
      _Step(label: 'Secure connection established', done: true),
      _Step(label: 'Notifying $doctorName', done: true),
      _Step(label: 'Joining the consultation room', active: true),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding - 4),
          child: Column(
            children: [
              // ── Top bar with back button ───────────────────────────────
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: 'Go back',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _advanceTimer?.cancel();
                          HapticPatterns.warning();
                          SemanticsService.announce(
                              'Consultation cancelled.', TextDirection.ltr);
                          if (context.canPop()) context.pop();
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ExcludeSemantics(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 24,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: AppDimensions.space8),

              // ── E2E badge ──────────────────────────────────────────────
              Align(
                alignment: Alignment.center,
                child: _E2EBadge(cs: cs, ext: ext, theme: theme),
              ),

              // ── Pulse avatar + info ────────────────────────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PulseAvatar(
                      initials: _initials,
                      pulse1: _pulse1,
                      pulse2: _pulse2,
                      reduceMotion: _reduceMotion,
                      cs: cs,
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        'Connecting to $doctorName',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$specialty · Voice consult',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Semantics(
                      liveRegion: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _reduceMotion
                              ? const SizedBox.shrink()
                              : SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: cs.primary,
                                  ),
                                ),
                          if (!_reduceMotion) const SizedBox(width: 9),
                          Flexible(
                            child: Text(
                              'Please wait — this usually takes a few seconds',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ext?.ink3 ?? cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Steps card ─────────────────────────────────────────────
              _StepsCard(steps: steps, cs: cs, ext: ext, theme: theme),

              const SizedBox(height: AppDimensions.space12),

              // ── Cancel / manual continue ───────────────────────────────
              if (_reduceMotion) ...[
                Semantics(
                  button: true,
                  label: 'Continue to consultation call',
                  child: SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: ElevatedButton(
                      onPressed: _goToCallRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusButton),
                        ),
                      ),
                      child: const ExcludeSemantics(
                        child: Text('Continue to call',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space12),
              ],

              Semantics(
                button: true,
                label: 'Cancel consultation',
                child: SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      _advanceTimer?.cancel();
                      HapticPatterns.warning();
                      SemanticsService.announce(
                          'Consultation cancelled.', TextDirection.ltr);
                      if (context.canPop()) context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.primary,
                      side: BorderSide(
                          color: ext?.line ?? cs.outline, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusButton),
                      ),
                    ),
                    child: const ExcludeSemantics(
                      child: Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _E2EBadge extends StatelessWidget {
  const _E2EBadge({required this.cs, required this.ext, required this.theme});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: 'End-to-end encrypted.',
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: ext?.line ?? cs.outline,
              width: 1.5,
            ),
          ),
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 16, color: ext?.ink2 ?? cs.onSurfaceVariant),
                const SizedBox(width: 7),
                Text(
                  'End-to-end encrypted',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ext?.ink2 ?? cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PulseAvatar extends StatelessWidget {
  const _PulseAvatar({
    required this.initials,
    required this.pulse1,
    required this.pulse2,
    required this.reduceMotion,
    required this.cs,
  });

  final String initials;
  final AnimationController pulse1;
  final AnimationController pulse2;
  final bool reduceMotion;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final pulseColor = cs.primary.withValues(alpha: 0.40);

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulse ring 1
          if (!reduceMotion)
            AnimatedBuilder(
              animation: pulse1,
              builder: (_, __) {
                final t = CurvedAnimation(
                  parent: pulse1,
                  curve: Curves.easeOut,
                ).value;
                return Transform.scale(
                  scale: 0.62 + 0.56 * t,
                  child: Opacity(
                    opacity: (0.5 * (1 - t)).clamp(0, 1),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pulseColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          // Outer pulse ring 2
          if (!reduceMotion)
            AnimatedBuilder(
              animation: pulse2,
              builder: (_, __) {
                final t = CurvedAnimation(
                  parent: pulse2,
                  curve: Curves.easeOut,
                ).value;
                return Transform.scale(
                  scale: 0.62 + 0.56 * t,
                  child: Opacity(
                    opacity: (0.5 * (1 - t)).clamp(0, 1),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: pulseColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          // Avatar
          ExcludeSemantics(
            child: Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [cs.primary, cs.secondary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.45),
                    blurRadius: 32,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({
    required this.steps,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final List<_Step> steps;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: ext?.line ?? cs.outline,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(height: 11),
            _StepRow(step: steps[i], cs: cs, ext: ext, theme: theme),
          ],
          const SizedBox(height: 13),
          // Audio guidance note
          MergeSemantics(
            child: Semantics(
              label: 'Audio guidance is on. You will hear a tone when the doctor joins.',
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ext?.blueTint ?? cs.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ExcludeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.volume_up_outlined,
                          size: 18, color: cs.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Audio guidance is on. You\'ll hear a tone when the doctor joins.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.primary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final _Step step;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color fgColor = step.done
        ? (ext?.green ?? Colors.green)
        : step.active
            ? cs.onSurface
            : (ext?.ink3 ?? cs.onSurfaceVariant);

    return Semantics(
      label: '${step.done ? 'Complete' : step.active ? 'In progress' : 'Pending'}. ${step.label}.',
      child: ExcludeSemantics(
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: step.done
                  ? Icon(Icons.check_circle_rounded,
                      size: 20, color: ext?.green ?? Colors.green)
                  : step.active
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(width: 13),
            Text(
              step.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: step.active ? FontWeight.w700 : FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step {
  const _Step({
    required this.label,
    this.done = false,
    this.active = false,
  });

  final String label;
  final bool done;
  final bool active;
}
