import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/animated_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/floating_shapes.dart';
import '../../../../../core/widgets/magnetic_button.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../bloc/contact_bloc/contact_bloc.dart';
import '../../widgets/animations/reveal_animation.dart';
import '../../widgets/forms/contact_form.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Stack(
      children: [
        const Positioned.fill(child: FloatingShapes(shapeCount: 5)),
        SectionWrapper(
          title: 'Cast Your Message',
          subtitle: "Let's create something magical together",
          backgroundColor: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withOpacity(0.1),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (ctx, box) {
                      final useRow = box.maxWidth > 700 && !isMobile;
                      return useRow
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _infoColumn(isMobile)),
                                const SizedBox(width: 48),
                                Expanded(child: _formCard()),
                              ],
                            )
                          : Column(
                              children: [
                                _infoColumn(isMobile),
                                const SizedBox(height: 40),
                                _formCard(),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 40),
                  RevealAnimation(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 1),
                    child: const _SocialLinks(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formCard() {
    return RevealAnimation(
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 1),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: BlocProvider(
            create: (context) => ContactBloc(),
            child: const ContactForm(),
          ),
        ),
      ),
    );
  }

  Widget _infoColumn(bool isMobile) {
    return RevealAnimation(
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 1),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          _ContactInfoCard(
            onTap: () {
              launchUrl(Uri.parse('https://github.com/EmadHany'));
            },
            icon: Icons.email,
            title: 'Email',
            content: 'emad-hany@outlook.com',
          ),
          SizedBox(height: 24),
          _ContactInfoCard(
            icon: Icons.phone,
            title: 'Phone',
            content: '+20 123 456 7890',
          ),
          SizedBox(height: 24),
          _ContactInfoCard(
            icon: Icons.location_on,
            title: 'Location',
            content: 'Remote & Worldwide',
          ),
          SizedBox(height: 24),
          _ContactInfoCard(
            icon: Icons.auto_awesome,
            title: 'Availability',
            content: 'Ready for magical projects',
          ),
        ],
      ),
    );
  }
}

class _ContactInfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback? onTap;

  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.content,
    this.onTap,
  });

  @override
  State<_ContactInfoCard> createState() => _ContactInfoCardState();
}

class _ContactInfoCardState extends State<_ContactInfoCard>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.scale(scale: _scaleAnim.value, child: child);
          },
          child: Card(
            elevation: _hovered ? 20 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.content,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _onHover(bool hover) {
    setState(() => _hovered = hover);
    if (hover) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MagneticButton(
      radius: 80,
      onTap: _launchUrl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final social = [
      {'icon': Icons.code, 'label': 'GitHub', 'url': 'https://github.com'},
      {'icon': Icons.work, 'label': 'LinkedIn', 'url': 'https://linkedin.com'},
      {
        'icon': Icons.email,
        'label': 'Email',
        'url': 'mailto:flutter.magician@example.com',
      },
      {'icon': Icons.chat, 'label': 'Twitter', 'url': 'https://twitter.com'},
    ];

    return Column(
      children: [
        Text(
          'Connect with me',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: social.map((link) {
            return _SocialButton(
              icon: link['icon'] as IconData,
              label: link['label'] as String,
              url: link['url'] as String,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        AnimatedText(
          text: '@ 2025 made with ❤️♥️ by Emad Hany',
          type: AnimationTextType.typewriter,
        ),
      ],
    );
  }
}
