// Thread detail screen — K3 in the Community design.
//
// Shows the original post at the top, then a reply list with nested threading
// and best-answer badges, then a mic-first composer at the bottom.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';
import 'package:opto/features/connect/presentation/cubit/post_thread_cubit.dart';
import 'package:opto/features/connect/presentation/share_post.dart';
import 'package:opto/features/connect/presentation/widgets/voice_note_player.dart';

/// Screen 19b — Post Thread (K3)
///
/// Renders:
///   • App bar: "Thread" + Listen + Share + More actions.
///   • Original post block (title, body, voice note, like/reply/save/flag stats).
///   • Reply count header + sort label.
///   • Reply bubbles with asymmetric border-radius, nested indentation, and
///     best-answer badge. OP author sees "Mark as best answer" affordance.
///   • Mic-first bottom composer for top-level and nested replies.
///
/// [seedPost] may be passed from the route extra for instant OP render
/// while the full thread loads from the network.
class PostThreadScreen extends StatelessWidget {
  const PostThreadScreen({
    super.key,
    required this.postId,
    this.seedPost,
  });

  final String postId;
  final PostEntity? seedPost;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostThreadCubit>(
      create: (_) => sl<PostThreadCubit>()..load(postId, seedPost: seedPost),
      child: _PostThreadView(postId: postId),
    );
  }
}

// =============================================================================
// INNER STATEFUL VIEW
// =============================================================================

class _PostThreadView extends StatefulWidget {
  const _PostThreadView({required this.postId});

  final String postId;

  @override
  State<_PostThreadView> createState() => _PostThreadViewState();
}

class _PostThreadViewState extends State<_PostThreadView> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocus = FocusNode();

  /// When non-null, the user is replying to a specific reply (nested).
  String? _replyingToId;
  String? _replyingToName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Thread. View replies.');
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocus.dispose();
    super.dispose();
  }

  void _sendReply(BuildContext context) {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    context.read<PostThreadCubit>().addReply(
          postId: widget.postId,
          body: text,
          parentReplyId: _replyingToId,
        );
    _replyController.clear();
    _replyFocus.unfocus();
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });
  }

  void _startReplyingTo(String replyId, String? replyAuthor) {
    setState(() {
      _replyingToId = replyId;
      _replyingToName = replyAuthor ?? 'reply';
    });
    _replyFocus.requestFocus();
    announce(context,
        'Replying to ${_replyingToName ?? "reply"}. Type your message.');
  }

  void _clearReplyTarget() {
    setState(() {
      _replyingToId = null;
      _replyingToName = null;
    });
    _replyFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    return BlocListener<PostThreadCubit, PostThreadState>(
      listener: (context, state) {
        if (state is PostThreadLoaded) {
          if (_replyController.text.isEmpty) {
            announce(context, 'Reply posted.');
          }
        } else if (state is PostThreadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: _ThreadAppBar(
          cs: cs,
          blueTint: blueTint,
          onShare: () {
            final state = context.read<PostThreadCubit>().state;
            final post = switch (state) {
              PostThreadLoaded(:final post) => post,
              PostThreadLoading(:final seedPost) => seedPost,
              _ => null,
            };
            if (post != null) sharePost(post);
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<PostThreadCubit, PostThreadState>(
                  builder: (context, state) {
                    // ── Loading (with optional seed post) ─────────────────
                    if (state is PostThreadLoading) {
                      return CustomScrollView(
                        slivers: [
                          if (state.seedPost != null)
                            SliverToBoxAdapter(
                              child: _OriginalPostBlock(
                                post: state.seedPost!,
                                cs: cs,
                                ext: ext,
                                isLoading: true,
                                onLike: () {},
                                onReply: () {},
                                onSave: () {},
                              ),
                            ),
                          SliverFillRemaining(
                            child: Center(
                              child: Semantics(
                                label: 'Loading replies',
                                child: const CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    // ── Error ──────────────────────────────────────────────
                    if (state is PostThreadError) {
                      return Center(
                        child: _ThreadError(
                          message: state.message,
                          onRetry: () => context
                              .read<PostThreadCubit>()
                              .load(widget.postId),
                        ),
                      );
                    }

                    // ── Loaded ─────────────────────────────────────────────
                    if (state is PostThreadLoaded) {
                      return _ThreadBody(
                        post: state.post,
                        topLevel: state.topLevel,
                        nested: state.nested,
                        cs: cs,
                        ext: ext,
                        postId: widget.postId,
                        onStartReplyTo: _startReplyingTo,
                        onMarkBestAnswer: (replyId) {
                          context.read<PostThreadCubit>().markBestAnswer(
                                replyId: replyId,
                                postId: widget.postId,
                              );
                          announce(context, 'Marked as best answer.');
                        },
                        onLikePost: () => context
                            .read<PostThreadCubit>()
                            .toggleLike(widget.postId),
                        onSaveTapped: () => context
                            .read<PostThreadCubit>()
                            .toggleBookmark(widget.postId),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // ── Divider ──────────────────────────────────────────────────
              Divider(height: 1, color: line),

              // ── Composer ─────────────────────────────────────────────────
              _ReplyComposer(
                controller: _replyController,
                focusNode: _replyFocus,
                cs: cs,
                replyingToName: _replyingToName,
                onClearReplyTarget: _clearReplyTarget,
                onSend: () => _sendReply(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// APP BAR
// =============================================================================

class _ThreadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ThreadAppBar({
    required this.cs,
    required this.blueTint,
    required this.onShare,
  });

  final ColorScheme cs;
  final Color blueTint;
  final VoidCallback onShare;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      leading: Semantics(
        button: true,
        label: 'Go back',
        child: IconButton(
          icon: ExcludeSemantics(
            child: Icon(Icons.arrow_back, color: cs.onSurface),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      title: Text(
        'Thread',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      ),
      actions: [
        Semantics(
          button: true,
          label: 'Listen to thread',
          child: IconButton(
            icon: ExcludeSemantics(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: blueTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.volume_up_outlined,
                    size: AppDimensions.iconMd, color: cs.primary),
              ),
            ),
            onPressed: () {
              // TODO(community): read thread aloud via TTS.
            },
          ),
        ),
        Semantics(
          button: true,
          label: 'Share thread',
          child: IconButton(
            icon: ExcludeSemantics(
              child: Icon(Icons.share_outlined, color: cs.onSurface),
            ),
            onPressed: onShare,
          ),
        ),
        Semantics(
          button: true,
          label: 'More options',
          child: IconButton(
            icon: ExcludeSemantics(
              child: Icon(Icons.more_vert, color: cs.onSurface),
            ),
            onPressed: () {
              // TODO(community): report / mute sheet.
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// THREAD BODY — OP + REPLIES
// =============================================================================

class _ThreadBody extends StatelessWidget {
  const _ThreadBody({
    required this.post,
    required this.topLevel,
    required this.nested,
    required this.cs,
    required this.ext,
    required this.postId,
    required this.onStartReplyTo,
    required this.onMarkBestAnswer,
    required this.onLikePost,
    required this.onSaveTapped,
  });

  final PostEntity post;
  final List<PostReplyEntity> topLevel;
  final Map<String, List<PostReplyEntity>> nested;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final String postId;
  final void Function(String replyId, String? replyAuthor) onStartReplyTo;
  final ValueChanged<String> onMarkBestAnswer;
  final VoidCallback onLikePost;
  final VoidCallback onSaveTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final int totalReplies =
        topLevel.length + nested.values.fold(0, (s, l) => s + l.length);

    return CustomScrollView(
      slivers: [
        // ── Original post ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: _OriginalPostBlock(
            post: post,
            cs: cs,
            ext: ext,
            isLoading: false,
            onLike: onLikePost,
            onReply: () => onStartReplyTo('', null),
            onSave: onSaveTapped,
          ),
        ),

        // ── Divider ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 1.5, color: line),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        '$totalReplies repl${totalReplies == 1 ? "y" : "ies"}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                          color: ink3,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ),
                    Text(
                      'Top first',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        // ── Empty replies ─────────────────────────────────────────────────
        if (topLevel.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No replies yet. Start the conversation!',
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: ink2),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        // ── Reply list ───────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.only(
            left: AppDimensions.screenPadding,
            right: AppDimensions.screenPadding,
            bottom: 24,
          ),
          sliver: SliverList.separated(
            itemCount: topLevel.length,
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              final reply = topLevel[i];
              final children = nested[reply.id] ?? [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top-level reply bubble
                  _ReplyBubble(
                    reply: reply,
                    isNested: false,
                    opAuthorId: post.authorId,
                    cs: cs,
                    ext: ext,
                    onReply: () =>
                        onStartReplyTo(reply.id, reply.authorName),
                    onMarkBestAnswer: () =>
                        onMarkBestAnswer(reply.id),
                  ),
                  // Nested children
                  if (children.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...children.map(
                      (child) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _ReplyBubble(
                          reply: child,
                          isNested: true,
                          opAuthorId: post.authorId,
                          cs: cs,
                          ext: ext,
                          onReply: () =>
                              onStartReplyTo(reply.id, child.authorName),
                          onMarkBestAnswer: () =>
                              onMarkBestAnswer(child.id),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ORIGINAL POST BLOCK
// =============================================================================

class _OriginalPostBlock extends StatelessWidget {
  const _OriginalPostBlock({
    required this.post,
    required this.cs,
    required this.ext,
    required this.isLoading,
    required this.onLike,
    required this.onReply,
    required this.onSave,
  });

  final PostEntity post;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final bool isLoading;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onSave;

  static const List<Color> _avatarPalette = [
    Color(0xFF2563D6),
    Color(0xFF1F8A5B),
    Color(0xFF7C3AED),
    Color(0xFFD97706),
    Color(0xFFDB2777),
  ];

  static Color _colorFor(String initial) =>
      _avatarPalette[initial.codeUnitAt(0) % _avatarPalette.length];

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
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final String authorName = post.authorName ?? 'Community Member';
    final String initial = authorName.trim().isNotEmpty
        ? authorName.trim()[0].toUpperCase()
        : 'C';
    final Color avatarColor = _colorFor(initial);
    final String timeLabel = _relativeTime(post.createdAt);

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Author row ────────────────────────────────────────────────
          MergeSemantics(
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (post.authorIsVerified) ...[
                            const SizedBox(width: 5),
                            Icon(Icons.verified,
                                size: 15, color: cs.primary),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (post.topic != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3),
                              decoration: BoxDecoration(
                                color: blueTint,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                post.topic!,
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: ink2,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                            Text('·',
                                style: TextStyle(color: ink3)),
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
                Semantics(
                  button: true,
                  label: 'More options',
                  child: SizedBox(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    child: Center(
                      child: ExcludeSemantics(
                        child: Icon(Icons.more_horiz,
                            color: ink2, size: AppDimensions.iconLg),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Title ────────────────────────────────────────────────────
          if (post.title != null && post.title!.isNotEmpty) ...[
            Text(
              post.title!,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // ── Body ─────────────────────────────────────────────────────
          Text(
            post.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: ink2,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),

          // ── Voice note ────────────────────────────────────────────────
          if (post.voiceUrl != null) ...[
            const SizedBox(height: 14),
            VoiceNotePlayer(
              durationLabel: '0:00',
              voiceUrl: post.voiceUrl,
            ),
          ],

          const SizedBox(height: 14),

          // ── Footer stats ──────────────────────────────────────────────
          if (!isLoading)
            Builder(
              builder: (context) {
                final isLargeText = MediaQuery.textScalerOf(context).scale(1.0) > 1.5;
                final likeButton = Semantics(
                  button: true,
                  label: post.likedByMe
                      ? 'Unlike. ${post.likeCount} likes.'
                      : 'Like. ${post.likeCount} likes.',
                  child: GestureDetector(
                    onTap: onLike,
                    child: _OpStatPill(
                      icon: post.likedByMe
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: '${post.likeCount}',
                      active: post.likedByMe,
                      activeColor: cs.error,
                      line: line,
                      ink2: ink2,
                      cs: cs,
                    ),
                  ),
                );
                final replyButton = Semantics(
                  button: true,
                  label: 'Reply to post.',
                  child: GestureDetector(
                    onTap: onReply,
                    child: _OpStatPill(
                      icon: Icons.forum_outlined,
                      label: '${post.replyCount}',
                      active: false,
                      activeColor: cs.primary,
                      line: line,
                      ink2: ink2,
                      cs: cs,
                    ),
                  ),
                );
                final saveButton = Semantics(
                  button: true,
                  label:
                      post.bookmarkedByMe ? 'Remove from saved' : 'Save post',
                  child: GestureDetector(
                    onTap: onSave,
                    child: _OpStatPill(
                      icon: post.bookmarkedByMe
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      label: '',
                      active: post.bookmarkedByMe,
                      activeColor: cs.primary,
                      line: line,
                      ink2: ink2,
                      cs: cs,
                    ),
                  ),
                );
                final reportButton = Semantics(
                  button: true,
                  label: 'Report post',
                  child: GestureDetector(
                    onTap: () {
                      // TODO(community): report post.
                    },
                    child: _OpStatPill(
                      icon: Icons.flag_outlined,
                      label: '',
                      active: false,
                      activeColor: cs.error,
                      line: line,
                      ink2: ink2,
                      cs: cs,
                    ),
                  ),
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
                    reportButton,
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
            ),
        ],
      ),
    );
  }
}

class _OpStatPill extends StatelessWidget {
  const _OpStatPill({
    required this.icon,
    required this.label,
    required this.active,
    required this.activeColor,
    required this.line,
    required this.ink2,
    required this.cs,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color activeColor;
  final Color line;
  final Color ink2;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
      decoration: BoxDecoration(
        color: active ? activeColor.withValues(alpha: 0.10) : cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? activeColor.withValues(alpha: 0.35) : line,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: AppDimensions.iconMd,
              color: active ? activeColor : ink2),
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
    );
  }
}

// =============================================================================
// REPLY BUBBLE
// =============================================================================

class _ReplyBubble extends StatelessWidget {
  const _ReplyBubble({
    required this.reply,
    required this.isNested,
    required this.opAuthorId,
    required this.cs,
    required this.ext,
    required this.onReply,
    required this.onMarkBestAnswer,
  });

  final PostReplyEntity reply;
  final bool isNested;
  final String opAuthorId;
  final ColorScheme cs;
  final AppExtendedCustomColors? ext;
  final VoidCallback onReply;
  final VoidCallback onMarkBestAnswer;

  static const List<Color> _avatarPalette = [
    Color(0xFF2563D6),
    Color(0xFF1F8A5B),
    Color(0xFF7C3AED),
    Color(0xFFD97706),
    Color(0xFFDB2777),
  ];

  static Color _colorFor(String initial) =>
      _avatarPalette[initial.codeUnitAt(0) % _avatarPalette.length];

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
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color tint = ext?.blueTint ?? cs.primaryContainer;
    final Color green = ext?.green ?? Colors.green;
    final Color greenTint = ext?.greenTint ?? Colors.green.withValues(alpha: 0.15);

    final String authorName = reply.authorName ?? 'Community Member';
    final String initial = authorName.trim().isNotEmpty
        ? authorName.trim()[0].toUpperCase()
        : 'C';
    final Color avatarColor = _colorFor(initial);
    final String timeLabel = _relativeTime(reply.createdAt);

    final String semanticLabel =
        '${reply.isBestAnswer ? "Best answer. " : ""}'
        '$authorName${reply.authorIsVerified ? ", verified" : ""}. '
        '${reply.body}. $timeLabel. ${reply.likeCount} likes.';

    return Padding(
      padding: isNested ? const EdgeInsets.only(left: 30) : EdgeInsets.zero,
      child: Semantics(
        container: true,
        label: semanticLabel,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            ExcludeSemantics(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Bubble + actions
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bubble card with asymmetric radius (co-reply-card)
                  Container(
                    decoration: BoxDecoration(
                      color: tint,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      border: Border.all(color: line, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name row
                        ExcludeSemantics(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                authorName,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                              ),
                              if (reply.authorIsVerified)
                                Icon(Icons.verified,
                                    size: 14, color: cs.primary),
                              if (reply.isBestAnswer)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: greenTint,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle_outline,
                                          size: 12, color: green),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Best answer',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                          color: green,
                                          fontSize: 10.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Reply body
                        Text(
                          reply.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ink2,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Voice note (if any)
                        if (reply.voiceUrl != null) ...[
                          const SizedBox(height: 10),
                          ExcludeSemantics(
                            excluding: false,
                            child: VoiceNotePlayer(
                              durationLabel: '0:00',
                              voiceUrl: reply.voiceUrl,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ── Reply actions row ──────────────────────────────────
                  ExcludeSemantics(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 9, left: 4),
                      child: Builder(
                        builder: (context) {
                          final isLargeText = MediaQuery.textScalerOf(context).scale(1.0) > 1.5;
                          final likeAction = _ReplyAction(
                            icon: Icons.favorite_border,
                            label: '${reply.likeCount}',
                            color: ink3,
                            onTap: () {
                              // TODO(community): reply like — no backend yet.
                            },
                          );
                          final replyAction = _ReplyAction(
                            icon: Icons.reply_outlined,
                            label: 'Reply',
                            color: ink3,
                            onTap: onReply,
                          );
                          final timeText = Text(
                            timeLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ink3,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                          final bestAnswerBtn = !reply.isBestAnswer
                              ? Semantics(
                                  button: true,
                                  label: 'Mark this reply as best answer',
                                  child: GestureDetector(
                                    onTap: onMarkBestAnswer,
                                    child: ExcludeSemantics(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              size: 14, color: green),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Best answer',
                                            style: theme.textTheme.labelSmall?.copyWith(
                                              color: green,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();

                          final leftGroup = Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              likeAction,
                              replyAction,
                              timeText,
                            ],
                          );

                          return SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                leftGroup,
                                if (!reply.isBestAnswer) bestAnswerBtn,
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _InvisibleReplyActions(
                    reply: reply,
                    onReply: onReply,
                    onMarkBestAnswer: onMarkBestAnswer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplyAction extends StatelessWidget {
  const _ReplyAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconMd, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// REPLY COMPOSER
// =============================================================================

class _ReplyComposer extends StatelessWidget {
  const _ReplyComposer({
    required this.controller,
    required this.focusNode,
    required this.cs,
    required this.replyingToName,
    required this.onClearReplyTarget,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ColorScheme cs;
  final String? replyingToName;
  final VoidCallback onClearReplyTarget;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color tint = ext?.blueTint ?? cs.primaryContainer;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Container(
      color: cs.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply-to banner
          if (replyingToName != null)
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: tint,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $replyingToName',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Cancel reply',
                    child: GestureDetector(
                      onTap: onClearReplyTarget,
                      child: ExcludeSemantics(
                        child: Icon(Icons.close,
                            size: AppDimensions.iconMd, color: cs.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingMin,
              vertical: AppDimensions.space8,
            ),
            child: Row(
              children: [
                // Mic button (voice stub)
                Semantics(
                  button: true,
                  label: 'Hold to speak reply',
                  child: GestureDetector(
                    onLongPress: () {
                      // TODO(community): record voice reply.
                    },
                    child: ExcludeSemantics(
                      child: Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mic_none_rounded,
                            size: AppDimensions.iconMd, color: Colors.white),
                      ),
                    ),
                  ),
                ),

                // Text field
                Expanded(
                  child: Semantics(
                    label: replyingToName != null
                        ? 'Reply to $replyingToName'
                        : 'Add a reply',
                    textField: true,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(
                        color: tint,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: line, width: 1.5),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Add a reply or hold to speak…',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: ink3,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: theme.textTheme.bodyMedium,
                        onSubmitted: (_) => onSend(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Send button
                Semantics(
                  button: true,
                  label: 'Send reply',
                  child: GestureDetector(
                    onTap: onSend,
                    child: ExcludeSemantics(
                      child: Container(
                        width: AppDimensions.minTapTarget,
                        height: AppDimensions.minTapTarget,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          size: AppDimensions.iconMd,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ERROR STATE
// =============================================================================

class _ThreadError extends StatelessWidget {
  const _ThreadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
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
            label: 'Retry loading replies',
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

class _InvisibleReplyActions extends StatelessWidget {
  const _InvisibleReplyActions({
    required this.reply,
    required this.onReply,
    required this.onMarkBestAnswer,
  });

  final PostReplyEntity reply;
  final VoidCallback onReply;
  final VoidCallback onMarkBestAnswer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0,
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Like reply by ${reply.authorName ?? "member"}. ${reply.likeCount} likes',
            child: GestureDetector(
              onTap: () {
                // TODO(community): reply like — no backend yet.
              },
              child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: 'Reply to ${reply.authorName ?? "reply"}',
            child: GestureDetector(
              onTap: onReply,
              child: const SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
              ),
            ),
          ),
          if (!reply.isBestAnswer)
            Semantics(
              button: true,
              label: 'Mark reply by ${reply.authorName ?? "reply"} as best answer',
              child: GestureDetector(
                onTap: onMarkBestAnswer,
                child: const SizedBox(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
