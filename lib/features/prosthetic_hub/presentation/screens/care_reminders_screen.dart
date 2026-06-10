// Care Reminders Screen — Prosthetic Hub.
//
// Displays and manages care reminder rows. Client layer only — notification
// dispatch (schedule_cron) is handled server-side by the Edge Function.
//
// Accessibility:
//   - Announces screen, save/toggle/delete results via live regions.
//   - Each tile has a Semantics label with label + schedule + active state.
//   - Tap targets ≥ 48dp.
//   - Cron expressions are humanized for the Semantics label.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_reminder_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/reminders/reminders_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/reminders/reminders_state.dart';

/// Screen — list of care reminders with add/edit/toggle/delete.
class CareRemindersScreen extends StatefulWidget {
  const CareRemindersScreen({super.key});

  @override
  State<CareRemindersScreen> createState() => _CareRemindersScreenState();
}

class _CareRemindersScreenState extends State<CareRemindersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().loadReminders();
  }

  // ── add / edit dialog ─────────────────────────────────────────────────────

  Future<void> _showUpsertDialog({CareReminderEntity? existing}) async {
    final labelCtrl =
        TextEditingController(text: existing?.label ?? '');
    final cronCtrl =
        TextEditingController(text: existing?.scheduleCron ?? '0 8 * * *');
    bool notifyCaregiver = existing?.notifyCaregiver ?? false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          title: Semantics(
            header: true,
            child: Text(existing == null ? 'New Reminder' : 'Edit Reminder'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'Reminder label',
                child: TextField(
                  controller: labelCtrl,
                  decoration: const InputDecoration(labelText: 'Label'),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                label: 'Schedule as cron expression',
                child: TextField(
                  controller: cronCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Schedule (cron)',
                    hintText: '0 8 * * * = daily at 8 AM',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                toggled: notifyCaregiver,
                label: 'Notify caregiver',
                child: CheckboxListTile(
                  title: const Text('Notify caregiver'),
                  value: notifyCaregiver,
                  onChanged: (v) =>
                      setDialogState(() => notifyCaregiver = v ?? false),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: const Text('Cancel'),
            ),
            Semantics(
              button: true,
              label: 'Save reminder',
              child: FilledButton(
                onPressed: () => Navigator.of(dialogCtx).pop(true),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );

    if (saved == true && mounted) {
      context.read<RemindersCubit>().upsertReminder(
            id: existing?.id,
            label: labelCtrl.text.trim(),
            scheduleCron: cronCtrl.text.trim(),
            notifyCaregiver: notifyCaregiver,
          );
    }

    labelCtrl.dispose();
    cronCtrl.dispose();
  }

  Future<void> _confirmDelete(CareReminderEntity reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete reminder?'),
        content: Text(
          'This will permanently delete "${reminder.label}".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<RemindersCubit>().deleteReminder(reminder.id);
    }
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocConsumer<RemindersCubit, RemindersState>(
          listenWhen: (_, curr) =>
              curr is RemindersLoaded ||
              curr is RemindersOperationSuccess ||
              curr is RemindersError,
          listener: (context, state) {
            if (state is RemindersLoaded) {
              announce(context, 'Care reminders.');
            } else if (state is RemindersOperationSuccess) {
              announce(context, state.message);
            } else if (state is RemindersError) {
              announce(context, 'Error: ${state.message}');
            }
          },
          builder: (context, state) {
            final reminders = switch (state) {
              RemindersLoaded(:final reminders) => reminders,
              RemindersOperationSuccess(:final reminders) => reminders,
              _ => null,
            };

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: cs.surface,
                  leading: Semantics(
                    button: true,
                    label: 'Back',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  title: const Text('Care Reminders'),
                  actions: [
                    Semantics(
                      button: true,
                      label: 'Add reminder',
                      child: IconButton(
                        icon: const Icon(Icons.add_alarm_outlined),
                        onPressed: () => _showUpsertDialog(),
                        tooltip: 'Add reminder',
                      ),
                    ),
                  ],
                ),

                if (state is RemindersInitial || state is RemindersLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is RemindersError && reminders == null)
                  SliverFillRemaining(
                    child: _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<RemindersCubit>().loadReminders(),
                    ),
                  )
                else if (reminders != null && reminders.isEmpty)
                  const SliverFillRemaining(child: _EmptyView())
                else if (reminders != null)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ReminderTile(
                        reminder: reminders[index],
                        onToggle: () => context
                            .read<RemindersCubit>()
                            .toggleActive(reminders[index].id),
                        onEdit: () =>
                            _showUpsertDialog(existing: reminders[index]),
                        onDelete: () =>
                            _confirmDelete(reminders[index]),
                      ),
                      childCount: reminders.length,
                    ),
                  ),

                // Dispatcher note — always visible, as required by CLAUDE.md
                // (client-only note; no payment/Edge integration on this screen).
                if (reminders != null)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: _DispatchNote(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// REMINDER TILE
// =============================================================================

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final CareReminderEntity reminder;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final activeLabel = reminder.isActive ? 'active' : 'paused';

    return Semantics(
      label:
          '${reminder.label}, schedule ${reminder.scheduleCron}, $activeLabel',
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Semantics(
          toggled: reminder.isActive,
          label: reminder.isActive ? 'Pause reminder' : 'Activate reminder',
          child: Switch(
            value: reminder.isActive,
            onChanged: (_) => onToggle(),
          ),
        ),
        title: Text(
          reminder.label,
          style: tt.bodyLarge?.copyWith(
            color: reminder.isActive ? null : cs.onSurfaceVariant,
            decoration:
                reminder.isActive ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          reminder.scheduleCron,
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: 'Edit ${reminder.label}',
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Delete ${reminder.label}',
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: cs.error),
                  onPressed: onDelete,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _DispatchNote extends StatelessWidget {
  const _DispatchNote();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      label:
          'Note: reminders are scheduled server-side. '
          'Changes take effect after the next server sync.',
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.info_outline,
              size: 16,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Reminders are scheduled server-side. '
              'Changes take effect after the next sync.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.alarm_add_outlined,
                size: 72,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No reminders yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first care reminder.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              label: 'Error: $message',
              child: Text(message, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: 'Retry loading reminders',
              child: FilledButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
