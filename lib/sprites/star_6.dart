import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Star6 extends StatelessWidget {
  final double height;
  final double width;
  const Star6({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/star_6.png',
      top: height * 0.05,
      left: width * 0.35,
      right: 0,
      height: height * 0.18,
    );
  }
}
