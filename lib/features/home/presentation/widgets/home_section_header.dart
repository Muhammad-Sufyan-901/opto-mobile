import 'package:flutter/material.dart';

/// Section-header row used between card groups on the Opto Home screen.
///
/// Renders a sentence-case label on the left and an optional "See all" link
/// on the right.
///
/// Design: `.sec-row`, `.sec`, `.sec-act` in `Android Home Dashboard.html`.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({super.key, required this.title, this.onSeeAll});

  /// Section label, e.g. "Quick actions" or "Up next".
  final String title;

  /// If provided, a tappable "See all" link is rendered on the right.
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Section label — 14/w600, secondary (blue-strong) colour.
        ExcludeSemantics(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: cs.secondary,
              height: 1.2,
            ),
          ),
        ),

        if (onSeeAll != null) ...[
          const Spacer(),
          Semantics(
            button: true,
            label: 'See all $title',
            child: GestureDetector(
              onTap: onSeeAll,
              child: ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
