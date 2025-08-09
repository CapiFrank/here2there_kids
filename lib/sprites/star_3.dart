import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Star3 extends StatelessWidget {
  final double height;
  final double width;
  const Star3({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/star_3.png',
      top: height * 0.05,
      left: 0,
      right: width * 0.25,
      height: height * 0.14,
    );
  }
}
