import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/doctor_entity.dart';
import 'package:opto/features/consultation/presentation/bloc/doctor_search_bloc.dart';
import 'package:opto/features/consultation/presentation/widgets/availability_slot_list.dart';

/// Screen 18a — Doctor profile and availability.
///
/// Receives a [DoctorEntity] via GoRouter [state.extra]. Fires
/// [DoctorSearchEvent.loadAvailability] on mount to populate the slot list.
///
/// Layout: white Scaffold + SafeArea + SingleChildScrollView (no bottom nav —
/// this is a pushed route).
class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = GoRouterState.of(context).extra as DoctorEntity;
    return BlocProvider<DoctorSearchBloc>(
      create: (_) => sl<DoctorSearchBloc>()
        ..add(DoctorSearchEvent.loadAvailability(doctor.id)),
      child: _DoctorProfileView(doctor: doctor),
    );
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final name = widget.doctor.fullName ?? 'Doctor';
      announce(
        context,
        'Doctor profile. $name, ${widget.doctor.specialty}.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final DoctorEntity doctor = widget.doctor;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
            top: 16,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Navigation header ─────────────────────────────────────────
              _ProfileHeader(cs: cs),
              const SizedBox(height: AppDimensions.space24),

              // ── Doctor info card ──────────────────────────────────────────
              _DoctorInfoCard(doctor: doctor, cs: cs, ext: ext, theme: theme),
              const SizedBox(height: AppDimensions.space24),

              // ── Availability section ──────────────────────────────────────
              _SectionLabel(label: 'AVAILABILITY', cs: cs, theme: theme),
              const SizedBox(height: AppDimensions.space12),

              BlocBuilder<DoctorSearchBloc, DoctorSearchState>(
                builder: (context, state) {
                  if (state is DoctorSearchLoading ||
                      state is DoctorSearchInitial) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.space32,
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is DoctorSearchError) {
                    return _AvailabilityError(
                      message: state.message,
                      onRetry: () => context.read<DoctorSearchBloc>().add(
                            DoctorSearchEvent.loadAvailability(doctor.id),
                          ),
                    );
                  }

                  if (state is DoctorSearchLoaded) {
                    return AvailabilitySlotList(
                      slots: state.availability,
                      onSlotTap: (slot) {
                        context.push(
                          AppRoutes.consultBooking.path,
                          extra: {'doctor': doctor, 'slot': slot},
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.cs});

  final ColorScheme cs;

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
              'Doctor Profile',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ),
        // Balance row — same width as back button
        const SizedBox(width: AppDimensions.minTapTarget),
      ],
    );
  }
}

class _DoctorInfoCard extends StatelessWidget {
  const _DoctorInfoCard({
    required this.doctor,
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final DoctorEntity doctor;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

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
    final Color bgColor = ext?.blueTint ?? cs.primaryContainer;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final String displayName = doctor.fullName ?? 'Doctor';
    final String semanticsLabel =
        '$displayName, ${doctor.specialty}'
        '${doctor.clinicName != null ? ', ${doctor.clinicName}' : ''}'
        '${doctor.isVerified ? ', verified doctor' : ''}';

    return MergeSemantics(
      child: Semantics(
        label: semanticsLabel,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.22),
              width: 1.5,
            ),
          ),
          child: ExcludeSemantics(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Avatar ────────────────────────────────────────────────
                SizedBox(
                  width: 52,
                  height: 52,
                  child: doctor.avatarUrl != null
                      ? CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(doctor.avatarUrl!),
                          backgroundColor: cs.primary,
                        )
                      : CircleAvatar(
                          radius: 26,
                          backgroundColor: cs.primary,
                          child: Text(
                            _initials,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),

                const SizedBox(width: AppDimensions.space16),

                // ── Info ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space4),
                      Text(
                        doctor.specialty,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ink2,
                        ),
                      ),
                      if (doctor.clinicName != null) ...[
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          doctor.clinicName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink2,
                          ),
                        ),
                      ],
                      if (doctor.isVerified) ...[
                        const SizedBox(height: AppDimensions.space8),
                        _VerifiedBadge(cs: cs, ext: ext, theme: theme),
                      ],
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

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({
    required this.cs,
    required this.ext,
    required this.theme,
  });

  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified_outlined, size: 14, color: cs.primary),
        const SizedBox(width: 4),
        Text(
          'Verified doctor',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
      ],
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
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _AvailabilityError extends StatelessWidget {
  const _AvailabilityError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        Semantics(
          button: true,
          label: 'Retry loading availability',
          child: TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}
