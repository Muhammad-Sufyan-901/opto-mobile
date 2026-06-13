import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/themes/app_custom_colors.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/care_log.dart';
import 'package:opto/features/prosthetic_hub/presentation/cubit/care_log_cubit.dart';
import 'package:opto/features/prosthetic_hub/presentation/widgets/prosthetic_header.dart';

/// Screen 17-L — Log today's prosthetic care.
///
/// Layout: white Scaffold, SafeArea, no bottom nav, single-scroll form.
/// Accessibility: announces "Log care." on entry; announces "Care log saved."
/// on successful save; announces state changes on checklist toggles.
class CareLogScreen extends StatefulWidget {
  const CareLogScreen({super.key});

  @override
  State<CareLogScreen> createState() => _CareLogScreenState();
}

class _CareLogScreenState extends State<CareLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      announce(context, 'Log care.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CareLogCubit>(
      create: (_) => CareLogCubit(),
      child: const _CareLogView(),
    );
  }
}

// =============================================================================
// MAIN VIEW
// =============================================================================

class _CareLogView extends StatelessWidget {
  const _CareLogView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CareLogCubit, CareLogFormState>(
      listenWhen: (prev, curr) => !prev.isSaved && curr.isSaved,
      listener: (context, state) {
        HapticFeedback.mediumImpact();
        announce(context, 'Care log saved.');
        if (context.canPop()) context.pop();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.screenPadding,
              right: AppDimensions.screenPadding,
              top: 16,
              bottom: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProstheticHeader(title: 'Log Care'),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _DateAndListenRow(),
                        const SizedBox(height: AppDimensions.sectionGap),
                        const _CareTasksSection(),
                        const SizedBox(height: AppDimensions.sectionGap),
                        const _ComfortSection(),
                        const SizedBox(height: AppDimensions.sectionGap),
                        const _NotesSection(),
                        const SizedBox(height: AppDimensions.space32),
                        const _ActionButtons(),
                      ],
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

// =============================================================================
// DATE CHIP + LISTEN ROW
// =============================================================================

class _DateAndListenRow extends StatelessWidget {
  const _DateAndListenRow();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final String formattedDate =
        DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Row(
      children: [
        // Date chip
        Semantics(
          label: 'Logging for $formattedDate',
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(21),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 9),
                ExcludeSemantics(
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Listen pill
        Semantics(
          button: true,
          label: 'Listen to today\'s log summary',
          child: GestureDetector(
            onTap: () => announce(
              context,
              'Care log for $formattedDate. '
              'Log your care tasks, comfort level, and any notes.',
            ),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.volume_up_outlined,
                      size: 16,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ExcludeSemantics(
                    child: Text(
                      'Listen',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// CARE TASKS SECTION
// =============================================================================

class _CareTasksSection extends StatelessWidget {
  const _CareTasksSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            'CARE TASKS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: ink3,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        BlocBuilder<CareLogCubit, CareLogFormState>(
          buildWhen: (p, c) => p.checkedTasks != c.checkedTasks,
          builder: (context, state) {
            return Column(
              children: [
                for (int i = 0; i < CareTask.values.length; i++) ...[
                  if (i > 0) const SizedBox(height: 11),
                  _CareTaskRow(
                    task: CareTask.values[i],
                    isChecked: state.checkedTasks.contains(CareTask.values[i]),
                    onToggle: () => context
                        .read<CareLogCubit>()
                        .toggleTask(CareTask.values[i]),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CareTaskRow extends StatelessWidget {
  const _CareTaskRow({
    required this.task,
    required this.isChecked,
    required this.onToggle,
  });

  final CareTask task;
  final bool isChecked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return Semantics(
      checked: isChecked,
      label: task.displayLabel,
      hint: isChecked ? 'Double tap to uncheck' : 'Double tap to check',
      child: GestureDetector(
        onTap: () {
          onToggle();
          announce(
            context,
            isChecked
                ? '${task.displayLabel} unchecked.'
                : '${task.displayLabel} checked.',
          );
          HapticFeedback.selectionClick();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: BoxDecoration(
            color: isChecked ? cs.primaryContainer : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isChecked ? cs.primary : line,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Checkbox visual
              ExcludeSemantics(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isChecked ? cs.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: isChecked
                        ? null
                        : Border.all(color: line, width: 2.5),
                  ),
                  child: isChecked
                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(width: 16),

              // Label
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    task.displayLabel,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isChecked ? FontWeight.w700 : FontWeight.w600,
                      color: isChecked
                          ? cs.onPrimaryContainer
                          : cs.onSurface,
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
}

// =============================================================================
// COMFORT LEVEL SECTION
// =============================================================================

class _ComfortSection extends StatelessWidget {
  const _ComfortSection();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            'COMFORT TODAY',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: ink3,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        BlocBuilder<CareLogCubit, CareLogFormState>(
          buildWhen: (p, c) => p.comfortLevel != c.comfortLevel,
          builder: (context, state) {
            return Semantics(
              label: 'Comfort level selection',
              child: Row(
                children: [
                  for (final level in ComfortLevel.values) ...[
                    if (level != ComfortLevel.values.first)
                      const SizedBox(width: 10),
                    Expanded(
                      child: _ComfortButton(
                        level: level,
                        isSelected: state.comfortLevel == level,
                        onTap: () => context
                            .read<CareLogCubit>()
                            .setComfort(level),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ComfortButton extends StatelessWidget {
  const _ComfortButton({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final ComfortLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (level) {
        ComfortLevel.poor => Icons.sentiment_dissatisfied_outlined,
        ComfortLevel.fair => Icons.sentiment_neutral_outlined,
        ComfortLevel.good => Icons.sentiment_satisfied_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;
    final Color ink2 = ext?.ink2 ?? cs.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Comfort: ${level.displayLabel}',
      child: GestureDetector(
        onTap: () {
          onTap();
          announce(context, 'Comfort set to ${level.displayLabel}.');
          HapticFeedback.selectionClick();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(18),
            border: isSelected
                ? null
                : Border.all(color: line, width: 2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                      spreadRadius: -8,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Icon(
                  _icon,
                  size: 20,
                  color: isSelected ? Colors.white : ink2,
                ),
              ),
              const SizedBox(width: 7),
              ExcludeSemantics(
                child: Text(
                  level.displayLabel,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : ink2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// NOTES SECTION
// =============================================================================

class _NotesSection extends StatefulWidget {
  const _NotesSection();

  @override
  State<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<_NotesSection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color ink3 = ext?.ink3 ?? cs.onSurfaceVariant;
    final Color line = ext?.line ?? cs.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Text(
            'NOTES',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: ink3,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space12),
        Semantics(
          label: 'Notes text field',
          hint: 'Add any observations or concerns',
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              TextField(
                controller: _ctrl,
                minLines: 3,
                maxLines: 6,
                onChanged: (v) =>
                    context.read<CareLogCubit>().updateNotes(v),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Add any observations or concerns…',
                  hintStyle: TextStyle(fontSize: 16, color: ink3),
                  fillColor: cs.surface,
                  filled: true,
                  contentPadding: const EdgeInsets.all(18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: line, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                ),
              ),
              // Floating label
              Positioned(
                top: -10,
                left: 16,
                child: ExcludeSemantics(
                  child: Container(
                    color: cs.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ACTION BUTTONS
// =============================================================================

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
    final ext = theme.extension<AppExtendedCustomColors>();
    final Color line = ext?.line ?? cs.outline;

    return Column(
      children: [
        // Save Log — primary
        Semantics(
          button: true,
          label: 'Save care log',
          child: GestureDetector(
            onTap: () => context.read<CareLogCubit>().save(),
            child: Container(
              height: AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius:
                    BorderRadius.circular(AppDimensions.buttonHeight / 2),
                boxShadow: [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.38),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(Icons.check_circle_outline,
                        size: 22, color: Colors.white),
                  ),
                  const SizedBox(width: 9),
                  ExcludeSemantics(
                    child: Text(
                      'Save Log',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // View past logs — outlined
        Semantics(
          button: true,
          label: 'View past care logs',
          child: GestureDetector(
            onTap: () {
              // TODO(prosthetic-hub): navigate to past logs screen
              announce(context, 'Past care logs — coming soon.');
            },
            child: Container(
              height: AppDimensions.buttonHeight,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius:
                    BorderRadius.circular(AppDimensions.buttonHeight / 2),
                border: Border.all(color: line, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      Icons.history,
                      size: 22,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 9),
                  ExcludeSemantics(
                    child: Text(
                      'View Past Logs',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
