import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Castle extends StatelessWidget {
  final double width;
  final double height;
  const Castle({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/castle.png',
      bottom: height * 0.24,
      left: width * 0.7,
      right: 0,
      height: height * 0.45,
    );
  }
}
