import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Star2 extends StatelessWidget {
  final double height;
  final double width;
  const Star2({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/star_2.png',
      top: height * 0.28,
      left: width * 0.48,
      right: 0,
      height: height * 0.14,
    );
  }
}
