import 'package:flutter/material.dart';

class Tilt3D extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final double perspective;

  const Tilt3D({
    super.key,
    required this.child,
    this.maxTilt = 12,
    this.perspective = 0.0015,
  });

  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> {
  double _dx = 0;
  double _dy = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final local = box.globalToLocal(event.position);
          final center = box.size.center(Offset.zero);
          final normX = (local.dx - center.dx) / (box.size.width / 2);
          final normY = (local.dy - center.dy) / (box.size.height / 2);
          setState(() {
            _dx = (-normY) * widget.maxTilt;
            _dy = (normX) * widget.maxTilt;
          });
        }
      },
      onExit: (_) => setState(() {
        _dx = 0;
        _dy = 0;
      }),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, widget.perspective)
          ..rotateX(_dx * 3.14159 / 180)
          ..rotateY(_dy * 3.14159 / 180),
        child: widget.child,
      ),
    );
  }
}
