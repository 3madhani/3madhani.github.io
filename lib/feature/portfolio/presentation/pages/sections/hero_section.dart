// lib/features/portfolio/presentation/pages/sections/hero_section.dart

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
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.colorScheme.secondary.withOpacity(0.05),
            theme.colorScheme.tertiary.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: ParticleSystem()),
          SafeArea(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: ResponsiveHelper.buildResponsiveRow(
                context,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        RevealAnimation(
                          child: AnimatedText(
                            text: "Hello, I'm",
                            type: AnimationTextType.fadeIn,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Animated name
                        RevealAnimation(
                          duration: const Duration(milliseconds: 200),
                          child: AnimatedText(
                            text: 'Flutter Magician',
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
                        // Subtitle
                        RevealAnimation(
                          duration: const Duration(milliseconds: 400),
                          child: AnimatedText(
                            text: "Magical Mobile & Web Developer",
                            type: AnimationTextType.slideUp,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        RevealAnimation(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
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
                        // Action buttons
                        RevealAnimation(
                          duration: const Duration(milliseconds: 800),
                          child: ResponsiveHelper.buildResponsiveRow(
                            context,
                            mainAxisAlignment: isMobile
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.start,
                            children: [
                              CustomButton(
                                text: 'View Projects',
                                icon: Icons.work,
                                onPressed: () {},
                                type: CustomButtonType.primary,
                              ),
                              const SizedBox(width: 16, height: 16),
                              CustomButton(
                                text: 'Contact Me',
                                icon: Icons.contact_mail,
                                onPressed: () {},
                                type: CustomButtonType.magical,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 64),
                    const Expanded(child: FloatingElements()),
                  ],
                ],
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
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return MagneticButton(
          child: Column(
            children: [
              Text('Scroll to discover', style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Transform.translate(
                offset: Offset(0, _animation.value),
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
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
}
