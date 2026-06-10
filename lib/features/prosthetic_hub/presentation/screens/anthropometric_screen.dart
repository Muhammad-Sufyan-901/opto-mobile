// Anthropometric Measurements Screen — Prosthetic Hub.
//
// 🔒 Displays and edits the current user's socket/iris measurements.
//    Owner-only data — never route to this screen without authentication.
//
// Accessibility:
//   - Announces screen and load/save results via live regions.
//   - All fields have Semantics labels.
//   - Tap targets ≥ 48dp.
//   - Numeric fields use TextInputType.numberWithOptions(decimal: true).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/constants/prosthetic_enums.dart';
import 'package:opto/features/prosthetic_hub/domain/entities/anthropometric_entity.dart';
import 'package:opto/features/prosthetic_hub/presentation/bloc/anthropometric/anthropometric_cubit.dart';

/// Screen — view and edit anthropometric socket/iris measurements.
class AnthropometricScreen extends StatefulWidget {
  const AnthropometricScreen({super.key});

  @override
  State<AnthropometricScreen> createState() => _AnthropometricScreenState();
}

class _AnthropometricScreenState extends State<AnthropometricScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnthropometricCubit>().loadMeasurements();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocConsumer<AnthropometricCubit, AnthropometricState>(
          listenWhen: (_, curr) =>
              curr is AnthropometricLoaded ||
              curr is AnthropometricSaved ||
              curr is AnthropometricError,
          listener: (context, state) {
            if (state is AnthropometricLoaded) {
              announce(context, 'My measurements.');
            } else if (state is AnthropometricSaved) {
              announce(context, 'Measurements saved.');
              // Reload to reflect the freshly saved data.
              context.read<AnthropometricCubit>().loadMeasurements();
            } else if (state is AnthropometricError) {
              announce(context, state.message);
            }
          },
          builder: (context, state) => switch (state) {
            AnthropometricInitial() ||
            AnthropometricLoading() =>
              const Center(child: CircularProgressIndicator()),
            AnthropometricSaved() =>
              const Center(child: CircularProgressIndicator()),
            AnthropometricLoaded(:final measurements) =>
              _MeasurementsForm(existing: measurements),
            AnthropometricError(:final message) =>
              _ErrorView(message: message),
          },
        ),
      ),
    );
  }
}

// =============================================================================
// MEASUREMENTS FORM
// =============================================================================

class _MeasurementsForm extends StatefulWidget {
  const _MeasurementsForm({required this.existing});
  final AnthropometricEntity? existing;

  @override
  State<_MeasurementsForm> createState() => _MeasurementsFormState();
}

class _MeasurementsFormState extends State<_MeasurementsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _socketCtrl;
  late final TextEditingController _curvatureCtrl;
  late final TextEditingController _irisCtrl;
  late final TextEditingController _irisHexCtrl;
  DataSource _source = DataSource.selfMeasured;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _socketCtrl = TextEditingController(
      text: e?.socketSizeMm?.toString() ?? '',
    );
    _curvatureCtrl = TextEditingController(
      text: e?.curvature?.toString() ?? '',
    );
    _irisCtrl = TextEditingController(
      text: e?.irisDiameterMm?.toString() ?? '',
    );
    _irisHexCtrl = TextEditingController(
      text: e?.matchedIrisHex ?? '',
    );
    _source = e?.source ?? DataSource.selfMeasured;
  }

  @override
  void dispose() {
    _socketCtrl.dispose();
    _curvatureCtrl.dispose();
    _irisCtrl.dispose();
    _irisHexCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AnthropometricCubit>().saveMeasurements(
          socketSizeMm: double.tryParse(_socketCtrl.text.trim()),
          curvature: double.tryParse(_curvatureCtrl.text.trim()),
          irisDiameterMm: double.tryParse(_irisCtrl.text.trim()),
          matchedIrisHex: _irisHexCtrl.text.trim().isEmpty
              ? null
              : _irisHexCtrl.text.trim(),
          source: _source,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 22,
        right: 22,
        top: 14,
        bottom: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            _ScreenHeader(cs: cs),

            const SizedBox(height: AppDimensions.sectionGap),

            // ── Numeric fields ─────────────────────────────────────────────
            _MeasurementField(
              controller: _socketCtrl,
              label: 'Socket size (mm)',
              semanticsLabel: 'Socket size in millimetres',
            ),
            const SizedBox(height: AppDimensions.space16),
            _MeasurementField(
              controller: _curvatureCtrl,
              label: 'Curvature (mm)',
              semanticsLabel: 'Curvature in millimetres',
            ),
            const SizedBox(height: AppDimensions.space16),
            _MeasurementField(
              controller: _irisCtrl,
              label: 'Iris diameter (mm)',
              semanticsLabel: 'Iris diameter in millimetres',
            ),
            const SizedBox(height: AppDimensions.space16),

            // ── Iris hex colour ────────────────────────────────────────────
            Semantics(
              label: 'Matched iris colour hex code',
              child: TextFormField(
                controller: _irisHexCtrl,
                decoration: const InputDecoration(
                  labelText: 'Matched iris colour (hex)',
                  hintText: '#A1B2C3',
                ),
                keyboardType: TextInputType.text,
              ),
            ),

            const SizedBox(height: AppDimensions.space24),

            // ── Source selector ────────────────────────────────────────────
            Semantics(
              label: 'Measurement source',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Measured by',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Row(
                    children: [
                      _SourceChip(
                        label: 'Self',
                        selected: _source == DataSource.selfMeasured,
                        onTap: () =>
                            setState(() => _source = DataSource.selfMeasured),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      _SourceChip(
                        label: 'Ocularist',
                        selected: _source == DataSource.ocularistRecord,
                        onTap: () => setState(
                          () => _source = DataSource.ocularistRecord,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.space32),

            // ── Save button ────────────────────────────────────────────────
            Semantics(
              button: true,
              label: 'Save measurements',
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const ExcludeSemantics(child: Text('Save')),
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
// PRIVATE WIDGETS
// =============================================================================

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Semantics(
          button: true,
          label: 'Back',
          child: GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoutes.prostheticHub.name);
              }
            },
            child: const SizedBox(
              width: AppDimensions.minTapTarget,
              height: AppDimensions.minTapTarget,
              child: Center(
                child: ExcludeSemantics(
                  child: Icon(Icons.chevron_left, size: 28),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ExcludeSemantics(
            child: Text(
              'My Measurements',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: AppDimensions.minTapTarget,
          height: AppDimensions.minTapTarget,
        ),
      ],
    );
  }
}

class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.controller,
    required this.label,
    required this.semanticsLabel,
  });

  final TextEditingController controller;
  final String label;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return null; // nullable field
          if (double.tryParse(v.trim()) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label measurement source',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: AppDimensions.minTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
          ),
          alignment: Alignment.center,
          child: ExcludeSemantics(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? cs.onPrimary : cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: AppDimensions.space16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading measurements',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: () =>
                        context.read<AnthropometricCubit>().loadMeasurements(),
                    child: const ExcludeSemantics(child: Text('Retry')),
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
