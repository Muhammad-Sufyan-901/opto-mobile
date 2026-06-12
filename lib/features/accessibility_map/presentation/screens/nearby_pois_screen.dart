// Nearby POIs Screen — primary Accessibility Map entry point.
//
// Accessibility contract:
//   • Primary UX is a spoken/scrollable list — completable without sight.
//   • Results count announced as a live region on load.
//   • Location denial → spoken message + alphabetical fallback (no crash).
//   • All tap targets ≥ 48dp (AppDimensions.minTapTarget).
//   • Contrast ≥ 4.5:1; text reflows to 300% via MediaQuery.textScaler.
//   • "View map" button navigates to the visual flutter_map screen (optional).
//   • "Add a place" FAB requires auth and location.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:opto/core/accessibility/accessibility.dart';
import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/core/location/location.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/nearby_pois/nearby_pois_bloc.dart';
import 'package:opto/features/accessibility_map/presentation/widgets/poi_list_tile.dart';

/// Screen — Accessibility Map nearby POIs list.
///
/// Acquires device position on init via [LocationService] (from DI), then
/// dispatches [LoadNearbyPois]. On permission failure it falls back to the
/// alphabetical full list and shows a spoken status message.
class NearbyPoisScreen extends StatefulWidget {
  const NearbyPoisScreen({super.key, required this.locationService});

  final LocationService locationService;

  @override
  State<NearbyPoisScreen> createState() => _NearbyPoisScreenState();
}

class _NearbyPoisScreenState extends State<NearbyPoisScreen> {
  @override
  void initState() {
    super.initState();
    _loadPois();
  }

  Future<void> _loadPois() async {
    final result = await widget.locationService.getCurrentPosition();

    if (!mounted) return;

    double? lat;
    double? lng;

    switch (result) {
      case LocationSuccess(:final position):
        lat = position.latitude;
        lng = position.longitude;
      case LocationPermissionDenied(:final permanentlyDenied):
        announce(
          context,
          permanentlyDenied
              ? 'Location permission permanently denied. '
                  'Open Settings to enable location, or browse all places.'
              : 'Location permission denied. Showing all accessible places.',
        );
      case LocationServiceDisabled():
        announce(
          context,
          'Location services are off. Showing all accessible places.',
        );
      case LocationError(:final message):
        announce(context, 'Location unavailable: $message');
    }

    context.read<NearbyPoisBloc>().add(
          NearbyPoisEvent.load(lat: lat, lng: lng),
        );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            _MapScreenHeader(
              cs: cs,
              onViewMap: () => context.pushNamed(
                AppRoutes.accessibilityMapVisual.name,
              ),
            ),

            // ── Content ──────────────────────────────────────────────────
            Expanded(
              child: BlocListener<NearbyPoisBloc, NearbyPoisState>(
                listenWhen: (prev, curr) =>
                    curr is NearbyPoisLoaded && prev is! NearbyPoisLoaded,
                listener: (context, state) {
                  if (state is NearbyPoisLoaded) {
                    final count = state.pois.length;
                    final sorted = state.locationAvailable
                        ? 'sorted by distance'
                        : 'sorted alphabetically';
                    announce(
                      context,
                      'Accessible places. $count result${count != 1 ? 's' : ''}, $sorted.',
                    );
                  }
                },
                child: BlocBuilder<NearbyPoisBloc, NearbyPoisState>(
                  builder: (context, state) {
                    return switch (state) {
                      NearbyPoisInitial() || NearbyPoisLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      NearbyPoisLoaded(:final pois) => pois.isEmpty
                          ? _EmptyState(cs: cs, onRetry: _loadPois)
                          : _PoiList(pois: pois),
                      NearbyPoisError(:final message) => _ErrorState(
                          message: message,
                          onRetry: _loadPois,
                        ),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      // ── FAB — Add a place ──────────────────────────────────────────────
      floatingActionButton: Semantics(
        button: true,
        label: 'Add an accessible place',
        child: FloatingActionButton.extended(
          onPressed: () => context.pushNamed(AppRoutes.addPoi.name),
          icon: const ExcludeSemantics(child: Icon(Icons.add_location_outlined)),
          label: const ExcludeSemantics(child: Text('Add a place')),
        ),
      ),
    );
  }
}

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _MapScreenHeader extends StatelessWidget {
  const _MapScreenHeader({
    required this.cs,
    required this.onViewMap,
  });

  final ColorScheme cs;
  final VoidCallback onViewMap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        top: 14,
        bottom: 4,
      ),
      child: Row(
        children: [
          // Back button
          Semantics(
            button: true,
            label: 'Back',
            child: GestureDetector(
              onTap: () {
                if (context.canPop()) context.pop();
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
                'Accessible Places',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          // "View map" icon button
          Semantics(
            button: true,
            label: 'View map',
            child: GestureDetector(
              onTap: onViewMap,
              child: SizedBox(
                width: AppDimensions.minTapTarget,
                height: AppDimensions.minTapTarget,
                child: Center(
                  child: ExcludeSemantics(
                    child: Icon(Icons.map_outlined, size: 24, color: cs.primary),
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

class _PoiList extends StatelessWidget {
  const _PoiList({required this.pois});

  final List pois;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingMin,
        vertical: AppDimensions.space8,
      ),
      itemCount: pois.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppDimensions.space12),
      itemBuilder: (context, index) {
        final poi = pois[index];
        return PoiListTile(
          poi: poi,
          onTap: () => context.pushNamed(
            AppRoutes.poiDetail.name,
            pathParameters: {'poiId': poi.id},
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.cs, required this.onRetry});

  final ColorScheme cs;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.place_outlined, size: 64, color: cs.onSurfaceVariant),
              const SizedBox(height: AppDimensions.space16),
              Text(
                'No accessible places found nearby',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Be the first to add one using the button below.',
                textAlign: TextAlign.center,
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading places',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: onRetry,
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

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;
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
              Text(
                message,
                textAlign: TextAlign.center,
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: cs.onSurface),
              ),
              const SizedBox(height: AppDimensions.space24),
              Semantics(
                button: true,
                label: 'Retry loading accessible places',
                child: SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: onRetry,
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
