import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

class PinnedNote extends StatelessWidget {
  const PinnedNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final blueTint = ext?.blueTint ?? cs.primaryContainer;
    final line = ext?.line ?? cs.outline;

    return Semantics(
      label: 'Pinned note: $note',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: line, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.push_pin_outlined, color: cs.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PINNED',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
