import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Grass extends StatelessWidget {
  final double height;
  const Grass({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/grass.png',
      bottom: -height * 0.1,
      left: 0,
      right: 0,
    );
  }
}