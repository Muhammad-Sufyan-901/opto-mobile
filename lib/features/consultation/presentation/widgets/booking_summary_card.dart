import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/consultation_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_availability_entity.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Summary card shown on the booking confirmation screen.
///
/// Displays the slot date/time, the doctor's name (if provided), and the
/// selected consultation mode. Wrapped in [MergeSemantics] so the screen
/// reader reads the whole card as one unit.
class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    required this.slot,
    required this.mode,
    this.doctor,
    super.key,
  });

  final DoctorAvailabilityEntity slot;
  final DoctorEntity? doctor;
  final ConsultMode mode;

  /// Returns a human-readable label for [ConsultMode].
  static String modeLabel(ConsultMode mode) {
    switch (mode) {
      case ConsultMode.voice:
        return 'Voice call';
      case ConsultMode.video:
        return 'Video call (coming soon)';
      case ConsultMode.nonVerbal:
        return 'Non-verbal session';
      case ConsultMode.inPerson:
        return 'In-person';
    }
  }

  /// Formats a slot's date/time range: e.g. "Mon, 10 Jun · 09:00–10:00"
  static String _formatSlot(DoctorAvailabilityEntity slot) {
    final start = slot.slotStart.toLocal();
    final end = slot.slotEnd.toLocal();
    final datePart = DateFormat('EEE, d MMM', 'en_US').format(start);
    final startTime = DateFormat('HH:mm', 'en_US').format(start);
    final endTime = DateFormat('HH:mm', 'en_US').format(end);
    return '$datePart · $startTime–$endTime';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color bgColor = ext?.blueTint ?? cs.primaryContainer;
    final Color borderColor = cs.primary.withValues(alpha: 0.22);
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    final String formattedSlot = _formatSlot(slot);
    final String doctorName = doctor?.fullName ?? 'Doctor';
    final String mode_ = modeLabel(mode);

    return MergeSemantics(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Eyebrow ──────────────────────────────────────────────────
            ExcludeSemantics(
              child: Text(
                'BOOKING SUMMARY',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: cs.primary,
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.space12),

            // ── Slot date/time ────────────────────────────────────────────
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: formattedSlot,
              cs: cs,
              ink2: ink2,
              theme: theme,
            ),

            const SizedBox(height: AppDimensions.space8),

            // ── Doctor name ───────────────────────────────────────────────
            if (doctor != null)
              _InfoRow(
                icon: Icons.person_outline,
                label: doctorName,
                cs: cs,
                ink2: ink2,
                theme: theme,
              ),

            if (doctor != null) const SizedBox(height: AppDimensions.space8),

            // ── Session mode ──────────────────────────────────────────────
            _InfoRow(
              icon: Icons.videocam_outlined,
              label: mode_,
              cs: cs,
              ink2: ink2,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.cs,
    required this.ink2,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ColorScheme cs;
  final Color ink2;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(icon, size: AppDimensions.iconMd, color: ink2),
        ),
        const SizedBox(width: AppDimensions.space8),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
