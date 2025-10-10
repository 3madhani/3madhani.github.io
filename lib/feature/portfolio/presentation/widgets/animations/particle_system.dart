import 'dart:math' as math;

import 'package:flutter/material.dart';

class Particle {
  final double x;
  final double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;

  const Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  factory Particle.random() {
    final random = math.Random();
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 4 + 1,
      speedX: (random.nextDouble() - 0.5) * 0.02,
      speedY: (random.nextDouble() - 0.5) * 0.02,
      opacity: random.nextDouble() * 0.5 + 0.1,
    );
  }

  Particle update(double t) {
    return Particle(
      x: (x + speedX * t) % 1,
      y: (y + speedY * t) % 1,
      size: size,
      speedX: speedX,
      speedY: speedY,
      opacity: opacity,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Animation<double> animation;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final p = particle.update(animation.value);
      paint.color = color.withOpacity(p.opacity);
      final dx = p.x * size.width;
      final dy = p.y * size.height;
      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) =>
      old.animation.value != animation.value;
}

class ParticleSystem extends StatefulWidget {
  /// Number of particles to display
  final int particleCount;

  /// Particle color (optional)
  final Color? color;

  const ParticleSystem({super.key, this.particleCount = 50, this.color});

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Particle> _particles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final particleColor =
        widget.color ?? theme.colorScheme.primary.withOpacity(0.1);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            animation: _controller,
            color: particleColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _particles = List.generate(widget.particleCount, (_) => Particle.random());
  }
}
