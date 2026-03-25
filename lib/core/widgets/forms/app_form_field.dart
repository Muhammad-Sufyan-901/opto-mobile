import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  final String label;
  final Widget child;
  final String? description;
  final String? errorText;
  final bool isRequired;

  const AppFormField({
    super.key,
    required this.label,
    required this.child,
    this.description,
    this.errorText,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. LABEL & REQUIRED ASTERISK
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: errorText != null
                    ? Colors.red.shade600
                    : theme.colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '*',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        // 2. THE INPUT COMPONENT (Child)
        child,

        // 3. DESCRIPTION TEXT (Optional)
        if (description != null && errorText == null) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
            ),
          ),
        ],

        // 4. ERROR TEXT (Optional, Prioritized over description)
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.red.shade600,
            ),
          ),
        ],
      ],
    );
  }
}
