// Tests for the Opto Brand & Welcome first-launch flow.
//
// Covers:
//  - WelcomeScreen renders all three slides via PageView
//  - Dot indicator is present
//  - CTA button label reads "Next" on first slide
//  - SplashScreen renders wordmark and tagline
//  - kWelcomeSlides data integrity

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ids_elder_rehab_app/core/themes/app_themes.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/models/welcome_slide_data.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/page_dots.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/welcome_slide.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child) {
  // Minimal wrapper with the Opto light theme applied; no GoRouter needed
  // since navigation calls in these tests are not exercised.
  return MaterialApp(
    theme: AppThemes.lightTheme,
    home: Scaffold(body: child),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── SplashScreen ─────────────────────────────────────────────────────────

  group('SplashScreen', () {
    testWidgets('renders Opto wordmark and tagline', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const SplashScreen()));

      expect(find.text('Opto'), findsOneWidget);
      expect(find.text('Your world, made clear.'), findsOneWidget);
    });

    testWidgets('renders accessibility footer caption', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const SplashScreen()));
      expect(
        find.text('Designed for blind, low-vision & prosthetic users'),
        findsOneWidget,
      );
    });
  });

  // ── WelcomeScreen ─────────────────────────────────────────────────────────

  group('WelcomeScreen', () {
    testWidgets('shows first slide title on load', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text(kWelcomeSlides[0].title), findsOneWidget);
      expect(find.text(kWelcomeSlides[0].eyebrow), findsOneWidget);
    });

    testWidgets('renders a PageDots indicator', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(PageDots), findsOneWidget);
    });

    testWidgets('CTA reads "Next" on first slide', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Get started'), findsNothing);
    });

    testWidgets('renders at least one WelcomeSlide widget', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(WelcomeSlide), findsWidgets);
    });

    testWidgets('Skip button is present', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const WelcomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });
  });

  // ── kWelcomeSlides data integrity ────────────────────────────────────────

  group('kWelcomeSlides', () {
    test('contains exactly 3 slides', () {
      expect(kWelcomeSlides.length, 3);
    });

    test('only the last slide has isLast == true', () {
      for (int i = 0; i < kWelcomeSlides.length - 1; i++) {
        expect(kWelcomeSlides[i].isLast, isFalse);
      }
      expect(kWelcomeSlides.last.isLast, isTrue);
    });

    test('all slides have non-empty copy', () {
      for (final WelcomeSlideData slide in kWelcomeSlides) {
        expect(slide.eyebrow, isNotEmpty);
        expect(slide.title, isNotEmpty);
        expect(slide.body, isNotEmpty);
        expect(slide.illustrationLabel, isNotEmpty);
      }
    });
  });
}
