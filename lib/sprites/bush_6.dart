import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Bush6 extends StatelessWidget {
  final double height;
  final double width;
  const Bush6({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/bush_6.png',
      bottom: 0,
      left: -width * 0.50,
      right: 0,
      height: height * 0.15,
    );
  }
}
