import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:opto/features/profile/presentation/widgets/profile_nav_row.dart';

/// Screen P5 — Account & Settings.
///
/// Groups: Account · Preferences · More. Email/phone are read from the active
/// Supabase session and ProfileBloc state. Sign out and Delete account are
/// "danger" rows; delete shows a confirmation dialog (deletion deferred to
/// an audited Edge Function — stub only for now).
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Account and settings.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    // Helper: trailing value + chevron
    Widget val(String text) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: Text(
              text,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: ink3,
                fontSize: 13.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: ink3, size: 20),
        ],
      );
    }

    // Real values from session / profile state (no additional network calls).
    final authUser = Supabase.instance.client.auth.currentUser;
    final email = authUser?.email;
    final profileState = context.watch<ProfileBloc>().state;
    final phone = profileState is ProfileLoaded
        ? profileState.profile.phone
        : null;

    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        state.mapOrNull(
          unauthenticated: (_) => ctx.go(AppRoutes.login.path),
        );
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
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
                  child:
                      Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
                ),
              ),
            ),
          ),
          title: Text(
            'Account & settings',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          actions: [
            Semantics(
              button: true,
              label: 'Listen to this page',
              child: GestureDetector(
                onTap: () => HapticPatterns.focusTick(),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: ext?.blueTint ?? cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ExcludeSemantics(
                      child: Icon(Icons.volume_up_outlined,
                          size: 24, color: cs.secondary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Account ──────────────────────────────────────────────
                _GroupLabel(label: 'ACCOUNT', ink3: ink3),
                const SizedBox(height: 12),
                Column(
                  children: [
                    ProfileNavRow(
                      icon: Icons.person_outline,
                      title: 'Email',
                      trailing: val(email ?? '—'),
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      trailing: val(phone ?? '—'),
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.lock_outline,
                      title: 'Password',
                      subtitle: 'Changed 3 months ago',
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.link_outlined,
                      title: 'Linked accounts',
                      trailing: val('2 linked'),
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.contacts_outlined,
                      title: 'Emergency contacts',
                      onTap: () =>
                          context.push(AppRoutes.emergencyContacts.path),
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.people_outline,
                      title: 'Caregiver links',
                      onTap: () =>
                          context.push(AppRoutes.caregiverLinks.path),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── Preferences ──────────────────────────────────────────
                _GroupLabel(label: 'PREFERENCES', ink3: ink3),
                const SizedBox(height: 12),
                Column(
                  children: [
                    ProfileNavRow(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      trailing: val('Bahasa Indonesia'),
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Replies, mentions, reminders',
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.shield_outlined,
                      title: 'Privacy & data',
                      subtitle: 'Who can see your profile',
                    ),
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.medical_services_outlined,
                      title: 'Connected clinic',
                      trailing: val('RS Mata Cicendo'),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ── More ─────────────────────────────────────────────────
                _GroupLabel(label: 'MORE', ink3: ink3),
                const SizedBox(height: 12),
                Column(
                  children: [
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
                    const SizedBox(height: 11),
                    ProfileNavRow(
                      icon: Icons.delete_outline,
                      title: 'Delete account',
                      danger: true,
                      trailing: const SizedBox(width: 8),
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Version footer ────────────────────────────────────────
                ExcludeSemantics(
                  child: Center(
                    child: Text(
                      'Opto · v4.2.0 · Made accessible in Bandung',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ink3,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This permanently removes your profile, posts, and health data. '
            'This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: cs.error),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed == true && mounted) {
      // TODO(profile): dispatch DeleteAccount event when backend is ready
      // ignore: use_build_context_synchronously
      announce(context, 'Account deletion is not yet available.');
    }
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.label, required this.ink3});

  final String label;
  final Color ink3;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: ink3,
              fontSize: 13,
            ),
      ),
    );
  }
}
