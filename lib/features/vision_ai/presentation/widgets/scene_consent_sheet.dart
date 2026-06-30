import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:opto/core/accessibility/accessibility.dart';

/// One-time UU PDP consent sheet shown before the first cloud scene-description
/// call when running on the Gemini free plan.
///
/// The sheet explains that the camera frame will be sent to Google's Gemini
/// API and may be used to improve models (free-tier training policy). The user
/// must tap **"Setuju / Agree"** explicitly before the cloud call proceeds.
/// Cancelling or dismissing the sheet keeps the on-device fallback active.
///
/// **Persistence:** the consent decision is stored as a `bool` under
/// [_consentKey] in the `settings_box` Hive box opened by [HiveClient.init()],
/// following the same pattern as [AccessibilitySettingsRepositoryImpl].
///
/// **Accessibility:**
/// - All interactive elements have descriptive [Semantics] labels.
/// - Agree / Cancel buttons meet the 48×48 dp minimum tap-target requirement.
/// - On sheet display, a live-region announcement is made so screen readers
///   don't miss it appearing.
/// - Copy is bilingual (Bahasa Indonesia first, English second).
class SceneConsentSheet extends StatelessWidget {
  const SceneConsentSheet._();

  /// Hive key under `settings_box` — versioned so a future policy change can
  /// prompt re-consent by bumping the suffix.
  static const String consentKey = 'vision_scene_consent_v1';

  // ---------------------------------------------------------------------------
  // Static helpers
  // ---------------------------------------------------------------------------

  /// Returns `true` if the user has already accepted the consent.
  static bool hasConsented(Box<dynamic> box) {
    return box.get(consentKey) == true;
  }

  /// Persists the consent decision.
  static Future<void> persistConsent(Box<dynamic> box) async {
    await box.put(consentKey, true);
  }

  /// Presents the consent sheet and returns `true` if the user agrees,
  /// `false` if they cancel or dismiss the sheet.
  ///
  /// Announces its own presence to the screen reader so blind users know
  /// the sheet has appeared without relying on focus to move there.
  static Future<bool> show(BuildContext context) async {
    // Announce sheet presence before showing (belt-and-suspenders with
    // modalBarrierSemantics — some screen readers miss the latter on Android).
    announce(
      context,
      'Izin diperlukan untuk deskripsi adegan. '
      'Permission required for scene description.',
    );

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SceneConsentSheet._(),
    );
    return result == true;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return Semantics(
      // Announce as a dialog/alertdialog so TalkBack navigates into it.
      container: true,
      explicitChildNodes: true,
      child: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: mediaQuery.viewInsets.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Drag handle ───────────────────────────────────────────────
                ExcludeSemantics(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // ── Icon ──────────────────────────────────────────────────────
                ExcludeSemantics(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.privacy_tip_outlined,
                      color: colorScheme.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Title ─────────────────────────────────────────────────────
                Semantics(
                  header: true,
                  child: Text(
                    'Izin Data Kamera\nCamera Data Permission',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Body ──────────────────────────────────────────────────────
                Text(
                  'Untuk mendeskripsikan adegan, gambar kamera Anda akan '
                  'dikirim ke layanan AI Google (Gemini) melalui server Opto.\n\n'
                  'To describe scenes, your camera frame will be sent to '
                  'Google\'s AI service (Gemini) via the Opto server.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '⚠  Pada paket gratis, Google dapat menggunakan data ini '
                  'untuk meningkatkan model AI-nya (kebijakan Google AI).\n\n'
                  '⚠  On the free plan, Google may use this data to improve '
                  'its AI models (Google AI policy).',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Buttons ───────────────────────────────────────────────────
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Batalkan. Cancel. '
                            'Scene description will use on-device fallback.',
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Batal / Cancel'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Agree
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Setuju. Agree. '
                            'I understand my camera frame will be sent to '
                            'Google Gemini and may be used to improve its models.',
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Setuju / Agree'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
