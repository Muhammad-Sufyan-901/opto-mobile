import 'package:flutter/foundation.dart';
import 'package:opto/core/constants/identity_enums.dart';

/// Core-level holder for the user's current haptic-feedback preference.
///
/// Registered as a [GetIt] singleton. [app.dart] pushes updates from
/// [AccessibilitySettingsCubit] into this notifier so [HapticPatterns]
/// can respect the preference without importing [features/].
class HapticController extends ValueNotifier<HapticLevel> {
  HapticController() : super(HapticLevel.full);

  /// Current [HapticLevel]. Update via [value] setter.
  HapticLevel get level => value;
}
