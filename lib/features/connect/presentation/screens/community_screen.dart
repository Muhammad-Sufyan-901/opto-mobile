import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_bottom_nav.dart';

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
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  /// Index of the currently selected topic chip (0-based).
  int _activeChip = 0;

  /// Like state for each post (post index → liked).
  final Map<int, bool> _liked = {0: true, 1: false};

  static const List<String> _topics = [
    'For you',
    'Low vision',
    'Prosthetics',
    'Tech tips',
  ];

  static const List<_PostData> _posts = [
    _PostData(
      avatarColor: Color(0xFF2563D6),
      initials: 'DW',
      name: 'Dewi W.',
      meta: 'Moderator · 2h',
      body:
          'Reminder: our weekly audio meet-up is tonight at 8. We\'ll share favorite TalkBack shortcuts — newcomers very welcome 💙',
      likes: 24,
      replies: 8,
    ),
    _PostData(
      avatarColor: Color(0xFF1F8A5B),
      initials: 'HS',
      name: 'Hendra S.',
      meta: '4h',
      body:
          'Just got my new prosthesis fitted. The Hub\'s cleaning reminders have been a lifesaver. What\'s everyone\'s routine?',
      likes: 17,
      replies: 12,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Community. Showing posts for you.',
        TextDirection.ltr,
      );
    });
  }

  void _toggleLike(int index) {
    setState(() {
      _liked[index] = !(_liked[index] ?? false);
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
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: 2),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Scrollable content ────────────────────────────────────────
            SingleChildScrollView(
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
                    // ── Header row ─────────────────────────────────────────
                    _HeaderRow(
                      cs: cs,
                      blueTint: blueTint,
                      blueStrong: blueStrong,
                    ),

                    const SizedBox(height: 14),

                    // ── Topic chip row ─────────────────────────────────────
                    _TopicChipRow(
                      topics: _topics,
                      activeIndex: _activeChip,
                      cs: cs,
                      line: line,
                      ink2: ink2,
                      onChanged: (i) => setState(() => _activeChip = i),
                    ),

                    const SizedBox(height: 18),

                    // ── Post list ──────────────────────────────────────────
                    Column(
                      children: List.generate(_posts.length, (i) {
                        final post = _posts[i];
                        final bool liked = _liked[i] ?? false;

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i < _posts.length - 1 ? 14 : 0,
                          ),
                          child: _PostCard(
                            post: post,
                            liked: liked,
                            cs: cs,
                            line: line,
                            ink2: ink2,
                            ink3: ink3,
                            onLike: () => _toggleLike(i),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            // ── Compose FAB ────────────────────────────────────────────────
            Positioned(
              bottom: 96,
              right: 20,
              child: _ComposeFab(cs: cs),
            ),
          ],
        ),
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
        Text(
          'Community',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),

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
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// POST CARD
// =============================================================================

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.liked,
    required this.cs,
    required this.line,
    required this.ink2,
    required this.ink3,
    required this.onLike,
  });

  final _PostData post;
  final bool liked;
  final ColorScheme cs;
  final Color line;
  final Color ink2;
  final Color ink3;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    // Adjust the displayed like count relative to the seed state.
    // _isInitiallyLiked == true  → seed already included +1; un-liking removes it.
    // _isInitiallyLiked == false → seed did not include +1; liking adds it.
    final int displayLikes =
        post.likes + (liked == _isInitiallyLiked ? 0 : liked ? 1 : -1);

    return Semantics(
      container: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF142850).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Post header ──────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar — decorative, announced via card container
                ExcludeSemantics(
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: post.avatarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        post.initials,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Name + meta
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      post.meta,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: ink3,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ── Post body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                post.body,
                style: TextStyle(
                  fontSize: 16.5,
                  color: cs.onSurface,
                  height: 1.5,
                ),
              ),
            ),

            // ── Post actions ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: _PostActions(
                likes: displayLikes,
                replies: post.replies,
                liked: liked,
                cs: cs,
                ink2: ink2,
                onLike: onLike,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Whether this post was initially liked in the seed data.
  /// Post 0 (Dewi W.) starts as liked, post 1 (Hendra S.) starts as not liked.
  bool get _isInitiallyLiked => post.initials == 'DW';
}

// =============================================================================
// POST ACTIONS ROW
// =============================================================================

class _PostActions extends StatelessWidget {
  const _PostActions({
    required this.likes,
    required this.replies,
    required this.liked,
    required this.cs,
    required this.ink2,
    required this.onLike,
  });

  final int likes;
  final int replies;
  final bool liked;
  final ColorScheme cs;
  final Color ink2;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Like button
        Semantics(
          button: true,
          label: 'Like, $likes likes${liked ? ", liked" : ""}',
          child: GestureDetector(
            onTap: onLike,
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: liked ? cs.error : ink2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: liked ? cs.error : ink2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Reply button
        Semantics(
          button: true,
          label: 'Reply, $replies replies',
          child: GestureDetector(
            onTap: () {
              // TODO(community): open reply thread
            },
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.reply_outlined,
                      size: 20,
                      color: ink2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      '$replies',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: ink2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Spacer pushes Listen to the right
        const Spacer(),

        // Listen button
        Semantics(
          button: true,
          label: 'Listen to post',
          child: GestureDetector(
            onTap: () {
              // TODO(community): read post aloud via TTS
            },
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.volume_up_outlined,
                      size: 20,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      'Listen',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
        onTap: () {
          // TODO(community): open compose new post sheet
        },
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

// =============================================================================
// DATA CLASSES
// =============================================================================

/// Immutable data for a community post card.
class _PostData {
  const _PostData({
    required this.avatarColor,
    required this.initials,
    required this.name,
    required this.meta,
    required this.body,
    required this.likes,
    required this.replies,
  });

  final Color avatarColor;
  final String initials;
  final String name;
  final String meta;
  final String body;
  final int likes;
  final int replies;
}
