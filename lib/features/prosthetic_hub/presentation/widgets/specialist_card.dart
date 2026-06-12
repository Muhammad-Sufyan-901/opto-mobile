// Widget: SpecialistCard
//
// Single row card in the Specialist Directory list. Visual style mirrors
// [CareGuideCard] and [_HubLink] in `prosthetic_hub_screen.dart` — avatar,
// name, specialty, verified chip, replies label, trailing chevron.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';

/// An accessible, tappable card representing a single [Specialist].
///
/// Semantics label:
/// "{fullName}. {specialty}[, verified]. {repliesLabel}."
///
/// All decorative elements (avatar, verified chip, chevron) are wrapped in
/// [ExcludeSemantics]. Minimum tap target is 72dp height.
class SpecialistCard extends StatelessWidget {
  const SpecialistCard({
    super.key,
    required this.specialist,
    required this.onTap,
  });

  final Specialist specialist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String semanticsLabel =
        '${specialist.fullName}. ${specialist.specialty}'
        '${specialist.isVerified ? ", verified" : ""}.'
        ' ${specialist.repliesLabel}.';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Avatar (42×42) ──────────────────────────────────────────
              ExcludeSemantics(
                child: _SpecialistAvatar(
                  specialist: specialist,
                  blueStrong: blueStrong,
                  blueTint: blueTint,
                ),
              ),

              const SizedBox(width: 14),

              // ── Text column ──────────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name
                      Text(
                        specialist.fullName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Specialty
                      Text(
                        specialist.specialty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
                      ),
                      // Clinic name
                      if (specialist.clinicName != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          specialist.clinicName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink3,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      const SizedBox(height: 5),
                      // Verified chip + replies label row
                      Row(
                        children: [
                          if (specialist.isVerified) ...[
                            _VerifiedChip(
                              blueStrong: blueStrong,
                              blueTint: blueTint,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              specialist.repliesLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: ink3,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Trailing chevron ─────────────────────────────────────────
              ExcludeSemantics(
                child: Icon(Icons.chevron_right, size: 22, color: ink3),
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

/// 42×42 circle avatar showing initials when no [avatarUrl] is available.
class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({
    required this.specialist,
    required this.blueStrong,
    required this.blueTint,
  });

  final Specialist specialist;
  final Color blueStrong;
  final Color blueTint;

  String get _initials {
    final parts = specialist.fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    // Use first letter of first non-title word and last word.
    final filtered = parts.where((p) => !p.endsWith('.')).toList();
    if (filtered.isEmpty) return parts.first[0].toUpperCase();
    if (filtered.length == 1) return filtered.first[0].toUpperCase();
    return '${filtered.first[0]}${filtered.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (specialist.avatarUrl != null) {
      return CircleAvatar(
        radius: 21,
        backgroundImage: NetworkImage(specialist.avatarUrl!),
        backgroundColor: Colors.transparent,
      );
    }
    return CircleAvatar(
      radius: 21,
      backgroundColor: blueTint,
      child: Text(
        _initials,
        style: TextStyle(
          color: blueStrong,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Small "Verified" chip with a check-outlined icon.
class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip({required this.blueStrong, required this.blueTint});

  final Color blueStrong;
  final Color blueTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_outlined,
            size: AppDimensions.iconSm,
            color: blueStrong,
          ),
          const SizedBox(width: 3),
          Text(
            'Verified',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: blueStrong,
            ),
          ),
        ],
      ),
    );
  }
}
