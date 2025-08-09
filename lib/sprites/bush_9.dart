import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Bush9 extends StatelessWidget {
  final double height;
  final double width;
  const Bush9({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/bush_9.png',
      bottom: height * 0.015,
      left: width * 0.86,
      right: 0,
      height: height * 0.20,
    );
  }
}
