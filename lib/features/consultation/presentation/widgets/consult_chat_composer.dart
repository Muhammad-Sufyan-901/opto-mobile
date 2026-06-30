// Widget: ConsultChatComposer
//
// Text input row at the bottom of the consultation chat screen.
// Calls [onSend] with the trimmed text and clears the field on send.
//
// Adapted from lib/features/prosthetic_hub/presentation/widgets/chat_composer.dart
// (cross-feature imports are forbidden; this is a deliberate local copy).
import 'package:flutter/material.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';

/// Accessible compose row: text field + send button.
///
/// The send button is only enabled when the input is non-empty.
/// Tap targets are ≥48dp.
class ConsultChatComposer extends StatefulWidget {
  const ConsultChatComposer({super.key, required this.onSend});

  /// Called with the trimmed message text when the user taps Send.
  final void Function(String text) onSend;

  @override
  State<ConsultChatComposer> createState() => _ConsultChatComposerState();
}

class _ConsultChatComposerState extends State<ConsultChatComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    HapticPatterns.focusTick();
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: line, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ── Text field ─────────────────────────────────────────────────
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppDimensions.minTapTarget,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRow),
                  border: Border.all(color: line, width: 1),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message…',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: ext?.ink3 ?? cs.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16,
                      vertical: AppDimensions.space12,
                    ),
                  ),
                  onSubmitted: _hasText ? (_) => _send() : null,
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.space8),

            // ── Send button ────────────────────────────────────────────────
            Semantics(
              button: true,
              label: 'Send message',
              enabled: _hasText,
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Material(
                  color:
                      _hasText ? cs.primary : cs.outline.withValues(alpha: 0.3),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusChip),
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusChip),
                    onTap: _hasText ? _send : null,
                    child: Icon(
                      Icons.send_rounded,
                      size: AppDimensions.iconMd,
                      color: _hasText ? Colors.white : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
