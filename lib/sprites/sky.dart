import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Sky extends StatelessWidget {
  final double height;
  const Sky({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/sky.png',
      top: -height * 0.1,
      left: 0,
      right: 0,
    );
  }
}