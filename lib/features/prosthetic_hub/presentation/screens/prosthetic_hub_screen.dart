import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/hub/hub_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/hub/hub_state.dart';

/// Screen 17 — Prosthetic Hub
///
/// Accessibility-first overview of the user's ocular prosthesis care status,
/// with quick links to care guides, supply ordering, measurements, eye photos,
/// and specialist messaging.
///
/// Status card is driven by live data (latest order + next active reminder)
/// via [HubCubit].
class ProstheticHubScreen extends StatefulWidget {
  const ProstheticHubScreen({super.key});

  @override
  State<ProstheticHubScreen> createState() => _ProstheticHubScreenState();
}

class _ProstheticHubScreenState extends State<ProstheticHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Prosthetic Hub.');
      context.read<HubCubit>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 22,
            right: 22,
            top: 14,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Screen header: back + title ───────────────────────────────
              _ScreenHeader(cs: cs),

              const SizedBox(height: 14),

              // ── Live Status card ──────────────────────────────────────────
              BlocBuilder<HubCubit, HubState>(
                builder: (context, state) {
                  final orderStatus = state is HubLoaded
                      ? state.latestOrderStatus
                      : null;
                  final nextReminder = state is HubLoaded
                      ? state.nextReminderLabel
                      : null;
                  return _StatusCard(
                    cs: cs,
                    latestOrderStatus: orderStatus,
                    nextReminderLabel: nextReminder,
                    isLoading: state is HubLoading,
                  );
                },
              ),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── "Care & support" section label ────────────────────────────
              ExcludeSemantics(
                child: Row(
                  children: [
                    Text(
                      'CARE & SUPPORT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: ext?.ink3 ?? cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── Hub link rows ─────────────────────────────────────────────

              // Care guides → tutorials ✅
              _HubLink(
                icon: Icons.menu_book_outlined,
                title: 'Care guides',
                subtitle: 'Cleaning, handling, sleep',
                onTap: () =>
                    context.goNamed(AppRoutes.careTutorials.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // Order supplies → catalog ✅
              _HubLink(
                icon: Icons.inventory_2_outlined,
                title: 'Order supplies',
                subtitle: 'Prosthetics, cases & care kits',
                onTap: () =>
                    context.goNamed(AppRoutes.prostheticCatalog.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // My orders → orders list ✅
              _HubLink(
                icon: Icons.shopping_bag_outlined,
                title: 'My orders',
                subtitle: 'Track and manage your orders',
                onTap: () =>
                    context.goNamed(AppRoutes.prostheticOrders.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // My measurements → anthropometric ✅
              _HubLink(
                icon: Icons.straighten_outlined,
                title: 'My measurements',
                subtitle: 'Socket size, iris diameter',
                onTap: () =>
                    context.goNamed(AppRoutes.anthropometric.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // Eye photos → eye_photos ✅
              _HubLink(
                icon: Icons.photo_camera_outlined,
                title: 'Eye photos',
                subtitle: 'Reference photos for matching',
                onTap: () =>
                    context.goNamed(AppRoutes.eyePhotos.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // Care reminders → reminders ✅
              _HubLink(
                icon: Icons.alarm_outlined,
                title: 'Care reminders',
                subtitle: 'Schedule cleaning & check-ups',
                onTap: () =>
                    context.goNamed(AppRoutes.careReminders.name),
              ),
              const SizedBox(height: AppDimensions.space12),

              // Fitting appointments — Phase 3D consultation (coming soon)
              _HubLink(
                icon: Icons.calendar_today_outlined,
                title: 'Fitting appointments',
                subtitle: 'Coming in a future update',
                enabled: false,
                onTap: () {},
              ),
              const SizedBox(height: AppDimensions.space12),

              // Message specialist — Phase 3D (coming soon)
              _HubLink(
                icon: Icons.message_outlined,
                title: 'Message my specialist',
                subtitle: 'Coming in a future update',
                enabled: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

/// Top row: 48×48 back chevron circle on the left, centered title.
class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        // ── Back button ────────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home.path);
              }
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Title (centered) ───────────────────────────────────────────────
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'Prosthetic Hub',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),

        // ── Trailing placeholder (mirrors back button for visual balance) ──
        const SizedBox(
          width: AppDimensions.minTapTarget,
          height: AppDimensions.minTapTarget,
        ),
      ],
    );
  }
}

/// Blue-gradient status card driven by live order + reminder data.
class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.cs,
    required this.isLoading,
    this.latestOrderStatus,
    this.nextReminderLabel,
  });

  final ColorScheme cs;
  final bool isLoading;
  final String? latestOrderStatus;
  final String? nextReminderLabel;

  String get _headlineText {
    if (isLoading) return 'Loading…';
    if (nextReminderLabel != null) return nextReminderLabel!;
    return 'No reminders set';
  }

  String get _subtitleText {
    if (isLoading) return '';
    final orderPart = latestOrderStatus != null
        ? 'Latest order: $latestOrderStatus.'
        : 'No orders yet.';
    return '$orderPart Tap to manage care reminders.';
  }

  String get _semanticsLabel {
    if (isLoading) return 'Prosthetic Hub status loading.';
    final reminder =
        nextReminderLabel != null ? nextReminderLabel! : 'No reminders set';
    final order = latestOrderStatus != null
        ? 'Latest order: $latestOrderStatus.'
        : 'No orders yet.';
    return 'Prosthetic status: $reminder. $order Double tap to manage care reminders.';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      button: true,
      label: _semanticsLabel,
      child: GestureDetector(
        onTap: () => context.goNamed(AppRoutes.careReminders.name),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.secondary],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.60),
                blurRadius: 30,
                offset: const Offset(0, 14),
                spreadRadius: -10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(AppDimensions.cardPaddingLarge),
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: status chip + type ────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isLoading)
                            const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Icon(
                              Icons.verified_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          const SizedBox(width: 4),
                          Text(
                            latestOrderStatus ?? 'No orders',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Ocular prosthesis',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  _headlineText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _subtitleText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                // ── CTA ────────────────────────────────────────────────
                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () =>
                          context.goNamed(AppRoutes.careReminders.name),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Manage reminders',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.secondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: AppDimensions.iconMd,
                              color: cs.secondary,
                            ),
                          ],
                        ),
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
}

/// A single "Care & support" link row.
class _HubLink extends StatelessWidget {
  const _HubLink({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = enabled ? cs.secondary : cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      button: enabled,
      enabled: enabled,
      label: enabled ? '$title. $subtitle' : '$title. Not yet available.',
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: AppDimensions.space16,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
              border: Border.all(color: line, width: 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExcludeSemantics(
                  child: Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: blueTint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, size: 22, color: blueStrong),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ink2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ExcludeSemantics(
                  child: Icon(Icons.chevron_right, size: 22, color: ink3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
