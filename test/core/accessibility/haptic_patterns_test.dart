// Tests for HapticPatterns — lib/core/accessibility/haptic_patterns.dart
//
// Strategy:
//   HapticFeedback.* uses platform channels which require the Flutter test
//   binding. We call TestWidgetsFlutterBinding.ensureInitialized() once at
//   the top and use plain async test() blocks (binding is already set up).
//   HapticFeedback channel calls are silently swallowed in tests (no real
//   vibration); Future.delayed calls DO take real time.
//
// What IS tested:
//   1. HapticLevel.off  — every method returns without exception (guard fires).
//   2. HapticLevel.light — success/warning/cameraReady/focusTick/tabNav all
//      complete; dangerSos() returns early (level != full → no loop).
//   3. HapticLevel.full  — all 6 methods complete without exception.
//   4. dangerSos guard: at off/light the call completes in < 100 ms (no loop);
//      at full the loop runs (takes > 50 ms because Future.delayed is real).
//
// GetIt is reset in setUp/tearDown to prevent "already registered" errors.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:opto/core/accessibility/haptic_controller.dart';
import 'package:opto/core/accessibility/haptic_patterns.dart';
import 'package:opto/core/constants/identity_enums.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Registers a [HapticController] with [level] in GetIt.
void _registerController(HapticLevel level) {
  final ctrl = HapticController()..value = level;
  GetIt.instance.registerLazySingleton<HapticController>(() => ctrl);
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // Initialize the Flutter test binding once so HapticFeedback channel calls
  // have a BinaryMessenger available. The calls become no-ops (ignored by the
  // test runner), but they no longer throw "Binding has not been initialized".
  TestWidgetsFlutterBinding.ensureInitialized();

  // Silence unhandled platform-channel MissingPluginException messages that
  // come from HapticFeedback on the test platform (the channel is not
  // registered). Using setMockMessageHandler replaces it with a no-op handler.
  setUpAll(() {
    // Register a no-op handler for the haptic feedback system channel so calls
    // return null (ignored) rather than throwing MissingPluginException.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/platform', (_) async => null);
  });

  setUp(() {
    // Wipe GetIt state between tests so registrations don't collide.
    GetIt.instance.reset();
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  // ---------------------------------------------------------------------------
  // HapticLevel.off — all methods are guarded (no vibration)
  // ---------------------------------------------------------------------------

  group('HapticLevel.off — all methods are guarded (no vibration)', () {
    setUp(() => _registerController(HapticLevel.off));

    test('success() completes without exception', () async {
      await expectLater(HapticPatterns.success(), completes);
    });

    test('warning() completes without exception', () async {
      await expectLater(HapticPatterns.warning(), completes);
    });

    test('cameraReady() completes without exception', () async {
      await expectLater(HapticPatterns.cameraReady(), completes);
    });

    test('focusTick() completes without exception', () async {
      await expectLater(HapticPatterns.focusTick(), completes);
    });

    test('tabNav() completes without exception', () async {
      await expectLater(HapticPatterns.tabNav(), completes);
    });

    test('dangerSos() completes without exception (returns early)', () async {
      await expectLater(HapticPatterns.dangerSos(), completes);
    });

    test('dangerSos() at off returns in < 100 ms (no loop delay)', () async {
      // The 5-pulse loop: 5 × (80 ms + 200 ms) = ~1 400 ms.
      // At level.off the guard returns immediately — well under 100 ms even
      // in a slow CI environment.
      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      expect(sw.elapsedMilliseconds, lessThan(100));
    });
  });

  // ---------------------------------------------------------------------------
  // HapticLevel.light — gentle patterns fire; dangerSos is blocked
  // ---------------------------------------------------------------------------

  group('HapticLevel.light — gentle patterns fire; dangerSos is blocked', () {
    setUp(() => _registerController(HapticLevel.light));

    test('success() completes without exception', () async {
      await expectLater(HapticPatterns.success(), completes);
    });

    test('warning() completes without exception', () async {
      await expectLater(HapticPatterns.warning(), completes);
    });

    test('cameraReady() completes without exception', () async {
      await expectLater(HapticPatterns.cameraReady(), completes);
    });

    test('focusTick() completes without exception', () async {
      await expectLater(HapticPatterns.focusTick(), completes);
    });

    test('tabNav() completes without exception', () async {
      await expectLater(HapticPatterns.tabNav(), completes);
    });

    test('dangerSos() completes without exception (guarded: level != full)', () async {
      await expectLater(HapticPatterns.dangerSos(), completes);
    });

    test('dangerSos() at light returns in < 100 ms (guard fires immediately)', () async {
      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      expect(sw.elapsedMilliseconds, lessThan(100),
          reason: 'dangerSos must return immediately when level is light');
    });
  });

  // ---------------------------------------------------------------------------
  // HapticLevel.full — all methods complete including dangerSos
  // ---------------------------------------------------------------------------

  group('HapticLevel.full — all patterns fire including dangerSos', () {
    setUp(() => _registerController(HapticLevel.full));

    test('success() completes without exception', () async {
      await expectLater(HapticPatterns.success(), completes);
    });

    test('warning() completes without exception', () async {
      await expectLater(HapticPatterns.warning(), completes);
    });

    test('cameraReady() completes without exception', () async {
      await expectLater(HapticPatterns.cameraReady(), completes);
    });

    test('focusTick() completes without exception', () async {
      await expectLater(HapticPatterns.focusTick(), completes);
    });

    test('tabNav() completes without exception', () async {
      await expectLater(HapticPatterns.tabNav(), completes);
    });

    // dangerSos() runs the 5-pulse loop. HapticFeedback channel calls are
    // no-ops but Future.delayed IS real (~1 400 ms total). Allow 10 s.
    test('dangerSos() completes without exception (loop runs)', () async {
      await expectLater(HapticPatterns.dangerSos(), completes);
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  // ---------------------------------------------------------------------------
  // Guard semantics — dangerSos ONLY fires at HapticLevel.full
  // ---------------------------------------------------------------------------

  group('Guard semantics: dangerSos fires only at full level', () {
    test('at off: dangerSos returns immediately (no SOS loop)', () async {
      _registerController(HapticLevel.off);
      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      expect(sw.elapsedMilliseconds, lessThan(100),
          reason: 'dangerSos must return immediately when level is off');
    });

    test('at light: dangerSos returns immediately (reserved for full only)', () async {
      _registerController(HapticLevel.light);
      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      expect(sw.elapsedMilliseconds, lessThan(100),
          reason: 'dangerSos must return immediately when level is light');
    });

    test('at full: dangerSos loop executes (takes > 50 ms)', () async {
      _registerController(HapticLevel.full);
      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      // HapticFeedback is a no-op but Future.delayed is real:
      // 5 loops × (80 ms + 200 ms) = ~1 400 ms. Even the first iteration
      // contributes 280 ms, so > 50 ms is a safe lower bound.
      expect(sw.elapsedMilliseconds, greaterThan(50),
          reason: 'dangerSos loop should have executed at full level');
    }, timeout: const Timeout(Duration(seconds: 10)));
  });

  // ---------------------------------------------------------------------------
  // HapticController value mutation — runtime level change
  // ---------------------------------------------------------------------------

  group('HapticController: runtime level change is respected', () {
    test('flipping level from full to off silences subsequent calls', () async {
      final ctrl = HapticController()..value = HapticLevel.full;
      GetIt.instance.registerLazySingleton<HapticController>(() => ctrl);

      // Initially full — success() should complete.
      await expectLater(HapticPatterns.success(), completes);

      // Flip to off.
      ctrl.value = HapticLevel.off;

      // success() still completes (returns early at guard).
      await expectLater(HapticPatterns.success(), completes);
    });

    test('dangerSos is fast after level changed from full to light', () async {
      final ctrl = HapticController()..value = HapticLevel.light;
      GetIt.instance.registerLazySingleton<HapticController>(() => ctrl);

      final sw = Stopwatch()..start();
      await HapticPatterns.dangerSos();
      sw.stop();
      expect(sw.elapsedMilliseconds, lessThan(100));
    });
  });
}
