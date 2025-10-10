import 'dart:async';

import 'package:flutter/material.dart';

class PerformanceMonitor extends StatefulWidget {
  const PerformanceMonitor({super.key});

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _fpsTimer;
  int _frameCount = 0;
  int _fps = 60;
  int _lastTime = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _fps.toString(),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _fps >= 50
                    ? Colors.green
                    : _fps >= 30
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'FPS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _fpsTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16), // ~60fps
      vsync: this,
    )..repeat();

    _controller.addListener(_updateFPS);
    _startFPSMonitoring();
  }

  void _startFPSMonitoring() {
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // FPS calculation logic would go here
      // For now, simulate FPS between 30-60
      if (mounted) {
        setState(() {
          _fps = 45 + (DateTime.now().millisecondsSinceEpoch % 15);
        });
      }
    });
  }

  void _updateFPS() {
    _frameCount++;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - _lastTime >= 1000) {
      if (mounted) {
        setState(() {
          _fps = (_frameCount * 1000 / (currentTime - _lastTime)).round();
        });
      }
      _frameCount = 0;
      _lastTime = currentTime;
    }
  }
}
