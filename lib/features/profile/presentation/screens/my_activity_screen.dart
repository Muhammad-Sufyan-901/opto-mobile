import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/profile/presentation/cubit/my_activity_cubit.dart';
import 'package:opto/features/profile/presentation/widgets/profile_stats_row.dart';

// ── Root widget — provides the cubit ─────────────────────────────────────────

/// Screen P6 — My Activity.
///
/// Shows the current user's community contributions (posts, stats).
/// Data is loaded via [MyActivityCubit] which reuses [MemberRepository] from
/// the Connect feature.
class MyActivityScreen extends StatelessWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyActivityCubit>(
      create: (_) => sl<MyActivityCubit>(),
      child: const _ActivityBody(),
    );
  }
}

// ── Body widget — owns filter + list state ────────────────────────────────────

class _ActivityBody extends StatefulWidget {
  const _ActivityBody();

  @override
  State<_ActivityBody> createState() => _ActivityBodyState();
}

class _ActivityBodyState extends State<_ActivityBody> {
  String _filter = 'posts';

  static const _filters = [
    _Filter(id: 'posts', label: 'Posts', icon: Icons.edit_outlined),
    _Filter(id: 'saved', label: 'Saved', icon: Icons.bookmark_outline),
    _Filter(id: 'replies', label: 'Replies', icon: Icons.reply_outlined),
    _Filter(id: 'liked', label: 'Liked', icon: Icons.favorite_border),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        context.read<MyActivityCubit>().load(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyActivityCubit, MyActivityState>(
      builder: (ctx, state) {
        if (state is MyActivityLoading || state is MyActivityInitial) {
          return _buildScaffold(ctx, body: Center(
            child: Semantics(
              label: 'Loading your activity, please wait.',
              child: const CircularProgressIndicator(),
            ),
          ));
        }
        if (state is MyActivityError) {
          return _buildScaffold(ctx, body: _buildErrorBody(ctx, state.message));
        }
        if (state is MyActivityLoaded) {
          // Announce once when loaded, using real counts.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final p = state.postsCount;
            final c = state.circlesCount;
            final h = state.helpfulCount;
            announce(ctx,
                'My activity. $p ${p == 1 ? "post" : "posts"}, '
                '$c ${c == 1 ? "circle" : "circles"}, $h helpful.');
          });
          return _buildScaffold(ctx, body: _buildLoadedBody(ctx, state));
        }
        // MyActivityInitial already handled above; exhaustive fallback.
        return _buildScaffold(ctx, body: const SizedBox.shrink());
      },
    );
  }

  // ── Scaffold shell (AppBar shared by all states) ────────────────────────────

  Widget _buildScaffold(BuildContext context, {required Widget body}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () => context.pop(),
            child: Center(
              child: ExcludeSemantics(
                child: Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
              ),
            ),
          ),
        ),
        title: Text(
          'My activity',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Listen to my activity',
            child: GestureDetector(
              onTap: () => HapticPatterns.focusTick(),
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                decoration: BoxDecoration(
                  color: blueTint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.volume_up_outlined,
                        size: 24, color: cs.secondary),
                  ),
                ),
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Filter activity',
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.filter_list_outlined,
                        size: 22, color: cs.onSurface),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: body),
    );
  }

  // ── Error state ─────────────────────────────────────────────────────────────

  Widget _buildErrorBody(BuildContext context, String message) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: cs.error),
            const SizedBox(height: 16),
            Semantics(
              liveRegion: true,
              child: ExcludeSemantics(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: 'Retry loading my activity',
              child: ElevatedButton(
                onPressed: () {
                  final userId =
                      Supabase.instance.client.auth.currentUser?.id;
                  if (userId != null) {
                    context.read<MyActivityCubit>().load(userId);
                  }
                },
                child: const ExcludeSemantics(child: Text('Retry')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loaded state ─────────────────────────────────────────────────────────────

  Widget _buildLoadedBody(BuildContext context, MyActivityLoaded state) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Stats strip ──────────────────────────────────────────
              ProfileStatsRow(
                stats: [
                  ProfileStat(
                      value: _formatCount(state.postsCount), label: 'Posts'),
                  ProfileStat(
                      value: _formatCount(state.circlesCount),
                      label: 'Circles'),
                  ProfileStat(
                      value: _formatCount(state.helpfulCount),
                      label: 'Helpful'),
                ],
              ),

              const SizedBox(height: 14),

              // ── Filter chips ─────────────────────────────────────────
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 9),
                  itemBuilder: (_, i) {
                    final f = _filters[i];
                    final bool selected = _filter == f.id;
                    return Semantics(
                      button: true,
                      selected: selected,
                      label:
                          '${f.label} filter${selected ? ", selected" : ""}',
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _filter = f.id);
                          HapticPatterns.focusTick();
                          announce(context, '${f.label} filter selected.');
                        },
                        child: Container(
                          height: 40,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: selected
                                ? cs.primary
                                : blueTint.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? cs.primary : line,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ExcludeSemantics(
                                child: Icon(
                                  f.icon,
                                  size: 15,
                                  color:
                                      selected ? Colors.white : ink2,
                                ),
                              ),
                              const SizedBox(width: 7),
                              ExcludeSemantics(
                                child: Text(
                                  f.label,
                                  style: theme.textTheme.labelMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? Colors.white
                                        : ink2,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // ── Content area — posts/saved or coming-soon ─────────────
              if (_filter == 'posts' || _filter == 'saved') ...[
                if ((_filter == 'posts' ? state.posts : state.savedPosts)
                    .isEmpty)
                  _filter == 'posts'
                      ? _buildEmptyPosts(context, theme, cs,
                          ext?.ink2 ?? cs.onSurfaceVariant)
                      : _buildEmptySaved(context, theme, cs,
                          ext?.ink2 ?? cs.onSurfaceVariant)
                else
                  for (final post in (_filter == 'posts'
                      ? state.posts
                      : state.savedPosts)) ...[
                    _ActivityCard(
                      post: post,
                      theme: theme,
                      cs: cs,
                      ext: ext,
                      line: line,
                      ink2: ink2,
                      ink3: ink3,
                      blueTint: blueTint,
                      onTap: () {
                        // TODO(activity): navigate to thread when thread route exists
                      },
                    ),
                    const SizedBox(height: 13),
                  ],
              ] else
                _buildComingSoon(context, theme, cs,
                    ext?.ink2 ?? cs.onSurfaceVariant),
            ]),
          ),
        ),
      ],
    );
  }

  // ── Empty / coming-soon helpers ─────────────────────────────────────────────

  Widget _buildEmptyPosts(
      BuildContext context, ThemeData theme, ColorScheme cs, Color ink2) {
    return Semantics(
      label: 'No posts yet. Your posts will appear here once you share '
          'something with the community.',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.edit_off_outlined,
                  size: 48, color: cs.outlineVariant),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                'No posts yet',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 6),
            ExcludeSemantics(
              child: Text(
                'Your posts will appear here once you share something '
                'with the community.',
                style: theme.textTheme.bodySmall?.copyWith(color: ink2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySaved(
      BuildContext context, ThemeData theme, ColorScheme cs, Color ink2) {
    return Semantics(
      label: 'No saved posts yet. Posts you bookmark will appear here.',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.bookmark_border,
                  size: 48, color: cs.outlineVariant),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                'No saved posts yet',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 6),
            ExcludeSemantics(
              child: Text(
                'Posts you bookmark will appear here.',
                style: theme.textTheme.bodySmall?.copyWith(color: ink2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoon(
      BuildContext context, ThemeData theme, ColorScheme cs, Color ink2) {
    return Semantics(
      label: 'This section is coming soon.',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.hourglass_empty_outlined,
                  size: 48, color: cs.outlineVariant),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                'Coming soon',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 6),
            ExcludeSemantics(
              child: Text(
                'This section will be available in a future update.',
                style: theme.textTheme.bodySmall?.copyWith(color: ink2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Formatting helpers ──────────────────────────────────────────────────────

  static String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays >= 365) return '${diff.inDays ~/ 365}y';
    if (diff.inDays >= 30) return '${diff.inDays ~/ 30}mo';
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w';
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    return 'now';
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _Filter {
  const _Filter({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

// ── Card widget ───────────────────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.post,
    required this.theme,
    required this.cs,
    required this.ext,
    required this.line,
    required this.ink2,
    required this.ink3,
    required this.blueTint,
    required this.onTap,
  });

  final PostEntity post;
  final ThemeData theme;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final Color line;
  final Color ink2;
  final Color ink3;
  final Color blueTint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final circle = post.topic ?? 'Community';
    final timeAgo = _ActivityBodyState._timeAgo(post.createdAt);
    final title = post.title ??
        (post.body.length > 80
            ? '${post.body.substring(0, 80)}…'
            : post.body);
    final hasVoice = post.voiceUrl != null;

    return Semantics(
      button: true,
      label: '$circle circle. $timeAgo ago. '
          '$title. '
          '${post.likeCount} helpful. ${post.replyCount} replies.'
          '${hasVoice ? " Includes voice note." : ""}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: blueTint.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meta row
              ExcludeSemantics(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: blueTint,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        circle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.secondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('·', style: TextStyle(color: ink3)),
                    const SizedBox(width: 6),
                    Text(
                      timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ink3,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    if (hasVoice) ...[
                      const Spacer(),
                      Icon(Icons.volume_up_outlined,
                          size: 13, color: cs.primary),
                      const SizedBox(width: 4),
                      Text(
                        'VOICE',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.primary,
                          fontSize: 10.5,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 11),

              // Title
              ExcludeSemantics(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                    letterSpacing: -0.3,
                    height: 1.25,
                    fontSize: 16.5,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Footer stats
              ExcludeSemantics(
                child: Row(
                  children: [
                    _StatPill(
                      icon: Icons.favorite_border,
                      count: post.likeCount,
                      theme: theme,
                      cs: cs,
                      line: line,
                      ink2: ink2,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      icon: Icons.reply_outlined,
                      count: post.replyCount,
                      theme: theme,
                      cs: cs,
                      line: line,
                      ink2: ink2,
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: ink3, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.count,
    required this.theme,
    required this.cs,
    required this.line,
    required this.ink2,
  });

  final IconData icon;
  final int count;
  final ThemeData theme;
  final ColorScheme cs;
  final Color line;
  final Color ink2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: line, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ink2),
          const SizedBox(width: 6),
          Text(
            '$count',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: ink2,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }
}
