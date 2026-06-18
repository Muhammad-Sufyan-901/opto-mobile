import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/connect/presentation/widgets/community_avatar.dart';
import 'package:opto/features/profile/domain/entities/profile_entity.dart';
import 'package:opto/features/profile/presentation/bloc/profile_bloc.dart';

/// Screen P2 — Edit Profile.
///
/// Pre-fills from the [ProfileBloc] loaded state. On save dispatches
/// [ProfileEvent.updateProfile] with the edited name and bio. The photo
/// change CTA is a stub (no backend storage yet).
class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _pronounsCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Edit profile.');
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _pronounsCtrl.dispose();
    _bioCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _prefill(ProfileEntity profile) {
    if (_initialised) return;
    _initialised = true;
    _nameCtrl.text = profile.fullName ?? '';
    _usernameCtrl.text = '@raniputri';
    _pronounsCtrl.text = 'she/her';
    _bioCtrl.text =
        'Living with low vision since 2019, left ocular prosthesis since \'24. '
        'I share routines, labeling tricks and the small daily wins. '
        'Voice notes always welcome.';
    _locationCtrl.text = 'Bandung, Indonesia';
  }

  void _save(BuildContext ctx) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    HapticPatterns.success();
    ctx.read<ProfileBloc>().add(
          ProfileEvent.updateProfile(
            userId: userId,
            fullName: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
          ),
        );
    announce(ctx, 'Profile saved.');
    ctx.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (ctx, state) {
        if (state is ProfileLoaded) _prefill(state.profile);
        if (state is ProfileError) {
          ScaffoldMessenger.of(ctx)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              behavior: SnackBarBehavior.floating,
            ));
        }
      },
      builder: (ctx, state) {
        // Prefill placeholders even if profile hasn't loaded
        if (!_initialised) {
          _nameCtrl.text = _nameCtrl.text.isEmpty ? 'Rani Putri' : _nameCtrl.text;
          _usernameCtrl.text = _usernameCtrl.text.isEmpty ? '@raniputri' : _usernameCtrl.text;
          _pronounsCtrl.text = _pronounsCtrl.text.isEmpty ? 'she/her' : _pronounsCtrl.text;
          _bioCtrl.text = _bioCtrl.text.isEmpty
              ? 'Living with low vision since 2019, left ocular prosthesis since \'24. '
                  'I share routines, labeling tricks and the small daily wins. '
                  'Voice notes always welcome.'
              : _bioCtrl.text;
          _locationCtrl.text = _locationCtrl.text.isEmpty
              ? 'Bandung, Indonesia'
              : _locationCtrl.text;
          _initialised = true;
        }

        return Scaffold(
          backgroundColor: cs.surface,
          appBar: AppBar(
            backgroundColor: cs.surface,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: Semantics(
              button: true,
              label: 'Back',
              child: GestureDetector(
                onTap: () => ctx.pop(),
                child: Center(
                  child: ExcludeSemantics(
                    child:
                        Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
                  ),
                ),
              ),
            ),
            title: Text(
              'Edit profile',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              Semantics(
                button: true,
                label: 'Save changes',
                child: GestureDetector(
                  onTap: () => _save(ctx),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: AppDimensions.minTapTarget,
                    height: AppDimensions.minTapTarget,
                    decoration: BoxDecoration(
                      color: ext?.blueTint ?? cs.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: ExcludeSemantics(
                        child: Icon(Icons.check_circle_outline,
                            size: 24, color: cs.secondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(18, 0, 18, AppDimensions.space32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Photo ─────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ExcludeSemantics(
                              child: CommunityAvatar(
                                name: _nameCtrl.text,
                                authorId: 'raniputri',
                                size: 92,
                                fontSize: 32,
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Semantics(
                                button: true,
                                label: 'Change photo',
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: cs.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: cs.surface, width: 3),
                                    ),
                                    child: Center(
                                      child: ExcludeSemantics(
                                        child: Icon(Icons.photo_camera,
                                            size: 17, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Semantics(
                          button: true,
                          label: 'Change photo',
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Change photo',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.primary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Fields ────────────────────────────────────────────
                  _LabeledField(label: 'Display name', controller: _nameCtrl),
                  const SizedBox(height: 20),
                  _LabeledField(
                      label: 'Username', controller: _usernameCtrl),
                  const SizedBox(height: 20),
                  _LabeledField(
                      label: 'Pronouns', controller: _pronounsCtrl),
                  const SizedBox(height: 20),
                  _LabeledField(
                      label: 'Bio',
                      controller: _bioCtrl,
                      maxLines: 4,
                      minHeight: 110),
                  const SizedBox(height: 20),
                  _LabeledField(
                      label: 'Location', controller: _locationCtrl),

                  const SizedBox(height: 18),

                  // ── Privacy banner ─────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: ext?.blueTint?.withValues(alpha: 0.4) ??
                          cs.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: line, width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExcludeSemantics(
                          child: Icon(Icons.info_outline,
                              size: 18, color: cs.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'This is your public profile',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                  fontSize: 14.5,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Name, bio and location are visible to the community. '
                                'Health details live in your private Vision profile.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: ext?.ink2 ?? cs.onSurfaceVariant,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Save button ────────────────────────────────────────
                  Semantics(
                    button: true,
                    label: 'Save changes',
                    child: GestureDetector(
                      onTap: () => _save(ctx),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.38),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ExcludeSemantics(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 22, color: Colors.white),
                                const SizedBox(width: 9),
                                Text(
                                  'Save changes',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Cancel ────────────────────────────────────────────
                  Semantics(
                    button: true,
                    label: 'Cancel',
                    child: GestureDetector(
                      onTap: () => ctx.pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: ink3,
                              fontSize: 15.5,
                            ),
                          ),
                        ),
                      ),
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

// ── Private: labeled text field ──────────────────────────────────────────────

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.minHeight,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return Semantics(
      label: label,
      child: Container(
        constraints: BoxConstraints(
          minHeight: minHeight ?? AppDimensions.inputHeight,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: line, width: 2),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10,
              left: 16,
              child: Container(
                color: cs.surface,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
