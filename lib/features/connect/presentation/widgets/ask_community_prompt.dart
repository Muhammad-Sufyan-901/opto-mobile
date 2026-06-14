import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

class AskCommunityPrompt extends StatelessWidget {
  const AskCommunityPrompt({
    super.key,
    required this.onTap,
    required this.onMicTap,
    this.avatarName = 'You',
  });

  final VoidCallback onTap;
  final VoidCallback onMicTap;
  final String avatarName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    // AppExtendedCustomColors has no `line2` field;
    // fall back to Material ColorScheme.outlineVariant.
    final line2 = ext?.divider ?? cs.outlineVariant;
    final ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return Semantics(
      label: 'Ask the community a question or share a win',
      button: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: line2,
              width: 2,
              // Note: Flutter doesn't support dashed borders natively;
              // using a solid slightly lighter border to approximate.
            ),
          ),
          child: Row(
            children: [
              // User avatar (initials placeholder)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  avatarName.isNotEmpty ? avatarName[0].toUpperCase() : 'Y',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Ask a question or share a win…',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: ink3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Semantics(
                label: 'Record voice message',
                button: true,
                onTap: onMicTap,
                child: GestureDetector(
                  onTap: onMicTap,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child:
                        const Icon(Icons.mic_outlined, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
