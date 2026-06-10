import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/widgets/buttons/app_button.dart';
import 'package:opto/features/onboarding/data/models/welcome_slide_data.dart';
import 'package:opto/features/onboarding/presentation/widgets/page_dots.dart';
import 'package:opto/features/onboarding/presentation/widgets/welcome_slide.dart';

/// Three-slide Welcome intro carousel (screens 02–04 in the design canvas).
///
/// Spec: `WelcomeSlide` / `.scr-welcome` in `Opto Onboarding.html`.
///
/// State: [PageController] + current index via [setState] (localised UI
/// state — allowed by CLAUDE.md for non-business-logic toggles).
///
/// Accessibility:
///   - "Skip" button has a minimum tap target of 48dp.
///   - Page change announces "<title>. Step X of 3" via a live region.
///   - Dots are [ExcludeSemantics]; dots' information is in the live announcement.
///   - Tap targets: Skip ≥ 48dp via [TextButton] style; primary CTA = 60dp.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  static const List<WelcomeSlideData> _slides = kWelcomeSlides;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextOrFinish() {
    if (_slides[_currentIndex].isLast) {
      _skip();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() => context.go(AppRoutes.login.path);

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);

    // Announce slide change for screen readers.
    SemanticsService.sendAnnouncement(
      View.of(context),
      '${_slides[index].title}. Step ${index + 1} of ${_slides.length}',
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final WelcomeSlideData current = _slides[_currentIndex];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Skip row ─────────────────────────────────
            SizedBox(
              height: 54,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Semantics(
                    button: true,
                    label: 'Skip intro',
                    child: TextButton(
                      onPressed: _skip,
                      style: TextButton.styleFrom(
                        minimumSize:
                            const Size(AppDimensions.minTapTarget, AppDimensions.minTapTarget),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        textStyle: const TextStyle(
                          fontFamily: 'Atkinson Hyperlegible',
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),
              ),
            ),

            // ── Slide pages ───────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return WelcomeSlide(data: _slides[index]);
                },
              ),
            ),

            // ── Footer: dots + CTA button ─────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.screenPadding,
                AppDimensions.space16,
                AppDimensions.screenPadding,
                AppDimensions.space24,
              ),
              child: Column(
                children: [
                  // Dot indicator — page position announced by live region.
                  PageDots(
                    count: _slides.length,
                    activeIndex: _currentIndex,
                  ),

                  const SizedBox(height: AppDimensions.space24),

                  // Primary CTA button.
                  Semantics(
                    button: true,
                    label: current.isLast ? 'Get started' : 'Next',
                    child: AppButton.primary(
                      text: current.isLast ? 'Get started' : 'Next',
                      onPressed: _goToNextOrFinish,
                      isFullWidth: true,
                      suffixIcon: Icons.arrow_forward,
                      height: AppDimensions.buttonHeight,
                      radius: AppDimensions.radiusButton,
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
