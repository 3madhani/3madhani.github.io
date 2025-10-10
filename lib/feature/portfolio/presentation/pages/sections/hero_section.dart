import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../widgets/animations/floating_elements.dart';
import '../../widgets/animations/particle_system.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          // Particle background
          ParticleSystem(),

          // Main content
          SafeArea(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: ResponsiveHelper.buildResponsiveRow(
                context,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text content
                  Expanded(
                    flex: ResponsiveHelper.isMobile(context) ? 1 : 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: ResponsiveHelper.isMobile(context)
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        // Greeting
                        Text(
                          "Hello, I'm",
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Animated name
                        SizedBox(
                          height:
                              ResponsiveHelper.getHeroFontSize(context) * 1.2,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Flutter Magician',
                                textStyle: theme.textTheme.displayLarge
                                    ?.copyWith(
                                      fontSize:
                                          ResponsiveHelper.getHeroFontSize(
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
                                              const Rect.fromLTWH(
                                                0,
                                                0,
                                                200,
                                                70,
                                              ),
                                            ),
                                    ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            isRepeatingAnimation: false,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subtitle
                        Text(
                          "Magical Mobile & Web Developer",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Container(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: Text(
                            "Creating extraordinary digital experiences with Flutter, "
                            "advanced animations, and cutting-edge device capabilities. "
                            "Passionate about building beautiful, performant applications "
                            "that feel truly magical.",
                            style: theme.textTheme.bodyLarge,
                            textAlign: ResponsiveHelper.isMobile(context)
                                ? TextAlign.center
                                : TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Action buttons
                        ResponsiveHelper.buildResponsiveRow(
                          context,
                          mainAxisAlignment: ResponsiveHelper.isMobile(context)
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                // Navigate to projects section
                              },
                              icon: const Icon(Icons.work),
                              label: const Text('View Projects'),
                            ),
                            const SizedBox(width: 16, height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Navigate to contact section
                              },
                              icon: const Icon(Icons.contact_mail),
                              label: const Text('Contact Me'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (!ResponsiveHelper.isMobile(context)) ...[
                    const SizedBox(width: 64),

                    // Floating elements animation
                    const Expanded(child: FloatingElements()),
                  ],
                ],
              ),
            ),
          ),

          // Scroll indicator (only on desktop)
          if (!ResponsiveHelper.isMobile(context))
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
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            Text('Scroll to discover', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              transform: Matrix4.translationValues(0, _animation.value, 0),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
          ],
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
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
}
