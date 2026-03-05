import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_hero.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            // Important: hasScrollBody: false allows Expanded to work in a ScrollView
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==========================================
                // 1. HERO SECTION
                // ==========================================
                const Expanded(
                  flex: 3,
                  child: OnboardingHero(),
                ),

                // ==========================================
                // 2. CONTENT SECTION
                // ==========================================
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Rehabilitasi Fisik\nUntuk Lansia',
                          textAlign: TextAlign.center,
                          style: textTheme.displayMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),

                        OnboardingPrimaryButton(
                          text: 'Mulai Sekarang',
                          onPressed: () => context.go(AppRoutes.login.path),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        const OnboardingFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
