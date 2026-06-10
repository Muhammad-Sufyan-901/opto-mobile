import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';

/// Screen 16 — Vision AI Camera Viewfinder.
///
/// A full-bleed dark camera UI that lets blind/low-vision users point their
/// device camera at the world and get audio readouts via Aura AI.
/// Spec: `ScreenVisionAI` / artboard "16 · Vision AI" in the Opto design
/// handoff ("Destinations" section).
///
/// Layout (top → bottom):
///   1. Top bar — close (×) · "Vision AI" title · flash toggle
///   2. Viewfinder reticle — 4-corner L-bracket framing guide
///   3. Readout pill — glassy live-region card with last AI result
///   4. Mode chips — Read text / Identify / Describe scene / Colors
///   5. Shutter row — gallery · shutter · mic
///
/// Accessibility:
///   - Screen announced on mount: "Vision AI. Point your camera to read text,
///     identify objects, or describe scenes." (design_system.md §21.3).
///   - Readout pill is a `liveRegion` so TalkBack/VoiceOver reads new results.
///   - Reticle is decorative — wrapped in `ExcludeSemantics`.
///   - All interactive elements carry descriptive `Semantics` labels.
///   - Tap targets ≥ 48×48 dp (design_system.md §9).
///
/// State: presentation-only (StatefulWidget + setState). Camera preview and
/// Aura AI integration are `⛔ Planned` — replaced here by a static dark
/// background with `TODO` markers.
class VisionAiScreen extends StatefulWidget {
  const VisionAiScreen({super.key});

  @override
  State<VisionAiScreen> createState() => _VisionAiScreenState();
}

class _VisionAiScreenState extends State<VisionAiScreen> {
  /// Currently active analysis mode index (0 = "Read text").
  int _activeMode = 0;

  /// Mode labels shown in the horizontal chip row.
  static const List<String> _modes = [
    'Read text',
    'Identify',
    'Describe scene',
    'Colors',
  ];

  @override
  void initState() {
    super.initState();
    // Announce a concise one-line summary on arrival (design_system.md §21.3).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(
        context,
        'Vision AI. Point your camera to read text, identify objects, or describe scenes.',
      );
    });
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home.path);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1422),
      extendBodyBehindAppBar: true,
      body: Container(
        // Radial gradient gives the dark navy "camera viewfinder" atmosphere.
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [Color(0xFF1B2640), Color(0xFF0A0F1C)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top bar ────────────────────────────────────────────────
              _TopBar(onClose: _close),

              // ── 2–5. Camera body (reticle + readout + chips + shutter) ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Push reticle toward the upper portion of the remaining space.
                    const Spacer(),

                    // ── 2. Viewfinder reticle ────────────────────────────
                    const Center(child: _ViewfinderReticle()),

                    // Flexible gap between reticle and bottom controls.
                    const Spacer(),

                    // ── 3. Readout pill ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18) // design spec: 18dp
                          .copyWith(bottom: AppDimensions.space16),
                      child: _ReadoutPill(primaryColor: cs.primary),
                    ),

                    // ── 4. Mode chips ────────────────────────────────────
                    _ModeChipRow(
                      modes: _modes,
                      activeIndex: _activeMode,
                      onSelect: (i) => setState(() => _activeMode = i),
                    ),

                    // ── 5. Shutter row ────────────────────────────────────
                    const _ShutterRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

/// Top bar: close × | "Vision AI" title | flash toggle.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: AppDimensions.space12), // design spec: 18dp horizontal
      child: Row(
        children: [
          // Close button.
          Semantics(
            button: true,
            label: 'Close Vision AI',
            child: GestureDetector(
              onTap: onClose,
              child: const _DarkCircleButton(child: Icon(Icons.close, color: Colors.white, size: 22)),
            ),
          ),

          // Center title — expands to fill available space.
          const Expanded(
            child: Text(
              'Vision AI',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Flash toggle button.
          Semantics(
            button: true,
            label: 'Toggle flash',
            child: GestureDetector(
              onTap: () {
                // TODO(vision-ai): toggle camera flash via CameraController.
              },
              child: const _DarkCircleButton(child: Icon(Icons.bolt, color: Colors.white, size: 22)),
            ),
          ),
        ],
      ),
    );
  }
}

/// A 48×48 translucent dark circle used for icon buttons in the top bar.
class _DarkCircleButton extends StatelessWidget {
  const _DarkCircleButton({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Decorative 4-corner L-bracket reticle (200×130).
///
/// The corners are painted as `Container`s with selective `Border` sides.
/// Wrapped in `ExcludeSemantics` — purely decorative.
class _ViewfinderReticle extends StatelessWidget {
  const _ViewfinderReticle();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 200,
        height: 130,
        child: Stack(
          children: [
            // Top-left corner.
            Positioned(
              top: 0,
              left: 0,
              child: _Corner(
                topBorder: true,
                leftBorder: true,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(4)),
              ),
            ),
            // Top-right corner.
            Positioned(
              top: 0,
              right: 0,
              child: _Corner(
                topBorder: true,
                rightBorder: true,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(4)),
              ),
            ),
            // Bottom-left corner.
            Positioned(
              bottom: 0,
              left: 0,
              child: _Corner(
                bottomBorder: true,
                leftBorder: true,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(4)),
              ),
            ),
            // Bottom-right corner.
            Positioned(
              bottom: 0,
              right: 0,
              child: _Corner(
                bottomBorder: true,
                rightBorder: true,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single L-shaped corner bracket for the viewfinder reticle.
class _Corner extends StatelessWidget {
  const _Corner({
    this.topBorder = false,
    this.bottomBorder = false,
    this.leftBorder = false,
    this.rightBorder = false,
    required this.borderRadius,
  });

  final bool topBorder;
  final bool bottomBorder;
  final bool leftBorder;
  final bool rightBorder;
  final BorderRadius borderRadius;

  static const Color _color = Color(0xFF78AAFF);
  static const double _size = 30;
  static const double _width = 3;

  BorderSide get _active => const BorderSide(color: _color, width: _width);
  BorderSide get _none => BorderSide.none;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: Border(
          top: topBorder ? _active : _none,
          bottom: bottomBorder ? _active : _none,
          left: leftBorder ? _active : _none,
          right: rightBorder ? _active : _none,
        ),
        borderRadius: borderRadius,
      ),
    );
  }
}

/// Glassy pill showing the latest AI readout as a live region.
///
/// Row: blue circle with volume icon | result text.
/// TODO(vision-ai): replace static text with a BLoC stream of VisionAiResult.
class _ReadoutPill extends StatelessWidget {
  const _ReadoutPill({required this.primaryColor});

  final Color primaryColor;

  static const String _readoutText =
      'Bank Mandiri — Jl. Sudirman No. 12. Open until 15:00.';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Read aloud: $_readoutText',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space12, vertical: AppDimensions.space12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Blue icon circle.
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.volume_up, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            // Readout text — expands to fill remaining space.
            const Expanded(
              child: Text(
                _readoutText,
                style: TextStyle(
                  color: Color(0xFFF2F6FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable row of analysis-mode chips.
class _ModeChipRow extends StatelessWidget {
  const _ModeChipRow({
    required this.modes,
    required this.activeIndex,
    required this.onSelect,
  });

  final List<String> modes;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: AppDimensions.space16), // design spec: 18dp horizontal
      child: Row(
        children: [
          for (int i = 0; i < modes.length; i++) ...[
            _ModeChip(
              label: modes[i],
              isActive: i == activeIndex,
              primaryColor: cs.primary,
              onTap: () => onSelect(i),
            ),
            if (i < modes.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

/// A single analysis-mode chip (active = blue; inactive = glass).
class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isActive,
    required this.primaryColor,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: '$label mode${isActive ? ", selected" : ""}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space12, vertical: AppDimensions.space8),
          decoration: BoxDecoration(
            color: isActive ? primaryColor : Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.70),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom shutter row: gallery · shutter · mic.
class _ShutterRow extends StatelessWidget {
  const _ShutterRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: AppDimensions.space24), // design spec: 36dp horizontal shutter padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: gallery / document button.
          Semantics(
            button: true,
            label: 'Open gallery',
            child: GestureDetector(
              onTap: () {
                // TODO(vision-ai): open image picker for gallery-based analysis.
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.article_outlined, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Center: shutter button (white bordered ring → white filled disc).
          Semantics(
            button: true,
            label: 'Capture photo',
            child: GestureDetector(
              onTap: () {
                // TODO(vision-ai): trigger camera capture via CameraController.
              },
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // Right: mic button.
          Semantics(
            button: true,
            label: 'Open voice commands',
            child: GestureDetector(
              onTap: () {
                // TODO(vision-ai): open Aura Voice command sheet.
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.mic, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
