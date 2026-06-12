// 🔒 MEDICALLY SENSITIVE — Patient consultation history.
//
// Access enforced exclusively by Supabase RLS. This screen and its state
// MUST NOT be shared with community, map, or catalog surfaces.
// Results must not be written to persistent local storage (Hive / shared prefs).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/consultation_entity.dart';
import 'package:opto/features/consultation/presentation/cubit/consultation_history_cubit.dart';

/// 🔒 Screen 18c — Patient's past consultation history.
///
/// Reads [ConsultationEntity] records owned by the signed-in patient.
/// RLS on the `consultations` table ensures no cross-patient data leakage —
/// the client does NOT perform any additional access filtering.
///
/// Layout: white Scaffold + SafeArea + column (no bottom nav — pushed route).
class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsultationHistoryCubit>(
      create: (_) => sl<ConsultationHistoryCubit>()..loadHistory(),
      child: const _HistoryView(),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Consultation history.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Navigation header ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: 16,
              ),
              child: _HistoryHeader(cs: cs),
            ),

            // ── List ──────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<ConsultationHistoryCubit,
                  ConsultationHistoryState>(
                builder: (context, state) {
                  if (state is ConsultationHistoryLoading ||
                      state is ConsultationHistoryInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ConsultationHistoryError) {
                    return _HistoryError(
                      message: state.message,
                      onRetry: () => context
                          .read<ConsultationHistoryCubit>()
                          .loadHistory(),
                    );
                  }

                  if (state is ConsultationHistoryLoaded) {
                    if (state.consultations.isEmpty) {
                      return const _EmptyHistory();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.screenPadding,
                        vertical: AppDimensions.space8,
                      ),
                      itemCount: state.consultations.length,
                      separatorBuilder: (_, _i) =>
                          const SizedBox(height: AppDimensions.space8),
                      itemBuilder: (context, index) {
                        return _ConsultationCard(
                          consultation: state.consultations[index],
                          cs: cs,
                          theme: theme,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
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

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.cs});

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
              'Consultation History',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.minTapTarget),
      ],
    );
  }
}

/// 🔒 Card for a single consultation record.
///
/// Shows date, a shortened reference ID, and whether a summary or prescription
/// was attached. Does NOT display raw summary/prescription text — only
/// availability indicators to avoid presenting sensitive data in a list context.
class _ConsultationCard extends StatelessWidget {
  const _ConsultationCard({
    required this.consultation,
    required this.cs,
    required this.theme,
  });

  final ConsultationEntity consultation;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    final String date =
        DateFormat('dd MMM yyyy').format(consultation.createdAt.toLocal());
    final String refId = consultation.bookingId.length >= 8
        ? consultation.bookingId.substring(0, 8).toUpperCase()
        : consultation.bookingId.toUpperCase();
    final bool hasSummary = consultation.summary != null;
    final bool hasPrescription = consultation.prescription != null;

    final String semanticsLabel =
        'Consultation on $date, reference $refId'
        '${hasSummary ? ', summary available' : ''}'
        '${hasPrescription ? ', prescription available' : ''}';

    return MergeSemantics(
      child: Semantics(
        label: semanticsLabel,
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.cardPadding),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: line, width: 1.5),
          ),
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Date ────────────────────────────────────────────────
                Text(
                  date,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.space4),

                // ── Reference ID ─────────────────────────────────────────
                Text(
                  'Ref: $refId',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),

                if (hasSummary || hasPrescription) ...[
                  const SizedBox(height: AppDimensions.space8),
                  Wrap(
                    spacing: AppDimensions.space8,
                    children: [
                      if (hasSummary) _AvailabilityChip(label: 'Summary', cs: cs),
                      if (hasPrescription)
                        _AvailabilityChip(label: 'Prescription', cs: cs),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({required this.label, required this.cs});

  final String label;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space4,
        horizontal: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: ext?.greenTint ?? cs.secondaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: ext?.green ?? cs.secondary,
            ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space32),
      child: Center(
        child: Semantics(
          label: 'No past consultations found',
          child: Text(
            'No past consultations found.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Semantics(
            button: true,
            label: 'Retry loading consultation history',
            child: TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }
}
