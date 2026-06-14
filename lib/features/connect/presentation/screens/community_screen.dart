import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_bloc.dart';
import 'package:opto/features/connect/presentation/widgets/community_thread_card.dart';
import 'package:opto/features/connect/presentation/widgets/report_post_sheet.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 19 — Community Feed (K2)
///
/// Redesigned to match the Android Community design (K2 · Feed artboard):
///   • Large title + subtitle app bar.
///   • Voice-first search bar (stub).
///   • Topic filter chips with server-side filtering.
///   • Feed of [CommunityThreadCard]s with like / reply / report actions.
///   • Realtime new-post announcement.
///   • FAB to compose a new post.
///
/// Accessibility: TalkBack / VoiceOver announcement on mount, all interactive
/// elements wrapped in [Semantics], decorative art excluded.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConnectFeedBloc>(
      create: (_) => sl<ConnectFeedBloc>()
        ..add(const ConnectFeedEvent.loadFeed())
        ..add(const ConnectFeedEvent.subscribeFeed()),
      child: const _CommunityView(),
    );
  }
}

// =============================================================================
// INNER STATEFUL VIEW
// =============================================================================

class _CommunityView extends StatefulWidget {
  const _CommunityView();

  @override
  State<_CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<_CommunityView> {
  // Topic chips — "All" maps to null (no server filter), others are exact
  // topic labels stored in the posts table.
  static const List<String?> _topicValues = [
    null,
    'Prosthetic care',
    'Low vision',
    'Daily living',
    'Tech & apps',
    'Wins',
  ];

  static const List<String> _topicLabels = [
    'All',
    'Prosthetic care',
    'Low vision',
    'Daily living',
    'Tech & apps',
    'Wins',
  ];

  /// Last known post count to detect Realtime arrivals.
  int _lastKnownPostCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Community feed. Showing all posts.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return BlocListener<ConnectFeedBloc, ConnectFeedState>(
      listener: (context, state) {
        if (state is FeedLoaded) {
          final int newCount = state.posts.length;
          if (newCount > _lastKnownPostCount && _lastKnownPostCount > 0) {
            final newPost = state.posts.first;
            announce(
              context,
              'New post from ${newPost.authorName ?? "someone"}.',
            );
          }
          _lastKnownPostCount = newCount;
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        bottomNavigationBar: const HomeBottomNav(activeTab: 2),
        floatingActionButton: _ComposeFab(cs: cs),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ConnectFeedBloc>()
                  .add(const ConnectFeedEvent.loadFeed(reset: true));
            },
            child: CustomScrollView(
              slivers: [
                // ── Large app bar ──────────────────────────────────────────
                _FeedSliverHeader(
                  cs: cs,
                  blueTint: blueTint,
                ),

                // ── Search bar ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPadding,
                    ),
                    child: _SearchBar(cs: cs, line: line, ink3: ink3),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // ── Topic chips ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: BlocBuilder<ConnectFeedBloc, ConnectFeedState>(
                    buildWhen: (prev, next) {
                      if (prev is FeedLoaded && next is FeedLoaded) {
                        return prev.activeTopic != next.activeTopic;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      final int active =
                          state is FeedLoaded ? state.activeTopic : 0;
                      return _TopicChipRow(
                        labels: _topicLabels,
                        activeIndex: active,
                        cs: cs,
                        line: line,
                        ink2: ink2,
                        onChanged: (i) {
                          context.read<ConnectFeedBloc>().add(
                                ConnectFeedEvent.changeTopicFilter(
                                  index: i,
                                  topic: _topicValues[i],
                                ),
                              );
                        },
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 18)),

                // ── Feed ───────────────────────────────────────────────────
                BlocBuilder<ConnectFeedBloc, ConnectFeedState>(
                  builder: (context, state) {
                    if (state is FeedLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: _LoadingIndicator()),
                      );
                    }

                    if (state is FeedError) {
                      return SliverFillRemaining(
                        child: _FeedError(
                          message: state.message,
                          onRetry: () => context
                              .read<ConnectFeedBloc>()
                              .add(const ConnectFeedEvent.loadFeed(
                                  reset: true)),
                        ),
                      );
                    }

                    if (state is FeedLoaded) {
                      if (state.posts.isEmpty) {
                        return const SliverFillRemaining(
                            child: _EmptyFeed());
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.only(
                          left: AppDimensions.screenPadding,
                          right: AppDimensions.screenPadding,
                          bottom: 100,
                        ),
                        sliver: SliverList.separated(
                          itemCount: state.posts.length +
                              (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 13),
                          itemBuilder: (context, i) {
                            if (i == state.posts.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: _LoadingIndicator()),
                              );
                            }
                            final post = state.posts[i];
                            return CommunityThreadCard(
                              post: post,
                              onLike: () => context
                                  .read<ConnectFeedBloc>()
                                  .add(ConnectFeedEvent.toggleLike(post.id)),
                              onReply: () => _openThread(context, post),
                              onReport: () =>
                                  ReportPostSheet.show(context, post.id),
                              onTap: () => _openThread(context, post),
                            );
                          },
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
    context.push(
      '/community/thread/${post.id}',
      extra: post,
    );
  }
}

// =============================================================================
// SLIVER LARGE APP BAR
// =============================================================================

class _FeedSliverHeader extends StatelessWidget {
  const _FeedSliverHeader({required this.cs, required this.blueTint});

  final ColorScheme cs;
  final Color blueTint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppDimensions.screenPaddingMin,
          right: AppDimensions.screenPaddingMin,
          top: 6,
          bottom: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top action row
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Feed',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),
                // Listen button (tonal)
                Semantics(
                  button: true,
                  label: 'Listen to feed',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(community): TTS read feed aloud.
                    },
                    child: Container(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      decoration: BoxDecoration(
                        color: blueTint,
                        shape: BoxShape.circle,
                      ),
                      child: ExcludeSemantics(
                        child: Icon(Icons.volume_up_outlined,
                            size: AppDimensions.iconLg, color: cs.primary),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Filter button
                Semantics(
                  button: true,
                  label: 'Filter feed',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(community): bottom sheet filter.
                    },
                    child: SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(Icons.tune_outlined,
                              size: AppDimensions.iconLg,
                              color: cs.onSurface),
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
                'Latest from circles you follow',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.extension<AppExtendedCustomColors>()?.ink2 ??
                      cs.onSurfaceVariant,
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
// SEARCH BAR
// =============================================================================

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.cs,
    required this.line,
    required this.ink3,
  });

  final ColorScheme cs;
  final Color line;
  final Color ink3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color tint = ext?.blueTint ?? cs.primaryContainer;

    return Semantics(
      label: 'Search posts, people or circles. Double-tap to search.',
      button: true,
      child: GestureDetector(
        onTap: () {
          // TODO(community): open search screen.
        },
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(Icons.search, size: AppDimensions.iconLg,
                    color: ink3),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    'Search posts, people or circles',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ink3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ExcludeSemantics(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic_none_rounded,
                      size: AppDimensions.iconMd, color: cs.primary),
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
// TOPIC CHIP ROW
// =============================================================================

class _TopicChipRow extends StatelessWidget {
  const _TopicChipRow({
    required this.labels,
    required this.activeIndex,
    required this.cs,
    required this.line,
    required this.ink2,
    required this.onChanged,
  });

  final List<String> labels;
  final int activeIndex;
  final ColorScheme cs;
  final Color line;
  final Color ink2;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding),
        itemCount: labels.length,
        separatorBuilder: (context, index) => const SizedBox(width: 9),
        itemBuilder: (context, i) {
          final bool active = i == activeIndex;
          return Semantics(
            button: true,
            selected: active,
            label: '${labels[i]} topic filter${active ? ", selected" : ""}',
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: ExcludeSemantics(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? cs.primary : line,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Builder(builder: (context) {
                      final theme = Theme.of(context);
                      return Text(
                        labels[i],
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: active ? Colors.white : ink2,
                          fontSize: 14.5,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
        onTap: () => context.push('/community/compose'),
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
// EMPTY / ERROR / LOADING STATES
// =============================================================================

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading posts',
      child: const CircularProgressIndicator.adaptive(),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'No posts yet. Be the first to share!',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _FeedError extends StatelessWidget {
  const _FeedError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(color: cs.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Semantics(
            button: true,
            label: 'Retry loading posts',
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
