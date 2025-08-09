import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Sun extends StatelessWidget {
  final double height;
  final double width;
  const Sun({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/sun.png',
      top: height * 0.10,
      left: width * 0.05,
      right: 0,
      height: height * 0.30,
    );
  }
}
