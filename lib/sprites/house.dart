import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class House extends StatelessWidget {
  final double height;
  final double width;
  const House({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/house.png',
      bottom: height * 0.23,
      left: -width * 0.7,
      right: 0,
      height: height * 0.35,
    );
  }
}
