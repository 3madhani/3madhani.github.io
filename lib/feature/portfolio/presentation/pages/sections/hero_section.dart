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
    final isTablet = ResponsiveHelper.isTablet(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return SizedBox(
      height: size.height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Positioned.fill(child: ParticleSystem()),
          SafeArea(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Desktop: Side-by-side layout
                  if (isDesktop) {
                    return _DesktopLayout(
                      theme: theme,
                      size: size,
                      onViewProjects: onViewProjects,
                      onContactMe: onContactMe,
                      scrollController: scrollController,
                      context: context,
                    );
                  }

                  // Tablet: Two-column with text left, image and buttons right
                  if (isTablet) {
                    return _TabletLayout(
                      theme: theme,
                      size: size,
                      onViewProjects: onViewProjects,
                      onContactMe: onContactMe,
                      scrollController: scrollController,
                      context: context,
                    );
                  }

                  // Mobile: Compact centered layout
                  return _MobileLayout(
                    theme: theme,
                    size: size,
                    onViewProjects: onViewProjects,
                    onContactMe: onContactMe,
                    scrollController: scrollController,
                    context: context,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Desktop Layout: Two-column design with profile image on right
class _DesktopLayout extends StatelessWidget {
  final ThemeData theme;
  final Size size;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final ScrollController? scrollController;
  final BuildContext context;

  const _DesktopLayout({
    required this.theme,
    required this.size,
    required this.onViewProjects,
    required this.onContactMe,
    required this.scrollController,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Left side: Content
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroContent(
                    theme: theme,
                    size: size,
                    isDesktop: true,
                    isMobile: false,
                    isTablet: false,
                    onViewProjects: onViewProjects,
                    onContactMe: onContactMe,
                    scrollController: scrollController,
                    context: context,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            // Right side: Profile image with floating elements
            Expanded(
              flex: 4,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  FloatingElements(),

                  RevealAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Container(
                      width: 360,
                      height: 360,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 4,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/profile_image.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _ScrollIndicator(onTap: () => _scrollToSection('about')),
      ],
    );
  }

  void _scrollToSection(String section) {
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

// Shared content component used for Desktop and Mobile
class _HeroContent extends StatelessWidget {
  final ThemeData theme;
  final Size size;
  final bool isDesktop;
  final bool isMobile;
  final bool isTablet;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final ScrollController? scrollController;
  final BuildContext context;

  const _HeroContent({
    required this.theme,
    required this.size,
    required this.isDesktop,
    required this.isMobile,
    required this.isTablet,
    required this.onViewProjects,
    required this.onContactMe,
    required this.scrollController,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        RevealAnimation(
          delay: const Duration(milliseconds: 200),
          child: AnimatedText(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(seconds: 2),
            text: "Hello, I'm",
            type: AnimationTextType.fadeIn,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: isMobile ? 18 : (isTablet ? 22 : 24),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        RevealAnimation(
          duration: const Duration(seconds: 2),
          delay: const Duration(milliseconds: 400),
          child: AnimatedText(
            delay: const Duration(milliseconds: 600),
            duration: const Duration(seconds: 2),
            text: contactName,
            type: AnimationTextType.typewriter,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: ResponsiveHelper.getHeroFontSize(context),
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        RevealAnimation(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(seconds: 2),
          child: AnimatedText(
            delay: const Duration(milliseconds: 800),
            duration: const Duration(seconds: 2),
            text: contactTitle,
            type: AnimationTextType.slideUp,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: isMobile ? 20 : (isTablet ? 26 : 32),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 16 : 24),
        RevealAnimation(
          delay: const Duration(milliseconds: 800),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 600 : (isTablet ? 500 : size.width * 0.9),
            ),
            child: Text(
              professionalSummary,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                height: 1.6,
              ),
              textAlign: isDesktop ? TextAlign.left : TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: isMobile ? 24 : 40),
        RevealAnimation(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 3),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: isMobile ? 12 : 16,
            runSpacing: isMobile ? 12 : 16,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
            children: [
              CustomButton(
                text: 'View Projects',
                icon: LucideIcons.codesandbox,
                onPressed: onViewProjects ?? () => _scrollToSection('projects'),
                type: CustomButtonType.primary,
              ),
              CustomButton(
                text: 'Contact Me',
                icon: LucideIcons.contact,
                onPressed: onContactMe ?? () => _scrollToSection('contact'),
                type: CustomButtonType.outline,
              ),
              if (!isMobile)
                CustomButton(
                  text: 'Download CV',
                  icon: LucideIcons.downloadCloud,
                  onPressed: _downloadCV,
                  type: CustomButtonType.outline,
                ),
            ],
          ),
        ),
        if (isMobile) ...[
          const SizedBox(height: 12),
          RevealAnimation(
            delay: const Duration(milliseconds: 1100),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Download CV',
                icon: LucideIcons.downloadCloud,
                onPressed: _downloadCV,
                type: CustomButtonType.outline,
              ),
            ),
          ),
        ],
        SizedBox(height: isMobile ? 20 : 24),
        RevealAnimation(
          delay: const Duration(milliseconds: 1200),
          child: Wrap(
            spacing: isMobile ? 12 : 16,
            alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
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
                onPressed: () => _launchURL('mailto:$contactEmail'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _downloadCV() => _launchURL(cvLink);

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _scrollToSection(String section) {
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

// Mobile Layout: Compact, centered, optimized for small screens
class _MobileLayout extends StatelessWidget {
  final ThemeData theme;
  final Size size;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final ScrollController? scrollController;
  final BuildContext context;

  const _MobileLayout({
    required this.theme,
    required this.size,
    required this.onViewProjects,
    required this.onContactMe,
    required this.scrollController,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.05),
        RevealAnimation(
          delay: const Duration(milliseconds: 300),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.20),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 3,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/profile_image.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _HeroContent(
          theme: theme,
          size: size,
          isDesktop: false,
          isMobile: true,
          isTablet: false,
          onViewProjects: onViewProjects,
          onContactMe: onContactMe,
          scrollController: scrollController,
          context: context,
        ),
      ],
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
    return AnimatedBuilder(
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

// Tablet Layout: Two-column with text left, image and buttons right
class _TabletLayout extends StatelessWidget {
  final ThemeData theme;
  final Size size;
  final VoidCallback? onViewProjects;
  final VoidCallback? onContactMe;
  final ScrollController? scrollController;
  final BuildContext context;

  const _TabletLayout({
    required this.theme,
    required this.size,
    required this.onViewProjects,
    required this.onContactMe,
    required this.scrollController,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = _getImageSize();
    final buttonWidth = _getButtonWidth();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Main content row
        Expanded(
          flex: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Text content
              Expanded(
                flex: 7,
                child: _TabletTextContent(
                  theme: theme,
                  size: size,
                  context: context,
                ),
              ),
              SizedBox(width: size.width * 0.04), // Responsive spacing
              // Right side: Profile image and buttons
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Profile Image - Responsive size
                    RevealAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        width: imageSize,
                        height: imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(
                                0.25,
                              ),
                              blurRadius:
                                  imageSize * 0.15, // Scale blur with size
                              spreadRadius: imageSize * 0.025,
                              offset: Offset(0, imageSize * 0.04),
                            ),
                          ],
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            width: 3,
                          ),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/profile_image.png',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: imageSize * 0.15), // Responsive spacing
                    // Buttons with responsive width
                    RevealAnimation(
                      delay: const Duration(milliseconds: 1000),
                      child: SizedBox(
                        width: buttonWidth,
                        child: CustomButton(
                          text: 'View Projects',
                          icon: LucideIcons.codesandbox,
                          onPressed:
                              onViewProjects ??
                              () => _scrollToSection('projects'),
                          type: CustomButtonType.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RevealAnimation(
                      delay: const Duration(milliseconds: 1100),
                      child: SizedBox(
                        width: buttonWidth,
                        child: CustomButton(
                          text: 'Contact Me',
                          icon: LucideIcons.contact,
                          onPressed:
                              onContactMe ?? () => _scrollToSection('contact'),
                          type: CustomButtonType.outline,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    RevealAnimation(
                      delay: const Duration(milliseconds: 1200),
                      child: SizedBox(
                        width: buttonWidth,
                        child: CustomButton(
                          text: 'Download CV',
                          icon: LucideIcons.downloadCloud,
                          onPressed: _downloadCV,
                          type: CustomButtonType.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.009),
        _ScrollIndicator(onTap: () => _scrollToSection('about')),
        SizedBox(height: size.height * 0.1),
      ],
    );
  }

  void _downloadCV() => _launchURL(cvLink);

  // Calculate button width based on available space
  double _getButtonWidth() {
    // Use 80% of half screen width, clamped between 180 and 280
    final calculatedWidth = (size.width * 0.5) * 0.8;
    return calculatedWidth.clamp(180.0, 280.0);
  }

  // Calculate responsive image size based on screen dimensions
  double _getImageSize() {
    // Use 20-30% of screen width, clamped between 180 and 300
    final calculatedSize = size.width * 0.22;
    return calculatedSize.clamp(180.0, 300.0);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _scrollToSection(String section) {
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

// Tablet-specific text content widget
class _TabletTextContent extends StatelessWidget {
  final ThemeData theme;
  final Size size;
  final BuildContext context;

  const _TabletTextContent({
    required this.theme,
    required this.size,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RevealAnimation(
          delay: const Duration(milliseconds: 200),
          child: AnimatedText(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(seconds: 2),
            text: "Hello, I'm",
            type: AnimationTextType.fadeIn,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(height: 12),
        RevealAnimation(
          duration: const Duration(seconds: 2),
          delay: const Duration(milliseconds: 400),
          child: AnimatedText(
            delay: const Duration(milliseconds: 600),
            duration: const Duration(seconds: 2),
            text: contactName,
            type: AnimationTextType.typewriter,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: ResponsiveHelper.getHeroFontSize(context),
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..shader = LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        RevealAnimation(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(seconds: 2),
          child: AnimatedText(
            delay: const Duration(milliseconds: 800),
            duration: const Duration(seconds: 2),
            text: contactTitle,
            type: AnimationTextType.slideUp,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 26,
            ),
          ),
        ),
        const SizedBox(height: 20),
        RevealAnimation(
          delay: const Duration(milliseconds: 800),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              professionalSummary,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        // Social buttons at bottom
        RevealAnimation(
          delay: const Duration(milliseconds: 1300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _SocialButton(
                icon: LucideIcons.github,
                tooltip: 'GitHub',
                onPressed: () => _launchURL(githubUrl),
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: LucideIcons.linkedin,
                tooltip: 'LinkedIn',
                onPressed: () => _launchURL(linkedInUrl),
              ),
              const SizedBox(width: 16),
              _SocialButton(
                icon: LucideIcons.mail,
                tooltip: 'Email',
                onPressed: () => _launchURL('mailto:$contactEmail'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
