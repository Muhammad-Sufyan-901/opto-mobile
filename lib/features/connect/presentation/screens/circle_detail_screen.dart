import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/cubit/circle_detail_cubit.dart';
import 'package:opto/features/connect/presentation/widgets/circle_cover.dart';
import 'package:opto/features/connect/presentation/widgets/community_thread_card.dart';
import 'package:opto/features/connect/presentation/widgets/pinned_note.dart';

/// Screen K5 — Circle Detail.
///
/// Shows a circle's cover, join/notify actions, about text, pinned note,
/// and a list of recent threads filtered to this circle's topic.
class CircleDetailScreen extends StatelessWidget {
  const CircleDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CircleDetailCubit>(
      create: (_) => sl<CircleDetailCubit>()..load(slug),
      child: _CircleDetailView(slug: slug),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _CircleDetailView extends StatefulWidget {
  const _CircleDetailView({required this.slug});

  final String slug;

  @override
  State<_CircleDetailView> createState() => _CircleDetailViewState();
}

class _CircleDetailViewState extends State<_CircleDetailView> {
  bool _announced = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return BlocListener<CircleDetailCubit, CircleDetailState>(
      listener: (context, state) {
        if (state is CircleDetailLoaded && !_announced) {
          _announced = true;
          final circle = state.circle;
          announce(
            context,
            '${circle.name} circle. '
            '${circle.memberCount} members. '
            '${circle.isMember ? "You are a member." : "Not a member."}',
          );
        }
        if (state is CircleDetailError) {
          _announced = false;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        body: BlocBuilder<CircleDetailCubit, CircleDetailState>(
          builder: (context, state) {
            if (state is CircleDetailLoading ||
                state is CircleDetailInitial) {
              return const _CircleLoadingView();
            }

            if (state is CircleDetailError) {
              return _CircleErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<CircleDetailCubit>().load(widget.slug),
              );
            }

            if (state is CircleDetailLoaded) {
              final circle = state.circle;
              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<CircleDetailCubit>().load(widget.slug),
                child: CustomScrollView(
                  slivers: [
                    // ── Cover / App bar ──────────────────────────────────
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      backgroundColor: cs.surface,
                      leading: Semantics(
                        button: true,
                        label: 'Back',
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                            child: ExcludeSemantics(
                              child: const Icon(Icons.arrow_back,
                                  size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.pin,
                        background: CircleCover(circle: circle),
                      ),
                    ),

                    // ── Body ─────────────────────────────────────────────
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.screenPadding,
                        20,
                        AppDimensions.screenPadding,
                        80,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Name + member count
                          Semantics(
                            header: true,
                            child: Text(
                              circle.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onSurface,
                                letterSpacing: -0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _memberLabel(circle.memberCount),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ext?.ink3 ?? cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description
                          if (circle.description != null) ...[
                            Text(
                              circle.description!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ext?.ink2 ?? cs.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Join + Notify row
                          Row(
                            children: [
                              Expanded(
                                child: _JoinButton(
                                  isMember: circle.isMember,
                                  onTap: () => context
                                      .read<CircleDetailCubit>()
                                      .toggleJoin(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Semantics(
                                button: true,
                                label: circle.isNotifying
                                    ? 'Turn off notifications for this circle'
                                    : 'Turn on notifications for this circle',
                                child: GestureDetector(
                                  // TODO(circles): wire up notification toggle
                                  onTap: () {},
                                  child: Container(
                                    width: AppDimensions.buttonHeight,
                                    height: AppDimensions.buttonHeight,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ext?.line ?? cs.outline,
                                        width: 1.5,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                    ),
                                    child: Center(
                                      child: ExcludeSemantics(
                                        child: Icon(
                                          circle.isNotifying
                                              ? Icons.notifications_active
                                              : Icons
                                                  .notifications_none_outlined,
                                          size: 22,
                                          color: circle.isNotifying
                                              ? cs.primary
                                              : cs.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Pinned note
                          if (circle.pinnedNote != null) ...[
                            PinnedNote(note: circle.pinnedNote!),
                            const SizedBox(height: 20),
                          ],

                          // About
                          if (circle.about != null) ...[
                            Text(
                              'ABOUT',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: ext?.ink3 ?? cs.onSurfaceVariant,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ext?.blueTint ??
                                    cs.primaryContainer
                                        .withValues(alpha: 0.35),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                circle.about!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface,
                                  height: 1.55,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Recent threads
                          Row(
                            children: [
                              Text(
                                'RECENT THREADS',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: ext?.ink3 ?? cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.4,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Semantics(
                                button: true,
                                label: 'Post to this circle',
                                child: GestureDetector(
                                  onTap: () => context.push(
                                    '/community/compose',
                                  ),
                                  child: ExcludeSemantics(
                                    child: Text(
                                      'Post',
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        color: cs.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (state.recentThreads.isEmpty)
                            _NoThreadsPrompt(circleName: circle.name)
                          else
                            ...state.recentThreads.map(
                              (post) => Padding(
                                padding: const EdgeInsets.only(bottom: 13),
                                child: CommunityThreadCard(
                                  post: post,
                                  onLike: () {},
                                  onReply: () => _openThread(context, post),
                                  onReport: () {},
                                  onSave: () {},
                                  onTap: () => _openThread(context, post),
                                ),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _memberLabel(int count) {
    if (count == 0) return 'No members yet';
    if (count == 1) return '1 member';
    if (count >= 1000) {
      final k = (count / 1000).toStringAsFixed(1);
      return '${k}k members';
    }
    return '$count members';
  }

  void _openThread(BuildContext context, PostEntity post) {
    context.push('/community/thread/${post.id}', extra: post);
  }
}

// =============================================================================
// JOIN BUTTON
// =============================================================================

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.isMember, required this.onTap});

  final bool isMember;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      button: true,
      label: isMember ? 'Leave circle' : 'Join circle',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            color: isMember ? cs.surfaceContainerHighest : cs.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: ExcludeSemantics(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isMember ? Icons.check_rounded : Icons.add,
                    size: 18,
                    color: isMember ? cs.onSurface : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMember ? 'Member' : 'Join Circle',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isMember ? cs.onSurface : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _NoThreadsPrompt extends StatelessWidget {
  const _NoThreadsPrompt({required this.circleName});

  final String circleName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: ext?.blueTint?.withValues(alpha: 0.5) ??
            cs.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 36, color: ext?.ink3 ?? cs.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(
            'No threads in $circleName yet',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Be the first to start a conversation.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: ext?.ink3 ?? cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// LOADING / ERROR STATES
// =============================================================================

class _CircleLoadingView extends StatelessWidget {
  const _CircleLoadingView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(backgroundColor: cs.surface, elevation: 0),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _CircleErrorView extends StatelessWidget {
  const _CircleErrorView(
      {required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(backgroundColor: cs.surface, elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off_outlined,
                  size: 48, color: ext?.ink3 ?? cs.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                'Could not load circle',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Semantics(
                button: true,
                label: 'Retry',
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
                      child: ExcludeSemantics(
                        child: Text(
                          'Retry',
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
