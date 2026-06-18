import 'package:flutter/material.dart';

/// A Material-3-style toggle switch matching the design mock (CSS: `.pr-switch`).
///
/// Wraps [Switch] with full [Semantics] (toggled state + descriptive label)
/// so TalkBack announces "On/Off, toggle button" automatically.
///
/// [value] is the current on/off state.
/// [onChanged] is called with the new state when toggled.
/// [label] is used as the semantic label prefix (e.g. "TalkBack").
class ProfileSwitch extends StatelessWidget {
  const ProfileSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Semantics(
      toggled: value,
      label: '$label ${value ? "on" : "off"}, toggle button',
      child: ExcludeSemantics(
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: cs.primary,
        ),
      ),
    );
  }
}
