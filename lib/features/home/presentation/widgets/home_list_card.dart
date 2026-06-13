import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A grouped surface card that wraps a list of [HomeListItem] widgets and
/// places a thin divider between adjacent items.
///
/// Design: `.card`, `.li-div` in `Android Home Dashboard.html` (V1 Card Stack).
/// Background: `cs.surfaceContainer` (--sc), radius 20, horizontal pad 16.
/// Divider: 1.5 dp, `divider` colour, left margin 60 dp (aligns with text).
class HomeListCard extends StatelessWidget {
  const HomeListCard({super.key, required this.items});

  /// The [HomeListItem] widgets to display. Adjacent items are separated by
  /// a decorative hairline divider.
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();
    final Color dividerColor = ext?.divider ?? cs.outlineVariant;

    return Container(
      decoration: BoxDecoration(
        // Use surfaceContainer (--sc ≈ #F5F7FA) for the card background.
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              // Divider that starts at x = 60 (past the 46px leading + 14px gap)
              Opacity(
                opacity: 0.8,
                child: Container(
                  height: 1.5,
                  margin: const EdgeInsets.only(left: 60),
                  color: dividerColor,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
