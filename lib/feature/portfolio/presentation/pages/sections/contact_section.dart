import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
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
          child: Column(
            children: [
              ResponsiveHelper.buildResponsiveRow(
                context,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Info
                  Expanded(
                    child: RevealAnimation(
                      duration: const Duration(milliseconds: 200),
                      child: Column(
                        crossAxisAlignment: isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          const _ContactInfoCard(
                            icon: Icons.email,
                            title: 'Email',
                            content: 'flutter.magician@example.com',
                          ),
                          const SizedBox(height: 24),
                          const _ContactInfoCard(
                            icon: Icons.location_on,
                            title: 'Location',
                            content: 'Remote & Worldwide',
                          ),
                          const SizedBox(height: 24),
                          const _ContactInfoCard(
                            icon: Icons.auto_awesome,
                            title: 'Availability',
                            content: 'Ready for magical projects',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isMobile) const SizedBox(width: 48),
                  // Contact Form
                  Expanded(
                    flex: isMobile ? 1 : 2,
                    child: RevealAnimation(
                      duration: const Duration(milliseconds: 400),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: BlocProvider(
                            create: (context) => ContactBloc(),
                            child: const ContactForm(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (isMobile) const SizedBox(height: 40),
              // Social Links
              RevealAnimation(
                duration: const Duration(milliseconds: 600),
                child: const _SocialLinks(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _ContactInfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
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
              child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
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
    );
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

    final socialLinks = [
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
          children: socialLinks.map((link) {
            return _SocialButton(
              icon: link['icon'] as IconData,
              label: link['label'] as String,
              url: link['url'] as String,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Schedule a Call',
          icon: Icons.videocam,
          onPressed: () {},
          type: CustomButtonType.magical,
          fullWidth: true,
        ),
      ],
    );
  }
}
