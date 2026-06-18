import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/widgets/consult_listen_button.dart';

/// Screen C7 — Consultation Summary & E-Rx.
///
/// Receives `Map<String, dynamic> {'doctor': DoctorEntity?}` via GoRouter extra.
///
/// Content is **session-only mock data** — never cached, never persisted to
/// local storage (🔒 medically sensitive per database_schema.md).
///
/// Actions:
/// - "Book follow-up" → pushes [consultBooking] with same doctor.
/// - "Save PDF" → stub (announces not yet available).
/// - "Send to pharmacy" → stub.
class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final doctor = extra?['doctor'] as DoctorEntity?;
    return _SummaryView(doctor: doctor);
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _SummaryView extends StatefulWidget {
  const _SummaryView({this.doctor});

  final DoctorEntity? doctor;

  @override
  State<_SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<_SummaryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Consultation complete. Your summary and prescription are ready. '
        'You can listen to the full summary or book a follow-up.',
      );
      HapticPatterns.success();
    });
  }

  void _bookFollowUp() {
    HapticPatterns.focusTick();
    if (widget.doctor != null) {
      context.push(
        AppRoutes.consultBooking.path,
        extra: {'doctor': widget.doctor},
      );
    } else {
      context.go(AppRoutes.consult.path);
    }
  }

  void _savePdf() {
    HapticPatterns.focusTick();
    SemanticsService.announce(
      'PDF export is not yet available. Check back soon.',
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final doctorName = widget.doctor?.fullName ?? 'Your Doctor';

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── App bar (no back arrow) ────────────────────────────────
            _AppBar(
              doctorName: doctorName,
              onDownload: _savePdf,
              cs: cs,
              ext: ext,
              theme: theme,
            ),

            // ── Scrollable body ────────────────────────────────────────
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.screenPadding,
                      AppDimensions.space16,
                      AppDimensions.screenPadding,
                      0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ── Done banner ──────────────────────────────────
                        _DoneBanner(cs: cs, ext: ext, theme: theme),
                        const SizedBox(height: AppDimensions.space16),

                        // ── Listen button ─────────────────────────────────
                        ConsultListenButton(
                          label: 'Listen to the full summary',
                          announcement:
                              'Summary: $doctorName recommends cleaning twice '
                              'daily, lubricating gel each night, and returning '
                              'in two weeks.',
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        // ── Doctor's notes ────────────────────────────────
                        _NotesCard(
                          doctorName: doctorName,
                          cs: cs,
                          ext: ext,
                          theme: theme,
                        ),
                        const SizedBox(height: AppDimensions.space16),

                        // ── E-prescription ────────────────────────────────
                        _RxCard(cs: cs, ext: ext, theme: theme),
                        const SizedBox(height: AppDimensions.space16),

                        // ── Follow-up recommendation ─────────────────────
                        _FollowUpCard(cs: cs, ext: ext, theme: theme),
                        const SizedBox(height: AppDimensions.space16),
                      ]),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom actions ─────────────────────────────────────────
            _BottomActions(
              onBookFollowUp: _bookFollowUp,
              onSavePdf: _savePdf,
              cs: cs,
              ext: ext,
              theme: theme,
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
  const _AppBar({
    required this.doctorName,
    required this.onDownload,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String doctorName;
  final VoidCallback onDownload;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.space16,
        AppDimensions.space12,
        AppDimensions.space12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consult Summary',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'with $doctorName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ext?.ink2 ?? cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Listen action
          Semantics(
            button: true,
            label: 'Listen to this page',
            child: _IconBtn(
              icon: Icons.volume_up_outlined,
              onTap: () {
                HapticPatterns.focusTick();
                SemanticsService.announce(
                  'Consult Summary with $doctorName. '
                  'Your prescription and notes are ready.',
                  TextDirection.ltr,
                );
              },
              cs: cs,
              ext: ext,
            ),
          ),
          const SizedBox(width: 8),
          // Download action
          Semantics(
            button: true,
            label: 'Download summary PDF',
            child: _IconBtn(
              icon: Icons.download_outlined,
              onTap: onDownload,
              cs: cs,
              ext: ext,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.cs,
    required this.ext,
  });

  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ExcludeSemantics(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ext?.line ?? cs.outline,
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: AppDimensions.iconMd, color: cs.onSurface),
        ),
      ),
    );
  }
}

class _DoneBanner extends StatelessWidget {
  const _DoneBanner({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final greenTint = ext?.greenTint ?? const Color(0xFFE6F9EE);
    final green = ext?.green ?? Colors.green;

    return MergeSemantics(
      child: Semantics(
        label: 'Consult complete.',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: greenTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consult complete',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: green,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your notes and prescription are ready below.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

class _NotesCard extends StatelessWidget {
  const _NotesCard({
    required this.doctorName,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final String doctorName;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  // Mock session-only note — never cached.
  static const _mockNote =
      'Patient reports mild redness and slight discharge from the prosthetic '
      'socket. Prosthesis is well-fitting with no structural damage observed. '
      'Advised cleaning twice daily with saline solution and application of '
      'lubricating gel each night. Return in two weeks for a fitting check.';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          "Doctor's notes. $_mockNote "
          "Summarized and read aloud automatically.",
      child: _Card(
        cs: cs,
        ext: ext,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: _CardHeader(
                icon: Icons.edit_note_rounded,
                label: "Doctor's Notes",
                cs: cs,
                ext: ext,
                theme: theme,
              ),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                _mockNote,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Summarized footer
            ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: (ext?.blueTint ?? cs.primaryContainer).withValues(
                    alpha: 0.6,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Summarized & read aloud automatically',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.primary,
                        ),
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

class _RxCard extends StatelessWidget {
  const _RxCard({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  // Mock Rx lines — session-only, never cached or stored locally.
  static const _rxItems = [
    _RxItem(name: 'Saline Eye Wash', dose: '0.9%', days: 30),
    _RxItem(name: 'Lubricating Eye Gel', dose: '0.2% gel', days: 30),
    _RxItem(name: 'Chloramphenicol', dose: '0.5% drops', days: 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'E-prescription. ${_rxItems.map((r) => '${r.name}, ${r.dose}, ${r.days} days').join('. ')}. '
          'Digitally signed. Valid for 30 days.',
      child: _Card(
        cs: cs,
        ext: ext,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: _CardHeader(
                icon: Icons.medication_outlined,
                label: 'E-Prescription',
                cs: cs,
                ext: ext,
                theme: theme,
              ),
            ),
            const SizedBox(height: 14),

            // Medication rows
            for (int i = 0; i < _rxItems.length; i++) ...[
              if (i > 0) ...[
                const SizedBox(height: 4),
                Divider(
                  color: (ext?.line ?? cs.outline).withValues(alpha: 0.5),
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 4),
              ],
              ExcludeSemantics(
                child: _RxRow(
                  item: _rxItems[i],
                  cs: cs,
                  ext: ext,
                  theme: theme,
                ),
              ),
            ],

            const SizedBox(height: 14),

            // Signed footer
            ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ext?.line ?? cs.outline,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: ext?.ink2 ?? cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Digitally signed · valid 30 days',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ext?.ink2 ?? cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        HapticPatterns.focusTick();
                        SemanticsService.announce(
                          'Pharmacy integration is coming soon.',
                          TextDirection.ltr,
                        );
                      },
                      child: Text(
                        'Send to pharmacy',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                          decoration: TextDecoration.underline,
                        ),
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

class _RxRow extends StatelessWidget {
  const _RxRow({
    required this.item,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final _RxItem item;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: (ext?.blueTint ?? cs.primaryContainer),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.medication_outlined, size: 20, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.dose,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ext?.ink2 ?? cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ext?.line ?? cs.outline,
                width: 1.5,
              ),
            ),
            child: Text(
              '${item.days} days',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowUpCard extends StatelessWidget {
  const _FollowUpCard({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Recommended follow-up. Return in 2 weeks for a fitting check.',
      child: _Card(
        cs: cs,
        ext: ext,
        child: ExcludeSemantics(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ext?.greenTint ?? const Color(0xFFE6F9EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: ext?.green ?? Colors.green,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Follow-Up',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Return in 2 weeks for a fitting check',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext?.ink2 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.onBookFollowUp,
    required this.onSavePdf,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final VoidCallback onBookFollowUp;
  final VoidCallback onSavePdf;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final isLargeText = MediaQuery.textScalerOf(context).scale(1.0) > 1.25;

    final savePdfButton = Semantics(
      button: true,
      label: 'Save PDF',
      child: OutlinedButton(
        onPressed: onSavePdf,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          foregroundColor: cs.primary,
          side: BorderSide(
            color: ext?.line ?? cs.outline,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
        ),
        child: ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download_outlined, size: AppDimensions.iconSm),
              const SizedBox(width: 7),
              const Flexible(
                child: Text(
                  'Save PDF',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final bookFollowUpButton = Semantics(
      button: true,
      label: 'Book a follow-up consultation',
      child: ElevatedButton(
        onPressed: onBookFollowUp,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          ),
          elevation: 0,
        ),
        child: ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  'Book follow-up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        AppDimensions.space12,
        AppDimensions.screenPadding,
        AppDimensions.space12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(
          top: BorderSide(
            color: (ext?.line ?? cs.outline).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      child: isLargeText
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                bookFollowUpButton,
                const SizedBox(height: 12),
                savePdfButton,
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: savePdfButton,
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: bookFollowUpButton,
                ),
              ],
            ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.cs, required this.ext, required this.child});

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(
          color: ext?.line ?? cs.outline,
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.icon,
    required this.label,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: cs.primary),
        const SizedBox(width: 9),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _RxItem {
  const _RxItem({
    required this.name,
    required this.dose,
    required this.days,
  });

  final String name;
  final String dose;
  final int days;
}
