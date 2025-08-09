import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Road extends StatelessWidget {
  final double height;
  const Road({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/road.png',
      bottom: height * 0.14,
      left: 0,
      right: 0,
      height: height * 0.2,
    );
  }
}
