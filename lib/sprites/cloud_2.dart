import 'package:flutter/material.dart';
import 'package:here2there_kids/components/sprite.dart';

class Cloud2 extends StatelessWidget {
  final double height;
  const Cloud2({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Sprite(
      spriteRoute: 'assets/cloud_2.png',
      top: 0,
      right: 0,
      height: height * 0.30,
    );
  }
}
