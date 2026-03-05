import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ids_elder_rehab_app/core/config/app_info.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_hero.dart';
import 'package:ids_elder_rehab_app/features/onboarding/presentation/widgets/onboarding_primary_button.dart';

void main() {
  // ➔ ✨ Setup wrapper standar untuk merender widget dengan Theme
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: OnboardingScreen(),
      ),
    );
  }

  group('OnboardingScreen Widget Tests', () {
    // Kembalikan state default sebelum setiap tes dijalankan
    setUp(() {
      // Simulasi aplikasi sedang berjalan di mode Production
      AppInfo.mockEnvironment = EnvironmentMode.production;
    });

    testWidgets('Merender komponen utama Onboarding Screen dengan benar', (
      WidgetTester tester,
    ) async {
      // 1. Build widget-nya
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Tunggu animasi selesai

      // 2. Verifikasi Hero Section (Gambar & Background)
      expect(find.byType(OnboardingHero), findsOneWidget);

      // 3. Verifikasi Teks Slogan Utama
      expect(find.text('Rehabilitasi Fisik\nUntuk Lansia'), findsOneWidget);

      // 4. Verifikasi Primary Button
      expect(find.byType(OnboardingPrimaryButton), findsOneWidget);
      expect(find.text('Mulai Sekarang'), findsOneWidget);

      // 5. Verifikasi Footer Utama (Sudah Punya Akun?)
      expect(find.byType(OnboardingFooter), findsOneWidget);
      expect(find.text('Sudah Punya Akun? '), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);
    });
  });

  // ==========================================
  // ➔ ✨ TEST KHUSUS KEAMANAN RUTE DEV (ENVIRONMENTAL TEST)
  // ==========================================
  group('OnboardingFooter Environment Tests', () {
    Widget createFooterUnderTest() {
      return const MaterialApp(
        home: Scaffold(
          body: OnboardingFooter(),
        ),
      );
    }

    testWidgets('TIDAK menampilkan link Developer di mode Production', (
      WidgetTester tester,
    ) async {
      // Set environment ke Production
      AppInfo.mockEnvironment = EnvironmentMode.production;

      await tester.pumpWidget(createFooterUnderTest());

      // Pastikan link "Masuk" (publik) tetap ada
      expect(find.text('Sudah Punya Akun? '), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);

      // ➔ ✨ KUNCI KEAMANAN: Pastikan link Dev tidak bocor ke publik!
      expect(find.text('Anda Pengembang? '), findsNothing);
      expect(find.text('Testing Widgets'), findsNothing);
    });

    testWidgets('MENAMPILKAN link Developer HANYA di mode Development', (
      WidgetTester tester,
    ) async {
      // Set environment ke Development
      AppInfo.mockEnvironment = EnvironmentMode.development;

      await tester.pumpWidget(createFooterUnderTest());

      // Pastikan link "Masuk" (publik) tetap ada
      expect(find.text('Sudah Punya Akun? '), findsOneWidget);
      expect(find.text('Masuk'), findsOneWidget);

      // ➔ ✨ Pastikan link Dev muncul agar Developer bisa masuk
      expect(find.text('Anda Pengembang? '), findsOneWidget);
      expect(find.text('Testing Widgets'), findsOneWidget);
    });
  });
}
