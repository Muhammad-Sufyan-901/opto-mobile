import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/connect/presentation/widgets/community_avatar.dart';
import 'package:opto/features/connect/presentation/widgets/profile_badge.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';
import 'package:opto/features/profile/presentation/widgets/profile_glance_card.dart';
import 'package:opto/features/profile/presentation/widgets/profile_home_skeleton.dart';
import 'package:opto/features/profile/presentation/widgets/profile_listen_button.dart';
import 'package:opto/features/profile/presentation/widgets/profile_nav_row.dart';
import 'package:opto/features/profile/presentation/widgets/profile_stats_row.dart';

/// Screen P1 — Profile Home.
///
/// Redesigned to match the "Android User Profile" design mock. Provides
/// [ProfileBloc], [AccessibilitySettingsCubit], and [AuthBloc] via
/// [MultiBlocProvider].
///
/// Layout:
///   1. App bar (Profile title · listen button · QR action)
///   2. Identity header — avatar, name + verified, handle, 3 badges
///   3. "Listen to profile summary" pill
///   4. Primary actions — "Edit profile" (→ P2) + share icon button
///   5. Stats strip (Posts / Helpful / Circles)
///   6. Vision profile at-a-glance card (→ P3)
///   7. "Manage your account" nav rows (→ P3, P4, P6, P5, help stub)
///   8. Sign-out danger row
///   9. Bottom nav (tab 4)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<AccessibilitySettingsCubit>.value(
          value: sl<AccessibilitySettingsCubit>(),
        ),
        BlocProvider<AuthBloc>.value(value: sl<AuthBloc>()),
      ],
      child: const _ProfileBody(),
    );
  }
}

// =============================================================================
// INNER BODY
// =============================================================================

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(ProfileEvent.loadProfile(userId: userId));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Profile.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        state.mapOrNull(
          unauthenticated: (_) => ctx.go(AppRoutes.login.path),
        );
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (ctx, profileState) {
          // Show skeleton while loading
          if (profileState is ProfileLoading ||
              profileState is ProfileInitial) {
            return const ProfileHomeSkeleton();
          }

          return _ProfileContent(profileState: profileState);
        },
      ),
    );
  }
}

// =============================================================================
// CONTENT (loaded + error states)
// =============================================================================

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profileState});

  final ProfileState profileState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    // Resolve real vs placeholder profile data
    final ProfileEntity? profile = profileState is ProfileLoaded
        ? (profileState as ProfileLoaded).profile
        : null;
    final String displayName = profile?.fullName ?? 'Rani Putri';
    final String handle = '@raniputri · Bandung · joined ${profile?.createdAt.year ?? 2022}';
    final String visionLabel = _visionLabel(profile?.visionProfile);

    // Profile summary for TTS
    final String summary =
        '$displayName. $visionLabel. 142 posts, 1.8k helpful votes, '
        '6 circles. Joined ${profile?.createdAt.year ?? 2022}.';

    return Scaffold(
      backgroundColor: cs.surface,
      bottomNavigationBar: const HomeBottomNav(activeTab: 4),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App bar ─────────────────────────────────────────────
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: cs.surface,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              pinned: false,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // No back button on a root tab
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Profile',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    // Volume/listen tonal button
                    Semantics(
                      button: true,
                      label: 'Listen to profile',
                      child: GestureDetector(
                        onTap: () => HapticPatterns.focusTick(),
                        child: Container(
                          width: AppDimensions.minTapTarget,
                          height: AppDimensions.minTapTarget,
                          decoration: BoxDecoration(
                            color: ext?.blueTint ?? cs.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ExcludeSemantics(
                              child: Icon(
                                Icons.volume_up_outlined,
                                size: 24,
                                color: cs.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // QR code button
                    Semantics(
                      button: true,
                      label: 'Show QR code',
                      child: GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: AppDimensions.minTapTarget,
                          height: AppDimensions.minTapTarget,
                          child: Center(
                            child: ExcludeSemantics(
                              child: Icon(
                                Icons.qr_code_2,
                                size: 24,
                                color: cs.onSurface,
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

            // ── Body ────────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Error banner (if any)
                  if (profileState is ProfileError)
                    Semantics(
                      liveRegion: true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          (profileState as ProfileError).message,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.error),
                        ),
                      ),
                    ),

                  // ── Identity header ─────────────────────────────────
                  Semantics(
                    header: true,
                    label: '$displayName profile. $handle.',
                    child: Column(
                      children: [
                        ExcludeSemantics(
                          child: CommunityAvatar(
                            name: displayName,
                            authorId: profile?.id ?? 'raniputri',
                            avatarUrl: profile?.avatarUrl,
                            size: 96,
                            fontSize: 34,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ExcludeSemantics(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                displayName,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                  letterSpacing: -0.5,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Icon(Icons.verified,
                                  size: 20, color: cs.primary),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        ExcludeSemantics(
                          child: Text(
                            handle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink3,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            const ProfileBadge(
                              label: 'Low vision',
                              icon: Icons.visibility_outlined,
                              variant: ProfileBadgeVariant.blue,
                            ),
                            const ProfileBadge(
                              label: 'Peer helper',
                              icon: Icons.school_outlined,
                              variant: ProfileBadgeVariant.green,
                            ),
                            const ProfileBadge(
                              label: "Prosthesis '24",
                              icon: Icons.adjust_outlined,
                              variant: ProfileBadgeVariant.amber,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Listen pill ────────────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileListenButton(summary: summary),
                  ),

                  const SizedBox(height: 14),

                  // ── Primary actions ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Edit profile',
                          child: GestureDetector(
                            onTap: () {
                              HapticPatterns.focusTick();
                              context.push(AppRoutes.profileEdit.path);
                            },
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: cs.primary,
                                borderRadius: BorderRadius.circular(27),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.38),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ExcludeSemantics(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.edit_outlined,
                                          size: 20,
                                          color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Edit profile',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
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
                      Semantics(
                        button: true,
                        label: 'Share profile',
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 60,
                            height: 54,
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(27),
                              border: Border.all(
                                  color: ext?.line ?? cs.outline,
                                  width: 2),
                            ),
                            child: Center(
                              child: ExcludeSemantics(
                                child: Icon(Icons.share_outlined,
                                    size: 20, color: cs.primary),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Stats strip ────────────────────────────────────────
                  const ProfileStatsRow(
                    stats: [
                      ProfileStat(value: '142', label: 'Posts'),
                      ProfileStat(value: '1.8k', label: 'Helpful'),
                      ProfileStat(value: '6', label: 'Circles'),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Vision profile at a glance ─────────────────────────
                  ProfileGlanceCard(
                    sectionIcon: Icons.shield_outlined,
                    sectionLabel: 'Vision profile',
                    facts: const [
                      ProfileGlanceFact(
                        icon: Icons.visibility_outlined,
                        label: 'Condition',
                        value: 'Low vision · right eye',
                      ),
                      ProfileGlanceFact(
                        icon: Icons.adjust_outlined,
                        label: 'Prosthesis',
                        value: 'Left eye · Mar 2024',
                      ),
                      ProfileGlanceFact(
                        icon: Icons.volume_up_outlined,
                        label: 'Primary access',
                        value: 'TalkBack · 1.5×',
                      ),
                    ],
                    actionLabel: 'Manage',
                    onAction: () => context.push(AppRoutes.visionProfile.path),
                    footerIcon: Icons.lock_outline,
                    footerText: 'Shared only with your linked care team',
                  ),

                  const SizedBox(height: 18),

                  // ── Section label ──────────────────────────────────────
                  ExcludeSemantics(
                    child: Text(
                      'MANAGE YOUR ACCOUNT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: ink3,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Nav rows ───────────────────────────────────────────
                  Column(
                    children: [
                      ProfileNavRow(
                        icon: Icons.visibility_outlined,
                        title: 'Vision profile',
                        subtitle: 'Condition, prosthesis & assistive tech',
                        onTap: () =>
                            context.push(AppRoutes.visionProfile.path),
                      ),
                      const SizedBox(height: 11),
                      ProfileNavRow(
                        icon: Icons.accessibility_new_outlined,
                        title: 'Accessibility',
                        subtitle: 'Screen reader, text size, contrast',
                        onTap: () => context
                            .push(AppRoutes.accessibilitySettings.path),
                      ),
                      const SizedBox(height: 11),
                      ProfileNavRow(
                        icon: Icons.grid_view_outlined,
                        title: 'My activity',
                        subtitle: '142 posts · 38 saved · 6 circles',
                        onTap: () =>
                            context.push(AppRoutes.myActivity.path),
                      ),
                      const SizedBox(height: 11),
                      ProfileNavRow(
                        icon: Icons.settings_outlined,
                        title: 'Account & settings',
                        subtitle: 'Language, notifications, privacy',
                        onTap: () =>
                            context.push(AppRoutes.accountSettings.path),
                      ),
                      const SizedBox(height: 11),
                      ProfileNavRow(
                        icon: Icons.help_outline,
                        title: 'Help & support',
                        subtitle: 'Guides, contact, accessibility help',
                        onTap: () {},
                      ),
                      const SizedBox(height: 11),

                      // ── Sign out (danger) ────────────────────────────
                      ProfileNavRow(
                        icon: Icons.logout,
                        title: 'Sign out',
                        danger: true,
                        trailing: const SizedBox(width: 8),
                        onTap: () {
                          HapticPatterns.warning();
                          context
                              .read<AuthBloc>()
                              .add(const AuthEvent.signOut());
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _visionLabel(VisionProfile? vp) {
    return switch (vp) {
      VisionProfile.blindTotal => 'Blind (total)',
      VisionProfile.lowVision => 'Low vision',
      VisionProfile.ocularProsthesis => 'Ocular prosthesis',
      VisionProfile.caregiver => 'Caregiver',
      _ => 'Not set',
    };
  }
}
