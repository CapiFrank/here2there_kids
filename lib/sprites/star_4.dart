import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Star4 extends StatelessWidget {
  final double height;
  final double width;
  const Star4({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/star_4.png',
      top: height * 0.30,
      left: width * 0.25,
      right: 0,
      height: height * 0.16,
    );
  }
}
