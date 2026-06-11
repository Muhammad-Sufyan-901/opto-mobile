// Reusable POI list tile widget.
//
// Used by [NearbyPoisScreen] for each accessibility point of interest.
// Semantics label includes the name, distance (if available), and which
// attributes the place has — so screen-reader users get the full picture
// on focus, not just the visual text.
import 'package:flutter/material.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/map_enums.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';

class PoiListTile extends StatelessWidget {
  const PoiListTile({
    super.key,
    required this.poi,
    required this.onTap,
  });

  final AccessibilityPoiEntity poi;
  final VoidCallback onTap;

  // ── helpers ──────────────────────────────────────────────────────────────

  String _distanceLabel() {
    final d = poi.distanceMeters;
    if (d == null) return '';
    if (d < 1000) return '${d.round()} m away. ';
    return '${(d / 1000).toStringAsFixed(1)} km away. ';
  }

  /// Build a spoken description of the attributes for TalkBack / VoiceOver.
  String _attributesSpeech() {
    final attrs = poi.attributes.entries
        .where((e) => e.value == true)
        .map((e) {
          final attr = PoiAttribute.fromJsonKey(e.key);
          return attr?.displayLabel ?? e.key;
        })
        .toList();
    if (attrs.isEmpty) return 'No accessibility features listed.';
    return 'Features: ${attrs.join(', ')}.';
  }

  /// Build a short text badge list for the visual layer.
  List<String> _badgeLabels() {
    return poi.attributes.entries
        .where((e) => e.value == true)
        .take(3)
        .map((e) {
          final attr = PoiAttribute.fromJsonKey(e.key);
          return attr?.displayLabel ?? e.key;
        })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;
    final Color blueTint = ext?.blueTint ?? cs.primaryContainer;

    final String semanticsLabel =
        '${poi.name}. ${_distanceLabel()}${_attributesSpeech()} '
        '${poi.verifiedCount} verification${poi.verifiedCount != 1 ? 's' : ''}.';

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.space12,
            horizontal: AppDimensions.space16,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
            border: Border.all(color: line, width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ──────────────────────────────────────────────────
              ExcludeSemantics(
                child: Container(
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  decoration: BoxDecoration(
                    color: blueTint,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusChip),
                  ),
                  child: Icon(
                    Icons.place_outlined,
                    size: 22,
                    color: cs.primary,
                  ),
                ),
              ),

              const SizedBox(width: AppDimensions.space12),

              // ── Text column ───────────────────────────────────────────
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (poi.distanceMeters != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          _distanceLabel().trim(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppDimensions.space4),
                      Wrap(
                        spacing: AppDimensions.space4,
                        runSpacing: AppDimensions.space4,
                        children: [
                          ..._badgeLabels().map(
                            (label) => _AttributeBadge(
                              label: label,
                              cs: cs,
                              theme: theme,
                            ),
                          ),
                          if (poi.verifiedCount > 0)
                            _VerifiedBadge(
                              count: poi.verifiedCount,
                              cs: cs,
                              theme: theme,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Chevron ───────────────────────────────────────────────
              ExcludeSemantics(
                child: Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small badge chip for a single accessibility attribute.
class _AttributeBadge extends StatelessWidget {
  const _AttributeBadge({
    required this.label,
    required this.cs,
    required this.theme,
  });

  final String label;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: cs.onSecondaryContainer,
        ),
      ),
    );
  }
}

/// "✓ N verified" badge.
class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({
    required this.count,
    required this.cs,
    required this.theme,
  });

  final int count;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 10, color: cs.tertiary),
          const SizedBox(width: 2),
          Text(
            '$count verified',
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onTertiaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
