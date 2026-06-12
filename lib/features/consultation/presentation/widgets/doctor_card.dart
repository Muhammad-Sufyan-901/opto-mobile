import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Tappable card showing a doctor's name, specialty, clinic, and verified status.
///
/// Navigates to consultDoctorProfile on tap, passing the [DoctorEntity] as
/// GoRouter extra.
class DoctorCard extends StatelessWidget {
  const DoctorCard({required this.doctor, super.key});

  final DoctorEntity doctor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final String displayName = doctor.fullName ?? 'Doctor';
    final String semanticsLabel =
        '$displayName, ${doctor.specialty}${doctor.isVerified ? ', verified' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: () {
          context.push('/consult/doctor/${doctor.id}', extra: doctor);
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.space12,
            horizontal: AppDimensions.screenPadding,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                // ── Avatar circle ──────────────────────────────────────────
                _DoctorAvatar(doctor: doctor, cs: cs, blueTint: blueTint),

                const SizedBox(width: AppDimensions.space12),

                // ── Name + specialty + clinic ──────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        displayName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Specialty
                      Text(
                        doctor.specialty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
                      ),
                      if (doctor.clinicName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          doctor.clinicName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Verified chip ──────────────────────────────────────────
                if (doctor.isVerified) ...[
                  const SizedBox(width: AppDimensions.space8),
                  _VerifiedChip(cs: cs),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Circular avatar — shows a [NetworkImage] if [doctor.avatarUrl] is present,
/// otherwise renders the doctor's initials on a primary-colored background.
class _DoctorAvatar extends StatelessWidget {
  const _DoctorAvatar({
    required this.doctor,
    required this.cs,
    required this.blueTint,
  });

  final DoctorEntity doctor;
  final ColorScheme cs;
  final Color blueTint;

  String get _initials {
    final name = doctor.fullName;
    if (name == null || name.trim().isEmpty) return 'DR';
    final parts = name.trim().split(' ');
    return parts
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 42,
      height: 42,
      child: doctor.avatarUrl != null
          ? CircleAvatar(
              radius: 21,
              backgroundImage: NetworkImage(doctor.avatarUrl!),
              backgroundColor: blueTint,
            )
          : CircleAvatar(
              radius: 21,
              backgroundColor: cs.primary,
              child: Text(
                _initials,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

/// Small blue chip shown when [DoctorEntity.isVerified] is true.
class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color bgColor = ext?.blueTint ?? cs.primaryContainer;
    final Color textColor = cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space4,
        horizontal: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            'Verified',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
