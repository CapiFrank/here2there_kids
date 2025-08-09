import 'package:flutter/material.dart';

class Sprite extends StatelessWidget {
  final String spriteRoute;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double? height;
  final double? width;

  const Sprite({
    super.key,
    required this.spriteRoute,
    this.top,
    this.left,
    this.bottom,
    this.right,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Image.asset(
        spriteRoute,
        height: height,
        width: width,
        fit: BoxFit.contain,
      ),
    );
  }
}
