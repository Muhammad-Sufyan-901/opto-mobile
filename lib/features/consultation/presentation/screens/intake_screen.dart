import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Screen C4 — Pre-consult Intake.
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity}` via GoRouter extra.
///
/// Voice-first: patients can tap multi-select reason chips, record a voice note
/// (placeholder), type a text note, and optionally attach an eye photo. No backend
/// persistence — data is held in local state and described as a summary to
/// TalkBack on screen entry.
class IntakeScreen extends StatelessWidget {
  const IntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final doctor = extra['doctor'] as DoctorEntity;
    return _IntakeView(doctor: doctor);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _IntakeView extends StatefulWidget {
  const _IntakeView({required this.doctor});

  final DoctorEntity doctor;

  @override
  State<_IntakeView> createState() => _IntakeViewState();
}

class _IntakeViewState extends State<_IntakeView>
    with SingleTickerProviderStateMixin {
  static const _reasons = [
    'Prosthesis discomfort',
    'Redness or irritation',
    'Blurred vision',
    'Dryness',
    'Discharge',
    'Routine check',
    'Fitting issue',
  ];

  final Set<String> _selectedReasons = {
    'Prosthesis discomfort',
    'Redness or irritation',
  };

  final TextEditingController _notesCtrl = TextEditingController();

  /// Wave animation for the voice-note affordance.
  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Before your consult with ${widget.doctor.fullName ?? 'the doctor'}. '
        'Step 3 of 3. Tell the doctor what\'s going on. '
        'Select the reasons that apply, then describe your symptoms.',
      );
      if (!MediaQuery.of(context).disableAnimations) {
        _waveCtrl.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _toggleReason(String r) {
    HapticPatterns.focusTick();
    setState(() {
      if (_selectedReasons.contains(r)) {
        _selectedReasons.remove(r);
      } else {
        _selectedReasons.add(r);
      }
    });
    SemanticsService.announce(
      _selectedReasons.contains(r) ? '$r selected.' : '$r deselected.',
      TextDirection.ltr,
    );
  }

  void _onContinue() {
    HapticPatterns.focusTick();
    SemanticsService.announce(
      'Connecting you to ${widget.doctor.fullName ?? 'your doctor'}.',
      TextDirection.ltr,
    );
    context.push(
      AppRoutes.consultConnecting.path,
      extra: {'doctor': widget.doctor},
    );
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
          children: [
            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── App bar ──────────────────────────────────────────
                    _AppBar(cs: cs, theme: theme),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppDimensions.space12),

                          // ── Progress indicator ───────────────────────
                          _ProgressSteps(cs: cs, ext: ext, theme: theme),

                          const SizedBox(height: AppDimensions.space20),

                          // ── Reason chips ─────────────────────────────
                          _SectionLabel(
                            label: "WHAT BRINGS YOU IN TODAY?",
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          _ReasonChips(
                            reasons: _reasons,
                            selected: _selectedReasons,
                            onToggle: _toggleReason,
                            cs: cs,
                            ext: ext,
                            theme: theme,
                          ),

                          const SizedBox(height: AppDimensions.space20),

                          // ── Voice note ───────────────────────────────
                          _SectionLabel(
                            label: 'DESCRIBE IT IN YOUR OWN WORDS',
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          _VoiceNote(
                            waveCtrl: _waveCtrl,
                            cs: cs,
                            ext: ext,
                            theme: theme,
                          ),

                          const SizedBox(height: AppDimensions.space12),

                          // ── Text notes ───────────────────────────────
                          _NotesField(
                            controller: _notesCtrl,
                            cs: cs,
                            ext: ext,
                            theme: theme,
                          ),

                          const SizedBox(height: AppDimensions.space20),

                          // ── Photo attach ─────────────────────────────
                          _SectionLabel(
                            label: 'ADD A PHOTO OF THE EYE (OPTIONAL)',
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          _PhotoAttach(cs: cs, ext: ext, theme: theme),

                          const SizedBox(height: AppDimensions.space24),

                          // ── CTA ──────────────────────────────────────
                          Semantics(
                            button: true,
                            label: 'Continue to consult with ${widget.doctor.fullName ?? 'doctor'}.',
                            child: SizedBox(
                              height: AppDimensions.buttonHeight,
                              child: ElevatedButton(
                                onPressed: _onContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusButton),
                                  ),
                                ),
                                child: const ExcludeSemantics(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Continue to consult',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

class _AppBar extends StatelessWidget {
  const _AppBar({required this.cs, required this.theme});

  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
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
                    child: Icon(Icons.chevron_left_rounded,
                        size: 28, color: cs.onSurface),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                'Before Your Consult',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Listen to page instructions',
            child: GestureDetector(
              onTap: () {
                HapticPatterns.focusTick();
                SemanticsService.announce(
                  'Before Your Consult. Step 3 of 3. Select reasons for your visit, '
                  'then describe your symptoms by voice or text. A photo is optional.',
                  TextDirection.ltr,
                );
              },
              child: Container(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppExtendedCustomColors>()
                      ?.blueTint,
                  shape: BoxShape.circle,
                ),
                child: ExcludeSemantics(
                  child: Icon(Icons.volume_up_outlined,
                      size: AppDimensions.iconLg, color: cs.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressSteps extends StatelessWidget {
  const _ProgressSteps({required this.cs, required this.ext, required this.theme});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: 'Step 3 of 3. Tell the doctor what\'s going on.',
        child: ExcludeSemantics(
          child: Row(
            children: [
              _Step(filled: true, active: false, cs: cs, ext: ext),
              const SizedBox(width: 7),
              _Step(filled: true, active: false, cs: cs, ext: ext),
              const SizedBox(width: 7),
              _Step(filled: true, active: true, cs: cs, ext: ext),
              const SizedBox(width: 8),
              Text(
                'Step 3 of 3 · Tell the doctor what\'s going on',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.filled,
    required this.active,
    required this.cs,
    required this.ext,
  });

  final bool filled;
  final bool active;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 50 : 34,
      height: 6,
      decoration: BoxDecoration(
        color: filled ? cs.primary : (ext?.line ?? cs.outline),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.cs,
    required this.theme,
  });

  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ReasonChips extends StatelessWidget {
  const _ReasonChips({
    required this.reasons,
    required this.selected,
    required this.onToggle,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final List<String> reasons;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: [
        for (final r in reasons)
          Semantics(
            button: true,
            selected: selected.contains(r),
            label: selected.contains(r) ? '$r, selected. Tap to deselect.' : '$r. Tap to select.',
            child: GestureDetector(
              onTap: () => onToggle(r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 130),
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: selected.contains(r)
                      ? (ext?.blueTint ?? cs.primaryContainer)
                      : cs.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected.contains(r)
                        ? cs.primary
                        : (ext?.line ?? cs.outline),
                    width: selected.contains(r) ? 2 : 1.5,
                  ),
                ),
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selected.contains(r)) ...[
                        Icon(Icons.check_circle_rounded,
                            size: 16, color: cs.primary),
                        const SizedBox(width: 7),
                      ],
                      Text(
                        r,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selected.contains(r)
                              ? cs.primary
                              : (ext?.ink2 ?? cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _VoiceNote extends StatelessWidget {
  const _VoiceNote({
    required this.waveCtrl,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final AnimationController waveCtrl;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  static const _barHeights = [10.0, 18.0, 8.0, 22.0, 14.0, 26.0, 12.0, 20.0, 9.0, 16.0];

  @override
  Widget build(BuildContext context) {
    final Color tint = ext?.blueTint ?? cs.primaryContainer;
    final Color borderColor = cs.primary.withValues(alpha: 0.24);

    return Semantics(
      button: true,
      label: 'Hold to record a voice note. Or type notes below.',
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          SemanticsService.announce(
            'Voice recording. Hold this button to record your symptoms. '
            'You can also type in the notes field below.',
            TextDirection.ltr,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                // Mic button
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.40),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic_rounded,
                      size: 26, color: Colors.white),
                ),

                const SizedBox(width: AppDimensions.space12),

                // Labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hold to record a voice note',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Or type below — both reach the doctor',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ext?.ink2 ?? cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppDimensions.space12),

                // Animated waveform
                SizedBox(
                  height: 34,
                  child: AnimatedBuilder(
                    animation: waveCtrl,
                    builder: (_, __) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (int i = 0; i < _barHeights.length; i++) ...[
                            if (i > 0) const SizedBox(width: 3),
                            Container(
                              width: 3.5,
                              height: (_barHeights[i] *
                                      (0.35 +
                                          0.65 *
                                              ((1 +
                                                      _barHeights[i] /
                                                          26.0 *
                                                          waveCtrl.value) /
                                                  2)))
                                  .clamp(4.0, 28.0),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
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

class _NotesField extends StatelessWidget {
  const _NotesField({
    required this.controller,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final TextEditingController controller;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Type how things feel…',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: ext?.ink3 ?? cs.onSurfaceVariant,
            ),
            labelText: 'Notes',
            labelStyle: theme.textTheme.labelSmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: ext?.line ?? cs.outline,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }
}

class _PhotoAttach extends StatelessWidget {
  const _PhotoAttach({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color tint = ext?.blueTint ?? cs.primaryContainer;
    final Color line2 = ext?.divider ?? cs.outlineVariant;

    return Semantics(
      button: true,
      label: 'Take or upload a photo of your eye. Optional. Helps the doctor see redness or fit.',
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          // TODO(consult): open camera / gallery picker
          SemanticsService.announce(
            'Photo picker. Camera and gallery access will be available in a future update.',
            TextDirection.ltr,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: line2,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.photo_camera_outlined,
                      size: 26, color: cs.primary),
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take or upload a photo',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Helps the doctor see redness or fit',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ext?.ink2 ?? cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.attach_file_rounded,
                    size: 22, color: cs.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
