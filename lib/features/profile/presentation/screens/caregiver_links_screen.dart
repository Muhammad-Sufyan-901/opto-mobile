// Screen 20g — Caregiver links management.
//
// Shows the signed-in user's caregiver relationships partitioned into:
//   • "People supporting me" — links where `link.userId == currentUserId`.
//     The current user can approve (pending → active) or revoke (active → revoked).
//   • "My caregiver links" — links where `link.caregiverId == currentUserId`.
//     Read-only because RLS prevents a caregiver from approving/revoking their
//     own request on the user's behalf.
//
// SECURITY: RLS is the server-side authorisation source of truth.
// The UI hides action buttons for the caregiver side but the backend enforces it.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/identity_enums.dart';
import 'package:opto/features/profile/domain/entities/caregiver_link_entity.dart';
import 'package:opto/features/profile/presentation/cubit/caregiver_links_cubit.dart';

/// Screen 20g — Caregiver links.
class CaregiverLinksScreen extends StatefulWidget {
  const CaregiverLinksScreen({super.key});

  @override
  State<CaregiverLinksScreen> createState() => _CaregiverLinksScreenState();
}

class _CaregiverLinksScreenState extends State<CaregiverLinksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Caregiver links.');
      final userId =
          Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        context.read<CaregiverLinksCubit>().load(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
            onTap: () => context.pop(),
            child: Center(
              child: ExcludeSemantics(
                child: Icon(Icons.arrow_back, size: 22, color: cs.onSurface),
              ),
            ),
          ),
        ),
        title: Text(
          'Caregiver links',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<CaregiverLinksCubit, CaregiverLinksState>(
          listener: (context, state) {
            if (state is CaregiverLinksError) {
              HapticPatterns.warning();
              announce(context, 'Error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is CaregiverLinksLoaded) {
              // Only announce after a mutation (not initial load — initState
              // already announced "Caregiver links").
            }
          },
          builder: (context, state) {
            if (state is CaregiverLinksLoading ||
                state is CaregiverLinksInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CaregiverLinksError) {
              return _ErrorBody(
                message: state.message,
                onRetry: () {
                  final userId =
                      Supabase.instance.client.auth.currentUser?.id;
                  if (userId != null) {
                    context.read<CaregiverLinksCubit>().load(userId);
                  }
                },
              );
            }
            if (state is CaregiverLinksLoaded) {
              return _LoadedBody(
                links: state.links,
                currentUserId: state.currentUserId,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Loaded body ───────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.links,
    required this.currentUserId,
  });

  final List<CaregiverLinkEntity> links;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    // Partition the links based on the current user's role in each link.
    final supportedByLinks = links
        .where((l) => l.userId == currentUserId)
        .toList(growable: false);
    final caregiverForLinks = links
        .where((l) => l.caregiverId == currentUserId)
        .toList(growable: false);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Section: People supporting me ──────────────────────────────
          _SectionHeader(
            title: 'People supporting me',
            semanticLabel:
                'People supporting me. ${supportedByLinks.length} link${supportedByLinks.length == 1 ? '' : 's'}.',
          ),
          const SizedBox(height: 12),
          if (supportedByLinks.isEmpty)
            _EmptyCard(
              message: 'No one is currently supporting you.',
              semanticLabel:
                  'No caregiver links yet. No one is currently supporting you.',
            )
          else
            ...supportedByLinks.map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: _LinkCard(
                  link: link,
                  // The current user is the person being supported: they CAN
                  // approve (pending → active) and revoke (active → revoked).
                  isActionable: true,
                  displayLabel: _labelForCaregiver(link),
                  displaySemantic: 'Caregiver: ${_labelForCaregiver(link)}. Status: ${_statusLabel(link.status)}.',
                ),
              ),
            ),

          const SizedBox(height: 24),

          // ── Section: My caregiver links ────────────────────────────────
          _SectionHeader(
            title: 'My caregiver links',
            semanticLabel:
                'My caregiver links. ${caregiverForLinks.length} link${caregiverForLinks.length == 1 ? '' : 's'}.',
          ),
          const SizedBox(height: 12),
          if (caregiverForLinks.isEmpty)
            _EmptyCard(
              message: 'You are not acting as a caregiver for anyone.',
              semanticLabel:
                  'No caregiver links. You are not acting as a caregiver for anyone.',
            )
          else
            ...caregiverForLinks.map(
              (link) => Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: _LinkCard(
                  link: link,
                  // The current user IS the caregiver: they cannot approve or
                  // revoke their own request (RLS enforces this server-side).
                  isActionable: false,
                  displayLabel: _labelForUser(link),
                  displaySemantic: 'Supporting: ${_labelForUser(link)}. Status: ${_statusLabel(link.status)}.',
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Fallback display label for the caregiver side of a link.
  /// The entity has no name field — we show a UUID prefix gracefully.
  String _labelForCaregiver(CaregiverLinkEntity link) {
    final id = link.caregiverId;
    return 'User ${id.length > 8 ? id.substring(0, 8) : id}…';
  }

  /// Fallback display label for the primary user side of a link.
  String _labelForUser(CaregiverLinkEntity link) {
    final id = link.userId;
    return 'User ${id.length > 8 ? id.substring(0, 8) : id}…';
  }

  String _statusLabel(LinkStatus status) {
    switch (status) {
      case LinkStatus.pending:
        return 'Pending approval';
      case LinkStatus.active:
        return 'Active';
      case LinkStatus.revoked:
        return 'Revoked';
    }
  }
}

// ── Individual link card ───────────────────────────────────────────────────────

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.link,
    required this.isActionable,
    required this.displayLabel,
    required this.displaySemantic,
  });

  final CaregiverLinkEntity link;

  /// Whether the current user can approve/revoke this link.
  final bool isActionable;

  /// Display name / ID fallback.
  final String displayLabel;

  /// Full semantic label for the card.
  final String displaySemantic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label: displaySemantic,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + status badge row
            Row(
              children: [
                Expanded(
                  child: ExcludeSemantics(
                    child: Text(
                      displayLabel,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                ExcludeSemantics(
                  child: _StatusBadge(status: link.status),
                ),
              ],
            ),

            // Action buttons (only for the supported-user side)
            if (isActionable) ...[
              const SizedBox(height: 12),
              ExcludeSemantics(
                child: _ActionRow(link: link),
              ),
              // Accessible buttons outside ExcludeSemantics so screen readers
              // can reach them individually.
              _AccessibleActionRow(link: link),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Visual action row (excluded from semantics — accessible row below handles it)

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.link});
  final CaregiverLinkEntity link;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (link.status == LinkStatus.revoked) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (link.status == LinkStatus.pending) ...[
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              minimumSize: const Size(88, 48),
            ),
            onPressed: () =>
                context.read<CaregiverLinksCubit>().updateStatus(
                      link.id,
                      LinkStatus.active,
                    ),
            child: const Text('Approve'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(88, 48),
              foregroundColor: cs.error,
              side: BorderSide(color: cs.error),
            ),
            onPressed: () =>
                context.read<CaregiverLinksCubit>().updateStatus(
                      link.id,
                      LinkStatus.revoked,
                    ),
            child: const Text('Reject'),
          ),
        ],
        if (link.status == LinkStatus.active)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(88, 48),
              foregroundColor: cs.error,
              side: BorderSide(color: cs.error),
            ),
            onPressed: () => _confirmRevoke(context),
            child: const Text('Revoke'),
          ),
      ],
    );
  }

  Future<void> _confirmRevoke(BuildContext context) async {
    final cubit = context.read<CaregiverLinksCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final cs = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('Revoke access?'),
          content: const Text(
            'This caregiver will no longer be able to access your information. '
            'You can re-invite them later.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: cs.error),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Revoke'),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      HapticPatterns.warning();
      cubit.updateStatus(link.id, LinkStatus.revoked);
    }
  }
}

// ── Accessible (screen-reader) action row ─────────────────────────────────────
// These widgets are visually hidden via Opacity(0) / zero-size so only the
// ExcludeSemantics-wrapped _ActionRow is visible, but screen readers land here.

class _AccessibleActionRow extends StatelessWidget {
  const _AccessibleActionRow({required this.link});
  final CaregiverLinkEntity link;

  @override
  Widget build(BuildContext context) {
    if (link.status == LinkStatus.revoked) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (link.status == LinkStatus.pending) ...[
            Semantics(
              button: true,
              label: 'Approve caregiver request',
              child: SizedBox(
                height: 48,
                width: 88,
                child: Opacity(
                  opacity: 0,
                  child: FilledButton(
                    onPressed: () {
                      HapticPatterns.success();
                      context
                          .read<CaregiverLinksCubit>()
                          .updateStatus(link.id, LinkStatus.active);
                      announce(context, 'Caregiver request approved.');
                    },
                    child: const Text('Approve'),
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Reject caregiver request',
              child: SizedBox(
                height: 48,
                width: 88,
                child: Opacity(
                  opacity: 0,
                  child: OutlinedButton(
                    onPressed: () {
                      HapticPatterns.warning();
                      context
                          .read<CaregiverLinksCubit>()
                          .updateStatus(link.id, LinkStatus.revoked);
                      announce(context, 'Caregiver request rejected.');
                    },
                    child: const Text('Reject'),
                  ),
                ),
              ),
            ),
          ],
          if (link.status == LinkStatus.active)
            Semantics(
              button: true,
              label: 'Revoke caregiver access',
              child: SizedBox(
                height: 48,
                width: 88,
                child: Opacity(
                  opacity: 0,
                  child: OutlinedButton(
                    onPressed: () {
                      HapticPatterns.warning();
                      context
                          .read<CaregiverLinksCubit>()
                          .updateStatus(link.id, LinkStatus.revoked);
                      announce(context, 'Caregiver access revoked.');
                    },
                    child: const Text('Revoke'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final LinkStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Color bgColor;
    Color fgColor;
    String label;

    switch (status) {
      case LinkStatus.pending:
        bgColor = cs.tertiaryContainer;
        fgColor = cs.onTertiaryContainer;
        label = 'Pending';
      case LinkStatus.active:
        bgColor = cs.primaryContainer;
        fgColor = cs.onPrimaryContainer;
        label = 'Active';
      case LinkStatus.revoked:
        bgColor = cs.errorContainer;
        fgColor = cs.onErrorContainer;
        label = 'Revoked';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.semanticLabel,
  });

  final String title;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

// ── Empty state card ──────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message, required this.semanticLabel});

  final String message;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      label: semanticLabel,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant, width: 1.5),
        ),
        child: ExcludeSemantics(
          child: Center(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Error loading caregiver links. $message',
              child: ExcludeSemantics(
                child: Icon(Icons.error_outline, size: 48, color: cs.error),
              ),
            ),
            const SizedBox(height: 12),
            ExcludeSemantics(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.error),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: 'Retry loading caregiver links',
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
