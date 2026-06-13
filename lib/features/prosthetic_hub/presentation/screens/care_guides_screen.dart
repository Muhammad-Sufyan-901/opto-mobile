// Screen: Care Guides list (M3 redesign)
//
// Featured "Recommended today" card for the daily clean guide, followed by
// an "All guides" section of restyled row cards.
// BLoC wiring, routing, and error handling are unchanged.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_guide.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/care_guides_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/care_guide_card.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/featured_guide_card.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen 17-B — Care Guides list.
///
/// Layout: white Scaffold, SafeArea, no bottom nav.
/// Accessibility: announces "Care guides." on entry via live region.
class CareGuidesScreen extends StatefulWidget {
  const CareGuidesScreen({super.key});

  @override
  State<CareGuidesScreen> createState() => _CareGuidesScreenState();
}

class _CareGuidesScreenState extends State<CareGuidesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Care guides.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CareGuidesCubit>(
      create: (_) => sl<CareGuidesCubit>()..load(),
      child: const _CareGuidesView(),
    );
  }
}

class _CareGuidesView extends StatelessWidget {
  const _CareGuidesView();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProstheticHeader(title: 'Care Guides'),
              const SizedBox(height: 4),
              // Subtitle
              ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    'Cleaning, handling & storage',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              Expanded(
                child: BlocBuilder<CareGuidesCubit, CareGuidesState>(
                  builder: (context, state) {
                    return switch (state) {
                      CareGuidesInitial() => const SizedBox.shrink(),
                      CareGuidesLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      CareGuidesLoaded(:final guides) =>
                        _GuidesList(guides: guides),
                      CareGuidesError(:final message) =>
                        _ErrorView(message: message),
                    };
                  },
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

void _openGuide(BuildContext context, CareGuide guide) {
  context.push(
    '${AppRoutes.prostheticCareGuides.path}/${guide.id}',
    extra: guide,
  );
}

/// Featured card + "All guides" section list.
class _GuidesList extends StatelessWidget {
  const _GuidesList({required this.guides});

  final List<CareGuide> guides;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    if (guides.isEmpty) {
      return const SizedBox.shrink();
    }

    // Pick the "clean" guide as featured if present, else use the first.
    final CareGuide featured = guides.firstWhere(
      (g) => g.category == CareGuideCategory.clean,
      orElse: () => guides.first,
    );
    // All guides still shown below (including featured).
    final List<CareGuide> allGuides = guides;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Daily routine section ────────────────────────────────────────
          ExcludeSemantics(
            child: Text(
              'DAILY ROUTINE',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: ink3,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          FeaturedGuideCard(
            guide: featured,
            onTap: () => _openGuide(context, featured),
          ),

          const SizedBox(height: AppDimensions.sectionGap),

          // ── All guides section ───────────────────────────────────────────
          ExcludeSemantics(
            child: Text(
              'ALL GUIDES',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: ink3,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          for (int i = 0; i < allGuides.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.space12),
            CareGuideCard(
              guide: allGuides[i],
              onTap: () => _openGuide(context, allGuides[i]),
            ),
          ],
          const SizedBox(height: AppDimensions.space24),
        ],
      ),
    );
  }
}

/// Centered error message with a "Retry" button.
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),
            Semantics(
              button: true,
              label: 'Retry loading care guides',
              child: TextButton(
                onPressed: () => context.read<CareGuidesCubit>().load(),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
