import 'package:flutter/material.dart';

class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double radius;

  const MagneticButton({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 80,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final local = box.globalToLocal(event.position);
          final center = box.size.center(Offset.zero);
          final delta = local - center;
          final distance = delta.distance;
          if (distance < widget.radius) {
            setState(() {
              _offset = delta / 6;
            });
          } else {
            setState(() => _offset = Offset.zero);
          }
        }
      },
      onExit: (_) => setState(() => _offset = Offset.zero),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform.translate(offset: _offset, child: widget.child),
      ),
    );
  }
}
