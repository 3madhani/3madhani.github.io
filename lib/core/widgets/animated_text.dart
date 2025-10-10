import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final AnimationTextType type;
  final Duration duration;
  final Duration? delay;

  const AnimatedText({
    super.key,
    required this.text,
    this.style,
    this.type = AnimationTextType.fadeIn,
    this.duration = const Duration(milliseconds: 800),
    this.delay,
  });

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

enum AnimationTextType { typewriter, fadeIn, slideUp, glitch }

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        switch (widget.type) {
          case AnimationTextType.typewriter:
            return _buildTypewriterText();
          case AnimationTextType.fadeIn:
            return _buildFadeInText();
          case AnimationTextType.slideUp:
            return _buildSlideUpText();
          case AnimationTextType.glitch:
            return _buildGlitchText();
        }
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

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    if (widget.delay != null) {
      Future.delayed(widget.delay!, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  Widget _buildFadeInText() {
    return Opacity(
      opacity: _animation.value,
      child: Text(widget.text, style: widget.style),
    );
  }

  Widget _buildGlitchText() {
    // Simple glitch effect with opacity changes
    final glitchValue = (_animation.value * 10) % 1;
    final opacity = glitchValue > 0.9 ? 0.3 : 1.0;

    return Opacity(
      opacity: opacity * _animation.value,
      child: Text(widget.text, style: widget.style),
    );
  }

  Widget _buildSlideUpText() {
    return Transform.translate(
      offset: Offset(0, (1 - _animation.value) * 30),
      child: Opacity(
        opacity: _animation.value,
        child: Text(widget.text, style: widget.style),
      ),
    );
  }

  Widget _buildTypewriterText() {
    final displayLength = (_animation.value * widget.text.length).floor();
    final displayText = widget.text.substring(0, displayLength);

    return Text(displayText, style: widget.style);
  }
}
