import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/widgets/consult_listen_button.dart';

/// Screen C2 — Doctor Profile & Modality Picker.
///
/// Receives a [DoctorEntity] via GoRouter [state.extra].
/// Allows the user to read/listen to the doctor's profile and choose a
/// consultation modality (voice/video/text) before booking.
///
/// Availability slot selection moved to Screen C3 (BookingScreen).
class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = GoRouterState.of(context).extra as DoctorEntity;
    return _DoctorProfileView(doctor: doctor);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _DoctorProfileView extends StatefulWidget {
  const _DoctorProfileView({required this.doctor});

  final DoctorEntity doctor;

  @override
  State<_DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<_DoctorProfileView> {
  ConsultMode _selectedMode = ConsultMode.voice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final name = widget.doctor.fullName ?? 'Doctor';
      announce(
        context,
        'Doctor profile. $name, ${widget.doctor.specialty}. '
        'Available now. Choose how you would like to consult.',
      );
    });
  }

  String get _initials {
    final name = widget.doctor.fullName;
    if (name == null || name.trim().isEmpty) return 'DR';
    return name
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
  }

  String get _modeLabel {
    switch (_selectedMode) {
      case ConsultMode.voice:
        return 'Voice consult · 30 min';
      case ConsultMode.video:
        return 'Video consult · 30 min';
      case ConsultMode.nonVerbal:
        return 'Text consult · 30 min';
      case ConsultMode.inPerson:
        return 'In-person · 45 min';
    }
  }

  /// Doctor about text.
  /// TODO(backend): hydrate from `doctors.bio` field when schema adds it.
  String get _about {
    final spec = widget.doctor.specialty.toLowerCase();
    if (spec.contains('prosthetic') || spec.contains('prosthesis')) {
      return 'Specialist in custom ocular prosthetics and post-enucleation care. '
          'Fits and maintains artificial eyes, and supports patients adapting to '
          'low vision. Speaks Bahasa Indonesia & English.';
    }
    if (spec.contains('low vision') || spec.contains('rehabilitation')) {
      return 'Expert in low-vision rehabilitation and assistive optical devices. '
          'Works with patients of all ages to maximise their remaining vision and '
          'independence. Speaks Bahasa Indonesia & English.';
    }
    return 'Experienced eye-care specialist providing personalised consultations '
        'for vision and ocular health. Committed to accessible, patient-centred care. '
        'Speaks Bahasa Indonesia & English.';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final String displayName = widget.doctor.fullName ?? 'Doctor';

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          // ── Scrollable body ────────────────────────────────────────────────
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: AppDimensions.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── App bar (back + listen + favourite) ──────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                                    child: Icon(
                                      Icons.chevron_left_rounded,
                                      size: 28,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Semantics(
                            button: true,
                            label: 'Listen to doctor profile',
                            child: GestureDetector(
                              onTap: () {
                                HapticPatterns.focusTick();
                                SemanticsService.announce(
                                  '$displayName, ${widget.doctor.specialty}. '
                                  '${_about} '
                                  'Voice consult recommended, average wait under 2 minutes.',
                                  TextDirection.ltr,
                                );
                              },
                              child: Container(
                                width: AppDimensions.minTapTarget,
                                height: AppDimensions.minTapTarget,
                                decoration: BoxDecoration(
                                  color: ext?.blueTint ?? cs.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: ExcludeSemantics(
                                  child: Icon(
                                    Icons.volume_up_outlined,
                                    size: AppDimensions.iconLg,
                                    color: cs.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: 'Save doctor to favourites',
                            child: GestureDetector(
                              onTap: () {
                                // TODO(consult): toggle favourite
                              },
                              child: SizedBox(
                                width: AppDimensions.minTapTarget,
                                height: AppDimensions.minTapTarget,
                                child: Center(
                                  child: ExcludeSemantics(
                                    child: Icon(
                                      Icons.favorite_border_rounded,
                                      size: AppDimensions.iconLg,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Centered doctor profile header ───────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppDimensions.space8),

                          // Avatar
                          MergeSemantics(
                            child: Semantics(
                              label:
                                  '$displayName, ${widget.doctor.specialty}. '
                                  '${widget.doctor.isVerified ? 'Verified doctor. ' : ''}'
                                  '${widget.doctor.clinicName != null ? widget.doctor.clinicName! + '. ' : ''}'
                                  'Available now.',
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      ExcludeSemantics(
                                        child: widget.doctor.avatarUrl != null
                                            ? CircleAvatar(
                                                radius: 48,
                                                backgroundImage: NetworkImage(
                                                    widget.doctor.avatarUrl!),
                                                backgroundColor: cs.primary,
                                              )
                                            : Container(
                                                width: 96,
                                                height: 96,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      cs.primary,
                                                      cs.secondary,
                                                    ],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: cs.primary
                                                          .withValues(alpha: 0.40),
                                                      blurRadius: 24,
                                                      offset:
                                                          const Offset(0, 12),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _initials,
                                                    style: theme
                                                        .textTheme.headlineMedium
                                                        ?.copyWith(
                                                      fontWeight: FontWeight.w800,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      // Online indicator
                                      ExcludeSemantics(
                                        child: Positioned(
                                          bottom: 3,
                                          right: 3,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: ext?.green ?? Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: cs.surface,
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: AppDimensions.space16),

                                  // Name + verified
                                  ExcludeSemantics(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            displayName,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: cs.onSurface,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                        ),
                                        if (widget.doctor.isVerified) ...[
                                          const SizedBox(width: 7),
                                          Icon(
                                            Icons.verified_rounded,
                                            size: 18,
                                            color: cs.primary,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // Specialty
                                  ExcludeSemantics(
                                    child: Text(
                                      widget.doctor.specialty,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Availability line
                                  ExcludeSemantics(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ext?.green ?? Colors.green,
                                            boxShadow: [
                                              BoxShadow(
                                                color: (ext?.green ??
                                                        Colors.green)
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 0,
                                                spreadRadius: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 7),
                                        Text(
                                          widget.doctor.clinicName != null
                                              ? 'Available now · ${widget.doctor.clinicName}'
                                              : 'Available now',
                                          style:
                                              theme.textTheme.labelMedium?.copyWith(
                                            color: ext?.green ?? Colors.green,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space16),

                          // ── Stats row ──────────────────────────────────────
                          _StatsRow(cs: cs, ext: ext, theme: theme),

                          const SizedBox(height: AppDimensions.space16),

                          // ── Listen button ──────────────────────────────────
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ConsultListenButton(
                              label: "Listen to doctor's profile",
                              announcement:
                                  '$displayName, ${widget.doctor.specialty}. '
                                  'Rating 4.9 out of 5, 320 reviews, 12 years experience. '
                                  '$_about',
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space16),

                          // ── About ──────────────────────────────────────────
                          _SectionLabel(label: 'ABOUT', cs: cs, theme: theme),
                          const SizedBox(height: AppDimensions.space8),
                          Semantics(
                            label: _about,
                            child: ExcludeSemantics(
                              child: Text(
                                _about,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                                  height: 1.55,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppDimensions.space24),

                          // ── Modality picker ────────────────────────────────
                          _SectionLabel(
                            label: 'HOW WOULD YOU LIKE TO CONSULT?',
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          _ModalityPicker(
                            selected: _selectedMode,
                            onSelect: (m) => setState(() => _selectedMode = m),
                            cs: cs,
                            ext: ext,
                            theme: theme,
                          ),

                          const SizedBox(height: AppDimensions.space8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Sticky bottom bar ──────────────────────────────────────────────
          SafeArea(
            top: false,
            child: _StickyBar(
              modeLabel: _modeLabel,
              selectedMode: _selectedMode,
              doctor: widget.doctor,
              cs: cs,
              ext: ext,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.cs, required this.ext, required this.theme});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // TODO(backend): hydrate from doctor_stats join.
    const stats = [
      _Stat(value: '4.9', label: 'Rating'),
      _Stat(value: '12 yr', label: 'Experience'),
      _Stat(value: '320', label: 'Reviews'),
    ];
    final Color line = ext?.line ?? cs.outline;
    const Color amber = Color(0xFFF59E0B);

    return MergeSemantics(
      child: Semantics(
        label: 'Rating 4.9. 12 years experience. 320 reviews.',
        child: Container(
          decoration: BoxDecoration(
            color: ext?.blueTint ?? cs.primaryContainer,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  for (int i = 0; i < stats.length; i++) ...[
                    if (i > 0)
                      VerticalDivider(
                          width: 1.5, thickness: 1.5, color: line),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (i == 0) ...[
                                  const Icon(Icons.star_rounded,
                                      size: 16, color: amber),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  stats[i].value,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: cs.onSurface,
                                    letterSpacing: -0.4,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              stats[i].label.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: ext?.ink3 ?? cs.onSurfaceVariant,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModalityPicker extends StatelessWidget {
  const _ModalityPicker({
    required this.selected,
    required this.onSelect,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ConsultMode selected;
  final ValueChanged<ConsultMode> onSelect;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    const modes = [
      _ModeOption(
        mode: ConsultMode.voice,
        icon: Icons.call_rounded,
        label: 'Voice call',
        sub: 'Recommended · audio-guided',
        tag: 'Best for you',
      ),
      _ModeOption(
        mode: ConsultMode.video,
        icon: Icons.videocam_outlined,
        label: 'Video call',
        sub: 'Show your eye to the doctor',
      ),
      _ModeOption(
        mode: ConsultMode.nonVerbal,
        icon: Icons.chat_bubble_outline_rounded,
        label: 'Text chat',
        sub: 'Type with screen reader',
      ),
    ];

    return Column(
      children: [
        for (final m in modes)
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: _ModalityRow(
              option: m,
              isSelected: selected == m.mode,
              onTap: () => onSelect(m.mode),
              cs: cs,
              ext: ext,
              theme: theme,
            ),
          ),
      ],
    );
  }
}

class _ModalityRow extends StatelessWidget {
  const _ModalityRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final _ModeOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final String semanticsLabel =
        '${option.label}. ${option.sub}'
        '${option.tag != null ? '. ${option.tag}' : ''}'
        '${isSelected ? '. Selected' : ''}';

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: isSelected ? blueTint : cs.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? cs.primary : line,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                // Icon box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary : cs.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? cs.primary : line,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    option.icon,
                    size: AppDimensions.iconLg,
                    color: isSelected ? Colors.white : cs.primary,
                  ),
                ),

                const SizedBox(width: AppDimensions.space12),

                // Label + sub + tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            option.label,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (option.tag != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                color: ext?.green ?? Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option.tag!,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10.5,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        option.sub,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ext?.ink2 ?? cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppDimensions.space12),

                // Radio
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? cs.primary : line,
                      width: 2.5,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyBar extends StatelessWidget {
  const _StickyBar({
    required this.modeLabel,
    required this.selectedMode,
    required this.doctor,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String modeLabel;
  final ConsultMode selectedMode;
  final DoctorEntity doctor;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final Color line = ext?.line ?? cs.outline;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        14,
        AppDimensions.screenPadding,
        14,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: line, width: 1.5)),
      ),
      child: Row(
        children: [
          // Price info
          ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  modeLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Rp 90.000', // TODO(backend): hydrate from doctor pricing
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: -0.3,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppDimensions.space16),

          // Choose a time CTA
          Expanded(
            child: Semantics(
              button: true,
              label: 'Choose a time. $modeLabel. Rp 90.000.',
              child: SizedBox(
                height: AppDimensions.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticPatterns.focusTick();
                    context.push(
                      AppRoutes.consultBooking.path,
                      extra: {
                        'doctor': doctor,
                        'mode': selectedMode,
                      },
                    );
                  },
                  icon: const ExcludeSemantics(child: SizedBox.shrink()),
                  label: const ExcludeSemantics(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Choose a time',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusButton),
                    ),
                    padding: EdgeInsets.zero,
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
    return Align(
      alignment: Alignment.centerLeft,
      child: ExcludeSemantics(
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────

class _Stat {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;
}

class _ModeOption {
  const _ModeOption({
    required this.mode,
    required this.icon,
    required this.label,
    required this.sub,
    this.tag,
  });

  final ConsultMode mode;
  final IconData icon;
  final String label;
  final String sub;
  final String? tag;
}
