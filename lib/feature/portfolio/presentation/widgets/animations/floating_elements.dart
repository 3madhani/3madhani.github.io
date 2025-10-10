import 'dart:math' as math;

import 'package:flutter/material.dart';

class FloatingElement extends StatefulWidget {
  final IconData icon;
  final Color color;

  const FloatingElement({super.key, required this.icon, required this.color});

  @override
  State<FloatingElement> createState() => _FloatingElementState();
}

class FloatingElements extends StatefulWidget {
  const FloatingElements({super.key});

  @override
  State<FloatingElements> createState() => _FloatingElementsState();
}

class _FloatingElementsState extends State<FloatingElements>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<IconData> _icons = [
    Icons.flutter_dash,
    Icons.code,
    Icons.phone_android,
    Icons.web,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 400,
      height: 400,
      child: Stack(
        children: _icons.asMap().entries.map((entry) {
          final index = entry.key;
          final icon = entry.value;

          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final angle = _animations[index].value;
              final radius = 120.0 + (index * 20);
              final x = math.cos(angle) * radius + 200;
              final y = math.sin(angle) * radius + 200;

              return Positioned(
                left: x - 40,
                top: y - 40,
                child: FloatingElement(
                  icon: icon,
                  color: theme.colorScheme.primary,
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

    _controllers = List.generate(
      _icons.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 3000 + (index * 500)),
        vsync: this,
      )..repeat(),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0,
        end: 2 * math.pi,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    }).toList();
  }
}

class _FloatingElementState extends State<FloatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: _isHovered ? 20 : 10,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.color, size: 40),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }
}
