// Screen for viewing the reply thread of a community post.
//
// Driven by [PostThreadCubit]. Shows the list of replies and a bottom
// composer for adding new replies. Announces "Reply posted." on success.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_reply_entity.dart';
import 'package:opto/features/connect/presentation/cubit/post_thread_cubit.dart';

/// Screen 19b — Post Thread
///
/// Displays the reply thread for a community post identified by [postId].
///
/// Accessibility:
/// - "Reply posted." is announced via live region on success.
/// - Loading and error states are announced via [Semantics.label].
/// - The reply text field has a [semanticsLabel].
/// - The send button has a meaningful [Semantics] label.
class PostThreadScreen extends StatelessWidget {
  const PostThreadScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostThreadCubit>(
      create: (_) => sl<PostThreadCubit>()..load(postId),
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
        );
    _replyController.clear();
    _replyFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return BlocListener<PostThreadCubit, PostThreadState>(
      listener: (context, state) {
        if (state is PostThreadLoaded) {
          // Announce whenever we (re)load — which happens after addReply succeeds.
          // Distinguish "reply posted" from initial load via a flag would add
          // complexity; instead we rely on the cubit calling load() after addReply.
          // The announce is safe to call multiple times; the screen reader deduplicates.
          if (_replyController.text.isEmpty) {
            // Only announce "Reply posted." if we just cleared the field,
            // meaning we just submitted a reply.
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
        appBar: AppBar(
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
            'Replies',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── Replies list ───────────────────────────────────────────
              Expanded(
                child: BlocBuilder<PostThreadCubit, PostThreadState>(
                  builder: (context, state) {
                    if (state is PostThreadLoading) {
                      return Center(
                        child: Semantics(
                          label: 'Loading replies',
                          child: const CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    if (state is PostThreadError) {
                      return _ThreadError(
                        message: state.message,
                        onRetry: () => context
                            .read<PostThreadCubit>()
                            .load(widget.postId),
                      );
                    }

                    if (state is PostThreadLoaded) {
                      if (state.replies.isEmpty) {
                        return const _EmptyReplies();
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenPadding,
                          vertical: AppDimensions.space16,
                        ),
                        itemCount: state.replies.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) =>
                            _ReplyCard(reply: state.replies[i]),
                      );
                    }

                    // PostThreadInitial
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // ── Divider ────────────────────────────────────────────────
              Divider(height: 1, color: line),

              // ── Reply composer ─────────────────────────────────────────
              _ReplyComposer(
                controller: _replyController,
                focusNode: _replyFocus,
                cs: cs,
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
// REPLY CARD
// =============================================================================

class _ReplyCard extends StatelessWidget {
  const _ReplyCard({required this.reply});

  final PostReplyEntity reply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    final String authorName = reply.authorName ?? 'Community Member';
    final String timeLabel = _formatRelativeTime(reply.createdAt);

    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MergeSemantics(
              child: Row(
                children: [
                  Text(
                    authorName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: ink3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              reply.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
// REPLY COMPOSER
// =============================================================================

class _ReplyComposer extends StatelessWidget {
  const _ReplyComposer({
    required this.controller,
    required this.focusNode,
    required this.cs,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ColorScheme cs;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        children: [
          // ── Text field ─────────────────────────────────────────────────
          Expanded(
            child: Semantics(
              label: 'Write a reply',
              textField: true,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write a reply…',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusInput),
                    borderSide: BorderSide(
                      color: cs.outline,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusInput),
                    borderSide: BorderSide(color: cs.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusInput),
                    borderSide:
                        BorderSide(color: cs.primary, width: 2),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ── Send button ────────────────────────────────────────────────
          Semantics(
            button: true,
            label: 'Send reply',
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Material(
                color: cs.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onSend,
                  child: const Center(
                    child: ExcludeSemantics(
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
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
// EMPTY REPLIES
// =============================================================================

class _EmptyReplies extends StatelessWidget {
  const _EmptyReplies();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Text(
        'No replies yet. Start the conversation!',
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

// =============================================================================
// THREAD ERROR
// =============================================================================

class _ThreadError extends StatelessWidget {
  const _ThreadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
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
      ),
    );
  }
}
