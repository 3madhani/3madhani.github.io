import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/widgets/glass_container.dart';
import '../../../domain/entities/project.dart';

class ProjectModal extends StatefulWidget {
  final Project project;

  const ProjectModal({super.key, required this.project});

  @override
  State<ProjectModal> createState() => _ProjectModalState();
}

class _ProjectModalState extends State<ProjectModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectColor = Color(
      int.parse(widget.project.color.replaceAll('#', '0xFF')),
    );
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background overlay
              GestureDetector(
                onTap: _closeModal,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.6 * _fadeAnimation.value),
                ),
              ),

              // Modal content
              Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      constraints: BoxConstraints(
                        maxWidth: isLargeScreen ? 800 : double.infinity,
                        maxHeight: screenSize.height * 0.9,
                      ),
                      child: GlassContainer(
                        blur: 20,
                        opacity: 0.95,
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header with gradient background
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    projectColor.withOpacity(0.3),
                                    projectColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Close button and project icon
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: projectColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Icon(
                                          _getProjectIcon(
                                            widget.project.category,
                                          ),
                                          size: 32,
                                          color: projectColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: _closeModal,
                                        icon: const Icon(Icons.close),
                                        style: IconButton.styleFrom(
                                          backgroundColor: theme
                                              .colorScheme
                                              .surfaceContainerHighest,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Project title and category
                                  Text(
                                    widget.project.title,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: projectColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          widget.project.category.name
                                              .toUpperCase(),
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: projectColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.2,
                                              ),
                                        ),
                                      ),

                                      if (widget.project.isFeatured) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 14,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'FEATURED',
                                                style: theme
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Content area
                            Flexible(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Project image placeholder
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            projectColor.withOpacity(0.3),
                                            projectColor.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: theme.colorScheme.outline
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Icon(
                                        _getProjectIcon(
                                          widget.project.category,
                                        ),
                                        size: 64,
                                        color: projectColor.withOpacity(0.6),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Description
                                    Text(
                                      'Project Overview',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      widget.project.description,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(height: 1.6),
                                    ),

                                    const SizedBox(height: 24),

                                    // Technologies
                                    Text(
                                      'Technologies Used',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    const SizedBox(height: 16),

                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: widget.project.technologies.map(
                                        (tech) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: theme.colorScheme.outline
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            child: Text(
                                              tech,
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onPrimaryContainer,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),

                                    const SizedBox(height: 24),

                                    // Project features or highlights
                                    Text(
                                      'Key Features',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    const SizedBox(height: 12),

                                    ..._getProjectFeatures().map((feature) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 20,
                                              color: theme.colorScheme.primary,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                feature,
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),

                            // Action buttons
                            Container(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () =>
                                          _launchUrl(widget.project.githubUrl),
                                      icon: const Icon(Icons.code),
                                      label: const Text('View Source Code'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (widget.project.demoUrl != null) ...[
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: FilledButton.icon(
                                        onPressed: () =>
                                            _launchUrl(widget.project.demoUrl!),
                                        icon: const Icon(Icons.launch),
                                        label: const Text('Live Demo'),
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          backgroundColor: projectColor,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  void _closeModal() {
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  List<String> _getProjectFeatures() {
    // Generate features based on project type
    switch (widget.project.category) {
      case ProjectCategory.mobile:
        return [
          'Cross-platform compatibility (iOS & Android)',
          'Native performance and smooth animations',
          'Material Design 3 implementation',
          'Responsive UI for all screen sizes',
          'Offline functionality and data persistence',
        ];
      case ProjectCategory.web:
        return [
          'Progressive Web App (PWA) capabilities',
          'Responsive design for all devices',
          'SEO optimized and fast loading',
          'Modern web technologies integration',
          'Cross-browser compatibility',
        ];
      default:
        return [
          'Clean and maintainable code architecture',
          'User-friendly interface design',
          'Performance optimized implementation',
          'Comprehensive testing coverage',
          'Documentation and deployment ready',
        ];
    }
  }

  IconData _getProjectIcon(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.mobile:
        return Icons.phone_android;
      case ProjectCategory.web:
        return Icons.web;
      case ProjectCategory.featured:
        return Icons.star;
      default:
        return Icons.apps;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }
}
