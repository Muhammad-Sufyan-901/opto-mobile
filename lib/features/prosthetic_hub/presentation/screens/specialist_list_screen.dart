// Screen: Specialist List (Prosthetic Hub — Message My Specialist flow)
//
// Shows a "RECOMMENDED" section (verified specialists) followed by
// "ALL SPECIALISTS", each rendered as [SpecialistCard]s.
// Tapping a card navigates to [SpecialistProfileScreen].
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/specialist.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/specialist_directory_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/specialist_card.dart';

/// Screen: Specialist Directory list.
///
/// Outer widget creates the [BlocProvider]; inner [StatefulWidget] handles
/// accessibility announcements.
class SpecialistListScreen extends StatelessWidget {
  const SpecialistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpecialistDirectoryCubit>(
      create: (_) => sl<SpecialistDirectoryCubit>()..load(),
      child: const _SpecialistListView(),
    );
  }
}

class _SpecialistListView extends StatefulWidget {
  const _SpecialistListView();

  @override
  State<_SpecialistListView> createState() => _SpecialistListViewState();
}

class _SpecialistListViewState extends State<_SpecialistListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Message my specialist.');
    });
  }

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
              const ProstheticHeader(title: 'Choose Specialist'),
              const SizedBox(height: AppDimensions.space16),
              Expanded(
                child: BlocBuilder<SpecialistDirectoryCubit,
                    SpecialistDirectoryState>(
                  builder: (context, state) {
                    return switch (state) {
                      SpecialistDirectoryInitial() ||
                      SpecialistDirectoryLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      SpecialistDirectoryLoaded(
                        :final recommended,
                        :final all,
                      ) =>
                        _SpecialistDirectory(
                          recommended: recommended,
                          all: all,
                        ),
                      SpecialistDirectoryError(:final message) =>
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

/// Scrollable list with "RECOMMENDED" and "ALL SPECIALISTS" sections.
class _SpecialistDirectory extends StatelessWidget {
  const _SpecialistDirectory({
    required this.recommended,
    required this.all,
  });

  final List<Specialist> recommended;
  final List<Specialist> all;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── "RECOMMENDED" section label ──────────────────────────────────
          if (recommended.isNotEmpty) ...[
            ExcludeSemantics(
              child: Text(
                'RECOMMENDED',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: ink3,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space12),
            for (int i = 0; i < recommended.length; i++) ...[
              if (i > 0) const SizedBox(height: AppDimensions.space12),
              SpecialistCard(
                specialist: recommended[i],
                onTap: () => context.push(
                  '${AppRoutes.prostheticSpecialists.path}/${recommended[i].id}',
                  extra: recommended[i],
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.space16),
          ],

          // ── "ALL SPECIALISTS" section label ──────────────────────────────
          ExcludeSemantics(
            child: Text(
              'ALL SPECIALISTS',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                color: ink3,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          for (int i = 0; i < all.length; i++) ...[
            if (i > 0) const SizedBox(height: AppDimensions.space12),
            SpecialistCard(
              specialist: all[i],
              onTap: () => context.push(
                '${AppRoutes.prostheticSpecialists.path}/${all[i].id}',
                extra: all[i],
              ),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space24,
        ),
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
              label: 'Retry loading specialists',
              child: TextButton(
                onPressed: () =>
                    context.read<SpecialistDirectoryCubit>().load(),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
