import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/widgets/inputs/app_input_field.dart';
import 'package:opto/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:opto/features/auth/presentation/widgets/relationship_chip.dart';

/// Screen 09 — Caregiver / assisted setup.
///
/// Spec: `ScreenCaregiver` / `.scr-pad` in `Opto Onboarding.html`.
///
/// Layout via [AuthFormScaffold]: back nav, scrollable body, pinned CTA.
///   - Blue-tint banner with hands icon + explanation text.
///   - "Who are you setting up for?" title.
///   - Name field (required, text).
///   - "Your relationship" — 4 selectable [RelationshipChip]s.
///   - Continue setup → push email auth.
class CaregiverSetupScreen extends StatefulWidget {
  const CaregiverSetupScreen({super.key});

  @override
  State<CaregiverSetupScreen> createState() => _CaregiverSetupScreenState();
}

class _CaregiverSetupScreenState extends State<CaregiverSetupScreen> {
  final _nameController = TextEditingController();
  String? _selectedRelationship;

  static const List<String> _relationships = [
    'Family',
    'Friend',
    'Carer',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final Color blueTint =
        theme.extension<AppExtendedCustomColors>()?.blueTint ??
            cs.primaryContainer;

    return AuthFormScaffold(
      ctaLabel: 'Continue setup',
      ctaSuffixIcon: Icons.arrow_forward,
      onCta: () => context.push(AppRoutes.authEmail.path),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Banner ─────────────────────────────────────
          Semantics(
            label:
                "You're setting up Opto for someone else. The account stays theirs — you just help get it ready.",
            container: true,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: blueTint,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon chip
                  Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusChip,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.people_outline,
                        size: AppDimensions.iconLg,
                        color: cs.primary,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppDimensions.space16),

                  // Text
                  Expanded(
                    child: Text(
                      "You're setting up Opto for someone else. "
                      "The account stays theirs — you just help get it ready.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface,
                        height: 1.45,
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Title ────────────────────────────────────
          Semantics(
            header: true,
            child: Text(
              'Who are you setting up for?',
              style: theme.textTheme.displaySmall?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space20),

          // ── Name field ────────────────────────────────
          Text(
            'Their name',
            style: theme.textTheme.titleSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space8),

          AppInputField(
            controller: _nameController,
            hintText: 'Full name',
            isRequired: true,
          ),

          const SizedBox(height: AppDimensions.space24),

          // ── Relationship label ────────────────────────
          Text(
            'Your relationship',
            style: theme.textTheme.titleSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppDimensions.space12),

          // ── Chips ─────────────────────────────────────
          Wrap(
            spacing: AppDimensions.space12,
            runSpacing: AppDimensions.space12,
            children: _relationships
                .map(
                  (r) => RelationshipChip(
                    label: r,
                    selected: _selectedRelationship == r,
                    onTap: () => setState(() => _selectedRelationship = r),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: AppDimensions.space24),
        ],
      ),
    );
  }
}
