import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/app_theme_mode.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/cubit/accessibility_settings_cubit.dart';

/// Screen 20 — Profile & Settings.
///
/// Provides [ProfileBloc], [AccessibilitySettingsCubit], and [AuthBloc] via
/// [MultiBlocProvider]. Loads the current user's profile on init, then
/// renders real data from [ProfileLoaded]. Falls back gracefully while loading
/// or on error.
///
/// Accessibility is the whole point of this app — every element follows
/// `design_system.md §9` and `CLAUDE.md` non-negotiable rules.
///
/// Layout:
///   1. Header row — "Profile" title + Settings cog button
///   2. Profile card — avatar, name, tagline, Edit button
///   3. "ACCESSIBILITY" section label (decorative, ExcludeSemantics)
///   4. Accessibility settings group (4 rows with live data)
///   5. "ACCOUNT" section label (decorative, ExcludeSemantics)
///   6. Account settings group (sign-out + help rows)
///   7. Persistent bottom nav (activeTab = 4)
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
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends StatefulWidget {
  const _ProfileScreenBody();

  @override
  State<_ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<_ProfileScreenBody> {
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<ProfileBloc>().add(ProfileEvent.loadProfile(userId: userId));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Profile.',
        TextDirection.ltr,
      );
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
          final ThemeData theme = Theme.of(ctx);
          final ColorScheme cs = theme.colorScheme;
          final ext = theme.extension<AppExtendedCustomColors>();
          final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
          final Color blueStrong = cs.secondary;
          final Color line = ext?.line ?? cs.outline;
          final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
          final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

          // Extract profile data when loaded, or fall back to placeholder values.
          final ProfileEntity? profile =
              profileState is ProfileLoaded ? profileState.profile : null;
          final String displayName = profile?.fullName ?? '—';
          final String initials = displayName.isNotEmpty &&
                  displayName != '—'
              ? displayName.trim().split(' ').map((w) => w[0]).take(2).join()
              : '?';
          final String visionLabel =
              _visionProfileLabel(profile?.visionProfile);
          final int memberYear = profile?.createdAt.year ??
              DateTime.now().year;
          final String tagline = '$visionLabel · Member since $memberYear';

          return Scaffold(
            backgroundColor: cs.surface,
            bottomNavigationBar: const HomeBottomNav(activeTab: 4),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 22,
                  right: 22,
                  top: 14,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 1. Header row ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        Semantics(
                          button: true,
                          label: 'Settings',
                          child: GestureDetector(
                            onTap: () {
                              // TODO(profile): navigate to Settings screen
                            },
                            child: Container(
                              width: AppDimensions.minTapTarget,
                              height: AppDimensions.minTapTarget,
                              decoration: BoxDecoration(
                                color: blueTint,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.settings_outlined,
                                  size: 22,
                                  color: blueStrong,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ── Loading / error overlay ────────────────────────────────
                    if (profileState is ProfileLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      )
                    else if (profileState is ProfileError)
                      Semantics(
                        liveRegion: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            profileState.message,
                            style: TextStyle(
                              color: cs.error,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                    // ── 2. Profile card ────────────────────────────────────────
                    Semantics(
                      button: true,
                      label:
                          '$displayName profile. $tagline. Double tap to edit.',
                      child: Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 22),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: blueTint,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusCard),
                          border: Border.all(
                            color: cs.primary.withValues(alpha: 0.18),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Avatar circle with initials
                            ExcludeSemantics(
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Name and tagline
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    tagline,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      color: ink2,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Edit button
                            Semantics(
                              button: true,
                              label: 'Edit profile',
                              child: GestureDetector(
                                onTap: () {
                                  // TODO(profile): navigate to edit profile screen
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: cs.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── 3. ACCESSIBILITY section label ─────────────────────────
                    ExcludeSemantics(
                      child: _SectionLabel(label: 'ACCESSIBILITY'),
                    ),

                    const SizedBox(height: 8),

                    // ── 4. Accessibility settings group ────────────────────────
                    BlocBuilder<AccessibilitySettingsCubit,
                        AccessibilitySettingsEntity>(
                      builder: (ctx2, settings) {
                        return _SettingGroup(
                          blueTint: blueTint,
                          blueStrong: blueStrong,
                          line: line,
                          ink3: ink3,
                          cs: cs,
                          rows: [
                            _SettingRowData(
                              icon: Icons.format_size_outlined,
                              title: 'Text size',
                              value: _textScaleLabel(settings.textScale),
                            ),
                            _SettingRowData(
                              icon: Icons.contrast,
                              title: 'High contrast',
                              value: settings.theme == AppThemeMode.highContrast
                                  ? 'On'
                                  : 'Off',
                            ),
                            _SettingRowData(
                              icon: Icons.volume_up_outlined,
                              title: 'Voice & speech',
                              value: settings.voiceEnabled ? 'On' : 'Off',
                            ),
                            _SettingRowData(
                              icon: Icons.visibility_outlined,
                              title: 'Vision profile',
                              value: visionLabel,
                              isLast: true,
                            ),
                          ],
                        );
                      },
                    ),

                    // ── 5. ACCOUNT section label ───────────────────────────────
                    const SizedBox(height: 8),

                    ExcludeSemantics(
                      child: _SectionLabel(label: 'ACCOUNT'),
                    ),

                    const SizedBox(height: 8),

                    // ── 6. Account settings group ──────────────────────────────
                    _SettingGroup(
                      blueTint: blueTint,
                      blueStrong: blueStrong,
                      line: line,
                      ink3: ink3,
                      cs: cs,
                      rows: [
                        const _SettingRowData(
                          icon: Icons.security_outlined,
                          title: 'Privacy & safety',
                          value: '',
                        ),
                        const _SettingRowData(
                          icon: Icons.help_outline,
                          title: 'Help & support',
                          value: '',
                        ),
                        _SettingRowData(
                          icon: Icons.logout,
                          title: 'Sign out',
                          value: '',
                          isLast: true,
                          onTap: () {
                            ctx.read<AuthBloc>().add(const AuthEvent.signOut());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _visionProfileLabel(VisionProfile? visionProfile) {
    switch (visionProfile) {
      case VisionProfile.blindTotal:
        return 'Blind (total)';
      case VisionProfile.lowVision:
        return 'Low vision';
      case VisionProfile.ocularProsthesis:
        return 'Ocular prosthesis';
      case VisionProfile.caregiver:
        return 'Caregiver';
      case VisionProfile.unspecified:
      case null:
        return 'Not set';
    }
  }

  String _textScaleLabel(double scale) {
    if (scale <= 1.0) return 'Default';
    if (scale <= 1.5) return 'Large';
    if (scale <= 2.0) return 'Larger';
    return 'Largest';
  }
}

// =============================================================================
// PRIVATE SUB-WIDGETS
// =============================================================================

/// Uppercase section label used above settings groups.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? theme.colorScheme.onSurfaceVariant;

    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.3,
        color: ink3,
      ),
    );
  }
}

/// Data class for a single setting row.
class _SettingRowData {
  final IconData icon;
  final String title;
  final String value;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingRowData({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
    this.onTap,
  });
}

/// A bordered group of [_SettingRow] items with hairline dividers between rows.
class _SettingGroup extends StatelessWidget {
  const _SettingGroup({
    required this.blueTint,
    required this.blueStrong,
    required this.line,
    required this.ink3,
    required this.cs,
    required this.rows,
  });

  final Color blueTint;
  final Color blueStrong;
  final Color line;
  final Color ink3;
  final ColorScheme cs;
  final List<_SettingRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
        color: cs.surface,
        border: Border.all(color: line, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in rows) ...[
            _SettingRow(
              icon: row.icon,
              title: row.title,
              value: row.value,
              blueTint: blueTint,
              blueStrong: blueStrong,
              ink3: ink3,
              cs: cs,
              onTap: row.onTap,
            ),
            if (!row.isLast)
              Divider(height: 1.5, thickness: 1.5, color: line),
          ],
        ],
      ),
    );
  }
}

/// A single tappable settings row with icon chip, title, value, and chevron.
class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.blueTint,
    required this.blueStrong,
    required this.ink3,
    required this.cs,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color blueTint;
  final Color blueStrong;
  final Color ink3;
  final ColorScheme cs;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String semanticLabel =
        value.isNotEmpty ? '$title, $value' : title;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap ?? () {
          // TODO(profile): navigate to $title screen
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: Row(
            children: [
              // Icon chip
              Container(
                width: AppDimensions.iconChipSize,
                height: AppDimensions.iconChipSize,
                decoration: BoxDecoration(
                  color: blueTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(icon, size: 22, color: blueStrong),
                ),
              ),

              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),

              // Value (optional)
              if (value.isNotEmpty) ...[
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ink3,
                  ),
                ),
                const SizedBox(width: 4),
              ],

              // Chevron
              Icon(Icons.chevron_right, color: ink3, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
