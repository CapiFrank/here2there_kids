import 'dart:convert';
import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:here2there_kids/utils/error_handler.dart';
import 'package:http/http.dart' as http;

class Place {
  final String name;
  final String displayName;
  final double lat;
  final double lon;

  Place({
    required this.name,
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      displayName: json['display_name'],
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
    );
  }
}

class NearbySearcher {
  final double lat;
  final double lon;
  final String query;
  final String userAgent;
  final List<int> radiusSteps;

  NearbySearcher({
    required this.lat,
    required this.lon,
    required this.query,
    this.userAgent = 'MyApp/1.0 (email@example.com)',
    this.radiusSteps = const [1, 5, 10, 20, 50],
  });

  /// Método principal que busca en varios radios
  Future<List<Place>> searchNearby() async {
    for (int radius in radiusSteps) {
      final viewbox = _getViewbox(lat, lon, radius.toDouble());
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}'
        '&format=json'
        '&bounded=1'
        '&viewbox=${viewbox.join(',')}'
        '&limit=10',
      );

      final response = await http.get(url, headers: {'User-Agent': userAgent});

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data.map((e) => Place.fromJson(e)).toList();
        }
      }
    }

    ErrorHandler.show('🕵️ No se encontraron resultados en radios definidos.');
    return [];
  }

  /// Si no encuentra nada cerca, intenta una búsqueda global más precisa
  Future<List<Place>> searchNearbyWithFallback({String? fallbackQuery}) async {
    final localResults = await searchNearby();

    final queryToUse = fallbackQuery ?? query;
    final geocodeUrl = Uri.parse(
      'https://nominatim.openstreetmap.org/search'
      '?q=${Uri.encodeComponent(queryToUse)}'
      '&format=json',
    );

    final geoResponse = await http.get(
      geocodeUrl,
      headers: {'User-Agent': userAgent},
    );

    if (geoResponse.statusCode == 200) {
      final data = jsonDecode(geoResponse.body);
      if (data.isNotEmpty) {
        final fallbackLat = double.parse(data[0]['lat']);
        final fallbackLon = double.parse(data[0]['lon']);
        final searcher = NearbySearcher(
          lat: fallbackLat,
          lon: fallbackLon,
          query: query,
          userAgent: userAgent,
          radiusSteps: radiusSteps,
        );
        final fallbackResults = await searcher.searchNearby();

        if (localResults.isEmpty) {
          return fallbackResults;
        } else {
          // Combina sin duplicados (opcional)
          final combined = [...fallbackResults];
          for (var place in localResults) {
            if (!combined.any(
              (p) => p.lat == place.lat && p.lon == place.lon,
            )) {
              combined.insert(0, place);
            }
          }
          return combined;
        }
      }
    }
    ErrorHandler.show('🕵️ No se encontraron resultados.');
    return [];
  }

  /// Cálculo del viewbox según lat/lon/radio
  List<double> _getViewbox(double lat, double lon, double radiusKm) {
    const double kmPerDegree = 111.0;
    final double latOffset = radiusKm / kmPerDegree;
    final double lonOffset = radiusKm / (kmPerDegree * cos(lat * pi / 180));

    double minLon = lon - lonOffset;
    double maxLon = lon + lonOffset;
    double minLat = lat - latOffset;
    double maxLat = lat + latOffset;

    return [minLon, maxLat, maxLon, minLat];
  }

  static Future<String> getNearbyPlaceName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Función auxiliar para validar
        String safePart(String? value) =>
            (value != null && value.trim().isNotEmpty) ? '$value, ' : '';

        final subLocality = safePart(place.subLocality);
        final locality = safePart(place.locality);
        final administrativeArea =
            (place.administrativeArea != null &&
                    place.administrativeArea!.trim().isNotEmpty)
                ? place.administrativeArea!
                : '';

        // Si todo está vacío, devolvemos algo por defecto
        final result = '$subLocality$locality$administrativeArea'.trim();
        return result.isNotEmpty ? 'Cerca de $result' : 'Ubicación desconocida';
      }
      return 'Lugar desconocido';
    } catch (e) {
      return 'Error obteniendo nombre del lugar';
    }
  }
}
