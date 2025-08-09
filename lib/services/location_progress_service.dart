import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:here2there_kids/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationProgressService with ChangeNotifier {
  static final LocationProgressService _instance =
      LocationProgressService._internal();
  factory LocationProgressService() => _instance;

  LocationProgressService._internal() {
    _location = Location();
  }

  late final Location _location;
  LatLng? _destination;
  LatLng? _currentLocation;
  double _progress = 0.15;
  double? _initialDistance;
  StreamSubscription<LocationData>? _subscription;
  bool _isLoading = false;

  double get progress => _progress;
  LatLng? get currentLocation => _currentLocation;
  LatLng? get destination => _destination;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    safeNotifyListeners();
  }

  void safeNotifyListeners() {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void setDestination(LatLng? destination) {
    _destination = destination;
    _initialDistance = null;
  }

  Future<Map<String, dynamic>?> _fetchRouteData(
    LatLng from,
    LatLng to, {
    bool overview = false,
    String userAgent = 'MyApp/1.0 (email@example.com)',
  }) async {
    try {
      final url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/'
        '${from.longitude},${from.latitude};'
        '${to.longitude},${to.latitude}?overview=${overview ? "full" : "false"}&geometries=polyline',
      );
      final response = await http.get(url, headers: {'User-Agent': userAgent});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      ErrorHandler.show('Error fetching route data: $e');
    }
    return null;
  }

  Future<double> fetchRouteDistance(
    LatLng? from,
    LatLng? to, {
    required String userAgent,
  }) async {
    _setLoading(true);
    try {
      if (from == null || to == null) return 0;
      final data = await _fetchRouteData(from, to, overview: false);
      if (data == null) return 0;

      return (data['routes'][0]['legs'][0]['distance'] as num).toDouble();
    } catch (e) {
      ErrorHandler.show('Error parsing route distance: $e');
      return 0;
    } finally {
      _setLoading(false);
    }
  }

  Future<String> fetchRouteGeometry(
    LatLng from,
    LatLng to, {
    required String userAgent,
  }) async {
    _setLoading(true);
    try {
      final data = await _fetchRouteData(from, to, overview: true);
      if (data == null) return '';

      return data['routes'][0]['geometry'] as String;
    } catch (e) {
      ErrorHandler.show('Error parsing route geometry: $e');
      return '';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> listenToLocationChanges({
    Future<void> Function()? onLocationUpdated,
  }) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return;

    stop(); // Detiene suscripciones anteriores
    
    await _location.changeSettings(
      accuracy: LocationAccuracy.high, // máxima precisión para navegación
      interval: 1000, // en ms: cada 1 segundo
      distanceFilter: 1, // en metros: actualiza si se mueve 1m o más
    );

    _subscription = _location.onLocationChanged.listen((locationData) async {
      if (locationData.latitude == null || locationData.longitude == null) {
        return;
      }

      _currentLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      safeNotifyListeners();
      if (onLocationUpdated != null) {
        await onLocationUpdated(); // Asegura que se espere si es async
      }
    });
  }

  Future<void> startTrackingProgressToDestination({
    required String userAgent,
  }) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission || _destination == null) return;

    await listenToLocationChanges(
      onLocationUpdated: () async {
        final distance = await fetchRouteDistance(
          _currentLocation!,
          _destination!,
          userAgent: userAgent,
        );

        _initialDistance ??= distance;
        _updateProgress(distance);
        safeNotifyListeners();
      },
    );
  }

  void _updateProgress(double distanceToDestination) {
    const double marginError = 10; // metros

    if (distanceToDestination <= marginError) {
      _progress = 0.85; // Llegó al destino (o muy cerca)
    } else {
      final progressRatio =
          (1 -
              ((distanceToDestination - marginError) /
                      (_initialDistance! - marginError))
                  .clamp(0, 1));
      _progress = (0.15 + progressRatio * (0.85 - 0.15)).clamp(0.15, 0.85);
    }
  }

  Future<bool> checkPermissions() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _location.requestService();
    if (!serviceEnabled) {
      ErrorHandler.show('Activa el servicio de ubicación.');
      return false;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    if (permissionGranted != PermissionStatus.granted) {
      ErrorHandler.show('Permiso de ubicación denegado.');
      return false;
    }

    return true;
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  List<LatLng> decodePolyline(String geometry) {
    List<PointLatLng> decodedPoints = PolylinePoints.decodePolyline(geometry);
    return decodedPoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }
}
