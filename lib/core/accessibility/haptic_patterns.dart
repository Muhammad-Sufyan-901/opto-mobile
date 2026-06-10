import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'package:opto/core/accessibility/haptic_controller.dart';
import 'package:opto/core/constants/identity_enums.dart';

/// Canonical haptic-feedback catalog for Opto.
///
/// All methods are static and gate on the current [HapticLevel] from
/// [HapticController] (registered in GetIt). Feature code must call these
/// instead of raw [HapticFeedback] methods so that the user's preference
/// is always respected.
///
/// Level semantics:
/// - [HapticLevel.off]   — no vibration at all.
/// - [HapticLevel.light] — gentle patterns only (success, cameraReady,
///   focusTick, tabNav, warning).
/// - [HapticLevel.full]  — all patterns including the reserved [dangerSos].
class HapticPatterns {
  HapticPatterns._();

  static HapticLevel get _level => GetIt.instance<HapticController>().level;

  /// Light single tap — success confirmation (e.g., OTP verified, form saved).
  static Future<void> success() async {
    if (_level == HapticLevel.off) return;
    await HapticFeedback.lightImpact();
  }

  /// Double medium tap — warning / destructive action confirmation.
  static Future<void> warning() async {
    if (_level == HapticLevel.off) return;
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.mediumImpact();
  }

  /// Selection click — camera viewfinder acquired focus.
  static Future<void> cameraReady() async {
    if (_level == HapticLevel.off) return;
    await HapticFeedback.selectionClick();
  }

  /// Selection click — accessibility focus moved to a new element.
  static Future<void> focusTick() async {
    if (_level == HapticLevel.off) return;
    await HapticFeedback.selectionClick();
  }

  /// Selection click — bottom-nav tab change.
  static Future<void> tabNav() async {
    if (_level == HapticLevel.off) return;
    await HapticFeedback.selectionClick();
  }

  /// Long pulsing danger pattern.
  ///
  /// **Reserved exclusively for Emergency SOS.**
  /// NEVER call this for any other event — it would violate
  /// `design_system.md §6` ("danger/SOS pattern … never reused").
  ///
  /// Only fires when [HapticLevel] is [HapticLevel.full].
  static Future<void> dangerSos() async {
    if (_level != HapticLevel.full) return;
    for (var i = 0; i < 5; i++) {
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.heavyImpact();
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }
}
