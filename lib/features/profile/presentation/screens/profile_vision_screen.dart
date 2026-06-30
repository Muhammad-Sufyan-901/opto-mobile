// Screen P3 — Vision Profile.
//
// 🔒 MEDICAL SENSITIVITY: This screen displays health details for the
// signed-in user only. Data is fetched via owner-row RLS policies
// (see database_schema.md). Never cache beyond session, never join to
// community/catalog queries, never expose to community feed, map, or
// catalog widgets.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/domain/entities/vision_clinical_entity.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/vision_clinical_cubit.dart';
import 'package:opto/features/profile/presentation/widgets/profile_fn_row.dart';
import 'package:opto/features/profile/presentation/widgets/profile_glance_card.dart';
import 'package:opto/features/profile/presentation/widgets/profile_listen_button.dart';
import 'package:opto/features/profile/presentation/widgets/profile_tech_chip.dart';

// ── Root widget — provides the cubit ─────────────────────────────────────────

class ProfileVisionScreen extends StatelessWidget {
  const ProfileVisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VisionClinicalCubit>(
      create: (_) => sl<VisionClinicalCubit>(),
      child: const _VisionBody(),
    );
  }
}

// ── Body widget — owns state & build logic ────────────────────────────────────

class _VisionBody extends StatefulWidget {
  const _VisionBody();

  @override
  State<_VisionBody> createState() => _VisionBodyState();
}

class _VisionBodyState extends State<_VisionBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Vision profile.');
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        context.read<VisionClinicalCubit>().load(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisionClinicalCubit, VisionClinicalState>(
      builder: (ctx, state) {
        if (state is VisionClinicalLoading || state is VisionClinicalInitial) {
          return _buildLoadingBody(ctx);
        }
        if (state is VisionClinicalEmpty) {
          return _buildEmptyBody(ctx);
        }
        if (state is VisionClinicalError) {
          return _buildErrorBody(ctx, state.message);
        }
        final clinical = (state as VisionClinicalLoaded).clinical;
        return _buildContent(ctx, clinical);
      },
    );
  }

  // ── Shared AppBar ───────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return AppBar(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Semantics(
        button: true,
        label: 'Back',
        child: GestureDetector(
          onTap: () => context.pop(),
          child: Center(
            child: ExcludeSemantics(
              child: Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
            ),
          ),
        ),
      ),
      title: Text(
        'Vision profile',
        style: theme.textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        Semantics(
          button: true,
          label: 'Listen to vision profile',
          child: GestureDetector(
            onTap: () => HapticPatterns.focusTick(),
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              decoration: BoxDecoration(
                color: ext?.blueTint ?? cs.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(Icons.volume_up_outlined,
                      size: 24, color: cs.secondary),
                ),
              ),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Edit vision profile',
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(Icons.edit_outlined,
                      size: 22, color: cs.onSurface),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Loading ─────────────────────────────────────────────────────────────────

  Widget _buildLoadingBody(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: Center(
        child: Semantics(
          label: 'Loading your vision profile, please wait.',
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  // ── Error ───────────────────────────────────────────────────────────────────

  Widget _buildErrorBody(BuildContext context, String message) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 56, color: cs.error),
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                button: true,
                label: 'Retry loading vision profile',
                child: ElevatedButton(
                  onPressed: () {
                    final userId =
                        Supabase.instance.client.auth.currentUser?.id;
                    if (userId != null) {
                      context.read<VisionClinicalCubit>().load(userId);
                    }
                  },
                  child: const ExcludeSemantics(child: Text('Retry')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Empty state ─────────────────────────────────────────────────────────────

  Widget _buildEmptyBody(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Semantics(
              label:
                  'No clinical details recorded. Add your vision diagnosis, prosthesis, and assistive tech details to see them here.',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.visibility_off_outlined,
                        size: 56, color: cs.outlineVariant),
                  ),
                  const SizedBox(height: 16),
                  ExcludeSemantics(
                    child: Text(
                      'No clinical details recorded',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ExcludeSemantics(
                    child: Text(
                      'Add your vision diagnosis, prosthesis, and assistive tech details to see them here.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: ink2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Loaded content ──────────────────────────────────────────────────────────

  Widget _buildContent(BuildContext context, VisionClinicalEntity clinical) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    // Clinic name from the parent-level ProfileBloc (provided by the router).
    final profileState = context.read<ProfileBloc>().state;
    final clinicName = (profileState is ProfileLoaded)
        ? profileState.profile.clinicName
        : null;
    final clinicDisplay = (clinicName != null && clinicName.isNotEmpty)
        ? clinicName
        : 'your linked care team';

    // Build diagnosis facts — only include non-null fields.
    final diagnosisFacts = <ProfileGlanceFact>[];
    if (clinical.diagnosis != null) {
      final condition = clinical.diagnosisSeverity != null
          ? '${clinical.diagnosis} — ${clinical.diagnosisSeverity}'
          : clinical.diagnosis!;
      diagnosisFacts.add(ProfileGlanceFact(
        icon: Icons.visibility_outlined,
        label: 'Primary condition',
        value: condition,
      ));
    }
    if (clinical.affectedEyes != null) {
      diagnosisFacts.add(ProfileGlanceFact(
        icon: Icons.adjust_outlined,
        label: 'Affected eye',
        value: clinical.affectedEyes!,
      ));
    }
    if (clinical.diagnosedYear != null) {
      diagnosisFacts.add(ProfileGlanceFact(
        icon: Icons.access_time_outlined,
        label: 'Onset',
        value: 'Diagnosed ${clinical.diagnosedYear}',
      ));
    }

    // Build functional vision rows — only include non-null fields.
    final fnRows = <Widget>[];
    if (clinical.lightPerception != null) {
      final isPresent =
          clinical.lightPerception!.toLowerCase() != 'absent' &&
          clinical.lightPerception!.toLowerCase() != 'no';
      if (fnRows.isNotEmpty) fnRows.add(const SizedBox(height: 10));
      fnRows.add(ProfileFnRow(
        label: 'Light perception',
        value: clinical.lightPerception!,
        isPresent: isPresent,
      ));
    }
    if (clinical.centralAcuity != null) {
      if (fnRows.isNotEmpty) fnRows.add(const SizedBox(height: 10));
      fnRows.add(ProfileFnRow(
        label: 'Central acuity',
        value: clinical.centralAcuity!,
        isPresent: false,
      ));
    }
    if (clinical.visualField != null) {
      if (fnRows.isNotEmpty) fnRows.add(const SizedBox(height: 10));
      fnRows.add(ProfileFnRow(
        label: 'Visual field',
        value: clinical.visualField!,
        isPresent: false,
      ));
    }

    // Build prosthesis facts — only include non-null fields.
    final prosthesisFacts = <ProfileGlanceFact>[];
    if (clinical.prosthesisEye != null) {
      final eyeValue = clinical.prosthesisType != null
          ? '${clinical.prosthesisEye} · ${clinical.prosthesisType}'
          : clinical.prosthesisEye!;
      prosthesisFacts.add(ProfileGlanceFact(
        icon: Icons.adjust_outlined,
        label: 'Eye',
        value: eyeValue,
      ));
      if (clinical.prosthesisFittedDate != null ||
          clinical.prosthesisFittedClinic != null) {
        final datePart = _formatDate(clinical.prosthesisFittedDate);
        final clinicPart = clinical.prosthesisFittedClinic ?? '';
        final fittedValue = [datePart, clinicPart]
            .where((s) => s.isNotEmpty)
            .join(' · ');
        prosthesisFacts.add(ProfileGlanceFact(
          icon: Icons.calendar_month_outlined,
          label: 'Fitted',
          value: fittedValue,
        ));
      }
      if (clinical.prosthesisMaterial != null) {
        prosthesisFacts.add(ProfileGlanceFact(
          icon: Icons.water_drop_outlined,
          label: 'Material',
          value: clinical.prosthesisMaterial!,
        ));
      }
      final polishStr =
          _formatPolishDates(clinical.lastPolishDate, clinical.nextPolishDue);
      if (polishStr.isNotEmpty) {
        prosthesisFacts.add(ProfileGlanceFact(
          icon: Icons.refresh_outlined,
          label: 'Last polish',
          value: polishStr,
        ));
      }
    }

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(18, 0, 18, AppDimensions.space32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Privacy banner ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: ext?.blueTint?.withValues(alpha: 0.35) ??
                      cs.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: line, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(
                      child: Icon(Icons.lock_outline,
                          size: 18, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Private health details',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Visible to you and your linked specialist at '
                            '$clinicDisplay. Never shown on your public profile.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink2,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: ProfileListenButton(
                  summary: _buildSummary(clinical),
                  label: 'Listen to your vision profile',
                ),
              ),

              const SizedBox(height: 16),

              // ── Diagnosis ──────────────────────────────────────────
              if (diagnosisFacts.isNotEmpty) ...[
                ExcludeSemantics(
                  child: Text(
                    'DIAGNOSIS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: ink3,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ProfileGlanceCard(
                  sectionIcon: Icons.medical_information_outlined,
                  sectionLabel: 'Diagnosis',
                  facts: diagnosisFacts,
                ),
                const SizedBox(height: 16),
              ],

              // ── Functional vision ──────────────────────────────────
              if (fnRows.isNotEmpty) ...[
                ExcludeSemantics(
                  child: Text(
                    'FUNCTIONAL VISION',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: ink3,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Column(children: fnRows),
                const SizedBox(height: 16),
              ],

              // ── Ocular prosthesis ──────────────────────────────────
              if (clinical.prosthesisEye != null &&
                  prosthesisFacts.isNotEmpty) ...[
                ExcludeSemantics(
                  child: Text(
                    'OCULAR PROSTHESIS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: ink3,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ProfileGlanceCard(
                  sectionIcon: Icons.adjust_outlined,
                  sectionLabel: 'Prosthesis',
                  facts: prosthesisFacts,
                ),
                const SizedBox(height: 16),
              ],

              // ── Assistive tech ─────────────────────────────────────
              if (clinical.assistiveTech.isNotEmpty) ...[
                ExcludeSemantics(
                  child: Text(
                    'ASSISTIVE TECH IN USE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: ink3,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.6,
                  children: clinical.assistiveTech
                      .map((tech) => ProfileTechChip(
                            icon: _iconForTech(tech.name),
                            name: tech.name,
                            isOn: tech.enabled,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static String _buildSummary(VisionClinicalEntity c) {
    final parts = <String>[];
    if (c.diagnosis != null) parts.add('Primary condition: ${c.diagnosis}');
    if (c.affectedEyes != null) parts.add('Affected eyes: ${c.affectedEyes}');
    if (c.diagnosedYear != null) parts.add('Diagnosed ${c.diagnosedYear}');
    return parts.isEmpty
        ? 'Vision profile. No details recorded yet.'
        : 'Vision profile. ${parts.join('. ')}.';
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String _formatPolishDates(DateTime? last, DateTime? next) {
    final parts = <String>[];
    if (last != null) parts.add(_formatDate(last));
    if (next != null) parts.add('due ${_formatDate(next)}');
    return parts.join(' · ');
  }

  static IconData _iconForTech(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('talkback') ||
        lower.contains('screen reader') ||
        lower.contains('voice')) {
      return Icons.volume_up_outlined;
    }
    if (lower.contains('magnif') || lower.contains('zoom')) {
      return Icons.zoom_in_outlined;
    }
    if (lower.contains('cane') || lower.contains('braille')) {
      return Icons.accessibility_new_outlined;
    }
    if (lower.contains('guide') || lower.contains('dog')) {
      return Icons.pets_outlined;
    }
    if (lower.contains('hearing') || lower.contains('cochlear')) {
      return Icons.hearing_outlined;
    }
    return Icons.devices_outlined;
  }
}
