import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A single fact row inside a [ProfileGlanceCard].
///
/// Renders: leading [icon] · [label] · right-aligned [value].
class ProfileGlanceFact {
  const ProfileGlanceFact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

/// The "vision at a glance" card (CSS: `.pr-glance`).
///
/// Shows a titled section with a list of [ProfileGlanceFact] rows and an
/// optional footer note line (e.g. lock/bell icon + text).
///
/// Accessibility: a single [Semantics] container whose label summarises all
/// fact pairs, keeping TalkBack traversal efficient; the icon column is
/// decorative ([ExcludeSemantics]).
class ProfileGlanceCard extends StatelessWidget {
  const ProfileGlanceCard({
    super.key,
    required this.sectionIcon,
    required this.sectionLabel,
    required this.facts,
    this.actionLabel,
    this.onAction,
    this.footerIcon,
    this.footerText,
    this.footerHighlight = false,
  });

  final IconData sectionIcon;
  final String sectionLabel;
  final List<ProfileGlanceFact> facts;

  /// Optional action label aligned to the right of the section title.
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Optional footer note line.
  final IconData? footerIcon;
  final String? footerText;

  /// When true, the footer text/icon uses the primary blue colour (e.g. a
  /// reminder note) instead of the default hint/ink-3 colour.
  final bool footerHighlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;
    final Color blueStrong = cs.secondary;
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    // Build a summary string for TalkBack
    final String semanticSummary = facts
        .map((f) => '${f.label}: ${f.value}')
        .join('. ');

    return Semantics(
      label: '$sectionLabel. $semanticSummary.',
      child: Container(
        decoration: BoxDecoration(
          color: blueTint.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: line, width: 1.5),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header row ──────────────────────────────────────────
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(sectionIcon, size: 17, color: cs.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  sectionLabel.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: ink2,
                    fontSize: 12.5,
                  ),
                ),
                if (actionLabel != null) ...[
                  const Spacer(),
                  Semantics(
                    button: true,
                    label: actionLabel,
                    child: GestureDetector(
                      onTap: onAction,
                      child: ExcludeSemantics(
                        child: Text(
                          actionLabel!,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 14),

            // ── Fact rows ────────────────────────────────────────────
            ExcludeSemantics(
              child: Column(
                children: [
                  for (int i = 0; i < facts.length; i++) ...[
                    if (i > 0) const SizedBox(height: 13),
                    _FactRow(
                      fact: facts[i],
                      blueStrong: blueStrong,
                      ink3: ink3,
                      theme: theme,
                    ),
                  ],
                ],
              ),
            ),

            // ── Footer note ──────────────────────────────────────────
            if (footerText != null) ...[
              const SizedBox(height: 13),
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.only(top: 13),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: line, width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      if (footerIcon != null) ...[
                        Icon(
                          footerIcon,
                          size: 15,
                          color: footerHighlight ? cs.primary : ink3,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          footerText!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: footerHighlight ? cs.primary : ink3,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Private: single fact row ─────────────────────────────────────────────────

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.fact,
    required this.blueStrong,
    required this.ink3,
    required this.theme,
  });

  final ProfileGlanceFact fact;
  final Color blueStrong;
  final Color ink3;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(fact.icon, size: 20, color: blueStrong),
        const SizedBox(width: 12),
        Text(
          fact.label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: ink3,
            fontSize: 13.5,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            fact.value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              fontSize: 14.5,
              letterSpacing: -0.2,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
