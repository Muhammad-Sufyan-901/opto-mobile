// POI Detail Screen — shows a single accessibility place with its attributes
// and allows the user to verify or suggest an edit.
//
// Accessibility contract:
//   • On load, attributes are read aloud via a live region.
//   • "Verify this place" and "Suggest edit" results announced as live region.
//   • All tap targets ≥ 48dp.
//   • Contrast ≥ 4.5:1; no meaning conveyed by colour alone.
//   • Activity indicator on contribution submit (PoiDetailContributing state).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/map_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/poi_detail/poi_detail_cubit.dart';

/// Screen — POI detail view.
///
/// Requires `poiId` as a path parameter. The [PoiDetailCubit] is provided via
/// [BlocProvider] in the router.
class PoiDetailScreen extends StatefulWidget {
  const PoiDetailScreen({super.key, required this.poiId});

  final String poiId;

  @override
  State<PoiDetailScreen> createState() => _PoiDetailScreenState();
}

class _PoiDetailScreenState extends State<PoiDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PoiDetailCubit>().loadPoi(widget.poiId);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocListener<PoiDetailCubit, PoiDetailState>(
          listener: (context, state) {
            if (state is PoiDetailLoaded) {
              announce(context, _buildSpokenDescription(state.poi));
            }
            if (state is PoiDetailContributionSuccess) {
              announce(context, state.message);
              HapticPatterns.success();
            }
            if (state is PoiDetailError) {
              announce(context, 'Error: ${state.message}');
              HapticPatterns.warning();
            }
          },
          child: BlocBuilder<PoiDetailCubit, PoiDetailState>(
            builder: (context, state) {
              return switch (state) {
                PoiDetailInitial() || PoiDetailLoading() =>
                  const Center(child: CircularProgressIndicator()),
                PoiDetailLoaded(:final poi) => _PoiContent(poi: poi),
                PoiDetailContributing(:final poi) =>
                  _PoiContent(poi: poi, isSubmitting: true),
                PoiDetailContributionSuccess(:final poi) =>
                  _PoiContent(poi: poi, successMessage: state.message),
                PoiDetailError(:final message) => _DetailError(
                    message: message,
                    onBack: () {
                      if (context.canPop()) context.pop();
                    },
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  String _buildSpokenDescription(AccessibilityPoiEntity poi) {
    final attrs = poi.attributes.entries
        .where((e) => e.value == true)
        .map((e) {
          final a = PoiAttribute.fromJsonKey(e.key);
          return a?.displayLabel ?? e.key;
        })
        .toList();
    final attrText = attrs.isEmpty
        ? 'No specific accessibility features listed.'
        : 'Features: ${attrs.join(', ')}.';
    return '${poi.name}. $attrText '
        '${poi.verifiedCount} verification${poi.verifiedCount != 1 ? 's' : ''}.';
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _PoiContent extends StatelessWidget {
  const _PoiContent({
    required this.poi,
    this.isSubmitting = false,
    this.successMessage,
  });

  final AccessibilityPoiEntity poi;
  final bool isSubmitting;
  final String? successMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color line = ext?.line ?? cs.outline;

    return CustomScrollView(
      slivers: [
        // ── App bar ────────────────────────────────────────────────────
        SliverAppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          leading: Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) context.pop();
              },
              child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.chevron_left, size: 28),
                  ),
                ),
              ),
            ),
          ),
          title: ExcludeSemantics(
            child: Text(
              poi.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingMin,
              vertical: AppDimensions.space8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Verified count ─────────────────────────────────────
                if (poi.verifiedCount > 0)
                  ExcludeSemantics(
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: cs.tertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${poi.verifiedCount} '
                          'verification${poi.verifiedCount != 1 ? 's' : ''}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: cs.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppDimensions.space16),

                // ── Attributes section ────────────────────────────────
                ExcludeSemantics(
                  child: Text(
                    'Accessibility features',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),

                _AttributesList(attributes: poi.attributes),

                const SizedBox(height: AppDimensions.space24),
                Divider(color: line),
                const SizedBox(height: AppDimensions.space16),

                // ── Success banner ────────────────────────────────────
                if (successMessage != null)
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.all(AppDimensions.space12),
                      decoration: BoxDecoration(
                        color: cs.tertiaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusChip,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: cs.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: AppDimensions.space8),
                          Expanded(
                            child: Text(
                              successMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onTertiaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (successMessage != null)
                  const SizedBox(height: AppDimensions.space16),

                // ── Action buttons ────────────────────────────────────
                _ActionButtons(
                  poiId: poi.id,
                  isSubmitting: isSubmitting,
                  successMessage: successMessage,
                ),

                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AttributesList extends StatelessWidget {
  const _AttributesList({required this.attributes});

  final Map<String, dynamic> attributes;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    if (attributes.isEmpty) {
      return Semantics(
        liveRegion: true,
        child: Text(
          'No accessibility features listed for this place.',
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }

    // Iterate all known attributes first, then any unknown keys.
    final knownTrue = <PoiAttribute>[];
    final knownFalse = <PoiAttribute>[];
    final unknownTrue = <String>[];

    for (final entry in attributes.entries) {
      final attr = PoiAttribute.fromJsonKey(entry.key);
      final isTrue = entry.value == true;
      if (attr != null) {
        if (isTrue) {
          knownTrue.add(attr);
        } else {
          knownFalse.add(attr);
        }
      } else if (isTrue) {
        unknownTrue.add(entry.key);
      }
    }

    return Column(
      children: [
        ...knownTrue.map(
          (a) => _AttributeRow(label: a.displayLabel, present: true),
        ),
        ...unknownTrue.map(
          (k) => _AttributeRow(label: k, present: true),
        ),
        ...knownFalse.map(
          (a) => _AttributeRow(label: a.displayLabel, present: false),
        ),
      ],
    );
  }
}

class _AttributeRow extends StatelessWidget {
  const _AttributeRow({required this.label, required this.present});

  final String label;
  final bool present;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Semantics(
      label: '$label: ${present ? 'available' : 'not available'}',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                present ? Icons.check_circle_outline : Icons.cancel_outlined,
                size: 20,
                color: present ? cs.tertiary : cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            ExcludeSemantics(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: present ? cs.onSurface : cs.onSurfaceVariant,
                  fontWeight: present ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.poiId,
    required this.isSubmitting,
    required this.successMessage,
  });

  final String poiId;
  final bool isSubmitting;
  final String? successMessage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final cubit = context.read<PoiDetailCubit>();

    if (isSubmitting) {
      return Semantics(
        liveRegion: true,
        label: 'Submitting your contribution',
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Once contributed, show a "Done" button only.
    if (successMessage != null) {
      return Semantics(
        button: true,
        label: 'Done',
        child: SizedBox(
          width: double.infinity,
          height: AppDimensions.minTapTarget,
          child: ElevatedButton(
            onPressed: () {
              if (context.canPop()) context.pop();
            },
            child: const ExcludeSemantics(child: Text('Done')),
          ),
        ),
      );
    }

    return Column(
      children: [
        Semantics(
          button: true,
          label: 'Verify this place — confirm it is correct',
          child: SizedBox(
            width: double.infinity,
            height: AppDimensions.minTapTarget,
            child: ElevatedButton.icon(
              onPressed: cubit.verifyPoi,
              icon: const ExcludeSemantics(
                child: Icon(Icons.check_circle_outline, size: 20),
              ),
              label: const ExcludeSemantics(
                child: Text('Verify this place'),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        Semantics(
          button: true,
          label: 'Suggest an edit to this place',
          child: SizedBox(
            width: double.infinity,
            height: AppDimensions.minTapTarget,
            child: OutlinedButton.icon(
              onPressed: () => _showSuggestEditSheet(context, cubit),
              icon: const ExcludeSemantics(
                child: Icon(Icons.edit_outlined, size: 20),
              ),
              label: const ExcludeSemantics(
                child: Text('Suggest an edit'),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.primary,
                side: BorderSide(color: cs.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuggestEditSheet(BuildContext context, PoiDetailCubit cubit) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.screenPaddingMin,
          right: AppDimensions.screenPaddingMin,
          top: AppDimensions.space24,
          bottom: MediaQuery.viewInsetsOf(context).bottom +
              AppDimensions.space24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggest an edit',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppDimensions.space12),
            Semantics(
              label: 'Describe your suggested change',
              child: TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe what should be changed...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Semantics(
              button: true,
              label: 'Submit suggestion',
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.minTapTarget,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    cubit.suggestEdit(
                      change: {'note': controller.text.trim()},
                    );
                  },
                  child: const ExcludeSemantics(child: Text('Submit')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: AppDimensions.space16),
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Go back',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: onBack,
                    child: const ExcludeSemantics(child: Text('Go back')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
