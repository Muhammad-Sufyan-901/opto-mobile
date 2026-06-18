// Screen P3 — Vision Profile.
//
// 🔒 MEDICAL SENSITIVITY: This screen displays health details for the
// signed-in user only. The content is static placeholder data — there is
// no clinical backend yet. When a backend is wired:
//   • Pull only from owner-row RLS policies (see database_schema.md).
//   • Never cache beyond session, never join to community/catalog queries.
//   • Never expose to community feed, map, or catalog widgets.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/presentation/widgets/profile_fn_row.dart';
import 'package:opto/features/profile/presentation/widgets/profile_glance_card.dart';
import 'package:opto/features/profile/presentation/widgets/profile_listen_button.dart';
import 'package:opto/features/profile/presentation/widgets/profile_tech_chip.dart';

class ProfileVisionScreen extends StatefulWidget {
  const ProfileVisionScreen({super.key});

  @override
  State<ProfileVisionScreen> createState() => _VisionProfileScreenState();
}

class _VisionProfileScreenState extends State<ProfileVisionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Vision profile.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Scaffold(
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
                child: Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
              ),
            ),
          ),
        ),
        title: Text(
          'Vision profile',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Listen to vision profile',
            child: GestureDetector(
              onTap: () => HapticPatterns.focusTick(),
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
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
          Semantics(
            button: true,
            label: 'Edit vision profile',
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.edit_outlined,
                        size: 22, color: cs.onSurface),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, AppDimensions.space32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Privacy banner ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: ext?.blueTint?.withValues(alpha: 0.35) ??
                      cs.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: line, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(
                      child:
                          Icon(Icons.lock_outline, size: 18, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Private health details',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              fontSize: 14.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Visible to you and your linked specialist at '
                            'RS Mata Cicendo. Never shown on your public profile.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: ink2,
                              height: 1.45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Align(
                alignment: Alignment.centerLeft,
                child: ProfileListenButton(
                  summary: 'Vision profile. Primary condition: Glaucoma, '
                      'advanced. Affected eye: Right functional, left prosthetic. '
                      'Diagnosed 2019.',
                  label: 'Listen to your vision profile',
                ),
              ),

              const SizedBox(height: 16),

              // ── Diagnosis ────────────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  'DIAGNOSIS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: ink3,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ProfileGlanceCard(
                sectionIcon: Icons.medical_information_outlined,
                sectionLabel: 'Diagnosis',
                facts: const [
                  ProfileGlanceFact(
                    icon: Icons.visibility_outlined,
                    label: 'Primary condition',
                    value: 'Glaucoma — advanced',
                  ),
                  ProfileGlanceFact(
                    icon: Icons.adjust_outlined,
                    label: 'Affected eye',
                    value: 'Right (functional) · Left (prosthetic)',
                  ),
                  ProfileGlanceFact(
                    icon: Icons.access_time_outlined,
                    label: 'Onset',
                    value: 'Diagnosed 2019',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Functional vision ────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  'FUNCTIONAL VISION',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: ink3,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: const [
                  ProfileFnRow(
                    label: 'Light perception',
                    value: 'Present',
                    isPresent: true,
                  ),
                  SizedBox(height: 10),
                  ProfileFnRow(
                    label: 'Central acuity',
                    value: '20/200 · counting fingers',
                    isPresent: false,
                  ),
                  SizedBox(height: 10),
                  ProfileFnRow(
                    label: 'Visual field',
                    value: 'Tunnel · ~10° remaining',
                    isPresent: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── Ocular prosthesis ────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  'OCULAR PROSTHESIS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: ink3,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              ProfileGlanceCard(
                sectionIcon: Icons.adjust_outlined,
                sectionLabel: 'Prosthesis',
                facts: const [
                  ProfileGlanceFact(
                    icon: Icons.adjust_outlined,
                    label: 'Eye',
                    value: 'Left · scleral shell',
                  ),
                  ProfileGlanceFact(
                    icon: Icons.calendar_month_outlined,
                    label: 'Fitted',
                    value: '14 Mar 2024 · RS Mata Cicendo',
                  ),
                  ProfileGlanceFact(
                    icon: Icons.water_drop_outlined,
                    label: 'Material',
                    value: 'PMMA acrylic',
                  ),
                  ProfileGlanceFact(
                    icon: Icons.refresh_outlined,
                    label: 'Last polish',
                    value: '6 weeks ago · due in 6 mo',
                  ),
                ],
                footerIcon: Icons.notifications_outlined,
                footerText: 'Reminder set for next polish appointment',
                footerHighlight: true,
              ),

              const SizedBox(height: 16),

              // ── Assistive tech ────────────────────────────────────────
              ExcludeSemantics(
                child: Text(
                  'ASSISTIVE TECH IN USE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: ink3,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 2.6,
                children: const [
                  ProfileTechChip(
                    icon: Icons.volume_up_outlined,
                    name: 'TalkBack',
                    isOn: true,
                  ),
                  ProfileTechChip(
                    icon: Icons.zoom_in_outlined,
                    name: 'Magnifier',
                    isOn: true,
                  ),
                  ProfileTechChip(
                    icon: Icons.accessibility_new_outlined,
                    name: 'White cane',
                    isOn: true,
                  ),
                  ProfileTechChip(
                    icon: Icons.pets_outlined,
                    name: 'Guide dog',
                    isOn: false,
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
