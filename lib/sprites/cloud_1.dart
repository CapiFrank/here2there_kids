import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Cloud1 extends StatelessWidget {
  final double height;
  const Cloud1({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/cloud_1.png',
      top: height * 0.28,
      left: 0,
      height: height * 0.15,
    );
  }
}
