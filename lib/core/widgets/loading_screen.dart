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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _progressController;
  late final Animation<double> _logoPulse;
  late final Animation<double> _progressBar;
  late final Animation<double> _halo;

  int _curMsgIdx = 0;
  String _deviceType = '...';
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final logoSize = isMobile ? 72.0 : 100.0;
    final progressWidth = math.min(size.width * 0.7, 340.0);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AnimatedBuilder(
        animation: _halo,
        builder: (_, __) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40,
              vertical: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Halo & Logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _halo,
                      builder: (_, __) => Container(
                        width: logoSize * _halo.value * 1.8,
                        height: logoSize * _halo.value * 1.8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(
                                0.18,
                              ),
                              blurRadius: 36,
                              spreadRadius: 6 * _halo.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: logoSize * 1.5,
                      height: logoSize * 1.5,
                      child: CustomPaint(
                        painter: _ParticleRingPainter(
                          animation: _logoController,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _logoPulse,
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(
                                0.35,
                              ),
                              blurRadius: 22,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.flutter_dash,
                          color: theme.colorScheme.onPrimary,
                          size: logoSize * 0.6,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isMobile ? 28 : 36),

                // Animated Loading Message
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    _loadingMessages[_curMsgIdx],
                    key: ValueKey(_curMsgIdx),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 18 : 22,
                      color: theme.colorScheme.primary,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: theme.colorScheme.primary.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Progress bar
                Container(
                  width: progressWidth,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: AnimatedBuilder(
                    animation: _progressBar,
                    builder: (_, __) => Stack(
                      children: [
                        Container(
                          width: progressWidth * _progressBar.value,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 24 : 32),

                // Device Info
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _InfoChip(icon: Icons.devices, label: _deviceType),
                    _InfoChip(icon: Icons.aspect_ratio, label: _screenSize),
                    _InfoChip(icon: Icons.auto_awesome, label: _performance),
                  ],
                ),
              ],
            ),
          ),
        ),
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
      duration: const Duration(seconds: 5),
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

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete();
    });
  }

  Future<void> _detectDevice() async {
    final info = DeviceInfoPlugin();
    try {
      final web = await info.webBrowserInfo;
      setState(() {
        _deviceType = web.browserName.name;
        _screenSize =
            '${MediaQuery.of(context).size.width.toInt()}×${MediaQuery.of(context).size.height.toInt()}';
        _performance = (web.hardwareConcurrency ?? 2) > 4 ? '✨✨✨' : '✨✨';
      });
    } catch (_) {
      setState(() {
        _deviceType = 'Native';
        _screenSize =
            '${MediaQuery.of(context).size.width.toInt()}×${MediaQuery.of(context).size.height.toInt()}';
      });
    }
  }

  void _startTextCycle() {
    Timer.periodic(const Duration(milliseconds: 850), (timer) {
      if (_curMsgIdx < _loadingMessages.length - 1) {
        setState(() => _curMsgIdx++);
      } else {
        timer.cancel();
      }
    });
  }
}

// Particle Ring Painter (smoother + optimized)
class _ParticleRingPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  _ParticleRingPainter({required this.animation, required this.color})
    : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.38;
    final paint = Paint()..color = color.withOpacity(0.2);
    for (int i = 0; i < 16; i++) {
      final angle = (i / 16) * 2 * math.pi + animation.value * 2 * math.pi;
      final dx = center.dx + math.cos(angle) * radius;
      final dy = center.dy + math.sin(angle) * radius;
      canvas.drawCircle(
        Offset(dx, dy),
        3 + 1.2 * math.sin(animation.value * 2 * math.pi + i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticleRingPainter oldDelegate) => true;
}
