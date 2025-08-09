import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:here2there_kids/screens/map/widgets/destination_marker.dart';
import 'package:here2there_kids/utils/nearby_searcher.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final MapController mapController;
  final LatLng? currentLocation;
  final LatLng? destination;
  final List<LatLng> route;
  final Function(Place) onTap;
  final Function()? onMapReady;

  const MapView({
    super.key,
    required this.mapController,
    required this.currentLocation,
    required this.destination,
    required this.route,
    required this.onTap,
    required this.onMapReady
  });

  @override
  Widget build(BuildContext context) {
    final bool isLoading = currentLocation == null;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.blue));
    }
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onMapReady: onMapReady,
        initialCenter: currentLocation ?? LatLng(0, 0),
        initialZoom: 2,
        minZoom: 0,
        maxZoom: 100,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onTap: (_, point) async {
          final lon = point.longitude;
          final lat = point.latitude;
          final displayName = await NearbySearcher.getNearbyPlaceName(lat, lon);
          final place = Place(
            name: 'Dropped pin',
            displayName: displayName,
            lat: lat,
            lon: lon,
          );
          onTap(place);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.csdev.here2there',
        ),

        // Ruta dibujada
        if (route.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                strokeWidth: 5,
                color: Colors.cyan.withAlpha(150),
                borderColor: Colors.blue,
                borderStrokeWidth: 3,
              ),
            ],
          ),
        if (currentLocation != null)
          CurrentLocationLayer(
            style: const LocationMarkerStyle(
              marker: DefaultLocationMarker(
                child: Icon(Icons.location_pin, color: Colors.white),
              ),
              markerSize: Size(35, 35),
              markerDirection: MarkerDirection.north,
            ),
          ),
        // Marcadores
        if (destination != null) DestinationMarker(destination: destination!),
      ],
    );
  }
}
