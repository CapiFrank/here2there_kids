import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:here2there_kids/components/search_overlay.dart';
import 'package:here2there_kids/screens/map/widgets/location_fab.dart';
import 'package:here2there_kids/screens/map/widgets/map_view.dart';
import 'package:here2there_kids/screens/map/widgets/north_fab.dart';
import 'package:here2there_kids/screens/map/widgets/place_info_modal.dart';
import 'package:here2there_kids/utils/error_handler.dart';
import 'package:here2there_kids/services/location_progress_service.dart';
import 'package:here2there_kids/utils/nearby_searcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final MapController _mapController = MapController();

  double _fabBottomPadding = 16;
  List<LatLng> _route = [];
  Place? _selectedPlace;
  double _distance = 0;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    context.read<LocationProgressService>().listenToLocationChanges();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sheetController.addListener(_updateFabPadding);
    });
  }

  void _updateFabPadding() {
    setState(() {
      _fabBottomPadding = _calculateFabBottomPadding(context);
    });
  }

  double _calculateFabBottomPadding(BuildContext context) {
    if (_sheetController.isAttached) {
      final extent = _sheetController.size;
      final screenHeight = MediaQuery.of(context).size.height;
      return screenHeight * extent + 10;
    }
    return 16;
  }

  Future<void> _fetchRoute(LatLng currentLocation, LatLng destination) async {
    final geometry = await context
        .read<LocationProgressService>()
        .fetchRouteGeometry(
          currentLocation,
          destination,
          userAgent: 'com.csdev.here2there',
        );
    setState(() {
      _route = LocationProgressService().decodePolyline(geometry);
    });
  }

  Future<void> _goToUserLocation(LatLng? currentLocation) async {
    if (currentLocation != null) {
      _mapController.move(currentLocation, 15);
    }
  }

  void _onPlaceSelected(Place place) async {
    final newDestination = LatLng(place.lat, place.lon);
    final locationService = context.read<LocationProgressService>();
    final currentLocation = locationService.currentLocation;
    if (currentLocation != null) {
      locationService.setDestination(newDestination);
      final distance = await locationService.fetchRouteDistance(
        currentLocation,
        newDestination,
        userAgent: 'com.csdev.here2there',
      );
      setState(() {
        _selectedPlace = place;
        _distance = distance;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateFabPadding());
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(currentLocation, newDestination),
          padding: EdgeInsets.all(115),
        ),
      );
      await _fetchRoute(currentLocation, newDestination);
    } else {
      ErrorHandler.show('Ubicación actual no disponible.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationService = context.watch<LocationProgressService>();
    final currentLocation = locationService.currentLocation;
    final destination = locationService.destination;
    final isLoading = locationService.isLoading;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                )
                : MapView(
                  mapController: _mapController,
                  currentLocation: currentLocation,
                  destination: destination,
                  route: _route,
                  onMapReady:
                      () => setState(() {
                        _mapReady = true;
                      }),
                  onTap: (tapPosition) {
                    _onPlaceSelected(tapPosition);
                    FocusScope.of(context).unfocus();
                  },
                ),

            // _buildMap(locationService),
            if (_selectedPlace != null)
              PlaceInfoModal(
                place: _selectedPlace!,
                onClose: () {
                  setState(() {
                    _selectedPlace = null;
                    _distance = 0;
                    _route = [];
                  });
                  locationService.setDestination(null);
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _updateFabPadding(),
                  );
                  _goToUserLocation(currentLocation);
                },
                onNavigate: () async {
                  final locationService =
                      context.read<LocationProgressService>();
                  await locationService.startTrackingProgressToDestination(
                    userAgent: 'com.csdev.here2there',
                  );

                  if (context.mounted) {
                    Navigator.pushNamed(context, '/travel');
                  }
                },
                controller: _sheetController,
                distance: _distance,
              ),
            LocationFAB(
              bottomPadding: _fabBottomPadding,
              onPressed: () => _goToUserLocation(currentLocation),
            ),
            if (_mapReady)
              if (_mapController.camera.rotation != 0)
                NorthFAB(
                  bottomPadding: _fabBottomPadding + 60,
                  onPressed: () => _mapController.rotate(0),
                ),
            SearchOverlay<Place>(
              itemLabel: (place) => place.name,
              itemDescription: (place) => place.displayName,
              onItemSelected: (place) => _onPlaceSelected(place),
              onChanged: (text) async {
                if (currentLocation == null) return [];
                final searcher = NearbySearcher(
                  lat: currentLocation.latitude,
                  lon: currentLocation.longitude,
                  query: text,
                  userAgent: 'com.csdev.here2there',
                );
                return await searcher.searchNearbyWithFallback();
              },
            ),
          ],
        ),
      ),
    );
  }
}
