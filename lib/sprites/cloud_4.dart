import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Cloud4 extends StatelessWidget {
  final double height;
  final double width;
  const Cloud4({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/cloud_4.png',
      top: height * 0.05,
      left: width * 0.05,
      height: height * 0.20,
    );
  }
}
