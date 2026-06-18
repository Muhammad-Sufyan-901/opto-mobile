import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A compact pill segmented control (CSS: `.pr-seg`).
///
/// Used for speech-rate and text-size selectors on the Accessibility screen.
/// Renders a row of equal-width segments; the active segment gets a filled
/// primary-blue pill with a drop shadow.
///
/// Accessibility: each option is an individual [Semantics] button with
/// `selected: true/false` and a combined label (e.g. "1.5× speed, selected").
class ProfileSegmented extends StatelessWidget {
  const ProfileSegmented({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,

    /// Optional list of display labels (e.g. different font sizes for the
    /// text-size demo). Must match [options] in length if provided.
    this.displayLabels,
    this.displayFontSizes,
    this.semanticSuffix = '',
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  /// If provided, these strings override the option value as visible text.
  final List<String>? displayLabels;

  /// If provided, each label is rendered at this fontSize (demo for text-size).
  final List<double>? displayFontSizes;

  /// Appended to each option's semantic label (e.g. ' speed', ' text size').
  final String semanticSuffix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color containerBg = ext?.blueTint?.withValues(alpha: 0.4) ??
        cs.surfaceContainerLow;
    final Color line = ext?.line ?? cs.outline;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: line, width: 1.5),
      ),
      child: Row(
        children: [
          for (int i = 0; i < options.length; i++)
            Expanded(
              child: _Segment(
                value: options[i],
                display: displayLabels != null ? displayLabels![i] : options[i],
                isSelected: options[i] == selected,
                fontSize: displayFontSizes != null ? displayFontSizes![i] : null,
                semanticLabel: '${displayLabels != null ? displayLabels![i] : options[i]}$semanticSuffix',
                onTap: () => onSelected(options[i]),
                theme: theme,
                cs: cs,
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.value,
    required this.display,
    required this.isSelected,
    required this.onTap,
    required this.theme,
    required this.cs,
    this.fontSize,
    required this.semanticLabel,
  });

  final String value;
  final String display;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme cs;
  final double? fontSize;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 46,
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: ExcludeSemantics(
              child: Text(
                display,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isSelected ? Colors.white : cs.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
