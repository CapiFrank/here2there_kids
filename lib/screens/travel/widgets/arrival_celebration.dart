import 'dart:math';
import 'package:flutter/material.dart';
import 'package:here2there_kids/sprites/star_1.dart';
import 'package:here2there_kids/sprites/star_2.dart';
import 'package:here2there_kids/sprites/star_3.dart';
import 'package:here2there_kids/sprites/star_4.dart';
import 'package:here2there_kids/sprites/star_5.dart';
import 'package:here2there_kids/sprites/star_6.dart';

class ArrivalCelebration extends StatefulWidget {
  final VoidCallback onClose;
  final double width;
  final double height;

  const ArrivalCelebration({
    super.key,
    required this.onClose,
    required this.width,
    required this.height,
  });

  @override
  State<ArrivalCelebration> createState() => _ArrivalCelebrationState();
}

class _ArrivalCelebrationState extends State<ArrivalCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  List<_ConfettiParticle> _confettiParticles = [];

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {
              // Actualizamos partículas
              for (final p in _confettiParticles) {
                p.update();
              }
            });
          })
          ..repeat();

    // Generar partículas iniciales
    _confettiParticles = List.generate(30, (_) => _ConfettiParticle(_random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black54,
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Castillo pulsante (o vehículo)
            Positioned(
              bottom: widget.height * 0.24,
              left: widget.width * 0.7,
              right: 0,
              child: _PulsingCastle(height: widget.height * 0.45),
            ),

            // Confetti animado
            ..._confettiParticles.map(
              (p) => Positioned(
                left: p.x * widget.width,
                top: p.y * widget.height,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: p.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Estrellas brillantes
            Star1(height: widget.height, width: widget.width),
            Star2(height: widget.height, width: widget.width),
            Star3(height: widget.height, width: widget.width),
            Star4(height: widget.height, width: widget.width),
            Star5(height: widget.height, width: widget.width),
            Star6(height: widget.height, width: widget.width),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double velocityY;
  final Color color;
  final Random random;

  _ConfettiParticle(this.random)
    : x = random.nextDouble(),
      y = random.nextDouble() * 0.5,
      velocityY = 0.01 + random.nextDouble() * 0.02,
      color = Colors.primaries[random.nextInt(Colors.primaries.length)];

  void update() {
    y += velocityY;
    if (y > 1.0) {
      y = 0.0;
      x = random.nextDouble();
    }
  }
}

class _PulsingCastle extends StatefulWidget {
  final double? width;
  final double? height;
  const _PulsingCastle({this.width, this.height});
  @override
  State<_PulsingCastle> createState() => __PulsingCastleState();
}

class __PulsingCastleState extends State<_PulsingCastle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Image.asset(
        'assets/castle.png',
        height: widget.height,
        width: widget.width,
        fit: BoxFit.contain,
      ),
    );
  }
}
