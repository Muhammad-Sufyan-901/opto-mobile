import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/config/app_info.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/core/widgets/buttons/app_button.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sudah Punya Akun? ',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            AppButton.link(
              text: 'Masuk',
              onPressed: () => context.go(AppRoutes.login.path),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        if (AppInfo.isDevelopment)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Anda Pengembang? ',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),

              AppButton.link(
                text: 'Testing Widgets',
                onPressed: () => context.go(AppRoutes.developer.path),
              ),
            ],
          ),
      ],
    );
  }
}
