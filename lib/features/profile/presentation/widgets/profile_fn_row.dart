import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Functional-vision status row (CSS: `.pr-fn-row`).
///
/// Renders: [label] · [value] · coloured status tag ([isPresent]).
///
/// The tag pairs colour + text to avoid encoding meaning by colour alone.
/// Accessibility: the whole row is a single [Semantics] container whose label
/// reads the complete triple (e.g. "Light perception: Present, OK").
class ProfileFnRow extends StatelessWidget {
  const ProfileFnRow({
    super.key,
    required this.label,
    required this.value,
    required this.isPresent,
  });

  final String label;
  final String value;

  /// True → "Present / OK" green tag. False → "Reduced / Low" amber tag.
  final bool isPresent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;
    final Color bg = ext?.blueTint?.withValues(alpha: 0.35) ??
        cs.surfaceContainerLowest;

    final Color tagBg = isPresent
        ? (ext?.greenTint ?? const Color(0xFFDCFCE7))
        : (ext?.warningTint ?? const Color(0xFFFEF3C7));
    final Color tagFg = isPresent
        ? (ext?.green ?? const Color(0xFF16A34A))
        : (ext?.warning ?? const Color(0xFF92400E));
    final String tagText = isPresent ? 'Present' : 'Reduced';

    return Semantics(
      label: '$label: $value. $tagText.',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: ExcludeSemantics(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            ExcludeSemantics(
              child: Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ink2,
                  fontSize: 12.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Status tag — pairs colour + text, never colour alone
            ExcludeSemantics(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  tagText.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: tagFg,
                    fontSize: 10.5,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
