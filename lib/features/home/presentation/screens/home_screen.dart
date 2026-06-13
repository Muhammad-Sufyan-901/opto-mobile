import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/features/home/presentation/widgets/aura_voice_card.dart';
import 'package:opto/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:opto/features/home/presentation/widgets/home_list_card.dart';
import 'package:opto/features/home/presentation/widgets/home_list_item.dart';
import 'package:opto/features/home/presentation/widgets/home_nearby_card.dart';
import 'package:opto/features/home/presentation/widgets/home_section_header.dart';
import 'package:opto/features/home/presentation/widgets/home_top_bar.dart';
import 'package:opto/features/home/presentation/widgets/quick_action_grid.dart';
import 'package:opto/features/home/presentation/widgets/sos_card.dart';

/// Screen 15 — Opto Home Dashboard · **V1 Card Stack**.
///
/// The main super-app hub reached after onboarding + setup completes.
/// Implements the `V1 · Card stack` artboard from `Android Home Dashboard.html`.
///
/// Layout (top → bottom):
///   1. Top bar — "Opto" title · bell+dot · avatar · greeting
///   2. Emergency SOS — **bold hero** (red gradient, pulsing ring)
///   3. Aura Voice bar — "Ask Opto anything"
///   4. "Quick actions" section → 2×2 grey M3 tiles
///   5. "Up next" section → grouped card (prosthetic reminder + doctor avatar)
///   6. Navigate nearby — borderless surfaceContainer card
///   7. "Recent activity" section → grouped card with 3 rows (no chevrons)
///   8. Pinned 5-tab bottom nav — M3 pill style
///
/// Accessibility:
///   - One-line screen summary announced on mount (design_system.md §21.3).
///   - Greeting "Rian" is a semantic heading (header: true).
///   - Every interactive element has a Semantics label.
///   - Decorative icons/waveforms wrapped in ExcludeSemantics.
///   - Colors exclusively from theme tokens — Light / Dark / High-Contrast all
///     render correctly without hardcoded hex in widgets.
///   - Respects MediaQuery.textScaler; SingleChildScrollView prevents clipping.
///   - SOS pulsing ring stops when MediaQuery.disableAnimations is true.
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
      announce(context, 'Home. Good morning, Rian.');
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
          // 16 dp horizontal padding matches `.pad` in the HTML spec.
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 6,
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top bar + greeting ──────────────────────────────────
              const HomeTopBar(),

              const SizedBox(height: 10),

              // ── 2. Emergency SOS — bold hero ───────────────────────────
              SosCard(
                bold: true,
                onTap: () => context.go(AppRoutes.sos.path),
              ),

              const SizedBox(height: 14),

              // ── 3. Aura Voice bar ──────────────────────────────────────
              AuraVoiceCard(
                onTap: () => context.go(AppRoutes.auraVoice.path),
              ),

              const SizedBox(height: 14),

              // ── 4. Quick actions 2×2 grid ──────────────────────────────
              HomeSectionHeader(
                title: 'Quick actions',
                onSeeAll: null, // no "See all" for quick actions in V1
              ),

              const SizedBox(height: 8),

              const QuickActionGrid(),

              const SizedBox(height: 14),

              // ── 5. Up next grouped card ────────────────────────────────
              HomeSectionHeader(
                title: 'Up next',
                onSeeAll: () {
                  // TODO: navigate to full schedule / upcoming list.
                },
              ),

              const SizedBox(height: 8),

              HomeListCard(
                items: [
                  HomeListItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Prosthetic cleaning',
                    subtitle: 'Tomorrow · 09:00',
                    semanticLabel:
                        'Prosthetic cleaning. Tomorrow at 09:00.',
                  ),
                  HomeListItem(
                    avatarInitials: 'BP',
                    title: 'Fitting — Dr. Budi Pratama',
                    subtitle: 'Fri, Apr 18 · RSU Mata Cicendo',
                    semanticLabel:
                        'Fitting with Dr. Budi Pratama. Friday, April 18 at RSU Mata Cicendo.',
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── 6. Navigate nearby ─────────────────────────────────────
              const HomeNearbyCard(),

              const SizedBox(height: 14),

              // ── 7. Recent activity grouped card ───────────────────────
              HomeSectionHeader(
                title: 'Recent activity',
                onSeeAll: () {
                  // TODO: navigate to full activity history.
                },
              ),

              const SizedBox(height: 8),

              HomeListCard(
                items: [
                  HomeListItem(
                    icon: Icons.visibility_outlined,
                    title: 'Read a letter from BPJS',
                    subtitle: 'Today · 08:14',
                    showChevron: false,
                    semanticLabel: 'Read a letter from BPJS. Today at 08:14.',
                  ),
                  HomeListItem(
                    icon: Icons.forum_outlined,
                    title: 'Replied in "Low-vision tips"',
                    subtitle: 'Yesterday · 19:02',
                    showChevron: false,
                    semanticLabel:
                        'Replied in Low-vision tips. Yesterday at 19:02.',
                  ),
                  HomeListItem(
                    icon: Icons.medical_services_outlined,
                    title: 'Booked Dr. Anwar — eye check',
                    subtitle: 'Mon · 14:30',
                    showChevron: false,
                    semanticLabel:
                        'Booked Dr. Anwar for eye check. Monday at 14:30.',
                  ),
                ],
              ),

              // Extra bottom breathing room above nav.
              const SizedBox(height: AppDimensions.space16),
            ],
          ),
        ),
      ),
    );
  }
}
