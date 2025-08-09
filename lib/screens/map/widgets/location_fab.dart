import 'package:flutter/material.dart';

class LocationFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomPadding;

  const LocationFAB({
    super.key,
    required this.onPressed,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: bottomPadding,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 1,
        onPressed: onPressed,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.my_location,
          size: 30,
          color: Colors.blue,
        ),
      ),
    );
  }
}
