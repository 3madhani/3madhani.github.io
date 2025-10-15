import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/animated_text.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/magnetic_button.dart';
import '../../../data/personal_data.dart';
import '../../widgets/animations/floating_elements.dart';
import '../../widgets/animations/particle_system.dart';
import '../../widgets/animations/reveal_animation.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final ScrollController? scrollController;

  const HeroSection({
    super.key,
    this.onViewProjects,
    this.onContactMe,
    this.scrollController,
  });

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
                                text: contactName, // From personal_data.dart
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
                                text: contactTitle, // From personal_data.dart
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
                                  professionalSummary, // From personal_data.dart
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
                                crossAxisAlignment: isMobile
                                    ? WrapCrossAlignment.center
                                    : WrapCrossAlignment.start,
                                spacing: 16,
                                runSpacing: 16,
                                alignment: isMobile
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                children: [
                                  CustomButton(
                                    text: 'View Projects',
                                    icon: Icons.work_outline,
                                    onPressed:
                                        onViewProjects ??
                                        () => _scrollToSection(
                                          context,
                                          'projects',
                                        ),
                                    type: CustomButtonType.primary,
                                  ),
                                  CustomButton(
                                    text: 'Contact Me',
                                    icon: Icons.contact_mail_outlined,
                                    onPressed:
                                        onContactMe ??
                                        () => _scrollToSection(
                                          context,
                                          'contact',
                                        ),
                                    type: CustomButtonType.outline,
                                  ),
                                  CustomButton(
                                    text: 'Download CV',
                                    icon: Icons.download_outlined,
                                    onPressed: () => _downloadCV(),
                                    type: CustomButtonType.outline,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Social Links
                            RevealAnimation(
                              delay: const Duration(milliseconds: 1200),
                              child: Wrap(
                                spacing: 16,
                                alignment: isMobile
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                children: [
                                  _SocialButton(
                                    icon: Icons.code,
                                    tooltip: 'GitHub',
                                    onPressed: () => _launchURL(githubUrl),
                                  ),
                                  _SocialButton(
                                    icon: Icons.work_outline,
                                    tooltip: 'LinkedIn',
                                    onPressed: () => _launchURL(linkedInUrl),
                                  ),
                                  _SocialButton(
                                    icon: Icons.email_outlined,
                                    tooltip: 'Email',
                                    onPressed: () =>
                                        _launchURL('mailto:$contactEmail'),
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
            _ScrollIndicator(onTap: () => _scrollToSection(context, 'about')),
        ],
      ),
    );
  }

  void _downloadCV() {
    // Implement CV download functionality
    // You can use url_launcher to open a direct link to your CV
    _launchURL(cvLink);
  }

  void _launchURL(String url) async {
    // Import url_launcher package
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _scrollToSection(BuildContext context, String section) {
    if (scrollController == null) return;

    final height = MediaQuery.of(context).size.height;
    double offset = 0;

    switch (section) {
      case 'about':
        offset = height;
        break;
      case 'skills':
        offset = height * 2;
        break;
      case 'projects':
        offset = height * 3;
        break;
      case 'contact':
        offset = height * 4;
        break;
    }

    scrollController?.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}

class _ScrollIndicator extends StatefulWidget {
  final VoidCallback? onTap;

  const _ScrollIndicator({this.onTap});

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
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return MagneticButton(
            radius: 60,
            onTap: widget.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scroll to discover',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
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
      ),
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MagneticButton(
      radius: 40,
      onTap: onPressed,
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
            color: theme.colorScheme.surface.withOpacity(0.5),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
