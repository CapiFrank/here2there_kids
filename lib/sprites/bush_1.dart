import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Bush1 extends StatelessWidget {
  final double height;
  final double width;
  const Bush1({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/bush_1.png',
      bottom: height * 0.25,
      left: -width * 0.85,
      right: 0,
      height: height * 0.10,
    );
  }
}
