import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class DestinationMarker extends StatelessWidget {
  final LatLng destination;

  const DestinationMarker({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: destination,
          width: 50,
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(0, 44), // sube el punto
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 44,
                    color: Colors.red[700], // Contorno (rojo claro)
                  ), // Contorno (blanco)
                  Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ), // Color principal
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
