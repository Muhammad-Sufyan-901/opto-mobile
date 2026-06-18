// Screen 20f — Emergency contacts management.
//
// Displays the owner's emergency contacts ordered by priority and allows
// creating, editing, and deleting entries.
//
// SECURITY NOTE: owner-only data (RLS).  Never expose outside this screen.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/profile/domain/entities/emergency_contact_entity.dart';
import 'package:opto/features/profile/presentation/cubit/emergency_contacts_cubit.dart';

/// Screen for viewing and managing emergency contacts.
///
/// Accessed from Account & settings → Emergency contacts.
class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load();
      announce(context, 'Emergency contacts.');
    });
  }

  void _load() {
    final userId =
        Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    context.read<EmergencyContactsCubit>().load(userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

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
          'Emergency contacts',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Add emergency contact',
            child: GestureDetector(
              onTap: () {
                HapticPatterns.focusTick();
                _showContactBottomSheet(context, contact: null);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: ext?.blueTint ?? cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.add, size: 24, color: cs.secondary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<EmergencyContactsCubit, EmergencyContactsState>(
          listener: (ctx, state) {
            if (state is EmergencyContactsError) {
              HapticPatterns.warning();
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: cs.error,
                ),
              );
              announce(ctx, state.message);
            }
          },
          builder: (ctx, state) {
            if (state is EmergencyContactsLoading ||
                state is EmergencyContactsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmergencyContactsError) {
              return _ErrorBody(
                message: state.message,
                onRetry: _load,
              );
            }

            if (state is EmergencyContactsLoaded) {
              if (state.contacts.isEmpty) {
                return _EmptyBody(
                  onAdd: () =>
                      _showContactBottomSheet(context, contact: null),
                );
              }
              return _ContactList(
                contacts: state.contacts,
                onTap: (c) =>
                    _showContactBottomSheet(context, contact: c),
                onDelete: (c) => _confirmDelete(context, c),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticPatterns.focusTick();
          _showContactBottomSheet(context, contact: null);
        },
        tooltip: 'Add emergency contact',
        child: Semantics(
          button: true,
          label: 'Add emergency contact',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // ── Bottom sheet ───────────────────────────────────────────────────────────

  Future<void> _showContactBottomSheet(
    BuildContext context, {
    required EmergencyContactEntity? contact,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<EmergencyContactsCubit>(),
        child: _ContactFormSheet(existingContact: contact),
      ),
    );
  }

  // ── Delete confirmation ────────────────────────────────────────────────────

  Future<void> _confirmDelete(
    BuildContext context,
    EmergencyContactEntity contact,
  ) async {
    final cs = Theme.of(context).colorScheme;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove contact?'),
        content: Text(
          'Remove ${contact.name} from your emergency contacts? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: cs.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      HapticPatterns.warning();
      // ignore: use_build_context_synchronously
      context.read<EmergencyContactsCubit>().delete(contact.id);
      // ignore: use_build_context_synchronously
      announce(context, '${contact.name} removed.');
    }
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _ContactList extends StatelessWidget {
  const _ContactList({
    required this.contacts,
    required this.onTap,
    required this.onDelete,
  });

  final List<EmergencyContactEntity> contacts;
  final ValueChanged<EmergencyContactEntity> onTap;
  final ValueChanged<EmergencyContactEntity> onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      itemCount: contacts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final contact = contacts[i];
        return _ContactTile(
          contact: contact,
          onTap: () => onTap(contact),
          onDelete: () => onDelete(contact),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
    required this.onTap,
    required this.onDelete,
  });

  final EmergencyContactEntity contact;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    final String semanticLabel =
        '${contact.name}, ${contact.phone}'
        '${contact.relationship != null ? ', ${contact.relationship}' : ''}'
        ', priority ${contact.priority + 1}';

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Dismissible(
        key: ValueKey(contact.id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          onDelete();
          // Return false: we handle deletion via the cubit, not Dismissible.
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: cs.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete_outline, color: cs.error, size: 26),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ext?.blueTint?.withValues(alpha: 0.45) ??
                  cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ext?.line ?? cs.outline,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Priority badge
                ExcludeSemantics(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ext?.blueTint ?? cs.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${contact.priority + 1}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name / phone / relationship
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        contact.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        contact.phone,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ext?.ink3 ?? cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (contact.relationship != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          contact.relationship!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Delete icon (≥48 dp target)
                Semantics(
                  button: true,
                  label: 'Delete ${contact.name}',
                  child: GestureDetector(
                    onTap: onDelete,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(
                            Icons.delete_outline,
                            color: cs.error,
                            size: 22,
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
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.contacts_outlined,
                size: 72,
                color: (ext?.ink3 ?? cs.onSurfaceVariant)
                    .withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No emergency contacts',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Add someone who should be contacted in an emergency.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ext?.ink3 ?? cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Semantics(
              button: true,
              label: 'Add emergency contact',
              child: FilledButton.icon(
                onPressed: onAdd,
                icon: const ExcludeSemantics(child: Icon(Icons.add)),
                label: const Text('Add contact'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(200, 52),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.error_outline, size: 56, color: cs.error),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Semantics(
              button: true,
              label: 'Retry loading emergency contacts',
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const ExcludeSemantics(child: Icon(Icons.refresh)),
                label: const Text('Retry'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(160, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contact form bottom sheet ─────────────────────────────────────────────────

class _ContactFormSheet extends StatefulWidget {
  const _ContactFormSheet({this.existingContact});
  final EmergencyContactEntity? existingContact;

  @override
  State<_ContactFormSheet> createState() => _ContactFormSheetState();
}

class _ContactFormSheetState extends State<_ContactFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _relationCtrl;
  late final TextEditingController _priorityCtrl;

  bool get _isEditing => widget.existingContact != null;

  @override
  void initState() {
    super.initState();
    final c = widget.existingContact;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _phoneCtrl = TextEditingController(text: c?.phone ?? '');
    _relationCtrl = TextEditingController(text: c?.relationship ?? '');
    _priorityCtrl =
        TextEditingController(text: c != null ? '${c.priority}' : '0');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _relationCtrl.dispose();
    _priorityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            ExcludeSemantics(
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cs.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            Text(
              _isEditing ? 'Edit contact' : 'Add emergency contact',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),

            // Name (required)
            Semantics(
              label: 'Full name, required',
              child: TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full name *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required.' : null,
              ),
            ),
            const SizedBox(height: 14),

            // Phone (required)
            Semantics(
              label: 'Phone number, required',
              child: TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number *',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty)
                        ? 'Phone number is required.'
                        : null,
              ),
            ),
            const SizedBox(height: 14),

            // Relationship (optional)
            Semantics(
              label: 'Relationship, optional',
              child: TextFormField(
                controller: _relationCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Relationship (optional)',
                  hintText: 'e.g. Mother, Spouse',
                  prefixIcon: Icon(Icons.favorite_border),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Priority (optional int)
            Semantics(
              label: 'Priority order, optional. Lower number means higher priority.',
              child: TextFormField(
                controller: _priorityCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Priority (optional)',
                  hintText: '0 = highest priority',
                  prefixIcon: Icon(Icons.sort),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final n = int.tryParse(v.trim());
                  if (n == null || n < 0) {
                    return 'Enter a non-negative number.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 28),

            // Save button
            Semantics(
              button: true,
              label: _isEditing ? 'Save changes' : 'Add contact',
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_isEditing ? 'Save changes' : 'Add contact'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final userId =
        Supabase.instance.client.auth.currentUser?.id ?? '';
    final priority = int.tryParse(_priorityCtrl.text.trim()) ?? 0;
    final relationship = _relationCtrl.text.trim().isEmpty
        ? null
        : _relationCtrl.text.trim();

    final cubit = context.read<EmergencyContactsCubit>();

    if (_isEditing) {
      final updated = widget.existingContact!.copyWith(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        relationship: relationship,
        priority: priority,
      );
      cubit.update(updated);
      announce(context, 'Contact updated.');
    } else {
      final newContact = EmergencyContactEntity(
        id: '', // ignored by server — Postgres generates it
        userId: userId,
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        relationship: relationship,
        priority: priority,
      );
      cubit.add(newContact);
      announce(context, 'Contact added.');
    }

    HapticPatterns.success();
    Navigator.of(context).pop();
  }
}
