import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Bush8 extends StatelessWidget {
  final double height;
  final double width;
  const Bush8({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/bush_8.png',
      bottom: 0,
      left: width * 0.4,
      right: 0,
      height: height * 0.15,
    );
  }
}
