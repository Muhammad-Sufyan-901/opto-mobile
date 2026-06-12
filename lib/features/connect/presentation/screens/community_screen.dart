import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/presentation/bloc/connect_feed_bloc.dart';
import 'package:opto/features/connect/presentation/widgets/post_card.dart';
import 'package:opto/features/connect/presentation/widgets/report_post_sheet.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 19 — Community
///
/// Peer-to-peer connection hub for the Opto community — topic-filtered feed,
/// post cards with like / reply / listen actions, and a compose FAB.
///
/// Layout: white Scaffold + SafeArea + Stack (scrollable content + floating FAB),
/// bottom nav active at index 2 (Community).
///
/// Accessibility: TalkBack / VoiceOver announcement on mount, all interactive
/// elements wrapped in [Semantics], decorative art excluded via [ExcludeSemantics].
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
  /// Index of the currently selected topic chip (0-based).
  int _activeChip = 0;

  /// Tracks the last known post count to detect new Realtime posts.
  int _lastKnownPostCount = 0;

  static const List<String> _topics = [
    'For you',
    'Low vision',
    'Prosthetics',
    'Tech tips',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Community. Showing posts for you.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return BlocListener<ConnectFeedBloc, ConnectFeedState>(
      listener: (context, state) {
        if (state is FeedLoaded) {
          final int newCount = state.posts.length;
          if (newCount > _lastKnownPostCount && _lastKnownPostCount > 0) {
            // A new post arrived via Realtime — announce it.
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 22,
                  right: 22,
                  top: 14,
                  bottom: 96,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // ── Header row ───────────────────────────────────────────
                  _HeaderRow(
                    cs: cs,
                    blueTint: blueTint,
                    blueStrong: blueStrong,
                  ),

                  const SizedBox(height: 14),

                  // ── Topic chip row ───────────────────────────────────────
                  _TopicChipRow(
                    topics: _topics,
                    activeIndex: _activeChip,
                    cs: cs,
                    line: line,
                    ink2: ink2,
                    onChanged: (i) {
                      setState(() => _activeChip = i);
                      context
                          .read<ConnectFeedBloc>()
                          .add(ConnectFeedEvent.changeTopicFilter(i));
                    },
                  ),

                  const SizedBox(height: 18),

                  // ── Post list ────────────────────────────────────────────
                  BlocBuilder<ConnectFeedBloc, ConnectFeedState>(
                    builder: (context, state) {
                      if (state is FeedLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: _LoadingIndicator(),
                          ),
                        );
                      }

                      if (state is FeedError) {
                        return _FeedError(
                          message: state.message,
                          onRetry: () => context
                              .read<ConnectFeedBloc>()
                              .add(const ConnectFeedEvent.loadFeed(reset: true)),
                        );
                      }

                      if (state is FeedLoaded) {
                        if (state.posts.isEmpty) {
                          return const _EmptyFeed();
                        }
                        return Column(
                          children: [
                            for (int i = 0; i < state.posts.length; i++) ...[
                              PostCard(
                                post: state.posts[i],
                                onLike: () => context
                                    .read<ConnectFeedBloc>()
                                    .add(ConnectFeedEvent.toggleLike(
                                        state.posts[i].id)),
                                onReply: () => context.push(
                                    '/community/thread/${state.posts[i].id}'),
                                onReport: () => ReportPostSheet.show(
                                    context, state.posts[i].id),
                              ),
                              if (i < state.posts.length - 1)
                                const SizedBox(height: 14),
                            ],
                            if (state.isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Center(child: _LoadingIndicator()),
                              ),
                          ],
                        );
                      }

                      // FeedInitial
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOADING INDICATOR
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

// =============================================================================
// EMPTY STATE
// =============================================================================

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

// =============================================================================
// FEED ERROR
// =============================================================================

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

// =============================================================================
// HEADER ROW
// =============================================================================

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.cs,
    required this.blueTint,
    required this.blueStrong,
  });

  final ColorScheme cs;
  final Color blueTint;
  final Color blueStrong;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Builder(builder: (context) {
          final theme = Theme.of(context);
          return Text(
            'Community',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          );
        }),

        // Notifications bell
        Semantics(
          button: true,
          label: 'Notifications',
          child: GestureDetector(
            onTap: () {
              // TODO(community): open notifications panel
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: blueTint,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: blueStrong,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// TOPIC CHIP ROW
// =============================================================================

class _TopicChipRow extends StatelessWidget {
  const _TopicChipRow({
    required this.topics,
    required this.activeIndex,
    required this.cs,
    required this.line,
    required this.ink2,
    required this.onChanged,
  });

  final List<String> topics;
  final int activeIndex;
  final ColorScheme cs;
  final Color line;
  final Color ink2;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(topics.length, (i) {
          final bool active = i == activeIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < topics.length - 1 ? 9 : 0),
            child: _TopicChip(
              label: topics[i],
              active: active,
              cs: cs,
              line: line,
              ink2: ink2,
              onTap: () => onChanged(i),
            ),
          );
        }),
      ),
    );
  }
}

// =============================================================================
// TOPIC CHIP
// =============================================================================

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.active,
    required this.cs,
    required this.line,
    required this.ink2,
    required this.onTap,
  });

  final String label;
  final bool active;
  final ColorScheme cs;
  final Color line;
  final Color ink2;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label topic${active ? ", selected" : ""}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          decoration: BoxDecoration(
            color: active ? cs.primary : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: active ? cs.primary : line,
              width: 1.5,
            ),
          ),
          child: ExcludeSemantics(
            child: Builder(builder: (context) {
              final theme = Theme.of(context);
              return Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: active ? Colors.white : ink2,
                ),
              );
            }),
          ),
        ),
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
            child: const Icon(
              Icons.add,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
