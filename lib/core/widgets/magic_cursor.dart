import 'package:flutter/material.dart';

class MagicCursorOverlay extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const MagicCursorOverlay({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<MagicCursorOverlay> createState() => _MagicCursorOverlayState();
}

class _MagicCursorOverlayState extends State<MagicCursorOverlay> {
  Offset _position = Offset.zero;
  bool _down = false;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      onHover: (event) => setState(() => _position = event.position),
      child: Listener(
        onPointerDown: (_) => setState(() => _down = true),
        onPointerUp: (_) => setState(() => _down = false),
        child: Stack(
          children: [
            widget.child,
            if (widget.enabled && _hovering)
              Positioned(
                left: _position.dx - 12,
                top: _position.dy - 12,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: _down ? 18 : 24,
                    height: _down ? 18 : 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          blurRadius: _down ? 8 : 14,
                          spreadRadius: _down ? 1 : 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
