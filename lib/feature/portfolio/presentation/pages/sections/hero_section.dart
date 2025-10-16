import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
                                delay: const Duration(seconds: 1),
                                text: contactName,
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
                              duration: const Duration(seconds: 2),
                              child: AnimatedText(
                                text: contactTitle,
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
                                  professionalSummary,
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
                                    icon: LucideIcons.codesandbox,
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
                                    icon: LucideIcons.contact,
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
                                    icon: LucideIcons.downloadCloud,
                                    onPressed: () => _downloadCV(),
                                    type: CustomButtonType.outline,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            RevealAnimation(
                              delay: const Duration(milliseconds: 1200),
                              child: Wrap(
                                spacing: 16,
                                alignment: isMobile
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                children: [
                                  _SocialButton(
                                    icon: LucideIcons.github,
                                    tooltip: 'GitHub',
                                    onPressed: () => _launchURL(githubUrl),
                                  ),
                                  _SocialButton(
                                    icon: LucideIcons.linkedin,
                                    tooltip: 'LinkedIn',
                                    onPressed: () => _launchURL(linkedInUrl),
                                  ),
                                  _SocialButton(
                                    icon: LucideIcons.mail,
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

  void _downloadCV() => _launchURL(cvLink);

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _scrollToSection(BuildContext context, String section) {
    if (scrollController == null) return;
    final height = MediaQuery.of(context).size.height;
    double offset = switch (section) {
      'about' => height,
      'skills' => height * 2,
      'projects' => height * 3,
      'contact' => height * 4,
      _ => 0,
    };
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
        builder: (context, child) => MagneticButton(
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
                  LucideIcons.chevronsDown,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
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
