import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';

/// Top row: 48×48 back chevron circle on the left, centered title, 48×48
/// placeholder span on the right to keep the title visually centred.
class ProstheticHeader extends StatelessWidget {
  const ProstheticHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Row(
      children: [
        // ── Back button ────────────────────────────────────────────────────
        Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home.path);
              }
            },
            child: SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),

        // ── Title (centered) ───────────────────────────────────────────────
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),

        // ── Trailing placeholder (mirrors back button for visual balance) ──
        const SizedBox(
          width: AppDimensions.minTapTarget,
          height: AppDimensions.minTapTarget,
        ),
      ],
    );
  }
}
