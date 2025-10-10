import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration glitchDuration;

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.glitchDuration = const Duration(seconds: 2),
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _glitchController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shouldGlitch =
            _controller.value > 0.8 && _controller.value < 0.85;

        if (shouldGlitch) {
          return Stack(
            children: [
              // Original text
              Text(widget.text, style: widget.style),

              // Glitch layer 1
              Transform.translate(
                offset: Offset(
                  (math.Random().nextDouble() - 0.5) * 4,
                  (math.Random().nextDouble() - 0.5) * 2,
                ),
                child: Text(
                  widget.text,
                  style: widget.style?.copyWith(
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              ),

              // Glitch layer 2
              Transform.translate(
                offset: Offset(
                  (math.Random().nextDouble() - 0.5) * 4,
                  (math.Random().nextDouble() - 0.5) * 2,
                ),
                child: Text(
                  widget.text,
                  style: widget.style?.copyWith(
                    color: Colors.blue.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          );
        }

        return Text(widget.text, style: widget.style);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.glitchDuration,
      vsync: this,
    )..repeat();

    _glitchController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }
}
