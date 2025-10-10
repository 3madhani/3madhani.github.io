import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../bloc/contact_bloc/contact_bloc.dart';
import '../../widgets/forms/contact_form.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      width: double.infinity,
      padding: ResponsiveHelper.getScreenPadding(context).copyWith(
        top: isMobile ? 40 : 80,
        bottom: isMobile ? 40 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          Text(
            'Cast Your Message',
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: ResponsiveHelper.getSectionTitleSize(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Let's create something magical together",
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Content
          ResponsiveHelper.buildResponsiveRow(
            context,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Info
              Expanded(
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

              if (!isMobile) const SizedBox(width: 48),

              // Contact Form
              Expanded(
                flex: isMobile ? 1 : 2,
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
            ],
          ),

          if (isMobile) const SizedBox(height: 40),

          // Social Links
          const _SocialLinks(),
        ],
      ),
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
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
              ),
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

class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final socialLinks = [
      {'icon': Icons.code, 'label': 'GitHub', 'url': 'https://github.com'},
      {'icon': Icons.work, 'label': 'LinkedIn', 'url': 'https://linkedin.com'},
      {'icon': Icons.email, 'label': 'Email', 'url': 'mailto:flutter.magician@example.com'},
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
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: GestureDetector(
        onTap: () {
          // Launch URL
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
