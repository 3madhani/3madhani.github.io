import 'dart:async';
import 'dart:math' as math;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const LoadingScreen({super.key, required this.onComplete});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class ParticleRingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  ParticleRingPainter({required this.animation, required this.color})
    : super(repaint: animation);
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.39;
    final paint = Paint()..color = color.withOpacity(0.18);
    for (int i = 0; i < 16; i++) {
      final angle = (i / 16) * 2 * math.pi + animation.value * 2 * math.pi;
      double dx = center.dx + math.cos(angle) * radius;
      double dy = center.dy + math.sin(angle) * radius;
      canvas.drawCircle(
        Offset(dx, dy),
        3 + 1.2 * math.sin(animation.value * 2 * math.pi + i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticleRingPainter oldDelegate) =>
      oldDelegate.animation.value != animation.value;
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 19, color: Theme.of(context).colorScheme.primary),
      const SizedBox(height: 3),
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    ],
  );
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoPulse;
  late Animation<double> _progressBar;
  late Animation<double> _halo;
  int _curMsgIdx = 0;

  String _deviceType = 'Unknown';
  String _screenSize = '...';
  String _performance = '✨';

  final List<String> _loadingMessages = [
    'Summoning pixels...',
    'Enchanting UI widgets...',
    'Channeling particle spirits...',
    'Initializing magical logics...',
    'Polishing the spell...',
    'The portal opens!',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedBuilder(
        animation: _halo,
        builder: (_, __) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Magical Halo
                      AnimatedBuilder(
                        animation: _halo,
                        builder: (_, __) {
                          return Container(
                            width: 140 * _halo.value,
                            height: 140 * _halo.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.18,
                                  ),
                                  blurRadius: 32,
                                  spreadRadius: 5 * _halo.value,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Particle ring
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CustomPaint(
                          painter: ParticleRingPainter(
                            animation: _logoController,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      // Flutter logo with pulse
                      ScaleTransition(
                        scale: _logoPulse,
                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.flutter_dash,
                            color: theme.colorScheme.onPrimary,
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Magical loading message
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 550),
                    child: Text(
                      _loadingMessages[_curMsgIdx],
                      key: ValueKey(_curMsgIdx),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        letterSpacing: 1.2,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: theme.colorScheme.primary.withOpacity(0.25),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Magical Progress Bar
                  Container(
                    width: 330,
                    height: 9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.5),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: AnimatedBuilder(
                      animation: _progressBar,
                      builder: (context, _) => Stack(
                        children: [
                          Container(
                            width: 330 * _progressBar.value,
                            height: 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.5),
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.secondary.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          if (_progressBar.value > 0)
                            Positioned(
                              left: 330 * _progressBar.value - 28,
                              child: Container(
                                width: 28,
                                height: 9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.5),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.18),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  // Device/about info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(icon: Icons.devices, label: _deviceType),
                      const SizedBox(width: 20),
                      _InfoChip(icon: Icons.aspect_ratio, label: _screenSize),
                      const SizedBox(width: 20),
                      _InfoChip(icon: Icons.auto_awesome, label: _performance),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _halo = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOutSine),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _progressBar = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _logoPulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _detectDevice();
    _startTextCycle();
    _progressController.forward();

    // End loading after animation completes
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete();
    });
  }

  Future<void> _detectDevice() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    try {
      final web = await info.webBrowserInfo;
      setState(() {
        _deviceType = '${web.browserName} Browser';
        _screenSize =
            '${MediaQuery.of(context).size.width.toInt()}×${MediaQuery.of(context).size.height.toInt()}';
        _performance =
            web.hardwareConcurrency != null && web.hardwareConcurrency! > 4
            ? '✨✨✨'
            : '✨✨';
      });
    } catch (e) {
      setState(() {
        _deviceType = 'Native App';
        _screenSize =
            '${MediaQuery.of(context).size.width.toInt()}×${MediaQuery.of(context).size.height.toInt()}';
        _performance = '✨✨';
      });
    }
  }

  void _startTextCycle() {
    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_curMsgIdx < _loadingMessages.length - 1) {
        setState(() => _curMsgIdx++);
      } else {
        timer.cancel();
      }
    });
  }
}
