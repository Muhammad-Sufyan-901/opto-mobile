import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/presentation/widgets/profile_stats_row.dart';

/// Screen P6 — My Activity.
///
/// Shows the user's community contributions — posts, saves, replies, likes.
/// Content is static placeholder data; a real backend would hook up a
/// cubit/BLoC that pages the `posts` and `post_reactions` tables.
class MyActivityScreen extends StatefulWidget {
  const MyActivityScreen({super.key});

  @override
  State<MyActivityScreen> createState() => _MyActivityScreenState();
}

class _MyActivityScreenState extends State<MyActivityScreen> {
  String _filter = 'posts';

  static const _filters = [
    _Filter(id: 'posts', label: 'Posts', icon: Icons.edit_outlined),
    _Filter(id: 'saved', label: 'Saved', icon: Icons.bookmark_outline),
    _Filter(id: 'replies', label: 'Replies', icon: Icons.reply_outlined),
    _Filter(id: 'liked', label: 'Liked', icon: Icons.favorite_border),
  ];

  static const _posts = [
    _ActivityPost(
      circle: 'Daily living',
      timeAgo: '2d',
      title:
          'How I label spice jars with bump dots + voice memos',
      helpful: 64,
      replies: 21,
      hasVoice: true,
    ),
    _ActivityPost(
      circle: 'Prosthetic care',
      timeAgo: '1w',
      title:
          'My morning routine for a comfortable scleral shell',
      helpful: 88,
      replies: 30,
      hasVoice: true,
    ),
    _ActivityPost(
      circle: 'Low vision',
      timeAgo: '2w',
      title:
          'Switched my whole home to high-contrast bulbs — worth it',
      helpful: 52,
      replies: 14,
      hasVoice: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'My activity. 142 posts, 38 saved items, 6 circles.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
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
                child:
                    Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Stats strip ────────────────────────────────────────
                  const ProfileStatsRow(
                    stats: [
                      ProfileStat(value: '142', label: 'Posts'),
                      ProfileStat(value: '38', label: 'Saved'),
                      ProfileStat(value: '1.8k', label: 'Helpful'),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Filter chips ───────────────────────────────────────
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      itemCount: _filters.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 9),
                      itemBuilder: (_, i) {
                        final f = _filters[i];
                        final bool selected = _filter == f.id;
                        return Semantics(
                          button: true,
                          selected: selected,
                          label: '${f.label} filter${selected ? ", selected" : ""}',
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _filter = f.id);
                              HapticPatterns.focusTick();
                              announce(context,
                                  '${f.label} filter selected.');
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18),
                              decoration: BoxDecoration(
                                color: selected ? cs.primary : blueTint.withValues(alpha: 0.35),
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
                                      color: selected
                                          ? Colors.white
                                          : ink2,
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

                  // ── Posts list ─────────────────────────────────────────
                  for (final post in _posts) ...[
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
                        // TODO(activity): navigate to thread
                      },
                    ),
                    const SizedBox(height: 13),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

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

class _ActivityPost {
  const _ActivityPost({
    required this.circle,
    required this.timeAgo,
    required this.title,
    required this.helpful,
    required this.replies,
    required this.hasVoice,
  });

  final String circle;
  final String timeAgo;
  final String title;
  final int helpful;
  final int replies;
  final bool hasVoice;
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

  final _ActivityPost post;
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
    return Semantics(
      button: true,
      label: '${post.circle} circle. ${post.timeAgo} ago. '
          '${post.title}. '
          '${post.helpful} helpful. ${post.replies} replies.'
          '${post.hasVoice ? " Includes voice note." : ""}',
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
                        post.circle,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.secondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·',
                      style: TextStyle(color: ink3),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      post.timeAgo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ink3,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    if (post.hasVoice) ...[
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
                  post.title,
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
                      count: post.helpful,
                      theme: theme,
                      cs: cs,
                      line: line,
                      ink2: ink2,
                    ),
                    const SizedBox(width: 8),
                    _StatPill(
                      icon: Icons.reply_outlined,
                      count: post.replies,
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
