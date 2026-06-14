// K4 · Compose Post — voice-first post composer.
//
// Primary path: voice note recorder (animated mic + waveform).
// Secondary path: "or write it out" with separate Title + Details fields.
// Selectors for target circle and audience, plus a Safe Space note.
// Driven by [ComposePostBloc]; local state handles recording UI and field
// controllers. Accessibility: every interactive element is labelled; success
// and errors are announced via live region / SnackBar.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/connect/presentation/bloc/compose_post_bloc.dart';

/// Screen K4 — Compose Post.
///
/// Voice-first post composer. Wraps [ComposePostBloc] so the bloc is
/// scoped to this screen and disposed when it leaves the tree.
class ComposePostScreen extends StatelessWidget {
  const ComposePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ComposePostBloc>(
      create: (_) => sl<ComposePostBloc>(),
      child: const _ComposePostView(),
    );
  }
}

// =============================================================================
// INNER STATEFUL VIEW
// =============================================================================

class _ComposePostView extends StatefulWidget {
  const _ComposePostView();

  @override
  State<_ComposePostView> createState() => _ComposePostViewState();
}

class _ComposePostViewState extends State<_ComposePostView>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _altController = TextEditingController();

  // Recording state
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;

  // Circle / audience selectors (UI-only stubs)
  String _selectedCircle = 'Prosthetic care';
  String _selectedAudience = 'All members';

  // Waveform animation
  late AnimationController _waveController;

  // Pulse ring on mic button
  late AnimationController _ringController;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;

  static const List<double> _waveHeights = [
    14, 26, 18, 32, 22, 36, 16, 28, 20, 34, 24, 30, 15, 27, 21, 33, 19, 25,
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _ringScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _altController.dispose();
    _waveController.dispose();
    _ringController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    if (_isRecording) {
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _recordingSeconds++);
      });
      announce(context, 'Recording started. Tap to pause.');
    } else {
      _recordingTimer?.cancel();
      announce(context, 'Recording paused.');
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && context.mounted) {
      context.read<ComposePostBloc>().add(
            ComposePostEvent.mediaSelected(
              localPath: picked.path,
              altText: '',
            ),
          );
      _altController.clear();
    }
  }

  void _submit(BuildContext context) {
    final state = context.read<ComposePostBloc>().state;

    // Build the combined body from title + details.
    final title = _titleController.text.trim();
    final details = _detailsController.text.trim();
    final body = details.isNotEmpty ? '$title\n\n$details' : title;

    // Sync alt text before submit if media is attached.
    if (state is ComposeIdle && state.mediaPath != null) {
      context.read<ComposePostBloc>().add(
            ComposePostEvent.mediaSelected(
              localPath: state.mediaPath!,
              altText: _altController.text,
            ),
          );
    }

    context.read<ComposePostBloc>()
      ..add(ComposePostEvent.bodyChanged(body))
      ..add(const ComposePostEvent.submit());
  }

  void _showCirclePicker(BuildContext context) {
    final circles = [
      'Prosthetic care',
      'Low vision',
      'Daily living',
      'Ask a specialist',
    ];
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _PickerSheet(
        title: 'Post to circle',
        options: circles,
        selected: _selectedCircle,
        onSelected: (v) => setState(() => _selectedCircle = v),
      ),
    );
  }

  void _showAudiencePicker(BuildContext context) {
    final options = ['All members', 'My circles only', 'Only me'];
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _PickerSheet(
        title: 'Who can see this',
        options: options,
        selected: _selectedAudience,
        onSelected: (v) => setState(() => _selectedAudience = v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final blueTint = ext?.blueTint ?? cs.primaryContainer;
    final ink2 = ext?.ink2 ?? cs.onSurface.withValues(alpha: 0.68);
    final ink3 = ext?.ink3 ?? cs.onSurface.withValues(alpha: 0.45);
    final lineColor = ext?.line ?? cs.outline.withValues(alpha: 0.35);

    return BlocConsumer<ComposePostBloc, ComposePostState>(
      listener: (context, state) {
        if (state is ComposeSuccess) {
          announce(context, 'Post submitted successfully.');
          context.pop();
        } else if (state is ComposeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final bool isSubmitting = state is ComposeSubmitting;
        final ComposeIdle? idleState = state is ComposeIdle ? state : null;
        final String? mediaPath = idleState?.mediaPath;
        final bool hasMedia = mediaPath != null;
        final bool titleEmpty = _titleController.text.trim().isEmpty;
        final bool altTextEmpty = _altController.text.trim().isEmpty;
        final bool submitEnabled =
            !isSubmitting && !(hasMedia && altTextEmpty);

        return Scaffold(
          backgroundColor: cs.surface,
          // ── AppBar ────────────────────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: cs.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: Semantics(
              button: true,
              label: 'Close compose screen',
              child: IconButton(
                icon: ExcludeSemantics(
                  child: Icon(Icons.close, color: cs.onSurface),
                ),
                onPressed: () => context.pop(),
              ),
            ),
            title: Text(
              'New post',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            actions: [
              Semantics(
                button: true,
                label: 'Accessibility help',
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: blueTint,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
                    ),
                    child: Center(
                      child: ExcludeSemantics(
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: cs.primary,
                          size: AppDimensions.iconLg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── Body ─────────────────────────────────────────────────────────
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenPadding,
                      vertical: AppDimensions.space16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Voice recorder (primary path) ─────────────────
                        _VoiceRecorderCard(
                          isRecording: _isRecording,
                          recordingSeconds: _recordingSeconds,
                          waveController: _waveController,
                          ringScale: _ringScale,
                          ringOpacity: _ringOpacity,
                          waveHeights: _waveHeights,
                          onTap: () => _toggleRecording(),
                          blueTint: blueTint,
                          ink2: ink2,
                          lineColor: lineColor,
                          cs: cs,
                          theme: theme,
                        ),

                        const SizedBox(height: AppDimensions.space16),

                        // ── "or write it out" divider ─────────────────────
                        _OrDivider(ink3: ink3, lineColor: lineColor),

                        const SizedBox(height: AppDimensions.space16),

                        // ── Title field ───────────────────────────────────
                        Semantics(
                          label: 'Post title',
                          textField: true,
                          child: _LabeledTextField(
                            controller: _titleController,
                            label: 'Title',
                            placeholder: 'Add a short, clear title',
                            minHeight: 60,
                            enabled: !isSubmitting,
                            onChanged: (_) => setState(() {}),
                            lineColor: lineColor,
                            ink3: ink3,
                            cs: cs,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space12),

                        // ── Details field ─────────────────────────────────
                        Semantics(
                          label: 'Post details, optional',
                          textField: true,
                          child: _LabeledTextField(
                            controller: _detailsController,
                            label: 'Details (optional)',
                            placeholder: 'Anything that helps people answer…',
                            minHeight: 96,
                            maxLines: null,
                            enabled: !isSubmitting,
                            lineColor: lineColor,
                            ink3: ink3,
                            cs: cs,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space16),

                        // ── Post-to circle selector ───────────────────────
                        Semantics(
                          button: true,
                          label: 'Post to circle: $_selectedCircle. Tap to change.',
                          child: _SelectorRow(
                            icon: Icons.lens_outlined,
                            labelKey: 'Post to',
                            value: _selectedCircle,
                            onTap: () => _showCirclePicker(context),
                            blueTint: blueTint,
                            lineColor: lineColor,
                            cs: cs,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space8),

                        // ── Audience selector ─────────────────────────────
                        Semantics(
                          button: true,
                          label: 'Who can see this: $_selectedAudience. Tap to change.',
                          child: _SelectorRow(
                            icon: Icons.group_outlined,
                            labelKey: 'Who can see this',
                            value: _selectedAudience,
                            onTap: () => _showAudiencePicker(context),
                            blueTint: blueTint,
                            lineColor: lineColor,
                            cs: cs,
                            theme: theme,
                          ),
                        ),

                        const SizedBox(height: AppDimensions.space16),

                        // ── Safe space note ───────────────────────────────
                        _SafeSpaceNote(
                          blueTint: blueTint,
                          ink2: ink2,
                          lineColor: lineColor,
                          cs: cs,
                          theme: theme,
                        ),

                        // ── Media preview + alt text ──────────────────────
                        if (hasMedia) ...[
                          const SizedBox(height: AppDimensions.space16),
                          _MediaPreview(
                            path: mediaPath,
                            onRemove: () {
                              context
                                  .read<ComposePostBloc>()
                                  .add(const ComposePostEvent.mediaRemoved());
                              _altController.clear();
                            },
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          Semantics(
                            label: 'Describe this image for screen readers (required)',
                            textField: true,
                            child: TextField(
                              controller: _altController,
                              enabled: !isSubmitting,
                              maxLines: 2,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                labelText: 'Image description (required)',
                                helperText: 'Describe the image for screen readers',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusInput),
                                ),
                                errorText: hasMedia && altTextEmpty
                                    ? 'Required when an image is attached'
                                    : null,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],

                        const SizedBox(height: AppDimensions.space8),
                      ],
                    ),
                  ),
                ),

                // ── Sticky bottom bar ─────────────────────────────────────
                _BottomBar(
                  isSubmitting: isSubmitting,
                  submitEnabled: submitEnabled && !titleEmpty,
                  isRecording: _isRecording,
                  onAttach: () => _pickImage(context),
                  onSubmit: () => _submit(context),
                  cs: cs,
                  theme: theme,
                  lineColor: lineColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// VOICE RECORDER CARD
// =============================================================================

class _VoiceRecorderCard extends StatelessWidget {
  const _VoiceRecorderCard({
    required this.isRecording,
    required this.recordingSeconds,
    required this.waveController,
    required this.ringScale,
    required this.ringOpacity,
    required this.waveHeights,
    required this.onTap,
    required this.blueTint,
    required this.ink2,
    required this.lineColor,
    required this.cs,
    required this.theme,
  });

  final bool isRecording;
  final int recordingSeconds;
  final AnimationController waveController;
  final Animation<double> ringScale;
  final Animation<double> ringOpacity;
  final List<double> waveHeights;
  final VoidCallback onTap;
  final Color blueTint;
  final Color ink2;
  final Color lineColor;
  final ColorScheme cs;
  final ThemeData theme;

  String _formatTime(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: blueTint,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.24),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Mic button with animated ring
          Semantics(
            button: true,
            label: isRecording
                ? 'Recording, ${_formatTime(recordingSeconds)}. Tap to pause.'
                : 'Tap to start recording a voice note.',
            child: GestureDetector(
              onTap: onTap,
              child: SizedBox(
                width: 104,
                height: 104,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse ring
                    if (isRecording)
                      AnimatedBuilder(
                        animation: ringScale,
                        builder: (context, child) => Transform.scale(
                          scale: ringScale.value,
                          child: Opacity(
                            opacity: ringOpacity.value,
                            child: Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cs.primary.withValues(alpha: 0.38),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Mic circle
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: cs.primary,
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.38),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(
                            isRecording ? Icons.pause_rounded : Icons.mic_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Label
          ExcludeSemantics(
            child: Text(
              isRecording
                  ? 'Recording your voice note…'
                  : 'Tap mic to record a voice note',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          // Waveform
          ExcludeSemantics(
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(waveHeights.length, (i) {
                  final baseH = waveHeights[i];
                  final delay = i * (1.0 / waveHeights.length);
                  return AnimatedBuilder(
                    animation: waveController,
                    builder: (context, child) {
                      final t = ((waveController.value + delay) % 1.0);
                      final scale = isRecording
                          ? (0.3 + 0.7 * math.sin(t * math.pi))
                          : 0.3;
                      return Container(
                        width: 4,
                        height: baseH * scale,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Time / hint
          ExcludeSemantics(
            child: Text(
              isRecording
                  ? '${_formatTime(recordingSeconds)} · tap to pause'
                  : 'Voice note',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: ink2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// "OR WRITE IT OUT" DIVIDER
// =============================================================================

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.ink3, required this.lineColor});

  final Color ink3;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          Expanded(child: Divider(color: lineColor, thickness: 1.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'or write it out',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: ink3,
              ),
            ),
          ),
          Expanded(child: Divider(color: lineColor, thickness: 1.5)),
        ],
      ),
    );
  }
}

// =============================================================================
// LABELED TEXT FIELD
// =============================================================================

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.controller,
    required this.label,
    required this.placeholder,
    required this.minHeight,
    required this.enabled,
    required this.lineColor,
    required this.ink3,
    required this.cs,
    required this.theme,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String placeholder;
  final double minHeight;
  final bool enabled;
  final Color lineColor;
  final Color ink3;
  final ColorScheme cs;
  final ThemeData theme;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: minHeight),
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: lineColor, width: 2),
          ),
          child: TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: placeholder,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: ink3,
                fontSize: 16,
              ),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontSize: 16,
              height: 1.5,
            ),
            onChanged: onChanged,
          ),
        ),
        // Floating label chip
        Positioned(
          top: -10,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            color: cs.surface,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SELECTOR ROW
// =============================================================================

class _SelectorRow extends StatelessWidget {
  const _SelectorRow({
    required this.icon,
    required this.labelKey,
    required this.value,
    required this.onTap,
    required this.blueTint,
    required this.lineColor,
    required this.cs,
    required this.theme,
  });

  final IconData icon;
  final String labelKey;
  final String value;
  final VoidCallback onTap;
  final Color blueTint;
  final Color lineColor;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: lineColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Icon chip
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(icon, color: cs.onPrimaryContainer, size: 22),
              ),
            ),
            const SizedBox(width: 13),
            // Label + value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelKey,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                      letterSpacing: -0.2,
                      fontSize: 15.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withValues(alpha: 0.5),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SAFE SPACE NOTE
// =============================================================================

class _SafeSpaceNote extends StatelessWidget {
  const _SafeSpaceNote({
    required this.blueTint,
    required this.ink2,
    required this.lineColor,
    required this.cs,
    required this.theme,
  });

  final Color blueTint;
  final Color ink2;
  final Color lineColor;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Safe space. Posts are moderated by peer volunteers. Be kind, keep medical advice general, and never share another member\'s details.',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: blueTint,
          borderRadius: BorderRadius.circular(18),
          border: Border(
            top: BorderSide(color: lineColor, width: 1.5),
            bottom: BorderSide(color: lineColor, width: 1.5),
            left: BorderSide(color: lineColor, width: 1.5),
            right: BorderSide(color: lineColor, width: 1.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.shield_outlined,
                color: cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text(
                      'SAFE SPACE',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  ExcludeSemantics(
                    child: Text(
                      'Posts are moderated by peer volunteers. Be kind, keep medical advice general, and never share another member\'s details.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ink2,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// BOTTOM BAR
// =============================================================================

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.isSubmitting,
    required this.submitEnabled,
    required this.isRecording,
    required this.onAttach,
    required this.onSubmit,
    required this.cs,
    required this.theme,
    required this.lineColor,
  });

  final bool isSubmitting;
  final bool submitEnabled;
  final bool isRecording;
  final VoidCallback onAttach;
  final VoidCallback onSubmit;
  final ColorScheme cs;
  final ThemeData theme;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: lineColor, width: 1.5)),
      ),
      child: Row(
        children: [
          // Attach button
          Semantics(
            button: true,
            label: 'Attach image',
            child: SizedBox(
              width: 60,
              height: 54,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : onAttach,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const StadiumBorder(),
                  side: BorderSide(color: lineColor, width: 2),
                  foregroundColor: cs.primary,
                ),
                child: ExcludeSemantics(
                  child: Icon(
                    Icons.attach_file_rounded,
                    size: AppDimensions.iconLg,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Post button
          Expanded(
            child: Semantics(
              button: true,
              label: isRecording ? 'Post voice note' : 'Post',
              child: SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: submitEnabled ? onSubmit : null,
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: cs.primary,
                    disabledBackgroundColor:
                        cs.onSurface.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: isSubmitting
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : ExcludeSemantics(
                          child: Icon(Icons.send_rounded, size: 20),
                        ),
                  label: isSubmitting
                      ? const SizedBox.shrink()
                      : ExcludeSemantics(
                          child: Text(
                            isRecording ? 'Post voice note' : 'Post',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// MEDIA PREVIEW
// =============================================================================

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: ExcludeSemantics(
            child: Image.file(
              File(path),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Remove attached image',
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: ExcludeSemantics(
                  child: Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PICKER SHEET  (circle / audience selector)
// =============================================================================

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...options.map(
              (opt) => Semantics(
                button: true,
                label: '$opt${opt == selected ? ', selected' : ''}',
                child: ListTile(
                  title: Text(
                    opt,
                    style: TextStyle(
                      fontWeight: opt == selected
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                  trailing: opt == selected
                      ? Icon(Icons.check_rounded, color: cs.primary)
                      : null,
                  onTap: () {
                    onSelected(opt);
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
