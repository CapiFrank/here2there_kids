import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Cloud3 extends StatelessWidget {
  final double height;
  final double width;
  const Cloud3({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/cloud_3.png',
      top: height * 0.30,
      left: width * 0.30,
      height: height * 0.15,
    );
  }
}
