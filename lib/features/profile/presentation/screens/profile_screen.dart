import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/core/themes/app_custom_colors.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_bottom_nav.dart';

/// Screen 20 — Profile & Settings.
///
/// Displays user profile info plus grouped accessibility and account settings.
/// Accessibility is the whole point of this app — every element follows
/// `design_system.md §9` and `CLAUDE.md` non-negotiable rules.
///
/// Layout:
///   1. Header row — "Profile" title + Settings cog button
///   2. Profile card — avatar, name, tagline, Edit button
///   3. "ACCESSIBILITY" section label (decorative, ExcludeSemantics)
///   4. Accessibility settings group (4 rows with dividers)
///   5. "ACCOUNT" section label (decorative, ExcludeSemantics)
///   6. Account settings group (2 rows with dividers)
///   7. Persistent bottom nav (activeTab = 4)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Profile. Rian Hidayat.',
        TextDirection.ltr,
      );
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

              // ── 2. Profile card ────────────────────────────────────────
              Semantics(
                button: true,
                label:
                    'Rian Hidayat profile. Low vision, member since 2025. Double tap to edit.',
                child: Container(
                  margin: const EdgeInsets.only(top: 6, bottom: 22),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
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
                              'R',
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
                              'Rian Hidayat',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Low vision · Member since 2025',
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
                      GestureDetector(
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
              _SettingGroup(
                blueTint: blueTint,
                blueStrong: blueStrong,
                line: line,
                ink3: ink3,
                cs: cs,
                rows: const [
                  _SettingRowData(
                    icon: Icons.format_size_outlined,
                    title: 'Text size',
                    value: 'Large',
                  ),
                  _SettingRowData(
                    icon: Icons.contrast,
                    title: 'High contrast',
                    value: 'On',
                  ),
                  _SettingRowData(
                    icon: Icons.volume_up_outlined,
                    title: 'Voice & speech',
                    value: 'On',
                  ),
                  _SettingRowData(
                    icon: Icons.visibility_outlined,
                    title: 'Vision profile',
                    value: 'Low vision',
                    isLast: true,
                  ),
                ],
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
                rows: const [
                  _SettingRowData(
                    icon: Icons.security_outlined,
                    title: 'Privacy & safety',
                    value: '',
                  ),
                  _SettingRowData(
                    icon: Icons.help_outline,
                    title: 'Help & support',
                    value: '',
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  const _SettingRowData({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
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
  });

  final IconData icon;
  final String title;
  final String value;
  final Color blueTint;
  final Color blueStrong;
  final Color ink3;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final String semanticLabel =
        value.isNotEmpty ? '$title, $value' : title;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: () {
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
