// Care Tutorials Screen — Prosthetic Hub tutorial listing.
//
// Accessibility-first: every tap target ≥ 48dp, all interactive elements
// have Semantics labels, and the screen announces itself on first load.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_tutorial_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/tutorials/tutorials_cubit.dart';

/// Screen — Prosthetic Hub care tutorial listing.
///
/// Provides a [TutorialsCubit] from DI (via [BlocProvider] in the route),
/// fires [loadTutorials] on init, and presents a filterable [ListView]
/// of tutorials grouped by [TutorialCategory].
class CareTutorialsScreen extends StatefulWidget {
  const CareTutorialsScreen({super.key});

  @override
  State<CareTutorialsScreen> createState() => _CareTutorialsScreenState();
}

class _CareTutorialsScreenState extends State<CareTutorialsScreen> {
  TutorialCategory? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<TutorialsCubit>().loadTutorials(
          categoryFilter: _categoryFilter,
        );
  }

  void _applyFilter(TutorialCategory? category) {
    setState(() => _categoryFilter = category);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            _TutorialsHeader(cs: cs),

            // ── Category filter chips ────────────────────────────────────────
            _CategoryFilterBar(
              selected: _categoryFilter,
              onSelected: _applyFilter,
            ),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<TutorialsCubit, TutorialsState>(
                listenWhen: (prev, curr) =>
                    curr is TutorialsLoaded && prev is! TutorialsLoaded,
                listener: (context, state) {
                  if (state is TutorialsLoaded) {
                    announce(
                      context,
                      'Care tutorials. '
                      '${state.tutorials.length} tutorials.',
                    );
                  }
                },
                builder: (context, state) {
                  return switch (state) {
                    TutorialsInitial() => const SizedBox.shrink(),
                    TutorialsLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    TutorialsLoaded(:final tutorials) => tutorials.isEmpty
                        ? _EmptyState(cs: cs)
                        : _TutorialList(tutorials: tutorials),
                    TutorialsError(:final message) => _ErrorState(
                        message: message,
                        onRetry: _load,
                      ),
                  };
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

/// Screen header: back button + centred title.
class _TutorialsHeader extends StatelessWidget {
  const _TutorialsHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 22,
        top: 14,
        bottom: 4,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.goNamed(AppRoutes.prostheticHub.name);
                }
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
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                'Care Tutorials',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: AppDimensions.minTapTarget,
            height: AppDimensions.minTapTarget,
          ),
        ],
      ),
    );
  }
}

/// Horizontal filter bar for [TutorialCategory].
class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final TutorialCategory? selected;
  final ValueChanged<TutorialCategory?> onSelected;

  static const _labels = <TutorialCategory?, String>{
    null: 'All',
    TutorialCategory.insert: 'Insert',
    TutorialCategory.remove: 'Remove',
    TutorialCategory.clean: 'Clean',
    TutorialCategory.lubricate: 'Lubricate',
    TutorialCategory.caseUse: 'Case Use',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingMin,
        vertical: AppDimensions.space8,
      ),
      child: SizedBox(
        height: AppDimensions.minTapTarget,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _labels.entries.map((entry) {
            final isSelected = selected == entry.key;
            final label = entry.value;
            return Padding(
              padding: const EdgeInsets.only(right: AppDimensions.space8),
              child: Semantics(
                button: true,
                selected: isSelected,
                label: 'Filter: $label${isSelected ? ', selected' : ''}',
                child: GestureDetector(
                  onTap: () => onSelected(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? cs.primary : cs.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusChip,
                      ),
                      border: Border.all(
                        color: isSelected ? cs.primary : cs.outline,
                        width: 1.5,
                      ),
                    ),
                    child: ExcludeSemantics(
                      child: Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? cs.onPrimary : cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Scrollable list of tutorial rows.
class _TutorialList extends StatelessWidget {
  const _TutorialList({required this.tutorials});

  final List<CareTutorialEntity> tutorials;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingMin,
        vertical: AppDimensions.space8,
      ),
      itemCount: tutorials.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.space12),
      itemBuilder: (context, index) => _TutorialRow(tutorial: tutorials[index]),
    );
  }
}

/// Single tutorial row card.
class _TutorialRow extends StatelessWidget {
  const _TutorialRow({required this.tutorial});

  final CareTutorialEntity tutorial;

  static const _categoryIcons = <TutorialCategory, IconData>{
    TutorialCategory.insert: Icons.add_circle_outline,
    TutorialCategory.remove: Icons.remove_circle_outline,
    TutorialCategory.clean: Icons.cleaning_services_outlined,
    TutorialCategory.lubricate: Icons.water_drop_outlined,
    TutorialCategory.caseUse: Icons.cases_outlined,
  };

  static const _categoryLabels = <TutorialCategory, String>{
    TutorialCategory.insert: 'Insert',
    TutorialCategory.remove: 'Remove',
    TutorialCategory.clean: 'Clean',
    TutorialCategory.lubricate: 'Lubricate',
    TutorialCategory.caseUse: 'Case Use',
  };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final icon = _categoryIcons[tutorial.category] ?? Icons.play_circle_outline;
    final categoryLabel =
        _categoryLabels[tutorial.category] ?? tutorial.category.dbValue;

    final semanticsLabel =
        '${tutorial.title}. $categoryLabel tutorial. Tap to open.';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: () => context.goNamed(
          AppRoutes.tutorialPlayer.name,
          pathParameters: {'tutorialId': tutorial.id},
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
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
              // ── Icon chip ────────────────────────────────────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusChip),
                  ),
                  child: Icon(icon, size: 22, color: cs.secondary),
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
                      Text(
                        tutorial.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        categoryLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ink2,
                        ),
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

/// Empty state widget shown when no tutorials match the current filter.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: 64,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                'No tutorials found',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Try selecting a different category.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error state widget with a retry button.
class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

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
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading tutorials',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    child: const ExcludeSemantics(
                      child: Text('Retry'),
                    ),
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
