import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';

/// Tappable card showing a doctor with avatar + online indicator, name,
/// specialty, star rating, review count, and availability status.
///
/// Navigates to `consultDoctorProfile` on tap, passing the [DoctorEntity]
/// as GoRouter extra.
///
/// [isOnline] and [rating]/[reviewCount] are mock values until the backend
/// hydrates them from `doctors` → `doctor_stats` table (TODO: backend A-6).
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    required this.doctor,
    super.key,
    // TODO(backend): these come from the `doctors` → `doctor_stats` join.
    this.rating = 4.8,
    this.reviewCount = 200,
    this.isOnline = false,
    this.availabilityLabel = 'In 10 min',
  });

  final DoctorEntity doctor;

  /// Star rating (1.0–5.0).  Mock until backend hydration.
  final double rating;

  /// Total review count. Mock until backend hydration.
  final int reviewCount;

  /// Whether the doctor is online / available now. Mock until backend hydration.
  final bool isOnline;

  /// Human-readable availability string, e.g. "Available now" or "In 10 min".
  final String availabilityLabel;

  String get _initials {
    final name = doctor.fullName;
    if (name == null || name.trim().isEmpty) return 'DR';
    return name
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color green = ext?.green ?? Colors.green;
    final Color amber = const Color(0xFFF59E0B);

    final String displayName = doctor.fullName ?? 'Doctor';
    final String statusLabel =
        isOnline ? 'Available now' : availabilityLabel;

    final String semanticsLabel = '$displayName, ${doctor.specialty}. '
        'Rating $rating, $reviewCount reviews. $statusLabel.'
        '${doctor.isVerified ? ' Verified doctor.' : ''}';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: () {
          HapticPatterns.focusTick();
          context.push('/consult/doctor/${doctor.id}', extra: doctor);
        },
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Avatar + online dot ────────────────────────────────────
                SizedBox(
                  width: 58,
                  height: 58,
                  child: Stack(
                    children: [
                      doctor.avatarUrl != null
                          ? CircleAvatar(
                              radius: 29,
                              backgroundImage:
                                  NetworkImage(doctor.avatarUrl!),
                              backgroundColor: cs.primary,
                            )
                          : CircleAvatar(
                              radius: 29,
                              backgroundColor: cs.primary,
                              child: Text(
                                _initials,
                                style:
                                    theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      if (isOnline)
                        Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: blueTint,
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: AppDimensions.space12),

                // ── Info block ─────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + verified
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style:
                                  theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                                letterSpacing: -0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (doctor.isVerified) ...[
                            const SizedBox(width: 5),
                            Icon(
                              Icons.verified_rounded,
                              size: 15,
                              color: cs.primary,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Specialty
                      Text(
                        doctor.specialty,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Rating · reviews
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 15, color: amber),
                          const SizedBox(width: 3),
                          Text(
                            rating.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '·',
                            style: TextStyle(
                                color: line, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$reviewCount reviews',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ink3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      // Availability dot + label
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOnline ? green : ink3,
                              boxShadow: isOnline
                                  ? [
                                      BoxShadow(
                                        color: green.withValues(alpha: 0.35),
                                        blurRadius: 0,
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isOnline ? green : ink3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Chevron ────────────────────────────────────────────────
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: ink3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
