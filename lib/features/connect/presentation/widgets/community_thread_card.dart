// Redesigned thread card for the Connect community feed.
//
// Matches the `co-thread` design from Android Community.html:
//   • Author row with avatar, name, verified badge, topic pill, relative time,
//     and a trailing "more" (report) button.
//   • Optional title heading (`co-thread-h`).
//   • Body text (`co-thread-b`).
//   • Optional voice-note player when voiceUrl is present.
//   • Footer stat pills: heart+likes (filled when liked), reply+count,
//     spacer, save (stub), share (stub).
//
// All interactive elements wrapped in [Semantics]; decorative parts in
// [ExcludeSemantics]. Meaning is never conveyed by colour alone.
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/widgets/community_avatar.dart';
import 'package:opto/features/connect/presentation/widgets/voice_note_player.dart';

/// Reusable card that renders a single community [PostEntity] in the feed.
///
/// Actions ([onLike], [onReply], [onReport], [onTap]) are callbacks so the
/// widget stays stateless — state lives in the parent BLoC.
class CommunityThreadCard extends StatelessWidget {
  const CommunityThreadCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onReply,
    required this.onReport,
    this.onTap,
  });

  final PostEntity post;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onReport;
  final VoidCallback? onTap;

  // ── Relative time ───────────────────────────────────────────────────────
  static String _relativeTime(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${(d.inDays / 7).floor()}w';
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

    final String authorName = post.authorName ?? 'Community Member';
    final String timeLabel = _relativeTime(post.createdAt);

    // Semantic label for the whole card.
    final String semanticLabel =
        '${post.title ?? post.body}. By $authorName'
        '${post.authorIsVerified ? ", verified" : ""}'
        '${post.topic != null ? ", ${post.topic}" : ""}. '
        '$timeLabel. '
        '${post.likeCount} like${post.likeCount == 1 ? "" : "s"}, '
        '${post.replyCount} repl${post.replyCount == 1 ? "y" : "ies"}.';

    return Semantics(
      container: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: blueTint,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(color: line, width: 1.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Author row ──────────────────────────────────────────────
              ExcludeSemantics(
                child: _AuthorRow(
                  authorName: authorName,
                  authorId: post.authorId,
                  isVerified: post.authorIsVerified,
                  topic: post.topic,
                  timeLabel: timeLabel,
                  ink2: ink2,
                  ink3: ink3,
                  cs: cs,
                  onReport: onReport,
                ),
              ),

              const SizedBox(height: 13),

              // ── Title (when present) ────────────────────────────────────
              if (post.title != null && post.title!.isNotEmpty) ...[
                ExcludeSemantics(
                  child: Text(
                    post.title!,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: -0.3,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],

              // ── Body ────────────────────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  post.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ink2,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ── Voice note player ───────────────────────────────────────
              if (post.voiceUrl != null) ...[
                const SizedBox(height: 12),
                ExcludeSemantics(
                  excluding: false, // player has its own semantics
                  child: VoiceNotePlayer(
                    durationLabel: '0:00',
                    voiceUrl: post.voiceUrl,
                  ),
                ),
              ],

              const SizedBox(height: 13),

              // ── Footer stat pills ───────────────────────────────────────
              ExcludeSemantics(
                child: _FooterRow(
                  post: post,
                  cs: cs,
                  ink2: ink2,
                  line: line,
                  onLike: onLike,
                  onReply: onReply,
                ),
              ),

              // ── Accessible action buttons (off-screen semantic targets) ─
              // The MergeSemantics at card level covers read-only fields;
              // individual interactive controls need their own labels.
              _InvisibleActions(
                post: post,
                onLike: onLike,
                onReply: onReply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// AUTHOR ROW
// =============================================================================

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({
    required this.authorName,
    required this.authorId,
    required this.isVerified,
    required this.topic,
    required this.timeLabel,
    required this.ink2,
    required this.ink3,
    required this.cs,
    required this.onReport,
  });

  final String authorName;
  final String authorId;
  final bool isVerified;
  final String? topic;
  final String timeLabel;
  final Color ink2;
  final Color ink3;
  final ColorScheme cs;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color blueTint2 = (ext?.blueTint ?? cs.primaryContainer)
        .withValues(alpha: 0.6);
    final Color onTint = ext?.ink2 ?? cs.onSurfaceVariant;

    return Row(
      children: [
        // Avatar
        CommunityAvatar(name: authorName, authorId: authorId, size: 44),

        const SizedBox(width: 12),

        // Name + verified + topic pill + time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      authorName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isVerified) ...[
                    const SizedBox(width: 5),
                    Icon(Icons.verified, size: 15, color: cs.primary),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (topic != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: blueTint2,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        topic!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: onTint,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    Text('·', style: TextStyle(color: ink3)),
                  ],
                  Text(
                    timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: ink3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // More / report button
        SizedBox(
          width: AppDimensions.minTapTarget,
          height: AppDimensions.minTapTarget,
          child: Semantics(
            button: true,
            label: 'More options for this post',
            child: GestureDetector(
              onTap: onReport,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(Icons.more_horiz, size: AppDimensions.iconLg,
                      color: ink2),
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
// FOOTER STAT PILLS
// =============================================================================

class _FooterRow extends StatelessWidget {
  const _FooterRow({
    required this.post,
    required this.cs,
    required this.ink2,
    required this.line,
    required this.onLike,
    required this.onReply,
  });

  final PostEntity post;
  final ColorScheme cs;
  final Color ink2;
  final Color line;
  final VoidCallback onLike;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final Color surface = cs.surface;

    return Builder(
      builder: (context) {
        final isLargeText = MediaQuery.textScalerOf(context).scale(1.0) > 1.5;
        final likeButton = _StatPill(
          icon: post.likedByMe ? Icons.favorite : Icons.favorite_border,
          label: '${post.likeCount}',
          active: post.likedByMe,
          activeColor: cs.error,
          surface: surface,
          line: line,
          ink2: ink2,
          onTap: onLike,
        );
        final replyButton = _StatPill(
          icon: Icons.forum_outlined,
          label: '${post.replyCount}',
          active: false,
          activeColor: cs.primary,
          surface: surface,
          line: line,
          ink2: ink2,
          onTap: onReply,
        );
        final saveButton = _StatPill(
          icon: Icons.bookmark_border,
          label: '',
          active: false,
          activeColor: cs.primary,
          surface: surface,
          line: line,
          ink2: ink2,
          onTap: () {
            // TODO(community): bookmark / save post — not yet backed by DB.
          },
        );
        final shareButton = _StatPill(
          icon: Icons.share_outlined,
          label: '',
          active: false,
          activeColor: cs.primary,
          surface: surface,
          line: line,
          ink2: ink2,
          onTap: () {
            // TODO(community): share post — native share sheet.
          },
        );

        final leftGroup = Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            likeButton,
            replyButton,
          ],
        );
        final rightGroup = Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            saveButton,
            shareButton,
          ],
        );

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              leftGroup,
              rightGroup,
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// STAT PILL
// =============================================================================

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.surface,
    required this.line,
    required this.ink2,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final Color surface;
  final Color line;
  final Color ink2;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color iconColor = active ? activeColor : ink2;
    final Color bg = active
        ? activeColor.withValues(alpha: 0.10)
        : surface;
    final Color border = active
        ? activeColor.withValues(alpha: 0.35)
        : line;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: AppDimensions.iconMd,
                color: active
                    ? (icon == Icons.favorite ? activeColor : iconColor)
                    : ink2),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: active ? activeColor : ink2,
                  fontSize: 13.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// INVISIBLE ACCESSIBLE ACTION BUTTONS
// =============================================================================
// These 0-size semantic nodes sit outside the ExcludeSemantics subtree
// so TalkBack / VoiceOver users can focus and activate them.

class _InvisibleActions extends StatelessWidget {
  const _InvisibleActions({
    required this.post,
    required this.onLike,
    required this.onReply,
  });

  final PostEntity post;
  final VoidCallback onLike;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      child: Row(
        children: [
          Semantics(
            button: true,
            label: post.likedByMe
                ? 'Unlike. ${post.likeCount} likes'
                : 'Like. ${post.likeCount} likes',
            child: GestureDetector(
              onTap: onLike,
              child: const SizedBox(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget),
            ),
          ),
          Semantics(
            button: true,
            label:
                'Reply. ${post.replyCount} repl${post.replyCount == 1 ? "y" : "ies"}',
            child: GestureDetector(
              onTap: onReply,
              child: const SizedBox(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget),
            ),
          ),
          Semantics(
            button: true,
            label: 'Save post',
            child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget),
          ),
          Semantics(
            button: true,
            label: 'Share post',
            child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget),
          ),
        ],
      ),
    );
  }
}
