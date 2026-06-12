// Screen for composing a new community post.
//
// Driven by [ComposePostBloc]. Supports optional image attachment with
// mandatory alt text for accessibility. Announcements are made on success
// and error via the [announce] helper.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/di/dependencies_injection_container.dart';
import 'package:opto/features/connect/presentation/bloc/compose_post_bloc.dart';

/// Screen 19a — Compose Post
///
/// A full-screen composer for creating a new community post.
/// Wrapped in its own [BlocProvider] so the bloc is scoped to this screen.
///
/// Accessibility:
/// - Text fields have [semanticsLabel] for TalkBack/VoiceOver.
/// - Success is announced via live region before the screen is popped.
/// - Errors are surfaced in a [SnackBar] (announced by the framework).
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

class _ComposePostViewState extends State<_ComposePostView> {
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _altController = TextEditingController();

  @override
  void dispose() {
    _bodyController.dispose();
    _altController.dispose();
    super.dispose();
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
      // Reset alt text field when a new image is picked.
      _altController.clear();
    }
  }

  void _submit(BuildContext context) {
    // Sync the alt text from the controller into the bloc before submitting.
    final state = context.read<ComposePostBloc>().state;
    if (state is ComposeIdle && state.mediaPath != null) {
      context.read<ComposePostBloc>().add(
            ComposePostEvent.mediaSelected(
              localPath: state.mediaPath!,
              altText: _altController.text,
            ),
          );
    }
    context.read<ComposePostBloc>().add(const ComposePostEvent.submit());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
        final ComposeIdle? idleState =
            state is ComposeIdle ? state : null;
        final String? mediaPath = idleState?.mediaPath;
        final bool hasMedia = mediaPath != null;
        final bool altTextEmpty = _altController.text.trim().isEmpty;
        final bool submitEnabled =
            !isSubmitting && !(hasMedia && altTextEmpty);

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: cs.surface,
            elevation: 0,
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
              'New Post',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Semantics(
                  button: true,
                  label: 'Publish post',
                  child: TextButton(
                    onPressed: submitEnabled ? () => _submit(context) : null,
                    child: isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.primary,
                            ),
                          )
                        : Text(
                            'Post',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: submitEnabled
                                  ? cs.primary
                                  : cs.onSurface.withValues(alpha: 0.38),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
                vertical: AppDimensions.space16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Post body ──────────────────────────────────────────
                  Semantics(
                    label: 'Post body',
                    textField: true,
                    child: TextField(
                      controller: _bodyController,
                      enabled: !isSubmitting,
                      autofocus: true,
                      maxLines: null,
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Share something with the community…',
                        border: InputBorder.none,
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface,
                        height: 1.5,
                      ),
                      onChanged: (val) => context
                          .read<ComposePostBloc>()
                          .add(ComposePostEvent.bodyChanged(val)),
                    ),
                  ),

                  const Divider(height: 24),

                  // ── Media preview + alt text ───────────────────────────
                  if (hasMedia) ...[
                    _MediaPreview(
                      path: mediaPath,
                      onRemove: () {
                        context
                            .read<ComposePostBloc>()
                            .add(const ComposePostEvent.mediaRemoved());
                        _altController.clear();
                      },
                    ),
                    const SizedBox(height: 12),
                    Semantics(
                      label:
                          'Describe this image for screen readers (required)',
                      textField: true,
                      child: TextField(
                        controller: _altController,
                        enabled: !isSubmitting,
                        maxLines: 2,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Image description (required)',
                          helperText:
                              'Describe the image for screen readers',
                          border: const OutlineInputBorder(),
                          errorText: hasMedia && altTextEmpty
                              ? 'Required when an image is attached'
                              : null,
                        ),
                        onChanged: (_) =>
                            setState(() {}), // rebuild to re-evaluate submit
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Attach media button ────────────────────────────────
                  Semantics(
                    button: true,
                    label: hasMedia ? 'Change attached image' : 'Attach image',
                    child: OutlinedButton.icon(
                      onPressed:
                          isSubmitting ? null : () => _pickImage(context),
                      icon: ExcludeSemantics(
                        child: Icon(
                          hasMedia ? Icons.image : Icons.add_photo_alternate_outlined,
                        ),
                      ),
                      label: Text(hasMedia ? 'Change image' : 'Attach image'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
              errorBuilder: (_, _, _) => Container(
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
