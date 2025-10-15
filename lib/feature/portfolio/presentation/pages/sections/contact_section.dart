import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/widgets/animated_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/floating_shapes.dart';
import '../../../../../core/widgets/magnetic_button.dart';
import '../../../../../core/widgets/section_wrapper.dart';
import '../../../data/personal_data.dart'; // Import personal data
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
          title: 'Let\'s Connect',
          subtitle: "Ready to build something amazing together?",
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
                                Expanded(child: _infoColumn(context, isMobile)),
                                const SizedBox(width: 48),
                                Expanded(child: _formCard()),
                              ],
                            )
                          : Column(
                              children: [
                                _infoColumn(context, isMobile),
                                const SizedBox(height: 40),
                                _formCard(),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 40),
                  RevealAnimation(
                    delay: const Duration(milliseconds: 600),
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
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

  Widget _infoColumn(BuildContext context, bool isMobile) {
    return RevealAnimation(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Personal intro
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.3),
                  Theme.of(
                    context,
                  ).colorScheme.secondaryContainer.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  "Ready to collaborate?",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
                const SizedBox(height: 12),
                Text(
                  "Let's discuss your next Flutter project and create something exceptional together.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Contact info cards
          _ContactInfoCard(
            onTap: () => _launchUrl('mailto:$contactEmail'),
            icon: Icons.email_outlined,
            title: 'Email',
            content: contactEmail,
          ),
          const SizedBox(height: 16),
          _ContactInfoCard(
            onTap: () => _launchUrl('tel:$contactPhone'),
            icon: Icons.phone_outlined,
            title: 'Phone',
            content: contactPhone,
          ),
          const SizedBox(height: 16),
          _ContactInfoCard(
            icon: Icons.location_on_outlined,
            title: 'Location',
            content: contactLocation,
          ),
          const SizedBox(height: 16),
          _ContactInfoCard(
            icon: Icons.work_outline,
            title: 'Status',
            content: 'Open to remote, onsite, and freelance opportunities',
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.scale(scale: _scaleAnim.value, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? theme.colorScheme.primary.withOpacity(0.3)
                    : theme.colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: _hovered
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _hovered ? 12 : 4,
                  offset: Offset(0, _hovered ? 4 : 2),
                ),
              ],
            ),
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
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
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
                if (widget.onTap != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
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

    // Real social links from personal data
    final socialLinks = [
      {'icon': Icons.code, 'label': 'GitHub', 'url': githubUrl},
      {'icon': Icons.work_outline, 'label': 'LinkedIn', 'url': linkedInUrl},
      {
        'icon': Icons.email_outlined,
        'label': 'Email',
        'url': 'mailto:$contactEmail',
      },
      {
        'icon': Icons.phone_outlined,
        'label': 'WhatsApp',
        'url':
            'https://wa.me/${contactPhone.replaceAll('+', '').replaceAll(' ', '')}',
      },
    ];

    return Column(
      children: [
        Text(
          'Connect with me',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: socialLinks.map((link) {
            return _SocialButton(
              icon: link['icon'] as IconData,
              label: link['label'] as String,
              url: link['url'] as String,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),

        // Footer with your name
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
          ),
          child: Column(
            children: [
              AnimatedText(
                text: '© 2025 Made with ❤️ by $contactName',
                type: AnimationTextType.typewriter,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                contactTitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
