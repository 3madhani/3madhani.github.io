import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/animated_text.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/magnetic_button.dart';
import '../../widgets/animations/floating_elements.dart';
import '../../widgets/animations/particle_system.dart';
import '../../widgets/animations/reveal_animation.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = ResponsiveHelper.isMobile(context);

    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          const Positioned.fill(child: ParticleSystem()),
          SafeArea(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    alignment: isMobile
                        ? Alignment.bottomCenter
                        : Alignment.centerLeft,
                    children: [
                      Positioned(
                        right: 0,
                        bottom: 100,
                        child: FloatingElements(),
                      ),
                      Positioned(
                        left: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: isMobile
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            RevealAnimation(
                              delay: const Duration(milliseconds: 200),
                              child: AnimatedText(
                                text: "Hello, I'm",
                                type: AnimationTextType.fadeIn,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            RevealAnimation(
                              delay: const Duration(milliseconds: 400),
                              child: AnimatedText(
                                delay: Duration(seconds: 1),
                                text: 'Emad Hany',
                                type: AnimationTextType.typewriter,
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: ResponsiveHelper.getHeroFontSize(
                                    context,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..shader =
                                        LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary,
                                            theme.colorScheme.secondary,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            ),
                            const SizedBox(height: 16),
                            RevealAnimation(
                              delay: const Duration(milliseconds: 600),
                              duration: Duration(seconds: 2),
                              child: AnimatedText(
                                text: "Magical Mobile & Web Developer",
                                type: AnimationTextType.slideUp,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            RevealAnimation(
                              delay: const Duration(milliseconds: 800),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? size.width : 600,
                                ),
                                child: Text(
                                  "Creating extraordinary digital experiences with Flutter, "
                                  "advanced animations, and cutting-edge device capabilities. "
                                  "Passionate about building beautiful, performant applications "
                                  "that feel truly magical.",
                                  style: theme.textTheme.bodyLarge,
                                  textAlign: isMobile
                                      ? TextAlign.center
                                      : TextAlign.left,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            RevealAnimation(
                              delay: const Duration(milliseconds: 1000),
                              duration: const Duration(milliseconds: 3),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                alignment: isMobile
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                children: [
                                  CustomButton(
                                    text: 'View Projects',
                                    icon: Icons.work,
                                    onPressed: () {},
                                    type: CustomButtonType.outline,
                                  ),
                                  CustomButton(
                                    text: 'Contact Me',
                                    icon: Icons.contact_mail,
                                    onPressed: () {},
                                    type: CustomButtonType.outline,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (!isMobile)
            const Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: _ScrollIndicator(),
            ),
        ],
      ),
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  const _ScrollIndicator();
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return MagneticButton(
          radius: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scroll to discover', style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Transform.translate(
                offset: Offset(0, _anim.value),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween(
      begin: 0.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
}
