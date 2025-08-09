import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Star5 extends StatelessWidget {
  final double height;
  final double width;
  const Star5({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/star_5.png',
      top: height * 0.30,
      right: width * 0.02,
      height: height * 0.14,
    );
  }
}
