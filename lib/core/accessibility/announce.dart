import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Announces [message] to the active screen reader (TalkBack / VoiceOver).
///
/// Wraps [SemanticsService.sendAnnouncement] — the current [BuildContext]
/// is required to obtain the [FlutterView] via [View.of].
///
/// Usage:
/// ```dart
/// announce(context, 'SOS sent. Help is on the way.');
/// ```
void announce(
  BuildContext context,
  String message, {
  TextDirection direction = TextDirection.ltr,
}) {
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    direction,
  );
}
