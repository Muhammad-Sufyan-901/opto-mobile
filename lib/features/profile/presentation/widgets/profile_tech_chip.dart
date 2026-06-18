import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// An assistive-technology chip for the 2×2 grid on the Vision Profile screen
/// (CSS: `.pr-techchip`).
///
/// When [isOn] the chip gets a blue-tinted background and a green check icon;
/// when off it gets a neutral background and a plus icon. State is **never**
/// conveyed by colour alone — the trailing icon and label always reflect the
/// on/off state.
///
/// Accessibility: wrapped in [Semantics] with `button: true`, `selected: isOn`,
/// and a descriptive label (e.g. "TalkBack, active").
class ProfileTechChip extends StatelessWidget {
  const ProfileTechChip({
    super.key,
    required this.icon,
    required this.name,
    required this.isOn,
    this.onTap,
  });

  final IconData icon;
  final String name;
  final bool isOn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color onBg = ext?.blueTint ?? cs.primaryContainer;
    final Color offBg = cs.surfaceContainerLowest;
    final Color onIconFg = cs.secondary;
    final Color offIconFg = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color onTextFg = cs.onSurface;
    final Color offTextFg = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color onBorder = cs.primary.withValues(alpha: 0.30);
    final Color offBorder = ext?.line ?? cs.outlineVariant;
    final Color checkColor = ext?.green ?? const Color(0xFF16A34A);
    final Color offCheckColor = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      button: onTap != null,
      selected: isOn,
      label: '$name, ${isOn ? "active" : "not active"}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isOn ? onBg : offBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isOn ? onBorder : offBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Device icon
              ExcludeSemantics(
                child: Icon(
                  icon,
                  size: 18,
                  color: isOn ? onIconFg : offIconFg,
                ),
              ),
              const SizedBox(width: 10),
              // Name
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isOn ? onTextFg : offTextFg,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ),
              // State icon — check (on) or plus (off)
              ExcludeSemantics(
                child: Icon(
                  isOn ? Icons.check_circle : Icons.add_circle_outline,
                  size: 18,
                  color: isOn ? checkColor : offCheckColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
