import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/home/domain/entities/home_summary_item.dart';
import 'package:opto/features/home/presentation/cubit/home_summary_cubit.dart';
import 'package:opto/features/home/presentation/widgets/aura_voice_card.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:opto/features/home/presentation/widgets/home_list_card.dart';
import 'package:opto/features/home/presentation/widgets/home_list_item.dart';
import 'package:opto/features/home/presentation/widgets/home_nearby_card.dart';
import 'package:opto/features/home/presentation/widgets/home_section_header.dart';
import 'package:opto/features/home/presentation/widgets/home_top_bar.dart';
import 'package:opto/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:opto/features/home/presentation/widgets/sos_card.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';

/// Screen 15 — Opto Home Dashboard · **V1 Card Stack**.
///
/// The main super-app hub reached after onboarding + setup completes.
/// Implements the `V1 · Card stack` artboard from `Android Home Dashboard.html`.
///
/// Layout (top → bottom):
///   1. Top bar — "Opto" title · bell+dot · avatar · greeting
///   2. Emergency SOS — **bold hero** (red gradient, pulsing ring)
///   3. Aura Voice bar — "Ask Opto anything"
///   4. "Quick actions" section → 2×2 grey M3 tiles
///   5. "Up next" section → grouped card (live data via `HomeSummaryCubit`)
///   6. Navigate nearby — borderless surfaceContainer card
///   7. "Recent activity" section → grouped card (live data via `HomeSummaryCubit`)
///   8. Pinned 5-tab bottom nav — M3 pill style
///
/// Accessibility:
///   - One-line screen summary announced on mount (design_system.md §21.3).
///   - Greeting "Rian" is a semantic heading (header: true).
///   - Every interactive element has a Semantics label.
///   - Decorative icons/waveforms wrapped in ExcludeSemantics.
///   - Colors exclusively from theme tokens — Light / Dark / High-Contrast all
///     render correctly without hardcoded hex in widgets.
///   - Respects MediaQuery.textScaler; SingleChildScrollView prevents clipping.
///   - SOS pulsing ring stops when MediaQuery.disableAnimations is true.
///
/// State: `ProfileBloc` drives the greeting/avatar; `HomeSummaryCubit` drives
/// the "Up next" / "Recent activity" cards via `HomeSummaryRepository`
/// (see `home_summary_repository_impl.dart`).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// ProfileBloc instance owned by this screen.
  late final ProfileBloc _profileBloc;

  /// HomeSummaryCubit instance owned by this screen — loads "Up next" and
  /// "Recent activity" data.
  late final HomeSummaryCubit _homeSummaryCubit;

  @override
  void initState() {
    super.initState();
    // Create a fresh ProfileBloc and immediately load the current user's profile.
    _profileBloc = sl<ProfileBloc>();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _profileBloc.add(LoadProfile(userId: userId));
    }

    _homeSummaryCubit = sl<HomeSummaryCubit>()..load();

    // Announce a concise one-line summary on arrival (design_system.md §21.3).
    // The name will be announced again when the profile loads (see BlocListener).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Home.');
    });
  }

  @override
  void dispose() {
    _profileBloc.close();
    _homeSummaryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: BlocProvider<HomeSummaryCubit>.value(
        value: _homeSummaryCubit,
        child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          // Announce the user's name once the profile loads successfully.
          if (state is ProfileLoaded) {
            final name = state.profile.fullName;
            if (name != null && name.isNotEmpty && mounted) {
              announce(context, 'Good morning, $name.');
            }
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            // Extract name/initial from the loaded profile; null during loading.
            final String? displayName = profileState is ProfileLoaded
                ? profileState.profile.fullName
                : null;
            final String? avatarInitial =
                displayName != null && displayName.isNotEmpty
                ? displayName[0].toUpperCase()
                : null;

            return Scaffold(
              backgroundColor: cs.surface,
              // Pinned bottom nav — lives outside the scroll area.
              bottomNavigationBar: const HomeBottomNav(activeTab: 0),
              body: SafeArea(
                child: SingleChildScrollView(
                  // 16 dp horizontal padding matches `.pad` in the HTML spec.
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 6,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── 1. Top bar + greeting ─────────────────────────────────────────────
                      HomeTopBar(
                        displayName: displayName,
                        avatarInitial: avatarInitial,
                      ),

                      const SizedBox(height: 10),

                      // ── 2. Emergency SOS — bold hero ───────────────────────────
                      SosCard(
                        bold: true,
                        onTap: () => context.go(AppRoutes.sos.path),
                      ),

                      const SizedBox(height: 14),

                      // ── 3. Aura Voice bar ──────────────────────────────────────
                      AuraVoiceCard(
                        onTap: () => context.go(AppRoutes.auraVoice.path),
                      ),

                      const SizedBox(height: 14),

                      // ── 4. Quick actions 2×2 grid ──────────────────────────────
                      HomeSectionHeader(
                        title: 'Quick actions',
                        onSeeAll: null, // no "See all" for quick actions in V1
                      ),

                      const SizedBox(height: 8),

                      const QuickActionGrid(),

                      const SizedBox(height: 14),

                      // ── 5–7. Up next / Nearby / Recent activity ────────────────
                      // Driven by a single HomeSummaryCubit — see
                      // `home_summary_repository_impl.dart` for the data merge.
                      BlocBuilder<HomeSummaryCubit, HomeSummaryState>(
                        builder: (context, summaryState) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ── 5. Up next grouped card ──────────────────────
                              HomeSectionHeader(
                                title: 'Up next',
                                onSeeAll: () {
                                  // TODO: navigate to full schedule / upcoming list.
                                },
                              ),

                              const SizedBox(height: 8),

                              HomeListCard(
                                items: _sectionRows(
                                  context,
                                  summaryState,
                                  isUpNext: true,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ── 6. Navigate nearby ───────────────────────────
                              const HomeNearbyCard(),

                              const SizedBox(height: 14),

                              // ── 7. Recent activity grouped card ──────────────
                              HomeSectionHeader(
                                title: 'Recent activity',
                                onSeeAll: () {
                                  // TODO: navigate to full activity history.
                                },
                              ),

                              const SizedBox(height: 8),

                              HomeListCard(
                                items: _sectionRows(
                                  context,
                                  summaryState,
                                  isUpNext: false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // Extra bottom breathing room above nav.
                      const SizedBox(height: AppDimensions.space16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        ),
      ),
    );
  }

  /// Maps the current [HomeSummaryState] to the row widgets for one section.
  ///
  /// [isUpNext] selects `upNext` vs `recentActivity` from a loaded state.
  /// Each row's trailing chevron reflects whether it has a
  /// [HomeSummaryItem.targetRoute] to navigate to on tap.
  List<Widget> _sectionRows(
    BuildContext context,
    HomeSummaryState state, {
    required bool isUpNext,
  }) {
    if (state is HomeSummaryError) {
      return [
        _HomeCardError(
          message: state.message,
          onRetry: () => _homeSummaryCubit.load(),
        ),
      ];
    }

    if (state is HomeSummaryLoaded) {
      final items = isUpNext ? state.upNext : state.recentActivity;
      if (items.isEmpty) {
        return [
          _HomeCardEmpty(
            message: isUpNext ? 'Nothing upcoming.' : 'No recent activity yet.',
          ),
        ];
      }
      return items
          .map((item) => _summaryItemToListItem(context, item))
          .toList();
    }

    // Initial / loading.
    return const [_HomeCardLoading()];
  }

  HomeListItem _summaryItemToListItem(BuildContext context, HomeSummaryItem item) {
    return HomeListItem(
      icon: item.avatarInitials == null ? _iconForKind(item.kind) : null,
      avatarInitials: item.avatarInitials,
      title: item.title,
      subtitle: item.subtitle,
      showChevron: item.targetRoute != null,
      onTap: item.targetRoute != null
          ? () => context.push(item.targetRoute!)
          : null,
    );
  }

  IconData _iconForKind(HomeItemKind kind) {
    switch (kind) {
      case HomeItemKind.appointment:
      case HomeItemKind.booking:
        return Icons.calendar_today_outlined;
      case HomeItemKind.order:
        return Icons.local_shipping_outlined;
      case HomeItemKind.reminder:
        return Icons.notifications_active_outlined;
      case HomeItemKind.post:
        return Icons.edit_outlined;
      case HomeItemKind.reply:
        return Icons.forum_outlined;
      case HomeItemKind.bookmark:
        return Icons.bookmark_outline;
      case HomeItemKind.consultation:
        return Icons.medical_services_outlined;
    }
  }
}

// =============================================================================
// PRIVATE — "Up next" / "Recent activity" placeholder rows
// =============================================================================

/// Single-row loading placeholder shown inside a [HomeListCard] while
/// [HomeSummaryCubit] fetches data.
class _HomeCardLoading extends StatelessWidget {
  const _HomeCardLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        height: 46,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
    );
  }
}

/// Single-row empty state shown inside a [HomeListCard].
class _HomeCardEmpty extends StatelessWidget {
  const _HomeCardEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Semantics(
        label: message,
        child: ExcludeSemantics(
          child: Text(
            message,
            style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

/// Single-row error state with a retry action, shown inside a [HomeListCard].
class _HomeCardError extends StatelessWidget {
  const _HomeCardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Text(
                message,
                style: TextStyle(fontSize: 14, color: cs.error),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Retry',
            child: TextButton(onPressed: onRetry, child: const Text('Retry')),
          ),
        ],
      ),
    );
  }
}
