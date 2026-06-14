import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/domain/entities/post_entity.dart';
import 'package:opto/features/connect/presentation/cubit/member_profile_cubit.dart';
import 'package:opto/features/connect/presentation/widgets/community_avatar.dart';
import 'package:opto/features/connect/presentation/widgets/member_stats_row.dart';
import 'package:opto/features/connect/presentation/widgets/profile_badge.dart';

/// Screen K7 — Member Profile.
///
/// Shows a community member's public profile:
///  • 96 dp avatar + name, verified badge, @handle, joined year.
///  • Follow / Message buttons.
///  • Posts / Helpful / Circles stats.
///  • Bio paragraph.
///  • "Recent contributions" compact thread list.
class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberProfileCubit>(
      create: (_) => sl<MemberProfileCubit>()..load(memberId),
      child: _MemberProfileView(memberId: memberId),
    );
  }
}

// =============================================================================
// INNER VIEW
// =============================================================================

class _MemberProfileView extends StatefulWidget {
  const _MemberProfileView({required this.memberId});

  final String memberId;

  @override
  State<_MemberProfileView> createState() => _MemberProfileViewState();
}

class _MemberProfileViewState extends State<_MemberProfileView> {
  bool _announced = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return BlocListener<MemberProfileCubit, MemberProfileState>(
      listener: (context, state) {
        if (state is MemberProfileLoaded && !_announced) {
          _announced = true;
          final profile = state.profile;
          announce(
            context,
            '${profile.name}\'s profile. '
            '${profile.isMentor ? "Community mentor. " : ""}'
            '${profile.postsCount} posts, '
            '${profile.helpfulCount} helpful votes, '
            '${profile.circlesCount} circles.',
          );
        }
        if (state is MemberProfileError) {
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
        body: BlocBuilder<MemberProfileCubit, MemberProfileState>(
          builder: (context, state) {
            if (state is MemberProfileLoading ||
                state is MemberProfileInitial) {
              return _ProfileLoadingView(cs: cs);
            }

            if (state is MemberProfileError) {
              return _ProfileErrorView(
                message: state.message,
                onRetry: () => context
                    .read<MemberProfileCubit>()
                    .load(widget.memberId),
              );
            }

            if (state is MemberProfileLoaded) {
              final profile = state.profile;

              return RefreshIndicator(
                onRefresh: () async =>
                    context.read<MemberProfileCubit>().load(widget.memberId),
                child: CustomScrollView(
                  slivers: [
                    // ── App bar ──────────────────────────────────────────
                    SliverAppBar(
                      pinned: true,
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
                              child: Icon(Icons.arrow_back,
                                  size: 22, color: cs.onSurface),
                            ),
                          ),
                        ),
                      ),
                      title: ExcludeSemantics(
                        child: Text(
                          profile.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      actions: [
                        // Share / overflow — stub
                        Semantics(
                          button: true,
                          label: 'More options',
                          child: GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              width: AppDimensions.minTapTarget,
                              height: AppDimensions.minTapTarget,
                              child: Center(
                                child: ExcludeSemantics(
                                  child: Icon(Icons.more_vert,
                                      size: 22, color: cs.onSurface),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          // ─ Header ──────────────────────────────────────
                          _ProfileHeader(
                            profile: profile,
                            ext: ext,
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: 20),

                          // ─ Badges ──────────────────────────────────────
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (profile.isMentor)
                                const ProfileBadge(
                                  label: 'Mentor',
                                  icon: Icons.school_outlined,
                                  variant: ProfileBadgeVariant.amber,
                                ),
                              if (profile.isVerified)
                                const ProfileBadge(
                                  label: 'Verified member',
                                  icon: Icons.verified_outlined,
                                  variant: ProfileBadgeVariant.blue,
                                ),
                              if (profile.joinedYear != null)
                                ProfileBadge(
                                  label:
                                      'Since ${profile.joinedYear}',
                                  icon: Icons.calendar_month_outlined,
                                  variant: ProfileBadgeVariant.green,
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ─ Follow + Message row ───────────────────────
                          _ActionRow(
                            isFollowing: profile.isFollowedByMe,
                            onFollow: () => context
                                .read<MemberProfileCubit>()
                                .toggleFollow(),
                            onMessage: () {
                              // TODO(community): open DM screen
                            },
                            cs: cs,
                            theme: theme,
                          ),
                          const SizedBox(height: 24),

                          // ─ Stats ──────────────────────────────────────
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: ext?.line ?? cs.outline, width: 1),
                                bottom: BorderSide(
                                    color: ext?.line ?? cs.outline, width: 1),
                              ),
                            ),
                            child: MemberStatsRow(
                              postsCount: profile.postsCount,
                              helpfulCount: profile.helpfulCount,
                              circlesCount: profile.circlesCount,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ─ Bio ────────────────────────────────────────
                          if (profile.bio != null) ...[
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
                            Text(
                              profile.bio!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface,
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // ─ Contributions ──────────────────────────────
                          Text(
                            'RECENT CONTRIBUTIONS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: ext?.ink3 ?? cs.onSurfaceVariant,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (state.contributions.isEmpty)
                            _NoContributionsView(ext: ext, cs: cs, theme: theme)
                          else
                            ...state.contributions.map(
                              (post) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ContributionCard(
                                  post: post,
                                  ext: ext,
                                  cs: cs,
                                  theme: theme,
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

  void _openThread(BuildContext context, PostEntity post) {
    context.push('/community/thread/${post.id}', extra: post);
  }
}

// =============================================================================
// PROFILE HEADER
// =============================================================================

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.ext,
    required this.cs,
    required this.theme,
  });

  final dynamic profile; // MemberProfileEntity
  final AppExtendedCustomColors? ext;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large avatar
        Semantics(
          label: '${profile.name}, profile picture',
          child: CommunityAvatar(
            name: profile.name,
            authorId: profile.id,
            avatarUrl: profile.avatarUrl,
            size: 96,
            fontSize: 34,
          ),
        ),
        const SizedBox(width: 16),

        // Name + handle + joined
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      profile.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                        letterSpacing: -0.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 6),
                    ExcludeSemantics(
                      child: Icon(Icons.verified,
                          size: 18, color: cs.primary),
                    ),
                  ],
                ],
              ),
              if (profile.handle != null) ...[
                const SizedBox(height: 2),
                Text(
                  '@${profile.handle}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ext?.ink3 ?? cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ACTION ROW (FOLLOW + MESSAGE)
// =============================================================================

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.isFollowing,
    required this.onFollow,
    required this.onMessage,
    required this.cs,
    required this.theme,
  });

  final bool isFollowing;
  final VoidCallback onFollow;
  final VoidCallback onMessage;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Follow button
        Expanded(
          child: Semantics(
            button: true,
            label: isFollowing ? 'Unfollow this member' : 'Follow this member',
            child: GestureDetector(
              onTap: onFollow,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                height: AppDimensions.buttonHeight,
                decoration: BoxDecoration(
                  color: isFollowing ? cs.surfaceContainerHighest : cs.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFollowing
                              ? Icons.person_remove_outlined
                              : Icons.person_add_outlined,
                          size: 18,
                          color: isFollowing ? cs.onSurface : Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isFollowing ? 'Following' : 'Follow',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: isFollowing ? cs.onSurface : Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Message button
        Expanded(
          child: Semantics(
            button: true,
            label: 'Send a message',
            child: GestureDetector(
              onTap: onMessage,
              child: Container(
                height: AppDimensions.buttonHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: cs.outline,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail_outline,
                            size: 18, color: cs.onSurface),
                        const SizedBox(width: 6),
                        Text(
                          'Message',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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
// CONTRIBUTION CARD (compact thread card)
// =============================================================================

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({
    required this.post,
    required this.ext,
    required this.cs,
    required this.theme,
    required this.onTap,
  });

  final PostEntity post;
  final AppExtendedCustomColors? ext;
  final ColorScheme cs;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${post.authorName}: ${post.body}. '
          '${post.likeCount} helpful votes. '
          '${post.replyCount} replies.',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: ext?.line ?? cs.outline.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topic chip
              if (post.topic != null)
                ExcludeSemantics(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: ext?.blueTint ??
                          cs.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      post.topic!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),

              // Content
              Text(
                post.body,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 10),

              // Footer: likes + replies
              ExcludeSemantics(
                child: Row(
                  children: [
                    Icon(Icons.favorite_border,
                        size: 14,
                        color: ext?.ink3 ?? cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likeCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext?.ink3 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Icon(Icons.chat_bubble_outline,
                        size: 14,
                        color: ext?.ink3 ?? cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${post.replyCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext?.ink3 ?? cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

// =============================================================================
// EMPTY / LOADING / ERROR STATES
// =============================================================================

class _NoContributionsView extends StatelessWidget {
  const _NoContributionsView(
      {required this.ext, required this.cs, required this.theme});

  final AppExtendedCustomColors? ext;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note_outlined,
              size: 36, color: ext?.ink3 ?? cs.onSurfaceVariant),
          const SizedBox(height: 10),
          Text(
            'No contributions yet',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ProfileLoadingView extends StatelessWidget {
  const _ProfileLoadingView({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(backgroundColor: cs.surface, elevation: 0),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView(
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
              Icon(Icons.person_off_outlined,
                  size: 48, color: ext?.ink3 ?? cs.onSurfaceVariant),
              const SizedBox(height: 16),
              Text(
                'Could not load profile',
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
                label: 'Retry loading profile',
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
