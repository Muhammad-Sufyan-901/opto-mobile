import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_bloc.dart';
import 'package:opto/features/connect/presentation/cubit/community_home_cubit.dart';
import 'package:opto/features/connect/presentation/widgets/ask_community_prompt.dart';
import 'package:opto/features/connect/presentation/widgets/circle_tile.dart';
import 'package:opto/features/connect/presentation/widgets/community_home_skeleton.dart';
import 'package:opto/features/connect/presentation/widgets/community_thread_card.dart';
import 'package:opto/features/connect/presentation/widgets/featured_hero_card.dart';
import 'package:opto/features/connect/presentation/widgets/report_post_sheet.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 19 (K1) — Community Home.
///
/// Landing screen for the community tab. Shows:
///   • Featured hero thread (most-liked in the recent batch).
///   • "Your circles" horizontal tile row.
///   • "Ask the community" prompt → compose.
///   • "Trending today" — 2 thread cards.
///
/// Navigation into this screen replaces the old [CommunityScreen] (K2) as the
/// /community root. K2 is now at /community/feed.
class CommunityHomeScreen extends StatelessWidget {
  const CommunityHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityHomeCubit>(
          create: (_) => sl<CommunityHomeCubit>()..load(),
        ),
        BlocProvider<ConnectFeedBloc>(
          create: (_) => sl<ConnectFeedBloc>()
            ..add(const ConnectFeedEvent.loadFeed())
            ..add(const ConnectFeedEvent.subscribeFeed()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool _announced = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final blueTint = ext?.blueTint ?? cs.primaryContainer;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return BlocListener<CommunityHomeCubit, CommunityHomeState>(
      listener: (context, state) {
        if (state is CommunityHomeLoaded && !_announced) {
          _announced = true;
          final circleCount = state.circles.length;
          final hasFeatured = state.featuredPost != null;
          announce(
            context,
            'Community home. '
            '${hasFeatured ? "Featured post available. " : ""}'
            '$circleCount circles.',
          );
        }
        if (state is CommunityHomeError) {
          _announced = false;
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        bottomNavigationBar: const HomeBottomNav(activeTab: 1),
        floatingActionButton: _ComposeFab(cs: cs),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<CommunityHomeCubit>().load();
              context
                  .read<ConnectFeedBloc>()
                  .add(const ConnectFeedEvent.loadFeed(reset: true));
            },
            child: CustomScrollView(
              slivers: [
                // ── Large app bar ──────────────────────────────────────────
                _HomeSliverHeader(cs: cs, blueTint: blueTint),

                // ── Body ───────────────────────────────────────────────────
                BlocBuilder<CommunityHomeCubit, CommunityHomeState>(
                  builder: (context, state) {
                    if (state is CommunityHomeLoading ||
                        state is CommunityHomeInitial) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: CommunityHomeSkeleton(),
                      );
                    }

                    if (state is CommunityHomeError) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: _HomeError(
                          message: state.message,
                          onRetry: () =>
                              context.read<CommunityHomeCubit>().load(),
                        ),
                      );
                    }

                    if (state is CommunityHomeLoaded) {
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDimensions.screenPadding,
                          6,
                          AppDimensions.screenPadding,
                          100,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            // Featured hero
                            if (state.featuredPost != null) ...[
                              FeaturedHeroCard(
                                post: state.featuredPost!,
                                onTap: () =>
                                    _openThread(context, state.featuredPost!),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Your circles
                            if (state.circles.isNotEmpty) ...[
                              _SectionHeader(
                                title: 'Your circles',
                                actionLabel: 'See all',
                                onAction: null, // TODO: circles list screen
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 145 * textScale,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  itemCount: state.circles.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, i) {
                                    final circle = state.circles[i];
                                    return CircleTile(
                                      circle: circle,
                                      onTap: () => context.push(
                                        '/community/circle/${Uri.encodeComponent(circle.slug)}',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Ask prompt
                            AskCommunityPrompt(
                              onTap: () =>
                                  context.push(AppRoutes.communityCompose.path),
                              onMicTap: () =>
                                  context.push(AppRoutes.communityCompose.path),
                            ),
                            const SizedBox(height: 20),

                            // Trending today
                            if (state.trendingPosts.isNotEmpty) ...[
                              _SectionHeader(
                                title: 'Trending today',
                                actionLabel: 'All Feed',
                                onAction: () =>
                                    context.push(AppRoutes.communityFeed.path),
                              ),
                              const SizedBox(height: 12),
                              ...state.trendingPosts.map(
                                (post) => Padding(
                                  padding: const EdgeInsets.only(bottom: 13),
                                  child: CommunityThreadCard(
                                    post: post,
                                    onLike: () {}, // stub — no feed BLoC here
                                    onReply: () => _openThread(context, post),
                                    onReport: () {},
                                    onSave: () {}, // stub — no feed BLoC here
                                    onTap: () => _openThread(context, post),
                                  ),
                                ),
                              ),
                            ] else ...[
                              // Show "Feed" link even when trending is empty
                              _SectionHeader(
                                title: 'Trending today',
                                actionLabel: 'Feed',
                                onAction: () =>
                                    context.push(AppRoutes.communityFeed.path),
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Text(
                                    'No trending posts yet.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: ext?.ink3 ?? cs.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Latest feed — full interactive cards powered by
                            // ConnectFeedBloc, with featured/trending excluded.
                            const SizedBox(height: 20),
                            _LatestFeedSection(
                              excludeIds: {
                                if (state.featuredPost != null)
                                  state.featuredPost!.id,
                                ...state.trendingPosts.map((p) => p.id),
                              },
                            ),
                          ]),
                        ),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openThread(BuildContext context, PostEntity post) {
    context.push('/community/thread/${post.id}', extra: post);
  }
}

// =============================================================================
// LARGE APP BAR
// =============================================================================

class _HomeSliverHeader extends StatelessWidget {
  const _HomeSliverHeader({required this.cs, required this.blueTint});

  final ColorScheme cs;
  final Color blueTint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final line = ext?.line ?? cs.outline;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.screenPaddingMin,
          right: AppDimensions.screenPaddingMin,
          top: 6,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Community',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),
                Semantics(
                  button: true,
                  label: 'Listen to community',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(community): TTS read aloud.
                    },
                    child: Container(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      decoration: BoxDecoration(
                        color: blueTint,
                        shape: BoxShape.circle,
                      ),
                      child: ExcludeSemantics(
                        child: Icon(
                          Icons.volume_up_outlined,
                          size: AppDimensions.iconLg,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Semantics(
                  button: true,
                  label: 'Search',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(community): open search.
                    },
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(
                            Icons.search,
                            size: AppDimensions.iconLg,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                'Peers who get it — share, ask, and listen',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: line),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION HEADER ROW
// =============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: ext?.ink3 ?? cs.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          if (onAction != null)
            Semantics(
              button: true,
              label: actionLabel,
              child: GestureDetector(
                onTap: onAction,
                child: ExcludeSemantics(
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =============================================================================
// LATEST FEED SECTION
// =============================================================================

/// Renders the full interactive feed below "Trending today" on the home screen.
///
/// Powered by [ConnectFeedBloc] (already provided above the widget tree), so
/// likes, replies, and reports all work exactly as they do on the Feed screen.
/// Posts whose ids appear in [excludeIds] are filtered out to avoid repeating
/// the featured-hero and trending cards shown earlier on the page.
class _LatestFeedSection extends StatelessWidget {
  const _LatestFeedSection({required this.excludeIds});

  final Set<String> excludeIds;

  void _openThread(BuildContext context, PostEntity post) {
    context.push('/community/thread/${post.id}', extra: post);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return BlocBuilder<ConnectFeedBloc, ConnectFeedState>(
      builder: (context, state) {
        if (state is FeedLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        if (state is FeedError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Semantics(
                  button: true,
                  label: 'Retry loading feed',
                  child: TextButton(
                    onPressed: () => context
                        .read<ConnectFeedBloc>()
                        .add(const ConnectFeedEvent.loadFeed(reset: true)),
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is FeedLoaded) {
          final posts = state.posts
              .where((p) => !excludeIds.contains(p.id))
              .toList();

          if (posts.isEmpty && !state.isLoadingMore) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                title: 'Latest',
                actionLabel: 'All Feed',
                onAction: () =>
                    context.push(AppRoutes.communityFeed.path),
              ),
              const SizedBox(height: 12),
              ...posts.map(
                (post) => Padding(
                  padding: const EdgeInsets.only(bottom: 13),
                  child: CommunityThreadCard(
                    post: post,
                    onLike: () => context
                        .read<ConnectFeedBloc>()
                        .add(ConnectFeedEvent.toggleLike(post.id)),
                    onReply: () => _openThread(context, post),
                    onReport: () => ReportPostSheet.show(context, post.id),
                    onSave: () => context
                        .read<ConnectFeedBloc>()
                        .add(ConnectFeedEvent.toggleBookmark(post.id)),
                    onTap: () => _openThread(context, post),
                  ),
                ),
              ),
              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

// =============================================================================
// COMPOSE FAB
// =============================================================================

class _ComposeFab extends StatelessWidget {
  const _ComposeFab({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Create new post',
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.communityCompose.path),
        child: ExcludeSemantics(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withValues(alpha: 0.60),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                  spreadRadius: -6,
                ),
              ],
            ),
            child: const Icon(Icons.add, size: 26, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ERROR STATE
// =============================================================================

class _HomeError extends StatelessWidget {
  const _HomeError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: ext?.ink3 ?? cs.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Could not load community',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ext?.ink3 ?? cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Retry loading community',
              child: GestureDetector(
                onTap: onRetry,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      'Retry',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
