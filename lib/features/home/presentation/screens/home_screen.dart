import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:ids_elder_rehab_app/core/constants/app_dimensions.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/aura_voice_card.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_info_row.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/home_top_bar.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/recent_activity_list.dart';
import 'package:ids_elder_rehab_app/features/home/presentation/widgets/sos_card.dart';

/// Screen 15 — Opto Home Dashboard.
///
/// The main super-app hub reached after onboarding + setup completes.
/// Spec: `ScreenDashboard` / artboard "15 · Dashboard" in `Opto Onboarding.html`
/// and `design_system.md §12.1` (Home Hub anatomy).
///
/// Layout (top → bottom):
///   1. Top bar — greeting + notification bell + avatar
///   2. Aura Voice quick-launch pill
///   3. Quick actions 2×2 grid (Vision AI, Prosthetic Hub, Consult, Community)
///   4. Emergency SOS card
///   5. Upcoming reminder row (Prosthetic cleaning)
///   6. Navigate nearby row
///   7. Recent activity list
///   8. Pinned 5-tab bottom nav (Home · Vision AI · Community · Consult · Profile)
///
/// Accessibility:
///   - One-line screen summary announced on mount per `design_system.md §21.3`.
///   - Greeting is a semantic heading (`header: true`).
///   - Every interactive element has a `Semantics` label.
///   - Decorative icons/waveforms are wrapped in `ExcludeSemantics`.
///   - Colors come exclusively from theme tokens — Light / Dark / High-Contrast
///     all render correctly without any hardcoded hex in the widgets.
///   - Respects `MediaQuery.textScaler`; `SingleChildScrollView` prevents
///     fixed-height clipping under large text.
///
/// State: presentation-only (StatefulWidget + setState pattern matching the
/// existing codebase). Hardcoded content will be replaced by
/// `HomeSummaryRepository` once the domain/data layer is built (⛔ Planned).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Announce a concise one-line summary on arrival (design_system.md §21.3).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      SemanticsService.sendAnnouncement(
        View.of(context),
        'Home. Good morning, Rian.',
        TextDirection.ltr,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      // Pinned bottom nav — lives outside the scroll area.
      bottomNavigationBar: const HomeBottomNav(activeTab: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          // Horizontal: 22dp (design spec `.dash-scroll` padding).
          // Top: 14dp; bottom: 24dp breathing room above nav.
          padding: const EdgeInsets.only(
            left: 22,
            right: 22,
            top: 14,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top bar ─────────────────────────────────────────
              const HomeTopBar(),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── 2. Aura Voice pill ─────────────────────────────────
              const AuraVoiceCard(),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── 3. Quick actions 2×2 grid ──────────────────────────
              const QuickActionGrid(),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── 4. Emergency SOS card ──────────────────────────────
              const SosCard(),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── 5. Upcoming reminder row ───────────────────────────
              HomeInfoRow(
                icon: Icons.calendar_today_outlined,
                eyebrow: 'Upcoming',
                title: 'Prosthetic cleaning',
                subtitle: 'Tomorrow · 09:00',
                semanticLabel:
                    'Upcoming. Prosthetic cleaning. Tomorrow at 09:00.',
              ),

              const SizedBox(height: AppDimensions.space12),

              // ── 6. Navigate nearby row ─────────────────────────────
              const HomeInfoRow(
                icon: Icons.place_outlined,
                title: 'Navigate nearby',
                subtitle: 'Guided walking with audio cues',
                semanticLabel:
                    'Navigate nearby. Guided walking with audio cues.',
              ),

              const SizedBox(height: AppDimensions.sectionGap),

              // ── 7. Recent activity list ────────────────────────────
              const RecentActivityList(),

              // Extra bottom spacing
              const SizedBox(height: AppDimensions.space16),
            ],
          ),
        ),
      ),
    );
  }
}
