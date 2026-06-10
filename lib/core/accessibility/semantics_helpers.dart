import 'package:flutter/material.dart';

/// Wraps [child] with [ExcludeSemantics] — use for purely decorative elements.
Widget decorative({required Widget child}) => ExcludeSemantics(child: child);

/// Wraps [child] as a live-region that auto-announces changes.
///
/// Use for dynamic status areas (Vision AI result, error messages, SOS status).
Widget liveRegion({required Widget child, String? label}) {
  return Semantics(
    liveRegion: true,
    label: label,
    child: child,
  );
}

/// Annotates [child] as a page/section header.
Widget heading({required Widget child}) {
  return Semantics(header: true, child: child);
}
