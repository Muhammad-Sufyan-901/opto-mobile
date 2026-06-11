// Reusable post card for the Connect community feed.
//
// Displays author info, post body, and action buttons (like / reply / listen /
// report). All interactive elements are wrapped in [Semantics] with meaningful
// labels; decorative art is hidden from the accessibility tree via
// [ExcludeSemantics].
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';

/// Public, reusable card that renders a single community [PostEntity].
///
/// All actions ([onLike], [onReply], [onReport]) are callbacks to keep the
/// widget stateless — state lives in the parent BLoC.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onReply,
    required this.onReport,
  });

  final PostEntity post;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String authorName = post.authorName ?? 'Community Member';
    final String initials = authorName.isNotEmpty
        ? authorName.trim()[0].toUpperCase()
        : 'U';
    final String timeLabel = _formatRelativeTime(post.createdAt);

    return Semantics(
      container: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: line, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF142850).withValues(alpha: 0.04),
              blurRadius: AppDimensions.shadowBlur,
              offset: Offset(0, AppDimensions.shadowOffsetY),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Post header ──────────────────────────────────────────────
            MergeSemantics(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar — decorative, semantic info is in MergeSemantics above
                  ExcludeSemantics(
                    child: _AvatarBubble(initials: initials),
                  ),

                  const SizedBox(width: 12),

                  // Name + meta — merged into one a11y node by MergeSemantics
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authorName,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: ink3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Report button — ellipsis / more options
                  Semantics(
                    button: true,
                    label: 'Report this post',
                    child: GestureDetector(
                      onTap: onReport,
                      child: SizedBox(
                        width: AppDimensions.minTapTarget,
                        height: AppDimensions.minTapTarget,
                        child: Center(
                          child: ExcludeSemantics(
                            child: Icon(
                              Icons.more_horiz,
                              size: AppDimensions.iconMd,
                              color: ink2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Post body ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                post.body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface,
                  height: 1.5,
                ),
              ),
            ),

            // ── Post actions ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: _PostActions(
                post: post,
                cs: cs,
                ink2: ink2,
                onLike: onLike,
                onReply: onReply,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formats [dateTime] as a short relative time string (e.g. "2h", "3d").
  static String _formatRelativeTime(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}

// =============================================================================
// AVATAR BUBBLE
// =============================================================================

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.initials});

  final String initials;

  /// Deterministic color from the initial character to vary avatars.
  static Color _colorFor(String initial) {
    final List<Color> palette = [
      const Color(0xFF2563D6),
      const Color(0xFF1F8A5B),
      const Color(0xFF7C3AED),
      const Color(0xFFD97706),
      const Color(0xFFDB2777),
    ];
    final int index = initial.codeUnitAt(0) % palette.length;
    return palette[index];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _colorFor(initials),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// POST ACTIONS ROW
// =============================================================================

class _PostActions extends StatelessWidget {
  const _PostActions({
    required this.post,
    required this.cs,
    required this.ink2,
    required this.onLike,
    required this.onReply,
  });

  final PostEntity post;
  final ColorScheme cs;
  final Color ink2;
  final VoidCallback onLike;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool liked = post.likedByMe;
    final int likes = post.likeCount;
    final int replies = post.replyCount;

    return Row(
      children: [
        // ── Like button ──────────────────────────────────────────────────
        Semantics(
          button: true,
          label:
              'Like this post, $likes like${likes == 1 ? "" : "s"}${liked ? ", liked" : ""}',
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
                      size: AppDimensions.iconMd,
                      color: liked ? cs.error : ink2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      '$likes',
                      style: theme.textTheme.bodySmall?.copyWith(
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

        // ── Reply button ─────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Reply to this post, $replies repl${replies == 1 ? "y" : "ies"}',
          child: GestureDetector(
            onTap: onReply,
            child: SizedBox(
              height: AppDimensions.minTapTarget,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.reply_outlined,
                      size: AppDimensions.iconMd,
                      color: ink2,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      '$replies',
                      style: theme.textTheme.bodySmall?.copyWith(
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

        // ── Listen button ────────────────────────────────────────────────
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
                      size: AppDimensions.iconMd,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  ExcludeSemantics(
                    child: Text(
                      'Listen',
                      style: theme.textTheme.bodySmall?.copyWith(
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
