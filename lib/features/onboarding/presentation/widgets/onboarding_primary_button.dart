import 'package:flutter/material.dart';

import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';

class OnboardingPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const OnboardingPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(150),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: AppButton.primary(
        text: text,
        radius: 150,
        onPressed: onPressed,
        isFullWidth: true,
      ),
    );
  }
}
