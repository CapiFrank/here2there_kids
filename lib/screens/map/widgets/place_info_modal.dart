import 'package:flutter/material.dart';
import 'package:here2there_kids/utils/error_handler.dart';
import 'package:here2there_kids/utils/nearby_searcher.dart';

class PlaceInfoModal extends StatelessWidget {
  final Place place;
  final VoidCallback onClose;
  final VoidCallback onNavigate;
  final double distance;
  final DraggableScrollableController? controller;

  const PlaceInfoModal({
    super.key,
    required this.place,
    required this.onClose,
    required this.onNavigate,
    this.distance = 0,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildDescription(),
              const SizedBox(height: 5),
              _buildDivider(),
              _buildDistance(),
              _buildDivider(),
              _buildCoordinates(),
              _buildDivider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() => Center(
    child: Container(
      width: 50,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(3),
      ),
    ),
  );

  Widget _buildHeader() => Row(
    children: [
      Expanded(
        child: Text(
          place.name,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
        ),
      ),
      TextButton.icon(
        onPressed: onNavigate,
        icon: const Icon(Icons.navigation),
        label: const Text('Navegar', style: TextStyle(fontSize: 18)),
        style: TextButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
        ),
      ),
      const SizedBox(width: 5),
      _buildCloseButton(),
    ],
  );

  Widget _buildCloseButton() => Material(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.grey[200],
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onClose,
      child: const Padding(
        padding: EdgeInsets.all(8),
        child: Icon(Icons.close, color: Colors.black),
      ),
    ),
  );

  Widget _buildDescription() => Text(
    place.displayName,
    style: TextStyle(color: Colors.grey[700], fontSize: 18),
  );

  Widget _buildDistance() {
    final double displayDistance;
    final String unit;

    if (distance < 1000) {
      displayDistance = distance; // en metros
      unit = 'm';
    } else {
      displayDistance = distance / 1000; // en km
      unit = 'km';
    }

    return Row(
      children: [
        const Icon(Icons.straighten),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "${displayDistance.toStringAsFixed(2)} $unit",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinates() => Row(
    children: [
      const Icon(Icons.location_searching),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          '(${place.lat.toStringAsFixed(6)}, ${place.lon.toStringAsFixed(6)})',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ],
  );

  Widget _buildDivider() => Divider(thickness: 1, color: Colors.grey[200]);
}
