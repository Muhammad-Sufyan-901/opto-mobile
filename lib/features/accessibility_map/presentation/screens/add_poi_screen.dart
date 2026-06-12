// Add POI Screen — accessible form to submit a new accessibility place.
//
// Accessibility contract:
//   • Location acquired on init (same service as NearbyPoisScreen).
//   • Form errors announced via live regions on submit attempt.
//   • All tap targets ≥ 48dp; name field semantics label present.
//   • Submit result announced via live region (success / error).
//   • Haptic: success pattern on successful insert.
//   • Text reflows to 300% via MediaQuery.textScaler.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/map_enums.dart';
import 'package:opto/core/location/location.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/add_poi/add_poi_cubit.dart';

/// Screen — form to add a new accessibility point of interest.
///
/// Requires [LocationService] to stamp the current position as lat/lng.
class AddPoiScreen extends StatefulWidget {
  const AddPoiScreen({super.key, required this.locationService});

  final LocationService locationService;

  @override
  State<AddPoiScreen> createState() => _AddPoiScreenState();
}

class _AddPoiScreenState extends State<AddPoiScreen> {
  final _nameController = TextEditingController();
  final Map<PoiAttribute, bool> _attributes = {
    for (final attr in PoiAttribute.values) attr: false,
  };

  double? _lat;
  double? _lng;
  bool _locationLoading = true;

  @override
  void initState() {
    super.initState();
    _acquireLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _acquireLocation() async {
    final result = await widget.locationService.getCurrentPosition();
    if (!mounted) return;
    switch (result) {
      case LocationSuccess(:final position):
        setState(() {
          _lat = position.latitude;
          _lng = position.longitude;
          _locationLoading = false;
        });
      case LocationPermissionDenied(:final permanentlyDenied):
        announce(
          context,
          permanentlyDenied
              ? 'Location permanently denied. '
                  'Open Settings to enable it, then return to add a place.'
              : 'Location permission denied. Location is required to add a place.',
        );
        setState(() => _locationLoading = false);
      case LocationServiceDisabled():
        announce(
          context,
          'Location services are off. Enable them to add a place.',
        );
        setState(() => _locationLoading = false);
      case LocationError():
        setState(() => _locationLoading = false);
    }
  }

  void _submit() {
    final lat = _lat;
    final lng = _lng;
    if (lat == null || lng == null) {
      announce(
        context,
        'Location unavailable. Please enable location services and try again.',
      );
      return;
    }

    context.read<AddPoiCubit>().submit(
          name: _nameController.text,
          lat: lat,
          lng: lng,
          attributes: {
            for (final entry in _attributes.entries)
              entry.key.jsonKey: entry.value,
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: BlocListener<AddPoiCubit, AddPoiState>(
          listener: (context, state) {
            if (state is AddPoiSuccess) {
              announce(context, state.message);
              HapticPatterns.success();
              // Navigate back to the list after a brief delay.
              Future.delayed(
                const Duration(milliseconds: 400),
                () {
                  if (context.mounted && context.canPop()) context.pop();
                },
              );
            }
            if (state is AddPoiError) {
              announce(context, 'Error: ${state.message}');
              HapticPatterns.warning();
            }
          },
          child: CustomScrollView(
            slivers: [
              // ── Header ────────────────────────────────────────────────
              SliverAppBar(
                backgroundColor: cs.surface,
                elevation: 0,
                leading: Semantics(
                  button: true,
                  label: 'Cancel and go back',
                  child: GestureDetector(
                    onTap: () {
                      if (context.canPop()) context.pop();
                    },
                    child: const SizedBox(
                      width: AppDimensions.minTapTarget,
                      height: AppDimensions.minTapTarget,
                      child: Center(
                        child: ExcludeSemantics(
                          child: Icon(Icons.close, size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                title: ExcludeSemantics(
                  child: Text(
                    'Add Accessible Place',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingMin,
                    vertical: AppDimensions.space8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Location status ───────────────────────────
                      _LocationStatus(
                        loading: _locationLoading,
                        lat: _lat,
                        lng: _lng,
                      ),

                      const SizedBox(height: AppDimensions.space20),

                      // ── Name field ───────────────────────────────
                      Semantics(
                        label: 'Place name, required',
                        child: TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'Place name',
                            hintText: 'e.g. City Mall entrance',
                            border: const OutlineInputBorder(),
                            prefixIcon: const ExcludeSemantics(
                              child: Icon(Icons.place_outlined),
                            ),
                            filled: true,
                            fillColor: cs.surface,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space24),

                      // ── Attribute toggles ─────────────────────────
                      ExcludeSemantics(
                        child: Text(
                          'Accessibility features',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space8),

                      ..._attributes.entries.map(
                        (entry) => _AttributeToggle(
                          attribute: entry.key,
                          value: entry.value,
                          onChanged: (v) => setState(
                            () => _attributes[entry.key] = v,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.space32),

                      // ── Submit / error ─────────────────────────────
                      BlocBuilder<AddPoiCubit, AddPoiState>(
                        builder: (context, state) {
                          if (state is AddPoiError) {
                            return Column(
                              children: [
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    state.message,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.space12),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      BlocBuilder<AddPoiCubit, AddPoiState>(
                        builder: (context, state) {
                          final isSubmitting = state is AddPoiSubmitting;
                          return Semantics(
                            button: true,
                            label: 'Submit this accessible place',
                            child: SizedBox(
                              width: double.infinity,
                              height: AppDimensions.minTapTarget,
                              child: ElevatedButton(
                                onPressed: isSubmitting || _locationLoading
                                    ? null
                                    : _submit,
                                child: isSubmitting
                                    ? const ExcludeSemantics(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : const ExcludeSemantics(
                                        child: Text('Add this place'),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppDimensions.space32),
                    ],
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
// PRIVATE WIDGETS
// =============================================================================

class _LocationStatus extends StatelessWidget {
  const _LocationStatus({
    required this.loading,
    required this.lat,
    required this.lng,
  });

  final bool loading;
  final double? lat;
  final double? lng;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    if (loading) {
      return Semantics(
        liveRegion: true,
        label: 'Acquiring your location',
        child: Row(
          children: [
            const ExcludeSemantics(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            ExcludeSemantics(
              child: Text(
                'Getting your location…',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (lat == null || lng == null) {
      return Semantics(
        liveRegion: true,
        label: 'Location unavailable. Enable location services to add a place.',
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.space12),
          decoration: BoxDecoration(
            color: cs.errorContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
          ),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(Icons.location_off, color: cs.error, size: 20),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    'Location unavailable. Enable location services to add a place.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      label: 'Location acquired. Your current position will be used.',
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space12),
        decoration: BoxDecoration(
          color: cs.tertiaryContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusChip),
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(Icons.my_location, color: cs.tertiary, size: 20),
            ),
            const SizedBox(width: AppDimensions.space8),
            ExcludeSemantics(
              child: Text(
                'Location acquired. This place will be added at your current position.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttributeToggle extends StatelessWidget {
  const _AttributeToggle({
    required this.attribute,
    required this.value,
    required this.onChanged,
  });

  final PoiAttribute attribute;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: '${attribute.displayLabel}: ${value ? 'on' : 'off'}',
      child: SizedBox(
        height: AppDimensions.minTapTarget,
        child: Row(
          children: [
            ExcludeSemantics(
              child: Switch(
                value: value,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            ExcludeSemantics(
              child: Text(
                attribute.displayLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
