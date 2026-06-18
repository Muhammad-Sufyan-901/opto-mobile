import 'package:flutter/material.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// A deterministic-color avatar showing a member's initials.
///
/// Uses a 5-color palette derived from the member's [authorId] or [name].
/// Falls back gracefully when [avatarUrl] is present (future image support).
class CommunityAvatar extends StatelessWidget {
  const CommunityAvatar({
    super.key,
    required this.name,
    this.authorId,
    this.avatarUrl,
    this.size = 44.0,
    this.fontSize,
  });

  final String name;
  final String? authorId;
  final String? avatarUrl;
  final double size;
  final double? fontSize;

  /// Returns the 1–2 char initials from [name].
  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  /// Returns a deterministic color index (0–4) from the [seed] string.
  static int _colorIndex(String seed) =>
      seed.codeUnits.fold(0, (a, b) => a + b) % 5;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<AppExtendedCustomColors>();

    // AppExtendedCustomColors has no `violet` field; use hardcoded fallback.
    const violet = Color(0xFF7C3AED);

    final colors = [
      cs.primary,
      violet,
      ext?.green ?? const Color(0xFF16A34A),
      const Color(0xFFE07B39), // amber/orange
      cs.primary,
    ];

    final seed = authorId ?? name;
    final bg = colors[_colorIndex(seed)];
    final label = initials(name);
    final textSize = fontSize ?? size * 0.36;

    return Semantics(
      label: name,
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: textSize,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
