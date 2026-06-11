// Bottom sheet for reporting a community post.
//
// Driven by [ReportCubit]. Each [ReportReason] is displayed as a tappable
// [ListTile]. On success, "Post reported." is announced to screen readers
// and the sheet is dismissed.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/connect_enums.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/connect/presentation/cubit/report_cubit.dart';

/// Bottom sheet for reporting a community post identified by [postId].
///
/// Use [ReportPostSheet.show] to display it from any [BuildContext].
///
/// Accessibility:
/// - An announcement is made on mount to orient screen-reader users.
/// - Each reason tile is wrapped in [Semantics] with a descriptive label.
/// - "Post reported." is announced on [ReportSuccess] before dismissal.
/// - Errors are surfaced via [SnackBar] (announced by the framework).
class ReportPostSheet extends StatelessWidget {
  const ReportPostSheet({super.key, required this.postId});

  final String postId;

  /// Convenience factory to show the sheet with its own [BlocProvider].
  static Future<void> show(BuildContext context, String postId) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlocProvider<ReportCubit>(
          create: (_) => sl<ReportCubit>(),
          child: ReportPostSheet(postId: postId),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          announce(context, 'Post reported.');
          context.pop();
        } else if (state is ReportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: _ReportSheetContent(postId: postId),
    );
  }
}

// =============================================================================
// SHEET CONTENT
// =============================================================================

class _ReportSheetContent extends StatefulWidget {
  const _ReportSheetContent({required this.postId});

  final String postId;

  @override
  State<_ReportSheetContent> createState() => _ReportSheetContentState();
}

class _ReportSheetContentState extends State<_ReportSheetContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Report post. Select a reason.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusCard),
        ),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            final bool isSubmitting = state is ReportSubmitting;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Drag handle ──────────────────────────────────────────
                ExcludeSemantics(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 4),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outline.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Title ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                    vertical: AppDimensions.space12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Report post',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (isSubmitting)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.primary,
                          ),
                        ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // ── Reason list ──────────────────────────────────────────
                for (final reason in ReportReason.values)
                  _ReasonTile(
                    reason: reason,
                    enabled: !isSubmitting,
                    onTap: () => context.read<ReportCubit>().submit(
                          postId: widget.postId,
                          reason: reason,
                        ),
                  ),

                const SizedBox(height: AppDimensions.space8),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// REASON TILE
// =============================================================================

class _ReasonTile extends StatelessWidget {
  const _ReasonTile({
    required this.reason,
    required this.enabled,
    required this.onTap,
  });

  final ReportReason reason;
  final bool enabled;
  final VoidCallback onTap;

  static IconData _iconFor(ReportReason reason) {
    switch (reason) {
      case ReportReason.spam:
        return Icons.block_outlined;
      case ReportReason.harassment:
        return Icons.person_off_outlined;
      case ReportReason.misinformation:
        return Icons.fact_check_outlined;
      case ReportReason.inappropriate:
        return Icons.warning_amber_outlined;
      case ReportReason.other:
        return Icons.more_horiz_outlined;
    }
  }

  static String _labelFor(ReportReason reason) {
    switch (reason) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.harassment:
        return 'Harassment';
      case ReportReason.misinformation:
        return 'Misinformation';
      case ReportReason.inappropriate:
        return 'Inappropriate content';
      case ReportReason.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final String label = _labelFor(reason);

    return Semantics(
      button: true,
      label: 'Report as $label',
      child: ListTile(
        enabled: enabled,
        leading: ExcludeSemantics(
          child: Icon(
            _iconFor(reason),
            color: enabled ? cs.onSurface : cs.onSurface.withValues(alpha: 0.38),
          ),
        ),
        title: ExcludeSemantics(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: enabled
                  ? cs.onSurface
                  : cs.onSurface.withValues(alpha: 0.38),
            ),
          ),
        ),
        minTileHeight: AppDimensions.minTapTarget,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
