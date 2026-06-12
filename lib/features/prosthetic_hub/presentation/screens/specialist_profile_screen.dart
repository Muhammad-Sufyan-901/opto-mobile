// Screen: Specialist Profile (Prosthetic Hub — Message My Specialist flow)
//
// Displays a specialist's details — avatar, name, specialty, clinic, verified
// badge, replies label — and a primary CTA button to open the chat room.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen: Specialist Profile.
///
/// Reads the [Specialist] from [GoRouterState.extra] and passes it to
/// [_SpecialistProfileView]. No BLoC needed — data is already in memory.
class SpecialistProfileScreen extends StatelessWidget {
  const SpecialistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    if (extra is! Specialist) {
      // extra is missing or wrong type (e.g. after hot restart or deep link)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return _SpecialistProfileView(specialist: extra);
  }
}

class _SpecialistProfileView extends StatefulWidget {
  const _SpecialistProfileView({required this.specialist});

  final Specialist specialist;

  @override
  State<_SpecialistProfileView> createState() =>
      _SpecialistProfileViewState();
}

class _SpecialistProfileViewState extends State<_SpecialistProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Specialist profile. ${widget.specialist.fullName}.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final specialist = widget.specialist;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
            top: 16,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProstheticHeader(title: 'Specialist Profile'),
              const SizedBox(height: AppDimensions.space24),

              // ── Specialist info card ─────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: _SpecialistInfoCard(specialist: specialist),
                ),
              ),

              const SizedBox(height: AppDimensions.space24),

              // ── "Message" CTA button ─────────────────────────────────────
              AppButton.primary(
                text: 'Message ${specialist.fullName}',
                prefixIcon: Icons.message_outlined,
                onPressed: () => context.push(
                  '${AppRoutes.prostheticSpecialists.path}/${specialist.id}/chat',
                  extra: specialist,
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

/// Card displaying the specialist's avatar, name, specialty, clinic,
/// verified badge, and replies label.
class _SpecialistInfoCard extends StatelessWidget {
  const _SpecialistInfoCard({required this.specialist});

  final Specialist specialist;

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
        '${specialist.clinicName != null ? ". ${specialist.clinicName}" : ""}'
        '${specialist.isVerified ? ". Verified specialist" : ""}.'
        ' ${specialist.repliesLabel}.';

    return Semantics(
      label: semanticsLabel,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
        ),
        child: ExcludeSemantics(
          child: Column(
            children: [
              // ── Avatar (52×52) ───────────────────────────────────────────
              _ProfileAvatar(
                specialist: specialist,
                blueStrong: blueStrong,
                blueTint: blueTint,
              ),

              const SizedBox(height: AppDimensions.space16),

              // ── Name ─────────────────────────────────────────────────────
              Text(
                specialist.fullName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.space4),

              // ── Specialty ────────────────────────────────────────────────
              Text(
                specialist.specialty,
                style: theme.textTheme.bodyMedium?.copyWith(color: ink2),
                textAlign: TextAlign.center,
              ),

              // ── Clinic name ──────────────────────────────────────────────
              if (specialist.clinicName != null) ...[
                const SizedBox(height: AppDimensions.space4),
                Text(
                  specialist.clinicName!,
                  style: theme.textTheme.bodySmall?.copyWith(color: ink3),
                  textAlign: TextAlign.center,
                ),
              ],

              const SizedBox(height: AppDimensions.space16),

              // ── Verified badge ───────────────────────────────────────────
              if (specialist.isVerified) ...[
                _VerifiedBadge(
                  blueStrong: blueStrong,
                  blueTint: blueTint,
                ),
                const SizedBox(height: AppDimensions.space12),
              ],

              // ── Replies label ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space16,
                  vertical: AppDimensions.space8,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusRow),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: AppDimensions.iconSm,
                      color: ink2,
                    ),
                    const SizedBox(width: AppDimensions.space6),
                    Text(
                      specialist.repliesLabel,
                      style: theme.textTheme.bodySmall?.copyWith(color: ink2),
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

/// 52×52 circle avatar with initials fallback.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.specialist,
    required this.blueStrong,
    required this.blueTint,
  });

  final Specialist specialist;
  final Color blueStrong;
  final Color blueTint;

  String get _initials {
    final parts = specialist.fullName.trim().split(RegExp(r'\s+'));
    final filtered = parts.where((p) => !p.endsWith('.')).toList();
    if (filtered.isEmpty) return parts.first[0].toUpperCase();
    if (filtered.length == 1) return filtered.first[0].toUpperCase();
    return '${filtered.first[0]}${filtered.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (specialist.avatarUrl != null) {
      return CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(specialist.avatarUrl!),
        backgroundColor: Colors.transparent,
      );
    }
    return CircleAvatar(
      radius: 26,
      backgroundColor: blueTint,
      child: Text(
        _initials,
        style: TextStyle(
          color: blueStrong,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }
}

/// "Verified specialist" badge row.
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.blueStrong, required this.blueTint});

  final Color blueStrong;
  final Color blueTint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_outlined,
            size: AppDimensions.iconMd,
            color: blueStrong,
          ),
          const SizedBox(width: AppDimensions.space6),
          Text(
            'Verified Specialist',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: blueStrong,
            ),
          ),
        ],
      ),
    );
  }
}
