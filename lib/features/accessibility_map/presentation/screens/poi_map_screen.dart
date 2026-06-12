// POI Map Screen — optional flutter_map visual layer.
//
// Accessibility contract:
//   • The map tile layer is wrapped in ExcludeSemantics — it is decorative
//     for screen-reader users. The list of POIs below is the SR-accessible
//     equivalent (Risk R5 from the plan).
//   • The map must never be the only way to reach a POI — tapping a marker
//     navigates to the same detail screen as the list.
//   • Accessible back button ≥ 48dp; "View list" button always reachable.
//   • Atkinson Hyperlegible font inherited from theme.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import 'package:opto/core/constants/app_dimensions.dart';
import 'package:opto/core/constants/app_routes.dart';
import 'package:opto/features/accessibility_map/domain/entities/accessibility_poi_entity.dart';
import 'package:opto/features/accessibility_map/presentation/bloc/nearby_pois/nearby_pois_bloc.dart';
import 'package:opto/features/accessibility_map/presentation/widgets/poi_list_tile.dart';

/// Screen — optional flutter_map visual view of nearby POIs.
///
/// Reads from the already-populated [NearbyPoisBloc] (provided by the router
/// ancestor). If not loaded yet, shows the list-view only.
class PoiMapScreen extends StatefulWidget {
  const PoiMapScreen({super.key});

  @override
  State<PoiMapScreen> createState() => _PoiMapScreenState();
}

class _PoiMapScreenState extends State<PoiMapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            _MapHeader(cs: cs),

            // ── Map + list ───────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<NearbyPoisBloc, NearbyPoisState>(
                builder: (context, state) {
                  final List<AccessibilityPoiEntity> pois =
                      state is NearbyPoisLoaded ? state.pois : [];

                  return Column(
                    children: [
                      // Map panel — decorative; ExcludeSemantics wraps tiles.
                      // Markers are accessible via the list below.
                      SizedBox(
                        height: 280,
                        child: ExcludeSemantics(
                          child: _MapPanel(
                            pois: pois,
                            mapController: _mapController,
                            onMarkerTap: (poi) => context.pushNamed(
                              AppRoutes.poiDetail.name,
                              pathParameters: {'poiId': poi.id},
                            ),
                          ),
                        ),
                      ),

                      // Accessible list — screen-reader entry point.
                      Expanded(
                        child: pois.isEmpty
                            ? Center(
                                child: Text(
                                  'No accessible places loaded. '
                                  'Go back to the list to load places near you.',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.screenPaddingMin,
                                  vertical: AppDimensions.space8,
                                ),
                                itemCount: pois.length,
                                separatorBuilder: (_, _) => const SizedBox(
                                  height: AppDimensions.space8,
                                ),
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
                              ),
                      ),
                    ],
                  );
                },
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

class _MapHeader extends StatelessWidget {
  const _MapHeader({required this.cs});

  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 22,
        top: 14,
        bottom: 4,
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Back to list',
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
                'Map View',
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
      ),
    );
  }
}

/// The flutter_map tile + marker widget.
///
/// Wrapped in ExcludeSemantics by the caller — the SR-accessible equivalent
/// is the list below the map.
class _MapPanel extends StatelessWidget {
  const _MapPanel({
    required this.pois,
    required this.mapController,
    required this.onMarkerTap,
  });

  final List<AccessibilityPoiEntity> pois;
  final MapController mapController;
  final ValueChanged<AccessibilityPoiEntity> onMarkerTap;

  static const LatLng _defaultCenter = LatLng(-6.2088, 106.8456); // Jakarta

  LatLng get _center {
    if (pois.isEmpty) return _defaultCenter;
    final first = pois.first;
    return LatLng(first.lat, first.lng);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: 15,
      ),
      children: [
        // OpenStreetMap tiles — no API key required.
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.opto.app',
        ),
        // POI markers.
        MarkerLayer(
          markers: pois
              .map(
                (poi) => Marker(
                  point: LatLng(poi.lat, poi.lng),
                  width: AppDimensions.minTapTarget,
                  height: AppDimensions.minTapTarget,
                  child: GestureDetector(
                    onTap: () => onMarkerTap(poi),
                    child: Icon(
                      Icons.place,
                      size: 36,
                      color: cs.primary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
