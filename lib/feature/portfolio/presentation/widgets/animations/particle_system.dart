import 'dart:math' as math;

import 'package:flutter/material.dart';

class Particle {
  double x, y, size, speedX, speedY, opacity;
  Particle(this.x, this.y, this.size, this.speedX, this.speedY, this.opacity);

  factory Particle.random() {
    final rand = math.Random();
    return Particle(
      rand.nextDouble(),
      rand.nextDouble(),
      rand.nextDouble() * 3 + 2,
      (rand.nextDouble() - 0.5) * 0.0005,
      (rand.nextDouble() - 0.5) * 0.0005,
      rand.nextDouble() * 0.5 + 0.2,
    );
  }

  void move(Duration delta) {
    final dt = delta.inMilliseconds;
    x = (x + speedX * dt) % 1;
    y = (y + speedY * dt) % 1;
    if (x < 0) x += 1;
    if (y < 0) y += 1;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter(this.particles, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      paint.color = color.withOpacity(p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) => true;
}

class ParticleSystem extends StatefulWidget {
  final int particleCount;
  final Color? color;

  const ParticleSystem({super.key, this.particleCount = 9, this.color});

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Particle> _particles;
  late Duration _lastTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary.withOpacity(0.15);
    return CustomPaint(
      painter: ParticlePainter(_particles, color),
      child: const SizedBox.expand(),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (_) => Particle.random());
    _lastTime = Duration.zero;
    _ctrl = AnimationController(vsync: this, duration: const Duration(days: 1))
      ..addListener(_onTick)
      ..forward();
  }

  void _onTick() {
    final now = _ctrl.lastElapsedDuration ?? Duration.zero;
    final delta = now - _lastTime;
    _lastTime = now;
    for (final p in _particles) {
      p.move(delta);
    }
    setState(() {}); // triggers repaint
  }
}
