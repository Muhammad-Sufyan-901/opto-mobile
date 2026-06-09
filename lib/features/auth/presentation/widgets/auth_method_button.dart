import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';

/// A full-width outline button with a leading icon and left-aligned label.
///
/// Used for the three sign-in method rows on [SignInHubScreen]:
///   Continue with Google / email / phone.
///
/// Spec: `.opt-btn.opt-btn-outline` — 60dp min-height, radius 18 (radiusRow),
/// 2px solid border (colorScheme.outline), left-aligned content with 14dp gap.
class AuthMethodButton extends StatelessWidget {
  const AuthMethodButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
  });

  final String label;

  /// Leading icon widget — can be an SVG, custom painter, or [Icon].
  final Widget icon;

  final VoidCallback? onPressed;

  /// Optional override for the semantics label (defaults to [label]).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.buttonHeight, // 60dp
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: cs.outline, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            alignment: Alignment.centerLeft,
            foregroundColor: cs.onSurface,
            backgroundColor: cs.surface,
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: AppDimensions.space16),
              Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
