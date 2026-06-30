// Widget: ConsultChatBubble
//
// A single chat message bubble in the consultation text-chat screen.
// Right-aligned for user messages (fromMe = true), left-aligned for
// doctor messages (fromMe = false).
//
// Adapted from lib/features/prosthetic_hub/presentation/widgets/chat_bubble.dart
// (cross-feature imports are forbidden; this is a deliberate local copy
// adapted for ConsultationMessageEntity and doctor-specific semantics).
import 'package:flutter/material.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/consultation/domain/entities/consultation_message_entity.dart';

/// Displays a [ConsultationMessageEntity] as an accessible chat bubble.
///
/// Semantics label:
/// "{You|Doctor}: {body}. Sent at {HH:mm}."
class ConsultChatBubble extends StatelessWidget {
  const ConsultChatBubble({
    super.key,
    required this.message,
    required this.fromMe,
  });

  /// The message to display.
  final ConsultationMessageEntity message;

  /// True if the current user sent this message; false if the doctor sent it.
  final bool fromMe;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final String timeLabel = _timeLabel(message.createdAt);

    // Colors — mirrors the prosthetic hub ChatBubble palette.
    final Color bubbleColor =
        fromMe ? cs.primary : (ext?.blueTint ?? cs.surfaceContainerHighest);
    final Color textColor = fromMe ? Colors.white : cs.onSurface;
    final Color timeColor = fromMe
        ? Colors.white.withValues(alpha: 0.75)
        : (ext?.ink3 ?? cs.onSurfaceVariant);

    // Border radii: flat on the sending-side bottom corner.
    final BorderRadius radius = fromMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusCard),
            topRight: Radius.circular(AppDimensions.radiusCard),
            bottomLeft: Radius.circular(AppDimensions.radiusCard),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.radiusCard),
            topRight: Radius.circular(AppDimensions.radiusCard),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(AppDimensions.radiusCard),
          );

    final String semanticsLabel =
        '${fromMe ? "You" : "Doctor"}: ${message.body}.'
        ' Sent at $timeLabel.';

    return Semantics(
      label: semanticsLabel,
      child: Align(
        alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.72,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: AppDimensions.space4,
            horizontal: AppDimensions.space16,
          ),
          child: Column(
            crossAxisAlignment:
                fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Bubble ───────────────────────────────────────────────────
              ExcludeSemantics(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: radius,
                  ),
                  child: Text(
                    message.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              // ── Time label ───────────────────────────────────────────────
              ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppDimensions.space2,
                    left: AppDimensions.space4,
                    right: AppDimensions.space4,
                  ),
                  child: Text(
                    timeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: timeColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats [sentAt] as "HH:mm" (24-hour).
  static String _timeLabel(DateTime sentAt) {
    final local = sentAt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
