import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';

import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/features/onboarding/presentation/widgets/opto_brand_mark.dart';

/// First screen the user sees on fresh launch.
///
/// Spec: `ScreenSplash` / `.scr-splash` in `Opto Onboarding.html`.
///   - Background: `colorScheme.primary` (--blue)
///   - Centred: [OptoBrandMark] + "Opto" wordmark + tagline
///   - Footer pinned 34dp from bottom: loading dots + caption
///
/// Accessibility: announces the brand tagline via a live-region on first
/// frame so screen-reader users hear it before auto-navigation fires.
///
/// Auto-advances to [WelcomeScreen] (path: `/onboarding`) after 2.2 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Announce the brand tagline on the first rendered frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Opto. Your world, made clear.');
    });

    // Auto-navigate to the Welcome carousel.
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) context.go(AppRoutes.onboarding.path);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Centred brand content ──────────────────────
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand mark: translucent square + aperture icon.
                  const OptoBrandMark(),

                  const SizedBox(height: 28),

                  // Wordmark "Opto" — 48px bold white.
                  Text(
                    'Opto',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                  ),

                  const SizedBox(height: 6),

                  // Tagline — ~19px white @ .88
                  Text(
                    'Your world, made clear.',
                    style: const TextStyle(
                      fontFamily: 'Atkinson Hyperlegible',
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: Colors.white,
                    ).copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),

            // ── Pinned footer ─────────────────────────────
            Positioned(
              bottom: 34,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Loading dots: 3 small circles, middle one brighter.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LoadingDot(opacity: 0.5),
                      const SizedBox(width: 8),
                      _LoadingDot(opacity: 0.8),
                      const SizedBox(width: 8),
                      _LoadingDot(opacity: 0.5),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Footer caption — excludes from semantics (visual-only).
                  ExcludeSemantics(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        'Designed for blind, low-vision & prosthetic users',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Atkinson Hyperlegible',
                          fontSize: 13.5,
                          height: 1.5,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
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

/// A small white dot used in the splash loading indicator.
class _LoadingDot extends StatelessWidget {
  const _LoadingDot({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
