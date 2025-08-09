import 'package:flutter/material.dart';

class NorthFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final double bottomPadding;

  const NorthFAB({
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
        child: const Text(
          'N',
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
      ),
    );
  }
}
