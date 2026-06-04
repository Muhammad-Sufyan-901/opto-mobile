import 'package:flutter/material.dart';

/// Animated page-indicator dots matching the design spec:
///   - Active dot: 11dp, `colorScheme.primary`
///   - Inactive dot: 9dp, `colorScheme.outline` (--line)
///   - Gap between dots: 8dp
///   - Animated size + colour via [AnimatedContainer]
///
/// Wrapped in [ExcludeSemantics] — page position is announced by the parent
/// [WelcomeScreen] via a live region instead (avoids duplicate TalkBack
/// announcements per CLAUDE.md §accessibility).
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  /// Total number of dots.
  final int count;

  /// Zero-based index of the currently active dot.
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (i) {
          final bool active = i == activeIndex;
          return Padding(
            padding: EdgeInsets.only(right: i < count - 1 ? 8.0 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 11.0 : 9.0,
              height: active ? 11.0 : 9.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? cs.primary : cs.outline,
              ),
            ),
          );
        }),
      ),
    );
  }
}
