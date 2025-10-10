import 'dart:math' as math;

import 'package:flutter/material.dart';

class FloatingShape {
  final double centerX;
  final double centerY;
  final double size;
  final double orbitRadius;
  final double phaseOffset;
  final double verticalStretch;
  final double wobbleFrequency;
  final double wobbleAmplitude;
  final double rotationSpeed;
  final double opacity;
  final bool isCircle;

  const FloatingShape({
    required this.centerX,
    required this.centerY,
    required this.size,
    required this.orbitRadius,
    required this.phaseOffset,
    required this.verticalStretch,
    required this.wobbleFrequency,
    required this.wobbleAmplitude,
    required this.rotationSpeed,
    required this.opacity,
    required this.isCircle,
  });

  factory FloatingShape.random({
    required double minSize,
    required double maxSize,
    required int index,
  }) {
    final random = math.Random(index);

    return FloatingShape(
      centerX: 50 + random.nextDouble() * 300, // Relative positioning
      centerY: 50 + random.nextDouble() * 300,
      size: minSize + random.nextDouble() * (maxSize - minSize),
      orbitRadius: 30 + random.nextDouble() * 80,
      phaseOffset: random.nextDouble() * 2 * math.pi,
      verticalStretch: 0.5 + random.nextDouble() * 0.5,
      wobbleFrequency: 1 + random.nextDouble() * 3,
      wobbleAmplitude: 5 + random.nextDouble() * 15,
      rotationSpeed: 0.5 + random.nextDouble(),
      opacity: 0.05 + random.nextDouble() * 0.15,
      isCircle: random.nextBool(),
    );
  }
}

class FloatingShapes extends StatefulWidget {
  final int shapeCount;
  final double minSize;
  final double maxSize;
  final Duration animationDuration;

  const FloatingShapes({
    super.key,
    this.shapeCount = 4,
    this.minSize = 60.0,
    this.maxSize = 120.0,
    this.animationDuration = const Duration(seconds: 20),
  });

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<FloatingShape> _shapes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: Stack(
        children: _shapes.asMap().entries.map((entry) {
          final index = entry.key;
          final shape = entry.value;

          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final progress = _animations[index].value;
              final angle = progress * 2 * math.pi + shape.phaseOffset;

              final x =
                  shape.centerX +
                  math.cos(angle) * shape.orbitRadius +
                  math.sin(progress * math.pi * shape.wobbleFrequency) *
                      shape.wobbleAmplitude;
              final y =
                  shape.centerY +
                  math.sin(angle) * shape.orbitRadius * shape.verticalStretch +
                  math.cos(progress * math.pi * shape.wobbleFrequency) *
                      shape.wobbleAmplitude;

              return Positioned(
                left: x - shape.size / 2,
                top: y - shape.size / 2,
                child: Transform.rotate(
                  angle: progress * 2 * math.pi * shape.rotationSpeed,
                  child: Container(
                    width: shape.size,
                    height: shape.size,
                    decoration: BoxDecoration(
                      shape: shape.isCircle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      borderRadius: shape.isCircle
                          ? null
                          : BorderRadius.circular(shape.size * 0.2),
                      color: theme.colorScheme.primary.withOpacity(
                        shape.opacity,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(
                            shape.opacity * 0.3,
                          ),
                          blurRadius: shape.size * 0.3,
                          spreadRadius: shape.size * 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeShapes();
  }

  void _initializeShapes() {
    _controllers = [];
    _animations = [];
    _shapes = [];

    for (int i = 0; i < widget.shapeCount; i++) {
      final controller = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));

      final shape = FloatingShape.random(
        minSize: widget.minSize,
        maxSize: widget.maxSize,
        index: i,
      );

      _controllers.add(controller);
      _animations.add(animation);
      _shapes.add(shape);

      controller.repeat();
    }
  }
}
